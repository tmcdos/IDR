Unit Resources;

Interface

Uses Windows,Messages, SysUtils, Classes, ComCtrls, AppEvnts, UfrmFormTree,
  Controls, StdCtrls, Graphics, Forms, Menus,ExtCtrls,Def_res,ActnList,
  StdActns,ExtActns,Buttons,Mask,Grids,CheckLst,Chart,Series,MPlayer,
  Tabs,Outline,TabNotBk,FileCtrl,Spin,ColorGrd,Gauges,DirOutln,Calendar,ValEdit;

Type
  IdrDfmLoader=class;

  //Records to resource list
  TDfm = class
    Open:Byte;               //2 - form opened; 1 - form closed but loader not destroyed; 0 - form closed
    Flags:Byte;              //Form flags (see FF_...)
    ResName:AnsiString;      //Resource name (ABOUTDIALOG)
    Name:AnsiString;         //Form name (AboutDialog)
    FormClass:AnsiString;    //Form class (TAboutDialog)
    MemStream:TMemoryStream; //Memory Stream, containing Resource Data
    ParentDfm:TDfm;          //Parent form
    Events:TList;			       //Form events list
    Components:TList;        //Form components list
    Form:TForm;              //Pointer to opened form
    Loader:IdrDfmLoader;     //Form loader
    Function IsFormComponent(CompName:AnsiString):Boolean;
    Constructor Create;
    Destructor Destroy; Override;
  end;

  TResourceInfo = class
    citadel:Boolean;
    Counter:Integer;
    hFormPlugin:HINST;
    FormPluginName:AnsiString;
    FormList:TList;      //Form names list
    Aliases:TStringList; //Aliases list
    Constructor Create;
    Destructor Destroy; Override;
    Procedure GetFormAsText(Dfm:TDfm; DstList:TStrings);
    Function EnumResources(FileName:AnsiString):Boolean;
    Procedure ShowResources(ListBox:TListBox);
    Procedure GetBitmap(Dfm:TDfm; DstBitmap:TBitmap);
    Function GetParentDfm(Dfm:TDfm):TDfm;
    Procedure CloseAllForms;
    Procedure ReopenAllForms;
    Procedure InitAliases;
    Function GetAlias(ClasName:AnsiString):AnsiString;
    Function GetFormIdx(FormName:AnsiString; var idx:Integer):TDfm;
    Function GetFormByClassName(ClasName:AnsiString):TDfm;
    Procedure GetEventsList(FormName:AnsiString; Lst:TList);
  end;

  TMyControl = class(TControl)
  Published
    property OnClick;
    property OnMouseDown;
    property PopupMenu;
  end;

  IdrDfmReader = class(TReader)
  Published
    property PropName;
  end;

  TComponentEvents = class(TCollectionItem)
    Component:TComponent;
    FoundEvents:TStringList;
    Constructor Create(Owner:TCollection); Override;
    Destructor Destroy; Override;
  end;

  IdrDfmForm = class(TForm)
  private
    FOnFindMethod:TFindMethodSourceEvent;
    Function getFormName:AnsiString;
    Procedure DoFindMethod(methodName:AnsiString);
    Procedure CMDialogKey(var Message:TCMDialogKey); Message CM_DIALOGKEY;
    Procedure MyFormShow(Sender:TObject);
    Procedure MyFormClose(Sender:TObject; var Action:TCloseAction);
    Procedure MyFormKeyDown(Sender:TObject; var Key:Word; Shift:TShiftState);
    Procedure MyShortCutEvent(var Msg:TWMKey; Var Handled:Boolean);
	  Procedure ShowMyPopupMenu(FormName, ControlName:AnsiString; show:Boolean);
  protected
    Procedure CreateHandle; Override;
    Procedure SetupControlHint(FormName:AnsiString; Control:TControl; InitHint:AnsiString);
    Procedure SetupMenuItem(mi:TMenuItem; searchName:AnsiString);
    Procedure ActionExecute(Sender:TObject);
    Procedure miClick(Sender:TObject);
    Procedure ControlMouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
    Procedure miPopupClick(Sender:TObject);
  public
    originalClassName:AnsiString;
    originalClassType:AnsiString;
    current:TComponentEvents;
    compsEventsList:TCollection;
    evPopup:TPopupMenu;
    frmTree:TIdrDfmFormTree;
    Procedure SetupControls;
    Procedure SetupControlResetShortcut(component:TComponent);
    Procedure SetDesigning(value, SetChildren:Boolean);
    Procedure SetMyHandlers;
    constructor Create(AOwner:TComponent); overload; override;
    constructor Create2(AOwner:TComponent; Dummy:Integer);
    Destructor Destroy; Override;
    property OnFindMethod:TFindMethodSourceEvent read FOnFindMethod write FOnFindMethod;
  end;

  IdrDfmLoader = class(TComponent)
  private
    dfmForm:IdrDfmForm;
    FOnFindMethod:TFindMethodSourceEvent;
  protected
    Counter:Integer;
    Current:TComponentEvents;
    CompsEventsList:TCollection;
    lastClassAliasName:AnsiString;
    procedure AncestorNotFound(Reader:TReader; Const ComponentName:AnsiString; ComponentClass:TPersistentClass; var Component:TComponent);
    procedure ReaderError(Reader:TReader; const Message:AnsiString; Var Handled:Boolean);
    procedure FindComponentClass(Reader:TReader; Const ClasName:AnsiString; var ComponentClass:TComponentClass);
    procedure CreateComponent(Reader:TReader; ComponentClass:TComponentClass; var Component:TComponent);
    procedure FindMethod(Reader:TReader; Const MethodName:AnsiString; var Address:Pointer; Var Error:Boolean);
    procedure SetComponentName(Reader:TReader; Component:TComponent; Var Name:AnsiString);
    procedure DoReferenceName(Reader:TReader; Var Name:AnsiString);
    Function HasGlyph(ClasName:AnsiString):Boolean;
  public
    Constructor Create(Owner:TComponent); Override;
    Destructor Destroy; Override;
    Function LoadForm(dfmStream:TStream; Dfm:TDfm; loadingParent:Boolean = false):TForm;
    property OnFindMethod:TFindMethodSourceEvent read FOnFindMethod write FOnFindMethod;
  end;

  IdrDfmDefaultControl = class(TPanel)
  private
    originalClassName, mappedClassName:AnsiString;
    //image for std nonvisual controls (dialogs, etc) (dclstd60.bpl has images)
    imgIcon:TImage;
    Procedure ImageMouseDown(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
    Function HasIconForClass(const name:AnsiString):Boolean;
    Procedure CreateImageIconForClass(const imgFile:AnsiString);
  protected
    Procedure Loaded; Override;
    Procedure ReadState(Reader:TReader); Override;
    Procedure Paint; Override;
  public
    Constructor Create(Owner:TComponent); Override;
    Function IsVisible:Boolean;
    Procedure SetClassName(const name, mappedName:AnsiString);
    Property OrigClassName:AnsiString Read originalClassName;
  end;

  {IdrImageControl = class(TImage)
  protected
    Procedure Paint; Override;
  public
   Constructor Create(Owner:TComponent); Override;
  end;}

Const
  RegClasses:Array[0..115] of RegClassInfo = (
    //Standard
    (RegClass:TFrame; ClasName: 'TFrame'),
    (RegClass:TMainMenu; ClasName: 'TMainMenu'),
    (RegClass:TPopupMenu; ClasName: 'TPopupMenu'),
    (RegClass:TLabel; ClasName: 'TLabel'),
    (RegClass:TEdit; clasName: 'TEdit'),
    (RegClass:TLabeledEdit; clasName: 'TLabeledEdit'),
    (RegClass:TMemo; clasName: 'TMemo'),
    (RegClass:TButton; clasName: 'TButton'),
    (RegClass:TCheckBox; clasName: 'TCheckBox'),
    (RegClass:TRadioButton; clasName: 'TRadioButton'),
    (RegClass:TListBox; clasName: 'TListBox'),
    (RegClass:TComboBox; clasName: 'TComboBox'),
    (RegClass:TScrollBar; clasName: 'TScrollBar'),
    (RegClass:TGroupBox; clasName: 'TGroupBox'),
    (RegClass:TRadioGroup; clasName: 'TRadioGroup'),
    (RegClass:TPanel; clasName: 'TPanel'),
    (RegClass:TActionList; clasName: 'TActionList'),
    (RegClass:TAction; clasName: 'TAction'),
    (RegClass:TEditCut; clasName: 'TEditCut'),
    (RegClass:TEditCopy; clasName: 'TEditCopy'),
    (RegClass:TEditPaste; clasName: 'TEditPaste'),
    (RegClass:TEditSelectAll; clasName: 'TEditSelectAll'),
    (RegClass:TEditUndo; clasName: 'TEditUndo'),
    (RegClass:TEditDelete; clasName: 'TEditDelete'),
    (RegClass:TWindowClose; clasName: 'TWindowClose'),
    (RegClass:TWindowCascade; clasName: 'TWindowCascade'),
    (RegClass:TWindowTileHorizontal; clasName: 'TWindowTileHorizontal'),
    (RegClass:TWindowTileVertical; clasName: 'TWindowTileVertical'),
    (RegClass:TWindowMinimizeAll; clasName: 'TWindowMinimizeAll'),
    (RegClass:TWindowArrange; clasName: 'TWindowArrange'),
    (RegClass:THelpContents; clasName: 'THelpContents'),
    (RegClass:THelpTopicSearch; clasName: 'THelpTopicSearch'),
    (RegClass:THelpOnHelp; clasName: 'THelpOnHelp'),
    (RegClass:THelpContextAction; clasName: 'THelpContextAction'),
    (RegClass:TFileOpen; clasName: 'TFileOpen'),
    (RegClass:TFileOpenWith; clasName: 'TFileOpenWith'),
    (RegClass:TFileSaveAs; clasName: 'TFileSaveAs'),
    (RegClass:TFilePrintSetup; clasName: 'TFilePrintSetup'),
    (RegClass:TFileExit; clasName: 'TFileExit'),
    (RegClass:TSearchFind; clasName: 'TSearchFind'),
    (RegClass:TSearchReplace; clasName: 'TSearchReplace'),
    (RegClass:TSearchFindFirst; clasName: 'TSearchFindFirst'),
    (RegClass:TSearchFindNext; clasName: 'TSearchFindNext'),
    (RegClass:TFontEdit; clasName: 'TFontEdit'),
    (RegClass:TColorSelect; clasName: 'TColorSelect'),
    (RegClass:TPrintDlg; clasName: 'TPrintDlg'),
    //TRichEditxxx actions?
    //TListControlXXX ?
    (RegClass:TOpenPicture; clasName: 'TOpenPicture'),
    (RegClass:TSavePicture; clasName: 'TSavePicture'),
    //Additional
    (RegClass:TBitBtn; clasName: 'TBitBtn'),
    (RegClass:TSpeedButton; clasName: 'TSpeedButton'),
    (RegClass:TMaskEdit; clasName: 'TMaskEdit'),
    (RegClass:TStringGrid; clasName: 'TStringGrid'),
    (RegClass:TDrawGrid; clasName: 'TDrawGrid'),
    (RegClass:TImage; clasName: 'TImage'),
    (RegClass:TPicture; clasName: 'TPicture'),
    (RegClass:TBitmap; clasName: 'TBitmap'),
    (RegClass:TGraphic; clasName: 'TGraphic'),
    (RegClass:TMetafile; clasName: 'TMetafile'),
    (RegClass:TIcon; clasName: 'TIcon'),

    (RegClass:TShape; clasName: 'TShape'),
    (RegClass:TBevel; clasName: 'TBevel'),
    (RegClass:TScrollBox; clasName: 'TScrollBox'),
    (RegClass:TCheckListBox; clasName: 'TCheckListBox'),
    (RegClass:TSplitter; clasName: 'TSplitter'),
    (RegClass:TStaticText; clasName: 'TStaticText'),
    (RegClass:TControlBar; clasName: 'TControlBar'),
    (RegClass:TChart; clasName: 'TChart'),
    (RegClass:TBarSeries; clasName: 'TBarSeries'),
    (RegClass:THorizBarSeries; clasName: 'THorizBarSeries'),
    (RegClass:TPointSeries; clasName:  'TPointSeries'),
    (RegClass:TAreaSeries; clasName: 'TAreaSeries'),
    (RegClass:TLineSeries; clasName: 'TLineSeries'),
    (RegClass:TFastLineSeries; clasName: 'TFastLineSeries'),
    (RegClass:TPieSeries; clasName: 'TPieSeries'),
    (RegClass:TColorBox; clasName: 'TColorBox'),
    //Win32
    (RegClass:TTabControl; clasName: 'TTabControl'),
    (RegClass:TPageControl; clasName: 'TPageControl'),
    (RegClass:TTabSheet; clasName: 'TTabSheet'),
    (RegClass:TImageList; clasName: 'TImageList'),
    (RegClass:TRichEdit; clasName: 'TRichEdit'),
    (RegClass:TTrackBar; clasName: 'TTrackBar'),
    (RegClass:TProgressBar; clasName: 'TProgressBar'),
    (RegClass:TUpDown; clasName: 'TUpDown'),
    (RegClass:THotKey; clasName: 'THotKey'),
    (RegClass:TAnimate; clasName: 'TAnimate'),
    (RegClass:TDateTimePicker; clasName: 'TDateTimePicker'),
    (RegClass:TMonthCalendar; clasName: 'TMonthCalendar'),
    (RegClass:TTreeView; clasName: 'TTreeView'),
    (RegClass:TListView; clasName: 'TListView'),
    (RegClass:THeaderControl; clasName: 'THeaderControl'),
    (RegClass:TStatusBar; clasName: 'TStatusBar'),
    (RegClass:TToolBar; clasName: 'TToolBar'),
    (RegClass:TToolButton; clasName: 'TToolButton'),
    (RegClass:TCoolBar; clasName: 'TCoolBar'),
    (RegClass:TComboBoxEx; clasName: 'TComboBoxEx'),
    (RegClass:TPageScroller; clasName: 'TPageScroller'),
    //System
    //RegClass:TPaintBox),
    (RegClass:TMediaPlayer; clasName: 'TMediaPlayer'),
    //Win 3.1
    (RegClass:TTabSet; clasName: 'TTabSet'),
    (RegClass:TOutline; clasName: 'TOutline'),
    (RegClass:TTabbedNotebook; clasName: 'TTabbedNotebook'),
    (RegClass:TNotebook; clasName: 'TNotebook'),
    (RegClass:TPage; clasName: 'TPage'),
    (RegClass:THeader; clasName: 'THeader'),
    (RegClass:TFileListBox; clasName: 'TFileListBox'),
    (RegClass:TDirectoryListBox; clasName: 'TDirectoryListBox'),
    (RegClass:TDriveComboBox; clasName: 'TDriveComboBox'),
    (RegClass:TFilterComboBox; clasName: 'TFilterComboBox'),
    //Samples
    //(RegClass:TPerformanceGraph; clasName: 'TPerformanceGraph'),
    (RegClass:TSpinButton; clasName: 'TSpinButton'),
    (RegClass:TTimerSpeedButton; clasName: 'TTimerSpeedButton'),
    (RegClass:TSpinEdit; clasName: 'TSpinEdit'),
    (RegClass:TColorGrid; clasName: 'TColorGrid'),
    (RegClass:TGauge; clasName: 'TGauge'),
    (RegClass:TDirectoryOutline; clasName: 'TDirectoryOutline'),
    (RegClass:TCalendar; clasName: 'TCalendar'),
    //(RegClass:TPie; clasName: 'TPie'),
    (RegClass:TValueListEditor; clasName: 'TValueListEditor'),
    (RegClass:IdrDfmDefaultControl; clasName: 'Default')
    //(RegClass:Nil; clasName:'')
  );

Implementation

Uses
  Misc,Main,Dialogs,StrUtils,Infos,Def_info,Def_main;

Type
  PfnGetDstSize = Function (MemPtr:Pointer; Len:Integer):Integer; stdcall;
  PfnDecrypt = Function (SrcPtr:Pointer; SrcLen:Integer; DstPtr:Pointer; DstLen:Integer):Boolean; stdcall;

Var
  classesRegistered:Boolean;
  fnGetDstSize:PfnGetDstSize;
  fnDecrypt:PfnDecrypt;

Constructor TDfm.Create;
Begin
  MemStream:=TMemoryStream.Create;
  Events:=TList.Create;
  Components:=TList.Create;
end;

Destructor TDfm.Destroy;
Var
  n,m:Integer;
  cInfo:PComponentInfo;
Begin
  MemStream.Free;
  for n := 0 to Events.Count-1 do
    Finalize(PEventInfo(Events[n])^);
  Events.Free;
  for n := 0to Components.Count-1 do
  begin
    cInfo := Components[n];
    if Assigned(cInfo.Events) then
    begin
      for m := 0 to cInfo.Events.Count-1 do
        Finalize(PEventInfo(cInfo.Events[m])^);
      cInfo.Events.Free;
    end;
    Finalize(cInfo^);
  end;
  Components.Free;
  Form.Free;
  Loader.Free;
  Inherited;
end;

Function TDfm.IsFormComponent (CompName:AnsiString):Boolean;
var
  m:Integer;
Begin
  Result:=False;
  For m:=0 to Components.Count-1 do
    if SameText(CompName, PComponentInfo(Components[m]).Name) then
    Begin
      Result:=true;
      Exit;
    end;
end;

Constructor TResourceInfo.Create;
var
  n:Integer;
Begin
  FormList:=TList.Create;
  Aliases:=TStringList.Create;
  if not ClassesRegistered then
  Begin
    for n := Low(RegClasses) to High(RegClasses) do
      RegisterClass(RegClasses[n].RegClass);
    ClassesRegistered := true;
  end;
end;

Destructor TResourceInfo.Destroy;
Var
  n:Integer;
Begin
  if hFormPlugin<>0 then
  begin
    FreeLibrary(hFormPlugin);
    hFormPlugin := 0;
  end;
  for n := 0 to FormList.Count-1 do
    TDfm(FormList[n]).Free;
  FormList.Free;
  Aliases.Free;
  Inherited;
end;

Function AnalyzeSection(Dfm:TDfm;FormText:TStringList; From:Integer; cInfo:PComponentInfo; objAlign:Integer):Integer;
var
  n, _pos, _end,tmp,off,align:Integer;
  componentName, componentClass, eventName, procName,line:AnsiString;
  _Info:PComponentInfo;
  eInfo:PEventInfo;
  is_inherit:Boolean;
Begin
  n := From;
  While n < FormText.Count do
  begin
    line := Trim(FormText[n]);
    if line = '' then
    begin
      Inc(n);
      continue;
    end;
    align := Pos(line,FormText[n]);
    if SameText(line, 'end') and (align = objAlign) then break;
    is_inherit := Pos('inherited ',line) = 1;
    if (Pos('object ',line) = 1) or is_inherit then
    begin
      _pos := Pos(':',line);
      _end := Length(line);
      tmp := Pos(' [',line);   //eg: object Label1: TLabel [1]
      if tmp<>0 then _end := tmp - 1;
      if is_inherit then off:=10 else off:=7;
      //object Label1: TLabel
      if _pos<>0 then
      begin
        componentName := Trim(Copy(line,off, _pos - off));
        componentClass := Trim(Copy(line,_pos + 1, _end - _pos));
      End
      //object TLabel
      else
      begin
        componentName := '_' + Val2Str(ResInfo.Counter,4) + '_';
        Inc(ResInfo.Counter);
        componentClass := Trim(Copy(line,off, _end - off + 1));
      End;
      New(_Info);
      with _Info^ do
      begin
        inherit := is_inherit;
        HasGlyph := false;
        Name := componentName;
        ClasName := componentClass;
        Events := TList.create;
      end;
      Dfm.Components.Add(_Info);
      if ResInfo.Aliases.IndexOf(_Info.ClasName) = -1 then
          ResInfo.Aliases.Add(_Info.ClasName);
      n := AnalyzeSection(Dfm, FormText, n + 1, _Info, align);
    End;
    //Events begins with "On" or "Action". But events of TDataSet may begin with no these prefixes!!!
    _pos := Pos('=',line);
    if _pos <> 0 Then
      if ((line[1] = 'O') and (line[2] = 'n')) or (Pos('Action ',line) = 1) then
      begin
        eventName := Trim(Copy(line,1, _pos - 1));   //Include "On"
        procName := Trim(Copy(line,_pos + 1, Length(line) - _pos));
        New(eInfo);
        eInfo.EventName := eventName;
        eInfo.ProcName := procName;
        //Form itself
        if CInfo=Nil then Dfm.Events.Add(eInfo)
          else CInfo.Events.Add(eInfo);
      End;
    //Has property Glyph?
    if Pos('Glyph.Data =',line) = 1 Then CInfo.HasGlyph := true;
    Inc(n);
  End;
  Result:=n;
end;

Function EnumResNameProcedure(hModule:Integer; _Type, Name:PAnsiChar; Param:TResourceInfo):BOOL; stdcall;
var
  res,is_inherit:Boolean;
  srcSize, dstSize:Integer;
  dfm:TDfm;
  formText:TStringList;
  ms,ds:TMemoryStream;
  resStream:TResourceStream;
  mp:PAnsiChar;
  line:AnsiString;
  off,_pos:Integer;
  signature:Array[1..4] of Char;
  len:Byte;
Begin
  if (_Type = RT_RCDATA) or (_Type = RT_BITMAP) then
  begin
    resStream := TResourceStream.Create(hModule, Name, _Type);
    if _Type = RT_RCDATA then
    begin
      ms := TMemoryStream.Create;
      ms.LoadFromStream(resStream);
      res := true;
      if ResInfo.hFormPlugin<>0 then
      begin
        @fnGetDstSize := GetProcAddress(ResInfo.hFormPlugin, 'GetDstSize');
        @fnDecrypt := GetProcAddress(ResInfo.hFormPlugin, 'Decrypt');
        res := Assigned(fnGetDstSize) and Assigned(fnDecrypt);
        if res then
        begin
          srcSize := ms.Size;
          dstSize := fnGetDstSize(ms.Memory, srcSize);
          if srcSize <> dstSize then
          begin
            ds := TMemoryStream.Create;
            ds.Size := dstSize;
            res := fnDecrypt(ms.Memory, srcSize, ds.Memory, dstSize);
            ms.Size := dstSize;
            ms.CopyFrom(ds, dstSize);
            ds.free;
          end
          else res := fnDecrypt(ms.Memory, srcSize, ms.Memory, dstSize);
        end;
        if res then
        begin
          mp := ms.Memory;
          len := Byte((mp + 4)^);
          res := (len = strlen(Name)) and SameText(Name, MakeString(mp + 5, len));
        End;
      end;
      if res then
      begin
        ms.Seek(0, soFromBeginning);
        ms.Read(signature, 4);
        if (signature[1] = 'T') And (signature[2] = 'P') and (signature[3] = 'F')
          and (signature[4] in ['0'..'7']) then
        begin
          if signature[4] = '0' then
          begin
            //Добавляем в список ресурсов
            dfm := TDfm.Create;
            dfm.ResName := Name;
            dfm.MemStream := ms;
            //Analyze text representation
            formText := TStringList.Create;
            ResInfo.GetFormAsText(dfm, formText);
            line := formText[0];
            is_inherit := Pos('inherited ',line) = 1;
            if is_inherit then dfm.Flags:=dfm.flags or FF_INHERITED;
            if (Pos('object ',line) = 1) or is_inherit then
            begin
              if is_inherit Then off := 10 else off:=7;
              _pos := Pos(':',line);
              dfm.Name := Trim(Copy(line,off, _pos - off));
              dfm.FormClass := Trim(Copy(line,_pos + 1, Length(line) - _pos));
              AnalyzeSection(dfm, formText, 1, Nil, 1);
            end;
            formText.free;
            Param.FormList.Add(dfm);
          end
          else if not ResInfo.citadel then
          begin
            ShowMessage('Citadel for Delphi detected, forms cannot be loaded');
            ResInfo.citadel := true;
          End;
        end
        else ms.Free;
      end
      else ms.free;
    end
    else if _Type = RT_BITMAP then
    begin
      dfm := TDfm.Create;
      dfm.ResName := Name;
      dfm.MemStream.LoadFromStream(resStream);
      Param.FormList.Add(dfm);
    end;
    resStream.free;
  End;
  Result:=true;
end;

Function TResourceInfo.EnumResources (FileName:AnsiString):Boolean;
var
  _Inst:HINST;
Begin
  Result:=false;
  hFormPlugin := LoadLibrary(PAnsiChar(FMain.AppDir + 'Plugins\' + FormPluginName));
  _Inst := LoadLibraryEx(PAnsiChar(FileName), 0, LOAD_LIBRARY_AS_DATAFILE);
  if _Inst<>0 then
  begin
    EnumResourceNames(_Inst, RT_RCDATA, @EnumResNameProcedure, Integer(Self));
    FreeLibrary(_Inst);
    Result:=true;
    Exit;
  end;
  if hFormPlugin<>0 then
  begin
    FreeLibrary(hFormPlugin);
    hFormPlugin := 0;
  end;
end;

Procedure TResourceInfo.ShowResources (ListBox:TListBox);
var
  Wid,maxwid,n:Integer;
  canva:TCanvas;
  dfm:TDfm;
Begin
  ListBox.Clear;
  maxwid := 0;
  canva := ListBox.Canvas;
  for n := 0 to FormList.Count-1 do
  begin
    dfm := TDfm(FormList[n]);
    ListBox.Items.Add(dfm.ResName + ' {' + dfm.Name + '}');
    wid := canva.TextWidth(dfm.ResName);
    if wid > maxwid then maxwid := wid;
  end;
  ListBox.ScrollWidth := maxwid + 2;
end;

Procedure TResourceInfo.GetFormAsText (Dfm:TDfm; DstList:TStrings);
var
  ms:TMemoryStream;
Begin
  ms:=TMemoryStream.Create;
  try
    ms.Size := Dfm.MemStream.Size;
    Dfm.MemStream.Seek(0, soFromBeginning);
    ObjectBinaryToText(Dfm.MemStream, ms);
    ms.Seek(0, soFromBeginning);
    DstList.LoadFromStream(ms);
  Finally
    ms.Free;
  end;
end;

Procedure TResourceInfo.GetBitmap (Dfm:TDfm; DstBitmap:TBitmap);
Begin
  Dfm.MemStream.Seek(0, soFromBeginning);
  DstBitmap.LoadFromStream(Dfm.MemStream);
end;

Function TResourceInfo.GetParentDfm (Dfm:TDfm):TDfm;
var
  parentName:AnsiString;
  n:Integer;
Begin
  parentName := GetParentName(Dfm.FormClass);
  for n := 0 to FormList.Count-1 do
  begin
    Result:= TDfm(FormList[n]);
    if SameText(Result.FormClass, parentName) then Exit;
  end;
  Result:=Nil;
end;

Procedure TResourceInfo.CloseAllForms;
var
  n:Integer;
  dfm:TDfm;
Begin
  for n := 0 to FormList.Count-1 do
  begin
    dfm := TDfm(FormList[n]);
    if dfm.Open = 2 then
    begin
      if Assigned(dfm.Form) and dfm.Form.Visible then dfm.Form.Close;
      dfm.Form := Nil;
      dfm.Open := 1;
    End;
    if dfm.Open = 1 then
    begin
      dfm.Loader.Free;
      dfm.Form := Nil;
      dfm.Loader := Nil;
      dfm.Open := 0;
    End;
  end;

  //this is a must have call!
  //it removes just closed form from the Screen->Forms[] list!
  //and we'll not have a new form with name [old_name]_1 !
  Application.ProcessMessages;
end;

Procedure TResourceInfo.ReopenAllForms;
var
  n,Idx:Integer;
  dfm:TDfm;
  FormName:AnsiString;
Begin
  for n := 0 to FormList.Count-1 do
  begin
    dfm := TDfm(FormList[n]);
    if dfm.Open = 2 Then  //still opened
      if Assigned(dfm.Form) and dfm.Form.Visible then
      begin
        FormName := dfm.Form.Name;
        dfm.Form.Close;

        //this is a must have call!
        //it removes just closed form from the Screen->Forms[] list!
        //and we'll not have a new form with name [old_name]_1 !
        Application.ProcessMessages;

        Idx := -1;
        dfm := GetFormIdx(FormName, Idx);
        FMain.ShowDfm(dfm);
      End;
  end;
end;

Procedure TResourceInfo.InitAliases;
var
  n:Integer;
  Alias,clasName:AnsiString;
  componentClass:TPersistentClass;
Begin
  for n := 0 to Aliases.Count-1 do
  begin
    clasName := Aliases[n];
    if Pos('=',clasName)=0 then
    begin
      alias := '';
      try
        componentClass := FindClass(clasName);
      except
        on E:Exception do
        begin
          if SameText(clasName, 'TDBGrid') then alias := 'TStringGrid'
          else if SameText(clasName, 'TDBText') Then alias := 'TLabel'
          else if SameText(clasName, 'TDBEdit') Then alias := 'TEdit'
          else if SameText(clasName, 'TDBMemo') then alias := 'TMemo'
          else if SameText(clasName, 'TDBImage') Then alias := 'TImage'
          else if SameText(clasName, 'TDBListBox') then alias := 'TListBox'
          else if SameText(clasName, 'TDBComboBox') then alias := 'TComboBox'
          else if SameText(clasName, 'TDBCheckBox') then alias := 'TCheckBox'
          else if SameText(clasName, 'TDBRadioGroup') then alias := 'TRadioGroup'
          else if SameText(clasName, 'TDBLookupListBox') then alias := 'TListBox'
          else if SameText(clasName, 'TDBLookupComboBox') then alias := 'TComboBox'
          else if SameText(clasName, 'TDBRichEdit') then alias := 'TRichEdit'
          else if SameText(clasName, 'TDBCtrlGrid') then alias := 'TStringGrid'
          else if SameText(clasName, 'TDBChart') then alias := 'TChart'
          //sample components are redirected to TCxxx components
          else if SameText(clasName, 'TGauge') then alias := 'TCGauge'
          else if SameText(clasName, 'TSpinEdit') then alias := 'TSpinEdit'
          else if SameText(clasName, 'TSpinButton') then alias := 'TSpinButton'
          else if SameText(clasName, 'TCalendar') then alias := 'TCalendar'
          else if SameText(clasName, 'TDirectoryOutline') then alias := 'TDirectoryOutline'
          else if SameText(clasName, 'TShellImageList') then alias := 'TImageList'
          //special case, if not handled - crash (eg:1st Autorun Express app)
          else if GetClass(clasName)=Nil then
          begin
            if IsInheritsByclassName(clasName, 'TBasicAction') then alias := 'TAction'
            else if IsInheritsByclassName(clasName, 'TMainMenu') then alias := 'TMainMenu'
            else if IsInheritsByclassName(clasName, 'TPopupMenu') then alias := 'TPopupMenu'
            else if IsInheritsByclassName(clasName, 'TCustomLabel') or
              AnsiContainsText (clasName, 'Label') then alias:= 'TLabel' //evristika
            else if IsInheritsByclassName(clasName, 'TCustomEdit') then alias := 'TEdit'
            else if IsInheritsByclassName(clasName, 'TCustomMemo') then alias := 'TMemo'
            else if IsInheritsByclassName(clasName, 'TButton') then alias := 'TButton'
            else if IsInheritsByclassName(clasName, 'TCustomCheckBox') then alias := 'TCheckBox'
            else if IsInheritsByclassName(clasName, 'TRadioButton') then alias := 'TRadioButton'
            else if IsInheritsByclassName(clasName, 'TCustomListBox') then alias := 'TListBox'
            else if IsInheritsByclassName(clasName, 'TCustomComboBox') then alias := 'TComboBox'
            else if IsInheritsByclassName(clasName, 'TCustomGroupBox') then alias := 'TGroupBox'
            else if IsInheritsByclassName(clasName, 'TCustomRadioGroup') then alias := 'TRadioGroup'
            else if IsInheritsByclassName(clasName, 'TCustomPanel') then alias := 'TPanel'
            else if IsInheritsByclassName(clasName, 'TBitBtn') then alias := 'TBitBtn'
            else if IsInheritsByclassName(clasName, 'TSpeedButton') then alias := 'TSpeedButton'
            else if IsInheritsByclassName(clasName, 'TImage') then alias := 'TImage'
            else if IsInheritsByclassName(clasName, 'TImageList') then alias := 'TImageList'
            else if IsInheritsByclassName(clasName, 'TBevel') then alias := 'TBevel'
            else if IsInheritsByclassName(clasName, 'TSplitter') then alias := 'TSplitter'
            else if IsInheritsByclassName(clasName, 'TPageControl') then alias := 'TPageControl'
            else if IsInheritsByclassName(clasName, 'TToolBar') then alias := 'TToolBar'
            else if IsInheritsByclassName(clasName, 'TToolButton') then alias := 'TToolButton'
            else if IsInheritsByclassName(clasName, 'TCustomStatusBar') then alias := 'TStatusBar'
            else if IsInheritsByclassName(clasName, 'TDateTimePicker') then alias := 'TDateTimePicker'
            else if IsInheritsByclassName(clasName, 'TCustomListView') then alias := 'TListView'
            else if IsInheritsByclassName(clasName, 'TCustomTreeView') then alias := 'TTreeView'
            else alias := 'Default';
          end;
        End;
      End;
      if alias <> '' then  Aliases[n] := clasName + '=' + alias;
    End;
  end;
end;

Function TResourceInfo.GetAlias (ClasName:AnsiString):AnsiString;
var
  n:Integer;
Begin
  Result:='';
  for n := 0 to Aliases.Count-1 do
    if SameText(ClasName, Aliases.Names[n]) then
    begin
      Result:=Aliases.Values[ClasName];
      Exit;
    end;
end;

Function TResourceInfo.GetFormIdx (FormName:AnsiString; Var idx:Integer):TDfm;
var
  n:Integer;
Begin
  for n := 0 to FormList.Count-1 do
  begin
    Result:= TDfm(FormList[n]);
    //Find form
    if SameText(Result.Name, FormName) then
    begin
      idx := n;
      Exit;
    End;
  end;
  idx := -1;
  Result:=Nil;
end;

Function TResourceInfo.GetFormByClassName (ClasName:AnsiString):TDfm;
var
  n:Integer;
Begin
  for n := 0 to FormList.Count-1 do
  begin
    Result:= TDfm(FormList[n]);
    //Find form
    if SameText(Result.FormClass, ClasName) then Exit;
  end;
  Result:=Nil;
end;

Procedure TResourceInfo.GetEventsList (FormName:AnsiString; Lst:TList);
var
  i,j,k,m,n, r,dot:Integer;
  item:PEventListItem;
  recN, recN1:InfoRec;
  dfm,parentDfm,dfm1:TDfm;
  classAdr:Integer;
  ev,ev1:TList;
  eInfo,eInfo1:PEventInfo;
  recM:PMethodRec;
  cInfo,cInfo1:PComponentInfo;
  methodName,moduleName,actionName:AnsiString;
Begin
  dfm := GetFormIdx(FormName, n);
  if dfm=Nil then Exit;
  classAdr := GetClassAdr(dfm.FormClass);
  if IsValidImageAdr(classAdr) then recN := InfoList[Adr2Pos(classAdr)]
    Else recN:=Nil;
  //Form
  //Inherited - begin fill list
  if (dfm.Flags and FF_INHERITED)<>0 then
  begin
    parentDfm := GetParentDfm(dfm);
    if Assigned(parentDfm) then
    begin
      GetEventsList(parentDfm.Name, Lst);
      //int evCount := Lst.Count;
      //evCount := evCount;
    end;
  end;
  if dfm.Events.Count<>0 then
  begin
    ev := dfm.Events;
    for k := 0 To ev.Count-1 do
    begin
      eInfo := ev[k];
      New(item);
      item.CompName := FormName;
      item.EventName := eInfo.EventName;//eInfo.ProcName;
      //Ищем адрес соответствующего метода
      recM := FMain.GetMethodInfo(recN, dfm.FormClass + '.' + eInfo.ProcName);
      if Assigned(recM) then item.Adr := Integer(recM) Else item.Adr:= 0;
      Lst.Add(item);
    End;
  End;
  //Components
  for m := 0 to dfm.Components.Count-1 do
  begin
    cInfo := dfm.Components[m];
    if cInfo.Events.Count=0 then continue;
    ev := cInfo.Events;
    for k := 0 to ev.Count-1 do
    begin
      recN1 := recN;
      eInfo := ev[k];
      New(item);
      item.CompName := cInfo.Name;
      item.EventName := eInfo.EventName;//eInfo.ProcName;
      methodName := '';
      //Action
      if SameText(eInfo.EventName, 'Action') then
      begin
        //Name eInfo.ProcName like FormName.Name
        dot := Pos('.',eInfo.ProcName);
        if dot<>0 then
        begin
          moduleName := Copy(eInfo.ProcName,1, dot - 1);
          actionName := Copy(eInfo.ProcName,dot + 1, Length(eInfo.ProcName) - dot);
          //Find form moduleName
          for j := 0 to FormList.Count-1 do
          begin
            dfm1 := TDfm(FormList[j]);
            if SameText(dfm1.Name, moduleName) then
            begin
              classAdr := GetClassAdr(dfm1.FormClass);
              if IsValidImageAdr(classAdr) then recN1 := InfoList[Adr2Pos(classAdr)]
                else recN1 := Nil;
              //Find component actionName
              for r := 0 to dfm1.Components.Count-1 do
              begin
                cInfo1 := dfm1.Components[r];
                if SameText(cInfo1.Name, actionName) then
                begin
                  //Find event OnExecute
                  ev1 := cInfo1.Events;
                  for i := 0 to ev1.Count-1 do
                  begin
                    eInfo1 := ev1[i];
                    if SameText(eInfo1.EventName, 'OnExecute') then
                    begin
                      methodName := dfm1.FormClass + '.' + eInfo1.ProcName;
                      break;
                    End;
                  End;
                  break;
                end;
              end;
              break;
            end;
          end;
        end
        else
        begin
          //Find component eInfo.ProcName
          for r := 0 to dfm.Components.Count-1 do
          begin
            cInfo1 := dfm.Components[r];
            if SameText(cInfo1.Name, eInfo.ProcName) then
            begin
              //Find event OnExecute
              ev1 := cInfo1.Events;
              for i := 0 to ev1.Count-1 do
              begin
                eInfo1 := ev1[i];
                if SameText(eInfo1.EventName, 'OnExecute') then
                begin
                  methodName := dfm.FormClass + '.' + eInfo1.ProcName;
                  break;
                end;
              End;
              break;
            end;
          end;
        end;
      end
      else methodName := dfm.FormClass + '.' + eInfo.ProcName;
      //Find method address
      recM := FMain.GetMethodInfo(recN1, methodName);
      if Assigned(recM) then item.Adr := Integer(recM) else recM.address := 0;
      Lst.Add(item);
    End;
  End;
end;

Constructor TComponentEvents.Create (Owner:TCollection);
Begin
  Inherited;
  FoundEvents:=TStringList.Create;
  FoundEvents.Sorted:=True;
end;

Destructor TComponentEvents.Destroy;
Begin
  FoundEvents.Free;
  Inherited;
end;

Constructor IdrDfmForm.Create (AOwner:TComponent);
Begin
  Inherited;
  evPopup:=TPopupMenu.Create(Nil);
  evPopup.AutoPopup:=False;
  evPopup.AutoHotkeys:=maManual;
  KeyPreview:=True;
end;

Constructor IdrDfmForm.Create2(AOwner:TComponent; Dummy:Integer);
Begin
  Inherited Create(Owner);
  evPopup:=TPopupMenu.Create(Nil);
  evPopup.AutoPopup:=False;
  evPopup.AutoHotkeys:=maManual;
  KeyPreview:=True;
end;

Destructor IdrDfmForm.Destroy;
Begin
  compsEventsList.Free;
  compsEventsList := Nil;
  evPopup.Free;
  frmTree.Free;
  frmTree := Nil;
  Inherited;
end;

Procedure IdrDfmForm.SetDesigning (value, SetChildren:Boolean);
Begin
  inherited;
end;

Procedure IdrDfmForm.CreateHandle;
Begin
  if FormStyle = fsMDIChild then FormStyle := fsNormal
    Else Inherited;
end;

//this is required action as sometimes ShortCut from target exe could be same as ours...
Procedure IdrDfmForm.SetupControlResetShortcut (component:TComponent);
Begin
  if component is TCustomAction Then TCustomAction(component).ShortCut := 0
  else if component is TMenuItem then TMenuItem(component).ShortCut:=0;
end;

//different fine-tuning and fixes for components of the DFM Forms
Procedure IdrDfmForm.SetupControls;
var
  component:TComponent;
  control:TControl;
  n:Integer;
  pgControl:TPageControl;
  mi:TMenuItem;
Begin
  component := Self;
  if Self is TControl then
  Begin
    control:=TControl(Self);
    SetupControlHint(Name, control, GetShortHint(control.Hint));
    TMyControl(control).OnMouseDown := ControlMouseDown;
    TMyControl(control).PopupMenu := Nil;
  end;
  If component is TBasicAction Then TBasicAction(component).OnExecute := ActionExecute;
  SetupControlResetShortcut(component);
  for n := 0 to ComponentCount-1 do
  begin
    component := Components[n];
    SetupControlResetShortcut(component);
    if component is TControl then
    begin
      control:=TControl(component);
      SetupControlHint(Name, control, GetShortHint(control.Hint));
      control.Visible := true;
      control.Enabled := true;
      TMyControl(control).OnMouseDown := ControlMouseDown;
      TMyControl(control).PopupMenu := Nil;
    End;
    if component is TPageControl then
    begin
      pgControl:=TPageControl(component);
      if pgControl.PageCount > 0 then
        pgControl.ActivePageIndex := pgControl.PageCount - 1;
    End
    else if component is TTabSheet then TTabSheet(component).TabVisible:=True
    else if component is TBasicAction then TBasicAction(component).OnExecute := ActionExecute
    else if component is TMenuItem then
    begin
      mi:=TMenuItem(component);
      SetupMenuItem(mi, Name); //we start from this form name
      mi.Enabled := true;
    end
    else if component is TProgressBar then TProgressBar(component).Position := TProgressBar(component).Max div 3
    else if component is TStatusBar then TStatusBar(component).AutoHint := false;
  End;
end;

Procedure IdrDfmForm.ControlMouseDown (Sender:TObject; Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
Begin
	if Button = mbRight then
    If Sender is TControl Then
    begin
      evPopup.Items.Clear;
      ShowMyPopupMenu(Name, TControl(Sender).Name, true);
    end;
end;

Procedure IdrDfmForm.miClick (Sender:TObject);
Begin
  with TMenuItem(Sender) do
    if Tag<>0 then FMain.ShowCode(Tag, 0, -1, -1);
end;

Procedure IdrDfmForm.ActionExecute (Sender:TObject);
var
  x:Integer;
Begin
  //note: this is stub, you shold not stop here.....
  //if you are here -> smth not OK
  x:=10;
  Inc(x);
end;

Procedure IdrDfmForm.ShowMyPopupMenu (FormName, ControlName:AnsiString; show:Boolean);
var
  i,j,n,k,m,r,dot:Integer;
  mi:TMenuItem;
  dfm,parentDfm,dfm1:TDfm;
  classAdr:Integer;
  recN:InfoRec;
  recM:PMethodRec;
  ev,ev1:TList;
  eInfo,eInfo1:PEventInfo;
  cInfo,cInfo1:PComponentInfo;
  methodName,moduleName,actionName:AnsiString;
Begin
  dfm := ResInfo.GetFormIdx(FormName, n);
  if dfm=Nil then Exit;
  classAdr := GetClassAdr(dfm.FormClass);
  if IsValidImageAdr(classAdr) Then recN := InfoList[Adr2Pos(classAdr)]
    else recN:= Nil;

  //Форма?
  if SameText(dfm.Name, ControlName) then
  begin
    //Inherited - начали заполнять меню
    if (dfm.Flags and FF_INHERITED)<>0 then
    begin
      parentDfm := ResInfo.GetParentDfm(dfm);
      if Assigned(parentDfm) then ShowMyPopupMenu(parentDfm.Name, parentDfm.Name, false);
      //В конце добавляем разделитель
      mi := TMenuItem.Create(evPopup);
      mi.Caption := '-';
      evPopup.Items.Add(mi);
    End;
    //Первая строка меню - название контрола
    mi := TMenuItem.Create(evPopup);
    mi.Caption := dfm.Name + '.' + dfm.FormClass;
    mi.Tag := classAdr;
    mi.OnClick := miPopupClick;
    evPopup.Items.Add(mi);
    //Вторая строка меню - разделитель
    mi := TMenuItem.Create(evPopup);
    mi.Caption := '-';
    evPopup.Items.Add(mi);
    if IsValidImageAdr(classAdr) Then recN := InfoList[Adr2Pos(classAdr)]
      else recN:= Nil;
    ev := dfm.Events;
    for k := 0 To ev.Count-1 do
    begin
      eInfo := ev[k];
      mi := TMenuItem.Create(evPopup);
      mi.Caption := eInfo.EventName + ' = ' + eInfo.ProcName;
      //Ищем адрес соответствующего метода
      recM := FMain.GetMethodInfo(recN, dfm.FormClass + '.' + eInfo.ProcName);
      If Assigned(recM) then mi.Tag := recM.address
        Else mi.Tag:= 0;
      mi.OnClick := miPopupClick;
      evPopup.Items.Add(mi);
    end;
    if show and (evPopup.Items.Count<>0) then evPopup.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
    Exit;
  End
  //Компонента формы?
  else
  begin
    //Inherited - начали заполнять меню
    if (dfm.Flags and FF_INHERITED)<>0 then
    begin
      parentDfm := ResInfo.GetParentDfm(dfm);
      if Assigned(parentDfm) then ShowMyPopupMenu(parentDfm.Name, ControlName, false);
      //В конце добавляем разделитель
      mi := TMenuItem.Create(evPopup);
      mi.Caption := '-';
      evPopup.Items.Add(mi);
    End;
    for m := 0 to dfm.Components.Count-1 do
    begin
      cInfo := dfm.Components[m];
      //Нашли компоненту, которой принадлежит control
      if SameText(cInfo.Name, ControlName) then
      begin
        //Чистим evPopup
        evPopup.Items.Clear;
        //Первая строка меню - название контрола
        mi := TMenuItem.Create(evPopup);
        mi.Caption := cInfo.Name + '.' + cInfo.ClasName;
        mi.Tag := GetClassAdr(cInfo.ClasName);
        mi.OnClick := miPopupClick;
        evPopup.Items.Add(mi);
        //Вторая строка меню - разделитель
        mi := TMenuItem.Create(evPopup);
        mi.Caption := '-';
        evPopup.Items.Add(mi);
        ev := cInfo.Events;
        for k := 0 to ev.Count-1 do
        begin
          eInfo := ev[k];
          mi := TMenuItem.Create(evPopup);
          mi.Caption := eInfo.EventName + ' = ' + eInfo.ProcName;
          methodName := '';
          //Action
          if SameText(eInfo.EventName, 'Action') then
          begin
            //Имя eInfo.ProcName может иметь вид FormName.Name
            dot := Pos('.',eInfo.ProcName);
            if dot<>0 then
            begin
              moduleName := Copy(eInfo.ProcName,1, dot - 1);
              actionName := Copy(eInfo.ProcName,dot + 1, Length(eInfo.ProcName) - dot);
              //Ищем форму moduleName
              for j := 0 To ResInfo.FormList.Count-1 do
              begin
                dfm1 := TDfm(ResInfo.FormList[j]);
                if SameText(dfm1.Name, moduleName) then
                begin
                  classAdr := GetClassAdr(dfm1.FormClass);
                  if IsValidImageAdr(classAdr) then recN := InfoList[Adr2Pos(classAdr)]
                    Else recN:=Nil;
                  //Ищем компоненту actionName
                  for r := 0 to dfm1.Components.Count-1 do
                  begin
                    cInfo1 := dfm1.Components[r];
                    if SameText(cInfo1.Name, actionName) then
                    begin
                      //Ищем событие OnExecute
                      ev1 := cInfo1.Events;
                      for i := 0 to ev1.Count-1 do
                      begin
                        eInfo1 := ev1[i];
                        if SameText(eInfo1.EventName, 'OnExecute') then
                        begin
                          methodName := dfm1.FormClass + '.' + eInfo1.ProcName;
                          break;
                        End;
                      End;
                      break;
                    End;
                  End;
                  break;
                End;
              End;
            end
            else
            begin
              //Ищем компоненту eInfo.ProcName
              for r := 0 to dfm.Components.Count-1 do
              begin
                cInfo1 := dfm.Components[r];
                if SameText(cInfo1.Name, eInfo.ProcName) then
                begin
                  //Ищем событие OnExecute
                  ev1 := cInfo1.Events;
                  for i := 0 to ev1.Count-1 do
                  begin
                    eInfo1 := ev1[i];
                    if SameText(eInfo1.EventName, 'OnExecute') then
                    begin
                      methodName := dfm.FormClass + '.' + eInfo1.ProcName;
                      break;
                    end;
                  End;
                  break;
                End;
              End;
            End;
          end
          else methodName := dfm.FormClass + '.' + eInfo.ProcName;
          //Ищем адрес соответствующего метода
          recM := FMain.GetMethodInfo(recN, methodName);
          if Assigned(recM) then mi.Tag := recM.address Else mi.Tag:= 0;
          mi.OnClick := miPopupClick;
          evPopup.Items.Add(mi);
        End;
        if evPopup.Items.Count<>0 then evPopup.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
        Exit;
      End;
    End;
  End;
end;

Procedure IdrDfmForm.miPopupClick (Sender:TObject);
var
  adr:Integer;
  recN:InfoRec;
Begin
  Adr := TMenuItem(Sender).Tag;
  if (Adr<>0) and IsValidImageAdr(Adr) then
  begin
    recN := GetInfoRec(Adr);
    if Assigned(recN) then
    begin
      if recN.kind = ikVMT then FMain.ShowClassViewer(Adr)
        else FMain.ShowCode(Adr, 0, -1, -1);
    End;
  end
  else ShowMessage('Handler not found');
end;

Procedure IdrDfmForm.SetupControlHint (FormName:AnsiString; Control:TControl; InitHint:AnsiString);
var
  n,k,m:Integer;
  dfm:TDfm;
  hnt:AnsiString;
  ev:TList;
  eInfo:PEventInfo;
  cInfo:PComponentInfo;
Begin
  for n := 0 to ResInfo.FormList.Count-1 do
  begin
    dfm := ResInfo.FormList[n];
    //Нашли форму, которой принадлежит control
    if SameText(dfm.Name, FormName) then
    begin
      hnt := InitHint;
      //Сама форма?
      if SameText(dfm.Name, Control.Name) then
      begin
        if hnt <> '' then hnt:=hnt +#13;
        hnt:=hnt + dfm.Name + ':' + dfm.FormClass;
        ev := dfm.Events;
        for k := 0 to ev.Count-1 do
        begin
          eInfo := ev[k];
          hnt:=hnt +#13 + eInfo.EventName + ' = ' + eInfo.ProcName;
        end;
        Control.Hint := hnt;
        Control.ShowHint := true;
        Exit;
      end
      else for m := 0 to dfm.Components.Count-1 do
      begin
        cInfo := dfm.Components[m];
        //Нашли компоненту, которой принадлежит control
        if SameText(cInfo.Name, Control.Name) then
        begin
          if hnt <> '' then hnt:=hnt +#13;
          hnt:=hnt + cInfo.Name + ':' + cInfo.ClasName;
          ev := cInfo.Events;
          for k := 0 to ev.Count-1 do
          begin
            eInfo := ev[k];
            hnt:=hnt +#13 + eInfo.EventName + ' = ' + eInfo.ProcName;
          End;
          Control.Hint := hnt;
          Control.ShowHint := true;
          Exit;
        End;
      end;
    End;
  End;
end;

Procedure IdrDfmForm.SetupMenuItem (mi:TMenuItem; searchName:AnsiString);
var
  menuFound, formInherited:Boolean;
  curDfm,dfm:TDfm;
  n,m,k,r,i:Integer;
  cInfo,cInfo1:PComponentInfo;
  eInfo,eInfo1:PEventInfo;
  classAdr:Integer;
  recN:InfoRec;
  ev,ev1:TList;
  recM:PMethodRec;
  methodName:AnsiString;
Begin
  menuFound:=False;
  formInherited:=False;
  curDfm:=Nil;
  for n := 0 to ResInfo.FormList.Count-1 do
  begin
    //as: I dont like this, maybe put TDfm* into IdrDfmForm?
    dfm := ResInfo.FormList[n];
    //Нашли форму, которой принадлежит control
    if SameText(dfm.Name, searchName) then
    begin
      curDfm := dfm;
      formInherited := (dfm.Flags and FF_INHERITED)<>0;
      for m := 0 to dfm.Components.Count-1 do
      begin
        cInfo := dfm.Components[m];
        //Нашли компоненту, которой принадлежит mi
        if SameText(cInfo.Name, mi.Name) then
        begin
          classAdr := GetClassAdr(dfm.FormClass);
          if IsValidImageAdr(classAdr) then recN := InfoList[Adr2Pos(classAdr)]
            else recN:=Nil;
          ev := cInfo.Events;
          for k := 0 to ev.Count-1 do
          begin
            eInfo := ev[k];
            //OnClick
            methodName := '';
            if SameText(eInfo.EventName, 'OnClick') then
            begin
              methodName := dfm.FormClass + '.' + eInfo.ProcName;
              //Ищем адрес соответствующего метода
              recM := FMain.GetMethodInfo(recN, methodName);
              if Assigned(recM) then mi.Tag := recM.address Else mi.Tag:=0;
              mi.OnClick := miPopupClick;
              //mi.Enabled := true;
              continue;
            End;
            //Action
            if SameText(eInfo.EventName, 'Action') then
            begin
              //Ищем компоненту с именем eInfo.ProcName
              for r := 0 to dfm.Components.Count-1 do
              begin
                cInfo1 := dfm.Components[r];
                if SameText(cInfo1.Name, eInfo.ProcName) then
                begin
                  //Ищем событие OnExecute
                  ev1 := cInfo1.Events;
                  for i := 0 to ev1.Count-1 do
                  begin
                    eInfo1 := ev1[i];
                    if SameText(eInfo1.EventName, 'OnExecute') then
                    begin
                      methodName := dfm.FormClass + '.' + eInfo1.ProcName;
                      recM := FMain.GetMethodInfo(recN, methodName);
                      if Assigned(recM) then mi.Tag := recM.address else mi.Tag:=0;
                      mi.OnClick := miPopupClick;
                      //mi.Enabled := true;
                      break;
                    end;
                  End;
                  break;
                end;
              end;
            End;
          end;
          //menuFound := true;
          Exit;
        end;
      end;
    end;
  end;
  if not menuFound and formInherited and Assigned(curDfm) and Assigned(curDfm.ParentDfm) then
  begin
    //recursive call in the parent form, trying to find the menu handler...
    SetupMenuItem(mi, curDfm.ParentDfm.Name);
  End;
end;

Procedure IdrDfmForm.DoFindMethod (methodName:AnsiString);
Begin
  if Assigned(FOnFindMethod) then FOnFindMethod(Self, getFormName, methodName);
end;

Procedure IdrDfmForm.CMDialogKey (Var Message:TCMDialogKey);
Begin
	//allows for example Ctrl+Tab in TabSheet
  if (Message.CharCode <> VK_ESCAPE) then Dispatch(Message);
end;

Procedure IdrDfmForm.MyFormShow (Sender:TObject);
var
  frmLeft:Integer;
Begin
  if frmTree=Nil then
  begin
    frmTree := TIdrDfmFormTree.Create(Self);
    FrmLeft := (Screen.WorkAreaWidth - Width) div 2;
    if frmTree.Width < FrmLeft then frmTree.Left := FrmLeft - frmTree.Width
      else frmTree.Left := 0;
    frmTree.Top := (Screen.WorkAreaHeight - frmTree.Height) div 2;
    frmTree.Show;
  End;
end;

Procedure IdrDfmForm.MyFormClose (Sender:TObject; Var Action:TCloseAction);
var
  n:Integer;
  dfm:TDfm;
Begin
  for n := 0 to ResInfo.FormList.Count-1 do
  begin
    dfm := ResInfo.FormList[n];
    if dfm.Open = 2 then dfm.Open := 1;
  End;

  //notify main window that form is closed (ugly ref to main form - refactor!)
  SendMessage(FMain.Handle, WM_DFMCLOSED, 0, 0); // crypto changed Post to Send
  Action := caFree;
end;

Procedure IdrDfmForm.MyFormKeyDown (Sender:TObject; Var Key:Word; Shift:TShiftState);
Begin
  Case Key of
    VK_ESCAPE: Close;
    VK_F11: if Assigned(frmTree) then frmTree.Show;
  end;
  Key := 0;
end;

Procedure IdrDfmForm.MyShortCutEvent (Var Msg:TWMKey; Var Handled:Boolean);
Begin
  if VK_ESCAPE = Msg.CharCode then
  Begin
    Close;
    Handled := true;
  End;
end;

Function IdrDfmForm.getFormName:AnsiString;
Begin
  Result:='T' + originalClassName;
end;

Procedure IdrDfmForm.SetMyHandlers;
Begin
  OnShow := MyFormShow;
  OnClose := MyFormClose;
  OnKeyDown := MyFormKeyDown;
  OnShortCut := MyShortCutEvent;
end;

Constructor IdrDfmLoader.Create (Owner:TComponent);
Begin
  Inherited;
  CompsEventsList:=TCollection.Create(TComponentEvents);
end;

Destructor IdrDfmLoader.Destroy;
Begin
  CompsEventsList.Free;
  Inherited;
end;

Function IdrDfmLoader.LoadForm (dfmStream:TStream; Dfm:TDfm; loadingParent:Boolean = false):TForm;
var
  reader:TReader;
  flags:TFilerFlags;
  childPos:Integer;
Begin
  dfmForm := Nil;
  dfmStream.Seek(0, soFromBeginning);
  if Assigned(dfm) and Assigned(dfm.ParentDfm) then
  begin
    dfm.Loader := IdrDfmLoader.Create(Nil);
    dfmForm := IdrDfmForm(dfm.Loader.LoadForm(dfm.ParentDfm.MemStream, dfm.ParentDfm, true));
    dfm.Loader.Free;
    dfm.Loader := Nil;
  end
  else dfmForm := IdrDfmForm.Create2(Application, 1);
  dfmStream.Seek(0, soFromBeginning);
  Reader := IdrDfmReader.Create(dfmStream, 4096);
  with Reader do
  begin
    OnAncestorNotFound   := AncestorNotFound;
    OnFindComponentClass := FindComponentClass;
    OnCreateComponent    := CreateComponent;
    OnFindMethod         := FindMethod;
    OnError              := ReaderError;
    OnSetName            := SetComponentName;
    OnReferenceName      := DoReferenceName;
  end;
  Current := TComponentEvents(CompsEventsList.Add);
  Current.Component := dfmForm;
  try
    Reader.ReadSignature;
    Reader.ReadPrefix(Flags, ChildPos);
    dfmForm.originalClassType := Reader.ReadStr;
    dfmForm.originalClassName := Reader.ReadStr;
    Reader.Position := 0;

    Reader.ReadRootComponent(dfmForm);

    dfmForm.Enabled := true;
    dfmForm.Visible := false;
    dfmForm.Position := poScreenCenter;
    dfmForm.compsEventsList := CompsEventsList;
    dfmForm.OnFindMethod := OnFindMethod;
    dfmForm.SetMyHandlers;

    dfmForm.SetDesigning(false, false);
    if not loadingParent then dfmForm.SetupControls;
    if dfmForm.AlphaBlend then dfmForm.AlphaBlendValue := 222;

    dfmForm.AutoSize := false;
    dfmForm.WindowState := wsNormal;
    dfmForm.FormStyle := fsStayOnTop;
    //dfmForm.FormState.clear;

    dfmForm.Constraints.MinWidth := 0;
    dfmForm.Constraints.MinHeight := 0;
    dfmForm.Constraints.MaxWidth := 0;
    dfmForm.Constraints.MaxHeight := 0;

    dfmForm.HelpFile := '';
    CompsEventsList := Nil;
  Except
    on E:Exception do
    begin
      ShowMessage('DFM Load Error'+#13 + e.ClassName +': ' + e.Message);
      FreeAndNil(dfmForm);
    End;
  end;
  Reader.free;
  Result:=dfmForm;
end;

Procedure IdrDfmLoader.AncestorNotFound (Reader:TReader; Const ComponentName:AnsiString; ComponentClass:TPersistentClass; var Component:TComponent);
Begin
  ShowMessage('Ancestor for "'+ ComponentClass.ClassName+'" not found');
end;

Procedure IdrDfmLoader.FindComponentClass (Reader:TReader; Const ClasName:AnsiString; var ComponentClass:TComponentClass);
Var
  alias:AnsiString;
  n:Integer;
Begin
  try
    TPersistentClass(ComponentClass) := FindClass(ClasName);
  Except
    on E:Exception  do
    begin
      lastClassAliasName := ClasName;
      alias := ResInfo.GetAlias(ClasName);
      for n := Low(RegClasses) to High(RegClasses) do
        if SameText(alias, RegClasses[n].ClasName) then
        begin
          TPersistentClass(ComponentClass) := RegClasses[n].RegClass;
          break;
        End;
    end;
  End;
end;

Procedure IdrDfmLoader.CreateComponent (Reader:TReader; ComponentClass:TComponentClass; var Component:TComponent);
Begin
  Current:=Nil;
end;

Procedure IdrDfmLoader.FindMethod (Reader:TReader; Const MethodName:AnsiString; var Address:Pointer; Var Error:Boolean);
Begin
  if Assigned(Current) then
  begin
    if Reader is IdrDfmReader then Current.FoundEvents.Add(IdrDfmReader(Reader).PropName + '=' + MethodName);
  end;
  Error := false;
  Address := Nil;
end;

Procedure IdrDfmLoader.ReaderError (Reader:TReader; const Message:AnsiString; Var Handled:Boolean);
Begin
  //if something really wrong happened, in order to fix the
  //"DFM Stream read error" - skip fault value!
  if AnsiEndsStr('Invalid property value', Message)
    or AnsiEndsStr('Unable to insert a line', Message)
    or AnsiContainsText(Message, 'List index out of bounds') then
  begin
    //move back to a type position byte
    Reader.Position:=Reader.Position - 1;
    //skip the unknown value for known property (eg: Top = 11.453, or bad Items for StringList)
    Reader.SkipValue;
  end;
  Handled := true;
end;

Procedure IdrDfmLoader.SetComponentName (Reader:TReader; Component:TComponent; Var Name:AnsiString);
var
  mappedClassName:AnsiString;
Begin
  if Name = '' then
  begin
    Name := '_' + Val2Str(Counter,4) + '_';
    Inc(Counter);
  end;
  if Assigned(Current) and (Current.Component = Component) then Exit;
  If Component is IdrDfmDefaultControl then
  begin
    try
      mappedClassName :=
      //IdrDfmClassNameAnalyzer::GetInstance().GetMapping(lastClassAliasName);
      ResInfo.GetAlias(lastClassAliasName);
    except
    end;
    IdrDfmDefaultControl(Component).SetClassName(lastClassAliasName, mappedClassName);
  End;
  Current := TComponentEvents(CompsEventsList.Add);
  Current.Component := Component;
end;

Procedure IdrDfmLoader.DoReferenceName (Reader:TReader; Var Name:AnsiString);
var
  component:TComponent;
Begin
  if Assigned(dfmForm) then
  begin
    Component := dfmForm.FindComponent(Name);
    if Assigned(Component) then
    begin
      if component is IdrDfmDefaultControl then Name := '';
    end;
  End;
end;

Function IdrDfmLoader.HasGlyph (ClasName:AnsiString):Boolean;
var
  n,m:Integer;
  dfm:TDfm;
  cInfo:PComponentInfo;
Begin
  Result:=False;
  for n := 0 to ResInfo.FormList.Count-1 do
  begin
    dfm := ResInfo.FormList[n];
    for m := 0 to dfm.Components.Count-1 do
    begin
      cInfo := dfm.Components[m];
      if SameText(cInfo.ClasName, ClasName) Then
      Begin
        Result:=cInfo.HasGlyph;
        Exit;
      End;
    end;
  end
end;

Constructor IdrDfmDefaultControl.Create (Owner:TComponent);
Begin
  Inherited;
  Color:=clNone;
end;

Function IdrDfmDefaultControl.IsVisible:Boolean;
Begin
  Result:= (Width > 0) and (Height > 0);
end;

Procedure IdrDfmDefaultControl.ReadState (Reader:TReader);
Begin
  DisableAlign;
  try
    Width := 24;
    Height := 24;
    Inherited;
  finally
    EnableAlign;
  end;

  (* wow, intersting case seen, D7:

    object WebDispatcher1: TWebDispatcher
      OldCreateOrder = False
      Actions = <>
      Left = 888
      Top = 8
      Height = 0
      Width = 0
    end

  *)
  // we are not happy with 0:0 sizes, lets correct
  if Width <= 0 then Width := 24;
  if Height <= 0 then Height := 24;
end;

Procedure IdrDfmDefaultControl.Loaded;
Begin
  Inherited;
  BorderStyle := bsNone;
  if Color = clNone then Color := clBtnFace;
end;

Procedure IdrDfmDefaultControl.Paint;
Begin
  with Canvas do
  begin
    Brush.Color := Color;
    Brush.Style := bsClear;
    Pen.Color := clGray;
    Pen.Style := psDot;
    Rectangle(GetClientRect);
  end;
end;

Procedure IdrDfmDefaultControl.SetClassName (Const name, mappedName:AnsiString);
Var
  usedClassName:AnsiString;
Begin
  originalClassName := name;
  //as note:
  //here we should have mapped class, eg:
  //we have on form TMyOpenDialog component, it was mapped to TOpenDialog,
  //so I expect to have a string "TOpenDialog in mappedName, not "Default" !

  mappedClassName := name;
  if mappedName='' then usedClassName := originalClassName
    else usedClassName:= mappedClassName;
  if HasIconForClass(usedClassName) then CreateImageIconForClass(usedClassName);
end;

Function IdrDfmDefaultControl.HasIconForClass (Const name:AnsiString):Boolean;
Begin
  Result:=true;
  //TBD: ask dll if it has specified icon for class
  //right now it is implicitly done in CreateImageIconForClass()
end;

Procedure IdrDfmDefaultControl.CreateImageIconForClass (Const imgFile:AnsiString);
const
  hResLib:HINST = 0;
  IconsDllLoaded:Boolean = false;
  IconsDllPresent:Boolean = true;
Begin
  if not IconsDllPresent then Exit;
  if not IconsDllLoaded then
  begin
    hResLib := LoadLibrary('Icons.dll');
    IconsDllPresent := hResLib <> 0;
    IconsDllLoaded := IconsDllPresent;
    if not IconsDllPresent Then Exit;
  end;
  imgIcon := TImage.Create(Self);
  //old way - read from .bmp files on disk
  //imgIcon.Picture.LoadFromFile(imgFile);
  try
    with imgIcon do
    begin
      Picture.Bitmap.LoadFromResourceName(hResLib, UpperCase(imgFile));
      AutoSize := true;
      Transparent := true;
      Parent := Self;
      //yes, we want same popup as our parent
      //OnMouseDown := ImageMouseDown;
    end;
    //update our component size in a case picture has another size
    if Width <> imgIcon.Picture.Bitmap.Width then Width := imgIcon.Picture.Bitmap.Width;
    if Height <> imgIcon.Picture.Bitmap.Height then Height := imgIcon.Picture.Bitmap.Height;
  Except
    on E:Exception do
    begin
      //icon not found or other error - free the image!
      imgIcon.Parent := Nil;
      FreeAndNil(imgIcon);
    End;
  End;
end;

Procedure IdrDfmDefaultControl.ImageMouseDown (Sender:TObject; Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
Begin
	if Button = mbRight then
  begin
    //Sender here is image, but we need this - replacing control!
    if Assigned(Parent) then
      TMyControl(Parent).OnMouseDown(Self, Button, Shift, X, Y);
  End;
end;

End.

