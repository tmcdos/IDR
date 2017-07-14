unit IdcSplitSize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TFIdcSplitSize = class(TForm)
    OKbtn:TButton;
    CancelBtn:TButton;
    Bevel1:TBevel;
    tbSplitSize:TTrackBar;
    Procedure OKBtnClick(Sender:TObject);
    procedure CancelBtnClick(Sender:TObject);
    procedure FormShow(Sender: TObject);
    procedure tbSplitSizeChange(Sender:TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FIdcSplitSize: TFIdcSplitSize;

implementation

{$R *.dfm}

uses Main;

Procedure TFIdcSplitSize.OKBtnClick (Sender:TObject);
Begin
  SplitSize := (1 SHL (tbSplitSize.Position + 19)); //MBytes
  ModalResult := mrOk;
end;

Procedure TFIdcSplitSize.CancelBtnClick (Sender:TObject);
Begin
  SplitSize:=0;
  ModalResult:=mrCancel;
end;

procedure TFIdcSplitSize.FormShow(Sender: TObject);
begin
  Caption:='Split size: 1 Mbyte';
end;

Procedure TFIdcSplitSize.tbSplitSizeChange (Sender:TObject);
Begin
  Caption:='Split size: '+IntToStr(tbSplitSize.position)+' MByte';
end;


end.
