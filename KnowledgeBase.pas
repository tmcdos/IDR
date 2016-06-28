Unit KnowledgeBase;

Interface

Uses Windows,Classes,Types,Def_know;

Type
  MKnowledgeBase = class
  Public
    Version:Integer;
    ModuleCount:Integer;
    ModuleOffsets:ArrOffsetInfo;
    Mods:TWordDynArray;
    UsedProcs:TByteDynArray;
    ConstOffsets:ArrOffsetInfo;
    TypeOffsets:ArrOffsetInfo;
    VarOffsets:ArrOffsetInfo;
    ResStrOffsets:ArrOffsetInfo;
    ProcOffsets:ArrOffsetInfo;
    Destructor Destroy; Override;
    Function Open(filename:AnsiString):Boolean;
    Procedure Close;
    function GetKBCachePtr(Offset, Size:Integer): PAnsiChar;
    function GetModuleID(ModuleName:PAnsiChar): WORD;
    Function GetModuleName(ModuleID:WORD):AnsiString;
    procedure GetModuleIdsByProcName(AProcName:PAnsiChar);
    function GetItemSection(ModuleIDs:TWordDynArray; ItemName:PAnsiChar): Integer;
    function GetConstIdx(ModuleIDs:TWordDynArray; ConstName:PAnsiChar): Integer;
    function GetConstIdxs(ConstName:PAnsiChar; Var ConstIdx:Integer): Integer;
    function GetTypeIdxByModuleIds(ModuleIDs:TWordDynArray; TypeName:PAnsiChar): Integer;
    function GetTypeIdxsByName(TypeName:PAnsiChar; Var TypeIdx:Integer): Integer;
    Function GetTypeIdxByUID(UID:AnsiString):Integer;
    function GetVarIdx(ModuleIDs:TWordDynArray; VarName:PAnsiChar): Integer;
    function GetResStrIdx(from:Integer; ResStrContext:PAnsiChar): Integer; overload;
    function GetResStrIdx(ModuleID:Word; ResStrContext:PAnsiChar): Integer; overload;
    function GetResStrIdx(ModuleIDs:TWordDynArray; ResStrName:PAnsiChar): Integer; overload;
    function GetProcIdx(ModuleID:Word; ProcName:PAnsiChar): Integer; overload;
    function GetProcIdx(ModuleID:Word; ProcName,code:PAnsiChar): Integer; overload;
    function GetProcIdx(ModuleIDs:TWordDynArray; ProcName,code:PAnsiChar): Integer; overload;
    function GetProcIdxs(ModuleID:Word;FirstProcIdx, LastProcIdx:PInteger): Boolean; overload;
    Function GetProcIdxs(ModuleID:Word; var FirstProcIdx, LastProcIdx, DumpSize:Integer):Boolean; Overload;
    function GetConstInfo(AConstIdx:Integer; AFlags:Integer; var cInfo:MConstInfo): Boolean;
    function GetProcInfo(ProcName:PAnsiChar; AFlags:Integer; out pInfo:MProcInfo; Var procIdx:Integer): Boolean; overload;
    function GetProcInfo(AProcIdx:Integer; AFlags:Integer; out pInfo:MProcInfo): Boolean; overload;
    function GetTypeInfo(ATypeIdx:Integer; AFlags:Integer; out tInfo:MTypeInfo): Boolean; overload;
    function GetVarInfo(AVarIdx:Integer; AFlags:Integer; Out vInfo:MVarInfo): Boolean;
    function GetResStrInfo(AResStrIdx:Integer; AFlags:Integer; out rsInfo:MResStrInfo): Boolean;
    function ScanCode(code:PAnsiChar;CodeFlags:PIntegerArray; CodeSz:Integer; pInfo:PMProcInfo): Integer;
    function GetModuleUses(ModuleID:Word): TWordDynArray;
    function GetProcUses(ProcName:PAnsiChar; _Uses:TWordDynArray): Integer;
    function GetTypeUses(TypeName:PAnsiChar): TWordDynArray;
    function GetConstUses(ConstName:PAnsiChar): TWordDynArray;
    Function GetProcPrototype(ProcIdx:Integer):AnsiString; Overload;
    function GetProcPrototype(pInfo:PMProcInfo): AnsiString; overload;
    Function IsUsedProc(AIdx:Integer):Boolean;
    Procedure SetUsedProc(AIdx:Integer);
    function GetKBProcInfo(typeName:PAnsiChar; out procInfo:MProcInfo; Var procIdx:Integer): Boolean;
    function GetKBTypeInfo(typeName:PAnsiChar; out typeInfo:MTypeInfo): Boolean;
    function GetKBPropertyInfo(clasName:PAnsiChar; propName:AnsiString; out typeInfo:MTypeInfo): Boolean;
  private
    Inited:Boolean;
    KBfile:TFileStream;
    SectionsOffset:Int64;
    //Modules
    MaxModuleDataSize:Integer;
    //Consts
    ConstCount:Integer;
    MaxConstDataSize:Integer;
    //Types
    TypeCount:Integer;
    MaxTypeDataSize:Integer;
    //Vars
    VarCount:Integer;
    MaxVarDataSize:Integer;
    //ResStr
    ResStrCount:Integer;
    MaxResStrDataSize:Integer;
    //Procs
    MaxProcDataSize:Integer;
    ProcCount:Integer;

    //as temp test (global KB file cache in mem)
    KBCache:Pointer;
    SizeKBFile:Int64;
    NameKBFile:AnsiString;
    function BoundL(final:Integer;OfsArr:ArrOffsetInfo;Item:PAnsiChar;n:PInteger;typeFix:Boolean): Integer;
    function BoundR(start,final:Integer;OfsArr:ArrOffsetInfo;Item:PAnsiChar;n:PInteger;typeFix:Boolean): Integer;
    function GetIdxName(OfsCnt:Integer;OfsArr:ArrOffsetInfo;ItemName:PAnsiChar; Var ItemIdx:Integer;typeFix:Boolean): Integer;
    function GetIdx(OfsCnt:Integer;OfsArr:ArrOffsetInfo;ModuleIDs:TWordDynArray; ItemName:PAnsiChar;typeFix:Boolean): Integer;
    Function CheckKBFile:Boolean;
  end;

Implementation

Uses SysUtils,Heuristic,Misc,Def_main;

Destructor MKnowledgeBase.Destroy;
Begin
  Close;
end;

Function MKnowledgeBase.CheckKBFile:Boolean;
var
  isMSIL:Boolean;
  delphiVer:Integer;
  crc,kbVer:Integer;
  signature:String[24];
  description:Array[1..256] of Char;
Begin
  Result:=False;
  with KBfile do
  begin
    Read(signature[1],24);
    Read(isMSIL,1);
    Read(delphiVer,4);
    Read(crc,4);
    Read(description,256);
    Read(kbVer,4);
  end;
  Byte(signature[0]):=StrLen(PAnsiChar(@signature[1]));
  //Old format
  if (signature = 'IDD Knowledge Base File') and (kbVer = 1) then
  begin
    Version := kbVer;
    Result:=true;
  End
  //New format
  Else if (signature = 'IDR Knowledge Base File') and (kbVer = 2) then
  begin
    Version := kbVer;
    Result:=true;
  End;
end;

Function MKnowledgeBase.Open (filename:AnsiString):Boolean;
Begin
  Result:=False;
  if Inited then
  begin
    if NameKBFile = filename then
    Begin
      Result:=True;
      Exit;
    end;
    Close;
  End;
  Inited := false;
  KBfile:=Nil;
  if not FileExists(filename) then Exit;
  try
    KBfile:=TFileStream.Create(filename, fmOpenRead);
    if not CheckKBFile then
    begin
      FreeAndNil(KBfile);
      Exit;
    End;
    KBfile.Seek(-4,soFromEnd);
    //Read SectionsOffset
    KBfile.Read(SectionsOffset,SizeOf(SectionsOffset));
    //Seek at SectionsOffset
    KBfile.Seek(SectionsOffset,soFromBeginning);
    //Read section Modules
    KBfile.Read(ModuleCount,SizeOf(ModuleCount));
    SetLength(Mods,ModuleCount + 1);
    FillMemory(@Mods[0], (ModuleCount + 1)*sizeof(WORD),255);
    KBfile.Read(MaxModuleDataSize, sizeof(MaxModuleDataSize));
    SetLength(ModuleOffsets,ModuleCount);
    KBfile.Read(ModuleOffsets[0], sizeof(OffsetInfo)*ModuleCount);
    //Read section Consts
    KBfile.Read(ConstCount, sizeof(ConstCount));
    KBfile.Read(MaxConstDataSize, sizeof(MaxConstDataSize));
    SetLength(ConstOffsets,ConstCount);
    KBfile.Read(ConstOffsets[0], sizeof(OffsetInfo)*ConstCount);
    //Read section Types
    KBfile.Read(TypeCount, sizeof(TypeCount));
    KBfile.Read(MaxTypeDataSize, sizeof(MaxTypeDataSize));
    SetLength(TypeOffsets,TypeCount);
    KBfile.Read(TypeOffsets[0], sizeof(OffsetInfo)*TypeCount);
    //Read section Vars
    KBfile.Read(VarCount, sizeof(VarCount));
    KBfile.Read(MaxVarDataSize, sizeof(MaxVarDataSize));
    SetLength(VarOffsets,VarCount);
    KBfile.Read(VarOffsets[0], sizeof(OffsetInfo)*VarCount);
    //Read section ResStr
    KBfile.Read(ResStrCount, sizeof(ResStrCount));
    KBfile.Read(MaxResStrDataSize, sizeof(MaxResStrDataSize));
    SetLength(ResStrOffsets,ResStrCount);
    KBfile.Read(ResStrOffsets[0], sizeof(OffsetInfo)*ResStrCount);
    //Read section Procs
    KBfile.Read(ProcCount, sizeof(ProcCount));
    KBfile.Read(MaxProcDataSize, sizeof(MaxProcDataSize));
    SetLength(ProcOffsets,ProcCount);
    KBfile.Read(ProcOffsets[0], sizeof(OffsetInfo)*ProcCount);
    SetLength(UsedProcs,ProcCount);
    FillMemory(@UsedProcs[0], Length(UsedProcs),0);

    //as global KB file cache in RAM (speed up 3..4 times!)
    SizeKBFile := KBfile.Size;
    if SizeKBFile > 0 then
    try
      GetMem(KBCache,SizeKBFile);
      KBfile.Seek(0, soFromBeginning);
      KBfile.Read(KBCache^, SizeKBFile);
    Except
      KBCache:=Nil;
    end;
    FreeAndNil(KBfile);
  Except
    Exit;
  end;
  NameKBFile := filename;
  Inited := true;
  Result:=true;
end;

Procedure MKnowledgeBase.Close;
Begin
  if Inited then
  begin
    Mods:=Nil;
    ModuleOffsets:=Nil;
    ConstOffsets:=Nil;
    TypeOffsets:=Nil;
    VarOffsets:=Nil;
    ResStrOffsets:=Nil;
    ProcOffsets:=Nil;
    UsedProcs:=Nil;
    //as
    if Assigned(KBCache) then
    begin
      FreeMem(KBCache);
      KBCache:=Nil;
    End;
    Inited := false;
  End;
  KBfile.Free;
end;

Function MKnowledgeBase.GetModuleID (ModuleName:PAnsiChar):WORD;
Var
  ID,M, F,L:Integer;
  p:PAnsiChar;
Begin
  Result:=$FFFF;
	if not Inited then Exit;
  if (ModuleName=Nil) or (ModuleName^=#0) or (ModuleCount=0) then Exit;
  F:=0;
  L:=ModuleCount-1;
  while F < L do
  begin
    M := (F + L) Div 2;
    ID := ModuleOffsets[M].NamId;
    p := GetKBCachePtr(ModuleOffsets[ID].Offset, ModuleOffsets[ID].Size);
    if StrIComp(ModuleName, p + 4) <= 0 then L := M
      else F := M + 1;
  End;
  ID := ModuleOffsets[L].NamId;
  p := GetKBCachePtr(ModuleOffsets[ID].Offset, ModuleOffsets[ID].Size);
  if StrIComp(ModuleName, p + 4)=0 then Result:=PWord(p)^;
end;

Function MKnowledgeBase.GetModuleName (ModuleID:WORD):AnsiString;
Var
  ID,modID,M, F,L:Integer;
  p:PAnsiChar;
Begin
  Result:='';
	if not Inited then Exit;
  if (ModuleID=$FFFF) or (ModuleCount=0) then Exit;
  F:=0;
  L:=ModuleCount-1;
  while F < L do
  begin
    M := (F + L) div 2;
    ID := ModuleOffsets[M].ModId;
    p := GetKBCachePtr(ModuleOffsets[ID].Offset, ModuleOffsets[ID].Size);
    ModID := PWord(p)^;
    if ModuleID <= ModID then L := M
      else F := M + 1;
  End;
  ID := ModuleOffsets[L].ModId;
  p := GetKBCachePtr(ModuleOffsets[ID].Offset, ModuleOffsets[ID].Size);
  ModID := PWord(p)^;
  if ModuleID = ModID then Result:=String(p + 4);
end;

Function MKnowledgeBase.BoundL(final:Integer;OfsArr:ArrOffsetInfo;Item:PAnsiChar;n:PInteger;typeFix:Boolean):Integer;
var
  x,ID:Integer;
  p:PAnsiChar;
Begin
  Result:=final-1;
  //Find left boundary
  for x := final-1 downto 0 do
  begin
    Result:=x;
    ID := OfsArr[Result].NamId;
    p := GetKBCachePtr(OfsArr[ID].Offset, OfsArr[ID].Size);
    if typeFix then Inc(p,4);
    If StrIComp(Item, p + 4)<>0 then Break;
    if Assigned(n) then Inc(n);
  End;
end;

Function MKnowledgeBase.BoundR(start,final:Integer;OfsArr:ArrOffsetInfo;Item:PAnsiChar;n:PInteger;typeFix:Boolean):Integer;
var
  x,ID:Integer;
  p:PAnsiChar;
Begin
  Result:=start+1;
  //Find right boundary
  for x := start + 1 To final-1 do
  begin
    Result:=x;
    ID := OfsArr[Result].NamId;
    p := GetKBCachePtr(OfsArr[ID].Offset, OfsArr[ID].Size);
    if typeFix then Inc(p,4);
    if StrIComp(Item, p + 4)<>0 then Break;
    if Assigned(n) then Inc(n);
  end;
end;

//Return modules ids list containing given proc
Procedure MKnowledgeBase.GetModuleIdsByProcName (AProcName:PAnsiChar);
var
  L,R,M,LN,RN:Integer;
  ID,res,n,k:Integer;
  p:PAnsiChar;
Begin
  Mods[0] := $FFFF;
  if Not Inited then Exit;
  if (AProcName=Nil)or(AProcName^=#0) or (ProcCount=0) then Exit;
  L := 0;
  R := ProcCount - 1;
  while True do
  begin
    M := (L + R) div 2;
    ID := ProcOffsets[M].NamId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    res := StrIComp(AProcName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      LN:=BoundL(M,ProcOffsets,AProcName,Nil,false);
      RN:=BoundR(M,ProcCount,ProcOffsets,AProcName,Nil,false);
      n := 0;
      for k:= LN + 1 to RN-1 do
      begin
        ID := ProcOffsets[N].NamId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        Mods[n] := PWord(p)^;
        Inc(n);
      end;
      Mods[n] := $FFFF;
      Break;
    End;
    if L > R then Break;
  End;
end;

Function MKnowledgeBase.GetIdx(OfsCnt:Integer;OfsArr:ArrOffsetInfo;ModuleIDs:TWordDynArray; ItemName:PAnsiChar;typeFix:Boolean):Integer;
var
  ModuleID, ModID:Word;
  ID,n, L, R,M,LN,RN,k,res:Integer;
  p:PAnsiChar;
Begin
  REsult:=-1;
  L:=0;
  R:=OfsCnt-1;
  while True do
  begin
    M := (L + R) div 2;
    ID := OfsArr[M].NamId;
    p := GetKBCachePtr(OfsArr[ID].Offset, OfsArr[ID].Size);
    if typeFix then Inc(p,4);
    res := stricomp(ItemName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      LN:=BoundL(M,OfsArr,ItemName,Nil,typeFix);
      RN:=BoundR(M,OfsCnt,OfsArr,ItemName,Nil,typeFix);
      for N := LN + 1 To RN-1 do
      begin
        ID := OfsArr[N].NamId;
        p := GetKBCachePtr(OfsArr[ID].Offset, OfsArr[ID].Size);
        if typeFix then Inc(p,4);
        ModID := PWord(p)^;
        for k:=Low(ModuleIDs) to High(ModuleIDs) do
        begin
          ModuleID := ModuleIDs[k];
          if ModuleID = $FFFF then break;
          if ModuleID = ModID then
          Begin
            Result:=N;
            Exit;
          end;
        End;
      End;
      //Nothing found - exit
      Exit;
    End;
    if L > R then Break;
  End;
end;

Function MKnowledgeBase.GetIdxName(OfsCnt:Integer;OfsArr:ArrOffsetInfo;ItemName:PAnsiChar; Var ItemIdx:Integer;typeFix:Boolean):Integer;
var
  ID, L, R,M,res,Num:Integer;
  p:PAnsiChar;
Begin
  Result:=0;
  L := 0;
  R := ConstCount - 1;
  while true do
  begin
    M := (L + R) div 2;
    ID := OfsArr[M].NamId;
    p := GetKBCachePtr(OfsArr[ID].Offset, OfsArr[ID].Size);
    if typeFix then Inc(p,4);
    res := stricomp(ItemName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      Num := 1;
      ItemIdx := M;
      BoundL(M,OfsArr,ItemName,@Num,typeFix);
      BoundR(M,OfsCnt,OfsArr,ItemName,@Num,typeFix);
      Result:=Num;
      Exit;
    End;
    if L > R then Break;
  End;
end;

//Return sections containing given ItemName
Function MKnowledgeBase.GetItemSection (ModuleIDs:TWordDynArray; ItemName:PAnsiChar):Integer;
Begin
  Result := KB_NO_SECTION;
  if not Inited Or (ItemName=Nil)or(ItemName^=#0) then Exit;
  if GetIdx(ConstCount,ConstOffsets,ModuleIDs,ItemName,False)<>-1 then Result:=Result or KB_CONST_SECTION;
  if GetIdx(TypeCount,TypeOffsets,ModuleIDs,ItemName,True)<>-1 then Result:=Result or KB_TYPE_SECTION;
  If GetIdx(VarCount,VarOffsets,ModuleIDs,ItemName,False)<>-1 then Result:=Result or KB_VAR_SECTION;
  if GetIdx(ResStrCount,ResStrOffsets,ModuleIDs,ItemName,False)<>-1 then Result:=Result or KB_RESSTR_SECTION;
  if GetIdx(ProcCount,ProcOffsets,ModuleIDs,ItemName,False)<>-1 Then Result:=Result or KB_PROC_SECTION;
end;

//Return constant index by name in given ModuleID
Function MKnowledgeBase.GetConstIdx (ModuleIDs:TWordDynArray; ConstName:PAnsiChar):Integer;
Begin
	if not Inited or (ModuleIDs=Nil) or (ConstName=Nil)
    or (ConstName^=#0) or (ConstCount=0) then Result:=-1
  Else Result:=GetIdx(ConstCount,ConstOffsets,ModuleIDs,ConstName,False);
end;

Function MKnowledgeBase.GetConstIdxs (ConstName:PAnsiChar; Var ConstIdx:Integer):Integer;
Begin
  ConstIdx := -1;
  if not Inited or (ConstName=Nil) Or (ConstName^=#0) or (ConstCount=0) then Result:=0
    else Result:=GetIdxName(ConstCount,ConstOffsets,ConstName,ConstIdx,False);
end;

Function MKnowledgeBase.GetTypeIdxByModuleIds (ModuleIDs:TWordDynArray; TypeName:PAnsiChar):Integer;
Begin
	if not Inited or (ModuleIDs=Nil) or (TypeName=Nil)
    or (TypeName^=#0) or (TypeCount=0) then Result:=-1
  Else Result:=GetIdx(TypeCount,TypeOffsets,ModuleIDs,TypeName,True);
end;

Function MKnowledgeBase.GetTypeIdxsByName (TypeName:PAnsiChar; Var TypeIdx:Integer):Integer;
Begin
  TypeIdx := -1;
  if not Inited or (TypeName=Nil) Or (TypeName^=#0) or (TypeCount=0) then Result:=0
    else Result:=GetIdxName(TypeCount,TypeOffsets,TypeName,TypeIdx,True);
end;

Function MKnowledgeBase.GetTypeIdxByUID (UID:AnsiString):Integer;
Begin
  // empty function
  Result:=0;
end;

Function MKnowledgeBase.GetVarIdx (ModuleIDs:TWordDynArray; VarName:PAnsiChar):Integer;
Begin
	if not Inited or (ModuleIDs=Nil) or (VarName=Nil)
    or (VarName^=#0) or (VarCount=0) then Result:=-1
  Else Result:=GetIdx(VarCount,VarOffsets,ModuleIDs,VarName,False);
end;

Function MKnowledgeBase.GetResStrIdx (from:Integer; ResStrContext:PAnsiChar):Integer;
var
  n,ID:Integer;
  p:PAnsiChar;
  len:Word;
Begin
  Result:=-1;
	if not Inited or (ResStrContext=Nil) or (ResStrContext^=#0) or (ResStrCount=0) then Exit;
  for n := from To ResStrCount-1 do
  begin
    ID := ResStrOffsets[n].NamId;
    p := GetKBCachePtr(ResStrOffsets[ID].Offset, ResStrOffsets[ID].Size);
    //ModuleID
    Inc(p, 2);
    //ResStrName
    len := PWord(p)^;
    Inc(p, len + 3);
    //TypeDef
    len := PWord(p)^;
    Inc(p, len + 5);
    //Context
    if stricomp(ResStrContext, p)=0 then
    begin
      Result:=n;
      Exit;
    end;
  End;
end;

Function MKnowledgeBase.GetResStrIdx(ModuleID:Word; ResStrContext:PAnsiChar):Integer;
var
  n,ID:Integer;
  p:PAnsiChar;
  modID,len:Word;
Begin
  Result:=-1;
	if not Inited or (ResStrContext=Nil) or (ResStrContext^=#0) or (ResStrCount=0) then Exit;
  for n := 0 To ResStrCount-1 do
  begin
    ID := ResStrOffsets[n].NamId;
    p := GetKBCachePtr(ResStrOffsets[ID].Offset, ResStrOffsets[ID].Size);
    //ModuleID
    ModID := PWord(p)^;
    Inc(p, 2);
    //ResStrName
    len := PWord(p)^;
    Inc(p, len + 3);
    //TypeDef
    len := PWord(p)^;
    Inc(p,len + 5);
    //Context
    if (ModuleID = ModID) and (stricomp(ResStrContext, p)=0) then
    begin
      REsult:=n;
      Exit;
    end;
  end;
end;

Function MKnowledgeBase.GetResStrIdx(ModuleIDs:TWordDynArray; ResStrName:PAnsiChar):Integer;
Begin
	if not Inited or (ModuleIDs=Nil) or (ResStrName=Nil)
    or (ResStrName^=#0) or (ResStrCount=0) then Result:=-1
  Else Result:=GetIdx(ResStrCount,ResStrOffsets,ModuleIDs,ResStrName,False);
end;

//Return proc index by name in given ModuleID
Function MKnowledgeBase.GetProcIdx (ModuleID:Word; ProcName:PAnsiChar):Integer;
var
  ID,n, L, R,M,LN,RN,res:Integer;
  p:PAnsiChar;
Begin
  Result:=-1;
	if not Inited or (ModuleID=$FFFF) or (ProcName=Nil)
    or (ProcName^=#0) or (ProcCount=0) then Exit;
  L := 0;
  R := ProcCount - 1;
  while true do
  begin
    M := (L + R) div 2;
    ID := ProcOffsets[M].NamId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    res := stricomp(ProcName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      LN:=BoundL(M,ProcOffsets,ProcName,Nil,false);
      RN:=BoundR(M,ProcCount,ProcOffsets,ProcName,Nil,false);
      for N := LN + 1 To RN-1 do
      begin
        ID := ProcOffsets[N].NamId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        if ModuleID = PWord(p)^ then
        Begin
          Result:=n;
          Exit;
        end;
      end;
      //Nothing found - exit
      Exit;
    end;
    if L > R then Break;
  end;
end;

//Return proc index by name in given ModuleID
//Code used for selection required proc (if there are exist several procs with the same name)
Function MKnowledgeBase.GetProcIdx(ModuleID:Word; ProcName,code:PAnsiChar):Integer;
var
  ID,n, L, R,M,LN,RN,res:Integer;
  p:PAnsiChar;
  aInfo:MProcInfo;
  modID:Word;
Begin
  Result:=-1;
	if not Inited or (ModuleID=$FFFF) or (ProcName=Nil)
    or (ProcName^=#0) or (ProcCount=0) then Exit;
  L := 0;
  R := ProcCount - 1;
  while true do
  begin
    M := (L + R) div 2;
    ID := ProcOffsets[M].NamId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    res := stricomp(ProcName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      LN:=BoundL(M,ProcOffsets,ProcName,Nil,false);
      RN:=BoundR(M,ProcCount,ProcOffsets,ProcName,Nil,false);
      for N := LN + 1 to RN-1 do
      begin
        GetProcInfo(ProcOffsets[N].NamId, INFO_DUMP, aInfo);
        ModID := aInfo.ModuleID;
        if MatchCode(code, @aInfo) And (ModuleID = ModID) Then
        Begin
          Result:=N;
          Exit;
        End;
      End;
      //Nothing found - exit
      Exit;
    end;
    if L > R then Break;
  End;
end;

//Return proc index by name in given array of ModuleID
Function MKnowledgeBase.GetProcIdx(ModuleIDs:TWordDynArray; ProcName,code:PAnsiChar):Integer;
var
  n,L,R,M,LN,RN,k,res:Integer;
  ID:Integer;
  p:PAnsiChar;
  aInfo:MProcInfo;
  ModuleID, ModID:Word;
Begin
  Result:=-1;
	if not Inited or (ModuleIDs=Nil) or (ProcName=Nil)
    or (ProcName^=#0) or (ProcCount=0) then Exit;
  L := 0;
  R := ProcCount - 1;
  while true do
  begin
    M := (L + R) div 2;
    ID := ProcOffsets[M].NamId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    res := stricomp(ProcName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      LN:=BoundL(M,ProcOffsets,ProcName,Nil,false);
      RN:=BoundR(M,ProcCount,ProcOffsets,ProcName,Nil,false);
      for N := LN + 1 to RN-1 do
      begin
        GetProcInfo(ProcOffsets[N].NamId, INFO_DUMP, aInfo);
        ModID := aInfo.ModuleID;
        if Assigned(code) then
        begin
          if MatchCode(code, @aInfo) then
            for k := Low(ModuleIDs) to High(ModuleIDs) do
            begin
              ModuleID := ModuleIDs[k];
              if ModuleID = $FFFF then break;
              if ModuleID = ModID Then
              Begin
                Result:=N;
                Exit;
              End;
            End;
        end
        else for k := Low(ModuleIDs) to High(ModuleIDs) do
        begin
          ModuleID := ModuleIDs[k];
          if ModuleID = $FFFF then break;
          if ModuleID = ModID Then
          Begin
            Result:=N;
            Exit;
          End;
        End;
      End;
      //Nothing found - exit
      Exit;
    end;
    if L > R Then Break;
  End;
end;

//Seek first ans last proc ID in given module
Function MKnowledgeBase.GetProcIdxs (ModuleID:Word;FirstProcIdx, LastProcIdx:PInteger):Boolean;
var
  ID,L,R,M,LN,RN:Integer;
  p:PAnsiChar;
  modID:Word;
Begin
  Result:=False;
	if not Inited or (ModuleID = $FFFF) or (ProcCount=0) or
    (FirstProcIdx=Nil) or (LastProcIdx=Nil) then Exit;
  FirstProcIdx^ := -1;
  LastProcIdx^ := -1;
  L := 0;
  R := ProcCount - 1;
  while true do
  begin
    M := (L + R) div 2;
    ID := ProcOffsets[M].ModId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    ModID := PWord(p)^;
    if ModuleID < ModID then R := M - 1
    else if ModuleID > ModID then L := M + 1
    else
    begin
      FirstProcIdx^ := M;
      LastProcIdx^ := M;
      //Find left boundary
      for LN := M - 1 downto 0 do
      begin
        ID := ProcOffsets[LN].ModId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        ModID := PWord(p)^;
        if ModID <> ModuleID then break;
        FirstProcIdx^ := LN;
      end;
      //Find right boundary
      for RN := M + 1 to ProcCount-1 do
      begin
        ID := ProcOffsets[RN].ModId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        ModID := PWord(p)^;
        if ModID <> ModuleID then break;
        LastProcIdx^ := RN;
      End;
      Result:=true;
      Exit;
    End;
    if L > R then Break;
  end;
end;

Function MKnowledgeBase.GetProcIdxs(ModuleID:Word; var FirstProcIdx, LastProcIdx, DumpSize:Integer):Boolean;
var
  ID,L,R,M,LN,RN,k:Integer;
  modID,len:Word;
  p:PAnsiChar;
Begin
  Result:=False;
	if not Inited or (ModuleID = $FFFF) or (ProcCount=0) then Exit;
  FirstProcIdx := -1;
  LastProcIdx := -1;
  DumpSize := 0;
  L := 0;
  R := ProcCount - 1;
  while true do
  begin
    M := (L + R) Div 2;
    ID := ProcOffsets[M].ModId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    ModID := PWord(p)^;
    if ModuleID < ModID then R := M - 1
    else if ModuleID > ModID then L := M + 1
    else
    begin
      FirstProcIdx := M;
      LastProcIdx := M;
      //Find left boundary
      for LN := M - 1 Downto 0 do
      begin
        ID := ProcOffsets[LN].ModId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        ModID := PWord(p)^;
        if ModID <> ModuleID then break;
        FirstProcIdx := LN;
      End;
      //Find right boundary
      for RN := M + 1 to ProcCount-1 do
      begin
        ID := ProcOffsets[RN].ModId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        ModID := PWord(p)^;
        if ModID <> ModuleID then break;
        LastProcIdx := RN;
      End;
      for k := FirstProcIdx to LastProcIdx do
      begin
        p := GetKBCachePtr(ProcOffsets[k].Offset, ProcOffsets[k].Size);
        //ModuleID
        Inc(p, 2);
        //ProcName
        Len := PWord(p)^;
        Inc(p, Len + 3);
        //Embedded
        Inc(p);
        //DumpType
        Inc(p);
        //MethodKind
        Inc(p);
        //CallKind
        Inc(p);
        //VProc
        Inc(p, 4);
        //TypeDef
        Len := PWord(p)^;
        Inc(p, Len + 3);
        //DumpTotal
        Inc(p, 4);
        //DumpSz
        Inc(DumpSize, (PInteger(p)^ + 3) and (-4));
      End;
      Result:=true;
      Exit;
    End;
    if L > R then Break;
  end;
end;

//ConstIdx was given by const name
Function MKnowledgeBase.GetConstInfo (AConstIdx:Integer; AFlags:Integer; var cInfo:MConstInfo):Boolean;
var
  //DumpTotal:Integer;
  p:PAnsiChar;
  len:Word;
Begin
  Result:=False;
	if not Inited or (AConstIdx = -1) then Exit;
  p := GetKBCachePtr(ConstOffsets[AConstIdx].Offset, ConstOffsets[AConstIdx].Size);
  cInfo.ModuleID := PWord(p)^;
  Inc(p, 2);
  Len := PWord(p)^;
  Inc(p, 2);
  cInfo.ConstName := String(p);
  Inc(p, Len + 1);
  cInfo._Type := Byte(p^);
  Inc(p);
  Len := PWord(p)^;
  Inc(p, 2);
  cInfo.TypeDef := String(p);
  Inc(p, Len + 1);
  Len := PWord(p)^;
  Inc(p, 2);
  cInfo.Value := String(p);
  Inc(p, Len + 1);
  //DumpTotal := PInteger(p)^;
  Inc(p, 4);
  cInfo.DumpSz := PInteger(p)^;
  Inc(p,4);
  cInfo.FixupNum := PInteger(p)^;
  Inc(p, 4);
  cInfo.Dump := Nil;
  if (AFlags and INFO_DUMP)<>0 then
    if cInfo.DumpSz<>0 then cInfo.Dump := p;
  Result:=True;
end;

Function MKnowledgeBase.GetProcInfo (ProcName:PAnsiChar; AFlags:Integer; out pInfo:MProcInfo; Var procIdx:Integer):Boolean;
var
  ID,L,R,M,LN,RN,res:Integer;
  DumpTotal,ArgsTotal:Integer;
  p,p1:PAnsiChar;
  Len:Word;
Begin
  Result:=false;
	if not Inited or (ProcName=Nil) or (ProcName^=#0) or (ProcCount=0) then Exit;
  L := 0;
  R := ProcCount - 1;
  while true do
  begin
    M := (L + R) div 2;
    ID := ProcOffsets[M].NamId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    res := stricomp(ProcName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      LN:=BoundL(M,ProcOffsets,ProcName,Nil,false);
      RN:=BoundR(M,ProcCount,ProcOffsets,ProcName,Nil,false);
      if RN - LN - 1 = 1 then
      begin
        procIdx := ProcOffsets[M].NamId;
        p := GetKBCachePtr(ProcOffsets[procIdx].Offset, ProcOffsets[procIdx].Size);
        pInfo.ModuleID := PWord(p)^;
        Inc(p, 2);
        Len := PWord(p)^;
        Inc(p, 2);
        pInfo.ProcName := String(p);
        Inc(p, Len + 1);
        pInfo.Embedded := p^ <> #0;
        Inc(p);
        pInfo.DumpType := p^;
        Inc(p);
        pInfo.MethodKind := p^;
        Inc(p);
        pInfo.CallKind := Byte(p^);
        Inc(p);
        pInfo.VProc := PInteger(p)^;
        Inc(p, 4);
        Len := PWord(p)^;
        Inc(p, 2);
        pInfo.TypeDef := TrimTypeName(String(p));
        Inc(p,Len + 1);
        DumpTotal := PInteger(p)^;
        Inc(p, 4);
        p1 := p;
        pInfo.DumpSz := PInteger(p)^;
        Inc(p, 4);
        pInfo.FixupNum := PInteger(p)^;
        Inc(p, 4);
        pInfo.Dump := Nil;
        if (AFlags and INFO_DUMP)<>0 then
          if pInfo.DumpSz<>0 then pInfo.Dump := p;
        p := p1 + DumpTotal;
        ArgsTotal := PInteger(p)^;
        Inc(p, 4);
        p1 := p;
        pInfo.ArgsNum := PWord(p)^;
        Inc(p, 2);
        pInfo.Args := Nil;
        if (AFlags and INFO_ARGS)<>0 then
          if pInfo.ArgsNum<>0 then pInfo.Args := p;
        p := p1 + ArgsTotal;
        (*
        LocalsTotal := PInteger(p)^;
        Inc(p, 4);
        pInfo.LocalsNum := PWord(p)^;
        Inc(p, 2);
        pInfo.Locals := 0;
        if (AFlags and INFO_LOCALS)<>0 then
          if (pInfo.LocalsNum) pInfo.Locals := p;
        *)
        Result:=True;
        Exit;
      End;
      //More than 2 items found
      (*
      for nnn := LN + 1 to RN - 1 do
      begin
        ID := ProcOffsets[nnn].NamId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        pInfo.ModuleID := PWord(p)^;
        Inc(p, 2);
        Len := PWord(p)^;
        Inc(p, 2);
        pInfo.ProcName := String(p);
        Inc(p, Len + 1);
        pInfo.Embedded := p^ <> #0;
        Inc(p);
        pInfo.DumpType := p^;
        Inc(p);
        pInfo.MethodKind := p^;
        Inc(p);
        pInfo.CallKind := Byte(p^);
        Inc(p);
        pInfo.VProc := PInteger(p)^;
        Inc(p, 4);
        Len := PWord(p)^;
        Inc(p, 2);
        pInfo.TypeDef := TrimTypeName(String(p));
        Inc(p, Len + 1);
        DumpTotal := PInteger(p)^;
        Inc(p, 4);
        p1 := p;
        pInfo.DumpSz := PInteger(p)^;
        Inc(p,4);
        pInfo.FixupNum := PInteger(p)^;
        Inc(p, 4);
        pInfo.Dump := Nil;
        if (AFlags and INFO_DUMP)<>0 then
          if pInfo.DumpSz<>0 then pInfo.Dump := p;
        p := p1 + DumpTotal;
        ArgsTotal := PInteger(p)^;
        Inc(p,4);
        p1 := p;
        pInfo.ArgsNum := PWord(p)^;
        Inc(p, 2);
        pInfo.Args := Nil;
        if (AFlags and INFO_ARGS)<>0 then
          if pInfo.ArgsNum<>0 then pInfo.Args := p;
      end;
      *)
      Exit;
    end;
    if L > R then Break;
  End;
end;

Function MKnowledgeBase.GetProcInfo(AProcIdx:Integer; AFlags:Integer; out pInfo:MProcInfo):Boolean;
Var
  p,p1:PAnsiChar;
  DumpTotal,ArgsTotal:Integer;
  len:Word;
Begin
  Result:=False;
	if not Inited or (AProcIdx = -1) then Exit;
  p := GetKBCachePtr(ProcOffsets[AProcIdx].Offset, ProcOffsets[AProcIdx].Size);
  pInfo.ModuleID := PWord(p)^;
  Inc(p, 2);
  Len := PWord(p)^;
  Inc(p, 2);
  pInfo.ProcName := String(p);
  Inc(p, Len + 1);
  pInfo.Embedded := p^ <> #0;
  Inc(p);
  pInfo.DumpType := p^;
  Inc(p);
  pInfo.MethodKind := p^;
  Inc(p);
  pInfo.CallKind := Byte(p^);
  Inc(p);
  pInfo.VProc := PInteger(p)^;
  Inc(p, 4);
  Len := PWord(p)^;
  Inc(p, 2);
  pInfo.TypeDef := TrimTypeName(String(p));
  Inc(p, Len + 1);

  DumpTotal := PInteger(p)^;
  Inc(p, 4);
  p1 := p;
  pInfo.DumpSz := PInteger(p)^;
  Inc(p, 4);
  pInfo.FixupNum := PInteger(p)^;
  Inc(p, 4);
  pInfo.Dump := Nil;
  if (AFlags and INFO_DUMP)<>0 then
    if pInfo.DumpSz<>0 then pInfo.Dump := p;
  p := p1 + DumpTotal;

  ArgsTotal := PInteger(p)^;
  Inc(p, 4);
  p1 := p;
  pInfo.ArgsNum := PWord(p)^;
  Inc(p, 2);
  pInfo.Args := Nil;
  if (AFlags and INFO_ARGS)<>0 then
    if pInfo.ArgsNum<>0 then pInfo.Args := p;
  p := p1 + ArgsTotal;
  (*
  LocalsTotal := PInteger(p)^;
  Inc(p, 4);
  pInfo.LocalsNum := PWord(p)^;
  Inc(p,2);
  pInfo.Locals := 0;
  if (AFlags and INFO_LOCALS)<>0 then
    if pInfo.LocalsNum<>0 then pInfo.Locals := p;
  *)
  Result:=true;
end;

Function MKnowledgeBase.GetTypeInfo(ATypeIdx:Integer; AFlags:Integer; out tInfo:MTypeInfo):Boolean;
Var
  p,p1:PAnsiChar;
  DumpTotal,FieldsTotal,PropsTotal,MethodsTotal:Integer;
  len:Word;
Begin
  Result:=False;
	if not Inited Or (ATypeIdx = -1) then Exit;
  p := GetKBCachePtr(TypeOffsets[ATypeIdx].Offset, TypeOffsets[ATypeIdx].Size);
  tInfo.Size := PInteger(p)^;
  Inc(p, 4);
  tInfo.ModuleID := PWord(p)^;
  Inc(p, 2);
  Len := PWord(p)^;
  Inc(p, 2);
  tInfo.TypeName := String(p);
  Inc(p, Len + 1);
  tInfo.Kind := Byte(p^);
  Inc(p);
  tInfo.VMCnt := PWord(p)^;
  Inc(p, 2);
  Len := PWord(p)^;
  Inc(p, 2);
  tInfo.Decl := String(p);
  Inc(p, Len + 1);

  DumpTotal := PInteger(p)^;
  Inc(p, 4);
  p1 := p;
  tInfo.DumpSz := PInteger(p)^;
  Inc(p, 4);
  tInfo.FixupNum := PInteger(p)^;
  Inc(p, 4);
  tInfo.Dump := Nil;
  if (AFlags and INFO_DUMP)<>0 then
    if tInfo.DumpSz<>0 then tInfo.Dump := p;
  p := p1 + DumpTotal;

  FieldsTotal := PInteger(p)^;
  Inc(p, 4);
  p1 := p;
  tInfo.FieldsNum := PWord(p)^;
  Inc(p, 2);
  tInfo.Fields := Nil;
  if (AFlags and INFO_FIELDS)<>0 then
    if tInfo.FieldsNum<>0 then tInfo.Fields := p;
  p := p1 + FieldsTotal;

  PropsTotal := PInteger(p)^;
  Inc(p, 4);
  p1 := p;
  tInfo.PropsNum := PWord(p)^;
  Inc(p, 2);
  tInfo.Props := Nil;
  if (AFlags and INFO_PROPS)<>0 then
    if tInfo.PropsNum<>0 then tInfo.Props := p;
  p := p1 + PropsTotal;

  MethodsTotal := PInteger(p)^;
  Inc(p, 4);
  tInfo.MethodsNum := PWord(p)^;
  Inc(p, 2);
  tInfo.Methods := Nil;
  if (AFlags and INFO_METHODS)<>0 then
    if tInfo.MethodsNum<>0 then tInfo.Methods := p;
  Result:=True;
end;

Function MKnowledgeBase.GetVarInfo (AVarIdx:Integer; AFlags:Integer; Out vInfo:MVarInfo):Boolean;
var
  p:PAnsiChar;
  len:Word;
Begin
  Result:=False;
	if not Inited or (AVarIdx = -1) then Exit;
  p := GetKBCachePtr(VarOffsets[AVarIdx].Offset, VarOffsets[AVarIdx].Size);
  vInfo.ModuleID := PWord(p)^;
  Inc(p, 2);
  Len := PWord(p)^;
  Inc(p,2);
  vInfo.VarName := String(p);
  Inc(p, Len + 1);
  vInfo._Type := Byte(p^);
  Inc(p);
  Len := PWord(p)^;
  Inc(p, 2);
  vInfo.TypeDef := String(p);
  Inc(p, Len + 1);
  if (AFlags and INFO_ABSNAME)<>0 then
  begin
    //Len := PWord(p)^;
    Inc(p, 2);
    vInfo.AbsName := String(p);
  end;
  Result:=True;
end;

Function MKnowledgeBase.GetResStrInfo (AResStrIdx:Integer; AFlags:Integer; out rsInfo:MResStrInfo):Boolean;
var
  p:PAnsiChar;
  len:Word;
Begin
  Result:=false;
	if not Inited or (AResStrIdx = -1) then Exit;
  p := GetKBCachePtr(ResStrOffsets[AResStrIdx].Offset, ResStrOffsets[AResStrIdx].Size);
  rsInfo.ModuleID := PWord(p)^;
  Inc(p, 2);
  Len := PWord(p)^;
  Inc(p, 2);
  rsInfo.ResStrName := String(p);
  Inc(p, Len + 1);
  Len := PWord(p)^;
  Inc(p, 2);
  rsInfo.TypeDef := String(p);
  Inc(p, Len + 1);
  if (AFlags and INFO_DUMP)<>0 then
  begin
    //Len := PWord(p)^;
    //Inc(p, 2);
    //rsInfo.AContext := String(p);
  End;
  REsult:=true;
end;

Function MKnowledgeBase.ScanCode (code:PAnsiChar;CodeFlags:PIntegerArray; CodeSz:Integer; pInfo:PMProcInfo):Integer;
var
  DumpSz:Integer;
  Dump,Reloc:PAnsiChar;
  i,n,k:Integer;
  found:Boolean;
Begin
  Result:=-1;
	if not Inited or (pInfo=Nil) Then Exit;
  DumpSz := pInfo.DumpSz;
  if (DumpSz=0) or (DumpSz >= CodeSz) then Exit;
  Dump := pInfo.Dump;
  Reloc := Dump + DumpSz;

  //Skip relocs in dump begin
  for n := 0 to DumpSz-1 do
    if Reloc[n] <> #255 then break;
  for i := n to CodeSz - DumpSz + n-1 do
    if (code[i] = Dump[n]) and ((CodeFlags[i] and cfCode) = 0) and ((CodeFlags[i] and cfData) = 0) then
    begin
      found := true;
      for k := n to DumpSz-1 do
      begin
        if ((CodeFlags[i - n + k] and cfCode) <> 0) or ((CodeFlags[i - n + k] and cfData) <> 0) then
        begin
          found := false;
          break;
        End;
        if (code[i - n + k] <> Dump[k]) and (Reloc[k] <> #255) then
        begin
          found := false;
          break;
        End;
      end;
      if found then
      begin
        //If "tail" matched (from position i - n), check "head"
        found := true;
        for k := 0 to n-1 do
          if ((CodeFlags[i - n + k] and cfCode) <> 0) or ((CodeFlags[i - n + k] and cfData) <> 0) then
          begin
            found := false;
            break;
          end;
        if found Then
        begin
          Result:=i - n;
          Exit;
        end;
      end;
    End;
end;

Function MKnowledgeBase.GetModuleUses (ModuleID:Word):TWordDynArray;
var
  p:PAnsiChar;
  m,n:Integer;
  len,usesNum,ID:Word;
Begin
  Result:=Nil;
	if not Inited or (ModuleID = $FFFF) then Exit;
  p := GetKBCachePtr(ModuleOffsets[ModuleID].Offset, ModuleOffsets[ModuleID].Size);

  //ID
  Inc(p, 2);
  //Name
  len := PWord(p)^;
  Inc(p, len + 3);
  //Filename
  len := PWord(p)^;
  Inc(p, len + 3);
  //UsesNum
  UsesNum := PWord(p)^;
  SetLength(Result,UsesNum + 2);
  Result[0] := ModuleID;
  m := 1;
  if UsesNum<>0 then
  begin
    Inc(p, 2);
    for n := 0 to UsesNum-1 do
    begin
      ID := PWord(p)^;
      Inc(p, 2);
      if ID <> $FFFF then
      begin
        Result[m] := ID;
        Inc(m);
      End;
    end;
  End;
  Result[m] := $FFFF;
end;

Function MKnowledgeBase.GetProcUses (ProcName:PAnsiChar; _Uses:TWordDynArray):Integer;
Var
  num:Integer;
  N,L,M,R,ID,res:Integer;
  p:PAnsiChar;
  modID:Word;
Begin
  Result:=0;
	if not Inited then Exit;
  num:=0;
  L := 0;
  R := ProcCount - 1;
  while true do
  begin
    M := (L + R) Div 2;
    ID := ProcOffsets[M].NamId;
    p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
    res := stricomp(ProcName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 Then L := M + 1
    else
    begin
      ModID := PWord(p)^;
      if ModID <> $FFFF then
      begin
        _uses[num] := ModID;
        Inc(num);
      end;
      //Take ModuleIDs in same name block (firstly from right to left)
      for N := M - 1 Downto 0 do
      begin
        ID := ProcOffsets[N].NamId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        if stricomp(ProcName, p + 4)<>0 then Break;
        ModID := PWord(p)^;
        if (ModID <> $FFFF) and (_uses[num - 1] <> ModID) then
        begin
          _uses[num] := ModID;
          Inc(num);
          assert(num < ModuleCount);
        End;
      end;
      //From ltft to right
      for N := M + 1 to ProcCount-1 do
      begin
        ID := ProcOffsets[N].NamId;
        p := GetKBCachePtr(ProcOffsets[ID].Offset, ProcOffsets[ID].Size);
        if stricomp(ProcName, p + 4)<>0 then Break;
        ModID := PWord(p)^;
        if (ModID <> $FFFF) and (_uses[num - 1] <> ModID) then
        begin
          _uses[num] := ModID;
          Inc(num);
          assert(num < ModuleCount);
        End;
      end;
      Result:=num;
      Exit;
    end;
    if L > R then Break;
  end;
end;

Function MKnowledgeBase.GetTypeUses (TypeName:PAnsiChar):TWordDynArray;
var
  num,L,R,M,N,ID,res:Integer;
  p:PAnsiChar;
  modID:Word;
Begin
  Result:=Nil;
	if Not Inited then Exit;
  num:=0;
  L := 0;
  R := TypeCount - 1;
  while true do
  begin
    M := (L + R) div 2;
    ID := TypeOffsets[M].NamId;
    p := GetKBCachePtr(TypeOffsets[ID].Offset, TypeOffsets[ID].Size) + 4;
    res := stricomp(TypeName, p + 4);
    if res < 0 then R := M - 1
    else if res > 0 then L := M + 1
    else
    begin
      SetLength(Result,ModuleCount + 1);
      ModID := PWord(p)^;
      if ModID <> $FFFF then
      begin
        Result[num] := ModID;
        Inc(num);
      End;
      //Take ModuleIDs in same name block (firstly from right to left)
      for N := M - 1 downto 0 do
      begin
        ID := TypeOffsets[N].NamId;
        p := GetKBCachePtr(TypeOffsets[ID].Offset, TypeOffsets[ID].Size) + 4;
        if stricomp(TypeName, p + 4)<>0 Then Break;
        ModID := PWord(p)^;
        if (ModID <> $FFFF) and (Result[num - 1] <> ModID) then
        begin
          Result[num] := ModID;
          Inc(num);
          assert(num < ModuleCount);
        end;
      end;
      //From left to right
      for N := M + 1 to TypeCount-1 do
      begin
        ID := TypeOffsets[N].NamId;
        p := GetKBCachePtr(TypeOffsets[ID].Offset, TypeOffsets[ID].Size) + 4;
        if stricomp(TypeName, p + 4)<>0 then Break;
        ModID := PWord(p)^;
        if (ModID <> $FFFF) and (Result[num - 1] <> ModID) then
        begin
          Result[num] := ModID;
          Inc(num);
          assert(num < ModuleCount);
        end;
      end;
      //After last element must be word 0xFFFF
      Result[num] := $FFFF;
      Exit;
    end;
    if L > R then Break;
  end;
end;

Function MKnowledgeBase.GetConstUses (ConstName:PAnsiChar):TWordDynArray;
var
  ID,num,F,L,M,N:Integer;
  p:PAnsiChar;
  modID:Word;
Begin
  Result:=Nil;
	if not Inited then Exit;
  F := 0;
  L := ConstCount - 1;
  while F < L do
  begin
    M := (F + L) div 2;
    ID := ConstOffsets[M].NamId;
    p := GetKBCachePtr(ConstOffsets[ID].Offset, ConstOffsets[ID].Size);
    if stricomp(ConstName, p + 4) <= 0 then L := M
      else F := M + 1;
  end;
  ID := ConstOffsets[L].NamId;
  p := GetKBCachePtr(ConstOffsets[ID].Offset, ConstOffsets[ID].Size);
  if stricomp(ConstName, p + 4)=0 then
  begin
    SetLength(Result,ModuleCount + 1);
    num := 0;
    ModID := PWord(p)^;
    if ModID <> $FFFF then
    begin
      Result[num] := ModID;
      Inc(num);
    End;
    //Take ModuleIDs in same name block (firstly from right to left)
    for N := L - 1 downto 0 do
    begin
      ID := ConstOffsets[N].NamId;
      p := GetKBCachePtr(ConstOffsets[ID].Offset, ConstOffsets[ID].Size);
      if stricomp(ConstName, p + 4)<>0 then break;
      ModID := PWord(p)^;
      if (ModID <> $FFFF) and (Result[num - 1] <> ModID) then
      begin
        Result[num] := ModID;
        Inc(num);
        assert(num < ModuleCount);
      End;
    end;
    //From left to right
    for N := L + 1 to ConstCount-1 do
    begin
      ID := ConstOffsets[N].NamId;
      p := GetKBCachePtr(ConstOffsets[ID].Offset, ConstOffsets[ID].Size);
      if stricomp(ConstName, p + 4)<>0 then break;
      ModID := PWord(p)^;
      if (ModID <> $FFFF) and (Result[num - 1] <> ModID) then
      begin
        Result[num] := ModID;
        Inc(num);
        assert(num < ModuleCount);
      end;
    end;
    //After last element must be word 0xFFFF
    Result[num] := $FFFF;
    Exit;
  end;
end;

Function MKnowledgeBase.GetProcPrototype (ProcIdx:Integer):AnsiString;
Var
  pInfo:MProcInfo;
Begin
  if Inited and GetProcInfo(ProcIdx, INFO_ARGS, pInfo) then Result:=GetProcPrototype(@pInfo)
    else Result:='';
end;

Function MKnowledgeBase.GetProcPrototype(pInfo:PMProcInfo):AnsiString;
var
  p:PAnsiChar;
  n:Integer;
  len:word;
Begin
  Result:='';
  if pInfo=Nil then Exit;
  case pInfo.MethodKind of
    'C': Result:='constructor ';
    'D': Result:='destructor ';
    'F': Result:='function ';
    'P': Result:='procedure ';
  End;
  Result:=Result + pInfo.ProcName;
  if pInfo.ArgsNum<>0 Then Result:=Result + '(';
  p := pInfo.Args;
  for n := 0 to pInfo.ArgsNum-1 do
  begin
    if n<>0 then Result:=Result + '; ';
    //Tag
    if p^ = #$22 then Result:=Result + 'var ';
    Inc(p);
    //Register
    Inc(p, 4);
    //Ndx
    Inc(p, 4);
    //Name
    Len := PWord(p)^;
    Inc(p,2);
    Result:=Result + MakeString(p, Len) + ':';
    Inc(p, Len + 1);
    //TypeDef
    Len := PWord(p)^;
    Inc(p, 2);
    Result:=Result + MakeString(p, Len);
    Inc(p,Len + 1);
  End;
  if pInfo.ArgsNum<>0 then Result:=Result + ')';
  if pInfo.MethodKind = 'F' then Result:=Result + ':' + pInfo.TypeDef;
  Result:=Result + ';';
  Case pInfo.CallKind of
    1: Result:=Result + ' cdecl;';
    2: Result:=Result + ' pascal;';
    3: Result:=Result + ' stdcall;';
    4: Result:=Result + ' safecall;';
  End;
end;

//return direct pointer to const data of KB
Function MKnowledgeBase.GetKBCachePtr (Offset, Size:Integer):PAnsiChar;
Begin
  assert((Offset >= 0) and (Offset < SizeKBFile) and (Offset + Size < SizeKBFile));
  Result:=PAnsiChar(KBCache) + Offset;
end;

Function MKnowledgeBase.IsUsedProc (AIdx:Integer):Boolean;
Begin
  Result:=(UsedProcs[AIdx] = 1);
end;

Procedure MKnowledgeBase.SetUsedProc (AIdx:Integer);
Begin
  UsedProcs[AIdx] := 1;
end;

Function MKnowledgeBase.GetKBProcInfo (typeName:PAnsiChar; out procInfo:MProcInfo; Var procIdx:Integer):Boolean;
Begin
  Result := GetProcInfo(typeName, INFO_DUMP or INFO_ARGS, procInfo, procIdx);
end;

Function MKnowledgeBase.GetKBTypeInfo (typeName:PAnsiChar; out typeInfo:MTypeInfo):Boolean;
var
  idx:Integer;
  _uses:TWordDynArray;
Begin
  Result:=False;
  _uses := GetTypeUses(typeName);
  idx := GetTypeIdxByModuleIds(_uses, typeName);
  _uses:=Nil;
  if idx <> -1 then
  begin
    idx := TypeOffsets[idx].NamId;
    if GetTypeInfo(idx, INFO_FIELDS or INFO_PROPS or INFO_METHODS {or INFO_DUMP}, typeInfo) then
      Result:=True;
  End;
end;

Function MKnowledgeBase.GetKBPropertyInfo (clasName:PAnsiChar; propName:AnsiString; out typeInfo:MTypeInfo):Boolean;
var
  n, idx, _pos:Integer;
  p:PAnsiChar;
  _uses:TWordDynArray;
  Len:Word;
  tInfo:MTypeInfo;
  name, _type:AnsiString;
Begin
  Result:=False;
  _uses := GetTypeUses(clasName);
  idx := GetTypeIdxByModuleIds(_uses, clasName);
  _uses:=Nil;
  if idx <> -1 then
  begin
    idx := TypeOffsets[idx].NamId;
    if GetTypeInfo(idx, INFO_PROPS, tInfo) then
    begin
      p := tInfo.Props;
      for n := 0 To tInfo.PropsNum-1 do
      begin
        Inc(p);//Scope
        Inc(p, 4);//Index
        Inc(p, 4);//DispID
        Len := PWord(p)^;
        Inc(p, 2);
        name := MakeString(p, Len);
        Inc(p, Len + 1);//Name
        Len := PWord(p)^;
        Inc(p, 2);
        _type := TrimTypeName(MakeString(p, Len));
        Inc(p,Len + 1);//TypeDef
        Len := PWord(p)^;
        Inc(p, 2 + Len + 1);//ReadName
        Len := PWord(p)^;
        Inc(p, 2 + Len + 1);//WriteName
        Len := PWord(p)^;
        Inc(p, 2 + Len + 1);//StoredName
        if SameText(name, propName) then
        begin
          _pos := LastDelimiter(':.',_type);
          if _pos<>0 then _type := Copy(_type,_pos + 1, Length(_type));
          Result:=GetKBTypeInfo(PAnsiChar(_type), typeInfo);
          Exit;
        End;
      End;
    End;
  end;
end;

End.

