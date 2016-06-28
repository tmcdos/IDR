unit FindDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFFindDlg=class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    cbText: TComboBox;
    Label1: TLabel;
    procedure FormShow(Sender : TObject);
    procedure cbTextEnter(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFindDlg:TFFindDlg;

implementation

{$R *.DFM}

procedure TFFindDlg.FormShow(Sender : TObject);
begin
  if cbText.Items.Count<>0 then cbText.Text := cbText.Items[0];
  ActiveControl := cbText;
end;

procedure TFFindDlg.cbTextEnter(Sender : TObject);
begin
  cbText.SelectAll;
end;

end.
