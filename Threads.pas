Unit Threads;

Interface

Uses Classes, Def_thread,Main;

Type
  TAnalyzeThread = class(TThread)
  private
    mainForm:TFMain;
    adrCnt:Integer;
    Function StartProgress(pbMaxCount:Integer; const sbText:AnsiString):Integer;
    Procedure UpdateProgress;
    Procedure StopProgress;
    Procedure UpdateStatusBar(adr:Integer); Overload;
    Procedure UpdateStatusBar(const sbText:AnsiString); Overload;
    Procedure UpdateAddrInStatusBar(adr:Integer);
    Procedure UpdateUnits;
    Procedure UpdateRTTIs;
    Procedure UpdateVmtList;
    Procedure UpdateStrings;
    Procedure UpdateCode;
    Procedure UpdateXrefs;
    Procedure UpdateShortClassViewer;
    Procedure UpdateClassViewer;
    Procedure UpdateBeforeClassViewer;
    Procedure StrapSysProcs;
    Procedure FindRTTIs;
    Procedure FindVMTs2;                //Для версии Дельфи2 (другая структура!)
    Procedure FindVMTs;
    Procedure FindTypeFields;
    Function FindEvent(VmtAdr:Integer; Name:AnsiString):AnsiString;
    Procedure FindPrototypes;
    Procedure StrapVMTs;
    Procedure ScanCode;
    Procedure ScanCode1;
    Procedure ScanVMTs;
    Procedure ScanConsts;
    Procedure ScanGetSetStoredProcs;
    Procedure FindStrings;
    Procedure AnalyzeCode1;
    Procedure AnalyzeCode2(args:Boolean);
    Procedure PropagateClassProps;
    Procedure FillClassViewer;
    Procedure AnalyzeDC;
    Procedure ClearPassFlags;
  protected
    procedure Execute; Override;
  public
    all:Boolean;    //if false, only ClassViewer
    ReturnValue:Integer;
    Constructor Create(AForm:TFMain; AllValue:Boolean);
  end;

Implementation

Uses Windows,Messages,SysUtils,Types,Def_know,Def_info,Def_main,Forms,
  Misc,Infos,Def_disasm,TypInfo,Resources,Def_res,Dialogs,Heuristic;

type
  StdUnitInfo = record
    used:Boolean;
    name:PAnsiChar;   //имя юнита
    matched:Single;	  //максимальное кол-во совпадений
    maxno:Integer;  	//номер юнита с максимальным кол-вом совпадений
  end;
  PStdUnitInfo = ^StdUnitInfo;

const
  SKIPADDR_COUNT = 10;
  PB_MAX_STEPS = 2048;
  StdUnits:Array[0..6] of StdUnitInfo = (
    (used:false; name:'Types';    matched:0; maxno:-1),
    (used:false; name:'Multimon'; matched:0; maxno:-1),
    (used:false; name:'VarUtils'; matched:0; maxno:-1),
    (used:false; name:'StrUtils'; matched:0; maxno:-1),
    (used:false; name:'Registry'; matched:0; maxno:-1),
    (used:false; name:'IniFiles'; matched:0; maxno:-1),
    (used:false; name:'Clipbrd';  matched:0; maxno:-1)
  );


Constructor TAnalyzeThread.Create (AForm:TFMain; AllValue:Boolean);
Begin
  Inherited Create(True);
  Priority:=tpLower;
  mainForm:=AForm;
  all:=AllValue;
end;

//PopupMenu items!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//The Execute method is called when the thread starts
Procedure TAnalyzeThread.Execute;
Begin
  try
    if all then
    begin
      //1
      StrapSysProcs;
      ReturnValue := 1;
      CurProcAdr := EP;
      UpdateCode;
      //2
      if DelphiVersion <> 2 Then
      begin
        FindRTTIs;
        ReturnValue := 2;
        UpdateUnits;
      End;
      //3
      if DelphiVersion = 2 then FindVMTs2
        else FindVMTs;
      ReturnValue := 3;
      UpdateVmtList;
      UpdateRTTIs;
      UpdateCode;
      //4
      StrapVMTs;
      ReturnValue := 4;
      UpdateCode;
      //5
      ScanCode;
      ReturnValue := 5;
      UpdateCode;
      //6
      ScanVMTs;
      ReturnValue := 6;
      UpdateVmtList;
      UpdateCode;
      UpdateShortClassViewer;
      //7
      ScanConsts;
      ReturnValue := 7;
      UpdateUnits;
      //8
      ScanGetSetStoredProcs;
      ReturnValue := 8;
      //9
      FindStrings;
      ReturnValue := 9;
      //10
      AnalyzeCode1;
      ReturnValue := 10;
      UpdateCode;
      UpdateXrefs;
      //11
      ScanCode1;
      ReturnValue := 11;
      UpdateCode;
      //12
      PropagateClassProps;
      ReturnValue := 12;
      UpdateCode;
      //13
      FindTypeFields;
      ReturnValue := 13;
      UpdateCode;
      //14
      FindPrototypes;
      ReturnValue := 14;
      UpdateCode;
      //15
      AnalyzeCode2(true);
      ReturnValue := 15;
      UpdateCode;
      UpdateStrings;
      //16
      AnalyzeDC;
      ReturnValue := 16;
      UpdateCode;
      //17
      AnalyzeCode2(false);
      ReturnValue := 17;
      UpdateCode;
      UpdateStrings;
      //18
      AnalyzeDC;
      ReturnValue := 18;
      UpdateCode;
      //19
      AnalyzeCode2(false);
      ReturnValue := LAST_ANALYZE_STEP;
      UpdateCode;
      UpdateStrings;
      UpdateBeforeClassViewer;
    end;
    //20
    FillClassViewer;
    ReturnValue := LAST_ANALYZE_STEP + 1;
    UpdateClassViewer;
  Except
    on E:Exception do Application.ShowException(e);
  end;
  //as update main wnd about operation over
  //only Post() here! - async, otehrwise deadlock!
  PostMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taFinished), 0);
end;

Function TAnalyzeThread.StartProgress (pbMaxCount:Integer; Const sbText:AnsiString):Integer;
var
  stepSize, pbSteps:Integer;
  startOperation:PThreadAnalysisData;
Begin
  stepSize := 1;
  pbSteps := pbMaxCount div stepSize;
  if pbSteps * stepSize < pbMaxCount then Inc(pbSteps);
  if pbMaxCount > PB_MAX_STEPS then
  begin
    stepSize := 256;
    while pbSteps > PB_MAX_STEPS do
    begin
      stepSize:= stepSize shl 1;
      pbSteps := pbMaxCount div stepSize;
      if pbSteps * stepSize < pbMaxCount then Inc(pbSteps);
    end;
  End;
  New(startOperation);
  startOperation.pbSteps:=pbSteps;
  startOperation.sbText:=sbText;
  PostMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taStartPrBar), Integer(startOperation));
  //if stepSize <> 1 then Dec(stepSize);
  Result:=stepSize - 1;
end;

Procedure TAnalyzeThread.UpdateProgress;
Begin
  PostMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdatePrBar), 0);
end;

Procedure TAnalyzeThread.StopProgress;
Begin
  PostMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taStopPrBar), 0);
  //as the nice place to check if we are asked to Terminate
  if Terminated Then Raise Exception.Create('Termination request 1');
end;

Procedure TAnalyzeThread.UpdateStatusBar (adr:Integer);
var
  updStatBar:PThreadAnalysisData;
Begin
  if Terminated then Raise Exception.Create('Termination request 2');
  New(updStatBar);
  updStatBar.pbSteps:=0;
  updStatBar.sbText:= Val2Str(adr,8);
  SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateStBar), Integer(updStatBar));
end;

Procedure TAnalyzeThread.UpdateStatusBar(const sbText:AnsiString);
var
  updStatBar:PThreadAnalysisData;
Begin
  if Terminated then Raise Exception.Create('Termination request 3');
  New(updStatBar);
  updStatBar.pbSteps:=0;
  updStatBar.sbText:= sbText;
  SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateStBar), Integer(updStatBar));
end;

Procedure TAnalyzeThread.UpdateAddrInStatusBar (adr:Integer);
Begin
  Inc(adrCnt);
  if adrCnt = SKIPADDR_COUNT then
  begin
    UpdateStatusBar(adr);
    adrCnt := 0;
  end;
end;

Procedure TAnalyzeThread.UpdateUnits;
var
  isLastStep:LongBool;
Begin
  if not Terminated then
  begin
    isLastStep := ReturnValue = LAST_ANALYZE_STEP;
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateUnits), Ord(isLastStep));
  End;
end;

Procedure TAnalyzeThread.UpdateRTTIs;
Begin
  if not Terminated then
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateRTTIs), 0);
end;

Procedure TAnalyzeThread.UpdateVmtList;
Begin
  if not Terminated then
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateVmtList), 0);
end;

Procedure TAnalyzeThread.UpdateStrings;
Begin
  if not Terminated then
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateStrings), 0);
end;

Procedure TAnalyzeThread.UpdateCode;
Begin
  if not Terminated then
  begin
    UpdateUnits;
    //cant use Post here, there are some global shared vars!
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateCode), 0);
  end;
end;

Procedure TAnalyzeThread.UpdateXrefs;
Begin
  if not Terminated then
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateXrefs), 0);
end;

Procedure TAnalyzeThread.UpdateShortClassViewer;
Begin
  if not Terminated then
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateShortClassViewer), 0);
end;

Procedure TAnalyzeThread.UpdateClassViewer;
Begin
  if not Terminated then
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateClassViewer), 0);
end;

Procedure TAnalyzeThread.UpdateBeforeClassViewer;
Begin
  if not Terminated then
    SendMessage(mainForm.Handle, WM_UPDANALYSISSTATUS, Ord(taUpdateBeforeClassViewer), 0);
end;

Procedure TAnalyzeThread.StrapSysProcs;
var
  n, Idx, _pos:Integer;
  pInfo:MProcInfo;
  moduleID:Word;
  has_pInfo:Boolean;
Begin
  StartProgress(mainForm.SysProcsNum, 'Strap SysProcs');
  moduleID := KBase.GetModuleID('System');
  for n:=Low(SysProcs) to High(SysProcs) do
  begin
    if Terminated then Break;
    UpdateProgress;
    Idx := KBase.GetProcIdx(moduleID, PAnsiChar(SysProcs[n].name));
    if Idx <> -1 then
    begin
      Idx := KBase.ProcOffsets[Idx].NamId;
      if not KBase.IsUsedProc(Idx) then
      begin
        has_pInfo:=KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo);
        if SysProcs[n].impAdr<>0 then
          mainForm.StrapProc(Adr2Pos(SysProcs[n].impAdr), Idx, @pInfo, false, 6)
        else
        begin
          _pos := KBase.ScanCode(Code, FlagList, CodeSize, @pInfo);
          if has_pInfo and (_pos <> -1) then
          begin
            UpdateStatusBar(pInfo.ProcName);
            mainForm.StrapProc(_pos, Idx, @pInfo, true, pInfo.DumpSz);
          End;
        end;
      End;
    end;
  end;
  moduleID := KBase.GetModuleID('SysInit');
  for n:=Low(SysInitProcs) to High(SysInitProcs) do
  begin
    if Terminated then Break;
    UpdateProgress;
    Idx := KBase.GetProcIdx(moduleID, PAnsiChar(SysInitProcs[n].name));
    if Idx <> -1 then
    begin
      Idx := KBase.ProcOffsets[Idx].NamId;
      if not KBase.IsUsedProc(Idx) then
      begin
        has_pInfo := KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo);
        _pos := KBase.ScanCode(Code, FlagList, CodeSize, @pInfo);
        if has_pInfo and (_pos <> -1) then
        begin
          UpdateStatusBar(pInfo.ProcName);
          mainForm.StrapProc(_pos, Idx, @pInfo, true, pInfo.DumpSz);
        end;
      end;
    end;
  end;
  StopProgress;
end;

Procedure TAnalyzeThread.FindRTTIs;
Var
  paramCnt, numOps, methodKind, flags, len:Byte;
  typeKind:LKind;
  dw, Count, methCnt:Word;
  typInfo, baseTypeAdr, procSig, stepMask:Integer;
  i,j, n, m, minValue, maxValue, elNum, _pos, instrLen:Integer;
  adr,TypeAdr:Integer;
  recN:InfoRec;
  recT:PTypeRec;
  unitName, typeName:AnsiString;
  //prefix:AnsiString;
  disInfo:TDisInfo;
Begin
	stepMask := StartProgress(CodeSize, 'Find Types');
	i:=0;
	while (i< CodeSize) and not Terminated do
	Begin
    if (i and stepMask) = 0 then UpdateProgress;
    adr := PInteger(Code + i)^;
    if IsValidImageAdr(adr) and (adr = Pos2Adr(i) + 4) then
    Begin
      //euristica - look at byte Code + i - 3 - may be case (jmp [adr + reg*4])
      instrLen := frmDisasm.Disassemble(Code + i - 3, Pos2Adr(i) - 3, @DisInfo, Nil);
      if (instrLen > 3) and DisInfo.Branch and (DisInfo.Offset = adr) then
      begin
        Inc(i,4);
        continue;
      end;
      typeAdr := adr - 4;
      typeKind := LKind(Code[i + 4]);
      if (typeKind = ikUnknown) or (typeKind > ikProcedure) then
      begin
        Inc(i,4);
        continue;
      End;
      len := Byte(Code[i + 5]);
      if not IsValidName(len, i + 6) then
      begin
        Inc(i,4);
        continue;
      end;
      TypeName := GetTypeName(adr);
      UpdateStatusBar(TypeName);
      (*
      //Names that begins with '.'
      if TypeName[1] = '.' then
      Begin
        case typeKind of
          ikEnumeration: prefix := '_Enumeration_';
          ikArray:       prefix := '_Array_';
          ikDynArray:    prefix := '_DynArray_';
        else             prefix := form.GetUnitName(recU);
        End;
        TypeName := prefix + Val2Str(recU.iniOrder) + '_' + Copy(TypeName,2, len);
      End;
      *)
      n := i + 6 + len;
      SetFlag(cfRTTI, i);
      unitName := '';
      case typeKind of
        ikInteger: //1
          begin
            Inc(n);	//ordType
            Inc(n,4);	//MinVal
            Inc(n,4);	//MaxVal
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikChar: //2
          begin
            Inc(n);	//ordType
            Inc(n,4);	//MinVal
            Inc(n,4);	//MaxVal
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikEnumeration: //3
          begin
            Inc(n);    //ordType
            minValue := PInteger(Code + n)^; 
            Inc(n, 4);
            maxValue := PInteger(Code + n)^; 
            Inc(n, 4);
            //BaseType
            baseTypeAdr := PInteger(Code + n)^; 
            Inc(n, 4);
            if baseTypeAdr = typeAdr then
            Begin
              if SameText(TypeName, 'ByteBool') or
                SameText(TypeName, 'WordBool') or
                SameText(TypeName, 'LongBool') then
              Begin
                minValue := 0;
                maxValue := 1;
              End;
              for j := minValue to maxValue do
              Begin
                len := Byte(Code[n]);
                Inc(n, len + 1);
              End;
            End;
            (*
            //UnitName
            len := Code[n];
            if IsValidName(len, n + 1) then
            Begin
              unitName := Trim(MakeString(Code + n + 1, len));
              SetUnitName(recU, unitName);
            End;
            Inc(n, len + 1);
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^; 
              Inc(n, dw);
            End;
            *)
            SetFlags(cfData, i, n - i);
          end;
        ikFloat: //4
          begin
            Inc(n);    //FloatType
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikString: //5
          begin
            Inc(n);    //MaxLength
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikSet: //6
          begin
            Inc(n, 1 + 4);     //ordType+CompType
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikClass: //7
          begin
            Inc(n, 4);     //classVMT
            Inc(n, 4);     //ParentInfo
            Inc(n, 2);     //PropCount
            //UnitName
            len := Byte(Code[n]);
            if IsValidName(len, n + 1) then
            Begin
              unitName := Trim(MakeString(Code + n + 1, len));
              //FMain.SetUnitName(recU, unitName);
            End;
            Inc(n, len + 1);
            //PropData
            Count := PWord(Code + n)^; 
            Inc(n, 2);
            for j := 0 to Count-1 do
            Begin
              //TPropInfo
              Inc(n, 26);
              len := Byte(Code[n]);
              Inc(n, len + 1);
            End;
            if DelphiVersion >= 2010 then
            Begin
              //PropDataEx
              Count := PWord(Code + n)^; 
              Inc(n, 2);
              for j := 0 to Count-1 do
              Begin
                //TPropInfoEx
                //Flags
                Inc(n);
                //Info
                typInfo := PInteger(Code + n)^; 
                Inc(n, 4);
                _pos := Adr2Pos(typInfo);
                len := Byte(Code[_pos + 26]);
                SetFlags(cfData, _pos, 27 + len);
                //AttrData
                dw := PWord(Code + n)^;
                Inc(n, dw);//ATR!!
              End;
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
              if DelphiVersion >= 2012 then
              Begin
                //ArrayPropCount
                Count := PWord(Code + n)^; 
                Inc(n, 2);
                //ArrayPropData
                for j := 0 to Count-1 do
                Begin
                  //Flags
                  Inc(n);
                  //ReadIndex
                  Inc(n, 2);
                  //WriteIndex
                  Inc(n, 2);
                  //Name
                  len := Byte(Code[n]);
                  Inc(n, len + 1);
                  //AttrData
                  dw := Pword(Code + n)^;
                  Inc(n,dw);//ATR!!
                End;
              End;
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikMethod: //8
          begin
            //MethodKind
            methodKind := Byte(Code[n]);
            Inc(n);  //0 (mkProcedure) or 1 (mkFunction)
            paramCnt := Byte(Code[n]);
            Inc(n);
            for j := 0 to paramCnt-1 do
            Begin
              Inc(n);        //Flags
              len := Byte(Code[n]);
              Inc(n, len + 1);    //ParamName
              len := Byte(Code[n]);
              Inc(n,len + 1);    //TypeName
            End;
            if methodKind<>0 then
            Begin
              //ResultType
              len := Byte(Code[n]);
              Inc(n, len + 1);
              if DelphiVersion > 6 then
              Begin
                //ResultTypeRef
                Inc(n, 4);
              End;
            End;
            if DelphiVersion > 6 then
            Begin
              //CC
              Inc(n);
              //ParamTypeRefs
              Inc(n, 4*paramCnt);
              if DelphiVersion >= 2010 then
              Begin
                //MethSig
                procSig := PInteger(Code + n)^; 
                Inc(n, 4);
                //AttrData
                dw := PWord(Code + n)^;
                Inc(n, dw);//ATR!!
                //Procedure Signature
                if procSig<>0 then
                Begin
                  if IsValidImageAdr(procSig) then
                    _pos := Adr2Pos(procSig)
                  else
                    _pos := i + procSig;
                  m := 0;
                  //Flags
                  flags := Byte(Code[_pos]);
                  Inc(m);
                  if flags <> 255 then
                  Begin
                    //CC
                    Inc(m);
                    //ResultType
                    Inc(m, 4);
                    //ParamCount
                    paramCnt := Byte(Code[_pos + m]);
                    Inc(m);
                    for j := 0 to paramCnt-1 do
                    Begin
                      //Flags
                      Inc(m);
                      //ParamType
                      Inc(m, 4);
                      //Name
                      len := Byte(Code[_pos + m]);
                      Inc(m, len + 1);
                      //AttrData
                      dw := PWord(Code + _pos + m)^;
                      Inc(m, dw);//ATR!!
                    End;
                  End;
                  SetFlags(cfData, _pos, m);
                End;
              End;
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikWChar: //9
          begin
            Inc(n);        //ordType
            Inc(n, 4);     //MinVal
            Inc(n, 4);     //MaxVal
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikLString: // $0A
          begin
            //CodePage
            if DelphiVersion >= 2009 then Inc(n, 2);
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikWString: // $0B
          begin
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikVariant: // $0C
          begin
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikArray: // $0D
          begin
            Inc(n, 4);     //Size
            Inc(n, 4);     //ElCount
            Inc(n, 4);     //ElType
            if DelphiVersion >= 2010 then
            Begin
              //DimCount
              paramCnt := Byte(Code[n]);
              Inc(n);
              for j := 0 to paramCnt-1 do
              Begin
                //Dims
                Inc(n, 4);
              End;
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikRecord: // $0E
          begin
            Inc(n, 4); //Size
            elNum := PInteger(Code + n)^; 
            Inc(n, 4);    //ManagedFldCount
            for j := 0 to elNum-1 do
            Begin
              Inc(n, 4); //TypeRef
              Inc(n, 4); //FldOffset
            End;
            if DelphiVersion >= 2010 then
            Begin
              numOps := Byte(Code[n]);
              Inc(n);  //NumOps
              for j := 0 to numOps-1 do    //RecOps
                Inc(n, 4);
              elNum := PInteger(Code + n)^; 
              Inc(n, 4);    //RecFldCnt
              for j := 0 to elNum-1 do
              Begin
                Inc(n, 4); //TypeRef
                Inc(n, 4); //FldOffset
                Inc(n);    //Flags
                len := Byte(Code[n]);
                Inc(n, len + 1);    //Name
                dw := PWord(Code + n)^;
                if dw <> 2 then dummy := 1;
                Inc(n, dw);//ATR!!
              End;
              dw := PWord(Code + n)^;
              if dw <> 2 then dummy:=1;
              Inc(n, dw);//ATR!!
              if DelphiVersion >= 2012 then
              Begin
                methCnt := PWord(Code + n)^; 
                Inc(n, 2);
                for j := 0 to methCnt-1 do
                Begin
                  Inc(n);    //Flags
                  Inc(n, 4); //Code
                  len := Byte(Code[n]);
                  Inc(n, len + 1);    //Name
                  //ProcedureSignature
                  //Flags
                  flags := Byte(Code[n]);
                  Inc(n);
                  if flags <> 255 then
                  Begin
                    //CC
                    Inc(n);
                    //ResultType
                    Inc(n, 4);
                    //ParamCnt
                    paramCnt := Byte(Code[n]);
                    Inc(n);
                    //Params
                    for m := 0 to paramCnt-1 do
                    Begin
                      Inc(n);    //Flags
                      Inc(n, 4); //ParamType
                      len := Byte(Code[n]);
                      Inc(n, len + 1);    //Name
                      dw := PWord(Code + n)^;
                      if dw <> 2 then dummy:=1;
                      Inc(n, dw);//ATR!!
                    End;
                  End;
                  dw := PWord(Code + n)^;
                  if dw <> 2 then dummy:=1;
                  Inc(n, dw);//ATR!!
                End;
              End;
            End;
            SetFlags(cfData, i, n - i);
          End;
        ikInterface: // $0F
          begin
            Inc(n, 4);     //IntfParent
            Inc(n);        //IntfFlags
            Inc(n, 16);    //GUID
            //UnitName
            len := Byte(Code[n]);
            if IsValidName(len, n + 1) then
            Begin
              unitName := Trim(MakeString(Code + n + 1, len));
              //FMain.SetUnitName(recU, unitName);
            End;
            Inc(n, len + 1);
            //PropCount
            Count := PWord(Code + n)^; 
            Inc(n, 2);
            if DelphiVersion >= 6 then
            Begin
              //RttiCount
              dw := PWord(Code + n)^; 
              Inc(n, 2);
              if dw <> $FFFF then
              Begin
                if DelphiVersion >= 2010 then
                Begin
                  for j := 0 to Count-1 do
                  Begin
                    //Name
                    len := Byte(Code[n]);
                    Inc(n, len + 1);
                    //Kind
                    methodKind := Byte(Code[n]);
                    Inc(n);
                    //CallConv
                    Inc(n);
                    //ParamCount
                    paramCnt := Byte(Code[n]);
                    Inc(n);
                    for m := 0 to paramCnt-1 do
                    Begin
                      //Flags
                      Inc(n);
                      //ParamName
                      len := Byte(Code[n]);
                      Inc(n, len + 1);
                      //TypeName
                      len := Byte(Code[n]);
                      Inc(n, len + 1);
                      //ParamType
                      Inc(n, 4);
                      //AttrData
                      dw := PWord(Code + n)^;
                      Inc(n, dw);//ATR!!
                    End;
                    if methodKind<>0 then
                    Begin
                      //ResultTypeName
                      len := Byte(Code[n]);
                      Inc(n, len + 1);
                      if len<>0 then
                      Begin
                        //ResultType
                        Inc(n, 4);
                        // ======  Insert by Pigrecos
                        //AttrData
                        dw := PWord(Code + n)^;
                        Inc(n, dw); //ATR!!
                        // ======  Insert by Pigrecos
                      End;
                    End;
                  End;
                End
                else for j := 0 to Count-1 do
                Begin
                  //PropType
                  Inc(n, 4);
                  //GetProc
                  Inc(n, 4);
                  //SetProc
                  Inc(n, 4);
                  //StoredProc
                  Inc(n, 4);
                  //Index
                  Inc(n, 4);
                  //Default
                  Inc(n, 4);
                  //NameIndex
                  Inc(n, 2);
                  //Name
                  len := Byte(Code[n]);
                  Inc(n, len + 1);
                End;
              End;
              if DelphiVersion >= 2010 then
              Begin
                //AttrData
                dw := PWord(Code + n)^;
                Inc(n, dw);//ATR!!
              End;
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikInt64: // $10
          begin
            Inc(n, 8);     //MinVal
            Inc(n, 8);     //MaxVal
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikDynArray: // $11
          begin
            Inc(n, 4);     //elSize
            Inc(n, 4);     //elType
            Inc(n, 4);     //varType
            if DelphiVersion >= 6 then
            Begin
              Inc(n, 4);     //elType2
              //UnitName
              len := Byte(Code[n]);
              if IsValidName(len, n + 1) then
              Begin
                unitName := Trim(MakeString(Code + n + 1, len));
                //FMain.SetUnitName(recU, unitName);
              End;
              Inc(n, len + 1);
            End;
            if DelphiVersion >= 2010 then
            Begin
              //DynArrElType
              Inc(n, 4);
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikUString: // $12
          begin
            if DelphiVersion >= 2010 then
            Begin
              //AttrData
              dw := PWord(Code + n)^;
              Inc(n, dw);//ATR!!
            End;
            SetFlags(cfData, i, n - i);
          end;
        ikClassRef: // $13
          begin
            //InstanceType
            Inc(n, 4);
            //AttrData
            dw := PWord(Code + n)^;
            Inc(n, dw);//ATR!!
            SetFlags(cfData, i, n - i);
          end;
        ikPointer: // $14
          begin
            //RefType
            Inc(n,4);
            //AttrData
            dw := PWord(Code + n)^;
            Inc(n, dw);//ATR!!
            SetFlags(cfData, i, n - i);
          end;
        ikProcedure: // $15
          begin
            //MethSig
            procSig := PInteger(Code + n)^; 
            Inc(n, 4);
            //AttrData
            dw := PWord(Code + n)^;
            Inc(n, dw);//ATR!!
            SetFlags(cfData, i, n - i);
            //Procedure Signature
            if procSig<>0 then
            Begin
              if IsValidImageAdr(procSig) then
                _pos := Adr2Pos(procSig)
              else
                _pos := i + procSig;
              m := 0;
              //Flags
              flags := Byte(Code[_pos]);
              Inc(m);
              if flags <> 255 then
              Begin
                //CC
                Inc(m);
                //ResultType
                Inc(m, 4);
                //ParamCount
                paramCnt := Byte(Code[_pos + m]);
                Inc(m);
                for j := 0 to paramCnt-1 do
                Begin
                  //Flags+ParamType
                  Inc(m, 5);
                  //Name
                  len := Byte(Code[_pos + m]);
                  Inc(m, len + 1);
                  //AttrData
                  dw := PWord(Code + _pos + m)^;
                  Inc(m, dw);//ATR!!
                End;
              End;
              SetFlags(cfData, _pos, m);
            End;
          end;
      End;
      if InfoList[i]=Nil then
      Begin
        recN := InfoRec.Create(i, typeKind);
        recN.Name:=TypeName;
      End;
      New(recT);
      recT.kind := typeKind;
      recT.adr := typeAdr;
      if unitName <> '' then TypeName:=TypeName + ' (' + unitName + ')';
      recT.name := TypeName;
      OwnTypeList.Add(recT);
    End;
		Inc(i,4);
	End;
	StopProgress;
end;

Procedure TAnalyzeThread.FindVMTs2;
var
  b,len:Byte;
  typeKind:ShortInt;
  Num16,skipNext:Word;
  Num32,selfPtr,initTableAdr,typeInfoAdr,fieldTableAdr,methodTableAdr:Integer;
  dynamicTableAdr,classNameAdr,instanceSize,parentAdr,defaultHandlerAdr:Integer;
  newInstanceAdr,freeInstanceAdr,destroyAdr,classVMT,stopAt:Integer;
  m,i, _pos, bytes, _ap, _ap0, stepMask,typesTab:Integer;
  TypeName,unitName:AnsiString;
  recT:PTypeRec;
  recN:InfoRec;
  recU:PUnitRec;
Begin
  stepMask := StartProgress(CodeSize, 'Find Virtual Method Tables D2');
  i:=0;
  _pos:=0;
  while (i < CodeSize) and not Terminated do
  begin
    if (i and stepMask) = 0 then UpdateProgress;
    if IsFlagSet(cfCode or cfData, i) then continue;
    selfPtr := PInteger(Code + i)^;
    if (selfPtr<>0) and not IsValidImageAdr(selfPtr) then continue;
    initTableAdr := PInteger(Code + i + 4)^;
    if initTableAdr<>0 then
    begin
      if not IsValidImageAdr(initTableAdr) then continue;
      if Code[_pos] <> #$E then continue;
      _pos := Adr2Pos(initTableAdr);
      Num32 := PInteger(Code + _pos + 5)^;
      if Num32 > 10000 then continue;
    End;
    typeInfoAdr := PInteger(Code + i + 8)^;
    if typeInfoAdr<>0 then
    begin
      if not IsValidImageAdr(typeInfoAdr) then continue;
      //typeInfoAdr contains kind of type
      _pos := Adr2Pos(typeInfoAdr);
      typeKind := Byte(Code[_pos]);
      if typeKind > Ord(tkVariant) then continue;
      //len := Byte(Code[_pos + 1]);
      //if not IsValidName(len, _pos + 2) then continue;
    End;
    fieldTableAdr := PInteger(Code + i + $C)^;
    if fieldTableAdr<>0 then
    begin
      if not IsValidImageAdr(fieldTableAdr) then continue;
      _pos := Adr2Pos(fieldTableAdr);
      Num16 := PWord(Code + _pos)^;
      if Num16 > 10000 then continue;
    End;
    methodTableAdr := PInteger(Code + i + $10)^;
    if methodTableAdr<>0 then
    begin
      if not IsValidImageAdr(methodTableAdr) then continue;
      _pos := Adr2Pos(methodTableAdr);
      Num16 := PWord(Code + _pos)^;
      if Num16 > 10000 then continue;
    End;
    dynamicTableAdr := PInteger(Code + i + $14)^;
    if dynamicTableAdr<>0 then
    begin
      if not IsValidImageAdr(dynamicTableAdr) then continue;
      _pos := Adr2Pos(dynamicTableAdr);
      Num16 := PWord(Code + _pos)^;
      if Num16 > 10000 then continue;
    End;
    classNameAdr := PInteger(Code + i + $18)^;
    if (classNameAdr=0) or not IsValidImageAdr(classNameAdr) then continue;
    //_ap := Adr2Pos(classNameAdr);
    //len := Byte(Code[_ap]);
    //if not IsValidName(len, _ap + 1) then continue;
    instanceSize := PInteger(Code + i + $1C)^;
    if instanceSize=0 then continue;
    parentAdr := PInteger(Code + i + $20)^;
    if (parentAdr<>0) and not IsValidImageAdr(parentAdr) then continue;
    defaultHandlerAdr := PInteger(Code + i + $24)^;
    if (defaultHandlerAdr<>0) and not IsValidImageAdr(defaultHandlerAdr) then continue;
    newInstanceAdr := PInteger(Code + i + $28)^;
    if (newInstanceAdr<>0) and not IsValidImageAdr(newInstanceAdr) then continue;
    freeInstanceAdr := PInteger(Code + i + $2C)^;
    if (freeInstanceAdr<>0) and not IsValidImageAdr(freeInstanceAdr) then continue;
    destroyAdr := PInteger(Code + i + $30)^;
    if (destroyAdr<>0) and not IsValidImageAdr(destroyAdr) then continue;
    classVMT := Pos2Adr(i) - VmtSelfPtr;
    if Adr2Pos(classVMT) < 0 then continue;
    StopAt := GetStopAt(classVMT);
    if i + StopAt - classVMT - VmtSelfPtr >= CodeSize then continue;
    _ap := Adr2Pos(classNameAdr);
    if _ap <= 0 then continue;
    len := Byte(Code[_ap]);
    TypeName := MakeString(Code + _ap + 1, len);
    UpdateStatusBar(TypeName);

    //Add to TypeList
    New(recT);
    recT.kind := ikVMT;
    recT.adr := Pos2Adr(i);
    recT.name := TypeName;
    OwnTypeList.Add(recT);

    //Name already used
    SetFlags(cfData, _ap, len + 1);
    if InfoList[i]=Nil then
    begin
      recN := InfoRec.Create(i, ikVMT);
      recN.Name:=TypeName;
    End;
    //InitTable
    if initTableAdr<>0 then
    begin
      _pos := Adr2Pos(initTableAdr); 
      bytes := 0;
      Inc(_pos); 
      Inc(bytes);         //skip 0xE
      Inc(_pos); 
      Inc(bytes);         //unknown byte
      Inc(_pos, 4); 
      Inc(bytes, 4);   //unknown dd
      Num32 := PInteger(Code + _pos)^; 
      Inc(bytes, 4);
      for m := 0 to Num32-1 do
      begin
        //Type offset (Information about types already extracted)
        Inc(bytes, 4);
        //FieldOfs
        Inc(bytes, 4);
      End;
      //InitTable used
      SetFlags(cfData, Adr2Pos(initTableAdr), bytes);
    End;
    //FieldTable
    if fieldTableAdr<>0 then
    begin
      _pos := Adr2Pos(fieldTableAdr); 
      bytes := 0;
      Num16 := PWord(Code + _pos)^;
      Inc(_pos, 2); 
      Inc(bytes, 2);
      //TypesTab
      typesTab := PInteger(Code + _pos)^; 
      Inc(_pos, 4); 
      Inc(bytes, 4);
      for m := 0 to Num16-1 do
      begin
        //FieldOfs
        Inc(_pos,4); 
        Inc(bytes, 4);
        //idx
        Inc(_pos, 2); 
        Inc(bytes, 2);
        len := Byte(Code[_pos]);
        Inc(_pos);
        Inc(bytes);
        //name
        Inc(_pos, len); 
        Inc(bytes, len);
      End;
      //FieldTable used
      SetFlags(cfData, Adr2Pos(fieldTableAdr), bytes);
      //Use TypesTab
      Num16 := PWord(Code + Adr2Pos(typesTab))^;
      SetFlags(cfData, Adr2Pos(typesTab), 2 + Num16*4);
    End;
    //MethodTable
    if methodTableAdr<>0 then
    begin
      _pos := Adr2Pos(methodTableAdr); 
      bytes := 0;
      Num16 := PWord(Code + _pos)^; 
      Inc(_pos, 2);
      Inc(bytes, 2);
      for m := 0 to Num16-1 do
      begin
        //Length of Method Description
        skipNext := PWord(Code + _pos)^; 
        Inc(_pos, skipNext); 
        Inc(bytes, skipNext);
      End;
      //MethodTable used
      SetFlags(cfData, Adr2Pos(methodTableAdr), bytes);
    End;
    //DynamicTable
    if dynamicTableAdr<>0 then
    begin
      _pos := Adr2Pos(dynamicTableAdr); 
      bytes := 0;
      Num16 := PWord(Code + _pos)^;
      Inc(_pos, 2); 
      Inc(bytes, 2);
      for m := 0 to Num16-1 do
      begin
        //Msg
        Inc(bytes, 2);
        //ProcAdr
        Inc(bytes, 4);
      End;
      //DynamicTable used
      SetFlags(cfData, Adr2Pos(dynamicTableAdr), bytes);
    End;

    //StopAt := GetStopAt(classVMT);
    //Использовали виртуальную таблицу
    SetFlags(cfData, i, StopAt - classVMT - VmtSelfPtr);
    recU := mainForm.GetUnit(classVMT);
    if Assigned(recU) then
      if typeInfoAdr<>0 then    //extract unit name
      begin
        _ap0 := Adr2Pos(typeInfoAdr); 
        _ap := _ap0;
        b := Byte(Code[_ap]); 
        Inc(_ap);
        if b <> 7 then continue;
        len := Byte(Code[_ap]);
        Inc(_ap);
        if not IsValidName(len, _ap) then continue;
        Inc(_ap, len + 10);
        len := Byte(Code[_ap]);
        Inc(_ap);
        if not IsValidName(len, _ap) then continue;
        unitName := Trim(MakeString(Code + _ap, len)); 
        Inc(_ap, len);
        FMain.SetUnitName(recU, unitName);
        //Use information about Unit
        SetFlags(cfData, _ap0, _ap - _ap0);
      End;
    Inc(i,4);
  End;
  StopProgress;
end;

//Collect information from VMT structure
Procedure TAnalyzeThread.FindVMTs;
var
  b,len,typeKind,paramCnt:Byte;
  Num16,skipBytes,dw:Word;
  Num32:Integer;
  bytes, _pos, pos1, posv, EntryCount, stepMask:Integer;
  k,m,n,i,adr,classVMT,stopAt,intfTableAdr,autoTableAdr,initTableAdr:Integer;
  typeInfoAdr,fieldTableAdr,methodTableAdr,dynamicTableAdr,vAdr:Integer;
  classNameAdr,parentAdr,vTableAdr,vStart,vEnd,typesTab,methodEntry:Integer;
  typeName,unitName:AnsiString;
  recT:PTypeRec;
  recN:InfoRec;
  recU:PUnitRec;
Begin
  stepMask := StartProgress(TotalSize, 'Find Virtual Method Tables');
  i:=0;
  while (i < TotalSize) and not Terminated do 
  Begin
    if (i and stepMask) = 0 then UpdateProgress;
    if IsFlagSet(cfCode or cfData, i) then
    Begin
      Inc(i,4);
      continue;
    End;
    adr := PInteger(Code + i)^;  //Points to vmt0 (VmtSelfPtr)
    if IsValidImageAdr(adr) and (Pos2Adr(i) = adr + VmtSelfPtr) then
    Begin
      classVMT := adr;
      StopAt := GetStopAt(classVMT);
      //if i + StopAt - classVMT - VmtSelfPtr >= CodeSize then continue;
      intfTableAdr := PInteger(Code + i + 4)^;
      if intfTableAdr<>0 then
      Begin
        if not IsValidImageAdr(intfTableAdr) then
        begin
          Inc(i,4);
          continue;
        end;
        _pos := Adr2Pos(intfTableAdr);
        EntryCount := PInteger(Code + _pos)^;
        if EntryCount > 10000 then
        Begin
          Inc(i,4);
          continue;
        end;
      End;
      autoTableAdr := PInteger(Code + i + 8)^;
      if autoTableAdr<>0 then
      Begin
        if not IsValidImageAdr(autoTableAdr) then
        Begin
          Inc(i,4);
          continue;
        end;
        _pos := Adr2Pos(autoTableAdr);
        EntryCount := PInteger(Code + _pos)^;
        if EntryCount > 10000 then
        Begin
          Inc(i,4);
          continue;
        end;
      End;
      initTableAdr := PInteger(Code + i + 12)^;
      if initTableAdr<>0 then
      Begin
        if not IsValidImageAdr(initTableAdr) then
        begin
          Inc(i,4);
          continue;
        end;
        _pos := Adr2Pos(initTableAdr);
        Num32 := PInteger(Code + _pos + 6)^;
        if Num32 > 10000 then
        Begin
          Inc(i,4);
          continue;
        end;
      End;
      typeInfoAdr := PInteger(Code + i + 16)^;
      if typeInfoAdr<>0 then
      Begin
        if not IsValidImageAdr(typeInfoAdr) then
        Begin
          Inc(i,4);
          continue;
        end;
        //По адресу typeInfoAdr должны быть данные о типе, начинающиеся с определенной информации
        _pos := Adr2Pos(typeInfoAdr);
        typeKind := Byte(Code[_pos]);
        if Ord(typeKind) > Ord(ikProcedure) then
        Begin
          Inc(i,4);
          continue;
        end;
        //len := Byte(Code[_pos + 1]);
        //if not IsValidName(len, _pos + 2) then begin inc(i,4); continue; end;
      End;
      fieldTableAdr := PInteger(Code + i + 20)^;
      if fieldTableAdr<>0 then
      Begin
        if not IsValidImageAdr(fieldTableAdr) then
        Begin
          Inc(i,4);
          continue;
        end;
        _pos := Adr2Pos(fieldTableAdr);
        Num16 := PWord(Code + _pos)^;
        if Num16 > 10000 then
        Begin
          Inc(i,4);
          continue;
        end;
      End;
      methodTableAdr := PInteger(Code + i + 24)^;
      if methodTableAdr<>0 then
      Begin
        if not IsValidImageAdr(methodTableAdr) then
        Begin
          Inc(i,4);
          continue;
        end;
        _pos := Adr2Pos(methodTableAdr);
        Num16 := PWord(Code + _pos)^;
        if Num16 > 10000 then
        Begin
          Inc(i,4);
          continue;
        end;
      End;
      dynamicTableAdr := PInteger(Code + i + 28)^;
      if dynamicTableAdr<>0 then
      Begin
        if not IsValidImageAdr(dynamicTableAdr) then
        Begin
          Inc(i,4);
          continue;
        end;
        _pos := Adr2Pos(dynamicTableAdr);
        Num16 := PWord(Code + _pos)^;
        if Num16 > 10000 then
        Begin
          Inc(i,4);
          continue;
        end;
      End;
      classNameAdr := PInteger(Code + i + 32)^;
      if (classNameAdr=0) or not IsValidImageAdr(classNameAdr) then
      Begin
        Inc(i,4);
        continue;
      end;
      //n := Adr2Pos(classNameAdr);
      //len := Byte(Code[n]);
      //if not IsValidName(len, n + 1) then begin inc(i,4); continue; end;
      parentAdr := PInteger(Code + i + $28)^;
      if (parentAdr<>0) and not IsValidImageAdr(parentAdr) then
      Begin
        Inc(i,4);
        continue;
      end;
      n := Adr2Pos(classNameAdr);
      len := Byte(Code[n]);
      //if not IsValidName(len, n + 1) then begin inc(i,4); continue; end;
      TypeName := MakeString(Code + n + 1, len);
      UpdateStatusBar(TypeName);
     
      //Add to TypeList
      New(recT);
      recT.kind := ikVMT;
      recT.adr := Pos2Adr(i);
      recT.name := TypeName;
      OwnTypeList.Add(recT);

      //Name already use
      SetFlags(cfData, n, len + 1);
      if GetInfoRec(Pos2Adr(i))=Nil then
      Begin
        recN := InfoRec.Create(i, ikVMT);
        recN.Name:=TypeName;
      End;
      SetFlag(cfData, i);
      //IntfTable
      if intfTableAdr<>0 then
      Begin
        _pos := Adr2Pos(intfTableAdr); 
        bytes := 0;
        SetFlag(cfData or cfVTable, _pos);
        EntryCount := PInteger(Code + _pos)^; 
        Inc(_pos, 4); 
        Inc(bytes, 4);
        for m := 0 to EntryCount-1 do
        Begin
          //GUID
          Inc(_pos,16); 
          Inc(bytes, 16);
          vTableAdr := PInteger(Code + _pos)^;
          Inc(_pos, 4);
          Inc(bytes, 4);
          if IsValidImageAdr(vTableAdr) then SetFlag(cfData or cfVTable, Adr2Pos(vTableAdr));
          //IOffset
          Inc(_pos, 4); 
          Inc(bytes, 4);
          if DelphiVersion > 3 then
          Begin
            //ImplGetter
            Inc(_pos, 4); 
            Inc(bytes, 4);
          End;
        End;
        //Intfs
        if DelphiVersion >= 2012 then Inc(bytes, EntryCount * 4);
        //Use IntfTable
        SetFlags(cfData, Adr2Pos(intfTableAdr), bytes);
        //Second pass (to use already set flags)
        _pos := Adr2Pos(intfTableAdr) + 4;
        for m := 0 to EntryCount-1 do
        Begin
          //Skip GUID
          Inc(_pos, 16);
          vTableAdr := PInteger(Code + _pos)^; 
          Inc(_pos, 4);
          //IOffset
          Inc(_pos, 4);
          if DelphiVersion > 3 then
          Begin
            //ImplGetter
            Inc(_pos, 4);
          End;
          //Use VTable
          if IsValidImageAdr(vTableAdr) then
          Begin
            vEnd := vTableAdr;
            vStart := vTableAdr;
            posv := Adr2Pos(vTableAdr); 
            bytes := 0;
            while true do
            Begin
              if Pos2Adr(posv) = intfTableAdr then break;
              vAdr := PInteger(Code + posv)^;
              Inc(posv, 4);
              Inc(bytes, 4);
              if (vAdr<>0) and (vAdr < vStart) then vStart := vAdr;
            End;
            //Use VTable
            SetFlags(cfData, Adr2Pos(vEnd), bytes);
            //Leading always byte CC
            Dec(vStart);
            //Use all refs
            SetFlags(cfData, Adr2Pos(vStart), vEnd - vStart);
          End;
        End;
      End;
      //AutoTable
      if autoTableAdr<>0 then
      Begin
        _pos := Adr2Pos(autoTableAdr);
        bytes := 0;
        EntryCount := PInteger(Code + _pos)^; 
        Inc(_pos, 4); 
        Inc(bytes, 4);
        for m := 0 to EntryCount-1 do
        Begin
          //DispID
          Inc(_pos, 4); 
          Inc(bytes, 4);
          //NameAdr
          pos1 := Adr2Pos(PInteger(Code + _pos)^); 
          Inc(_pos, 4);
          Inc(bytes, 4);
          len := Byte(Code[pos1]);
          //Use name
          SetFlags(cfData, pos1, len + 1);
          //Flags
          Inc(_pos, 4); 
          Inc(bytes, 4);
          //ParamsAdr
          pos1 := Adr2Pos(PInteger(Code + _pos)^); 
          Inc(_pos, 4); 
          Inc(bytes, 4);
          ParamCnt := Byte(Code[pos1 + 1]);
          //Use Params
          SetFlags(cfData, pos1, ParamCnt + 2);
          //AddressAdr
          Inc(_pos, 4); 
          Inc(bytes, 4);
        End;
        //Use AutoTable
        SetFlags(cfData, Adr2Pos(autoTableAdr), bytes);
      End;
      //InitTable
      if initTableAdr<>0 then
      Begin
        _pos := Adr2Pos(initTableAdr); 
        bytes := 0;
        //Skip 0xE
        Inc(_pos); 
        Inc(bytes);
        //Unknown byte
        Inc(_pos); 
        Inc(bytes);
        //Unknown dword
        Inc(_pos, 4); 
        Inc(bytes, 4);
        Num32 := PInteger(Code + _pos)^; 
        Inc(bytes, 4);
        for m := 0 to Num32-1 do
        Begin
          //TypeOfs (information about types is already extracted)
          Inc(bytes, 4);
          //FieldOfs
          Inc(bytes, 4);
        End;
        //Use InitTable
        SetFlags(cfData, Adr2Pos(initTableAdr), bytes);
      End;
      //FieldTable
      if fieldTableAdr<>0 then
      Begin
        _pos := Adr2Pos(fieldTableAdr); 
        bytes := 0;
        Num16 := PWord(Code + _pos)^; 
        Inc(_pos, 2); 
        Inc(bytes, 2);
        //TypesTab
        typesTab := PInteger(Code + _pos)^; 
        Inc(_pos, 4);
        Inc(bytes, 4);
        for m := 0 to Num16-1 do
        Begin
          //Offset
          Inc(_pos, 4); 
          Inc(bytes, 4);
          //Idx
          Inc(_pos, 2); 
          Inc(bytes, 2);
          //Name
          len := Byte(Code[_pos]);
          Inc(_pos); 
          Inc(bytes);
          Inc(_pos, len); 
          Inc(bytes, len);
        End;
        //Use TypesTab
        if typesTab<>0 then
        Begin
          Num16 := PWord(Code + Adr2Pos(typesTab))^;
          SetFlags(cfData, Adr2Pos(typesTab), 2 + Num16*4);
        End;
        //Extended Information
        if DelphiVersion >= 2010 then
        Begin
          Num16 := PWord(Code + _pos)^; 
          Inc(_pos, 2); 
          Inc(bytes, 2);
          for m := 0 to Num16-1 do
          Begin
            //Flags
            Inc(_pos); 
            Inc(bytes);
            //TypeRef
            Inc(_pos, 4); 
            Inc(bytes, 4);
            //Offset
            Inc(_pos, 4);
            Inc(bytes, 4);
            //Name
            len := Byte(Code[_pos]);
            Inc(_pos); 
            Inc(bytes);
            Inc(_pos, len); 
            Inc(bytes, len);
            //AttrData
            dw := PWord(Code + _pos)^;
            Inc(_pos, dw);
            Inc(bytes, dw);//ATR!!
          End;
        End;
        //Use FieldTable
        SetFlags(cfData, Adr2Pos(fieldTableAdr), bytes);
      End;
      //MethodTable
      if methodTableAdr<>0 then
      Begin
        _pos := Adr2Pos(methodTableAdr); 
        bytes := 0;
        Num16 := PWord(Code + _pos)^; 
        Inc(_pos, 2); 
        Inc(bytes, 2);
        for m := 0 to Num16-1 do
        Begin
          //Len
          skipBytes := PWord(Code + _pos)^; 
          Inc(_pos,skipBytes); 
          Inc(bytes, skipBytes);
        End;
        if DelphiVersion >= 2010 then
        Begin
          Num16 := PWord(Code + _pos)^; 
          Inc(_pos, 2); 
          Inc(bytes, 2);
          for m := 0 to Num16-1 do
          Begin
            //MethodEntry
            methodEntry := PInteger(Code + _pos)^; 
            Inc(_pos,4); 
            Inc(bytes, 4);
            skipBytes := PWord(Code + Adr2Pos(methodEntry))^;
            SetFlags(cfData, Adr2Pos(methodEntry), skipBytes);
            //Flags
            Inc(_pos, 2); 
            Inc(bytes, 2);
            //VirtualIndex
            Inc(_pos, 2); 
            Inc(bytes, 2);
          End;
          if DelphiVersion >= 2012 then
          Begin
            //VirtCount
            Inc(bytes, 2); 
          End;
        End;
        //Use MethodTable
        SetFlags(cfData, Adr2Pos(methodTableAdr), bytes);
      End;
      //DynamicTable
      if dynamicTableAdr<>0 then
      Begin
        _pos := Adr2Pos(dynamicTableAdr); 
        bytes := 0;
        Num16 := PWord(Code + _pos)^; 
        Inc(bytes, 2);
        for m := 0 to Num16-1 do
        Begin
          //Msg+ProcAdr
          Inc(bytes, 6);
        End;
        //Use DynamicTable
        SetFlags(cfData, Adr2Pos(dynamicTableAdr), bytes);
      End;

      //StopAt := GetStopAt(classVMT);
      //Use Virtual Table
      SetFlags(cfData, i, StopAt - classVMT - VmtSelfPtr);
      recU := mainForm.GetUnit(classVMT);
      if Assigned(recU) then
      Begin
        adr := PInteger(Code + i - VmtSelfPtr + VmtTypeInfo)^;
        if (adr<>0) and IsValidImageAdr(adr) then
        Begin
          //Extract unit name
          _pos := Adr2Pos(adr); 
          bytes := 0;
          b := Byte(Code[_pos]);
          Inc(_pos);
          Inc(bytes);
          if b <> 7 then
          Begin
            Inc(i,4);
            continue;
          end;
          len := Byte(Code[_pos]);
          Inc(_pos); 
          Inc(bytes);
          if not IsValidName(len, _pos) then
          Begin
            Inc(i,4);
            continue;
          end;
          Inc(_pos, len + 10); 
          Inc(bytes, len + 10);
          len := Byte(Code[_pos]);
          Inc(_pos); 
          Inc(bytes);
          if not IsValidName(len, _pos) then
          begin
            Inc(i,4);
            continue;
          end;
          unitName := Trim(MakeString(Code + _pos, len)); 
          Inc(bytes, len);
          FMain.SetUnitName(recU, unitName);
          //Use information about Unit (including previous dword)
          SetFlags(cfData, Adr2Pos(adr) - 4, bytes + 4);
        End;
      End;
    End;
    Inc(i,4);
  End;
  StopProgress;
end;

Procedure TAnalyzeThread.StrapVMTs;
var
  stepMask:Integer;
  cInfo:MConstInfo;
  i,Idx:Integer;
  recN:InfoRec;
  use:TWordDynArray;
  _name,constName:AnsiString;
Begin
  stepMask := StartProgress(TotalSize, 'Strap Virtual Method Tables');
  i:=0;
  While (i < TotalSize) and not Terminated do
  begin
    if (i and stepMask) = 0 then UpdateProgress;
    recN := GetInfoRec(Pos2Adr(i));
    if Assigned(recN) and (recN.kind = ikVMT) then
    begin
      _name := recN.Name;
      ConstName := '_DV_' + _name;
      use := KBase.GetConstUses(PAnsiChar(ConstName));
      Idx := KBase.GetConstIdx(use, PAnsiChar(ConstName));
      if Idx <> -1 then
      begin
        Idx := KBase.ConstOffsets[Idx].NamId;
        if KBase.GetConstInfo(Idx, INFO_DUMP, cInfo) then
        begin
          UpdateStatusBar(_name);
          mainForm.StrapVMT(i + 4, Idx, @cInfo);
        end;
      end;
      use:=Nil;
    end;
    Inc(i,4);
  end;
  StopProgress;
end;

Procedure TAnalyzeThread.FindTypeFields;
var
  len,moduleID:Word;
  stepMask,i,u,n:Integer;
  cntVmt,vmtAdr,cntUnit,idx:Integer;
  tInfo:MTypeInfo;
  recN:InfoRec;
  recU:PUnitRec;
  recV:PVmtListRec;
  use:TWordDynArray;
  P:PAnsiChar;
  Scope:Byte;       //9-private, 10-protected, 11-public, 12-published
  Offset:Integer;   //Offset in the object
  _Case:Integer;    //case for record types (0xFFFFFFFF for the rest)
  Name:AnsiString;  //Field name
  _Type:AnsiString; //Field type
Begin
  stepMask := StartProgress(TotalSize, 'Find Type Fields');
  i:=0;
  While (i < TotalSize) and not Terminated do
  begin
    if (i and stepMask) = 0 then UpdateProgress;
    recN := GetInfoRec(Pos2Adr(i));
    if Assigned(recN) and (recN.kind = ikVMT) then
    begin
      vmtAdr := Pos2Adr(i) - VmtSelfPtr;
      recU := mainForm.GetUnit(vmtAdr);
      if Assigned(recU) then
      begin
        cntUnit:=recU.names.Count;
        u:=0;
        while (u< cntUnit) and not Terminated do
        begin
          ModuleID := KBase.GetModuleID(PAnsiChar(recU.names[u]));
          use := KBase.GetModuleUses(ModuleID);
          //Find Type to extract information about fields
          Idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(recN.Name));
          if Idx <> -1 then
          begin
            Idx := KBase.TypeOffsets[Idx].NamId;
            if KBase.GetTypeInfo(Idx, INFO_FIELDS, tInfo) then
            begin
              if Assigned(tInfo.Fields) then
              begin
                UpdateStatusBar(tInfo.TypeName);
                p := tInfo.Fields;
                for n := 0 To tInfo.FieldsNum-1 do
                begin
                  Scope := Byte(p^);
                  Inc(p);
                  Offset := PInteger(p)^;
                  Inc(p, 4);
                  _Case := PInteger(p)^;
                  Inc(p, 4);
                  Len := PWord(p)^;
                  Inc(p, 2);
                  Name := MakeString(p, Len);
                  Inc(p, Len + 1);
                  Len := PWord(p)^;
                  Inc(p, 2);
                  _Type := TrimTypeName(MakeString(p, Len));
                  Inc(p, Len + 1);
                  recN.vmtInfo.AddField(0, 0, Scope, Offset, _Case, Name, _Type);
                end;
              end;
            end;
          End;
          use:=Nil;
          Inc(u);
        end;
      end;
    end;
    Inc(i,4);
  end;
  StopProgress;
  cntVmt := VmtList.Count;
  stepMask := StartProgress(cntVmt, 'Propagate VMT Names');
  n:=0;
  While (n < cntVmt) and not Terminated do
  begin
    if (n and stepMask) = 0 then UpdateProgress;
    recV := PVmtListRec(VmtList[n]);
    UpdateStatusBar(GetClsName(recV.vmtAdr));
    mainForm.PropagateVMTNames(recV.vmtAdr);
    Inc(n);
  end;
  StopProgress;
end;

Function TAnalyzeThread.FindEvent (VmtAdr:Integer; Name:AnsiString):AnsiString;
var
  adr,n:Integer;
  recN:InfoRec;
  fInfo:FieldInfo;
Begin
  Result:='';
  adr:=VmtAdr;
  while adr<>0 do
  begin
    recN := GetInfoRec(adr);
    if Assigned(recN) and Assigned(recN.vmtInfo.fields) then
      for n := 0 to recN.vmtInfo.fields.Count-1 do
      begin
        fInfo := FieldInfo(recN.vmtInfo.fields[n]);
        if SameText(fInfo.Name, Name) Then
        Begin
          Result:=fInfo._Type;
          Exit;
        end;
      end;
    adr := GetParentAdr(adr);
  end;
end;

Procedure TAnalyzeThread.FindPrototypes;
var
  n, m, k, r, idx, usesNum,stepMask,ss,formAdr,ctlAdr:Integer;
  recN,recN1:InfoRec;
  importName, _name:AnsiString;
  pInfo:MProcInfo;
  tInfo:MTypeInfo;
  arg:ArgInfo;
  dot,len:Integer;
  p:PAnsiChar;
  dfm:TDfm;
  ev:TList;
  eInfo:PEventInfo;
  recM:PMethodRec;
  cInfo:PComponentInfo;
  clsName,clasName,typeName:AnsiString;
  callKind:Byte;
  found:Boolean;
  use:TWordDynArray;
  wlen:Word;
Begin
  stepMask := StartProgress(CodeSize, 'Find Import Prototypes');
  n:=0;
  SetLength(use,128);
  while (n < CodeSize) and not Terminated do
  Begin
    if (n and stepMask) = 0 then UpdateProgress;
    if IsFlagSet(cfImport, n) then
    Begin
      recN := GetInfoRec(Pos2Adr(n));
      _name := recN.Name;
      dot := Pos('.',_name);
      len := Length(_name);
      found := false;
      //try find arguments
      //FullName
      importName := Copy(_name,dot + 1, len);
      usesNum := KBase.GetProcUses(PAnsiChar(importName), use);
      for m:=0 to usesNum-1 do
      Begin
        if Terminated then Break;
        idx := KBase.GetProcIdx(use[m], PAnsiChar(importName));
        if idx <> -1 then
        Begin
          idx := KBase.ProcOffsets[idx].NamId;
          if KBase.GetProcInfo(idx, INFO_ARGS, pInfo) then
          Begin
            if pInfo.MethodKind = 'F' then
            Begin
              recN.kind := ikFunc;
              recN._type := pInfo.TypeDef;
            End
            else if pInfo.MethodKind = 'P' then
              recN.kind := ikProc;
            if recN.procInfo=Nil then recN.procInfo := InfoProcInfo.Create;
            if Assigned(pInfo.Args) then
            Begin
              callKind := pInfo.CallKind;
              recN.procInfo.flags:= recN.procInfo.flags or callKind;
              p := pInfo.Args; 
              ss := 8;
              for k := 0 to pInfo.ArgsNum-1 do
              Begin
                FillArgInfo(k, callKind, @arg, p, ss);
                recN.procInfo.AddArg(@arg);
              End;
              found := true;
            End;
          End;
          if found then break;
        End;
      End;
      if not found then
      Begin
        //try short name
        importName := Copy(_name,dot + 1, len - dot - 1);
        usesNum := KBase.GetProcUses(PAnsiChar(importName), use);
        for m:=0 to usesNum-1 do
        Begin
          if Terminated then Break;
          idx := KBase.GetProcIdx(use[m], PAnsiChar(importName));
          if idx <> -1 then
          Begin
            idx := KBase.ProcOffsets[idx].NamId;
            if KBase.GetProcInfo(idx, INFO_ARGS, pInfo) then
            Begin
              if pInfo.MethodKind = 'F' then
              Begin
                recN.kind := ikFunc;
                recN._type := pInfo.TypeDef;
              End
              else if pInfo.MethodKind = 'P' then
                recN.kind := ikProc;
              if recN.procInfo=Nil then recN.procInfo := InfoProcInfo.Create;
              if Assigned(pInfo.Args) then
              Begin
                callKind := pInfo.CallKind;
                recN.procInfo.flags := recN.procInfo.flags or callKind;
                p := pInfo.Args;
                ss := 8;
                for k := 0 to pInfo.ArgsNum-1 do
                Begin
                  FillArgInfo(k, callKind, @arg, p, ss);
                  recN.procInfo.AddArg(@arg);
                End;
                found := true;
              End;
            End;
            if found then break;
          End;
        End;
      End;
      if not found then
      Begin
        //try without arguments
        //FullName
        importName := Copy(_name,dot + 1, len - dot);
        usesNum := KBase.GetProcUses(PAnsiChar(importName), use);
        for m:=0 to usesNum-1 do
        Begin
          if Terminated then Break;
          idx := KBase.GetProcIdx(use[m], PAnsiChar(importName));
          if idx <> -1 then
          Begin
            idx := KBase.ProcOffsets[idx].NamId;
            if KBase.GetProcInfo(idx, INFO_ARGS, pInfo) then
            Begin
              if pInfo.MethodKind = 'F' then
              Begin
                recN.kind := ikFunc;
                recN._type := pInfo.TypeDef;
              End
              else if pInfo.MethodKind = 'P' then
                recN.kind := ikProc;
              found := true;
            End;
            if found then break;
          End;
        End;
      End;
      if not found then
      Begin
        //try without arguments
        //ShortName
        importName := Copy(_name,dot + 1, len - dot - 1);
        usesNum := KBase.GetProcUses(PAnsiChar(importName), use);
        for m:=0 to usesNum-1 do
        Begin
          if Terminated then Break;
          idx := KBase.GetProcIdx(use[m], PAnsiChar(importName));
          if idx <>-1 then
          Begin
            idx := KBase.ProcOffsets[idx].NamId;
            if KBase.GetProcInfo(idx, INFO_ARGS, pInfo) then
            Begin
              if pInfo.MethodKind = 'F' then
              Begin
                recN.kind := ikFunc;
                recN._type := pInfo.TypeDef;
              End
              else if pInfo.MethodKind = 'P' then
                recN.kind := ikProc;
              found := true;
            End;
            if found then break;
          End;
        End;
      End;
    End;
    Inc(n,4);
  End;
  use:=Nil;
  StopProgress;
  StartProgress(ResInfo.FormList.Count, 'Find Event Prototypes');
  for n:=0 to ResInfo.FormList.Count-1 do
  Begin
    if Terminated then Break;
    UpdateProgress;
    dfm := ResInfo.FormList[n];
    clasName := dfm.FormClass;
    formAdr := GetClassAdr(clasName);
    if formAdr=0 then continue;
    recN := GetInfoRec(formAdr);
    if (recN=Nil) or (recN.vmtInfo.methods=Nil) then continue;

    //The first: form events
    ev := dfm.Events;
    for m:=0 to ev.Count-1 do
    Begin
      if Terminated then Break;
      eInfo := ev[m];
      ctlAdr := GetClassAdr(dfm.FormClass);
      typeName := FindEvent(ctlAdr, 'F' + eInfo.EventName);
      if typeName = '' then typeName := FindEvent(ctlAdr, eInfo.EventName);
      if typeName <> '' then
      Begin
        for k:=0 to recN.vmtInfo.methods.Count-1 do
        Begin
          if Terminated then Break;
          recM := recN.vmtInfo.methods[k];
          if SameText(recM.name, clasName + '.' + eInfo.ProcName) then
          Begin
            recN1 := GetInfoRec(recM.address);
            if Assigned(recN1) then
            Begin
              clsname := clasName;
              while true do
              Begin
                if KBase.GetKBPropertyInfo(PAnsiChar(clsname), eInfo.EventName, tInfo) then
                Begin
                  recN1.kind := ikProc;
                  recN1.procInfo.flags := recN1.procInfo.flags or PF_EVENT;
                  recN1.procInfo.DeleteArgs;
                  //eax always Self
                  recN1.procInfo.AddArg($21, 0, 4, 'Self', clasName);
                  //transform declaration to arguments
                  recN1.procInfo.AddArgsFromDeclaration(tInfo.Decl, 1, 0);
                  break;
                End;
                clsname := GetParentName(clsname);
                if clsname = '' then break;
              End;
            End
            else ShowMessage('recN is NULL');
            break;
          End;
        End;
      End;
    End;
    //The second: components events
    for m:=0 to dfm.Components.Count-1 do
    Begin
      if Terminated then Break;
      cInfo := dfm.Components[m];
      ev := cInfo.Events;
      for k:=0 to ev.Count-1 do
      Begin
        if Terminated then Break;
        eInfo := ev[k];
        ctlAdr := GetClassAdr(cInfo.ClasName);
        typeName := FindEvent(ctlAdr, 'F' + eInfo.EventName);
        if typeName = '' then typeName := FindEvent(ctlAdr, eInfo.EventName);
        if typeName <> '' then
        Begin
          for r:=0 to recN.vmtInfo.methods.Count-1 do
          Begin
            if Terminated then Break;
            recM := recN.vmtInfo.methods[r];
            if SameText(recM.name, clasName + '.' + eInfo.ProcName) then
            Begin
              recN1 := GetInfoRec(recM.address);
              if Assigned(recN1) then
              Begin
                clsname := clasName;
                while true do
                Begin
                  if KBase.GetKBPropertyInfo(PAnsiChar(clsname), eInfo.EventName, tInfo) then
                  Begin
                    recN1.kind := ikProc;
                    recN1.procInfo.flags := recN1.procInfo.flags or PF_EVENT;
                    recN1.procInfo.DeleteArgs;
                    //eax always Self
                    recN1.procInfo.AddArg($21, 0, 4, 'Self', clasName);
                    //transform declaration to arguments
                    recN1.procInfo.AddArgsFromDeclaration(tInfo.Decl, 1, 0);
                    break;
                  End;
                  clsname := GetParentName(clsname);
                  if clsname = '' then break;
                End;
              End
              else ShowMessage('recN is NULL');
              break;
            End;
          End;
        End;
      End;
    End;
  End;
  StopProgress;
end;

Procedure TAnalyzeThread.ScanCode;
var
  matched,term:Boolean;
  moduleID:Word;
  Adr, iniAdr, finAdr, vmtAdr:Integer;
  FirstProcIdx, LastProcIdx, Num, DumpSize:Integer;
  i, n, m, k, r, u, Idx, fromPos, toPos, lastMatchPos, stepMask:Integer;
  recU:PUnitRec;
  recN:InfoRec;
  pInfo:MProcInfo;
  cInfo:MConstInfo;
  clasName, unitName,constName:AnsiString;
Begin
  StartProgress(UnitsNum, 'Scan Initialization and Finalization procs');

  //Begin with initialization and finalization procs
  for n:=0 to UnitsNum-1 do
  Begin
    if Terminated then Break;
    UpdateProgress;
    recU := Units[n];
    if recU.trivial then continue;
    iniAdr := recU.iniadr;
    if (iniAdr<>0) and not recU.trivialIni then
    Begin
      mainForm.AnalyzeProc(0, iniAdr);
      for u:=0 to recU.names.Count-1 do
      Begin
        if Terminated then Break;
        moduleID := KBase.GetModuleID(PAnsiChar(recU.names[u]));
        if moduleID = $FFFF then continue;
        recU.kb := true;
        //If unit is in knowledge base try to find proc Initialization
        Idx := KBase.GetProcIdx(moduleID, PAnsiChar(recU.names[u]));
        if Idx <> -1 then
        Begin
          Idx := KBase.ProcOffsets[Idx].NamId;
          if not KBase.IsUsedProc(Idx) then
          begin
            if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
            Begin
              matched := MatchCode(Code + Adr2Pos(iniAdr), @pInfo) and mainForm.StrapCheck(Adr2Pos(iniAdr), @pInfo);
              if matched then mainForm.StrapProc(Adr2Pos(iniAdr), Idx, @pInfo, true, pInfo.DumpSz);
            End;
          end;
        End;
      End;
    End;
    finAdr := recU.finadr;
    if (finAdr<>0) and not recU.trivialFin then
    Begin
      mainForm.AnalyzeProc(0, finAdr);
      for u:=0 to recU.names.Count-1 do
      Begin
        if Terminated then Break;
        moduleID := KBase.GetModuleID(PAnsiChar(recU.names[u]));
        if moduleID = $FFFF then continue;
        recU.kb := true;
        //If unit is in knowledge base try to find proc Finalization
        Idx := KBase.GetProcIdx(moduleID, 'Finalization');
        if Idx <>-1 then
        Begin
          Idx := KBase.ProcOffsets[Idx].NamId;
          if not KBase.IsUsedProc(Idx) then
          begin
            if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
            Begin
              matched := MatchCode(Code + Adr2Pos(finAdr), @pInfo) and mainForm.StrapCheck(Adr2Pos(finAdr), @pInfo);
              if matched then mainForm.StrapProc(Adr2Pos(finAdr), Idx, @pInfo, true, pInfo.DumpSz);
            End;
          end;
        End;
      End;
    End;
  End;
  StopProgress;
  //EP
  mainForm.AnalyzeProc(0, EP);
  //Classes (methods, dynamics procedures, virtual methods)
  stepMask := StartProgress(TotalSize, 'Analyze Class Tables');
  term:=False;
  for n:=0 to TotalSize-1 do
  Begin
    if Terminated then Break;
    if (n and stepMask) = 0 then UpdateProgress;
    recN := GetInfoRec(Pos2Adr(n));
  	if Assigned(recN) and (recN.kind = ikVMT) then
    Begin
      vmtAdr := Pos2Adr(n);
      UpdateStatusBar(GetClsName(vmtAdr));
      mainForm.AnalyzeMethodTable(0, vmtAdr, Term);
      if Term then
      Begin
        Terminate;
        break;
      end;
      mainForm.AnalyzeDynamicTable(0, vmtAdr, Term);
      if Term then
      Begin
        Terminate;
        break;
      end;
      mainForm.AnalyzeVirtualTable(0, vmtAdr, Term);
      if Term then
      begin
        Terminate;
        Break;
      end;
    End;
  End;
  StopProgress;
  //Scan some standard units
  StartProgress(Length(StdUnits), 'Scan Standard Units: step 1');
  for r:=Low(StdUnits) to High(StdUnits) do
  Begin
    if Terminated then Break;
    UpdateProgress;
    StdUnits[r].used := false;
    StdUnits[r].matched := 0;
    StdUnits[r].maxno := -1;
    moduleID := KBase.GetModuleID(StdUnits[r].name);
    if moduleID = $FFFF then continue;
    if not KBase.GetProcIdxs(moduleID, @FirstProcIdx, @LastProcIdx) then continue;
    for n:=0 to UnitsNum-1 do
    Begin
      if Terminated then Break;
      recU := Units[n];
      if recU.trivial then continue;

      //Analyze units without name
      if recU.names.Count=0 then
      Begin
        recU.matchedPercent := 0;
        fromPos := Adr2Pos(recU.fromAdr);
        toPos := Adr2Pos(recU.toAdr);
        for m:=fromPos to toPos-1 do
        Begin
          if Terminated then Break;
          if IsFlagSet(cfProcStart, m) then
          Begin
            if (r <> 5) and (Pos2Adr(m) = recU.iniadr) then continue;
            if (r <> 5) and (Pos2Adr(m) = recU.finadr) then continue;
            recN := GetInfoRec(Pos2Adr(m));
            if Assigned(recN) and recN.HasName then continue;
            UpdateAddrInStatusBar(Pos2Adr(m));
            for k:=FirstProcIdx to LastProcIdx do
            Begin
              if Terminated then Break;
              Idx := KBase.ProcOffsets[k].ModId;
              if not KBase.IsUsedProc(Idx) then
              Begin
                matched := false;
                if KBase.GetProcInfo(Idx, INFO_DUMP, pInfo) and (pInfo.DumpSz >= 8) then
                Begin
                  matched := MatchCode(Code + m, @pInfo) and mainForm.StrapCheck(m, @pInfo);
                  if matched then
                  Begin
                    //If method of class, check that ClassName is found
                    clasName := ExtractClassName(pInfo.ProcName);
                    if (clasName = '') or Assigned(GetOwnTypeByName(clasName)) then
                    Begin
                      recU.matchedPercent:=recU.matchedPercent + 100 * pInfo.DumpSz / (toPos - fromPos + 1);
                      break;
                    End;
                  End;
                End;
              End;
            End;
          End;
        End;
        if recU.matchedPercent > StdUnits[r].matched then
        Begin
          StdUnits[r].matched := recU.matchedPercent;
          StdUnits[r].maxno := n;
        End;
      End;
    End;
  End;
  StopProgress;
  StartProgress(Length(StdUnits), 'Scan Standard Units: step 2');
  for r:=Low(StdUnits) to High(StdUnits) do
  Begin
    if Terminated then Break;
    UpdateProgress;
    if StdUnits[r].used then continue;
    if StdUnits[r].matched < 50 then continue;
    moduleID := KBase.GetModuleID(StdUnits[r].name);
    if moduleID = $FFFF then continue;
    if not KBase.GetProcIdxs(moduleID, @FirstProcIdx, @LastProcIdx) then continue;
    n := StdUnits[r].maxno;
    recU := Units[n];
    if recU.trivial then continue;
    //Analyze units without name
    if recU.names.Count=0 then
    Begin
      fromPos := Adr2Pos(recU.fromAdr);
      toPos := Adr2Pos(recU.toAdr);
      for m:=fromPos to toPos-1 do
      Begin
        if Terminated then Break;
        if IsFlagSet(cfProcStart, m) then
        Begin
          if (r <> 5) and (Pos2Adr(m) = recU.iniadr) then continue;
          if (r <> 5) and (Pos2Adr(m) = recU.finadr) then continue;
          recN := GetInfoRec(Pos2Adr(m));
          if Assigned(recN) and recN.HasName then continue;
          UpdateAddrInStatusBar(Pos2Adr(m));
          for k:=FirstProcIdx to LastProcIdx do
          Begin
            if Terminated then Break;
            Idx := KBase.ProcOffsets[k].ModId;
            if not KBase.IsUsedProc(Idx) then
            Begin
              matched := false;
              if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) and (pInfo.DumpSz >= 8) then
              Begin
                matched := MatchCode(Code + m, @pInfo) and mainForm.StrapCheck(m, @pInfo);
                if matched then
                Begin
                  //If method of class, check that ClassName is found
                  clasName := ExtractClassName(pInfo.ProcName);
                  if (clasName = '') or Assigned(GetOwnTypeByName(clasName)) then
                  Begin
                    mainForm.StrapProc(m, Idx, @pInfo, true, pInfo.DumpSz);
                    StdUnits[r].used := true;
                    break;
                  End;
                End;
              End;
            End;
          End;
        End;
      End;
    End;
  End;
  StopProgress;
  for n:=0 to UnitsNum-1 do
  Begin
    if Terminated then Break;
    //UpdateProgress;
    recU := Units[n];
    if recU.trivial then continue;
    fromPos := Adr2Pos(recU.fromAdr);
    toPos := Adr2Pos(recU.toAdr);
    //Delphi2 - it is possible that toPos := -1 
    if toPos = -1 then toPos := TotalSize;
    for u:=0 to recU.names.Count-1 do
    Begin
      if Terminated then Break;
      unitName := recU.names[u];
      moduleID := KBase.GetModuleID(PAnsiChar(unitName));
      if moduleID = $FFFF then continue;
      if not KBase.GetProcIdxs(moduleID, FirstProcIdx, LastProcIdx, DumpSize) then continue;
      stepMask := StartProgress(toPos - fromPos + 1, 'Scan Unit ' + unitName + ': step 1');
      recU.kb := true;
      lastMatchPos := 0;
      m:=fromPos;
      While m < toPos do
      Begin
        if Terminated then Break;
        if ((m-fromPos) and stepMask) = 0 then UpdateProgress;
        if (lastMatchPos<>0) and (m > lastMatchPos + DumpSize) then break;
        if Code[m]=#0 then
        Begin
          Inc(m);
          continue;
        end;
        if IsFlagSet(cfProcStart, m) or (FlagList[m]=0) then
        Begin
          if ((Pos2Adr(m) = recU.iniadr) and recU.trivialIni) or
            ((Pos2Adr(m) = recU.finadr) and recU.trivialFin) then
          begin
            Inc(m);
            continue;
          end;
          recN := GetInfoRec(Pos2Adr(m));
          if Assigned(recN) and recN.HasName then
          Begin
            Inc(m);
            continue;
          end;
          UpdateAddrInStatusBar(Pos2Adr(m));
          for k:=FirstProcIdx to LastProcIdx do
          Begin
            if Terminated then Break;
            Idx := KBase.ProcOffsets[k].ModId;
            if not KBase.IsUsedProc(Idx) then
            Begin
              if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) and (pInfo.DumpSz >= 8) then
              Begin
                //Check code matching
                matched := MatchCode(Code + m, @pInfo) and mainForm.StrapCheck(m, @pInfo);
                if matched then
                Begin
                  //If method of class, check that ClassName is found
                  clasName := ExtractClassName(pInfo.ProcName);
                  if (clasName = '') or Assigned(GetOwnTypeByName(clasName)) then
                  Begin
                    if lastMatchPos=0 then lastMatchPos := m;
                    mainForm.StrapProc(m, Idx, @pInfo, true, pInfo.DumpSz);
                    Inc(m, pInfo.DumpSz - 1);
                    break;
                  End;
                End;
              End;
            End;
          End;
        End;
        Inc(m);
      End;
      StopProgress;
    End;
  End;
  //Теперь попробуем опять пройтись по VMT и поискать их в базе знаний
  stepMask := StartProgress(TotalSize, 'Scan Units: step 2');
  for n:=0 to TotalSize-1 do
  Begin
    if Terminated then Break;
    if (n and stepMask) = 0 then UpdateProgress;
    recN := GetInfoRec(Pos2Adr(n));
  	if Assigned(recN) and (recN.kind = ikVMT) then
    Begin
      ConstName := '_DV_' + recN.Name;
      Num := KBase.GetConstIdxs(PAnsiChar(ConstName), Idx);
      if Num = 1 then
      Begin
        Adr := Pos2Adr(n);
        recU := mainForm.GetUnit(Adr);
        if (recU=Nil) or recU.trivial then continue;
        if recU.names.Count=0 then
        Begin
          Idx := KBase.ConstOffsets[Idx].NamId;
          if KBase.GetConstInfo(Idx, INFO_DUMP, cInfo) then
          Begin
            moduleID := cInfo.ModuleID;
            if not KBase.GetProcIdxs(moduleID, @FirstProcIdx, @LastProcIdx) then continue;
            fromPos := Adr2Pos(recU.fromAdr);
            toPos := Adr2Pos(recU.toAdr);
            for m:=fromPos to toPos-1 do
            Begin
              if Terminated then Break;
              if IsFlagSet(cfProcStart, m) then
              Begin
                if (Pos2Adr(m) = recU.iniadr) and recU.trivialIni then continue;
                if (Pos2Adr(m) = recU.finadr) and recU.trivialFin then continue;
                recN := GetInfoRec(Pos2Adr(m));
                if Assigned(recN) and recN.HasName then continue;
                UpdateAddrInStatusBar(Pos2Adr(m));
                for k:=FirstProcIdx to LastProcIdx do
                Begin
                  if Terminated then Break;
                  Idx := KBase.ProcOffsets[k].ModId;
                  if not KBase.IsUsedProc(Idx) then
                  Begin
                    matched := false;
                    if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
                    Begin
                      matched := MatchCode(Code + m, @pInfo) and mainForm.StrapCheck(m, @pInfo);
                      if matched then
                      Begin
                        unitName := KBase.GetModuleName(moduleID);
                        FMain.SetUnitName(recU, unitName);
                        recU.kb := true;
                        mainForm.StrapProc(m, Idx, @pInfo, true, pInfo.DumpSz);
                        break;
                      End;
                    End;
                  End;
                End;
              End;
            End;
          End;
        End;
      End;
    End;
  End;
  StopProgress;
end;

Procedure TAnalyzeThread.ScanCode1;
Var
  matched:Boolean;
  moduleID:Word;
  FirstProcIdx, LastProcIdx:Integer;
  n, m, k, r, u, Idx, fromPos, toPos:Integer;
  recU:PUnitRec;
  recN:InfoRec;
  pInfo:MProcInfo;
  clasName:AnsiString;
Begin
  StartProgress(UnitsNum, 'Scan Code more...');
  for n:=0 to UnitsNum-1 do
  Begin
    if Terminated then Break;
    UpdateProgress;
    recU := Units[n];
    if recU.trivial then continue;
    fromPos := Adr2Pos(recU.fromAdr);
    toPos := Adr2Pos(recU.toAdr);
    for u:=0 to recU.names.Count-1 do
    Begin
      if Terminated then Break;
      moduleID := KBase.GetModuleID(PAnsiChar(recU.names[u]));
      if moduleID = $FFFF then continue;
      if not KBase.GetProcIdxs(moduleID, @FirstProcIdx, @LastProcIdx) then continue;
      for m:=fromPos to toPos-1 do
      Begin
        if Terminated then Break;
        if IsFlagSet(cfProcStart, m) then
        Begin
          if (Pos2Adr(m) = recU.iniadr) and recU.trivialIni then continue;
          if (Pos2Adr(m) = recU.finadr) and recU.trivialFin then continue;
          recN := GetInfoRec(Pos2Adr(m));
          if Assigned(recN) and recN.HasName then continue;
          UpdateAddrInStatusBar(Pos2Adr(m));
          for k:=FirstProcIdx to LastProcIdx do
          Begin
            if Terminated Then Break;
            Idx := KBase.ProcOffsets[k].ModId;
            if not KBase.IsUsedProc(Idx) then
            Begin
              if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) and (pInfo.DumpSz > 1) then
              Begin
                matched := MatchCode(Code + m, @pInfo) and mainForm.StrapCheck(m, @pInfo);
                if matched then
                Begin
                  //If method of class, check that ClassName is found
                  clasName := ExtractClassName(pInfo.ProcName);
                  if (clasName = '') or Assigned(GetOwnTypeByName(clasName)) then
                  Begin
                    mainForm.StrapProc(m, Idx, @pInfo, true, pInfo.DumpSz);
                    break;
                  End;
                End;
              End;
            End;
          End;
        End;
      End;
    End;
  End;
  StopProgress;
  StartProgress(Length(StdUnits), 'Scan Standard Units more: step 1');
  //Попробуем некоторые стандартные юниты
  for r:=Low(StdUnits) to High(StdUnits) do
  Begin
    if Terminated then Break;
    UpdateProgress;
    if StdUnits[r].used then continue;
    StdUnits[r].matched := 0;
    StdUnits[r].maxno := -1;
    moduleID := KBase.GetModuleID(StdUnits[r].name);
    if moduleID = $FFFF then continue;
    if not KBase.GetProcIdxs(moduleID, @FirstProcIdx, @LastProcIdx) then continue;
    for n:=0 to UnitsNum-1 do
    Begin
      if Terminated then Break;
      recU := Units[n];
      if recU.trivial then continue;
      //Анализируем непоименованные юниты
      if recU.names.Count=0 then
      Begin
        recU.matchedPercent := 0;
        fromPos := Adr2Pos(recU.fromAdr);
        toPos := Adr2Pos(recU.toAdr);
        for m:=fromPos to toPos-1 do
        Begin
          if Terminated then Break;
          if IsFlagSet(cfProcStart, m) then
          Begin
            if Pos2Adr(m) = recU.iniadr then continue;
            if Pos2Adr(m) = recU.finadr then continue;
            recN := GetInfoRec(Pos2Adr(m));
            if Assigned(recN) and recN.HasName then continue;
            UpdateAddrInStatusBar(Pos2Adr(m));
            for k:=FirstProcIdx to LastProcIdx do
            Begin
              if Terminated then Break;
              Idx := KBase.ProcOffsets[k].ModId;
              if not KBase.IsUsedProc(Idx) then
              Begin
                matched := false;
                if KBase.GetProcInfo(Idx, INFO_DUMP, pInfo) and (pInfo.DumpSz > 1) then
                Begin
                  matched := MatchCode(Code + m, @pInfo) and mainForm.StrapCheck(m, @pInfo);
                  if matched then
                  Begin
                    //If method of class, check that ClassName is found
                    clasName := ExtractClassName(pInfo.ProcName);
                    if (clasName = '') or Assigned(GetOwnTypeByName(clasName)) then
                    Begin
                      recU.matchedPercent := recU.matchedPercent + 100 * pInfo.DumpSz / (toPos - fromPos + 1);
                      break;
                    End;
                  End;
                End;
              End;
            End;
          End;
        End;
        if recU.matchedPercent > StdUnits[r].matched then
        Begin
          StdUnits[r].matched := recU.matchedPercent;
          StdUnits[r].maxno := n;
        End;
      End;
    End;
  End;
  StopProgress;
  StartProgress(Length(StdUnits), 'Scan Standard Units more: step 2');
  for r:=Low(StdUnits) to High(StdUnits) do
  Begin
    if Terminated then Break;
    UpdateProgress;
    if StdUnits[r].used then continue;
    if StdUnits[r].matched < 50 then continue;
    moduleID := KBase.GetModuleID(StdUnits[r].name);
    if moduleID = $FFFF then continue;
    if not KBase.GetProcIdxs(moduleID, @FirstProcIdx, @LastProcIdx) then continue;
    n := StdUnits[r].maxno;
    recU := Units[n];
    if recU.trivial then continue;

    //Анализируем непоименованные юниты
    if recU.names.Count=0 then
    Begin
      fromPos := Adr2Pos(recU.fromAdr);
      toPos := Adr2Pos(recU.toAdr);
      for m:=fromPos to toPos-1 do
      Begin
        if Terminated then Break;
        if IsFlagSet(cfProcStart, m) then
        Begin
          if Pos2Adr(m) = recU.iniadr then continue;
          if Pos2Adr(m) = recU.finadr then continue;
          recN := GetInfoRec(Pos2Adr(m));
          if Assigned(recN) and recN.HasName then continue;
          UpdateAddrInStatusBar(Pos2Adr(m));
          for k:=FirstProcIdx to LastProcIdx do
          Begin
            if Terminated then Break;
            Idx := KBase.ProcOffsets[k].ModId;
            if not KBase.IsUsedProc(Idx) then
            Begin
              matched := false;
              if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) and (pInfo.DumpSz > 1) then
              Begin
                matched := MatchCode(Code + m, @pInfo) and mainForm.StrapCheck(m, @pInfo);
                if matched then
                Begin
                  //If method of class, check that ClassName is found
                  clasName := ExtractClassName(pInfo.ProcName);
                  if (clasName = '') or Assigned(GetOwnTypeByName(clasName)) then
                  Begin
                    mainForm.StrapProc(m, Idx, @pInfo, true, pInfo.DumpSz);
                    StdUnits[r].used := true;
                    break;
                  End;
                End;
              End;
            End;
          End;
        End;
      End;
    End;
  End;
  StopProgress;
end;

Procedure TAnalyzeThread.ScanVMTs;
var
  n,stepMask,vmtAdr:Integer;
  recN:InfoRec;
  _name:AnsiString;
Begin
  stepMask := StartProgress(TotalSize, 'Scan Virtual Method Tables');
  for n:=0 to TotalSize-1 do
  begin
    if Terminated then Break;
    if (n and stepMask) = 0 then UpdateProgress;
    recN := GetInfoRec(Pos2Adr(n));
    if Assigned(recN) and (recN.kind = ikVMT) then
    begin
      vmtAdr := Pos2Adr(n);
      _name := recN.Name;
      UpdateStatusBar(_name);
      mainForm.ScanFieldTable(vmtAdr);
      if Terminated then break;
      mainForm.ScanMethodTable(vmtAdr, _name);
      if Terminated then break;
      mainForm.ScanVirtualTable(vmtAdr);
      if Terminated then break;
      mainForm.ScanDynamicTable(vmtAdr);
      if Terminated then break;
      if DelphiVersion <> 2 then
      begin
        mainForm.ScanIntfTable(vmtAdr);
        mainForm.ScanAutoTable(vmtAdr);
        if Terminated then break;
      end;
      mainForm.ScanInitTable(vmtAdr);
    end;
  end;
  StopProgress;
end;

Procedure TAnalyzeThread.ScanConsts;
var
  ModID:Word;
  n, m, u, Bytes, adr,ResStrIdx, ResStrNum, ResStrNo:Integer;
	resid:Cardinal;
  recU:PUnitRec;
  recN:InfoRec;
  rsInfo:MResStrInfo;
  uname:AnsiString;
  Inst:HINST;
  Counters:Array of Integer;
  buf:Array[0..1024] of Char;
Begin
  if Terminated or (HInstanceVarAdr = -1) then Exit;
  Inst := LoadLibraryEx(PAnsiChar(mainForm.SourceFile), 0, LOAD_LIBRARY_AS_DATAFILE); //DONT_RESOLVE_DLL_REFERENCES);
  if Inst=0 then Exit;

  //Array of counters for units frequences
  SetLength(Counters,KBase.ModuleCount);
  StartProgress(UnitsNum, 'Scan Resource Strings');
  For m:=0 to UnitsNum-1 do
  Begin
    if Terminated then Break;
    UpdateProgress;
    recU := Units[m];
    if recU=Nil then continue;
    ModID := $FFFF;
    //If module from KB load information about ResStrings
    if recU.names.Count<>0 then
    Begin
      for u:=0 to recU.names.Count-1 do
      Begin
        if Terminated then Break;
        UpdateAddrInStatusBar(u);
        ModID := KBase.GetModuleID(PAnsiChar(recU.names[u]));
        //Если из базы знаний, вытащим из нее информацию о ResStr
        if ModID <> $FFFF then
        Begin
          n:=Adr2Pos(recU.fromAdr);
          while (n < Adr2Pos(recU.toAdr)) and not Terminated do
          Begin
            adr := PInteger(Code + n)^;
            resid := PInteger(Code + n + 4)^;
            if IsValidImageAdr(adr) and (adr = HInstanceVarAdr) and (resid < $10000) then
            Begin
              recN := GetInfoRec(Pos2Adr(n));
              //If export at this position, delete InfoRec and create new (ikResString)
              if IsFlagSet(cfExport, n) then
              Begin
                ClearFlag(cfProcStart, n);
                FreeAndNil(recN);
              End;
              if recN=Nil then recN := InfoRec.Create(n, ikResString)
              else
              Begin
                if recN.kind = ikResString then
                Begin
                  Inc(n,4);
                  continue;
                end;
                //may be ikData
                //if recN.rsInfo=Nil then recN.rsInfo := InfoResStringInfo.Create;
              End;
              recN._type := 'TResStringRec';
              //Set Flags
              SetFlags(cfData, n, 8);
              //Get Context
              Bytes := LoadString(Inst, resid, buf, 1024);
              recN.rsInfo := MakeString(buf, Bytes);
              ResStrIdx := KBase.GetResStrIdx(ModID, buf);
              if ResStrIdx <> -1 then
              Begin
                ResStrIdx := KBase.ResStrOffsets[ResStrIdx].NamId;
                if KBase.GetResStrInfo(ResStrIdx, 0, rsInfo) then
                begin
                  if not recN.HasName then
                  Begin
                    UpdateStatusBar(rsInfo.ResStrName);
                    recN.Name:=rsInfo.ResStrName;
                  End;
                end;
              End
              else if not recN.HasName then
              Begin
                recN.ConcatName('SResString' + IntToStr(LastResStrNo));
                Inc(LastResStrNo);
              End;
            End;
            Inc(n,4);
          End;
        End
        //Else extract ResStrings from analyzed file
        else
        Begin
          n := Adr2Pos(recU.fromAdr);
          while (n < Adr2Pos(recU.toAdr)) and not Terminated do
          Begin
            adr := PInteger(Code + n)^;
            resid := PInteger(Code + n + 4)^;
            if IsValidImageAdr(adr) and (adr = HInstanceVarAdr) and (resid < $10000) then
            Begin
              recN := GetInfoRec(Pos2Adr(n));
              //If export at this position, delete InfoRec and create new (ikResString)
              if IsFlagSet(cfExport, n) then
              Begin
                ClearFlag(cfProcStart, n);
                FreeAndNil(recN);
              End;
              if recN=Nil then recN := InfoRec.Create(n, ikResString)
              else
              Begin
                if recN.kind = ikResString then
                Begin
                  Inc(n,4);
                  continue;
                end;
                //may be ikData
                //if recN.rsInfo=Nil then recN.rsInfo := InfoResStringInfo.Create;
              End;
              recN._type := 'TResStringRec';
              //Set Flags
              SetFlags(cfData, n, 8);
              //Get Context
              Bytes := LoadString(Inst, resid, buf, 1024);
              recN.rsInfo := MakeString(buf, Bytes);
              if not recN.HasName then
              Begin
                recN.ConcatName('SResString' + IntToStr(LastResStrNo));
                Inc(LastResStrNo);
              End;
            End;
            Inc(n,4);
          End;
        End;
      End;
    End
    //If unit has no names - check whether it is module of ResStrings
    else
    Begin
      UpdateProgress;
      FillMemory(@Counters[0], KBase.ModuleCount*SizeOf(Integer),0);
      ResStrNum := 0;
      n := Adr2Pos(recU.fromAdr);
      while (n < Adr2Pos(recU.toAdr)) and not Terminated do
      Begin
        adr := PInteger(Code + n)^;
        resid := PInteger(Code + n + 4)^;
        if IsValidImageAdr(adr) and (adr = HInstanceVarAdr) and (resid < $10000) then
        Begin
          Bytes := LoadString(Inst, resid, buf, 1024);
          //Number of ReStrings in this module
          Inc(ResStrNum);
          ResStrNo := 0;
          while not Terminated do
          Begin
            ResStrIdx := KBase.GetResStrIdx(ResStrNo, buf);
            if ResStrIdx = -1 then break;
            ResStrNo := ResStrIdx + 1;
            ResStrIdx := KBase.ResStrOffsets[ResStrIdx].NamId;
            if KBase.GetResStrInfo(ResStrIdx, 0, rsInfo) then
              Inc(Counters[rsInfo.ModuleID]);
          End;
        End;
        Inc(n,4);
      End;
      //What module has frequency >= ResStrNum
      if ResStrNum<>0 then
      Begin
        for n:=0 to KBase.ModuleCount-1 do
        Begin
          if Terminated then Break;
          if Counters[n] >= 0.9 * ResStrNum then
          Begin
            ModID := n;
            break;
          End;
        End;
        //Module is found
        if ModID <> $FFFF then
        Begin
          uname := KBase.GetModuleName(ModID);
          FMain.SetUnitName(recU, uname);
          recU.kb := true;
          n := Adr2Pos(recU.fromAdr);
          while (n < Adr2Pos(recU.toAdr)) and not Terminated do
          Begin
            adr := PInteger(Code + n)^;
            resid := PInteger(Code + n + 4)^;
            if IsValidImageAdr(adr) and (adr = HInstanceVarAdr) and (resid < $10000) then
            Begin
              recN := GetInfoRec(Pos2Adr(n));
              //If export at this position, delete InfoRec and create new (ikResString)
              if IsFlagSet(cfExport, n) then
              Begin
                ClearFlag(cfProcStart, n);
                FreeAndNil(recN);
              End;
              if recN=Nil then recN := InfoRec.Create(n, ikResString)
              else
              Begin
                if recN.kind = ikResString then
                Begin
                  Inc(n,4);
                  continue;
                end;
                //may be ikData
              	//if recN.rsInfo=Nil then recN.rsInfo := InfoResStringInfo.Create;
              End;
              recN._type := 'TResStringRec';
              //Set Flags
              SetFlags(cfData, n, 8);
              //Get Context
              Bytes := LoadString(Inst, resid, buf, 1024);
              recN.rsInfo := MakeString(buf, Bytes);
              ResStrIdx := KBase.GetResStrIdx(ModID, buf);
              if ResStrIdx <> -1 then
              Begin
                ResStrIdx := KBase.ResStrOffsets[ResStrIdx].NamId;
                if KBase.GetResStrInfo(ResStrIdx, 0, rsInfo) then
                begin
                  if not recN.HasName then
                  Begin
                    UpdateStatusBar(rsInfo.ResStrName);
                    recN.Name:=rsInfo.ResStrName;
                  End;
                End;
              End
              else if not recN.HasName then
              Begin
                recN.ConcatName('SResString' + IntToStr(LastResStrNo));
                Inc(LastResStrNo);
              End;
            End;
            Inc(n,4);
          End;
        End
        //Module not found, get ResStrings from analyzed file
        else
        Begin
          n := Adr2Pos(recU.fromAdr);
          while (n < Adr2Pos(recU.toAdr)) and not Terminated do
          Begin
            adr := PInteger(Code + n)^;
            resid := PInteger(Code + n + 4)^;
            if IsValidImageAdr(adr) and (adr = HInstanceVarAdr) and (resid < $10000) then
            Begin
              recN := GetInfoRec(Pos2Adr(n));
              //If export at this position, delete InfoRec and create new (ikResString)
              if IsFlagSet(cfExport, n) then
              Begin
                ClearFlag(cfProcStart, n);
                FreeAndNil(recN);
              End;
              if recN=Nil then recN := InfoRec.Create(n, ikResString)
              else
              Begin
                if recN.kind = ikResString then
                Begin
                  Inc(n,4);
                  continue;
                end;
                //may be ikData
                //if recN.rsInfo=Nil then recN.rsInfo := InfoResStringInfo.Create;
              End;
              recN._type := 'TResStringRec';
              //Set Flags
              SetFlags(cfData, n, 8);
              //Get Context
              Bytes := LoadString(Inst, resid, buf, 1024);
              recN.rsInfo := MakeString(buf, Bytes);
              if not recN.HasName then
              Begin
                recN.ConcatName('SResString' + IntToStr(LastResStrNo));
                Inc(LastResStrNo);
              End;
            End;
            Inc(n,4);
          End;
        End;
      End;
    End;
  End;
  FreeLibrary(Inst);
  StopProgress;
  Counters:=Nil;
end;

Procedure TAnalyzeThread.ScanGetSetStoredProcs;
var
  len:Byte;
  propCnt:Word;
  i,m,n,classVMT,propType,getProc,setProc,storedProc,fieldOfs,posn:Integer;
  fieldType,fieldName:AnsiString;
  recN:InfoRec;
  recT:PTypeRec;
Begin
  for m:=0 To OwnTypeList.Count-1 do
  begin
    if Terminated Then Break;
    recT := OwnTypeList[m];
    if recT.kind = ikClass then
    begin
      n := Adr2Pos(recT.adr);
      //SelfPtr
      Inc(n, 4);
      //typeKind
      Inc(n);
      len := Byte(Code[n]);
      Inc(n);
      //clsName
      Inc(n, len);
      classVMT := PInteger(Code + n)^;
      Inc(n,4);
      recN := GetInfoRec(classVMT + VmtSelfPtr);
      //parentAdr := PInteger(Code + n)^;
      Inc(n, 4);
      propCnt := PWord(Code + n)^;
      Inc(n, 2);
      //Skip unit name
      len := Byte(Code[n]);
      Inc(n);
      Inc(n,len);
      //Real properties count
      propCnt := PWord(Code + n)^;
      Inc(n, 2);
      for i:=0 to propCnt-1 do
      begin
        if Terminated then Break;
        propType := PInteger(Code + n)^;
        Inc(n, 4);
        posn := Adr2Pos(propType);
        Inc(posn, 4);
        Inc(posn); //property type
        len := Byte(Code[posn]);
        Inc(posn);
        fieldType := MakeString(Code + posn, len);
        getProc := PInteger(Code + n)^;
        Inc(n, 4);
        setProc := PInteger(Code + n)^;
        Inc(n, 4);
        storedProc := PInteger(Code + n)^;
        Inc(n, 4);
        //idx
        Inc(n, 4);
        //defval
        Inc(n, 4);
        //nameIdx
        Inc(n, 2);
        len := Byte(Code[n]);
        Inc(n);
        fieldName := MakeString(Code + n, len);
        Inc(n, len);
        fieldOfs := -1;
        if (getProc and $FFFFFF00)<>0 then
        begin
          if (getProc and $FF000000) = $FF000000 then fieldOfs := getProc and $00FFFFFF;
        end;
        if (setProc and $FFFFFF00)<>0 then
        begin
          if (setProc and $FF000000) = $FF000000 then fieldOfs := setProc and $00FFFFFF;
        end;
        if (storedProc and $FFFFFF00)<>0 then
        begin
          if (storedProc and $FF000000) = $FF000000 then fieldOfs := storedProc and $00FFFFFF;
        end;
        if Assigned(recN) and (fieldOfs <> -1) then
          recN.vmtInfo.AddField(0, 0, FIELD_PUBLIC, fieldOfs, -1, fieldName, fieldType);
      end;
    end;
  end;
end;

//LString
//RefCnt     Length     Data
//0          4          8
//                      recN (kind = ikLString, name = context)
//UString
//CodePage  Word    RefCnt  Length  Data
//0         2       4       8       12
//                                  recN (kind = ikUString, name = context)
Procedure TAnalyzeThread.FindStrings;
var
  i, len:Integer;
  codePage, elemSize:Word;
  refCnt,stepMask:Integer;
  recN:InfoRec;
Begin
  if DelphiVersion >= 2009 then
  begin
    stepMask := StartProgress(CodeSize, 'Scan UStrings');
    //Scan UStrings
    i:=0;
    while (i < CodeSize) and not Terminated do
    begin
      if (i and stepMask) = 0 then UpdateProgress;
      if IsFlagSet(cfData, i) then
      begin
        Inc(i,4);
        continue;
      end;
      codePage := PWord(Code + i)^;
      elemSize := PWord(Code + i + 2)^;
      if (elemSize=0) or (elemSize > 4) then
      begin
        Inc(i,4);
        continue;
      end;
      refCnt := PInteger(Code + i + 4)^;
      if refCnt <> -1 then
      begin
        Inc(i,4);
        continue;
      end;
      len := lstrlenW(PWideChar(Code + i + 12));
      //len = *((int*)(Code + i + 8));
      if (len <= 0) or (len > 10000) then
      begin
        Inc(i,4);
        continue;
      end;
      if i + 12 + (len + 1)*elemSize >= CodeSize then
      begin
        Inc(i,4);
        continue;
      end;
      if InfoList[i + 12]=Nil then
      begin
        UpdateAddrInStatusBar(Pos2Adr(i));
        recN := InfoRec.Create(i + 12, ikUString);
        if elemSize = 1 then
          recN.Name:=TransformString(Code + i + 12, len)
        else
          recN.Name:=TransformUString(codePage, PWideChar(Code + i + 12), len);
      end;
      //Align to 4 bytes
      len := (12 + (len + 1)*elemSize + 3) and -4;
      SetFlags(cfData, i, len);
      Inc(i,4);
    end;
    StopProgress;
  end;
  stepMask := StartProgress(CodeSize, 'Scan LStrings');
  //Scan LStrings
  i:=0;
  while (i < CodeSize) and not Terminated do
  begin
    if (i and stepMask) = 0 then UpdateProgress;
    if IsFlagSet(cfData, i) then
    begin
      Inc(i,4);
      continue;
    end;
    refCnt := PInteger(Code + i)^;
    if refCnt <> -1 then
    begin
      Inc(i,4);
      continue;
    end;
    len := PInteger(Code + i + 4)^;
    if (len <= 0) or (len > 10000) or (i + 8 + len + 1 >= CodeSize)
      //Check last 0
      or (Code[ + i + 8 + len] <> #0) then
    begin
      Inc(i,4);
      continue;
    end;
    //Check flags
    //!!!
    if InfoList[i + 8]=Nil then
    begin
      UpdateAddrInStatusBar(Pos2Adr(i));
      recN := InfoRec.Create(i + 8, ikLString);
      recN.Name:=TransformString(Code + i + 8, len);
    end;
    //Align to 4 bytes
    len := (8 + len + 1 + 3) and -4;
    SetFlags(cfData, i, len);
    Inc(i,4);
  end;
  StopProgress;
end;

Procedure TAnalyzeThread.AnalyzeCode1;
const
  msg = 'Analyzing step 1...';
var
  n,adr,stepMask,vmtAdr:Integer;
  recU:PUnitRec;
  recN:InfoRec;
  Term:Boolean;
Begin
  StartProgress(UnitsNum, msg);
  //Initialization and Finalization procedures
  n:=0;
  while (n < UnitsNum) and not Terminated do
  begin
    UpdateProgress;
    recU := Units[n];
    if Assigned(recU) then
    begin
      adr := recU.iniadr;
      if adr<>0 then
      begin
        UpdateStatusBar(adr);
        mainForm.AnalyzeProc(1, adr);
      end;
      adr := recU.finadr;
      if adr<>0 then
      begin
        UpdateStatusBar(adr);
        mainForm.AnalyzeProc(1, adr);
      end;
    end;
    Inc(n);
  end;
  StopProgress;
  stepMask := StartProgress(TotalSize, msg);
  //EP
  mainForm.AnalyzeProc(1, EP);
  //Classes (methods, dynamics procedures, virtual methods)
  n:=0;
  Term:=False;
  while (n < TotalSize) and not Terminated do
  begin
    if (n and stepMask) = 0 then UpdateProgress;
    recN := GetInfoRec(Pos2Adr(n));
    if Assigned(recN) and (recN.kind = ikVMT) then
    begin
      vmtAdr := Pos2Adr(n);
      UpdateAddrInStatusBar(vmtAdr);
      mainForm.AnalyzeMethodTable(1, vmtAdr, Term);
      if Term then
      Begin
        Terminate;
        break;
      end;
      mainForm.AnalyzeDynamicTable(1, vmtAdr, Term);
      if Term then
      Begin
        Terminate;
        break;
      end;
      mainForm.AnalyzeVirtualTable(1, vmtAdr, Term);
      if Term Then
      begin
        Terminate;
        Break;
      end;
    end;
    Inc(n);
  end;
  StopProgress;
  //All procs
  stepMask := StartProgress(CodeSize, msg);
  n:=0;
  while (n < CodeSize) and not Terminated do
  begin
    if (n and stepMask) = 0 then UpdateProgress;
    if IsFlagSet(cfProcStart, n) then
    begin
      adr := Pos2Adr(n);
      UpdateAddrInStatusBar(adr);
      mainForm.AnalyzeProc(1, adr);
    End;
    Inc(n);
  end;
  StopProgress;
end;

Procedure TAnalyzeThread.AnalyzeCode2 (args:Boolean);
var
  stepMask,n,adr:Integer;
Begin
  stepMask := StartProgress(CodeSize, 'Analyzing step 2...');
  //EP
  mainForm.AnalyzeProc(2, EP);
  for n:=0 to CodeSize-1 do
  begin
    if Terminated then Break;
    if (n and stepMask) = 0 then
    UpdateProgress;
    if IsFlagSet(cfProcStart, n) then
    begin
      adr := Pos2Adr(n);
      UpdateAddrInStatusBar(adr);
      if args then mainForm.AnalyzeArguments(adr);
      mainForm.AnalyzeProc(2, adr);
    end;
  end;
  StopProgress;
end;

Procedure TAnalyzeThread.PropagateClassProps;
var
  typeKind:LKind;
  len:Byte;
  propCnt:Word;
  i,n,_pos,posn,propType,vmtofs, fieldOfs:Integer;
  recN,recN1:InfoRec;
  stepMask,classVMT,getProc,setProc,storedProc:Integer;
  clsName,typeName,_name:AnsiString;
Begin
  stepMask := StartProgress(CodeSize, 'Propagating Class Properties...');
  n:=0;
  while (n < CodeSize) and not Terminated do
  Begin
    if (n and stepMask) = 0 then UpdateProgress;
    recN := GetInfoRec(Pos2Adr(n));
  	if Assigned(recN) and recN.HasName then
    Begin
      typeKind := recN.kind;
      if typeKind > ikProcedure then
      begin
        Inc(n,4);
        continue;
      end;
      //Пройдемся по свойствам класса и поименуем процедуры
      if typeKind = ikClass then
      Begin
        _pos := n;
        //SelfPointer
        Inc(_pos, 4);
        //TypeKind
        Inc(_pos);
        len := Byte(Code[_pos]);
        Inc(_pos);
        clsName := MakeString(Code + _pos, len); 
        Inc(_pos, len);
        classVMT := PInteger(Code + _pos)^; 
        Inc(_pos, 4);
        Inc(_pos, 4);   //ParentAdr
        Inc(_pos, 2);   //PropCount
        //UnitName
        len := Byte(Code[_pos]); 
        Inc(_pos);
        Inc(_pos, len);
        propCnt := PWord(Code + _pos)^; 
        Inc(_pos, 2);
        i:=0;
        while (i < propCnt) and not Terminated do
        Begin
          propType := PInteger(Code + _pos)^; 
          Inc(_pos, 4);
          posn := Adr2Pos(propType); 
          Inc(posn, 4);
          Inc(posn); //property type
          len := Byte(Code[posn]); 
          Inc(posn);
          typeName := MakeString(Code + posn, len);
          getProc := PInteger(Code + _pos)^; 
          Inc(_pos, 4);
          setProc := PInteger(Code + _pos)^; 
          Inc(_pos, 4);
          storedProc := PInteger(Code + _pos)^; 
          Inc(_pos, 4);
          Inc(_pos, 4);   //Idx
          Inc(_pos, 4);   //DefVal
          Inc(_pos, 2);   //NameIdx
          len := Byte(Code[_pos]); 
          Inc(_pos);
          _name := MakeString(Code + _pos, len); 
          Inc(_pos, len);
          if (getProc and $FFFFFF00)<>0 then
          Begin
            if (getProc and $FF000000) = $FF000000 then
            Begin
              fieldOfs := getProc and $00FFFFFF;
              recN1 := GetInfoRec(classVMT + VmtSelfPtr);
              recN1.vmtInfo.AddField(0, 0, FIELD_PUBLIC, fieldOfs, -1, _name, typeName);
            End
            else if (getProc and $FF000000) = $FE000000 then
            Begin
              if (getProc and $00008000)<>0 then
                vmtofs := -(getProc and $0000FFFF)
              else
                vmtofs := getProc and $0000FFFF;
              posn := Adr2Pos(classVMT) + vmtofs;
              getProc := PInteger(Code + posn)^;
              recN1 := GetInfoRec(getProc);
              if recN1=Nil then recN1 := InfoRec.Create(Adr2Pos(getProc), ikFunc)
              else if recN1.procInfo=Nil then recN1.procInfo := InfoProcInfo.Create;
              recN1.kind := ikFunc;
              recN1._type := typeName;
              if not recN1.HasName then recN1.Name:=clsName + '.Get' + _name;
              recN1.procInfo.flags := recN1.procInfo.flags or PF_METHOD;
              recN1.procInfo.AddArg($21, 0, 4, 'Self', clsName);
              mainForm.AnalyzeProc1(getProc, #0, 0, 0, false);
            End
            else
            Begin
              recN1 := GetInfoRec(getProc);
              if recN1=Nil then recN1 := InfoRec.Create(Adr2Pos(getProc), ikFunc)
              else if recN1.procInfo=Nil then recN1.procInfo := InfoProcInfo.Create;
              recN1.kind := ikFunc;
              if not recN1.HasName then recN1.Name:=clsName + '.Get' + _name;
              recN1.procInfo.flags := recN1.procInfo.flags or PF_METHOD;
              recN1.procInfo.AddArg($21, 0, 4, 'Self', clsName);
              mainForm.AnalyzeProc1(getProc, #0, 0, 0, false);
            End;
          End;
          if (setProc and $FFFFFF00)<>0 then
          Begin
            if (setProc and $FF000000) = $FF000000 then
            Begin
              fieldOfs := setProc and $00FFFFFF;
              recN1 := GetInfoRec(classVMT + VmtSelfPtr);
              recN1.vmtInfo.AddField(0, 0, FIELD_PUBLIC, fieldOfs, -1, _name, typeName);
            End
            else if (setProc and $FF000000) = $FE000000 then
            Begin
              if (setProc and $00008000)<>0 then
                vmtofs := -(setProc and $0000FFFF)
              else
                vmtofs := setProc and $0000FFFF;
              posn := Adr2Pos(classVMT) + vmtofs;
              setProc := PInteger(Code + posn)^;
              recN1 := GetInfoRec(setProc);
              if recN1=Nil then recN1 := InfoRec.Create(Adr2Pos(setProc), ikProc)
              else if recN1.procInfo=Nil then recN1.procInfo := InfoProcInfo.Create;
              recN1.kind := ikProc;
              if not recN1.HasName then recN1.Name:=clsName + '.Set' + _name;
              recN1.procInfo.flags := recN1.procInfo.flags or PF_METHOD;
              recN1.procInfo.AddArg($21, 0, 4, 'Self', clsName);
              recN1.procInfo.AddArg($21, 1, 4, 'Value', typeName);
              mainForm.AnalyzeProc1(setProc, #0, 0, 0, false);
            End
            else
            Begin
              recN1 := GetInfoRec(setProc);
              if recN1=Nil then recN1 := InfoRec.Create(Adr2Pos(setProc), ikProc)
              else if recN1.procInfo=Nil then recN1.procInfo := InfoProcInfo.Create;
              recN1.kind := ikProc;
              if not recN1.HasName then recN1.Name:=clsName + '.Set' + _name;
              recN1.procInfo.flags := recN1.procInfo.flags or PF_METHOD;
              recN1.procInfo.AddArg($21, 0, 4, 'Self', clsName);
              recN1.procInfo.AddArg($21, 1, 4, 'Value', typeName);
              mainForm.AnalyzeProc1(setProc, #0, 0, 0, false);
            End;
          End;
          if (storedProc and $FFFFFF00)<>0 then
          Begin
            if (storedProc and $FF000000) = $FF000000 then
            Begin
              fieldOfs := storedProc and $00FFFFFF;
              recN1 := GetInfoRec(classVMT + VmtSelfPtr);
              recN1.vmtInfo.AddField(0, 0, FIELD_PUBLIC, fieldOfs, -1, _name, typeName);
            End
            else if (storedProc and $FF000000) = $FE000000 then
            Begin
              if (storedProc and $00008000)<>0 then
                vmtofs := -(storedProc and $0000FFFF)
              else
                vmtofs := storedProc and $0000FFFF;
              posn := Adr2Pos(classVMT) + vmtofs;
              storedProc := PInteger(Code + posn)^;
              recN1 := GetInfoRec(storedProc);
              if recN1=Nil then recN1 := InfoRec.Create(Adr2Pos(storedProc), ikFunc)
              else if recN1.procInfo=Nil then recN1.procInfo := InfoProcInfo.Create;
              recN1.kind := ikFunc;
              recN1._type := 'Boolean';
              if not recN1.HasName then recN1.Name:=clsName + '.IsStored' + _name;
              recN1.procInfo.flags := recN1.procInfo.flags or PF_METHOD;
              recN1.procInfo.AddArg($21, 0, 4, 'Self', clsName);
              recN1.procInfo.AddArg($21, 1, 4, 'Value', typeName);
              mainForm.AnalyzeProc1(storedProc, #0, 0, 0, false);
            End
            else
            Begin
              recN1 := GetInfoRec(storedProc);
              if recN1=Nil then recN1 := InfoRec.Create(Adr2Pos(storedProc), ikFunc)
              else if recN1.procInfo=Nil then recN1.procInfo := InfoProcInfo.Create;
              recN1.kind := ikFunc;
              recN1._type := 'Boolean';
              if not recN1.HasName then recN1.Name:=clsName + '.IsStored' + _name;
              recN1.procInfo.flags := recN1.procInfo.flags or PF_METHOD;
              recN1.procInfo.AddArg($21, 0, 4, 'Self', clsName);
              recN1.procInfo.AddArg($21, 1, 4, 'Value', typeName);
              mainForm.AnalyzeProc1(storedProc, #0, 0, 0, false);
            End;
          End;
          Inc(i);
        End;
      End;
    End;
    Inc(n,4);
  End;
  StopProgress;
end;

Procedure TAnalyzeThread.FillClassViewer;
var
  recV:PVmtListRec;
  cntVmt,stepMask,n:Integer;
  tmpList:TStringList;
  Term:Boolean;
Begin
  mainForm.tvClassesFull.Items.Clear;
  cntVmt := VmtList.Count;
  if cntVmt=0 then Exit;
  stepMask := StartProgress(cntVmt, 'Building ClassViewer Tree...');
  tmpList := TStringList.Create;
  try
    tmpList.Sorted := false;
    mainForm.tvClassesFull.Items.BeginUpdate;
    try
      n:=0;
      Term:=False;
      while (n < cntVmt) and not Terminated do
      begin
        if (n and stepMask) = 0 then UpdateProgress;
        recV := VmtList[n];
        UpdateStatusBar(GetClsName(recV.vmtAdr));
        mainForm.FillClassViewerOne(n, tmpList, Term);
        if Term then Terminate;
        Inc(n);
      end;
    finally
      mainForm.tvClassesFull.Items.EndUpdate;
    end;
    ProjectModified := true;
    ClassTreeDone := true;
  finally
    tmpList.Free;
  end;
  StopProgress;
end;

Procedure TAnalyzeThread.AnalyzeDC;
var
  n, m, k, dotpos, _pos, stepMask, cntVmt:Integer;
  vmtAdr, adr, procAdr, stopAt, classAdr:Integer;
  clasName, _name:AnsiString;
  recV:PVmtListRec;
  recN, recN1, recN2:InfoRec;
  aInfo:PArgInfo;
  recM, recM1:PMethodRec;
  recX:PXrefRec;
Begin
  //Создаем временный список пар (высота, адрес VMT)
  cntVmt := VmtList.Count;
  if cntVmt=0 then Exit;
  stepMask := StartProgress(cntVmt, 'Analyzing Constructors and Destructors, step 1...');
  for n:=0 to cntVmt-1 do
  Begin
    if Terminated then Break;
    if (n and stepMask) = 0 then UpdateProgress;
    recV := VmtList[n];
    vmtAdr := recV.vmtAdr;
    clasName := GetClsName(vmtAdr);
    UpdateStatusBar(clasName);

    //Destructor
    _pos := Adr2Pos(vmtAdr) - VmtSelfPtr + VmtDestroy;
    adr := PInteger(Code + _pos)^;
    if IsValidImageAdr(adr) then
    Begin
      recN := GetInfoRec(adr);
      if Assigned(recN) and not recN.HasName then
      Begin
        recN.kind := ikDestructor;
        recN.Name:=clasName + '.Destroy';
      End;
    End;
    //Constructor
    recN := GetInfoRec(vmtAdr);
    if Assigned(recN) and Assigned(recN.xrefs) then
    Begin
      for m := 0 to recN.xrefs.Count-1 do
      Begin
        recX := recN.xrefs[m];
        adr := recX.adr + recX.offset;
        recN1 := GetInfoRec(adr);
        if Assigned(recN1) and not recN1.HasName then
          if IsFlagSet(cfProcStart, Adr2Pos(adr)) then
          Begin
            recN1.kind := ikConstructor;
            recN1.Name:=clasName + '.Create';
          End;
      End;
    End;
  End;
  StopProgress;
  stepMask := StartProgress(cntVmt, 'Analyzing Constructors, step 2...');
  for n:=0 to cntVmt-1 do
  Begin
    if Terminated then Break;
    if (n and stepMask) = 0 then UpdateProgress;
    recV := VmtList[n];
    vmtAdr := recV.vmtAdr;
    stopAt := GetStopAt(vmtAdr - VmtSelfPtr);
    if vmtAdr = stopAt then continue;
    clasName := GetClsName(vmtAdr);
    UpdateStatusBar(clasName);
    _pos := Adr2Pos(vmtAdr) - VmtSelfPtr + VmtParent + 4;
    m := VmtParent + 4;
    while true do
    Begin
      if Pos2Adr(_pos) = stopAt then break;
      procAdr := PInteger(Code + _pos)^;
      if m >= 0 then
      Begin
        recN := GetInfoRec(procAdr);
        if Assigned(recN) and (recN.kind = ikConstructor) and not recN.HasName then
        Begin
          classAdr := vmtAdr;
          while classAdr<>0 do
          Begin
            recM := mainForm.GetMethodInfo(classAdr, 'V', m);
            if Assigned(recM) then
            Begin
              _name := recM.name;
              if _name <> '' then
              Begin
                dotpos := Pos('.',_name);
                if dotpos<>0 then
                  recN.Name:=clasName + Copy(_name,dotpos, Length(_name))
                else
                  recN.Name:=_name;
                break;
              End;
            End;
            classAdr := GetParentAdr(classAdr);
          End;
        End;
      End;
      Inc(m,4);
      Inc(_pos,4);
    End;
  End;
  StopProgress;
  stepMask := StartProgress(cntVmt, 'Analyzing Dynamic Methods...');
  for n:=0 to cntVmt-1 do
  Begin
    if Terminated then Break;
    if (n and stepMask) = 0 then UpdateProgress;
    recV := VmtList[n];
    vmtAdr := recV.vmtAdr;
    clasName := GetClsName(vmtAdr);
    UpdateStatusBar(clasName);
    recN := GetInfoRec(vmtAdr);
    if Assigned(recN) and Assigned(recN.vmtInfo.methods) then
    Begin
      for m := 0 to recN.vmtInfo.methods.Count-1 do
      Begin
        recM := recN.vmtInfo.methods[m];
        if recM.kind = 'D' then
        Begin
          recN1 := GetInfoRec(recM.address);
          if Assigned(recN1) then
          Begin
            classAdr := GetParentAdr(vmtAdr);
            while classAdr<>0 do
            Begin
              recM1 := mainForm.GetMethodInfo(classAdr, 'D', recM.id);
              if Assigned(recM1) then
              Begin
                recN2 := GetInfoRec(recM1.address);
                if Assigned(recN2) and Assigned(recN2.procInfo.args) then
                  for k := 0 to recN2.procInfo.args.Count-1 do
                    if k=0 then recN1.procInfo.AddArg($21, 0, 4, 'Self', clasName)
                    else
                    Begin
                      aInfo := PArgInfo(recN2.procInfo.args[k]);
                      recN1.procInfo.AddArg(aInfo);
                    End;
              End;
              classAdr := GetParentAdr(classAdr);
            End;
          End;
        End;
      End;
    End;
  End;
  StopProgress;
end;

Procedure TAnalyzeThread.ClearPassFlags;
Begin
  if not Terminated then mainForm.ClearPassFlags;
end;

End.
