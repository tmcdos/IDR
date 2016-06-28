unit InputDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFInputDlg=class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    edtName: TLabeledEdit;
    procedure FormShow(Sender : TObject);
    procedure edtNameEnter(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInputDlg:TFInputDlg;
  
implementation

{$R *.DFM}

procedure TFInputDlg.FormShow(Sender : TObject);
begin
  if edtName.CanFocus then ActiveControl := edtName;
end;

procedure TFInputDlg.edtNameEnter(Sender : TObject);
begin
  edtName.SelectAll;
end;

end.
