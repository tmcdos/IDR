unit TypeInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Def_know,Def_main;

type
  TFTypeInfo=class(TForm)
    memDescription: TMemo;
    Panel1: TPanel;
    bSave: TButton;
    procedure FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure bSaveClick(Sender : TObject);
  private
    { Private declarations }
    RTTIKind:LKind;
    RTTIAdr:Integer;
    RTTIName:AnsiString;
  public
    { Public declarations }
    Procedure ShowKbInfo(tInfo:MTypeInfo);
    function GetRTTI(adr:Integer): AnsiString;
    Procedure ShowRTTI(adr:Integer);
  end;

var
  FTypeInfo:TFTypeInfo;
  
implementation

{$R *.DFM}

uses Misc,Main,Def_info,Infos,TypInfo;

Procedure TFTypeInfo.ShowKbInfo (tInfo:MTypeInfo);
var
  len:Word;
  line:AnsiString;
  p:PAnsiChar;
  fInfo:FieldInfo;
  mInfo:MethodInfo;
  pInfo:PropInfo;
  n:Integer;
Begin
  memDescription.ReadOnly := True;
  Panel1.Visible := False;
  if tInfo.ModuleID <> $FFFF then
    Caption := KBase.GetModuleName(tInfo.ModuleID) + '.';
  Caption := Caption + tInfo.TypeName;
  if tInfo.Size<>0 then
    Caption := Caption + ' (size = ' + Val2Str(tInfo.Size) + ')';
  memDescription.Clear;
  if tInfo.Decl <> '' then memDescription.Lines.Add(tInfo.Decl);
  if tInfo.FieldsNum<>0 then
  begin
    memDescription.Lines.Add('//FIELDS//');
    p := tInfo.Fields;
    for n := 1 to tInfo.FieldsNum do
    begin
      fInfo.Scope := Byte(p^);
      Inc(p);
      fInfo.Offset := PInteger(p)^;
      Inc(p, 4);
      fInfo._Case := PInteger(p)^;
      Inc(p, 4);
      Len := PWord(p)^;
      Inc(p, 2);
      fInfo.Name:=MakeString(p, Len);
      Inc(p, Len + 1);
      Len := PWord(p)^;
      Inc(p, 2);
      fInfo._Type := TrimTypeName(MakeString(p, Len));
      Inc(p, Len + 1);
      line := 'f' + Val2Str(fInfo.Offset) + ' ';
      case fInfo.Scope of
        FIELD_PRIVATE: line:=line + 'private';
        FIELD_PROTECTED: line:=line + 'protected';
        FIELD_PUBLIC: line:=line + 'public';
        FIELD_PUBLISHED: line:=line + 'published';
      end;
      if fInfo._Case <> -1 then line:=line + ' case ' + IntToStr(fInfo._Case);
      line:=line + ' ' + fInfo.Name + ':' + fInfo._Type;
      memDescription.Lines.Add(line);
    End;
  End;
  if tInfo.PropsNum<>0 then
  begin
    memDescription.Lines.Add('//PROPERTIES//');
    p := tInfo.Props;
    for n := 1 To tInfo.PropsNum do
    begin
      pInfo.Scope := Byte(p^);
      Inc(p);
      pInfo.Index := PInteger(p)^;
      Inc(p, 4);
      pInfo.DispID := PInteger(p)^;
      Inc(p, 4);
      Len := PWord(p)^;
      Inc(p, 2);
      pInfo.Name := MakeString(p, Len);
      Inc(p, Len + 1);
      Len := PWord(p)^;
      Inc(p, 2);
      pInfo.TypeDef := MakeString(p, Len);
      Inc(p, Len + 1);
      Len := PWord(p)^;
      Inc(p, 2);
      pInfo.ReadName := MakeString(p, Len);
      Inc(p, Len + 1);
      Len := PWORD(p)^;
      Inc(p, 2);
      pInfo.WriteName := MakeString(p, Len);
      Inc(p, Len + 1);
      Len := PWord(p)^;
      Inc(p, 2);
      pInfo.StoredName := MakeString(p, Len);
      Inc(p, Len + 1);
      line := '';
      Case pInfo.Scope of
        FIELD_PRIVATE: line:=line + 'private';
        FIELD_PROTECTED: line:=line + 'protected';
        FIELD_PUBLIC: line:=line + 'public';
        FIELD_PUBLISHED: line:=line + 'published';
      end;
      line:=line + ' ' + pInfo.Name + ':' + pInfo.TypeDef
        + ' ' + pInfo.ReadName
        + ' ' + pInfo.WriteName
        + ' ' + pInfo.StoredName;
      if pInfo.Index <> -1 then
        Case (pInfo.Index and 6) of
          2: line:=line + ' read';
          4: line:=line + ' write';
        end;
      memDescription.Lines.Add(line);
    End;
  End;
  if tInfo.MethodsNum<>0 then
  begin
    memDescription.Lines.Add('//METHODS//');
    p := tInfo.Methods;
    for n := 1 to tInfo.MethodsNum do
    begin
      mInfo.Scope := Byte(p^);
      Inc(p);
      mInfo.MethodKind := Byte(p^);
      Inc(p);
      Len := PWord(p)^;
      Inc(p, 2);
      mInfo.Prototype := MakeString(p, Len);
      Inc(p, Len + 1);
      line := '';
      Case mInfo.Scope of
        FIELD_PRIVATE: line:=line + 'private';
        FIELD_PROTECTED: line:=line + 'protected';
        FIELD_PUBLIC: line:=line + 'public';
        FIELD_PUBLISHED: line:=line + 'published';
      end;
      line:=line + ' ' + mInfo.Prototype;
      memDescription.Lines.Add(line);
    end;
  End;
  if Assigned(tInfo.Dump) then
  begin
    memDescription.Lines.Add('//Dump//');
    p := tInfo.Dump;
    line := '';
    for n := 0 to tInfo.DumpSz-1 do
    begin
      if n<>0 then line:=line + ' ';
      line:=line + Val2Str(PByte(p)^,2);
      Inc(p);
    end;
    memDescription.Lines.Add(line);
  end;
  ShowModal;
end;

Function GetVarTypeString(val:Integer):AnsiString;
Begin
  Result:='';
  Case val Of
    0: Result:='Empty';
    1: Result:='Null';
    2: Result:='Smallint';
    3: Result:='Integer';
    4: Result:='Single';
    5: Result:='Double';
    6: Result:='Currency';
    7: Result:='Date';
    8: Result:='OleStr';
    9: Result:='Dispatch';
    10:Result:='Error';
    11:Result:='Boolean';
    12:Result:='Variant';
    13:Result:='Unknown_0D';
    14:Result:='Decimal';
    15:Result:='Undef_0F';
    16:Result:='ShortInt';
    17:Result:='Byte';
    18:Result:='Word';
    19:Result:='LongWord';
    20:Result:='Int64';
    21:Result:='Word64';
    $48:Result:='StrArg';
    $100:Result:='String';
    $101:Result:='Any';
    $FFF:Result:='TypeMask';
    $2000:Result:='Array';
    $4000:Result:='ByRef';
  End;
end;

Function TFTypeInfo.GetRTTI (adr:Integer):AnsiString;
var
  found:Boolean;
  paramFlags:TParamFlags;
  _floatType, _methodKind, paramCount, numOps, ordType:Byte;
  callConv, propFlags, flags, dimCount:Byte;
  dw, propCount, methCnt:Word;
  minValue, maxValue, minValueB, maxValueB:Integer;
  i, m, n, vmtofs, _pos, posn, spos, _ap:Integer;
  minInt64Value, maxInt64Value:Int64;
  elSize, varType:Integer;    //for tkDynArray
  elType:Integer;             //for tkDynArray
  typeAdr, classVMT, parentAdr, Size, elNum, elOff, resultTypeAdr:Integer;
  propType, getProc, setProc, storedProc, methAdr, procSig:Integer;
  GUID:TGUID;
  typname, _name, FldFileName:AnsiString;
  stm:TFileStream;
  proto:AnsiString;
  recN:InfoRec;
  len:Byte;
Begin
  RTTIAdr := adr;
  _ap := Adr2Pos(RTTIAdr);
  _pos := _ap;
  Inc(_pos, 4);
  RTTIKind := LKind(Code[_pos]);
  Inc(_pos);
  len := Byte(Code[_pos]);
  Inc(_pos);
  RTTIName := MakeString(Code + _pos, len);
  Inc(_pos, len);
  Caption := RTTIName;
  result := '';
  Case RTTIKind of
    ikInteger,
    ikChar,
    ikWChar:
      begin
        ordType := Byte(Code[_pos]);
        Inc(_pos);
        minValue := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        maxValue := PInteger(Code + _pos)^;
        if (ordType and 1)=0 then
          //Signed type
          result := IntToStr(minValue) + '..' + IntToStr(maxValue)
        else
          //Unsigned type
          result := '$' + IntToHex(minValue, 0) + '..' + '$' + IntToHex(maxValue, 0);
      end;
    ikEnumeration:
      begin
        result := '(';
        ordType := Byte(Code[_pos]);
        Inc(_pos);
        minValue := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        maxValue := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        //BaseTypeAdr
        typeAdr := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        if SameText(RTTIName, 'ByteBool') or
            SameText(RTTIName, 'WordBool') or
            SameText(RTTIName, 'LongBool') then
        begin
          minValue := 0;
          maxValue := 1;
        end;
        //If BaseTypeAdr <> SelfAdr then fields extracted from BaseType
        if typeAdr <> RTTIAdr then
        begin
          _pos := Adr2pos(typeAdr);
          Inc(_pos, 4);   //SelfPointer
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
        for i:= minValueB to maxValueB do
        begin
          len := Byte(Code[_pos]);
          Inc(_pos);
          if (i >= minValue) and (i <= maxValue) then
          begin
            _name := MakeString(Code + _pos, len);
            if i <> minValue then result:=result + ', ';
            result:=result + _name;
          end;
          Inc(_pos, len);
        end;
        result:=Result + ')';
        //UnitName
        len := Byte(Code[_pos]);
        if IsValidName(len, _pos + 1) then
        begin
          Inc(_pos);
          Caption := Trim(MakeString(Code + _pos, len)) + '.' + Caption;
        End;
      end;
    ikFloat:
      if SameText(RTTIName, 'Single') or
          SameText(RTTIName, 'Double') or
          SameText(RTTIName, 'Extended') or
          SameText(RTTIName, 'Comp') or
          SameText(RTTIName, 'Currency') then
          result := RTTIName //'float'
      else
      begin
        _floatType := Byte(Code[_pos]);
        Inc(_pos);
        result := 'type ';
        case TFloatType(_floatType) of
          FtSingle: result:=result + 'Single';
          FtDouble: result:=result + 'Double';
          FtExtended: result:=result + 'Extended';
          FtComp: result:=result + 'Comp';
          FtCurr: result:=result + 'Currency';
        end;
      End;
    ikString: result := 'String';
    ikSet:
      begin
        //result := 'set of ';
        Inc(_pos);  //skip ordType
        typeAdr := PInteger(Code + _pos)^;
        result := 'set of ' + GetTypeName(typeAdr);
      end;
    ikClass:
      begin
        result := 'class';
        classVMT := PInteger(Code + _pos)^;
        Inc(_pos,4);
        parentAdr := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        if parentAdr<>0 then result:=result + '(' + GetTypeName(parentAdr) + ')';
        propCount := PWord(Code + _pos)^;
        Inc(_pos, 2);
        //UnitName
        len := Byte(Code[_pos]);
        Inc(_pos);
        Caption := Trim(MakeString(Code + _pos, len)) + '.' + Caption;
        Inc(_pos, len);
        propCount := PWord(Code + _pos)^;
        Inc(_pos, 2);
        for i := 1 to propCount do
        begin
          propType := PInteger(Code + _pos)^;
          Inc(_pos,4);
          posn := Adr2pos(propType);
          Inc(posn, 4);
          Inc(posn); //property type
          len := Byte(Code[posn]);
          Inc(posn);
          typname := MakeString(Code + posn, len);
          getProc := PInteger(Code + _pos)^;
          Inc(_pos, 4);
          setProc := PInteger(Code + _pos)^;
          Inc(_pos, 4);
          storedProc := PInteger(Code + _pos)^;
          Inc(_pos, 4);
          //idx
          Inc(_pos,4);
          //defval
          Inc(_pos, 4);
          //nameIdx
          Inc(_pos, 2);
          len := Byte(Code[_pos]);
          Inc(_pos);
          _name := MakeString(Code + _pos, len);
          Inc(_pos, len);
          result:=result + #13 + _name + ':' + typname;
          if (getProc and $FFFFFF00)<>0 then
          begin
            result:=result + #13+' read ';
            if (getProc and $FF000000) = $FF000000 then
                result:=result + _name + ' f' + Val2Str(getProc and $00FFFFFF)
            else if (getProc and $FF000000) = $FE000000 then
            begin
              if (getProc and $00008000)<>0 then
                vmtofs := -(getProc and $0000FFFF)
              else
                vmtofs := (getProc and $0000FFFF);
              posn := Adr2pos(classVMT) + vmtofs;
              getProc := PInteger(Code + posn)^;
              result:=result + ' vmt' + Val2Str(vmtofs) + ' ' + Val2Str(getProc);
              recN := GetInfoRec(getProc);
              if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
            end
            else
            begin
              result:=result + Val2Str(getProc);
              recN := GetInfoRec(getProc);
              if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
            End;
          end;
          if (setProc and $FFFFFF00)<>0 then
          begin
            result:=result + #13+ ' write ';
            if (setProc and $FF000000) = $FF000000 then
              result:=result + _name + ' f' + Val2Str(setProc and $00FFFFFF)
            else if (setProc and $FF000000) = $FE000000 then
            begin
              if (setProc and $00008000)<>0 then
                vmtofs := -(setProc and $0000FFFF)
              else
                vmtofs := (setProc and $0000FFFF);
              posn := Adr2pos(classVMT) + vmtofs;
              setProc := PInteger(Code + posn)^;
              result:=result + ' vmt' + Val2Str(vmtofs) + ' ' + Val2Str(setProc);
              recN := GetInfoRec(setProc);
              if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
            end
            else
            begin
              result:=result + Val2Str(setProc);
              recN := GetInfoRec(setProc);
              if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
            End;
          end;
          if (storedProc and $FFFFFF00)<>0 then
          begin
            result:=result + #13+ ' stored ';
            if (storedProc and $FF000000) = $FF000000 then
              result:=result + _name + ' f' + Val2Str(storedProc and $00FFFFFF)
            else if (storedProc and $FF000000) = $FE000000 then
            begin
              if (storedProc and $00008000)<>0 then
                vmtofs := -(storedProc and $0000FFFF)
              else
                vmtofs := (storedProc and $0000FFFF);
              posn := Adr2pos(classVMT) + vmtofs;
              storedProc := PInteger(Code + posn)^;
              result:=result + ' vmt' + Val2Str(vmtofs) + ' ' + Val2Str(storedProc);
              recN := GetInfoRec(storedProc);
              if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
            end
            else
            begin
              result:=result + Val2Str(storedProc);
              recN := GetInfoRec(storedProc);
              if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
            End;
          end;
        end;
        if DelphiVersion >= 2010 then
        begin
          propCount := PWord(Code + _pos)^;
          Inc(_pos, 2);
          for i :=1 to propCount do
          begin
            //Flags
            propFlags := Byte(Code[_pos]);
            Inc(_pos);
            //PPropInfo
            propType := PInteger(Code + _pos)^;
            Inc(_pos, 4);
            //AttrData
            dw := PWord(Code + _pos)^;
            Inc(_pos, dw);//ATR!!
            spos := _pos;
            //PropInfo
            _pos := Adr2pos(propType);
            propType := PInteger(Code + _pos)^;
            Inc(_pos,4);
            if IsFlagSet(cfImport, Adr2pos(propType)) then
            begin
              recN := GetInfoRec(propType);
              typname := recN.Name;
            end
            else
            begin
              posn := Adr2pos(propType);
              Inc(posn, 4);
              Inc(posn); //property type
              len := Byte(Code[posn]);
              Inc(posn);
              typname := MakeString(Code + posn, len);
            end;
            getProc := PInteger(Code + _pos)^;
            Inc(_pos, 4);
            setProc := PInteger(Code + _pos)^;
            Inc(_pos, 4);
            storedProc := PInteger(Code + _pos)^;
            Inc(_pos, 4);
            //idx
            Inc(_pos, 4);
            //defval
            Inc(_pos, 4);
            //nameIdx
            Inc(_pos, 2);
            len := Byte(Code[_pos]);
            Inc(_pos);
            _name := MakeString(Code + _pos, len);
            Inc(_pos, len);
            result:=result + #13+ _name + ':' + typname;
            if (getProc and $FFFFFF00)<>0 then
            begin
              result:=result + #13+' read ';
              if (getProc and $FF000000) = $FF000000 then
                result:=result + _name + ' f' + Val2Str(getProc and $00FFFFFF)
              else if (getProc and $FF000000) = $FE000000 then
              begin
                if (getProc and $00008000)<>0 then
                  vmtofs := -(getProc and $0000FFFF)
                else
                  vmtofs := (getProc and $0000FFFF);
                posn := Adr2pos(classVMT) + vmtofs;
                getProc := PInteger(Code + _pos)^;
                result:=result + ' vmt' + Val2Str(vmtofs) + ' ' + Val2Str(getProc);
                recN := GetInfoRec(getProc);
                if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
              end
              else
              begin
                result:=result + Val2Str(getProc);
                recN := GetInfoRec(getProc);
                if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
              end;
            End;
            if (setProc and $FFFFFF00)<>0 then
            begin
              result:=result +#13+ ' write ';
              if (setProc and $FF000000) = $FF000000 then
                result:=result + _name + ' f' + Val2Str(setProc and $00FFFFFF)
              else if (setProc and $FF000000) = $FE000000 then
              begin
                if (setProc and $00008000)<>0 then
                  vmtofs := -(setProc and $0000FFFF)
                else
                  vmtofs := (setProc and $0000FFFF);
                posn := Adr2pos(classVMT) + vmtofs;
                setProc := PInteger(Code + _pos)^;
                result:=result + ' vmt' + Val2Str(vmtofs) + ' ' + Val2Str(setProc);
                recN := GetInfoRec(setProc);
                if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
              end
              else
              begin
                result:=result + Val2Str(setProc);
                recN := GetInfoRec(setProc);
                if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
              end;
            end;
            if (storedProc and $FFFFFF00)<>0 then
            begin
              result:=result +#13+ ' stored ';
              if (storedProc and $FF000000) = $FF000000 then
                result:=result + _name + ' f' + Val2Str(storedProc and $00FFFFFF)
              else if (storedProc and $FF000000) = $FE000000 then
              begin
                if (storedProc and $00008000)<>0 then
                  vmtofs := -(storedProc and $0000FFFF)
                else
                  vmtofs := (storedProc and $0000FFFF);
                posn := Adr2pos(classVMT) + vmtofs;
                storedProc := PInteger(Code + _pos)^;
                result:=result + ' vmt' + Val2Str(vmtofs) + ' ' + Val2Str(storedProc);
                recN := GetInfoRec(storedProc);
                if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
              end
              else
              begin
                result:=result + Val2Str(storedProc);
                recN := GetInfoRec(storedProc);
                if Assigned(recN) and recN.HasName then result:=result + ' ' + recN.Name;
              end;
            end;
            _pos := spos;
          End;
          //AttrData
          dw := PWord(Code + _pos)^;
          Inc(_pos, dw);//ATR!!
          if DelphiVersion >= 2012 then
          begin
            //ArrayPropCount
            propCount := PWord(Code + _pos)^;
            Inc(_pos, 2);
            for i := 1 to propCount do
            begin
              //Flags
              Inc(_pos);
              //ReadIndex
              Inc(_pos, 2);
              //WriteIndex
              Inc(_pos, 2);
              //Name
              len := Byte(Code[_pos]);
              Inc(_pos);
              _name := MakeString(Code + _pos, len);
              Inc(_pos, len);
              result:=result +#13+ _name;
              //AttrData
              dw := PWord(Code + _pos)^;
              Inc(_pos, dw);//ATR!!
            end;
          End;
        End;
      end;
    ikMethod:
      begin
        _methodKind := Byte(Code[_pos]);
        Inc(_pos);
        case TMethodKind(_methodKind) of
          MkProcedure: result := 'procedure';
          MkFunction: result := 'function';
          MkConstructor: result := 'constructor';
          MkDestructor: result := 'destructor';
          MkClassProcedure: result := 'class procedure';
          MkClassFunction: result := 'class function';
          mkSafeProcedure:
            if DelphiVersion < 2009 then result := 'safeprocedure'
              else result := 'class constructor';
          mkSafeFunction:
            if DelphiVersion < 2009 then result := 'safefunction'
              else result := 'operator overload';
        end;
        paramCount := Byte(Code[_pos]);
        Inc(_pos);
        if paramCount > 0 then proto := '(';
        for i:=1 to paramCount do
        begin
          paramFlags := TParamFlags(Code[_pos]);
          Inc(_pos);
          if pfVar in paramFlags then proto:=proto + 'var '
          else if pfConst in paramFlags then proto:=proto + 'const '
          else if pfArray in paramFlags then proto:=proto + 'array ';
          len := Byte(Code[_pos]);
          Inc(_pos);
          _name := MakeString(Code + _pos, len);
          Inc(_pos, len);
          proto:=proto + _name + ':';
          len := Byte(Code[_pos]);
          Inc(_pos);
          _name := MakeString(Code + _pos, len);
          Inc(_pos, len);
          proto:=proto + _name;
          if i <> paramCount then proto:=proto + '; ';
        End;
        if paramCount > 0 then proto:=proto + ')';
        if _methodKind<>0 then
        begin
          len := Byte(Code[_pos]);
          Inc(_pos);
          _name := MakeString(Code + _pos, len);
          Inc(_pos, len);
          if DelphiVersion > 6 then
          begin
            typeAdr := PInteger(Code + _pos)^;
            Inc(_pos,4);
            _name := GetTypeName(typeAdr);
          end;
          proto:=proto + ':' + _name;
        End;
        if DelphiVersion > 6 then
        begin
          //CC
          callConv := Byte(Code[_pos]);
          Inc(_pos);
          //ParamTypeRefs
          Inc(_pos, 4*paramCount);
          if DelphiVersion >= 2010 then
          begin
            //MethSig
            procSig := PInteger(Code + _pos)^;
            Inc(_pos,4);
            //AttrData
            dw := PWord(Code + _pos)^;
            Inc(_pos, dw);//ATR!!
            //Procedure Signature
            if procSig<>0 then
            begin
              if IsValidImageAdr(procSig) then
                posn := Adr2pos(procSig)
              else
                posn := _ap + procSig;
              //Flags
              flags := Byte(Code[posn]);
              Inc(posn);
              if flags <> 255 then
              begin
                //CC
                callConv := Byte(Code[posn]);
                Inc(posn);
                //ResultType
                resultTypeAdr := PInteger(Code + posn)^;
                Inc(posn, 4);
                //ParamCount
                paramCount := Byte(Code[posn]);
                Inc(posn);
                if paramCount > 0 then proto := '(';
                for i:=1 To paramCount do
                begin
                  paramFlags := TParamFlags(Code[posn]);
                  Inc(posn);
                  if pfVar in paramFlags then proto:=proto + 'var '
                  else if pfConst in paramFlags then proto:=proto + 'const '
                  else if pfArray in paramFlags then proto:=proto + 'array ';
                  typeAdr := PInteger(Code + posn)^;
                  Inc(posn,4);
                  len := Byte(Code[posn]);
                  Inc(posn);
                  _name := MakeString(Code + posn, len);
                  Inc(posn, len);
                  proto:=proto + _name + ':' + GetTypeName(typeAdr);
                  if i <> paramCount then proto:=proto + '; ';
                  //AttrData
                  dw := PWord(Code + posn)^;
                  Inc(posn, dw);//ATR!!
                end;
                if paramCount > 0 then proto:=proto + ')';
                if resultTypeAdr<>0 then proto:=proto + ':' + GetTypeName(resultTypeAdr);
              end;
            end;
          end;
        end;
        result:=result + proto + ' of object;';
      End;
    ikLString: result := 'String';
    ikWString: result := 'WideString';
    ikVariant: result := 'Variant';
    ikArray:
      begin
        Size := PInteger(Code + _pos)^;
        Inc(_pos,4);
        elNum := PInteger(Code + _pos)^;
        Inc(_pos,4);
        resultTypeAdr := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        result := 'array [1..' + IntToStr(elNum);
        if DelphiVersion >= 2010 then
        begin
          result := 'array [';
          //DimCount
          dimCount := Byte(Code[_pos]);
          Inc(_pos);
          for i:= 1 to dimCount do
          begin
            typeAdr := PInteger(Code + _pos)^;
            Inc(_pos,4);
            if IsValidImageAdr(typeAdr) then result:=result + GetTypeName(typeAdr)
            else
            begin
              if typeAdr=0 then
              begin
                if dimCount = 1 then result:=result + '1..' + IntToStr(elNum)
                  else result:=result + '1..?';
              end
              else result:=result + '1..' + IntToStr(typeAdr);
            end;
            if i <> dimCount Then result:=result + ',';
          end;
        end;
        result:=result + '] of ' + GetTypeName(resultTypeAdr);
      end;
    ikRecord:
      begin
        Size := PInteger(Code + _pos)^;
        Inc(_pos,4);
        elNum := PInteger(Code + _pos)^;
        Inc(_pos,4);  //FldCount
        if elNum<>0 then
        begin
          result := RTTIName + ' = record // size=' + Val2Str(Size);
          for i:= 1 to elNum do
          begin
            typeAdr := PInteger(Code + _pos)^;
            Inc(_pos, 4);
            elOff := PInteger(Code + _pos)^;
            Inc(_pos, 4);
            result:=result +#13+ 'f' + Val2Str(elOff) + ':' + GetTypeName(typeAdr) + '; //f' + Val2Str(elOff);
          End;
          result:=result +#13+ 'end;';
        End;
        if DelphiVersion >= 2010 then
        begin
          //NumOps
          numOps := Byte(Code[_pos]);
          Inc(_pos);
          for i := 1 to numOps do //RecOps
            Inc(_pos, 4);
          elNum := PInteger(Code + _pos)^;
          Inc(_pos,4);  //RecFldCnt
          if elNum<>0 then
          begin
            result := RTTIName + ' = record // size=' + Val2Str(Size);
            for i := 1 to elNum do
            begin
              //TypeRef
              typeAdr := PInteger(Code + _pos)^;
              Inc(_pos,4);
              //FldOffset
              elOff := PInteger(Code + _pos)^;
              Inc(_pos,4);
              //Flags
              Inc(_pos);
              //Name
              len := Byte(Code[_pos]);
              Inc(_pos);
              _name := MakeString(Code + _pos, len);
              Inc(_pos,len);
              result:=result +#13+ _name + ':' + GetTypeName(typeAdr) + '; //f' + Val2Str(elOff);
              //AttrData
              dw := PWord(Code + _pos)^;
              Inc(_pos,dw);//ATR!!
            End;
            result:=result +#13+ 'end;';
          End;
          //AttrData
          dw := PWord(Code + _pos)^;
          Inc(_pos, dw);//ATR!!
          if DelphiVersion >= 2012 then
          begin
            methCnt := PWord(Code + _pos)^;
            Inc(_pos, 2);
            if methCnt > 0 then result:=result +#13+ '//Methods:';
            for m := 1 to methCnt do
            begin
              //Flags
              Inc(_pos);
              //Code
              methAdr := PInteger(Code + _pos)^;
              Inc(_pos,4);
              //Name
              len := Byte(Code[_pos]);
              Inc(_pos);
              _name := MakeString(Code + _pos, len);
              Inc(_pos,len);
              result:=result + #13+ _name;
              //ProcedureSignature
              //Flags
              flags := Byte(Code[_pos]);
              Inc(_pos);
              if flags <> 255 then
              begin
                //CC
                Inc(_pos);
                //ResultType
                resultTypeAdr := PInteger(Code + _pos)^;
                Inc(_pos, 4);
                //ParamCnt
                paramCount := Byte(Code[_pos]);
                Inc(_pos);
                if paramCount > 0 then result:=result + '(';
                //Params
                for n := 1 to paramCount do
                begin
                  //Flags
                  Inc(_pos);
                  //ParamType
                  typeAdr := PInteger(Code + _pos)^;
                  Inc(_pos,4);
                  //Name
                  len := Byte(Code[_pos]);
                  Inc(_pos);
                  _name := MakeString(Code + _pos, len);
                  Inc(_pos, len);
                  result:=result + _name + ':' + GetTypeName(typeAdr);
                  if n <> paramCount then result:=result + ';';
                  //AttrData
                  dw := PWord(Code + _pos)^;
                  Inc(_pos,dw);//ATR!!
                End;
                if paramCount > 0 then result:=result + ')';
                if resultTypeAdr<>0 Then result:=result + ':' + GetTypeName(resultTypeAdr);
                result:=result + '; //' + Val2Str(methAdr,8);
              End;
              //AttrData
              dw := PWord(Code + _pos)^;
              Inc(_pos, dw);//ATR!!
            End;
          End;
        end;
      end;
    ikInterface:
      begin
        result := 'interface';
        //IntfParent
        typeAdr := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        if typeAdr<>0 then result:=result + '(' + GetTypeName(typeAdr) + ')';
        //IntfFlags
        Inc(_pos);
        //GUID
        MoveMemory(@GUID, @Code[_pos], SizeOf(TGUID));
        Inc(_pos,16);
        result:=result + '['''+GuidToString(GUID)+''']' + #13;

        //UnitName
        len := Byte(Code[_pos]);
        Inc(_pos);
        Caption := Trim(MakeString(Code + _pos, len)) + '.' + Caption;
        Inc(_pos, len);

        //Methods
        propCount := PWord(Code + _pos)^;
        Inc(_pos, 2);
        result:=result + 'Methods Count = ' + IntToStr(propCount);
        if DelphiVersion >= 6 then
        begin
          //RttiCount
          dw := PWord(Code + _pos)^;
          Inc(_pos, 2);
          if dw <> $FFFF then
          begin
            if DelphiVersion >= 2010 then
            begin
              for i := 1 to propCount do
              begin
                //Name
                len := Byte(Code[_pos]);
                Inc(_pos);
                result:=result + #13 + MakeString(Code + _pos, len);
                Inc(_pos, len);
                //Kind
                _methodKind := Byte(Code[_pos]);
                Inc(_pos);
                //CallConv
                Inc(_pos);
                //ParamCount
                paramCount := Byte(Code[_pos]);
                Inc(_pos);
                if paramCount<>0 then result:=result + '(';
                for m := 1 to paramCount do
                begin
                  if m<>1 then result:=result + ';';
                  //Flags
                  Inc(_pos);
                  //ParamName
                  len := Byte(Code[_pos]);
                  Inc(_pos);
                  result:=result + MakeString(Code + _pos, len);
                  Inc(_pos, len);
                  //TypeName
                  len := Byte(Code[_pos]);
                  Inc(_pos);
                  result:=result + ':' + MakeString(Code + _pos, len);
                  Inc(_pos, len);
                  //ParamType
                  Inc(_pos, 4);
                End;
                if paramCount<>0 then result:=result + ')';
                if _methodKind<>0 then
                begin
                  result:=result + ':';
                  //ResultTypeName
                  len := Byte(Code[_pos]);
                  Inc(_pos);
                  result:=result + MakeString(Code + _pos, len);
                  Inc(_pos, len);
                  if len<>0 then
                  begin
                    //ResultType
                    Inc(_pos, 4);
                  End;
                End;
              End;
            end
            else for i := 1 to propCount do
            begin
              //PropType
              Inc(_pos, 4);
              //GetProc
              Inc(_pos, 4);
              //SetProc
              Inc(_pos, 4);
              //StoredProc
              Inc(_pos, 4);
              //Index
              Inc(_pos, 4);
              //Default
              Inc(_pos, 4);
              //NameIndex
              Inc(_pos, 2);
              //Name
              len := Byte(Code[_pos]);
              Inc(_pos);
              result:=result +#13 + MakeString(Code + _pos, len);
              Inc(_pos, len);
            end;
          End;
        End;
      end;
    ikInt64:
      begin
        minInt64Value := PInt64(Code + _pos)^;
        Inc(_pos,8);
        maxInt64Value := PInt64(Code + _pos)^;
        result := IntToStr(minInt64Value) + '..' + IntToStr(maxInt64Value);
      end;
    ikDynArray:
      begin
        //elSize
        elSize := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        //elType
        elType := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        result := 'array of ' + GetTypeName(elType);
        //varType
        varType := PInteger(Code + _pos)^;
        Inc(_pos, 4);
        if DelphiVersion >= 6 then
        begin
          //elType2
          Inc(_pos, 4);
          //UnitName
          len := Byte(Code[_pos]);
          Inc(_pos);
          Caption := Trim(MakeString(Code + _pos, len)) + '.' + Caption;
          Inc(_pos,len);
        End;
        if DelphiVersion >= 2010 then
        begin
          //DynArrElType
          elType := PInteger(Code + _pos)^;
          result := 'array of ' + GetTypeName(elType);
        End;
        result:=result + ';';
        if elSize<>0 then result:=result + #13+'//elSize = ' + Val2Str(elSize);
        if varType <> -1 then result:=result + #13+'//varType equivalent: var' + GetVarTypeString(varType);
      end;
    ikUString: result:= 'UString';
    ikClassRef:    //0x13
      begin
        typeAdr := PInteger(Code + _pos)^;
        if typeAdr<>0 then result := 'class of ' + GetTypeName(typeAdr);
      end;
    ikPointer:     //0x14
      begin
        typeAdr := PInteger(Code + _pos)^;
        if typeAdr<>0 then result := '^' + GetTypeName(typeAdr);
      end;
    ikProcedure:   //0x15
      begin
        result := RTTIName;
        //MethSig
        procSig := PInteger(Code + _pos)^;
        Inc(_pos,4);
        //AttrData
        dw := PWord(Code + _pos)^;
        Inc(_pos, dw);//ATR!!
        //Procedure Signature
        if procSig<>0 then
        begin
          if IsValidImageAdr(procSig) then _pos := Adr2pos(procSig)
            else _pos := _ap + procSig;
          //Flags
          flags := Byte(Code[_pos]);
          Inc(_pos);
          if flags <> 255 then
          begin
            //CallConv
            callConv := Byte(Code[_pos]);
            Inc(_pos);
            //ResultType
            resultTypeAdr := PInteger(Code + _pos)^;
            Inc(_pos, 4);
            if resultTypeAdr<>0 then result := 'function '
              else result := 'procedure ';
            result:=result + RTTIName;

            //ParamCount
            paramCount := Byte(Code[_pos]);
            Inc(_pos);
            if paramCount<>0 then result:=result + '(';
            for i := 1 to paramCount do
            begin
              //Flags
              paramFlags := TParamFlags(Code[_pos]);
              Inc(_pos);
              if pfVar in paramFlags then result:=result + 'var ';
              if pfConst in paramFlags then result:=result + 'const ';
              //ParamType
              typeAdr := PInteger(Code + _pos)^;
              Inc(_pos, 4);
              //Name
              len := Byte(Code[_pos]);
              Inc(_pos);
              result:=result + MakeString(Code + _pos, len) + ':';
              Inc(_pos, len);
              result:=result + GetTypeName(typeAdr);
              if i <> paramCount Then result:=result + '; ';
              //AttrData
              dw := PWord(Code + _pos)^;
              Inc(_pos, dw);//ATR!!
            End;
            if paramCount<>0 then result:=result + ')';
            if resultTypeAdr<>0 then result:=result + ':' + GetTypeName(resultTypeAdr);
            result:=result + ';';
            case callConv of
              1: result:=result + ' cdecl;';
              2: result:=result + ' pascal;';
              3: result:=result + ' stdcall;';
              4: result:=result + ' safecall;';
            End;
          End;
        End;
      end;
  End;
end;

Procedure TFTypeInfo.ShowRTTI (adr:Integer);
var
  line:AnsiString;
  e,b,len:Integer;
Begin
  memDescription.ReadOnly := True;
  Panel1.Visible := False;
	line := GetRTTI(adr);
  if line <>'' then
  begin
    memDescription.Clear;
    len := Length(line);
    b := 1;
    e := Pos(#13,line);
    while True do
    begin
      if e<>0 then
      begin
        line[e] := ' ';
        memDescription.Lines.Add(Copy(line,b, e - b));
      end
      else
      begin
        memDescription.Lines.Add(Copy(line,b, len - b + 1));
        break;
      End;
      b := e + 1;
      e := Pos(#13,line);
    End;
    if RTTIKind = ikDynArray then
    begin
      memDescription.ReadOnly := False;
      Panel1.Visible := True;
    End;
    ShowModal;
  End;
end;

procedure TFTypeInfo.FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key=VK_ESCAPE then ModalResult:=mrCancel;
end;

procedure TFTypeInfo.bSaveClick(Sender : TObject);
Var
  len:Byte;
  _pos, p,n:Integer;
  line, decl:AnsiString;
begin
  for n := 0 to memDescription.Lines.Count-1 do
  begin
    line := Trim(memDescription.Lines[n]);
    if line= '' then continue;
    decl:=decl + line;
  end;
  decl := Trim(decl);
  p := pos(';',decl);
  if p <>0 then decl := Copy(decl,1, p - 1);
  _pos := Adr2Pos(RTTIAdr);
  Inc(_pos, 4);
  Inc(_pos);//Kind
  len := Byte(Code[_pos]);
  Inc(_pos);
  Inc(_pos, len);//Name
  if RTTIKind = ikDynArray then
  begin
    //elSize
    Inc(_pos, 4);
    //elType
    PInteger(Code + _pos)^ := GetOwnTypeAdr(GetArrayElementType(decl));
  end;
  ModalResult := mrOk;
end;

end.
