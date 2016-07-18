Unit Decompiler;

Interface

Uses Windows, Classes, KnowledgeBase, DisAsm, Infos, Def_decomp, Def_disasm,Def_info,
  Def_know,Def_main,Types;

Type
  TForInfo = class
  public
    NoVar:Boolean;
    Down:Boolean;       //downto (=true)
    StopAdr:Integer;    //instructions are ignored from this address and to end of cycle
    From:AnsiString;
    _To:AnsiString;
    VarInfo:IdxInfo;
    CntInfo:IdxInfo;
    Constructor Create(ANoVar, ADown:Boolean; AStopAdr:Integer; AFrom, ATo:AnsiString; AVarType:Byte; AVarIdx:Integer; ACntType:Byte; ACntIdx:Integer);
  end;

  TWhileInfo = class
  public
    NoCondition:Boolean;    //No condition
    Constructor Create(ANoCond:Boolean);
  End;

  TLoopInfo = class
  public
    Kind:Char;       //'F'- for; 'W' - while; 'T' - while true; 'R' - repeat
    ContAdr:Integer;    //Continue address
    BreakAdr:Integer;   //Break address
    LastAdr:Integer;    //Last address for decompilation (skip some last instructions)
    forInfo:TForInfo;
    whileInfo:TWhileInfo;
    constructor Create(AKind:Char; AContAdr, ABreakAdr, ALastAdr:Integer);
  end;

  TNamer = class
  public
    MaxIdx:Integer;
    Names:TStringList;
    Constructor Create;
    Destructor Destroy; Override;
    Function MakeName(template:AnsiString):AnsiString;
  end;

  TDecompiler=class;

  TDecompileEnv = class
  public
    ProcName:AnsiString;       //Name of decompiled procedure
    StartAdr:Integer;       //Start of decompilation area
    Size:Integer;           //Size of decompilation area
    Indent:Integer;         //For output source code
    Alarm:Boolean;
    BpBased:Boolean;
    LocBase:Integer;
    StackSize:Integer;
    Stack:PItemArr;
    ErrAdr:Integer;
    LastResString:AnsiString;
    Body:TStringList;
    RegInfo:Regs;  // Normal registers context
    FStack:Regs;      //Floating registers stack
    Namer:TNamer;
    BJLnum:Integer;
    BJLmaxbcnt:Integer;
    SavedContext:TList;
    BJLseq:TList;//TBJLInfo
    BJLlist:TList;//TBJL
    CmpStack:TList;
    Embedded:Boolean; // Is proc emebedded ?
    //EmbeddedList:TStringList;//List of embedded procedures addresses
    constructor Create(AStartAdr:Integer; ASize:Integer; recN:InfoRec);
    Destructor Destroy; Override;
    Function GetLvarName(Ofs:Integer):AnsiString;
    Procedure AddToBody(src:AnsiString); Overload;
    Procedure AddToBody(src:TStringList); Overload;
    Function IsExitAtBodyEnd:Boolean;

    Procedure OutputSourceCodeLine(line:AnsiString);
    Procedure OutputSourceCode;
    Procedure DecompileProc;
    //BJL
    Function GetBJLRange(fromAdr:Integer; var bodyBegAdr, bodyEndAdr, jmpAdr:Integer; loopInfo:TLoopInfo):Boolean;
    Procedure CreateBJLSequence(fromAdr, bodyBegAdr, bodyEndAdr:Integer);
    Procedure UpdateBJLList;
    procedure BJLAnalyze;
    function BJLGetIdx(idx:PIntegerArray; from, num:Integer): Boolean;
    Function BJLCheckPattern1(t:PAnsiChar; from:Integer):Boolean;
    Function BJLCheckPattern2(t:PAnsiChar; from:Integer):Boolean;
    Function BJLFindLabel(address:Integer; var no:Integer):Integer;
    procedure BJLSeqSetStateU(idx:PIntegerArray; num:Integer);
    Procedure BJLListSetUsed(from, num:Integer);
    Function ExprGetOperation(s:AnsiString):Char;
    Procedure ExprMerge(var dst:AnsiString; src:AnsiString; op:Char);//dst = dst op src, op = '|' or '&'
    Function PrintBJL:AnsiString;
    Function GetContext(Adr:Integer):PDContext;
    Procedure SaveContext(Adr:Integer);
    Procedure RestoreContext(Adr:Integer);
  end;

  TDecompiler = class
  public
    WasRet:Boolean;  //Was ret instruction
    CmpOp:Char;      //Compare operation
    CmpAdr:Integer;    //Compare dest address
    _ESP_:Integer;   //Stack pointer
    _TOP_:Integer;   //Top of FStack
    DisaInfo:TDisInfo;
    CompInfo:TCmpItem;
    Env:TDecompileEnv;
    DeFlags:TByteDynArray;
    Stack:PItem;
    Constructor Create(AEnv:TDecompileEnv);
    Destructor Destroy; Override;
    Function CheckPrototype(ARec:InfoRec):Boolean;
    Procedure ClearStop(Adr:Integer);
    function Decompile(fromAdr:Integer; flags:TDecomCset; loopInfo:TLoopInfo): Integer;
    function DecompileCaseEnum(fromAdr:Integer; Q:Integer; loopInfo:TLoopInfo): Integer;
    function DecompileGeneralCase(fromAdr, markAdr:Integer; loopInfo:TLoopInfo; Q:Integer): Integer;
    Function DecompileTry(fromAdr:Integer; flags:TDecomCset; loopInfo:TLoopInfo):Integer;
    Function FGet(idx:Integer):PItem;
    function FPop: PITEM;
    Procedure FPush(val:PITEM);
    Procedure FSet(idx:Integer; val:PITEM);
    Function GetArrayFieldOffset(ATypeName:AnsiString; AFromOfs, AScale:Integer):FieldInfo;
    Function GetCmpInfo(fromAdr:Integer):Integer;
    Function GetCycleFrom:AnsiString;
    Procedure GetCycleIdx(IdxInfo:PIdxInfo; ADisInfo:TDisInfo);
    Function GetCycleTo:AnsiString;
    procedure GetFloatItemFromStack(Esp:Integer; Dst:PITEM; FloatType:TFloatKind);
    Function GetStringArgument(item:PItem):AnsiString;
    Function GetLoopInfo(fromAdr:Integer):TLoopInfo;
    Procedure GetMemItem(CurAdr:Integer; Dst:PITEM; Op:Byte);
    procedure GetRegItem(Idx:Integer; var Dst:TITEM);
    Function GetRegType(Idx:Integer):AnsiString;
    Function GetSysCallAlias(AName:AnsiString):AnsiString;
    Function Init(fromAdr:Integer):Boolean;
    Procedure InitFlags;
    Procedure MarkCaseEnum(fromAdr:Integer);
    Procedure MarkGeneralCase(fromAdr:Integer);
    Function Pop:PItem;
    Procedure Push(item:PITEM);
    Procedure SetStackPointers(ASrc:TDecompiler);
    Procedure SetDeFlags(ASrc:Pointer);
    procedure SetRegItem(Idx:Integer; var val:TITEM);
    Procedure SetStop(Adr:Integer);
    function SimulateCall(curAdr, callAdr:Integer; instrLen:Integer; mtd:PMethodRec; AClassAdr:Integer): Boolean;
    Procedure SimulateFloatInstruction(curAdr:Integer; instrLen:Integer);
    Procedure SimulateFormatCall;
    Procedure SimulateInherited(procAdr:Integer);
    Procedure SimulateInstr1(curAdr:Integer; Op:Byte);
    Procedure SimulateInstr2(curAdr:Integer; Op:Byte);
    Procedure SimulateInstr2RegImm(curAdr:Integer; Op:Byte);
    Procedure SimulateInstr2RegMem(curAdr:Integer; Op:Byte);
    Procedure SimulateInstr2RegReg(curAdr:Integer; Op:Byte);
    Procedure SimulateInstr2MemImm(curAdr:Integer; Op:Byte);
    Procedure SimulateInstr2MemReg(curAdr:Integer; Op:Byte);
    Procedure SimulateInstr3(curAdr:Integer; Op:Byte);
    Procedure SimulatePop(curAdr:Integer);
    Procedure SimulatePush(curAdr:Integer);
    Function SimulateSysCall(name:AnsiString; procAdr:Integer; instrLen:Integer):Boolean;
    Function AnalyzeConditions(brType:Integer; curAdr, sAdr, jAdr:Integer; loopInfo:TLoopInfo):Integer;
  end;

Implementation

Uses SysUtils,Misc,Main,Heuristic,StrUtils,Forms,Scanf;

Function GetString(item:PITEM;precedence:Byte):AnsiString;
Begin
  Result:=item.Value;
  if Result = '' then
  begin
    if IF_INTVAL in item.Flags then
      Result:= GetImmString(item._Type, item.IntValue)
    Else if item.Name <> '' then Result := item.Name;
  end
  Else if (item.Precedence<>0) and (item.Precedence < precedence) then Result:='(' + Result + ')';
end;

Function GetFieldName(fInfo:FieldInfo):AnsiString;
Begin
  if fInfo.Name = '' then Result:='?f' + Val2Str(fInfo.Offset)
    Else Result:=fInfo.Name;
end;

Function GetArgName(aInfo:PArgInfo):AnsiString;
Begin
  if aInfo.Name = '' then Result:='arg_' + Val2Str(aInfo.Ndx)
    else Result:=aInfo.Name;
end;

Function GetGVarName(adr:Integer):AnsiString;
var
  recN:InfoRec;
Begin
  if not IsValidImageAdr(adr) then Result:='?'
  Else
  begin
    recN := GetInfoRec(adr);
    if Assigned(recN) and recN.HasName then Result:=recN.Name
      else Result:=MakeGvarName(adr);
  end;
end;

Function GetDirectCondition(c:Char):AnsiString;
Begin
  if c >= 'A' then Result:=DirectConditions[Ord(c) - Ord('A')]
    else Result:='?';
end;

Function GetInvertCondition(c:Char):AnsiString;
Begin
  if c >= 'A' then Result:=InvertConditions[Ord(c) - Ord('A')]
    else Result:='?';
end;

Procedure InitItem(item:PItem);
Begin
  with item^ Do
  Begin
    Flags:=[];
    Precedence:=PRECEDENCE_ATOM;
    Size:=0;
    Offset:=0;
    IntValue:=0;
    Value:='';
    Value1:='';
    _Type:='';
    Name:='';
  end;
end;

procedure AssignItem(var dstItem,srcItem:TItem);
Begin
  DstItem.Flags := SrcItem.Flags;
  DstItem.Precedence := SrcItem.Precedence;
  DstItem.Size := SrcItem.Size;
  DstItem.IntValue := SrcItem.IntValue;
  DstItem.Value := SrcItem.Value;
  DstItem.Value1 := SrcItem.Value1;
  DstItem._Type := SrcItem._Type;
  DstItem.Name := SrcItem.Name;
end;

Constructor TNamer.Create;
Begin
  MaxIdx:=-1;
  Names:=TStringList.Create;
  Names.Sorted:=True;
end;

Destructor TNamer.Destroy;
Begin
  Names.Free;
  Inherited;
end;

Function TNamer.MakeName (template:AnsiString):AnsiString;
Var
  n,idx:Integer;
Begin
  if template[1] = 'T' then
  begin
    idx := -1;
    Result := '_'+template+'_';
    for n := 0 to MaxIdx do
    begin
      Result:=Result+IntToStr(n);
      if Names.IndexOf(Result) <> -1 then idx := n;
    end;
    if idx = -1 then
    begin
      Names.Add(Result);
      if MaxIdx = -1 then MaxIdx := 0;
    end
    else
    begin
      Result:=Result+IntToStr(idx + 1);
      Names.Add(Result);
      if idx + 1 > MaxIdx then MaxIdx := idx + 1;
    end;
  End;
end;

Constructor TForInfo.Create (ANoVar, ADown:Boolean; AStopAdr:Integer; AFrom, ATo:AnsiString; AVarType:Byte; AVarIdx:Integer; ACntType:Byte; ACntIdx:Integer);
Begin
  NoVar := ANoVar;
  Down := ADown;
  StopAdr := AStopAdr;
  From := AFrom;
  _To := ATo;
  VarInfo.IdxType := AVarType;
  VarInfo.IdxValue := AVarIdx;
  CntInfo.IdxType := ACntType;
  CntInfo.IdxValue := ACntIdx;
end;

Constructor TWhileInfo.Create (ANoCond:Boolean);
Begin
  NoCondition:=ANoCond;
end;

Constructor TLoopInfo.Create (AKind:Char; AContAdr, ABreakAdr, ALastAdr:Integer);
Begin
  Kind := AKind;
  ContAdr := AContAdr;
  BreakAdr := ABreakAdr;
  LastAdr := ALastAdr;
  forInfo := Nil;
  whileInfo := Nil;
end;

constructor TDecompileEnv.Create(AStartAdr:Integer; ASize:Integer; recN:InfoRec);
Begin
  StartAdr := AStartAdr;
  Size := ASize;
  StackSize := recN.procInfo.stackSize;
  if StackSize=0 then StackSize := $8000;
  SetLength(Stack,StackSize);
  ErrAdr := 0;
  Body := TStringList.Create;
  Namer := TNamer.Create;
  SavedContext := TList.Create;
  BJLseq := TList.Create;
  bjllist := TList.Create;
  CmpStack := TList.Create;
  Embedded := PF_EMBED in recN.procInfo.flags;
  //EmbeddedList := TStringList.Create;
end;

Destructor TDecompileEnv.Destroy;
Begin
  Stack:=Nil;
  Body.Free;
  Namer.Free;
  SavedContext.Free;
  BJLseq.Free;
  BJLlist.Free;
  CmpStack.Free;
  //EmbeddedList.Free;
  Inherited;
end;

Function TDecompileEnv.GetLvarName (Ofs:Integer):AnsiString;
Begin
  Result:='lvar_' + Val2Str(LocBase - Ofs);
end;

Function TDecompileEnv.GetContext (Adr:Integer):PDContext;
var
  n:Integer;
Begin
  for n := 0 to SavedContext.Count-1 do
  begin
    Result := SavedContext[n];
    if Result.adr = Adr Then Exit;
  end;
  Result:=Nil;
end;

Procedure TDecompileEnv.SaveContext (Adr:Integer);
var
  n:Integer;
  ctx:PDContext;
Begin
  if GetContext(Adr)=Nil then
  begin
    New(ctx);
    ctx.adr := Adr;
    for n := 0 to High(RegInfo) do
    begin
      ctx.gregs[n] := RegInfo[n];
      ctx.fregs[n] := FStack[n];
    end;
    SavedContext.Add(ctx);
  end;
end;

Procedure TDecompileEnv.RestoreContext (Adr:Integer);
var
  n:Integer;
  ctx:PDContext;
Begin
  ctx := GetContext(Adr);
  if Assigned(ctx) then
    for n := 0 to High(RegInfo) do
    begin
      RegInfo[n] := ctx.gregs[n];
      FStack[n] := ctx.fregs[n];
    End;
end;

Constructor TDecompiler.Create (AEnv:TDecompileEnv);
Begin
  Env:=AEnv;
  SetLength(DeFlags,AEnv.Size + 1);
end;

Destructor TDecompiler.Destroy;
Begin
  Stack:=Nil;
  DeFlags:=Nil;
  Inherited;
end;

Procedure TDecompiler.SetDeFlags (ASrc:Pointer);
Begin
  MoveMemory(@DeFlags[0], ASrc, Env.Size + 1);
end;

Procedure TDecompiler.SetStop (Adr:Integer);
Begin
  DeFlags[Adr - Env.StartAdr] := 1;
end;

Procedure TDecompiler.InitFlags;
var
  n,_ap:Integer;
  recN:InfoRec;
Begin
  FillMemory(@DeFlags[0], Env.Size + 1,0);
  _ap := Adr2Pos(Env.StartAdr);
  for n := _ap to _ap + Env.Size do
  begin
    if IsFlagSet([cfLoc], n) then
    begin
      recN := GetInfoRec(Pos2Adr(n));
      if Assigned(recN) then recN.counter := 0;
    end;
    ClearFlag([cfPass], n);
  end;
end;

Procedure TDecompiler.ClearStop (Adr:Integer);
Begin
  DeFlags[Adr - Env.StartAdr] := 0;
end;

Procedure TDecompiler.SetStackPointers (ASrc:TDecompiler);
Begin
  _TOP_ := ASrc._TOP_;
  _ESP_ := ASrc._ESP_;
end;

Procedure TDecompiler.SetRegItem (Idx:Integer; var val:TITEM);
Var
  x:Integer;
Begin
  if Idx >= 16 then
  begin
    x := Idx - 16;
    Env.RegInfo[x].Size := 4;
  end
  else if Idx >= 8 then
  begin
    x := Idx - 8;
    Env.RegInfo[x].Size := 2;
  end
  else if Idx >= 4 then
  begin
    x := Idx - 4;
    Env.RegInfo[x].Size := 1;
  end
  else
  begin
    x := Idx;
    Env.RegInfo[x].Size := 1;
  end;
  with Env.RegInfo[x] do
  Begin
    Flags := Val.Flags;
    Precedence := Val.Precedence;
    Offset := Val.Offset;
    IntValue := Val.IntValue;
    Value := Val.Value;
    Value1 := Val.Value1;
    _Type := Val._Type;
    Name := Val.Name;
  End;
end;

Procedure TDecompiler.GetRegItem (Idx:Integer; var Dst:TITEM);
var
  x:Integer;
Begin
  assert((Idx >= 0) and (Idx < 24));
  if Idx >= 16 Then x := Idx - 16
  else if Idx >= 8 then x := Idx - 8
  else if Idx >= 4 then x := Idx - 4
  else x := Idx;
  With Env.RegInfo[x] do
  begin
    Dst.Flags := Flags;
    Dst.Precedence := Precedence;
    Dst.Size := Size;
    Dst.Offset := Offset;
    Dst.IntValue := IntValue;
    Dst.Value := Value;
    Dst.Value1 := Value1;
    Dst._Type := _Type;
    Dst.Name := Name;
  End;
end;

Function TDecompiler.GetRegType (Idx:Integer):AnsiString;
Begin
  if Idx >= 16 then Result:=Env.RegInfo[Idx - 16]._Type
  Else if Idx >= 8 then Result:=Env.RegInfo[Idx - 8]._Type
  Else if Idx >= 4 then Result:=Env.RegInfo[Idx - 4]._Type
  Else Result:=Env.RegInfo[Idx]._Type;
end;

Procedure TDecompiler.Push (item:PITEM);
Begin
  if _ESP_ < 4 then
  begin
    Env.ErrAdr := CurProcAdr;
    Raise Exception.Create('Attempt to PUSH on full Stack!');
  end;
  Dec(_ESP_, 4);
  With Env.Stack[_ESP_] do
  Begin
    Flags := Item.Flags;
    Precedence := Item.Precedence;
    Size := Item.Size;
    Offset := Item.Offset;
    IntValue := Item.IntValue;
    Value := Item.Value;
    _Type := Item._Type;
    Name := Item.Name;
  end;
end;

Function TDecompiler.Pop:PItem;
Begin
  if _ESP_ = Env.StackSize then
  begin
    Env.ErrAdr := CurProcAdr;
    raise Exception.Create('Attempt to POP on empty Stack!');
  End;
  Result:= @Env.Stack[_ESP_];
  Inc(_ESP_, 4);
end;

//Get val from ST(idx)
Function TDecompiler.FGet (idx:Integer):PItem;
Begin
  Result:=@Env.FStack[(_TOP_ + idx) and 7];
end;

//Save val into ST(idx)
Procedure TDecompiler.FSet (idx:Integer; val:PITEM);
Begin
  With Env.FStack[(_TOP_ + idx) and 7] do
  Begin
    Flags := val.Flags;
    Precedence := val.Precedence;
    Size := val.Size;
    Offset := val.Offset;
    IntValue := val.IntValue;
    Value := val.Value;
    _Type := val._Type;
    Name := val.Name;
  End;
end;

Procedure TDecompiler.FPush (val:PITEM);
Begin
  _TOP_:=(_TOP_-1) and 7;
  FSet(0, val);
end;

Function TDecompiler.FPop:PITEM;
Begin
  Result:=FGet(0);
  _TOP_:=(_TOP_+1) and 7;
end;

Function TDecompiler.CheckPrototype (ARec:InfoRec):Boolean;
var
  n,argNum:Integer;
  aInfo:PArgInfo;
Begin
  Result:=False;
  if Assigned(ARec.procInfo.args) then argNum := ARec.procInfo.args.Count
    Else argNum:= 0;
  for n := 0 to argNum-1 do
  begin
    aInfo := PArgInfo(ARec.procInfo.args[n]);
    if aInfo.TypeDef = '' then Exit;
  end;
  if (ARec.kind = ikFunc) and (ARec._type = '') Then Exit;
  Result:=False;
end;

Function TDecompiler.Init (fromAdr:Integer):Boolean;
var
  retKind:LKind;
  callKind:Byte;
  n, argNum, ndx, rn, size:Integer;
  fromPos:Integer;
  recN:InfoRec;
  aInfo:PArgInfo;
  item:TItem;
  retType:AnsiString;
Begin
  Result:=True;
  retKind:=ikUnknown;
  fromPos := Adr2Pos(fromAdr); 
  assert(fromPos >= 0);
  //Imports not decompile
  if IsFlagSet([cfImport], fromPos) then Exit;
  recN := GetInfoRec(fromAdr);
  if not CheckPrototype(recN) then
  begin
    Result:=false;
    Exit;
  end;
  retType := recN._type;
  //Check that function return type is given
  if recN.kind = ikFunc then retKind := GetTypeKind(retType, size);
  //Init registers
  InitItem(@item);
  for n := 16 to 23 do
    SetRegItem(n, item);

  //Init Env.Stack
  _ESP_ := Env.StackSize;
  //Init floating registers stack
  _TOP_ := 0;
  for n := 0 to 7 do
    FSet(n, @item);
  callKind := recN.procInfo.call_kind;

  //Arguments
  if Assigned(recN.procInfo.args) then argNum := recN.procInfo.args.Count
    else argNum:= 0;
  if callKind = 0 then //fastcall
  Begin
    ndx := 0;
    for n := 0 to argNum-1 do
    Begin
      aInfo := PARGINFO(recN.procInfo.args[n]);
      InitItem(@item);
      item.Flags := [IF_ARG];
      if aInfo.Tag = $22 then Include(item.Flags, IF_VAR);
      item._Type := aInfo.TypeDef;
      item.Name := GetArgName(aInfo);
      item.Value := item.Name;
      if aInfo.Size > 4 then
      Begin
        size := aInfo.Size;
        while size<>0 do
        Begin
          Push(@item);
          Dec(size, 4);
        End;
        continue;
      End;
      //eax, edx, ecx
      if ndx in [0..2] then
      Begin
        if ndx<>0 then rn := 19 - ndx
          else rn := 16;
        SetRegItem(rn, item);
        Inc(ndx);
      End
      else Push(@item);
    End;
    //ret value
    if (retKind = ikLString) or (retKind = ikRecord) then
    Begin
      InitItem(@item);
      item.Flags := [IF_ARG, IF_VAR];
      item._Type := retType;
      item.Name := 'Result';
      item.Value := item.Name;
      //eax, edx, ecx
      if ndx in [0..2] then
      Begin
        if ndx<>0 then rn := 19 - ndx
          else rn := 16;
        SetRegItem(rn, item);
        //Inc(_ndx); not used
      End
      else Push(@item);
    End;
  End
  else if (callKind = 3) or (callKind = 1) then //stdcall, cdecl
  Begin
    //Arguments in reverse order
    for n := argNum - 1 downto 0 do
    Begin
      aInfo := PARGINFO(recN.procInfo.args[n]);
      InitItem(@item);
      item.Flags := [IF_ARG];
      if aInfo.Tag = $22 then Include(item.Flags, IF_VAR);
      item._Type := aInfo.TypeDef;
      item.Name := GetArgName(aInfo);
      item.Value := item.Name;
      Push(@item);
    End;
  End
  else if callKind = 2 then //pascal
    for n := 0 to argNum-1 do
    Begin
      aInfo := PARGINFO(recN.procInfo.args[n]);
      InitItem(@item);
      item.Flags := [IF_ARG];
      if aInfo.Tag = $22 then Include(item.Flags, IF_VAR);
      item._Type := aInfo.TypeDef;
      item.Name := GetArgName(aInfo);
      item.Value := item.Name;
      Push(@item);
    End;
  //Push ret address
  InitItem(@item);
  Push(@item);
  Env.BpBased := PF_BPBASED in recN.procInfo.flags;
  Env.LocBase := 0;
  if not Env.BpBased then Env.LocBase := _ESP_;
  Env.LastResString := '';
end;

Procedure TDecompileEnv.OutputSourceCodeLine (line:AnsiString);
Begin
  FMain.lbSourceCode.Items.Add(StringOfChar(' ',TAB_SIZE*Indent)+line);
end;

Procedure TDecompileEnv.OutputSourceCode;
var
  _end:Boolean;
  line, nextline:AnsiString;
  n:Integer;
Begin
  Alarm := False;
  FMain.lbSourceCode.Clear;
  Indent := 0;
  for n := 0 to Body.Count-1 do
  begin
    line := Body[n];
    if n < Body.Count - 1 Then nextline := Body[n + 1]
      else nextline := '';
    if (line <> '') and (line[1] = '/') and (Pos('??? And ???',line)<>0) Then Alarm := True;
    if SameText(line, 'begin') Or
      SameText(line, 'try') Or
      SameText(line, 'repeat') or
      (Pos('case ',line) > 0) then
    begin
      if SameText(line, 'begin') then line:=line + '// ' + IntToStr(Indent);
      OutputSourceCodeLine(line);
      Inc(Indent);
      continue;
    end
    Else if SameText(line, 'finally') or SameText(line, 'except') then
    begin
      Dec(Indent);
      if Indent < 0 then Indent := 0;
      line:=line + '// ' + IntToStr(Indent);
      OutputSourceCodeLine(line);
      Inc(Indent);
      continue;
    end
    Else if SameText(line, 'end') or SameText(line, 'until') then
    begin
      _end := SameText(line, 'end');
      Dec(Indent);
      if Indent < 0 then Indent := 0;
      if not SameText(nextline, 'else') then line:=line + ';';
      if _end then line:=line + '// ' + IntToStr(Indent);
      OutputSourceCodeLine(line);
      continue;
    end;
    OutputSourceCodeLine(line);
  End;
end;

//Embedded???
Procedure TDecompileEnv.DecompileProc;
var
  de:TDecompiler;
  recN:InfoRec;
Begin
  //EmbeddedList.Clear;
  De := TDecompiler.Create(Self);
  try
    if not De.Init(StartAdr) then
    begin
      De.Env.ErrAdr := De.Env.StartAdr;
      Raise Exception.Create('Procedure Prototype is not completed');
    end;
    De.InitFlags;
    De.SetStop(StartAdr + Size);
    //add prototype
    recN := GetInfoRec(StartAdr);
    ProcName := recN.Name;
    AddToBody(recN.MakePrototype(StartAdr, true, false, false, true, false));
    AddToBody('begin');
    if StartAdr <> EP then
    begin
      if recN.kind = ikConstructor then
        De.Decompile(StartAdr, [CF_CONSTRUCTOR], Nil)
      else if recN.kind = ikDestructor then
        De.Decompile(StartAdr, [CF_DESTRUCTOR], Nil)
      else De.Decompile(StartAdr, [], Nil);
    end
    else De.Decompile(StartAdr, [], Nil);
    AddToBody('end');
  Finally
    De.Free;
  End;
end;

Function TDecompileEnv.GetBJLRange (fromAdr:Integer; Var bodyBegAdr, bodyEndAdr, jmpAdr:Integer; loopInfo:TLoopInfo):Boolean;
var
  _curPos, _instrLen, brType:Integer;
  _curAdr, _jmpAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=False;
  bodyEndAdr := 0;
  jmpAdr := 0;
  _curPos := Adr2Pos(fromAdr);
  assert(_curPos >= 0);
  _curAdr := fromAdr;
  while true do
  begin
    if _curAdr = bodyBegAdr then break;
    _instrLen := frmDisasm.Disassemble(Code + _curPos, _curAdr, @disInfo, Nil);
    Inc(_curPos, _instrLen);
    Inc(_curAdr, _instrLen);
    if disInfo.Branch then
    begin
      if IsFlagSet([cfSkip], _curPos - _instrLen) then continue;
      if not disInfo.Conditional then Exit;
      brType := BranchGetPrevInstructionType(disInfo.Immediate, _jmpAdr, loopInfo);
      Case brType of
        1: //jcc down
          if disInfo.Immediate > bodyBegAdr then
          begin
            bodyBegAdr := disInfo.Immediate;
            continue;
          end;
        0,3: //simple if or jmp down
          if disInfo.Immediate > bodyEndAdr then
          begin
            bodyEndAdr := disInfo.Immediate;
            if brType = 3 then jmpAdr := _jmpAdr;
            continue;
          end;
        2: //jcc up
          //if disInfo.Immediate > fromAdr then Exit;
          if bodyEndAdr = 0 then
            bodyEndAdr := disInfo.Immediate
          else if bodyEndAdr <> disInfo.Immediate then
            Raise Exception.Create('GetBJLRange: unknown situation');
        4: //jmp up
          Exit;
      end;
    end;
  End;
  Result:=true;
end;

Procedure TDecompileEnv.CreateBJLSequence (fromAdr, bodyBegAdr, bodyEndAdr:Integer);
var
  found:Boolean;
  b:Byte;
  i, j, m, curPos, instrLen:Integer;
  curAdr, adr:Integer;
  bjl_0, bjl_1, bjl_2:PBJL;
  bjlInfo_0, bjlInfo_1, bjlInfo_2:PBJLInfo;
  disInfo:TDisInfo;
Begin
  BJLnum := 0;
  bjllist.Clear;
  BJLseq.Clear;
  curPos := Adr2Pos(fromAdr); 
  assert(curPos >= 0);
  curAdr := fromAdr;
  while true do
  Begin
    if curAdr = bodyBegAdr then
    Begin
      New(bjl_0);
      bjl_0.branch := false;
      bjl_0.loc := true;
      bjl_0._type := BJL_LOC;
      bjl_0.address := bodyBegAdr;
      bjl_0.idx := 0;
      bjllist.Add(bjl_0);
      New(bjlInfo_0);
      bjlInfo_0.state := 'L';
      bjlInfo_0.bcnt := 0;
      bjlInfo_0.address := bodyBegAdr;
      bjlInfo_0.dExpr := '';
      bjlInfo_0.iExpr := '';
      BJLseq.Add(bjlInfo_0);
      New(bjl_0);
      bjl_0.branch := false;
      bjl_0.loc := true;
      bjl_0._type := BJL_LOC;
      bjl_0.address := bodyEndAdr;
      bjl_0.idx := 0;
      bjllist.Add(bjl_0);
      New(bjlInfo_0);
      bjlInfo_0.state := 'L';
      bjlInfo_0.bcnt := 0;
      bjlInfo_0.address := bodyEndAdr;
      bjlInfo_0.dExpr := '';
      bjlInfo_0.iExpr := '';
      BJLseq.Add(bjlInfo_0);
      break;
    End;
    if IsFlagSet([cfLoc], curPos) then
    Begin
      New(bjl_0);
      bjl_0.branch := false;
      bjl_0.loc := true;
      bjl_0._type := BJL_LOC;
      bjl_0.address := curAdr;
      bjl_0.idx := 0;
      bjllist.Add(bjl_0);
      New(bjlInfo_0);
      bjlInfo_0.state := 'L';
      bjlInfo_0.bcnt := 0;
      bjlInfo_0.address := curAdr;
      bjlInfo_0.dExpr := '';
      bjlInfo_0.iExpr := '';
      BJLseq.Add(bjlInfo_0);
    End;
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    if disInfo.Branch then
    Begin
      New(bjl_0);
      bjl_0.branch := true;
      bjl_0.loc := false;
      if IsFlagSet([cfSkip], curPos) then bjl_0._type := BJL_SKIP_BRANCH
        else bjl_0._type := BJL_BRANCH;
      bjl_0.address := disInfo.Immediate;
      bjl_0.idx := 0;
      bjllist.Add(bjl_0);
      New(bjlInfo_0);
      bjlInfo_0.state := 'B';
      bjlInfo_0.bcnt := 0;
      bjlInfo_0.address := disInfo.Immediate;
      b := Byte(Code[curPos]);
      if b = 15 then b := Byte(Code[curPos + 1]);
      bjlInfo_0.dExpr := GetDirectCondition(Chr((b and $F) + Ord('A')));
      bjlInfo_0.iExpr := GetInvertCondition(Chr((b and $F) + Ord('A')));
      BJLseq.Add(bjlInfo_0);
    End;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
  BJLmaxbcnt := 0;
  for i := 0 to bjllist.Count-1 do
  Begin
    bjl_1 := bjllist[i];
    if (bjl_1._type = BJL_BRANCH) or (bjl_1._type = BJL_SKIP_BRANCH) then
      for j := 0 to bjllist.Count-1 do
      Begin
        bjl_2 := bjllist[j];
        if (bjl_2._type = BJL_LOC) and (bjl_1.address = bjl_2.address) then
        Begin
          bjlInfo_0 := BJLseq[j];
          Inc(bjlInfo_0.bcnt);
          if bjlInfo_0.bcnt > BJLmaxbcnt then BJLmaxbcnt := bjlInfo_0.bcnt;
        End;
      End;
  End;
  while true do
  Begin
    found := false;
    for i := 0 to bjllist.Count-1 do
    Begin
      bjl_1 := bjllist[i];
      if bjl_1._type = BJL_SKIP_BRANCH then
      Begin
        adr := bjl_1.address;
        bjllist.Delete(i);
        Dispose(bjl_1);
        bjlInfo_1 := BJLseq[i];
        BJLseq.Delete(i);
        Dispose(bjlInfo_1);
        for j := 0 to bjllist.Count-1 do
        Begin
          bjl_2 := bjllist[j];
          if (bjl_2._type = BJL_LOC) and (adr = bjl_2.address) then
          Begin
            bjlInfo_2 := BJLseq[j];
            Dec(bjlInfo_2.bcnt);
            if bjlInfo_2.bcnt=0 then
            Begin
              bjllist.Delete(j);
              Dispose(bjl_2);
              BJLseq.Delete(j);
              Dispose(bjlInfo_2);
            End;
            found := true;
            break;
          End;
        End;
        if found then break;
      End;
    End;
    if not found then break;
  End;
  m := 1;
  BJLmaxbcnt := 0;
  for i := 0 to bjllist.Count-1 do
  Begin
    bjl_1 := bjllist[i];
    bjl_1.idx := i;
    if bjl_1._type = BJL_BRANCH then
    Begin
      bjlInfo_0 := BJLseq[i];
      bjlInfo_0.dExpr := '#' + IntToStr(m) + '#' + bjlInfo_0.dExpr + '#' + IntToStr(m + 1) + '#';
      bjlInfo_0.iExpr := '#' + IntToStr(m) + '#' + bjlInfo_0.iExpr + '#' + IntToStr(m + 1) + '#';
      Inc(m, 2);
      for j := 0 to bjllist.Count-1 do
      Begin
        bjl_2 := bjllist[j];
        if (bjl_2._type = BJL_LOC) and (bjl_1.address = bjl_2.address) then
        Begin
          bjlInfo_0 := BJLseq[j];
          if bjlInfo_0.bcnt > BJLmaxbcnt then BJLmaxbcnt := bjlInfo_0.bcnt;
        End;
      End;
    End;
  End;
  BJLnum := bjllist.Count;
end;

Procedure TDecompileEnv.UpdateBJLList;
var
  i:Integer;
Begin
  i:=0;
  while i<bjllist.Count do
    if PBJL(bjllist[i])._type = BJL_USED then bjllist.Delete(i)
      Else Inc(i);
end;

Procedure TDecompileEnv.BJLAnalyze;
var
  found:Boolean;
  i, j, k, indx, no:Integer;
  _bjl:PBJL;
  _bjlInfo:PBJLInfo;
  sd, si:AnsiString;
  idx:Array[0..MAXSEQNUM] of Integer;
  pattern:Array[0..MAXSEQNUM] of Char;
Begin
  found:=true;
  UpdateBJLList;
  while found do
  Begin
    found := false;
		//BM BM ... BM <:=> BM (|| ... ||)
		//BM	0
		//BM	1
		//...
		//BM	k-1
    for k := BJLmaxbcnt downto 2 do
    Begin
      for i := 0 to bjllist.Count-1 do
      Begin
        if not BJLGetIdx(@idx[0], i, k) then continue;
        for j := 0 to k-1 do pattern[j] := 'B';
        pattern[k] := #0;
        if not BJLCheckPattern1(pattern, i) then continue;
        for j := 0 to k-1 do pattern[j] := '1';
        pattern[k] := #0;
        if not BJLCheckPattern2(pattern, i) then continue;
        _bjl := PBJL(bjllist[i]);
        indx := BJLFindLabel(_bjl.address, no);
        if indx = -1 then continue;

        BJLSeqSetStateU(@idx[0], k - 1);
        BJLListSetUsed(i, k - 1);
        sd := '';
        si := '';
        for j := 0 to k-1 do
        Begin
          _bjlInfo := PBJLInfo(BJLseq[idx[j]]);
          ExprMerge(sd, _bjlInfo.dExpr, '|');
          ExprMerge(si, _bjlInfo.iExpr, '&');
        End;
        _bjlInfo := PBJLInfo(BJLseq[idx[k - 1]]);
        _bjlInfo.dExpr := sd;
        _bjlInfo.iExpr := si;

        _bjlInfo := PBJLInfo(BJLseq[indx]);
        _bjl := PBJL(bjllist[no]);
        Dec(_bjlInfo.bcnt, k - 1);
        if (_bjlInfo.bcnt=0) and (_bjl._type = BJL_LOC) then _bjl._type := BJL_USED;
        UpdateBJLList;
        found := true;
        break;
      End;
      if found then break;
    End;
    if found then continue;
		//BN BM @N <:=> BM (&&)
		//BN	0
		//BM	1
		//@N  2
    for i := 0 to bjllist.Count-1 do
    Begin
      if not BJLGetIdx(@idx[0], i, 3) then continue;
      if not BJLCheckPattern1('BBL', i) then continue;
      if not BJLCheckPattern2('101', i) then continue;
      if BJLCheckPattern2('111', i) then continue; //check that N !:= M

      _bjlInfo := PBJLInfo(BJLseq.Items[idx[0]]);
      _bjlInfo.state := 'U';
      _bjl := PBJL(bjllist[i]);
      _bjl._type := BJL_USED;

      sd := ''; 
      si := '';
      ExprMerge(sd, _bjlInfo.iExpr, '&');
      ExprMerge(si, _bjlInfo.dExpr, '|');
      _bjlInfo := PBJLInfo(BJLseq[idx[1]]);
      ExprMerge(sd, _bjlInfo.dExpr, '&');
      ExprMerge(si, _bjlInfo.iExpr, '|');

      _bjlInfo.dExpr := sd;
      _bjlInfo.iExpr := si;

      _bjlInfo := PBJLInfo(BJLseq[idx[2]]);
      _bjl := PBJL(bjllist[i + 2]);
      Dec(_bjlInfo.bcnt);
      if (_bjlInfo.bcnt=0) and (_bjl._type = BJL_LOC) then _bjl._type := BJL_USED;
      UpdateBJLList;
      found := true;
      break;
    End;
    if found then continue;
		//BN @N <:=> if (~BN)
		//BN	0   if Begin
		//@N	1   End;
    for i := 0 to bjllist.Count-1 do
    Begin
      if not BJLGetIdx(@idx[0], i, 2) then continue;
      if not BJLCheckPattern1('BL', i) then continue;
      if not BJLCheckPattern2('11', i) then continue;

      _bjlInfo := PBJLInfo(BJLseq[idx[0]]);
      _bjlInfo.state := 'I';
      _bjlInfo.result := _bjlInfo.iExpr;
      _bjl := PBJL(bjllist[i]);
      _bjl.branch := false;
      _bjl._type := BJL_USED;

      _bjlInfo := PBJLInfo(BJLseq[idx[1]]);
      _bjl := PBJL(bjllist[i + 1]);
      Dec(_bjlInfo.bcnt);
      if (_bjlInfo.bcnt=0) and (_bjl._type = BJL_LOC) then _bjl._type := BJL_USED;
      UpdateBJLList;
      found := true;
      break;
    End;
    if found then continue;
		//BN BM @N @M <:=> if (BN || ~BM)
		//BN    0   if Begin
		//BM    1
		//@N    2
		//@M    3   End;    k := 1
    for i := 0 to bjllist.Count-1 do
    Begin
      if not BJLGetIdx(@idx[0], i, 4) then continue;
      if not BJLCheckPattern1('BBLL', i) then continue;
      if not BJLCheckPattern2('1010', i) then continue;
      if not BJLCheckPattern2('0101', i) then continue;
      _bjlInfo := PBJLInfo(BJLseq[idx[0]]);
      _bjlInfo.state := 'I';
      sd := _bjlInfo.dExpr;
      _bjlInfo := PBJLInfo(BJLseq[idx[1]]);
      ExprMerge(sd, _bjlInfo.iExpr, '|');
      _bjlInfo := PBJLInfo(BJLseq[idx[0]]);
      _bjlInfo.result := sd;

      BJLSeqSetStateU(@idx[0], 2);
      BJLListSetUsed(i, 2);

      _bjlInfo := PBJLInfo(BJLseq[idx[2]]);
      _bjl := PBJL(bjllist[i + 2]);
      Dec(_bjlInfo.bcnt);
      if (_bjlInfo.bcnt=0) and (_bjl._type = BJL_LOC) then _bjl._type := BJL_USED;
      _bjl := PBJL(bjllist[i + 3]);
      Dec(_bjlInfo.bcnt);
      if (_bjlInfo.bcnt=0) and (_bjl._type = BJL_LOC) then _bjl._type := BJL_USED;
      UpdateBJLList;
      found := true;
      break;
    End;
    if found then continue;
  End;
end;

Function TDecompileEnv.BJLGetIdx (idx:PIntegerArray; from, num:Integer):Boolean;
Var
  k:Integer;
  bjl:PBJL;
Begin
  Result:=False;
  for k := 0 to num-1 do
    if from + k < bjllist.Count then
    begin
      bjl := PBJL(bjllist[from + k]);
      idx[k] := bjl.idx;
    end
    else Exit;
  Result:=True;
end;

Function TDecompileEnv.BJLCheckPattern1 (t:PAnsiChar; from:Integer):Boolean;
Var
  k,l:Integer;
  bjl:PBJL;
Begin
  Result:=False;
  l:=StrLen(t);
  for k := 0 to l-1 do
  begin
    if from + k >= bjllist.Count then Exit;
    bjl := PBJL(bjllist[from + k]);
    if (t[k] = 'B') and not bjl.branch then Exit;
    if (t[k] = 'L') and not bjl.loc then Exit;
  end;
  Result:=true;
end;

Function TDecompileEnv.BJLCheckPattern2 (t:PAnsiChar; from:Integer):Boolean;
Var
  k,l,address:Integer;
  bjl:PBJL;
Begin
  Result:=False;
  address:=-1;
  l:=StrLen(t);
  for k := 0 to l-1 do
  begin
    if from + k >= bjllist.Count Then Exit;
    if t[k] = '1' then
    begin
      bjl := PBJL(bjllist[from + k]);
      if address = -1 then
      begin
        address := bjl.address;
        continue;
      end;
      if bjl.address <> address then Exit;
    end;
  end;
  Result:=true;
end;

Function TDecompileEnv.BJLFindLabel (address:Integer; Var no:Integer):Integer;
Var
  k:Integer;
  bjl:PBJL;
Begin
  no := -1;
  Result:=-1;
  for k := 0 to bjllist.Count-1 do
  begin
    bjl := PBJL(bjllist[k]);
    if bjl.loc and (bjl.address = address) then
    begin
      no := k;
      Result:=bjl.idx;
      Exit;
    End;
  end;
end;

Procedure TDecompileEnv.BJLSeqSetStateU (idx:PIntegerArray; num:Integer);
var
  k:Integer;
Begin
  for k := 0 to num-1 do
  begin
    if (idx[k] < 0) or (idx[k] >= BJLseq.Count) then break;
    PBJLInfo(BJLseq[idx[k]]).state := 'U';
  end;
end;

Procedure TDecompileEnv.BJLListSetUsed (from, num:Integer);
var
  k:Integer;
Begin
  for k := 0 to num-1 do
  begin
    if from + k >= bjllist.Count then break;
    PBJL(bjllist[from + k])._type := BJL_USED;
  end;
end;

Function TDecompileEnv.ExprGetOperation (s:AnsiString):Char;
var
  n,k:Integer;
Begin
  n:=0;
  for k := 1 to Length(s) do
  begin
    Result := s[k];
    if Result = '(' then Inc(n)
    Else if Result = ')' then Dec(n)
    else if ((Result = '&') or (Result = '|')) And (n=0) then Exit;
  end;
  Result:=#0;
end;

Procedure TDecompileEnv.ExprMerge (Var dst:AnsiString; src:AnsiString; op:Char);// dst = dst op src, op = '|' or '';
var
  op1,op2:Char;
Begin
  if dst = '' then dst := src
  else
  begin
    op1 := ExprGetOperation(dst);
    op2 := ExprGetOperation(src);
    if op = '|' then
    begin
      if op1 = #0 then
      Case op2 of
        #0: dst := dst + ' || ' + src;
        '|': dst := dst + ' || ' + src;
        '&': dst := dst + ' || (' + src + ')';
      end
      else if op1 = '|' then
      Case op2 of
        #0: dst := dst + ' || ' + src;
        '|': dst := dst + ' || ' + src;
        '&': dst := dst + ' || (' + src + ')';
      end
      Else if op1 = '&' then
      case op2 of
        #0: dst := '(' + dst + ') || ' + src;
        '|': dst := '(' + dst + ') || ' + src;
        '&': dst := '(' + dst + ') || (' + src + ')';
      end;
    end
    else if op = '&' then
    begin
      if op1 = #0 then
      Case op2 of
        #0: dst := dst + ' && ' + src;
        '|': dst := dst + ' && (' + src + ')';
        '&': dst := dst + ' && ' + src;
      end
      else if op1 = '|' then
      case op2 of
        #0: dst := '(' + dst + ') && ' + src;
        '|': dst := '(' + dst + ') && (' + src + ')';
        '&': dst := '(' + dst + ') && ' + src;
      end
      else if op1 = '&' then
      case op2 of
        #0: dst := dst + ' && ' + src;
        '|': dst := dst + ' && (' + src + ')';
        '&': dst := dst + ' && ' + src;
      end;
    End;
  end;
end;

Function TDecompileEnv.PrintBJL:AnsiString;
var
  n, m, k:Integer;
  _cmpItem:PCMPITEM;
  bjlInfo:PBJLInfo;
Begin
  Result:='';
  for n := 0 to BJLseq.Count-1 do
  begin
    bjlInfo := PBJLInfo(BJLseq[n]);
    if bjlInfo.state = 'I' then
    begin
      result := bjlInfo.result;
      k:=1;
      for m := 0 to CmpStack.Count-1 do
      begin
        _cmpItem := PCMPITEM(CmpStack[m]);
        result := AnsiReplaceStr(result, '#' + IntToStr(k) + '#', '(' + _cmpItem.L + ' ');
        Inc(k);
        result := AnsiReplaceStr(result, '#' + IntToStr(k) + '#', ' ' + _cmpItem.R + ')');
        Inc(k);
      end;
      break;
    end;
  end;
  result := AnsiReplaceStr(result, '||', 'Or');
  result := AnsiReplaceStr(result, '&&', 'And');
end;

Function TDecompiler.Decompile (fromAdr:Integer; flags:TDecomCset; loopInfo:TLoopInfo):Integer;
var
  cmp, immInt64,fullSim:Boolean;
  op:Byte;
  kind:LKind;
  curAdr, branchAdr, sAdr, jmpAdr, begAdr,endAdr, adr:Integer;
  r,n, skip1, skip2, _size, elSize, procSize:Integer;
  fromPos, curPos, endPos,instrLen, instrLen1, num, regIdx, _pos, sPos:Integer;
  decPos, cmpRes, varIdx, brType, _mod, _div:Integer;
  bytesToSkip, bytesToSkip1, bytesToSkip2, bytesToSkip3:Integer;
  int64Val:Int64;
  recN, recN1:InfoRec;
  _loopInfo:TLoopInfo;
  recX:PXrefRec;
  item, item1, item2:TItem;
  cmpItem:PCmpItem;
  dd,line, comment, _name, typeName:AnsiString;
  disInfo:TDisInfo;
  de:TDecompiler;
Begin
  fromPos := Adr2Pos(fromAdr);

  line := '//' + Val2Str(fromAdr,8);
  if IsFlagSet([cfPass], fromPos) then
  Begin
    line:=line + '??? And ???';
    //return fromAdr;
  End;
  Env.AddToBody(line);
  curPos := fromPos; 
  curAdr := fromAdr;
  procSize := GetProcSize(Env.StartAdr);
  while true do
  Begin
    //End of decompilation
    if DeFlags[curAdr - Env.StartAdr] = 1 then
    Begin
      SetFlag([cfPass], fromPos);
      break;
    End;
    //@TryFinallyExit
    if IsFlagSet([cfFinallyExit], curPos) then
    Begin
      Env.AddToBody('Exit;');
      while IsFlagSet([cfFinallyExit], curPos) do
      Begin
        Inc(curPos);
        Inc(curAdr);
      End;
      continue;
    End;
    //Try
    if IsFlagSet([cfTry], curPos) then
    Begin
      try
        curAdr := DecompileTry(curAdr, flags, loopInfo);
      except 
        on E:Exception do raise Exception.Create('Decompile.' + E.Message);
      End;
      curPos := Adr2Pos(curAdr);
      continue;
    End;
    if IsFlagSet([cfLoop], curPos) then
    Begin
      recN := GetInfoRec(curAdr);
      if IsFlagSet([cfFrame], curPos) then
      Begin
        if Assigned(recN) and (recN.xrefs.Count = 1) then
        Begin
          recX := PXrefRec(recN.xrefs[0]);
          endPos := GetNearestUpInstruction(Adr2Pos(recX.adr + recX.offset));
          endAdr := Pos2Adr(endPos);
          //Check instructions between _curAdr and _endAdr (must be push, add or sub to full simulation)
          fullSim := true;
          _pos := curPos;
          adr := curAdr;
          while true do
          begin
            instrLen := frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
            op := frmDisasm.GetOp(disInfo.Mnem);
            if (op <> OP_PUSH) and (op <> OP_ADD) and (op <> OP_SUB) then
            begin
              fullSim := false;
              break;
            end;
            Inc(_pos, instrLen);
            Inc(adr, instrLen);
            if _pos >= endPos then break;
          End;
          //Full simulation
          if fullSim then
          begin
            //Get instruction at _endAdr
            _pos := endPos;
            adr := endAdr;
            instrLen := frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
            op := frmDisasm.GetOp(disInfo.Mnem);
            //dec reg in frame - full simulate
            if (op = OP_DEC) and (disInfo.OpType[0] = otREG) then
            Begin
              regIdx := disInfo.OpRegIdx[0];
              GetRegItem(regIdx, item);
              //Save dec position
              decPos := _pos;
              num := item.IntValue;
              //next instruction is jne
              Inc(_pos, instrLen);
              Inc(adr, instrLen);
              instrLen := frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
              branchAdr := disInfo.Immediate;
              //Save position
              sPos := _pos + instrLen;
              sAdr := adr + instrLen;
              for n := 0 to num-1 do
              Begin
                adr := branchAdr;
                _pos := Adr2Pos(adr);
                while true do
                Begin
                  if _pos = decPos then break;
                  instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
                  op := frmDisasm.GetOp(DisaInfo.Mnem);
                  if op = OP_PUSH then SimulatePush(adr);
                  if (op = OP_ADD) or (op = OP_SUB) then SimulateInstr2(adr, op);
                  Inc(_pos, instrLen);
                  Inc(adr, instrLen);
                End;
              End;
              //reg := 0 after cycle
              InitItem(@item);
              Include(item.Flags, IF_INTVAL);
              SetRegItem(regIdx, item);
              curPos := sPos;
              curAdr := sAdr;
              continue;
            End;
          End;
        End;
      End
      else//loop
      Begin
        //Count xrefs from above
        num := 0;
        for n := 0 to recN.xrefs.Count-1 do
        Begin
          recX := PXrefRec(recN.xrefs[n]);
          if recX.adr + recX.offset < curAdr then Inc(num);
        End;
        if Assigned(recN) and (recN.counter < recN.xrefs.Count - num) then
        Begin
          Inc(recN.counter);
          _loopInfo := GetLoopInfo(curAdr);
          if _loopInfo=Nil then
          Begin
            Env.ErrAdr := curAdr;
            raise Exception.Create('Control flow under construction');
          End;
          //for
          if _loopInfo.Kind = 'F' then
          Begin
            line := 'for ';
            if _loopInfo.forInfo.NoVar then
            Begin
              varIdx := _loopInfo.forInfo.CntInfo.IdxValue;
              //register
              if _loopInfo.forInfo.CntInfo.IdxType = itREG then
                line:=line + GetDecompilerRegisterName(varIdx);
              //local var
              if _loopInfo.forInfo.CntInfo.IdxType = itLVAR then
                line:=line + Env.GetLvarName(varIdx);
            End
            else
            Begin
              varIdx := _loopInfo.forInfo.VarInfo.IdxValue;
              //register
              if _loopInfo.forInfo.VarInfo.IdxType = itREG then
                line:=line + GetDecompilerRegisterName(varIdx);
              //local var
              if _loopInfo.forInfo.VarInfo.IdxType = itLVAR then
                line:=line + Env.GetLvarName(varIdx);
            End;
            line:=line + ' := ' + _loopInfo.forInfo.From + ' ';
            if _loopInfo.forInfo.Down then line:=line + 'down';
            line:=line + 'to ' + _loopInfo.forInfo._To + ' do';
            Env.AddToBody(line);

            de := TDecompiler.Create(Env);
            de.SetStackPointers(Self);
            de.SetDeFlags(DeFlags);
            de.SetStop(_loopInfo.forInfo.StopAdr);
            try
              Env.AddToBody('begin');
              curAdr := de.Decompile(curAdr, [], _loopInfo);
              Env.AddToBody('end');
            except
              on E:Exception do
              Begin
                FreeAndNil(de);
                raise Exception.Create('Loop. ' + E.Message);
              End;
            end;
            de.Free;
            if curAdr > _loopInfo.BreakAdr then
            Begin
              Env.ErrAdr := curAdr;
              raise Exception.Create('Loop.desynchronization');
            End;
            curAdr := _loopInfo.BreakAdr;
            curPos := Adr2Pos(curAdr);
            _loopInfo.Free;
            continue;
          End
          //while, repeat
          else
          Begin
            de := TDecompiler.Create(Env);
            de.SetStackPointers(Self);
            de.SetDeFlags(DeFlags);
            de.SetStop(_loopInfo.BreakAdr);
            try
              if _loopInfo.Kind = 'R' then Env.AddToBody('repeat')
              else
              Begin
                Env.AddToBody('while () do');
                Env.AddToBody('begin');
              End;
              curAdr := de.Decompile(curAdr, [], _loopInfo);
              if _loopInfo.Kind = 'R' then Env.AddToBody('until')
                else Env.AddToBody('end');
            except
              on E:Exception do
              Begin
                FreeAndNil(de);
                raise Exception.Create('Loop. ' + E.Message);
              End;
            end;
            de.Free;
            if curAdr > _loopInfo.BreakAdr then
            Begin
              Env.ErrAdr := curAdr;
              raise Exception.Create('Loop.desynchronization');
            End;
            curAdr := _loopInfo.BreakAdr;
            curPos := Adr2Pos(curAdr);
            _loopInfo.Free;
            continue;
          End;             
        End;
      End;
    End;
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
    //if _instrLen=0 then
    //Begin
    //  Env.ErrAdr := _curAdr;
    //  raise Exception.Create('Unknown instruction');
    //End;
    if instrLen=0 then
    Begin
      Env.AddToBody('???');
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    if IsFlagSet([cfDSkip], curPos) then
    Begin
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    dd := DisaInfo.Mnem;
    //skip wait, sahf
    if (dd = 'wait') or (dd = 'sahf') then
    Begin
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    op := frmDisasm.GetOp(DisaInfo.Mnem);
    //cfSkip - skip instructions
    if IsFlagSet([cfSkip], curPos) then
    Begin
      //Constructor or Destructor
      if ((op in [OP_TEST, OP_CMP]) or DisaInfo.Call) and (flags * [CF_CONSTRUCTOR, CF_DESTRUCTOR] <> []) then
      Begin
        while true do
        Begin
          //If instruction test or cmp - skip until loc (instruction at loc position need to be executed)
          if ((op = OP_TEST) or (op = OP_CMP)) and IsFlagSet([cfLoc], curPos) then break;
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          //Skip @BeforeDestruction
          if DisaInfo.Call and not IsFlagSet([cfSkip], curPos) then break;
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
          if instrLen=0 then
          Begin
            Env.AddToBody('???');
            Inc(curPos, instrLen); 
            Inc(curAdr, instrLen);
            continue;
          End;
        End;
        continue;
      End;
      if flags * [CF_FINALLY, CF_EXCEPT] <> [] then
      Begin
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      if DisaInfo.Call then
      Begin
        if CF_EXCEPT in flags then
        Begin
          recN := GetInfoRec(DisaInfo.Immediate);
          if recN.SameName('@DoneExcept') then
          Begin
            Inc(curPos, instrLen); 
            Inc(curAdr, instrLen);
            break;
          End;
        End;
      End;
    End;
    if DisaInfo.Branch then
    Begin
      _pos := Adr2Pos(DisaInfo.Immediate);
      if DisaInfo.Conditional then
      Begin
        bytesToSkip := IsIntOver(curAdr);
        if bytesToSkip<>0 then
        Begin
          Inc(curPos, bytesToSkip); 
          Inc(curAdr, bytesToSkip);
          continue;
        End;
        //Skip jns
        if dd = 'jns' then
        Begin
          curAdr := DisaInfo.Immediate;
          curPos := Adr2Pos(curAdr);
          continue;
        End;
      End
      //skip jmp
      else
      Begin
        //Case without cmp
        if IsFlagSet([cfSwitch], curPos) then
        Begin
          GetRegItem(DisaInfo.OpRegIdx[0], item);
          if item.Value <> '' then
            Env.AddToBody('case ' + item.Value + ' of')
          else
            Env.AddToBody('case ' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' of');
          curAdr := DecompileCaseEnum(curAdr, 0, loopInfo);
          Env.AddToBody('end');
          curPos := Adr2Pos(curAdr);
          continue;
        End;
        //Some deoptimization!
        if 0=1 then //IsFlagSet(cfLoop, _pos)
        Begin
          recN := GetInfoRec(DisaInfo.Immediate);
          if Assigned(recN.xrefs) then
          Begin
            for n := 0 to recN.xrefs.Count-1 do
            Begin
              recX := PXrefRec(recN.xrefs[n]);
              if (recX.adr + recX.offset = curAdr) and (recX._type = 'J') then
              Begin
                SetFlag([cfLoop, cfLoc], curPos);
                recN1 := GetInfoRec(curAdr);
                if recN1=Nil then recN1 := InfoRec.Create(curPos, ikUnknown);
                continue;
              End;
            End;
          End;
        End;
        //jmp XXXXXXXX - End Of Decompilation?
        if DeFlags[DisaInfo.Immediate - Env.StartAdr] = 1 then
        Begin
          //SetFlag(cfPass, _fromPos);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          break;
        End;
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        if DeFlags[curAdr - Env.StartAdr] = 1 then
        Begin
          //if stop flag at this point - check Exit
          if IsExit(DisaInfo.Immediate) then Env.AddToBody('Exit;');
          //if jmp BreakAdr
          if Assigned(loopInfo) and (loopInfo.BreakAdr = DisaInfo.Immediate) then
            Env.AddToBody('Break;');
        End;
        continue;
      End;
    End;
    if DisaInfo.Call then
    Begin
      recN := GetInfoRec(DisaInfo.Immediate);
      if Assigned(recN) then
      Begin
        //Inherited
        if (flags * [CF_CONSTRUCTOR, CF_DESTRUCTOR] <> []) and IsValidCodeAdr(DisaInfo.Immediate) then
        Begin
          GetRegItem(16, item);
          if SameText(item.Value, 'Self') then  //eax:=Self
          Begin
            if (recN.kind = ikConstructor) or (recN.kind = ikDestructor) then
            Begin
              SimulateInherited(DisaInfo.Immediate);
              Env.AddToBody('inherited;');
              Inc(curPos, instrLen); 
              Inc(curAdr, instrLen);
              continue;
            End;
          End;
        End;
        //Other case (not constructor and destructor)
        if IsInheritsByProcName(Env.ProcName, recN.Name) then
        Begin
          SimulateInherited(DisaInfo.Immediate);
          InitItem(@item);
          item.Precedence := PRECEDENCE_ATOM;
          item.Name := 'EAX';
          item._Type := recN._type;
          SetRegItem(16, item);
          Env.AddToBody('EAX := inherited ' + ExtractProcName(Env.ProcName) + ';');
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
      End;
      //true - CMP
      cmp := SimulateCall(curAdr, DisaInfo.Immediate, instrLen, Nil, 0);
      if cmp then
      Begin
        sPos := curPos;
        sAdr := curAdr;
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        cmpRes := GetCmpInfo(curAdr);
        CompInfo.O := CmpOp;
        if cmpRes = CMP_FAILED then continue;
        if CF_BJL in flags then
        Begin
          New(cmpItem);
          cmpItem.L := CompInfo.L;
          cmpItem.O := CompInfo.O;
          cmpItem.R := CompInfo.R;
          Env.CmpStack.Add(cmpItem);
          //skip jcc
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue; //???
        End;
        if cmpRes = CMP_BRANCH then
        Begin
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
          //jcc up
          if disInfo.Immediate < curAdr then
          Begin
            line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Continue;';
            Env.AddToBody(line);
            Inc(curPos, instrLen); 
            Inc(curAdr, instrLen);
            continue;
          End;
           brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
          //Skip conditional branch
          Inc(curAdr, instrLen);
          curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
          curPos := Adr2Pos(curAdr);
          continue;
        End
        else if cmpRes = CMP_SET then
        Begin
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
          SimulateInstr1(curAdr, frmDisasm.GetOp(DisaInfo.Mnem));
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if op = OP_MOV then
    Begin
      SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    if DisaInfo.Ret then
    Begin
      Inc(_ESP_, 4);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      //End of proc
      if (procSize<>0) and (curPos - fromPos < procSize) then
        Env.AddToBody('Exit;');
      WasRet := true;
      SetFlag([cfPass], Adr2Pos(fromAdr));
      break;
      //continue;
    End;
    if op = OP_PUSH then
    Begin
      bytesToSkip1 := IsInt64ComparisonViaStack1(curAdr, skip1, endAdr);
      bytesToSkip2 := IsInt64ComparisonViaStack2(curAdr, skip1, skip2, endAdr);
      if bytesToSkip1 + bytesToSkip2 = 0 then
      Begin
        SimulatePush(curAdr);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
      End
      else
      Begin
        //Save position
        sPos := curPos;
        sAdr := curAdr;
  
        //Simulate push
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulatePush(curAdr);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulatePush(curAdr);
        Inc(curPos, instrLen);
        Inc(curAdr, instrLen);

        //Decompile until _skip1
        SetStop(endAdr);
        Decompile(curAdr, flags, Nil);
        if bytesToSkip1<>0 then
          cmpRes := GetCmpInfo(sAdr + bytesToSkip1)
        else
          cmpRes := GetCmpInfo(sAdr + bytesToSkip2);

        //Simulate 2nd cmp instruction
        curPos := sPos + skip1; 
        curAdr := sAdr + skip1;
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulateInstr2(curAdr, OP_CMP);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        //Simulate pop
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulatePop(curAdr);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulatePop(curAdr);
        if bytesToSkip1<>0 then
        Begin
          curPos := sPos + bytesToSkip1; 
          curAdr := sAdr + bytesToSkip1;
        End
        else
        Begin
          curPos := sPos + bytesToSkip2;
          curAdr := sAdr + bytesToSkip2;
        End;
        if cmpRes = CMP_FAILED then continue;
        if CF_BJL in flags then
        Begin
          New(cmpItem);
          cmpItem.L := CompInfo.L;
          cmpItem.O := CompInfo.O;
          cmpItem.R := CompInfo.R;
          Env.CmpStack.Add(cmpItem);
          //skip jcc
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
        if cmpRes = CMP_BRANCH then
        Begin
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
          //jcc up
          if disInfo.Immediate < curAdr then
          Begin
            line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Continue;';
            Env.AddToBody(line);
            Inc(curPos, instrLen); 
            Inc(curAdr, instrLen);
            continue;
          End;
           brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
          //Skip conditional branch
          Inc(curAdr, instrLen);
          curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
          curPos := Adr2Pos(curAdr);
        End;
      End;
      continue;
    End
    else if op = OP_POP then
    Begin
      SimulatePop(curAdr);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if op = OP_XOR then
    Begin
      if not IsXorMayBeSkipped(curAdr) then SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if (op = OP_CMP) or (DisaInfo.Float and (dd = 'fcom')) then
    Begin
      //Save position
      sPos := curPos; 
      sAdr := curAdr;
      bytesToSkip := IsBoundErr(curAdr);
      if bytesToSkip<>0 then
      Begin
        Inc(curPos, bytesToSkip);
        Inc(curAdr, bytesToSkip);
        continue;
      End;
      if IsFlagSet([cfSwitch], curPos) then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        if item.Value <> '' then
          Env.AddToBody('case ' + item.Value + ' of')
        else
          Env.AddToBody('case ' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' of');
        curAdr := DecompileCaseEnum(curAdr, 0, loopInfo);
        Env.AddToBody('end');
        curPos := Adr2Pos(curAdr);
        continue;
      End;
      bytesToSkip := IsInlineLengthCmp(curAdr);
      if bytesToSkip<>0 then
      Begin
        GetMemItem(curAdr, @item, 0);
        line := item.Name + ' := Length(';
        if item.Name <> '' then line:=line + item.Name
          else line:=line + item.Value;
        line:=line + ');';
        Env.AddToBody(line);
        Inc(curPos, bytesToSkip); 
        Inc(curAdr, bytesToSkip);
        continue;
      End;
      endAdr := IsGeneralCase(curAdr, Env.StartAdr + Env.Size);
      if endAdr<>0 then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        if item.Value <> '' then
          Env.AddToBody('case ' + item.Value + ' of')
        else
          Env.AddToBody('case ' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' of');
        curAdr := DecompileGeneralCase(curAdr, curAdr, loopInfo, 0);
        Env.AddToBody('end');
        //_curAdr := _endAdr;
        curPos := Adr2Pos(curAdr);
        continue;
      End;
      //skip current instruction (cmp)
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      if not DisaInfo.Float then
      Begin
        bytesToSkip1 := 0; //IsInt64Equality(_sAdr, @_skip1, @_skip2, @_immInt64Val, @_int64Val);
        bytesToSkip2 := 0; //IsInt64NotEquality(_sAdr, @_skip1, @_skip2, @_immInt64Val, @_int64Val);
        bytesToSkip3 := IsInt64Comparison(sAdr, skip1, skip2, immInt64, int64Val);
        if bytesToSkip1 + bytesToSkip2 + bytesToSkip3 = 0 then
        Begin
          cmpRes := GetCmpInfo(curAdr);
          SimulateInstr2(sAdr, op);
          if cmpRes = CMP_FAILED then continue;
          if CF_BJL in flags then
          Begin
            New(cmpItem);
            cmpItem.L := CompInfo.L;
            cmpItem.O := CompInfo.O;
            cmpItem.R := CompInfo.R;
            Env.CmpStack.Add(cmpItem);
            //skip jcc
            instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
            Inc(curPos, instrLen); 
            Inc(curAdr, instrLen);
            continue;
          End;
        End
        //int64 comparison
        else
        Begin
          if bytesToSkip1<>0 then
          Begin
            cmpRes := GetCmpInfo(sAdr + skip2);
            curPos := sPos + skip1; 
            curAdr := sAdr + skip1;
            instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
            SimulateInstr2(curAdr, op);
            if immInt64 then CompInfo.R := IntToStr(int64Val) + 'Begin' + IntToHex(int64Val, 0) + 'End;';
            curPos := sPos + bytesToSkip1; 
            curAdr := sAdr + bytesToSkip1;
          End
          else if bytesToSkip2<>0 then
          Begin
            cmpRes := GetCmpInfo(sAdr + skip2);
            curPos := sPos + skip1; 
            curAdr := sAdr + skip1;
            instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
            SimulateInstr2(curAdr, op);
            if immInt64 then CompInfo.R := IntToStr(int64Val) + 'Begin' + IntToHex(int64Val, 0) + 'End;';
            curPos := sPos + bytesToSkip2; 
            curAdr := sAdr + bytesToSkip2;
          End
          else //_bytesToSkip3
          Begin
            cmpRes := GetCmpInfo(sAdr + skip2);
            curPos := sPos + skip1; 
            curAdr := sAdr + skip1;
            instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
            SimulateInstr2(curAdr, op);
            if immInt64 then CompInfo.R := IntToStr(int64Val) + 'Begin' + IntToHex(int64Val, 0) + 'End;';
            curPos := sPos + bytesToSkip3;
            curAdr := sAdr + bytesToSkip3;
          End;
          if CF_BJL in flags then
          Begin
            New(cmpItem);
            cmpItem.L := CompInfo.L;
            cmpItem.O := CompInfo.O;
            cmpItem.R := CompInfo.R;
            Env.CmpStack.Add(cmpItem);
            //skip jcc
            instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
            Inc(curPos, instrLen); 
            Inc(curAdr, instrLen);
            continue; //???
          End;
        End;
      End
      else
      Begin
        //skip until branch or set
        while true do
        Begin
          instrLen1 := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
          op := frmDisasm.GetOp(disInfo.Mnem);
          if disInfo.Branch or (op = OP_SET) then break;
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
        End;
        cmpRes := GetCmpInfo(curAdr);
        //SimulateFloatInstruction(_sAdr, _instrLen);
        if CF_BJL in flags then
        Begin
          SimulateFloatInstruction(sAdr, instrLen);
          New(cmpItem);
          cmpItem.L := CompInfo.L;
          cmpItem.O := CompInfo.O;
          cmpItem.R := CompInfo.R;
          Env.CmpStack.Add(cmpItem);
          Inc(curPos, instrLen1); 
          Inc(curAdr, instrLen1);
          continue;
        End;
      End;
      if cmpRes = CMP_FAILED then continue;
      if cmpRes = CMP_BRANCH then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        //jcc up
        if disInfo.Immediate < curAdr then
        Begin
          //if (DisInfo.Float) SimulateFloatInstruction(_sAdr, _instrLen);
          line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Continue;';
          Env.AddToBody(line);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
        //jcc at BreakAdr
        if Assigned(loopInfo) and (loopInfo.BreakAdr = disInfo.Immediate) then
        Begin
          //if (DisInfo.Float) SimulateFloatInstruction(_sAdr, _instrLen);
          line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Break;';
          Env.AddToBody(line);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
        //jcc at forInfo.StopAdr
        if Assigned(loopInfo) and Assigned(loopInfo.forInfo) and (loopInfo.forInfo.StopAdr = disInfo.Immediate) then
        Begin
          line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Continue;';
          Env.AddToBody(line);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
        brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
        //Skip conditional branch
        Inc(curAdr, instrLen);
        curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
        curPos := Adr2Pos(curAdr);
        continue;
      End
      else if cmpRes = CMP_SET then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulateInstr1(curAdr, frmDisasm.GetOp(DisaInfo.Mnem));
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
    End
    else if (op = OP_TEST) or (op = OP_BT) then
    Begin
      //Save position
      sAdr := curAdr;
      bytesToSkip := IsInlineLengthTest(curAdr);
      if bytesToSkip<>0 then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        item.Precedence := PRECEDENCE_ATOM;
        item.Value := 'Length(' + item.Value + ')';
        item._Type := 'Integer';
        SetRegItem(DisaInfo.OpRegIdx[0], item);

        line := GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' := Length(' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ');';
        Env.AddToBody(line);

        Inc(curPos, bytesToSkip); 
        Inc(curAdr, bytesToSkip);
        continue;
      End;
      bytesToSkip := IsInlineDiv(curAdr, _div);
      if bytesToSkip<>0 then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        item.Precedence := PRECEDENCE_MULT;
        item.Value := GetString(@item, PRECEDENCE_MULT) + ' Div ' + String(_div);
        item._Type := 'Integer';
        SetRegItem(DisaInfo.OpRegIdx[0], item);

        line := GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' := ' + item.Value + ';';
        Env.AddToBody(line);

        Inc(curPos, bytesToSkip); 
        Inc(curAdr, bytesToSkip);
        continue;
      End;
      cmpRes := GetCmpInfo(curAdr + instrLen);
      SimulateInstr2(sAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      if cmpRes = CMP_FAILED then continue;
      if CF_BJL in flags then
      Begin
        New(cmpItem);
        cmpItem.L := CompInfo.L;
        cmpItem.O := CompInfo.O;
        cmpItem.R := CompInfo.R;
        Env.CmpStack.Add(cmpItem);
        //skip jcc
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      if cmpRes = CMP_BRANCH then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        //jcc up
        if disInfo.Immediate < curAdr then
        Begin
          line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Continue;';
          Env.AddToBody(line);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
        //jcc at BreakAdr
        if Assigned(loopInfo) and (loopInfo.BreakAdr = disInfo.Immediate) then
        Begin
          line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Break;';
          Env.AddToBody(line);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
        //jcc at forInfo.StopAdr
        if Assigned(loopInfo) and Assigned(loopInfo.forInfo) and (loopInfo.forInfo.StopAdr = disInfo.Immediate) then
        Begin
          line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Continue;';
          Env.AddToBody(line);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
         brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
        //Skip conditional branch
        Inc(curAdr, instrLen);

        curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
        curPos := Adr2Pos(curAdr);
        continue;
      End
      else if cmpRes = CMP_SET then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulateInstr1(curAdr, frmDisasm.GetOp(DisaInfo.Mnem));
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
    End
    else if op = OP_LEA then
    Begin
      SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if op = OP_ADD then
    Begin
      bytesToSkip := IsIntOver(curAdr + instrLen);
      endAdr := IsGeneralCase(curAdr, Env.StartAdr + Env.Size);
      if endAdr<>0 then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        if item.Value <> '' then
          Env.AddToBody('case ' + item.Value + ' of')
        else
          Env.AddToBody('case ' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' of');
        curAdr := DecompileGeneralCase(curAdr, curAdr, loopInfo, 0);
        Env.AddToBody('end');
        //_curAdr := _endAdr;
        curPos := Adr2Pos(curAdr);
        continue;
      End;
      //Next switch
      if IsFlagSet([cfSwitch], curPos + instrLen) then
      Begin
        n := - DisaInfo.Immediate;
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        GetRegItem(disInfo.OpRegIdx[0], item);
        if item.Value <> '' then
          Env.AddToBody('case ' + item.Value + ' of')
        else
          Env.AddToBody('case ' + GetDecompilerRegisterName(disInfo.OpRegIdx[0]) + ' of');
        curAdr := DecompileCaseEnum(curAdr, n, loopInfo);
        Env.AddToBody('end');
        curPos := Adr2Pos(curAdr);
        continue;
      End;
      SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen + bytesToSkip); 
      Inc(curAdr, instrLen + bytesToSkip);
      continue;
    End
    else if op = OP_SUB then
    Begin
      //Save position
      sAdr := curAdr;
      bytesToSkip := IsIntOver(curAdr + instrLen);
      endAdr := IsGeneralCase(curAdr, Env.StartAdr + Env.Size);
      if endAdr<>0 then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        if item.Value <> '' then
          Env.AddToBody('case ' + item.Value + ' of')
        else
          Env.AddToBody('case ' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' of');
        curAdr := DecompileGeneralCase(curAdr, curAdr, loopInfo, 0);
        Env.AddToBody('end');
        //_curAdr := _endAdr;
        curPos := Adr2Pos(curAdr);
        continue;
      End;
      //Next switch
      if IsFlagSet([cfSwitch], curPos + instrLen) then
      Begin
        n := DisaInfo.Immediate;
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        GetRegItem(disInfo.OpRegIdx[0], item);
        if item.Value <> '' then
          Env.AddToBody('case ' + item.Value + ' of')
        else
          Env.AddToBody('case ' + GetDecompilerRegisterName(disInfo.OpRegIdx[0]) + ' of');
        curAdr := DecompileCaseEnum(curAdr, n, loopInfo);
        Env.AddToBody('end');
        curPos := Adr2Pos(curAdr);
        continue;
      End;
      cmpRes := GetCmpInfo(curAdr + instrLen);
      SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      if bytesToSkip<>0 then
      Begin
        Inc(curPos, bytesToSkip); 
        Inc(curAdr, bytesToSkip);
        continue;
      End;
      if cmpRes = CMP_FAILED then continue;
      if CF_BJL in flags then
      Begin
        New(cmpItem);
        cmpItem.L := CompInfo.L;
        cmpItem.O := CompInfo.O;
        cmpItem.R := CompInfo.R;
        Env.CmpStack.Add(cmpItem);
        //skip jcc
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      if cmpRes = CMP_BRANCH then
      Begin
        brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
        //Skip conditional branch
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curAdr, instrLen);
        curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
        curPos := Adr2Pos(curAdr);
        continue;
      End
      else if cmpRes = CMP_SET then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulateInstr1(curAdr, frmDisasm.GetOp(DisaInfo.Mnem));
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      continue;
    End
    else if op = OP_AND then
    Begin
      bytesToSkip := IsInlineMod(curAdr, _mod);
      if bytesToSkip<>0 then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        item.Precedence := PRECEDENCE_ATOM;
        item.Value := item.Value + ' mod ' + IntToStr(_mod);
        item._Type := 'Integer';
        SetRegItem(DisaInfo.OpRegIdx[0], item);

        line := GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' := ' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' mod ' + IntToStr(_mod);
        Env.AddToBody(line);
        Inc(curPos, bytesToSkip); 
        Inc(curAdr, bytesToSkip);
        continue;
      End;
      cmpRes := GetCmpInfo(curAdr + instrLen);
      SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      if cmpRes = CMP_FAILED then continue;
      if CF_BJL in flags then
      Begin
        New(cmpItem);
        cmpItem.L := CompInfo.L;
        cmpItem.O := CompInfo.O;
        cmpItem.R := CompInfo.R;
        Env.CmpStack.Add(cmpItem);
        //skip jcc
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      if cmpRes = CMP_BRANCH then
      Begin
        brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
        //Skip conditional branch
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curAdr, instrLen);
        curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
        curPos := Adr2Pos(curAdr);
        continue;
      End
      else if cmpRes = CMP_SET then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulateInstr1(curAdr, frmDisasm.GetOp(DisaInfo.Mnem));
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      continue;
    End
    else if op = OP_OR then
    Begin
      cmpRes := GetCmpInfo(curAdr + instrLen);
      SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      if cmpRes = CMP_FAILED then continue;
      if CF_BJL in flags then
      Begin
        New(cmpItem);
        cmpItem.L := CompInfo.L;
        cmpItem.O := CompInfo.O;
        cmpItem.R := CompInfo.R;
        Env.CmpStack.Add(cmpItem);
        //skip jcc
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      if cmpRes = CMP_BRANCH then
      Begin
        brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
        //Skip conditional branch
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curAdr, instrLen);
        curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
        curPos := Adr2Pos(curAdr);
        continue;
      End
      else if cmpRes = CMP_SET then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulateInstr1(curAdr, frmDisasm.GetOp(DisaInfo.Mnem));
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      continue;
    End
    else if (op = OP_ADC) or (op = OP_SBB) then
    Begin
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End
    else if (op = OP_SAL) or (op = OP_SHL) then
    Begin
      bytesToSkip := IsInt64Shl(curAdr);
      if bytesToSkip<>0 then
      Begin
        DisaInfo.OpNum := 2;
        DisaInfo.OpType[1] := otIMM;
      End
      else bytesToSkip := instrLen;
      SimulateInstr2(curAdr, op);
      Inc(curPos, bytesToSkip); 
      Inc(curAdr, bytesToSkip);
      continue;
    End
    else if (op = OP_SAR) or (op = OP_SHR) then
    Begin
      bytesToSkip := IsInt64Shr(curAdr);
      if bytesToSkip<>0 then
      Begin
        DisaInfo.OpNum := 2;
        DisaInfo.OpType[1] := otIMM;
      End
      else bytesToSkip := instrLen;
      SimulateInstr2(curAdr, op);
      Inc(curPos, bytesToSkip); 
      Inc(curAdr, bytesToSkip);
      continue;
    End
    else if op = OP_NEG then
    Begin
      SimulateInstr1(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if op = OP_NOT then
    Begin
      SimulateInstr1(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if op = OP_XCHG then
    Begin
      SimulateInstr2(curAdr, op);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if (op = OP_INC) or (op = OP_DEC) then
    Begin
      endAdr := IsGeneralCase(curAdr, Env.StartAdr + Env.Size);
      if endAdr<>0 then
      Begin
        GetRegItem(DisaInfo.OpRegIdx[0], item);
        if item.Value <> '' then
          Env.AddToBody('case ' + item.Value + ' of')
        else
          Env.AddToBody('case ' + GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' of');
        curAdr := DecompileGeneralCase(curAdr, curAdr, loopInfo, 0);
        Env.AddToBody('end');
        //_curAdr := _endAdr;
        curPos := Adr2Pos(curAdr);
        continue;
      End;
      //simulate dec as sub
      DisaInfo.OpNum := 2;
      DisaInfo.OpType[1] := otIMM;
      DisaInfo.Immediate := 1;
      cmpRes := GetCmpInfo(curAdr + instrLen);
      if op = OP_DEC then SimulateInstr2(curAdr, OP_SUB)
        else SimulateInstr2(curAdr, OP_ADD);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      if cmpRes = CMP_FAILED then continue;
      if CF_BJL in flags then
      Begin
        New(cmpItem);
        cmpItem.L := CompInfo.L;
        cmpItem.O := CompInfo.O;
        cmpItem.R := CompInfo.R;
        Env.CmpStack.Add(cmpItem);
        //skip jcc
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      if cmpRes = CMP_BRANCH then
      Begin
        brType := BranchGetPrevInstructionType(CmpAdr, jmpAdr, loopInfo);
        //Skip conditional branch
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, Nil, Nil);
        Inc(curAdr, instrLen);
        curAdr := AnalyzeConditions(brType, curAdr, sAdr, jmpAdr, loopInfo);
        curPos := Adr2Pos(curAdr);
        continue;
      End
      else if cmpRes = CMP_SET then
      Begin
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisaInfo, Nil);
        SimulateInstr1(curAdr, frmDisasm.GetOp(DisaInfo.Mnem));
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      continue;
    End
    else if (op = OP_DIV) or (op = OP_IDIV) then
    Begin
      if DisaInfo.OpNum = 2 then
      Begin
        SimulateInstr2(curAdr, op);
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
    End
    else if (op = OP_MUL) or (op = OP_IMUL) then
    Begin
      bytesToSkip := IsIntOver(curAdr + instrLen);
      if DisaInfo.OpNum in [1..3] then
      begin
        case DisaInfo.OpNum of
          1: SimulateInstr1(curAdr, op);
          2: SimulateInstr2(curAdr, op);
          3: SimulateInstr3(curAdr, op);
        end;
        Inc(curPos, instrLen + bytesToSkip); 
        Inc(curAdr, instrLen + bytesToSkip);
        continue;
      End;
    End
    else if op = OP_CDQ then
    Begin
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      GetRegItem(16, item);
      bytesToSkip := IsAbs(curAdr);
      if bytesToSkip<>0 then
      Begin
        item.Flags := [IF_CALL_RESULT];
        item.Precedence := PRECEDENCE_ATOM;
        item.Value := 'Abs(' + item.Value + ')';
        item._Type := 'Integer';
        SetRegItem(16, item);
        line := 'EAX := Abs(EAX)';
        comment := item.Value;
        Env.AddToBody(line + '; //' + comment);
        Inc(curPos, bytesToSkip); 
        Inc(curAdr, bytesToSkip);
      End;
      SetRegItem(18, item);//Set edx to eax
      continue;
    End
    else if op = OP_MOVS then
    Begin
      GetRegItem(23, item1);//edi
      GetRegItem(22, item2);//esi
      //.lvar
      if IF_STACK_PTR in item1.Flags then
      Begin
        if item1._Type <> '' then
          typeName := item1._Type
        else
          typeName := item2._Type;
        kind := GetTypeKind(typeName, _size);
        if kind = ikRecord then
        Begin
          _size := GetRecordSize(typeName);
          for r := 0 to _size-1 do
          Begin
            if item1.IntValue + r >= Env.StackSize then
            Begin
              Env.ErrAdr := curAdr;
              raise Exception.Create('Possibly incorrect RecordSize (or incorrect type of record)');
            End;
            item := Env.Stack[item1.IntValue + r];
            item.Flags := [IF_FIELD];
            item.Offset := r;
            item._Type := '';
            if r = 0 then item._Type := typeName;
            Env.Stack[item1.IntValue + r] := item;
          End;
        End
        else if kind = ikArray then
        Begin
          _size := GetArraySize(typeName);
          elSize := GetArrayElementTypeSize(typeName);
          typeName := GetArrayElementType(typeName);
          if (_size=0) or (elSize=0) then
          Begin
            Env.ErrAdr := curAdr;
            raise Exception.Create('Possibly incorrect array definition');
          End;
          r:=0;
          while r < _size do 
          Begin
            if item1.IntValue + r >= Env.StackSize then
            Begin
              Env.ErrAdr := curAdr;
              raise Exception.Create('Possibly incorrect array definition');
            End;
            Env.Stack[item1.IntValue + r]._Type := typeName;
            Inc(r, elSize);
          End;
        End;
        Env.AddToBody(Env.GetLvarName(item1.IntValue) + ' := ' + item2.Value + ';');
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      //lvar.
      if IF_STACK_PTR in item2.Flags then
      Begin
        if item2._Type <> '' then
          typeName := item2._Type
        else
          typeName := item1._Type;
        kind := GetTypeKind(typeName, _size);
        if kind = ikRecord then
        Begin
          _size := GetRecordSize(typeName);
          for r := 0 to _size-1 do
          Begin
            if item2.IntValue + r >= Env.StackSize then
            Begin
              Env.ErrAdr := curAdr;
              raise Exception.Create('Possibly incorrect RecordSize (or incorrect type of record)');
            End;
            item := Env.Stack[item2.IntValue + r];
            item.Flags := [IF_FIELD];
            item.Offset := r;
            item._Type := '';
            if r = 0 then item._Type := typeName;
            Env.Stack[item2.IntValue + r] := item;
          End;
        End
        else if kind = ikArray then
        Begin
          _size := GetArraySize(typeName);
          elSize := GetArrayElementTypeSize(typeName);
          typeName := GetArrayElementType(typeName);
          if (_size=0) or (elSize=0) then
          Begin
            Env.ErrAdr := curAdr;
            raise Exception.Create('Possibly incorrect array definition');
          End;
          r:=0;
          while r < _size do 
          Begin
            if item1.IntValue + r >= Env.StackSize then
            Begin
              Env.ErrAdr := curAdr;
              raise Exception.Create('Possibly incorrect array definition');
            End;
            Env.Stack[item1.IntValue + r]._Type := typeName;
            Inc(r, elSize);
          End;
        End;
        Env.AddToBody(item1.Value + ' := ' + Env.GetLvarName(item2.IntValue) + ';');
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
      if item1.Value <> '' then line := item1.Value
        else line := '_edi_';
      line:=line + ' := ';
      if item2.Value <> '' then line:=line + item2.Value
        else line:=line + '_esi_';
      line:=line + ';';
      Env.AddToBody(line);
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    if DisaInfo.Float then
    Begin
      SimulateFloatInstruction(curAdr, instrLen);
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    Env.ErrAdr := curAdr;
    raise Exception.Create('Still unknown');
  End;
  Result:=curAdr;
end;

Procedure TDecompiler.SimulateInherited (procAdr:Integer);
Begin
  Inc(_ESP_, GetInfoRec(procAdr).procInfo.retBytes);
end;

Function TDecompiler.SimulateCall (curAdr, callAdr:Integer; instrLen:Integer; mtd:PMethodRec; AClassAdr:Integer):Boolean;
var
  sep, fromKB, _vmt:Boolean;
  callKind:Byte;
  kind, retKind, methodKind:LKind;
  pp:PAnsiChar;
  savedIdx,savedStartAdr,savedLocBase,savedSize:Integer;
  argsNum, retBytes, retBytesCalc, len, _val, _esp:Integer;
  r,n,idx, rn, ndx, ss, _pos, _size, recsize:Integer;
  classAdr, adr, dynAdr, vmtAdr:Integer;
  item, item1:TItem;
  aInfo:PArgInfo;
  fInfo:FieldInfo;
  pInfo:MProcInfo;
  recM:PMethodRec;
  recN, recN1:InfoRec;
  pCode:PPICODE;
  de:TDecompiler;
  _name, alias, line, retType, _value, iname, embAdr:AnsiString;
  _typeName, comment, regName,propName:AnsiString;
Begin
  idx:=-1;
  pp := Nil;
  ss := 0;
  _esp:=0;
  retKind:=ikUnknown;
  methodKind:=ikUnknown;
  //call imm
  if IsValidCodeAdr(callAdr) then
  Begin
    recN := GetInfoRec(callAdr);
    _name:=recN.Name;
    //Is it property function (Set, Get, Stored)?
    if Pos('.',_name)<>0 then
      propName := KBase.IsPropFunction(ExtractClassName(_name), ExtractProcName(_name));
    if SameText(_name,'@AbstractError') then
    Begin
      Env.ErrAdr := curAdr;
      raise Exception.Create('Pure Virtual Call');
    End;
    //Import can have no prototype
    if IsFlagSet([cfImport], Adr2Pos(callAdr)) then
    Begin
      if not CheckPrototype(recN) then
      Begin
        Env.AddToBody(recN.Name + '(...); //Import');
        _value := ManualInput(CurProcAdr, curAdr, 'Input the number of RET bytes (in hex) of procedure at ' + Val2Str(curAdr,8), 'Bytes:');
        if _value = '' then
        Begin
          Env.ErrAdr := curAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
        sscanf(PAnsiChar(_value),'%lX',[@retBytes]);
        Inc(_ESP_, retBytes);
        Result:=false;
        Exit;
      End;
    End;
    //@DispInvoke
    if SameText(_name,'@DispInvoke') then
    Begin
      Env.AddToBody('DispInvoke(...);');
      _value := ManualInput(CurProcAdr, curAdr, 'Input the number of RET bytes (in hex) of procedure at ' + Val2Str(curAdr,8), 'Bytes:');
      if _value = '' then
      Begin
        Env.ErrAdr := curAdr;
        raise Exception.Create('Empty input - See you later!');
      End;
      sscanf(PAnsiChar(_value),'%lX',[@retBytes]);
      Inc(_ESP_, retBytes);
      Result:=false;
      Exit;
    End;
    if mtd=Nil then
    Begin
      _name := recN.Name;
      callKind := recN.procInfo.call_kind;
      methodKind := recN.kind;
      if Assigned(recN.procInfo.args) then argsNum := recN.procInfo.args.Count
        else argsNum:=0;
      retType := recN._type;
      fromKB := recN.kbIdx <> -1;
      retBytes := recN.procInfo.retBytes;
      //stdcall, pascal, cdecl - return bytes := 4 * ArgsNum
      if (callKind in [1..3]) and (retBytes=0) then retBytes := argsNum * 4;
      (*
      if (recN.procInfo.flags and PF_EMBED)<>0 then
      Begin
        _embAdr := Val2Str(callAdr,8);
        if Env.EmbeddedList.IndexOf(_embAdr) = -1 then
        Begin
          Env.EmbeddedList.Add(_embAdr);
          _savedIdx := FMain.lbCode.ItemIndex;
          FMain.lbCode.ItemIndex := -1;
          if Application.MessageBox(PAnsiChar('Decompile embedded procedure at address ' + _embAdr + '?'), 'Confirmation', MB_YESNO) = IDYES then
          Begin
            Env.AddToBody('//BEGIN_EMBEDDED_' + _embAdr);
            Env.AddToBody(recN.MakePrototype(callAdr, true, false, false, true, false));
            _savedStartAdr := Env.StartAdr;
            _savedBpBased := Env.BpBased;
            _savedLocBase := Env.LocBase;
            _savedSize := Env.Size;
            Env.StartAdr := callAdr;
            _size := GetProcSize(callAdr);
            Env.Size := _size;
            de := TDecompiler.Create(Env);
            Dec(_ESP_, 4); //ret address
            de.SetStackPointers(Self);
            de.SetStop(callAdr + _size);
            try
              Env.AddToBody('begin');
              de.Decompile(callAdr, 0, Nil);
              Env.AddToBody('end');
              Env.AddToBody('//END_EMBEDDED_' + _embAdr);
            except
              on E:Exception do
              Begin
                de.Free;
                raise Exception.Create('Embedded.' + E.Message);
              End;
            end;
            Inc(_ESP_, 4);
            de.Free;
            Env.StartAdr := _savedStartAdr;
            Env.Size := _savedSize;
            Env.BpBased := _savedBpBased;
            Env.LocBase := _savedLocBase;
          End;
          FMain.lbCode.ItemIndex := _savedIdx;
        End;
      End;
      *)
    End
    else
    Begin
      _name := mtd.name;
      if KBase.GetProcInfo(PAnsiChar(mtd.name), [INFO_DUMP, INFO_ARGS], pInfo, idx) then
      Begin
        callKind := pInfo.CallKind;
        case pInfo.MethodKind of
          'C': methodKind := ikConstructor;
          'D': methodKind := ikDestructor;
          'F': methodKind := ikFunc;
          'P': methodKind := ikProc;
        End;
        if Assigned(pInfo.Args) then argsNum := pInfo.ArgsNum
          else argsNum:=0;
        retType := pInfo.TypeDef;
        pp := pInfo.Args;
        fromKB := true;
        retBytes := GetProcRetBytes(pInfo);
      End
      else
      Begin
        _name := recN.Name;
        callKind := recN.procInfo.call_kind;
        methodKind := recN.kind;
        if Assigned(recN.procInfo.args) then argsNum := recN.procInfo.args.Count
          else argsNum:=0;
        retType := recN._type;
        fromKB := false;
        retBytes := recN.procInfo.retBytes;
      End;
    End;
    //Check prototype
    if not fromKB then
    Begin
      if not CheckPrototype(recN) then
      Begin
        Env.ErrAdr := curAdr;
        if _name <> '' then
          raise Exception.Create('Prototype of ' + _name + ' is not completed')
        else
          raise Exception.Create('Prototype of ' + GetDefaultProcName(callAdr) + ' is not completed');
      End;
    End;
    if _name <> '' then
    Begin
      if _name[1] = '@' then
      Begin
        if SameText(_name, '@CallDynaInst') or
          SameText(_name, '@CallDynaClass') then
        Begin
          recN := GetInfoRec(curAdr);
          if Assigned(recN) then
          Begin
            pcode := recN.pcode;
            if Assigned(pcode) and (pcode.Op = OP_CALL) then
            Begin
              SimulateCall(curAdr, pcode.Offset, instrLen, Nil, 0);
              Result:=false;
              Exit;
            End;
          End
          else
          Begin
            GetRegItem(16, item);
            if DelphiVersion <= 5 then
            Begin
              GetRegItem(11, item1);
              comment := GetDynaInfo(GetClassAdr(item._Type), item1.IntValue, dynAdr);	//bx
            End
            else
            Begin
              GetRegItem(14, item1);
              comment := GetDynaInfo(GetClassAdr(item._Type), item1.IntValue, dynAdr);	//si
            End;
            AddPicode(Adr2Pos(curAdr), OP_CALL, comment, dynAdr);
            SimulateCall(curAdr, dynAdr, instrLen, Nil, 0);
            Result:=false;
            Exit;
          End;
        End;
        alias := GetSysCallAlias(_name);
        if alias = '' then
        Begin
          Result:=SimulateSysCall(_name, curAdr, instrLen);
          Exit;
        End;
        _name := alias;
      End;
      //Some special functions
      if SameText(_name, 'Format') then
      Begin
        SimulateFormatCall;
        Result:=false;
        Exit;
      End;
      if Pos('.',_name)<>0 then line := ExtractProcName(_name)
        else line := _name;
    End
    else line := GetDefaultProcName(callAdr);
    if propName <> '' then line:=line + '{' + propName + '}';
    if methodKind = ikFunc then
    Begin
      while true do
      Begin
        if retType = '' then retKind := ikUnknown
        else
        Begin
          if retType[1] = '^' then retType := GetTypeDeref(retType);
          retKind := GetTypeKind(retType, _size);
        End;
        if retKind<>ikUnknown then break;
        retType := ManualInput(Env.StartAdr, curAdr, 'Define type of function at ' + IntToHex(curAdr, 8), 'Type:');
        if retType = '' then
        Begin
          Env.ErrAdr := curAdr;
          raise Exception.Create('You need to define type of function later');
        End;
      End;
    End;
    retBytesCalc := 0; 
    ndx := 0;
    if argsNum<>0 then
    Begin
      line:=line + '(';
      if callKind in [0..3] then //fastcall, stdcall, pascal, cdecl 
      Begin
        sep := false;
        _esp := _ESP_;
        Inc(_ESP_, retBytes);
        //fastcall, pascal - reverse order of arguments
        if (callKind = 0) or (callKind = 2) then _esp := _ESP_;
        //cdecl - stack restored by caller
        if callKind = 1 then Dec(_ESP_, retBytes);
        for n := 0 to argsNum-1 do
        Begin
          if pp<>Nil then
            FillArgInfo(n, callKind, aInfo, pp, ss)
          else
            aInfo := PARGINFO(recN.procInfo.args[n]);
          rn := -1; 
          regName := '';
          kind := GetTypeKind(aInfo.TypeDef, _size);
          if aInfo.Tag = $22 then _size := 4;
          //else _size := _argInfo.Size;
          if callKind = 0 then //fastcall
          Begin
            if methodKind = ikConstructor then
            Begin
              if ndx <= 1 then
              Begin
                if ndx=0 then
                Begin
                  GetRegItem(16, item);
                  retType := item._Type;
                  retKind := GetTypeKind(retType, _size);
                  line := retType + '.Create(';
                End;
                Inc(ndx);
                continue;
              End;
            End;
            if _size >= 8 then
            Begin
              Dec(_esp, _size);
              item := Env.Stack[_esp];
              item1 := Env.Stack[_esp + 4];
              Inc(retBytesCalc, _size);
            End
            else
            Begin
              //fastcall
              if ndx in [0..2] then
              Begin
                //eax
                if ndx = 0 then
                Begin
                  rn := 16;
                  regName := 'EAX';
                End
                //edx
                else if ndx = 1 then
                Begin
                  rn := 18;
                  regName := 'EDX';
                End
                //ecx
                else
                Begin
                  rn := 17;
                  regName := 'ECX';
                End;
                GetRegItem(rn, item);
                Inc(ndx);
              End
              //stack args
              else
              Begin
                Dec(_esp, aInfo.Size);
                item := Env.Stack[_esp];
                Inc(retBytesCalc, aInfo.Size);
              End;
            End;
          End
          else if (callKind = 3) or (callKind = 1) then //stdcall, cdecl
          Begin
            if _size >= 8 then
            Begin
              item := Env.Stack[_esp];
              item1 := Env.Stack[_esp + 4];
              Inc(_esp, _size);
              Inc(retBytesCalc, _size);
            End
            else
            Begin
              item := Env.Stack[_esp];
              Inc(_esp, aInfo.Size);
              Inc(retBytesCalc, aInfo.Size);
            End;
          End;
          if SameText(aInfo.Name, 'Self') then
          Begin
            if not SameText(item.Value, 'Self') then line := item.Value + '.' + line;
            sep := false;
            continue;
          End;
          if SameText(aInfo.Name, '_Dv__') then
          Begin
            sep := false;
            continue;
          End;
          if sep then line:=line + ', ';
          sep := true;
          if IF_STACK_PTR in item.Flags then
          Begin
            item1 := Env.Stack[item.IntValue];
            if kind = ikInteger then
            Begin
              line:=line + Env.GetLvarName(item.IntValue);
              Env.Stack[item.IntValue].Value := Env.GetLvarName(item.IntValue);
              continue;
            End
            else if kind = ikEnumeration then
            Begin
              line:=line + Env.GetLvarName(item.IntValue);
              Env.Stack[item.IntValue].Value := Env.GetLvarName(item.IntValue);
              continue;
            End
            else if (kind = ikLString) or (kind = ikVariant) then
            Begin
              line:=line + Env.GetLvarName(item.IntValue);
              Env.Stack[item.IntValue].Value := Env.GetLvarName(item.IntValue);
              Env.Stack[item.IntValue]._Type := aInfo.TypeDef;
              continue;
            End
            else if (kind = ikVMT) or (kind = ikClass) then
            Begin
              line:=line + item1.Value;
              continue;
            End
            else if kind = ikArray then
            Begin
              line:=line + Env.GetLvarName(item.IntValue);
              continue;
            End
            else if kind = ikRecord then
            Begin
              line:=line + Env.GetLvarName(item.IntValue);
              recsize := GetRecordSize(aInfo.TypeDef);
              for r := 0 to recsize-1 do
              Begin
                if item.IntValue + r >= Env.StackSize then
                Begin
                  Env.ErrAdr := curAdr;
                  raise Exception.Create('Possibly incorrect RecordSize (or incorrect type of record) '+item.Name);
                End;
                item1 := Env.Stack[item.IntValue + r];
                item1.Flags := [IF_FIELD];
                item1.Offset := r;
                item1._Type := '';
                if r = 0 then item1._Type := aInfo.TypeDef;
                Env.Stack[item.IntValue + r] := item1;
              End;
              continue;
            End;
            //Type not found
            line:=line + Env.GetLvarName(item.IntValue);
            Env.Stack[item.IntValue].Value := Env.GetLvarName(item.IntValue);
            Env.Stack[item.IntValue]._Type := aInfo.TypeDef;
            continue;
          End;
          if kind = ikInteger then
          Begin
            line:=line + item.Value;
            if IF_INTVAL in item.Flags then line:=line + 'Begin' + GetImmString(item.IntValue) + 'End;';
            continue;
          End
          else if kind = ikChar then
          Begin
            line:=line + item.Value;
            if IF_INTVAL in item.Flags then line:=line + 'Begin "' + IntToStr(item.IntValue) + '" End;';
            continue;
          End
          else if kind in [ikLString, ikWString, ikUString, ikCString, ikWCString] then
          Begin
            if item.Value <> '' then line:=line + item.Value
            else
            Begin
              if IF_INTVAL in item.Flags then
              Begin
                if item.IntValue=0 then line:=line + ''''''
                else
                Begin
                  recN1 := GetInfoRec(item.IntValue);
                  if Assigned(recN1) then line:=line + recN1.Name
                  else
                  Begin
                    if kind = ikCString then
                      line:=line + '''' + String(PAnsiChar(Code + Adr2Pos(item.IntValue))) + ''''
                    else if kind = ikLString then
                      line:=line + TransformString(Code + Adr2Pos(item.IntValue), -1)
                    else
                      line:=line + TransformUString(CP_ACP, PWideChar(Code + Adr2Pos(item.IntValue)), -1);
                  End;
                End;
              End;
            End;
            continue;
          End
          else if (kind = ikVMT) or (kind = ikClass) then
          Begin
            if item.Value <> '' then line:=line + item.Value
            else
            Begin
              if (IF_INTVAL in item.Flags) and (item.IntValue=0) then line:=line + 'Nil'
                else line:=line + '?';
            End;
            continue;
          End
          else if kind = ikEnumeration then
          Begin
            if rn <> -1 then line:=line + regName + 'Begin';
            if IF_INTVAL in item.Flags then
              line:=line + GetEnumerationString(aInfo.TypeDef, item.IntValue)
            else if item.Value <> '' then
              line:=line + item.Value;
            if rn <> -1 then line:=line + 'End;';
            continue;
          End
          else if kind = ikSet then
          Begin
            if IF_INTVAL in item.Flags then
            Begin
              if IsValidImageAdr(item.IntValue) then
                line:=line + GetSetString(aInfo.TypeDef, Code + Adr2Pos(item.IntValue))
              else
                line:=line + GetSetString(aInfo.TypeDef, @item.IntValue);
            End
            else line:=line + item.Value;
            continue;
          End
          else if kind = ikRecord then
          Begin
            line:=line + item.Value; //ExtractClassName(_item.Value);
            continue;
          End
          else if kind = ikFloat then
          Begin
            if IF_INTVAL in item.Flags then
            Begin
              GetFloatItemFromStack(_esp, @item, FloatNameToFloatType(aInfo.TypeDef));
              line:=line + item.Value;
            End
            else line:=line + item.Value;
            continue;
          End
          else if kind = ikClassRef then
          Begin
            line:=line + item._Type;
            continue;
          End
          else if kind = ikResString then
          Begin
            line:=line + item.Value;
            continue;
          End
          else if kind = ikPointer then
          Begin
            if (IF_INTVAL in item.Flags) and IsValidImageAdr(item.IntValue) then
            Begin
              recN1 := GetInfoRec(item.IntValue);
              if Assigned(recN1) and (recN1.HasName) then
                line:=line + recN1.Name
              else
                line:=line + 'sub_' + Val2Str(item.IntValue,8);
              continue;
            End;
          End;
          //var
          if aInfo.Tag = $22 then
          Begin
            adr := item.IntValue;
            if IsValidImageAdr(adr) then
            Begin
              recN1 := GetInfoRec(adr);
              if Assigned(recN1) and recN1.HasName  then
                line:=line + recN1.Name
              else
                line:=line + MakeGvarName(adr);
            End
            else line:=line + item.Value;
            continue;
          End;
          if aInfo.Size = 8 then
          Begin
            if SameText(item1.Value, 'Self') then
            Begin
              if (IF_INTVAL in item.Flags) and IsValidImageAdr(item.IntValue) then
              Begin
                recN1 := GetInfoRec(item.IntValue);
                if Assigned(recN1) and recN1.HasName then
                  line:=line + recN1.Name
                else
                  line:=line + 'sub_' + Val2Str(item.IntValue,8);
                continue;
              End;
            End;
            line:=line + item.Value;
            continue;
          End;
          if item.Value <> '' then
            line:=line + item.Value
          else if IF_INTVAL in item.Flags then
            line:=line + IntToStr(item.IntValue)
          else line:=line + '?';
          continue;
        End;
      End;
      len := Length(line);
      if line[len] <> '(' then line:=line + ')'
        else SetLength(line,len - 1);
    End;
    if (methodKind <> ikFunc) and (methodKind <> ikConstructor) then
    Begin
      line:=line + ';';
      if Env.LastResString <> '' then
      Begin
        line:=line + ' //' + QuotedStr(Env.LastResString);
        Env.LastResString := '';
      End;
      Env.AddToBody(line);
    End
    else
    Begin
      if callKind = 0 then //fastcall
      Begin
        if retKind in [ikLString, ikUString, ikRecord, ikArray] then
        Begin
          //eax
          if ndx = 0 then GetRegItem(16, item)
          //edx
          else if ndx = 1 then GetRegItem(18, item)
          //ecx
          else if ndx = 2 then GetRegItem(17, item)
          //last pushed
          else
          Begin
            Dec(_esp, 4);
            item := Env.Stack[_esp];
          End;
          if IF_STACK_PTR in item.Flags then
          Begin
            if item.Name <> '' then
              line := item.Name + ' := ' + line
            else if item.Value <> '' then
              line := item.Value + ' := ' + line
            else
              line := Env.GetLvarName(item.IntValue) + ' := ' + line;
            if retKind = ikRecord then
            Begin
              _size := GetRecordSize(retType);
              for r := 0 to _size-1 do
              Begin
                if item.IntValue + r >= Env.StackSize then
                Begin
                  Env.ErrAdr := curAdr;
                  raise Exception.Create('Possibly incorrect RecordSize (or incorrect type of record) '+item.Name);
                End;
                item1 := Env.Stack[item.IntValue + r];
                item1.Flags := [IF_FIELD];
                item1.Offset := r;
                item1._Type := '';
                if r = 0 then item1._Type := retType;
                Env.Stack[item.IntValue + r] := item1;
              End;
            End;
            Env.Stack[item.IntValue].Flags := [];
            Env.Stack[item.IntValue]._Type := retType;
          End
          else line := item.Value + ' := ' + line;
          line:=line + ';';
          if Env.LastResString <> '' then
          Begin
            line:=line + ' //' + QuotedStr(Env.LastResString);
            Env.LastResString := '';
          End;
          Env.AddToBody(line);
        End
        else if retKind = ikFloat then
        Begin
          InitItem(@item);
          item.Value := line;
          item._Type := retType;
          FPush(@item);
        End
        else
        Begin
          //???__int64
          InitItem(@item);
          item.Precedence := PRECEDENCE_ATOM;
          item.Flags := [IF_CALL_RESULT];
          item.Value := line;
          item._Type := retType;
          SetRegItem(16, item);
          line:=line + ';';
          if Env.LastResString <> '' then
          Begin
            line:=line + ' //' + QuotedStr(Env.LastResString);
            Env.LastResString := '';
          End;
          Env.AddToBody('EAX := ' + line);
        End;
      End
      else if (callKind = 3) or (callKind = 1) then //stdcall, cdecl
      Begin
        InitItem(@item);
        item.Precedence := PRECEDENCE_ATOM;
        item.Flags := [IF_CALL_RESULT];
        item.Value := line;
        item._Type := retType;
        SetRegItem(16, item);
        line:=line + ';';
        Env.AddToBody('EAX := ' + line);
      End;
    End;
    if (callKind = 3) and (retBytesCalc <> retBytes) then
    Begin
      Env.ErrAdr := curAdr;
      raise Exception.Create('Incorrect number of return bytes!');
    End;
    //_ESP_ +:= _retBytes;
    Result:=false;
    Exit;
  End;
  //call [reg+N]
  if DisaInfo.BaseReg <> -1 then
  Begin
    //esp
    if DisaInfo.BaseReg = 20 then
    Begin
      item := Env.Stack[_ESP_ + DisaInfo.Offset];
      line := Env.GetLvarName(_ESP_ + DisaInfo.Offset) + '(...);';
      Env.AddToBody(line);
      _value := ManualInput(CurProcAdr, curAdr, 'Enter number of RET bytes (in hex) of procedure at ' + Val2Str(curAdr,8), 'Bytes:');
      if _value = '' then
      Begin
        Env.ErrAdr := curAdr;
        raise Exception.Create('Empty input - See you later!');
      End;
      sscanf(PAnsiChar(_value),'%lX',[@retBytes]);
      Inc(_ESP_, retBytes);
      Result:=false;
      Exit;
    End;
    GetRegItem(DisaInfo.BaseReg, item);
    classAdr := 0;
    //if SameText(_item.Value, 'Self') then
    //Begin
    //  Env.ErrAdr := curAdr;
    //  raise Exception.Create('Under construction');
    //End;
    if item._Type <> '' then classAdr := GetClassAdr(item._Type);
    if IF_VMT_ADR in item.Flags then classAdr := item.IntValue;
    if IsValidImageAdr(classAdr) then
    Begin
      //Interface
      if IF_INTERFACE in item.Flags then
      Begin
        Env.AddToBody(item.Value + '.I' + IntToStr(DisaInfo.Offset) + '(...);');
        _value := ManualInput(CurProcAdr, curAdr, 'Enter number of RET bytes (in hex) of procedure at ' + Val2Str(curAdr,8), 'Bytes:');
        if _value = '' then
        Begin
          Env.ErrAdr := curAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
        sscanf(PAnsiChar(_value),'%lX',[@retBytes]);
        Inc(_ESP_, retBytes);
        Result:=false;
        Exit;
      End;
      //Method
      recM := FMain.GetMethodInfo(classAdr, 'V', DisaInfo.Offset);
      if Assigned(recM) then
      Begin
        callAdr := PInteger(Code + Adr2Pos(classAdr) - VmtSelfPtr + DisaInfo.Offset)^;
        if recM._abstract then
        Begin
          classAdr := GetChildAdr(classAdr);
          callAdr := PInteger(Code + Adr2Pos(classAdr) - VmtSelfPtr + DisaInfo.Offset)^;
        End;
        if recM.name <> '' then
          Result:=SimulateCall(curAdr, callAdr, instrLen, recM, classAdr)
        else
          Result:=SimulateCall(curAdr, callAdr, instrLen, Nil, classAdr);
        Exit;
      End;
      //Field
      fInfo := FMain.GetField(item._Type, DisaInfo.Offset, _vmt, vmtAdr);
      if fInfo=Nil then
      Begin
        while recM=Nil do
        Begin
          _typeName := ManualInput(CurProcAdr, curAdr, 'Class ' + item._Type + ' has no such virtual method. Give correct class name', 'Name:');
          if _typeName = '' then
          Begin
            Env.ErrAdr := curAdr;
            raise Exception.Create('Possibly incorrect class (has no such virtual method)');
          End;
          classAdr := GetClassAdr(_typeName);
          recM := FMain.GetMethodInfo(classAdr, 'V', DisaInfo.Offset);
        End;
        callAdr := PInteger(Code + Adr2Pos(classAdr) - VmtSelfPtr + DisaInfo.Offset)^;
        if recM._abstract then
        Begin
          classAdr := GetChildAdr(classAdr);
          callAdr := PInteger(Code + Adr2Pos(classAdr) - VmtSelfPtr + DisaInfo.Offset)^;
        End;
        if recM.name <> '' then
          Result:=SimulateCall(curAdr, callAdr, instrLen, recM, classAdr)
        else
          Result:=SimulateCall(curAdr, callAdr, instrLen, Nil, classAdr);
        Exit;
      End
      else
      Begin
        if fInfo.Name <> '' then
          Env.AddToBody(fInfo.Name + '(...);')
        else
          Env.AddToBody('f' + Val2Str(DisaInfo.Offset) + '(...);');
        _value := ManualInput(CurProcAdr, curAdr, 'Enter number of RET bytes (in hex) of procedure at ' + Val2Str(curAdr,8), 'Bytes:');
        if _value = '' then
        Begin
          Env.ErrAdr := curAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
        sscanf(PAnsiChar(_value),'%lX',[@retBytes]);
        Inc(_ESP_, retBytes);
        Result:=false;
        Exit;
      End;
    End;
    if IF_STACK_PTR in item.Flags then
    Begin
      item := Env.Stack[item.IntValue + DisaInfo.Offset];
      line := item.Value + ';';
      Env.AddToBody(line);
      _value := ManualInput(CurProcAdr, curAdr, 'Enter number of RET bytes (in hex) of procedure at ' + Val2Str(curAdr,8), 'Bytes:');
      if _value = '' then
      Begin
        Env.ErrAdr := curAdr;
        raise Exception.Create('Emptry input - See you later!');
      End;
      sscanf(PAnsiChar(_value),'%lX',[@retBytes]);
      Inc(_ESP_, retBytes);
      Result:=false;
      Exit;
    End;
  End;
  //call reg
  if (DisaInfo.OpNum = 1) and (DisaInfo.OpType[0] = otREG) then
  Begin
    GetRegItem(DisaInfo.OpRegIdx[0], item);
    line := item.Value + ';';
    Env.AddToBody(line);
    _value := ManualInput(CurProcAdr, curAdr, 'Enter number of RET bytes (in hex) of procedure at ' + Val2Str(curAdr,8), 'Bytes:');
    if _value = '' then
    Begin
      Env.ErrAdr := curAdr;
      raise Exception.Create('Emptry input - See you later!');
    End;
    sscanf(PAnsiChar(_value),'%lX',[@retBytes]);
    Inc(_ESP_, retBytes);
    Result:=false;
    Exit;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

Function TDecompiler.GetCmpInfo (fromAdr:Integer):Integer;
var
  op:Byte;
  b:Char;
  curAdr,curPos:Integer;
  _disInfo:TDisInfo;
Begin
  curAdr:=fromAdr;
  curPos := Adr2Pos(curAdr);
  CmpAdr := 0;
  frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
  if _disInfo.Conditional and IsValidCodeAdr(_disInfo.Immediate) then
  begin
    b := Code[curPos];
    if b = #15 then b := Code[curPos + 1];
    b := Chr((Ord(b) and 15) + Ord('A'));
    if (b = 'A') or (b = 'B') then
    Begin
      Result:=CMP_FAILED;
      Exit;
    End;
    CmpAdr := _disInfo.Immediate;
    CmpOp := b;
    Result:=CMP_BRANCH;
    Exit;
  end;
  op := frmDisasm.GetOp(_disInfo.Mnem);
  if op = OP_SET then
  begin
    CmpAdr := 0;
    b := Code[curPos + 1];
    CmpOp := Chr((Ord(b) and 15) + Ord('A'));
    Result:=CMP_SET;
    Exit;
  End;
  Result:=CMP_FAILED;
end;

//"for" cycle types
//1 - for I := C1 to C2
//2 - for I := 0 to N
//3 - for I := 1 to N
//4 - for I := C to N
//5 - for I := N to C
//6 - for I ;= N1 to N2
//7 - for I := C1 downto C2
//8 - for I := 0 downto N
//9 - for I := C downto N
//10 - for I := N downto C
//11 - for I := N1 downto N2
Function TDecompiler.GetLoopInfo (fromAdr:Integer):TLoopInfo;
var
  noVar, down, bWhile:Boolean;
  op:BYTE;
  kind:LKind;
  instrLen, _pos, pos1, fromPos, intTo, idx, idxVal:Integer;
  n,maxAdr, brkAdr, lastAdr, stopAdr,_size:Integer;
  recN:InfoRec;
  recX:PXrefRec;
  _disInfo:TDisInfo;
  dd,dd1,from, _to, cnt:AnsiString;
  item:TItem;
  varIdxInfo, cntIdxInfo:IdxInfo;
Begin
  fromPos := Adr2Pos(fromAdr);
  pos1 := GetNearestUpInstruction(fromPos);
  frmDisasm.Disassemble(Code + pos1, Pos2Adr(pos1), @_disInfo, Nil);
  dd := _disInfo.Mnem;
  if dd = 'jmp' then bWhile := true;
  recN := GetInfoRec(fromAdr);
  if Assigned(recN) and Assigned(recN.xrefs) then
  Begin
    maxAdr := 0;
    for n := 0 to recN.xrefs.Count-1 do
    Begin
      recX := PXrefRec(recN.xrefs[n]);
      if recX.adr + recX.offset > maxAdr then maxAdr := recX.adr + recX.offset;
    End;
    //Instruction at maxAdr
    instrLen := frmDisasm.Disassemble(Code + Adr2Pos(maxAdr), maxAdr, @_disInfo, Nil);
    brkAdr := maxAdr + instrLen;
    lastAdr := maxAdr;
    if bWhile then
    Begin
      Result:= TLoopInfo.Create('W', fromAdr, brkAdr, lastAdr); //while
      Exit;
    End;
    dd := _disInfo.Mnem;
    if dd = 'jmp' then
    Begin
      Result := TLoopInfo.Create('T', fromAdr, brkAdr, lastAdr); //while true
      result.whileInfo := TWhileInfo.Create(true);
      Exit;
    End;
    //First instruction before maxAdr
    pos1 := GetNearestUpInstruction(Adr2Pos(maxAdr), fromPos);
    frmDisasm.Disassemble(Code + pos1, Pos2Adr(pos1), @_disInfo, Nil);
    dd1 := _disInfo.Mnem;
    //cmp reg/mem, imm
    if (dd1 = 'cmp') and (_disInfo.OpType[1] = otIMM) then
    Begin
      noVar := false;
      GetCycleIdx(@varIdxInfo, _disInfo);
      intTo := _disInfo.Immediate;
      //Find mov reg/mem,...
      _pos := fromPos;
      while true do
      Begin
        _pos := GetNearestUpInstruction(_pos);
        instrLen := frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos), @_disInfo, Nil);
        if _disInfo.Branch or IsFlagSet([cfProcStart], _pos) then
        Begin
          Result := TLoopInfo.Create('R', fromAdr, brkAdr, lastAdr); //repeat
          Exit;
        End;
        op := frmDisasm.GetOp(_disInfo.Mnem);
        if (op = OP_MOV) or (op = OP_XOR) then
        Begin
          if (varIdxInfo.IdxType = itREG) and (_disInfo.OpType[0] = otREG) 
            and IsSameRegister(_disInfo.OpRegIdx[0], varIdxInfo.IdxValue) then
          Begin
            GetRegItem(varIdxInfo.IdxValue, item);
            if IF_INTVAL in item.Flags then
            Begin
              from := IntToStr(item.IntValue);
              Exclude(item.Flags, IF_INTVAL);
            End
            else from := item.Value;
            item.Value := GetDecompilerRegisterName(varIdxInfo.IdxValue);
            SetRegItem(varIdxInfo.IdxValue, item);
            break;
          End;
          if (varIdxInfo.IdxType = itLVAR) and (_disInfo.OpType[0] = otMEM) then
          Begin
            if _disInfo.BaseReg = 21 then //[ebp-N]
            Begin
              GetRegItem(_disInfo.BaseReg, item);
              if item.IntValue + _disInfo.Offset = varIdxInfo.IdxValue then
              Begin
                if IF_INTVAL in Env.Stack[varIdxInfo.IdxValue].Flags then
                  from := IntToStr(Env.Stack[varIdxInfo.IdxValue].IntValue)
                else
                  from := Env.Stack[varIdxInfo.IdxValue].Value;
                Env.Stack[varIdxInfo.IdxValue].Value := Env.GetLvarName(varIdxInfo.IdxValue);
                break;
              End;
            End;
            if _disInfo.BaseReg = 20 then //[esp+N]
            Begin
              if _ESP_ + _disInfo.Offset = varIdxInfo.IdxValue then
              Begin
                if IF_INTVAL in Env.Stack[varIdxInfo.IdxValue].Flags then
                  from := IntToStr(Env.Stack[varIdxInfo.IdxValue].IntValue)
                else
                  from := Env.Stack[varIdxInfo.IdxValue].Value;
                Env.Stack[varIdxInfo.IdxValue].Value := Env.GetLvarName(varIdxInfo.IdxValue);
                break;
              End;
            End;
          End;
        End;
      End;
      //Find array elements
      Inc(_pos, instrLen);
      while true do
      Begin
        if _pos = fromPos then break;
        instrLen := frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos), @_disInfo, Nil);
        op := frmDisasm.GetOp(_disInfo.Mnem);
        //lea reg, mem
        if (op = OP_LEA) and (_disInfo.OpType[1] = otMEM) then
        Begin
          idx := _disInfo.OpRegIdx[0];
          GetRegItem(idx, item);
          Include(item.Flags, IF_ARRAY_PTR);
          SetRegItem(idx, item);
          Inc(_pos, instrLen);
          continue;
        End;
        //mov reg, esp
        if (op = OP_MOV) and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otREG) and (_disInfo.OpRegIdx[1] = 20) then
        Begin
          idx := _disInfo.OpRegIdx[0];
          GetRegItem(idx, item);
          Include(item.Flags, IF_ARRAY_PTR);
          SetRegItem(idx, item);
          Inc(_pos, instrLen);
          continue;
        End;
        //mov
        if op = OP_MOV then
        Begin
          if (_disInfo.OpType[1] = otIMM) and IsValidImageAdr(_disInfo.Immediate) then
          Begin
            if _disInfo.OpType[0] = otREG then
            Begin
              GetRegItem(_disInfo.OpRegIdx[0], item);
              Include(item.Flags, IF_ARRAY_PTR);
              SetRegItem(_disInfo.OpRegIdx[0], item);
            End;
            if _disInfo.OpType[0] = otMEM then
            Begin
              if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
              Begin
                if _disInfo.BaseReg = 21 then //[ebp-N]
                Begin
                  GetRegItem(_disInfo.BaseReg, item);
                  idxVal := item.IntValue + _disInfo.Offset;
                End
                else //[esp-N]
                Begin
                  idxVal := _ESP_ + _disInfo.Offset;
                End;
                Include(Env.Stack[idxVal].Flags, IF_ARRAY_PTR);
              End;
            End;
          End
          else if _disInfo.OpType[1] = otREG then
          Begin
            GetRegItem(_disInfo.OpRegIdx[1], item);
            if IF_ARRAY_PTR in item.Flags then
            Begin
              if _disInfo.OpType[0] = otREG then
              Begin
                GetRegItem(_disInfo.OpRegIdx[0], item);
                Include(item.Flags, IF_ARRAY_PTR);
                SetRegItem(_disInfo.OpRegIdx[0], item);
              End
              else if _disInfo.OpType[0] = otMEM then
              Begin
                if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
                Begin
                  if _disInfo.BaseReg = 21 then //[ebp-N]
                  Begin
                    GetRegItem(_disInfo.BaseReg, item);
                    idxVal := item.IntValue + _disInfo.Offset;
                  End
                  else idxVal := _ESP_ + _disInfo.Offset; //[esp-N]
                  Include(Env.Stack[idxVal].Flags, IF_ARRAY_PTR);
                End;
              End;
            End;
          End
          else if _disInfo.OpType[1] = otMEM then
          Begin
            if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
            Begin
              if _disInfo.BaseReg = 21 then //[ebp-N]
              Begin
                GetRegItem(_disInfo.BaseReg, item);
                idxVal := item.IntValue + _disInfo.Offset;
              End
              else //[esp-N]
              Begin
                idxVal := _ESP_ + _disInfo.Offset;
              End;
              if IF_ARRAY_PTR in Env.Stack[idxVal].Flags then
              Begin
                GetRegItem(_disInfo.OpRegIdx[0], item);
                Include(item.Flags, IF_ARRAY_PTR);
                SetRegItem(_disInfo.OpRegIdx[0], item);
              End;
            End;
          End;
        End;
        Inc(_pos, instrLen);
      End;
      //4
      _pos := Adr2Pos(maxAdr); 
      stopAdr := brkAdr;
      _pos := GetNearestUpInstruction(_pos);
      while true do
      Begin
        _pos := GetNearestUpInstruction(_pos);
        frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos), @_disInfo, Nil);
        dd := _disInfo.Mnem;
        if (dd = 'inc') or (dd = 'dec') or (dd = 'add') or (dd = 'sub') then
        Begin
          if _disInfo.OpType[0] = otREG then
          Begin
            GetRegItem(_disInfo.OpRegIdx[0], item);
            if IF_ARRAY_PTR in item.Flags then
            Begin
              stopAdr := Pos2Adr(_pos);
              continue;
            End;
            if (varIdxInfo.IdxType = itREG) and IsSameRegister(_disInfo.OpRegIdx[0], varIdxInfo.IdxValue) then
            Begin
              if dd = 'dec' then down := true;
              stopAdr := Pos2Adr(_pos);
            End;
            break;
          End
          else if _disInfo.OpType[0] = otMEM then
          Begin
            if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
            Begin
              if _disInfo.BaseReg = 21 then //[ebp-N]
              Begin
                GetRegItem(_disInfo.BaseReg, item);
                idxVal := item.IntValue + _disInfo.Offset;
              End
              else //[esp-N]
              Begin
                idxVal := _ESP_ + _disInfo.Offset;
              End;
              if IF_ARRAY_PTR in Env.Stack[idxVal].Flags then
              Begin
                stopAdr := Pos2Adr(_pos);
                continue;
              End;
              if (varIdxInfo.IdxType = itLVAR) and (varIdxInfo.IdxValue = idxVal) then
              Begin
                if dd = 'dec' then down := true;
                stopAdr := Pos2Adr(_pos);
              End;
            End;
            break;
          End;
        End;
        break;
      End;
      Result := TLoopInfo.Create('F', fromAdr, brkAdr, lastAdr); //for
      if not down then _to := IntToStr(intTo - 1)
        else _to := IntToStr(intTo + 1);
      result.forInfo := TForInfo.Create(noVar, down, stopAdr, from, _to, varIdxInfo.IdxType, varIdxInfo.IdxValue, 255, 255);
      Exit;
    End;
    if (dd1 = 'inc') or (dd1 = 'dec') then
    Begin
      from := '1';
      //1
      GetCycleIdx(@cntIdxInfo, _disInfo);
      if _disInfo.OpType[0] = otREG then
      Begin
        GetRegItem(_disInfo.OpRegIdx[0], item);
        if IF_INTVAL in item.Flags then
          cnt := IntToStr(item.IntValue)
        else if item.Value1 <> '' then
          cnt := item.Value1
        else
          cnt := item.Value;
      End
      else if _disInfo.OpType[0] = otMEM then
      Begin
        GetRegItem(_disInfo.BaseReg, item);
        if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
        Begin
          if _disInfo.BaseReg = 21 then //[ebp-N]
            item := Env.Stack[item.IntValue + _disInfo.Offset]
          else //[esp-N]
            item := Env.Stack[_ESP_ + _disInfo.Offset];
          if IF_INTVAL in item.Flags then
            cnt := IntToStr(item.IntValue)
          else
            cnt := item.Value;
        End;
      End;
      //2
      _pos := fromPos;
      while true do
      Begin
        _pos := GetNearestUpInstruction(_pos);
        instrLen := frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos), @_disInfo, Nil);
        if SameText(cntIdxInfo.IdxStr, _disInfo.Op1) then break;
      End;
      //3
      Inc(_pos, instrLen);
      while true do
      Begin
        if _pos = fromPos then break;
        instrLen := frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos), @_disInfo, Nil);
        op := frmDisasm.GetOp(_disInfo.Mnem);
        //lea reg1, mem
        if (op = OP_LEA) and (_disInfo.OpType[1] = otMEM) then
        Begin
          idx := _disInfo.OpRegIdx[0];
          GetRegItem(idx, item);
          Include(item.Flags, IF_ARRAY_PTR);
          SetRegItem(idx, item);
          Inc(_pos, instrLen);
          continue;
        End;
        //mov reg, esp
        if (op = OP_MOV) and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otREG) and (_disInfo.OpRegIdx[1] = 20) then
        Begin
          idx := _disInfo.OpRegIdx[0];
          GetRegItem(idx, item);
          Include(item.Flags, IF_ARRAY_PTR);
          SetRegItem(idx, item);
          Inc(_pos, instrLen);
          continue;
        End;
        if op = OP_MOV then
        Begin
          if _disInfo.OpType[1] = otIMM then
          Begin
            if not IsValidImageAdr(_disInfo.Immediate) then
            Begin
              GetCycleIdx(@varIdxInfo, _disInfo);
              noVar := false;
            End
            else
            Begin
              if _disInfo.OpType[0] = otREG then
              Begin
                GetRegItem(_disInfo.OpRegIdx[0], item);
                Include(item.Flags, IF_ARRAY_PTR);
                SetRegItem(_disInfo.OpRegIdx[0], item);
              End
              else //otMEM
              Begin
                if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
                Begin
                  if _disInfo.BaseReg = 21 then //[ebp-N]
                  Begin
                    GetRegItem(_disInfo.BaseReg, item);
                    idxVal := item.IntValue + _disInfo.Offset;
                  End
                  else idxVal := _ESP_ + _disInfo.Offset; //[esp-N]
                  Include(Env.Stack[idxVal].Flags, IF_ARRAY_PTR);
                End;
              End;
            End;
          End
          else if _disInfo.OpType[1] = otREG then
          Begin
            GetRegItem(_disInfo.OpRegIdx[1], item);
            kind := GetTypeKind(item._Type, _size);
            if (IF_ARRAY_PTR in item.Flags) or (kind in [ikArray, ikDynArray]) then
            Begin
              if _disInfo.OpType[0] = otREG then
              Begin
                GetRegItem(_disInfo.OpRegIdx[0], item);
                Include(item.Flags, IF_ARRAY_PTR);
                SetRegItem(_disInfo.OpRegIdx[0], item);
              End
              else //otMEM
              Begin
                if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
                Begin
                  if _disInfo.BaseReg = 21 then //[ebp-N]
                  Begin
                    GetRegItem(_disInfo.BaseReg, item);
                    idxVal := item.IntValue + _disInfo.Offset;
                  End
                  else idxVal := _ESP_ + _disInfo.Offset; //[esp-N]
                  Include(Env.Stack[idxVal].Flags, IF_ARRAY_PTR);
                End;
              End;
            End
            else
            Begin
              GetCycleIdx(@varIdxInfo, _disInfo);
              noVar := false;
            End;
          End
          else if _disInfo.OpType[1] = otMEM then
          Begin
            //??????not not not not not not 
            if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
            Begin
              if _disInfo.BaseReg = 21 then //[ebp-N]
              Begin
                GetRegItem(_disInfo.BaseReg, item);
                idxVal := item.IntValue + _disInfo.Offset;
              End
              else //[esp-N]
                idxVal := _ESP_ + _disInfo.Offset;
              item := Env.Stack[idxVal];
              if IF_VAR in item.Flags then
              Begin
                GetRegItem(_disInfo.OpRegIdx[0], item);
                Include(item.Flags, IF_ARRAY_PTR);
                SetRegItem(_disInfo.OpRegIdx[0], item);
                Inc(_pos, instrLen);
                continue;
              End;
              if Not (IF_ARRAY_PTR in item.Flags) then
              Begin
                GetCycleIdx(@varIdxInfo, _disInfo);
                noVar := false;
              End;
            End;
          End;
        End;
        Inc(_pos, instrLen);
      End;
      //4
      _pos := GetNearestUpInstruction(Adr2Pos(maxAdr)); 
      stopAdr := Pos2Adr(_pos);
      while true do
      Begin
        _pos := GetNearestUpInstruction(_pos);
        frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos), @_disInfo, Nil);
        dd := _disInfo.Mnem;
        if (dd = 'inc') or (dd = 'dec') or (dd = 'add') or (dd = 'sub') then
        Begin
          if _disInfo.OpType[0] = otREG then
          Begin
            GetRegItem(_disInfo.OpRegIdx[0], item);
            if IF_ARRAY_PTR in item.Flags then
            Begin
              stopAdr := Pos2Adr(_pos);
              continue;
            End;
            if noVar then
            Begin
              GetCycleIdx(@varIdxInfo, _disInfo);
              if IF_INTVAL in item.Flags then
              Begin
                from := IntToStr(item.IntValue);
                Exclude(item.Flags, IF_INTVAL);
              End
              else from := item.Value;
              stopAdr := Pos2Adr(_pos);
            End
            else if (varIdxInfo.IdxType = itREG) and IsSameRegister(_disInfo.OpRegIdx[0], varIdxInfo.IdxValue) then
            Begin
              if dd = 'dec' then down := true;
              stopAdr := Pos2Adr(_pos);
            End;
            break;
          End
          else if _disInfo.OpType[0] = otMEM then
            if (_disInfo.BaseReg = 21) or (_disInfo.BaseReg = 20) then
            Begin
              if _disInfo.BaseReg = 21 then //[ebp-N]
              Begin
                GetRegItem(_disInfo.BaseReg, item);
                idxVal := item.IntValue + _disInfo.Offset;
              End
              else //[esp-N]
                idxVal := _ESP_ + _disInfo.Offset;
              item := Env.Stack[idxVal];
              if IF_ARRAY_PTR in item.Flags then
              Begin
                stopAdr := Pos2Adr(_pos);
                continue;
              End;
              if not noVar and (varIdxInfo.IdxType = itLVAR) and (varIdxInfo.IdxValue = idxVal) then
              Begin
                if dd = 'dec' then down := true;
                stopAdr := Pos2Adr(_pos);
              End;
              break;
            End;
        End;
        break;
      End;
      //from, to
      if noVar then
      Begin
        //from := '1';
        if cntIdxInfo.IdxType = itREG then
        Begin
          if SameText(from, '1') then _to := cnt
            else _to := cnt + ' + ' + from + ' - 1';
          GetRegItem(cntIdxInfo.IdxValue, item);
          if IF_INTVAL in item.Flags then
          Begin
            //_to := IntToStr(item.IntValue);
            Exclude(item.Flags, IF_INTVAL);
          End;
          //else _to := item.Value;
          item.Value := GetDecompilerRegisterName(cntIdxInfo.IdxValue);
          SetRegItem(cntIdxInfo.IdxValue, item);
        End
        else if cntIdxInfo.IdxType = itLVAR then
        Begin
          item := Env.Stack[cntIdxInfo.IdxValue];
          if IF_INTVAL in item.Flags then
          Begin
            //_to := IntToStr(item.IntValue);
            Exclude(item.Flags, IF_INTVAL);
          End;
          //else _to := item.Value;
          item.Value := Env.GetLvarName(cntIdxInfo.IdxValue);
          Env.Stack[cntIdxInfo.IdxValue] := item;
        End;
      End
      else
      Begin
        if varIdxInfo.IdxType = itREG then
        Begin
          GetRegItem(varIdxInfo.IdxValue, item);
          if IF_INTVAL in item.Flags then
          Begin
            if from = '' then from := IntToStr(item.IntValue);
            Exclude(item.Flags, IF_INTVAL);
          End
          else if from = '' then from := item.Value;
          item.Value := GetDecompilerRegisterName(varIdxInfo.IdxValue);
          Include(item.Flags, IF_CYCLE_VAR);
          SetRegItem(varIdxInfo.IdxValue, item);
        End
        else if varIdxInfo.IdxType = itLVAR then
        Begin
          item := Env.Stack[varIdxInfo.IdxValue];
          from := item.Value1;
          item.Value := Env.GetLvarName(varIdxInfo.IdxValue);
          Include(item.Flags, IF_CYCLE_VAR);
          Env.Stack[varIdxInfo.IdxValue] := item;
        End;
        if cntIdxInfo.IdxType = itREG then
        Begin
          GetRegItem(cntIdxInfo.IdxValue, item);
          if IF_INTVAL in item.Flags then
          Begin
            if cnt = '' then cnt := IntToStr(item.IntValue);
            Exclude(item.Flags, IF_INTVAL);
          End
          else if cnt = '' then cnt := item.Value;
          item.Value := GetDecompilerRegisterName(cntIdxInfo.IdxValue);
          SetRegItem(cntIdxInfo.IdxValue, item);
        End
        else if cntIdxInfo.IdxType = itLVAR then
        Begin
          cnt := Env.Stack[cntIdxInfo.IdxValue].Value;
          Env.Stack[cntIdxInfo.IdxValue].Value := Env.GetLvarName(cntIdxInfo.IdxValue);
        End;
        if SameText(from, '1') then _to := cnt
        else if SameText(from, '0') then _to := cnt + ' - 1'
        else _to := cnt + ' + ' + from + ' - 1';
      End;
      Result := TLoopInfo.Create('F', fromAdr, brkAdr, lastAdr); //for
      Result.forInfo := TForInfo.Create(noVar, false, stopAdr, from, _to, varIdxInfo.IdxType, varIdxInfo.IdxValue, cntIdxInfo.IdxType, cntIdxInfo.IdxValue);
      Exit;
    End;
  End;
  Result:= TLoopInfo.Create('R', fromAdr, brkAdr, lastAdr); //repeat
end;

Procedure TDecompiler.SimulatePush (curAdr:Integer);
var
  _vmt:Boolean;
  offset, idx:Integer;
  _vmtAdr:Integer;
  item, item1:TItem;
  recN:InfoRec;
  fInfo:FieldInfo;
  _name, typeName, _value:AnsiString;
Begin
  //push imm
  if DisaInfo.OpType[0] = otIMM then
  Begin
    if IsValidImageAdr(DisaInfo.Immediate) then
    Begin
      recN := GetInfoRec(DisaInfo.Immediate);
      if Assigned(recN) and (recN.kind in [ikLString, ikWString, ikUString]) then
      Begin
        InitItem(@item);
        item.Value := recN.Name;
        item._Type := 'String';
        Push(@item);
        Exit;
      End;
    End;
    InitItem(@item);
    item.Flags := [IF_INTVAL];
    item.IntValue := DisaInfo.Immediate;
    Push(@item);
    Exit;
  End
  //push reg
  else if DisaInfo.OpType[0] = otREG then
  Begin
    idx := DisaInfo.OpRegIdx[0];
    //push esp
    if idx = 20 then
    Begin
      InitItem(@item);
      item.Flags := [IF_STACK_PTR];
      item.IntValue := _ESP_;
      Push(@item);
      Exit;
    End;
    GetRegItem(idx, item);
    _value := GetDecompilerRegisterName(idx);
    if item.Value <> '' then _value := item.Value + 'Begin' + _value + 'End;';
    item.Value := _value;

    //push eax - clear flag IF_CALL_RESULT
    if IF_CALL_RESULT in item.Flags then
    Begin
      Exclude(item.Flags, IF_CALL_RESULT);
      SetRegItem(idx, item);
    End;
    //if (_item.Flags and IF_ARG)<>0 then
    //Begin
    //  _item.Flags := _item.Flags and not IF_ARG;
    //  _item.Name := '';
    //End;
    Push(@item);
    Exit;
  End
  //push mem
  else if DisaInfo.OpType[0] = otMEM then
  Begin
    GetMemItem(curAdr, @item, OP_PUSH);
    Push(@item);
    Exit; // !!!!!!! why so early ??? what about the rest of the code below ?

    offset := DisaInfo.Offset;
    //push [BaseReg + IndxReg*Scale + Offset]
    if DisaInfo.BaseReg <> -1 then
    Begin
      if DisaInfo.BaseReg = 20 then
      Begin
        item := Env.Stack[_ESP_ + offset];
        Push(@item);
        Exit;
      End;
      GetRegItem(DisaInfo.BaseReg, item1);
      //cop reg, [BaseReg + Offset]
      if DisaInfo.IndxReg = -1 then
      Begin
        //push [ebp-N]
        if IF_STACK_PTR in item1.Flags then
        Begin
          _name := Env.GetLvarName(item1.IntValue + offset);
          item := Env.Stack[item1.IntValue + offset];
          item.Value := _name;
          Push(@item);
          Exit;
        End;
        //push [reg]
        if offset=0 then
        Begin
          //var
          if IF_VAR in item1.Flags then
          Begin
            InitItem(@item);
            item.Value := item1.Value;
            item._Type := item1._Type;
            Push(@item);
            Exit;
          End;
          if IsValidImageAdr(item1.IntValue) then
          Begin
            recN := GetInfoRec(item1.IntValue);
            if Assigned(recN) then
            Begin
              InitItem(@item);
              item.Value := recN.Name;
              item._Type := recN._type;
              Push(@item);
              Exit;
            End;
          End;
        End;
        typeName := TrimTypeName(GetRegType(DisaInfo.BaseReg));
        if typeName <> '' then
        Begin
          if typeName[1] = '^' then   //Pointer to gvar (from other unit)
          Begin
            InitItem(@item);
            item.Value := item1.Value;
            item._Type := GetTypeDeref(typeName);
            Push(@item);
            Exit;
          End;
          //push [reg+N]
          fInfo := FMain.GetField(typeName, offset, _vmt, _vmtAdr);
          if Assigned(fInfo) then
          Begin
            InitItem(@item);
            _name := GetFieldName(fInfo);
            if SameText(item1.Value, 'Self') then
              item.Value := _name
            else
              item.Value := item1.Value + '.' + _name;
            item._Type := fInfo._Type;
            Push(@item);
            Exit;
          End;
        End;
      End;
    End;
    //[Offset]
    if IsValidImageAdr(offset) then
    Begin
      recN := GetInfoRec(offset);
      if Assigned(recN) then
      Begin
        InitItem(@item);
        item.Value := recN.Name;
        item._Type := recN._type;
        Push(@item);
        Exit;
      End;
      InitItem(@item);
      Push(@item);
      Exit;
    End
    else
    Begin
      Env.ErrAdr := curAdr;
      raise Exception.Create('Address is outside program image');
    End;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction'); 
end;

Procedure TDecompiler.SimulatePop (curAdr:Integer);
Var
  line:AnsiString;
  item:PItem;
Begin
  //pop reg
  if DisaInfo.OpType[0] = otREG then
  begin
    item := Pop;
    if IF_ARG in item.Flags then
      if not IsFlagSet([cfFrame], Adr2Pos(curAdr)) then
      begin
        line := GetDecompilerRegisterName(DisaInfo.OpRegIdx[0]) + ' := ' + item.Name + ';';
        Env.AddToBody(line);
      end;
    item.Precedence := PRECEDENCE_NONE;
    SetRegItem(DisaInfo.OpRegIdx[0], item^);
    Exit;
  End
  //pop mem
  Else if DisaInfo.OpType[0] = otMEM then
  begin

  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

Procedure TDecompiler.SimulateInstr1 (curAdr:Integer; Op:Byte);
var
  regIdx, offset:Integer;
  item, item1, item2, itemBase, itemSrc:TItem;
  _name, _value, line:AnsiString;
Begin
  //op reg
  if DisaInfo.OpType[0] = otREG then
  Begin
    regIdx := DisaInfo.OpRegIdx[0];
    if Op = OP_INC then
    Begin
      GetRegItem(regIdx, item);
      item.Precedence := PRECEDENCE_ADD;
      item.Value := item.Value + ' + 1';
      SetRegItem(regIdx, item);
      line := GetDecompilerRegisterName(regIdx) + ' := ' + GetDecompilerRegisterName(regIdx) + ' + 1;';
      if item.Value <> '' then line:=line + ' //' + item.Value;
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_DEC then
    Begin
      GetRegItem(regIdx, item);
      item.Precedence := PRECEDENCE_ADD;
      item.Value := item.Value + ' - 1';
      SetRegItem(regIdx, item);
      line := GetDecompilerRegisterName(regIdx) + ' := ' + GetDecompilerRegisterName(regIdx) + ' - 1;';
      if item.Value <> '' then line:=line + ' //' + item.Value;
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_IMUL then
    Begin
      GetRegItem(regIdx, item1);
      GetRegItem(16, item2);
      InitItem(@item);
      item.Precedence := PRECEDENCE_MULT;
      item.Value := item1.Value + ' * ' + item2.Value;
      item._Type := 'Int64';
      SetRegItem(16, item);
      SetRegItem(18, item);
      line := 'EDX_EAX := ' + GetDecompilerRegisterName(regIdx) + ' * ' + 'EAX;';
      if item.Value <> '' then line:=line + ' //' + item.Value;
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_NEG then
    Begin
      GetRegItem(regIdx, item);
      item.Precedence := PRECEDENCE_ATOM;
      item.Value := '-' + item.Value;
      SetRegItem(regIdx, item);
      line := GetDecompilerRegisterName(regIdx) + ' := -' + GetDecompilerRegisterName(regIdx) + ';';
      if item.Value <> '' then line:=line + ' //' + item.Value;
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_NOT then
    Begin
      GetRegItem(regIdx, item);
      item.Precedence := PRECEDENCE_ATOM;
      item.Value := 'not ' + item.Value;
      SetRegItem(regIdx, item);
      line := GetDecompilerRegisterName(regIdx) + ' := not ' + GetDecompilerRegisterName(regIdx) + ';';
      if item.Value <> '' then line:=line + ' //' + item.Value;
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_SET then
    Begin
      InitItem(@item);
      item.Value := CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R;
      item._Type := 'Boolean';
      SetRegItem(regIdx, item);
      line := GetDecompilerRegisterName(regIdx) + ' := ' + '(' + item.Value + ');';
      Env.AddToBody(line);
      Exit;
    End;
    Env.ErrAdr := curAdr;
    raise Exception.Create('Under construction');
  End
  //op mem
  else if DisaInfo.OpType[0] = otMEM then
  Begin
    GetMemItem(curAdr, @itemSrc, Op);
    if itemSrc.Name <> '' then _value := itemSrc.Name
      else _value := itemSrc.Value;
    if Op = OP_IMUL then
    Begin
      GetRegItem(16, item1);
      InitItem(@item);
      item.Precedence := PRECEDENCE_MULT;
      item.Value := _value + ' * ' + item1.Value;;
      item._Type := 'Int64';
      SetRegItem(16, item);
      SetRegItem(18, item);
      line := 'EDX_EAX := ' + item.Value + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_SET then
    Begin
      line := _value + ' := (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ');';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_NEG then
    Begin
      line := _value + ' := -' + _value + ';';
      Env.AddToBody(line);
      Exit;
    End;
    Env.ErrAdr := curAdr;
    raise Exception.Create('Under construction');
    
    // !!!!!!!!!!!! - under construction ?
    offset := DisaInfo.Offset;
    if DisaInfo.BaseReg <> -1 then
    Begin
      if DisaInfo.IndxReg = -1 then
      Begin
        GetRegItem(DisaInfo.BaseReg, itemBase);
        //op [esp+N]
        if DisaInfo.BaseReg = 20 then
          if Op = OP_IMUL then
          Begin
            item1 := Env.Stack[_ESP_ + offset];
            GetRegItem(16, item2);
            InitItem(@item);
            item.Precedence := PRECEDENCE_MULT;
            item.Value := item1.Value + ' * ' + item2.Value;
            item._Type := 'Integer';
            SetRegItem(16, item);
            SetRegItem(18, item);
            line := 'EDX_EAX := EAX * ' + Env.GetLvarName(_ESP_ + offset) + '; //' + item1.Value;
            Env.AddToBody(line);
            Exit;
          End;
        //op [ebp-N]
        if (DisaInfo.BaseReg = 21) and (IF_STACK_PTR in itemBase.Flags) then
          if Op = OP_IMUL then
          Begin
            item1 := Env.Stack[itemBase.IntValue + offset];
            GetRegItem(16, item2);
            if item1.Value <> '' then
              _name := item1.Value
            else
              _name := Env.GetLvarName(itemBase.IntValue + offset);
            InitItem(@item);
            item.Precedence := PRECEDENCE_MULT;
            item.Value := _name + ' * ' + item2.Value;
            item._Type := 'Integer';
            SetRegItem(16, item);
            SetRegItem(18, item);
            line := 'EDX_EAX := EAX * ' + Env.GetLvarName(_ESP_ + offset) + '; //' + item.Value;
            Env.AddToBody(line);
            Exit;
          End;
        if itemBase._Type[1] = '^' then   //Pointer to gvar (from other unit)
          if Op = OP_IMUL then
          Begin
            GetRegItem(16, item2);
            InitItem(@item);
            item.Precedence := PRECEDENCE_MULT;
            item.Value := GetString(@item2, PRECEDENCE_MULT) + ' * ' + GetString(@itemBase, PRECEDENCE_MULT);
            item._Type := 'Integer';
            SetRegItem(16, item);
            SetRegItem(18, item);
            line := 'EDX_EAX := EAX * ' + itemBase.Value + '; //' + item.Value;
            Env.AddToBody(line);
            Exit;
          End;
      End;
    End;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

Procedure TDecompiler.SimulateInstr2RegImm (curAdr:Integer; Op:Byte);
var
  _vmt:Boolean;
  kind, kind1:LKind;
  tmpBuf:PAnsiChar;
  reg1Idx, pow2, _size:Integer;
  n,idx, len, ap:Integer;
  vmtAdr:Integer;
  item, item1:TItem;
  recN:InfoRec;
  fInfo:FieldInfo;
  _name, _value, typeName, line, comment, imm,  txt:AnsiString;
  wStr:WideString;
Begin
  reg1Idx := DisaInfo.OpRegIdx[0];
  imm := GetImmString(DisaInfo.Immediate);
  if Op = OP_MOV then
  Begin
    InitItem(@item);
    item.Flags := [IF_INTVAL];
    item.IntValue := DisaInfo.Immediate;
    SetRegItem(reg1Idx, item);
    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + imm + ';';
    Env.AddToBody(line);
    Exit;

    if IsValidImageAdr(DisaInfo.Immediate) then
    Begin
      ap := Adr2Pos(DisaInfo.Immediate);
      if ap >= 0 then
      Begin
        recN := GetInfoRec(DisaInfo.Immediate);
        if Assigned(recN) then
        Begin
          kind1 := recN.kind;
          if kind1 = ikPointer then
          Begin
            item.Flags := [IF_INTVAL];
            item.IntValue := DisaInfo.Immediate;
            SetRegItem(reg1Idx, item);
            Exit;
          End;
          if (kind1 = ikUnknown) or (kind1 = ikData) then kind1 := GetTypeKind(recN._type, _size);
          case kind1 of
            ikSet:
              begin
                item.Flags := [IF_INTVAL];
                item.IntValue := DisaInfo.Immediate;
                item.Value := GetDecompilerRegisterName(reg1Idx);
                item._Type := recN._type;
              end;
            ikString:
              begin
                item.Value := recN.Name;
                item._Type := 'ShortString';
              end;
            ikLString:
              begin
                item.Value := recN.Name;
                item._Type := 'String';
              end;
            ikWString:
              begin
                item.Value := recN.Name;
                item._Type := 'WideString';
              end;
            ikUString:
              begin
                item.Value := recN.Name;
                item._Type := 'UnicodeString';
              end;
            ikCString:
              begin
                item.Value := recN.Name;
                item._Type := 'PChar';
              end;
            ikWCString:
              begin
                len := lstrlenw(PWideChar(Code + ap));
                wStr := WideString(PWideChar(Code + ap));
                _size := WideCharToMultiByte(CP_ACP, 0, PWideChar(wStr), len, Nil, 0, Nil, Nil);
                if _size<>0 then
                Begin
                  GetMem(tmpBuf,_size + 1);
                  WideCharToMultiByte(CP_ACP, 0, PWideChar(wStr), len, tmpBuf, _size, Nil, Nil);
                  recN.Name:=TransformString(tmpBuf, _size);
                  FreeMem(tmpBuf);
                End;
                item.Value := recN.Name;
                item._Type := 'PWideChar';
              end;
            ikResString:
              begin
                Env.LastResString := recN.rsInfo;
                item.Value := recN.Name;
                item._Type := 'PResStringRec';
              end;
            ikArray:
              begin
                item.Value := recN.Name;
                item._Type := recN._type;
              end;
            ikDynArray:
              begin
                item.Value := recN.Name;
                item._Type := recN._type;
              end;
            else
            begin
              Env.ErrAdr := curAdr;
              raise Exception.Create('Under construction');
            end;
          End;
          SetRegItem(reg1Idx, item);
          Exit;
        End;
      End
      else
      Begin
        idx := BSSInfos.IndexOf(Val2Str(DisaInfo.Immediate,8));
        if idx <> -1 then
        Begin
          recN := InfoRec(BSSInfos.Objects[idx]);
          item.Value := recN.Name;
          item._Type := recN._type;
        End
        else
        Begin
          item.Value := MakeGvarName(DisaInfo.Immediate);
          AddToBSSInfos(DisaInfo.Immediate, item.Value, '');
        End;
        SetRegItem(reg1Idx, item);
        Exit;
      End;
    End;
    item.Flags := [IF_INTVAL];
    item.IntValue := DisaInfo.Immediate;
    SetRegItem(reg1Idx, item);
    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + imm + ';';
    Env.AddToBody(line);
    Exit;
  End
  //cmp reg, imm
  else if Op = OP_CMP then
  Begin
    GetRegItem(reg1Idx, item);
    CompInfo.L := GetDecompilerRegisterName(reg1Idx);
    if (item.Value <> '') and not SameText(item.Value, CompInfo.L) then
      CompInfo.L:= CompInfo.L + 'Begin' + item.Value + 'End;';
    CompInfo.O := CmpOp;
    CompInfo.R := GetImmString(item._Type, DisaInfo.Immediate);
    Exit;
  End
  //test reg, imm
  else if Op = OP_TEST then
  Begin
    GetRegItem(reg1Idx, item);
    kind := GetTypeKind(item._Type, _size);
    if kind = ikSet then
    Begin
      CompInfo.L := GetSetString(item._Type, @DisaInfo.Immediate);
      CompInfo.O := Chr(Ord(CmpOp) + 12); //look GetDirectCondition (in)
      CompInfo.R := GetDecompilerRegisterName(reg1Idx);
      Exit;
    End;
    CompInfo.L := GetDecompilerRegisterName(reg1Idx) + ' And ' + imm;
    CompInfo.O := CmpOp;
    CompInfo.R := '0';
    Exit;
  End
  //add reg, imm (points to class field)
  else if Op = OP_ADD then
  Begin
    //add esp, imm
    if reg1Idx = 20 then
    Begin
      Inc(_ESP_, DisaInfo.Immediate);
      Exit;
    End;
    //add reg, imm
    GetRegItem(reg1Idx, item1);
    //If stack ptr
    if IF_STACK_PTR in item1.Flags then
    Begin
      Inc(item1.IntValue, DisaInfo.Immediate);
      SetRegItem(reg1Idx, item1);
      Exit;
    End;
    if item1._Type <> '' then
    Begin
      if item1._Type[1] = '^' then
      Begin
        typeName := GetTypeDeref(item1._Type);
        kind := GetTypeKind(typeName, _size);
        if kind = ikRecord then
        Begin
          _value := item1.Value;
          InitItem(@item);
          txt := GetRecordFields(DisaInfo.Immediate, typeName);
          if Pos(':',txt)<>0 then
          Begin
            _value:=_value + '.' + ExtractName(txt);
            typeName := ExtractType(txt);
          End
          else
          Begin
            _value:=_value + '.f' + Val2Str(DisaInfo.Immediate);
            typeName := txt;
          End;
          item.Value := _value;
          item._Type := typeName;
          SetRegItem(reg1Idx, item);
          line := GetDecompilerRegisterName(reg1Idx) + ' := ^' + item.Value;
          Env.AddToBody(line);
          Exit;
        End;
      End;
      fInfo := FMain.GetField(item1._Type, DisaInfo.Immediate, _vmt, vmtAdr);
      if Assigned(fInfo) then
      Begin
        InitItem(@item);
        _name := GetFieldName(fInfo);
        if SameText(item1.Value, 'Self') then
          item.Value := _name
        else
          item.Value := item1.Value + '.' + _name;
        item._Type := fInfo._Type;
        SetRegItem(reg1Idx, item);
        line := GetDecompilerRegisterName(reg1Idx) + ' := ' + item.Value;
        Env.AddToBody(line);
        Exit;
      End;
    End;
    if item1.Value <> '' then
      _value := GetString(@item1, PRECEDENCE_ADD) + ' + ' + imm
    else
      _value := GetDecompilerRegisterName(reg1Idx) + ' + ' + imm;
    //-1 and +1 for cycles
    if (DisaInfo.Immediate = 1) and (item1.Value <> '') then
    Begin
      len := Length(item1.Value);
      if len > 4 then
        if SameText(Copy(item1.Value,len - 3, 4), ' - 1') then
        Begin
          item1.Value := Copy(item1.Value,1, len - 4);
          item1.Precedence := PRECEDENCE_NONE;
          SetRegItem(reg1Idx, item1);
          Exit;
        End;
    End;
    CompInfo.L := GetDecompilerRegisterName(reg1Idx);
    CompInfo.O := CmpOp;
    CompInfo.R := '';

    InitItem(@item);
    item.Precedence := PRECEDENCE_ADD;
    item.Value := GetDecompilerRegisterName(reg1Idx);
    SetRegItem(reg1Idx, item);

    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' + ' + imm;
    comment := item.Value;
    Env.AddToBody(line + '; //' + comment);
    Exit;
  End
  //sub reg, imm
  else if Op = OP_SUB then
  Begin
    //sub esp, imm
    if reg1Idx = 20 then
    Begin
      Dec(_ESP_,DisaInfo.Immediate);
      Exit;
    End;
    GetRegItem(reg1Idx, item1);
    //If reg point to VMT - return (may be operation with Interface)
    if GetTypeKind(item1._Type, _size) = ikVMT then Exit;
    CompInfo.L := GetDecompilerRegisterName(reg1Idx);
    CompInfo.O := CmpOp;
    CompInfo.R := '';

    InitItem(@item);
    item.Precedence := PRECEDENCE_ADD;
    item.Value := GetDecompilerRegisterName(reg1Idx);
    SetRegItem(reg1Idx, item);

    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' - ' + imm;
    comment := item.Value;
    Env.AddToBody(line + '; //' + comment);
    Exit;
  End
  //and reg, imm
  else if Op = OP_AND then
  Begin
    GetRegItem(reg1Idx, item1);
    if (DisaInfo.Immediate = 255) and SameText(item1._Type, 'Byte') then Exit;

    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    item.Value := GetString(@item1, PRECEDENCE_MULT) + ' And ' + imm;
    SetRegItem(reg1Idx, item);

    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' And ' + imm;
    comment := item.Value;
    Env.AddToBody(line + '; //' + comment);
    Exit;
  End
  //or reg, imm
  else if Op = OP_OR then
  Begin
    GetRegItem(reg1Idx, item1);
    InitItem(@item);
    if DisaInfo.Immediate = -1 then
    Begin
      item.Flags := [IF_INTVAL];
      item.IntValue := -1;
      item._Type := 'Cardinal';
    End
    else
    Begin
      item.Precedence := PRECEDENCE_ADD;
      item.Value := GetString(@item1, PRECEDENCE_MULT) + ' Or ' + imm;
      item._Type := 'Cardinal';
    End;
    SetRegItem(reg1Idx, item);

    line := GetDecompilerRegisterName(reg1Idx) + ' := ';
    if DisaInfo.Immediate <> -1 then
      line:=line + GetDecompilerRegisterName(reg1Idx) + ' Or ';
    line:=line + imm;
    Env.AddToBody(line + ';');
    Exit;
  End
  //sal(shl) reg, imm
  else if (Op = OP_SAL) or (Op = OP_SHL) then
  Begin
    pow2 := 1;
    for n := 0 to DisaInfo.Immediate-1 do pow2:=pow2 * 2;
    GetRegItem(reg1Idx, item1);
    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    if Op = OP_SHL then
    Begin
      item.Value := GetString(@item1, PRECEDENCE_MULT) + ' Shl ' + IntToStr(DisaInfo.Immediate);
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Shl ' + IntToStr(DisaInfo.Immediate);
      comment := GetString(@item1, PRECEDENCE_MULT) + ' * ' + IntToStr(pow2);
    End
    else
    Begin
      item.Value := GetString(@item1, PRECEDENCE_MULT) + ' * ' + IntToStr(pow2);
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' * ' + IntToStr(pow2);
      comment := '';
    End;
    SetRegItem(reg1Idx, item);
    if comment <> '' then line:=line + '; //' + comment;
    Env.AddToBody(line);
    Exit;
  End
  //sar(shr) reg, imm
  else if (Op = OP_SAR) or (Op = OP_SHR) then
  Begin
    pow2 := 1;
    for n := 0 to DisaInfo.Immediate-1 do pow2:=pow2 * 2;
    GetRegItem(reg1Idx, item1);
    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    if Op = OP_SHR then
    Begin
      item.Value := GetString(@item1, PRECEDENCE_MULT) + ' Shr ' + IntToStr(DisaInfo.Immediate);
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Shr ' + IntToStr(DisaInfo.Immediate);
      comment := GetString(@item1, PRECEDENCE_MULT) + ' Div ' + IntToStr(pow2);
    End
    else
    Begin
      item.Value := GetString(@item1, PRECEDENCE_MULT) + ' Div ' + IntToStr(pow2);
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Div ' + IntToStr(pow2);
      comment := '';
    End;
    SetRegItem(reg1Idx, item);
    if comment <> '' then line:=line + '; //' + comment;
    Env.AddToBody(line);
    Exit;
  End
  //xor reg, imm
  else if Op = OP_XOR then
  Begin
    GetRegItem(reg1Idx, item1);
    InitItem(@item);
    item.Precedence := PRECEDENCE_ADD;
    item.Value := GetString(@item1, PRECEDENCE_ADD) + ' Xor ' + imm;
    SetRegItem(reg1Idx, item);

    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Xor ' + imm;
    comment := item.Value;
    Env.AddToBody(line + '; //' + comment);
    Exit;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction'); 
end;

Procedure TDecompiler.SimulateInstr2RegReg (curAdr:Integer; Op:Byte);
var
  reg1Idx, reg2Idx:Integer;
  item, item1, item2:TItem;
  line, comment, _op:AnsiString;
Begin
  reg1Idx := DisaInfo.OpRegIdx[0];
  reg2Idx := DisaInfo.OpRegIdx[1];
  GetRegItem(reg1Idx, item1);
  GetRegItem(reg2Idx, item2);
  if Op = OP_MOV then
  Begin
    if IsSameRegister(reg1Idx, reg2Idx) then Exit;
    //mov esp, reg
    if reg1Idx = 20 then
    Begin
      SetRegItem(20, item2);
      Exit;
    End;
    //mov reg, esp
    if reg2Idx = 20 then
    Begin
      InitItem(@item);
      item.Flags := [IF_STACK_PTR];
      item.IntValue := _ESP_;
      SetRegItem(reg1Idx, item);
      //mov ebp, esp
      if Env.BpBased and (reg1Idx = 21) and (Env.LocBase=0) then Env.LocBase := _ESP_;
      Exit;
    End;
    //mov reg, reg
    if IF_ARG in item2.Flags then
    Begin
      if reg1Idx <> reg2Idx then
      Begin
        Exclude(item2.Flags, IF_ARG);
        item2.Name := '';
        SetRegItem(reg1Idx, item2);
        line := GetDecompilerRegisterName(reg1Idx) + ' := ' + item2.Value + ';';
        Env.AddToBody(line);
      End;
      Exit;
    End;
    //mov reg, eax (eax - call result) . set eax to regnot not not not 
    if IF_CALL_RESULT in item2.Flags then
    Begin
      Exclude(item2.Flags, IF_CALL_RESULT);
      item2.Value1 := item2.Value;
      item2.Value := GetDecompilerRegisterName(reg1Idx);
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + item2.Value1 + ';';
      SetRegItem(reg1Idx, item2);
      Env.AddToBody(line);
      Exit;
    End;
    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg2Idx) + ';';
    if item2.Value <> '' then line:=line + ' //' + item2.Value;
    item2.Flags := [];
    if item2.Value = '' then
      item2.Value := GetDecompilerRegisterName(reg2Idx);
    SetRegItem(reg1Idx, item2);
    Env.AddToBody(line);
    Exit;
  End
  //cmp reg, reg
  else if Op = OP_CMP then
  Begin
    //kind1 := GetTypeKind(_item1.Type, _size);
    //kind2 := GetTypeKind(_item2.Type, _size);
    //not not not  if kind1 <> kind2 ???
    CompInfo.L := GetDecompilerRegisterName(reg1Idx);
    if (item1.Value <> '') and not SameText(item1.Value, CompInfo.L) then
      CompInfo.L := CompInfo.L + 'Begin' + item1.Value + 'End;';
    CompInfo.O := CmpOp;
    CompInfo.R := GetDecompilerRegisterName(reg2Idx);
    if (item2.Value <> '') and not SameText(item2.Value, CompInfo.R) then
      CompInfo.R := CompInfo.R + 'Begin' + item2.Value + 'End;';
    Exit;
  End
  else if Op = OP_TEST then
  begin
    if reg1Idx = reg2Idx then
    Begin
      //GetRegItem(_reg1Idx, &_item);
      CompInfo.L := GetDecompilerRegisterName(reg1Idx);
      if (item1.Value <> '') and not SameText(item1.Value, CompInfo.L) then
        CompInfo.L := CompInfo.L + 'Begin' + item1.Value + 'End;';
      CompInfo.O := CmpOp;
      CompInfo.R := GetImmString(item1._Type, 0);
      Exit;
    End
    else
    Begin
      CompInfo.L := GetDecompilerRegisterName(reg1Idx) + ' And ' + GetDecompilerRegisterName(reg2Idx);
      CompInfo.O := CmpOp;
      CompInfo.R := '0';
      Exit;
    End;
  end;
  case Op Of
    OP_ADD: _op := ' + ';
    OP_SUB: _op := ' - ';
    OP_OR:  _op := ' Or ';
    OP_XOR: _op := ' Xor ';
    OP_MUL,
    OP_IMUL:_op := ' * ';
    OP_AND: _op := ' And ';
    OP_SHR: _op := ' Shr ';
    OP_SHL: _op := ' Shl ';
  end;
  if Op in [OP_ADD, OP_SUB, OP_OR, OP_XOR] then
  Begin
    if (Op = OP_XOR) and (reg1Idx = reg2Idx) then //xor reg,reg
    Begin
      Env.AddToBody(GetDecompilerRegisterName(reg1Idx) + ' := 0;');
      InitItem(@item);
      item.Flags := [IF_INTVAL];
      item.IntValue := 0;
      SetRegItem(reg1Idx, item);
      Exit;
    End;
    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) 
      + _op + GetDecompilerRegisterName(reg2Idx);
    comment := GetString(@item1, PRECEDENCE_ADD) + _op + GetString(@item2, PRECEDENCE_ADD);
    Env.AddToBody(line + '; //' + comment);
    InitItem(@item);
    item.Precedence := PRECEDENCE_ADD;
    item.Value := GetDecompilerRegisterName(reg1Idx);
    SetRegItem(reg1Idx, item);
    if Op = OP_SUB then
    Begin
      CompInfo.L := GetDecompilerRegisterName(reg1Idx);
      CompInfo.O := CmpOp;
      CompInfo.R := GetDecompilerRegisterName(reg2Idx);
    End;
    Exit;
  End
  else if Op in [OP_MUL, OP_IMUL, OP_AND, OP_SHR, OP_SHL] then
  Begin
    line:=line + GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + _op + GetDecompilerRegisterName(reg2Idx);
    comment := GetString(@item1, PRECEDENCE_MULT) + _op + GetString(@item2, PRECEDENCE_MULT);
    Env.AddToBody(line + '; //' + comment);

    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    item.Value := comment;
    item._Type := 'Integer';
    SetRegItem(reg1Idx, item);
    Exit;
  End
  else if (Op = OP_DIV) or (Op = OP_IDIV) then
  Begin
    line := 'EAX := ' + GetDecompilerRegisterName(reg1Idx) + ' Div ' + GetDecompilerRegisterName(reg2Idx);
    comment := GetString(@item1, PRECEDENCE_MULT) + ' Div ' + GetString(@item2, PRECEDENCE_MULT);
    Env.AddToBody(line + '; //' + comment);

    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    item.Value := comment;
    item._Type := 'Integer';
    SetRegItem(16, item);
    item.Value := GetString(@item1, PRECEDENCE_MULT) + ' Mod ' + GetString(@item2, PRECEDENCE_MULT);;
    SetRegItem(18, item);
    Exit;
  End
  else if Op = OP_XCHG then
  Begin
    SetRegItem(reg1Idx, item2);
    SetRegItem(reg2Idx, item1);
    Exit;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

Procedure TDecompiler.SimulateInstr2RegMem (curAdr:Integer; Op:Byte);
var
  _op,_fname,_name,_type,_value,line:AnsiString;
  reg1Idx,fOffset,offset,ap,adr,size:Integer;
  itemSrc,itemDst, item,item1,item2:TItem;
  recN,recN1:InfoRec;
Begin
  reg1Idx := DisaInfo.OpRegIdx[0];
  GetRegItem(reg1Idx, itemDst);
  GetMemItem(curAdr, @itemSrc, Op);
  if itemSrc.Flags * [IF_VMT_ADR, IF_EXTERN_VAR] <> [] then
  Begin
    SetRegItem(reg1Idx, itemSrc);
    Exit;
  End;
  _op := '?';
  if Op in [OP_ADD, OP_SUB, OP_MUL, OP_IMUL, OP_OR, OP_AND, OP_XOR] then
  case Op of
    OP_ADD: _op := ' + ';
    OP_SUB: _op := ' - ';
    OP_MUL,
    OP_IMUL:_op := ' * ';
    OP_OR:  _op := ' Or ';
    OP_AND: _op := ' And ';
    OP_XOR: _op := ' Xor ';
  End;
  if IF_STACK_PTR in itemSrc.Flags then
  Begin
    item := Env.Stack[itemSrc.IntValue];
    if Op = OP_MOV then
    Begin
      //Arg
      if IF_ARG in item.Flags then
      Begin
        Exclude(item.Flags, IF_ARG);
        //_item.Flags := _item.Flags and not IF_VAR;
        item.Value := item.Name;
        SetRegItem(reg1Idx, item);
        Env.AddToBody(GetDecompilerRegisterName(reg1Idx) + ' := ' + item.Value + ';');
        Exit;
      End
      //Var
      else if IF_VAR in item.Flags then
      Begin
        //_item.Flags :=_item.Flags and not IF_VAR;
        SetRegItem(reg1Idx, item);
        Exit;
      End
      //Field
      else if IF_FIELD in item.Flags then
      Begin
        fOffset := item.Offset;
        _fname := GetRecordFields(fOffset, Env.Stack[itemSrc.IntValue - fOffset]._Type);
        _name := Env.Stack[itemSrc.IntValue - fOffset].Value;
        if _name = '' then
          _name := Env.GetLvarName(itemSrc.IntValue - fOffset);
        InitItem(@itemDst);
        if Pos(':',_fname)<>0 then
        Begin
          itemDst.Value := _name + '.' + ExtractName(_fname);
          itemDst._Type := ExtractType(_fname);
        End
        else itemDst.Value := _name + '.f' + Val2Str(fOffset);
        SetRegItem(reg1Idx, itemDst);
        Env.AddToBody(GetDecompilerRegisterName(reg1Idx) + ' := ' + itemDst.Value + ';');
        Exit;
      End;
      if item.Name <> '' then _value := item.Name
      else
      Begin
        _value := Env.GetLvarName(itemSrc.IntValue);
        if item.Value <> '' then
          _value:=_value + 'Begin' + item.Value + 'End;';
      End;
      item.Value := _value;
      SetRegItem(reg1Idx, item);
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + _value + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_LEA then
    Begin
      SetRegItem(reg1Idx, itemSrc);
      Exit;
    End
    else if Op in [OP_ADD, OP_SUB, OP_MUL, OP_IMUL, OP_OR, OP_AND] then
    Begin
      //Field
      if IF_FIELD in item.Flags then
      Begin
        fOffset := item.Offset;
        _fname := GetRecordFields(fOffset, Env.Stack[itemSrc.IntValue - fOffset]._Type);
        _name := Env.Stack[itemSrc.IntValue - fOffset].Value;
        itemDst.Flags := [];
        itemDst.Precedence := PRECEDENCE_ADD;
        if Pos(':',_fname)<>0 then
        Begin
          itemDst.Value := itemDst.Value + _op + _name + '.' + ExtractName(_fname);
          itemDst._Type := ExtractType(_fname);
        End
        else itemDst.Value := itemDst.Value + _op + _name + '.f' + Val2Str(fOffset);
        SetRegItem(reg1Idx, itemDst);
        Env.AddToBody(GetDecompilerRegisterName(reg1Idx) + ' := ' + itemDst.Value + ';');
        Exit;
      End;
      if itemSrc.Name <> '' then
        _name := itemSrc.Name
      else
        _name := itemSrc.Value;
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + _op + _name + ';';
      itemDst.Flags := [];
      if (Op = OP_ADD) or (Op = OP_SUB) or (Op = OP_OR) then
        itemDst.Precedence := PRECEDENCE_ADD
      else if (Op = OP_MUL) or (Op = OP_IMUL) or (Op = OP_AND) then
        itemDst.Precedence := PRECEDENCE_MULT;
      itemDst.Value := GetDecompilerRegisterName(reg1Idx);
      SetRegItem(reg1Idx, itemDst);
      Env.AddToBody(line);
      if (Op = OP_OR) or (Op = OP_AND) then
      Begin
        CompInfo.L := GetDecompilerRegisterName(reg1Idx);
        CompInfo.O := CmpOp;
        CompInfo.R := '0';
      End;
      Exit;
    End
    else if Op = OP_CMP then
    Begin
      CompInfo.L := GetDecompilerRegisterName(reg1Idx);
      if (itemDst.Value <>'') and not SameText(itemDst.Value, CompInfo.L) then
        CompInfo.L := CompInfo.L + 'Begin' + itemDst.Value + 'End;';
      CompInfo.O := CmpOp;
      if IF_ARG in item.Flags then
        CompInfo.R := item.Name
      else
        CompInfo.R := itemSrc.Value;
      Exit;
    End
    else if Op = OP_XCHG then
    Begin
      SetRegItem(reg1Idx, item);
      Env.Stack[itemSrc.IntValue] := itemDst;
      Exit;
    End;
  End;
  if IF_INTVAL in itemSrc.Flags then
  Begin
    offset := itemSrc.IntValue;
    if Op in [OP_MOV, OP_ADD, OP_SUB, OP_MUL, OP_IMUL, OP_DIV, OP_IDIV] then
    Begin
      _name := '';
      _type := '';
      ap := Adr2Pos(offset);
      recN := GetInfoRec(offset);
      if Assigned(recN) then
      Begin
        //VMT
        if recN.kind = ikVMT then
        Begin
          InitItem(@item);
          item.Flags := [IF_INTVAL];
          item.IntValue := offset;
          item.Value := recN.Name;
          item._Type := recN.Name;
          SetRegItem(reg1Idx, item);
          Exit;
        End;
        MakeGvar(recN, offset, curAdr);
        _name := recN.Name;
        _type := recN._type;
        if ap >= 0 then
        Begin
          adr := PInteger(Code + ap)^;
          //May be pointer to var
          if IsValidImageAdr(adr) then
          Begin
            recN1 := GetInfoRec(adr);
            if Assigned(recN1) then
            Begin
              MakeGvar(recN1, offset, curAdr);
              InitItem(@item);
              item.Value := recN1.Name;
              item._Type := '^' + recN1._type;
              SetRegItem(reg1Idx, item);
            End;
            Exit;
          End;
        End;
      End
      //Just value
      else
      Begin
        InitItem(@item);
        item.Flags := [IF_INTVAL];
        item.IntValue := offset;
        SetRegItem(reg1Idx, item);
        line := GetDecompilerRegisterName(reg1Idx) + ' := ' + IntToStr(offset) + ';';
        Env.AddToBody(line);
        Exit;
      End;
      if Op = OP_MOV then
      Begin
        InitItem(@item);
        item.Value := _name;
        item._Type := _type;
        SetRegItem(reg1Idx, item);
        line := GetDecompilerRegisterName(reg1Idx) + ' := ' + _name + ';';
        Env.AddToBody(line);
        Exit;
      End
      else if Op in [OP_ADD, OP_SUB, OP_MUL, OP_IMUL] then
      Begin
        line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) + _op + _name + ';';
        Env.AddToBody(line);
        Exit;
      End
      else if (Op = OP_DIV) or (Op = OP_IDIV) then
      Begin
        line := GetDecompilerRegisterName(16) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Div ' + _name + ';';
        Env.AddToBody(line);
        line := GetDecompilerRegisterName(18) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Mod ' + _name + ';';
        Env.AddToBody(line);
        Exit;
      End;
      Env.ErrAdr := curAdr;
      raise Exception.Create('Under construction');
    End
    else if Op = OP_CMP then
    Begin
      CompInfo.L := GetDecompilerRegisterName(reg1Idx);
      if (itemDst.Value <> '') and not SameText(itemDst.Value, CompInfo.L) then
        CompInfo.L := CompInfo.L + 'Begin' + itemDst.Value + 'End;';
      CompInfo.O := CmpOp;
      recN := GetInfoRec(offset);
      if Assigned(recN) then
        CompInfo.R := recN.Name
      else
        CompInfo.R := MakeGvarName(offset);
      Exit;
    End;
  End;
  if (Op = OP_MOV) or (Op = OP_LEA) then
  Begin
    InitItem(@item);
    item.Flags := itemSrc.Flags;
    item.Value := itemSrc.Value;
    item._Type := itemSrc._Type;
    //if Op = OP_LEA then _item.Type := '^' + _item.Type;
    SetRegItem(reg1Idx, item);
    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + item.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_CMP then
  Begin
    CompInfo.L := GetDecompilerRegisterName(reg1Idx);
    if (itemDst.Value <>'') and not SameText(itemDst.Value, CompInfo.L) then
      CompInfo.L := CompInfo.L + 'Begin' + itemDst.Value + 'End;';
    CompInfo.O := CmpOp;
    CompInfo.R := itemSrc.Value;
    Exit;
  End
  else if (Op = OP_ADD) or (Op = OP_SUB) or (Op = OP_XOR) then
  Begin
    InitItem(@item);
    item.Precedence := PRECEDENCE_ADD;
    item.Value := GetString(@itemDst, PRECEDENCE_ADD) + _op + GetString(@itemSrc, PRECEDENCE_ADD);
    item._Type := itemSrc._Type;
    SetRegItem(reg1Idx, item);
    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx)
      + _op + itemSrc.Value + '; //' + item.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if (Op = OP_MUL) or (Op = OP_IMUL) or (Op = OP_AND) then
  Begin
    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    item.Value := GetString(@itemDst, PRECEDENCE_MULT) + _op + GetString(@itemSrc, PRECEDENCE_MULT);
    item._Type := itemSrc._Type;
    SetRegItem(reg1Idx, item);
    line := GetDecompilerRegisterName(reg1Idx) + ' := ' + GetDecompilerRegisterName(reg1Idx) 
      + _op + itemSrc.Value + '; //' + item.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if (Op = OP_DIV) or (Op = OP_IDIV) then
  Begin
    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    item.Value := GetString(@itemDst, PRECEDENCE_MULT) + ' Div ' + GetString(@itemSrc, PRECEDENCE_MULT);
    item._Type := itemSrc._Type;
    SetRegItem(16, item);

    InitItem(@item);
    item.Precedence := PRECEDENCE_MULT;
    item.Value := GetString(@itemDst, PRECEDENCE_MULT) + ' Mod ' + GetString(@itemSrc, PRECEDENCE_MULT);
    itemDst._Type := itemSrc._Type;
    SetRegItem(18, item);

    line := GetDecompilerRegisterName(16) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Div ' 
      + itemSrc.Value + '; //' + itemDst.Value + ' Div ' + itemSrc.Value;
    Env.AddToBody(line);
    line := GetDecompilerRegisterName(18) + ' := ' + GetDecompilerRegisterName(reg1Idx) + ' Mod ' 
      + itemSrc.Value + '; //' + itemDst.Value + ' Div ' + itemSrc.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_OR then
  Begin
    //Dst - Set
    if GetTypeKind(itemDst._Type, size) = ikSet then
    Begin
      AssignItem(item1, itemDst);
      AssignItem(item2, itemSrc);
    End;
    //Src - Set
    if GetTypeKind(itemSrc._Type, size) = ikSet then
    Begin
      AssignItem(item1, itemSrc);
      AssignItem(item2, itemDst);
    End;
    line := item1.Value + ' := ' + item1.Value + ' + ';
    if IF_INTVAL in item2.Flags then
    Begin
      if IsValidImageAdr(item2.IntValue) then
        line:=line + GetSetString(item1._Type, Code + Adr2Pos(item2.IntValue))
      else
        line:=line + GetSetString(item1._Type, PAnsiChar(item2.IntValue));
    End
    else line:=line + item2.Value;
    line:=line + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_XCHG then
  Begin
    SetRegItem(reg1Idx, itemSrc);
    Env.Stack[itemSrc.IntValue] := itemDst;
    Exit;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

Procedure TDecompiler.SimulateInstr2MemImm (curAdr:Integer; Op:Byte);
Var
  kind:LKind;
  imm,_name,line,typeName,_type:AnsiString;
  itemDst,item:TItem;
  size,ap,idx:Integer;
  recN:InfoRec;
Begin
  imm := GetImmString(DisaInfo.Immediate);
  GetMemItem(curAdr, @itemDst, Op);
  if IF_STACK_PTR in itemDst.Flags then
  Begin
    if itemDst.Name <> '' then
      _name := itemDst.Name
    else
      _name := itemDst.Value;
    item := Env.Stack[itemDst.IntValue];
    if IF_ARG in item.Flags then
      _name := item.Value;
    if Op = OP_MOV then
    Begin
      Env.Stack[itemDst.IntValue].Value1 := imm;
      line := _name + ' := ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_CMP then
    Begin
      CompInfo.L := _name;
      CompInfo.O := CmpOp;
      CompInfo.R := GetImmString(item._Type, DisaInfo.Immediate);
      Exit;
    End
    else if Op = OP_ADD then
    Begin
      Env.Stack[itemDst.IntValue].Value := _name;
      line := _name + ' := ' + _name + ' + ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_SUB then
    Begin
      Env.Stack[itemDst.IntValue].Value := _name;
      line := _name + ' := ' + _name + ' - ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_AND then
    Begin
      Env.Stack[itemDst.IntValue].Value := _name;
      line := _name + ' := ' + _name + ' And ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_XOR then
    Begin
      Env.Stack[itemDst.IntValue].Value := _name;
      line := _name + ' := ' + _name + ' Xor ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_TEST then
    Begin
      typeName := TrimTypeName(Env.Stack[itemDst.IntValue]._Type);
      kind := GetTypeKind(typeName, size);
      if kind = ikSet then
      Begin
        CompInfo.L := GetSetString(typeName, PAnsiChar(DisaInfo.Immediate));
        CompInfo.O := Chr(Ord(CmpOp) + 12);
        CompInfo.R := _name;
        Exit;
      End;
      CompInfo.L := _name + ' And ' + imm;
      CompInfo.O := CmpOp;
      CompInfo.R := '0';
      Exit;
    End
    else if Op = OP_SHR then
    Begin
      Env.Stack[itemDst.IntValue].Value := _name;
      line := _name + ' := ' + _name + ' Shr ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_SHL then
    Begin
      Env.Stack[itemDst.IntValue].Value := _name;
      line := _name + ' := ' + _name + ' Shl ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End;
    Env.ErrAdr := curAdr;
    raise Exception.Create('Under construction');
  End;
  if IF_INTVAL in itemDst.Flags then
  Begin
    if IsValidImageAdr(itemDst.IntValue) then
    Begin
      _name := MakeGvarName(itemDst.IntValue);
      ap := Adr2Pos(itemDst.IntValue);
      if ap >= 0 then
      Begin
        recN := GetInfoRec(itemDst.IntValue);
        if Assigned(recN) then
        Begin
          if recN.HasName then _name := recN.Name;
          if recN._type <> '' then imm := GetImmString(recN._type, DisaInfo.Immediate);
        End;
      End
      else
      Begin
        idx := BSSInfos.IndexOf(Val2Str(itemDst.IntValue,8));
        if idx <> -1 then
        Begin
          recN := InfoRec(BSSInfos.Objects[idx]);
          _name := recN.Name;
          _type := recN._type;
          if _type <>'' then imm := GetImmString(_type, DisaInfo.Immediate);
        End
        else AddToBSSInfos(itemDst.IntValue, _name, '');
      End;
      if Op = OP_MOV then
      Begin
        line := _name + ' := ' + imm + ';';
        Env.AddToBody(line);
        Exit;
      End
      else if Op = OP_CMP then
      Begin
        CompInfo.L := _name;
        CompInfo.O := CmpOp;
        CompInfo.R := imm;
        Exit;
      End
      else if Op = OP_ADD then
      Begin
        line := _name + ' := ' + _name + ' + ' + imm + ';';
        Env.AddToBody(line);
        Exit;
      End
      else if Op = OP_SUB then
      Begin
        line := _name + ' := ' + _name + ' - ' + imm + ';';
        Env.AddToBody(line);
        Exit;
      End;
    End;
    Env.ErrAdr := curAdr;
    raise Exception.Create('Under construction');
  End;
  if (itemDst.Name <>'') and not IsDefaultName(itemDst.Name) then
    _name := itemDst.Name
  else
    _name := itemDst.Value;
  typeName := TrimTypeName(itemDst._Type);
  if typeName = '' then
  Begin
    if Op = OP_MOV then
    Begin
      line := _name + ' := ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_CMP then
    Begin
      CompInfo.L := _name;
      CompInfo.O := CmpOp;
      CompInfo.R := imm;
      Exit;
    End
    else if Op = OP_ADD then
    Begin
      line := _name + ' := ' + _name + ' + ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_SUB then
    Begin
      line := _name + ' := ' + _name + ' - ' + imm + ';';
      Env.AddToBody(line);
      Exit;
    End;
    Env.ErrAdr := curAdr;
    raise Exception.Create('Under construction');
  End;
  kind := GetTypeKind(typeName, size);
  if Op = OP_MOV then
  Begin
    if kind = ikMethod then
    Begin
      if IsValidImageAdr(DisaInfo.Immediate) then
      Begin
        ap := Adr2Pos(DisaInfo.Immediate);
        if ap >= 0 then
        Begin
          recN := GetInfoRec(DisaInfo.Immediate);
          if Assigned(recN) then
          Begin
            if recN.HasName then
              line := _name + ' := ' + recN.Name + ';'
            else
              line := _name + ' := ' + GetDefaultProcName(DisaInfo.Immediate);
          End;
          if IsFlagSet([cfProcStart], ap) then
            line := _name + ' := ' + GetDefaultProcName(DisaInfo.Immediate);
        End
        else
        Begin
          idx := BSSInfos.IndexOfName(Val2Str(DisaInfo.Immediate,8));
          if idx <> -1 then
          Begin
            recN := InfoRec(BSSInfos.Objects[idx]);
            line := _name + ' := ' + recN.Name + ';';
          End
          else
          Begin
            AddToBSSInfos(DisaInfo.Immediate, MakeGvarName(DisaInfo.Immediate), '');
            line := _name + ' := ' + MakeGvarName(DisaInfo.Immediate);
          End;
        End;
        Env.AddToBody(line);
        Exit;
      End;
    End;
    line := _name + ' := ' + GetImmString(typeName, DisaInfo.Immediate) + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_CMP then
  Begin
    CompInfo.L := _name;
    CompInfo.O := CmpOp;
    CompInfo.R := GetImmString(typeName, DisaInfo.Immediate);
    Exit;
  End
  else if Op = OP_ADD then
  Begin
    line := _name + ' := ' + _name + ' + ' + GetImmString(typeName, DisaInfo.Immediate) + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_SUB then
  Begin
    line := _name + ' := ' + _name + ' - ' + GetImmString(typeName, DisaInfo.Immediate) + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_TEST then
  Begin
    if kind = ikSet then
    Begin
      CompInfo.L := GetSetString(typeName, PAnsiChar(DisaInfo.Immediate));
      CompInfo.O := Chr(Ord(CmpOp) + 12);
      CompInfo.R := _name;
      Exit;
    End
    else if kind = ikInteger then
    Begin
      CompInfo.L := GetImmString(typeName, DisaInfo.Immediate);
      CompInfo.O := CmpOp;
      CompInfo.R := _name;
      Exit;
    End;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

Procedure TDecompiler.SimulateInstr2MemReg (curAdr:Integer; Op:Byte);
var
  kind:LKind;
  reg2Idx,_offset,ap,adr,size:Integer;
  itemSrc,itemDst:TItem;
  _value,_name,line,typeName:AnsiString;
  recN,recN1:InfoRec;
Begin
  reg2Idx := DisaInfo.OpRegIdx[1];
  GetRegItem(reg2Idx, itemSrc);
  _value := GetDecompilerRegisterName(reg2Idx);
  if itemSrc.Value <> '' then _value := itemSrc.Value;
  GetMemItem(curAdr, @itemDst, Op);
  _name := '?';
  if itemDst.Value <> '' then
  Begin
    _name := itemDst.Value;
    if (itemDst.Name <> '') and not SameText(_name, itemDst.Name) then
      _name:=_name + 'Begin' + itemDst.Name + 'End;';
  End
  else if itemDst.Name <> '' then
    _name := itemDst.Name;
  if IF_STACK_PTR in itemDst.Flags then
  Begin
    if Op = OP_MOV then
    Begin
      if IF_CALL_RESULT in itemSrc.Flags then
      Begin
        Exclude(itemSrc.Flags, IF_CALL_RESULT);
        itemSrc.Value := Env.GetLvarName(itemDst.IntValue);
        SetRegItem(reg2Idx, itemSrc);
      End
      else
      Begin
        if not(IF_ARG in itemSrc.Flags) then
          itemSrc.Name := Env.GetLvarName(itemDst.IntValue);
      End;
      Env.Stack[itemDst.IntValue] := itemSrc;
      line := _name + ' := ' + _value + ';';
      Env.AddToBody(line);
      Exit;
    End
    else if Op = OP_ADD then
    Begin
      line := _name + ' := ' + _name + ' + ' + _value + ';';
      Env.AddToBody(line);
      Env.Stack[itemDst.IntValue].Value := _name + ' + ' + _value;
      Exit;
    End
    else if Op = OP_SUB then
    Begin
      line := _name + ' := ' + _name + ' - ' + _value + ';';
      Env.AddToBody(line);
      Env.Stack[itemDst.IntValue].Value := _name + ' - ' + _value;
      Exit;
    End
    else if Op = OP_TEST then
    Begin
      CompInfo.L := _name + ' And ' + _value;
      CompInfo.O := CmpOp;
      CompInfo.R := '';
      Exit;
    End
    else if Op = OP_XOR then
    Begin
      line := _name + ' := ' + _name + ' Xor ' + _value + ';';
      Env.AddToBody(line);
      Env.Stack[itemDst.IntValue].Value := _name + ' Xor ' + _value;
      Exit;
    End
    else if Op = OP_BT then
    Begin
      CompInfo.L := _name + '[' + _value + ']';
      CompInfo.O := CmpOp;
      CompInfo.R := 'True';
      Exit;
    End;
  End;
  if IF_INTVAL in itemDst.Flags then
  Begin
    _offset := itemDst.IntValue;
    if Op = OP_MOV then
    Begin
      ap := Adr2Pos(_offset);
      recN := GetInfoRec(_offset);
      if ap >= 0 then
      Begin
        adr := PInteger(Code + ap)^;
        //May be pointer to var
        if IsValidImageAdr(adr) then
        Begin
          recN1 := GetInfoRec(adr);
          if Assigned(recN1) then
          Begin
            MakeGvar(recN1, _offset, curAdr);
            if itemSrc._Type <> '' then recN1._type := itemSrc._Type;
            line := '^' + recN1.Name + ' := ' + _value + ';';
            Env.AddToBody(line);
            Exit;
          End;
        End;
      End;
      if Assigned(recN) then
      Begin
        MakeGvar(recN, _offset, curAdr);
        if itemSrc._Type <> '' then recN._type := itemSrc._Type;
        line := recN.Name + ' := ' + _value + ';';
        Env.AddToBody(line);
        Exit;
      End;
      Env.ErrAdr := curAdr;
      raise Exception.Create('Under construction');
    End;
  End;
  if Op = OP_MOV then
  Begin
    line := _name + ' := ';
    typeName := itemDst._Type;
    if typeName <> '' then
    Begin
      kind := GetTypeKind(typeName, size);
      if kind = ikSet then
      Begin
        line:=line + GetSetString(typeName, PAnsiChar(itemSrc.IntValue)) + ';';
        Env.AddToBody(line);
        Exit;
      End;
    End;
    line:=line + GetDecompilerRegisterName(reg2Idx) + ';';
    if _value <> '' then line:=line + ' //' + _value;
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_ADD then
  Begin
    line := _name + ' := ' + _name + ' + ' + _value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_SUB then
  Begin
    line := _name + ' := ' + _name + ' - ' + _value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_OR then
  Begin
    line := _name + ' := ' + _name + ' Or ' + _value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_TEST then
  Begin
    CompInfo.L := _name + ' And ' + _value;
    CompInfo.O := CmpOp;
    CompInfo.R := '';
    line := _name + ' := ' + _name + ' And ' + _value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Op = OP_BT then
  Begin
    CompInfo.L := _name + '[' + _value + ']';
    CompInfo.O := CmpOp;
    CompInfo.R := 'True';
    line := _name + ' := ' + _name + '[' + _value + '];';
    Env.AddToBody(line);
    Exit;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

//Simulate instruction with 2 operands
Procedure TDecompiler.SimulateInstr2 (curAdr:Integer; Op:Byte);
Begin
  if DisaInfo.OpType[0] = otREG then
  begin
    if DisaInfo.OpType[1] = otIMM then
      SimulateInstr2RegImm(curAdr, Op)
    Else if DisaInfo.OpType[1] = otREG then
      SimulateInstr2RegReg(curAdr, Op)
    else if DisaInfo.OpType[1] = otMEM then
      SimulateInstr2RegMem(curAdr, Op);
  end
  Else if DisaInfo.OpType[0] = otMEM then
    if DisaInfo.OpType[1] = otIMM then
      SimulateInstr2MemImm(curAdr, Op)
    else if DisaInfo.OpType[1] = otREG then
      SimulateInstr2MemReg(curAdr, Op);
end;

//Simulate instruction with 3 operands
Procedure TDecompiler.SimulateInstr3 (curAdr:Integer; Op:Byte);
var
  reg1Idx, reg2Idx, imm:Integer;
  itemSrc,itemDst:TItem;
  _value,line,comment:AnsiString;
Begin
  reg1Idx := DisaInfo.OpRegIdx[0];
  reg2Idx := DisaInfo.OpRegIdx[1];
  imm     := DisaInfo.Immediate;

  InitItem(@itemDst);
  itemDst._Type := 'Integer';
  if Op = OP_IMUL then
  begin
    //mul reg, reg, imm
    if DisaInfo.OpType[1] = otREG then
    begin
      _value := IntToStr(imm) + ' * ' + GetDecompilerRegisterName(reg2Idx);
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + _value;
      GetRegItem(reg2Idx, itemSrc);
      comment := IntToStr(imm) +  ' * ' + GetString(@itemSrc, PRECEDENCE_MULT);
      itemDst.Precedence := PRECEDENCE_MULT;
      itemDst.Value := comment;
      SetRegItem(reg1Idx, itemDst);
      Env.AddToBody(line + '; //' + comment);
      Exit;
    end
    //mul reg, [Mem], imm
    else if DisaInfo.OpType[1] = otMEM then
    begin
      GetMemItem(curAdr, @itemSrc, Op);
      _value := IntToStr(imm) + ' * ' + itemSrc.Name;
      line := GetDecompilerRegisterName(reg1Idx) + ' := ' + _value;
      comment := IntToStr(imm) +  ' * ' + GetString(@itemSrc, PRECEDENCE_MULT);
      itemDst.Precedence := PRECEDENCE_MULT;
      itemDst.Value := comment;
      SetRegItem(reg1Idx, itemDst);
      Env.AddToBody(line + '; //' + comment);
      Exit;
    end;
  end;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

function TDecompiler.DecompileTry(fromAdr:Integer; flags:TDecomCset; loopInfo:TLoopInfo): Integer;
var
  _pos, tpos, pos1, instrLen, skipNum,num,n,m:Integer;
  startTryAdr, endTryAdr, startFinallyAdr, endFinallyAdr, endExceptAdr, adr, endAdr, hAdr:Integer;
  recN:InfoRec;
  item:TItem;
  de:TDecompiler;
Begin
  skipNum := IsTryBegin(fromAdr, startTryAdr) + IsTryBegin0(fromAdr, startTryAdr);
  adr := startTryAdr; 
  _pos := Adr2pos(adr);
  if IsFlagSet([cfFinally], _pos) then
  Begin
    //jmp @HandleFinally
    instrLen := frmDisasm.Disassemble(Code + _pos, adr, Nil, Nil);
    Inc(adr,  instrLen); 
    Inc(_pos, instrLen);
    //jmp @2
    frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
    startFinallyAdr := DisaInfo.Immediate;
    //Get prev push
    pos1 := GetNearestUpInstruction(Adr2pos(DisaInfo.Immediate));
    frmDisasm.Disassemble(Code + pos1, pos2Adr(pos1), @DisaInfo, Nil);
    endFinallyAdr := DisaInfo.Immediate;
    //Find flag cfFinally
    while true do
    Begin
      Dec(pos1);
      if IsFlagSet([cfFinally], pos1) then break;
    End;
    if pos1<>0 then endTryAdr := pos2Adr(pos1);
    if endTryAdr=0 then
    Begin
      Env.ErrAdr := fromAdr;
      raise Exception.Create('Invalid end address of TRY section');
    End;
    //Decompile try
    Env.AddToBody('try');
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(endTryAdr);
    try
      endAdr := de.Decompile(fromAdr + skipNum, flags, loopInfo);
    except
      on E:Exception do
      Begin
        de.Free;
        raise Exception.Create('Try.' + E.Message);
      End;
    end;
    de.Free;
    Env.AddToBody('finally');
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(endFinallyAdr);
    try
      endAdr := de.Decompile(startFinallyAdr, [CF_FINALLY], loopInfo);
    except
      on E:Exception do
      Begin
        de.Free;
        raise Exception.Create('Try.' + E.Message);
      End;
    end;
    Env.AddToBody('end');
    de.Free;
    Result:=endAdr;
  End
  else if IsFlagSet([cfExcept], _pos) then
  Begin
    //Prev jmp
    pos1 := GetNearestUpInstruction(_pos);
    frmDisasm.Disassemble(Code + pos1, pos2Adr(pos1), @DisaInfo, Nil);
    endExceptAdr := DisaInfo.Immediate;
    //Next
    Inc(_pos, frmDisasm.Disassemble(Code + _pos, pos2Adr(_pos), @DisaInfo, Nil));
    //Find prev flag cfExcept
    while true do
    Begin
      if IsFlagSet([cfExcept], pos1) then break;
      Dec(pos1);
    End;
    if pos1<>0 then endTryAdr := pos2Adr(pos1);
    if endTryAdr=0 then
    Begin
      Env.ErrAdr := fromAdr;
      raise Exception.Create('Invalid end address of TRY section');
    End;
    //Decompile try
    Env.AddToBody('try');
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(endTryAdr);
    try
      endAdr := de.Decompile(fromAdr + 14, [], loopInfo);
    except 
      on E:Exception do
      Begin
        de.Free;
        raise Exception.Create('Try.' + E.Message);
      End;
    end;
    de.Free;
    //on except
    if IsFlagSet([cfETable], _pos) then
    Begin
      Env.AddToBody('except');
      num := PInteger(Code + _pos)^; 
      Inc(_pos, 4);
      //Table _pos
      tpos := _pos;
      for n := 0 to num-1 do
      Begin
        adr := PInteger(Code + _pos)^; 
        Inc(_pos, 4);
        if IsValidCodeAdr(adr) then
        Begin
          recN := GetInfoRec(adr);
          InitItem(@item);
          item.Value := 'E';
          item._Type := recN.Name;
          SetRegItem(16, item);  //eax . exception info
          Env.AddToBody('on E:' + recN.Name + ' do');
        End
        else Env.AddToBody('else');
        hAdr := PInteger(Code + _pos)^; 
        Inc(_pos, 4);
        if IsValidCodeAdr(hAdr) then
        Begin
          de := TDecompiler.Create(Env);
          de.SetStackPointers(Self);
          de.SetDeFlags(DeFlags); 
          pos1 := tpos;
          for m := 0 to num-1 do
          Begin
            Inc(pos1, 4);
            adr := PInteger(Code + pos1)^; 
            Inc(pos1, 4);
            de.SetStop(adr);
          End;
          de.ClearStop(hAdr);
          de.SetStop(endExceptAdr);
          try
            Env.AddToBody('begin');
            endAdr := de.Decompile(hAdr, [], loopInfo);
            Env.AddToBody('end');
          Except
            on E:Exception do
            Begin
              de.Free;
              raise Exception.Create('Try.' + E.Message);
            End;
          end;
          de.Free;
        End;
      End;
      Env.AddToBody('end');
    End
    //except
    else
    Begin
      Env.AddToBody('except');
      de := TDecompiler.Create(Env);
      de.SetStackPointers(Self);
      de.SetDeFlags(DeFlags);
      de.SetStop(endExceptAdr);
      try
        endAdr := de.Decompile(pos2Adr(_pos), [CF_EXCEPT], loopInfo);
      Except
        on E:Exception do
        Begin
          de.Free;
          raise Exception.Create('Try.' + E.Message);
        End;
      end;
      Env.AddToBody('end');
      de.Free;
    End;
    Result:=endAdr;//endExceptAdr;
  End;
end;

Procedure TDecompiler.MarkCaseEnum (fromAdr:Integer);
var
  b,op:BYTE;
  adr, jAdr,instrLen,caseNum,endOfCaseAdr,maxN:Integer;
  n, _pos, cTblPos, jTblPos,cTblAdr,jTblAdr,cNum:Integer;
Begin
  adr:=fromAdr;
  _pos:=Adr2Pos(fromAdr);
  //cmp reg, Imm
  //Imm -
  instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  caseNum := DisaInfo.Immediate + 1;
  Inc(_pos, instrLen);
  Inc(adr, instrLen);
  //ja EndOfCaseAdr
  instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  endOfCaseAdr := DisaInfo.Immediate;
  Inc(_pos, instrLen);
  Inc(adr, instrLen);
  //mov???
  instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  op := frmDisasm.GetOp(DisaInfo.Mnem);
  cTblAdr := 0;
  jTblAdr := 0;
  if op = OP_MOV then
  Begin
    cTblAdr := DisaInfo.Offset;
    Inc(_pos, instrLen);
    Inc(adr, instrLen);
    instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  End;
  jTblAdr := DisaInfo.Offset;
  maxN := 0;
  if cTblAdr<>0 then
  Begin
    cTblpos := Adr2pos(cTblAdr);
    cNum := jTblAdr - cTblAdr;
    for n := 0 to cNum-1 do
    Begin
      b := Byte(Code[cTblpos]);
      if b > maxN then maxN := b;
      Inc(cTblpos);
    End;
    jTblpos := Adr2pos(jTblAdr);
    for n := 0 to maxN do
    Begin
      jAdr := PInteger(Code + jTblpos)^;
      SetStop(jAdr);
      Inc(jTblpos, 4);
    End;
  End
  else
  Begin
    jTblpos := Adr2pos(jTblAdr);
    for n := 0 to caseNum-1 do
    Begin
      if IsFlagSet([cfCode, cfLoc], jTblpos) then break;
      jAdr := PInteger(Code + jTblpos)^;
      SetStop(jAdr);
      Inc(jTblpos, 4);
    End;
  End;
end;

Function TDecompiler.DecompileCaseEnum (fromAdr:Integer; Q:Integer; loopInfo:TLoopInfo):Integer;
Var
  skip:Boolean;
  b,op:BYTE;
  adr, jAdr, jAdr1, adr2, endAdr,instrLen,caseNum,cTblAdr,jTblAdr,cNum:Integer;
  n, m, _pos, cTblPos, cTblPos1, jTblPos, jTblPos1,endOfCaseAdr,maxN:Integer;
  line:AnsiString;
  de:TDecompiler;
Begin
  endAdr:=0;
  adr:=fromAdr;
  _pos:=Adr2Pos(fromAdr);
  line:='';
  //cmp reg, Imm
  //Imm -
  instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  caseNum := DisaInfo.Immediate + 1;
  Inc(_pos, instrLen);
  Inc(adr, instrLen);
  //ja EndOfCaseAdr
  instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  endOfCaseAdr := DisaInfo.Immediate;
  Inc(_pos, instrLen);
  Inc(adr, instrLen);
  //mov???
  instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  op := frmDisasm.GetOp(DisaInfo.Mnem);
  cTblAdr := 0;
  jTblAdr := 0;
  if op = OP_MOV then
  Begin
    cTblAdr := DisaInfo.Offset;
    Inc(_pos, instrLen);
    Inc(adr, instrLen);
    instrLen := frmDisasm.Disassemble(Code + _pos, adr, @DisaInfo, Nil);
  End;
  jTblAdr := DisaInfo.Offset;
  maxN := 0;
  if cTblAdr<>0 then
  Begin
    cTblpos := Adr2pos(cTblAdr);
    cNum := jTblAdr - cTblAdr;
    for n := 0 to cNum-1 do
    Begin
      b := Byte(Code[cTblpos]);
      if b > maxN then maxN := b;
      Inc(cTblpos);
    End;
    jTblpos := Adr2pos(jTblAdr);
    for m := 0 to maxN do
    Begin
      line := '';
      skip := false;
      cTblpos := Adr2pos(cTblAdr);
      for n := 0 to cNum-1 do
      Begin
        b := Byte(Code[cTblpos]);
        jAdr := PInteger(Code + jTblpos)^;
        if b = m then
        Begin
          if jAdr = endOfCaseAdr then
          Begin
            skip := true;
            break;
          End;
          if line <> '' then line:=line + ',';
          line:=line + IntToStr(n + Q);
        End;
        Inc(cTblpos);
      End;
      if not skip then
      Begin
        Env.AddToBody(line + ':');
        Env.SaveContext(endOfCaseAdr);
        de := TDecompiler.Create(Env);
        de.SetStackPointers(Self);
        de.SetDeFlags(DeFlags);
        de.SetStop(endOfCaseAdr);
        de.MarkCaseEnum(fromAdr);
        de.ClearStop(jAdr);
        try
          Env.AddToBody('begin');
          adr2 := de.Decompile(jAdr, [], loopInfo);
          if adr2 > endAdr then endAdr := adr2;
          Env.AddToBody('end');
        Except
          on E:Exception do
          Begin
            de.Free;
            raise Exception.Create('CaseEnum.' + E.Message);
          End;
        end;
        Env.RestoreContext(endOfCaseAdr);
        de.Free;
      End;
      Inc(jTblpos, 4);
    End;
    Result:= endAdr; //endOfCaseAdr;
    Exit;
  End;
  jTblpos := Adr2pos(jTblAdr);
  for n := 0 to caseNum-1 do
  Begin
    if IsFlagSet([cfCode, cfLoc], jTblpos) then break;
    jAdr := PInteger(Code + jTblpos)^;
    if jAdr <> endOfCaseAdr then
    Begin
      skip := false;
      //If case already decompiled?
      jTblpos1 := Adr2pos(jTblAdr);
      for m := 0 to n-1 do
      Begin
        jAdr1 := PInteger(Code + jTblpos1)^;
        if jAdr1 = jAdr then
        Begin
          skip := true;
          break;
        End;
        Inc(jTblpos1, 4);
      End;
      if not skip then
      Begin
        line := '';
        jTblpos1 := Adr2pos(jTblAdr);
        for m := 0 to caseNum-1 do
        Begin
          if IsFlagSet([cfCode, cfLoc], jTblpos1) then break;
          jAdr1 := PInteger(Code + jTblpos1)^;
          if jAdr1 = jAdr then
          Begin
            if line <> '' then line:=line + ',';
            line:=line + IntToStr(m + Q);
          End;
          Inc(jTblpos1, 4);
        End;
        Env.AddToBody(line + ':');
        Env.SaveContext(endOfCaseAdr);
        de := TDecompiler.Create(Env);
        de.SetStackPointers(Self);
        de.SetDeFlags(DeFlags);
        de.SetStop(endOfCaseAdr);
        de.MarkCaseEnum(fromAdr);
        de.ClearStop(jAdr);
        try
          Env.AddToBody('begin');
          adr2 := de.Decompile(jAdr, [], loopInfo);
          if adr2 > endAdr then endAdr := adr2;
          Env.AddToBody('end');
        Except
           on E:Exception do
          Begin
            de.Free;
            raise Exception.Create('CaseEnum.' + E.Message);
          End;
        end;
        Env.RestoreContext(endOfCaseAdr);
        de.Free;
      End;
    End;
    Inc(jTblpos, 4);
  End;
  Result:= endAdr; //endOfCaseAdr;
end;

Function TDecompiler.GetSysCallAlias (AName:AnsiString):AnsiString;
Begin
  Result:='';
  if SameText(AName, '@Assign') or
    SameText(AName, '@AssignText') Then Result:='AssignFile'
  else if SameText(AName, '@Append') Then Result:='Append'
  Else if SameText(AName, '@Assert') then Result:= 'Assert'
  else if SameText(AName, '@BlockRead') then Result:= 'Read'
  else if SameText(AName, '@BlockWrite') then Result:= 'Write'
  else if SameText(AName, '@ChDir') then Result:= 'ChDir'
  else if SameText(AName, '@Close') then Result:= 'CloseFile'
  else if SameText(AName, '@EofText') then Result:= 'Eof'
  else if SameText(AName, '@FillChar')then Result:= 'FillChar'
  else if SameText(AName, '@Flush')then Result:= 'Flush'
  else if SameText(AName, '@LStrCopy') or
    SameText(AName, '@WStrCopy') or
    SameText(AName, '@UStrCopy') then Result:= 'Copy'
  else if SameText(AName, '@LStrDelete') or
    SameText(AName, '@UStrDelete') then Result:= 'Delete'
  else if SameText(AName, '@LStrFromPCharLen') then Result:= 'SetString'
  else if SameText(AName, '@LStrInsert') then Result:= 'Insert'
  else if SameText(AName, '@PCharLen') or
    SameText(AName, '@LStrLen') or
    SameText(AName, '@WStrLen') or
    SameText(AName, '@UStrLen') then Result:= 'Length'
  else if SameText(AName, '@LStrOfChar') then Result:= 'StringOfChar'
  else if SameText(AName, '@LStrPos') then Result:= 'Pos'
  else if SameText(AName, '@LStrSetLength') or
    SameText(AName, '@UStrSetLength') then Result:= 'SetLength'
  else if SameText(AName, '@MkDir') then Result:= 'MkDir'
  else if SameText(AName, '@New') then Result:= 'New'
  else if SameText(AName, '@RaiseAgain') then Result:= 'Raise'
  else if SameText(AName, '@RandInt') then Result:= 'Random'
  else if SameText(AName, '@ReadLn') then Result:= 'ReadLn'
  else if SameText(AName, '@ReadLong') or
    SameText(AName, '@ReadLString') or
    SameText(AName, '@ReadRec') or
    SameText(AName, '@ReadUString') then Result:= 'Read'
  else if SameText(AName, '@ReallocMem') then Result:= 'ReallocMem'
  else if SameText(AName, '@ResetFile') or
    SameText(AName, '@ResetText') then Result:= 'Reset'
  else if SameText(AName, '@ValLong') or
    SameText(AName, '@ValInt64') then Result:= 'Val'
  else if SameText(AName, '@WriteLn') then Result:= 'WriteLn';
end;

Function TDecompiler.SimulateSysCall (name:AnsiString; procAdr:Integer; instrLen:Integer):Boolean;
var
  cnt, _esp, _size:Integer;
  _adr,n,r:Integer;
  item, item1, item2, item3, item4:TItem;
  recN:InfoRec;
  line, _value, value1, value2, _typeName:AnsiString;
  _int64Val:Int64;
Begin
  Result:=False;
  if SameText(name, '@AsClass') then
  Begin
    //type of edx . type of eax
    GetRegItem(16, item1);
    GetRegItem(18, item2);
    item1.Value := item2._Type + '(' + item1.Value + ')';
    item1._Type := item2._Type;
    SetRegItem(16, item1);
    Exit;
  End
  else if SameText(name, '@IsClass') then
  Begin
    GetRegItem(16, item1);
    GetRegItem(18, item2);
    _adr := item2.IntValue;
    if not IsValidImageAdr(_adr) then
      raise Exception.Create('Invalid address $'+IntToHex(_adr,0));
    recN := GetInfoRec(_adr);
    InitItem(@item);
    item.Value := '(' + item1.Value + ' is ' + recN.Name + ')';
    item._Type := 'Boolean';
    SetRegItem(16, item);
    Exit;
  End
  else if SameText(name, '@CopyRecord') then
  Begin
    //dest:Pointer
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
    Begin
      Env.Stack[item1.IntValue].Value := Env.GetLvarName(item1.IntValue);
      item1 := Env.Stack[item1.IntValue];
    End;
    //source:Pointer
    GetRegItem(18, item2);
    //typeInfo:Pointer
    GetRegItem(17, item3);
    recN := GetInfoRec(item3.IntValue);
    Env.Stack[item1.IntValue]._Type := recN.Name;
    line := item1.Value + ' := ' + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@DynArrayAsg') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
    Begin
      if Env.Stack[item1.IntValue].Value = '' then 
        Env.Stack[item1.IntValue].Value := Env.GetLvarName(item1.IntValue);
      item1 := Env.Stack[item1.IntValue];
    End;
    //edx - src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
    Begin
      if Env.Stack[item2.IntValue].Value = '' then 
        Env.Stack[item2.IntValue].Value := Env.GetLvarName(item2.IntValue);
      item2 := Env.Stack[item2.IntValue];
    End;
    line := item1.Value + ' := ' + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@DynArrayClear') then
  Begin
    //eax - var
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
    Begin
      if Env.Stack[item1.IntValue].Value = '' then 
        Env.Stack[item1.IntValue].Value := Env.GetLvarName(item1.IntValue);
      item1 := Env.Stack[item1.IntValue];
    End;
    line := item1.Value + ' := Nil;';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@DynArrayLength') then
  Begin
    //eax - ptr
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
    Begin
      if Env.Stack[item1.IntValue].Value = '' then 
        Env.Stack[item1.IntValue].Value := Env.GetLvarName(item1.IntValue);
      item1 := Env.Stack[item1.IntValue];
    End;
    _value := 'Length(' + item1.Value + ')';
    line := 'EAX := ' + _value;
    Env.AddToBody(line);
    InitItem(@item);
    Include(item.Flags, IF_CALL_RESULT);
    item.Value := _value;
    item._Type := 'Integer';
    SetRegItem(16, item);
    Exit;
  End
  else if SameText(name, '@DynArraySetLength') then //stdcall
  Begin
    //eax - dst
    GetRegItem(16, item1);
    item := item1;
    if IF_STACK_PTR in item1.Flags then
    Begin
      if Env.Stack[item1.IntValue].Value = '' then 
        Env.Stack[item1.IntValue].Value := Env.GetLvarName(item1.IntValue);
      item := Env.Stack[item1.IntValue];
    End;
    line := 'SetLength(' + item.Value;
    //edx - type of DynArray
    GetRegItem(18, item2);
    Env.Stack[item1.IntValue]._Type := GetTypeName(item2.IntValue);
    //ecx - dims cnt
    GetRegItem(17, item3);
    cnt := item3.IntValue;
    _esp := _ESP_;
    for n := 0 to cnt-1 do
    Begin
      line:=line + ', ';
      item := Env.Stack[_esp];
      if IF_INTVAL in item.Flags then
        line:=line + IntToStr(item.IntValue)
      else
        line:=line + item.Value;
      Inc(_esp, 4);
    End;
    line:=line + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@FreeMem') then
  Begin
    line := 'FreeMem(';
    GetRegItem(16, item);
    if item.Value <> '' then
      line:=line + item.Value
    else
      line:=line + 'EAX';
    line:=line + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@GetMem') then
  Begin
    _value := 'GetMem(';
    //eax-Bytes
    GetRegItem(16, item);
    if IF_INTVAL in item.Flags then
      _value:=_value + IntToStr(item.IntValue)
    else
      _value:=_value + item.Value;
    _value:=_value + ')';
    line := _value + ';';
    Env.AddToBody(line);
    _typeName := ManualInput(CurProcAdr, procAdr, 'Define type of function GetMem', 'Type:');
    if _typeName = '' then
    Begin
      Env.ErrAdr := procAdr;
      raise Exception.Create('Empty input - See you later!');
    End;
    InitItem(@item);
    Include(item.Flags, IF_CALL_RESULT);
    item.Value := _value;
    item._Type := _typeName;
    SetRegItem(16, item);
    Exit;
  End
  else if SameText(name, '@Halt0') then
  Begin
    //_line := 'Exit;';
    //Env.AddToBody(_line);
    Exit;
  End
  else if SameText(name, '@InitializeRecord') or
    SameText(name, '@FinalizeRecord') or
    SameText(name, '@AddRefRecord') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    //edx - TypeInfo
    GetRegItem(18, item2);
    if IF_STACK_PTR in item1.Flags then
    Begin
      _typeName := GetTypeName(item2.IntValue);
      _size := GetRecordSize(_typeName);
      for r := 0 to _size-1 do
      Begin
        if item1.IntValue + r >= Env.StackSize then
        Begin
          Env.ErrAdr := procAdr;
          raise Exception.Create('Possibly incorrect RecordSize (or incorrect type of record)');
        End;
        item := Env.Stack[item1.IntValue + r];
        item.Flags := [IF_FIELD];
        item.Offset := r;
        item._Type := '';
        if r = 0 then item._Type := _typeName;
        Env.Stack[item1.IntValue + r] := item;
      End;
      if Env.Stack[item1.IntValue].Value = '' then 
        Env.Stack[item1.IntValue].Value := Env.GetLvarName(item1.IntValue);
      Env.Stack[item1.IntValue]._Type := _typeName;
    End;
    Exit;
  End
  else if SameText(name, '@InitializeArray') or
    SameText(name, '@FinalizeArray') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    item := item1;
    if IF_STACK_PTR in item1.Flags then
    Begin
      if Env.Stack[item1.IntValue].Value = '' then
        Env.Stack[item1.IntValue].Value := Env.GetLvarName(item1.IntValue);
      item := Env.Stack[item1.IntValue];
    End;
    //edx - type of DynArray
    GetRegItem(18, item2);
    //ecx - dims cnt
    GetRegItem(17, item3);
    cnt := item3.IntValue;
    Env.Stack[item1.IntValue]._Type := 'array [1..' + IntToStr(cnt) + '] of ' + GetTypeName(item2.IntValue);;
    Exit;
  End
  else if SameText(name, '@IntfClear') then
  Begin
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'IInterface';
    line := item1.Value + ' := Nil;';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@IntfCopy') then
  Begin
    GetRegItem(16, item1);
    GetRegItem(18, item2);
    line := item1.Value + ' := ' + item2.Value1;
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@LStrAsg') or
    SameText(name, '@LStrLAsg') or
    SameText(name, '@WStrAsg') or
    SameText(name, '@WStrLAsg') or
    SameText(name, '@UStrAsg') or
    SameText(name, '@UStrLAsg') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    //edx - src
    GetRegItem(18, item2);
    line := GetStringArgument(@item1) + ' := ' + GetStringArgument(@item2) + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@LStrCat') or
    SameText(name, '@WStrCat') or
    SameText(name, '@UStrCat') then
  Begin
    //eax - dst
    GetRegItem(16, item);
    line := GetStringArgument(@item) + ' := ' + GetStringArgument(@item) + ' + ';
    //edx - src
    GetRegItem(18, item);
    line:=line + GetStringArgument(@item) + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@LStrCat3') or
    SameText(name, '@WStrCat3') or
    SameText(name, '@UStrCat3') then
  Begin
    //eax - dst
    GetRegItem(16, item);
    line := GetStringArgument(@item) + ' := ';
    //edx - str1
    GetRegItem(18, item);
    line:=line + GetStringArgument(@item) + ' + ';
    //ecx - str2
    GetRegItem(17, item);
    line:=line + GetStringArgument(@item) + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@LStrCatN') or
    SameText(name, '@WStrCatN') or
    SameText(name, '@UStrCatN') then
  Begin
    //eax - dst
    GetRegItem(16, item);
    line := GetStringArgument(@item) + ' := ';
    if IF_STACK_PTR in item.Flags then
    Begin
      Env.Stack[item.IntValue].Flags := [];
      Env.Stack[item.IntValue].Value := Env.GetLvarName(item.IntValue);
      if name[2] = 'L' then
        Env.Stack[item.IntValue]._Type := 'AnsiString'
      else if name[2] = 'W' then
        Env.Stack[item.IntValue]._Type := 'WideString'
      else
        Env.Stack[item.IntValue]._Type := 'UnicodeString';
    End;
    //edx - argCnt
    GetRegItem(18, item2);
    cnt := item2.IntValue;
    Inc(_ESP_, 4*cnt); 
    _esp := _ESP_;
    for n := 0 to cnt-1 do
    Begin
      if n<>0 then line:=line + ' + ';
      Dec(_esp, 4);
      item := Env.Stack[_esp];
      line:=line + GetStringArgument(@item);
    End;
    line:=line + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@LStrClr') or
    SameText(name, '@WStrClr') or
    SameText(name, '@UStrClr') then
  Begin
    GetRegItem(16, item);
    line := GetStringArgument(@item) + ' := '';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@AStrCmp') or
    SameText(name, '@LStrCmp') or
    SameText(name, '@WStrCmp') or
    SameText(name, '@UStrCmp') or
    SameText(name, '@UStrEqual') then
  Begin
    GetCmpInfo(procAdr + instrLen);
    CompInfo.O := 'F'; //By default (<>)
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then item1 := Env.Stack[item1.IntValue];
    CompInfo.L := item1.Value;
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
    Begin
      item2 := Env.Stack[item2.IntValue];
      CompInfo.R := item2.Value;
    End
    else if IF_INTVAL in item2.Flags then
    Begin
      if item2.IntValue=0 then CompInfo.R := ''''
      else
      Begin
        recN := GetInfoRec(item2.IntValue);
        if Assigned(recN) then CompInfo.R := recN.Name
        else
      //Fix it!!!
      //Add analyze of String type
          CompInfo.R := TransformString(Code + Adr2Pos(item2.IntValue), -1);
      End;
    End
    else CompInfo.R := item2.Value;
    Result:=TRUE;
    Exit;
  End
  else if SameText(name, '@LStrFromArray') or
    SameText(name, '@LStrFromChar')   or
    SameText(name, '@LStrFromPChar')  or
    SameText(name, '@LStrFromString') or
    SameText(name, '@LStrFromWStr')   or
    SameText(name, '@LStrFromUStr') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'String';
    //edx - src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
    Begin
      case name[10] of
        'A': _typeName := 'PAnsiChar';
        'C': _typeName := 'Char';
        'P': _typeName := 'PChar';
        'S': _typeName := 'ShortString';
        'W': _typeName := 'WideString';
        'U': _typeName := 'UnicodeString';
      end;
      Env.Stack[item2.IntValue]._Type := _typeName;
    End;
    line := item1.Value + ' := ' + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@LStrToPChar') then
  Begin
    //eax - src
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'String';
    item1.Value := 'PChar(' + item1.Value + ')';
    SetRegItem(16, item1);
    line := 'EAX := ' + item1.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@LStrToString') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'ShortString';
    //edx - src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'String';
    line := item1.Value + ' := ' + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@PStrNCat') or
    SameText(name, '@PStrCpy') or
    SameText(name, '@PStrNCpy') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'ShortString';
    //edx - src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'ShortString';
    line := item1.Value + ' := ';
    if SameText(name, '@PStrNCat') then line:=line + item1.Value + ' + ';
    line:=line + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@RaiseExcept') then
  Begin
    //eax - Exception
    GetRegItem(16, item1);
    line := 'raise ' + item1.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@RewritFile') or
    SameText(name, '@RewritText') then
  Begin
    //File
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      item1 := Env.Stack[item1.IntValue];
    line := 'Rewrite(' + ExtractClassName(item1.Value) + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@Sin') or
    SameText(name, '@Cos') or
    SameText(name, '@Int') then
  Begin
    _value := Copy(name,2, 5);
    InitItem(@item1);
    item1.Value := _value + '(' + FGet(0).Value + ')';
    item1._Type := 'Extended';
    FSet(0, @item1);
    Exit;
  End
  else if SameText(name, '@Trunc') or
    SameText(name, '@Round') then
  Begin
    _value := Copy(name,2, 5) + '(' + FGet(0).Value + ')';
    InitItem(@item);
    item.Value := _value;
    item._Type := 'Int64';
    SetRegItem(16, item);
    SetRegItem(18, item);
    line := '//EAX := ' + _value + ';';
    Env.AddToBody(line);
    FPop;
    Exit;
  End
  else if SameText(Copy(name,1, Length(name) - 1), '@UniqueString') then
  Begin
    GetRegItem(16, item1);
    InitItem(@item);
    item.Value := 'EAX';
    item._Type := 'String';
    SetRegItem(16, item);
    if IF_STACK_PTR in item1.Flags then
    Begin
      _value := 'UniqueString(' + Env.Stack[item1.IntValue].Value + ')';
      Env.Stack[item1.IntValue]._Type := 'String';
      line := '//EAX := ' + _value;
      Env.AddToBody(line);
      Exit;
    End;
    _value := 'UniqueString(' + item1.Value + ')';
    line := '//EAX := ' + _value;
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@UStrFromWChar') then
  Begin
    //eax-Dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'UnicodeString';
    //edx-Src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'WideChar';
    line := item1.Value + ' := ' + item2.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@UStrFromLStr') then
  Begin
    //eax-Dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'UnicodeString';
    //edx-Src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'AnsiString';
    line := item1.Value + ' := ' + item2.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@UStrFromString') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'UnicodeString';
    //edx - src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'ShortString';
    line := item1.Value + ' := ' + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@UStrFromWStr') then
  Begin
    //eax-Dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'UnicodeString';
    //edx-Src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'WideString';
    line := item1.Value + ' := ' + item2.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@UStrFromPWChar') then
  Begin
    //eax - Dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'UnicodeString';
    //edx-Src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'PWideChar';
    line := item1.Value + ' := ' + item2.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@WStrToPWChar') then
  begin
    //eax - src
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'WideString';
    item1.Value := 'PWideChar(' + item1.Value + ')';
    item1._Type := 'PWideChar';
    SetRegItem(16, item1);
    line := 'EAX := ' + item1.Value + ';';
    Env.AddToBody(line);
    Exit;
  end
  else if SameText(name, '@UStrToPWChar') then
  Begin
    //eax - src
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'UnicodeString';
    item1.Value := 'PWideChar(' + item1.Value + ')';
    item1._Type := 'PWideChar';
    SetRegItem(16, item1);
    line := 'EAX := ' + item1.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@UStrToString') then
  Begin
    //eax - dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'UnicodeString';
    //edx - src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'String';
    line := item1.Value + ' := ' + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@VarClear') then
  begin
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'Variant';
    line := item1.Value + ' := 0;';
    Env.AddToBody(line);
    Exit;
  end
  else if SameText(name, '@VarAdd') then
  begin
    //eax=eax+edx
    GetRegItem(16, item1);
    GetRegItem(18, item2);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'Variant';
    if IF_STACK_PTR in item2.Flags then
      Env.Stack[item2.IntValue]._Type := 'Variant';
    line := item1.Value + ' := ' + item1.Value + ' + ' + item2.Value + ';';
    Env.AddToBody(line);
    Exit;
  end
  //Cast to Variant
  else if SameText(name, '@VarFromBool') or
    SameText(name, '@VarFromInt') or
    SameText(name, '@VarFromPStr') or
    SameText(name, '@VarFromLStr') or
    SameText(name, '@VarFromWStr') or
    SameText(name, '@VarFromUStr') or
    SameText(name, '@VarFromDisp') then
  Begin
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
    begin
      Env.Stack[item1.IntValue]._Type := 'Variant';
      line := Env.GetLvarName(item1.IntValue);
    end;
    GetRegItem(18, item2);
    line := line + ' := Variant(' + item2.Value + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@VarFromTDateTime') then
  Begin
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
    begin
      Env.Stack[item1.IntValue]._Type := 'Variant';
      line := Env.GetLvarName(item1.IntValue);
    end;
    line:=line + ' := Variant(' + FPop.Value + ')'; //FGet(0)
    Env.AddToBody(line);
    FPop;
    Exit;
  end
  else if SameText(name, '@VarFromReal') then
  begin
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      line := Env.GetLvarName(item1.IntValue);
    line:=line + ' := Variant(' + FPop.Value + ')';
    Env.AddToBody(line);
    Exit;
  end
  else if SameText(name, '@VarToInt') then
  begin
    //eax=Variant, return Integer
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'Variant';
    InitItem(@item);
    item.Value := 'Integer(' + Env.GetLvarName(item1.IntValue) + ')';
    SetRegItem(16, item);
    line := 'EAX := ' + item.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@VarToInteger') then
  Begin
    //edx=Variant, eax=Integer
    GetRegItem(18, item1);
    GetRegItem(16, item2);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'Variant';
    InitItem(@item);
    item.Value := 'Integer(' + item1.Value + ')';
    SetRegItem(16, item);
    line := Env.GetLvarName(item2.IntValue) + ' := ' + item.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@VarToLStr') then
  begin
    //edx=Variant, eax=String
    GetRegItem(18, item1);
    GetRegItem(16, item2);
    if IF_STACK_PTR in item1.Flags then
      Env.Stack[item1.IntValue]._Type := 'Variant';
    InitItem(@item);
    item.Value := 'String(' + item1.Value + ')';
    SetRegItem(16, item);
    line := Env.GetLvarName(item2.IntValue) + ' := ' + item.Value + ';';
    Env.AddToBody(line);
    Exit;
  end
  else if SameText(name, '@Write0Ext') then
  Begin
    //File
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then item1 := Env.Stack[item1.IntValue];
    //Value (Extended)
    GetFloatItemFromStack(_ESP_, @item2, FT_EXTENDED);
    Inc(_ESP_, 12);
    line := 'Write(' + ExtractClassName(item1.Value) + ', ' + item2.Value + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@Str2Ext') then
  Begin
    //Value (Extended)
    GetFloatItemFromStack(_ESP_, @item1, FT_EXTENDED); 
    Inc(_ESP_, 12);
    //Width - eax
    GetRegItem(16, item2);
    //Precision - edx
    GetRegItem(18, item3);
    //Destination - ecx
    GetRegItem(17, item4);
    line:=line + 'Str(' + item1.Value + ':' + IntToStr(item2.IntValue) 
      + ':' + IntToStr(item3.IntValue) + ', ' + item4.Value + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@Write2Ext') then
  Begin
    //File
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then item1 := Env.Stack[item1.IntValue];
    //Value (Extended)
    GetFloatItemFromStack(_ESP_, @item2, FT_EXTENDED); 
    Inc(_ESP_, 12);
    //edx
    GetRegItem(18, item3);
    //ecx
    GetRegItem(17, item4);
    line:=line + 'Write(' + ExtractClassName(item1.Value) + ', ' + item2.Value 
      + ':' + IntToStr(item3.IntValue) + ':' + IntToStr(item4.IntValue) + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@Write0Char') or
    SameText(name, '@Write0WChar') or
    SameText(name, '@WriteLong') or
    SameText(name, '@Write0Long') then
  Begin
    //File
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then item1 := Env.Stack[item1.IntValue];
    line := 'Write(' + ExtractClassName(item1.Value) + ', ';
    //edx
    GetRegItem(18, item2);
    if IF_INTVAL in item2.Flags then
      line:=line + GetImmString(item2.IntValue)
    else
      line:=line + item2.Value;
    line:=line + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@Write0LString') or
    SameText(name, '@Write0UString') then
  Begin
    //File
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then item1 := Env.Stack[item1.IntValue];
    //edx
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then item2 := Env.Stack[item2.IntValue];
    line := 'Write(' + ExtractClassName(item1.Value) + ', ' + item2.Value + ');';
    Env.AddToBody(line);
    Exit;
  End
  else if SameText(name, '@WStrFromUStr') or
    SameText(name, '@WStrFromLStr') then
  Begin
    //eax-Dst
    GetRegItem(16, item1);
    if IF_STACK_PTR in item1.Flags then
    Begin
      item := Env.Stack[item1.IntValue];
      item.Value := Env.GetLvarName(item1.IntValue);
      item._Type := 'WideString';
      Env.Stack[item1.IntValue] := item;
      item1 := item;
    End;
    //edx-Src
    GetRegItem(18, item2);
    if IF_STACK_PTR in item2.Flags then
    Begin
      item2 := Env.Stack[item2.IntValue];
      if SameText(name, '@WStrFromUStr') then
        Env.Stack[item2.IntValue]._Type := 'UnicodeString'
      else
        Env.Stack[item2.IntValue]._Type := 'String';
    End;
    line := item1.Value + ' ::= ' + item2.Value;
    Env.AddToBody(line);
    Exit;
  End
  else if (Pos('@_lldiv',name) = 1) or
    SameText(name, '@__lludiv') then
  Begin
    //Argument (Int64) in edx:eax
    GetRegItem(16, item1);
    GetRegItem(18, item2);
    if IF_INTVAL in item1.Flags then
    Begin
      _int64Val := (item2.IntValue shl 32) or item1.IntValue;
      value1 := IntToStr(_int64Val);
    End
    else if IF_STACK_PTR in item1.Flags then
    Begin
      item1 := Env.Stack[item1.IntValue];
      value1 := item1.Value;
    End
    else value1 := item1.Value;
    //Argument (Int64) in stack
    item3 := Env.Stack[_ESP_]; 
    Inc(_ESP_, 4);
    item4 := Env.Stack[_ESP_]; 
    Inc(_ESP_, 4);
    if IF_INTVAL in item3.Flags then
    Begin
      _int64Val := (item4.IntValue shl 32) or item3.IntValue;
      value2 := IntToStr(_int64Val);
    End
    else if IF_STACK_PTR in item3.Flags then
    Begin
      item3 := Env.Stack[item3.IntValue];
      value2 := item3.Value;
    End
    else value2 := item3.Value;
    InitItem(@item);
    item.Value := value1 + ' Div ' + value2;
    item._Type := 'Int64';
    SetRegItem(16, item);
    SetRegItem(18, item);
    line := 'EDX_EAX := ' + item.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if (Pos('@_llmod',name) = 1) or
    SameText(name, '@__llumod') then
  Begin
    //Argument (Int64) in edx:eax
    GetRegItem(16, item1);
    GetRegItem(18, item2);
    if IF_INTVAL in item1.Flags then
    Begin
      _int64Val := (item2.IntValue shl 32) or item1.IntValue;
      value1 := IntToStr(_int64Val);
    End
    else if IF_STACK_PTR in item1.Flags then
    Begin
      item1 := Env.Stack[item1.IntValue];
      value1 := item1.Value;
    End
    else value1 := item1.Value;
    //Argument (Int64) in stack
    item3 := Env.Stack[_ESP_]; 
    Inc(_ESP_, 4);
    item4 := Env.Stack[_ESP_]; 
    Inc(_ESP_, 4);
    if IF_INTVAL in item3.Flags then
    Begin
      _int64Val := (item4.IntValue shl 32) or item3.IntValue;
      value2 := IntToStr(_int64Val);
    End
    else if IF_STACK_PTR in item3.Flags then
    Begin
      item3 := Env.Stack[item3.IntValue];
      value2 := item3.Value;
    End
    else value2 := item3.Value;
    InitItem(@item);
    item.Value := value1 + ' Mod ' + value2;
    item._Type := 'Int64';
    SetRegItem(16, item);
    SetRegItem(18, item);
    line := 'EDX_EAX := ' + item.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  else if Pos('@_llmul',name) = 1 then
  Begin
    //Argument (Int64) in edx:eax
    GetRegItem(16, item1);
    GetRegItem(18, item2);
    if IF_INTVAL in item1.Flags then
    Begin
      _int64Val := (item2.IntValue shl 32) or item1.IntValue;
      value1 := IntToStr(_int64Val);
    End
    else if IF_STACK_PTR in item1.Flags then
    Begin
      item1 := Env.Stack[item1.IntValue];
      value1 := item1.Value;
    End
    else value1 := item1.Value;
    //Argument (Int64) in stack
    item3 := Env.Stack[_ESP_]; 
    Inc(_ESP_, 4);
    item4 := Env.Stack[_ESP_]; 
    Inc(_ESP_, 4);
    if IF_INTVAL in item3.Flags then
    Begin
      _int64Val := (item4.IntValue shl 32) or item3.IntValue;
      value2 := IntToStr(_int64Val);
    End
    else if IF_STACK_PTR in item3.Flags then
    Begin
      item3 := Env.Stack[item3.IntValue];
      value2 := item3.Value;
    End
    else value2 := item3.Value;
    InitItem(@item);
    item.Value := value1 + ' * ' + value2;
    item._Type := 'Int64';
    SetRegItem(16, item);
    SetRegItem(18, item);
    line := 'EDX_EAX := ' + item.Value + ';';
    Env.AddToBody(line);
    Exit;
  End
  //No action
  else if SameText(name, '@DoneExcept') or
    SameText(name, '@LStrAddRef') or
    SameText(name, '@WStrAddRef') or
    SameText(name, '@UStrAddRef') or
    SameText(name, '@LStrArrayClr') or
    SameText(name, '@WStrArrayClr') or
    SameText(name, '@UStrArrayClr') or
    SameText(name, '@VarClr') or
    SameText(name, '@DynArrayAddRef') or
    SameText(name, '@EnsureAnsiString') or
    SameText(name, '@EnsureUnicodeString') or
    SameText(name, '@_IOTest') or
    SameText(name, '@CheckAutoResult') or
    SameText(name, '@InitExe') or
    SameText(name, '@InitLib') then Exit;
  Env.ErrAdr := procAdr;
  raise Exception.Create('Under construction');
end;

Procedure TDecompiler.SimulateFormatCall;
var
  n, num, ofs, _esp:Integer;
  line:AnsiString;
  item:TItem;
Begin
  line:='Format(';
  //eax - format
  GetRegItem(16, item);
  line:=line + item.Value + ', [';
  //edx - pointer to args
  GetRegItem(18, item);
  ofs := item.IntValue;
  //ecx - args num
  GetRegItem(17, item);
  num := item.IntValue + 1;
  for n := 0 to num-1 do
  begin
    if n<>0 Then line:=line + ', ';
    line:=line + Env.Stack[ofs].Value;
    Inc(ofs, 5);
  End;
  line:=line + ']);';
  //Result
  _esp := _ESP_;
  Inc(_ESP_, 4);
  item := Env.Stack[_esp];
  line := item.Value + ' := ' + line;
  Env.AddToBody(line);
  Env.LastResString := '';
end;

Procedure TDecompiler.SimulateFloatInstruction (curAdr:Integer; instrLen:Integer);
var
  reverse, pop1, pop2:Boolean;
  _pos,reg1Idx, reg2Idx, sz, _ofs:Integer;
  _item, itemSrc:TItem;
  recN:InfoRec;
  _val, line:AnsiString;
Begin
  reverse := false; 
  pop1 := false; 
  pop2 := false;
  //fild, fld
  if (DisaInfo.Mnem = 'fild') or (DisaInfo.Mnem = 'fld') then
  Begin
    //op Mem
    if DisaInfo.OpType[0] = otMEM then
    Begin
      GetMemItem(curAdr, @itemSrc, 0);
      if IF_STACK_PTR in itemSrc.Flags then
      Begin
        _item := Env.Stack[itemSrc.IntValue];
        if _item.Value = '' then
        Begin
          if itemSrc.Value <> '' then
            _item.Value := itemSrc.Value;
          if itemSrc.Name <> '' then
            _item.Value := itemSrc.Name;
        End;
        _item.Precedence := PRECEDENCE_NONE;
        FPush(@_item);
        Exit;
      End;
      if IF_INTVAL in itemSrc.Flags then
      Begin
        recN := GetInfoRec(itemSrc.IntValue);
        if Assigned(recN) and recN.HasName then
        Begin
          InitItem(@_item);
          _item.Value := recN.Name;
          _item._Type := recN._Type;
          FPush(@_item);
          Exit;
        End;
      End;
      InitItem(@_item);
      if (itemSrc.Name <> '') and not IsDefaultName(itemSrc.Name) then
        _item.Value := itemSrc.Name
      else
        _item.Value := itemSrc.Value;
      _item._Type := itemSrc._Type;
      FPush(@_item);
      Exit;
    End;
  End;
  //fst, fstp
  _pos := Pos('fst',DisaInfo.Mnem);
  if _pos <> 0 then
  Begin
    if DisaInfo.Mnem[_pos+3] = 'p' then pop1 := True;
    //op Mem
    if DisaInfo.OpType[0] = otMEM then
    Begin
      GetMemItem(curAdr, @itemSrc, 0);
      if IF_STACK_PTR in itemSrc.Flags then
      Begin
        _item := Env.FStack[_TOP_];
        if pop1 then FPop;
        line := Env.GetLvarName(itemSrc.IntValue) + ' := ' + _item.Value + ';';
        Env.AddToBody(line);
        _item.Value := Env.GetLvarName(itemSrc.IntValue);
        _ofs := itemSrc.IntValue; 
        sz := DisaInfo.MemSize;
        Env.Stack[_ofs] := _item; 
        Inc(_ofs, 4);
        Dec(sz, 4);
        InitItem(@_item);
        while sz > 0 do
        Begin
          Env.Stack[_ofs] := _item; 
          Inc(_ofs, 4); 
          Dec(sz, 4);
        End;
        Exit;
      End;
      if IF_INTVAL in itemSrc.Flags then
      Begin
        recN := GetInfoRec(itemSrc.IntValue);
        if Assigned(recN) and recN.HasName then
        Begin
          _item := Env.FStack[_TOP_];
          if pop1 then FPop;
          line := recN.Name + ' := ' + _item.Value + ';';
          Env.AddToBody(line);
          Exit;
        End;
      End;
      _item := Env.FStack[_TOP_];
      if pop1 then FPop;
      if (itemSrc.Name <> '') and not IsDefaultName(itemSrc.Name) then
        line := itemSrc.Name
      else
        line := itemSrc.Value;
      line:=line + ' := ' + _item.Value + ';';
      Env.AddToBody(line);
      Exit;
    End;
    //fstp - do nothing
    if DisaInfo.OpType[0] = otFST then Exit;
  End;
  //fcom, fcomp, fcompp
  _pos := Pos('fcom',DisaInfo.Mnem);
  if _pos <> 0 then
  Begin
    if DisaInfo.Mnem[_pos+4] = 'p' then pop1 := True;
    if DisaInfo.Mnem[_pos+5] = 'p' then pop2 := True;
    if DisaInfo.OpNum = 0 then
    Begin
      CompInfo.L := FGet(0).Value;
      CompInfo.O := CmpOp;
      CompInfo.R := FGet(1).Value;
      if pop1 then
      Begin
        FPop;
        //fcompp
        if pop2 then FPop;
      End;
      Exit;
    End
    else if DisaInfo.OpNum = 1 then
    Begin
      if DisaInfo.OpType[0] = otMEM then
      Begin
        GetMemItem(curAdr, @itemSrc, 0);
        if IF_STACK_PTR in itemSrc.Flags then
        Begin
          CompInfo.L := FGet(0).Value;
          CompInfo.O := CmpOp;
          _item := Env.Stack[itemSrc.IntValue];
          if _item.Value <> '' then
            CompInfo.R := _item.Value
          else
            CompInfo.R := Env.GetLvarName(itemSrc.IntValue);
          if pop1 then
          Begin
            FPop;
            //fcompp
            if pop2 then FPop;
          End;
          Exit;
        End;
        if IF_INTVAL in itemSrc.Flags then
        Begin
          recN := GetInfoRec(itemSrc.IntValue);
          if Assigned(recN) and recN.HasName then
          Begin
            CompInfo.L := FGet(0).Value;
            CompInfo.O := CmpOp;
            CompInfo.R := recN.Name;
            if pop1 then
            Begin
              FPop;
              //fcompp
              if pop2 then FPop;
            End;
            Exit;
          End;
        End;
        CompInfo.L := FGet(0).Value;
        CompInfo.O := CmpOp;
        CompInfo.R := itemSrc.Value;
        if pop1 then
        Begin
          FPop;
          //fcompp
          if pop2 then FPop;
        End;
        Exit;
      End;
    End;
  End;
  //fadd, fiadd, faddp
  _pos := Pos('fadd',DisaInfo.Mnem);
  if _pos <> 0 then
  Begin
    if DisaInfo.Mnem[_pos+4] = 'p' then pop1 := True;
    //faddp (ST(1) := ST(0) + ST(1) and pop)
    if DisaInfo.OpNum = 0 then
    Begin
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_ADD;
      _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' + ' + GetString(FGet(1), PRECEDENCE_ADD);
      _item._Type := 'Extended';
      FSet(1, @_item);
      FPop;
      Exit;
    End
    //fadd r/m (ST(0) := ST(0) + r/m)
    else if DisaInfo.OpNum = 1 then
    Begin
      if DisaInfo.OpType[0] = otMEM then
      Begin
        GetMemItem(curAdr, @itemSrc, 0);
        if IF_STACK_PTR in itemSrc.Flags then
        Begin
          _item := Env.Stack[itemSrc.IntValue];
          if _item.Value <> '' then
            _val := GetString(@_item, PRECEDENCE_ADD)
          else
            _val := Env.GetLvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_ADD;
          _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' + ' + _val;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        if  IF_INTVAL in itemSrc.Flags then
        Begin
          recN := GetInfoRec(itemSrc.IntValue);
          if Assigned(recN) and recN.HasName then
            _val := recN.Name
          else
            _val := GetGvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_ADD;
          _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' + ' + recN.Name;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        InitItem(@_item);
        _item.Precedence := PRECEDENCE_ADD;
        _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' + ' + itemSrc.Value;
        _item._Type := 'Extended';
        FSet(0, @_item);
        Exit;
      End;
    End
    //fadd ST(X), ST(Y) (ST(X) := ST(X)+ST(Y))
    else if DisaInfo.OpNum = 2 then
    Begin
      reg1Idx := DisaInfo.OpRegIdx[0] - 30;
      reg2Idx := DisaInfo.OpRegIdx[1] - 30;
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_ADD;
      _item.Value := GetString(FGet(reg1Idx), PRECEDENCE_ADD) + ' + ' + GetString(FGet(reg2Idx), PRECEDENCE_ADD);
      _item._Type := 'Extended';
      FSet(reg1Idx, @_item);
      //faddp
      if pop1 then FPop;
      Exit;
    End;
  End;
  //fsub, fisub, fsubp, fsubr, fisubr, fsubrp
  _pos := Pos('fsub',DisaInfo.Mnem);
  if _pos <>0 then
  Begin
    if DisaInfo.Mnem[_pos+4] = 'r' then
    Begin
      reverse := true;
      if DisaInfo.Mnem[_pos+5] = 'p' then pop1 := True;
    End;
    if DisaInfo.Mnem[_pos+4] = 'p' then pop1 := True;
    //fsubp, fsubrp (ST(1) := ST(1) - ST(0) and pop)
    if DisaInfo.OpNum = 0 then
    Begin
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_ADD;
      if reverse then
        _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' - ' + GetString(FGet(1), PRECEDENCE_ADD)
      else
        _item.Value := GetString(FGet(1), PRECEDENCE_ADD) + ' - ' + GetString(FGet(0), PRECEDENCE_ADD);
      _item._Type := 'Extended';
      FSet(1, @_item);
      FPop;
      Exit;
    End
    //fsub r/m (ST(0) := ST(0) - r/m)
    else if DisaInfo.OpNum = 1 then
    Begin
      if DisaInfo.OpType[0] = otMEM then
      Begin
        GetMemItem(curAdr, @itemSrc, 0);
        if IF_STACK_PTR in itemSrc.Flags then
        Begin
          _item := Env.Stack[itemSrc.IntValue];
          if _item.Value <> '' then
            _val := GetString(@_item, PRECEDENCE_ADD)
          else
            _val := Env.GetLvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_ADD;
          if reverse then
            _item.Value := _val + ' - ' + GetString(FGet(0), PRECEDENCE_ADD)
          else
            _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' - ' + _val;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        if  IF_INTVAL in itemSrc.Flags then
        Begin
          recN := GetInfoRec(itemSrc.IntValue);
          if Assigned(recN) and recN.HasName then
            _val := recN.Name
          else
            _val := GetGvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_ADD;
          if reverse then
            _item.Value := _val + ' - ' + GetString(FGet(0), PRECEDENCE_ADD)
          else
            _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' - ' + _val;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        InitItem(@_item);
        _item.Precedence := PRECEDENCE_ADD;
        if reverse then
          _item.Value := itemSrc.Value + ' - ' + GetString(FGet(0), PRECEDENCE_ADD)
        else
          _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' - ' + itemSrc.Value;
        _item._Type := 'Extended';
        FSet(0, @_item);
        Exit;
      End;
    End
    //fsub ST(X), ST(Y) (ST(X) := ST(X)-ST(Y))
    else if DisaInfo.OpNum = 2 then
    Begin
      reg1Idx := DisaInfo.OpRegIdx[0] - 30;
      reg2Idx := DisaInfo.OpRegIdx[1] - 30;
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_ADD;
      if reverse then
        _item.Value := GetString(FGet(reg2Idx), PRECEDENCE_ADD) + ' - ' + GetString(FGet(reg1Idx), PRECEDENCE_ADD)
      else
        _item.Value := GetString(FGet(reg1Idx), PRECEDENCE_ADD) + ' - ' + GetString(FGet(reg2Idx), PRECEDENCE_ADD);
      _item._Type := 'Extended';
      FSet(reg1Idx, @_item);
      //fsubp
      if pop1 then FPop;
      Exit;
    End;
  End;
  //fmul, fimul, fmulp
  _pos := Pos('fmul',DisaInfo.Mnem);
  if _pos <>0 then
  Begin
    if DisaInfo.Mnem[_pos+4] = 'p' then pop1 := True;
    //fmulp (ST(1) := ST(0) * ST(1) and pop)
    if DisaInfo.OpNum = 0 then
    Begin
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_MULT;
      _item.Value := GetString(FGet(0), PRECEDENCE_MULT) + ' * ' + GetString(FGet(1), PRECEDENCE_MULT);
      _item._Type := 'Extended';
      FSet(1, @_item);
      FPop;
      Exit;
    End
    //fmul r/m (ST(0) := r/m * ST(0))
    else if DisaInfo.OpNum = 1 then
    Begin
      if DisaInfo.OpType[0] = otMEM then
      Begin
        GetMemItem(curAdr, @itemSrc, 0);
        if IF_STACK_PTR in itemSrc.Flags then
        Begin
          _item := Env.Stack[itemSrc.IntValue];
          if _item.Value <> '' then
            _val := GetString(@_item, PRECEDENCE_MULT)
          else
            _val := Env.GetLvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_MULT;
          _item.Value := GetString(FGet(0), PRECEDENCE_MULT) + ' * ' + _val;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        if  IF_INTVAL in itemSrc.Flags then
        Begin
          recN := GetInfoRec(itemSrc.IntValue);
          if Assigned(recN) and recN.HasName then
            _val := recN.Name
          else
            _val := GetGvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_MULT;
          _item.Value := GetString(FGet(0), PRECEDENCE_MULT) + ' * ' + _val;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        InitItem(@_item);
        _item.Precedence := PRECEDENCE_ADD;
        _item.Value := GetString(FGet(0), PRECEDENCE_MULT) + ' * ' + itemSrc.Value;
        _item._Type := 'Extended';
        FSet(0, @_item);
        Exit;
      End;
    End
    //fmul ST(X), ST(Y) (ST(X) := ST(X)*ST(Y))
    else if DisaInfo.OpNum = 2 then
    Begin
      reg1Idx := DisaInfo.OpRegIdx[0] - 30;
      reg2Idx := DisaInfo.OpRegIdx[1] - 30;
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_MULT;
      _item.Value := GetString(FGet(reg1Idx), PRECEDENCE_MULT) + ' * ' + GetString(FGet(reg2Idx), PRECEDENCE_MULT);
      _item._Type := 'Extended';
      FSet(reg1Idx, @_item);
      //fmulp
      if pop1 then FPop;
      Exit;
    End;
  End;
  //fdiv, fdivr, fidiv, fidivr, fdivp, fdivrp
  _pos := Pos('fdiv',DisaInfo.Mnem);
  if _pos <>0 then
  Begin
    if DisaInfo.Mnem[_pos+4] = 'r' then
    Begin
      reverse := true;
      if DisaInfo.Mnem[_pos+5] = 'p' then pop1 := True;
    End;
    if DisaInfo.Mnem[_pos+4] = 'p' then pop1 := True;

    //fdivp (ST(1) := ST(1) / ST(0) and pop)
    //fdivrp (ST(1) := ST(0) / ST(1) and pop)
    if DisaInfo.OpNum = 0 then
    Begin
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_MULT;
      if reverse then
        _item.Value := GetString(FGet(0), PRECEDENCE_MULT) + ' / ' + GetString(FGet(1), PRECEDENCE_MULT)
      else
        _item.Value := GetString(FGet(1), PRECEDENCE_MULT) + ' / ' + GetString(FGet(0), PRECEDENCE_MULT);
      _item._Type := 'Extended';
      FSet(1, @_item);
      FPop;
      Exit;
    End
    //fdiv r/m (ST(0) := ST(0) / r/m)
    //fdivr r/m (ST(0) := r/m / ST(0))
    else if DisaInfo.OpNum = 1 then
    Begin
      if DisaInfo.OpType[0] = otMEM then
      Begin
        GetMemItem(curAdr, @itemSrc, 0);
        if IF_STACK_PTR in itemSrc.Flags then
        Begin
          _item := Env.Stack[itemSrc.IntValue];
          if _item.Value <> '' then
            _val := GetString(@_item, PRECEDENCE_MULT)
          else
            _val := Env.GetLvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_MULT;
          if reverse then
            _item.Value := _val + ' / ' + GetString(FGet(0), PRECEDENCE_ADD)
          else
            _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' / ' + _val;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        if  IF_INTVAL in itemSrc.Flags then
        Begin
          recN := GetInfoRec(itemSrc.IntValue);
          if Assigned(recN) and recN.HasName then
            _val := recN.Name
          else
            _val := GetGvarName(itemSrc.IntValue);
          InitItem(@_item);
          _item.Precedence := PRECEDENCE_MULT;
          if reverse then
            _item.Value := _val + ' / ' + GetString(FGet(0), PRECEDENCE_ADD)
          else
            _item.Value := GetString(FGet(0), PRECEDENCE_ADD) + ' / ' + _val;
          _item._Type := 'Extended';
          FSet(0, @_item);
          Exit;
        End;
        InitItem(@_item);
        _item.Precedence := PRECEDENCE_MULT;
        if reverse then
          _item.Value := itemSrc.Value + ' / ' + GetString(FGet(0), PRECEDENCE_MULT)
        else
          _item.Value := GetString(FGet(0), PRECEDENCE_MULT) + ' / ' + itemSrc.Value;
        _item._Type := 'Extended';
        FSet(0, @_item);
        Exit;
      End;
    End
    //fdiv(p) ST(X), ST(Y) (ST(X) := ST(X)/ST(Y))
    //fdivr(p) ST(X), ST(Y) (ST(X) := ST(X)/ST(Y))
    else if DisaInfo.OpNum = 2 then
    Begin
      reg1Idx := DisaInfo.OpRegIdx[0] - 30;
      reg2Idx := DisaInfo.OpRegIdx[1] - 30;
      InitItem(@_item);
      _item.Precedence := PRECEDENCE_MULT;
      if reverse then
        _item.Value := GetString(FGet(reg2Idx), PRECEDENCE_MULT) + ' / ' + GetString(FGet(reg1Idx), PRECEDENCE_MULT)
      else
        _item.Value := GetString(FGet(reg1Idx), PRECEDENCE_MULT) + ' / ' + GetString(FGet(reg2Idx), PRECEDENCE_MULT);
      _item._Type := 'Extended';
      FSet(reg1Idx, @_item);
      //fdivp
      if pop1 then FPop;
      Exit;
    End;
  End;
  //fabs
  if DisaInfo.Mnem = 'fabs' then
  Begin
    InitItem(@_item);
    _item.Precedence := PRECEDENCE_ATOM;
    _item.Value := 'Abs(' + FGet(0).Value + ')';
    _item._Type := 'Extended';
    FSet(0, @_item);
    Exit;
  End
  //fchs
  else if DisaInfo.Mnem = 'fchs' then
  Begin
    _item := Env.FStack[_TOP_];
    _item.Value := '-' + _item.Value;
    FSet(0, @_item);
    Exit;
  End
  //fld1
  else if DisaInfo.Mnem = 'fld1' then
  Begin
    InitItem(@_item);
    _item.Precedence := PRECEDENCE_ATOM;
    _item.Value := '1.0';
    _item._Type := 'Extended';
    FPush(@_item);
    Exit;
  End
  //fpatan
  else if DisaInfo.Mnem = 'fpatan' then
  Begin
    InitItem(@_item);
    _item.Precedence := PRECEDENCE_ATOM;
    if SameText(FGet(0).Value, '1.0') then
      _item.Value := 'ArcTan(' + FGet(1).Value + ')'
    else
      _item.Value := 'ArcTan(' + FGet(1).Value + ' / ' + FGet(0).Value + ')';
    _item._Type := 'Extended';
    FSet(1, @_item);
    FPop;
    Exit;
  End
  //fsqrt
  else if DisaInfo.Mnem = 'fsqrt' then
  Begin
    InitItem(@_item);
    _item.Precedence := PRECEDENCE_ATOM;
    _item.Value := 'Sqrt(' + FGet(0).Value + ')';
    _item._Type := 'Extended';
    FSet(0, @_item);
    Exit;
  End;
  Env.ErrAdr := curAdr;
  raise Exception.Create('Under construction');
end;

Procedure TDecompileEnv.AddToBody (src:AnsiString);
Begin
  Body.Add(src);
end;

Procedure TDecompileEnv.AddToBody(src:TStringList);
var
  n:Integer;
Begin
  for n := 0 to src.Count-1 do
    Body.Add(src[n]);
end;

Function TDecompileEnv.IsExitAtBodyEnd:Boolean;
Begin
  Result:=SameText(Body[Body.Count - 1], 'Exit;');
end;

Procedure TDecompiler.GetCycleIdx (IdxInfo:PIdxInfo; ADisInfo:TDisInfo);
var
  item:TItem;
Begin
  with IdxInfo^ do
  begin
    IdxType := itUNK;
    IdxValue := 0;
    IdxStr := ADisInfo.Op1;
  end;
  if ADisInfo.OpType[0] = otREG then
  begin
    IdxInfo.IdxType := itREG;
    IdxInfo.IdxValue := ADisInfo.OpRegIdx[0];
  end
  else if ADisInfo.OpType[0] = otMEM then
  begin
    //Offset
    if ADisInfo.BaseReg = -1 then
    begin
      IdxInfo.IdxType := itGVAR;
      IdxInfo.IdxValue := ADisInfo.Offset;
      IdxInfo.IdxStr := ADisInfo.Op1;
    end
    //[ebp-N]
    else if ADisInfo.BaseReg = 21 then
    begin
      GetRegItem(ADisInfo.BaseReg, item);
      IdxInfo.IdxType := itLVAR;
      IdxInfo.IdxValue := item.IntValue + ADisInfo.Offset; //LocBase - (item.Value + ADisInfo.Offset);
    end
    //[esp-N]
    else if ADisInfo.BaseReg = 20 then
    begin
      IdxInfo.IdxType := itLVAR;
      IdxInfo.IdxValue := _ESP_ + ADisInfo.Offset; //LocBase - (_ESP_ + ADisInfo.Offset);
    end;
  end;
end;

Function TDecompiler.GetCycleFrom:AnsiString;
var
  item:TItem;
Begin
  if DisaInfo.OpType[1] = otIMM Then Result:=IntToStr(DisaInfo.Immediate)
  Else if DisaInfo.OpType[1] = otREG then
  begin
    GetRegItem(DisaInfo.OpRegIdx[1], item);
    Result:=item.Value;
  end
  else if DisaInfo.OpType[1] = otMEM then
  begin
    //Offset
    if DisaInfo.BaseReg = -1 Then Result:=GetGvarName(DisaInfo.Offset)
    //[ebp-N]
    else if DisaInfo.BaseReg = 21 then
    begin
      GetRegItem(DisaInfo.BaseReg, item);
      item := Env.Stack[item.IntValue + DisaInfo.Offset];
      Result:=item.Value;
    end
    //[esp-N]
    else if DisaInfo.BaseReg = 20 then
    begin
      GetRegItem(DisaInfo.BaseReg, item);
      item := Env.Stack[_ESP_ + DisaInfo.Offset];
      Result:=item.Value;
    end;
  end
  else Result:='?';
end;

Function TDecompiler.GetCycleTo:AnsiString;
var
  item:TItem;
Begin
  if DisaInfo.OpType[0] = otREG then
  begin
    GetRegItem(DisaInfo.OpRegIdx[0], item);
    Result:=item.Value;
  end
  Else if DisaInfo.OpType[0] = otMEM then
  begin
    //Offset
    if DisaInfo.BaseReg = -1 Then Result:=GetGvarName(DisaInfo.Offset)
    //[ebp-N]
    else if DisaInfo.BaseReg = 21 then
    begin
      GetRegItem(DisaInfo.BaseReg, item);
      item := Env.Stack[item.IntValue + DisaInfo.Offset];
      Result:=item.Value;
    end
    //[esp-N]
    else if DisaInfo.BaseReg = 20 then
    begin
      GetRegItem(DisaInfo.BaseReg, item);
      item := Env.Stack[_ESP_ + DisaInfo.Offset];
      Result:=item.Value;
    end;
  end
  else Result:='?';
end;

Function TDecompiler.DecompileGeneralCase (fromAdr, markAdr:Integer; loopInfo:TLoopInfo; Q:Integer):Integer;
var
  _N, N1, N2:Integer;
  curAdr, adr, endAdr, begAdr:Integer;
  curPos:Integer;
  len:Integer;
  de:TDecompiler;
  _disInfo:TDisInfo;
  dd:AnsiString;
Begin
  N1:=Q;
  curAdr:=fromAdr;
  endAdr:=0;
  curPos:= Adr2Pos(fromAdr);
  while true do
  Begin
    len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
    dd:=_disInfo.Mnem;
    //Switch at current address
    if IsFlagSet([cfSwitch], curPos) then
    Begin
      de := TDecompiler.Create(Env);
      begAdr := curAdr;
      Env.SaveContext(begAdr);
      de.SetStackPointers(Self);
      de.SetDeFlags(DeFlags);
      de.MarkGeneralCase(markAdr);
      de.ClearStop(curAdr);
      try
        adr := de.DecompileCaseEnum(begAdr, 0, loopInfo);
        if adr > endAdr then endAdr := adr;
      Except
         on E:Exception do
        Begin
          de.Free;
          raise Exception.Create('GeneralCase.' + E.Message);
        End;
      end;
      Env.RestoreContext(begAdr);
      de.Free;
      Result:=endAdr;
      Exit;
    End
    //Switch at next address
    else if IsFlagSet([cfSwitch], curPos + len) then
    Begin
      _N := _disInfo.Immediate;
      //add or sub
      if dd = 'add' then _N := -_N;
      Inc(curAdr, len); 
      Inc(curPos, len);
      begAdr := curAdr;
      Env.SaveContext(begAdr);
      de := TDecompiler.Create(Env);
      de.SetStackPointers(Self);
      de.SetDeFlags(DeFlags);
      de.MarkGeneralCase(curAdr); //markAdr
      de.ClearStop(curAdr);
      try
        adr := de.DecompileCaseEnum(begAdr, _N, loopInfo);
        if adr > endAdr then endAdr := adr;
      Except
        on E:Exception do
        Begin
          de.Free;
          raise Exception.Create('GeneralCase.' + E.Message);
        End;
      end;
      Env.RestoreContext(begAdr);
      de.Free;
      Result:=endAdr;
      Exit;
    End
    //cmp reg, imm
    else if (dd = 'cmp') and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otIMM) then
    Begin
      _N := _disInfo.Immediate;
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @_disInfo, Nil);
      dd := _disInfo.Mnem;
      if (dd = 'jb') or (dd = 'jg') or (dd = 'jge') then
      Begin
        adr := DecompileGeneralCase(_disInfo.Immediate, markAdr, loopInfo, N1);
        if adr > endAdr then endAdr := adr;
        Inc(curAdr, len); 
        Inc(curPos, len);
        len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
        dd := _disInfo.Mnem;
        if (dd = 'jz') or (dd = 'je') then
        Begin
          Env.AddToBody(IntToStr(_N) + ':');
          begAdr := _disInfo.Immediate;
          Env.SaveContext(begAdr);
          de := TDecompiler.Create(Env);
          de.SetStackPointers(Self);
          de.SetDeFlags(DeFlags);
          de.MarkGeneralCase(markAdr);
          de.ClearStop(begAdr);
          try
            Env.AddToBody('begin');
            adr := de.Decompile(begAdr, [], loopInfo);
            if adr > endAdr then endAdr := adr;
            Env.AddToBody('end');
          Except
            on E:Exception do
            Begin
              de.Free;
              raise Exception.Create('GeneralCase.' + E.Message);
            End;
          end;
          Env.RestoreContext(begAdr);
          de.Free;
          Inc(curAdr, len); 
          Inc(curPos, len);
        End;
        continue;
      End;
    End
    //dec reg; sub reg, imm
    else if ((dd = 'sub') and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otIMM)) 
      or ((dd = 'dec') and (_disInfo.OpType[0] = otREG)) then
    Begin
      if dd = 'sub' then
        N2 := _disInfo.Immediate
      else
        N2 := 1;
      Inc(N1, N2);
      if _disInfo.OpRegIdx[0] < 8 then
        N1 := N1 and 255
      else if _disInfo.OpRegIdx[0] < 16 then
        N1 := N1 and $FFFF;
      Inc(curAdr, len); 
      Inc(curPos, len);
      len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
      dd := _disInfo.Mnem;
      if dd = 'jb' then
      Begin
        Env.AddToBody(IntToStr(N1 - N2) + '..' + IntToStr(N1 - 1) + ':');
        begAdr := _disInfo.Immediate;
        Env.SaveContext(begAdr);
        de := TDecompiler.Create(Env);
        de.SetStackPointers(Self);
        de.SetDeFlags(DeFlags);
        de.MarkGeneralCase(markAdr);
        de.ClearStop(begAdr);
        try
          Env.AddToBody('begin');
          adr := de.Decompile(begAdr, [], loopInfo);
          if adr > endAdr then endAdr := adr;
          Env.AddToBody('end');
        Except
          on E:Exception do
          Begin
            de.Free;
            raise Exception.Create('GeneralCase.' + E.Message);
          End;
        end;
        Env.RestoreContext(begAdr);
        de.Free;
        Inc(curAdr, len); 
        Inc(curPos, len);
        len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
        dd := _disInfo.Mnem;
        if (dd = 'jz') or (dd = 'je') then
        Begin
          Env.AddToBody(IntToStr(N1) + ':');
          begAdr := _disInfo.Immediate;
          Env.SaveContext(begAdr);
          de := TDecompiler.Create(Env);
          de.SetStackPointers(Self);
          de.SetDeFlags(DeFlags);
          de.MarkGeneralCase(markAdr);
          de.ClearStop(begAdr);
          try
            Env.AddToBody('begin');
            adr := de.Decompile(begAdr, [], loopInfo);
            if adr > endAdr then endAdr := adr;
            Env.AddToBody('end');
          Except
            on E:Exception do
            Begin
              de.Free;
              raise Exception.Create('GeneralCase.' + E.Message);
            End;
          end;
          Env.RestoreContext(begAdr);
          de.Free;
          Inc(curAdr, len); 
          Inc(curPos, len);
        End;
        continue;
      End
      else if (dd = 'jz') or (dd = 'je') then
      Begin
        Env.AddToBody(IntToStr(N1) + ':');
        begAdr := _disInfo.Immediate;
        Env.SaveContext(begAdr);
        de := TDecompiler.Create(Env);
        de.SetStackPointers(Self);
        de.SetDeFlags(DeFlags);
        de.MarkGeneralCase(markAdr);
        de.ClearStop(begAdr);
        try
          Env.AddToBody('begin');
          adr := de.Decompile(begAdr, [], loopInfo);
          if adr > endAdr then endAdr := adr;
          Env.AddToBody('end');
        Except
          on E:Exception do
          Begin
            de.Free;
            raise Exception.Create('GeneralCase.' + E.Message);
          End;
        end;
        Env.RestoreContext(begAdr);
        de.Free;
        Inc(curAdr, len); 
        Inc(curPos, len);
        continue;
      End
      else if (dd = 'jnz') or (dd = 'jne') then
      Begin
        Env.AddToBody(IntToStr(N1) + ':');
        begAdr := curAdr + len;
        Env.SaveContext(begAdr);
        de := TDecompiler.Create(Env);
        de.SetStackPointers(Self);
        de.SetDeFlags(DeFlags);
        de.MarkGeneralCase(markAdr);
        try
          Env.AddToBody('begin');
          adr := de.Decompile(begAdr, [], loopInfo);
          if adr > endAdr then endAdr := adr;
          Env.AddToBody('end');
        Except
          on E:Exception do
          Begin
            de.Free;
            raise Exception.Create('GeneralCase.' + E.Message);
          End;
        end;
        Env.RestoreContext(begAdr);
        de.Free;
        break;
      End;
    End
    //inc reg; add reg, imm
    else if ((dd = 'add') and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otIMM)) 
      or ((dd = 'inc') and (_disInfo.OpType[0] = otREG)) then
    Begin
      if dd = 'add' then
        N2 := _disInfo.Immediate
      else
        N2 := 1;
      Dec(N1, N2);
      if _disInfo.OpRegIdx[0] < 8 then
        N1 := N1 and 255
      else if _disInfo.OpRegIdx[0] < 16 then
        N1 := N1 and $FFFF;
      Inc(curAdr, len); 
      Inc(curPos, len);
      len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
      dd := _disInfo.Mnem;
      if (dd = 'jz') or (dd = 'je') then
      Begin
        Env.AddToBody(IntToStr(N1) + ':');
        begAdr := _disInfo.Immediate;
        Env.SaveContext(begAdr);
        de := TDecompiler.Create(Env);
        de.SetStackPointers(Self);
        de.SetDeFlags(DeFlags);
        de.MarkGeneralCase(markAdr);
        de.ClearStop(begAdr);
        try
          Env.AddToBody('begin');
          adr := de.Decompile(begAdr, [], loopInfo);
          if adr > endAdr then endAdr := adr;
          Env.AddToBody('end');
        Except
          on E:Exception do
          Begin
            de.Free;
            raise Exception.Create('GeneralCase.' + E.Message);
          End;
        end;
        Env.RestoreContext(begAdr);
        de.Free;
        Inc(curAdr, len);
        Inc(curPos, len);
        continue;
      End;
    End
    else if dd = 'jmp' then break;
  End;
  Result:=endAdr;
end;

Procedure TDecompiler.MarkGeneralCase (fromAdr:Integer);
var
  dd:AnsiString;
  curAdr, curPos, len:Integer;
  _disInfo:TDisInfo;
Begin
  curAdr:=fromAdr;
  curPos:= Adr2Pos(fromAdr);
  while true do
  Begin
    len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
    dd := _disInfo.Mnem;
    //Switch at current address
    if IsFlagSet([cfSwitch], curPos) then
    Begin
      //frmDisasm.Disassemble(Code + _curPos + _len, _curAdr + _len, @_disInfo, Nil); //ja
      MarkCaseEnum(curAdr);
      Exit;
    End
    //Switch at next address
    else if IsFlagSet([cfSwitch], curPos + len) then
    Begin
      Inc(curPos, len); 
      Inc(curAdr, len);
      //_len := frmDisasm.Disassemble(Code + _curPos, _curAdr, @_disInfo, Nil); //ja
      //Inc(_curPos, _len)
      //Inc(_curAdr, _len);
      MarkCaseEnum(curAdr);
      Exit;
    End
    //cmp reg, imm
    else if (dd = 'cmp') and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otIMM) then
    Begin
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @_disInfo, Nil);
      dd := _disInfo.Mnem;
      if (dd = 'jb') or (dd = 'jg') or (dd = 'jge') then
      Begin
        MarkGeneralCase(_disInfo.Immediate);
        Inc(curAdr, len); 
        Inc(curPos, len);
        len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
        dd := _disInfo.Mnem;
        if (dd = 'jz') or (dd = 'je') then
        Begin
          SetStop(_disInfo.Immediate);
          Inc(curAdr, len); 
          Inc(curPos, len);
        End;
        continue;
      End;
    End
    //sub reg, imm; dec reg
    else if ((dd = 'sub') and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otIMM)) 
      or ((dd = 'dec') and (_disInfo.OpType[0] = otREG)) then
    Begin
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @_disInfo, Nil);
      dd := _disInfo.Mnem;
      if dd = 'sub' then
      Begin
        len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @_disInfo, Nil);
        dd := _disInfo.Mnem;
      End
      else if dd = 'jb' then
      Begin
        SetStop(_disInfo.Immediate);
        Inc(curAdr, len); 
        Inc(curPos, len);
        len := frmDisasm.Disassemble(Code + curPos, curAdr, @_disInfo, Nil);
        dd := _disInfo.Mnem;
        if (dd = 'jz') or (dd = 'je') then
        Begin
          SetStop(_disInfo.Immediate);
          Inc(curAdr, len); 
          Inc(curPos, len);
        End;
        continue;
      End
      else if (dd = 'jz') or (dd = 'je') then
      Begin
        SetStop(_disInfo.Immediate);
        Inc(curAdr, len); 
        Inc(curPos, len);
        continue;
      End
      else if (dd = 'jnz') or (dd = 'jne') then break;
    End
    //add reg, imm; inc reg
    else if ((dd = 'add') and (_disInfo.OpType[0] = otREG) and (_disInfo.OpType[1] = otIMM)) 
      or ((dd = 'inc') and (_disInfo.OpType[0] = otREG)) then
    Begin
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @_disInfo, Nil);
      dd := _disInfo.Mnem;
      if dd = 'sub' then
      Begin
        len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @_disInfo, Nil);
        dd := _disInfo.Mnem;
        if dd = 'jb' then
        Begin
          SetStop(_disInfo.Immediate);
          Inc(curAdr, len); 
          Inc(curPos, len);
          continue;
        End;
      End
      else if (dd = 'jz') or (dd = 'je') then
      Begin
        SetStop(_disInfo.Immediate);
        Inc(curAdr, len);
        Inc(curPos, len);
        continue;
      End;
    End
    else if dd = 'jmp' then
    Begin
      SetStop(_disInfo.Immediate);
      break;
    End;
  End;
end;

Function TDecompiler.GetArrayFieldOffset (ATypeName:AnsiString; AFromOfs, AScale:Integer):FieldInfo;
var
  _vmt:Boolean;
  _offset,classSize,_vmtAdr,_size,l_idx,h_idx,ofs:Integer;
  fInfo:FieldInfo;
Begin
  Result:=Nil;
  _offset:=AFromOfs;
  classSize := GetClassSize(GetClassAdr(ATypeName));
  while True do
  begin
    if _offset >= classSize then break;
    fInfo := FMain.GetField(ATypeName, _offset, _vmt, _vmtAdr);
    if Assigned(fInfo) and (GetTypeKind(fInfo._Type, _size) = ikArray)
      and GetArrayIndexes(fInfo._Type, 1, l_Idx, h_Idx) then
    begin
      _size := GetArrayElementTypeSize(fInfo._Type);
      ofs := AFromOfs + AScale * l_Idx;
      if (ofs >= fInfo.Offset) and (ofs <= fInfo.Offset + (h_Idx - l_Idx) * _size) then
      begin
        Result:=fInfo;
        Exit;
      end;
    End;
    //Try next offset
    Inc(_offset);
  end;
end;

procedure TDecompiler.GetFloatItemFromStack(Esp:Integer; Dst:PITEM; FloatType:TFloatKind);
var
  binData:Array[0..15] of Byte;
  singleVal:Single;
  doubleVal:Double;
  extVal:Extended;
  realVal:Real;
  compVal:Comp;
  item:TItem;
Begin
  InitItem(Dst);
  item := Env.Stack[Esp];
  if not(IF_INTVAL in item.Flags) then
  begin
    Dst.Value := item.Value;
    Dst._Type := item._Type;
    Exit;
  End;
  FillMemory(@binData[0], Length(binData), 0);
  MoveMemory(@binData[0], @item.IntValue, 4);
  if FloatType = FT_SINGLE then
  begin
    singleVal := 0;
    MoveMemory(@singleVal, @binData[0], 4);
    Dst.Value := FloatToStr(singleVal);
    Dst._Type := 'Single';
    Exit;
  end
  else if FloatType = FT_REAL then
  begin
    realVal := 0;
    MoveMemory(@realVal, @binData[0], 4);
    Dst.Value := FloatToStr(realVal);
    Dst._Type := 'Real';
    Exit;
  End;
  item := Env.Stack[Esp + 4];
  MoveMemory(@binData[4], @item.IntValue, 4);
  if FloatType = FT_DOUBLE then
  begin
    doubleVal := 0;
    MoveMemory(@doubleVal, @binData[0], 8);
    Dst.Value := FloatToStr(doubleVal);
    Dst._Type := 'Double';
    Exit;
  end
  Else if FloatType = FT_COMP then
  begin
    compVal := 0;
    MoveMemory(@compVal, @binData[0], 8);
    Dst.Value := FloatToStr(compVal);
    Dst._Type := 'Comp';
    Exit;
  end;
  item := Env.Stack[Esp + 8];
  MoveMemory(@binData[8], @item.IntValue, 4);
  if FloatType = FT_EXTENDED then
  begin
    extVal := 0;
    MoveMemory(@extVal, @binData[0], 10);
    try
      Dst.Value := FloatToStr(extVal);
      Dst._Type := 'Extended';
    Except
      on E:Exception do
        raise Exception.Create('Extended floating point error - ' + E.Message);
    end;
  end;
end;

Procedure TDecompiler.GetMemItem (CurAdr:Integer; Dst:PITEM; Op:Byte);
var
  _vmt:Boolean;
  kind:LKind;
  offset, foffset, size, idx, idx1, _mod, k:Integer;
  adr, vmtAdr:Integer;
  recN:InfoRec;
  fInfo:FieldInfo;
  item, itemBase, itemIndx:TItem;
  _fname, _name, typeName, iname, _value, txt:AnsiString;
Begin
  InitItem(Dst);
  offset := DisaInfo.Offset;
  if DisaInfo.BaseReg = -1 then
  Begin
    if DisaInfo.IndxReg = -1 then
    Begin
      //[Offset]
      if IsValidImageAdr(offset) then
      Begin
        Dst.Flags := [IF_INTVAL];
        Dst.IntValue := offset;
        Exit;
      End;
      Env.ErrAdr := CurAdr;
      raise Exception.Create('Address '+Val2Str(offset)+' is outside program image');
    End;
    //[Offset + IndxReg*Scale]
    if IsValidImageAdr(offset) then
    Begin
      recN := GetInfoRec(offset);
      if Assigned(recN) and recN.HasName then
        _name := recN.Name
      else
        _name := GetGvarName(offset);
      Dst.Value := _name + '[' + GetDecompilerRegisterName(DisaInfo.IndxReg) + ']';
      Exit;
    End;
    Env.ErrAdr := CurAdr;
    raise Exception.Create('Address '+Val2Str(offset)+' is outside program image');
  End;
  GetRegItem(DisaInfo.BaseReg, itemBase);
  //[BaseReg + Offset]
  if DisaInfo.IndxReg = -1 then
  Begin
    //[esp+N]
    if DisaInfo.BaseReg = 20 then
    Begin
      Dst.Flags := [IF_STACK_PTR];
      Dst.IntValue := _ESP_ + offset;
      item := Env.Stack[_ESP_ + offset];
      //Field
      if IF_FIELD in item.Flags then
      Begin
        foffset := item.Offset;
        Dec(offset, foffset);
        _fname := GetRecordFields(foffset, Env.Stack[_ESP_ + offset]._Type);
        _name := Env.GetLvarName(_ESP_ + offset);
        if Pos(':',_fname)<>0 then
        Begin
          Dst.Value := _name + '.' + ExtractName(_fname);
          Dst._Type := ExtractType(_fname);
        End
        else Dst.Value := _name + '.f' + Val2Str(foffset);
        Dst.Name := Dst.Value;
        Exit;
      End;
      _value := Env.GetLvarName(_ESP_ + offset);
      if item.Value <> '' then _value := _value + 'Begin' + item.Value + 'End;';
      Dst.Value := _value;
      Exit;
    End;
    //Embedded procedures
    if Env.Embedded then
    begin
      //[ebp+8] - set flag IF_EXTERN_VAR and exit
      if (DisaInfo.BaseReg = 21) and (offset = 8) then
      begin
        Dst.Flags := [IF_EXTERN_VAR];
        Exit;
      end;
      if IF_EXTERN_VAR in itemBase.Flags then
      begin
        Dst.Value := 'extlvar_' + Val2Str(-offset);
        Exit;
      end;
    End;
    //[reg-N]
    if IF_STACK_PTR in itemBase.Flags then
    Begin
      //xchg ecx,[ebp-XXX] - special processing
      if Op = OP_XCHG then with Dst^ do
      Begin
        Flags := [IF_STACK_PTR];
        IntValue := itemBase.IntValue + offset;
        Value := itemBase.Value;
        Name := itemBase.Name;
        Exit;
      End
      else if IF_ARG in itemBase.Flags then with Dst^ do
      Begin
        Flags := [IF_STACK_PTR];
        IntValue := itemBase.IntValue + offset;
        Value := itemBase.Value;
        Name := itemBase.Name;
        Exit;
      End
      else if IF_ARRAY_PTR in itemBase.Flags then with Dst^ do
      Begin
        Flags := [IF_STACK_PTR];
        IntValue := itemBase.IntValue + offset;
        if itemBase.Value <> '' then Value := itemBase.Value + '[]';
        if itemBase.Name <> '' then Name := itemBase.Name + '[]';
        Exit;
      End;
      item := Env.Stack[itemBase.IntValue + offset];
      //Arg
      if IF_ARG in item.Flags then with Dst^ do
      Begin
        Flags := [IF_STACK_PTR];
        IntValue := itemBase.IntValue + offset;
        //AssignItem(Dst, &_item);
        //Dst.Flags &:= ~IF_ARG;
        Value := item.Name;
        Name := item.Name;
        Exit;
      End
      //Var
      else if IF_VAR in item.Flags then
      Begin
        Exclude(item.Flags, IF_VAR);
        item._Type := '^' + item._Type;
        AssignItem(Dst^, item);
        Dst.Name := Env.GetLvarName(itemBase.IntValue + offset);
        Exit;
      End
      //Field
      else if IF_FIELD in item.Flags then
      Begin
        foffset := item.Offset;
        Dec(offset, foffset);
        _fname := GetRecordFields(foffset, Env.Stack[itemBase.IntValue + offset]._Type);
        _name := Env.GetLvarName(itemBase.IntValue + offset);
        if Pos(':',_fname)<>0 then
        Begin
          Dst.Value := _name + '.' + ExtractName(_fname);
          Dst._Type := ExtractType(_fname);
        End
        else Dst.Value := _name + '.f' + Val2Str(foffset);
        Dst.Name := _name;
        Exit;
      End
      //Not interface
      else if (item._Type = '') or (GetTypeKind(item._Type, size) <> ikInterface) then
      Begin
        Env.Stack[itemBase.IntValue + offset].Name := Env.GetLvarName(itemBase.IntValue + offset);
        Dst.Flags := [IF_STACK_PTR];
        Dst.IntValue := itemBase.IntValue + offset;
        Dst.Value := Env.GetLvarName(itemBase.IntValue + offset);
        Dst.Name := Dst.Value;
        Exit;
      End;
    End
    //lea
    else if Op = OP_LEA then
    Begin
      //Dst.Value := GetDecompilerRegisterName(DisInfo.BaseReg) + ' + ' + String(_offset);
      //return;
    End
    //[BaseReg]
    else if offset = 0 then
    Begin
      typeName := itemBase._Type;
      if IF_VAR in itemBase.Flags then
      Begin
        AssignItem(Dst^, itemBase);
        Exclude(Dst.Flags, IF_VAR);
        Dst.Name := '';
        Exit;
      End
      else if IF_ARRAY_PTR in itemBase.Flags then with Dst^ do
      Begin
        Value := itemBase.Value + '[]';
        _Type := GetArrayElementType(typeName);
        Name := '';
        Exit;
      End
      else if IF_STACK_PTR in itemBase.Flags then
      Begin
        item := Env.Stack[itemBase.IntValue];
        AssignItem(Dst^, item);
        Exit;
      End
      else if IF_INTVAL in itemBase.Flags then
      Begin
        adr := itemBase.IntValue;
        if IsValidImageAdr(adr) then
        Begin
          recN := GetInfoRec(adr);
          if Assigned(recN) then
          Begin
            Dst.Value := recN.Name;
            Dst._Type := recN._type;
            Exit;
          End;
        End;
      End
      else if typeName = '' then
      Begin
        _name := GetDecompilerRegisterName(DisaInfo.BaseReg);
        typeName := ManualInput(CurProcAdr, CurAdr, 'Define type of base register (' + _name + ')', 'Type:');
        if typeName = '' then
        Begin
          Env.ErrAdr := CurAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
      End
      else if typeName[1] = '^' then //Pointer to var
      Begin
        _value := itemBase.Value;
        typeName := GetTypeDeref(typeName);
        kind := GetTypeKind(typeName, size);
        if kind = ikRecord then
        Begin
          txt := GetRecordFields(0, typeName);
          if Pos(':',txt)<>0 then
          Begin
            _value := _value + '.' + ExtractName(txt);
            typeName := ExtractType(txt);
          End
          else
          Begin
            _value := _value + '.f0';
            typeName := txt;
          End;
        End
        else if kind = ikArray then
          _value := _value + '[ofs:=' + IntToStr(offset) + ']';
        Dst.Value := _value;
        Dst.Name := GetDecompilerRegisterName(DisaInfo.BaseReg);
        Dst._Type := typeName;
        Exit;
      End;
      kind := GetTypeKind(typeName, size);
      if kind = ikEnumeration then
      Begin
        Dst.Value := GetEnumerationString(typeName, itemBase.Value);
        Dst._Type := typeName;
        Exit;
      End
      else if (kind = ikLString) or (kind = ikString) then
      Begin
        Dst.Value := itemBase.Value + '[1]';
        Dst._Type := 'Char';
        Exit;
      End
      else if kind = ikRecord then
      Begin
        txt := GetRecordFields(offset, typeName);
        if Pos(':',txt)<>0 then
        Begin
          _value := itemBase.Value + '.' + ExtractName(txt);
          typeName := ExtractType(txt);
        End
        else
        Begin
          _value := itemBase.Value + '.f' + Val2Str(offset);
          typeName := txt;
        End;
        Dst.Value := _value;
        Dst._Type := typeName;
        Exit;
      End;
      Dst.Flags := [IF_VMT_ADR];
      if IF_INTERFACE in itemBase.Flags then
      Begin
        Include(Dst.Flags, IF_INTERFACE);
        Dst.Value := itemBase.Value;
      End;
      Dst.IntValue := GetClassAdr(typeName);
      Dst._Type := typeName;
      Exit;
    End;
    //[BaseReg+Offset]
    if IsValidImageAdr(offset) then
    Begin
      recN := GetInfoRec(offset);
      if Assigned(recN) and recN.HasName then
        _name := recN.Name
      else
        _name := GetGvarName(offset);
      Dst.Value := _name + '[' + GetDecompilerRegisterName(DisaInfo.BaseReg) + ']';
      Exit;
    End
    else if IF_ARRAY_PTR in itemBase.Flags then
    Begin
      if (IF_STACK_PTR in itemBase.Flags) and (Env.Stack[itemBase.IntValue].Value <> '') then
        Dst.Value := Env.Stack[itemBase.IntValue].Value + '['
      else
        Dst.Value := GetDecompilerRegisterName(DisaInfo.BaseReg) + '[';
      if offset > 0 then
        Dst.Value := Dst.Value + ' + ' + IntToStr(offset)
      else if offset < 0 then
        Dst.Value := Dst.Value + ' ' + IntToStr(offset);
      Dst.Value := Dst.Value + ']';
      Exit;
    End;
    typeName := itemBase._Type;
    if typeName = '' then
    Begin
      _name := GetDecompilerRegisterName(DisaInfo.BaseReg);
      typeName := ManualInput(CurProcAdr, CurAdr, 'Define type of base register (' + _name + ')', 'Type:');
      if typeName = '' then
      Begin
        Env.ErrAdr := CurAdr;
        raise Exception.Create('Empty input - See you later!');
      End;
    End
    else if (typeName[1] = '^') then typeName := GetTypeDeref(typeName);

    itemBase.Flags := [];
    if itemBase.Value = '' then
      itemBase.Value := GetDecompilerRegisterName(DisaInfo.BaseReg);
    itemBase._Type := typeName;
    SetRegItem(DisaInfo.BaseReg, itemBase);

    iname := itemBase.Value;
    kind := GetTypeKind(typeName, size);
    if (kind = ikLString) or (kind = ikString) then
    Begin
      _value := iname + '[' + IntToStr(offset + 1) + ']';
      typeName := 'Char';
    End
    else if kind = ikRecord then
    Begin
      if itemBase.Value <> '' then
        _value := itemBase.Value
      else
        _value := GetDecompilerRegisterName(DisaInfo.BaseReg);
      txt := GetRecordFields(offset, typeName);
      if Pos(':',txt)<>0 then
      Begin
        _value := _value + '.' + ExtractName(txt);
        typeName := ExtractType(txt);
      End
      else
      Begin
        _value := _value + '.f' + Val2Str(offset);
        typeName := txt;
      End;
    End
    else if kind = ikArray then
      _value := iname + '[ofs=' + IntToStr(offset) + ']'
    else if kind = ikDynArray then
    Begin
      typeName := GetArrayElementType(typeName);
      if typeName = '' then
      Begin
        Env.ErrAdr := CurAdr;
        raise Exception.Create('Type of array elements not found');
      End
      else if GetTypeKind(typeName, size) = ikRecord then
      Begin
        k := 0;
        size := GetRecordSize(typeName);
        if offset < 0 then while true do
        Begin
          Inc(offset, size); 
          Dec(k);
          if (offset >= 0) and (offset < size) then break;
        End;
        if offset >= size then while true do
        Begin
          Dec(offset, size); 
          Inc(k);
          if (offset >= 0) and (offset < size) then break;
        End;
        txt := GetRecordFields(offset, typeName);
        if txt = '' then
        Begin
          txt := ManualInput(CurProcAdr, CurAdr, 'Define [name:]type of field '
            + typeName + '.f' + Val2Str(offset), '[Name]:Type:');
          if txt = '' then
          Begin
            Env.ErrAdr := CurAdr;
            raise Exception.Create('Empty input - See you later!');
          End;
        End;
        _value := itemBase.Value + '[' + IntToStr(k) + ']';
        if Pos(':',txt)<>0 then
        Begin
          _value := _value + '.' + ExtractName(txt);
          typeName := ExtractType(txt);
        End
        else
        Begin
          _value := _value + '.f' + Val2Str(offset);
          typeName := txt;
        End;
      End;
      Dst.Value := _value;
      Dst._Type := typeName;
      Exit;
    End
    else if (kind = ikVMT) or (kind = ikClass) then
    Begin
      fInfo := FMain.GetField(typeName, offset, _vmt, vmtAdr);
      if not Assigned(fInfo) then
      Begin
        txt := ManualInput(CurProcAdr, CurAdr, 'Define correct type of field f' + Val2Str(offset), 'Type:');
        if txt = '' then
        Begin
          Env.ErrAdr := CurAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
        fInfo := FMain.GetField(txt, offset, _vmt, vmtAdr);
        if not Assigned(fInfo) then
        Begin
          Env.ErrAdr := CurAdr;
          raise Exception.Create('Field f' + Val2Str(offset) + ' not found in specified type');
        End;
      End;
      _value := GetFieldName(fInfo);
      typeName := fInfo._Type;
      //if Op <> OP_LEA then
      Begin
        kind := GetTypeKind(typeName, size);
        //Interface
        if kind = ikInterface then
        Begin
          typeName[1] := 'T';
          Dst.Flags := [IF_INTERFACE];
          Dst.Value := _value; 
          Dst._Type := typeName;
          Exit;
        End
        //Record
        else if kind = ikRecord then
        Begin
          txt := GetRecordFields(offset - fInfo.Offset, typeName);
          if txt = '' then
          Begin
            txt := ManualInput(CurProcAdr, CurAdr, 'Define [name:]type of field '
              + typeName + '.f' + Val2Str(offset - fInfo.Offset), '[Name]:Type:');
            if txt = '' then
            Begin
              Env.ErrAdr := CurAdr;
              raise Exception.Create('Empty input - See you later!');
            End;
          End
          else if Pos(':',txt)<>0 then
          Begin
            _value := _value + '.' + ExtractName(txt);
            typeName := ExtractType(txt);
          End
          else
          Begin
            _value := _value + '.f' + Val2Str(offset);
            typeName := txt;
          End;
        End
        //Array
        else if kind = ikArray then
          _value := _value + '[ofs:=' + IntToStr(offset - fInfo.Offset) + ']';
        if not SameText(iname, 'Self') then _value := iname + '.' + _value;
      End;
    End;
    Dst.Value := _value;
    Dst._Type := typeName;
    Exit;
  End
  //[BaseReg + IndxReg*Scale + Offset]
  else
  Begin
    GetRegItem(DisaInfo.IndxReg, itemIndx);
    if Op = OP_LEA then
    Begin
      if IF_STACK_PTR in itemBase.Flags then Include(Dst.Flags, IF_STACK_PTR);
      Dst.Value := GetDecompilerRegisterName(DisaInfo.BaseReg) + ' + '
        + GetDecompilerRegisterName(DisaInfo.IndxReg) + ' * ' + IntToStr(DisaInfo.Scale);
      if offset > 0 then
        Dst.Value := Dst.Value + IntToStr(offset)
      else if offset < 0 then
        Dst.Value := Dst.Value + IntToStr(-offset);
      Exit;
    End;
    typeName := itemBase._Type;
    if typeName = '' then
    Begin
      //esp
      if DisaInfo.BaseReg = 20 then
      Begin
        Dst.Value := Env.GetLvarName(_ESP_ + offset + DisaInfo.Scale) + '[' + itemIndx.Value + ']';
        Exit;
      End
      //ebp
      else if (DisaInfo.BaseReg = 21) and (IF_STACK_PTR in itemBase.Flags) then
      Begin
        Dst.Value := Env.GetLvarName(itemBase.IntValue + offset + DisaInfo.Scale) + '[' + itemIndx.Value + ']';
        Exit;
      End;
      kind := ikUnknown;
      //Lets try analyze _itemBase if it is address
      if IF_INTVAL in itemBase.Flags then
      Begin
        adr := itemBase.IntValue;
        if IsValidImageAdr(adr) then
        Begin
          recN := GetInfoRec(adr);
          if Assigned(recN) then
          Begin
            kind := recN.kind;
            if (recN._type <> '') and ((kind = ikUnknown) or (kind = ikData)) then
              kind := GetTypeKind(recN._type, size);
          End;
        End;
      End;
      while (kind = ikUnknown) or (kind = ikData) do
      Begin
        txt := ManualInput(CurProcAdr, CurAdr, 'Define type of base register', 'Type:');
        if txt = '' then
        Begin
          Env.ErrAdr := CurAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
        typeName := txt;
        kind := GetTypeKind(typeName, size);
      End;
    End
    else
    Begin
      if typeName[1] = '^' then typeName := GetTypeDeref(typeName);
      kind := GetTypeKind(typeName, size);
      while kind = ikUnknown do
      Begin
        txt := ManualInput(CurProcAdr, CurAdr, 'Define type of base register', 'Type:');
        if txt = '' then
        Begin
          Env.ErrAdr := CurAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
        typeName := txt;
        kind := GetTypeKind(typeName, size);
      End;
    End;
    if (kind = ikClass) or (kind = ikVMT) then
    Begin
      fInfo := GetArrayFieldOffset(typeName, offset, DisaInfo.Scale);
      while not Assigned(fInfo) do
      Begin
        txt := ManualInput(CurProcAdr, CurAdr, 'Define actual offset of array field', 'Offset (in hex):');
        if txt = '' then
        Begin
          Env.ErrAdr := CurAdr;
          raise Exception.Create('Empty input - See you later!');
        End;
        offset := StrToIntDef('$'+Trim(txt),0);
        fInfo := GetArrayFieldOffset(typeName, offset, DisaInfo.Scale);
      End;
      if not SameText(itemBase.Value, 'Self') then _value := itemBase.Value + '.';
      if fInfo.Name <> '' then
        _value := _value + fInfo.Name
      else
        _value := _value + 'f' + Val2Str(fInfo.Offset);
      _value := _value + '[' + GetDecompilerRegisterName(DisaInfo.IndxReg) + ']';
      Dst.Value := _value;
      Dst._Type := GetArrayElementType(fInfo._Type);
      Exit;
    End;
    if (kind = ikLString) or (kind = ikCString) or (kind = ikPointer) then
    Begin
      Dst.Value := GetDecompilerRegisterName(DisaInfo.BaseReg) + '[' + GetDecompilerRegisterName(DisaInfo.IndxReg);
      if kind = ikLString then Inc(offset);
      if offset > 0 then
        Dst.Value := Dst.Value + ' + ' + IntToStr(offset)
      else if offset < 0 then
        Dst.Value := Dst.Value + ' ' + IntToStr(offset);
      Dst.Value := Dst.Value + ']';
      Dst._Type := 'Char';
      Exit;
    End
    else if kind = ikRecord then
    Begin
      _value := itemBase.Value;
      txt := GetRecordFields(offset + DisaInfo.Scale, typeName);
      if Pos(':',txt)<>0 then
      Begin
        _value := _value + '.' + ExtractName(txt);
        typeName := ExtractType(txt);
      End
      else
      Begin
        _value := _value + '.f' + Val2Str(offset);
        typeName := txt;
      End;
      if GetTypeKind(typeName, size) = ikArray then
      Begin
        _value := _value + '[' + GetDecompilerRegisterName(DisaInfo.IndxReg) + ']';
        typeName := GetArrayElementType(typeName);
      End;
      Dst.Value := _value;
      Dst._Type := typeName;
      Exit;
    End
    else if kind = ikArray then
    Begin
      if IF_INTVAL in itemBase.Flags then
      Begin
        adr := itemBase.IntValue;
        recN := GetInfoRec(adr);
        if Assigned(recN) and recN.HasName then
          _name := recN.Name
        else
          _name := GetGvarName(adr);
      End;
      _name := itemBase.Value;
      typeName := GetArrayElementType(typeName);
      if typeName = '' then
      Begin
        Env.ErrAdr := CurAdr;
        raise Exception.Create('Type of array elements not found');
      End;
      if GetTypeKind(typeName, size) = ikRecord then
      Begin
        k := 0;
        size := GetRecordSize(typeName);
        if offset < 0 then while true do
        Begin
          Inc(offset, size);
          Dec(k);
          if (offset >= 0) and (offset < size) then break;
        End;
        if offset > size then while true do
        Begin
          Dec(offset, size); 
          Inc(k);
          if (offset >= 0) and (offset < size) then break;
        End;
        txt := GetRecordFields(offset, typeName);
        if txt = '' then
        Begin
          txt := ManualInput(CurProcAdr, CurAdr, 'Define [name:]type of field '
            + typeName + '.f' + Val2Str(offset), '[Name]:Type:');
          if txt = '' then
          Begin
            Env.ErrAdr := CurAdr;
            raise Exception.Create('Empty input - See you later!');
          End;
        End;
        _value := _name + '[';
        if itemIndx.Value <> '' then
          _value := _value + itemIndx.Value
        else
          _value := _value + GetDecompilerRegisterName(DisaInfo.IndxReg);
        if k < 0 then
          _value := _value + ' ' + IntToStr(k) + ']'
        else if k > 0 then
          _value := _value + ' + ' + IntToStr(k) + ']'
        else
          _value := _value + ']';
        if Pos(':',txt)<>0 then
        Begin
          _value := _value + '.' + ExtractName(txt);
          typeName := ExtractType(txt);
        End
        else
        Begin
          _value := _value + '.f' + Val2Str(offset);
          typeName := txt;
        End;
        Dst.Value := _value;
        Dst._Type := typeName;
        Exit;
      End;
      if not GetArrayIndexes(itemBase._Type, 1, idx, idx1) then
      Begin
        Env.ErrAdr := CurAdr;
        raise Exception.Create('Incorrect array definition');
      End;
      _mod := offset mod DisaInfo.Scale;
      if _mod<>0 then
      Begin
        Env.ErrAdr := CurAdr;
        raise Exception.Create('Array element is record');
      End;
      if itemIndx.Value <> '' then
        _value := itemBase.Value + '[' + itemIndx.Value + ']'
      else
        _value := itemBase.Value + '[' + GetDecompilerRegisterName(DisaInfo.IndxReg) + ']';
      Dst.Value := _value;
      Dst._Type := GetArrayElementType(itemBase._Type);
      Exit;
    End
    else if kind = ikDynArray then
    Begin
      typeName := GetArrayElementType(typeName);
      if typeName = '' then
      Begin
        Env.ErrAdr := CurAdr;
        raise Exception.Create('Type of array elements not found');
      End;
      _value := itemBase.Value + '[';
      if itemIndx.Value <> '' then
        _value := _value + itemIndx.Value
      else
        _value := _value + GetDecompilerRegisterName(DisaInfo.IndxReg);
      _value := _value + ']';
      if GetTypeKind(typeName, size) = ikRecord then
      Begin
        k := 0;
        size := GetRecordSize(typeName);
        if offset < 0 then while true do
        Begin
          Inc(offset, size); 
          Dec(k);
          if (offset >= 0) and (offset < size) then break;
        End;
        if offset > size then while true do
        Begin
          Dec(offset, size); 
          Inc(k);
          if (offset >= 0) and (offset < size) then break;
        End;
        txt := GetRecordFields(offset, typeName);
        if txt = '' then
        Begin
          txt := ManualInput(CurProcAdr, CurAdr, 'Define [name:]type of field '
            + typeName + '.f' + Val2Str(offset), '[Name]:Type:');
          if txt = '' then
          Begin
            Env.ErrAdr := CurAdr;
            raise Exception.Create('Empty input - See you later!');
          End;
        End;
        _value := itemBase.Value + '[';
        if itemIndx.Value <> '' then
          _value := _value + itemIndx.Value
        else
          _value := _value + GetDecompilerRegisterName(DisaInfo.IndxReg);
        if k < 0 then
          _value := _value + ' ' + IntToStr(k) + ']'
        else if k > 0 then
          _value := _value + ' + ' + IntToStr(k) + ']'
        else
          _value := _value + ']';
        if Pos(':',txt)<>0 then
        Begin
          _value := _value + '.' + ExtractName(txt);
          typeName := ExtractType(txt);
        End
        else
        Begin
          _value := _value + '.f' + Val2Str(offset);
          typeName := txt;
        End;
      End;
      Dst.Value := _value;
      Dst._Type := typeName;
      Exit;
    End;
    Env.ErrAdr := CurAdr;
    raise Exception.Create('Under construction');
  End;
end;

Function TDecompiler.GetStringArgument (item:PItem):AnsiString;
var
  idx, ap, size:Integer;
  adr:Integer;
  recN:InfoRec;
  key:AnsiString;
  tmpBuf:PAnsiChar;
Begin
  Result:=item.Name;
  if item.Name <> '' then exit;
  if IF_STACK_PTR in item.Flags then
  Begin
    Env.Stack[item.IntValue]._Type := 'String';
    Result:= Env.GetLvarName(item.IntValue);
    Exit;
  End
  else if IF_INTVAL in item.Flags then
  Begin
    adr := item.IntValue;
    if adr = 0 then
    Begin
      Result:='';
      Exit;
    End
    else if IsValidImageAdr(adr) then
    Begin
      ap := Adr2Pos(adr);
      if ap >= 0 then
      Begin
        recN := GetInfoRec(adr);
        if Assigned(recN) and ((recN.kind = ikLString) or (recN.kind = ikWString) or (recN.kind = ikUString)) then
        Begin
          Result:= recN.Name;
          Exit;
        End;
        size := WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + ap, -1, Nil, 0, NIL, NIL);
        if size<>0 then
        Begin
          GetMem(tmpBuf,size + 1);
          WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + ap, -1, tmpBuf, size, Nil, NIL);
          Result := TransformString(tmpBuf, size);
          FreeMem(tmpBuf);
          Exit;
        End;
      End
      else
      Begin
        key := Val2Str(adr,8);
        idx := BSSInfos.IndexOf(key);
        if idx <> -1 then
          recN := InfoRec(BSSInfos.Objects[idx])
        Else recN:=Nil;
        if Assigned(recN) then
          Result:= recN.Name
        else
          Result:= item.Value;
        Exit;
      End;
    End
    else
    Begin
      Result:= item.Value;
      Exit;
    End;
  End
  else Result:= item.Value;
end;

Function TDecompiler.AnalyzeConditions (brType:Integer; curAdr, sAdr, jAdr:Integer; loopInfo:TLoopInfo):Integer;
var
  _begAdr, _bodyBegAdr, _bodyEndAdr, _jmpAdr,_curAdr:Integer;
  de:TDecompiler;
  _line:AnsiString;
Begin
  _curAdr:=curAdr;
  _jmpAdr:=jAdr;
  //simple if
  if brType = 0 then
  Begin
    if CompInfo.O = 'R' then //not in
      _line := 'if (not (' + CompInfo.L + ' in ' + CompInfo.R + ')) then'
    else
      _line := 'if (' + CompInfo.L + ' ' + GetInvertCondition(CompInfo.O) + ' ' + CompInfo.R + ') then';
    Env.AddToBody(_line);
    _begAdr := _curAdr;
    Env.SaveContext(_begAdr);
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(CmpAdr);
    try
      Env.AddToBody('begin');
      _curAdr := de.Decompile(_begAdr, [], loopInfo);
      Env.AddToBody('end');
    except 
      on E:exception do
      Begin
        de.Free;
        raise Exception.Create('If = ' + E.Message);
      End;
    end;
    Env.RestoreContext(_begAdr); //if (de.WasRet)
    de.Free;
  End
  //complex if
  else if brType = 1 then
  Begin
    _bodyBegAdr := _curAdr;
    if not Env.GetBJLRange(sAdr, _bodyBegAdr, _bodyEndAdr, _jmpAdr, loopInfo) then
    Begin
      Env.ErrAdr := _curAdr;
      raise Exception.Create('Control flow under construction');
    End;
    Env.CmpStack.Clear();
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(_bodyBegAdr);
    try
      de.Decompile(sAdr, [CF_BJL], loopInfo);
    except
      on E:exception do
      Begin
        de.Free;
        raise Exception.Create('Complex if = ' + E.Message);
      End;
    end;
    de.Free;
    if _bodyEndAdr > _bodyBegAdr then
    Begin
      Env.CreateBJLSequence(sAdr, _bodyBegAdr, _bodyEndAdr);
      Env.BJLAnalyze;
      _line := 'if ' + Env.PrintBJL() + ' then';
      Env.AddToBody(_line);
      Env.SaveContext(_bodyBegAdr);
      de := TDecompiler.Create(Env);
      de.SetStackPointers(Self);
      de.SetDeFlags(DeFlags);
      de.SetStop(_bodyEndAdr);
      try
        Env.AddToBody('begin');
        _curAdr := de.Decompile(_bodyBegAdr, [], loopInfo);
        Env.AddToBody('end');
      Except
        on E:exception do
        Begin
          de.Free;
          raise Exception.Create('Complex if = ' + E.Message);
        End;
      end;
      Env.RestoreContext(_bodyBegAdr); //if (_jmpAdr || de.WasRet)
      de.Free;
      if _jmpAdr<>0 then
      Begin
        Env.AddToBody('else');
        _begAdr := _curAdr;
        Env.SaveContext(_begAdr);
        de := TDecompiler.Create(Env);
        de.SetStackPointers(Self);
        de.SetDeFlags(DeFlags);
        de.SetStop(_jmpAdr);
        try
          Env.AddToBody('begin');
          _curAdr := de.Decompile(_begAdr, [CF_ELSE], loopInfo);
          Env.AddToBody('end');
        Except
          on E:exception do
          Begin
            de.Free;
            raise Exception.Create('If Else = ' + E.Message);
          End;
        end;
        Env.RestoreContext(_begAdr); //if (de.WasRet)
        de.Free;
      End;
    End
    else
    Begin
      Env.CreateBJLSequence(sAdr, _bodyBegAdr, _bodyEndAdr);
      Env.BJLAnalyze();
      _line := 'if ' + Env.PrintBJL() + ' then';
    End;
  End
  //cycle
  else if brType = 2 then
  Begin
    if CompInfo.O = 'R' then //not in
      _line := 'if (not (' + CompInfo.L + ' in ' + CompInfo.R + ')) then'
    else
      _line := 'if (' + CompInfo.L + ' ' + GetInvertCondition(CompInfo.O) + ' ' + CompInfo.R + ') then';
    Env.AddToBody(_line);
    _begAdr := _curAdr;
    Env.SaveContext(_begAdr);
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(CmpAdr);
    try
      Env.AddToBody('begin');
      _curAdr := de.Decompile(_begAdr, [], loopInfo);
      Env.AddToBody('end');
    Except
      on E:exception do
      Begin
        de.Free;
        raise Exception.Create('If = ' + E.Message);
      End;
    end;
    Env.RestoreContext(_begAdr); //if (de.WasRet)
    de.Free;
  End
  //simple if else
  else if brType = 3 then
  Begin
    if CompInfo.O = 'R' then //not in
      _line := 'if (not (' + CompInfo.L + ' in ' + CompInfo.R + ')) then'
    else
      _line := 'if (' + CompInfo.L + ' ' + GetInvertCondition(CompInfo.O) + ' ' + CompInfo.R + ') then';
    Env.AddToBody(_line);
    _begAdr := _curAdr;
    Env.SaveContext(_begAdr);
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(CmpAdr);
    try
      Env.AddToBody('begin');
      _curAdr := de.Decompile(_begAdr, [], loopInfo);
      Env.AddToBody('end');
    Except
       on E:exception do
      Begin
        de.Free;
        raise Exception.Create('If Else = ' + E.Message);
      End;
    end;
    Env.RestoreContext(_begAdr);
    de.Free;
    Env.AddToBody('else');
    _begAdr := _curAdr;
    Env.SaveContext(_begAdr);
    de := TDecompiler.Create(Env);
    de.SetStackPointers(Self);
    de.SetDeFlags(DeFlags);
    de.SetStop(_jmpAdr);
    try
      Env.AddToBody('begin');
      _curAdr := de.Decompile(_begAdr, [CF_ELSE], loopInfo);
      Env.AddToBody('end');
    Except
      on E:exception do
      Begin
        de.Free;
        raise Exception.Create('If Else = ' + E.Message);
      End;
    end;
    Env.RestoreContext(_begAdr); //if (de.WasRet)
    de.Free;
  End
  else
  Begin
    _line := 'if (' + CompInfo.L + ' ' + GetDirectCondition(CompInfo.O) + ' ' + CompInfo.R + ') then Break;';
    Env.AddToBody(_line);
  End;
  Result:= _curAdr;
end;

End.

//---------------------------------------------------------------------------
//cfLoc - make XRefs
//Names
//---------------------------------------------------------------------------
//hints
//DynArrayClear == (varName := Nil);
//DynArraySetLength == SetLength(varName, colsnum, rowsnum)
//@Assign  == AssignFile
//@Close == CloseFile
//@Flush == Flush
//@ResetFile;@ResetText == Reset
//@RewritFile4@RewritText == Rewrite
//@Str2Ext == Str(val:width:prec,s)
//@Write0LString == Write
//@WriteLn == WriteLn
//@LStrPos == Pos
//@LStrCopy == Copy
//@LStrLen == Length
//@LStrDelete == Delete
//@LStrInsert == Insert
//@LStrCmp == '='
//@UStrCmp == '='
//@RandInt == Random
//@LStrOfChar == StringOfChar
//0x61 = Ord('a')
//@LStrFromChar=Chr
//@LStrToPChar=PChar
//@LStrFromArray=String(src,len)
//---------------------------------------------------------------------------
//Constructions
//---------------------------------------------------------------------------
//Length
//test reg, reg
//jz @1
//mov reg, [reg-4]
//or
//sub reg, 4
//mov reg, [reg]
//---------------------------------------------------------------------------
//mod 2
//and eax, 80000001
//jns @1
//dec eax
//or eax, 0fffffffe
//inc eax
//@1
//---------------------------------------------------------------------------
//mod 2^k
//and eax, (80000000 | (2^k - 1))
//jns @1
//dec eax
//or eax, -2^k
//inc eax
//@1
//---------------------------------------------------------------------------
//div 2^k
//test reg, reg
//jns @1
//add reg, (2^k - 1)
//sar reg, k
//@1
//---------------------------------------------------------------------------
//mod N
//mov reg, N (reg != eax)
//cdq
//idiv reg
//use edx
//---------------------------------------------------------------------------
//in [0..N]
//sub eax, (N + 1)
//jb @body
//---------------------------------------------------------------------------
//in [N1..N2,M1..M2]
//add eax, -N1
//sub eax, (N2 - N1 + 1)
//jb @body
//add eax, -(M1 - N2 - 1)
//sub eax, (M1 - M2 + 1)
//jnb @end
//@body
//...
//@end
//---------------------------------------------------------------------------
//not in [N1..N2,M1..M2]
//add eax, -N1
//sub eax, (N2 - N1 + 1)
//jb @end
//add eax, -(M1 - N2 - 1)
//sub eax, (M1 - M2 + 1)
//jb @end
//@body
//...
//@end
//---------------------------------------------------------------------------
//Int64 comparison  if (A > B) then >(jbe,jle) >=(jb,jl) <(jae,jge) <=(ja,jg)
//cmp highA,highB
//jnz(jne) @1
//{pop reg}
//{pop reg}
//cmp lowA,lowB
//jbe @2 (setnbe)
//jmp @3
//@1:
//{pop reg}
//{pop reg}
//jle @2 (setnle)
//@3
//body
//@2
//---------------------------------------------------------------------------
//LStrAddRef - if exists, then no prefix const
//---------------------------------------------------------------------------
//Exit in except block
//@DoneExcept 
//jmp ret
//@DoneExcept
//---------------------------------------------------------------------------
//If array of strings before procedure (function), then this array is declared
//in var section
//---------------------------------------------------------------------------
//mov [A],0
//mov [A + 4], 0x3FF00000
//->(Double)A := (00 00 00 00 00 00 F0 3F) Bytes in revers order! 
//---------------------------------------------------------------------------
//exetended -> tools
//push A
//push B
//push C
//C,B,A in reverse order
//---------------------------------------------------------------------------
//@IsClass<-> (eax is edx)
//---------------------------------------------------------------------------
//SE4(5D1817) - while!!!
