unit StringInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;

type
  TFStringInfo=class(TForm)
    memStringInfo: TMemo;
    procedure FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FStringInfo:TFStringInfo;
  
implementation

{$R *.DFM}

procedure TFStringInfo.FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key=VK_ESCAPE then ModalResult:=mrCancel;
end;

end.
