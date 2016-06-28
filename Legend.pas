unit Legend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;

type
  TFLegend=class(TForm)
    gb1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lblUnitStd: TLabel;
    lblUnitUser: TLabel;
    lblUnitTrivial: TLabel;
    lblUnitUserUnk: TLabel;
    gb2: TGroupBox;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblInit: TLabel;
    lblFin: TLabel;
    lblUnk: TLabel;
    btnOK: TButton;
    procedure FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure FormCreate(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLegend:TFLegend;
  
implementation

{$R *.DFM}

procedure TFLegend.FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key=VK_ESCAPE then Close;
end;

procedure TFLegend.FormCreate(Sender : TObject);
begin
  lblUnitStd.Font.Color     := $C08000; //blue
  lblUnitUser.Font.Color    := $00B000; //green
  lblUnitTrivial.Font.Color := $0000B0; //brown
  lblUnitUserUnk.Font.Color := $8080FF; //red
end;

end.