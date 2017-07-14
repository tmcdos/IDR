unit EditFieldsDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFieldOp = (FD_OP_EDIT, FD_OP_ADD, FD_OP_DELETE);

  TFEditFieldsDlg=class(TForm)
    lbFXrefs: TListBox;
    lbFields: TListBox;
    Panel1: TPanel;
    bAdd: TButton;
    bRemove: TButton;
    edtPanel: TPanel;
    edtName: TLabeledEdit;
    edtType: TLabeledEdit;
    bApply: TButton;
    bClose: TButton;
    edtOffset: TLabeledEdit;
    bEdit: TButton;
    panel2: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender : TObject);
    procedure lbFXrefsDblClick(Sender : TObject);
    procedure lbFieldsClick(Sender : TObject);
    procedure edtNameChange(Sender : TObject);
    procedure edtTypeChange(Sender : TObject);
    procedure bCloseClick(Sender : TObject);
    procedure bApplyClick(Sender : TObject);
    procedure bEditClick(Sender : TObject);
    procedure bRemoveClick(Sender : TObject);
    procedure bAddClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
  private
    { Private declarations }
    Procedure ShowFields;
  public
    { Public declarations }
    Op:TFieldOp;
    SelIndex:Integer;
    FieldOffset:Integer;
	  VmtAdr:Integer;
    fieldsList:TList;
  end;

var
  FEditFieldsDlg:TFEditFieldsDlg;

implementation

{$R *.DFM}

Uses Main,KnowledgeBase,Misc,Infos,Def_main,Def_info,Def_know,Scanf;

procedure TFEditFieldsDlg.FormCreate(Sender : TObject);
begin
  Op := FD_OP_EDIT;
  SelIndex := -1;
  FieldOffset := -1;
	VmtAdr := 0;
  fieldsList := TList.Create;
end;

procedure TFEditFieldsDlg.FormDestroy(Sender: TObject);
begin
  fieldsList.Free;
end;

Procedure TFEditFieldsDlg.ShowFields;
Var
  n, fieldsNum:Integer;
  fInfo:FieldInfo;
  line:AnsiString;
Begin
	lbFields.Enabled := true;
	lbFields.Clear;
	fieldsList.Clear;
  fieldsNum := FMain.LoadFieldTable(VmtAdr, fieldsList);
  if fieldsNum<>0 then
  begin
    SelIndex := -1;
    for n := 0 To fieldsNum-1 do
    begin
      fInfo := fieldsList.Items[n];
      line := Val2Str(fInfo.Offset,5) + ' ';
      if fInfo.Name <> '' then line := line + fInfo.Name
        else line := line + '?';
      line := line + ':';
      if fInfo._Type <> '' then line := line + fInfo._Type
        else line := line + '?';
      lbFields.Items.Add(line);
      if fInfo.Offset = FieldOffset then SelIndex := n;
    End;
  End;
end;

procedure TFEditFieldsDlg.FormShow(Sender : TObject);
begin
	Caption := GetClsName(VmtAdr) + ' fields';
  edtPanel.Visible := false;
  lbFields.Height := lbFXrefs.Height;

  lbFXrefs.Clear;
  ShowFields;
  lbFields.ItemIndex := SelIndex;

  bEdit.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);
  bAdd.Enabled := true;
  bRemove.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);
  bClose.Enabled := true;
end;

procedure TFEditFieldsDlg.lbFXrefsDblClick(Sender : TObject);
var
  //_type:Array[0..1] of Char;
  adr:Integer;
  item:AnsiString;
  m:Integer;
  _type:Array[1..2] of Char;
begin
  item := lbFXrefs.Items[lbFXrefs.ItemIndex];
  adr:=StrToInt(item);
  //sscanf(item.c_str() + 1, "%lX%2c", &adr, type);
  sscanf(PAnsiChar(item) + 1, '%lX%2c', [@adr, @_type]);

  for m := Adr2Pos(adr) Downto 0 do
    if IsFlagSet([cfProcStart], m) then
    begin
      FMain.ShowCode(Pos2Adr(m), adr, -1, -1);
      break;
    End;
end;

procedure TFEditFieldsDlg.lbFieldsClick(Sender : TObject);
var
  line:AnsiString;
  fInfo:FieldInfo;
  n:Integer;
  recX:PXrefRec;
begin
  lbFXrefs.Clear;
  if lbFields.ItemIndex = -1 then Exit;
  fInfo := fieldsList.Items[lbFields.ItemIndex];
  if Assigned(fInfo.xrefs) then
    for n := 0 to fInfo.xrefs.Count-1 do
    begin
      recX := fInfo.xrefs.Items[n];
      line := Val2Str(recX.adr + recX.offset,8);
      if recX._type = 'c' then line := line + ' <-';
      lbFXrefs.Items.Add(line);
    End;
  bEdit.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);
  bRemove.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);
end;

procedure TFEditFieldsDlg.bEditClick(Sender : TObject);
Var
  fInfo:FieldInfo;
begin
  Op := FD_OP_EDIT;
  edtPanel.Visible := true;

  fInfo := fieldsList.Items[lbFields.ItemIndex];
  edtOffset.Text := Val2Str(fInfo.Offset);
  edtOffset.Enabled := false;
  edtName.Text := fInfo.Name;
  edtName.Enabled := true;
  edtType.Text := fInfo._Type;
  edtType.Enabled := true;
  edtName.SetFocus;

  lbFields.Enabled := false;
  bApply.Enabled := false;
  bClose.Enabled := true;
  bEdit.Enabled := false;
  bAdd.Enabled := false;
  bRemove.Enabled := false;
end;

procedure TFEditFieldsDlg.edtNameChange(Sender : TObject);
begin
  bApply.Enabled := true;
end;

procedure TFEditFieldsDlg.edtTypeChange(Sender : TObject);
begin
  bApply.Enabled := true;
end;

procedure TFEditFieldsDlg.bApplyClick(Sender : TObject);
var
  vmt:Boolean;
  adr:Integer;
  offset:Integer;
  recN:InfoRec;
  fInfo:FieldInfo;
  txt:AnsiString;
  itemidx,topidx:Integer;
begin
  Case Op of
    FD_OP_EDIT:
      begin
        fInfo := fieldsList.Items[lbFields.ItemIndex];
        fInfo.Name := edtName.text;
        fInfo._Type := edtType.text;
      End;
    FD_OP_ADD,
    FD_OP_DELETE:
      begin
        txt := edtOffset.text;
        sscanf(PAnsiChar(txt),'%lX',[@offset]);
        recN := GetInfoRec(VmtAdr);
        if Op = FD_OP_ADD then
        begin
          fInfo := FMain.GetField(recN.Name, offset, vmt, adr,'');
          if Not Assigned(fInfo) Then
            if Application.MessageBox('Field already exists', 'Replace?', MB_YESNO) = IDYES then
              recN.vmtInfo.AddField(0, 0, FIELD_PUBLIC, offset, -1, edtName.text, edtType.text);
        end
        else if Application.MessageBox('Delete field?', 'Confirmation', MB_YESNO) = IDYES then
          recN.vmtInfo.RemoveField(offset);
      End;
  End;
  itemidx := lbFields.ItemIndex;
  topidx := lbFields.TopIndex;
  ShowFields;
  lbFields.ItemIndex := itemidx;
  lbFields.TopIndex := topidx;

  FMain.RedrawCode;
  FMain.ShowClassViewer(VmtAdr);

  edtPanel.Visible := false;
  lbFields.Enabled := true;
  bEdit.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);
  bAdd.Enabled := true;
  bRemove.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);

  ProjectModified := true;
end;

procedure TFEditFieldsDlg.bCloseClick(Sender : TObject);
begin
  edtPanel.Visible := false;
  lbFields.Height := lbFXrefs.Height;

  lbFields.Enabled := true;
  bEdit.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);
  bAdd.Enabled := true;
  bRemove.Enabled := (lbFields.Count<>0) and (lbFields.ItemIndex <> -1);
end;

procedure TFEditFieldsDlg.bAddClick(Sender : TObject);
begin
  Op := FD_OP_ADD;
  edtPanel.Visible := true;

  edtOffset.Text := '';
  edtOffset.Enabled := true;
  edtName.Text := '';
  edtName.Enabled := true;
  edtType.Text := '';
  edtType.Enabled := true;
  edtOffset.SetFocus;

  lbFields.Enabled := false;
  bApply.Enabled := false;
  bClose.Enabled := true;
  bEdit.Enabled := false;
  bAdd.Enabled := false;
  bRemove.Enabled := false;
end;

procedure TFEditFieldsDlg.bRemoveClick(Sender : TObject);
Var
  fInfo:FieldInfo;
begin
  Op := FD_OP_DELETE;
  edtPanel.Visible := true;

  fInfo := fieldsList.Items[lbFields.ItemIndex];
  edtOffset.Text := Val2Str(fInfo.Offset);
  edtOffset.Enabled := false;
  edtName.Text := fInfo.Name;
  edtName.Enabled := false;
  edtType.Text := fInfo._Type;
  edtType.Enabled := false;

  lbFields.Enabled := false;
  bApply.Enabled := true;
  bClose.Enabled := true;
  bEdit.Enabled := false;
  bAdd.Enabled := false;
  bRemove.Enabled := false;
end;

end.
