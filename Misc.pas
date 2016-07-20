unit Misc;

interface

Uses Windows,Classes,Infos,KnowledgeBase,Decompiler, Graphics,Def_main,Def_know;

Var
  IDRVersion:AnsiString;

//global API
Procedure FreeInvalidate(var Obj);
Function FirstWord(const str:AnsiString;from:Integer=1;Last:Integer=0):Integer;
Function StrTok(const str:AnsiString;Delim:TChars):AnsiString;
Function MakeString(p:PAnsiChar;L:Integer):AnsiString;
Function Adr2Pos(adr:Integer):Integer;
function Val2Str(Val:Integer;dig:Byte = 0): AnsiString;
function Pos2Adr(_Pos:Integer): Integer;
Function AddToBSSInfos(Adr:Integer; AName, ATypeName:AnsiString):InfoRec;
Procedure AddFieldXref(fInfo:FIELDINFO; ProcAdr:Integer; ProcOfs:Integer; _type:Char);
procedure AddPicode(_Pos:Integer; Op:Byte; _Name:AnsiString; Ofs:Integer);
Function ArgsCmpFunction(item1, item2:Pointer):Integer;
Function CanReplace(var fromName, toName:AnsiString):Boolean;
procedure ClearFlag(flag:TCflagSet; p:Integer);
procedure ClearFlags(flag:TCflagSet; p, num:Integer);
Procedure Copy2Clipboard(items:TStrings; leftMargin:Integer; asmCode:Boolean);
Function ExportsCmpFunction(item1, item2:Pointer):Integer;
Function ExtractClassName(const AName:AnsiString):AnsiString;
Function ExtractProcName(const AName:AnsiString):AnsiString;
Function ExtractName(const AName:AnsiString):AnsiString;
Function ExtractType(const AName:AnsiString):AnsiString;
procedure FillArgInfo(k:Integer; callkind:Byte; argInfo:PArgInfo; var p:PAnsiChar; Var s:Integer);
function FloatNameToFloatType(AName:AnsiString): TFloatKind;
Function GetArrayElementType(arrType:AnsiString):AnsiString;
Function GetArrayElementTypeSize(arrType:AnsiString):Integer;
Function GetArrayIndexes(arrType:AnsiString; ADim:Integer; var LowIdx, HighIdx:Integer):Boolean;
Function GetArraySize(arrType:AnsiString):Integer;
Function GetChildAdr(Adr:Integer):Integer;
Function GetClassAdr(const AName:AnsiString):Integer;
Function GetClassSize(Adr:Integer):Integer;
Function GetClsName(Adr:Integer):AnsiString;
Function GetDefaultProcName(Adr:Integer):AnsiString;
Function GetDynaInfo(adr:Integer; id:Word; var dynAdr:Integer):AnsiString;
Function GetDynArrayTypeName(adr:Integer):AnsiString;
Function GetEnumerationString(TypeName:AnsiString; Val:Variant):AnsiString;
Function GetImmString(Val:Integer):AnsiString; Overload;
Function GetImmString(TypeName:AnsiString; Val:Integer):AnsiString; Overload;
function GetInfoRec(adr:Integer): InfoRec;
Function GetLastLocPos(fromAdr:Integer):Integer;
Function GetModuleVersion(const module:AnsiString):AnsiString;
Function GetNearestArgA(fromPos:Integer):Integer;
Function GetNearestDownInstruction(fromPos:Integer):Integer; Overload;
function GetNearestDownInstruction(fromPos:Integer; Instruction:AnsiString): Integer; overload;
Function GetNearestUpPrefixFs(fromPos:Integer):Integer;
Function GetNthUpInstruction(fromPos, N:Integer):Integer;
Function GetNearestUpInstruction(fromPos:Integer):Integer; Overload;
Function GetNearestUpInstruction(fromPos, toPos:Integer):Integer; Overload;
Function GetNearestUpInstruction(fromPos, toPos, no:Integer):Integer; Overload;
function GetNearestUpInstruction1(fromPos, toPos:Integer; Instruction:AnsiString): Integer;
Function GetNearestUpInstruction2(fromPos, toPos:Integer; Instruction1, Instruction2:PAnsiChar):Integer;
Function GetParentAdr(Adr:Integer):Integer;
Function GetParentName(adr:Integer):AnsiString; Overload;
Function GetParentName(const ClasName:AnsiString):AnsiString; Overload;
Function GetParentSize(Adr:Integer):Integer;
Function GetProcRetBytes(pInfo:MProcInfo):Integer;
Function GetProcSize(fromAdr:Integer):Integer;
Function GetRecordSize(AName:AnsiString):Integer;
Function GetRecordFields(AOfs:Integer; ARecType:AnsiString):AnsiString;
Function GetAsmRegisterName(Idx:Integer):AnsiString;
Function GetDecompilerRegisterName(Idx:Integer):AnsiString;
Function GetSetString(TypeName:AnsiString; ValAdr:PAnsiChar):AnsiString;
Function GetStopAt(vmtAdr:Integer):Integer;
Function GetOwnTypeAdr(AName:AnsiString):Integer;
Function GetOwnTypeByName(AName:AnsiString):PTypeRec;
Function GetTypeDeref(ATypeName:AnsiString):AnsiString;
Function GetTypeKind(AName:AnsiString; var size:Integer):LKind;
Function GetPackedTypeSize(AName:AnsiString):Integer;
Function GetTypeName(Adr:Integer):AnsiString;
Function GetTypeSize(AName:AnsiString):Integer;
Function ImportsCmpFunction(item1, item2:Pointer):Integer;
Function IsADC(Idx:Integer):Boolean;
Function IsDefaultName(AName:AnsiString):Boolean;
Function IsInheritsByAdr(const Adr1, Adr2:Integer):Boolean;
Function IsInheritsByClassName(const Name1, Name2:AnsiString):Boolean;
Function IsInheritsByProcName(const Name1, Name2:AnsiString):Boolean;
Function IsSameRegister(Idx1, Idx2:Integer):Boolean;
Function IsValidCodeAdr(Adr:Integer):Boolean;
Function IsValidCString(p:Integer):Boolean;
Function IsValidImageAdr(Adr:Integer):Boolean;
Function IsValidName(len, p:Integer):Boolean;
Function IsValidString(len, p:Integer):Boolean;
Procedure MakeGvar(recN:InfoRec; adr, xrefAdr:Integer);
Function MakeGvarName(adr:Integer):AnsiString;
Function MethodsCmpFunction(item1, item2:Pointer):Integer;
procedure OutputDecompilerHeader(var f:TextFile);
function IsFlagSet(flag:TCflagSet; p:Integer): Boolean;
procedure SetFlag(flag:TCflagSet; p:Integer);
procedure SetFlags(flag:TCFlagSet; p, num:Integer);
Function SortUnitsByAdr(item1, item2:Pointer):Integer;
Function SortUnitsByNam(item1, item2:Pointer):Integer;
Function SortUnitsByOrd(item1, item2:Pointer):Integer;
Function TransformString(str:PAnsiChar; len:Integer):AnsiString;
Function TransformUString(codePage:Word; data:PWideChar; len:Integer):AnsiString;
Function TrimTypeName(const TypeName:AnsiString):AnsiString;
Function TypeKind2Name(kind:LKind):AnsiString;

//Decompiler
Function InputDialogExec(caption, labelText, text:AnsiString):AnsiString;
Function ManualInput(procAdr, curAdr:Integer; caption, labelText:AnsiString):AnsiString;
Procedure SaveCanvas(ACanvas:TCanvas);
Procedure RestoreCanvas(ACanvas:TCanvas);
Procedure DrawOneItem(AItem:AnsiString; ACanvas:TCanvas; var ARect:TRect; AColor:TColor; flags:Integer);

Function OutputHex(v:Integer;sign:Boolean;dig:Integer=0):AnsiString;

var
  StringBuf:Array [0..MAXSTRBUFFER] of Char;    //Buffer to make string

implementation

Uses TypInfo,Types,Forms,SysUtils,Main,Def_disasm,Def_info,Variants,StrUtils,
  Controls,Clipbrd,InputDlg,Scanf;

const
  {TypeKinds:Array[0..21] of AnsiString =
  (
    'Unknown',
    'Integer',
    'Char',
    'Enumeration',
    'Float',
    'ShortString',
    'Set',
    'Class',
    'Method',
    'WChar',
    'AnsiString',
    'WideString',
    'Variant',
    'Array',
    'Record',
    'Interface',
    'Int64',
    'DynArray',
    'UString',
    'ClassRef',
    'Pointer',
    'Procedure'
  );}

  IdxToIdx32Tab:Array[0..23] of Integer =
    (16, 17, 18, 19, 16, 17, 18, 19, 16, 17, 18, 19, 20, 21, 22, 23, 16, 17, 18, 19, 20, 21, 22, 23);

Var
  SavedPenColor, SavedBrushColor, SavedFontColor:TColor;
  SavedBrushStyle:TBrushStyle;

Procedure FreeInvalidate(var Obj);
var
  temp:TObject;
Begin
  temp:=TObject(Obj);
  Pointer(Obj):=Pointer(1);
  temp.Free;
end;

Function FirstWord(const str:AnsiString;from:Integer=1;Last:Integer=0):Integer;
var
  k:Integer;
Begin
  Result:=from;
  if Last<>0 then k:=Last else k:=Length(str);
  while (Result<=k)and not(str[Result] in [' ',#13,#10,#9]) Do Inc(Result);
  Dec(Result);
end;

Function StrTok(const str:AnsiString;Delim:TChars):AnsiString;
Const
  s:Ansistring = '';
  p:Integer = 1;
var
  j,k:Integer;
Begin
  if str<>'' then
  begin
    s:=str;
    p:=1;
  end;
  k:=Length(s);
  while (p<=k) and (s[p] in delim) do Inc(p);
  j:=p;
  while (p<=k) and not (s[p] in delim) do Inc(p);
  Result:=Copy(s,j,p-j);
end;

Function MakeString(p:PAnsiChar;L:Integer):AnsiString;
Begin
  SetLength(Result,L);
  if L<>0 then StrLCopy(PAnsiChar(Result),p,L);
end;

Function Adr2Pos (adr:Integer):Integer;
var
  n,ofs:Integer;
  segInfo:PSegmentInfo;
Begin
  ofs:=0;
  for n := 0 to SegmentList.Count-1 do
  begin
    segInfo := SegmentList[n];
    if (segInfo.Start <= adr) and (adr < segInfo.Start + segInfo.Size) then
    begin
      if (segInfo.Flags and IMAGE_SCN_MEM_PRELOAD)<>0 then Result:= -1
        Else Result:=ofs + (adr - segInfo.Start);
      Exit;
    End;
    if (segInfo.Flags and IMAGE_SCN_MEM_PRELOAD)=0 then Inc(ofs, segInfo.Size);
  End;
  Result:= -2;
end;

Function Pos2Adr (_Pos:Integer):Integer;
var
  n, fromPos, toPos:Integer;
  segInfo:PSegmentInfo;
Begin
  toPos:=0;
  for n := 0 to SegmentList.Count-1 do
  begin
    segInfo := SegmentList[n];
    if (segInfo.Flags and IMAGE_SCN_MEM_PRELOAD)=0 then
    begin
      fromPos := toPos;
      Inc(toPos, segInfo.Size);
      if (fromPos <= _Pos) and (_Pos < toPos) then
      begin
        Result:=segInfo.Start + (_Pos - fromPos);
        Exit;
      End;
    end;
  End;
  Result:=0;
end;

//Can replace type "fromName" to type "toName"?
Function CanReplace (Var fromName, toName:AnsiString):Boolean;
Begin
  Result:=False;
	//Skip empty toName
	if toName <> '' then
    //We can replace empty "fromName" or name "byte", "word", "dword'
    Result:= (fromName = '') or SameText(fromName, 'byte') or SameText(fromName, 'word')
      or SameText(fromName, 'dword');
end;

Function GetDefaultProcName (Adr:Integer):AnsiString;
Begin
  Result:= 'sub_' + Val2Str(adr,8);
end;

Function Val2Str (Val:Integer;dig:Byte = 0):AnsiString;
Begin
  Result:=IntToHex(Val, dig);
end;

Function AddToBSSInfos (Adr:Integer; AName, ATypeName:AnsiString):InfoRec;
var
  _key:AnsiString;
  idx:Integer;
Begin
  _key := Val2Str(Adr,8);
  idx := BSSInfos.IndexOf(_key);
  if idx = -1 then
  begin
    Result := InfoRec.Create(-1, ikData);
    Result.SetName(AName);
    Result._type := ATypeName;
    BSSInfos.AddObject(_key, Result);
  end
  else
  begin
    Result := InfoRec(BSSInfos.Objects[idx]);
    if Result._type = '' then Result._type := ATypeName;
  end;
end;

Function MakeGvarName (adr:Integer):AnsiString;
Begin
  Result:='gvar_' + Val2Str(adr,8);
end;

Procedure MakeGvar (recN:InfoRec; adr, xrefAdr:Integer);
Begin
  if not recN.HasName then recN.SetName(MakeGvarName(adr));
  if xrefAdr<>0 then recN.AddXref('C', xrefAdr, 0);
end;

Procedure FillArgInfo (k:Integer; callkind:Byte; argInfo:PArgInfo; var p:PAnsiChar; Var s:Integer);
var
  ndx,locflags:Integer;
  wlen:Word;
Begin
  argInfo.Tag := PByte(p)^;
  Inc(p);
  locflags := PInteger(p)^;
  Inc(p,4);
  argInfo.in_Reg := (locflags and 8)<>0;
  ndx := PInteger(p)^;
  Inc(p, 4);
  if callkind=0 then
  begin
    //fastcall
    if argInfo.in_Reg and (k < 3) then argInfo.Ndx := k // << 24;???
      else argInfo.Ndx := ndx;
  end
  else
  begin
    //stdcall, cdecl, pascal
    argInfo.Ndx := s;
    Inc(s, 4);
  end;
  argInfo.Size := 4;
  wlen := PWord(p)^;
  Inc(p,2);
  argInfo.Name := MakeString(p, wlen);
  Inc(p, wlen + 1);
  wlen := PWord(p)^;
  Inc(p, 2);
  argInfo.TypeDef := TrimTypeName(MakeString(p, wlen));
  Inc(p, wlen + 1);
end;

Function TrimTypeName (Const TypeName:AnsiString):AnsiString;
var
  _pos:Integer;
  i:Integer;
Begin
  if TypeName='' then Result:=''
  Else
  begin
    _pos := Pos('.',TypeName);
    //No '.' in TypeName or TypeName begins with '.'
    if (_pos = 0) or (_pos = 1) then Result:=TypeName
    //или это имя типа range
    else if TypeName[_pos + 1] = '.' then Result:=TypeName
    else
    begin
      //Check special symbols upto '.'
      for i:=1 to Length(TypeName) do
      begin
        if TypeName[i] = '.' then break
        Else if (TypeName[i] < '0') or (TypeName[i]= '<') then
        begin
          Result:=TypeName;
          Exit;
        End;
      end;
      Result:=ExtractProcName(TypeName);
    End;
  end;
end;

Function IsValidImageAdr (Adr:Integer):Boolean;
Begin
  Result:= (Adr >= Integer(CodeBase)) and (Adr < Integer(CodeBase) + ImageSize);
end;

Function IsValidCodeAdr (Adr:Integer):Boolean;
Begin
  Result:=(Adr >= Integer(CodeBase)) and (Adr < Integer(CodeBase) + CodeSize);
end;

Function ExtractClassName (Const AName:AnsiString):AnsiString;
var
  p:Integer;
Begin
  Result:='';
  if AName <>'' then
  begin
    p:= Pos('.',AName);
    if p<>0 then Result:=Copy(AName,1, p - 1);
  End;
end;

Function ExtractProcName (Const AName:AnsiString):AnsiString;
var
  p:Integer;
Begin
  Result:='';
  if AName <>'' then
  begin
    p:= Pos('.',AName);
    if p<>0 then Result:=Copy(AName,p+1, Length(AName))
      else Result:=AName;
  End;
end;

Function ExtractName (Const AName:AnsiString):AnsiString;
var
  p:Integer;
Begin
  Result:='';
  if AName <>'' then
  begin
    p:= Pos(':',AName);
    if p<>0 then Result:=Copy(AName,1, p-1);
  End;
end;

Function ExtractType (Const AName:AnsiString):AnsiString;
var
  p:Integer;
Begin
  Result:='';
  if AName <>'' then
  begin
    p:= Pos(':',AName);
    if p<>0 then Result:=Copy(AName,p+1, Length(AName));
  End;
end;

//Return position of nearest up argument eax from position fromPos
Function GetNearestArgA (fromPos:Integer):Integer;
Begin
  Result := fromPos-1;
  while true do
  begin
    if IsFlagSet([cfInstruction], Result) then
    begin
      if IsFlagSet([cfProcStart], Result) then break;
      if IsFlagSet([cfSetA], Result) then Exit;
    End;
    Dec(Result);
  end;
  Result:= -1;
end;

//Return position of nearest up instruction with segment prefix fs:
Function GetNearestUpPrefixFs (fromPos:Integer):Integer;
Var
  _disInfo:TDisInfo;
Begin
  if fromPos>=0 then
  begin
    Result:=fromPos - 1;
    while Result>=0 Do
    begin
      if IsFlagSet([cfInstruction], Result) then
      begin
        frmDisasm.Disassemble(Pos2Adr(Result), @_disInfo, Nil);
        if _disInfo.SegPrefix = 4 Then Exit;
      End;
      if IsFlagSet([cfProcStart], Result) then break;
      Dec(Result);
    End;
  End;
  Result:= -1;
end;

//Return position of nearest up instruction from position fromPos
Function GetNearestUpInstruction (fromPos:Integer):Integer; Overload;
Begin
  if fromPos >= 0 Then
  begin
    Result:= fromPos - 1;
    while Result>=0 do
    begin
      if IsFlagSet([cfInstruction], Result) then Exit;
      if IsFlagSet([cfProcStart], Result) then break;
      Dec(Result);
    End;
  end;
  result:=-1;
end;

//Return position of N-th up instruction from position fromPos
Function GetNthUpInstruction (fromPos, N:Integer):Integer;
Begin
  if fromPos>=0 then
  begin
    Result:= fromPos - 1;
    while Result>= 0 do
    begin
      if IsFlagSet([cfInstruction], Result) then
      begin
        Dec(N);
        if N=0 then Exit;
      End;
      if IsFlagSet([cfProcStart], Result) then break;
      Dec(Result);
    End;
  end;
  Result:= -1;
end;

//Return position of nearest up instruction from position fromPos
Function GetNearestUpInstruction (fromPos, toPos:Integer):Integer; Overload;
Begin
  If fromPos>=0 then
  begin
    Result:= fromPos - 1;
    While Result>= toPos do
    begin
      if IsFlagSet([cfInstruction], Result) then Exit;
      if IsFlagSet([cfProcStart], Result) then break;
      Dec(Result);
    End;
  end;
  Result:=-1;
end;

Function GetNearestUpInstruction (fromPos, toPos, no:Integer):Integer; Overload;
Begin
  If fromPos>=0 then
  begin
    Result:= fromPos - 1;
    While Result>= toPos do
    begin
      if IsFlagSet([cfInstruction], Result) then
      begin
        Dec(no);
        if no=0 Then Exit;
      End;
      Dec(Result);
    end;
  end;
  Result:=-1;
end;

//Return position of nearest up instruction from position fromPos
Function GetNearestUpInstruction1 (fromPos, toPos:Integer; Instruction:AnsiString):Integer;
var
  len:Integer;
  _DisInfo:TDisInfo;
Begin
  If fromPos>=0 then
  begin
    len:=Length(Instruction);
    Result:= fromPos - 1;
    while Result>= toPos do
    begin
      if IsFlagSet([cfInstruction], Result) then
      begin
        frmDisasm.Disassemble(Pos2Adr(Result), @_DisInfo, Nil);
        if (len<>0) and (_DisInfo.Mnem=Instruction) then Exit;
      end;
      if IsFlagSet([cfProcStart], Result) then break;
      Dec(Result);
    End;
  End;
  Result:=-1;
end;

//Return position of nearest up instruction from position fromPos
Function GetNearestUpInstruction2 (fromPos, toPos:Integer; Instruction1, Instruction2:PAnsiChar):Integer;
var
  len1,len2:Integer;
  _DisInfo:TDisInfo;
Begin
  If fromPos>=0 then
  begin
    len1:=Length(Instruction1);
    len2:=Length(Instruction2);
    Result:= fromPos - 1;
    while Result>= toPos do
    begin
      if IsFlagSet([cfInstruction], Result) then
      begin
        frmDisasm.Disassemble(Pos2Adr(Result), @_DisInfo, Nil);
        if ((len1<>0) and (_DisInfo.Mnem=Instruction1)) or
            ((len2<>0) and (_DisInfo.Mnem=Instruction2)) Then Exit;
      End;
      if IsFlagSet([cfProcStart], result) then break;
      Dec(Result);
    End;
  End;
  Result:=-1;
end;

//Return position of nearest down instruction from position fromPos
Function GetNearestDownInstruction (fromPos:Integer):Integer; Overload;
var
  instrLen:Integer;
  DisInfo:TDisInfo;
begin
  Result:=-1;
  If fromPos >= 0 then
  begin
    instrLen := frmDisasm.Disassemble(Pos2Adr(fromPos), @DisInfo, Nil);
    if instrLen<>0 then Result:= fromPos + instrLen;
  End;
end;

//Return position of nearest down "Instruction" from position fromPos
Function GetNearestDownInstruction (fromPos:Integer; Instruction:AnsiString):Integer; Overload;
var
  instrLen, len:Integer;
  curPos:Integer;
  DisInfo:TDisInfo;
begin
  Result:=-1;
  len:=Length(Instruction);
  curPos := fromPos;
  if fromPos >= 0 then
    while true do
    begin
      instrLen := frmDisasm.Disassemble(Pos2Adr(curPos), @DisInfo, Nil);
      if instrLen=0 then
      begin
        Inc(curPos);
        continue;
      End;
      if (len<>0) and (DisInfo.Mnem=Instruction) then
      Begin
        Result:= curPos + instrLen;
        Exit;
      end;
      if DisInfo.Ret then break;
      Inc(curPos, instrLen);
    end;
end;

Function IsFlagSet (flag:TCflagSet; p:Integer):Boolean;
Begin
  //!!!
  if (p < 0) or (p >= TotalSize) then
  begin
    dummy := 1;
    Result:=false;
  End
  else Result:=(flag * FlagList[p] <> []);
end;

Procedure SetFlag (flag:TCflagSet; p:Integer);
Begin
  //!!!
  if (p < 0) or (p >= TotalSize) then dummy := 1
    else if Assigned(FlagList) then FlagList[p]:=FlagList[p] + flag;
end;

Procedure SetFlags (flag:TCFlagSet; p, num:Integer);
var
  i:Integer;
Begin
  //!!!
  if (p < 0) or (p + num >= TotalSize) then dummy := 1
  Else if Assigned(FlagList) then for i := P to p + num-1 do
    FlagList[i]:=FlagList[i] + flag;
end;

Procedure ClearFlag (flag:TCflagSet; p:Integer);
Begin
  //!!!
  if (p < 0) or (p >= TotalSize) then dummy := 1
    else if Assigned(FlagList) then FlagList[p]:=FlagList[p] - flag;
end;

Procedure ClearFlags (flag:TCflagSet; p, num:Integer);
var
  i:Integer;
Begin
  if (p < 0) or (p + num > TotalSize) Then dummy := 1
  else if Assigned(FlagList) then for i := p to p + num-1 do
    FlagList[i]:=FlagList[i] - flag;
end;

//pInfo must contain pInfo->
Function GetProcRetBytes (pInfo:MProcInfo):Integer;
var
  _pos,_curAdr:Integer;
  _disInfo:TDisInfo;
Begin
  _pos := pInfo.DumpSz - 1;
  _curAdr := Integer(CodeBase) + _pos;
  while _pos >= 0 do
  begin
    frmDisasm.Disassemble(pInfo.Dump + _pos, _curAdr, @_disInfo, Nil);
    if _disInfo.Ret then
    begin
      //ImmPresent
      if _disInfo.OpType[0] = otIMM then Result:=_disInfo.Immediate
        else Result:=0;
      Exit;
    End;
    Dec(_pos);
    Dec(_curAdr);
  End;
  Result:=0;
end;

Function GetProcSize (fromAdr:Integer):Integer;
var
  recN:InfoRec;
Begin
  Result := 0;
  recN := GetInfoRec(fromAdr);
  if Assigned(recN) and Assigned(recN.procInfo) then Result := recN.procInfo.procSize;
  if Result=0 then Result := FMain.EstimateProcSize(fromAdr);
(*
  int     pos, size = 0;
  for (pos = Adr2Pos(fromAdr); pos < TotalSize; pos++)
  {
      size++;
      if (IsFlagSet(cfProcEnd, pos)) break;
  }
  return size;
*)
end;

Function GetRecordSize (AName:AnsiString):Integer;
var
  len:Byte;
  _uses:TWordDynArray;
  idx, _pos:Integer;
  tInfo:MTypeInfo;
  recT:PTypeRec;
  str:AnsiString;
  recFile:Text;
Begin
  //Manual
  Result:=0;
  //File
  str:=FMain.WrkDir + '\types.idr';
  If FileExists(str) then
  begin
    AssignFile(recFile,str);
    Reset(recFile);
    try
      while not Eof(recFile) do
      begin
        Readln(recFile,str);
        if Pos(AName+'=',str) = 1 then
        begin
          _pos := Pos('size=',str);
          if _pos<>0 then
          begin
            sscanf(PAnsiChar(str)+_pos+5,'%lX',[@Result]);
            Exit;
          End;
        End;
      end;
    Finally
      CloseFile(recFile);
    End;
  End;
  //KB
  _uses := KBase.GetTypeUses(PAnsiChar(AName));
  idx := KBase.GetTypeIdxByModuleIds(_uses, PAnsiChar(AName));
  _uses:=Nil;
  if idx <> -1 then
  begin
    idx := KBase.TypeOffsets[idx].NamId;
    if KBase.GetTypeInfo(idx, [INFO_DUMP], tInfo) then
    begin
      Result:=tInfo.Size;
      Exit;
    end;
  End;
  //RTTI
  recT := GetOwnTypeByName(AName);
  if Assigned(recT) and (recT.kind = ikRecord) then
  begin
    _pos := Adr2Pos(recT.adr);
    Inc(_pos, 4);//SelfPtr
    Inc(_pos);//TypeKind
    len := Byte(Code[_pos]);
    Inc(_pos, len + 1);//Name
    Result:=PInteger(Code + _pos)^;
    Exit;
  End;
end;

Function GetRecordFields (AOfs:Integer; ARecType:AnsiString):AnsiString;
var
  len, numOps:Byte;
  kind:LKind;
  p:PAnsiChar;
  dw, len1:Word;
  _uses:TWordDynArray;
  i, k, _idx, _pos, _elNum, _elOfs,  _size, _case, _offset:Integer;
  typeAdr:Integer;
  recT:PTypeRec;
  tInfo:MTypeInfo;
  str, _name, _typeName:AnsiString;
  recFile:Text;
Begin
  Result:='';
  if ARecType = '' then Exit;
  //File
  str:=FMain.WrkDir + '\types.idr';
  if FileExists(str) Then
  begin
    AssignFile(recFile,str);
    Reset(recFile);
    try
      while not Eof(recFile) do
      begin
        Readln(recFile,str);
        if Pos(ARecType+'=',str) = 1 then
        begin
          while not eof(recFile) do
          begin
            Readln(recFile,str);
            if Pos('end;',str)<>0 then break;
            if Pos('//' + Val2Str(AOfs),str)<>0 then
            begin
              result := str;
              _pos := LastDelimiter(';',Result);
              if _pos<>0 then SetLength(Result,_pos - 1);
              Exit;
            End;
          End;
        End;
      End;
    Finally
      closeFile(recFile);
    end;
  end;
  //KB
  _uses := KBase.GetTypeUses(PAnsiChar(ARecType));
  _idx := KBase.GetTypeIdxByModuleIds(_uses, PAnsiChar(ARecType));
  _uses:=Nil;
  if _idx <> -1 then
  begin
    _idx := KBase.TypeOffsets[_idx].NamId;
    if KBase.GetTypeInfo(_idx, [INFO_FIELDS], tInfo) then
    begin
      if tInfo.FieldsNum<>0 then
      begin
        p := tInfo.Fields;
        for k := 1 to tInfo.FieldsNum do
        begin
          //Scope
          Inc(p);
          _offset := PInteger(p)^;
          Inc(p, 4);
          _case := PInteger(p)^;
          Inc(p, 4);
          //Name
          len1 := PWord(p)^;
          Inc(p, 2);
          _name := MakeString(p, len1);
          Inc(p, len1 + 1);
          //Type
          len1 := PWord(p)^;
          Inc(p, 2);
          _typeName := TrimTypeName(MakeString(p, len1));
          Inc(p, len1 + 1);
          kind := GetTypeKind(_typeName, _size);
          if kind = ikRecord then
          begin
            _size := GetRecordSize(_typeName);
            if (AOfs >= _offset) and (AOfs < _offset + _size) then
              result:=result + _name + '.' + GetRecordFields(AOfs - _offset, _typeName);
          end
          else if (AOfs >= _offset) and (AOfs < _offset + _size) then
          begin
            if _size > 4 then
              result := _name + '+' + IntToStr(AOfs - _offset) + ':' + _typeName
            else
              result := _name + ':' + _typeName;
          End;
        End;
      End;
    End;
  End;
  if result <> '' Then Exit;
  //RTTI
  recT := GetOwnTypeByName(ARecType);
  if Assigned(recT) and (recT.kind = ikRecord) then
  begin
    _pos := Adr2Pos(recT.adr);
    Inc(_pos, 4);//SelfPtr
    Inc(_pos);//TypeKind
    len := Byte(Code[_pos]);
    Inc(_pos, len + 1);//Name
    Inc(_pos, 4);//Size
    _elNum := PInteger(Code + _pos)^;
    Inc(_pos, 4);
    for i := 1 to _elNum do
    begin
      typeAdr := PInteger(Code + _pos)^;
      Inc(_pos, 4);
      _elOfs := PInteger(Code + _pos)^;
      Inc(_pos, 4);
      _typeName := GetTypeName(typeAdr);
      kind := GetTypeKind(_typeName, _size);
      if kind = ikRecord then
      begin
        _size := GetRecordSize(_typeName);
        if (AOfs >= _elOfs) and (AOfs < _elOfs + _size) then
          result := 'f' + Val2Str(_elOfs) + '.' + GetRecordFields(AOfs - _elOfs, _typeName);
      end
      else if (AOfs >= _elOfs) and (AOfs < _elOfs + _size) then
      begin
        if _size > 4 then
          result := 'f' + Val2Str(_elOfs) + '+' + IntToStr(AOfs - _elOfs) + ':' + _typeName
        else
          result := 'f' + Val2Str(_elOfs) + ':' + _typeName;
      End;
    End;
    if DelphiVersion >= 2010 then
    begin
      //NumOps
      numOps := Byte(Code[_pos]);
      Inc(_pos);
      for i := 1 to numOps do //RecOps
        Inc(_pos, 4);
      _elNum := PInteger(Code + _pos)^;
      Inc(_pos, 4);  //RecFldCnt
      for i := 1 to _elNum do
      begin
        //TypeRef
        typeAdr := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        //FldOffset
        _elOfs := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        //Flags
        Inc(_pos);
        //Name
        len := Byte(Code[_pos]);
        Inc(_pos);
        _name := MakeString(Code + _pos, len);
        Inc(_pos, len);
        _typeName := GetTypeName(typeAdr);
        kind := GetTypeKind(_typeName, _size);
        if kind = ikRecord then
        begin
          _size := GetRecordSize(_typeName);
          if (AOfs >= _elOfs) and (AOfs < _elOfs + _size) then
            result := _name + '.' + GetRecordFields(AOfs - _elOfs, _typeName);
        end
        else if (AOfs >= _elOfs) and (AOfs < _elOfs + _size) then
        begin
          if _size > 4 then
            result := _name + '+' + IntToStr(AOfs - _elOfs) + ':' + _typeName
          else
            result := _name + ':' + _typeName;
        End;
        //AttrData
        dw := PWord(Code + _pos)^;
        Inc(_pos, dw);//ATR!!
      End;
    End;
  End;
end;

Function GetAsmRegisterName (Idx:Integer):AnsiString;
Begin
  Result:='';
  if (Idx >= 0) and (Idx < 32) then
  begin
    if Idx >= 31 then Result:='ST(' + IntToStr(Idx - 31) + ')'
    Else if Idx = 30 then Result:= 'ST'
    else if Idx >= 24 then Result:= SegRegTab[Idx - 24]
    else if Idx >= 16 then Result:=Reg32Tab[Idx - 16]
    Else if Idx >= 8 then Result:=Reg16Tab[Idx - 8]
    else Result:=Reg8Tab[Idx];
  End;
end;

Function GetDecompilerRegisterName (Idx:Integer):AnsiString;
Begin
  Result:='';
  If (Idx >= 0) and (Idx < 32) Then
  begin
    if Idx >= 16 then Result:=UpperCase(Reg32Tab[Idx - 16])
    Else if Idx >= 8 then Result:=UpperCase(Reg32Tab[Idx - 8])
    else Result:=UpperCase(Reg32Tab[Idx]);
  End;
end;

Function IsValidName (len, p:Integer):Boolean;
var
  i:Integer;
  b:Char;
Begin
  Result:=False;
  if len=0 then Exit;
  for i := P to p + len-1 do
  begin
    //if IsFlagSet(cfCode, i) then Exit;
    b := Code[i];
    //first symbol may be letter or '_' or '.' or ':'
    if i = p then
    begin
      if b in ['A'..'z','.','_',':'] then continue
        else Exit;
    End;
    if b > #127 then Exit;
    //if ((b < '0' || b > 'z') && b != '.' && b != '_' && b != ':' && b != '$') return false;
  End;
  Result:=True;
end;

Function IsValidString (len, p:Integer):Boolean;
var
  i:Integer;
Begin
  Result:=False;
  if len < 5 then Exit;
  for i := p to p + len-1 do
  begin
    //if IsFlagSet(cfCode, i) then Exit;

    //BYTE b = *(Code + i);
    //if (b < ' ' && b != '\t' && b != '\n' && b != '\r') return false;
    if (Code[i]<' ') And not (Code[i] in [#9,#10,#13]) then Exit;
  End;
  Result:=true;
end;

Function IsValidCString (p:Integer):Boolean;
var
  i,len:Integer;
Begin
  Result:=False;
  len := 0;
  for i := p to p + 1023 do
  begin
    //if IsFlagSet(cfCode, i) then break;
    if Code[i]=#0 then
    Begin
      Result:= (len >= 5);
      Exit;
    end;
    if (Code[i]<' ') And not (Code[i] in [#9,#10,#13]) then Exit;
    Inc(len);
  End;
end;

Function GetParentAdr (Adr:Integer):Integer;
var
  vmtAdr, P, adres:Integer;
Begin
  Result:=0;
  if not IsValidImageAdr(Adr) then Exit;
  vmtAdr := Adr - VmtSelfPtr;
  p := Adr2Pos(vmtAdr) + VmtParent;
  adres := PInteger(Code + p)^;
  if IsValidImageAdr(adres) and IsFlagSet([cfImport], Adr2Pos(adres)) then Exit;
  if (DelphiVersion = 2) And (adres<>0) then Inc(adres, VmtSelfPtr);
  Result:=adres;
end;

Function GetChildAdr (Adr:Integer):Integer;
var
  m:Integer;
  recV:PVmtListRec;
Begin
  Result:=0;
  if not IsValidImageAdr(Adr) then Exit;
  for m := 0 to VmtList.Count-1 do
  begin
    recV := VmtList[m];
    if (recV.vmtAdr <> Adr) and IsInheritsByAdr(recV.vmtAdr, Adr) then
    begin
      Result:=recV.vmtAdr;
      Exit;
    end;
  End;
end;

Function GetClassSize (Adr:Integer):Integer;
var
  vmtAdr,p,size:Integer;
Begin
  Result:=0;
  if not IsValidImageAdr(adr) then Exit;
  vmtAdr := adr - VmtSelfPtr;
  p := Adr2Pos(vmtAdr) + VmtInstanceSize;
  size := PInteger(Code + p)^;
  if DelphiVersion >= 2009 then Result:=size - 4
    else Result:=size;
end;

Function GetClsName (Adr:Integer):AnsiString;
var
  vmtAdr,p,nameAdr:Integer;
  recN:InfoRec;
  len:Byte;
Begin
  Result:='';
  if not IsValidImageAdr(adr) then Exit;
  vmtAdr := adr - VmtSelfPtr;
  p := Adr2Pos(vmtAdr) + VmtClassName;
  if IsFlagSet([cfImport], p) then
  begin
    recN := GetInfoRec(vmtAdr + VmtClassName);
    Result:=recN.Name;
    Exit;
  End;
  nameAdr := PInteger(Code + p)^;
  if not IsValidImageAdr(nameAdr) Then Exit;
  p := Adr2Pos(nameAdr);
  len := Byte(Code[p]);
  Inc(p);
  Result:=MakeString(Code+p, len);
end;

Function GetClassAdr (Const AName:AnsiString):Integer;
var
  name:AnsiString;
  adr,p,n:Integer;
  recV:PVmtListRec;
Begin
  Result:=0;
  if AName='' then Exit;
  adr := FindClassAdrByName(AName);
  if adr<>0 then
  Begin
    Result:=adr;
    Exit;
  end;
  p := Pos('.',AName);
  if p<>0 then
  begin
    //type as .XX or array[XX..XX] of XXX - skip
    if (p = 1) or (AName[p + 1] = '.') then Exit;
    name := Copy(AName,p + 1, Length(AName));
  end
  else name := AName;
  for n := 0 to VmtList.Count-1 do
  begin
    recV := VmtList[n];
    if SameText(recV.vmtName, name) then
    begin
      adr := recV.vmtAdr;
      AddClassAdr(adr, name);
      Result:=adr;
      Exit;
    End;
  end;
end;

Function GetParentSize (Adr:Integer):Integer;
Begin
  Result:=GetClassSize(GetParentAdr(Adr));
end;

Function GetParentName (adr:Integer):AnsiString; Overload;
var
  adres:Integer;
Begin
  Result:='';
  adres := GetParentAdr(Adr);
  if adres<>0 then Result:=GetClsName(adres);
end;

Function GetParentName (Const ClasName:AnsiString):AnsiString; Overload;
Begin
	Result:=GetParentName(GetClassAdr(ClasName));
end;

//Adr1 inherits Adr2 (Adr1 >= Adr2)
Function IsInheritsByAdr (Const Adr1, Adr2:Integer):Boolean;
Var
  adr:Integer;
Begin
  Result:=False;
  adr := Adr1;
  while adr<>0 do
  begin
    if adr = Adr2 Then
    Begin
      Result:=true;
      Exit;
    end;
    adr := GetParentAdr(adr);
  end;
end;

//Name1 >= Name2
Function IsInheritsByClassName (Const Name1, Name2:AnsiString):Boolean;
var
  adr:Integer;
Begin
  Result:=False;
  adr := GetClassAdr(Name1);
  while adr<>0 do
  begin
    if SameText(GetClsName(adr), Name2) Then
    Begin
      Result:=true;
      Exit;
    end;
    adr := GetParentAdr(adr);
  end;
end;

Function IsInheritsByProcName (Const Name1, Name2:AnsiString):Boolean;
Begin
  Result:= IsInheritsByClassName(ExtractClassName(Name1), ExtractClassName(Name2))
    and SameText(ExtractProcName(Name1), ExtractProcName(Name2));
end;

Function TransformString (str:PAnsiChar; len:Integer):AnsiString;
var
  z:Byte; // 0 = nothing, 1 = needs opening quote, 2 = needs closing quote
  c:char;
  p:PAnsiChar;
  k:Integer;
Begin
  z:=0;
  p:=str;
  Result:='';
  for k :=0 To len-1 do
  begin
    c := p^;
    Inc(p);
    if c in [' '..#126] then
    Begin
      if (z=1)or(Result='') then Result:=Result + COMENT_QUOTE;
      result:=result + c;
      z:=2;
    end
    else
    begin
      if z=2 then result:=Result + COMENT_QUOTE;
      Result:=Result + '#' + IntToStr(Ord(c));
      z:=1;
    end;
  End;
  if z=2 Then result:=result + COMENT_QUOTE;
end;

Function TransformUString (codePage:Word; data:PWideChar; len:Integer):AnsiString;
Var
  nChars:Integer;
  tmpBuf:PAnsiChar;
Begin
  Result:='';
  if not IsValidCodePage(codePage) then codePage := CP_ACP;
  nChars := WideCharToMultiByte(codePage, 0, data, -1, Nil, 0, Nil, Nil);
  if nChars=0 then Exit;
  GetMem(tmpBuf,nChars + 1);
  WideCharToMultiByte(codePage, 0, data, -1, tmpBuf, nChars, Nil, Nil);
  tmpBuf[nChars] := #0;
  Result:= QuotedStr(tmpBuf);
  FreeMem(tmpBuf,nChars+1);
end;

//Get stop address for analyzing virtual tables
Function GetStopAt (vmtAdr:Integer):Integer;
Var
  m:Integer;
  p, ptr:Integer;
Begin
  Result := Integer(CodeBase) + TotalSize;
  if DelphiVersion <> 2 then
  begin
    p := Adr2Pos(VmtAdr) + VmtIntfTable;
    m := VmtIntfTable;
    While m <> VmtInstanceSize do
    begin
      ptr := PInteger(Code + p)^;
      if (ptr >= VmtAdr) and (ptr < Result) then Result:= ptr;
      Inc(m,4);
      Inc(p,4);
    End;
  end
  else
  begin
    p := Adr2Pos(VmtAdr) + VmtInitTable;
    m := VmtInitTable;
    while m <> VmtInstanceSize do
    begin
      if Adr2Pos(VmtAdr) < 0 then
      begin
        Result:=0;
        Exit;
      End;
      ptr := PInteger(Code + p)^;
      if (ptr >= VmtAdr) and (ptr < Result) then Result:= ptr;
      Inc(m,4);
      Inc(p,4);
    end;
  End;
end;

Function GetTypeName (Adr:Integer):AnsiString;
var
  p:Integer;
  len:Byte;
  kind:LKind;
  recU:PUnitRec;
  prefix:AnsiString;
Begin
	if not IsValidImageAdr(adr) Then
  Begin
    Result:='?';
    Exit;
  end;
  if IsFlagSet([cfImport], Adr2Pos(adr)) then
  begin
    Result:=GetInfoRec(adr).Name;
    Exit;
  End;
  p := Adr2Pos(adr);
  if IsFlagSet([cfRTTI], p) then Inc(p,4);
  //TypeKind
  kind := LKind(Code[p]);
  Inc(p);
  len := Byte(Code[p]);
  Inc(p);
  Result := MakeString(Code + p, len);
  if Result[1] = '.' then
  begin
    recU := FMain.GetUnit(adr);
    if Assigned(recU) then
    begin
      case kind of
        ikEnumeration: prefix := '_Enum_';
        ikArray: prefix := '_Arr_';
        ikDynArray: prefix := '_DynArr_';
      else prefix := FMain.GetUnitName(recU);
      end;
      Result := prefix + IntToStr(recU.iniOrder) + '_' + Copy(Result,2, len);
    end;
  End;
end;

Function GetDynaInfo (adr:Integer; id:Word; Var dynAdr:Integer):AnsiString;
var
	m:Integer;
	classAdr:Integer;
  recN:InfoRec;
  recM:PMethodRec;
Begin
  classAdr := adr;
  dynAdr := 0;
  Result:='';
	if not IsValidCodeAdr(adr) then Exit;
  while classAdr<>0 do
  begin
    recN := GetInfoRec(classAdr);
    if Assigned(recN) and Assigned(recN.vmtInfo.methods) then
    begin
      for m := 0 to recN.vmtInfo.methods.Count-1 do
      begin
        recM := recN.vmtInfo.methods[m];
        if (recM.kind = 'D') and (recM.id = id) then
        begin
          dynAdr := recM.address;
          if (recM.name <> '') then Result:=recM.name;
          Exit; //GetDefaultProcName(recM.address);
        end;
      end;
    end;
    classAdr := GetParentAdr(classAdr);
  end;
end;

Function GetDynArrayTypeName (adr:Integer):AnsiString;
Var
  p:Integer;
  len:Byte;
Begin
  p := Adr2pos(adr);
  Inc(p, 4);
  Inc(p);//Kind
  len := Byte(Code[p]);
  Inc(p);
  Inc(p, len);//Name
  Inc(p, 4);//elSize
  Result:=GetTypeName(PInteger(Code + p)^);
end;

Function GetTypeSize (AName:AnsiString):Integer;
Var
  idx:Integer;
  _uses:TWordDynArray;
  tInfo:MTypeInfo;
Begin
  _uses := KBase.GetTypeUses(PAnsiChar(AName));
  idx := KBase.GetTypeIdxByModuleIds(_uses, PAnsiChar(AName));
  _uses:=Nil;
  if idx <>-1 then
  begin
    idx := KBase.TypeOffsets[idx].NamId;
    if KBase.GetTypeInfo(idx, [INFO_DUMP], tInfo) then
    begin
      if tInfo.Size<>0 then
      Begin
        Result:=tInfo.Size;
        Exit;
      End;
    end;
  end;
  Result:=4;
end;

Function TypeKind2Name (kind:LKind):AnsiString;
Begin
  //Result:='';
  //if kind < Length(TypeKinds) Then Result:=TypeKinds[kind];
  Result:=GetEnumName(TypeInfo(LKind),Ord(kind));
end;

Function GetOwnTypeAdr (AName:AnsiString):Integer;
var
  recT:PTypeRec;
Begin
  Result:=0;
  if AName <>'' then
  begin
    recT := GetOwnTypeByName(AName);
    if Assigned(recT) then REsult:=recT.adr;
  end;
end;

Function GetOwnTypeByName (AName:AnsiString):PTypeRec;
var
  m:Integer;
  recT:PTypeRec;
Begin
  Result:=Nil;
  if AName <>'' then
    for m := 0 to OwnTypeList.Count-1 do
    begin
      recT := OwnTypeList[m];
      if SameText(recT.name, AName) Then
      Begin
        Result:=recT;
        Exit;
      end;
    end;
end;

Function GetTypeDeref (ATypeName:AnsiString):AnsiString;
var
  idx:Integer;
  _uses:TWordDynArray;
  tInfo:MTypeInfo;
Begin
  if ATypeName[1] = '^' Then
  Begin
    Result:=Copy(ATypeName,2, Length(ATypeName));
    Exit;
  End;
  //Scan knowledgeBase
  _uses := KBase.GetTypeUses(PAnsiChar(ATypeName));
  idx := KBase.GetTypeIdxByModuleIds(_uses, PAnsiChar(ATypeName));
  _uses:=Nil;
  if idx <>-1 then
  begin
    idx := KBase.TypeOffsets[idx].NamId;
    if KBase.GetTypeInfo(idx, [INFO_DUMP], tInfo) then
    begin
      if (tInfo.Decl <> '') and (tInfo.Decl[1] = '^') then
      begin
        Result:=Copy(tInfo.Decl,2, Length(tInfo.Decl));
        Exit;
      end;
    end;
  end;
  Result:='';
end;

Function GetTypeKind (AName:AnsiString; Var size:Integer):LKind;
var
  p, idx:Integer;
  _uses:TWordDynArray;
  tInfo:MTypeInfo;
  name, str:AnsiString;
  recFile:Text;
  recT:PTypeRec;
Begin
  //Manual
  Result:=ikUnknown;
  size := 4;
  if AName <> '' then
  begin
    if Pos('array',AName)<>0 then
    Begin
      if Pos('array of',AName)<>0 then Result:=ikDynArray
        Else Result:=ikArray;
      Exit;
    end;
    p := Pos('.',AName);
    if (p > 1) and (AName[p + 1] <> ':') then
      name := Copy(AName,p + 1, Length(AName))
    else name := AName;
    if SameText(name, 'Boolean') or
      SameText(name, 'ByteBool') or
      SameText(name, 'WordBool') or
      SameText(name, 'LongBool') then
    begin
      Result:=ikEnumeration;
      Exit;
    end
    else if SameText(name, 'ShortInt') or
      SameText(name, 'Byte')     or
      SameText(name, 'SmallInt') or
      SameText(name, 'Word')     or
      SameText(name, 'Dword')    or
      SameText(name, 'Integer')  or
      SameText(name, 'LongInt')  or
      SameText(name, 'LongWord') or
      SameText(name, 'Cardinal') then
    begin
      Result:=ikInteger;
      Exit;
    end
    else if SameText(name, 'Char') then
    begin
      Result:=ikChar;
      Exit;
    end
    else if SameText(name, 'Text') or SameText(name, 'File') then
    begin
      Result:=ikRecord;
      Exit;
    end
    else if SameText(name, 'Int64') then
    begin
      size := 8;
      Result:=ikInt64;
      Exit;
    end
    else if SameText(name, 'Single') then
    begin
      Result:=ikFloat;
      Exit;
    end
    else if SameText(name, 'Real48')  or
      SameText(name, 'Real')     or
      SameText(name, 'Double')   or
      SameText(name, 'TDate')    or
      SameText(name, 'TTime')    or
      SameText(name, 'TDateTime')or
      SameText(name, 'Comp')     or
      SameText(name, 'Currency') then
    begin
      size := 8;
      Result:=ikFloat;
      Exit;
    end
    else if SameText(name, 'Extended') then
    begin
      size := 12;
      Result:=ikFloat;
      Exit;
    end
    else if SameText(name, 'ShortString') Then
    Begin
      Result:=ikString;
      Exit;
    end
    else if SameText(name, 'String') or SameText(name, 'AnsiString') Then
    Begin
      Result:=ikLString;
      Exit;
    end
    else if SameText(name, 'WideString') Then
    Begin
      Result:=ikWString;
      Exit;
    end
    else if SameText(name, 'UnicodeString') or SameText(name, 'UString') Then
    Begin
      Result:=ikUString;
      Exit;
    end
    else if SameText(name, 'PChar') or SameText(name, 'PAnsiChar') Then
    Begin
      Result:=ikCString;
      Exit;
    end
    else if SameText(name, 'PWideChar') Then
    Begin
      Result:=ikWCString;
      Exit;
    end
    else if SameText(name, 'Variant') Then
    Begin
      Result:=ikVariant;
      Exit;
    end
    else if SameText(name, 'Pointer') Then
    Begin
      Result:=ikPointer;
      Exit;
    end;

    //File
    str := FMain.WrkDir + '\types.idr';
    If FileExists(str) then
    begin
      AssignFile(recFile,str);
      Reset(recFile);
      try
        while not eof(recFile) do
        begin
          Readln(recFile,str);
          if Pos(AName + '=',str) = 1 then
            if Pos('=record',str)<>0 then
            begin
              REsult:=ikRecord;
              Exit;
            end;
        end;
      Finally
        closeFile(recFile);
      end;
    End;
    //RTTI
    recT := GetOwnTypeByName(name);
    if Assigned(recT) then
    begin
      size := 4;
      Result:=recT.kind;
      Exit;
    end;
    //Scan KB
    _uses := KBase.GetTypeUses(PAnsiChar(name));
    idx := KBase.GetTypeIdxByModuleIds(_uses, PAnsiChar(name));
    _uses:=Nil;
    if idx <>-1 then
    begin
      idx := KBase.TypeOffsets[idx].NamId;
      if KBase.GetTypeInfo(idx, [INFO_DUMP], tInfo) then
      begin
        if tInfo.Kind = Ord('Z') then  //drAlias???
        Begin
          Result:=ikUnknown;
          Exit;
        end
        else if (tInfo.Decl <> '') and (tInfo.Decl[1] = '^') then
        begin
          Result:=ikUnknown;
          Exit;
          //res := GetTypeKind(tInfo.Decl.SubString(2, tInfo.Decl.Length()), size);
          //if (res) return res;
          //return 0;
        end;
        size := tInfo.Size;
        case tInfo.Kind of
          drRangeDef://0x44
            begin
              Result:=ikEnumeration;
              Exit;
            end;
          drPtrDef://0x45
            begin
              Result:=ikMethod;
              Exit;
            end;
          drProcTypeDef://0x48
            begin
              Result:=ikMethod;
              Exit;
            end;
          drSetDef://0x4A
            begin
              Result:=ikSet;
              Exit;
            end;
          drRecDef://0x4D
            begin
              Result:=ikRecord;
              Exit;
            end;
        end;
        if tInfo.Decl <> '' then
        begin
          Result := GetTypeKind(tInfo.Decl, size);
          if Result<>ikUnknown Then Exit;
        end;
      end;
    end;
    //May be Interface name
    if AName[1] = 'I' then
    begin
      AName[1] := 'T';
      if GetTypeKind(AName, size) = ikVMT then
      Begin
        Result:=ikInterface;
        Exit;
      End;
    end;
  end;
end;

Function GetPackedTypeSize (AName:AnsiString):Integer;
var
  _size:Integer;
Begin
  if SameText(AName, 'Boolean')  or
    SameText(AName, 'ShortInt') or
    SameText(AName, 'Byte')     or
    SameText(AName, 'Char') then Result:=1
  else if SameText(AName, 'SmallInt') or
      SameText(AName, 'Word') then Result:=2
  else if SameText(AName, 'Dword') or
    SameText(AName, 'Integer')  or
    SameText(AName, 'LongInt')  or
    SameText(AName, 'LongWord') or
    SameText(AName, 'Cardinal') or
    SameText(AName, 'Single') then Result:=4
  else if SameText(AName, 'Real48') then Result:=6
  else if SameText(AName, 'Real') or
    SameText(AName, 'Double')   or
    SameText(AName, 'Comp')     or
    SameText(AName, 'Currency') or
    SameText(AName, 'Int64') then Result:=8
  else if SameText(AName, 'Extended') Then Result:=10
  else if GetTypeKind(AName, _size) = ikRecord then
    Result:=GetRecordSize(AName)
  else REsult:=4;
end;

//return string representation of immediate value with comment
Function GetImmString (Val:Integer):AnsiString; Overload;
var
  res0:AnsiString;
Begin
  res0:=IntToStr(Val);
  if (Val > -16) and (Val < 16) then Result:=res0
  Else
  begin
    Result:= '$' + Val2Str(Val);
    if not IsValidImageAdr(Val) then Result:=Result + ' {' + res0 + '}';
  End;
end;

Function GetImmString (TypeName:AnsiString; Val:Integer):AnsiString; Overload;
Var
  _size:Integer;
  str, _default:AnsiString;
  kind:LKind;
Begin
  _default := GetImmString(Val);
  kind:= GetTypeKind(TypeName, _size);
  if (Val=0) and (kind in [ikString,ikLString,ikWString,ikUString]) Then Result:='""'
  else if (Val=0) and (kind in [ikClass,ikVMT]) then Result:='NIL'
  else if kind = ikEnumeration then
  begin
    str := GetEnumerationString(TypeName, Val);
    if str <> '' Then Result:=str
      else Result:=_default;
  end
  else if kind = ikChar then Result:=COMENT_QUOTE + Chr(Val) + COMENT_QUOTE
  Else Result:=_default;
end;

Function GetInfoRec (adr:Integer):InfoRec;
Var
  p,idx:Integer;
Begin
  p := Adr2Pos(adr);
  if p >= 0 Then Result:=InfoList[p]
  else
  begin
    idx := BSSInfos.IndexOf(Val2Str(adr,8));
    if idx <> -1 then Result:=InfoRec(BSSInfos.Objects[idx])
      Else Result:=Nil;
  end;
end;

Function GetEnumerationString (TypeName:AnsiString; Val:Variant):AnsiString;
var
  len:BYTE;
  n, _pos, _val, idx:Integer;
  adr, typeAdr, minValue, maxValue, minValueB, maxValueB:Integer;
  b, e:Integer;
  use:TWordDynArray;
  tInfo:MTypeInfo;
  clsName:AnsiString;
Begin
  if VarType(Val) = varString then
  Begin
    Result:=Val;
    Exit;
  end;
  _val := Val;
  if SameText(TypeName, 'Boolean') or
    SameText(TypeName, 'ByteBool') or
    SameText(TypeName, 'WordBool') or
    SameText(TypeName, 'LongBool') then
  begin
    if _val<>0 then Result:='True'
      else Result:='False';
    Exit;
  end;
  adr := GetOwnTypeAdr(TypeName);
  //RTTI exists
  if IsValidImageAdr(adr) then
  begin
    _pos := Adr2pos(adr);
    Inc(_pos, 4);
    //typeKind
    Inc(_pos);
    len := Byte(Code[_pos]);
    Inc(_pos);
    clsName := MakeString(Code + _pos, len);
    Inc(_pos, len);
    //ordType
    Inc(_pos);
    minValue := PInteger(Code + _pos)^;
    Inc(_pos, 4);
    maxValue := PInteger(Code + _pos)^;
    Inc(_pos, 4);
    //BaseTypeAdr
    typeAdr := PInteger(Code + _pos)^;
    Inc(_pos, 4);

    //If BaseTypeAdr <> SelfAdr then fields extracted from BaseType
    if typeAdr <> adr then
    begin
      _pos := Adr2pos(typeAdr);
      Inc(_pos,4);   //SelfPointer
      Inc(_pos);      //typeKind
      len := Byte(Code[_pos]);
      Inc(_pos);
      Inc(_pos, len); //BaseClassName
      Inc(_pos);      //ordType
      minValueB := PInteger(Code + _pos)^;
      Inc(_pos, 4);
      maxValueB := PInteger(Code + _pos)^;
      Inc(_pos, 4);
      Inc(_pos, 4);   //BaseClassPtr
    end
    else
    begin
      minValueB := minValue;
      maxValueB := maxValue;
    end;
    for n := minValueB To maxValueB do
    begin
      len := Byte(Code[_pos]);
      Inc(_pos);
      if (n >= minValue) and (n <= maxValue) and (n = _val) then
      begin
        Result:=MakeString(Code + _pos, len);
        Exit;
      end;
      Inc(_pos, len);
    end;
  end
  //Try get from KB
  else
  begin
    use := KBase.GetTypeUses(PAnsiChar(TypeName));
    idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(TypeName));
    use:=Nil;
    if idx <> -1 then
    begin
      idx := KBase.TypeOffsets[idx].NamId;
      if KBase.GetTypeInfo(idx, [INFO_FIELDS, INFO_PROPS, INFO_METHODS, INFO_DUMP], tInfo) then
      begin
        if tInfo.Kind = drRangeDef Then
        begin
          Result:=Val;
          Exit;
        End;
        //if (SameText(TypeName, tInfo.TypeName) && tInfo.Decl <> '')
        if tInfo.Decl <> '' then
        begin
          e := 0;
          for n := 0 to _val do
          begin
            b := e + 1;
            e := PosEx(',',tInfo.Decl,b);
            if e=0 then
            Begin
              Result:='';
              Exit;
            end;
          end;
          Result:=Copy(tInfo.Decl,b, e - b);
          Exit;
        end;
      end;
    end;
  end;
  Result:='';
end;

Function GetSetString (TypeName:AnsiString; ValAdr:PAnsiChar):AnsiString;
Var
  n, m, idx, size:Integer;
  b:BYTE;
  pVal:PAnsiChar;
  use:TWordDynArray;
  tInfo:MTypeInfo;
  p,name:AnsiString;
Begin
  REsult:='';
  //Get from KB
  use := KBase.GetTypeUses(PAnsiChar(TypeName));
  idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(TypeName));
  use:=Nil;
  if idx <> -1 then
  begin
    idx := KBase.TypeOffsets[idx].NamId;
    if KBase.GetTypeInfo(idx, [INFO_DUMP], tInfo) then
      if Pos('set of ',tInfo.Decl)<>0 then
      begin
        size := tInfo.Size;
        name := TrimTypeName(Copy(tInfo.Decl,8, Length(TypeName)));
        use := KBase.GetTypeUses(PAnsiChar(name));
        idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(name));
        use:=Nil;
        if idx <> -1 then
        begin
          idx := KBase.TypeOffsets[idx].NamId;
          if KBase.GetTypeInfo(idx, [INFO_DUMP], tInfo) then
          begin
            pVal := ValAdr;
            p := strtok(tInfo.Decl, [',','(',')']);
            for n := 0 to size-1 do
            begin
              b := Byte(pVal^);
              for m := 0 to 7 do
              begin
                if (b and (1 shl m))<>0 then
                begin
                  if result <> '' then result:=result + ',';
                  if p<>'' then result:=result + p
                    else result:=result + '$' + Val2Str(n * 8 + m,2);
                end;
                if p<>'' then p := strtok('', [',',')']);
              end;
              Inc(pVal);
            end;
          end;
        end;
      end;
  end;
  if result <> '' then result := '[' + result + ']';
end;

Procedure OutputDecompilerHeader (var f:Text);
Begin
  WriteLn(f,'//********************************************');
  WriteLn(f,'//IDR home page: http://kpnc.org/idr32/en');
  WriteLn(f,'//Decompiled by IDR v',IDRVersion);
  WriteLn(f,'//********************************************');
end;

Procedure AddFieldXref (fInfo:FIELDINFO; ProcAdr:Integer; ProcOfs:Integer; _Type:Char);
var
  recX:PXrefRec;
  F,L,M:Integer;
Begin
  if not Assigned(fInfo.xrefs) then fInfo.xrefs := TList.Create;
  if fInfo.xrefs.Count=0 then
  begin
    New(recX);
    recX._type := _type;
    recX.adr := ProcAdr;
    recX.offset := ProcOfs;
    fInfo.xrefs.Add(recX);
    Exit;
  end;
  F := 0;
  recX := fInfo.xrefs[F];
  if ProcAdr + ProcOfs < recX.adr + recX.offset then
  begin
    New(recX);
    recX._type := _type;
    recX.adr := ProcAdr;
    recX.offset := ProcOfs;
    fInfo.xrefs.Insert(F, recX);
    Exit;
  end;
  L := fInfo.xrefs.Count - 1;
  recX := fInfo.xrefs[L];
  if ProcAdr + ProcOfs > recX.adr + recX.offset then
  begin
    New(recX);
    recX._type := _type;
    recX.adr := ProcAdr;
    recX.offset := ProcOfs;
    fInfo.xrefs.Add(recX);
    Exit;
  end;
  while F < L do
  begin
    M := (F + L) div 2;
    recX := fInfo.xrefs[M];
    if ProcAdr + ProcOfs <= recX.adr + recX.offset then L := M
      else F := M + 1;
  end;
  recX := fInfo.xrefs[L];
  if ProcAdr + ProcOfs <> recX.adr + recX.offset then
  begin
    New(recX);
    recX._type := _type;
    recX.adr := ProcAdr;
    recX.offset := ProcOfs;
    fInfo.xrefs.Insert(L, recX);
  end;
end;

Function ArgsCmpFunction (item1, item2:Pointer):Integer;
Begin
  if PArgInfo(item1).Ndx > PArgInfo(item2).Ndx then Result:=1
  else if PArgInfo(item1).Ndx < PArgInfo(item2).Ndx then Result:=-1
  else Result:=0;
end;

Function ExportsCmpFunction (item1, item2:Pointer):Integer;
Begin
  if PExportNameRec(item1).address > PExportNameRec(item2).address then Result:=1
  else if PExportNameRec(item1).address < PExportNameRec(item2).address then Result:=-1
  else Result:=0;
end;

Function ImportsCmpFunction (item1, item2:Pointer):Integer;
Begin
  if PImportNameRec(item1).address > PImportNameRec(item2).address then Result:=1
  else if PImportNameRec(item1).address < PImportNameRec(item2).address then Result:=-1
  else Result:=0;
end;

Function MethodsCmpFunction (item1, item2:Pointer):Integer;
Begin
  if PMethodRec(item1).kind > PMethodRec(item2).kind then Result:=1
  else if PMethodRec(item1).kind < PMethodRec(item2).kind then Result:=-1
  Else if PMethodRec(item1).id > PMethodRec(item2).id Then Result:=1
  Else if PMethodRec(item1).id < PMethodRec(item2).id Then Result:=-1
  else Result:=0;
end;

Procedure AddPicode (_Pos:Integer; Op:Byte; _Name:AnsiString; Ofs:Integer);
var
  recN:InfoRec;
Begin
  if _Name = '' then Exit;
	recN := GetInfoRec(Pos2Adr(_Pos));
  //if (recN && recN->picode) return;
  if not Assigned(recN) then recN := InfoRec.Create(_Pos, ikUnknown);
  with recN do
  begin
    if not Assigned(Pcode) then New(Pcode);
    Pcode.Op := Op;
    Pcode.Name := _Name;
    Pcode.Offset:=Ofs;
  end;
  //if Op = OP_CALL Then recN.code.Ofs.Address := Ofs
    //else recN.code.Ofs.Offset := Ofs;
end;

Function SortUnitsByAdr (item1, item2:Pointer):Integer;
Begin
  if PUnitRec(item1).toAdr > PUnitRec(item2).toAdr then Result:=1
  else if PUnitRec(item1).toAdr < PUnitRec(item2).toAdr then Result:=-1
  else Result:=0;
end;

Function SortUnitsByOrd (item1, item2:Pointer):Integer;
Begin
  if PUnitRec(item1).iniOrder > PUnitRec(item2).iniOrder then Result:=1
  else if PUnitRec(item1).iniOrder < PUnitRec(item2).iniOrder then Result:=-1
  else Result:=0;
end;

Function SortUnitsByNam (item1, item2:Pointer):Integer;
Var
  name1,name2:AnsiString;
  n:Integer;
Begin
  name1 :='';
  for n := 0 To PUnitRec(item1).names.Count-1 do
  begin
    if n<>0 then name1:=name1 + '+';
    name1:=name1 + PUnitRec(item1).names[n];
  end;
  name2 :='';
  for n := 0 To PUnitRec(item2).names.Count-1 do
  begin
    if n<>0 then name2:=name2 + '+';
    name2:=name2 + PUnitRec(item2).names[n];
  end;
  result := CompareText(name1, name2);
  if result=0 then
    if PUnitRec(item1).toAdr > PUnitRec(item2).toAdr then Result:=1
    else if PUnitRec(item1).toAdr < PUnitRec(item2).toAdr then Result:=-1
    else Result:=0;
end;

Function GetArrayElementType (arrType:AnsiString):AnsiString;
var
  adr,p:Integer;
Begin
  adr := GetOwnTypeAdr(arrType);
  if IsValidImageAdr(adr) and IsFlagSet([cfRTTI], Adr2Pos(adr)) then
  begin
    Result:=GetDynArrayTypeName(adr);
    Exit;
  end;
  p := Pos(' of ',arrType);
  if p<>0 then Result:=Trim(Copy(arrType,p + 4, Length(arrType)))
    else Result:='';
end;

Function GetArrayElementTypeSize (arrType:AnsiString):Integer;
var
  elType:AnsiString;
Begin
  elType := GetArrayElementType(arrType);
  if elType = '' then Result:=0
  else if SameText(elType, 'procedure') then Result:=8
  else Result:=GetTypeSize(elType);
end;

//array [N1..M1,N2..M2,...,NK..MK] of Type
//A:array [N..M] of Size
//A[K]: [A + (K - N1)*Size] = [A - N1*Size + K*Size]
//A:array [N1..M1,N2..M2] of Size <=> array [N1..M1] of array [N2..M2] of Size
//A[K,L]: [A + (K - N1)*Dim2*Size + (L - N2)*Size]
//A:array [N1..M1,N2..M2,N3..M3] of Size <=> array [N1..M1] of array [N2..M2,N3..M3] of Size
//A[K,L,R]: [A + (K - N1)*Dim2*Dim3*Size + (L - N2)*Dim3*Size + (R - M3)*Size]
//A[I1,I2,...,IK]: [A + (I1 - N1L)*S/(N1H - N1L) + (I2 - N2L)*S/(N1H - N1L)*(N2H - N2L) + ... + (IK - NKL)*S/S] (*Size)
Function GetArrayIndexes (arrType:AnsiString; ADim:Integer; Var LowIdx, HighIdx:Integer):Boolean;
var
  c:char;
  p, b:Integer;
  _dim, _val, _pos:Integer;
  _item, _item1, _item2:AnsiString;
Begin
  LowIdx := 1;
  HighIdx := 1;//by default
  p := Pos('[',arrType);
  if p=0 Then
  Begin
    Result:=false;
    Exit;
  end;
  Inc(p);
  b := p;
  _dim := 0;
  while true do
  begin
    c := arrType[p];
    if (c = ',') or (c = ']') then
    begin
      Inc(_dim);
      if _dim = ADim then
      begin
        _item := Trim(Copy(arrType,b,p-b));
        _pos := Pos('..',_item);
        if _pos=0 then LowIdx := 0 //Type
        else
        begin
          _item1 := Copy(_item,1, _pos - 1);
          if TryStrToInt(_item1, _val) then LowIdx := _val
            else LowIdx := 0;//Type
          _item2 := Copy(_item,_pos + 2, Length(_item));
          if TryStrToInt(_item2, _val) then HighIdx := _val
            else HighIdx := 0;//Type
        End;
        Result:=true;
        Exit;
      End;
      if c = ']' then break;
    End;
    Inc(p);
  End;
  Result:=false;
end;

Function GetArraySize (arrType:AnsiString):Integer;
Var
  c:char;
  p,b:Integer;
  {dim,} _val, _pos, _lIdx, _hIdx, elTypeSize:Integer;
  item, item1, item2:AnsiString;
Begin
  Result:=1;
  elTypeSize := GetArrayElementTypeSize(arrType);
  if elTypeSize = 0 then
  Begin
    Result:=0;
    Exit;
  End;
  p := Pos('[',arrType);
  if p=0 Then
  Begin
    Result:=0;
    Exit;
  end;
  Inc(p);
  b := p;
  _lIdx := 0;
  _hIdx := 0;
  //dim := 0;
  while true do
  begin
    c := arrType[p];
    if (c = ',') or (c = ']') then
    begin
      //Inc(dim);
      item := Trim(Copy(arrType,b,p-b));
      _pos := Pos('..',item);
      if _pos=0 then _lIdx := 0 //Type
      else
      begin
        item1 := Copy(item,1, _pos - 1);
        if TryStrToInt(item1, _val) then _lIdx := _val
          else _lIdx := 0; //Type
        item2 := Copy(item,_pos + 2, Length(item));
        if TryStrToInt(item2, _val) then _hIdx := _val
          else _hIdx := 0; //Type
      End;
      if _hIdx < _lIdx Then
      Begin
        Result:=0;
        Exit;
      end;
      result:=result * (_hIdx - _lIdx + 1);
      if c = ']' then
      begin
        result:=result * elTypeSize;
        break;
      end;
      b := p + 1;
    end;
    Inc(p);
  End;
end;


Function GetArrayElement(arrType:AnsiString; offset:Integer):AnsiString;
var
  arrSize{, elTypeSize}:Integer;
  p,b:Integer;
  c:Char;
  {dim,} _val, _pos, lIdx, hIdx:Integer;
  item, item1, item2:AnsiString;
begin
  Result:='';
  arrSize := GetArraySize(arrType);
  if arrSize = 0 then Exit;
  //elTypeSize := GetArrayElementTypeSize(arrType);
  p := Pos('[',arrType);
  if p=0 Then Exit;
  Inc(p);
  b := p;
  //dim := 0;
  while true do
  begin
    c := arrType[p];
    if (c = ',') or (c = ']') then
    begin
      //Inc(dim);
      item := Trim(Copy(arrType,b,p-b));
      _pos := Pos('..',item);
      if _pos=0 then lIdx := 0 //Type
      else
      begin
        item1 := Copy(item,1, _pos - 1);
        if TryStrToInt(item1, _val) then lIdx := _val
          else lIdx := 0; //Type
        item2 := Copy(item,_pos + 2, Length(item));
        if TryStrToInt(item2, _val) then hIdx := _val
          else hIdx := 0; //Type
      End;
      if hIdx - lIdx + 1 <= 0 then Exit;
      if offset > arrSize / (hIdx - lIdx + 1) then
      begin

      end;
      if c = ']' then
      begin
        //result:=result * _elTypeSize;
        break;
      end;
      b := p + 1;
    End;
    Inc(p);
  end;
end;

Procedure Copy2Clipboard (items:TStrings; leftMargin:Integer; asmCode:Boolean);
Const
  CRLF:AnsiString = #13+#10;
Var
  n,BufLen:Integer;
  line:AnsiString;
  buf:TMemoryStream;
Begin
  bufLen := 0;
  Screen.Cursor := crHourGlass;
  try
    for n := 0 to items.Count-1 do
      Inc(bufLen, Length(items[n]) + 2);
    //Последний символ должен быть 0
    Inc(bufLen);
    buf:=TMemoryStream.Create;
    try
      buf.Size:=BufLen;
      buf.Position:=0;
      Clipboard.Open;
      //Запихиваем все данные в буфер
      for n := 0 to items.Count-1 do
      begin
        line := Copy(items[n],leftMargin+1,2000);
        buf.Write(line[1],Length(line)-Ord(asmCode));
        buf.Write(CRLF[1],2);
      End;
      n:=0;
      buf.Write(n,1);
      Clipboard.SetTextBuf(buf.Memory);
      Clipboard.Close;
    Finally
      buf.Free;
    end;
  Finally
    Screen.Cursor := crDefault;
  end;
end;

Function GetModuleVersion (Const module:AnsiString):AnsiString;
Var
  Size  :Cardinal;
  Buf   :Pointer;
  VerPtr:PVSFixedFileInfo;
  VerLen:Cardinal;
  v1,v2,v3,v4:Word;
Begin
  result:='';
  Size:=GetFileVersionInfoSize(PChar(module), Size);
  if Size > 0 then
  Begin
    GetMem(Buf,Size);
    GetFileVersionInfo(PChar(module), 0, Size, Buf);
		// get file version
    if VerQueryValue(Buf, '\', Pointer(VerPtr), VerLen) then
    Begin
      v1:=VerPtr^.dwFileVersionMS shr 16;
      v2:=VerPtr^.dwFileVersionMS and $FFFF;
      v3:=VerPtr^.dwFileVersionLS shr 16;
      v4:=VerPtr^.dwFileVersionLS and $FFFF;
      Result:=Format('%d.%d.%d.%d',[v1,v2,v3,v4]);
    end;
    FreeMem(Buf,Size);
  End;
end;

Function IsSameRegister (Idx1, Idx2:Integer):Boolean;
Begin
  Result:=IdxToIdx32Tab[Idx1] = IdxToIdx32Tab[Idx2];
end;

//Is register al, ah, ax, eax, dl, dh, dx, edx, cl, ch, cx, ecx
Function IsADC (Idx:Integer):Boolean;
var
  i:Integer;
Begin
  i := IdxToIdx32Tab[Idx];
  Result:= i in [16..18];
end;

Function IsAnalyzedAdr(Adr:Integer):Boolean;
var
  n:Integer;
  segInfo:PSegmentInfo;
begin
  Result:=False;
  for n := 0 to SegmentList.Count-1 do
  begin
    segInfo := SegmentList[n];
    if (segInfo.Start <= Adr) and (Adr < segInfo.Start + segInfo.Size) then
    begin
      if (segInfo.Flags and IMAGE_SCN_MEM_PRELOAD)=0 then Result:=true;
      break;
    End;
  End;
End;

Function GetLastLocPos (fromAdr:Integer):Integer;
Begin
  Result := Adr2Pos(fromAdr);
  while True do
  begin
    if IsFlagSet([cfLoc], Result) Then Exit;
    Dec(Result);
  End;
end;

Function IsDefaultName (AName:AnsiString):Boolean;
var
  idx:Integer;
  str:AnsiString;
Begin
  Result:=False;
  for Idx := 0 to 7 do
    if SameText(AName, '_' + Reg32Tab[Idx] + '_') Then
    Begin
      Result:=true;
      Exit;
    end;
  str:=Copy(AName,1, 5);
  if SameText(str, 'lvar_') or SameText(str, 'gvar_') then Result:=true;
end;

function FloatNameToFloatType(AName:AnsiString): TFloatKind;
Begin
  if SameText(AName, 'Single') then Result:=FT_SINGLE
  else if SameText(AName, 'Double') then REsult:=FT_DOUBLE
  else if SameText(AName, 'Extended') then result:=FT_EXTENDED
  else if SameText(AName, 'Real') then Result:=FT_REAL
  else if SameText(AName, 'Comp') then result:=FT_COMP
  else Result:=TFloatKind(-1);
end;

Function InputDialogExec (caption, labelText, text:AnsiString):AnsiString;
Begin
  REsult:='';
  FInputDlg.Caption := caption;
  FInputDlg.edtName.EditLabel.Caption := labelText;
  FInputDlg.edtName.Text := text;
  while result ='' do
  begin
    if FInputDlg.ShowModal = mrCancel then break;
    result := Trim(FInputDlg.edtName.Text);
  end;
end;

Function ManualInput (procAdr, curAdr:Integer; caption, labelText:AnsiString):AnsiString;
Begin
  result :='';
  FMain.ShowCode(procAdr, curAdr, FMain.lbCXrefs.ItemIndex, -1);
  FInputDlg.Caption := caption;
  FInputDlg.edtName.EditLabel.Caption := labelText;
  FInputDlg.edtName.Text := '';
  while result = '' do
  begin
    if FInputDlg.ShowModal = mrCancel then break;
    result := Trim(FInputDlg.edtName.Text);
  end;
end;

Procedure SaveCanvas (ACanvas:TCanvas);
Begin
  SavedPenColor   := ACanvas.Pen.Color;
  SavedBrushColor := ACanvas.Brush.Color;
  SavedFontColor  := ACanvas.Font.Color;
  SavedBrushStyle := ACanvas.Brush.Style;
end;

Procedure RestoreCanvas (ACanvas:TCanvas);
Begin
  ACanvas.Pen.Color   := SavedPenColor;
  ACanvas.Brush.Color := SavedBrushColor;
  ACanvas.Font.Color  := SavedFontColor;
  ACanvas.Brush.Style := SavedBrushStyle;
end;

Procedure DrawOneItem (AItem:AnsiString; ACanvas:TCanvas; var ARect:TRect; AColor:TColor; flags:Integer);
var
  r:TRect;
Begin
  SaveCanvas(ACanvas);
  ARect.Left := ARect.Right;
  ARect.Right:=ARect.Right + ACanvas.TextWidth(AItem);
  r := Rect(ARect.Left -1, ARect.Top, ARect.Right, ARect.Bottom - 1);
  if SameText(AItem, SelectedAsmItem) then
  begin
    ACanvas.Brush.Color := TColor($80DDFF); // orange
    ACanvas.Brush.Style := bsSolid;
    ACanvas.FillRect(R);
    ACanvas.Brush.Style := bsClear;
    ACanvas.Pen.Color := TColor($226DA8); // brown
    ACanvas.Rectangle(R);
  End;
  ACanvas.Font.Color := AColor;
  ACanvas.TextOut(ARect.Left, ARect.Top, AItem);
  RestoreCanvas(ACanvas);
end;

Function OutputHex(v:Integer;sign:Boolean;dig:Integer=0):AnsiString;
begin
  if sign then
  begin
    if (v>=-9) and (v<=9) then
    begin
      if v<0 then Result:=IntToStr(v)
        else Result:='+'+IntToStr(v);
    end
    else
    begin
      if v<0 then Result:='-$'+IntToHex(-v,dig)
        else Result:='+$'+IntToHex(v,dig);
    end;
  end
  else
  begin
    if v in [0..9] then Result:=IntToStr(v)
      else Result:='$'+IntToHex(v,dig);
  end;
end;

Initialization
  IDRVersion:=GetModuleVersion(Application.ExeName);

end.
