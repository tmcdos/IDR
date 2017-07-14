Unit IDCGen;

Interface

Uses Windows,Messages,Classes,Def_main,Infos,Dialogs;

Type
  TIDCGen = class
  public
    idcF:TFileStream;
    unitName:AnsiString;
    itemName:AnsiString;
    names:TStringList;
    repeated:TList;
    SplitSize:Integer; // Maximum output bytes if IDC splitted
    CurrentPartNo:Integer; // current part number (filename looks like XXX_NN.idc)
    CurrentBytes:Integer; // current part output bytes
    constructor Create(f:TFileStream;AsplitSize:Integer);
    Destructor Destroy; Override;
    procedure NewIDCPart(f:TFileStream);
    Procedure DeleteName(_pos:Integer);
    Function MakeByte(_pos:Integer):Integer;
    Function MakeWord(_pos:Integer):Integer;
    Function MakeDword(_pos:Integer):Integer;
    Function MakeQword(_pos:Integer):Integer;
    Function MakeArray(_pos:Integer; num:Integer):Integer;
    Function MakeShortString(_pos:Integer):Integer;
    Function MakeCString(_pos:Integer):Integer;
    Procedure MakeLString(_pos:Integer);
    Procedure MakeWString(_pos:Integer);
    Procedure MakeUString(_pos:Integer);
    Function MakeCode(_pos:Integer):Integer;
    Procedure MakeFunction(adr:Integer);
    Procedure MakeComment(_pos:Integer; text:AnsiString);
    Function OutputAttrData(_pos:Integer):Integer;
    Procedure OutputHeaderFull;
    Procedure OutputHeaderShort;
    Function OutputRTTIHeader(kind:LKind; _pos:Integer):Integer;
    Procedure OutputRTTIInteger(kind:LKind; _pos:Integer);
    Procedure OutputRTTIChar(kind:LKind; _pos:Integer);
    Procedure OutputRTTIEnumeration(kind:LKind; _pos:Integer; adr:Integer);
    Procedure OutputRTTIFloat(kind:LKind; _pos:Integer);
    Procedure OutputRTTIString(kind:LKind; _pos:Integer);
    Procedure OutputRTTISet(kind:LKind; _pos:Integer);
    Procedure OutputRTTIClass(kind:LKind; _pos:Integer);
    Procedure OutputRTTIMethod(kind:LKind; _pos:Integer);
    Procedure OutputRTTIWChar(kind:LKind; _pos:Integer);
    Procedure OutputRTTILString(kind:LKind; _pos:Integer);
    Procedure OutputRTTIWString(kind:LKind; _pos:Integer);
    Procedure OutputRTTIVariant(kind:LKind; _pos:Integer);
    Procedure OutputRTTIArray(kind:LKind; _pos:Integer);
    procedure OutputRTTIRecord(kind:LKind; _pos:Integer);
    procedure OutputRTTIInterface(kind:LKind; _pos:Integer);
    procedure OutputRTTIInt64(kind:LKind; _pos:Integer);
    procedure OutputRTTIDynArray(kind:LKind; _pos:Integer);
    procedure OutputRTTIUString(kind:LKind; _pos:Integer);
    procedure OutputRTTIClassRef(kind:LKind; _pos:Integer);
    procedure OutputRTTIPointer(kind:LKind; _pos:Integer);
    procedure OutputRTTIProcedure(kind:LKind; _pos:Integer);
    procedure OutputVMT(_pos:Integer; recN:InfoRec);
    Function OutputVMTHeader(_pos:Integer; vmtName:AnsiString):Integer;
    procedure OutputIntfTable(_pos:Integer);
    procedure OutputIntfVTable(_pos:Integer; stopAdr:Integer);
    procedure OutputAutoTable(_pos:Integer);
    procedure OutputAutoPTable(_pos:Integer);
    procedure OutputInitTable(_pos:Integer);
    procedure OutputFieldTable(_pos:Integer);
    procedure OutputFieldTTable(_pos:Integer);
    procedure OutputMethodTable(_pos:Integer);
    procedure OutputVmtMethodEntry(_pos:Integer);
    Function OutputVmtMethodEntryTail(_pos:Integer):Integer;
    procedure OutputDynamicTable(_pos:Integer);
    procedure OutputResString(_pos:Integer; recN:InfoRec);
    Function OutputProc(_pos:Integer; recN:InfoRec; imp:Boolean):Integer;
    procedure OutputData(_pos:Integer; recN:InfoRec);
    Function GetNameInfo(idx:Integer):PRepNameInfo;
  end;

  TSaveIDCDialog = class(TOpenDialog)
    Constructor Create(AOwner:TComponent);
    procedure WndProc(var Msg:TMessage); Override;
  end;

Implementation

Uses Misc,SysUtils,Main,Def_disasm;

Const
  chkSplit_ID = 101;

constructor TIDCGen.Create(f:TFileStream;AsplitSize:Integer);
Begin
  idcF:=f;
  names:=TStringList.Create;
  repeated:=TList.Create;
  splitSize:=AsplitSize;
  CurrentPartNo:=1;
  CurrentBytes:=0;
end;

Destructor TIDCGen.Destroy;
Begin
  names.Free;
  repeated.Free;
  inherited;
end;

procedure TIDCGen.NewIDCPart(f:TFileStream);
Begin
  idcF:=f;
  CurrentBytes:=0;
  Inc(CurrentPartNo);
end;

Procedure TIDCGen.DeleteName (_pos:Integer);
var
  adr:Integer;
  s:AnsiString;
Begin
  adr := Pos2Adr(_pos);
  s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "", 0);'+#13,[adr,adr]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
end;

Function TIDCGen.MakeByte (_pos:Integer):Integer;
var
  s:AnsiString;
Begin
  s:=Format('MakeByte(0x%x);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  Result:=_pos + 1;
end;

Function TIDCGen.MakeWord (_pos:Integer):Integer;
var
  s:AnsiString;
Begin
  s:=Format('MakeWord(0x%x);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  Result:=_pos + 2;
end;

Function TIDCGen.MakeDword (_pos:Integer):Integer;
var
  s:AnsiString;
Begin
  s:=Format('MakeDword(0x%x);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  Result:=_pos + 4;
end;

Function TIDCGen.MakeQword (_pos:Integer):Integer;
var
  s:AnsiString;
Begin
  s:=Format('MakeQword(0x%x);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  Result:=_pos + 8;
end;

Function TIDCGen.MakeArray (_pos:Integer; num:Integer):Integer;
Var
  s:AnsiString;
  adr:Integer;
Begin
  adr:=Pos2Adr(_pos);
  s:=Format('MakeByte(0x%x);'+#13+'MakeArray(0x%x, %d);'+#13,[adr,adr,num]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  Result:=_pos + num;
end;

Function TIDCGen.MakeShortString (_pos:Integer):Integer;
var
  adr:Integer;
  s:AnsiString;
  len:Byte;
Begin
  len := Byte(Code[_pos]);
  //Empty String
  if len=0 then Result:=_pos + 1
  Else if Not IsValidName(len, _pos + 1) Then Result:=_pos
  Else
  begin
    adr:=Pos2Adr(_pos);
    s:=Format('SetLongPrm(INF_STRTYPE, ASCSTR_PASCAL);'+#13+'MakeStr(0x%x, 0x%x);'+#13,[adr,adr+len+1]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    Result:=_pos + len + 1;
  End;
end;

Function TIDCGen.MakeCString (_pos:Integer):Integer;
var
  len:Integer;
  s:AnsiString;
  adr:Integer;
Begin
  adr:=Pos2Adr(_pos);
  len:=StrLen(Code + _pos);
  s:=Format('SetLongPrm(INF_STRTYPE, ASCSTR_TERMCHR);'+#13+'MakeStr(0x%x, 0x%x);'+#13,[adr,adr+len+1]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  Result:=_pos + len + 1;
end;

Procedure TIDCGen.MakeLString (_pos:Integer);
var
  s:AnsiString;
Begin
  s:=Format('SetLongPrm(INF_STRTYPE, ASCSTR_TERMCHR);'+#13+'MakeStr(0x%x, -1);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  //Length
  MakeDword(_pos - 4);
  //RefCount
  MakeDword(_pos - 8);
end;

Procedure TIDCGen.MakeWString (_pos:Integer);
var
  s:AnsiString;
Begin
  s:=Format('SetLongPrm(INF_STRTYPE, ASCSTR_UNICODE);'+#13+'MakeStr(0x%x, -1);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  //Length
  MakeDword(_pos - 4);
end;

Procedure TIDCGen.MakeUString (_pos:Integer);
var
  s:AnsiString;
Begin
  s:=Format('SetLongPrm(INF_STRTYPE, ASCSTR_UNICODE);'+#13+'MakeStr(0x%x, -1);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  //Length
  MakeDword(_pos - 4);
  //RefCount
  MakeDword(_pos - 8);
  //Word
  MakeWord(_pos - 10);
  //CodePage
  MakeWord(_pos - 12);
end;

Function TIDCGen.MakeCode (_pos:Integer):Integer;
var
  s:AnsiString;
Begin
  s:=Format('MakeCode(0x%x);'+#13,[Pos2Adr(_pos)]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  Result := frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos),Nil, Nil);
  if Result=0 then Result := 1;
end;

Procedure TIDCGen.MakeFunction (adr:Integer);
var
  s:AnsiString;
Begin
  If adr<>0 then
  Begin
    s:=Format('MakeFunction(0x%x, -1);'+#13,[adr]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    MakeCode(Adr2Pos(adr));
  end;
end;

Procedure TIDCGen.MakeComment (_pos:Integer; text:AnsiString);
Var
  s:AnsiString;
Begin
  s:=Format('MakeComm(0x%x, "%s");'+#13,[Pos2Adr(_pos), text]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
end;

Function TIDCGen.OutputAttrData (_pos:Integer):Integer;
var
  dw:Word;
Begin
  dw:=PWord(Code + _pos)^;
  _pos:=MakeWord(_pos);
  Result:=_pos;
end;

Procedure TIDCGen.OutputHeaderFull;
var
  s:AnsiString;
Begin
  s:=Format('#include <idc.idc>'+#13
    +'static clear(from){'+#13
    +'auto ea;'+#13
    +'ea = from;'+#13
    +'while (1){'+#13
    +'ea = NextFunction(ea);'+#13
    +'if (ea == -1) break;'+#13
    +'DelFunction(ea);'+#13
    +'MakeNameEx(ea, "", 0);}'+#13
    +'ea = from;'+#13
    +'while (1){'+#13
    +'ea = FindExplored(ea, SEARCH_DOWN | SEARCH_NEXT);'+#13
    +'if (ea == -1) break;'+#13
    +'MakeUnkn(ea, 1);}'+#13
    +'}'+#13
    +'static main(){'+#13
    +'clear(0x%lX);'
    ,[CodeBase]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
end;

procedure TIDCGen.OutputHeaderShort;
var
  s:AnsiString;
Begin
  s:='#include <idc.idc>'+#13+'static main(){'+#13;
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
end;

function TIDCGen.OutputRTTIHeader(kind:LKind; _pos:Integer): Integer;
var
  s:AnsiString;
  from,adr:Integer;
  len:Byte;
Begin
  from:=_pos;
  len := Byte(Code[_pos + 5]);
  SetLength(itemName,len);
  StrLCopy(PAnsiChar(itemName),Code + _pos + 6, len);
  adr := Pos2Adr(_pos);
  s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "RTTI_%x_%s_%s", 0);',[adr,adr,adr,TypeKind2Name(kind),itemName]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  //Selfptr
  _pos := MakeDword(_pos);
  //Kind
  //Delete name (often presents)
  DeleteName(_pos);
  _pos := MakeByte(_pos);
  //Name
  _pos := MakeShortString(_pos);
  result:= _pos - from;
end;

procedure TIDCGen.OutputRTTIInteger(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos+OutputRTTIHeader(kind,_pos);
  //ordType
  _pos := MakeByte(_pos);
  //minValue
  _pos := MakeDword(_pos);
  //maxValue
  _pos := MakeDword(_pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIChar(kind:LKind; _pos:Integer);
Begin
  _pos :=_pos + OutputRTTIHeader(kind, _pos);
  //ordType
  _pos := MakeByte(_pos);
  //minValue
  _pos := MakeDword(_pos);
  //maxValue
  _pos := MakeDword(_pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIEnumeration(kind:LKind; _pos:Integer; adr:Integer);
var
  n,minValue,maxValue,baseTypeAdr:Integer;
Begin
  _pos :=_pos+ OutputRTTIHeader(kind, _pos);
  //ordType
  _pos := MakeByte(_pos);
  //minValue
  minValue := PInteger(Code + _pos)^;
  _pos := MakeDword(_pos);
  //maxValue
  maxValue := PInteger(Code + _pos)^;
  _pos := MakeDword(_pos);
  //baseTypeAdr
  baseTypeAdr := PInteger(Code + _pos)^;
  _pos := MakeDword(_pos);
  if baseTypeAdr = adr then
  begin
    if SameText(itemName, 'ByteBool') or
       SameText(itemName, 'WordBool') or
       SameText(itemName, 'LongBool') then
    begin
      minValue := 0;
      maxValue := 1;
    End;
    for n := minValue to maxValue do
      _pos := MakeShortString(_pos);
  End;
  //UnitName
  //_pos := MakeShortString(_pos);
  //if DelphiVersion = 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIFloat(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //FloatType
  _pos := MakeByte(_pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIString(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //MaxLength
  _pos := MakeByte(_pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTISet(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //OrdType
  _pos := MakeByte(_pos);
  //CompType
  _pos := MakeDword(_pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIClass(kind:LKind; _pos:Integer);
var
  count:Word;
  n,m,TypeInfo:Integer;
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //classVMT
  _pos := MakeDword(_pos);
  //ParentInfo
  _pos := MakeDword(_pos);
  //PropCount
  _pos := MakeWord(_pos);
  //UnitName
  _pos := MakeShortString(_pos);
  //PropData
  Count := PWord(Code + _pos)^;
  _pos := MakeWord(_pos);
  for n := 1 to Count do
  begin
    //TPropInfo
    for m := 0 to 5 do _pos := MakeDword(_pos);
    _pos := MakeWord(_pos);
    _pos := MakeShortString(_pos);
  end;
  if DelphiVersion >= 2010 then
  begin
    //PropDataEx
    Count := PWord(Code + _pos)^;
    _pos := MakeWord(_pos);
    for n := 1 To count do
    begin
      //Flags
      _pos := MakeByte(_pos);
      //Info
      typeInfo := PInteger(Code + _pos)^;
      _pos := MakeDword(_pos);
      for m := 0 to 5 do
      begin
        MakeDword(Adr2pos(typeInfo));
        Inc(typeInfo, 4);
      end;
      MakeWord(Adr2pos(typeInfo));
      Inc(typeInfo, 2);
      MakeShortString(Adr2pos(typeInfo));
      //AttrData
      _pos := OutputAttrData(_pos);
    End;
    //AttrData
    OutputAttrData(_pos);
  End;
end;

procedure TIDCGen.OutputRTTIMethod(kind:LKind; _pos:Integer);
Var
  pos1,pos2:Integer;
  MethodKind,ParamCnt,flags:Byte;
  n,procSig:Integer;
Begin
  pos1:=_pos;
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //MethodKind
  methodKind := Byte(Code[_pos]);
  _pos := MakeByte(_pos);
  //ParamCnt
  paramCnt := Byte(Code[_pos]);
  _pos := MakeByte(_pos);
  for n := 1 to paramCnt do
  begin
    //Flags
    _pos := MakeByte(_pos);
    //ParamName
    _pos := MakeShortString(_pos);
    //TypeName
    _pos := MakeShortString(_pos);
  end;
  if methodKind<>0 then
  begin
    //ResultType
    _pos := MakeShortString(_pos);
    if DelphiVersion > 6 then
    begin
      //ResultTypeRef
      _pos := MakeDword(_pos);
    End;
  end;
  if DelphiVersion > 6 then
  begin
    //CC (TCallConv)
    _pos := MakeByte(_pos);
    //ParamTypeRefs
    for n := 1 to paramCnt do
      _pos := MakeDword(_pos);
    if DelphiVersion >= 2010 then
    begin
      procSig := PInteger(Code + _pos)^;
      //MethSig
      _pos := MakeDword(_pos);
      //AttrData
      OutputAttrData(_pos);
      //Procedure Signature
      if procSig<>0 then
      begin
        if IsValidImageAdr(procSig) then pos2 := Adr2Pos(procSig)
          else pos2 := pos1 + procSig;
        //Flags
        flags := Byte(Code[pos2]);
        pos2 := MakeByte(pos2);
        if flags <> 255 then
        begin
          //CC
          pos2 := MakeByte(pos2);
          //ResultType
          pos2 := MakeDword(pos2);
          //ParamCount
          paramCnt := Byte(Code[pos2]);
          pos2 := MakeByte(pos2);
          for n := 1 to paramCnt do
          begin
            //Flags
            pos2 := MakeByte(pos2);
            //ParamType
            pos2 := MakeDword(pos2);
            //Name
            pos2 := MakeShortString(pos2);
            //AttrData
            pos2 := OutputAttrData(pos2);
          End;
        end;
      end;
    end;
  End;
end;

procedure TIDCGen.OutputRTTIWChar(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //ordType
  _pos := MakeByte(_pos);
  //minValue
  _pos := MakeDword(_pos);
  //maxValue
  _pos := MakeDword(_pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTILString(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  if DelphiVersion >= 2009 then
  begin
    //CodePage
    _pos := MakeWord(_pos);
  End;
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIWString(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIVariant(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIArray(kind:LKind; _pos:Integer);
var
  dim,n:Integer;
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //Size
  _pos := MakeDword(_pos);
  //ElCount
  _pos := MakeDword(_pos);
  //ElType
  _pos := MakeDword(_pos);
  if DelphiVersion >= 2010 then
  begin
    //DimCount
    dim := Byte(Code[_pos]);
    _pos := MakeByte(_pos);
    for n := 1 to dim do
    begin
      //Dims
      _pos := MakeDword(_pos);
    End;
    //AttrData
    OutputAttrData(_pos);
  End;
end;

procedure TIDCGen.OutputRTTIRecord(kind:LKind; _pos:Integer);
Var
  n, m, elNum:Integer;
  metCnt:Word;
  numOp,flags,paramCnt:Byte;
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //Size
  _pos := MakeDword(_pos);
  //ManagedFldCount
  elNum := PInteger(Code + _pos)^;
  _pos := MakeDword(_pos);
  for n := 1 to elNum do
  begin
    //TypeRef
    _pos := MakeDword(_pos);
    //FldOffset
    _pos := MakeDword(_pos);
  End;
  if DelphiVersion >= 2010 then
  begin
    //NumOps
    numOp := Byte(Code[_pos]);
    _pos := MakeByte(_pos);
    for n := 1 to numOp do //RecOps
      _pos := MakeDword(_pos);
    //RecFldCnt
    elNum := PInteger(Code + _pos)^;
    _pos := MakeDword(_pos);
    for n := 1 to elNum do
    begin
      //TypeRef
      _pos := MakeDword(_pos);
      //FldOffset
      _pos := MakeDword(_pos);
      //Flags
      _pos := MakeByte(_pos);
      //Name
      _pos := MakeShortString(_pos);
      //AttrData
      _pos := OutputAttrData(_pos);
    End;
    //AttrData
    _pos := OutputAttrData(_pos);
    if DelphiVersion >= 2012 then
    begin
      metCnt := PWord(Code + _pos)^;
      _pos := MakeWord(_pos);
      for n := 1 to metCnt do
      begin
        //Flags
        _pos := MakeByte(_pos);
        //Code
        _pos := MakeDword(_pos);
        //Name
        _pos := MakeShortString(_pos);
        //ProcedureSignature
        //Flags
        flags := Byte(Code[_pos]);
        _pos := MakeByte(_pos);
        if flags <> 255 then
        begin
          //CC
          _pos := MakeByte(_pos);
          //ResultType
          _pos := MakeDword(_pos);
          paramCnt := Byte(Code[_pos]);
          _pos := MakeByte(_pos);
          //Params
          for m := 1 to paramCnt do
          begin
            //Flags
            _pos := MakeByte(_pos);
            //ParamType
            _pos := MakeDword(_pos);
            //Name
            _pos := MakeShortString(_pos);
            //AttrData
            _pos := OutputAttrData(_pos);
          end;
        End;
        //AttrData
        _pos := OutputAttrData(_pos);
      end;
    End;
  end;
end;

procedure TIDCGen.OutputRTTIInterface(kind:LKind; _pos:Integer);
Var
  count,dw:Word;
  n,m:Integer;
  methodKind,paramCnt,len:Byte;
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //IntfParent
  _pos := MakeDword(_pos);
  //IntfFlags
  _pos := MakeByte(_pos);
  //GUID
  _pos := MakeArray(_pos, 16);
  //UnitName
  _pos := MakeShortString(_pos);
  //PropCount
  Count := PWORD(Code + _pos)^;
  _pos := MakeWord(_pos);
  if DelphiVersion >= 6 then
  begin
    //RttiCount
    dw := PWORD(Code + _pos)^;
    _pos := MakeWord(_pos);
    if dw <> $FFFF then
    begin
      if DelphiVersion >= 2010 then
      begin
        for n := 1 To Count do
        begin
          //Name
          _pos := MakeShortString(_pos);
          //Kind
          methodKind := Byte(Code[_pos]);
          _pos := MakeByte(_pos);
          //CallConv
          _pos := MakeByte(_pos);
          //ParamCount
          paramCnt := Byte(Code[_pos]);
          _pos := MakeByte(_pos);
          for m := 1 to paramCnt do
          begin
            //Flags
            _pos := MakeByte(_pos);
            //ParamName
            _pos := MakeShortString(_pos);
            //TypeName
            _pos := MakeShortString(_pos);
            //ParamType
            _pos := MakeDword(_pos);
          End;
          if methodKind<>0 then
          begin
            //ResultTypeName
            len := Byte(Code[_pos]);
            _pos := MakeShortString(_pos);
            if len<>0 then
            begin
              //ResultType
              _pos := MakeDword(_pos);
            End;
          end;
        End;
      end
      else
      begin
        for n := 1 to Count do
        begin
          //PropType
          _pos := MakeDword(_pos);
          //GetProc
          _pos := MakeDword(_pos);
          //SetProc
          _pos := MakeDword(_pos);
          //StoredProc
          _pos := MakeDword(_pos);
          //Index
          _pos := MakeDword(_pos);
          //Default
          _pos := MakeDword(_pos);
          //NameIndex
          _pos := MakeWord(_pos);
          //Name
          _pos := MakeShortString(_pos);
        End;
      End;
    End;
    if DelphiVersion >= 2010 then
    begin
      //AttrData
      OutputAttrData(_pos);
    End;
  End;
end;

procedure TIDCGen.OutputRTTIInt64(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //MinVal
  _pos := MakeQword(_pos);
  //MaxVal
  _pos := MakeQword(_pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIDynArray(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //elSize
  _pos := MakeDword(_pos);
  //elType
  _pos := MakeDword(_pos);
  //varType
  _pos := MakeDword(_pos);
  if DelphiVersion >= 6 then
  begin
    //elType2
    _pos := MakeDword(_pos);
    //UnitName
    _pos := MakeShortString(_pos);
  end;
  if DelphiVersion >= 2010 then
  begin
    //DynArrElType
    _pos := MakeDword(_pos);
    //AttrData
    OutputAttrData(_pos);
  end;
end;

procedure TIDCGen.OutputRTTIUString(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  if DelphiVersion >= 2010 then OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIClassRef(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //InstanceType
  _pos := MakeDword(_pos);
  //AttrData
  OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIPointer(kind:LKind; _pos:Integer);
Begin
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //RefType
  _pos := MakeDword(_pos);
  //AttrData
  OutputAttrData(_pos);
end;

procedure TIDCGen.OutputRTTIProcedure(kind:LKind; _pos:Integer);
Var
  pos1,procSig,n:Integer;
  flags,paramCnt:Byte;
Begin
  pos1:=_pos;
  _pos:=_pos + OutputRTTIHeader(kind, _pos);
  //MethSig
  procSig := PInteger(Code + _pos)^;
  _pos := MakeDword(_pos);
  //AttrData
  _pos := OutputAttrData(_pos);
  //Procedure Signature
  if procSig<>0 then
  begin
    if IsValidImageAdr(procSig) then _pos := Adr2pos(procSig)
      else _pos := pos1 + procSig;
    //Flags
    flags := Byte(Code[_pos]);
    _pos := MakeByte(_pos);
    if flags <> 255 then
    begin
      //CallConv
      _pos := MakeByte(_pos);
      //ResultType
      _pos := MakeDword(_pos);
      //ParamCnt
      paramCnt := Byte(Code[_pos]);
      _pos := MakeByte(_pos);
      for n:=1 to paramCnt do
      begin
        //Flags
        _pos := MakeByte(_pos);
        //ParamType
        _pos := MakeDword(_pos);
        //Name
        _pos := MakeShortString(_pos);
        //AttrData
        _pos := OutputAttrData(_pos);
      end;
    end;
  end;
end;

Procedure TIDCGen.OutputVMT (_pos:Integer; recN:InfoRec);
var
  nameAdr,stop,ofs:Integer;
Begin
  itemName := recN.Name;
  _pos:=_pos + OutputVMTHeader(_pos, itemName);
  if DelphiVersion >= 3 then
  begin
    //VmtIntfTable
    OutputIntfTable(_pos);
    Inc(_pos, 4);
    //VmtAutoTable
    OutputAutoTable(_pos);
    Inc(_pos, 4);
  end;
  //VmtInitTable
  OutputInitTable(_pos);
  Inc(_pos, 4);
  //VmtTypeInfo
  _pos := MakeDword(_pos);
  //VmtFieldTable
  OutputFieldTable(_pos);
  Inc(_pos, 4);
  //VmtMethodTable
  OutputMethodTable(_pos);
  Inc(_pos, 4);
  //VmtDynamicTable
  OutputDynamicTable(_pos);
  Inc(_pos, 4);
  //VmtClassName
  nameAdr := PInteger(Code + _pos)^;
  _pos := MakeDword(_pos);
  MakeShortString(Adr2pos(nameAdr));
  //VmtInstanceSize
  _pos := MakeDword(_pos);
  //VmtParent
  _pos := MakeDword(_pos);
  if DelphiVersion >= 2009 then
  begin
    //VmtEquals
    _pos := MakeDword(_pos);
    //VmtGetHashCode
    _pos := MakeDword(_pos);
    //VmtToString
    _pos := MakeDword(_pos);
  end;
  if DelphiVersion >= 3 then
  begin
    //VmtSafeCallException
    _pos := MakeDword(_pos);
  end;
  if DelphiVersion >= 4 then
  begin
    //VmtAfterConstruction
    _pos := MakeDword(_pos);
    //VmtBeforeDestruction
    _pos := MakeDword(_pos);
    //VmtDispatch
    _pos := MakeDword(_pos);
  end;
  //VmtDefaultHandler
  _pos := MakeDword(_pos);
  //VmtNewInstance
  _pos := MakeDword(_pos);
  //VmtFreeInstance
  _pos := MakeDword(_pos);
  //VmtDestroy
  _pos := MakeDword(_pos);
  //Vmt
  stop := Adr2pos(GetStopAt(pos2Adr(_pos)));
  //Virtual Methods
  ofs := 0;
  while _pos < stop do
  begin
    MakeComment(_pos, '+' + Val2Str(ofs));
    Inc(ofs, 4);
    _pos := MakeDword(_pos);
  end;
end;

Function TIDCGen.OutputVMTHeader (_pos:Integer; vmtName:AnsiString):Integer;
var
  from,adr:Integer;
  s:AnsiString;
Begin
  from := _pos;
  adr := pos2Adr(_pos);
  s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "VMT_%x_%s", 0);'+#13,[adr,adr,adr,vmtName]);
  idcF.Write(s[1],Length(s));
  Inc(CurrentBytes,Length(s));
  //VmtSelfPtr
  _pos := MakeDword(_pos);
  Result:= _pos - from;
end;

Procedure TIDCGen.OutputIntfTable (_pos:Integer);
var
  intfTable,Count,n:Integer;
  s:AnsiString;
Begin
  MakeDword(_pos);
  intfTable := PInteger(Code + _pos)^;
  if intfTable<>0 then
  begin
    s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s_IntfTable", 0);'+#13,[intfTable,intfTable,itemName]);
    idcF.Write(s[1],LEngth(s));
    Inc(CurrentBytes,Length(s));
    _pos := Adr2pos(intfTable);
    //EntryCount
    Count := PInteger(Code + _pos)^;
    _pos := MakeDword(_pos);
    for n:=1 to Count do
    begin
      //GUID
      _pos := MakeArray(_pos, 16);
      //vTableAdr
      OutputIntfVTable(_pos, intfTable);
      Inc(_pos, 4);
      //IOffset
      _pos := MakeDword(_pos);
      if DelphiVersion > 3 then
      begin
        //ImplGetter
        _pos := MakeDword(_pos);
      End;
    end;
  end;
end;

Procedure TIDCGen.OutputIntfVTable (_pos:Integer; stopAdr:Integer);
var
  vTableAdr,vAdr,cc,n:Integer;
Begin
  MakeDword(_pos);
  vTableAdr := PInteger(Code + _pos)^;
  if vTableAdr<>0 then
  begin
    _pos := Adr2pos(vTableAdr);
    //CC byte address
    CC := vTableAdr;
    n:=0;
    while true do
    begin
      if pos2Adr(_pos) = stopAdr Then break;
      vAdr := PInteger(Code + _pos)^;
      _pos := MakeDword(_pos);
      MakeFunction(vAdr);
      if (vAdr<>0) and (vAdr < CC) then CC := vAdr;
      Inc(n);
    end;
    Dec(CC);
    MakeByte(Adr2pos(CC));
  end;
end;

Procedure TIDCGen.OutputAutoTable (_pos:Integer);
Var
  autoTable,Count,n:Integer;
  s:AnsiString;
Begin
  MakeDword(_pos);
  autoTable := PInteger(Code + _pos)^;
  if autoTable<>0 then
  begin
    s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s_AutoTable", 0);'+#13,[autoTable,autoTable,itemName]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    _pos := Adr2pos(autoTable);
    //EntryCount
    Count := PInteger(Code + _pos)^;
    _pos := MakeDword(_pos);
    for n:=1 to Count do
    begin
      //DispID
      _pos := MakeDword(_pos);
      //NameAdr
      _pos := MakeDword(_pos);
      //Flags
      _pos := MakeDword(_pos);
      //ParamsAdr
      OutputAutoPTable(_pos);
      Inc(_pos, 4);
      //ProcAdr
      //DWORD procAdr := *((DWORD*)(Code + _pos));
      _pos := MakeDword(_pos);
      //MakeFunction(procAdr);
    End;
  End;
end;

Procedure TIDCGen.OutputAutoPTable (_pos:Integer);
Var
  paramsAdr:Integer;
  paramCnt:Byte;
Begin
  MakeDword(_pos);
  paramsAdr := PInteger(Code + _pos)^;
  if paramsAdr<>0 then
  begin
    _pos := Adr2Pos(paramsAdr);
    paramCnt := Byte(Code[_pos + 1]);
    MakeArray(Adr2Pos(paramsAdr), paramCnt + 2);
  end;
end;

Procedure TIDCGen.OutputInitTable (_pos:Integer);
var
  initTable,n,num:Integer;
  s:AnsiString;
Begin
  MakeDword(_pos);
  initTable := PInteger(Code + _pos)^;
  if initTable<>0 then
  begin
    s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s_InitTable", 0);'+#13,[initTable,initTable,itemName]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    _pos := Adr2pos(initTable);
    //0xE
    _pos := MakeByte(_pos);
    //Unknown byte
    _pos := MakeByte(_pos);
    //Unknown dword
    _pos := MakeDword(_pos);
    //num
    num := PInteger(Code + _pos)^;
    _pos := MakeDword(_pos);
    for n:=1 to num do
    begin
      //TypeOfs
      _pos := MakeDword(_pos);
      //FieldOfs
      _pos := MakeDword(_pos);
    end;
  end;
end;

Procedure TIDCGen.OutputFieldTable (_pos:Integer);
var
  s:AnsiString;
  fieldTable,num,n:Integer;
Begin
  MakeDword(_pos);
  fieldTable := PInteger(Code + _pos)^;
  if fieldTable<>0 then
  begin
    s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s_FieldTable", 0);'+#13,[fieldTable,fieldTable,itemName]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    _pos := Adr2pos(fieldTable);
    //num
    num := PInteger(Code + _pos)^;
    _pos := MakeWord(_pos);
    //TypesTab
    OutputFieldTTable(_pos);
    Inc(_pos, 4);
    for n:=1 to num do
    begin
      //Offset
      _pos := MakeDword(_pos);
      //Idx
      _pos := MakeWord(_pos);
      //Name
      _pos := MakeShortString(_pos);
    end;
    if DelphiVersion >= 2010 then
    begin
      //num
      num := PWord(Code + _pos)^;
      _pos := MakeWord(_pos);
      for n:=1 to num do
      begin
        //Flags
        _pos := MakeByte(_pos);
        //TypeRef
        _pos := MakeDword(_pos);
        //Offset
        _pos := MakeDword(_pos);
        //Name
        _pos := MakeShortString(_pos);
        //AttrData
        _pos := OutputAttrData(_pos);
      End;
    End;
  end;
end;

Procedure TIDCGen.OutputFieldTTable (_pos:Integer);
var
  typesTab,n:Integer;
  num:Word;
Begin
  MakeDword(_pos);
  typesTab := PInteger(Code + _pos)^;
  if typesTab<>0 then
  begin
    _pos := Adr2pos(typesTab);
    //num
    num := PWord(Code + _pos)^;
    _pos := MakeWord(_pos);
    for n:=1 to num do _pos := MakeDword(_pos);
  End;
end;

Procedure TIDCGen.OutputMethodTable (_pos:Integer);
var
  s:AnsiString;
  methodTable,end_pos,n:Integer;
  count,len:Word;
Begin
  MakeDword(_pos);
  methodTable := PInteger(Code + _pos)^;
  if methodTable<>0 then
  begin
    s:=Format('MakeUnkn(0x%lX, 1);'+#13+'MakeNameEx(0x%lX, \"%s_MethodTable\", 0);'+#13,
      [methodTable,methodTable,itemName]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    _pos := Adr2pos(methodTable);
    //Count
    count := PWORD(Code + _pos)^;
    _pos := MakeWord(_pos);
    for n:=1 to count do
    begin
      //Len
      len := PWord(Code + _pos)^;
      end_pos := _pos + len;
      _pos := MakeWord(_pos);
      //CodeAddress
      //codeAdr := PInteger(Code + _pos)^;
      _pos := MakeDword(_pos);
      //MakeFunction(codeAdr);
      //Name
      _pos := MakeShortString(_pos);
      //Tail
      if _pos < end_pos then
      begin
        OutputVmtMethodEntryTail(_pos);
        _pos := end_pos;
      End;
    End;
    if DelphiVersion >= 2010 then
    begin
      //ExCount
      count := PWord(Code + _pos)^;
      _pos := MakeWord(_pos);
      for n:=1 to count do
      begin
        //Entry
        OutputVmtMethodEntry(_pos);
        Inc(_pos, 4);
        //Flags
        _pos := MakeWord(_pos);
        //VirtualIndex
        _pos := MakeWord(_pos);
      End;
    End;
  end;
end;

Procedure TIDCGen.OutputVmtMethodEntry (_pos:Integer);
Var
  entry,len:Word;
  end_pos:Integer;
Begin
  MakeDword(_pos);
  entry := PInteger(Code + _pos)^;
  if entry<>0 then
  begin
    _pos := Adr2pos(entry);
    //Len
    len := PWord(Code + _pos)^;
    end_pos := _pos + len;
    _pos := MakeWord(_pos);
    //CodeAddress
    //codeAdr := PInteger(Code + _pos)^;
    _pos := MakeDword(_pos);
    //MakeFunction(codeAdr);
    //Name
    _pos := MakeShortString(_pos);
    //Tail
    if _pos < end_pos then _pos := OutputVmtMethodEntryTail(_pos);
  End;
end;

Function TIDCGen.OutputVmtMethodEntryTail (_pos:Integer):Integer;
var
  n:Integer;
  paramCnt:Byte;
Begin
  //Version
  _pos := MakeByte(_pos);
  //CC
  _pos := MakeByte(_pos);
  //ResultType
  _pos := MakeDword(_pos);
  //ParOff
  _pos := MakeWord(_pos);
  //ParamCount
  paramCnt := Byte(Code[_pos]);
  _pos := MakeByte(_pos);
  for n:=1 to paramCnt do
  begin
    //Flags
    _pos := MakeByte(_pos);
    //ParamType
    _pos := MakeDword(_pos);
    //ParOff
    _pos := MakeWord(_pos);
    //Name
    _pos := MakeShortString(_pos);
    //AttrData
    _pos := OutputAttrData(_pos);
  end;
  //AttrData
  Result:= OutputAttrData(_pos);
end;

Procedure TIDCGen.OutputDynamicTable (_pos:Integer);
var
  s:AnsiString;
  dynamicTable,n:Integer;
  num:Word;
Begin
  MakeDword(_pos);
  dynamicTable := PInteger(Code + _pos)^;
  if dynamicTable<>0 then
  begin
    s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s_DynamicTable", 0);'+#13,
      [dynamicTable,dynamicTable,itemName]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    _pos := Adr2pos(dynamicTable);
    //Num
    num := PWord(Code + _pos)^;
    _pos := MakeWord(_pos);
    for n:=1 to num do
    begin
      //Msg
      _pos := MakeWord(_pos);
    end;
    for n:=1 to num do
    begin
      //ProcAddress
      _pos := MakeDword(_pos);
    end;
  end;
end;

Procedure TIDCGen.OutputResString (_pos:Integer; recN:InfoRec);
Begin
  itemName := recN.Name;
  MakeComment(_pos, itemName);
  _pos := MakeDword(_pos);
  _pos := MakeDword(_pos);
end;

Function TIDCGen.OutputProc (_pos:Integer; recN:InfoRec; imp:Boolean):Integer;
var
  from_pos,fromAdr,idx:Integer;
  procSize,cnt,instrLen,n:Integer;
  s:AnsiString;
  info:PRepNameInfo;
  recN1:InfoRec;
Begin
  itemName := recN.Name;
  from_pos := _pos;
  fromAdr := pos2Adr(_pos);
  if itemName <>'' then
  begin
    idx := names.IndexOf(itemName);
    if idx = -1 then
    begin
      names.Add(itemName);
      s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s", 0x20);'+#13,[fromAdr,fromAdr,itemName]);
      idcF.Write(s[1],Length(s));
      Inc(CurrentBytes,Length(s));
    end
    else
    begin
      info := GetNameInfo(idx);
      if Not Assigned(info) then
      begin
        New(info);
        info.index := idx;
        info.counter := 0;
        repeated.Add(info);
      end;
      cnt := info.counter;
      Inc(info.counter);
      s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s_%d", 0x20);'+#13,
        [fromAdr,fromAdr,itemName,cnt]);
      idcF.Write(s[1],Length(s));
      Inc(CurrentBytes,Length(s));
    end;
    MakeComment(_pos, recN.MakePrototype(fromAdr, true, false, false, true, false));
  end;
  procSize := GetProcSize(fromAdr);
  //If no procedure just return 0;
  if procSize=0 then
  Begin
    Result:=0;
    Exit;
  end;
  instrLen := MakeCode(_pos);
  if imp or (procSize = instrLen) then
  begin
    s:=Format('MakeFunction(0x%x, 0x%x);'+#13,[fromAdr,fromAdr + instrLen]);
    idcF.Write(s[1],Length(s));
    Inc(CurrentBytes,Length(s));
    Result:= instrLen - 1;//:= procSize - 1
    Exit;
  end;
  while true do
  begin
    if _pos - from_pos + 1 = procSize then
    begin
      s:=Format('MakeFunction(0x%x, 0x%x);'+#13,[fromAdr, pos2Adr(_pos) + 1]);
      idcF.Write(s[1],Length(s));
      Inc(CurrentBytes,Length(s));
      break;
    end;
    recN1 := GetInfoRec(pos2Adr(_pos));
    if Assigned(recN1) and Assigned(recN1.Pcode) Then
      MakeComment(_pos, FMain.MakeComment(recN1.Pcode));
    if IsFlagSet([cfExcept, cfFinally], _pos) then
    begin
      MakeCode(_pos);
      Inc(_pos);
      continue;
    end;
    if IsFlagSet([cfETable], _pos) then
    begin
      cnt := PInteger(Code + _pos)^;
      _pos := MakeDword(_pos);
      for n:=1 to cnt do
      begin
        _pos := MakeDword(_pos);   //ExceptionInfo
        _pos := MakeDword(_pos);   //ExceptionProc
      end;
      continue;
    end;
    if IsFlagSet([cfLoc], _pos) and (_pos <> from_pos) then
    begin
      MakeCode(_pos);
      Inc(_pos);
      continue;
    end;
    Inc(_pos);
  end;
  Result:= _pos - from_pos;//:= procSize - 1
end;

Procedure TIDCGen.OutputData (_pos:Integer; recN:InfoRec);
var
  _name,s:AnsiString;
  idx,adr,cnt:Integer;
  info:PRepNameInfo;
Begin
  if recN.HasName then
  begin
    MakeByte(_pos);
    if (recN._type = '') or not
      (SameText(recN._type, 'Single') or
      SameText(recN._type, 'Double') or
      SameText(recN._type, 'Extended') or
      SameText(recN._type, 'Comp') or
      SameText(recN._type, 'Currency')) then
    begin
      _name := recN.Name;
      idx := names.IndexOf(_name);
      adr := pos2Adr(_pos);
      if idx = -1 then
      begin
        names.Add(_name);
        s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s", 0);'+#13,[adr,adr,_name]);
        idcF.Write(s[1],Length(s));
        Inc(CurrentBytes,Length(s));
      end
      else
      begin
        info := GetNameInfo(idx);
        if not Assigned(info) then
        begin
          New(info);
          info.index := idx;
          info.counter := 0;
          repeated.Add(info);
        end;
        cnt := info.counter;
        Inc(info.counter);
        s:=Format('MakeUnkn(0x%x, 1);'+#13+'MakeNameEx(0x%x, "%s_%d", 0);'+#13,
          [adr,adr,_name,cnt]);
        idcF.Write(s[1],Length(s));
        Inc(CurrentBytes,Length(s));
      end;
    end;
    if recN._type <> '' then MakeComment(_pos, recN._type);
  end;
end;

Function TIDCGen.GetNameInfo (idx:Integer):PRepNameInfo;
var
  n:Integer;
Begin
  for n:=0 to repeated.Count-1 do
  begin
    Result := repeated.Items[n];
    if Result.index = idx Then Exit;
  end;
  Result:=Nil;
end;

Constructor TSaveIDCDialog.Create(AOwner:TComponent);
Begin
  Inherited;
  Options:=Options + [ofEnableSizing];
  if SplitIDC then CheckDlgButton(Handle,chkSplit_ID,BST_CHECKED)
    else CheckDlgButton(Handle,chkSplit_ID,BST_UNCHECKED);
end;

procedure TSaveIDCDialog.WndProc(var Msg:TMessage);
Begin
  if (Msg.Msg = WM_COMMAND)and(Msg.WParamLo = chkSplit_ID) then
    SplitIDC:=IsDlgButtonChecked(Handle,chkSplit_ID) = BST_CHECKED;
  Inherited;
end;

End.

