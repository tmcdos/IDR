unit Explorer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls;

type
  DefKind = (UNDEFINE, DEFINE_AS_CODE, DEFINE_AS_STRING);

  TFExplorer=class(TForm)
    pc1: TPageControl;
    tsCode: TTabSheet;
    tsData: TTabSheet;
    lbCode: TListBox;
    lbData: TListBox;
    tsString: TTabSheet;
    rgStringViewStyle: TRadioGroup;
    tsText: TTabSheet;
    lbText: TListBox;
    pm1: TPopupMenu;
    miCopy2Clipboard: TMenuItem;
    Panel2: TPanel;
    rgDataViewStyle: TRadioGroup;
    lbString: TMemo;
    Panel3: TPanel;
    btnDefCode: TButton;
    btnUndefCode: TButton;
    Panel1: TPanel;
    btnDefString: TButton;
    btnUndefString: TButton;
    procedure btnDefCodeClick(Sender : TObject);
    procedure btnUndefCodeClick(Sender : TObject);
    procedure rgStringViewStyleClick(Sender : TObject);
    procedure miCopy2ClipboardClick(Sender : TObject);
    procedure FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure FormShow(Sender : TObject);
    procedure rgDataViewStyleClick(Sender : TObject);
    procedure btnDefStringClick(Sender : TObject);
  private
    { Private declarations }
    Adr:Integer;  // Starting address
  public
    { Public declarations }
    DefineAs:DefKind;   //1- Define as Code, 2 - Undefine
    WAlign:Integer;		//Alignment for WideString visualization
    Procedure ShowCode(fromAdr:Integer; maxBytes:Integer);
    Procedure ShowData(fromAdr:Integer; maxBytes:Integer);
    Procedure ShowString(fromAdr:Integer; maxbytes:Integer);
  end;

Var
  FExplorer:TFExplorer;
  
implementation

{$R *.DFM}

Uses Disasm,Misc,Def_disasm,Main;

Type
  PReal = ^Real;

Procedure TFExplorer.ShowCode (fromAdr:Integer; maxBytes:Integer);
var
  _pos:Integer;
  DisInfo:TDisInfo;
  curAdr:Integer;
  disLine:AnsiString;
  n,instrLen:Integer;
Begin
  lbCode.Clear;
  _pos := Adr2Pos(fromAdr);
  if _pos = -1 then Exit;

  Adr := fromAdr;
  curAdr := Adr;
  n:=0;
  while n < maxBytes do
  begin
    instrLen := frmDisasm.Disassemble(Code + _pos, curAdr, @DisInfo, @disLine);
    if instrLen=0 then
    begin
      instrLen := 1;
      lbCode.Items.Add(Val2Str(curAdr,8) + '  ???');
    end
    else lbCode.Items.Add(Val2Str(curAdr,8) + '  ' + disLine);
    if n + instrLen > maxBytes then break;
    if _pos + instrLen >= CodeSize then break;
    Inc(_pos,instrLen);
    Inc(curAdr,instrLen);
    Inc(n,instrLen);
  end;
end;

Procedure TFExplorer.ShowData (fromAdr:Integer; maxBytes:Integer);
var
  b:Char;
  n, k, m, _pos:Integer;
  singleVal:Single;
  doubleVal:Double;
  extendedVal:Extended;
  realVal:Real;
  compVal:Comp;
  line1, line2:AnsiString;
  curAdr:Integer;
Begin
  lbData.Clear;
  _pos := Adr2Pos(fromAdr);
  if _pos = -1 Then Exit;
  Adr := fromAdr;
  curAdr := Adr;
  Case rgDataViewStyle.ItemIndex of
    0: // Hex (default)
      begin
        k:=0;
        for n := 0 to maxBytes-1 do
        begin
          if _pos > ImageSize then break;
          if k=0 then
          begin
            line1 := Val2Str(curAdr,8) + ' ';
            line2 := '  ';
          End;
          line1 :=line1 + ' ' + Val2Str(Ord(Image[_pos]),2);
          b := Image[_pos];
          if b < ' ' then b := ' ';
          line2 :=line2 + b;
          Inc(k);
          if k = 16 then
          begin
            lbData.Items.Add(line1 + line2);
            Inc(curAdr,16);
            k := 0;
          End;
          Inc(_pos);
        End;
        if (k > 0) and (k < 16) then
        begin
          for m := k To 15 do line1 := line1 + '   ';
          lbData.Items.Add(line1 + line2);
        End;
      End;
    //Single = float
    1:
      begin
        singleVal := PSingle(Image + _pos)^;
        line1 := Val2Str(curAdr,8) + '  ' + FloatToStr(singleVal);
        lbData.Items.Add(line1);
      end;
    //Double = doulbe
    2:
      begin
        doubleVal := PDouble(Image + _pos)^;
        line1 := Val2Str(curAdr,8) + '  ' + FloatToStr(doubleVal);
        lbData.Items.Add(line1);
      end;
    //Extended = long double
    3:
      begin
        try
          extendedVal := PExtended(Image + _pos)^;
          line1 := Val2Str(curAdr,8) + '  ' + FloatToStr(extendedVal);
        Except
          line1 := 'Impossible!';
        End;
        lbData.Items.Add(line1);
      end;
    //Real = double
    4:
      begin
        realVal := PReal(Image + _pos)^;
        line1 := Val2Str(curAdr,8) + '  ' + FloatToStr(realVal);
        lbData.Items.Add(line1);
      end;
    //Comp = Comp
    5:
      begin
        compVal := PComp(Image + _pos)^;
        line1 := Val2Str(curAdr,8) + '  ' + FloatToStr(compVal);
        lbData.Items.Add(line1);
      end;
  end;
  lbData.Update;
end;

Procedure TFExplorer.ShowString (fromAdr:Integer; maxbytes:Integer);
var
  len, size, _pos:Integer;
  str:AnsiString;
  wStr:WideString;
Begin
  lbString.Clear;
  _pos := Adr2Pos(fromAdr);
  if _pos = -1 then Exit;
  Case rgStringViewStyle.ItemIndex of
    0: //PAnsiChar
      begin
        len := StrLen(Image + _pos);
        if len < 0 then len := 0;
        if len > maxBytes then len := maxBytes;
        str := TransformString(Image + _pos, len);
      end;
    1: //PWideChar
      begin
        len := lstrlenW(PWideChar(Image) + _pos);
        if len < 0 then len := 0;
        if len > maxBytes then len := maxBytes;
        wStr := WideString(PWideChar(Image + _pos));
        size := WideCharToMultiByte(CP_ACP, 0, PWideChar(wStr), len, Nil, 0, Nil, Nil);
        if size<>0 then
        begin
          SetLength(str,size);
          WideCharToMultiByte(CP_ACP, 0, PWideChar(wStr), len, PAnsiChar(str), size, Nil, Nil);
        End;
      end;
    2: //ShortString
      begin
        len := PByte(Image + _pos)^;
        //if len < 0 len = 0;
        if len > maxBytes then len := maxBytes;
        str := TransformString(Image + _pos + 1, len);
      end;
    3: //AnsiString
      begin
        len := PLongInt(Image + _pos)^;
        if len < 0 then len := 0;
        if len > maxBytes then len := maxBytes;
        str := TransformString(Image + _pos + 4, len);
      end;
    4: //WideString
      begin
        len := PLongInt(Image + _pos + WAlign)^;
        if len < 0 then len := 0;
        if len > maxBytes then len := maxBytes;
        wStr := WideString(PWideChar(Image + _pos + WAlign + 4));
        size := WideCharToMultiByte(CP_ACP, 0, PWideChar(wStr), len, Nil, 0, Nil, Nil);
        if size<>0 then
        begin
          SetLength(str,size);
          WideCharToMultiByte(CP_ACP, 0, PWideChar(wStr), len, PAnsiChar(str), size, Nil, Nil);
        end;
      end;
  end;
  lbString.Lines.Add(str);
end;

procedure TFExplorer.btnDefCodeClick(Sender : TObject);
begin
  DefineAs:=DEFINE_AS_CODE;
  ModalResult:=mrOk;
end;

procedure TFExplorer.btnUndefCodeClick(Sender : TObject);
begin
  DefineAs:=UNDEFINE;
  ModalResult:=mrCancel;
end;

procedure TFExplorer.btnDefStringClick(Sender : TObject);
begin
  DefineAs:=DEFINE_AS_STRING;
  ModalResult:=mrOk;
end;

procedure TFExplorer.rgStringViewStyleClick(Sender : TObject);
begin
  ShowString(Adr,1024);
end;

procedure TFExplorer.miCopy2ClipboardClick(Sender : TObject);
var
  items:TStrings;
begin
  if pc1.ActivePage = tsCode then items := lbCode.Items
  Else if pc1.ActivePage = tsData then items := lbData.Items
  Else If pc1.ActivePage = tsString then items := lbString.Lines
  Else If pc1.ActivePage = tsText then items := lbText.Items
  Else items:=Nil;
  Copy2Clipboard(items, 0, false);
end;

procedure TFExplorer.FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key=VK_ESCAPE then ModalResult:=mrCancel;
end;

procedure TFExplorer.FormShow(Sender : TObject);
begin
  DefineAs:=UNDEFINE;
end;

procedure TFExplorer.rgDataViewStyleClick(Sender : TObject);
begin
  ShowData(Adr,1024);
end;

end.
