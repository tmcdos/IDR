unit Plugins;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, CheckLst;

type
  _RegisterPlugIn = Procedure (var PlugName:AnsiString); Stdcall;
  _AboutPlugIn = Procedure; Stdcall;

  TFPlugins=class(TForm)
    cklbPluginsList: TCheckListBox;
    bOk: TButton;
    bCancel: TButton;
    procedure bCancelClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure cklbPluginsListClickCheck(Sender: TObject);
    procedure cklbPluginsListDblClick(Sender: TObject);
    procedure FormShow(Sender : TObject);
    procedure FormCreate(Sender : TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PluginsPath:AnsiString;
    PluginName:AnsiString;
  end;

var
  FPlugins:TFPlugins;
  
implementation

{$R *.DFM}

Var
  fnRegisterPlugIn:_RegisterPlugIn;
  fnAboutPlugIn:_AboutPlugIn;

procedure TFPlugins.FormCreate(Sender : TObject);
begin
  PluginsPath:='';
  PluginName:='';
end;

procedure TFPlugins.FormShow(Sender : TObject);
Var
  sr:TSearchRec;
  curDir,info,ptr:AnsiString;
  hModule:HINST;
begin
  cklbPluginsList.Clear;
  if PluginsPath <> '' then
  begin
    curDir := GetCurrentDir;
    try
      Screen.Cursor := crHourGlass;
      ChDir(PluginsPath);
      if FindFirst('*.dll', faArchive, sr)<>0 then
      begin
        Repeat
          hModule := LoadLibrary(PAnsiChar(sr.Name));
          if hModule<>0 then
          begin
            info := '';
            @fnRegisterPlugIn := GetProcAddress(hModule, 'RegisterPlugIn');
            if Assigned(fnRegisterPlugIn) then
            begin
              fnRegisterPlugIn(ptr);
              info := ptr;
            End;
            cklbPluginsList.Items.Add(sr.Name + ' - ' + info);
            FreeLibrary(hModule);
          End;
        Until FindNext(sr)=0;
        FindClose(sr);
      End;
    Finally
      ChDir(curDir);
      Screen.Cursor := crDefault;
    end;
  End;
end;

procedure TFPlugins.cklbPluginsListClickCheck(Sender: TObject);
var
  N:Integer;
begin
  if cklbPluginsList.State[cklbPluginsList.ItemIndex]<>cbUnchecked then
    for n := 0 to cklbPluginsList.Items.Count-1 do
      if n = cklbPluginsList.ItemIndex then cklbPluginsList.State[n] := cbChecked
        Else cklbPluginsList.State[n]:=cbUnchecked;
end;

procedure TFPlugins.cklbPluginsListDblClick(Sender: TObject);
var
  filename, line:AnsiString;
  _pos:Integer;
  hModule:HINST;
begin
  filename := '';
  line := cklbPluginsList.Items[cklbPluginsList.ItemIndex];
  _pos := pos('-',line);
  if _pos <> 0 then filename := Trim(Copy(line,1, _pos - 1));
  if filename <> '' then
  begin
    hModule := LoadLibrary(PAnsiChar(PluginsPath + '\' + filename));
    if hModule<>0 then
    begin
      @fnAboutPlugIn := GetProcAddress(hModule, 'AboutPlugIn');
      if Assigned(fnAboutPlugIn) then fnAboutPlugIn;
      FreeLibrary(hModule);
    End;
  End;
end;

procedure TFPlugins.bOkClick(Sender: TObject);
var
  n,_pos:Integer;
  line:AnsiString;
begin
  PluginName := '';
  for n := 0 to cklbPluginsList.Items.Count-1 do
    if cklbPluginsList.State[n]<>cbUnchecked then
    begin
      line := cklbPluginsList.Items[n];
      _pos := Pos('-',line);
      if _pos <> 0 then PluginName := Trim(Copy(line,1, _pos - 1));
      break;
    End;
  ModalResult := mrOk;
end;

procedure TFPlugins.bCancelClick(Sender: TObject);
begin
  PluginName:='';
  ModalResult:=mrCancel;
end;

end.
