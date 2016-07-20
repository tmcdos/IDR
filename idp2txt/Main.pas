unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    panel2: TPanel;
    btnLoad: TButton;
    btnUpdate: TButton;
    dlgOpen1: TOpenDialog;
    dlgSave1: TSaveDialog;
    progInfos: TProgressBar;
    btnText: TButton;
    txt1: TEdit;
    panel3: TPanel;
    txtInfos: TLabel;
    panel4: TPanel;
    txtBSS: TLabel;
    progBSS: TProgressBar;
    panel5: TPanel;
    txtUnit: TLabel;
    progUnit: TProgressBar;
    panel6: TPanel;
    txtType: TLabel;
    progType: TProgressBar;
    panel7: TPanel;
    txtForm: TLabel;
    progForm: TProgressBar;
    procedure btnLoadClick(Sender: TObject);
    procedure btnTextClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  LKind = (
  ikUnknown,//       = $00;    //UserDefined!
  ikInteger,//       = $01;
  ikChar,//          = $02;
  ikEnumeration,//   = $03;
  ikFloat,//         = $04;
  ikString,//        = $05;   //ShortString
  ikSet,//           = $06;
  ikClass,//         = $07;
  ikMethod,//        = $08;
  ikWChar,//         = $09;
  ikLString,//       = $0A;   //String, AnsiString
  ikWString,//       = $0B;   //WideString
  ikVariant,//       = $0C;
  ikArray,//         = $0D;
  ikRecord,//        = $0E;
  ikInterface,//     = $0F;
  ikInt64,//         = $10;
  ikDynArray,//      = $11;
//>=2009
  ikUString,//		    = $12;    //UnicodeString
//>=2010
  ikClassRef,//		  = $13;
  ikPointer,//		    = $14;
  ikProcedure,//		  = $15;

  ik16,ik17,ik18,ik19,ik1A,ik1B,ik1C,ik1D,ik1E,ik1F,

// additional types
  ikCString,//       = $20;    //PChar, PAnsiChar
  ikWCString,//      = $21;    //PWideChar

  ikResString,//     = $22;
  ikVMT,//           = $23;    //VMT
  ikGUID,//          = $24;
  ikRefine,//        = $25;    //Code, but what - procedure or function?
  ikConstructor,//   = $26;
  ikDestructor,//    = $27;
  ikProc,//			    = $28;
  ikFunc,//			    = $29;

  ikLoc,//           = $2A;
  ikData,//          = $2B;
  ikDataLink,//      = $2C;    //Link to variable from other module
  ikExceptName,//    = $2D;
  ikExceptHandler,// = $2E;
  ikExceptCase,//    = $2F;
  ikSwitch,//        = $30;
  ikCase,//          = $31;
  ikFixup,//         = $32;    //Fixup (for example, TlsLast)
  ikThreadVar,//     = $33;
  ikTry//			      = $34;  	//!!!Deleted - old format!!!
  );

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses TypInfo;

Type
  //Proc navigation history record
  PROCHISTORYREC = record
    adr:Integer;            //Procedure Address
    itemIdx:Integer;      //Selected Item Index
    xrefIdx:Integer;      //Selected Xref Index
    topIdx:Integer;       //TopIndex of ListBox
  End;
  PPROCHISTORYREC = ^PROCHISTORYREC;

Const
  MAX_ITEMS             = $10000;    //Max items number for read-write

var

  EP:Integer;
  Code:PAnsiChar;
  CodeBase:PAnsiChar;
  CodeSize:Integer;
  CodeStart:Integer;
  Image:PAnsiChar;
  ImageBase:Integer;
  ImageSize:Integer;
  Data:PAnsiChar;
  DataBase:Integer;
  DataSize:Integer;
  DataStart:Integer;
  TotalSize:Integer;      //Size of sections CODE + DATA

Function MakeString(p:PAnsiChar;L:Integer):AnsiString;
Begin
  SetLength(Result,L);
  if L<>0 then StrLCopy(PAnsiChar(Result),p,L);
end;

Function ExtractProcName (Const AName:AnsiString):AnsiString;
var
  p:Integer;
Begin
  Result:='';
  if AName <>'' then
  begin
    p:= Pos('.',AName);
    if p<>0 then Result:=Copy(AName,p+1, Length(AName));
  End;
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

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  ForceCurrentDirectory:=True;
  If dlgOpen1.Execute Then txt1.Text:=dlgOpen1.FileName
    else txt1.Text:='';
end;

procedure read_info(var s:TextFile;buf:Pointer;ins:TMemoryStream);
var
  x,num,xnum,m,xm,pxrefAdr,xrefAdr,adr,offset:Integer;
  w:Word;
  _type:Char;
  kind:LKind;
  b:Byte;
  t:Boolean;
Begin
  ins.Read(kind, sizeof(kind));
  WriteLn(s,'    kind = ',GetEnumName(TypeInfo(LKind),Ord(kind)),' (',IntToStr(Ord(kind)),')');
  ins.Read(x, sizeof(x));
  WriteLn(s,'    kbIdx = ',IntToStr(x));
  ins.Read(x, sizeof(x));
  ins.Read(buf^, x);
  WriteLn(s,'    name = ',MakeString(buf, x));
  ins.Read(x, sizeof(x));
  ins.Read(buf^, x);
  WriteLn(s,'    type = ',MakeString(buf, x));
  ins.Read(x, sizeof(x));
  if x<>0 Then
  Begin
    // read Pcode
    WriteLn(s,'    Pcode');
    WriteLn(s,'    {');
    ins.Read(b, sizeof(b));
    WriteLn(s,'      Op = ',IntToStr(b));
    ins.Read(x, sizeof(x));
    WriteLn(s,'      Offset = ',IntToHex(x,8));
    ins.Read(x, sizeof(x));
    ins.Read(buf^, x);
    WriteLn(s,'      name = ',MakeString(buf, x));
    WriteLn(s,'    }');
  end;
  //xrefs
  ins.Read(num, sizeof(num));
  pxrefAdr := 0;
  for m := 0 to num-1 do
  Begin
    //type
    ins.Read(_type, sizeof(_type));
    //adr
    ins.Read(adr, sizeof(adr));
    //offset
    ins.Read(offset, sizeof(offset));
    xrefAdr := adr + offset;
    if (pxrefAdr=0) or (pxrefAdr <> xrefAdr) then   //clear duplicates
    Begin
      Writeln(s,'    XRef #',IntToStr(m));
      WriteLn(s,'    {');
      writeLn(s,'      type = "',_type,'"');
      WriteLn(s,'      adr = ',IntToHex(adr,8));
      WriteLn(s,'      ofs = ',IntToHex(offset,8));
      WriteLn(s,'    }');
      pxrefAdr := xrefAdr;
    End;
  End;
  if kind = ikResString then
  Begin
  	//value
    ins.Read(x, sizeof(x));
    ins.Read(buf^, x);
    Writeln(s,'    rsInfo = ',MakeString(buf, x));
  End
  else if kind = ikVMT then
  Begin
  	//interfaces
    ins.Read(num, sizeof(num));
    If num<>0 Then
    begin
      WriteLn(s,'    interfaces = ',num);
      WriteLn(s,'    {');
      for m := 0 to num-1 do
      Begin
        ins.Read(x, sizeof(x));
        ins.Read(buf^, x);
        Writeln(s,'      ',MakeString(buf, x));
      End;
      WriteLn(s,'    }');
    end;
  	//fields
    ins.Read(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      WriteLn(s,'    field #',m);
      WriteLn(s,'    {');
      ins.Read(b, sizeof(b));
      WriteLn(s,'      scope = ',b);
      ins.Read(x, sizeof(x));
      WriteLn(s,'      offset = ',IntToHex(x,8));
      ins.Read(x, sizeof(x));
      WriteLn(s,'      case = ',IntToHex(x,8));
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      Writeln(s,'      name = ',MakeString(buf, x));
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      Writeln(s,'      type = ',MakeString(buf, x));
      //xrefs
      ins.Read(xnum, sizeof(xnum));
      for xm := 0 to xnum-1 do
      Begin
        WriteLn(s,'      xref #',xm);
        WriteLn(s,'      {');
        ins.Read(_type, sizeof(_type));
        WriteLn(s,'        type = ',b);
        ins.Read(adr, sizeof(adr));
        WriteLn(s,'        adr = ',IntToHex(adr,8));
        ins.Read(offset, sizeof(offset));
        WriteLn(s,'        ofs = ',IntToHex(offset,8));
        WriteLn(s,'      }');
      End;
      WriteLn(s,'    }');
    End;
  	//methods
    ins.Read(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      WriteLn(s,'    method #',m);
      WriteLn(s,'    {');
      with ins do
      begin
        Read(t, sizeof(t));
        WriteLn(s,'      abstract = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
        Read(_type, sizeof(_type));
        WriteLn(s,'      kind = ',_type);
        Read(x, sizeof(x));
        WriteLn(s,'      id = ',IntToHex(x,8));
        Read(x, sizeof(x));
        WriteLn(s,'      address = ',IntToHex(x,8));
        Read(x, sizeof(x));
        Read(buf^, x);
        WriteLn(s,'      name = ',MakeString(buf, x));
      end;
      WriteLn(s,'    }');
    End;
  End
  else if kind in [ikRefine..ikFunc] then
  Begin
    ins.Read(x, sizeof(x));
    WriteLn(s,'    procInfo.flags = ',IntToHex(x,8));
    ins.Read(w, sizeof(w));
    WriteLn(s,'    procInfo.BP_base = ',IntToStr(w));
    ins.Read(w, sizeof(w));
    WriteLn(s,'    procInfo.retBytes = ',IntToStr(w));
    ins.Read(x, sizeof(x));
    WriteLn(s,'    procInfo.proc_size = ',IntToStr(x));
    ins.Read(x, sizeof(x));
    WriteLn(s,'    procInfo.stack_size = ',IntToStr(x));
 		//args
    ins.Read(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      WriteLn(s,'    arg #',IntToStr(m));
      WriteLn(s,'    {');
      ins.Read(b, sizeof(b));
      WriteLn(s,'      tag = ',b);
      ins.Read(t, sizeof(t));
      WriteLn(s,'      register = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
      ins.Read(x, sizeof(x));
      Case x Of
        0: WriteLn(s,'      Ndx = EAX');
        1: WriteLn(s,'      Ndx = ECX');
        2: WriteLn(s,'      Ndx = EDX');
      Else WriteLn(s,'      Ndx = ',IntToStr(x));
      End;
      ins.Read(x, sizeof(x));
      WriteLn(s,'      size = ',IntToHex(x,8));
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      Writeln(s,'      name = ',MakeString(buf, x));
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      Writeln(s,'      TypeDef = ',TrimTypeName(MakeString(buf, x)));
      WriteLn(s,'    }');
    End;
    //locals
    ins.Read(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      WriteLn(s,'    local #',IntToStr(m));
      WriteLn(s,'    {');
      ins.Read(x, sizeof(x));
      WriteLn(s,'      ofs = ',IntToStr(x));
      ins.Read(x, sizeof(x));
      WriteLn(s,'      size = ',IntToStr(x));
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      Writeln(s,'      name = ',MakeString(buf, x));
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      Writeln(s,'      TypeDef = ',TrimTypeName(MakeString(buf, x)));
      WriteLn(s,'    }');
    End;
  End;
end;

procedure ReadNode(var s:TextFile;buf:Pointer;ins:TMemoryStream;level:Integer);
var
  n,Len,Cnt:Integer;
Begin
  ins.Read(Cnt, sizeof(Cnt));
  //Text
  ins.Read(len, sizeof(len));
  ins.Read(buf^, len);
  Writeln(s,' ':level*2,'node = ',MakeString(buf, len));
  for n := 0 to Cnt-1 do
    ReadNode(s,buf,ins,level+1);
  Application.ProcessMessages;
end;

procedure TForm1.btnTextClick(Sender: TObject);
Var
  f:THandle;
  s:TextFile;
  kind:LKind;
  b:Byte;
  t:Boolean;
  _ver,MaxBufLen,num,num2,evnum,n,m,k,x:Integer;
  Buf:PAnsiChar;
  inStream:TMemoryStream;
  pImage:PAnsiChar;
  q:AnsiString;
  magic:Array[1..12] of Char;
begin
  if txt1.Text<>'' then
  Begin
    txtInfos.Caption:='InfoRec';
    txtBSS.Caption:='BSS';
    txtType.Caption:='Types';
    txtUnit.Caption:='Units';
    txtForm.Caption:='Forms';
    Screen.Cursor := crHourGlass;
    f:=FileOpen(txt1.Text, fmOpenRead or fmShareDenyNone);
    FileSeek(f, 12, Ord(soBeginning));
    FileRead(f,_ver, sizeof(_ver));
    _ver:=_ver and $7FFF;
    MaxBufLen := 0;
    n:=FileSeek(f, -4, Ord(soEnd));
    FileRead(f,MaxBufLen, sizeof(MaxBufLen));
    FileClose(f);
    AssignFile(s,ChangeFileExt(txt1.Text,'.txt'));
    Rewrite(s);

    GetMem(buf,MaxBufLen);
    inStream := TMemoryStream.Create;
    inStream.LoadFromFile(dlgOpen1.FileName);
    // Read
    inStream.Read(magic[1], 12);
    inStream.Read(_ver, sizeof(_ver));
    _ver := _ver and $7FFF;
    // Write
    Writeln(S,'magic = ',magic);
    Writeln(s,'version = ',IntToStr(_ver));
    // Read
    inStream.Read(EP, sizeof(EP));
    inStream.Read(ImageBase, sizeof(ImageBase));
    inStream.Read(ImageSize, sizeof(ImageSize));
    inStream.Read(TotalSize, sizeof(TotalSize));
    inStream.Read(CodeBase, sizeof(CodeBase));
    inStream.Read(CodeSize, sizeof(CodeSize));
    inStream.Read(CodeStart, sizeof(CodeStart));
    inStream.Read(DataBase, sizeof(DataBase));
    inStream.Read(DataSize, sizeof(DataSize));
    inStream.Read(DataStart, sizeof(DataStart));
    // Write
    Writeln(s,'EP = ',IntToHex(EP,8));
    WriteLn(s,'ImageBase = ',IntToHex(ImageBase,8));
    WriteLn(s,'ImageSize = ',IntToHex(ImageSize,8));
    WriteLn(s,'TotalSize = ',IntToHex(TotalSize,8));
    WriteLn(s,'CodeBase = ',IntToHex(Integer(CodeBase),8));
    WriteLn(s,'CodeSize = ',IntToHex(CodeSize,8));
    WriteLn(s,'CodeStart = ',IntToHex(CodeStart,8));
    WriteLn(s,'DataBase = ',IntToHex(DataBase,8));
    WriteLn(s,'DataSize = ',IntToHex(DataSize,8));
    WriteLn(s,'DataStart = ',IntToHex(DataStart,8));


    //SegmentList
    inStream.Read(num, sizeof(num));
    Writeln(s,'segments = ',IntToStr(num));
    Writeln(s,'{');
    for n := 0 to num-1 do
    Begin
      WriteLn(s,'  segment #',IntToStr(n));
      WriteLn(s,'  {');
      inStream.Read(x, sizeof(x));
      WriteLn(s,'    start = ',IntToHex(x,8));
      inStream.Read(x, sizeof(x));
      WriteLn(s,'    size = ',IntToHex(x,8));
      inStream.Read(x, sizeof(x));
      WriteLn(s,'    flags = ',IntToHex(x,8));
      inStream.Read(x, sizeof(x));
      inStream.Read(buf^, x);
      WriteLn(s,'    name = ',MakeString(buf, x));
      WriteLn(s,'  }');
    End;
    Writeln(s,'}');

    Code := Image + CodeStart;
    Data := Image + DataStart;
    inStream.Position:=inStream.Position + TotalSize + SizeOf(DWORD)*TotalSize;

    inStream.Read(num, sizeof(num));
    txtInfos.Caption:='InfoRec = '+IntToStr(num);
    progInfos.Max:=num;
    progInfos.Position:=0;
    WriteLn(s,'RecInfo count = '+IntToStr(num));
    WriteLn(s,'{');
    for n := 0 to TotalSize-1 do
    Begin
      if (n and 1024) = 0 then
      Begin
        progInfos.Position:=n;
        Application.ProcessMessages;
      End;
      inStream.Read(x, sizeof(x));
      if x = -1 then Break;
      Writeln(s,'  Rec #',n);
      WriteLn(s,'  {');
      WriteLn(s,'    pos = '+IntToHex(x,8));
      read_info(s,Buf,inStream);
      WriteLn(s,'  }');
    End;
    WriteLn(s,'}');

    //BSSInfos
    inStream.Read(num, sizeof(num));
    txtBSS.Caption:='BSS = '+IntToStr(num);
    progBSS.Max:=num;
    progBSS.Position:=0;
    WriteLn(s,'BSS info count = '+IntToStr(num));
    Writeln(s,'{');
    for n := 0 to num-1 do
    Begin
      progBSS.Position:=n;
      Application.ProcessMessages;
      WriteLn(s,'  BSS #',n);
      Writeln(s,'  {');
      inStream.Read(x, sizeof(x));
      inStream.Read(buf^, x);
      WriteLn(s,'    address = '+MakeString(buf, x));
      read_info(s,Buf,inStream);
      WriteLn(s,'  }');
    End;
    WriteLn(s,'}');

    //Units
    inStream.Read(num, sizeof(num));
    txtUnit.Caption:='Units = '+IntToStr(num);
    progUnit.Max:=num;
    progUnit.Position:=0;
    WriteLn(s,'Units count = '+IntToStr(num));
    Writeln(s,'{');
    for n := 0 to num-1 do
    Begin
      progUnit.Position:=n;
      Application.ProcessMessages;
      WriteLn(s,'  Unit #',n);
      WriteLn(s,'  {');
      with inStream do
      begin
        Read(t, sizeof(t));
        WriteLn(s,'    trivial = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
        Read(t, sizeof(t));
        WriteLn(s,'    trivial Ini = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
        Read(t, sizeof(t));
        WriteLn(s,'    trivial Fin = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
        Read(t, sizeof(t));
        WriteLn(s,'    in KB = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
        Read(x, sizeof(x));
        WriteLn(s,'    fromAdr = ',IntToHex(x,8));
        Read(x, sizeof(x));
        WriteLn(s,'    toAdr = ',IntToHex(x,8));
        Read(x, sizeof(x));
        WriteLn(s,'    finAdr = ',IntToHex(x,8));
        Read(x, sizeof(x));
        WriteLn(s,'    finSize = ',IntToStr(x));
        Read(x, sizeof(x));
        WriteLn(s,'    iniAdr = ',IntToHex(x,8));
        Read(x, sizeof(x));
        WriteLn(s,'    iniSize = ',IntToStr(x));
        Read(x, sizeof(x));
        WriteLn(s,'    iniOrder = ',IntToStr(x));
        Read(num2, sizeof(num2));
      end;
      if num2<>0 then
      Begin
        WriteLn(s,'    Names');
        WriteLn(s,'    {');
        for m := 0 to num2-1 do
        Begin
          inStream.Read(x, sizeof(x));
          inStream.Read(buf^, x);
          Writeln(s,'      #',m,' = ',MakeString(buf, x));
        End;
        WriteLn(s,'    }');
      end;
      WriteLn(s,'  }');
    End;
    WriteLn(s,'}');

    if num<>0 then
    Begin
      inStream.Read(x, sizeof(x));
      inStream.Read(m, sizeof(m)); // CurUnitAdr
      inStream.Read(x, sizeof(x));
      inStream.Read(x, sizeof(x));
      //UnitItems
      if m<>0 then
      Begin
        inStream.Read(x, sizeof(x));
        inStream.Read(x, sizeof(x));
      End;
    End;

    //Types
    inStream.Read(num, sizeof(num));
    txtType.Caption:='Types = '+IntToStr(num);
    progType.Max:=num;
    progType.Position:=0;
    WriteLn(s,'Types count = '+IntToStr(num));
    Writeln(s,'{');
    for n := 0 to num-1 do
    Begin
      progType.Position:=n;
      Application.ProcessMessages;
      WriteLn(s,'  Type #',n);
      WriteLn(s,'  {');
      with inStream do
      Begin
        Read(kind, sizeof(kind));
        WriteLn(s,'    kind = ',GetEnumName(TypeInfo(LKind),Ord(kind)));
        Read(x, sizeof(x));
        WriteLn(s,'    adr = ',IntToHex(x,8));
        Read(x, sizeof(x));
        Read(buf^, x);
        Writeln(s,'    name = ', MakeString(buf, x));
      end;
      WriteLn(s,'  }');
    End;
    if num<>0 then inStream.Read(x, sizeof(x));
    Writeln(s,'}');

    //Forms
    inStream.Read(num, sizeof(num));
    txtForm.Caption:='Forms = '+IntToStr(num);
    progForm.Max:=num;
    progForm.Position:=0;
    WriteLn(s,'Forms count = '+IntToStr(num));
    Writeln(s,'{');
    for n := 0 to num-1 do
    Begin
      progForm.Position:=n;
      Application.ProcessMessages;
      WriteLn(s,'  Form #',n);
      WriteLn(s,'  {');
      inStream.Read(b, sizeof(b));
      WriteLn(s,'    flags = $',IntToHex(b,2));
      inStream.Read(x, sizeof(x));
      inStream.Read(buf^, x);
      WriteLn(s,'    resName = ', MakeString(buf, x));
      inStream.Read(x, sizeof(x));
      inStream.Read(buf^, x);
      Writeln(s,'    formName = ', MakeString(buf, x));
      inStream.Read(x, sizeof(x));
      inStream.Read(buf^, x);
      Writeln(s,'    className = ', MakeString(buf, x));
      //MemStream
      inStream.Read(x, sizeof(x));
      inStream.Position:=inStream.Position + x;
      //Events
      inStream.Read(num2, sizeof(num2));
      If num2<>0 Then
      begin
        WriteLn(s,'    event handlers');
        WriteLn(s,'    {');
        for m := 0 to num2-1 do
        Begin
          inStream.Read(x, sizeof(x));
          inStream.Read(buf^, x);
          q := MakeString(buf, x); // event name
          //ProcName
          inStream.Read(x, sizeof(x));
          inStream.Read(buf^, x);
          Writeln(s,'      ',q,' = ', MakeString(buf, x));
        End;
        WriteLn(s,'    }');
      end;
      //Components
      inStream.Read(num2, sizeof(num2));
      if num2<>0 then
      Begin
        for m := 0 to num2-1 do
        Begin
          WriteLn(s,'    component #',m);
          WriteLn(s,'    {');
          inStream.Read(t, sizeof(t));
          WriteLn(s,'      Inherited = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
          inStream.Read(t, sizeof(t));
          WriteLn(s,'      hasGlyph = ',GetEnumName(TypeInfo(Boolean),Ord(t)));
          inStream.Read(x, sizeof(x));
          inStream.Read(buf^, x);
          Writeln(s,'      Name = ',MakeString(buf, x));
          inStream.Read(x, sizeof(x));
          inStream.Read(buf^, x);
          Writeln(s,'      ClassName = ',MakeString(buf, x));
          //Events
          inStream.Read(evnum, sizeof(evnum));
          if evnum<>0 Then
          Begin
            WriteLn(s,'      event handlers');
            WriteLn(s,'      {');
            for k := 0 to evnum-1 do
            Begin
              inStream.Read(x, sizeof(x));
              inStream.Read(buf^, x);
              q := MakeString(buf, x); // event name
              inStream.Read(x, sizeof(x));
              inStream.Read(buf^, x);
              Writeln(s,'        ',q,' = ',MakeString(buf, x));
            End;
            WriteLn(s,'      }');
          end;
          WriteLn(s,'    }');
        End;
      End;
      Writeln(s,'  }');
    End;
    Writeln(s,'}');

    //Aliases
    inStream.Read(num, sizeof(num));
    if num<>0 Then
    begin
      WriteLn(s,'Aliases count = ',num);
      WriteLn(s,'{');
      for n := 0 to num-1 do
      Begin
        inStream.Read(x, sizeof(x));
        inStream.Read(buf^, x);
        Writeln(s,'  ',MakeString(buf, x));
      End;
      WriteLn(s,'}');
    end;

    //CodeHistory
    inStream.Read(k, sizeof(k)); // CodeHistorySize
    inStream.Read(x, sizeof(x));
    inStream.Read(x, sizeof(x));
    inStream.Position:=inStream.Position + sizeof(PROCHISTORYREC) * k;

    inStream.Read(x, sizeof(x));
    inStream.Read(x, sizeof(x));

    //Important variables
    inStream.Read(x, sizeof(x));
    inStream.Read(x, sizeof(x));

    inStream.Read(x, sizeof(x));
    inStream.Read(x, sizeof(x));

    inStream.Read(x, sizeof(x));

    //Class Viewer
    //Total nodes num (for progress)
    inStream.Read(Num, sizeof(Num));
    if Num<>0 then
    Begin
      WriteLn(s,'Class tree = ',num);
      WriteLn(s,'{');
      ReadNode(s,Buf,inStream, 1);
      WriteLn(s,'}');
    End;

    //Для проверки
    inStream.Read(MaxBufLen, sizeof(MaxBufLen));

    if Assigned(buf) then FreeMem(buf);
    inStream.Free;
    Screen.Cursor := crDefault;
    CloseFile(s);
  end;
end;

procedure convert_info(ins,outs:TFileStream;buf:Pointer);
var
  x,num,xnum,m,xm,pxrefAdr,xrefAdr,adr,offset:Integer;
  w:Word;
  _type:Char;
  kind:LKind;
  b:Byte;
  t:Boolean;
Begin
  ins.Read(kind, sizeof(kind));
  outs.Write(kind, sizeof(kind));
  // kbIdx
  ins.Read(x, sizeof(x));
  outs.Write(x, sizeof(x));
  // name
  ins.Read(x, sizeof(x));
  ins.Read(buf^, x);
  outs.Write(x, sizeof(x));
  outs.Write(buf^, x);
  // type
  ins.Read(x, sizeof(x));
  ins.Read(buf^, x);
  outs.Write(x, sizeof(x));
  outs.Write(buf^, x);
  // PiCode
  ins.Read(x, sizeof(x));
  outs.Write(x, sizeof(x));
  if x<>0 Then
  Begin
    // read Pcode
    ins.Read(b, sizeof(b));
    // Op
    outs.Write(b, sizeof(b));
    // offset
    ins.Read(x, sizeof(x));
    outs.Write(x, sizeof(x));
    // name
    ins.Read(x, sizeof(x));
    ins.Read(buf^, x);
    outs.Write(x, sizeof(x));
    outs.Write(buf^, x);
  end;
  //xrefs
  ins.Read(num, sizeof(num));
  outs.Write(num, sizeof(num));
  for m := 0 to num-1 do
  Begin
    //type
    ins.Read(_type, sizeof(_type));
    outs.Write(_type, sizeof(_type));
    //adr
    ins.Read(adr, sizeof(adr));
    outs.Write(adr, sizeof(adr));
    //offset
    ins.Read(offset, sizeof(offset));
    outs.Write(offset, sizeof(offset));
  End;
  if kind = ikResString then
  Begin
  	//value
    ins.Read(x, sizeof(x));
    ins.Read(buf^, x);
    outs.Write(x, sizeof(x));
    outs.Write(buf^, x);
  End
  else if kind = ikVMT then
  Begin
  	//interfaces
    ins.Read(num, sizeof(num));
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
    End;
  	//fields
    ins.Read(num, sizeof(num));
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      // scope
      ins.Read(b, sizeof(b));
      outs.Write(b, sizeof(b));
      // offset
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // case
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // name
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
      // type
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
      //xrefs
      ins.Read(xnum, sizeof(xnum));
      outs.Write(xnum, sizeof(xnum));
      for xm := 0 to xnum-1 do
        outs.CopyFrom(ins,9);
    End;
  	//methods
    ins.Read(num, sizeof(num));
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      // abstract
      ins.Read(t, sizeof(t));
      outs.Write(t, sizeof(t));
      // kind
      ins.Read(_type, sizeof(_type));
      outs.Write(_type, sizeof(_type));
      // ID
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // address
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // name
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
    End;
  End
  else if kind in [ikRefine..ikFunc] then
  Begin
    // flags
    ins.Read(x, sizeof(x));
    outs.Write(x, sizeof(x));
    // BP-base
    ins.Read(w, sizeof(w));
    outs.Write(w, sizeof(w));
    // ret Bytes
    ins.Read(w, sizeof(w));
    outs.Write(w, sizeof(w));
    // proc size
    ins.Read(x, sizeof(x));
    outs.Write(x, sizeof(x));
    // stack size
//    ins.Read(x, sizeof(x));
    x:=0;
    outs.Write(x, sizeof(x));
 		//args
    ins.Read(num, sizeof(num));
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      // tag
      ins.Read(b, sizeof(b));
      outs.Write(b, sizeof(b));
      // register
      ins.Read(t, sizeof(t));
      outs.Write(t, sizeof(t));
      // Ndx
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // size
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // name
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
      // typeDef
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
    End;
    //locals
    ins.Read(num, sizeof(num));
    outs.Write(num, sizeof(num));
    for m := 0 to num-1 do
    Begin
      // ofs
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // size
      ins.Read(x, sizeof(x));
      outs.Write(x, sizeof(x));
      // name
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
      // typeDef
      ins.Read(x, sizeof(x));
      ins.Read(buf^, x);
      outs.Write(x, sizeof(x));
      outs.Write(buf^, x);
    End;
  End;
end;

procedure TForm1.btnUpdateClick(Sender: TObject);
Var
  f:THandle;
  outs,ins:TFileStream;
  kind:LKind;
  b:Byte;
  t:Boolean;
  _ver,MaxBufLen,num,num2,evnum,n,m,k,x:Integer;
  Buf:PAnsiChar;
  pImage:PAnsiChar;
  q:AnsiString;
  magic:Array[1..12] of Char;
begin
  if txt1.Text<>'' then
  Begin
    txtInfos.Caption:='InfoRec';
    txtBSS.Caption:='BSS';
    txtType.Caption:='Types';
    txtUnit.Caption:='Units';
    txtForm.Caption:='Forms';
    Screen.Cursor := crHourGlass;
    f:=FileOpen(txt1.Text, fmOpenRead or fmShareDenyNone);
    FileSeek(f, 12, Ord(soBeginning));
    FileRead(f,_ver, sizeof(_ver));
    _ver:=_ver and $7FFF;
    MaxBufLen := 0;
    n:=FileSeek(f, -4, Ord(soEnd));
    FileRead(f,MaxBufLen, sizeof(MaxBufLen));
    FileClose(f);
    outs:=Nil;
    ins:=Nil;
    Try
      outs:=TFileStream.Create(ChangeFileExt(txt1.Text,'_.idp'),fmCreate);
      ins := TFileStream.Create(dlgOpen1.FileName,fmOpenRead);
      GetMem(buf,MaxBufLen);

      ins.Read(magic[1], 12);
      outs.Write(magic[1], 12);
      ins.Read(_ver, sizeof(_ver));
      outs.Write(_ver, sizeof(_ver));

      ins.Read(Buf^, sizeof(Integer)*3);
      outs.Write(Buf^, sizeof(Integer)*3);
      ins.Read(TotalSize, sizeof(TotalSize));
      outs.Write(TotalSize, sizeof(TotalSize));
      ins.Read(Buf^, sizeof(Integer)*6);
      outs.Write(Buf^, sizeof(Integer)*6);

      //SegmentList
      ins.Read(num, sizeof(num));
      outs.Write(num, sizeof(num));
      for n := 0 to num-1 do
      Begin
        ins.Read(buf^,sizeof(Integer)*3);
        outs.Write(buf^,sizeof(Integer)*3);
        ins.Read(x, sizeof(x));
        ins.Read(buf^, x);
        outs.Write(x, sizeof(x));
        outs.Write(buf^, x);
      End;

      outs.CopyFrom(ins,TotalSize + SizeOf(DWORD)*TotalSize);

      ins.Read(num, sizeof(num));
      outs.Write(num, sizeof(num));
      txtInfos.Caption:='Info objects = '+IntToStr(num);
      progInfos.Max:=num;
      progInfos.Position:=0;
      for n := 0 to TotalSize-1 do
      Begin
        if (n and 1024) = 0 then
        Begin
          progInfos.Position:=n;
          Application.ProcessMessages;
        End;
        ins.Read(x, sizeof(x));
        outs.Write(x, sizeof(x));
        if x = -1 then Break;
        convert_info(ins,outs,Buf);
      End;

      //BSSInfos
      ins.Read(num, sizeof(num));
      outs.Write(num, sizeof(num));
      txtBSS.Caption:='BSS info = '+IntToStr(num);
      progBSS.Max:=num;
      progBSS.Position:=0;
      for n := 0 to num-1 do
      Begin
        progBSS.Position:=n;
        Application.ProcessMessages;
        ins.Read(x, sizeof(x));
        ins.Read(buf^, x);
        outs.Write(x, sizeof(x));
        outs.Write(buf^, x);
        convert_info(ins,outs,Buf);
      End;

      outs.CopyFrom(ins,ins.Size - ins.Position);
      {
      //Units
      ins.Read(num, sizeof(num));
      outs.Write(num, sizeof(num));
      txtUnit.Caption:='Units = '+IntToStr(num);
      progUnit.Max:=num;
      progUnit.Position:=0;
      for n := 0 to num-1 do
      Begin
        progUnit.Position:=n;
        Application.ProcessMessages;
        outs.CopyFrom(ins,4*SizeOf(Boolean)+7*SizeOf(Integer));
        ins.Read(num2, sizeof(num2));
        for m := 0 to num2-1 do
        Begin
          ins.Read(x, sizeof(x));
          ins.Read(buf^, x);
          outs.Write(x, sizeof(x));
          outs.Write(buf^, x);
        End;
      End;

      if num<>0 then
      begin
        ins.Read(x, sizeof(x));
        outs.Write(x, sizeof(x));
        ins.Read(m, sizeof(m)); // CurUnitAdr
        outs.Write(m, sizeof(m)); // CurUnitAdr
        ins.Read(x, sizeof(x));
        outs.Write(x, sizeof(x));
        ins.Read(x, sizeof(x));
        outs.Write(x, sizeof(x));
        //UnitItems
        if m<>0 then
        Begin
          inStream.Read(x, sizeof(x));
          outs.Write(x, sizeof(x));
          inStream.Read(x, sizeof(x));
          outs.Write(x, sizeof(x));
        End;
      end;

      //Types
      ins.Read(num, sizeof(num));
      outs.Write(num, sizeof(num));
      txtType.Caption:='Types = '+IntToStr(num);
      progType.Max:=num;
      progType.Position:=0;
      for n := 0 to num-1 do
      Begin
        progType.Position:=n;
        Application.ProcessMessages;
        ins.Read(kind, sizeof(kind));
        outs.Write(kind, sizeof(kind));
        ins.Read(x, sizeof(x));
        outs.Write(x, sizeof(x));
        ins.Read(x, sizeof(x));
        ins.Read(buf^, x);
        outs.Write(x, sizeof(x));
        outs.Write(buf^, x);
      End;
      if num<>0 then
      Begin
        ins.Read(x, sizeof(x));
        outs.Write(x, sizeof(x));
      end;

      //Forms
      ins.Read(num, sizeof(num));
      outs.Write(num, sizeof(num));
      txtForm.Caption:='Forms = '+IntToStr(num);
      progForm.Max:=num;
      progForm.Position:=0;
      for n := 0 to num-1 do
      Begin
        progForm.Position:=n;
        Application.ProcessMessages;
        // Flags
        ins.Read(b, sizeof(b));
        outs.Write(b, sizeof(b));
        // ResName
        ins.Read(x, sizeof(x));
        ins.Read(buf^, x);
        outs.Write(x, sizeof(x));
        outs.Write(buf^, x);
        // Name
        ins.Read(x, sizeof(x));
        ins.Read(buf^, x);
        outs.Write(x, sizeof(x));
        outs.Write(buf^, x);
        // ClassName
        ins.Read(x, sizeof(x));
        ins.Read(buf^, x);
        outs.Write(x, sizeof(x));
        outs.Write(buf^, x);
        //MemStream
        ins.Read(x, sizeof(x));
        outs.Write(x,SizeOf(x));
        if x<>0 then outs.CopyFrom(ins,x);
        //Events
        ins.Read(num2, sizeof(num2));
        for m := 0 to num2-1 do
        Begin
          // event name
          ins.Read(x, sizeof(x));
          ins.Read(buf^, x);
          outs.Write(x, sizeof(x));
          outs.Write(buf^, x);
          //ProcName
          ins.Read(x, sizeof(x));
          ins.Read(buf^, x);
          outs.Write(x, sizeof(x));
          outs.Write(buf^, x);
        End;
        //Components
        ins.Read(num2, sizeof(num2));
        for m := 0 to num2-1 do
        Begin
          // inherited
          ins.Read(t, sizeof(t));
          outs.Write(t, sizeof(t));
          // hasGlyph
          ins.Read(t, sizeof(t));
          outs.Write(t, sizeof(t));
          // Name
          ins.Read(x, sizeof(x));
          ins.Read(buf^, x);
          outs.Write(x, sizeof(x));
          outs.Write(buf^, x);
          // ClassName
          ins.Read(x, sizeof(x));
          ins.Read(buf^, x);
          outs.Write(x, sizeof(x));
          outs.Write(buf^, x);
          //Events
          ins.Read(evnum, sizeof(evnum));
          outs.Write(evnum, sizeof(evnum));
          for k := 0 to evnum-1 do
          Begin
            // event name
            ins.Read(x, sizeof(x));
            ins.Read(buf^, x);
            outs.Write(x, sizeof(x));
            outs.Write(buf^, x);
            //ProcName
            ins.Read(x, sizeof(x));
            ins.Read(buf^, x);
            outs.Write(x, sizeof(x));
            outs.Write(buf^, x);
          End;
        End;
      End;

      //Aliases
      inStream.Read(num, sizeof(num));
      if num<>0 Then
      begin
        for n := 0 to num-1 do
        Begin
          inStream.Read(x, sizeof(x));
          inStream.Read(buf^, x);
        End;
      end;

      //CodeHistory
      inStream.Read(k, sizeof(k)); // CodeHistorySize
      inStream.Read(x, sizeof(x));
      inStream.Read(x, sizeof(x));
      inStream.Position:=inStream.Position + sizeof(PROCHISTORYREC) * k;

      inStream.Read(x, sizeof(x));
      inStream.Read(x, sizeof(x));

      //Important variables
      inStream.Read(x, sizeof(x));
      inStream.Read(x, sizeof(x));

      inStream.Read(x, sizeof(x));
      inStream.Read(x, sizeof(x));

      inStream.Read(x, sizeof(x));

      //Class Viewer
      //Total nodes num (for progress)
      inStream.Read(Num, sizeof(Num));
      if Num<>0 then
      Begin
        ReadNode(s,Buf,inStream, 1);
      End;

      //Для проверки
      inStream.Read(MaxBufLen, sizeof(MaxBufLen));
      }
    Finally
      if Assigned(buf) then FreeMem(buf);
      ins.Free;
      outs.Free;
      Screen.Cursor := crDefault;
    End;
  end;
end;

end.
