unit Hex2Double;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFHex2DoubleDlg=class(TForm)
    rgDataViewStyle: TRadioGroup;
    edtValue: TLabeledEdit;
    procedure FormShow(Sender : TObject);
    procedure edtValueEnter(Sender : TObject);
    procedure rgDataViewStyleClick(Sender : TObject);
  private
    { Private declarations }
    PrevIdx:Integer;
    BinData:Array[0..15] of Byte;
    Procedure Str2Binary(const AStr:AnsiString);
    Function Binary2Str(BytesNum:Integer):AnsiString;
  public
    { Public declarations }
  end;

var
  FHex2DoubleDlg:TFHex2DoubleDlg;
  
implementation

{$R *.DFM}

Uses Def_main,Misc,Scanf;

procedure TFHex2DoubleDlg.FormShow(Sender : TObject);
begin
  rgDataViewStyle.ItemIndex := 0;
  PrevIdx := 0;
  edtValue.Text := '';
  if edtValue.CanFocus then ActiveControl := edtValue;
end;

procedure TFHex2DoubleDlg.edtValueEnter(Sender : TObject);
begin
  edtValue.SelectAll;
end;

Procedure TFHex2DoubleDlg.Str2Binary (Const AStr:AnsiString);
var
  c:Char;
  n:Integer;
  src:PAnsiChar;
Begin
  src := PAnsiChar(AStr);
  FillMemory(@BinData, SizeOf(BinData),0);
  n := 0;
  while True do
  begin
    c := src^;
    if c=#0 then break;
    if c <> ' ' then
    begin
      sscanf(src, '%l8X', [@BinData[n]]);
      Inc(n);
      while True do
      begin
        c := src^;
        if (c=#0) or (c = ' ') then break;
        Inc(src);
      End;
      if c=#0 then break;
    End;
    Inc(src);
  End;
end;

Function TFHex2DoubleDlg.Binary2Str (BytesNum:Integer):AnsiString;
var
  n:Integer;
Begin
  result := '';
  for n := 0 To BytesNum-1 do
  begin
    if n<>0 then result :=Result+' ';
    result :=Result + Val2Str(BinData[n],2);
  end;
end;

procedure TFHex2DoubleDlg.rgDataViewStyleClick(Sender : TObject);
var
  singleVal:Single;
  doubleVal:Double;
  extendedVal:Extended;
  realVal:Real;
  compVal:Comp;
  result:AnsiString;
begin
  if edtValue.Text = '' then
  begin
    PrevIdx := rgDataViewStyle.ItemIndex;
    Exit;
  End;
  if rgDataViewStyle.ItemIndex = PrevIdx then Exit;
  result := edtValue.Text;
  try
    if rgDataViewStyle.ItemIndex = 0 Then
    Begin
      //Hex
      FillMemory(@BinData, SizeOf(BinData),0);
      Case TFloatKind(PrevIdx) Of
        FT_SINGLE:
          begin
            singleVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @singleVal, SizeOf(singleVal));
            result := Binary2Str(SizeOf(singleVal));
          end;
        FT_DOUBLE:
          begin
            doubleVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @doubleVal, SizeOf(doubleVal));
            result := Binary2Str(SizeOf(doubleVal));
          end;
        FT_EXTENDED:
          begin
            extendedVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @extendedVal, SizeOf(extendedVal));
            result := Binary2Str(SizeOf(extendedVal));
          end;
        FT_REAL:
          begin
            realVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @realVal, SizeOf(realVal));
            result := Binary2Str(SizeOf(realVal));
          end;
        FT_COMP:
          begin
            compVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @compVal, SizeOf(compVal));
            result := Binary2Str(SizeOf(compVal));
          End;
      end;
    end
    else
    begin
      Case TFloatKind(PrevIdx) of
        FT_NONE: Str2Binary(edtValue.Text);
        FT_SINGLE:
          begin
            singleVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @singleVal, SizeOf(singleVal));
          End;
        FT_DOUBLE:
          begin
            doubleVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @doubleVal, SizeOf(doubleVal));
          End;
        FT_EXTENDED:
          begin
            extendedVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @extendedVal, SizeOf(extendedVal));
          end;
        FT_REAL:
          begin
            realVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @realVal, SizeOf(realVal));
          End;
        FT_COMP:
          begin
            compVal := StrToFloat(edtValue.Text);
            MoveMemory(@BinData, @compVal, SizeOf(compVal));
          end;
      End;
      Case TFloatKind(rgDataViewStyle.ItemIndex) of
        FT_SINGLE:
          begin
            MoveMemory(@singleVal, @BinData, SizeOf(singleVal));
            result := FloatToStr(singleVal);
          End;
        FT_DOUBLE:
          begin
            MoveMemory(@doubleVal, @BinData, SizeOf(doubleVal));
            result := FloatToStr(doubleVal);
          End;
        FT_EXTENDED:
          begin
            MoveMemory(@extendedVal, @BinData, SizeOf(extendedVal));
            result := FloatToStr(extendedVal);
          End;
        FT_REAL:
          begin
            MoveMemory(@realVal, @BinData, SizeOf(realVal));
            result := FloatToStr(realVal);
          End;
        FT_COMP:
          begin
            MoveMemory(@compVal, @BinData, SizeOf(compVal));
            result := FloatToStr(compVal);
          end;
      End;
    end;
  Except
    result := 'Impossible!';
  End;
  PrevIdx := rgDataViewStyle.ItemIndex;
  edtValue.Text := result;
end;

end.
