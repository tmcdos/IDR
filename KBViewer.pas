unit KBViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFKBViewer=class(TForm)
    lbKB: TListBox;
    lbIDR: TListBox;
    Panel3: TPanel;
    bPrev: TButton;
    bNext: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    lPosition: TLabel;
    Splitter1: TSplitter;
    edtCurrIdx: TEdit;
    lKBIdx: TLabel;
    Panel1: TPanel;
    cbUnits: TComboBox;
    Label1: TLabel;
    lblKbIdxs: TLabel;
    procedure bPrevClick(Sender : TObject);
    procedure bNextClick(Sender : TObject);
    procedure btnOkClick(Sender : TObject);
    procedure btnCancelClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure edtCurrIdxChange(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure cbUnitsChange(Sender : TObject);
  private
    { Private declarations }
    UnitsNum:Integer;
    CurrIdx:Integer;
    CurrAdr:Integer;
  public
    { Public declarations }
    Position:Integer;
    FromIdx:Integer;//First Unit idx
    ToIdx:Integer;  //Last Unit idx
    Procedure ShowCode(adr:Integer; idx:Integer);
  end;

Var
  FKBViewer:TFKBViewer;
  
implementation

{$R *.DFM}

Uses Def_know,Def_Disasm,Main,KnowledgeBase,Infos,Heuristic,Misc,Types;

procedure TFKBViewer.FormCreate(Sender : TObject);
begin
  CurrIdx:=-1;
  lbIDR.Canvas.Font.Assign(lbIDR.Font);
  lbKB.Canvas.Font.Assign(lbKB.Font);
end;

Procedure TFKBViewer.ShowCode (adr:Integer; idx:Integer);
var
  outfixup:Boolean;
  n, m, wid, maxwid, row:Integer;
  firstProcIdx, lastProcIdx:Integer;
  Val, Adres:Integer;
  canva:TCanvas;
  line,disLine:AnsiString;
  DisInfo:TDisInfo;
  pInfo:MProcInfo;
  _bytes:Integer;
  instrLen, _pos:Integer;
  curAdr:Integer;
  p:PAnsiChar;
  fixupType:Char;
  fixupOfs:Integer;
  len:Word;
  fixupName:AnsiString;
  Op:Byte;
Begin
  CurrIdx := idx;
  CurrAdr := adr;
  edtCurrIdx.Text := IntToStr(CurrIdx);
  lPosition.Caption := IntToStr(CurrIdx - Position);
  lbIDR.Clear;
  canva := lbIDR.canvas;
  maxwid := 0;
  for m := 0 To FMain.lbCode.Count-1 do
  begin
    line := FMain.lbCode.Items[m];
    //Ignore first byte (for symbol <)
    _bytes := Length(line) - 1;
    //If instruction, ignore flags (last byte)
    if m<>0 then Dec(_bytes);
    //Extract original instruction
    line := Copy(line,2, _bytes);
    //For first row add prefix IDR:
    if m=0 then line := 'IDR:' + line;
    lbIDR.Items.Add(line);
    wid := canva.TextWidth(line);
    if wid > maxwid then maxwid := wid;
  End;
  lbIDR.ScrollWidth := maxwid + 2;
  lbKB.Clear;
  row := 0;
  maxwid := 0;
  if KBase.GetProcInfo(CurrIdx, INFO_DUMP, pInfo) then
  begin
    cbUnits.Text := KBase.GetModuleName(pInfo.ModuleID);
    KBase.GetProcIdxs(pInfo.ModuleID, @firstProcIdx, @lastProcIdx);
    lblKbIdxs.Caption := IntToStr(firstProcIdx) + ' - ' + IntToStr(lastProcIdx);
    canva := lbKB.canvas;
    line := 'KB:' + pInfo.ProcName;
    lbKB.Items.Add(line);
    Inc(row);
    wid := canva.TextWidth(line);
    if wid > maxwid then maxwid := wid;
    _pos := 0;
    curAdr := adr;
    if pInfo.FixupNum<>0 then
    begin
      p := PAnsiChar(pInfo.Dump) + 2*pInfo.DumpSz;
      for n := 0 To pInfo.FixupNum-1 do
      begin
        fixupType := p^;
        Inc(p);
        fixupOfs := PInteger(p)^;
        Inc(p,4);
        len := PWord(p)^;
        Inc(p,2);
        SetLength(fixupName,len);
        StrLCopy(PAnsiChar(fixupName),p,len);
        Inc(p,len + 1);
        while (_pos <= fixupOfs) and (_pos < pInfo.DumpSz) do
        begin
          instrLen := frmDisasm.Disassemble(pInfo.Dump + _pos, curAdr, @DisInfo, @disLine);
          if instrLen=0 then
          begin
            lbKB.Items.Add(Val2Str(curAdr,8) + '      ???');
            Inc(row);
            Inc(_pos);
            Inc(curAdr);
            continue;
          End;
          op := frmDisasm.GetOp(DisInfo.Mnem);
          line := Val2Str(curAdr,8) + '      ' + disLine;
          outfixup := false;
          if _pos + instrLen > fixupOfs then
          begin
            if DisInfo.Call then
            begin
              line := Val2Str(curAdr,8) + '      call        ';
              outfixup := true;
            end
            else if op = OP_JMP then
              line := Val2Str(curAdr,8) + '      jmp         '
            else line:=line + ';';
            if not SameText(fixupName, pInfo.ProcName) then line:=line + fixupName
            else
            begin
              Val := PInteger(Code + Adr2Pos(CurrAdr) + fixupOfs)^;
              if fixupType = 'J' then
                Adres := CurrAdr + fixupOfs + Val + 4
              else Adres := Val;
              line:=line + Val2Str(Adres,8);
            End;
          End;
          lbKB.Items.Add(line);
          if outfixup then lbKB.Selected[row] := true;
          Inc(row);
          wid := canva.TextWidth(line);
          if wid > maxwid then maxwid := wid;
          Inc(_pos,instrLen);
          Inc(curAdr,instrLen);
        End;
      End;
    End;
    while _pos < pInfo.DumpSz do
    begin
      instrLen := frmDisasm.Disassemble(pInfo.Dump + _pos, curAdr, @DisInfo, @disLine);
      if instrLen=0 then
      begin
        lbKB.Items.Add(Val2Str(curAdr,8) + '      ???');
        Inc(_pos);
        Inc(curAdr);
        continue;
      End;
      line := Val2Str(curAdr,8) + '      ' + disLine;
      lbKB.Items.Add(line);
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
      Inc(_pos,instrLen);
      Inc(curAdr,instrLen);
    End;
  End;
  lbKB.ScrollWidth := maxwid + 2;
  lbKB.TopIndex := 0;
end;

procedure TFKBViewer.bPrevClick(Sender : TObject);
begin
  if CurrIdx <> -1 then ShowCode(CurrAdr, CurrIdx - 1);
end;

procedure TFKBViewer.bNextClick(Sender : TObject);
begin
  if CurrIdx <> -1 then ShowCode(CurrAdr, CurrIdx + 1);
end;

procedure TFKBViewer.btnOkClick(Sender : TObject);
Var
  m, k1, k2, ap, _pos, pos1, pos2, Idx, val:Integer;
  adr:Integer;
  pInfo:MProcInfo;
  recN:InfoRec;
  kbName, idrName, kbLine, idrLine:AnsiString;
  use:TWordDynArray;
begin
  if KBase.GetProcInfo(CurrIdx, INFO_DUMP or INFO_ARGS, pInfo) then
  begin
    adr := CurProcAdr;
    ap := Adr2Pos(adr);
    if ap < 0 then Exit;
    recN := GetInfoRec(adr);
    if Not Assigned(recN) Then Exit;
    recN.procInfo.DeleteArgs;
    FMain.StrapProc(ap, CurrIdx, @pInfo, false, FMain.EstimateProcSize(CurProcAdr));
    //Strap all selected items (in IDR list box)
    if lbKB.SelCount = lbIDR.SelCount then
    begin
      k1 := 0;
      k2 := 0;
      for m := 0 To lbKB.SelCount-1 do
      begin
        kbLine := '';
        idrLine := '';
        while k1 < lbKB.Items.Count do
        begin
          if lbKB.Selected[k1] then
          begin
            kbLine := lbKB.Items[k1];
            Inc(k1);
            break;
          End;
          Inc(k1);
        End;
        while k2 < lbIDR.Items.Count do
        begin
          if lbIDR.Selected[k2] then
          begin
            idrLine := lbIDR.Items[k2];
            Inc(k2);
            break;
          End;
          Inc(k2);
        End;
        if (kbLine <> '') and (idrLine <> '') then
        begin
          pos1 := Pos('call',kbLine);
          pos2 := Pos('call',idrLine);
          if (pos1<>0) and (pos2<>0) then
          begin
            kbName := Trim(Copy(kbLine,pos1 + 4, Length(kbLine)));
            idrName := Trim(Copy(idrLine,pos2 + 4, Length(idrLine)));
            _pos := Pos(';',idrName);
            if _pos<>0 then idrName := Copy(idrName,1, _pos - 1);
            adr := 0;
            if TryStrToInt('$' + idrName, val) then adr := val;
            ap := Adr2Pos(adr);
            if (kbName <> '') and (ap >= 0) then
            begin
              recN := GetInfoRec(adr);
              recN.procInfo.DeleteArgs;
              use := KBase.GetModuleUses(KBase.GetModuleID(PAnsiChar(cbUnits.Text)));
              Idx := KBase.GetProcIdx(use, PAnsiChar(kbName), Code+ap);
              if Idx <> -1 then
              begin
                Idx := KBase.ProcOffsets[Idx].NamId;
                if not KBase.IsUsedProc(Idx) then
                  if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
                    FMain.StrapProc(ap, Idx, @pInfo, true, pInfo.DumpSz);
              end
              else
              begin
                Idx := KBase.GetProcIdx(use, PAnsiChar(kbName), Nil);
                if Idx <> -1 then
                begin
                  Idx := KBase.ProcOffsets[Idx].NamId;
                  if Not KBase.IsUsedProc(Idx) then
                    if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
                      FMain.StrapProc(ap, Idx, @pInfo, false, FMain.EstimateProcSize(adr));
                End;
              End;
            End;
          End;
        End;
      End;
    End;
    FMain.RedrawCode;
    FMain.ShowUnitItems(FMain.GetUnit(CurUnitAdr), FMain.lbUnitItems.TopIndex, FMain.lbUnitItems.ItemIndex);
  End;
  Close;
end;

procedure TFKBViewer.btnCancelClick(Sender : TObject);
begin
  Close;
end;

procedure TFKBViewer.edtCurrIdxChange(Sender : TObject);
begin
  try
    ShowCode(CurrAdr, StrToInt(edtCurrIdx.Text));
  Except
    on E:Exception do Application.ShowException(E);
  end;
end;

procedure TFKBViewer.cbUnitsChange(Sender : TObject);
Var
  _moduleID:Word;
  k, firstProcIdx, lastProcIdx, idx:Integer;
  pInfo:MProcInfo;
begin
  Position := -1;
  _moduleID := KBase.GetModuleID(PAnsiChar(cbUnits.Text));
  if _moduleID <> $FFFF then
  begin
    if KBase.GetProcIdxs(_moduleID, @firstProcIdx, @lastProcIdx) then
    begin
      edtCurrIdx.Text := IntToStr(firstProcIdx);
      lblKbIdxs.Caption := IntToStr(firstProcIdx) + ' - ' + IntToStr(lastProcIdx);
      for k := firstProcIdx To lastProcIdx do
      begin
        idx := KBase.ProcOffsets[k].ModId;
        if not KBase.IsUsedProc(idx) then
          if KBase.GetProcInfo(idx, INFO_DUMP or INFO_ARGS, pInfo) then
            if MatchCode(Code + Adr2Pos(CurProcAdr), @pInfo) then
            begin
              edtCurrIdx.Text := IntToStr(idx);
              Position := idx;
              break;
            End;
      End;
    End;
  End;
  if Position = -1 then ShowCode(CurProcAdr, firstProcIdx)
    else ShowCode(CurProcAdr, Position);
end;

procedure TFKBViewer.FormShow(Sender : TObject);
Var
  n,ID:Integer;
  p:PAnsiChar;
begin
  if UnitsNum=0 then
    for n := 0 To KBase.ModuleCount-1 do
    begin
      ID := KBase.ModuleOffsets[n].NamId;
      p := KBase.GetKBCachePtr(KBase.ModuleOffsets[ID].Offset, KBase.ModuleOffsets[ID].Size);
      cbUnits.Items.Add(String(p + 4));
      Inc(UnitsNum);
    End;
end;

end.
