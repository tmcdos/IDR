unit AboutDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, ComCtrls;

type
  TFAboutDlg=class(TForm)
    Panel3: TPanel;
    Button2: TButton;
    PageControl1: TPageControl;
    tsIDR: TTabSheet;
    tsCrypto: TTabSheet;
    Icon: TImage;
    lProduct: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    lVer: TLabel;
    lEmail: TLabel;
    lWWW: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    bDonate: TBitBtn;
    Label7: TLabel;
    Label8: TLabel;
    lblHint: TLabel;
    procedure FormCreate(Sender : TObject);
    procedure lEmailClick(Sender : TObject);
    procedure lWWWClick(Sender : TObject);
    procedure bDonateClick(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAboutDlg:TFAboutDlg;

implementation

{$R *.DFM}

Uses Misc,ShellAPI;

procedure TFAboutDlg.FormCreate(Sender : TObject);
begin
  lVer.Caption:='Version: '+IDRVersion;
end;

procedure TFAboutDlg.lEmailClick(Sender : TObject);
begin
  ShellExecute(Handle,'open','mailto:crypto2011@gmail.com',Nil,Nil,SHOW_OPENWINDOW);
end;

procedure TFAboutDlg.lWWWClick(Sender : TObject);
begin
  ShellExecute(Handle,'open','http://kpnc.org/idr32/en/',Nil,Nil,SHOW_OPENWINDOW);
end;

procedure TFAboutDlg.bDonateClick(Sender : TObject);
begin
  ShellExecute(Handle,'open','http://kpnc.org/idr32/en/donation.htm',Nil,Nil,SHOW_OPENWINDOW);
end;

end.