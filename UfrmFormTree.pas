unit UfrmFormTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Menus, ComCtrls;
  
type
  TIdrDfmFormTree=class(TForm)
    tvForm: TTreeView;
    dlgFind: TFindDialog;
    mnuTree: TPopupMenu;
    Expand1: TMenuItem;
    Collapse1: TMenuItem;
    Find1: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure tvFormKeyPress(Sender : TObject; Var Key:Char);
    procedure tvFormDblClick(Sender : TObject);
    procedure dlgFindFind(Sender : TObject);
    procedure Expand1Click(Sender : TObject);
    procedure Collapse1Click(Sender : TObject);
    procedure Find1Click(Sender : TObject);
    procedure FormClose(Sender : TObject; var Action:TCloseAction);
    procedure FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure FormCreate(Sender : TObject);
  private
    { Private declarations }
    prevCursor:TCursor;
    //TTreeNodeMap NodesMap;
    Function MakeNodeCaption(curComp:TComponent):AnsiString;
    Function MakeNodeEventCaption(item:Pointer):AnsiString;
    Procedure BorderTheControl(aControl:TControl);
    Procedure AddEventsToNode(compName:AnsiString; dstNode:TTreeNode; evList:TList);
    Function FindTreeNodeByText(nodeFrom:TTreeNode; const txt:AnsiString; caseSensitive:Boolean):TTreeNode;
    Function FindTreeNodeByTag(tag:Pointer):TTreeNode;
    Procedure AddTreeNodeWithTag(node:TTreeNode; tag:Pointer);
    Function IsEventNode(selNode:TTreeNode):Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses Def_res,Def_main,Main,Resources,Infos,Misc,StrUtils;

procedure TIdrDfmFormTree.AddEventsToNode(compName:AnsiString; dstNode:TTreeNode; evList:TList);
Var
  m:Integer;
  item:PEventListItem;
Begin
  for m := 0 To evList.Count-1 do
  begin
    item := evList.Items[m];
    if SameText(item.CompName, compName) then
      tvForm.Items.AddChildObject(dstNode, MakeNodeEventCaption(item), Pointer(item.Adr));
  End;
end;

procedure TIdrDfmFormTree.FormCreate(Sender : TObject);
var
  compCnt,i:Integer;
  frmOwner:TForm;
  evList:TList;
  rootNode,parentNode,parentNode2,childNode:TTreeNode;
  curComp, parComp, parComp2:TComponent;
  externalNames, tnCaption:AnsiString;
  parName, parName2, ownName:AnsiString;
  externalParent:Boolean;
begin
  prevCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  Application.ProcessMessages;
  frmOwner:=TForm(Owner);
  compCnt := frmOwner.ComponentCount;
  if compCnt > 1 then Caption := frmOwner.Name + ' (' + IntToStr(compCnt) + ' components)'
    else Caption := frmOwner.Name + ' (1 component)';
  evList:=TList.Create;
  ResInfo.GetEventsList(frmOwner.Name, evList);
  tvForm.Items.BeginUpdate;
  try
    rootNode := tvForm.Items.AddObject(Nil, frmOwner.Name, frmOwner);
    AddTreeNodeWithTag(rootNode, frmOwner);
    AddEventsToNode(frmOwner.Name, rootNode, evList);
    externalParent := false;
    for i := 0 To compCnt-1 do
    begin
      curComp := frmOwner.Components[i];
      if curComp = Self Then continue;     //Don't display Form TreeView
      tnCaption := MakeNodeCaption(curComp);
      parComp := curComp.GetParentComponent;
      if curComp.HasParent then
      begin
        //in some very rare cases parent could be located in another module!
        //so in this case we have true for currComp->HasParent() but NULL for parCompo
        if not Assigned(parComp) then
        begin
          externalParent := true;
          if externalNames<>'' then externalNames:= externalNames + ', ';
          externalNames := externalNames + tnCaption;
        End;
        if Assigned(parComp) Then parName:=parComp.Name
          Else parName:='N/A';
        ownName := curComp.Owner.Name;
        parentNode := FindTreeNodeByTag(parComp);

        //tricky case for special components (eg: TPage, TTabPage)
        //they are a) noname (but renamed in IDR)
        //         b) not present in Components[] array
        if Not Assigned(parentNode) and Assigned(parComp) then
        begin
          parComp2 := parComp.GetParentComponent;
          parName2 := parComp2.Name;
          parentNode2 := FindTreeNodeByTag(parComp2);

          // add noname parent
          parentNode := tvForm.Items.AddChildObject(parentNode2, MakeNodeCaption(parComp), parComp);
          AddTreeNodeWithTag(parentNode, parComp);
        End;
      end
      else parentNode := FindTreeNodeByTag(curComp.Owner);
      childNode := tvForm.Items.AddChildObject(parentNode, tnCaption, curComp);
      AddTreeNodeWithTag(childNode, curComp);
      AddEventsToNode(curComp.Name, childNode, evList);
    End;
    rootNode.Expand(false);
  Finally
    tvForm.Items.EndUpdate;
  End;
  if externalParent then
    Application.MessageBox(PAnsiChar('Form has some component classes defined in external modules:'+#13+#10
      + externalNames + #13+#10+#13+#10+'Visualization of these components is not yet implemented'),
      'Warning', MB_OK or MB_ICONWARNING);
end;

procedure TIdrDfmFormTree.FormDestroy(Sender: TObject);
begin
  Screen.Cursor:=prevCursor;
end;

Function TIdrDfmFormTree.MakeNodeCaption (curComp:TComponent):AnsiString;
Var
  clasName:AnsiString;
Begin
  clasName := curComp.ClassName;
  if curComp Is IdrDfmDefaultControl then
    clasName := '!' + IdrDfmDefaultControl(curComp).OrigClassName;
  Result:=curComp.Name + ':' + clasName;
end;

Function TIdrDfmFormTree.MakeNodeEventCaption (item:Pointer):AnsiString;
Var
  recN:InfoRec;
Begin
  if PEventListItem(item).Adr<>0 then
  begin
    recN := GetInfoRec(PEventListItem(item).Adr);
    if Assigned(recN) and recN.HasName then
    begin
      Result:=PEventListItem(item).EventName + '=' + recN.Name;
      Exit;
    End;
  End;
  Result:=PEventListItem(item).EventName;
end;

Function TIdrDfmFormTree.FindTreeNodeByTag (tag:Pointer):TTreeNode;
Begin
//  TTreeNodeMap::const_iterator it = NodesMap.find(tag);
//  if (it != NodesMap.end()) return it->second;
  Result:=Nil;
end;

Function TIdrDfmFormTree.FindTreeNodeByText (nodeFrom:TTreeNode; Const txt:AnsiString; caseSensitive:Boolean):TTreeNode;
Var
  nodes:TTreeNodes;
  i:Integer;
  ttt:AnsiString;
  startScan:Boolean;
Begin
  Result := Nil;
  If Assigned(nodeFrom) Then startScan:=False
    Else startScan:=True;
  nodes := tvForm.Items;
  for i:=0 to nodes.Count-1 do
  begin
    if not startScan then
    begin
      if nodeFrom = nodes.Item[i] then startScan := true;
      continue;
    End;
    ttt := nodes.Item[i].Text;
    if ((caseSensitive and AnsiContainsStr(nodes.Item[i].Text, txt))
        or (not caseSensitive and AnsiContainsText(nodes.Item[i].Text, txt))
       ) then
    begin
      Result := nodes.Item[i];
      break;
    end;
  End;
end;

Procedure TIdrDfmFormTree.AddTreeNodeWithTag (node:TTreeNode; tag:Pointer);
Begin
  //NodesMap[tag] = node;
end;

Function TIdrDfmFormTree.IsEventNode (selNode:TTreeNode):Boolean;
Begin
  Result:= Assigned(selNode) and (selNode.Text<>'') and (Pos('=',selNode.Text)<>0);
end;

procedure TIdrDfmFormTree.FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    Key := 0;
    Close;
    TForm(Owner).SetFocus;
  end
  else if Key=VK_F3 then dlgFindFind(Sender)
  else if (ssCtrl in Shift) and (Key=Ord('F')) then dlgFind.Execute;
end;

procedure TIdrDfmFormTree.tvFormKeyPress(Sender : TObject; Var Key:Char);
begin
  if Key=#13 Then
  Begin
    Key:=#0;
    tvFormDblClick(Sender);
  end;
end;

Procedure TIdrDfmFormTree.BorderTheControl (aControl:TControl);
Var
  can:TControlCanvas;
  parCtrl:TWinControl;
  aDC:HDC;
  aRect:TRect;
  aHandle:HWND;
  frm:TForm;
  bMenu:Boolean;
Begin
  can:=TControlCanvas.create;
  parCtrl := aControl.Parent;
  if Not Assigned(parCtrl) Then parCtrl := TWinControl(aControl);
  can.Control := parCtrl;
  aHandle := parCtrl.Handle;
  aDC := GetWindowDC(aHandle);
  with Can do
  begin
    Handle := aDC;
    Brush.Style := bsSolid;
    Pen.Width := 1;
    Pen.Color := clRed;
  end;
  aRect := aControl.ClientRect;
  frm := parCtrl as TForm;
  bMenu := Assigned(frm) and Assigned(frm.Menu);
  AdjustWindowRectEx(aRect,
                     GetWindowLong(aHandle, GWL_STYLE),
                     bMenu,
                     GetWindowLong(aHandle, GWL_EXSTYLE));
  MoveWindowOrg(aDC, -aRect.Left, -aRect.Top);
  if parCtrl = aControl then aRect := aControl.ClientRect
  else
  begin
    aRect := aControl.BoundsRect;
    InflateRect(aRect, 2, 2);
  End;
  //C->Rectangle(aRect);
  can.DrawFocusRect(aRect);
  ReleaseDC(aHandle, aDC);
end;

procedure TIdrDfmFormTree.tvFormDblClick(Sender : TObject);
var
  selNode:TTreeNode;
  Adr,i:Integer;
  recN:InfoRec;
  selControl:TControl;
  parControl:TWinControl;
  ownerForm:TForm;
begin
  selNode := tvForm.Selected;
  if not Assigned(selNode) Then Exit;
  if IsEventNode(selNode) then
  begin
    Adr := Integer(selNode.Data);
    if (Adr<>0) and IsValidCodeAdr(Adr) then
    begin
      recN := GetInfoRec(Adr);
      if Assigned(recN) then
      begin
        if recN.kind = ikVMT then FMain.ShowClassViewer(Adr)
          else FMain.ShowCode(Adr, 0, -1, -1);
      end;
    End;
    Exit;
  End;
  selControl := TControl(selNode.Data);
  if Not Assigned(selControl) Then Exit;
  parControl := selControl.Parent;
  if Not Assigned(parControl) Then Exit;
  ownerForm := TForm(Owner);
  ownerForm.BringToFront;
  selControl.BringToFront;
  for i := 0 to 1 do
  begin
    BorderTheControl(selControl);
    selControl.Hide;
    selControl.Update;
    Sleep(150);
    BorderTheControl(selControl);
    selControl.Show;
    selControl.Update;
    Sleep(150);
  End;
  BringToFront;
end;

procedure TIdrDfmFormTree.dlgFindFind(Sender : TObject);
var
  caseSensitive:Boolean;
  tn:TTreeNode;
begin
  caseSensitive := frMatchCase in dlgFind.Options;
  tn := FindTreeNodeByText(tvForm.Selected, dlgFind.FindText, caseSensitive);
  if Not Assigned(tn) Then tn := FindTreeNodeByText(Nil, Trim(dlgFind.FindText), caseSensitive);
  if Assigned(tn) Then
  begin
    tvForm.Selected := tn;
    tn.Expand(false);
    tvForm.SetFocus;
  end;
end;

procedure TIdrDfmFormTree.Expand1Click(Sender : TObject);
begin
  if Assigned(tvForm.Selected) Then tvForm.Selected.Expand(true);
end;

procedure TIdrDfmFormTree.Collapse1Click(Sender : TObject);
begin
  if Assigned(tvForm.Selected) then tvForm.Selected.Collapse(false);
end;

procedure TIdrDfmFormTree.Find1Click(Sender : TObject);
begin
  dlgFind.Execute;
end;

procedure TIdrDfmFormTree.FormClose(Sender : TObject; var Action:TCloseAction);
begin
  dlgFind.CloseDialog;
end;

end.
