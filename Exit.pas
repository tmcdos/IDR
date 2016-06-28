Unit Exit;

Interface

Uses Windows, SysUtils, Classes, StdCtrls, Forms, Controls, Buttons, ExtCtrls;

Type

  TFExit = class(TForm)
	  OKBtn:TButton;
	  CancelBtn:TButton;
	  Bevel1:TBevel;
    cbDontSaveProject:TCheckBox;
    procedure OKBtnClick(Sender:TObject);
    procedure CancelBtnClick(Sender:TObject);
  private
  public
  end;

Implementation

{$R *.DFM}

Procedure TFExit.OKBtnClick (Sender:TObject);
Begin
  ModalResult:=mrOk;
end;

Procedure TFExit.CancelBtnClick (Sender:TObject);
Begin
  ModalResult:=mrCancel;
end;

End.
