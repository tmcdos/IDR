Unit Infos;

Interface

Uses KnowledgeBase,Windows,Classes,Contnrs,Def_info,Def_know,Def_main;

Type
  InfoVmtInfo = class
  public
    interfaces:TStringList;
    fields:TObjectList;
    methods:TList;
    Destructor Destroy; Override;
    Procedure AddInterface(Value:AnsiString);
    function AddField(ProcAdr:Integer; ProcOfs:Integer; _Scope:Byte; _Offset, _Case_:Integer; _Name, _Type_:AnsiString): FIELDINFO;
    function AddMethod(_Abstract_:Boolean; _Kind:Char; _Id:Integer; _Address:Integer; _Name:AnsiString): Boolean;
    Procedure RemoveField(Offset:Integer);
  end;

  InfoProcInfo = class
  public
    call_kind:Byte;
	  flags:TProcFlagSet;
    bpBase:WORD;    	//First argument distance from base ebp
    retBytes:WORD;
    procSize:Integer;
    stackSize:Integer;
    args:TList;
    locals:TList;
    Destructor Destroy; Override;
    Function AddArg(aInfo:PArgInfo):PArgInfo; Overload;
    function AddArg(_Tag:BYTE; Ofs, _Size:Integer; _Name, _TypeDef:AnsiString): PArgInfo; overload;
    Function AddArgsFromDeclaration(Decl:AnsiString; from, callKind:Integer):AnsiString;
    Function GetArg(n:Integer):PArgInfo;
    Procedure DeleteArg(n:Integer);
    Procedure DeleteArgs;
    Function AddLocal(_Ofs, _Size:Integer; _Name, _TypeDef:AnsiString):PLocalInfo;
    Function GetLocal(Ofs:Integer):PLocalInfo;
    Procedure DeleteLocal(n:Integer);
    Procedure DeleteLocals;
  End;

  InfoRec = class
  private
    FName:AnsiString;
  public
    counter:Byte;
    kind:LKind;
    kbIdx:Integer;
    _type:AnsiString;       //Return value type for function
    Pcode:PPICODE;		//Internal code
    xrefs:TList;
    rsInfo:AnsiString; //PInfoResStringInfo;
    vmtInfo:InfoVmtInfo;
    procInfo:InfoProcInfo;
    Constructor Create(APos:Integer; AKind:LKind);
    Destructor Destroy; Override;
    Function HasName:Boolean;
    Function GetNameLength:Integer;
    Procedure SetName(AValue:AnsiString);
    Procedure ConcatName(AValue:AnsiString);
    Function SameName(AValue:AnsiString):Boolean;
    procedure AddXref(_Type_:Char; _Adr:Integer; Ofs:Integer);
    Procedure DeleteXref(Adr:Integer);
    Procedure ScanUpItemAndAddRef(fromPos:Integer; itemAdr:Integer; refType:Char; refAdr:Integer);
    Procedure Save(outs:TStream); Virtual;
    Procedure Load(ins:TStream; buf:Pointer); Virtual;
    //procedure Skip(ins:TStream; buf:Pointer; asKind:Byte); virtual;
    Function MakePrototype(adr:Integer; showKind, showTail, multiline, fullName, allArgs:Boolean):AnsiString;
    Function MakeDelphiPrototype(Adr:Integer; recM:PMethodRec):AnsiString;
    Function MakeMultilinePrototype(Adr:Integer; Var ArgsBytes:Integer; MethodType:AnsiString):AnsiString;
    Function MakeMapName(Adr:Integer):AnsiString;
    Function MakeArgsManually:Boolean;
    property Name:AnsiString read FName write SetName;
    property NameLength:Integer read GetNameLength;
  end;

  AInfoRec = Array of InfoRec;

Implementation

Uses SysUtils,StrUtils,Misc,Main,Def_disasm,Scanf,CodeSiteLogging;

Var
  //as some statistics for memory leaks detection (remove it when fixed)
  stat_InfosOverride:Cardinal;

Function FieldsCmpFunction(item1,item2:Pointer):Integer;
Begin
  if FieldInfo(item1).Offset > FieldInfo(item2).Offset then Result:=1
  Else if FieldInfo(item1).Offset < FieldInfo(item2).Offset then Result:=-1
  Else Result:=0;
end;

Function LocalsCmpFunction(item1,item2:Pointer):Integer;
Begin
  if PLocalInfo(item1).Ofs > PLocalInfo(item2).Ofs then Result:=1
  Else if PLocalInfo(item1).Ofs < PLocalInfo(item2).Ofs then Result:=-1
  Else Result:=0;
end;

Destructor InfoVmtInfo.Destroy;
var
  i:Integer;
Begin
  interfaces.Free;
  Fields.Free;
  if Assigned(methods)then
  begin
    for i:=0 to methods.Count-1 do
      Dispose(PMethodRec(methods[i]));
    methods.Free;
  End;
end;

Procedure InfoVmtInfo.AddInterface (Value:AnsiString);
Begin
  if not Assigned(interfaces) then interfaces := TStringList.Create;
  interfaces.Add(Value);
end;

Function InfoVmtInfo.AddField (ProcAdr:Integer; ProcOfs:Integer; _Scope:Byte; _Offset, _Case_:Integer; _Name, _Type_:AnsiString):FIELDINFO;
var
  M,F,L:Integer;
  
  procedure FillRes;
  begin
    with Result do
    begin
      Scope := _Scope;
      Offset := _Offset;
      _Case := _Case_;
      Name := _Name;
      _Type := _Type_;
    end;
  end;
  
Begin
  Result:=Nil;
  if fields=Nil then fields := TObjectList.Create(True);
  if fields.Count=0 then
  begin
    Result := FieldInfo.Create;
    FillRes;
    fields.Add(Result);
    Exit;
  end;
  F := 0;
  L := fields.Count - 1;
  while F < L do
  begin
    M := (F + L) div 2;
    Result := FieldInfo(fields[M]);
    if _Offset <= Result.Offset then L := M
      else F := M + 1;
  End;
  Result := FieldInfo(fields[L]);
  if Result.Offset <> _Offset then
  begin
    Result := FieldInfo.Create;
    FillRes;
    fields.Add(Result);
    fields.Sort(FieldsCmpFunction);
  end
  else
  begin
    if Result.Name = '' then Result.Name := _Name;
    if Result._Type = '' then Result._Type := _Type_;
  End;
end;

Procedure InfoVmtInfo.RemoveField (Offset:Integer);
var
  fInfo:FieldInfo;
  L,F,M:Integer;
Begin
  if (fields=Nil) or (fields.Count=0) then Exit;
  F := 0;
  L := fields.Count - 1;
  while F < L do
  begin
    M := (F + L) div 2;
    fInfo := FieldInfo(fields[M]);
    if Offset <= fInfo.Offset Then L := M
      else F := M + 1;
  end;
  fInfo := FieldInfo(fields[L]);
  if fInfo.Offset = Offset then fields.Delete(L);
end;

Function InfoVmtInfo.AddMethod (_Abstract_:Boolean; _Kind:Char; _Id:Integer; _Address:Integer; _Name:AnsiString):Boolean;
var
  recM:PMethodRec;
  n:Integer;
Begin
  if methods=Nil then methods := TList.Create;
  for n := 0 to methods.Count-1 do
  begin
    recM := PMethodRec(methods[n]);
    if (_Kind = 'A') or (_Kind = 'V') then
    begin
      if (recM.kind = _Kind) and (recM.id = _Id) then
      begin
        if (recM.name = '') and (_Name <> '') then recM.name := _Name;
        Result:=false;
        Exit;
      end
    end
    else
    begin
      if (recM.kind = _Kind) and (recM.address = _Address) then
      begin
        if (recM.name = '') and (_Name <> '') then recM.name := _Name;
        Result:=false;
        Exit;
      End;
    End;
  end;
  New(recM);
  with recM^ do
  begin
    _abstract := _Abstract_;
    kind := _Kind;
    id := _Id;
    address := _Address;
    name := _Name;
  end;
  methods.Add(recM);
  Result:=true;
end;

Destructor InfoProcInfo.Destroy;
Var
  i:Integer;
Begin
  if Assigned(args) then
  begin
    for i:=0 to args.Count-1 do
      Dispose(PArgInfo(args[i]));
    args.Free;
  end;
  if assigned(locals) Then
  Begin
    for i:=0 to locals.Count-1 do
      Dispose(PLocalInfo(locals[i]));
    locals.Free;
  end;
end;

Function InfoProcInfo.AddArg (aInfo:PARGINFO):PArgInfo;
Begin
  Result:=AddArg(aInfo.Tag,aInfo.Ndx,aInfo.Size,aInfo.Name,aInfo.TypeDef);
end;

Function InfoProcInfo.AddArg(_Tag:BYTE; Ofs, _Size:Integer; _Name, _TypeDef:AnsiString):PArgInfo;
var
  F,L,M:Integer;

  procedure NewRes;
  begin
    New(Result);
    with Result^ do
    begin
      in_Reg:= Ofs In [0..3];
      Tag := _Tag;
      Ndx := Ofs;
      Size := _Size;
      Name := _Name;
      TypeDef := _TypeDef;
    end;
  end;
  
Begin
  if args=Nil then args := TList.Create;
  if args.Count=0 then
  begin
    NewRes;
    args.Add(Result);
    Exit;
  End;
  F := 0;
  Result := PArgInfo(args[F]);
  if Ofs < Result.Ndx then
  begin
    NewRes;
    args.Insert(F, Result);
    Exit;
  end;
  L := args.Count - 1;
  Result := PArgInfo(args[L]);
  if Ofs > Result.Ndx then
  begin
    NewRes;
    args.Add(Result);
    Exit;
  end;
  while F < L do
  begin
    M := (F + L) div 2;
    Result := PArgInfo(args[M]);
    if Ofs <= Result.Ndx then L := M
      else F := M + 1;
  end;
  Result := PArgInfo(args[L]);
  if Result.Ndx <> Ofs then
  begin
    NewRes;
    args.Insert(L, Result);
    Exit;
  end;
  if Result.Name = '' then Result.Name := _Name;
  if Result.TypeDef = '' then Result.TypeDef := _TypeDef;
  if Result.Tag=0 then Result.Tag := _Tag;
end;

Function InfoProcInfo.AddArgsFromDeclaration (Decl:AnsiString; from, callKind:Integer):AnsiString;
var
  fColon:Boolean;
  p, pp, cp:Integer;
  sc:Char;
  ss, num,arg:Integer;
  aInfo:ArgInfo;
  _Name,_Type:AnsiString;
Begin
  Result:='';
  aInfo.in_Reg:=False;
  p := Pos('(',Decl);
  if p<>0 then
  Begin
    Inc(p); 
    pp := p; 
    num := 0; 
    fColon := false;
    while true do
    Begin
      case Decl[pp] of
        ')': break;
        ';': fColon := false;
        ':': if not fColon then
            Begin
              Decl[pp] := ' ';
              Inc(num);
              fColon := true;
            End;
      end;
      Inc(pp);
    End;
    if num<>0 then
    Begin
      ss := bpBase;
      arg := from;
      while true do 
      Begin
        _Name := '';
        _Type := '';
        sc := ';'; 
        pp := PosEx(sc,Decl,p);
        if pp=0 then
        Begin
          sc := ')';
          pp := PosEx(sc,Decl,p);
        End;
        // pp^ := #0;
        //Tag
        aInfo.Tag := $21;
        while Decl[p] = ' ' do Inc(p);
        _Name:=Copy(Decl,p,FirstWord(Decl,p,pp));
        if _Name='var' then
        Begin
          aInfo.Tag := $22;
          Inc(p, Length(_Name));
          while Decl[p] = ' ' do Inc(p);
          //Name
          _Name:=Copy(Decl,p,FirstWord(Decl,p,pp));
        End
        else if _Name= 'val' then
        Begin
          Inc(p, Length(_Name));
          while Decl[p] = ' ' do Inc(p);
          //Name
          _Name:=Copy(Decl,p,FirstWord(Decl,p,pp));
        End;
        Inc(p, Length(_Name));
        while Decl[p] = ' ' do Inc(p);
        //Type
        _Type:=Copy(Decl, p,pp-p);
        //Inc(p, strlen(_Type));
        //while p^ = ' ' do Inc(p);
        aInfo.Size := 4;
        cp := Pos(':',_Type);
        if cp<>0 then
        Begin
          sscanf(PAnsiChar(_type)+cp+1,'%d',[@aInfo.Size]);
          _Type[cp]:=' ';
          //sscanf(cp + 1, '%d', &argInfo.Size);
          //cp^ := #0;
        End;
        if callKind = 0 then //fastcall
        Begin
          if (arg < 3) and (aInfo.Size = 4) then aInfo.Ndx := arg
          else
          Begin
            aInfo.Ndx := ss;
            Inc(ss, aInfo.Size);
          End;
        End
        else
        Begin
          aInfo.Ndx := ss;
          Inc(ss, aInfo.Size);
        End;
        if _Name= '?' then aInfo.Name := ''
          else aInfo.Name := Trim(_Name);
        if _Type = '?' then aInfo.TypeDef := ''
          else aInfo.TypeDef := TrimTypeName(_Type);
        AddArg(@aInfo);
        Decl[pp] := ' ';
        p := pp + 1;
        if sc = ')' then break;
        Inc(arg);
      End;
    End;
  End
  else p := 1;
  p := PosEx(':',Decl,p);
  if p<>0 then
  Begin
    Inc(p);
    pp := PosEx(';',Decl,p);
    if pp<>0 then _Name:=Copy(Decl,p,pp-p)
      else _Name:=Copy(Decl, p,Length(Decl));
    Result:= Trim(_Name);
  End;
end;

Function InfoProcInfo.GetArg (n:Integer):PArgInfo;
Begin
  if Assigned(args) and (n >= 0) and (n < args.Count) then Result:=PArgInfo(args[n])
    else Result:=Nil; 
end;

Procedure InfoProcInfo.DeleteArg (n:Integer);
Begin
  if Assigned(args) and (n >= 0) and (n < args.Count) then args.Delete(n);
end;

Procedure InfoProcInfo.DeleteArgs;
var
  n:Integer;
Begin
  if Assigned(args) then
  begin
    for n := 0 to args.Count-1 do
      Finalize(PArgInfo(args[n])^);
    args.Clear;
  end;
end;

Function InfoProcInfo.AddLocal (_Ofs, _Size:Integer; _Name, _TypeDef:AnsiString):PLocalInfo;
var
  F,L,M:Integer;

  procedure NewRes;
  begin
    New(Result);
    with Result^ do
    begin
      Ofs := _Ofs;
      Size := _Size;
      Name := _Name;
      TypeDef := _TypeDef;
    end;
  end;

Begin
  if locals=Nil then locals := TList.Create;
  if locals.Count=0 then
  begin
    NewRes;
    locals.Add(Result);
    Exit;
  End;
  F := 0;
  Result := PLocalInfo(locals[F]);
  if {-}_Ofs >{< -}Result.Ofs then
  Begin
    NewRes;
    locals.Insert(F,Result);
    Exit;
  End;
  L := locals.Count - 1;
  Result := PLocalInfo(locals[L]);
  if {-}_Ofs <{> -}Result.Ofs then
  Begin
    NewRes;
    locals.Add(Result);
    Exit;
  End;
  while F < L do
  Begin
    M := (F + L) div 2;
    Result := PLocalInfo(locals[M]);
    if {-}_Ofs >={<= -}Result.Ofs then L := M
      else F := M + 1;
  End;
  Result := PLocalInfo(locals[L]);
  if Result.Ofs <> _Ofs then
  Begin
    NewRes;
    locals.Insert(L,Result);
    Exit;
  End
  else
  Begin
    if _Name <> '' then Result.Name := _Name;
    if _TypeDef <> '' then Result.TypeDef := _TypeDef;
  End;
end;

Function InfoProcInfo.GetLocal (Ofs:Integer):PLocalInfo;
var
  n:Integer;
Begin
  if Assigned(locals) then
    for n := 0 to locals.Count-1 do
    begin
      Result:= PLocalInfo(locals[n]);
      if Result.Ofs = Ofs then Exit;
    end;
  Result:=Nil;
end;

Procedure InfoProcInfo.DeleteLocal (n:Integer);
Begin
  if Assigned(locals) and (n >= 0) and (n < locals.Count) then locals.Delete(n); 
end;

Procedure InfoProcInfo.DeleteLocals;
var
  n:Integer;
Begin
  if Assigned(locals) then
  begin
    for n := 0 to locals.Count-1 do
      Finalize(PLocalInfo(locals[n])^);
    locals.Clear;
  end;
end;

Constructor InfoRec.Create (APos:Integer; AKind:LKind);
Begin
  kind:=AKind;
  kbIdx:=-1;
  if kind = ikResString then rsInfo := ''
  else if kind = ikVMT then vmtInfo := InfoVmtInfo.Create
  else if kind in [ikRefine..ikFunc] then procInfo := InfoProcInfo.Create;
  if APos >= 0 then
  begin
    if Assigned(InfoList[APos]) then
    begin
      //as: if we here - memory leak then!
      Inc(stat_InfosOverride);
    end;
    InfoList[APos] := Self;
  end;
end;

Destructor InfoRec.Destroy;
var
  n:Integer;
Begin
  if Assigned(Pcode) then Dispose(Pcode);
  if Assigned(xrefs) Then for n:=0 to xrefs.Count-1 do
    Dispose(PXrefRec(xrefs[n]));
  xrefs.free;
  if kind = ikVMT then vmtInfo.Free
  else if kind in [ikRefine..ikFunc] then procInfo.Free;
  Inherited;
end;

Function InfoRec.HasName:Boolean;
Begin
  Result:=Fname <>''; 
end;

Function InfoRec.GetNameLength:Integer;
Begin
  Result:=Length(FName); 
end;

Procedure InfoRec.SetName (AValue:AnsiString);
Begin
  CrtSection.Enter;
  Fname := AValue;
  if (ExtractClassName(name) <> '') and (kind in [ikRefine..ikFunc]) 
    and Assigned(procInfo) then Include(procInfo.flags, PF_METHOD);
  CrtSection.Leave; 
end;

Procedure InfoRec.ConcatName (AValue:AnsiString);
Begin
  Fname:=FName + AValue; 
end;

Function InfoRec.SameName (AValue:AnsiString):Boolean;
Begin
  Result:=SameText(Fname, AValue); 
end;

Procedure InfoRec.AddXref (_Type_:Char; _Adr:Integer; Ofs:Integer);
var
  recX:PXRefRec;
  F,L,M:Integer;

  Procedure NewRec;
  begin
    New(recX);
    with recX^ do
    begin
      _type := _Type_;
      adr := _Adr;
      offset := Ofs;
    end;
  end;

Begin
	if xrefs=Nil then xrefs := TList.Create;
{If Name='@HandleFinally' Then
Begin
  s:=IntToStr(xrefs.Count);
  CodeSite.EnterMethod(s);
  CodeSite.Send('Type',_Type_);
  CodeSite.Send('Adr',_Adr);
  CodeSite.Send('Offset',Ofs);
  CodeSite.ExitMethod(s);
end;}
  if xrefs.Count=0 then
  Begin
    NewRec;
    xrefs.Add(recX);
    Exit;
  End;
  F := 0;
  recX := PXrefRec(xrefs[F]);
  if _Adr + Ofs < recX.adr + recX.offset then
  Begin
    NewRec;
    xrefs.Insert(F, recX);
    Exit;
  End;
  L := xrefs.Count - 1;
  recX := PXrefRec(xrefs[L]);
  if _Adr + Ofs > recX.adr + recX.offset then
  Begin
    NewRec;
    xrefs.Add(recX);
    Exit;
  End;
  while F < L do
  Begin
    M := (F + L) div 2;
    recX := PXrefRec(xrefs[M]);
    if _Adr + Ofs <= recX.adr + recX.offset then L := M
      else F := M + 1;
  End;
  recX := PXrefRec(xrefs[L]);
  if recX.adr + recX.offset <> _Adr + Ofs then
  Begin
    NewRec;
    xrefs.Insert(L, recX);
  End; 
end;

Procedure InfoRec.DeleteXref (Adr:Integer);
var
  n:Integer;
  recX:PXRefRec;
Begin
  for n := 0 to xrefs.Count-1 do
  begin
    recX := PXrefRec(xrefs[n]);
    if Adr = recX.adr + recX.offset then
    begin
      xrefs.Delete(n);
      break;
    end;
  end;
end;

Procedure InfoRec.ScanUpItemAndAddRef (fromPos:Integer; itemAdr:Integer; refType:Char; refAdr:Integer);
var
  disInfo:TDisInfo;
Begin
  while fromPos >= 0 do
  begin
    Dec(fromPos);
    if IsFlagSet([cfProcStart], fromPos) then break;
    if IsFlagSet([cfInstruction], fromPos) then
    begin
      frmDisasm.Disassemble(Code + fromPos, Pos2Adr(fromPos), @disInfo, Nil);
      if (disInfo.Immediate = itemAdr) or (disInfo.Offset = itemAdr) then
      begin
        AddXref(refType, refAdr, Pos2Adr(fromPos) - refAdr);
        break;
      end;
    end;
  end;
end;

Procedure InfoRec.Save (outs:TStream);
var
  m, xm, num, xnum, len:Integer; 
  recX:PXRefRec;
  fInfo:FieldInfo;
  recM:PMethodRec;
  aInfo:PArgInfo;
  locInfo:PLocalInfo;
  s:AnsiString;
Begin
  //kbIdx
  outs.Write(kbIdx, sizeof(kbIdx));
  //name
  len := Length(FName); 
  if len > MaxBufLen then MaxBufLen := len;
  outs.Write(len, sizeof(len));
  outs.Write(Fname[1], len);
  //type
  len := Length(_Type); 
  if len > MaxBufLen then MaxBufLen := len;
  outs.Write(len, sizeof(len));
  outs.Write(_type[1], len);
  //picode
  outs.Write(Pcode, sizeof(Pcode));
  if Assigned(Pcode) then
  Begin
  	//Op
    outs.Write(Pcode.Op, sizeof(Pcode.Op));
    //Ofs
    {if _code.Op = OP_CALL then
    	outs.Write(_code.Ofs.Address, sizeof(_code.Ofs.Address));
    else}
    	outs.Write(Pcode.Offset, sizeof(Pcode.Offset));
    //Name
    len := Length(Pcode.Name);
    if len > MaxBufLen then MaxBufLen := len;
    outs.Write(len, sizeof(len));
    outs.Write(Pcode.Name[1], len);
  End;
  //xrefs
  if Assigned(xrefs) and (xrefs.Count<>0) then num := xrefs.Count
    else num := 0;
  outs.Write(num, sizeof(num));
  for m := 0 to num-1 do
  Begin
    recX := PXrefRec(xrefs[m]);
    //type
    outs.Write(recX._type, sizeof(recX._type));
    //adr
    outs.Write(recX.adr, sizeof(recX.adr));
    //offset
    outs.Write(recX.offset, sizeof(recX.offset));
  End;
  if kind = ikResString then
  Begin
    //value
    len := Length(rsInfo); 
    if len > MaxBufLen then MaxBufLen := len;
    outs.Write(len, sizeof(len));
    outs.Write(rsInfo[1], len);
  End
  else if kind = ikVMT then
  Begin
  	//interfaces
    if Assigned(vmtInfo.interfaces) and (vmtInfo.interfaces.Count<>0) then
    	num := vmtInfo.interfaces.Count
    else num := 0;
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      s:=vmtInfo.interfaces[m];
      len := Length(s);
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(s[1], len);
    End;
	  //fields
    if Assigned(vmtInfo.fields) and (vmtInfo.fields.Count<>0) then
    	num := vmtInfo.fields.Count
    else num := 0;
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      fInfo := FieldInfo(vmtInfo.fields[m]);
      //Scope
      outs.Write(fInfo.Scope, sizeof(fInfo.Scope));
      //Offset
      outs.Write(fInfo.Offset, sizeof(fInfo.Offset));
      //Case
      outs.Write(fInfo._Case, sizeof(fInfo._Case));
      //Name
      len := Length(fInfo.Name); 
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(fInfo.Name[1], len);
      //Type
      len := Length(fInfo._Type); 
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(fInfo._Type[1], len);
      //xrefs
      if Assigned(fInfo.xrefs) and (fInfo.xrefs.Count<>0) then
        xnum := fInfo.xrefs.Count
      else xnum := 0;
      outs.Write(xnum, sizeof(xnum));
      for xm := 0 to xnum-1 do
      Begin
        recX := PXrefRec(fInfo.xrefs[xm]);
        //type
        outs.Write(recX._type, sizeof(recX._type));
        //adr
        outs.Write(recX.adr, sizeof(recX.adr));
        //offset
        outs.Write(recX.offset, sizeof(recX.offset));
      End;
    End;
	  //methods
    if Assigned(vmtInfo.methods) and (vmtInfo.methods.Count<>0) then
    	num := vmtInfo.methods.Count
    else num := 0;
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      recM := PMethodRec(vmtInfo.methods[m]);
      outs.Write(recM._abstract, sizeof(recM._abstract));
      outs.Write(recM.kind, sizeof(recM.kind));
      outs.Write(recM.id, sizeof(recM.id));
      outs.Write(recM.address, sizeof(recM.address));
      len := Length(recM.name); 
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(recM.name[1], len);
    End;
  End
  else if kind in [ikRefine..ikFunc] then
  Begin
    //flags
    outs.Write(procInfo.flags, sizeof(procInfo.flags));
    //bpBase
    outs.Write(procInfo.bpBase, sizeof(procInfo.bpBase));
    //retBytes
    outs.Write(procInfo.retBytes, sizeof(procInfo.retBytes));
    //procSize
    outs.Write(procInfo.procSize, sizeof(procInfo.procSize));
    //stackSize
    outs.Write(procInfo.stackSize, sizeof(procInfo.stackSize));
  	//args
    if Assigned(procInfo.args) and (procInfo.args.Count<>0) then
    	num := procInfo.args.Count
    else num := 0;
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      aInfo := PArgInfo(procInfo.args[m]);
      //Tag
      outs.Write(aInfo.Tag, sizeof(aInfo.Tag));
      //Register
      outs.Write(aInfo.in_reg, sizeof(aInfo.in_reg));
      //Ndx
      outs.Write(aInfo.Ndx, sizeof(aInfo.Ndx));
      //Size
      outs.Write(aInfo.Size, sizeof(aInfo.Size));
      //Name
      len := Length(aInfo.Name); 
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(aInfo.Name[1], len);
      //TypeDef
      len := Length(aInfo.TypeDef); 
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(aInfo.TypeDef[1], len);
    End;
    //locals
    if Assigned(procInfo.locals) and (procInfo.locals.Count<>0) then
    	num := procInfo.locals.Count
    else num := 0;
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      locInfo := PLocalInfo(procInfo.locals[m]);
      //Ofs
      outs.Write(locInfo.Ofs, sizeof(locInfo.Ofs));
      //Size
      outs.Write(locInfo.Size, sizeof(locInfo.Size));
      //Name
      len := Length(locInfo.Name); 
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(locInfo.Name[1], len);
      //TypeDef
      len := Length(locInfo.TypeDef); 
      if len > MaxBufLen then MaxBufLen := len;
      outs.Write(len, sizeof(len));
      outs.Write(locInfo.TypeDef[1], len);
    End;
  End; 
end;

procedure InfoRec.Load(ins:TStream; buf:Pointer);
var
  m, xm, num, xnum, len, xrefAdr, pxrefAdr:Integer;
  recX1:XrefRec;
  recX:PXRefRec;
  fInfo:FieldInfo;
  recM:PMethodRec;
  aInfo:PArgInfo;
  locInfo:PLocalInfo;
Begin
  //kbIdx
  ins.Read(kbIdx, sizeof(kbIdx));
  //name
  ins.Read(len, sizeof(len));
  ins.Read(buf^, len);
  name := MakeString(buf, len);
  //type
  ins.Read(len, sizeof(len));
  ins.Read(buf^, len);
  _type := MakeString(buf, len);
  //picode
  ins.Read(Pcode, sizeof(Pcode));
  if Assigned(Pcode) then
  Begin
  	New(Pcode);
    //Op
    ins.Read(Pcode.Op, sizeof(Pcode.Op));
    //Ofs
    {if _code.Op = OP_CALL then
    	ins.Read(_icode.Ofs.Address, sizeof(_code.Ofs.Address))
    else}
    	ins.Read(Pcode.Offset, sizeof(Pcode.Offset));
    //Name
    ins.Read(len, sizeof(len));
    ins.Read(buf^, len);
    Pcode.Name := MakeString(buf, len);
  End;
  //xrefs
  ins.Read(num, sizeof(num));
  if num<>0 then xrefs := TList.Create;
  pxrefAdr := 0;
  for m := 0 to num-1 do
  Begin
    //type
    ins.Read(recX1._type, sizeof(recX1._type));
    //adr
    ins.Read(recX1.adr, sizeof(recX1.adr));
    //offset
    ins.Read(recX1.offset, sizeof(recX1.offset));
    xrefAdr := recX1.adr + recX1.offset;
    if (pxrefAdr=0) or (pxrefAdr <> xrefAdr) then   //clear duplicates
    Begin
    	New(recX);
      recX._type := recX1._type;
      recX.adr := recX1.adr;
      recX.offset := recX1.offset;
      xrefs.Add(recX);
      pxrefAdr := xrefAdr;
    End;
  End;
  if kind = ikResString then
  Begin
  	//value
    ins.Read(len, sizeof(len));
    ins.Read(buf^, len);
    rsInfo := MakeString(buf, len);
  End
  else if kind = ikVMT then
  Begin
  	//interfaces
    ins.Read(num, sizeof(num));
    if num<>0 then vmtInfo.interfaces := TStringList.Create;
    for m := 0 to num-1 do
    Begin
      ins.Read(len, sizeof(len));
      ins.Read(buf^, len);
      vmtInfo.interfaces.Add(MakeString(buf, len));
    End;
  	//fields
    ins.Read(num, sizeof(num));
    if num<>0 then vmtInfo.fields := TObjectList.Create(True);
    for m := 0 to num-1 do
    Begin
    	fInfo := FieldInfo.Create;
      //Scope
      ins.Read(fInfo.Scope, sizeof(fInfo.Scope));
      //Offset
      ins.Read(fInfo.Offset, sizeof(fInfo.Offset));
      //Case
      ins.Read(fInfo._Case, sizeof(fInfo._Case));
      //Name
      ins.Read(len, sizeof(len));
      ins.Read(buf^, len);
      fInfo.Name := MakeString(buf, len);
      //Type
      ins.Read(len, sizeof(len));
      ins.Read(buf^, len);
      fInfo._Type := MakeString(buf, len);
      //xrefs
      ins.Read(xnum, sizeof(xnum));
      if xnum<>0 then fInfo.xrefs := TList.Create;
      for xm := 0 to xnum-1 do
      Begin
        New(recX);
        //type
        ins.Read(recX._type, sizeof(recX._type));
        //adr
        ins.Read(recX.adr, sizeof(recX.adr));
        //offset
        ins.Read(recX.offset, sizeof(recX.offset));
        fInfo.xrefs.Add(recX);
      End;
      vmtInfo.fields.Add(fInfo);
    End;
  	//methods
    ins.Read(num, sizeof(num));
    if num<>0 then vmtInfo.methods := TList.Create;
    for m := 0 to num-1 do
    Begin
    	New(recM);
      with ins do
      begin
        Read(recM._abstract, sizeof(recM._abstract));
        Read(recM.kind, sizeof(recM.kind));
        Read(recM.id, sizeof(recM.id));
        Read(recM.address, sizeof(recM.address));
        Read(len, sizeof(len));
        Read(buf^, len);
      end;
      recM.name := MakeString(buf, len);
      vmtInfo.methods.Add(recM);
    End;
  End
  else if kind in [ikRefine..ikFunc] then
  Begin
    //flags
    ins.Read(procInfo.flags, sizeof(procInfo.flags));
    //bpBase
    ins.Read(procInfo.bpBase, sizeof(procInfo.bpBase));
    //retBytes
    ins.Read(procInfo.retBytes, sizeof(procInfo.retBytes));
    //procSize
    ins.Read(procInfo.procSize, sizeof(procInfo.procSize));
    //stackSize
    ins.Read(procInfo.stackSize, sizeof(procInfo.stackSize));
 		//args
    ins.Read(num, sizeof(num));
    if num<>0 then procInfo.args := TList.Create;
    for m := 0 to num-1 do
    Begin
    	New(aInfo);
      //Tag
      ins.Read(aInfo.Tag, sizeof(aInfo.Tag));
      //Register
      ins.Read(aInfo.in_reg, sizeof(aInfo.in_reg));
      //Ndx
      ins.Read(aInfo.Ndx, sizeof(aInfo.Ndx));
      //Size
      ins.Read(aInfo.Size, sizeof(aInfo.Size));
      //Name
      ins.Read(len, sizeof(len));
      ins.Read(buf^, len);
      aInfo.Name := MakeString(buf, len);
      //TypeDef
      ins.Read(len, sizeof(len));
      ins.Read(buf^, len);
      aInfo.TypeDef := TrimTypeName(MakeString(buf, len));
      procInfo.args.Add(aInfo);
    End;
    //locals
    ins.Read(num, sizeof(num));
    if num<>0 then procInfo.locals := TList.Create;
    for m := 0 to num-1 do
    Begin
    	New(locInfo);
      //Ofs
      ins.Read(locInfo.Ofs, sizeof(locInfo.Ofs));
      //Size
      ins.Read(locInfo.Size, sizeof(locInfo.Size));
      //Name
      ins.Read(len, sizeof(len));
      ins.Read(buf^, len);
      locInfo.Name := MakeString(buf, len);
      //TypeDef
      ins.Read(len, sizeof(len));
      ins.Read(buf^, len);
      locInfo.TypeDef := TrimTypeName(MakeString(buf, len));
      procInfo.locals.Add(locInfo);
    End;
  End; 
end;

Function InfoRec.MakePrototype (adr:Integer; showKind, showTail, multiline, fullName, allArgs:Boolean):AnsiString;
var
  callKind:Byte;
  n, num,argsNum, firstArg:Integer;
  aInfo:PArgInfo;
  argRes:AnsiString;
Begin
  Result:='';
  if showKind then
  case kind of
    ikConstructor: Result:='constructor ';
    ikDestructor: Result:='destructor ';
    ikFunc: Result:='function ';
    ikProc: Result:='procedure ';
  End;
  if Fname <> '' then
  Begin
    if not fullName then result:=Result + ExtractProcName(name)
      else result:=Result + Fname;
  End
  else result:=Result + GetDefaultProcName(adr);
  if Assigned(procInfo.args) then argsNum := procInfo.args.Count
    else argsNum := 0;
  num:=argsNum;
  firstArg := 0;
  if (num<>0) and not allArgs then
  Begin
    if (kind = ikConstructor) or (kind = ikDestructor) then
    Begin
      firstArg := 2;
      Dec(num, 2);
    End
    else if procInfo.flags * PF_ALLMETHODS <> [] then
    Begin
      firstArg := 1;
      Dec(num);
    End;
  End;
  if num<>0 then
  Begin
    result:=Result + '(';
    if multiline then result:=Result + #13;
    for n := firstArg to argsNum-1 do
    Begin
      if n <> firstArg then
      Begin
        result:=result + ';';
        if multiline then Result:=Result + #13
          else result:=Result + ' ';
      End;
      aInfo := PArgInfo(procInfo.args[n]);
      if aInfo.Tag = $22 then result:=Result + 'var ';
      if aInfo.Name <> '' then result:=Result + aInfo.Name
        else result:=Result + '?';
      result:=Result + ':';
      if aInfo.TypeDef <> '' then result:=Result + aInfo.TypeDef
        else result:=Result + '?';
    End;
    if multiline then result:=Result + #13;
    result:=Result + ')';
  End;
  if kind = ikFunc then
  Begin
    result:=Result + ':';
    if _type <> '' then result:=Result + TrimTypeName(_type)
      else result:=Result + '?';
  End;
  result:=Result + ';';
  callKind := procInfo.call_kind;
  case callKind of
    1: result:=result + ' cdecl;';
    2: result:=result + ' pascal;';
    3: result:=result + ' stdcall;';
    4: result:=result + ' safecall;';
  End;
  argres := '';
  //fastcall
  if callKind=0 then //(!IsFlagSet(cfImport, Adr2Pos(Adr)))
  Begin
    for n := 0 to argsNum-1 do
    Begin
      aInfo := PArgInfo(procInfo.args[n]);
      //if callKind=0 then
      //Begin
          case aInfo.Ndx of
            0: argres:=argRes + 'A';
            1: argres:=argRes + 'D';
            2: argres:=argRes + 'C';
          end;
      //End;
    End;
  End;
  if showTail then
  Begin
    if argres <> '' then result:=result + ' in' + argres;
    //output registers
    //if (info.procInfo.flags and PF_OUTEAX)<>0 then result:=result + ' out';
    if procInfo.retBytes<>0 then result:=result + ' RET ' + Val2Str(procInfo.retBytes);
    if PF_ARGSIZEG in procInfo.flags then result:=result + '+';
    if PF_ARGSIZEL in procInfo.flags then result:=result + '-';
  End;
end;

Function InfoRec.MakeDelphiPrototype (Adr:Integer; recM:PMethodRec):AnsiString;
var
  _abstract:Boolean;
  callKind:Byte;
  n, num, argsNum, firstArg:Integer;
  aInfo:PArgInfo;
Begin
  _abstract:=False;
  Result:='';
  case kind of
    ikConstructor: Result:= 'constructor ';
    ikDestructor:  Result:= 'destructor ';
    ikFunc:        Result:= 'function ';
    ikProc:        Result:= 'procedure ';
  end;
  if SameText(Fname, '@AbstractError') then _abstract := true;
  if Fname <> '' then
  Begin
    if not _abstract then Result:=Result+ExtractProcName(Fname)
    else if recM.name <> '' then Result:=Result+ExtractProcName(recM.name)
    else Result:=Result + 'v'+IntToHex(recM.id,0);
  End
  else Result:=Result + 'v'+IntToHex(recM.id,0);
  if Assigned(procInfo.args) then argsNum := procInfo.args.Count
    else argsNum := 0;
  num:=argsNum;
  firstArg:=0;
  callKind:=0;
  if num<>0 then
  Begin
    if procInfo.flags * PF_ALLMETHODS <> [] then
    Begin
      firstArg := 1;
      Dec(num);
      if (kind = ikConstructor) or (kind = ikDestructor) then
      Begin
        Inc(firstArg);
        Dec(num);
      End;
    End;
    if num<>0 then
    Begin
      Result:=Result + '(';
      callKind := procInfo.call_kind;
      for n := firstArg to argsNum-1 do
      Begin
        if n <> firstArg then Result:=Result + '; ';
        aInfo := PArgInfo(procInfo.args[n]);
        if aInfo.Tag = $22 then Result:=Result + 'var ';
        if aInfo.Name <> '' then Result:=Result + aInfo.Name
          else Result:=Result + '?';
        Result:=Result + ':';
        if aInfo.TypeDef <> '' then Result:=Result + aInfo.TypeDef
          else Result:=Result + '?';
      End;
      Result:=Result +')';
    End;
  End;
  if kind = ikFunc then
  Begin
    Result:=Result +':';
    if _type <> '' then Result:=Result + TrimTypeName(_type)
      else Result:=Result + '?';
  End;
  Result:=Result + '; virtual;';
  if _abstract then Result:=Result + ' abstract;'
  else
  case callKind of
    1: Result:=Result + ' cdecl;';
    2: Result:=Result + ' pascal;';
    3: Result:=Result + ' stdcall;';
    4: Result:=Result + ' safecall;';
  End;
end;

Function InfoRec.MakeMultilinePrototype (Adr:Integer; Var ArgsBytes:Integer; MethodType:AnsiString):AnsiString;
var
  callKind:Byte;
  n, num, argsNum, firstArg:Integer;
  aInfo:PArgInfo;
Begin
  argsBytes:=0;
  if Fname <> '' then result := Fname
    else result := GetDefaultProcName(Adr);
  if Assigned(procInfo.args) then argsNum := procInfo.args.Count
    else argsNum := 0;
  num:=argsNum;
  firstArg := 0;
  if (kind = ikConstructor) or (kind = ikDestructor) then
  Begin
    firstArg := 2;
    Dec(num, 2);
  End
  else if procInfo.flags * PF_ALLMETHODS <> [] then
  Begin
    if num=0 then
    Begin
      New(aInfo);
      with aInfo^ do
      begin
        Tag := $21;
        Ndx := 0;
        Size := 4;
        Name := 'Self';
        TypeDef := MethodType;
      end;
      procInfo.AddArg(aInfo);
    End
    else
    Begin
      if MethodType <> '' then
      Begin
        with PArgInfo(procInfo.args[0])^ do
        begin
          Name := 'Self';
          TypeDef := MethodType;
        end;
        //procInfo.args[0] := aInfo;
      End;
      Dec(num);
    End;
    firstArg := 1;
  End;
  if num > 0 then result:=result + '('+#13;
  callKind := procInfo.call_kind;
  for n := firstArg to argsNum-1 do
  Begin
    if n <> firstArg then result:=result + ';'+#13;
    aInfo := PArgInfo(procInfo.args[n]);
    //var
    if aInfo.Tag = $22 then result:=result + 'var ';
    //name
    if aInfo.Name <> '' then result:=result + aInfo.Name
      else result:=result + '?';
    //type
    result:=result + ':';
    if aInfo.TypeDef <> '' then result:=result + aInfo.TypeDef
      else result:=result + '?';
    //size
    if aInfo.Size > 4 then result:=result + ':' + IntToStr(aInfo.Size);
    if aInfo.Ndx > 2 then Inc(argsBytes, aInfo.Size);
  End;
  if num > 0 then result:=result +#13 + ')';
  if kind = ikFunc then
  Begin
    result:=result + ':';
    if _type <> '' then result:=result + TrimTypeName(_type)
      else result:=result + '?';
  End;
  result:=result + ';';
end;

Function InfoRec.MakeMapName (Adr:Integer):AnsiString;
Begin
  if Fname <> '' then result := Fname
    else result := GetDefaultProcName(Adr);
end;

Function InfoRec.MakeArgsManually:Boolean;
var
  sname,tmp:AnsiString;
Begin
  Result:=True;
	//if (info.procInfo.flags and PF_KBPROTO)<>0 then Exit;
  //Some procedures not begin with '@'
  //function QueryInterface(Self:Pointer; IID:TGUID; var Obj:Pointer);
  if Pos('.QueryInterface',fname)<>0 then
  Begin
    kind := ikFunc;
    _type := 'HRESULT';
    procInfo.call_kind := 3; //stdcall
    procInfo.AddArg($21, 8, 4, 'Self', '');
    procInfo.AddArg($21, 12, 4, 'IID', 'TGUID');
    procInfo.AddArg($22, 16, 4, 'Obj', 'Pointer');
    Exit;
  End
  //function _AddRef(Self:Pointer):Integer;
  //function _Release(Self:Pointer):Integer;
  else if (Pos('._AddRef',FName)<>0) or (Pos('._Release',FName)<>0) then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.call_kind := 3; //stdcall
    procInfo.AddArg($21, 8, 4, 'Self', '');
    Exit;
  End
  //procedure DynArrayClear(var arr:Pointer; typeInfo:PDynArrayTypeInfo);
  else if SameText(Fname, 'DynArrayClear') then
  Begin
  	kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'arr', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'typeInfo', 'PDynArrayTypeInfo');
    Exit;
  End
  //procedure DynArraySetLength(var arr:Pointer; typeInfo:PDynArrayTypeInfo; dimCnt:Longint; lenVec:PLongint);
  else if SameText(fname, 'DynArraySetLength') then
  Begin
  	kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'arr', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'typeInfo', 'PDynArrayTypeInfo');
    procInfo.AddArg($21, 2, 4, 'dimCnt', 'Longint');
    procInfo.AddArg($21, 8, 4, 'lenVec', 'PLongint');
    Exit;
  End;
  if Fname[1] <> '@' then
  begin
    Result:=false;
    Exit;
  End;
  //Strings
  if fname[2] = 'L' then sname := 'AnsiString'
  else if fname[2] = 'W' then sname := 'WideString'
  else if fname[2] = 'U' then sname := 'UnicodeString'
  else sname := '?';
  if sname <> '?' then
  Begin
    tmp:=Copy(fname,3,Length(fname));
    //@LStrClr, @WStrClr, @UStrClr
    if SameText(tmp, 'StrClr') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'S', sname);
      Exit;
    End
    //@LStrArrayClr, @WStrArrayClr, @UStrArrayClr
    else if SameText(tmp, 'StrArrayClr') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'StrArray', 'Pointer');
      procInfo.AddArg($21, 1, 4, 'Count', 'Integer');
      Exit;
    End
    //@LStrAsg, @WStrAsg, @UStrAsg
    else if SameText(tmp, 'StrAsg') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', sname);
      Exit;
    End
    //@LStrLAsg, @WStrLAsg, @UStrLAsg
    else if SameText(tmp, 'StrLAsg') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', sname);
      Exit;
    End
    //@LStrFromPCharLen, @WStrFromPCharLen, @UStrFromPCharLen
    else if SameText(tmp, 'StrFromPCharLen') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'PAnsiChar');
      procInfo.AddArg($21, 2, 4, 'Length', 'Integer');
      Exit;
    End
    //@LStrFromPWCharLen, @WStrFromPWCharLen, @UStrFromPWCharLen
    else if SameText(tmp, 'StrFromPWCharLen') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'PWideChar');
      procInfo.AddArg($21, 2, 4, 'Length', 'Integer');
      Exit;
    End
    //@LStrFromChar, @WStrFromChar, @UStrFromChar
    else if SameText(tmp, 'StrFromChar') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'AnsiChar');
      Exit;
    End
    //@LStrFromWChar, @WStrFromWChar, @UStrFromWChar
    else if SameText(tmp, 'StrFromWChar') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'WideChar');
      Exit;
    End
    //@LStrFromPChar, @WStrFromPChar, @UStrFromPChar
    else if SameText(tmp, 'StrFromPChar') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'PAnsiChar');
      Exit;
    End
    //@LStrFromPWChar, @WStrFromPWChar, @UStrFromPWChar
    else if SameText(tmp, 'StrFromPWChar') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'PWideChar');
      Exit;
    End
    //@LStrFromString, @WStrFromString, @UStrFromString
    else if SameText(tmp, 'StrFromString') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'ShortString');
      Exit;
    End
    //@LStrFromArray, @WStrFromArray, @UStrFromArray
    else if SameText(tmp, 'StrFromArray') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'PAnsiChar');
      procInfo.AddArg($21, 2, 4, 'Length', 'Integer');
      Exit;
    End
    //@LStrFromWArray, @WStrFromWArray, @UStrFromWArray
    else if SameText(tmp, 'StrFromWArray') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'PWideChar');
      procInfo.AddArg($21, 2, 4, 'Length', 'Integer');
      Exit;
    End
    //@LStrFromWStr, @UStrFromWStr
    else if SameText(tmp, 'StrFromWStr') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'WideString');
      Exit;
    End
    //@LStrToString, @WStrToString, @UStrToString
    else if SameText(tmp, 'StrToString') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', 'ShortString');
      procInfo.AddArg($21, 1, 4, 'Source', sname);
      procInfo.AddArg($21, 2, 4, 'MaxLen', 'Integer');
      Exit;
    End
    //@LStrLen, @WStrLen, @UStrLen
    else if SameText(tmp, 'StrLen') then
    Begin
      kind := ikFunc;
      _type := 'Integer';
      procInfo.AddArg($21, 0, 4, 'S', sname);
      Exit;
    End
    //@LStrCat, @WStrCat, @UStrCat
    else if SameText(tmp, 'StrCat') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', sname);
      Exit;
    End
    //@LStrCat3, @WStrCat3, @UStrCat3
    else if SameText(tmp, 'StrCat3') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source1', sname);
      procInfo.AddArg($21, 2, 4, 'Source2', sname);
      Exit;
    End
    //@LStrCatN, @WStrCatN, @UStrCatN
    else if SameText(tmp, 'StrCatN') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'ArgCnt', 'Integer');
      Exit;
    End
    //@LStrCmp, @WStrCmp, @UStrCmp
    else if SameText(tmp, 'StrCmp') then //return Flags
    Begin
      kind := ikFunc;
      procInfo.AddArg($21, 0, 4, 'Left', sname);
      procInfo.AddArg($21, 1, 4, 'Right', sname);
      Exit;
    End
    //@LStrAddRef, @WStrAddRef, @UStrAddRef
    else if SameText(tmp, 'StrAddRef') then
    Begin
      kind := ikFunc;
      _type := 'Pointer';
      procInfo.AddArg($22, 0, 4, 'S', sname);
      Exit;
    End
    //@LStrToPChar, @WStrToPChar, @UStrToPChar
    else if SameText(tmp, 'StrToPChar') then
    Begin
      kind := ikFunc;
      _type := 'PChar';
      procInfo.AddArg($21, 0, 4, 'S', sname);
      Exit;
    End
    //@LStrCopy, @WStrCopy, @UStrCopy
    else if SameText(tmp, 'StrCopy') then
    Begin
      kind := ikFunc;
      _type := sname;
      procInfo.AddArg($21, 0, 4, 'S', sname);
      procInfo.AddArg($21, 1, 4, 'Index', 'Integer');
      procInfo.AddArg($21, 2, 4, 'Count', 'Integer');
      Exit;
    End
    //@LStrDelete, @WStrDelete, @UStrDelete
    else if SameText(tmp, 'StrDelete') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'S', sname);
      procInfo.AddArg($21, 1, 4, 'Index', 'Integer');
      procInfo.AddArg($21, 2, 4, 'Count', 'Integer');
      Exit;
    End
    //@LStrInsert, @WStrInsert, @UStrInsert
    else if SameText(tmp, 'StrInsert') then
    Begin
      kind := ikProc;
      procInfo.AddArg($21, 0, 4, 'Source', sname);
      procInfo.AddArg($22, 1, 4, 'S', sname);
      procInfo.AddArg($21, 2, 4, 'Index', 'Integer');
      Exit;
    End
    //@LStrPos, @WStrPos, @UStrPos
    else if SameText(tmp, 'StrPos') then
    Begin
      kind := ikFunc;
      _type := 'Integer';
      procInfo.AddArg($21, 0, 4, 'Substr', sname);
      procInfo.AddArg($21, 1, 4, 'S', sname);
      Exit;
    End
    //@LStrSetLength, @WStrSetLength, @UStrSetLength
    else if SameText(tmp, 'StrSetLength') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'S', sname);
      procInfo.AddArg($21, 1, 4, 'NewLen', 'Integer');
      Exit;
    End
    //@LStrOfChar, @WStrOfChar, @UStrOfChar
    else if SameText(tmp, 'StrOfChar') then
    Begin
      kind := ikProc;
      procInfo.AddArg($21, 0, 1, 'C', 'Char');
      procInfo.AddArg($21, 1, 4, 'Count', 'Integer');
      procInfo.AddArg($22, 2, 4, 'Result', sname);
      Exit;
    End
    //@WStrToPWChar, @UStrToPWChar
    else if SameText(tmp, 'StrToPWChar') then
    Begin
      kind := ikFunc;
      _type := 'PWideChar';
      procInfo.AddArg($21, 0, 4, 'S', sname);
      Exit;
    End
    //@WStrFromLStr, @UStrFromLStr
    else if SameText(tmp, 'StrFromLStr') then
    Begin
      kind := ikProc;
      procInfo.AddArg($22, 0, 4, 'Dest', sname);
      procInfo.AddArg($21, 1, 4, 'Source', 'AnsiString');
      Exit;
    End
    //@WStrOfWChar
    else if SameText(tmp, 'StrOfWChar') then
    Begin
      kind := ikProc;
      procInfo.AddArg($21, 0, 4, 'C', 'WideChar');
      procInfo.AddArg($21, 1, 4, 'Count', 'Integer');
      procInfo.AddArg($22, 2, 4, 'Result', sname);
      Exit;
    End
    //@UStrEqual
    else if SameText(tmp, 'StrEqual') then
    Begin
      kind := ikProc;
      procInfo.AddArg($21, 0, 4, 'Left', sname);
      procInfo.AddArg($21, 1, 4, 'Right', sname);
      Exit;
    End;
  End;

  //ShortStrings
  sname := 'ShortString';
  //@Copy
  if SameText(fname, '@Copy') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'S', sname);
    procInfo.AddArg($21, 1, 4, 'Index', 'Integer');
    procInfo.AddArg($21, 2, 4, 'Count', 'Integer');
    procInfo.AddArg($21, 8, 4, 'Result', sname);
    Exit;
  End
  //@Delete
  else if SameText(fname, '@Delete') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'S', sname);
    procInfo.AddArg($21, 1, 4, 'Index', 'Integer');
    procInfo.AddArg($21, 2, 4, 'Count', 'Integer');
    Exit;
  End
  //@Insert
  else if SameText(fname, '@Insert') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Source', sname);
    procInfo.AddArg($22, 1, 4, 'Dest', 'ShortString');
    procInfo.AddArg($21, 2, 4, 'Index', 'Integer');
    Exit;
  End
  //@Pos
  else if SameText(fname, '@Pos') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($21, 0, 4, 'Substr', sname);
    procInfo.AddArg($21, 1, 4, 'S', sname);
    Exit;
  End;

  sname := 'PShortString';
  //@SetLength
  if SameText(fname, '@SetLength') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'S', sname);
    procInfo.AddArg($21, 1, 4, 'NewLength', 'Byte');
    Exit;
  End
  //@SetString
  else if SameText(fname, '@SetString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'S', sname);
    procInfo.AddArg($21, 1, 4, 'Buffer', 'PChar');
    procInfo.AddArg($21, 2, 4, 'Length', 'Byte');
    Exit;
  End
  //@PStrCat
  else if SameText(fname, '@PStrCat') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Dest', sname);
    procInfo.AddArg($21, 1, 4, 'Source', sname);
    Exit;
  End
  //@PStrNCat
  else if SameText(fname, '@PStrNCat') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Dest', sname);
    procInfo.AddArg($21, 1, 4, 'Source', sname);
    procInfo.AddArg($21, 2, 4, 'MaxLen', 'Byte');
    Exit;
  End
  //@PStrCpy
  else if SameText(fname, '@PStrCpy') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Dest', sname);
    procInfo.AddArg($21, 1, 4, 'Source', sname);
    Exit;
  End
  //@PStrNCpy
  else if SameText(fname, '@PStrNCpy') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Dest', sname);
    procInfo.AddArg($21, 1, 4, 'Source', sname);
    procInfo.AddArg($21, 2, 4, 'MaxLen', 'Byte');
    Exit;
  End
  //@AStrCmp
  else if SameText(fname, '@AStrCmp') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'S1', sname);
    procInfo.AddArg($21, 1, 4, 'S2', sname);
    procInfo.AddArg($21, 2, 4, 'Bytes', 'Integer');
    Exit;
  End
  //@PStrCmp
  else if SameText(fname, '@PStrCmp') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'S1', sname);
    procInfo.AddArg($21, 1, 4, 'S2', sname);
    Exit;
  End
  //@Str0Long
  else if SameText(fname, '@Str0Long') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Val', 'Longint');
    procInfo.AddArg($21, 1, 4, 'S', sname);
    Exit;
  End
  //@StrLong
  else if SameText(fname, '@StrLong') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Val', 'Integer');
    procInfo.AddArg($21, 1, 4, 'Width', 'Integer');
    procInfo.AddArg($21, 2, 4, 'S', sname);
    Exit;
  End

  //Files
  //@Append(
  Else if SameText(fname, '@Append') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@Assign
  else if SameText(fname, '@Assign') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'S', 'String');
    Exit;
  End
  //@BlockRead
  else if SameText(fname, '@BlockRead') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'buffer', 'Pointer');
    procInfo.AddArg($21, 2, 4, 'recCnt', 'Longint');
    procInfo.AddArg($22, 8, 4, 'recsRead', 'Longint');
    Exit;
  End
  //@BlockWrite
  else if SameText(fname, '@BlockWrite') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'buffer', 'Pointer');
    procInfo.AddArg($21, 2, 4, 'recCnt', 'Longint');
    procInfo.AddArg($22, 8, 4, 'recsWritten', 'Longint');
    Exit;
  End
  //@Close
  else if SameText(fname, '@Close') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@EofFile
  else if SameText(fname, '@EofFile') then
  Begin
    kind := ikFunc;
    _type := 'Boolean';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@EofText
  else if SameText(fname, '@EofText') then
  Begin
    kind := ikFunc;
    _type := 'Boolean';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@Eoln
  else if SameText(fname, '@Eoln') then
  Begin
    kind := ikFunc;
    _type := 'Boolean';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@Erase
  else if SameText(fname, '@Erase') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@FilePos
  else if SameText(fname, '@FilePos') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@FileSize
  else if SameText(fname, '@FileSize') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@Flush
  else if SameText(fname, '@Flush') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@ReadRec
  else if SameText(fname, '@ReadRec') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'Buffer', 'Pointer');
    Exit;
  End
  //@ReadChar
  else if SameText(fname, '@ReadChar') then
  Begin
    kind := ikFunc;
    _type := 'Char';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@ReadLong
  else if SameText(fname, '@ReadLong') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@ReadString
  else if SameText(fname, '@ReadString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'PShortString');
    procInfo.AddArg($21, 2, 4, 'MaxLen', 'Longint');
    Exit;
  End
  //@ReadCString
  else if SameText(fname, '@ReadCString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'PAnsiChar');
    procInfo.AddArg($21, 2, 4, 'MaxLen', 'Longint');
    Exit;
  End
  //@ReadLString
  else if SameText(fname, '@ReadLString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($22, 1, 4, 'S', 'AnsiString');
    Exit;
  End
  //@ReadWString
  else if SameText(fname, '@ReadWString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($22, 1, 4, 'S', 'WideString');
    Exit;
  End
  //@ReadUString
  else if SameText(fname, '@ReadUString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($22, 1, 4, 'S', 'UnicodeString');
    Exit;
  End
  //@ReadWCString
  else if SameText(fname, '@ReadWCString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'PWideChar');
    procInfo.AddArg($21, 2, 4, 'MaxBytes', 'Longint');
    Exit;
  End
  //@ReadWChar
  else if SameText(fname, '@ReadWChar') then
  Begin
    kind := ikFunc;
    _type := 'WideChar';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@ReadExt
  else if SameText(fname, '@ReadExt') then
  Begin
    //kind := ikFunc;
    //type := 'Extended';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@ReadLn
  else if SameText(fname, '@ReadLn') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@Rename
  else if SameText(fname, '@Rename') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'NewName', 'PChar');
    Exit;
  End
  //@ResetFile
  else if SameText(fname, '@ResetFile') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'RecSize', 'Longint');
    Exit;
  End
  //@ResetText
  else if SameText(fname, '@ResetText') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@RewritFile
  else if SameText(fname, '@RewritFile') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'RecSize', 'Longint');
    Exit;
  End
  //@RewritText
  else if SameText(fname, '@RewritText') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    //procInfo.AddArg($21, 1, 4, 'recSize', 'Longint');
    Exit;
  End
  //@Seek
  else if SameText(fname, '@Seek') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'RecNum', 'Longint');
    Exit;
  End
  //@SeekEof
  else if SameText(fname, '@SeekEof') then
  Begin
    kind := ikFunc;
    _type := 'Boolean';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@SeekEoln
  else if SameText(fname, '@SeekEoln') then
  Begin
    kind := ikFunc;
    _type := 'Boolean';
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@SetTextBuf
  else if SameText(fname, '@SetTextBuf') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'P', 'Pointer');
    procInfo.AddArg($21, 2, 4, 'Size', 'Longint');
    Exit;
  End
  //@Truncate
  else if SameText(fname, '@Truncate') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    Exit;
  End
  //@WriteRec
  else if SameText(fname, '@WriteRec') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'F', 'TFileRec');
    procInfo.AddArg($21, 1, 4, 'Buffer', 'Pointer');
    Exit;
  End
  //@WriteChar
  else if SameText(fname, '@WriteChar') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'C', 'AnsiChar');
    procInfo.AddArg($21, 2, 4, 'Width', 'Integer');
    Exit;
  End
  //@Write0Char
  else if SameText(fname, '@Write0Char') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'C', 'AnsiChar');
    Exit;
  End
  //@WriteBool
  else if SameText(fname, '@WriteBool') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'Val', 'Boolean');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0Bool
  else if SameText(fname, '@Write0Bool') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'Val', 'Boolean');
    Exit;
  End
  //@WriteLong
  else if SameText(fname, '@WriteLong') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'Val', 'Longint');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0Long
  else if SameText(fname, '@Write0Long') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'Val', 'Longint');
    Exit;
  End
  //@WriteString
  else if SameText(fname, '@WriteString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'ShortString');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0String
  else if SameText(fname, '@Write0String') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'ShortString');
    Exit;
  End
  //@WriteCString
  else if SameText(fname, '@WriteCString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'PAnsiChar');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0CString
  else if SameText(fname, '@Write0CString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'PAnsiChar');
    Exit;
  End
  //@WriteLString
  else if SameText(fname, '@WriteLString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'AnsiString');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0LString
  else if SameText(fname, '@Write0LString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'AnsiString');
    Exit;
  End
  //@Write2Ext
  else if SameText(fname, '@Write2Ext') or SameText(fname, '@Str2Ext') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 8, 12, 'Val', 'Extended');
    procInfo.AddArg($21, 1, 4, 'Width', 'Longint');
    procInfo.AddArg($21, 2, 4, 'Precision', 'Longint');
    Exit;
  End
  //@WriteWString
  else if SameText(fname, '@WriteWString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'WideString');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0WString
  else if SameText(fname, '@Write0WString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'WideString');
    Exit;
  End
  //@WriteWCString
  else if SameText(fname, '@WriteWCString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'PWideChar');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0WCString
  else if SameText(fname, '@Write0WCString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'PWideChar');
    Exit;
  End
  //@WriteWChar
  else if SameText(fname, '@WriteWChar') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'C', 'WideChar');
    procInfo.AddArg($21, 2, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0WChar
  else if SameText(fname, '@Write0WChar') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'C', 'WideChar');
    Exit;
  End
  //@Write1Ext
  else if SameText(fname, '@Write1Ext') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'Width', 'Longint');
    Exit;
  End
  //@Write0Ext
  else if SameText(fname, '@Write0Ext') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@WriteLn
  else if SameText(fname, '@WriteLn') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    Exit;
  End
  //@WriteUString
  else if SameText(fname, '@WriteUString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'UnicodeString');
    procInfo.AddArg($21, 2, 4, 'Width', 'Integer');
    Exit;
  End
  //@Write0UString
  else if SameText(fname, '@Write0UString') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'S', 'UnicodeString');
    Exit;
  End
  //@WriteVariant
  else if SameText(fname, '@WriteVariant') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'V', 'TVarData');
    procInfo.AddArg($21, 2, 4, 'Width', 'Integer');
    Exit;
  End
  //@Write0Variant
  else if SameText(fname, '@Write0Variant') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'T', 'TTextRec');
    procInfo.AddArg($21, 1, 4, 'V', 'TVarData');
    Exit;
  End;

  //Other

  //function @AsClass(child:TObject; parent:TClass):TObject;
  if SameText(fname, '@AsClass') then
  Begin
    kind := ikFunc;
    _type := 'TObject';
    procInfo.AddArg($21, 0, 4, 'child', 'TObject');
    procInfo.AddArg($21, 1, 4, 'parent', 'TClass');
    Exit;
  End
  //procedure @Assert(Message: String; Filename:String; LineNumber:Integer);
  else if SameText(fname, '@Assert') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Message', 'String');
    procInfo.AddArg($21, 1, 4, 'Filename', 'String');
    procInfo.AddArg($21, 2, 4, 'LineNumber', 'Integer');
    Exit;
  End
  //@BoundErr
  else if SameText(fname, '@BoundErr') then
  Begin
    kind := ikProc;
    Exit;
  End
  //@CopyArray
  else if SameText(fname, '@CopyArray') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Dest', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'Source', 'Pointer');
    procInfo.AddArg($21, 2, 4, 'TypeInfo', 'Pointer');
    procInfo.AddArg($21, 8, 4, 'Cnt', 'Integer');
    Exit;
  End
  //@CopyRecord
  else if SameText(fname, '@CopyRecord') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Dest', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'Source', 'Pointer');
    procInfo.AddArg($21, 2, 4, 'TypeInfo', 'Pointer');
    Exit;
  End

  //DynArrays
  //@DynArrayAddRef
  else if SameText(fname, '@DynArrayAddRef') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Arr', 'Pointer');
    Exit;
  End
  //@DynArrayAsg
  else if SameText(fname, '@DynArrayAsg') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'Dest', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'Source', 'Pointer');
    procInfo.AddArg($21, 2, 4, 'TypeInfo', 'PDynArrayTypeInfo');
    Exit;
  End
  //@DynArrayClear
  else if SameText(fname, '@DynArrayClear') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'Arr', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'TypeInfo', 'PDynArrayTypeInfo');
    Exit;
  End
  //@DynArrayCopy
  else if SameText(fname, '@DynArrayCopy') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Arr', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'TypeInfo', 'PDynArrayTypeInfo');
    procInfo.AddArg($22, 2, 4, 'Result', 'Pointer');
    Exit;
  End
  //@DynArrayCopyRange
  else if SameText(fname, '@DynArrayCopyRange') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 'Arr', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'TypeInfo', 'PDynArrayTypeInfo');
    procInfo.AddArg($21, 2, 4, 'Index', 'Integer');
    procInfo.AddArg($21, 8, 4, 'Count', 'Integer');
    procInfo.AddArg($22, 12, 4, 'Result', 'Pointer');
    Exit;
  End
  //@DynArrayHigh
  else if SameText(fname, '@DynArrayHigh') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($21, 0, 4, 'Arr', 'Pointer');
    Exit;
  End
  //@DynArrayLength
  else if SameText(fname, '@DynArrayLength') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($21, 0, 4, 'Arr', 'Pointer');
    Exit;
  End
  //@DynArraySetLength
  else if SameText(fname, '@DynArraySetLength') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'Arr', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'TypeInfo', 'PDynArrayTypeInfo');
    procInfo.AddArg($21, 2, 4, 'DimCnt', 'Longint');
    procInfo.AddArg($21, 8, 4, 'LengthVec', 'Longint');
    Exit;
  End
  //@FillChar
  else if SameText(fname, '@FillChar') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'dst', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'cnt', 'Integer');
    procInfo.AddArg($21, 2, 4, 'val', 'Char');
    Exit;
  End
  //@FreeMem
  else if SameText(fname, '@FreeMem') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($21, 0, 4, 'p', 'Pointer');
    Exit;
  End
  //@GetMem
  else if SameText(fname, '@GetMem') then
  Begin
    kind := ikFunc;
    _type := 'Pointer';
    procInfo.AddArg($21, 0, 4, 'size', 'Integer');
    Exit;
  End
  //@IntOver
  else if SameText(fname, '@IntOver') then
  Begin
    kind := ikProc;
    Exit;
  End
  //@IsClass
  else if SameText(fname, '@IsClass') then
  Begin
    kind := ikFunc;
    _type := 'Boolean';
    procInfo.AddArg($21, 0, 4, 'Child', 'TObject');
    procInfo.AddArg($21, 1, 4, 'Parent', 'TClass');
    Exit;
  End
  //@RandInt
  else if SameText(fname, '@RandInt') then
  Begin
    kind := ikFunc;
    _type := 'Integer';
    procInfo.AddArg($21, 0, 4, 'Range', 'Integer');
    Exit;
  End
  //@ReallocMem
  else if SameText(fname, '@ReallocMem') then
  Begin
    kind := ikFunc;
    _type := 'Pointer';
    procInfo.AddArg($22, 0, 4, 'P', 'Pointer');
    procInfo.AddArg($21, 1, 4, 'NewSize', 'Integer');
    Exit;
  End
  //@SetElem
  else if SameText(fname, '@SetElem') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'Dest', 'SET');
    procInfo.AddArg($21, 1, 1, 'Elem', 'Byte');
    procInfo.AddArg($21, 2, 1, 'Size', 'Byte');
    Exit;
  End
  //Trunc
  else if SameText(fname, '@Trunc') then
  Begin
    kind := ikFunc;
    _type := 'Int64';
    procInfo.AddArg($21, 0, 12, 'X', 'Extended');
    Exit;
  End

  //V
  //function @ValExt(s:AnsiString; var code:Integer):Extended;
  else if SameText(fname, '@ValExt') then
  Begin
    kind := ikProc;
    procInfo.AddArg($21, 0, 4, 's', 'AnsiString');
    procInfo.AddArg($22, 1, 4, 'code', 'Integer');
    Exit;
  End
  //function @ValLong(s:AnsiString; var code:Integer):Longint;
  else if SameText(fname, '@ValLong') then
  Begin
    kind := ikFunc;
    _type := 'Longint';
    procInfo.AddArg($21, 0, 4, 's', 'AnsiString');
    procInfo.AddArg($22, 1, 4, 'code', 'Integer');
    Exit;
  End
  //procedure @VarFromCurr(var v: Variant; val:Currency);
  else if SameText(fname, '@VarFromCurr') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'v', 'Variant');
    //procInfo.AddArg($21, ?, 8, 'val', 'Currency');
    Exit;
  End
  //procedure @VarFromReal(var v:Variant; val:Real);
  else if SameText(fname, '@VarFromReal') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'v', 'Variant');
    //procInfo.AddArg($21, ?, 8, 'val', 'Real'); 	fld!
    Exit;
  End
  //procedure @VarFromTDateTime(var v: Variant; val:TDateTime);
  else if SameText(fname, '@VarFromTDateTime') then
  Begin
    kind := ikProc;
    procInfo.AddArg($22, 0, 4, 'v', 'Variant');
    //procInfo.AddArg($21, ?, 8, 'val', 'TDateTime');	fld!
    Exit;
  End;
  Result:=False;
  //SET
  //procedure @SetRange(lo:Byte; hi:Byte; size:Byte; VAR d:SET); AL,DL,ECX,AH {Usage: d := [lo..hi]};
  //function @SetEq(left:SET; right:SET; size:Byte):ZF; {Usage: left := right};
  //function @SetLe(left:SET; right:SET; size:Byte):ZF;
  //procedure @SetIntersect(var dest:SET; src:SET; size:Byte);
  //procedure @SetIntersect3(var dest:SET; src:SET; size:Longint; src2:SET);
  //procedure @SetUnion(var dest:SET; src:SET; size:Byte);
  //procedure @SetUnion3(var dest:SET; src:SET; size:Longint; src2:SET);
  //procedure @SetSub(var dest:SET; src:SET; size:Byte);
  //procedure @SetSub3(var dest:SET; src:SET; size:Longint; src2:SET);
  //procedure @SetExpand(src:SET; var dest:SET; lo:Byte; hi:Byte); EAX,EDX,CH,CL
  //in <-> bt
end;

End.
