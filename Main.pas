unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,Types,
  Controls, Forms, Dialogs, StdCtrls,Menus, ActnList, ComCtrls, Grids,
  ExtCtrls, Disasm, KnowledgeBase, Resources, Infos, UFileDropper,
  Def_main,Def_info,Def_know,SyncObjs, VirtualTrees;

Type
  TFMain=class(TForm)
    miFile: TMenuItem;
    miLoadFile: TMenuItem;
    miExit: TMenuItem;
    miSaveProject: TMenuItem;
    OpenDlg: TOpenDialog;
    MainMenu: TMainMenu;
    miTools: TMenuItem;
    pcInfo: TPageControl;
    tsUnits: TTabSheet;
    tsRTTIs: TTabSheet;
    lbUnits: TListBox;
    lbRTTIs: TListBox;
    miOpenProject: TMenuItem;
    pcWorkArea: TPageControl;
    tsCodeView: TTabSheet;
    lbCode: TListBox;
    pmCode: TPopupMenu;
    miGoTo: TMenuItem;
    miExploreAdr: TMenuItem;
    SaveDlg: TSaveDialog;
    SplitterH1: TSplitter;
    SplitterV1: TSplitter;
    miViewProto: TMenuItem;
    CodePanel: TPanel;
    bEP: TButton;
    bCodePrev: TButton;
    tsClassView: TTabSheet;
    tvClassesFull: TTreeView;
    tsStrings: TTabSheet;
    lbStrings: TListBox;
    Panel1: TPanel;
    pmUnits: TPopupMenu;
    miSearchUnit: TMenuItem;
    pmRTTIs: TPopupMenu;
    pmVMTs: TPopupMenu;
    miSearchRTTI: TMenuItem;
    miSortRTTI: TMenuItem;
    miSortRTTIsByAdr: TMenuItem;
    miSortRTTIsByKnd: TMenuItem;
    miSortRTTIsByNam: TMenuItem;
    miSearchVMT: TMenuItem;
    miCopyCode: TMenuItem;
    miRenameUnit: TMenuItem;
    pmUnitItems: TPopupMenu;
    miSearchItem: TMenuItem;
    tsForms: TTabSheet;
    Panel2: TPanel;
    rgViewFormAs: TRadioGroup;
    lbForms: TListBox;
    sb: TStatusBar;
    pb: TProgressBar;
    miCollapseAll: TMenuItem;
    lbCXrefs: TListBox;
    ShowCXrefs: TPanel;
    tvClassesShort: TTreeView;
    rgViewerMode: TRadioGroup;
    miClassTreeBuilder: TMenuItem;
    miMRF: TMenuItem;
    miExe1: TMenuItem;
    miExe2: TMenuItem;
    miExe3: TMenuItem;
    miExe4: TMenuItem;
    miIdp1: TMenuItem;
    miIdp2: TMenuItem;
    miIdp3: TMenuItem;
    miIdp4: TMenuItem;
    N1: TMenuItem;
    tsItems: TTabSheet;
    sgItems: TStringGrid;
    miExe5: TMenuItem;
    miExe6: TMenuItem;
    miExe7: TMenuItem;
    miExe8: TMenuItem;
    miIdp5: TMenuItem;
    miIdp6: TMenuItem;
    miIdp7: TMenuItem;
    miIdp8: TMenuItem;
    lbUnitItems: TListBox;
    miEditFunctionC: TMenuItem;
    miMapGenerator: TMenuItem;
    miAutodetectVersion: TMenuItem;
    miDelphi2: TMenuItem;
    miDelphi3: TMenuItem;
    miDelphi4: TMenuItem;
    miDelphi5: TMenuItem;
    miDelphi6: TMenuItem;
    miDelphi7: TMenuItem;
    miDelphi2006: TMenuItem;
    miDelphi2007: TMenuItem;
    miKBTypeInfo: TMenuItem;
    miName: TMenuItem;
    miLister: TMenuItem;
    bCodeNext: TButton;
    lProcName: TLabel;
    miInformation: TMenuItem;
    miEditFunctionI: TMenuItem;
    pmStrings: TPopupMenu;
    miSearchString: TMenuItem;
    miViewClass: TMenuItem;
    miDelphi2009: TMenuItem;
    miDelphi2010: TMenuItem;
    Panel3: TPanel;
    lbSXrefs: TListBox;
    ShowSXrefs: TPanel;
    miAbout: TMenuItem;
    miHelp: TMenuItem;
    miEditClass: TMenuItem;
    miCtdPassword: TMenuItem;
    pmCodePanel: TPopupMenu;
    miEmptyHistory: TMenuItem;
    miTabs: TMenuItem;
    Units1: TMenuItem;
    RTTI1: TMenuItem;
    Forms1: TMenuItem;
    CodeViewer1: TMenuItem;
    ClassViewer1: TMenuItem;
    Strings1: TMenuItem;
    miUnitDumper: TMenuItem;
    tsNames: TTabSheet;
    Names1: TMenuItem;
    lbNames: TListBox;
    Panel4: TPanel;
    Splitter1: TSplitter;
    lbAliases: TListBox;
    pnlAliases: TPanel;
    lClassName: TLabel;
    cbAliases: TComboBox;
    bApplyAlias: TButton;
    bCancelAlias: TButton;
    miLegend: TMenuItem;
    miFuzzyScanKB: TMenuItem;
    miCopyList: TMenuItem;
    miDelphi2005: TMenuItem;
    miCommentsGenerator: TMenuItem;
    miIDCGenerator: TMenuItem;
    miSaveDelphiProject: TMenuItem;
    tsSourceCode: TTabSheet;
    lbSourceCode: TListBox;
    SourceCode1: TMenuItem;
    Panel5: TPanel;
    ShowNXrefs: TPanel;
    lbNXrefs: TListBox;
    miHex2Double: TMenuItem;
    alMain: TActionList;
    acOnTop: TAction;
    acShowBar: TAction;
    acShowHoriz: TAction;
    acDefCol: TAction;
    FontsDlg: TFontDialog;
    Appearance2: TMenuItem;
    Colorsall2: TMenuItem;
    Colorsthis2: TMenuItem;
    Fontall2: TMenuItem;
    Defaultcolumns2: TMenuItem;
    Showhorizontalscroll2: TMenuItem;
    Showbar2: TMenuItem;
    bDecompile: TButton;
    miCopyStrings: TMenuItem;
    miCopyAddressI: TMenuItem;
    miCopyAddressCode: TMenuItem;
    pmSourceCode: TPopupMenu;
    miCopySource2Clipboard: TMenuItem;
    miDelphiXE1: TMenuItem;
    miXRefs: TMenuItem;
    miDelphiXE2: TMenuItem;
    miPlugins: TMenuItem;
    miViewAll: TMenuItem;
    cbMultipleSelection: TCheckBox;
    miSwitchSkipFlag: TMenuItem;
    miSwitchFrameFlag: TMenuItem;
    miSwitchFlag: TMenuItem;
    cfTry1: TMenuItem;
    miDelphiXE3: TMenuItem;
    miDelphiXE4: TMenuItem;
    vtUnit: TVirtualStringTree;
    procedure miExitClick(Sender : TObject);
    procedure miAutodetectVersionClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure miSaveProjectClick(Sender : TObject);
    procedure miOpenProjectClick(Sender : TObject);
    procedure lbCodeDblClick(Sender : TObject);
    procedure bEPClick(Sender : TObject);
    procedure lbStringsDblClick(Sender : TObject);
    procedure lbRTTIsDblClick(Sender : TObject);
    procedure lbUnitItemsDblClick(Sender : TObject);
    procedure lbUnitsDblClick(Sender : TObject);
    procedure miGoToClick(Sender : TObject);
    procedure miExploreAdrClick(Sender : TObject);
    procedure miNameClick(Sender : TObject);
    procedure miViewProtoClick(Sender : TObject);
    procedure lbXrefsDblClick(Sender : TObject);
    procedure bCodePrevClick(Sender : TObject);
    procedure tvClassesDblClick(Sender : TObject);
    procedure miSearchUnitClick(Sender : TObject);
    procedure miSearchVMTClick(Sender : TObject);
    procedure miSearchRTTIClick(Sender : TObject);
    procedure miSortRTTIsByAdrClick(Sender : TObject);
    procedure miSortRTTIsByKndClick(Sender : TObject);
    procedure miSortRTTIsByNamClick(Sender : TObject);
    procedure miCopyCodeClick(Sender : TObject);
    procedure miRenameUnitClick(Sender : TObject);
    procedure FormClose(Sender : TObject; Var Action:TCloseAction);
    procedure lbFormsDblClick(Sender : TObject);
    procedure lbUnitsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
    procedure FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure lbCodeKeyDown(Sender : TObject; Var Key:Word; Shift:TShiftState);
    procedure miCollapseAllClick(Sender : TObject);
    procedure NamePosition;
    procedure GoToAddress;
    procedure FindText(str:AnsiString);
    procedure miSearchItemClick(Sender : TObject);
    procedure ShowCXrefsClick(Sender : TObject);
    procedure lbUnitItemsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
    procedure lbUnitsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure lbRTTIsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure lbFormsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure lbCodeMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure tvClassesFullMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure lbStringsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure lbUnitItemsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure lbXrefsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure rgViewerModeClick(Sender : TObject);
    procedure tvClassesShortMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure miClassTreeBuilderClick(Sender : TObject);
    procedure lbUnitsClick(Sender : TObject);
    procedure lbRTTIsClick(Sender : TObject);
    procedure lbUnitItemsClick(Sender : TObject);
    procedure tvClassesShortClick(Sender : TObject);
    procedure tvClassesFullClick(Sender : TObject);
    procedure miExe1Click(Sender : TObject);
    procedure miExe2Click(Sender : TObject);
    procedure miExe3Click(Sender : TObject);
    procedure miExe4Click(Sender : TObject);
    procedure miIdp1Click(Sender : TObject);
    procedure miIdp2Click(Sender : TObject);
    procedure miIdp3Click(Sender : TObject);
    procedure miIdp4Click(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure miKBTypeInfoClick(Sender : TObject);
    procedure miExe5Click(Sender : TObject);
    procedure miExe6Click(Sender : TObject);
    procedure miExe7Click(Sender : TObject);
    procedure miExe8Click(Sender : TObject);
    procedure miIdp5Click(Sender : TObject);
    procedure miIdp6Click(Sender : TObject);
    procedure miIdp7Click(Sender : TObject);
    procedure miIdp8Click(Sender : TObject);
    procedure FormResize(Sender : TObject);
    procedure miEditFunctionCClick(Sender : TObject);
    procedure lbXrefsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
    procedure miMapGeneratorClick(Sender : TObject);
    procedure pmUnitsPopup(Sender : TObject);
    procedure lbCodeDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
    procedure miDelphi2Click(Sender : TObject);
    procedure miDelphi3Click(Sender : TObject);
    procedure miDelphi4Click(Sender : TObject);
    procedure miDelphi5Click(Sender : TObject);
    procedure miDelphi6Click(Sender : TObject);
    procedure miDelphi7Click(Sender : TObject);
    procedure miDelphi2005Click(Sender : TObject);
    procedure miDelphi2006Click(Sender : TObject);
    procedure miDelphi2007Click(Sender : TObject);
    procedure lbXrefsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure lbUnitsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure lbRTTIsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure lbFormsKeyDown(Sender : TObject; Var Key:Word; Shift:TShiftState);
    procedure tvClassesShortKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure lbUnitItemsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
    procedure miListerClick(Sender : TObject);
    procedure bCodeNextClick(Sender : TObject);
    procedure miEditFunctionIClick(Sender : TObject);
    procedure miSearchStringClick(Sender : TObject);
    procedure lbStringsClick(Sender : TObject);
    procedure miViewClassClick(Sender : TObject);
    procedure pmVMTsPopup(Sender : TObject);
    procedure lbStringsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
    procedure ShowSXrefsClick(Sender : TObject);
    procedure miAboutClick(Sender : TObject);
    procedure miHelpClick(Sender : TObject);
    procedure pmRTTIsPopup(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; Var CanClose:Boolean);
    procedure miEditClassClick(Sender : TObject);
    procedure miCtdPasswordClick(Sender : TObject);
    procedure pmCodePanelPopup(Sender : TObject);
    procedure miEmptyHistoryClick(Sender : TObject);
    procedure pmStringsPopup(Sender : TObject);
    procedure Units1Click(Sender : TObject);
    procedure RTTI1Click(Sender : TObject);
    procedure Forms1Click(Sender : TObject);
    procedure CodeViewer1Click(Sender : TObject);
    procedure ClassViewer1Click(Sender : TObject);
    procedure Strings1Click(Sender : TObject);
    procedure Names1Click(Sender : TObject);
    procedure miUnitDumperClick(Sender : TObject);
    procedure miFuzzyScanKBClick(Sender : TObject);
    procedure miDelphi2009Click(Sender : TObject);
    procedure miDelphi2010Click(Sender : TObject);
    procedure lbNamesClick(Sender : TObject);
    procedure bApplyAliasClick(Sender : TObject);
    procedure bCancelAliasClick(Sender : TObject);
    procedure lbAliasesDblClick(Sender : TObject);
    procedure miLegendClick(Sender : TObject);
    procedure miCopyListClick(Sender : TObject);
    procedure miCommentsGeneratorClick(Sender : TObject);
    procedure miIDCGeneratorClick(Sender : TObject);
    procedure miSaveDelphiProjectClick(Sender : TObject);
    procedure bDecompileClick(Sender : TObject);
    procedure SourceCode1Click(Sender : TObject);
    procedure miHex2DoubleClick(Sender : TObject);
    procedure acFontAllExecute(Sender : TObject);
    procedure pmUnitItemsPopup(Sender : TObject);
    procedure miCopyAddressIClick(Sender : TObject);
    procedure miCopyAddressCodeClick(Sender : TObject);
    procedure miCopySource2ClipboardClick(Sender : TObject);
    procedure miDelphiXE1Click(Sender : TObject);
    procedure pmCodePopup(Sender : TObject);
    procedure lbFormsClick(Sender : TObject);
    procedure lbCodeClick(Sender : TObject);
    procedure pcInfoChange(Sender : TObject);
    procedure pcWorkAreaChange(Sender : TObject);
    procedure miPluginsClick(Sender : TObject);
    procedure miCopyStringsClick(Sender : TObject);
    procedure miViewAllClick(Sender : TObject);
    procedure lbSourceCodeMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
    procedure cbMultipleSelectionClick(Sender : TObject);
    procedure lbSourceCodeDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
    procedure miSwitchSkipFlagClick(Sender : TObject);
    procedure miSwitchFrameFlagClick(Sender : TObject);
    procedure cfTry1Click(Sender : TObject);
    procedure miDelphiXE3Click(Sender : TObject);
    procedure miDelphiXE4Click(Sender : TObject);
    Procedure miProcessDumperClick(Sender:TObject);
    procedure miDelphiXE2Click(Sender: TObject);
    procedure vtUnitClick(Sender: TObject);
    procedure vtUnitCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vtUnitDblClick(Sender: TObject);
    procedure vtUnitFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtUnitGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vtUnitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vtUnitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure vtUnitPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private
    ProjectLoaded:Boolean;
    dragdropHelper:TDragDropHelper;
    //typedef std::map<const String, TTreeNode*> TTreeNodeNameMap;
    tvClassMap:TStringList;

    Procedure Init;
    Procedure AnalyzeThreadDone(Sender:TObject);

    Function IsExe(FileName:AnsiString):Boolean;
    Function IsIdp(FileName:AnsiString):Boolean;
    Procedure LoadFile(FileName:AnsiString; version:Integer);
    Procedure LoadDelphiFile(version:Integer);
    Procedure LoadDelphiFile1(FileName:AnsiString; version:Integer; loadExp, loadImp:Boolean);
    Procedure ReadNode(stream:TStream; node:TTreeNode; buf:PAnsiChar);
    Procedure OpenProject(FileName:AnsiString);
    Function LoadImage(f:TFileStream; loadExp, loadImp:Boolean):Integer;
    Procedure FindExports;
    Procedure FindImports;
    Function GetDelphiVersion:Integer;
    Procedure InitSysProcs;
    Function IsExtendedInitTab(var unitsTab:Integer):Boolean;
    Function GetUnits2(dprName:AnsiString):Integer;   //For Delphi2 (other structure!)
    Function GetUnits(dprName:AnsiString):Integer;
    Function GetBCBUnits(dprName:AnsiString):Integer;
    Function IsValidCode(fromAdr:Integer):Integer;
    Procedure CodeHistoryPush(rec:PPROCHISTORYREC);
    Function CodeHistoryPop:PPROCHISTORYREC;
    Procedure ShowCodeXrefs(Adr:Integer; selIdx:Integer);
    Procedure ShowStringXrefs(Adr:Integer; selIdx:Integer);
    Procedure ShowNameXrefs(Adr:Integer; selIdx:Integer);
    Procedure StartProgress(text0, text1:AnsiString; steps:Integer);
    Procedure WriteNode(stream:TStream; node:TTreeNode);
    Procedure SaveProject(FileName:AnsiString);
    Procedure CloseProject;
    Procedure CleanProject;
    Procedure IniFileRead;
    Procedure IniFileWrite;
    Procedure AddExe2MRF(FileName:AnsiString);
    Procedure AddIdp2MRF(FileName:AnsiString);
    Function GetSegmentNo(Adr:Integer):Integer;
    function CodeGetTargetAdr(line:AnsiString; trgAdr:PInteger): Integer;
    procedure OutputLine(Var outF:TextFile; flag:Byte; adr:Integer; content:AnsiString);
    procedure OutputCode(Var outF:TextFile; fromAdr:Integer; prototype:AnsiString; onlyComments:Boolean);
    //Drag & Drop
    procedure wm_dropFiles(Var Msg:TWMDropFiles); message WM_DROPFILES;
    Procedure DoOpenProjectFile(FileName:AnsiString);
    Function ContainsUnexplored(recU:PUnitRec):Boolean;
    //GUI update from thread
    Procedure wm_updAnalysisStatus(var msg:TMessage); Message WM_UPDANALYSISSTATUS;
    Procedure wm_dfmClosed(Var msg:TMessage); Message WM_DFMCLOSED;
    //Tree view booster
    Procedure ClearTreeNodeMap;
    Procedure SetupAllFonts(font:TFont);
    procedure miSearchFormClick(Sender:TObject);
    procedure miSearchNameClick(Sender:TObject);
  public
    AppDir:AnsiString;
    WrkDir:AnsiString;
    SourceFile:AnsiString;
    SysProcsNum:Integer;    //Number of elements in SysProcs array
    WhereSearch:Integer;
    //UNITS
    UnitsSearchFrom:Integer;
    UnitsSearchList:TStringList;
    UnitsSearchText:AnsiString;
    //RTTIS
    RTTIsSearchFrom:Integer;
    RTTIsSearchList:TStringList;
    RTTIsSearchText:AnsiString;
    //UNITITEMS
    UnitItemsSearchFrom:Integer;
    UnitItemsSearchList:TStringList;
    UnitItemsSearchText:AnsiString;
    //FORMS
    FormsSearchFrom:Integer;
    FormsSearchList:TStringList;
    FormsSearchText:AnsiString;
    //VMTS
    TreeSearchFrom:TTreeNode;
    BranchSearchFrom:TTreeNode;
    VMTsSearchList:TStringList;
    VMTsSearchText:AnsiString;
    //STRINGS
    StringsSearchFrom:Integer;
    StringsSearchList:TStringList;
    StringsSearchText:AnsiString;
    //NAMES
    NamesSearchFrom:Integer;
    NamesSearchList:TStringList;
    NamesSearchText:AnsiString;

    Constructor Create(Owner:TComponent); Override;
    Destructor Free;
    Procedure DoOpenDelphiFile(version:Integer; FileName:AnsiString; loadExp, loadImp:Boolean);
    Procedure ClearPassFlags;
    Function EstimateProcSize(fromAdr:Integer):Integer;
    function EvaluateInitTable(Data:PAnsiChar; Size, Base:Integer): Integer;
    Function GetField(TypeName:AnsiString; Offset:Integer; var vmt:Boolean; var vmtAdr:Integer):FieldInfo;
    Function AddField(ProcAdr:Integer; ProcOfs:Integer; TypeName:AnsiString; Scope:Byte; Offset, _Case:Integer; Name, _Type:AnsiString):FieldInfo;
    Function GetMethodOfs(rec:InfoRec; procAdr:Integer):Integer;
    function GetMethodInfo(rec:InfoRec; _name:AnsiString): PMethodRec; overload;
    Function GetMethodInfo(adr:Integer; kind:Char; methodOfs:Integer):PMethodRec; Overload;

    Function GetImportRec(adr:Integer):PImportNameRec;
    procedure StrapProc(_pos, ProcIdx:Integer; ProcInfo:PMProcInfo; useFixups:Boolean; procSize:Integer);
    Procedure ShowUnits(showUnk:Boolean);
    Procedure ShowUnitItems(recU:PUnitRec; topIdx, itemIdx:Integer);
    Procedure ShowRTTIs;
    Procedure FillVmtList;
    Procedure ShowClassViewer(VmtAdr:Integer);
    function IsUnitExist(_Name:AnsiString): Boolean;
    Procedure SetVmtConsts(version:Integer);
    Function GetUnit(Adr:Integer):PUnitRec;
    Function GetUnitName(recU:PUnitRec):AnsiString; Overload;
    Function GetUnitName(Adr:Integer):AnsiString; Overload;
    procedure SetUnitName(recU:PUnitRec; _name:AnsiString);
    Function InOneUnit(Adr1, Adr2:Integer):Boolean;
    procedure StrapVMT(_pos, ConstId:Integer; ConstInfo:PMConstInfo);
    function StrapCheck(_pos:Integer; ProcInfo:PMProcInfo): Boolean;
    Function GetNodeByName(AName:AnsiString):TTreeNode;

    Procedure ScanIntfTable(adr:Integer);
    Procedure ScanAutoTable(adr:Integer);
    Procedure ScanInitTable(adr:Integer);
    Procedure ScanFieldTable(adr:Integer);
    Procedure ScanMethodTable(adr:Integer; clasName:AnsiString);
    Procedure ScanDynamicTable(adr:Integer);
    Procedure ScanVirtualTable(adr:Integer);
    Function GetClassHeight(adr:Integer):Integer;
    Function GetCommonType(Name1, Name2:AnsiString):AnsiString;
    Procedure PropagateVMTNames(adr:Integer);

    Procedure ShowStrings(idx:Integer);
    Procedure ShowNames(idx:Integer);
    //Procedure ScanImports;
    Procedure RedrawCode;
    function AddAsmLine(adr:Integer; _text:AnsiString; Flags:Byte): Integer;
    Procedure ShowCode(fromAdr:Integer; SelectedIdx, XrefIdx, topIdx:Integer);
    Procedure AnalyzeProc(pass:Integer; procAdr:Integer);
    Procedure AnalyzeMethodTable(pass:Integer; adr:Integer; var Terminated:Boolean);
    Procedure AnalyzeDynamicTable(pass:Integer; adr:Integer; var Terminated:Boolean);
    Procedure AnalyzeVirtualTable(pass:Integer; adr:Integer; Var Terminated:Boolean);
    Function AnalyzeProcInitial(fromAdr:Integer):Integer;
    Procedure AnalyzeProc1(fromAdr:Integer; xrefType:Char; xrefAdr:Integer; xrefOfs:Integer; maybeEmb:Boolean);
    Procedure AnalyzeProc2(fromAdr:Integer; addArg, AnalyzeRetType:Boolean); Overload;
    Function AnalyzeProc2(fromAdr:Integer; addArg, AnalyzeRetType:Boolean; sctx:TList):Boolean; Overload;
    function AnalyzeTypes(parentAdr:Integer; callPos:Integer; callAdr:Integer; var registers:RegList): AnsiString;
    Function AnalyzeArguments(fromAdr:Integer):AnsiString;

    Function LoadIntfTable(adr:Integer; dstList:TStringList):Integer;
    Function LoadAutoTable(adr:Integer; dstList:TStringList):Integer;
    Function LoadFieldTable(adr:Integer; dstList:TList):Integer;
    Function LoadMethodTable(adr:Integer; dstList:TList):Integer; Overload;
    Function LoadMethodTable(adr:Integer; dstList:TStringList):Integer; Overload;
    Function LoadDynamicTable(adr:Integer; dstList:TList):Integer; Overload;
    Function LoadDynamicTable(adr:Integer; dstList:TStringList):Integer; Overload;
    Function LoadVirtualTable(adr:Integer; dstList:TList):Integer; Overload;
    Function LoadVirtualTable(adr:Integer; dstList:TStringList):Integer; Overload;
    Procedure FillClassViewerOne(n:Integer; tmpList:TStringList; Var terminated:Boolean);
    function AddClassTreeNode(node:TTreeNode; nodeText:AnsiString): TTreeNode;
    //Function
    Procedure EditFunction(Adr:Integer);
    Function MakeComment(code:PPICODE):AnsiString;
    Procedure InitAliases(find:Boolean);
    Procedure CopyAddress(line:AnsiString; ofs, bytes:Integer);
    Procedure GoToXRef(Sender:TObject);
    //Procedure ChangeDelphiHighlightTheme(Sender:TObject);

    //Treenode booster for analysis
    procedure AddTreeNodeWithName(node:TTreeNode; Const Aname:AnsiString);
    function FindTreeNodeByName(Const Aname:AnsiString): TTreeNode;

    //show Form by its dfm object
    Procedure ShowDfm(dfm:TDfm);
  end;

function FindClassAdrByName(const AName:AnsiString):Integer;
procedure AddClassAdr(Adr:Integer; const AName:AnsiString);

Var
  SysProcs:Array[0..6] of SysProcInfo = (
    (name:'@HandleFinally'; impAdr:0),
    (name:'@HandleAnyException'; impAdr:0),
    (name:'@HandleOnException'; impAdr:0),
    (name:'@HandleAutoException'; impAdr:0),
    (name:'@RunError'; impAdr:0),
    (name:'@Halt0'; impAdr:0),
    (name:'@AbstractError'; impAdr:0)
  );

  SysInitProcs:Array[0..1] Of SysProcInfo = (
    (name:'@InitExe'; impAdr:0),
    (name:'@InitLib'; impAdr:0)
  );

  dummy:Integer;          //for debugging purposes!!!
  FMain: TFMain;
  ProjectModified:Boolean;
  frmDisasm:MDisasm;				//Дизассемблер для анализатора кода
  KBase:MKnowledgeBase;
  ResInfo:TResourceInfo;       //Information about forms
  Code:PAnsiChar;
  CodeSize:Integer;
  ImageSize:Integer;
  Image:PAnsiChar;
  CurProcAdr:Integer;
  CurUnitAdr:Integer;
  VmtList:TList;       //VMT list
  CodeBase:PAnsiChar;
  DelphiVersion:Integer;
  InfoList:AInfoRec; //Array of pointers to store items data
  BSSInfos:TStringList;  //Data from BSS
  SegmentList:TList;   //Information about Image Segments
  TotalSize:Integer;      //Size of sections CODE + DATA
  FlagList:PIntegerArray;     //flags for used data
  OwnTypeList:TList;
  SelectedAsmItem:AnsiString;    //Selected item in Asm Listing
  CrtSection:TCriticalSection;
  MaxBufLen:Integer;      //Максимальная длина буфера (для загрузки)
  HInstanceVarAdr:Integer;
  EP:Integer;
  UnitsNum:Integer;
  Units:TList;
  LastResStrNo:Integer;   //Last ResourceStringNo
  ClassTreeDone:Boolean;

implementation

{$R *.DFM}

Uses Threads,Misc,StrUtils,Def_disasm,Heuristic,{Highlight,}ActiveX,ShlObj,
  StringInfo, Explorer, FindDlg, EditFieldsDlg,Def_res,IniFiles,TypeInfo,
  InputDlg,Def_thread, EditFunctionDlg,IDCGen,AboutDlg,ShellAPI,Contnrs,
  KBViewer, Legend,Decompiler, Hex2Double,Clipbrd, Plugins,ActiveProcesses,
  Scanf,CodeSiteLogging;

Var
  is_debug:Boolean;
  Dest:TCodeSiteDestination;
  DelphiLbId:Cardinal;
  DelphiThemesCount:Integer;

//Image       Code
//|===========|======================================|
//ImageBase   CodeBase

  CodeHistorySize:Integer;    //Current size of Code navigation History Array
  CodeHistoryPtr:Integer;     //Curent pointer of Code navigation History Array
	CodeHistoryMax:Integer;		//Max pointer position of Code navigation History Array (for ->)
  CodeHistory:Array of PROCHISTORYREC;   //Code navigation History Array

  AnalyzeThread:TAnalyzeThread; //Поток для фонового анализа кода
  AnalyzeThreadRetVal:Integer;
  SourceIsLibrary:Boolean;
  UserKnowledgeBase:Boolean;

  //Common variables
  IDPFile:AnsiString;
  ImageBase:Integer;
  CodeStart:Integer;
  DataBase:Integer;
  DataSize:Integer;
  DataStart:Integer;
  Data:Pointer;

  ExpFuncList:TList;   //Exported functions list (temporary)
  ImpFuncList:TList;   //Imported functions list (temporary)
  ImpModuleList:TStringList; //Imported modules   list (temporary)

  //Units
  UnitSortField:Integer; //0 - по адресу, 1 - в порядке инициализации, 2 - по имени
  //Types
  RTTISortField:Integer; //0 - по адресу, 1 - по виду, 2 - по имени

  CurProcSize:Integer;
  LastTls:Integer;            //Последний занятый индекс Tls, показывает, сколько ThreadVars в программе
  Reserved:Integer;
  CtdRegAdr:Integer;			//Адрес процедуры CtdRegAdr

  VmtSelfPtr:Integer;
  VmtIntfTable:Integer;
  VmtAutoTable:Integer;
  VmtInitTable:Integer;
  VmtTypeInfo:Integer;
  VmtFieldTable:Integer;
  VmtMethodTable:Integer;
  VmtDynamicTable:Integer;
  VmtClassName:Integer;
  VmtInstanceSize:Integer;
  VmtParent:Integer;
  VmtEquals:Integer;
  VmtGetHashCode:Integer;
  VmtToString:Integer;
  VmtSafeCallException:Integer;
  VmtAfterConstruction:Integer;
  VmtBeforeDestruction:Integer;
  VmtDispatch:Integer;
  VmtDefaultHandler:Integer;
  VmtNewInstance:Integer;
  VmtFreeInstance:Integer;
  VmtDestroy:Integer;

  //class addresses cache
  //typedef std::map<const String, DWORD> TClassAdrMap;
  classAdrMap:TStringList;
  Procedure ClearClassAdrMap; Forward;

Constructor TFMain.Create(Owner:TComponent);
Begin
  Inherited;
  dragdropHelper:=TDragDropHelper.Create(Handle);
  CrtSection:=TCriticalSection.Create;
end;

Destructor TFMain.Free;
Begin
  CrtSection.Free;
end;

procedure TFMain.FormClose(Sender : TObject; Var Action:TCloseAction);
begin
  ModalResult:=mrCancel;
end;

procedure TFMain.FormKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  case Key of
    Ord('G'): GoToAddress;
    Ord('N'): NamePosition;
    Ord('F'):  //CTRL + F (1st search on different areas)
      if ssCtrl in Shift then case WhereSearch of
        SEARCH_UNITS: miSearchUnitClick(Sender);
        SEARCH_UNITITEMS: miSearchItemClick(Sender);
        SEARCH_RTTIS: miSearchRTTIClick(Sender);
        SEARCH_FORMS: miSearchFormClick(Sender);
        SEARCH_CLASSVIEWER: miSearchVMTClick(Sender);
        SEARCH_STRINGS: miSearchStringClick(Sender);
        SEARCH_NAMES: miSearchNameClick(Sender);
        //todo rest of locations
      End;
    VK_F3:  // F3 - (2nd search, continue search with same text)
      case WhereSearch of
        SEARCH_UNITS: FindText(UnitsSearchText);
        SEARCH_UNITITEMS: FindText(UnitItemsSearchText);
        SEARCH_RTTIS: FindText(RTTIsSearchText);
        SEARCH_FORMS: FindText(FormsSearchText);
        SEARCH_CLASSVIEWER: FindText(VMTsSearchText);
        SEARCH_STRINGS:	FindText(StringsSearchText);
        SEARCH_NAMES:	FindText(NamesSearchText);
      End;
  End;
end;

procedure TFMain.Units1Click(Sender : TObject);
begin
  //if tsUnits.Enabled then
  //begin
    pcInfo.ActivePage := tsUnits;
    if lbUnits.CanFocus then ActiveControl := lbUnits;
  //end;
end;

procedure TFMain.RTTI1Click(Sender : TObject);
begin
  //if tsRTTIs.Enabled then
  //begin
    pcInfo.ActivePage := tsRTTIs;
    if lbRTTIs.CanFocus then ActiveControl := lbRTTIs;
  //end;
end;

procedure TFMain.Forms1Click(Sender : TObject);
begin
  //if tsForms.Enabled then
  //begin
    pcInfo.ActivePage := tsForms;
    if lbForms.CanFocus then ActiveControl := lbForms;
  //end;
end;

procedure TFMain.CodeViewer1Click(Sender : TObject);
begin
  //if tsCodeView.Enabled then
  //begin
    pcWorkArea.ActivePage := tsCodeView;
    if lbCode.CanFocus then ActiveControl := lbCode;
  //end;
end;

procedure TFMain.ClassViewer1Click(Sender : TObject);
begin
  //if tsClassView.Enabled then
  //begin
    pcWorkArea.ActivePage := tsClassView;
    if rgViewerMode.ItemIndex=0 then
      if tvClassesFull.CanFocus then ActiveControl := tvClassesFull
      else if tvClassesShort.CanFocus then ActiveControl := tvClassesShort;
  //end;
end;

procedure TFMain.Strings1Click(Sender : TObject);
begin
  //if tsStrings.Enabled then
  //begin
    pcWorkArea.ActivePage := tsStrings;
    if lbStrings.CanFocus then ActiveControl := lbStrings;
  //end;
end;

procedure TFMain.Names1Click(Sender : TObject);
begin
  //if tsNames.Enabled then
  //begin
    pcWorkArea.ActivePage := tsNames;
    if lbNames.CanFocus then ActiveControl := lbNames;
  //end;
end;

procedure TFMain.SourceCode1Click(Sender : TObject);
begin
  //if tsSourceCode.Enabled then
  //begin
    pcWorkArea.ActivePage := tsSourceCode;
    if lbSourceCode.CanFocus then ActiveControl := lbSourceCode;
  //end;
end;

procedure TFMain.miExitClick(Sender : TObject);
begin
  Close;
end;

Procedure TFMain.Init;
Begin
  IDPFile := '';
  UnitsNum := 0;
  CurProcAdr := 0;
  CurProcSize := 0;
  SelectedAsmItem := '';
  CurUnitAdr := 0;
  CodeHistoryPtr := -1;
  CodeHistorySize := 0; //HISTORY_CHUNK_LENGTH;
  SetLength(CodeHistory,0);
  CodeHistoryMax := CodeHistoryPtr;

	DelphiVersion := -1;
  Caption := 'Interactive Delphi Reconstructor by crypto';

  HInstanceVarAdr := -1;
  LastTls := 0;
  CtdRegAdr := 0;

  WhereSearch := SEARCH_UNITS;
  UnitsSearchFrom := -1;
  UnitsSearchText := '';

  RTTIsSearchFrom := -1;
  RTTIsSearchText := '';

  FormsSearchFrom := -1;
  FormsSearchText := '';

  UnitItemsSearchFrom := -1;
  UnitItemsSearchText := '';

  TreeSearchFrom := Nil;
  BranchSearchFrom := Nil;
  VMTsSearchText := '';

  StringsSearchFrom := 0;
  StringsSearchText := '';

  NamesSearchFrom := 0;
  NamesSearchText := '';

  //Init Menu
  miLoadFile.Enabled := true;
  miOpenProject.Enabled := true;
  miMRF.Enabled := true;
  miSaveProject.Enabled := false;
  miSaveDelphiProject.Enabled := false;
  miExit.Enabled := true;
  miMapGenerator.Enabled := false;
  miCommentsGenerator.Enabled := false;
  miIDCGenerator.Enabled := false;
  miLister.Enabled := false;
  miClassTreeBuilder.Enabled := false;
  miKBTypeInfo.Enabled := false;
  miCtdPassword.Enabled := false;
  miHex2Double.Enabled := false;

  //Init Units
  lbUnits.Clear;
  vtUnit.Clear;
  miRenameUnit.Enabled := false;
  miSearchUnit.Enabled := false;
  miCopyList.Enabled := false;
  UnitSortField := 0;
  tsUnits.Enabled := false;

  //Init RTTIs
  lbRTTIs.Clear;
  miSearchRTTI.Enabled := false;
  miSortRTTI.Enabled := false;
  RTTISortField := 0;
  miSortRTTIsByAdr.Checked := true;
  miSortRTTIsByKnd.Checked := false;
  miSortRTTIsByNam.Checked := false;
  tsRTTIs.Enabled := false;

  //Init Forms
  lbForms.Clear;
  lbAliases.Clear;
  lClassName.Caption := '';
  cbAliases.Clear;
  rgViewFormAs.ItemIndex := 0;
  tsForms.Enabled := false;

  //Init Code
  lProcName.Caption := '';
  lbCode.Clear;
  lbCode.ScrollWidth := 0;
  miGoTo.Enabled := false;
  miExploreAdr.Enabled := false;
  miName.Enabled := false;
  miViewProto.Enabled := false;
  miEditFunctionC.Enabled := false;
  miXRefs.Enabled := false;
  miSwitchFlag.Enabled := false;
  bEP.Enabled := false;
  bDecompile.Enabled := false;
  bCodePrev.Enabled := false;
  bCodeNext.Enabled := false;
  tsCodeView.Enabled := false;
  lbCXrefs.Clear;
  lbCXrefs.Visible := true;

  //Init Strings
  lbStrings.Clear;
  miSearchString.Enabled := false;
  tsStrings.Enabled := false;
  //Init Names
  lbNames.Clear;
  tsNames.Enabled := false;

  //Xrefs
  lbSXrefs.Clear;
  lbSXrefs.Visible := true;

  //Init Unit Items
  lbUnitItems.Clear;
  lbUnitItems.ScrollWidth := 0;
  miEditFunctionI.Enabled := false;
  miFuzzyScanKB.Enabled := false;
  miSearchItem.Enabled := false;

  //Init ClassViewer
  ClassTreeDone := false;
  tvClassesFull.Items.Clear;
  tvClassesShort.Items.Clear;
  tvClassesShort.BringToFront;
  rgViewerMode.ItemIndex := 1;    //Short View
  tsClassView.Enabled := false;

  ClearTreeNodeMap;
  ClearClassAdrMap;

  pb.Position := 0;
  pb.Visible := false;
  sb.Panels[0].Width := Width div 2;
  sb.Panels[0].Text := '';
  sb.Panels[1].Text := '';

  Update;
  Sleep(0);

  ProjectLoaded := false;
  ProjectModified := false;
  UserKnowledgeBase := false;
  SourceIsLibrary := false;
end;

Function TFMain.GetImportRec (adr:Integer):PImportNameRec;
var
  n:Integer;
Begin
  for n := 0 to ImpFuncList.Count-1 do
  begin
    Result:= ImpFuncList[n];
    if adr = Result.address Then Exit;
  end;
  Result:=Nil;
end;

Procedure TFMain.FindExports;
var
  _pos,i,Adr:Integer;
  recE:PExportNameRec;
  recN:InfoRec;
Begin
  for i := 0 to ExpFuncList.Count-1 do
  begin
    recE := ExpFuncList[i];
    Adr := recE.address;
    if IsValidImageAdr(Adr) then
    begin
      _pos :=Adr2Pos(Adr);
      if _pos <> -1 then
      begin
        recN := InfoRec.Create(_pos, ikRefine);
        recN.Name:=recE.name;
        recN.procInfo.flags := 3; // stdcall
        InfoList[_pos] := recN; // probably needless, since InfoRec.Create already did it
        SetFlag(cfProcStart or cfExport, _pos);
      end;
    End;
  end;
end;

Procedure TFMain.FindImports;
var
  _pos,i,n,Adr,b,e:Integer;
  recI:PImportNameRec;
  recN:InfoRec;
Begin
  for i := 0 to TotalSize - 7 do
  Begin
    if (Code[i] = #255) and (Code[i + 1] = #$25) then
    Begin
      adr := PInteger(Code + i + 2)^;
      recI := GetImportRec(adr);
      if Assigned(recI) then
      Begin
        //name := UnmangleName(recI.name);
        if not Assigned(InfoList[i]) then
        Begin
          recN := InfoRec.Create(i, ikRefine);
          if (Pos('@Initialization$',recI.name)<>0) or (Pos('@Finalization$',recI.name)<>0) then
            recN.Name:=recI.module + '.' + recI.name
          else
          Begin
            b := Pos('@',recI.name);
            if b<>0 then
            Begin
              e := PosEx('$',recI.name,b + 1);
              if e<>0 then
              Begin
                if recI.name[e - 1] <> '@' then
                  recN.Name:=Copy(recI.name,b + 1, e - b - 1)
                else
                  recN.Name:=Copy(recI.name,b + 1, e - b - 2);
                if Pos('$bctr$',recI.name)<>0 then
                Begin
                  recN.ConcatName('@Create');
                  recN.kind := ikConstructor;
                End
                else if Pos('$bdtr$',recI.name)<>0 then
                Begin
                  recN.ConcatName('@Destroy');
                  recN.kind := ikDestructor;
                End;
                _pos := Pos('@',recN.Name);
                if _pos > 1 then PAnsiChar(recN.Name)[_pos] := '.';
              End;
            End
            else recN.Name:=recI.module + '.' + recI.name;
          End;
          for n:=Low(SysProcs) to High(SysProcs) do
          begin
            if Pos(SysProcs[n].name,recI.name)<>0 then
            Begin
              SysProcs[n].impAdr := Pos2Adr(i);
              break;
            End;
          end;
          SetFlag(cfImport, i);
        End;
        SetFlags(cfCode, i, 6);
      End;
    End;
  End;
end;

// Insert VMT into the code at position POS
Procedure TFMain.StrapVMT (_pos, ConstId:Integer; ConstInfo:PMConstInfo);
var
  pp,p,dump,relocs:PAnsiChar;
  ss,k,m,n,Idx, VMTOffset,Adr:Integer;
  fixup:FixupInfo;
  pInfo:MProcInfo;
  args:ArgInfo;
  recN:InfoRec;
  Len:Word;
  use:TWordDynArray;
  callKind:Byte;
  match:Boolean;
Begin
  if not Assigned(ConstInfo) then Exit;

  //Check dump VMT
  dump := ConstInfo.Dump;
  relocs := ConstInfo.Dump + ConstInfo.DumpSz;
  match := true;
  for n := 0 to ConstInfo.DumpSz-1 do
    if (relocs[n] <> Chr(255)) and (Code[_pos + n] <> dump[n]) then
    Begin
      match := false;
      break;
    End;
  if not match then Exit;

  SetFlags(cfData , _pos - 4, ConstInfo.DumpSz + 4);

  //VMTOffset := VmtSelfPtr + 4;
  //'Strap' fixups
  //Get used modules array
  use := KBase.GetModuleUses(ConstInfo.ModuleID);
  //Begin fixups data
  p := ConstInfo.Dump + 2*(ConstInfo.DumpSz);
  for n := 0 to ConstInfo.FixupNum-1 do
  Begin
    fixup._Type := Byte(p^);
    Inc(p);
    fixup.Ofs := PInteger(p)^;
    Inc(p, 4);
    Len := PWord(p)^; 
    Inc(p, 2);
    fixup.Name := p; 
    Inc(p, Len + 1);
    //Name begins with _D - skip it
    if (fixup.Name[0] = '_') and (fixup.Name[1] = 'D') then continue;
    //In VMT all fixups has type 'A'
    Adr := PInteger(Code + _pos + fixup.Ofs)^;
    VMTOffset := VmtSelfPtr + 4 + fixup.Ofs;
    if VMTOffset = VmtIntfTable then
    Begin
      if IsValidCodeAdr(Adr) and not Assigned(InfoList[Adr2Pos(Adr)]) then
      Begin
        //Strap IntfTable
        Idx := KBase.GetProcIdx(ConstInfo.ModuleID, fixup.Name, Code + Adr2Pos(Adr));
        if Idx <> -1 then
        Begin
          Idx := KBase.ProcOffsets[Idx].NamId;
          if not KBase.IsUsedProc(Idx) then
            if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
              StrapProc(Adr2Pos(Adr), Idx, @pInfo, true, pInfo.DumpSz);
        End;
      End;
      continue;
    End
    else if VMTOffset = VmtAutoTable then
    Begin
      //Strap AutoTable
      //Unknown - no examples
      continue;
    End
    else if VMTOffset = VmtInitTable then
    Begin
      //InitTable представляет собой ссылки на типы, которые встретятся позже
      continue;
    End
    else if VMTOffset = VmtTypeInfo then
    Begin
      //Информация о типе уже обработана, пропускаем
      continue;
    End
    else if VMTOffset = VmtFieldTable then
    Begin
      //Пропускаем, поскольку будем обрабатывать информацию о полях позднее
      continue;
    End
    else if VMTOffset = VmtMethodTable then
    Begin
      //Пропускаем, поскольку методы будут обработаны среди прочих фиксапов
      continue;
    End
    else if VMTOffset = VmtDynamicTable then
    Begin
      //Пропускаем, поскольку динамические вызовы будут обработаны среди прочих фиксапов
      continue;
    End
    else if VMTOffset = VmtClassName then
    Begin
      //ClassName не обрабатываем
      continue;
    End
    else if VMTOffset = VmtParent then
    Begin
      //Указывает на родительский класс, не обрабатываем, поскольку он все-равно встретится отдельно
      continue;
    End
    else if (VMTOffset >= VmtParent + 4) and (VMTOffset <= VmtDestroy) then
    Begin
      if IsValidCodeAdr(Adr) and not Assigned(InfoList[Adr2Pos(Adr)]) then
      Begin
        Idx := KBase.GetProcIdx(use, fixup.Name, Code + Adr2Pos(Adr));
        if Idx <> -1 then
        Begin
          Idx := KBase.ProcOffsets[Idx].NamId;
          if not KBase.IsUsedProc(Idx) then
            if (KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo)) then
              StrapProc(Adr2Pos(Adr), Idx, @pInfo, true, pInfo.DumpSz);
        End
        //Code not matched, but prototype may be used
        else
        Begin
          recN := InfoRec.Create(Adr2Pos(Adr), ikRefine);
          recN.Name:=fixup.Name;
          //Prototype???
          if Length(use)<>0 then
          Begin
            m:=0;
            while use[m] <> $FFFF do
            Begin
              Idx := KBase.GetProcIdx(use[m], fixup.Name);
              if Idx <> -1 then
              Begin
                Idx := KBase.ProcOffsets[Idx].NamId;
                if KBase.GetProcInfo(Idx, INFO_ARGS, pInfo) then
                Begin
                  case pInfo.MethodKind of
                    'C': recN.kind := ikConstructor;
                    'D': recN.kind := ikDestructor;
                    'P': recN.kind := ikProc;
                    'F':
                      Begin
                        recN.kind := ikFunc;
                        recN._type := pInfo.TypeDef;
                      end;
                  End;
                  if Assigned(pInfo.Args) then
                  Begin
                  	callKind := pInfo.CallKind;
                    recN.procInfo.flags := recN.procInfo.flags or callKind;
                    pp := pInfo.Args;
                    ss := 8;
                    for k := 0 to pInfo.ArgsNum-1 do
                    Begin
                      FillArgInfo(k, callKind, @args, pp, ss);
                      recN.procInfo.AddArg(@args);
                    End;
                  End;
                  //Set kbIdx for fast search
                  recN.kbIdx := Idx;
                  recN.procInfo.flags := recN.procInfo.flags or PF_KBPROTO;
                End;
              End;
              Inc(m);
            End;
          End;
        End;
      End;
      continue;
    End
    //Если адрес в кодовом сегменте и с ним не связано никакой информации
    else if IsValidCodeAdr(Adr) and not Assigned(InfoList[Adr2Pos(Adr)]) then
    Begin
      //Название типа?
      if not IsFlagSet(cfRTTI, Adr2Pos(Adr)) then
      Begin
        //Процедура?
        Idx := KBase.GetProcIdx(use, fixup.Name, Code + Adr2Pos(Adr));
        if Idx <> -1 then
        Begin
          Idx := KBase.ProcOffsets[Idx].NamId;
          if not KBase.IsUsedProc(Idx) then
            if (KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo)) then
              StrapProc(Adr2Pos(Adr), Idx, @pInfo, true, pInfo.DumpSz);
        End
        //Code not matched, but prototype may be used
        else
        Begin
          recN := InfoRec.Create(Adr2Pos(Adr), ikRefine);
          recN.Name:=fixup.Name;
          //Prototype???
          if Length(use)<>0 then
          Begin
            m:=0;
            while use[m] <> $FFFF do
            Begin
              Idx := KBase.GetProcIdx(use[m], fixup.Name);
              if Idx <> -1 then
              Begin
                Idx := KBase.ProcOffsets[Idx].NamId;
                if KBase.GetProcInfo(Idx, INFO_ARGS, pInfo) then
                Begin
                  case pInfo.MethodKind of
                    'C': recN.kind := ikConstructor;
                    'D': recN.kind := ikDestructor;
                    'P': recN.kind := ikProc;
                    'F':
                      Begin
                        recN.kind := ikFunc;
                        recN._type := pInfo.TypeDef;
                      end;
                  End;
                  if Assigned(pInfo.Args) then
                  Begin
                  	callKind := pInfo.CallKind;
                    recN.procInfo.flags := recN.procInfo.flags or callKind;
                    pp := pInfo.Args; 
                    ss := 8;
                    for k := 0 to pInfo.ArgsNum-1 do
                    Begin
                      FillArgInfo(k, callKind, @args, pp, ss);
                      recN.procInfo.AddArg(@args);
                    End;
                  End;
                  //Set kbIdx for fast search
                  recN.kbIdx := Idx;
                  recN.procInfo.flags := recN.procInfo.flags or PF_KBPROTO;
                End;
              End;
              Inc(m);
            End;
          End;
        End;
      End;
      continue;
    End;
  End;
  use:=Nil;
end;

//Check possibility of "straping" procedure (only at the first level)
Function TFMain.StrapCheck (_pos:Integer; ProcInfo:PMProcInfo):Boolean;
var
  c:Char;
  n,ap,Adr, Ofs, Val:Integer;
  p,dump:PAnsiChar;
  _name, name1, fName:AnsiString;
  recN:InfoRec;
  fixup:FixupInfo;
  Len:Word;
Begin
  Result:=false;
  if not Assigned(ProcInfo) then exit;

  dump := ProcInfo.Dump;
  //Fixup data begin
  p := dump + 2*(ProcInfo.DumpSz);
  //If procedure is jmp off_XXXXXXXX, return false
  if (dump^ = Chr($FF)) and (dump[1] = Chr($25)) then Exit;
  for n := 0 to ProcInfo.FixupNum-1 do
  Begin
    fixup._Type := Byte(p^);
    Inc(p);
    fixup.Ofs := PInteger(p)^; 
    Inc(p, 4);
    Len := PWord(p)^; 
    Inc(p, 2);
    fixup.Name := p; 
    Inc(p, Len + 1);
    fName := String(fixup.Name);
    //Fixupname begins with "_Dn_" - skip it
    if Pos('_Dn_',fName) = 1 then continue;
    //Fixupname begins with "_NF_" - skip it
    if Pos('_NF_',fName) = 1 then continue;
    //Fixupname is "_DV_" - skip it
    if SameText(fName, '_DV_') then continue;
    //Fixupname begins with "_DV_"
    if Pos('_DV_',fName) = 1 then
    Begin
      c := fName[5];
      //Fixupname is _DV_number - skip it
      if c in ['0'..'9'] then continue
      //Else transfrom fixupname to normal
      else if fName[Len] = '_' then
        fName := Copy(fName,5, Len - 5)
      else
        fName := Copy(fName,5, Len - 4);
    End;
    //Empty fixupname - skip it
    if fName = '' then continue;
    Val := PInteger(Code + _pos + fixup.Ofs)^;
    if (fixup._Type = Ord('A')) or (fixup._Type = Ord('S')) then
    Begin
      Ofs := PInteger(dump + fixup.Ofs)^;
      Adr := Val - Ofs;
      if IsValidImageAdr(Adr) then
      Begin
        ap := Adr2Pos(Adr); 
        recN := GetInfoRec(Adr);
        if Assigned(recN) and recN.HasName then
        Begin
          //If not import call just compare names
          if (ap >= 0) and not IsFlagSet(cfImport, ap) then
          Begin
            if not recN.SameName(fName) then Exit;
          End
          //Else may be partial unmatching
          else
          Begin
            _name := ExtractProcName(recN.Name);
            if not SameText(_name, fName) and 
              not SameText(Copy(_name,1, Length(_name) - 1), fName) then Exit;
          End;
        End;
      End;
    End
    else if fixup._Type = Ord('J') then
    Begin
      Adr := Integer(CodeBase) + _pos + fixup.Ofs + 4 + Val;
      if IsValidCodeAdr(Adr) then
      Begin
        ap := Adr2Pos(Adr); 
        recN := GetInfoRec(Adr);
        if Assigned(recN) and recN.HasName then
        Begin
          //If not import call just compare names
          if (ap >= 0) and not IsFlagSet(cfImport, ap) then
          Begin
            if not recN.SameName(fName) then Exit;
          End
          //Else may be partial unmatching
          else
          Begin
            _name := ExtractProcName(recN.Name);
            if not SameText(_name, fName) then
            Begin
              name1 := Copy(_name,1, Length(_name) - 1); //Trim last symbol ('A','W') - GetWindowLongW(A)
              if not SameText(Copy(fName,1, Length(name1)), name1) then Exit;
            End;
          End;
        End;
      End;
    End
    else if fixup._Type = Ord('D') then
    Begin
      Adr := Val;
      if IsValidImageAdr(Adr) then
      Begin
        recN := GetInfoRec(Adr);
        if Assigned(recN) and recN.HasName then
        Begin
          if not recN.SameName(fName) then Exit;
        End;
      End;
    End;
  End;
  Result:=True;
end;

//"Strap" procedure ProcIdx int code from position pos
Procedure TFMain.StrapProc (_pos, ProcIdx:Integer; ProcInfo:PMProcInfo; useFixups:Boolean; procSize:Integer);
var
  ndx,locflags,k,procStart,procEnd,aa,ss,instrlen:Integer;
  ps,n,idx,size,Adr, Adr1, Ofs, Val,Sections,bytes:Integer;
  use:TWordDynArray;
  fName,moduleName,cname:AnsiString;
  fixup:FixupInfo;
  recU:PUnitRec;
  recN:InfoRec;
  aInfo:ArgInfo;
  cInfo:MConstInfo;
  tInfo:MTypeInfo;
  vInfo:MVarInfo;
  rsInfo:MResStrInfo;
  pInfo:MProcInfo;
  disInfo:TDisInfo;
  p:PAnsiChar;
  wLen,Len:Word;
  callKind:Byte;
  c:Char;
  isHInstance:Boolean;
Begin
  if not Assigned(ProcInfo) then Exit;
  //Citadel!!!
  if SameText(ProcInfo.ProcName, 'CtdReg') then
  Begin
  	if procSize = 1 then Exit;
    CtdRegAdr := Pos2Adr(_pos);
  End;
  ProcStart := Pos2Adr(_pos);
  ProcEnd := ProcStart + procSize;
  ModuleName := KBase.GetModuleName(ProcInfo.ModuleID);
  if not IsUnitExist(ModuleName) then
  Begin
    //Get unit by pos
    recU := GetUnit(Pos2Adr(_pos));
    if Assigned(recU) then
    Begin
      SetUnitName(recU, ModuleName);
      recU.kb := true;
    End;
  End;
  if ProcInfo.DumpType = 'D' then
  	SetFlags(cfData, _pos, procSize)
  else
  Begin
    SetFlags(cfCode, _pos, procSize);
    //Mark proc begin
    SetFlag(cfProcStart, _pos);
    //SetFlag(cfProcEnd, _pos + procSize - 1);

    recN := GetInfoRec(Pos2Adr(_pos));
    if not Assigned(recN) then recN := InfoRec.Create(_pos, ikRefine);
    //Mark proc end
    recN.procInfo.procSize := procSize;
    case ProcInfo.MethodKind of
      'C': recN.kind := ikConstructor;
      'D': recN.kind := ikDestructor;
      'F': 
        Begin
          recN.kind := ikFunc;
          recN._type := ProcInfo.TypeDef;
        End;
      'P': recN.kind := ikProc;
    End;
    recN.kbIdx := ProcIdx;
    recN.Name:=ProcInfo.ProcName;
    //Get Args
    if not recN.MakeArgsManually then
    Begin
      callKind := ProcInfo.CallKind;
      recN.procInfo.flags := recN.procInfo.flags or callKind;
      aa := 0;
      ss := 8;
      p := ProcInfo.Args;
      if Assigned(p) then
      Begin
        for k := 0 to ProcInfo.ArgsNum-1 do
        Begin
          aInfo.Tag := Byte(p^);
          Inc(p);
          locflags := PInteger(p)^; 
          Inc(p, 4);
          aInfo.in_Reg := (locflags and 8)<>0;
          //Ndx
          ndx := PInteger(p)^; 
          Inc(p, 4);
          aInfo.Size := 4;
          wlen := PWord(p)^; 
          Inc(p,2);
          aInfo.Name := MakeString(p, wlen);
          Inc(p, wlen + 1);
          wlen := PWord(p)^; 
          Inc(p, 2);
          aInfo.TypeDef := TrimTypeName(MakeString(p, wlen));
          Inc(p, wlen + 1);
          //Some correction of knowledge base
          if SameText(aInfo.Name, 'Message') and SameText(aInfo.TypeDef, 'void') then
          Begin
            aInfo.Name := 'Msg';
            aInfo.TypeDef := 'TMessage';
          End;
          if SameText(aInfo.TypeDef, 'String') then aInfo.TypeDef := 'AnsiString';
          if SameText(aInfo.TypeDef, 'Int64') or
            SameText(aInfo.TypeDef, 'Real') or
            SameText(aInfo.TypeDef, 'Real48') or
            SameText(aInfo.TypeDef, 'Comp') or
            SameText(aInfo.TypeDef, 'Double') or
            SameText(aInfo.TypeDef, 'Currency') or
            SameText(aInfo.TypeDef, 'TDateTime') then
            aInfo.Size := 8;
          if SameText(aInfo.TypeDef, 'Extended') then aInfo.Size := 12;
          if callKind=0 then
          Begin
            if (aa < 3) and (aInfo.Size = 4) then
            Begin
              aInfo.Ndx := aa;
              Inc(aa);
            End
            else
            Begin
              aInfo.Ndx := ss;
              Inc(ss, aInfo.Size);
            End;
          End
          else
          Begin
            aInfo.Ndx := ss;
            Inc(ss, aInfo.Size);
          End;
          recN.procInfo.AddArg(@aInfo);
        End;
      End;
    End;
    recN.procInfo.flags := recN.procInfo.flags or PF_KBPROTO;
  End;
  //Fix used procedure
  KBase.SetUsedProc(ProcIdx);
  if useFixups and (ProcInfo.FixupNum<>0) then
  Begin
    //Get array of used modules
    use := KBase.GetModuleUses(ProcInfo.ModuleID);
    //Начало данных по фиксапам
    p := ProcInfo.Dump + 2*ProcInfo.DumpSz;
    for n := 0 to ProcInfo.FixupNum-1 do
    Begin
      fixup._Type := Byte(p^);
      Inc(p);
      fixup.Ofs := PInteger(p)^;
      Inc(p, 4);
      Len := PWord(p)^; 
      Inc(p, 2);
      fixup.Name := p; 
      Inc(p,Len + 1);
      fName := MakeString(fixup.Name, Len);
      //Fixupname begins with _Dn_ - skip it
      if Pos('_Dn_',fName) = 1 then continue;
      //Fixupname begins with _NF_ - skip it
      if Pos('_NF_',fName) = 1 then continue;
      //Fixupname is '_DV_' - skip it
      if SameText(fName, '_DV_') then continue;
      //Fixupname begins with _DV_
      if Pos('_DV_',fName) = 1 then
      Begin
        c := fName[5];
        //Fixupname is _DV_number - skip it
        if c in ['0'..'9'] then continue
        //Else transfrom fixupname to normal
        else if fName[Len] = '_' then
          fName := Copy(fName,5, Len - 5)
        else
          fName := Copy(fName,5, Len - 4);
      End;
      if (fName = '') or (fName = '.') then continue;

      Val := PInteger(Code + _pos + fixup.Ofs)^;
      //FixupName is the same as ProcName
      if SameText(fName, ProcInfo.ProcName) then
      Begin
        //!!!
        //Need to use this information:
        //CaseStudio, 405ae4 - call [offs+4*eax] - how to use offs? And offs has cfLoc
        //Val inside procedure - possible jump address for switch (or call)
        if fixup._Type = Ord('J') then
        Begin
          Adr := Integer(CodeBase) + _pos + fixup.Ofs + Val + 4;
          if (Adr >= ProcStart) and (Adr < ProcEnd) then
            SetFlag(cfLoc or cfEmbedded, Adr2Pos(Adr));
        End;
        continue;
      End;
      //Сначала подсчитаем адрес, а потом будем пытаться определять секцию
      if Char(fixup._Type) in ['A','S','4','8'] then
      Begin
        //Смотрим, какая величина стоит в дампе в позиции фиксапа
        Ofs := PInteger(ProcInfo.Dump + fixup.Ofs)^;
        Adr := Val - Ofs;
      End
      else if fixup._Type = Ord('J') then
        Adr := Integer(CodeBase) + _pos + fixup.Ofs + Val + 4
      else if Char(fixup._Type) in ['D','6','5'] then
        Adr := Val
      else
      Begin
        ShowMessage('Unknown fixup type: ' + IntToStr(fixup._Type));
        Adr:=0;
      end;

      isHInstance := AnsiStrIComp(fixup.Name, 'HInstance') = 0;
      if not IsValidImageAdr(Adr) then
      Begin
        //Пока здесь наблюдались лишь одни ThreadVars и TlsLast
        if AnsiStrIComp(fixup.Name, 'TlsLast')=0 then
          LastTls := Val
        else
        Begin
          recN := GetInfoRec(Pos2Adr(_pos + fixup.Ofs));
          if not Assigned(recN) then
          Begin
            recN := InfoRec.Create(_pos + fixup.Ofs, ikData);
            recN.Name:=fixup.Name;
            //Определим тип Var
            Idx := KBase.GetVarIdx(use, fixup.Name);
            if Idx <> -1 then
            Begin
              Idx := KBase.VarOffsets[Idx].NamId;
              if KBase.GetVarInfo(Idx, 0, vInfo) then
              Begin
                if vInfo._Type = Ord('T') then recN.kind := ikThreadVar;
                recN.kbIdx := Idx;
                recN._type := TrimTypeName(vInfo.TypeDef);
              End;
            End;
          End;
        End;
        continue;
      End;
      if (Adr >= ProcStart) and (Adr < ProcEnd) then continue;
      if isHInstance then
      Begin
        Adr1 := PInteger(Code + Adr2Pos(Adr))^;
        if IsValidImageAdr(Adr1) then
          HInstanceVarAdr := Adr1
        else
          HInstanceVarAdr := Adr;
      End;
      Sections := KBase.GetItemSection(use, fixup.Name);
      //Адрес в кодовом сегменте вне тела самой функции
      if IsValidCodeAdr(Adr) then
      Begin
        recN := GetInfoRec(Adr);
        if not Assigned(recN) then
        Begin
          case Sections of
            KB_CONST_SECTION:
              begin
                Idx := KBase.GetConstIdx(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.ConstOffsets[Idx].NamId;
                  //Если имя начинается на _DV_, значит это VMT
                  if AnsiStrLComp(fixup.Name, '_DV_', 4)=0 then
                  Begin
                    if KBase.GetConstInfo(Idx, INFO_DUMP, cInfo) then
                      StrapVMT(Adr2Pos(Adr) + 4, Idx, @cInfo);
                  End;
                end;
              End;
            KB_TYPE_SECTION:
              begin
                Idx := KBase.GetTypeIdxByModuleIds(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.TypeOffsets[Idx].NamId;
                  if KBase.GetTypeInfo(Idx, 0, tInfo) then
                  Begin
                    recN := InfoRec.Create(Adr2Pos(Adr), ikData);
                    recN.kbIdx := Idx;
                    recN.Name:=tInfo.TypeName;
                  End;
                end;
              End;
            KB_VAR_SECTION:
              begin
                Idx := KBase.GetVarIdx(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.VarOffsets[Idx].NamId;
                  if KBase.GetVarInfo(Idx, 0, vInfo) then
                  Begin
                    recN := InfoRec.Create(Adr2Pos(Adr), ikData);
                    recN.kbIdx := Idx;
                    recN.Name:=vInfo.VarName;
                    recN._type := TrimTypeName(vInfo.TypeDef);
                  End;
                end;
              End;
            KB_RESSTR_SECTION:
              begin
                Idx := KBase.GetResStrIdx(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.ResStrOffsets[Idx].NamId;
                  if KBase.GetResStrInfo(Idx, 0, rsInfo) then
                  Begin
                    recN := InfoRec.Create(Adr2Pos(Adr), ikData);
                    recN.kbIdx := Idx;
                    recN.Name:=rsInfo.ResStrName;
                    recN._type := rsInfo.TypeDef;
                  End;
                end;
              End;
            KB_PROC_SECTION:
              begin
                Idx := KBase.GetProcIdx(use, fixup.Name, Code + Adr2Pos(Adr));
                if Idx <> -1 then
                Begin
                  Idx := KBase.ProcOffsets[Idx].NamId;
                  if not KBase.IsUsedProc(Idx) then
                    if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
                      StrapProc(Adr2Pos(Adr), Idx, @pInfo, true, pInfo.DumpSz);
                end
                else
                Begin
                  Idx := KBase.GetProcIdx(use, fixup.Name, Nil);
                  if Idx <> -1 then
                  Begin
                    Idx := KBase.ProcOffsets[Idx].NamId;
                    if not KBase.IsUsedProc(Idx) then
                    Begin
                      if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
                      Begin
                        if not SameText(fName, '@Halt') then
                          StrapProc(Adr2Pos(Adr), Idx, @pInfo, false, EstimateProcSize(Adr))
                        else
                        Begin
                          bytes := EstimateProcSize(Adr);
                          while bytes > 0 do
                          Begin
                            instrlen := frmDisasm.Disassemble(Code + Adr2Pos(Adr), Adr, @disInfo, Nil);
                            if disInfo.Branch and not disInfo.Conditional then
                            Begin
                              Adr := disInfo.Immediate;
                              Idx := KBase.GetProcIdx(use, '@Halt0', Nil);
                              if Idx <> -1 then
                              Begin
                                Idx := KBase.ProcOffsets[Idx].NamId;
                                if not KBase.IsUsedProc(Idx) then
                                  if KBase.GetProcInfo(Idx, INFO_DUMP or INFO_ARGS, pInfo) then
                                    StrapProc(Adr2Pos(Adr), Idx, @pInfo, false, EstimateProcSize(Adr));
                              End;
                              break;
                            End;
                            Dec(bytes, instrlen);
                          End;
                        End;
                      End;
                    End;
                  End;
                End;
              End;
          End;
          continue;
        End;
      End;
      //Адрес в секции DATA
      if IsValidImageAdr(Adr) then
      Begin
        ps := Adr2Pos(Adr);
        if ps >= 0 then
        Begin
          recN := GetInfoRec(Adr);
          if not Assigned(recN) then
          Begin
            case Sections of
              KB_CONST_SECTION:
                begin
                  Idx := KBase.GetConstIdx(use, fixup.Name);
                  if Idx <> -1 then
                  Begin
                    Idx := KBase.ConstOffsets[Idx].NamId;
                    if KBase.GetConstInfo(Idx, INFO_DUMP, cInfo) then
                    Begin
                      cname := '';
                      if Pos('_DV_',cInfo.ConstName) = 1 then
                      Begin
                        c := cInfo.ConstName[5];
                        if c > '9' then
                        Begin
                          if cInfo.ConstName[Len] = '_' then
                            cname := Copy(cInfo.ConstName,5, Len - 5)
                          else
                            cname := Copy(cInfo.ConstName,5, Len - 4);
                        End;
                      End
                      else cname := cInfo.ConstName;
                      recN := InfoRec.Create(ps, ikData);
                      recN.kbIdx := Idx;
                      recN.Name:=cname;
                      recN._type := cInfo.TypeDef;
                    End;
                  End;
                end;
              KB_TYPE_SECTION:
                begin
                  Idx := KBase.GetTypeIdxByModuleIds(use, fixup.Name);
                  if Idx <> -1 then
                  Begin
                    Idx := KBase.TypeOffsets[Idx].NamId;
                    if KBase.GetTypeInfo(Idx, 0, tInfo) then
                    Begin
                      recN := InfoRec.Create(ps, ikData);
                      recN.kbIdx := Idx;
                      recN.Name:=tInfo.TypeName;
                    End;
                  End;
                end;
              KB_VAR_SECTION:
                begin
                  Idx := KBase.GetVarIdx(use, fixup.Name);
                  if Idx <> -1 then
                  Begin
                    Idx := KBase.VarOffsets[Idx].NamId;
                    if KBase.GetVarInfo(Idx, 0, vInfo) then
                    Begin
                      recN := InfoRec.Create(ps, ikData);
                      recN.kbIdx := Idx;
                      recN.Name:=vInfo.VarName;
                      recN._type := TrimTypeName(vInfo.TypeDef);
                    End;
                  End;
                end;
              KB_RESSTR_SECTION:
                begin
                  Idx := KBase.GetResStrIdx(use, fixup.Name);
                  if Idx <> -1 then
                  Begin
                    Idx := KBase.ResStrOffsets[Idx].NamId;
                    if KBase.GetResStrInfo(Idx, 0, rsInfo) then
                    Begin
                      recN := InfoRec.Create(ps, ikData);
                      recN.kbIdx := Idx;
                      recN.Name:=rsInfo.ResStrName;
                      recN._type := rsInfo.TypeDef;
                    End;
                  End;
                end;
            End;
          End;
        End
        else
        Begin
          case Sections of
            KB_CONST_SECTION:
              begin
                Idx := KBase.GetConstIdx(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.ConstOffsets[Idx].NamId;
                  if KBase.GetConstInfo(Idx, INFO_DUMP, cInfo) then
                  Begin
                    cname := '';
                    if Pos('_DV_',cInfo.ConstName) = 1 then
                    Begin
                      c := cInfo.ConstName[5];
                      if c > '9' then
                      Begin
                        if cInfo.ConstName[Len] = '_' then
                          cname := Copy(cInfo.ConstName,5, Len - 5)
                        else
                          cname := Copy(cInfo.ConstName,5, Len - 4);
                      End;
                    End
                    else cname := cInfo.ConstName;
                    AddToBSSInfos(Adr, cname, cInfo.TypeDef);
                  End;
                End;
              end;
            KB_TYPE_SECTION:
              begin
                Idx := KBase.GetTypeIdxByModuleIds(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.TypeOffsets[Idx].NamId;
                  if KBase.GetTypeInfo(Idx, 0, tInfo) then
                  begin
                    AddToBSSInfos(Adr, tInfo.TypeName, '');
                  end;
                End;
              end;
            KB_VAR_SECTION:
              begin
                Idx := KBase.GetVarIdx(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.VarOffsets[Idx].NamId;
                  if KBase.GetVarInfo(Idx, 0, vInfo) then
                    AddToBSSInfos(Adr, vInfo.VarName, TrimTypeName(vInfo.TypeDef));
                End;
              end;
            KB_RESSTR_SECTION:
              begin
                Idx := KBase.GetResStrIdx(use, fixup.Name);
                if Idx <> -1 then
                Begin
                  Idx := KBase.ResStrOffsets[Idx].NamId;
                  if KBase.GetResStrInfo(Idx, 0, rsInfo) then
                    AddToBSSInfos(Adr, rsInfo.ResStrName, rsInfo.TypeDef);
                End;
              end;
          End;
        End;
      End;
    End;
    use:=Nil;
  End;
end;

Function TFMain.GetDelphiVersion:Integer;
var
  moduleID:Word;
  n,v,m,idx, _pos, version:Integer;
  unitsTab, vmtAdr, adr:Integer;
  TControlInstSize,TFormInstSize:Integer;
  KBFileName:AnsiString;
  sysKB:MKnowledgeBase;
  pInfo:MProcInfo;
  rtlBplName, vclBplName, rtlBpl, vclBpl:AnsiString;
  srcPath,rtlFile,vclFile,rtlBplVersion,vclBplVersion:AnsiString;
Begin
  Result:=-1;
  if IsExtendedInitTab(unitsTab) then // >=2010
  Begin
    KBFileName := AppDir + 'syskb2014.bin';
    sysKB:=MKnowledgeBase.Create;
    try
      if SysKB.Open(KBFileName) then
      Begin
        moduleID := SysKB.GetModuleID('System');
        if moduleID <> $FFFF then
        Begin
          //Find index of function 'StringCopy' in this module
          idx := SysKB.GetProcIdx(moduleID, 'StringCopy');
          if idx <> -1 then
          Begin
            SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
            _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
            if _pos <> -1 then
            Begin
              SysKB.Close;
              Result:=2014;
              Exit;
            End;
          End;
        End;
        SysKB.Close;
      End;
    Finally
      sysKB.Free;
    end;

    KBFileName := AppDir + 'syskb2013.bin';
    sysKB:=MKnowledgeBase.Create;
    try
      if SysKB.Open(KBFileName) then
      Begin
        moduleID := SysKB.GetModuleID('System');
        if moduleID <> $FFFF then
        Begin
          //Find index of function '@FinalizeResStrings' in this module
          idx := SysKB.GetProcIdx(moduleID, '@FinalizeResStrings');
          if idx <> -1 then
          Begin
            SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
            _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
            if _pos <> -1 then
            Begin
              SysKB.Close;
              Result:=2013;
              Exit;
            End;
          End;
        End;
        SysKB.Close;
      End;
    Finally
      sysKB.Free;
    end;

    KBFileName := AppDir + 'syskb2012.bin';
    sysKB:=MKnowledgeBase.Create;
    try
      if SysKB.Open(KBFileName) then
      Begin
        moduleID := SysKB.GetModuleID('System');
        if moduleID <> $FFFF then
        Begin
          //Find index of function '@InitializeControlWord' in this module
          idx := SysKB.GetProcIdx(moduleID, '@InitializeControlWord');
          if idx <> -1 then
          Begin
            SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
            _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
            if _pos <> -1 then
            Begin
              SysKB.Close;
              Result:=2012;
              Exit;
            End;
          End;
        End;
        SysKB.Close;
      End;
    Finally
      sysKB.Free;
    end;

    KBFileName := AppDir + 'syskb2011.bin';
    sysKB:=MKnowledgeBase.Create;
    try
      if SysKB.Open(KBFileName) then
      Begin
        moduleID := SysKB.GetModuleID('System');
        if moduleID <> $FFFF then
        Begin
          //Find index of function 'ErrorAt' in this module
          idx := SysKB.GetProcIdx(moduleID, 'ErrorAt');
          if idx <> -1 then
          Begin
            SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
            _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
            if _pos <> -1 then
            Begin
              SysKB.Close;
              Result:=2011;
              Exit;
            End;
          End;
        End;
        SysKB.Close;
      End;
    Finally
      sysKB.Free;
    end;
    Result:=2010;
    Exit;
  End;

  TControlInstSize := 0;
  //Пробуем для начала как в DeDe (Ищем тип TControl)
  n:=0;
  while n<TotalSize - 14 do
  Begin
    if AnsiStrLComp(Image + n,#7#8'TControl',10)=0 then
    Begin
    	//После типа должен следовать указатель на таблицу VMT (0)
      vmtAdr := PInteger(Image + n + 10)^;
      if IsValidImageAdr(vmtAdr) then
      Begin
      	//Проверяем смещение -$18
        TControlInstSize := PInteger(Image + Adr2Pos(vmtAdr) - $18)^;
        if TControlInstSize = $A8 then 
        begin
          Result:=2;
          Exit;
        end;
      	//Проверяем смещение -$1C
        TControlInstSize := PInteger(Image + Adr2Pos(vmtAdr) - $1C)^;
        if (TControlInstSize = $B0) or (TControlInstSize = $B4) then
        begin
          Result:=3;
          Exit;
        end;
      	//Проверяем смещение -$28
        TControlInstSize := PInteger(Image + Adr2Pos(vmtAdr) - $28)^;
        if TControlInstSize = $114 then
        begin
          Result:=4;
          Exit;
        end
        else if TControlInstSize = $120 then
        begin
          Result:=5;
          Exit;
        end
        else if TControlInstSize = $15C then //6 или 7
        Begin
          TFormInstSize := 0;
          //Ищем тип TForm (выбор между версией 6 и 7)
          m:=0;
          while m < TotalSize - 11 do
          Begin
            if AnsiStrLComp(Image + m, #7#5'TForm',7)=0 then
            Begin
              //После типа должен следовать указатель на таблицу VMT (0)
              vmtAdr := PInteger(Image + m + 7)^;
              if IsValidImageAdr(vmtAdr) then
              Begin
                //Проверяем смещение -$28
                TFormInstSize := PInteger(Image + Adr2Pos(vmtAdr) - $28)^;
                if TFormInstSize = $2F0 then
                begin
                  Result:=6;
                  Exit;
                end
                else if TFormInstSize = $2F8 then 
                begin
                  Result:=7;
                  Exit;
                end;
              End;
            End;
            Inc(m,4);
          End;
          break;
        End
        else if TControlInstSize = $164 then
        begin
          Result:=2005;
          Exit;
        end
        else if TControlInstSize = $190 then break;	//2006 или 2007
        //Проверяем смещение -$34
        TControlInstSize := PInteger(Image + Adr2Pos(vmtAdr) - $34)^;
        if TControlInstSize = $1A4 then
        begin
          Result:=2009;
          Exit;
        end
        else if TControlInstSize = $1AC then
        begin
          Result:=2010;
          Exit;
        end;
      End;
    End;
    Inc(n,4);
  End;
  //Оставшиеся варианты проверяем через базу знаний
  for v:=Low(DelphiVersions) To High(DelphiVersions) do
  Begin
    version := DelphiVersions[v];
    if (TControlInstSize = $190) and (version <> 2006) and (version <> 2007) then continue;
    KBFileName := AppDir + 'syskb' + IntToStr(version) + '.bin';
    sysKB:=MKnowledgeBase.Create;
    try
      if SysKB.Open(KBFileName) then
      Begin
        moduleID := SysKB.GetModuleID('System');
        if moduleID <> $FFFF then
        Begin
          //Ищем индекс функции 'System' в данном модуле
          idx := SysKB.GetProcIdx(moduleID, 'System');
          if idx <> -1 then
          Begin
            SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
            _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
            if _pos <> -1 then
            Begin
              if (version = 4) or (version = 5) then
              Begin
                idx := SysKB.GetProcIdx(moduleID, '@HandleAnyException');
                if idx <> -1 then
                Begin
                  SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
                  _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
                  if _pos <> -1 then
                  Begin
                    SysKB.Close;
                    Result:=version;
                    Exit;
                  End;
                End;
              End
              else if (version = 2006) or (version = 2007) then
              Begin
                idx := SysKB.GetProcIdx(moduleID, 'GetObjectClass');
                if idx <> -1 then
                Begin
                  SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
                  _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
                  if _pos <> -1 then
                  Begin
                    SysKB.Close;
                    Result:=version;
                    Exit;
                  End;
                End;
              End
              else if (version = 2009) or (version = 2010) then
              Begin
                //Ищем индекс функции '@Halt0' в данном модуле
                idx := SysKB.GetProcIdx(moduleID, '@Halt0');
                if idx <> -1 then
                Begin
                  SysKB.GetProcInfo(SysKB.ProcOffsets[idx].NamId, INFO_DUMP, pInfo);
                  _pos := SysKB.ScanCode(Code, FlagList, CodeSize, @pInfo);
                  if _pos <> -1 then
                  Begin
                    SysKB.Close;
                    Result:=version;
                    Exit;
                  End;
                End;
              End
              else
              Begin
                SysKB.Close;
                Result:=version;
                Exit;
              End;
            End;
          End;
        End;
        SysKB.Close;
      End;
    Finally
      sysKB.Free;
    end;
  End;
  //Analyze VMTs (if exists)
  version := -1;
  n:=0;
  while n < CodeSize do
  Begin
    vmtAdr := PInteger(Code + n)^;  //Points to vmt0 (VmtSelfPtr)
    //VmtSelfPtr
    if IsValidCodeAdr(vmtAdr) then
    Begin
      if Pos2Adr(n) = vmtAdr - $34 then
      Begin
        //VmtInitTable
        adr := PInteger(Code + n + 4)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtTypeInfo
        adr := PInteger(Code + n + 8)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtFieldTable
        adr := PInteger(Code + n + 12)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtMethodTable
        adr := PInteger(Code + n + 16)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtDynamicTable
        adr := PInteger(Code + n + 20)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtClassName
        adr := PInteger(Code + n + 24)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtInstanceSize
        adr := PInteger(Code + n + 28)^;
        if (adr=0) or IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        version := Pos2Adr(n) - vmtAdr;
        break;
      End
      else if (Pos2Adr(n) = vmtAdr - $40) or (Pos2Adr(n) = vmtAdr - $4C) or (Pos2Adr(n) = vmtAdr - $58) then
      Begin
        //VmtIntfTable
        adr := PInteger(Code + n + 4)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtAutoTable
        adr := PInteger(Code + n + 8)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtInitTable
        adr := PInteger(Code + n + 12)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtTypeInfo
        adr := PInteger(Code + n + 16)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtFieldTable
        adr := PInteger(Code + n + 20)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtMethodTable
        adr := PInteger(Code + n + 24)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtDynamicTable
        adr := PInteger(Code + n + 28)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtClassName
        adr := PInteger(Code + n + 32)^;
        if (adr<>0) and not IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        //VmtInstanceSize
        adr := PInteger(Code + n + 36)^;
        if (adr=0) or IsValidCodeAdr(adr) then
        begin
          Inc(n,4);
          continue;
        end;
        version := Pos2Adr(n) - vmtAdr;
        break;
      End;
    End;
    Inc(n,4);
  End;
  if version = -$34 then
  begin
    Result:=2;
    Exit;
  end
  else if version = -$40 then
  begin
    Result:=3;
    Exit;
  end
  else if version = -$58 then
  begin
    Result:=2009;
    Exit;
  end;
  (*
  //Check that system is in external rtl
  num := PInteger(Code + unitsTab - 8)^;
  n:=0;
  while n < num do 
  Begin
    iniAdr := PInteger(Code + unitsTab)^;
    if (iniAdr<>0) and IsValidImageAdr(iniAdr) and IsFlagSet(cfImport, Adr2Pos(iniAdr)) then
    Begin
      recN := GetInfoRec(iniAdr);
      _pos := Pos('.',recN.name);
      if (_pos<>0) and SameText(Copy(recN.name,_pos + 1, 22), '@System@Initialization') then
      Begin
        _name := Copy(recN.name,1, _pos - 1);
        if SameText(_name, 'rtl120') then
        begin
          Result:=2009;
          Exit;
        end;
      End;
    End;
    finAdr := PInteger(Code + unitsTab + 4)^;
    if (finAdr<>0) and IsValidImageAdr(finAdr) and IsFlagSet(cfImport, Adr2Pos(finAdr)) then
    Begin
      recN := GetInfoRec(finAdr);
      _pos := Pos('.',recN.name);
      if _pos<>0 then _name := Copy(recN.name,1, _pos - 1);
    End;
    Inc(n);
    Inc(unitsTab, 8);
  End;
  *)

  //as
  //try to find the Delphi version based on imported delphi bpls.... (if any)
  for n := 0 to ImpModuleList.Count-1 do
  Begin
    if LowerCase(Copy(ImpModuleList[n],1,3)) = 'rtl' then
      rtlBpl := LowerCase(ImpModuleList[n])
    else if LowerCase(Copy(ImpModuleList[n],1,3)) = 'vcl' then
      vclBpl := LowerCase(ImpModuleList[n]);
    if (rtlBpl <> '') and (vclBpl <> '') then break;
  End;

  // or (or) is here because Delphi3 and 4 do not have rtl...
  if (rtlBpl <> '') or (vclBpl <> '') then
    for n := Low(delphiBplVer) to High(delphiBplVer) do
    Begin
      rtlBplName := delphiBplVer[n].rtl_ver;
      vclBplName := delphiBplVer[n].vcl_ver;
      if vclBplName <> vclBpl then continue;

      //if we found something - lets continue the analysis
      //here we have two cases
      // (i) bpl are near the input Delphi target or
      // (ii) it was installed into system dir...(or any dir in %PATH% !)

      srcPath := ExtractFilePath(SourceFile);
      if rtlBplName='' then rtlFile := rtlBplName else rtlFile:=srcPath+rtlBplName;
      vclFile := srcPath+vclBplName;

      if not FileExists(vclFile) then
      Begin
        //we'll not look into windows\system32 only...
        //instead we leave path as no path. system will scan for us
        //in all the %PATH% directories (when doing LoadLibrary)!
        rtlFile := rtlBplName;
        vclFile := vclBplName;
      End;

      //check the export of bpl - it must have 2 predefined functions
      if not (((rtlFile = '') or IsBplByExport(rtlFile)) and IsBplByExport(vclFile)) then
      Begin
        ShowMessage('Input file imports Delphi system packages ('
          + rtlFile + ', ' + vclFile + ').'
          + '\r\nIn order to figure out the version, please put those packages in the same folder');
        break;
      End;

      rtlBplVersion := GetModuleVersion(rtlFile);
      vclBplVersion := GetModuleVersion(vclFile);
      //hack for D3 and 4
      if rtlBplVersion = '' then rtlBplVersion := vclBplVersion;
      if (rtlBplVersion = vclBplVersion) and (rtlBplVersion = delphiBplVer[n].ver_str) then
      begin
        Result:=delphiBplVer[n].idr_ver;
        Exit;
      end;
    End;
  if version = -$4C then result:=1;
  //here we failed to find the version.....sorry
end;

Procedure TFMain.InitSysProcs;
var
  n,Idx, _pos:Integer;
  pInfo:MProcInfo;
  recN:InfoRec;
  moduleID:Word;
Begin
  SysProcsNum := 0;
  moduleID := KBase.GetModuleID('System');
  for n := Low(SysProcs) to High(SysProcs) do
  Begin
    Idx := KBase.GetProcIdx(moduleID, PAnsiChar(SysProcs[n].name));
    if Idx <> -1 then
    Begin
      Idx := KBase.ProcOffsets[Idx].NamId;
      if not KBase.IsUsedProc(Idx) then
      Begin
        KBase.GetProcInfo(Idx, INFO_DUMP, pInfo);
        if SysProcs[n].impAdr<>0 then
          StrapProc(Adr2Pos(SysProcs[n].impAdr), Idx, @pInfo, false, 6)
        else
        Begin
          _pos := KBase.ScanCode(Code, FlagList, CodeSize, @pInfo);
          if _pos <> -1 then
          Begin
            recN := InfoRec.Create(_pos, ikRefine);
            recN.Name:=SysProcs[n].name;
            StrapProc(_pos, Idx, @pInfo, true, pInfo.DumpSz);
          End;
        End;
      End;
    End;
    Inc(SysProcsNum);
  End;
  moduleID := KBase.GetModuleID('SysInit');
  for n := Low(SysInitProcs) to High(SysInitProcs) do
  Begin
    Idx := KBase.GetProcIdx(moduleID, PAnsiChar(SysInitProcs[n].name));
    if Idx <> -1 then
    Begin
      Idx := KBase.ProcOffsets[Idx].NamId;
      if not KBase.IsUsedProc(Idx) then
      Begin
        KBase.GetProcInfo(Idx, INFO_DUMP, pInfo);
        if SysInitProcs[n].impAdr<>0 then
          StrapProc(Adr2Pos(SysInitProcs[n].impAdr), Idx, @pInfo, false, 6);
        _pos := KBase.ScanCode(Code, FlagList, CodeSize, @pInfo);
        if _pos <> -1 then
        Begin
          recN := InfoRec.Create(_pos, ikRefine);
          recN.Name:=SysInitProcs[n].name;
          StrapProc(_pos, Idx, @pInfo, true, pInfo.DumpSz);
          if n = 1 then SourceIsLibrary := true;
        End;
      End;
    End;
    Inc(SysProcsNum);
  End;
end;

Procedure TFMain.SetVmtConsts (version:Integer);
Begin
  case version of
    2:
      begin
        VmtSelfPtr			 := -$34;     //??? (:=0???)
        VmtInitTable		 := -$30;
        VmtTypeInfo			 := -$2C;
        VmtFieldTable		 := -$28;
        VmtMethodTable	 := -$24;
        VmtDynamicTable	 := -$20;
        VmtClassName		 := -$1C;
        VmtInstanceSize	 := -$18;
        VmtParent		     := -$14;
        VmtDefaultHandler:= -$10;
        VmtNewInstance	 := -$C;
        VmtFreeInstance	 := -8;
        VmtDestroy			 := -4;
      end;
    3:
      begin
        VmtSelfPtr			 := -$40;
        VmtIntfTable		 := -$3C;
        VmtAutoTable		 := -$38;
        VmtInitTable		 := -$34;
        VmtTypeInfo			 := -$30;
        VmtFieldTable		 := -$2C;
        VmtMethodTable	 := -$28;
        VmtDynamicTable	 := -$24;
        VmtClassName		 := -$20;
        VmtInstanceSize	 := -$1C;
        VmtParent			   := -$18;
        VmtSafeCallException := -$14;
        VmtDefaultHandler:= -$10;
        VmtNewInstance	 := -$C;
        VmtFreeInstance	 := -8;
        VmtDestroy			 := -4;
      end;
    4..7,2005..2007:
      begin
        VmtSelfPtr			     := -$4C;
        VmtIntfTable 		     := -$48;
        VmtAutoTable 		     := -$44;
        VmtInitTable 		     := -$40;
        VmtTypeInfo 		     := -$3C;
        VmtFieldTable 		   := -$38;
        VmtMethodTable 		   := -$34;
        VmtDynamicTable 	   := -$30;
        VmtClassName 		     := -$2C;
        VmtInstanceSize 	   := -$28;
        VmtParent 			     := -$24;
        VmtSafeCallException := -$20;
        VmtAfterConstruction := -$1C;
        VmtBeforeDestruction := -$18;
        VmtDispatch 		     := -$14;
        VmtDefaultHandler 	 := -$10;
        VmtNewInstance 		   := -$C;
        VmtFreeInstance 	   := -8;
        VmtDestroy 			     := -4;
      end;
    2009,2010:
      begin
        VmtSelfPtr           := -$58;
        VmtIntfTable         := -$54;
        VmtAutoTable         := -$50;
        VmtInitTable         := -$4C;
        VmtTypeInfo          := -$48;
        VmtFieldTable        := -$44;
        VmtMethodTable       := -$40;
        VmtDynamicTable      := -$3C;
        VmtClassName         := -$38;
        VmtInstanceSize      := -$34;
        VmtParent            := -$30;
        VmtEquals            := -$2C;
        VmtGetHashCode       := -$28;
        VmtToString          := -$24;
        VmtSafeCallException := -$20;
        VmtAfterConstruction := -$1C;
        VmtBeforeDestruction := -$18;
        VmtDispatch          := -$14;
        VmtDefaultHandler    := -$10;
        VmtNewInstance       := -$C;
        VmtFreeInstance      := -8;
        VmtDestroy           := -4;
      end;
    2011..2014:
      begin
        VmtSelfPtr           := -$58;
        VmtIntfTable         := -$54;
        VmtAutoTable         := -$50;
        VmtInitTable         := -$4C;
        VmtTypeInfo          := -$48;
        VmtFieldTable        := -$44;
        VmtMethodTable       := -$40;
        VmtDynamicTable      := -$3C;
        VmtClassName         := -$38;
        VmtInstanceSize      := -$34;
        VmtParent            := -$30;
        VmtEquals            := -$2C;
        VmtGetHashCode       := -$28;
        VmtToString          := -$24;
        VmtSafeCallException := -$20;
        VmtAfterConstruction := -$1C;
        VmtBeforeDestruction := -$18;
        VmtDispatch          := -$14;
        VmtDefaultHandler    := -$10;
        VmtNewInstance       := -$C;
        VmtFreeInstance      := -8;
        VmtDestroy           := -4;
        //VmtQueryInterface    := 0;
        //VmtAddRef            := 4;
        //VmtRelease           := 8;
        //VmtCreateObject      := $C;
      end;
  end;
end;

Function TFMain.IsUnitExist (_Name:AnsiString):Boolean;
var
  n:Integer;
  recU:PUnitRec;
Begin
  Result:=False;
  for n := 0 To UnitsNum-1 do
  begin
    recU := Units[n];
    if recU.names.IndexOf(_Name) <> -1 Then
    Begin
      Result:=true;
      Exit;
    End;
  end;
end;

Function TFMain.GetUnit (Adr:Integer):PUnitRec;
Var
  n:Integer;
  recU:PUnitRec;
Begin
  CrtSection.Enter;
  Result:=Nil;
  for n := 0 to UnitsNum-1 do
  begin
    recU := Units[n];
    if (Adr >= recU.fromAdr) and (Adr < recU.toAdr) then Result:= recU;
  End;
  CrtSection.Leave;
end;

Function TFMain.GetUnitName (recU:PUnitRec):AnsiString;
Begin
  if Assigned(recU) then
  begin
    if recU.names.Count = 1 then
      Result:= recU.names[0]
    else
      Result:= '_Unit' + IntToStr(recU.iniOrder);
  end
  else Result:='';
end;

Function TFMain.GetUnitName(Adr:Integer):AnsiString;
Begin
  Result:= GetUnitName(GetUnit(Adr));
end;

Procedure TFMain.SetUnitName (recU:PUnitRec; _name:AnsiString);
Begin
  if Assigned(recU) and (recU.names.IndexOf(_name) = -1) then
    recU.names.Add(_name);
end;

Function TFMain.InOneUnit (Adr1, Adr2:Integer):Boolean;
var
  n:Integer;
  recU:PUnitRec;
Begin
  Result:=False;
  for n := 0 to UnitsNum-1 do
  begin
    recU := Units[n];
    if (Adr1 >= recU.fromAdr) and (Adr1 < recU.toAdr) and
      (Adr2 >= recU.fromAdr) and (Adr2 < recU.toAdr) Then
    Begin
      Result:=true;
      Exit;
    end;
  End;
end;

Function TFMain.GetSegmentNo (Adr:Integer):Integer;
var
  n:Integer;
  segInfo:PSegmentInfo;
Begin
  Result:=-1;
  for n := 0 to SegmentList.Count-1 do
  begin
    segInfo := SegmentList[n];
    if (segInfo.Start <= Adr) and (Adr < segInfo.Start + segInfo.Size) Then
    Begin
      Result:=n;
      Exit;
    end;
  End;
end;

Function FollowInstructions(fromAdr,toAdr:Integer):Integer;
var
  instrLen,fromPos,curPos,curAdr:Integer;
  DisInfo:TDisInfo;
Begin
  fromPos:=Adr2Pos(fromAdr);
  curPos:=fromPos;
  curAdr:=fromAdr;
  while true do
  begin
    if curAdr >= toAdr then break;
    if IsFlagSet(cfInstruction, curPos) then break;
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    if instrLen=0 then break;
    SetFlag(cfInstruction, curPos);
  end;
  Result:=curAdr;
end;

Function TFMain.EstimateProcSize (fromAdr:Integer):Integer;
var
  op,b1,b2:BYTE;
  cTblAdr,jTblAdr,CNum,NPos,k,delta:Integer;
  row, num, instrLen, instrLen1, instrLen2, _Pos, outRows:Integer;
  fromPos,curPos,curAdr,lastAdr, Adr, Adr1, lastMovAdr:Integer;
  recN:InfoRec;
  DisInfo:TDisInfo;
  CTab:Array[0..255] of Byte;
Begin
  fromPos:=Adr2Pos(fromAdr);
  curPos:=fromPos;
  curAdr:=fromAdr;
  lastAdr:=0;
  lastMovAdr:=0;
  outRows := MAX_DISASSEMBLE;
  if IsFlagSet(cfImport, fromPos) then outRows := 1;
  for row := 0 to outRows-1 do
  Begin
    //Exception table
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      Inc(curPos, 4 + 8*num);
      Inc(curAdr, 4 + 8*num);
      continue;
    End;

    b1 := Ord(Code[curPos]);
    b2 := Ord(Code[curPos + 1]);
    if (b1=0) and (b2=0) and (lastAdr=0) then break;
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) break;
    if instrLen=0 then
    Begin
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    //Code
    SetFlags(cfCode, curPos, instrLen);
    //Instruction begin
    SetFlag(cfInstruction, curPos);
    op := frmDisasm.GetOp(DisInfo.Mnem);
    if curAdr >= lastAdr then lastAdr := 0;
    if op = OP_JMP then
    Begin
      if curAdr = fromAdr then
      Begin
        Inc(curAdr, instrLen);
        break;
      End
      else if DisInfo.OpType[0] = otMEM then
      Begin
        if (Adr2Pos(DisInfo.Offset) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then
        Begin
          Inc(curAdr, instrLen);
          break;
        End;
      End;
      if DisInfo.OpType[0] = otIMM then
      Begin
        Adr := DisInfo.Immediate;
        if (Adr2Pos(Adr) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then
        Begin
          Inc(curAdr, instrLen);
          break;
        End
        else if (GetSegmentNo(Adr) <> 0) and (GetSegmentNo(fromAdr) <> GetSegmentNo(Adr)) 
          and ((lastAdr=0) or (curAdr = lastAdr)) then
        Begin
          Inc(curAdr, instrLen);
          break;
        End
        else if (Adr < fromAdr) and ((lastAdr=0) or (curAdr = lastAdr)) then
        Begin
          Inc(curAdr, instrLen);
          break;
        End;
      End;
    End;
    //End of procedure
    if DisInfo.Ret and ((lastAdr=0) or (curAdr = lastAdr)) then
    Begin
      Inc(curAdr, instrLen);
      break;
    End;
    if op = OP_MOV then lastMovAdr := DisInfo.Offset;

    if (b1 = 255) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) 
      and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      if not IsValidCodeAdr(DisInfo.Offset) then
      Begin
      	Inc(curAdr, instrLen);
        break;
      End;
      cTblAdr := 0;
      jTblAdr := 0;
      _Pos := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Адрес таблицы - последние 4 байта инструкции
      jTblAdr := PInteger(Code + _Pos - 4)^;
      //Анализируем промежуток на предмет таблицы cTbl
      if (Adr <= lastMovAdr) and (lastMovAdr < jTblAdr) then cTblAdr := lastMovAdr;
      //Если есть cTblAdr, пропускаем эту таблицу
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        Inc(_Pos, CNum);
        Inc(Adr, CNum);
      End;
      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, _Pos) then break;
        Adr1 := PInteger(Code + _Pos)^;
        //Validate Adr1
        if not IsValidImageAdr(Adr1) or (Adr1 < fromAdr) then break;
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        Inc(_Pos, 4); 
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := _Pos;
      curAdr := Adr;
      continue;
    End;
    if b1 = $68 then //try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //check that next instruction is push fs:[reg] or retn
      if (
        (Code[NPos] = #$64) and
        (Code[NPos + 1] = #$FF) and
        (((Code[NPos + 2] >= #$30) and (Code[NPos + 2] <= #$37)) or (Code[NPos + 2] = #$75))
        ) or (Code[NPos] = #$C3) then
      Begin
        Adr := DisInfo.Immediate;      //Adr:=@1
        if IsValidCodeAdr(Adr) then
        Begin
          if Adr > lastAdr then lastAdr := Adr;
          _Pos := Adr2Pos(Adr); 
          assert(_Pos >= 0);
          delta := _Pos - NPos;
          if delta >= 0 then // and delta < outRows)
          Begin
            if Code[_Pos] = #$E9 then //jmp Handle...
            Begin
              //Disassemble jmp
              instrLen1 := frmDisasm.Disassemble(Code + _Pos, Adr, @DisInfo, Nil);
              //if (!instrLen1) return Size;
              recN := GetInfoRec(DisInfo.Immediate);
              if Assigned(recN) then
                if recN.SameName('@HandleFinally') then
                Begin
                  //jmp HandleFinally
                  Inc(_Pos, instrLen1); 
                  Inc(Adr, instrLen1);
                  //jmp @2
                  instrLen2 := frmDisasm.Disassemble(Code + _Pos, Adr, @DisInfo, Nil);
                  Inc(Adr,instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                  {
                  //@2
                  Adr1 := DisInfo.Immediate - 4;
                  Adr := PInteger(Code + Adr2Pos(Adr1))^;
                  if Adr > lastAdr then lastAdr := Adr;
                  }
                End
                else if recN.SameName('@HandleAnyException') or recN.SameName('@HandleAutoException') then
                Begin
                  //jmp HandleAnyException
                  Inc(_Pos, instrLen1); 
                  Inc(Adr, instrLen1);
                  //call DoneExcept
                  instrLen2 := frmDisasm.Disassemble(Code + _Pos, Adr, Nil, Nil);
                  Inc(Adr, instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                End
                else if recN.SameName('@HandleOnException') then
                Begin
                  //jmp HandleOnException
                  Inc(_Pos, instrLen1); 
                  Inc(Adr, instrLen1);
                  //Set cfETable to output data correctly
                  SetFlag(cfETable, _Pos);
                  //dd num
                  num := PInteger(Code + _Pos)^; 
                  Inc(_Pos, 4);
                  if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                  for k := 0 to num-1 do
                  Begin
                    //dd offset ExceptionInfo
                    Inc(_Pos, 4);
                    //dd offset ExceptionProc
                    Inc(_Pos, 4);
                  End;
                End;
            End;
          End;
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
      End;
    End;
    if (b1 = $EB) or				 //short relative abs jmp or cond jmp
    	((b1 >= $70) and (b1 <= $7F)) or
      ((b1 = 15) and (b2 >= $80) and (b2 <= $8F)) then
    Begin
      Adr := DisInfo.Immediate;
      if IsValidImageAdr(Adr) then
      Begin
        SetFlag(cfLoc, Adr2Pos(Adr));
        if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if b1 = $E9 then    //relative abs jmp or cond jmp
    Begin
      Adr := DisInfo.Immediate;
      if IsValidImageAdr(Adr) then
      Begin
        SetFlag(cfLoc, Adr2Pos(Adr));
        recN := GetInfoRec(Adr);
        if not Assigned(recN) and (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if DisInfo.Call then
    Begin
      Adr := DisInfo.Immediate; 
      _Pos := Adr2Pos(Adr);
      if IsValidImageAdr(Adr) then
      Begin
        if _Pos >= 0 then
        Begin
          SetFlag(cfLoc, _Pos);
          recN := GetInfoRec(Adr);
          if Assigned(recN) and recN.SameName('@Halt0') then
            if (fromAdr = EP) and (lastAdr=0) then break;
        End;
        {
        //Call is inside procedure (may be embedded or filled by data)
        if (lastAdr<>0) and (Adr > fromAdr) and (Adr <= lastAdr) then
          if not IsFlagSet(cfInstruction, _Pos) then
          Begin
            curAdr := Adr;
            curPos := Pos;
          End;
          else
          Begin
            Inc(curPos, instrLen);
            Inc(curAdr, instrLen);
          End;
        }
      End;
    End;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
  Result:= curAdr - fromAdr;
end;

Function TFMain.GetUnits2 (dprName:AnsiString):Integer;   // For Delphi2 (other structure!);
var
  instrLen, iniProcSize, _pos, num, start, n:Integer;
  iniAdres,curAdr,curPos,no:Integer;
  recU:PUnitRec;
  recN:InfoRec;
  DisInfo:TDisInfo;
Begin
  curAdr:=EP;
  curPos:=Adr2Pos(curAdr);
  //Ищем первую инструкцию call := @InitExe
  n := 0;
  while true do
  Begin
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) return num;
    if instrLen=0 then
    Begin
      Inc(curPos);
      Inc(curAdr);
      continue;
    End;
    if DisInfo.Call then Inc(n);
    if n = 2 then break;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
  //Читаем список вызовов (процедуры инициализации)
  no := 1;
  num:=0;
  while true do
  Begin
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) return num;
    if instrLen=0 then
    Begin
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    if not DisInfo.Call then break;
    iniAdres := DisInfo.Immediate;
    iniProcSize := EstimateProcSize(iniAdres);

    New(recU);
    with recU^ do
    begin
      trivial := false;
      trivialIni := false;
      trivialFin := true;
      kb := false;
      names := TStringList.Create;
  
      fromAdr := 0;
      toAdr := 0;
      matchedPercent := 0.0;
      iniOrder := no;
      Inc(no);

      toAdr := (iniAdres + iniProcSize + 3) and $FFFFFFFC;

      finadr := 0;
      finSize := 0;
      iniAdr := iniAdres;
      iniSize := iniProcSize;
    end;

    _pos := Adr2Pos(iniAdres);
    SetFlag(cfProcStart, _pos);
    recN := GetInfoRec(iniAdres);
    if not Assigned(recN) then recN := InfoRec.Create(_pos, ikProc);
    recN.procInfo.procSize := iniProcSize;

    Units.Add(recU);
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
    Inc(num);
  End;
  start := Integer(CodeBase);
  num := Units.Count;
  for n:= 0 to num-1 do
  Begin
  	recU := Units[n];
    recU.fromAdr := start;
    start := recU.toAdr;
    //Last Unit has program name
    if n = num - 1 then
    Begin
      recU.toAdr := Integer(CodeBase) + CodeSize;
      SetUnitName(recU, dprName);
    End;
  End;
  Result:=num;
end;

Function TFMain.IsExtendedInitTab (Var unitsTab:Integer):Boolean;
var
  i, num, _pos, n:Integer;
  initTable, iniAdr, finAdr:Integer;
Begin
  unitsTab := 0;
  i:=0;
  while i < ((TotalSize - 4) and (-4)) do
  Begin
    initTable := PInteger(Image + i)^;
    if initTable = Integer(CodeBase) + i + 4 then
    Begin
      num := PInteger(Image + i - 4)^;
      if (num <= 0) or (num > 10000) then
      begin
        Inc(i,4);
        continue;
      end;
      unitsTab := i + 4;
    	_pos := unitsTab;
      for n := 0 to num-1 do 
      Begin
        iniAdr := PInteger(Image + _pos)^;
        if iniAdr<>0 then
          if not IsValidImageAdr(iniAdr) then
          Begin
            unitsTab := 0;
            break;
          End;
        finAdr := PInteger(Image + _pos + 4)^;
        if finAdr<>0 then
          if not IsValidImageAdr(finAdr) then
          Begin
            unitsTab := 0;
            break;
          End;
        Inc(_pos, 8);
      End;
      if unitsTab<>0 then break;
    End;
    Inc(i, 4);
  End;
  if unitsTab<>0 then
  begin
    Result:=false;
    Exit;
  End;
  //May be D2010
  unitsTab := 0;
  i:=0;
  while i < ((TotalSize - 20) and (-4)) do 
  Begin
    initTable := PInteger(Image + i)^;
    if initTable = Integer(CodeBase) + i + 20 then
    Begin
      num := PInteger(Image + i - 4)^;
      if (num <= 0) or (num > 10000) then
      begin
        Inc(i,4);
        continue;
      end;
      unitsTab := i + 20;
  	  _pos := unitsTab;
      for n := 0 to num-1 do
      Begin
        iniAdr := PInteger(Image + _pos)^;
        if iniAdr<>0 then
          if not IsValidImageAdr(iniAdr) then
          Begin
            unitsTab := 0;
            break;
          End;
        finAdr := PInteger(Image + _pos + 4)^;
        if finAdr<>0 then
          if not IsValidImageAdr(finAdr) then
          Begin
            unitsTab := 0;
            break;
          End;
        Inc(_pos, 8);
      End;
      if unitsTab<>0 then break;
    End;
    Inc(i, 4);
  End;
  if unitsTab<>0 then
  Begin
    Result:=true;
    Exit;
  end;
  Result:=false;
end;

Function TFMain.EvaluateInitTable (Data:PAnsiChar; Size, Base:Integer):Integer;
var
  i, num, _pos, unitsPos, n:Integer;
  initTable, iniAdr, finAdr, maxAdr,res:Integer;
Begin
  unitsPos:=0;
  maxAdr:=0;
  res:=0;
  initTable:=0;
  i:=0;
  while i < ((Size - 4) and (-4)) do
  Begin
    res := PInteger(Data + i)^;
    initTable := res;
    if initTable = Base + i + 4 then
    Begin
      num := PInteger(Data + i - 4)^;
      if (num <= 0) or (num > 10000) then
      begin
        Inc(i,4);
        continue;
      end;
      unitsPos := i + 4;
    	_pos := unitsPos;
      for n := 0 to num-1 do
      Begin
        iniAdr := PInteger(Data + _pos)^;
        if iniAdr<>0 then
        Begin
          if (iniAdr < Base) or (iniAdr >= Base + Size) then //!IsValidImageAdr(iniAdr))
          Begin
            unitsPos := 0;
            break;
          End
          else if iniAdr > maxAdr then maxAdr := iniAdr;
        End;
        finAdr := PInteger(Data + _pos + 4)^;
        if finAdr<>0 then
          if (finAdr < Base) or (finAdr >= Base + Size) then //!IsValidImageAdr(finAdr))
          Begin
            unitsPos := 0;
            break;
          End
          else if finAdr > maxAdr then maxAdr := finAdr;
        Inc(res, 8);
        Inc(_pos, 8);
      End;
      if unitsPos<>0 then break;
    End;
    Inc(i, 4);
  End;
  if maxAdr > res then res := (maxAdr + 3) and (-4);
  if unitsPos<>0 then
  begin
    Result:=initTable - 8;
    Exit;
  end;

  //May be D2010
  maxAdr := 0;
  i:=0;
  while i < ((Size - 20) and (-4)) do 
  Begin
    res := PInteger(Data + i)^;
    initTable := res;
    if initTable = Base + i + 20 then
    Begin
      num := PInteger(Data + i - 4)^;
      if (num <= 0) or (num > 10000) then
      begin
        Inc(i,4);
        continue;
      end;
      unitsPos := i + 20;
    	_pos := unitsPos;
      for n := 0 to num-1 do
      Begin
        iniAdr := PInteger(Data + _pos)^;
        if iniAdr<>0 then
          if (iniAdr < Base) or (iniAdr >= Base + Size) then //!IsValidImageAdr(iniAdr))
          Begin
            unitsPos := 0;
            break;
          End
          else if iniAdr > maxAdr then
          Begin
            if PInteger(Data + Adr2Pos(iniAdr))^ <>0 then maxAdr := iniAdr;
          End;
        finAdr := PInteger(Data + _pos + 4)^;
        if finAdr<>0 then
          if (finAdr < Base) or (finAdr >= Base + Size) then //!IsValidImageAdr(finAdr))
          Begin
            unitsPos := 0;
            break;
          End
          else if finAdr > maxAdr then
          Begin
            if PInteger(Data + Adr2Pos(finAdr))^ <>0 then maxAdr := finAdr;
          End;
        Inc(res, 8);
        INC(_pos, 8);
      End;
      if unitsPos<>0 then break;
    End;
    Inc(i, 4);
  End;
  //if maxAdr > res then res := (maxAdr + 3) and (-4);
  if unitsPos<>0 then Result:= initTable - 24
    else Result:=0;
end;

Function TFMain.GetUnits (dprName:AnsiString):Integer;
var
  len:Byte;
	b,e,n, i, no, unitsPos, start, spos, _pos, iniProcSize, finProcSize, numUnits:Integer;
  typesNum, numUnit2, typesTable, unitsTable:Integer;   //For D2010
	initTable, ini_Adr, fin_Adr, unitsTabEnd, to_Adr,isize,fsize:Integer;
	recU:PUnitRec;
  recN:InfoRec;
  found:Boolean;
Begin
  unitsPos:=0;
  numUnits:=0;
  initTable:=0;
  if DelphiVersion >= 2010 then
  begin
    i:=0;
    while i < ((TotalSize - 20) and (-4)) do 
    Begin
      initTable := PInteger(Image + i)^;
      if initTable = Integer(CodeBase) + i + 20 then
      Begin
        numUnits := PInteger(Image + i - 4)^;
        if (numUnits <= 0) or (numUnits > 10000) then
        begin
          Inc(i,4);
          continue;
        end;
        unitsPos := i + 20;
        _pos := unitsPos;
        for n := 0 to numUnits-1 do 
        Begin
          ini_Adr := PInteger(Image + _pos)^;
          if (ini_Adr<>0) and not IsValidImageAdr(ini_Adr) then
          Begin
            unitsPos := 0;
            break;
          End;
          fin_Adr := PInteger(Image + _pos + 4)^;
          if (fin_Adr<>0) and not IsValidImageAdr(fin_Adr) then
          Begin
            unitsPos := 0;
            break;
          End;
          Inc(_pos, 8);
        End;
        if unitsPos<>0 then break;
      End;
    End;
    Inc(i, 4);
  end
  else
  Begin
    i:=0;
    while i < ((CodeSize - 4) and (-4)) do
    Begin
      initTable := PInteger(Image + i)^;
      if initTable = Integer(CodeBase) + i + 4 then
      Begin
        numUnits := PInteger(Image + i - 4)^;
        if (numUnits <= 0) or (numUnits > 10000) then
        begin
          Inc(i,4);
          continue;
        end;
        unitsPos := i + 4;
        _pos := unitsPos;
        for n := 0 to numUnits-1 do 
        Begin
          ini_Adr := PInteger(Image + _pos)^;
          if (ini_Adr<>0) and not IsValidImageAdr(ini_Adr) then
          Begin
            unitsPos := 0;
            break;
          End;
          fin_Adr := PInteger(Image + _pos + 4)^;
          if (fin_Adr<>0) and not IsValidImageAdr(fin_Adr) then
          Begin
            unitsPos := 0;
            break;
          End;
          Inc(_pos, 8);
        End;
        if unitsPos<>0 then break;
      End;
      Inc(i, 4);
    End;
  End;
  //if (!unitsPos) return 0;

  if unitsPos=0 then
  Begin
    numUnits := 1;
    New(recU);
    with recU^ do
    begin
      trivial := false;
      trivialIni := true;
      trivialFin := true;
      kb := false;
      names := TStringList.Create;

      fromAdr := Integer(CodeBase);
      toAdr := Integer(CodeBase) + TotalSize;
      matchedPercent := 0.0;
      iniOrder := 1;
  
      finAdr := 0;
      finSize := 0;
      iniAdr := 0;
      iniSize := 0;
    end;
    Units.Add(recU);
    Result:=numUnits;
    Exit;
  End;

  unitsTabEnd := initTable + 8 * numUnits;
  if DelphiVersion >= 2010 then
  Begin
    Dec(initTable, 24);
    SetFlags(cfData, Adr2Pos(initTable), 8*numUnits + 24);
    typesNum := PInteger(Image + Adr2Pos(initTable + 8))^;
    typesTable := PInteger(Image + Adr2Pos(initTable + 12))^;
    SetFlags(cfData, Adr2Pos(typesTable), 4*typesNum);
    numUnit2 := PInteger(Image + Adr2Pos(initTable + 16))^;
    unitsTable := PInteger(Image + Adr2Pos(initTable + 20))^;
    _pos := Adr2Pos(unitsTable);
    spos := _pos;
    for i := 0 to numUnit2-1 do
    Begin
      len := Byte(Image[_pos]);
      Inc(_pos, len + 1);
    End;
    SetFlags(cfData, Adr2Pos(unitsTable), _pos - spos);
  End
  else
  Begin
    Dec(initTable, 8);
    SetFlags(cfData, Adr2Pos(initTable), 8*numUnits + 8);
  End;
  no:=1;
  for i := 0 to numUnits-1 do 
  Begin
    ini_Adr := PInteger(Image + unitsPos)^;
    fin_Adr := PInteger(Image + unitsPos + 4)^;
    if ((ini_Adr=0) and (fin_Adr=0)) or
      ((ini_Adr<>0) and (PInteger(Image + Adr2Pos(ini_Adr))^ = 0)) or
      ((fin_Adr<>0) and (PInteger(Image + Adr2Pos(fin_Adr))^ = 0)) then
    begin
      Inc(unitsPos,8);
      Continue;
    end;

    //MAY BE REPEATED ADRESSES!!!
    found := false;
    for n := 0 to Units.Count-1 do
    Begin
      recU := Units[n];
      if (recU.iniAdr = ini_Adr) and (recU.finAdr = fin_Adr) then
      Begin
        found := true;
        break;
      End;
    End;
    if found then
    Begin
      Inc(unitsPos,8);
      continue;
    end;
    if ini_Adr<>0 then
    	iniProcSize := EstimateProcSize(ini_Adr)
    else
    	iniProcSize := 0;
    if fin_Adr<>0 then
    	finProcSize := EstimateProcSize(fin_Adr)
    else
    	finProcSize := 0;

    to_Adr := 0;
    if (ini_Adr<>0) and (ini_Adr < unitsTabEnd) then
    Begin
      if ini_Adr >= fin_Adr + finProcSize then
        to_Adr := (ini_Adr + iniProcSize + 3) and $FFFFFFFC;
      if fin_Adr >= ini_Adr + iniProcSize then
        to_Adr := (fin_Adr + finProcSize + 3) and $FFFFFFFC;
    End
    else if fin_Adr<>0 then
      to_Adr := (fin_Adr + finProcSize + 3) and $FFFFFFFC;

    if to_Adr=0 then
    Begin
      if Units.Count > 0 then
      Begin
        Inc(unitsPos,8);
        continue;
      end;
      to_Adr := Integer(CodeBase) + CodeSize;
    End;

    New(recU);
    with recU^ do
    begin
      trivial := false;
      trivialIni := true;
      trivialFin := true;
      kb := false;
      names := TStringList.Create;
  
      fromAdr := 0;
      toAdr := to_Adr;
      matchedPercent := 0.0;
      iniOrder := no;
      Inc(no);

      finAdr := fin_Adr;
      finSize := finProcSize;
      iniAdr := ini_Adr;
      iniSize := iniProcSize;
    end;

    if ini_Adr<>0 then
    Begin
      _pos := Adr2Pos(ini_Adr);
      //Check trivial initialization
    	if iniProcSize > 8 then recU.trivialIni := false;
      SetFlag(cfProcStart, _pos);
      //SetFlag(cfProcEnd, pos + iniProcSize - 1);
      recN := GetInfoRec(ini_Adr);
      if not Assigned(recN) then recN := InfoRec.Create(_pos, ikProc);
      recN.procInfo.procSize := iniProcSize;
    End;
    if fin_Adr<>0 then
    Begin
      _pos := Adr2Pos(fin_Adr);
      //Check trivial finalization
    	if finProcSize > 46 then recU.trivialFin := false;
      SetFlag(cfProcStart, _pos);
      //SetFlag(cfProcEnd, _pos + finProcSize - 1);
      recN := GetInfoRec(fin_Adr);
      if not Assigned(recN) then recN := InfoRec.Create(_pos, ikProc);
      recN.procInfo.procSize := finProcSize;
      //import?
      if IsFlagSet(cfImport, _pos) then
      Begin
        b := Pos('@',recN.Name);
        if b<>0 then
        Begin
          e := PosEx('@',recN.Name,b + 1);
          if e<>0 then SetUnitName(recU, Copy(recN.Name,b + 1, e - b - 1));
        End;
      End;
    End;
    Units.Add(recU);
    Inc(unitsPos, 8);
  End;
  Units.Sort(@SortUnitsByAdr);
  start := Integer(CodeBase);
  numUnits := Units.Count;
  for i := 0 to numUnits-1 do
  Begin
  	recU := Units[i];
    recU.fromAdr := start;
    if recU.toAdr<>0 then start := recU.toAdr;
    //Is unit trivial?
    if recU.trivialIni and recU.trivialFin then
    Begin
      isize := (recU.iniSize + 3) and $FFFFFFFC;
      fsize := (recU.finSize + 3) and $FFFFFFFC;
      if isize + fsize = recU.toAdr - recU.fromAdr then recU.trivial := true;
    End;
    //Last Unit has program name and toAdr := initTable
    if i = numUnits - 1 then
    Begin
      recU.toAdr := initTable;
      SetUnitName(recU, dprName);
    End;
  End;
  Result:=numUnits;
end;

Function TFMain.GetBCBUnits (dprName:AnsiString):Integer;
var
  n, _pos, curPos, instrLen, iniNum, finNum, no:Integer;
  adr, curAdr, modTable, iniTable, iniTableEnd, finTable, finTableEnd, from_Adr, to_Adr:Integer;
  recU:PUnitRec;
  recN:InfoRec;
  disInfo:TDisInfo;
  list:TStringList;
Begin
  //EP: jmp @1
  curAdr := EP; 
  curPos := Adr2Pos(curAdr);
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  if disInfo.Mnem = 'jmp' then
  Begin
    curAdr := disInfo.Immediate; 
    curPos := Adr2Pos(curAdr);
    while true do
    Begin
      instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
      if disInfo.Mnem = 'jmp' then break;
      if (disInfo.Mnem = 'push') and (disInfo.OpType[0] = otIMM) and (disInfo.Immediate<>0) then
      Begin
        modTable := disInfo.Immediate;
        if IsValidImageAdr(modTable) then
        Begin
          _pos := Adr2Pos(modTable);
          iniTable := PInteger(Image + _pos)^;
          iniTableEnd := PInteger(Image + _pos + 4)^;
          finTable := PInteger(Image + _pos + 8)^;
          finTableEnd := PInteger(Image + _pos + 12)^;
          n:=16;
          while n < 32 do 
          Begin
            adr := PInteger(Image + _pos + n)^;
            if IsValidImageAdr(adr) then
            Begin
              _pos := Adr2Pos(adr);
              SetFlag(cfProcStart, _pos);
              recN := GetInfoRec(adr);
              if not Assigned(recN) then recN := InfoRec.Create(_pos, ikProc);
              recN.Name:='WinMain';
              break;
            End;
            Inc(n, 4);
          End;
          iniNum := (iniTableEnd - iniTable) div 6;
          SetFlags(cfData, Adr2Pos(iniTable), iniTableEnd - iniTable);
          finNum := (finTableEnd - finTable) div 6;
          SetFlags(cfData, Adr2Pos(finTable), finTableEnd - finTable);

          list := TStringList.Create;
          try
            list.Sorted := false;
            list.Duplicates := dupIgnore;
            if iniNum > finNum then
            Begin
              _pos := Adr2Pos(iniTable);
              for n := 0 to iniNum-1 do
              Begin
                adr := PInteger(Image + _pos + 2)^;
                Inc(_pos, 6);
                list.Add(Val2Str(adr,8));
              End;
            End
            else
            Begin
              _pos := Adr2Pos(finTable);
              for n := 0 to finNum-1 do
              Begin
                adr := PInteger(Image + _pos + 2)^;
                Inc(_pos, 6);
                list.Add(Val2Str(adr,8));
              End;
            End;
            list.Sort;
            from_Adr := Integer(CodeBase);
            no := 1;
            for n := 0 to list.Count-1 do
            Begin
              New(recU);
              with recU^ do
              begin
                trivial := false;
                trivialIni := true;
                trivialFin := true;
                kb := false;
                names := TStringList.Create;

                matchedPercent := 0.0;
                iniOrder := no;
                Inc(no);

                to_Adr := StrToInt('$' + list[n]);
                finadr := 0;
                finSize := 0;
                iniadr := to_Adr;
                iniSize := 0;

                fromAdr := from_Adr;
                toAdr := to_Adr;
              end;
              Units.Add(recU);

              from_Adr := to_Adr;
              if n = list.Count - 1 then SetUnitName(recU, dprName);
            End;
          finally
            list.Free;
          end;
          Units.Sort(@SortUnitsByAdr);
          Result:=Units.Count;
          Exit;
        End;
      End;
      Inc(curAdr, instrLen);
      Inc(curPos, instrLen);
    End;
  End;
  Result:=0;
end;

//-1 - not Code
//0 - possible Code
//1 - Code
Function TFMain.IsValidCode (fromAdr:Integer):Integer;
var
  b1,b2,op:BYTE;
  firstPushReg, lastPopReg,CNum,delta:Integer;
  firstPushPos, lastPopPos,NPos:Integer;
  row, num, instrLen, instrLen1, instrLen2:Integer;
  fromPos, curPos,outRows,k,cTblAdr,jTblAdr:Integer;
  curAdr, lastAdr, Adr, Adr1, _Pos, lastMovAdr:Integer;
  recN:InfoRec;
  DisInfo:TDisInfo;
  CTab:Array[0..255] of Byte;
Begin
  lastAdr:=0;
  lastMovAdr:=0;
  fromPos := Adr2Pos(fromAdr);
  if (fromPos < 0) or (fromAdr > EP) or (AnsiStrComp(Code + fromPos, 'DISPLAY')=0) then
  begin
    Result:= -1;
    Exit;
  end;

  //recN := GetInfoRec(fromAdr);
  outRows := MAX_DISASSEMBLE;
  if IsFlagSet(cfImport, fromPos) then outRows := 1;
  lastPopReg := -1;
  firstPushReg := -1;
  lastPopPos := -1;
  firstPushPos := -1;
  curPos := fromPos;
  curAdr := fromAdr;

  for row := 0 to outRows-1 do
  Begin
    //Таблица exception
    if not IsValidImageAdr(curAdr) then
    begin
      Result:= -1;
      Exit;
    end;
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      Inc(curPos, 4 + 8*num);
      Inc(curAdr, 4 + 8*num);
      continue;
    End;
    b1 := Byte(Code[curPos]);
    b2 := Byte(Code[curPos + 1]);
    //00,00 - Data!
    if (b1=0) and (b2=0) and (lastAdr=0) then
    begin
      Result:= -1;
      Exit;
    end;
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) return -1;
    if instrLen=0 then // ????????
    Begin
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    if (DisInfo.Mnem = 'arpl') or
      (DisInfo.Mnem = 'out')  or
      (DisInfo.Mnem = 'in') then
    Begin
      Result:= -1;
      Exit;
    End;
    op := frmDisasm.GetOp(DisInfo.Mnem);
    if op = OP_JMP then
    Begin
      if curAdr = fromAdr then break;
      if DisInfo.OpType[0] = otMEM then
      Begin
        if (Adr2Pos(DisInfo.Offset) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
      End
      else if DisInfo.OpType[0] = otIMM then
      Begin
        Adr := DisInfo.Immediate; 
        _Pos := Adr2Pos(Adr);
        if (_Pos < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        if (GetSegmentNo(Adr) <> 0) and (GetSegmentNo(fromAdr) <> GetSegmentNo(Adr))
          and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        if (Adr < fromAdr) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        curAdr := Adr; 
        curPos := _Pos;
        continue;
      End;
    End
    //Mark push or pop
    else if op = OP_PUSH then
    Begin
      //Если первая инструкция не push reg
      if (row=0) and (DisInfo.OpType[0] <> otREG) then
      begin
        Result:= -1;
        Exit;
      end
      else if (DisInfo.OpType[0] = otREG) and (firstPushReg = -1) then
      Begin
        firstPushReg := DisInfo.OpRegIdx[0];
        firstPushPos := curPos;
      End;
    End
    else if op = OP_POP then
    Begin
      if DisInfo.OpType[0] = otREG then
      Begin
        lastPopReg := DisInfo.OpRegIdx[0];
        lastPopPos := curPos;
      End;
    End;

    //Отбраковка по первой инструкции
    if row=0 then
    Begin
      //Инструкция перехода или ret c аргументами
      if (DisInfo.Ret and (DisInfo.OpNum >= 1)) or DisInfo.Branch then
      begin
        Result:= -1;
        Exit;
      end;
      if (DisInfo.Mnem = 'bound') or
        (DisInfo.Mnem = 'retf') or
        (DisInfo.Mnem = 'pop') or
        (DisInfo.Mnem = 'aaa') or
        (DisInfo.Mnem = 'adc') or
        (DisInfo.Mnem = 'sbb') or
        (DisInfo.Mnem = 'rcl') or
        (DisInfo.Mnem = 'rcr') or
        (DisInfo.Mnem = 'clc') or
        (DisInfo.Mnem = 'stc') then
      begin
        Result:= -1;
        Exit;
      end;
    End;
    //Если в позиции встретился уже определенный ранее код, выходим
    for k := 0 to instrLen-1 do
      if IsFlagSet(cfProcStart, curPos + k) or IsFlagSet(cfCode, curPos + k) then
      begin
        Result:= -1;
        Exit;
      end;

    if curAdr >= lastAdr then lastAdr := 0;
    //Конец процедуры
    if DisInfo.Ret and ((lastAdr=0) or (curAdr = lastAdr)) then
    Begin
      //Standard frame
      if (Code[fromPos] = #$55) and (Code[fromPos + 1] = #$8B) and (Code[fromPos + 2] = #$EC) then break;
      if (firstPushReg = lastPopReg) and (firstPushPos = fromPos) and (lastPopPos = curPos - 1) then break;
      Result:= 0;
      Exit;
    End;
    if op = OP_MOV then lastMovAdr := DisInfo.Offset;
    if (b1 = $FF) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      if not IsValidCodeAdr(DisInfo.Offset) then break;
      {
      //Первая инструкция
      if curAdr = fromAdr then break;
      }
      cTblAdr := 0;
      jTblAdr := 0;
      _Pos := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Адрес таблицы - последние 4 байта инструкции
      jTblAdr := PInteger(Code + _Pos - 4)^;
      //Анализируем промежуток на предмет таблицы cTbl
      if (Adr <= lastMovAdr) and (lastMovAdr < jTblAdr) then cTblAdr := lastMovAdr;
      //Если есть cTblAdr, пропускаем эту таблицу
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        Inc(_Pos, CNum);
        Inc(Adr, CNum);
      End;
      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, _Pos) then break;
        Adr1 := PInteger(Code + _Pos)^;
        //Validate Adr1
        if not IsValidCodeAdr(Adr1) or (Adr1 < fromAdr) then break;
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        Inc(_Pos,4); 
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := _Pos;
      curAdr := Adr;
      continue;
    End;
    if b1 = $68 then //try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //check that next instruction is push fs:[reg] or retn
      if ((Code[NPos] = #$64) and (Code[NPos + 1] = #$FF) and (Code[NPos + 2] in [#$30..#$37,#$75]))
        or (Code[NPos] = #$C3) then
      Begin
        Adr := DisInfo.Immediate;      //Adr:=@1
        if not IsValidCodeAdr(Adr) then
        begin
          Result:= -1;
          Exit;
        end;
        if Adr > lastAdr then lastAdr := Adr;
        _Pos := Adr2Pos(Adr);
        assert(_Pos >= 0);
        delta := _Pos - NPos;
        if delta >= 0 then // and delta < outRows)
        Begin
          if Code[_Pos] = #$E9 then //jmp Handle...
          Begin
            //Дизассемблируем jmp
            instrLen1 := frmDisasm.Disassemble(Code + _Pos, Adr, @DisInfo, Nil);
            //if (!instrLen1) return -1;
            recN := GetInfoRec(DisInfo.Immediate);
            if Assigned(recN) then
            Begin
              if recN.SameName('@HandleFinally') then
              Begin
                //jmp HandleFinally
                Inc(_Pos, instrLen1); 
                Inc(Adr, instrLen1);
                //jmp @2
                instrLen2 := frmDisasm.Disassemble(Code + _Pos, Adr, @DisInfo, Nil);
                Inc(Adr, instrLen2);
                if Adr > lastAdr then lastAdr := Adr;
                {
                //@2
                Adr1 := DisInfo.Immediate - 4;
                Adr := PInteger(Code + Adr2Pos(Adr1))^;
                if Adr > lastAdr then lastAdr := Adr;
                }
              End
              else if recN.SameName('@HandleAnyException') or recN.SameName('@HandleAutoException') then
              Begin
                //jmp HandleAnyException
                Inc(_Pos, instrLen1);
                Inc(Adr, instrLen1);
                //call DoneExcept
                instrLen2 := frmDisasm.Disassemble(Code + _Pos, Adr, Nil, Nil);
                Inc(Adr, instrLen2);
                if Adr > lastAdr then lastAdr := Adr;
              End
              else if recN.SameName('@HandleOnException') then
              Begin
                //jmp HandleOnException
                Inc(_Pos, instrLen1); 
                Inc(Adr, instrLen1);
                //Флажок cfETable, чтобы правильно вывести данные
                SetFlag(cfETable, _Pos);
                //dd num
                num := PInteger(Code + _Pos)^; 
                Inc(_Pos, 4);
                if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                for k := 0 to num-1 do
                Begin
                  //dd offset ExceptionInfo
                  Inc(_Pos, 4);
                  //dd offset ExceptionProc
                  Inc(_Pos, 4);
                End;
              End;
            End;
          End;
        End;
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
    End;
    //short relative abs jmp or cond jmp
    if (b1 in [$EB,$70..$7F]) or
      ((b1 = $F) and (b2 in [$80..$8F])) then
    Begin
      Adr := DisInfo.Immediate;
      if not IsValidImageAdr(Adr) then
      begin
        Result:= -1;
        Exit;
      end;
      if IsValidCodeAdr(Adr) then
      Begin
        if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End
    else if b1 = $E9 then    //relative abs jmp or cond jmp
    Begin
      Adr := DisInfo.Immediate;
      if not IsValidImageAdr(Adr) then
      begin
        Result:= -1;
        Exit;
      end;
      if IsValidCodeAdr(Adr) then
      Begin
        recN := GetInfoRec(Adr);
        if not Assigned(recN) and (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    Inc(curPos, instrLen); 
    Inc(curAdr, instrLen);
  End;
  Result:= 1;
end;

//Sort VmtList by height and vmtAdr
Function SortPairsCmpFunction(item1,item2:Pointer) :Integer;
Var
  rec1:PVmtListRec Absolute item1;
  rec2:PVmtListRec Absolute item2;
Begin
  if rec1.height > rec2.height then Result:=1
  else if rec1.height < rec2.height then Result:=-1
  else if rec1.vmtAdr > rec2.vmtAdr then Result:= 1
  else if rec1.vmtAdr < rec2.vmtAdr then Result:=-1
  else Result:=0;
end;

Procedure TFMain.FillVmtList;
var
  n:Integer;
  recN:InfoRec;
  recV:PVmtListRec;
Begin
  VmtList.Clear;
  for n := 0 to TotalSize-1 do
  begin
    recN := GetInfoRec(Pos2Adr(n));
    if Assigned(recN) and (recN.kind = ikVMT) and recN.HasName then
    begin
      New(recV);
      with recV^ do
      begin
        height := GetClassHeight(Pos2Adr(n));
        vmtAdr := Pos2Adr(n);
        vmtName := recN.Name;
      end;
      VmtList.Add(recV);
    end;
  end;
  VmtList.Sort(SortPairsCmpFunction);
end;

//Return virtual method offset of procedure with address procAdr
Function TFMain.GetMethodOfs (rec:InfoRec; procAdr:Integer):Integer;
var
  m:Integer;
  recM:PMethodRec;
Begin
  if Assigned(rec) and Assigned(rec.vmtInfo.methods) then
    for m := 0 to rec.vmtInfo.methods.Count-1 do
    begin
      recM := rec.vmtInfo.methods[m];
      if (recM.kind = 'V') and (recM.address = procAdr) Then
      begin
        Result:=recM.id;
        Exit;
      end;
    end;
  Result:=-1;
end;

//Return PMethodRec of method with given name
Function TFMain.GetMethodInfo (rec:InfoRec; _name:AnsiString):PMethodRec;
var
  m:Integer;
  recM:PMethodRec;
Begin
  if Assigned(rec) and Assigned(rec.vmtInfo.methods) then
    for m := 0 to rec.vmtInfo.methods.Count-1 do
    begin
      recM := rec.vmtInfo.methods[m];
      if SameText(recM.name,_name) Then
      begin
        Result:=recM;
        Exit;
      end;
    end;
  Result:=Nil;
end;

//IntfTable присутствует, если класс порожден от интерфейсов
{
Interfaces
    Any class can implement any number of interfaces. The compiler stores a
    table of interfaces as part of the class's RTTI. The VMT points to the table
    of interfaces, which starts with a 4-byte count, followed by a list of
    interface records. Each interface record contains the GUID, a pointer to the
    interface's VMT, the offset to the interface's hidden field, and a pointer
    to a property that implements the interface with the implements directive.
    If the offset is zero, the interface property (called ImplGetter) must be
    non-nil, and if the offset is not zero, ImplGetter must be nil. The interface
    property can be a reference to a field, a virtual method, or a static method,
    following the conventions of a property reader (which is described earlier
    in this chapter, under Section 3.2.3"). When an object is constructed, Delphi
    automatically checks all the interfaces, and for each interface with a
    non-zero IOffset, the field at that offset is set to the interface's VTable
    (a pointer to its VMT). Delphi defines the the types for the interface table,
    unlike the other RTTI tables, in the System unit. These types are shown in
    Example 3.9. Type Declarations for the Interface Table

    type
      PInterfaceEntry = ^TInterfaceEntry;
      TInterfaceEntry = record
        IID: TGUID;
        VTable: Pointer;
        IOffset: Integer;
        ImplGetter: Integer;
      end;

      PInterfaceTable = ^TInterfaceTable;
      TInterfaceTable = record
        EntryCount: Integer;
        // Declare the type with the largest possible size,
        // but the true size of the array is EntryCount elements.
        Entries: array[0..9999] of TInterfaceEntry;
        // >= DXE2
        Intfs:array[0..EntryCount - 1] of PPTypeInfo;
      end;

    TObject implements several methods for accessing the interface table.
    See for the details of the GetInterface, GetInterfaceEntry, and GetInterfaceTable methods.
}

Procedure TFMain.ScanIntfTable (adr:Integer);
var
  vmtProc:Boolean;
  _dx, _bx, _si:Word;
  n, pos1, pos2,entryCount, cnt, vmtOfs, vpos, iOffset:Integer;
  vmtAdr, intfAdr, vAdr, iAdr, adres,v,instrlen:Integer;
  clasName, _name:AnsiString;
  recN, recN1:InfoRec;
  disInfo:TDisInfo;
  GUID:TGUID;
Begin
  if not IsValidImageAdr(adr) then Exit;
  clasName := GetClsName(adr);
  recN := GetInfoRec(adr);
  vmtAdr := adr - VmtSelfPtr;
  pos1 := Adr2Pos(vmtAdr) + VmtIntfTable;
  intfAdr := PInteger(Code + pos1)^;
  if intfAdr=0 then Exit;
  pos1 := Adr2Pos(intfAdr);
  entryCount := PInteger(Code + pos1)^; 
  Inc(pos1, 4);

  for n := 0 to entryCount-1 do
  Begin
    MoveMemory(@GUID, Code + pos1, 16);
    Inc(pos1, 16);
    //VTable
    vAdr := PInteger(Code + pos1)^; 
    Inc(pos1, 4);
    if IsValidCodeAdr(vAdr) then
    Begin
      cnt := 0;
      vpos := Adr2Pos(vAdr);
      v:=0;
      while true do
      Begin
        if IsFlagSet(cfVTable, vpos) then Inc(cnt);
        if cnt = 2 then break;
        iAdr := PInteger(Code + vpos)^; 
        adres := iAdr;
        pos2 := Adr2Pos(adres); 
        vmtProc := false; 
        vmtOfs := 0;
        _dx := 0; 
        _bx := 0; 
        _si := 0;
        while true do
        Begin
          instrlen := frmDisasm.Disassemble(Code + pos2, adres, @disInfo, Nil);
          if ((disInfo.OpType[0] = otMEM) or (disInfo.OpType[1] = otMEM)) 
            and (disInfo.BaseReg <> 20) then //to exclude instruction 'xchg reg, [esp]'
            vmtOfs := disInfo.Offset;
          if (disInfo.OpType[0] = otREG) and (disInfo.OpType[1] = otIMM) then
          Case disInfo.OpRegIdx[0] of
            10: _dx := disInfo.Immediate;
            11: _bx := disInfo.Immediate;
            14: _si := disInfo.Immediate;
          End;
          if disInfo.Call then
          Begin
            recN1 := GetInfoRec(disInfo.Immediate);
            if Assigned(recN1) then
            Begin
              if recN1.SameName('@CallDynaInst') or recN1.SameName('@CallDynaClass') then
              Begin
                if DelphiVersion <= 5 then GetDynaInfo(adr, _bx, iAdr)
                  else GetDynaInfo(adr, _si, iAdr);
                break;
              End
              else if recN1.SameName('@FindDynaInst') or recN1.SameName('@FindDynaClass') then
              Begin
                GetDynaInfo(adr, _dx, iAdr);
                break;
              End;
            End;
          End;
          if disInfo.Branch and not disInfo.Conditional then
          Begin
            if IsValidImageAdr(disInfo.Immediate) then
              iAdr := disInfo.Immediate
            else
              vmtProc := true;
            break;
          End
          else if disInfo.Ret then
          Begin
            vmtProc := true;
            break;
          End;
          Inc(pos2, instrlen);
          Inc(adres, instrlen);
        End;
        if not vmtProc and IsValidImageAdr(iAdr) then
        Begin
          AnalyzeProcInitial(iAdr);
          recN1 := GetInfoRec(iAdr);
          if Assigned(recN1) then
          Begin
            if recN1.HasName then
            Begin
              clasName := ExtractClassName(recN1.Name);
              _name := ExtractProcName(recN1.Name);
            End
            else _name := GetDefaultProcName(iAdr);
            if v >= 3 then
            Begin
              if not recN1.HasName then recN1.Name:=clasName + '.' + _name;
            End;
          End;
        End;
        Inc(vpos, 4);
        Inc(v, 4);
      End;
    End;
    //iOffset
    iOffset := PInteger(Code + pos1)^;
    Inc(pos1, 4);
    //ImplGetter
    if DelphiVersion > 3 then Inc(pos1, 4);
    recN.vmtInfo.AddInterface(Val2Str(vAdr,8) + ' ' + Val2Str(iOffset,4) + ' [''' + GuidToString(GUID)+''']');
  End;
end;


{
Automated Methods
    The automated section of a class declaration is now obsolete because it is
    easier to create a COM automation server with Delphi's type library editor,
    using interfaces. Nonetheless, the compiler currently supports automated
    declarations for backward compatibility. A future version of the compiler
    might drop support for automated declarations.
    The OleAuto unit tells you the details of the automated method table: The
    table starts with a 2-byte count, followed by a list of automation records.
    Each record has a 4-byte dispid (dispatch identifier), a pointer to a short
    string method name, 4-bytes of flags, a pointer to a list of parameters,
    and a code pointer. The parameter list starts with a 1-byte return type,
    followed by a 1-byte count of parameters, and ends with a list of 1-byte
    parameter types. The parameter names are not stored. Example 3.8 shows the
    declarations for the automated method table.
    Example 3.8. The Layout of the Automated Method Table

    const
      // Parameter type masks
      atTypeMask = $7F;
      varStrArg  = $48;
      atByRef    = $80;
      MaxAutoEntries = 4095;
      MaxAutoParams = 255;

    type
      TVmtAutoType = Byte;
      // Automation entry parameter list
      PAutoParamList = ^TAutoParamList;
      TAutoParamList = packed record
        ReturnType: TVmtAutoType;
        Count: Byte;
        Types: array[1..Count] of TVmtAutoType;
      end;
      // Automation table entry
      PAutoEntry = ^TAutoEntry;
      TAutoEntry = packed record
        DispID: LongInt;
        Name: PShortString;
        Flags: LongInt; // Lower byte contains flags
        Params: PAutoParamList;
        Address: Pointer;
      end;

      // Automation table layout
      PAutoTable = ^TAutoTable;
      TAutoTable = packed record
        Count: LongInt;
        Entries: array[1..Count] of TAutoEntry;
      end;
}

//Auto function prototype can be recovered from AutoTable!!!
Procedure TFMain.ScanAutoTable (adr:Integer);
var
  vmtAdr, _pos, autoAdr,params,address:Integer;
  clasName,_name,procname:AnsiString;
  recN,recN1:InfoRec;
  entryCount,i,dispID,flags:Integer;
  ppos,nameAdr, posn,m:Integer;
  len,typeCode,paramsNum,argType:Byte;
Begin
  if not IsValidImageAdr(Adr) then Exit;
  vmtAdr := Adr - VmtSelfPtr;
  _pos := Adr2Pos(vmtAdr) + VmtAutoTable;
  autoAdr := PInteger(Code + _pos)^;
  if autoAdr=0 then Exit;
  clasName := GetClsName(Adr);
  recN := GetInfoRec(Adr);

  _pos := Adr2Pos(autoAdr);
  entryCount := PInteger(Code + _pos)^; 
  Inc(_pos, 4);
  for i := 0 to entryCount-1 do
  Begin
    dispID := PInteger(Code + _pos)^; 
    Inc(_pos, 4);
    nameAdr := PInteger(Code + _pos)^; 
    Inc(_pos, 4);
    posn := Adr2Pos(nameAdr);
    len := Byte(Code[posn]); 
    Inc(posn);
    _name := MakeString(Code + posn, len);
    procname := clasName + '.';
    flags := PInteger(Code + _pos)^;
    Inc(_pos, 4);
    params := PInteger(Code + _pos)^; 
    Inc(_pos, 4);
    address := PInteger(Code + _pos)^; 
    Inc(_pos, 4);
    
    //afVirtual
    if (flags and 8) = 0 then
    Begin
      //afPropGet
      if (flags and 2)<>0 then procname := procname + 'Get';
      //afPropSet
      if (flags and 4)<>0 then procname := procname + 'Set';
    End
    else
    Begin
      //virtual table function
      address := PInteger(Code + Adr2Pos(vmtAdr + address))^;
    End;
    procname := procname + name;
    AnalyzeProcInitial(address);
    recN1 := GetInfoRec(address);
    if not Assigned(recN1) then recN1 := InfoRec.Create(Adr2Pos(address), ikRefine);
    if not recN1.HasName then recN1.Name:=procname;
    //Method
    if (flags and 1) <> 0 then recN1.procInfo.flags := recN1.procInfo.flags or PF_METHOD;
    //params
    ppos := Adr2Pos(params);
    typeCode := Byte(Code[ppos]);
    Inc(ppos);
    paramsNum := Byte(Code[ppos]);
    Inc(ppos);
    for m := 0 to paramsNum-1 do
    Begin
      argType := Byte(Code[ppos]);
      Inc(ppos);

    End;
    recN.vmtInfo.AddMethod(false, 'A', dispID, address, procname);
  End;
end;

(*
Initialization and Finalization
    When Delphi constructs an object, it automatically initializes strings,
    dynamic arrays, interfaces, and Variants. When the object is destroyed,
    Delphi must decrement the reference counts for strings, interfaces, dynamic
    arrays, and free Variants and wide strings. To keep track of this information,
    Delphi uses initialization records as part of a class's RTTI. In fact, every
    record and array that requires finalization has an associated initialization
    record, but the compiler hides these records. The only ones you have access
    to are those associated with an object's fields.
    A VMT points to an initialization table. The table contains a list of
    initialization records. Because arrays and records can be nested, each
    initialization record contains a pointer to another initialization table,
    which can contain initialization records, and so on. An initialization table
    uses a TTypeKind field to keep track of whether it is initializing a string,
    a record, an array, etc.
    An initialization table begins with the type kind (1 byte), followed by the
    type name as a short string, a 4-byte size of the data being initialized, a
    4-byte count for initialization records, and then an array of zero or more
    initialization records. An initialization record is just a pointer to a
    nested initialization table, followed by a 4-byte offset for the field that
    must be initialized. Example 3.7 shows the logical layout of the initialization
    table and record, but the declarations depict the logical layout without
    being true Pascal code.
    Example 3.7. The Layout of the Initialization Table and Record

    type
      // Initialization/finalization record
      PInitTable = ^TInitTable;
      TInitRecord = packed record
        InitTable: ^PInitTable;
        Offset: LongWord;        // Offset of field in object
      end;

      // Initialization/finalization table
      TInitTable = packed record
      {$MinEnumSize 1} // Ensure that TypeKind takes up 1 byte.
        TypeKind: TTypeKind;
        TypeName: packed ShortString;
        DataSize: LongWord;
        Count: LongWord;
        // If TypeKind=ikArray, Count is the array size, but InitRecords
        // has only one element; if the type kind is tkRecord, Count is the
        // number of record members, and InitRecords[] has a
        // record for each member. For all other types, Count=0.
        InitRecords: array[1..Count] of TInitRecord;
      end;
*)

Procedure TFMain.ScanInitTable (adr:Integer);
var
  recN:InfoRec;
  i,num,typeAdr,vmtAdr,pos1,pos2,initAdr,fieldOfs:Integer;
  typeName:AnsiString;
  len:Byte;
Begin
  if not IsValidImageAdr(Adr) then Exit;
  recN := GetInfoRec(Adr);
  vmtAdr := Adr - VmtSelfPtr;
  pos1 := Adr2Pos(vmtAdr) + VmtInitTable;
  initAdr := PInteger(Code + pos1)^;
  if initAdr=0 then Exit;

  pos1 := Adr2Pos(initAdr);
  Inc(pos1);  	//skip 0xE
  Inc(pos1);    	//unknown
  Inc(pos1, 4);	//unknown
  num := PInteger(Code + pos1)^;
  Inc(pos1, 4);
  for i := 0 to num-1 do
  begin
    typeAdr := PInteger(Code + pos1)^;
    Inc(pos1, 4);
    pos2 := Adr2Pos(typeAdr);
    if DelphiVersion <> 2 then Inc(pos2, 4);  //skip SelfPtr
    Inc(pos2);     //skip tkKind
    len := Byte(Code[pos2]);
    Inc(pos2);
    typeName := MakeString(Code + pos2, len);
    fieldOfs := PInteger(Code + pos1)^;
    Inc(pos1, 4);
    recN.vmtInfo.AddField(0, 0, FIELD_PUBLIC, fieldOfs, -1, '', typeName);
  End;
end;

//For Version>=2010
//Count: Word; // Published fields
//ClassTab: PVmtFieldClassTab
//Entry: array[1..Count] of TVmtFieldEntry
//ExCount: Word;
//ExEntry: array[1..ExCount] of TVmtFieldExEntry;
//================================================
//TVmtFieldEntry
//FieldOffset: Longword;
//TypeIndex: Word; // index into ClassTab
//Name: ShortString;
//================================================
//TFieldExEntry = packed record
//Flags: Byte;
//TypeRef: PPTypeInfo;
//Offset: Longword;
//Name: ShortString;
//AttrData: TAttrData
Procedure TFMain.ScanFieldTable (adr:Integer);
Var
  recN,recN1:InfoRec;
  _name:AnsiString;
  vmtAdr,_pos,pos2,classAdr,fieldAdr,typesTab,i,fieldOfs,typeRef,offset:Integer;
  count,idx,exCount,dw:Word;
  len,flags:Byte;
Begin
  if not IsValidImageAdr(Adr) then Exit;

  recN := GetInfoRec(Adr);
  vmtAdr := Adr - VmtSelfPtr;
  _pos := Adr2Pos(vmtAdr) + VmtFieldTable;
  fieldAdr := PInteger(Code + _pos)^;
  if fieldAdr=0 then Exit;
  _pos := Adr2Pos(fieldAdr);
  count := PWord(Code + _pos)^; 
  Inc(_pos, 2);
  typesTab := PInteger(Code + _pos)^;
  Inc(_pos, 4);

  for i := 0 to count-1 do
  Begin
    fieldOfs := PInteger(Code + _pos)^;
    Inc(_pos, 4);
    idx := PWord(Code + _pos)^;
    Inc(_pos, 2);
    len := Byte(Code[_pos]);
    Inc(_pos);
    _name := MakeString(Code + _pos, len);
    Inc(_pos, len);
    pos2 := Adr2Pos(typesTab) + 2 + 4 * idx;
    classAdr := PInteger(Code + pos2)^;
    if IsFlagSet(cfImport, Adr2Pos(classAdr)) then
    Begin
      recN1 := GetInfoRec(classAdr);
      recN.vmtInfo.AddField(0, 0, FIELD_PUBLISHED, fieldOfs, -1, _name, recN1.Name);
    End
    else
    Begin
      if DelphiVersion = 2 then Inc(classAdr, VmtSelfPtr);
      recN.vmtInfo.AddField(0, 0, FIELD_PUBLISHED, fieldOfs, -1, _name, GetClsName(classAdr));
    End;
  End;
  if DelphiVersion >= 2010 then
  Begin
    exCount := PWord(Code + _pos)^;
    Inc(_pos, 2);
    for i := 0 to exCount-1 do
    Begin
      flags := Byte(Code[_pos]);
      Inc(_pos);
      typeRef := PInteger(Code + _pos)^;
      Inc(_pos, 4);
      offset := PInteger(Code + _pos)^;
      Inc(_pos, 4);
      len := Byte(Code[_pos]);
      Inc(_pos);
      _name := MakeString(Code + _pos, len);
      Inc(_pos, len);
      dw := PWord(Code + _pos)^;
      Inc(_pos, dw);
      recN.vmtInfo.AddField(0, 0, FIELD_PUBLISHED, offset, -1, _name, GetTypeName(typeRef));
    End;
  End;
end;

Procedure TFMain.ScanMethodTable (adr:Integer; clasName:AnsiString);
var
  len:BYTE;
  skipNext,count,exCount:Word;
  n,codeAdr, pos1,spos, tpos,vmtAdr,methodAdr,entry:Integer;
  _name, methodName:AnsiString;
  recN1:InfoRec;
Begin
  if not IsValidImageAdr(adr) then Exit;
  vmtAdr := adr - VmtSelfPtr;
  methodAdr := PInteger(Code + Adr2Pos(vmtAdr) + VmtMethodTable)^;
  if methodAdr=0 then Exit;

  tpos := Adr2Pos(methodAdr);
  count := PWord(Code + tpos)^; 
  Inc(tpos, 2);
  for n := 0 to count-1 do
  Begin
    spos := tpos;
  	skipNext := PWord(Code + tpos)^;
  	Inc(tpos, 2);
    codeAdr := PInteger(Code + tpos)^; 
    Inc(tpos, 4);
    len := Byte(Code[tpos]);
    Inc(tpos);
    _name := MakeString(Code + tpos, len); 
    Inc(tpos, len);

    //as added   why this code was removed? 
    methodName := clasName + '.' + _name;
    pos1 := Adr2Pos(codeAdr);
    recN1 := GetInfoRec(codeAdr);
    if not Assigned(recN1) then
    Begin
      recN1 := InfoRec.Create(pos1, ikRefine);
      recN1.Name:=methodName;
    End;        
    //~

    InfoList[Adr2Pos(adr)].vmtInfo.AddMethod(false, 'M', -1, codeAdr, methodName);
    tpos := spos + skipNext;
  End;
  if DelphiVersion >= 2010 then
  Begin
    exCount := PWord(Code + tpos)^; 
    Inc(tpos, 2);
    for n := 0 to exCount-1 do
    Begin
      //Entry
      entry := PInteger(Code + tpos)^;
      Inc(tpos, 4);
      //Flags
      Inc(tpos, 2);
      //VirtualIndex
      Inc(tpos, 2);
      spos := tpos;
      //Entry
      tpos := Adr2Pos(entry);
      skipNext := PWord(Code + tpos)^;
      Inc(tpos, 2);
      codeAdr := PInteger(Code + tpos)^;
      Inc(tpos, 4);
      len := Byte(Code[tpos]);
      Inc(tpos);
      _name := MakeString(Code + tpos, len);
      Inc(tpos, len);
      InfoList[Adr2Pos(adr)].vmtInfo.AddMethod(false, 'M', -1, codeAdr, clasName + '.' + _name);
      tpos := spos;
    End;
  End;
end;

Function GetMsgInfo(msg:Word):PMsgInfo;
var
  m:Integer;
Begin
  Result:=Nil;
  //WindowsMsgTab
  if msg < $400 then
    for m:=Low(WindowsMsgTab) to High(WindowsMsgTab) do
      if WindowsMsgTab[m].id = msg Then
      Begin
        Result:=@WindowsMsgTab[m];
        Exit;
      end;
  //VCLControlsMsgTab
  if (msg >= $B000) and (msg < $C000) then
    for m:=Low(VCLControlsMsgTab) to High(VCLControlsMsgTab) do
      if VCLControlsMsgTab[m].id = msg Then
      Begin
        Result:=@VCLControlsMsgTab[m];
        Exit;
      end;
end;

Procedure TFMain.ScanDynamicTable (adr:Integer);
var
  recN, recN1, recN2:InfoRec;
  recM:MethodRec;
  info:PMsgInfo;
  vmtAdr,pos1,pos2,pos3,pos4,j,i,dynAdr,procAdr,procAdr1,dpos,parentAdr,vmtAdr1:Integer;
  clasName,typName:AnsiString;
  num,num1,msg,msg1:Word;
Begin
  if not IsValidImageAdr(adr) then Exit;
  recN := GetInfoRec(adr);
  if not Assigned(recN) then Exit;

  vmtAdr := adr - VmtSelfPtr;
  pos1 := Adr2Pos(vmtAdr) + VmtDynamicTable;
  dynAdr := PInteger(Code + pos1)^;
  if dynAdr=0 then Exit;
  clasName := GetClsName(adr);

  pos1 := Adr2Pos(dynAdr);
  num := PWord(Code + pos1)^; 
  Inc(pos1, 2);
  pos2 := pos1 + 2 * num;
  //First fill wellknown names
  for i := 0 to num-1 do
  Begin
    msg := PWord(Code + pos1)^; 
    Inc(pos1, 2);
    procAdr := PInteger(Code + pos2)^; 
    Inc(pos2, 4);
    recM._abstract := false;
    recM.kind := 'D';
    recM.id := msg;
    recM.address := procAdr;
    recM.name := '';

    recN1 := GetInfoRec(procAdr);
    if Assigned(recN1) and recN1.HasName then recM.name := recN1.Name
    else
    Begin
      info := GetMsgInfo(msg);
      if Assigned(info) then
      Begin
        typname := info.typname;
        if typname <> '' then
        Begin
          if not Assigned(recN1) then recN1 := InfoRec.Create(Adr2Pos(procAdr), ikRefine);
          recM.name := clasName + '.' + typname;
          recN1.Name:=recM.name;
        End;
      End;
      if recM.name = '' then
      Begin
        parentAdr := GetParentAdr(adr);
        while parentAdr<>0 do
        Begin
          recN2 := GetInfoRec(parentAdr);
          if Assigned(recN2) then
          Begin
            vmtAdr1 := parentAdr - VmtSelfPtr;
            pos3 := Adr2Pos(vmtAdr1) + VmtDynamicTable;
            dynAdr := PInteger(Code + pos3)^;
            if dynAdr<>0 then
            Begin
              pos3 := Adr2Pos(dynAdr);
              num1 := PWord(Code + pos3)^; 
              Inc(pos3, 2);
              pos4 := pos3 + 2 * num1;
              for j := 0 to num1-1 do
              Begin
                msg1 := PWord(Code + pos3)^; 
                Inc(pos3, 2);
                procAdr1 := PInteger(Code + pos4)^; 
                Inc(pos4, 4);
                if msg1 = msg then
                Begin
                  recN2 := GetInfoRec(procAdr1);
                  if Assigned(recN2) and recN2.HasName then
                  Begin
                    dpos := Pos('.',recN2.Name);
                    if dpos<>0 then
                      recM.name := clasName + Copy(recN2.Name,dpos, Length(recN2.Name) - dpos + 1)
                    else
                      recM.name := recN2.Name;
                  End;
                  break;
                End;
              End;
              if recM.name <> '' then break;
            End;
          End;
          parentAdr := GetParentAdr(parentAdr);
        End;
      End;
      if (recM.name = '') or SameText(recM.name, '@AbstractError') then
      	recM.name := clasName + '.sub_' + Val2Str(recM.address,8);

      recN1 := InfoRec.Create(Adr2Pos(procAdr), ikRefine);
      recN1.Name:=recM.name;
    End;
    recN.vmtInfo.AddMethod(recM._abstract, recM.kind, recM.id, recM.address, recM.name);
  End;
end;

Function IsOwnVirtualMethod(vmtAdr,procAdr:Integer):Boolean;
var
  parentAdr,stopAt,pos1,m:Integer;
Begin
  Result:=True;
  parentAdr := GetParentAdr(vmtAdr);
  if parentAdr=0 then Exit;
  stopAt := GetStopAt(parentAdr - VmtSelfPtr);
  if vmtAdr = stopAt Then
  Begin
    Result:=false;
    Exit;
  end;
  pos1 := Adr2Pos(parentAdr) + VmtParent + 4;
  m := VmtParent + 4;
  while True Do
  begin
    if Pos2Adr(pos1) = stopAt then break;
    if PInteger(Code + pos1)^ = procAdr Then
    Begin
      Result:=false;
      Exit;
    end;
    Inc(m,4);
    Inc(pos1,4);
  End;
end;

//Create recN->methods list
Procedure TFMain.ScanVirtualTable (adr:Integer);
var
  m, pos1, idx:Integer;
  vmtAdr, stopAt:Integer;
  clsName:AnsiString;
  recN, recN1:InfoRec;
  recM:MethodRec;
  pInfo:MProcInfo;
Begin
  if not IsValidImageAdr(adr) then Exit;
  clsName := GetClsName(adr);
  vmtAdr := adr - VmtSelfPtr;
  stopAt := GetStopAt(vmtAdr);
  if vmtAdr = stopAt then Exit;

  pos1 := Adr2Pos(vmtAdr) + VmtParent + 4;
  recN := GetInfoRec(vmtAdr + VmtSelfPtr);

  m := VmtParent + 4;
  while true do
  Begin
    if Pos2Adr(pos1) = stopAt then break;

    recM._abstract := false;
    recM.address := PInteger(Code + pos1)^;
    recN1 := GetInfoRec(recM.address);
    if Assigned(recN1) and recN1.HasName then
    Begin
      if not recN1.SameName('@AbstractError') then
        recM.name := recN1.Name
      else
      Begin
        recM._abstract := true;
        recM.name := '';
      End;
    End
    else
    Begin
      recM.name := '';
      if m = VmtFreeInstance then
        recM.name := clsName + '.' + 'FreeInstance'
      else if m = VmtNewInstance then
        recM.name := clsName + '.' + 'NewInstance'
      else if m = VmtDefaultHandler then
        recM.name := clsName + '.' + 'DefaultHandler';
      if (DelphiVersion = 3) and (m = VmtSafeCallException) then
        recM.name := clsName + '.' + 'SafeCallException';
      if DelphiVersion >= 4 then
      Begin
        if m = VmtSafeCallException then
          recM.name := clsName + '.' + 'SafeCallException'
        else if m = VmtAfterConstruction then
          recM.name := clsName + '.' + 'AfterConstruction'
        else if m = VmtBeforeDestruction then
          recM.name := clsName + '.' + 'BeforeDestruction'
        else if m = VmtDispatch then
          recM.name := clsName + '.' + 'Dispatch';
      End;
      if DelphiVersion >= 2009 then
      Begin
        if m = VmtEquals then
          recM.name := clsName + '.' + 'Equals'
        else if m = VmtGetHashCode then
          recM.name := clsName + '.' + 'GetHashCode'
        else if m = VmtToString then
          recM.name := clsName + '.' + 'ToString';
      End;
      if (recM.name <> '') and KBase.GetKBProcInfo(PAnsiChar(recM.name), pInfo, idx) then
        StrapProc(Adr2Pos(recM.address), idx, @pInfo, true, pInfo.DumpSz);
    End;
    recN.vmtInfo.AddMethod(recM._abstract, 'V', m, recM.address, recM.name);
    Inc(m, 4);
    Inc(pos1, 4);
  End;
end;

//Возвращает "высоту" класса (число родительских классов до 0)
Function TFMain.GetClassHeight (adr:Integer):Integer;
Begin
  Result:=0;
  while true do
  begin
    adr := GetParentAdr(adr);
    if adr=0 then break;
    Inc(Result);
  end;
end;

Procedure TFMain.PropagateVMTNames (adr:Integer);
var
  clasName,_name:AnsiString;
  recN,recN1,recN2:InfoRec;
  recM:PMethodRec;
  pos1,m,n,procAdr,dotpos,classAdr,vmtAdr,stopAt:Integer;
  aInfo2:PArgInfo;
  aInfo:ArgInfo;
Begin
  clasName := GetClsName(adr);
  recN := GetInfoRec(adr);
  vmtAdr := adr - VmtSelfPtr;
  stopAt := GetStopAt(vmtAdr);
  if vmtAdr = stopAt then Exit;
  pos1 := Adr2Pos(vmtAdr) + VmtParent + 4;
  m := VmtParent + 4;
  while true do
  Begin
    if Pos2Adr(pos1) = stopAt then break;
    procAdr := PInteger(Code + pos1)^;
    recN1 := GetInfoRec(procAdr);
    if not Assigned(recN1) then recN1 := InfoRec.Create(Adr2Pos(procAdr), ikRefine);
    if not recN1.HasName then
    Begin
    	classAdr := adr;
      while classAdr<>0 do
      Begin
      	recM := GetMethodInfo(classAdr, 'V', m);
        if Assigned(recM) then
        Begin
          _name := recM.name;
          if _name <> '' then
          Begin
            dotpos := Pos('.',_name);
            if dotpos<>0 then
              recN1.Name:=clasName + Copy(_name,dotpos, Length(_name))
            else
              recN1.Name:=_name;

            recN2 := GetInfoRec(recM.address);
            recN1.kind := recN2.kind;
            if not Assigned(recN1.procInfo.args) and Assigned(recN2.procInfo.args) then
            Begin
            	recN1.procInfo.flags := recN1.procInfo.flags or (recN2.procInfo.flags and 7);
              //Get Arguments
              for n := 0 to recN2.procInfo.args.Count-1 do
              Begin
                aInfo2 := recN2.procInfo.args[n];
                aInfo.Tag := aInfo2.Tag;
                aInfo.In_Reg := aInfo2.In_Reg;
                aInfo.Ndx := aInfo2.Ndx;
                aInfo.Size := 4;
                aInfo.Name := aInfo2.Name;
                aInfo.TypeDef := TrimTypeName(aInfo2.TypeDef);
                recN1.procInfo.AddArg(@aInfo);
              End;
            End;
            recN.vmtInfo.AddMethod(false, 'V', m, procAdr, recN1.Name);
            break;
          End;
        End;
        classAdr := GetParentAdr(classAdr);
      End;
    End;
    Inc(m, 4);
    Inc(pos1, 4);
  End;
end;

Function TFMain.GetMethodInfo(adr:Integer; kind:Char; methodOfs:Integer):PMethodRec;
var
  recN:InfoRec;
  n:Integer;
Begin
  Result:=Nil;
  if not IsValidCodeAdr(adr) then Exit;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo.methods) then
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    begin
      Result := recN.vmtInfo.methods[n];
      if (Result.id = methodOfs) and (Result.kind = kind) Then Exit;
    end;
  Result:=Nil;
end;

procedure ClearClassAdrMap;
Begin
  classAdrMap.Clear;
end;

Function FindClassAdrByName(const AName:AnsiString):Integer;
var
  idx:Integer;
Begin
  idx:=classAdrMap.IndexOf(AName);
  if idx <> -1 Then Result:=Integer(classAdrMap.Objects[idx])
    Else Result:=0;
end;

procedure AddClassAdr(Adr:Integer; const AName:AnsiString);
begin
  classAdrMap.AddObject(AName, TObject(Adr));
end;

//Возвращает общий родительский тип для типов Name1, Name2
Function TFMain.GetCommonType (Name1, Name2:AnsiString):AnsiString;
var
  adr1,adr2,h1,h2:Integer;
Begin
  if SameText(Name1, Name2) then
  begin
    Result:=Name1;
    Exit;
  end;

  adr1 := GetClassAdr(Name1);
  adr2 := GetClassAdr(Name2);
  //Synonims
  if (adr1=0) or (adr2=0) then
  Begin
    //dword and ClassName -> ClassName
    if SameText(Name1, 'Dword') and IsValidImageAdr(GetClassAdr(Name2)) then
    begin
      Result:=Name2;
      Exit;
    end;
    if SameText(Name2, 'Dword') and IsValidImageAdr(GetClassAdr(Name1)) then
    begin
      Result:=Name1;
      Exit;
    end;
    if DelphiVersion >= 2009 then
    Begin
      //UString - UnicodeString
    	if (SameText(Name1, 'UString') and SameText(Name2, 'UnicodeString')) or
      	(SameText(Name1, 'UnicodeString') and SameText(Name2, 'UString')) then
      begin
        Result:='UnicodeString';
        Exit;
      end;
    End;
	  //String - AnsiString
  	if (SameText(Name1, 'String') and SameText(Name2, 'AnsiString')) or
    	(SameText(Name1, 'AnsiString') and SameText(Name2, 'String')) then
    begin
      Result:='AnsiString';
      Exit;
    end;
    //Text - TTextRec
    if (SameText(Name1, 'Text') and SameText(Name2, 'TTextRec')) or
    	(SameText(Name1, 'TTextRec') and SameText(Name2, 'Text')) then
    begin
      Result:= 'TTextRec';
      Exit;
    end;
    Result:= '';
    Exit;
  End;
  
  h1 := GetClassHeight(adr1);
  h2 := GetClassHeight(adr2);
  while h1 <> h2 do
  	if h1 > h2 then
    Begin
    	adr1 := GetParentAdr(adr1);
      Dec(h1);
    End
    else
    Begin
    	adr2 := GetParentAdr(adr2);
      Dec(h2);
    End;

  while adr1 <> adr2 do
  Begin
  	adr1 := GetParentAdr(adr1);
    adr2 := GetParentAdr(adr2);
  End;
  Result:= GetClsName(adr1);
end;

procedure TFMain.FormCreate(Sender : TObject);
begin
  DeleteFile('z:\IDR.csl');
  Dest := TCodeSiteDestination.Create( Self );
  Dest.LogFile.Active := True;
  Dest.LogFile.FileName := 'IDR.csl';
  Dest.LogFile.FilePath := 'z:\';
  CodeSite.Destination := Dest;

  frmDisasm:=MDisasm.Create;
  if not frmDisasm.Init then
  begin
    frmDisasm.Free;
    ShowMessage('Cannot initialize Dis-assembler');
    Application.Terminate;
  end;
  AppDir := ExtractFilePath(Application.ExeName);
  if AppDir[Length(AppDir)] <> '\' then AppDir := AppDir + '\';
  Application.HelpFile := AppDir + 'idr.chm';
  IniFileRead;

  miDelphi2.Enabled := FileExists(AppDir + 'kb2.bin');
  miDelphi3.Enabled := FileExists(AppDir + 'kb3.bin');
  miDelphi4.Enabled := FileExists(AppDir + 'kb4.bin');
  miDelphi5.Enabled := FileExists(AppDir + 'kb5.bin');
  miDelphi6.Enabled := FileExists(AppDir + 'kb6.bin');
  miDelphi7.Enabled := FileExists(AppDir + 'kb7.bin');
  miDelphi2005.Enabled := FileExists(AppDir + 'kb2005.bin');
  miDelphi2006.Enabled := FileExists(AppDir + 'kb2006.bin');
  miDelphi2007.Enabled := FileExists(AppDir + 'kb2007.bin');
  miDelphi2009.Enabled := FileExists(AppDir + 'kb2009.bin');
  miDelphi2010.Enabled := FileExists(AppDir + 'kb2010.bin');
  miDelphiXE1.Enabled := FileExists(AppDir + 'kb2011.bin');
  miDelphiXE2.Enabled := FileExists(AppDir + 'kb2012.bin');
  miDelphiXE3.Enabled := FileExists(AppDir + 'kb2013.bin');
  miDelphiXE4.Enabled := FileExists(AppDir + 'kb2014.bin');

  KBase:=MKnowledgeBase.Create;
  tvClassMap:=TStringList.Create;
  classAdrMap:=TStringList.Create;
  SegmentList := TList.Create;
  ExpFuncList := TList.Create;
  ImpFuncList := TList.Create;
  ImpModuleList := TStringList.Create;
  VmtList := TList.Create;
  ResInfo := TResourceInfo.Create;
  Units := TList.Create;
  OwnTypeList := TList.Create;
  UnitsSearchList := TStringList.Create;
  RTTIsSearchList := TStringList.Create;
  UnitItemsSearchList := TStringList.Create;
  VMTsSearchList := TStringList.Create;
  FormsSearchList := TStringList.Create;
  StringsSearchList := TStringList.Create;
  NamesSearchList := TStringList.Create;

  Init;

  lbUnits.Canvas.Font.Assign(lbUnits.Font);
  lbRTTIs.Canvas.Font.Assign(lbRTTIs.Font);
  lbForms.Canvas.Font.Assign(lbForms.Font);
  lbCode.Canvas.Font.Assign(lbCode.Font);
  lbUnitItems.Canvas.Font.Assign(lbUnitItems.Font);

  lbCXrefs.Canvas.Font.Assign(lbCXrefs.Font);
  lbCXrefs.Width := lbCXrefs.Canvas.TextWidth('T')*14;
  ShowCXrefs.Width := lbCXrefs.Width;

  lbSXrefs.Canvas.Font.Assign(lbSXrefs.Font);
  lbSXrefs.Width := lbSXrefs.Canvas.TextWidth('T')*14;
  ShowSXrefs.Width := lbSXrefs.Width;

  lbNXrefs.Canvas.Font.Assign(lbNXrefs.Font);
  lbNXrefs.Width := lbNXrefs.Canvas.TextWidth('T')*14;
  ShowNXrefs.Width := lbNXrefs.Width;

  vtUnit.NodeDataSize:=SizeOf(vtUnitNode);
  {
  //----Highlighting------
	if InitHighlight then
  begin
    lbSourceCode.Style := lbOwnerDrawFixed;
    DelphiLbId         := CreateHighlight(lbSourceCode.Handle, ID_DELPHI);
    DelphiThemesCount  := GetThemesCount(ID_DELPHI);
    for n := 0 to DelphiThemesCount-1 do
    begin
      mi := TMenuItem.Create(pmCode.Items);
      GetThemeName(ID_DELPHI, n,@buf[1], 255);
      mi.Caption := String(buf);
      mi.Tag := n;
      mi.OnClick := ChangeDelphiHighlightTheme;
      miDelphiAppearance.Add(mi);
    End;
	end;
  //----Highlighting-------
  }
end;

procedure TFMain.FormDestroy(Sender : TObject);
var
  n:Integer;
  recU:PUnitRec;
begin
  CloseProject;

  KBase.Free;
  frmDisasm.Free;
  tvClassMap.Free;
  classAdrMap.Free;
  SegmentList.Free;
  ExpFuncList.Free;
  ImpFuncList.Free;
  ImpModuleList.Free;
  VmtList.Free;
  ResInfo.Free;
  OwnTypeList.Free;
  UnitsSearchList.Free;
  RTTIsSearchList.Free;
  UnitItemsSearchList.Free;
  VMTsSearchList.Free;
  FormsSearchList.Free;
  StringsSearchList.Free;
  NamesSearchList.Free;

  for n := 0 to UnitsNum-1 do
  begin
    recU := Units[n];
    recU.names.Free;
  end;
  Units.Free;
  {
  //----Highlighting--------
  if Assigned(DeleteHighlight) then DeleteHighlight(DelphiLbId);
  FreeHighlight;
  //----Highlighting---------
  }
end;

Function GetFilenameFromLink(LinkName:AnsiString):AnsiString;
var
  ppf:IPersistFile;
  pshl:IShellLinkW;
  wfd:TWin32FindData;
  temp:Array[0..MAX_PATH] of WideChar;
  target:Array[0..MAX_PATH] of WideChar;
Begin
  Result:='';
  //Initialize COM-library
  CoInitialize(NIL);
  //Create COM-object and get pointer to interface IPersistFile
  CoCreateInstance(CLSID_ShellLink, Nil, CLSCTX_INPROC_SERVER, IID_IPersistFile, ppf);
  //Load Shortcut
  StringToWideChar(LinkName, temp, MAX_PATH);
  ppf.Load(temp, STGM_READ);

  //Get pointer to IShellLink
  ppf.QueryInterface(IID_IShellLinkW, pshl);
  //Find Object shortcut points to
  pshl.Resolve(0, SLR_ANY_MATCH or SLR_NO_UI);
  //Get Object name
  pshl.GetPath(target, MAX_PATH, wfd, 0);
  result := String(target);

  pshl._Release;
  ppf._Release;
  CoFreeUnusedLibraries;
  CoUninitialize;
end;

procedure TFMain.FormShow(Sender : TObject);
Var
  fName,fExtension:AnsiString;
begin
  if ParamCount > 0 then
  begin
    fName := ParamStr(1);
    fExtension := ExtractFileExt(fName);
    //Shortcut
    if SameText(fExtension, '.lnk') then
      fName := GetFilenameFromLink(fName);
    if IsExe(fName) then
      LoadDelphiFile1(fName, DELHPI_VERSION_AUTO, true, true)
    else if IsIdp(fName) then
      OpenProject(fName)
    else
      ShowMessage('File ' + fName + ' is not executable or IDR project file');
  end;
end;

Function TFMain.MakeComment (code:PPICODE):AnsiString;
var
  vmt:Boolean;
  vmtAdr:Integer;
  fInfo:FieldInfo;
Begin
  Result:='';
  if (code.Op = OP_CALL) or (code.Op = OP_COMMENT) then
  	Result := code.Name
  else
  Begin
    fInfo := GetField(code.Name, code.Offset, vmt, vmtAdr);
    if Assigned(fInfo) then
    Begin
      Result := code.Name + '.';
      if fInfo.Name = '' then
        Result := Result + '?f' + Val2Str(code.Offset)
      else
        Result := Result + fInfo.Name;
      Result := Result + ':';
      if fInfo._Type = '' then
        Result := Result + '?'
      else
        Result := Result + TrimTypeName(fInfo._Type);
      if not vmt then fInfo.Free;
    End
    else if code.Name <> '' then
      Result := code.Name + '.?f' + Val2Str(code.Offset) + ':?';
  End;
end;

Procedure TFMain.RedrawCode;
var
  adr:Integer;
Begin
  adr := CurProcAdr;
  CurProcAdr := 0;
  ShowCode(adr, lbCode.ItemIndex, lbCXrefs.ItemIndex, lbCode.TopIndex);
end;

//MXXXXXXXX    textF
//M:<,>,=
//XXXXXXXX - adr
//F - flags
Function TFMain.AddAsmLine (adr:Integer; _text:AnsiString; Flags:Byte):Integer;
var
  line:AnsiString;
Begin
  line := ' ' + Val2Str(Adr,8) + '        ' + _text + ' ';
  if (Flags and 1)<>0 then line[1] := '>';
  if (Flags and 8)<>0 then line[10] := '>';
  line[Length(line)] := Char(Flags);
  lbCode.Items.Add(line);
  Result:=lbCode.Canvas.TextWidth(line);
end;

//Argument SelectedIdx can be address (for selection) and index of list
Procedure TFMain.ShowCode (fromAdr:Integer; SelectedIdx, XrefIdx, topIdx:Integer);
var
  b1,b2,op, flags:Byte;
  db:Char;
  selectByAdr,NameInside:Boolean;
  row, wid, maxwid, _pos, idx, ap, selectedRow:Integer;
  canva:TCanvas;
  num, instrLen, instrLen1, instrLen2, procSize:Integer;
  k,i,outRows,Adr, Adr1, Pos2, lastMovAdr:Integer;
  fromPos, curPos, curAdr, lastAdr,NameInsideAdr:Integer;
  cTblAdr,jTblAdr,CNum,NPos,delta,targetAdr:Integer;
  line, line1,moduleName,procName:AnsiString;
  disLine,namei, comment, _name, pname, _type, ptype:AnsiString;
  recN:InfoRec;
  recU:PUnitRec;
  DisInfo, DisInfo1:TDisInfo;
  CTab:Array[0..255] of Char;
Begin
  row:=0;
  maxwid:=0;
  canva:=lbCode.Canvas;
  lastMovAdr:=0;
  lastAdr:=0;
  fromPos := Adr2Pos(fromAdr);
  if fromPos < 0 then Exit;

  //if (AnalyzeThread) AnalyzeThread.Suspend();

  selectByAdr := IsValidImageAdr(SelectedIdx);
  //If procedure is the same then move selection and not update Xrefs
  if fromAdr = CurProcAdr then
  Begin
    if selectByAdr then
      for i := 1 to lbCode.Items.Count-1 do
      Begin
        line := lbCode.Items[i];
        sscanf(PAnsiChar(line)+1,'%lX',[@Adr]);
        if Adr >= SelectedIdx then
        Begin
          if Adr = SelectedIdx then
          Begin
            lbCode.ItemIndex := i;
            break;
          End
          else
          Begin
            lbCode.ItemIndex := i - 1;
            break;
          End;
        End;
      End
    else lbCode.ItemIndex := SelectedIdx;
    pcWorkArea.ActivePage := tsCodeView;
    //if (lbCode.CanFocus()) ActiveControl := lbCode;
    Exit;
  End;
  if not Assigned(AnalyzeThread) then //Clear all Items (used in highlighting)
  Begin
    //AnalyzeProc1(fromAdr, 0, 0, 0, false);//!!!
    AnalyzeProc2(fromAdr, false, false);
  End;
  CurProcAdr := fromAdr;
  CurProcSize := 0;
  lbCode.Clear;
  lbCode.Items.BeginUpdate;

  recN := GetInfoRec(fromAdr);
  outRows := MAX_DISASSEMBLE;
  if IsFlagSet(cfImport, fromPos) then outRows := 2;
  line := ' ';
  if fromAdr = EP then line := line + 'EntryPoint'
  else
  Begin
    moduleName := '';
    procName := '';
    recU := GetUnit(fromAdr);
    if Assigned(recU) then
    Begin
      moduleName := GetUnitName(recU);
      if fromAdr = recU.iniadr then
        procName := 'Initialization'
      else if fromAdr = recU.finadr then
        procName := 'Finalization';
    End;
    if Assigned(recN) and (procName = '') then procName := recN.MakeMapName(fromAdr);
    if moduleName <> '' then
      line := line + moduleName + '.' + procName
    else
      line := line + procName;
  End;
  lProcName.Caption := line;
  lbCode.Items.Add(line);
  Inc(row);

  procSize := GetProcSize(fromAdr);
  curPos := fromPos; 
  curAdr := fromAdr;
  selectedRow := -1;

  while row < outRows do
  Begin
    //End of procedure
    if (curAdr <> fromAdr) and (procSize<>0) and (curAdr - fromAdr >= procSize) then break;
    //Loc?
    flags := 32; // ' ';
    if (curAdr <> CurProcAdr) and IsFlagSet(cfLoc, curPos) then flags := flags or 1;
    if IsFlagSet(cfFrame or cfSkip, curPos) then flags := flags or 2;
    if IsFlagSet(cfLoop, curPos) then flags := flags or 4;

    //If exception table, output it
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      wid := AddAsmLine(curAdr, 'dd          ' + IntToStr(num), flags); 
      Inc(row);
      if wid > maxwid then maxwid := wid;
      Inc(curPos, 4);
      Inc(curAdr, 4);
      for k := 0 to num-1 do
      Begin
        //dd offset ExceptionInfo
        Adr := PInteger(Code + curPos)^;
        line1 := 'dd          ' + Val2Str(Adr,8);
        //Name of Exception
        if IsValidCodeAdr(Adr) then
        Begin
          recN := GetInfoRec(Adr);
          if Assigned(recN) and recN.HasName then line1 := line1 + ';' + recN.Name;
        End;
        wid := AddAsmLine(curAdr, line1, flags); 
        Inc(row);
        if wid > maxwid then maxwid := wid;

        //dd offset ExceptionProc
        Inc(curPos, 4); 
        Inc(curAdr, 4);
        Adr := PInteger(Code + curPos)^;
        wid := AddAsmLine(curAdr, 'dd          ' + Val2Str(Adr,8), flags);
        Inc(row);
        if wid > maxwid then maxwid := wid;
        Inc(curPos, 4); 
        Inc(curAdr, 4);
      End;
      continue;
    End;

    b1 := Byte(Code[curPos]);
    b2 := Byte(Code[curPos + 1]);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, @disLine);
    if instrLen=0 then
    Begin
      wid := AddAsmLine(curAdr, '???', $22); 
      Inc(row);
      if wid > maxwid then maxwid := wid;
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    op := frmDisasm.GetOp(DisInfo.Mnem);

    //Calculate ItemIdx (ItemIdx can be distinct with instruction begin!)
    if selectByAdr and (curAdr <= SelectedIdx) and (SelectedIdx < curAdr + instrLen) then selectedRow := row;

    //Check inside instruction Fixup or ThreadVar
    NameInside := false;
    for k := 1 to instrLen-1 do
      if Assigned(InfoList[curPos + k]) then
      Begin
        NameInside := true;
        NameInsideAdr:= curAdr + k;
        break;
      End;
    line := disLine;
    if curAdr >= lastAdr then lastAdr := 0;

    //Proc end
    if DisInfo.Ret and ((lastAdr=0) or (curAdr = lastAdr)) then
    Begin
      wid := AddAsmLine(curAdr, line, flags); 
      Inc(row);
      if wid > maxwid then maxwid := wid;
      break;
    End;
    if op = OP_MOV then lastMovAdr := DisInfo.Offset;
    //short relative abs jmp or cond jmp
    if (b1 = $EB) or				 
    	((b1 >= $70) and (b1 <= $7F)) or
      ((b1 = 15) and (b2 >= $80) and (b2 <= $8F)) then
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        if op = OP_JMP then
        Begin
          ap := Adr2Pos(Adr);
          recN := GetInfoRec(Adr);
          if Assigned(recN) and IsFlagSet(cfProcStart, ap) and recN.HasName then
            line := 'jmp         ' + recN.Name;
        End;
        flags := flags or 8;
        if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      wid := AddAsmLine(curAdr, line, flags); 
      Inc(row);
      if wid > maxwid then maxwid := wid;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if b1 = $E9 then    //relative abs jmp or cond jmp
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        ap := Adr2Pos(Adr);
        recN := GetInfoRec(Adr);
        if Assigned(recN) and IsFlagSet(cfProcStart, ap) and recN.HasName then
          line := 'jmp         ' + recN.Name;
        flags := flags or 8;
        if not Assigned(recN) and (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      wid := AddAsmLine(curAdr, line, flags); 
      Inc(row);
      if wid > maxwid then maxwid := wid;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    if DisInfo.Call then  //call sub_XXXXXXXX
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        recN := GetInfoRec(Adr);
        if Assigned(recN) and recN.HasName then
        Begin
          line := 'call        ' + recN.Name;
          //Found @Halt0 - exit
          if recN.SameName('@Halt0') and (fromAdr = EP) and (lastAdr=0) then
          Begin
            wid := AddAsmLine(curAdr, line, flags); 
            Inc(row);
            if wid > maxwid then maxwid := wid;
            break;
          End;
        End;
      End;
      recN := GetInfoRec(curAdr);
      if Assigned(recN) and Assigned(recN.Pcode) then line := line + ';' + MakeComment(recN.pcode);
      wid := AddAsmLine(curAdr, line, flags); 
      Inc(row);
      if wid > maxwid then maxwid := wid;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if (b1 = 255) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      wid := AddAsmLine(curAdr, line, flags); 
      Inc(row);
      if wid > maxwid then maxwid := wid;
      if not IsValidCodeAdr(DisInfo.Offset) then break;
      
      //First instruction
      //if (curAdr = fromAdr) break;
      
      cTblAdr := 0;
      jTblAdr := 0;
      Pos2 := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Table address - last 4 bytes of instruction
      jTblAdr := PInteger(Code + Pos2 - 4)^;
      //Analyze address range to find table cTbl
      if (Adr <= lastMovAdr) and (lastMovAdr < jTblAdr) then cTblAdr := lastMovAdr;
      //If exist cTblAdr, skip this table
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        for k := 0 to CNum-1 do
        Begin
          db := Code[Pos2];
          CTab[k] := db;
          wid := AddAsmLine(Adr, 'db          ' + IntToStr(Ord(db)), $22);
          Inc(row);
          if wid > maxwid then maxwid := wid;
          Inc(Pos2); 
          Inc(Adr);
        End;
      End;
      //Check transitions by negative register values (in Delphi 2009)
      //bool neg := false;
      //Adr1 := *((DWORD*)(Code + Pos - 4));
      //if (IsValidCodeAdr(Adr1) && IsFlagSet(cfLoc, Adr2Pos(Adr1))) neg := true;

      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, Pos2) then break;
        Adr1 := PInteger(Code + Pos2)^;
        //Validate Adr1
        if not IsValidCodeAdr(Adr1) or (Adr1 < fromAdr) then break;

        //Add row to assembler listing
        wid := AddAsmLine(Adr, 'dd          ' + Val2Str(Adr1,8), $22); 
        Inc(row);
        if wid > maxwid then maxwid := wid;
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        Inc(Pos2, 4); 
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := Pos2; 
      curAdr := Adr;
      continue;
    End;
    //----------------------------------
    //PosTry: xor reg, reg
    //        push ebp
    //        push offset @1
    //        push fs:[reg]
    //        mov fs:[reg], esp
    //        ...
    //@2:     ...
    //At @1 various variants:
    //----------------------------------
    //@1:     jmp @HandleFinally
    //        jmp @2
    //----------------------------------
    //@1:     jmp @HandleAnyException
    //        call DoneExcept
    //----------------------------------
    //@1:     jmp HandleOnException
    //        dd num
    //Next follows list of records like these
    //        dd offset ExceptionInfo
    //        dd offset ExceptionProc
    //----------------------------------
    if b1 = $68 then		//try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //check that next instruction is push fs:[reg] or retn
      if ((Code[NPos] = #$64) and
          (Code[NPos + 1] = #$FF) and
          (((Code[NPos + 2] >= #$30) and (Code[NPos + 2] <= #$37)) or (Code[NPos + 2] = #$75))
        ) or (Code[NPos] = #$C3) then
      Begin
        Adr := DisInfo.Immediate;      //Adr:=@1
        if IsValidCodeAdr(Adr) then
        Begin
          if Adr > lastAdr then lastAdr := Adr;
          Pos2 := Adr2Pos(Adr); 
          assert(Pos2 >= 0);
          delta := Pos2 - NPos;
          if delta >= 0 then // && delta < outRows)
          Begin
            if Code[Pos2] = #$E9 then //jmp Handle...
            Begin
              //Disassemble jmp
              instrLen1 := frmDisasm.Disassemble(Code + Pos2, Adr, @DisInfo, Nil);
              recN := GetInfoRec(DisInfo.Immediate);
              if Assigned(recN) then
              Begin
                if recN.SameName('@HandleFinally') then
                Begin
                  //jmp HandleFinally
                  Inc(Pos2, instrLen1); 
                  Inc(Adr, instrLen1);
                  //jmp @2
                  instrLen2 := frmDisasm.Disassemble(Code + Pos2, Adr, @DisInfo, Nil);
                  Inc(Adr, instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                  {
                  //@2
                  Adr1 := DisInfo.Immediate - 4;
                  Adr := PInteger(Code + Adr2Pos(Adr1))^;
                  if IsValidCodeAdr(Adr) and (Adr > lastAdr) then lastAdr := Adr;
                  }
                End
                else if recN.SameName('@HandleAnyException') or recN.SameName('@HandleAutoException') then
                Begin
                  //jmp HandleAnyException
                  Inc(Pos2, instrLen1); 
                  Inc(Adr, instrLen1);
                  //call DoneExcept
                  instrLen2 := frmDisasm.Disassemble(Code + Pos2, Adr, Nil, Nil);
                  Inc(Adr, instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                End
                else if recN.SameName('@HandleOnException') then
                Begin
                  //jmp HandleOnException
                  Inc(Pos2, instrLen1); 
                  Inc(Adr, instrLen1);
                  //Set flag cfETable to correct output data
                  SetFlag(cfETable, Pos2);
                  //dd num
                  num := PInteger(Code + Pos2)^;
                  Inc(Pos2, 4);
                  if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                  for k := 0 to num-1 do
                  Begin
                    //dd offset ExceptionInfo
                    Inc(Pos2, 4);
                    //dd offset ExceptionProc
                    Inc(Pos2, 4);
                  End;
                End;
              End;
            End;
          End;
          wid := AddAsmLine(curAdr, line, flags); 
          Inc(row);
          if wid > maxwid then maxwid := wid;
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
      End;
    End;

    //Name inside instruction (Fixip, ThreadVar)
    namei := '';
    comment := '';
    if NameInside then
    Begin
      recN := GetInfoRec(NameInsideAdr);
      if Assigned(recN) and recN.HasName then
      Begin
        namei := namei + recN.Name;
        if recN._type <> '' then namei := namei + ':' + recN._type;
      End;
    End;
    //comment
    recN := GetInfoRec(curAdr);
    if Assigned(recN) and Assigned(recN.pcode) then comment := MakeComment(recN.pcode);
    targetAdr := 0;
    if IsValidImageAdr(DisInfo.Immediate) then
    Begin
    	if not IsValidImageAdr(DisInfo.Offset) then targetAdr := DisInfo.Immediate;
    End
    else if IsValidImageAdr(DisInfo.Offset) then targetAdr := DisInfo.Offset;

    _name := '';
    pname := '';
    _type := '';
    ptype := '';
    if targetAdr<>0 then
    Begin
      _pos := Adr2Pos(targetAdr);
      if _pos >= 0 then
      Begin
        recN := GetInfoRec(targetAdr);
        if Assigned(recN) then
        Begin
          if recN.kind = ikResString then
            _name := recN.Name + ':PResStringRec'
          else
          Begin
            if recN.HasName then
            Begin
              _name := recN.Name;
              if recN._type <> '' then _type := recN._type;
            End
            else if IsFlagSet(cfProcStart, _pos) then
              _name := GetDefaultProcName(targetAdr);
          End;
        End
        //For Delphi2 pointers to VMT are distinct
        else if DelphiVersion = 2 then
        Begin
          recN := GetInfoRec(targetAdr + VmtSelfPtr);
          if Assigned(recN) and (recN.kind = ikVMT) and recN.HasName then
            _name := recN.Name;
        End;
        Adr := PInteger(Code + _pos)^;
        if IsValidImageAdr(Adr) then
        Begin
          recN := GetInfoRec(Adr);
          if Assigned(recN) then
          Begin
            if recN.HasName then
            Begin
              pname := recN.Name;
              ptype := recN._type;
            End
            else if IsFlagSet(cfProcStart, _pos) then
              pname := GetDefaultProcName(Adr);
          End;
        End;
      End
      else
      Begin
        idx := BSSInfos.IndexOf(Val2Str(targetAdr,8));
        if idx <> -1 then
        Begin
          recN := InfoRec(BSSInfos.Objects[idx]);
          _name := recN.Name;
          _type := recN._type;
        End;
      End;
    End;
    if SameText(comment, _name) then _name := '';
    if pname <> '' then
    Begin
      if comment <> '' then comment := comment + ' ';
      comment := comment + '^' + pname;
      if ptype <> '' then comment := comment + ':' + ptype;
    End
    else if _name <> '' then
    Begin
      if comment <> '' then comment := comment + ' ';
     	comment := comment + _name;
      if _type <> '' then comment := comment + ':' + _type;
    End;
    if (comment <> '') or (namei <> '') then
    Begin
      line := line + ';';
      if comment <> '' then line := line + comment;
      if namei <> '' then line := line + 'Begin' + namei + 'End;';
    End;
    if Length(line) > MAXLEN then line := Copy(line,1, MAXLEN) + '...';
    wid := AddAsmLine(curAdr, line, flags);
    Inc(row);
    if wid > maxwid then maxwid := wid;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
  CurProcSize := (curAdr + instrLen) - CurProcAdr;

  pcWorkArea.ActivePage := tsCodeView;
  lbCode.ScrollWidth := maxwid + 2;
  if selectedRow <> -1 then
  Begin
    lbCode.Selected[selectedRow] := true;
    lbCode.ItemIndex := selectedRow;
  End;
  if topIdx <> -1 then lbCode.TopIndex := topIdx;
  lbCode.ItemHeight := lbCode.Canvas.TextHeight('T');
  lbCode.Items.EndUpdate;

  ShowCodeXrefs(CurProcAdr, XrefIdx);

  //if (AnalyzeThread) AnalyzeThread.Resume();
end;

Procedure TFMain.AnalyzeMethodTable (pass:Integer; adr:Integer; Var Terminated:Boolean);
var
  sLen, paramFlags, paramCnt, cc,_tag:Byte;
  skipNext, dw, parOfs,count,exCount,flags,vIndex:Word;
  procPos, procAdr, paramType, resultType,spos:Integer;
  recN:InfoRec;
  clasName,paramName, metodName:AnsiString;
  vmtAdr, methodAdr,_pos,n,m,methodEntry:Integer;
Begin
  vmtAdr:=Adr - VmtSelfPtr;
  methodAdr := PInteger(Code + Adr2Pos(vmtAdr) + VmtMethodTable)^;
  if methodAdr=0 then Exit;

  clasName := GetClsName(Adr);
  _pos := Adr2Pos(methodAdr);
  count := PWord(Code + _pos)^; 
  Inc(_pos, 2);
  for n := 0 to count-1 do
  Begin
    if Terminated then Break;
    skipNext := PWord(Code + _pos)^;
    procAdr := PInteger(Code + _pos + 2)^;
    procPos := Adr2Pos(procAdr);
    sLen := Byte(Code[_pos + 6]);
    metodName := MakeString(Code + _pos + 7, sLen);
    AnalyzeProc(Pass, procAdr);

    if Pass = 1 then
    Begin
      recN := GetInfoRec(procAdr);
      if Assigned(recN) and (recN.kind <> ikConstructor) and (recN.kind <> ikDestructor) and (recN.kind <> ikClassRef) then
      with recN do
      Begin
        Name:=clasName + '.' + metodName;
        kind := ikProc;
        AddXref('D', Adr, 0);
        procInfo.AddArg($21, 0, 4, 'Self', clasName);
      End;
    End;
    Inc(_pos, skipNext);
  End;
  if DelphiVersion >= 2010 then
  Begin
    exCount := PWord(Code + _pos)^; 
    Inc(_pos, 2);
    for n := 0 to exCount-1 do
    Begin
      if Terminated then Break;
      methodEntry := PInteger(Code + _pos)^; 
      Inc(_pos, 4);
      flags := PWord(Code + _pos)^; 
      Inc(_pos, 2);
      vIndex := PWord(Code + _pos)^; 
      Inc(_pos, 2);
      spos := _pos;
      _pos := Adr2Pos(methodEntry);
      //Length
      skipNext := PWord(Code + _pos)^; 
      Inc(_pos, 2);
      procAdr := PInteger(Code + _pos)^; 
      Inc(_pos, 4);
      procPos := Adr2Pos(procAdr);
      sLen := Byte(Code[_pos]);
      metodName := MakeString(Code + _pos + 1, sLen); 
      Inc(_pos, sLen + 1);
      if procAdr = Adr then continue;

      recN := GetInfoRec(procAdr);
      //IMHO it means that methods are pure virtual calls and must be readed in child classes
      if Assigned(recN) and (recN.kind = ikVMT) then
      Begin
        _pos := spos;
        continue;
      End;
      AnalyzeProc(Pass, procAdr);
      recN := GetInfoRec(procAdr);
      if Pass = 1 then
        if Assigned(recN) and Assigned(recN.procInfo) and (recN.kind <> ikConstructor) and (recN.kind <> ikDestructor) then //recN.kind !:= ikClassRef
        with recN do
        Begin
          SetName(clasName + '.' + metodName);
          kind := ikProc;
          AddXref('D', Adr, 0);
          procInfo.AddArg($21, 0, 4, 'Self', clasName);
        End;
      if _pos - Adr2Pos(methodEntry) < skipNext then
      Begin
        //Version
        Inc(_pos);
        cc := Byte(Code[_pos]);
        Inc(_pos);
        resultType := PInteger(Code + _pos)^; 
        Inc(_pos, 4);
        //ParOff
        Inc(_pos, 2);
        if Pass = 1 then
          if Assigned(recN) and Assigned(recN.procInfo) and (recN.kind <> ikConstructor) and (recN.kind <> ikDestructor) then //recN.kind !:= ikClassRef)
          Begin
            if resultType<>0 then
            Begin
              recN.kind := ikFunc;
              recN._type := GetTypeName(resultType);
            End;
            if cc <> $FF then recN.procInfo.flags := recN.procInfo.flags OR cc;
          End;
        paramCnt := Byte(Code[_pos]);
        Inc(_pos);
        if Pass = 1 then
          if Assigned(recN) and Assigned(recN.procInfo) then
          Begin
            recN.procInfo.DeleteArgs;
            if paramCnt=0 then recN.procInfo.AddArg($21, 0, 4, 'Self', clasName);
          End;
        for m := 0 to paramCnt-1 do 
        Begin
          if Terminated then Break;
          paramFlags := Byte(Code[_pos]);
          Inc(_pos);
          paramType := PInteger(Code + _pos)^; 
          Inc(_pos, 4);
          //ParOff
          parOfs := PWord(Code + _pos)^; 
          Inc(_pos, 2);
          sLen := Byte(Code[_pos]);
          paramName := MakeString(Code + _pos + 1, sLen); 
          Inc(_pos, sLen + 1);
          //AttrData
          dw := PWord(Code + _pos)^;
          Inc(_pos, dw); //ATR!!
          if (paramFlags and $40)<>0 then continue; //Result
          if Pass = 1 then
            if Assigned(recN) and Assigned(recN.procInfo) then //recN.kind !:= ikClassRef)
            Begin
              _tag := $21;
              if (paramFlags and 1)<>0 then _tag := $22;
              recN.procInfo.AddArg(_tag, parOfs, 4, paramName, GetTypeName(paramType));
            End;
        End;
      End
      else
      Begin
        cc := $FF;
        paramCnt := 0;
      End;
      _pos := spos;
    End;
  End;
end;

Procedure TFMain.AnalyzeDynamicTable (pass:Integer; adr:Integer; Var Terminated:Boolean);
var
  skip:Boolean;
  i,vmtAdr, DynamicAdr,_pos,post,procAdr,procPos:Integer;
  num:Word;
  clsName:AnsiString;
  recN:InfoRec;
Begin
  vmtAdr:=Adr - VmtSelfPtr;
  DynamicAdr := PInteger(Code + Adr2Pos(vmtAdr) + VmtDynamicTable)^;
  if DynamicAdr=0 then Exit;
  clsName := GetClsName(Adr);
  _pos := Adr2Pos(DynamicAdr);
  Num := PWord(Code + _pos)^;
  Inc(_pos, 2);
  post := _pos + 2 * Num;
  for i := 0 to Num-1 Do
  Begin
    If Terminated then Break;
    //WORD Msg
    Inc(_pos, 2);
    procAdr := PInteger(Code + post)^;
    procPos := Adr2Pos(procAdr);
    if procPos=0 then continue; //Something wrong!
    skip := (Code[procPos] = #0) and (Code[procPos + 1] = #0);
    if not skip then AnalyzeProc(Pass, procAdr);
    if (Pass = 1) and not skip then
    begin
      recN := GetInfoRec(procAdr);
      if Assigned(recN) then
      with recN do
      begin
        kind := ikProc;
        procInfo.flags := procInfo.flags or PF_DYNAMIC;
        AddXref('D', Adr, 0);
        procInfo.AddArg($21, 0, 4, 'Self', clsName);
      end;
    end;
    Inc(post,4);
  end;
end;

Procedure TFMain.AnalyzeVirtualTable (pass:Integer; adr:Integer; Var Terminated:Boolean);
var
  _pos,n,m,procAdr,procPos,parentAdr,vmtAdr,stopAt,pAdr:Integer;
  skip:Boolean;
  recN,recN1:InfoRec;
  recM:PMethodRec;
  procName:AnsiString;
Begin
  parentAdr := GetParentAdr(Adr);
  vmtAdr := Adr - VmtSelfPtr;
  stopAt := GetStopAt(vmtAdr);
  if vmtAdr = stopAt then Exit;
  _pos := Adr2Pos(vmtAdr) + VmtParent + 4;
  n := VmtParent + 4;
  while Not Terminated do
  begin
    if Pos2Adr(_pos) = stopAt then break;
    procAdr := PInteger(Code + _pos)^;
    procPos := Adr2Pos(procAdr);
    skip := (Code[procPos] = #0) and (Code[procPos + 1] = #0);
    if not skip then AnalyzeProc(Pass, procAdr);
    recN := GetInfoRec(procAdr);
    if Assigned(recN) then
    begin
      if (Pass = 1) and not skip then
      begin
        recN.procInfo.flags := recN.procInfo.flags or PF_VIRTUAL;
        recN.AddXref('D', Adr, 0);
      End;
      pAdr := parentAdr;
      while (pAdr<>0) and not Terminated do
      begin
        recN1 := GetInfoRec(pAdr);
        //Look at parent class methods
        if Assigned(recN1) and Assigned(recN1.vmtInfo.methods) then
          for m := 0 to recN1.vmtInfo.methods.Count-1 do
          begin
            recM := recN1.vmtInfo.methods[m];
            if recM._abstract and (recM.kind = 'V') and (recM.id = n) and (recM.name = '') then
            begin
              procName := recN.Name;
              if (procName <> '') And not SameText(procName, '@AbstractError') then
                recM.name := GetClsName(pAdr) + '.' + ExtractProcName(procName);
              break;
            End;
          end;
        pAdr := GetParentAdr(pAdr);
      end;
    end;
    Inc(n, 4);
    Inc(_pos, 4);
  end;
end;

Procedure TFMain.AnalyzeProc (pass:Integer; procAdr:Integer);
Begin
if procAdr=4705128 then is_debug:=True;
  Case pass of
    0: AnalyzeProcInitial(procAdr);
    1: AnalyzeProc1(procAdr, #0, 0, 0, false);
    2: AnalyzeProc2(procAdr, true, true);
  End;
is_debug:=False;
end;

//Scan proc calls
Function TFMain.AnalyzeProcInitial (fromAdr:Integer):Integer;
var
  op, b1, b2:Byte;
  num, instrLen, instrLen1, instrLen2, _procSize,cTblAdr,jTblAdr:Integer;
  fromPos, curPos, curAdr, lastAdr, Adr, Adr1, Pos2, lastMovAdr:Integer;
  CNum,k,NPos,delta:Integer;
  recN:InfoRec;
  DisInfo:TDisInfo;
Begin
  lastAdr:=0;
  lastMovAdr:=0;
  Result:=0;
  fromPos := Adr2Pos(fromAdr);
  if (fromPos < 0)
    or IsFlagSet(cfPass0, fromPos) 
    or IsFlagSet(cfEmbedded, fromPos)
    or IsFlagSet(cfExport, fromPos) then Exit;

  b1 := Byte(Code[fromPos]);
  b2 := Byte(Code[fromPos + 1]);
  if (b1=0) and (b2=0) then Exit;

  SetFlag(cfProcStart or cfPass0, fromPos);

  //Don't analyze imports
  if IsFlagSet(cfImport, fromPos) then Exit;
  _procSize := GetProcSize(fromAdr);
  curPos := fromPos; 
  curAdr := fromAdr;
  while true do
  Begin
    if curAdr >= Integer(CodeBase) + TotalSize then break;
    //For example, cfProcEnd can be set for interface procs
    if (_procSize<>0) and (curAdr - fromAdr >= _procSize) then break;
    //Skip exception table
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      Inc(curPos, 4 + 8*num); 
      Inc(curAdr, 4 + 8*num);
      continue;
    End;

    b1 := Byte(Code[curPos]);
    b2 := Byte(Code[curPos + 1]);
    if (b1=0) and (b2=0) and (lastAdr=0) then break;
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) break;
    if instrLen=0 then
    Begin
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    op := frmDisasm.GetOp(DisInfo.Mnem);
    //Code
    SetFlags(cfCode, curPos, instrLen);
    //Instruction begin
    SetFlag(cfInstruction, curPos);
    if curAdr >= lastAdr then lastAdr := 0;

    //End of procedure
    if DisInfo.Ret and ((lastAdr=0) or (curAdr = lastAdr)) then break;
    if op = OP_MOV then lastMovAdr := DisInfo.Offset;
    if (b1 = $FF) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      if not IsValidCodeAdr(DisInfo.Offset) then break;
      //First instruction
      //if curAdr = fromAdr then break;
      cTblAdr := 0;
      jTblAdr := 0;
      Pos2 := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Table address - last 4 bytes of instruction
      jTblAdr := PInteger(Code + Pos2 - 4)^;
      //Scan gap to find table cTbl
      if (Adr <= lastMovAdr) and (lastMovAdr < jTblAdr) then cTblAdr := lastMovAdr;
      //If exists cTblAdr skip it
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        Inc(Pos2, CNum); 
        Inc(Adr, CNum);
      End;
      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, Pos2) then break;
        Adr1 := PInteger(Code + Pos2)^;
        //Validate Adr1
        if not IsValidCodeAdr(Adr1) or (Adr1 < fromAdr) then break;
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        Inc(Pos2, 4); 
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := Pos2;
      curAdr := Adr;
      continue;
    End;
    if b1 = $68 then		//try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //Check that next instruction is push fs:[reg] or retn
      if ((Code[NPos] = #$64) and (Code[NPos + 1] = #$FF) and (Code[NPos + 2] in [#$30..#$37,#$75]))
        or (Code[NPos] = #$C3) then
      Begin
        Adr := DisInfo.Immediate;      //Adr:=@1
        if IsValidCodeAdr(Adr) then
        Begin
          if Adr > lastAdr then lastAdr := Adr;
          Pos2 := Adr2Pos(Adr);
          delta := Pos2 - NPos;
          if (delta >= 0) and (delta < MAX_DISASSEMBLE) then
          Begin
            if Code[Pos2] = #$E9 then //jmp Handle...
            Begin
              //Disassemble jmp
              instrLen1 := frmDisasm.Disassemble(Code + Pos2, Adr, @DisInfo, Nil);
              recN := GetInfoRec(DisInfo.Immediate);
              if Assigned(recN) then
              Begin
                if recN.SameName('@HandleFinally') then
                Begin
                  //jmp HandleFinally
                  Inc(Pos2, instrLen1); 
                  Inc(Adr, instrLen1);
                  //jmp @2
                  instrLen2 := frmDisasm.Disassemble(Code + Pos2, Adr, @DisInfo, Nil);
                  Inc(Adr, instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                  {
                  //@2
                  Adr1 := DisInfo.Immediate - 4;
                  Adr := PInteger(Code + Adr2Pos(Adr1))^;
                  if Adr > lastAdr then lastAdr := Adr;
                  }
                End
                else if recN.SameName('@HandleAnyException') or recN.SameName('@HandleAutoException') then
                Begin
                  //jmp HandleAnyException
                  Inc(Pos2, instrLen1); 
                  Inc(Adr, instrLen1);
                  //call DoneExcept
                  instrLen2 := frmDisasm.Disassemble(Code + Pos2, Adr, Nil, Nil);
                  Inc(Adr, instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                End
                else if recN.SameName('@HandleOnException') then
                Begin
                  //jmp HandleOnException
                  Inc(Pos2, instrLen1); 
                  Inc(Adr, instrLen1);
                  //Set flag cfETable to correctly output data
                  SetFlag(cfETable, Pos2);
                  //dd num
                  num := PInteger(Code + Pos2)^; 
                  Inc(Pos2, 4);
                  if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                  for k := 0 to num-1 do
                  Begin
                    //dd offset ExceptionInfo
                    Inc(Pos2, 4);
                    //dd offset ExceptionProc
                    Inc(Pos2, 4);
                  End;
                End;
              End;
            End;
          End;
          Inc(curPos, instrLen);
          Inc(curAdr, instrLen);
          continue;
        End;
      End;
    End;
    if DisInfo.Call then  //call sub_XXXXXXXX
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        recN := GetInfoRec(Adr);
        //If @Halt0 - end of procedure
        if Assigned(recN) and recN.SameName('@Halt0') then
        Begin
          if (fromAdr = EP) and (lastAdr=0) then break;
        End;
        AnalyzeProcInitial(Adr);
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if op = OP_JMP then
    Begin
      if curAdr = fromAdr then Exit;
      if DisInfo.OpType[0] = otMEM then
      Begin
        if (Adr2Pos(DisInfo.Offset) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then Exit;
      End;
      if DisInfo.OpType[0] = otIMM then
      Begin
        Adr := DisInfo.Immediate;
        if (Adr2Pos(Adr) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then Exit;
        if (GetSegmentNo(Adr) <> 0) and (GetSegmentNo(fromAdr) <> GetSegmentNo(Adr)) and ((lastAdr=0) or (curAdr = lastAdr)) then Exit;
        if (Adr < fromAdr) and ((lastAdr=0) or (curAdr = lastAdr)) then
        begin
          Result:=Adr;
          Exit;
        end;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End
    else if DisInfo.Conditional then
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
end;

Function TFMain.CodeGetTargetAdr (line:AnsiString; trgAdr:PInteger):Integer;
var
  p,n, wid, instrlen,	adr, targetAdr:Integer;
  cursorPos:TPoint;
  canva:TCanvas;
  DisInfo:TDisInfo;
Begin
  canva := lbCode.Canvas;
  trgAdr^ := 0;
  Result:=0;
  line[1]:=' ';
  //If db - no address
  if PosEx(' db ',Line,2)<>0 then Exit;
  //If dd - address
  p := PosEx(' dd ',Line,2);
  if p<>0 then sscanf(PAnsiChar(Line)+p+4,'%lX',[@targetAdr]);
  if not IsValidImageAdr(targetAdr) then
  Begin
    sscanf(PAnsiChar(Line),'%lX',[@adr]);
    instrlen := frmDisasm.Disassemble(Code + Adr2Pos(adr), adr, @DisInfo, Nil);
    if instrlen=0 then Exit;
    if IsValidImageAdr(DisInfo.Immediate) then
    Begin
      if not IsValidImageAdr(DisInfo.Offset) then targetAdr := DisInfo.Immediate;
    End
    else if IsValidImageAdr(DisInfo.Offset) then targetAdr := DisInfo.Offset;
  End;
  if not IsValidImageAdr(targetAdr) then
  Begin
    cursorPos := lbCode.ScreenToClient(Mouse.CursorPos);
    wid:=0;
    n:=2;
    While n <= Length(Line) do
    Begin
      if wid >= cursorPos.x then
      Begin
        while n >= 2 do
        Begin
          if Line[n] in [' ',',','[','+'] then
          Begin
            sscanf(PAnsiChar(Line)+n+1,'%lX',[@targetAdr]);
            break;
          End;
          Dec(n);
        End;
        break;
      End;
      Inc(wid, canva.TextWidth(Line[n]));
      Inc(n);
    End;
  End;
  if IsValidImageAdr(targetAdr) then trgAdr^ := targetAdr;
  Result:=DisInfo.MemSize;
end;

procedure TFMain.lbCodeDblClick(Sender : TObject);
var
  _pos, idx, size:Integer;
  adr, targetAdr:Integer;
  recN:InfoRec;
  tInfo:MTypeInfo;
  rec:PROCHISTORYREC;
  txt:AnsiString;
  use:TWordDynArray;
begin
  if lbCode.ItemIndex <= 0 then Exit;

  txt := lbCode.Items[lbCode.ItemIndex];
  size := CodeGetTargetAdr(txt, @targetAdr);
  if IsValidImageAdr(targetAdr) then
  Begin
    _pos := Adr2Pos(targetAdr);
    if _pos = -2 then Exit;
    if _pos = -1 then
    Begin
      ShowMessage('BSS');
      Exit;
    End
    else if IsFlagSet(cfImport, _pos) then
    Begin
      ShowMessage('Import');
      Exit;
    End
    //RTTI
    else if IsFlagSet(cfRTTI, _pos) then
    Begin
      FTypeInfo.ShowRTTI(targetAdr);
      Exit;
    End
    //if start of procedure, show it
    else if IsFlagSet(cfProcStart, _pos) then
    Begin
      rec.adr := CurProcAdr;
      rec.itemIdx := lbCode.ItemIndex;
      rec.xrefIdx := lbCXrefs.ItemIndex;
      rec.topIdx := lbCode.TopIndex;
      ShowCode(Pos2Adr(_pos), targetAdr, -1, -1);
      CodeHistoryPush(@rec);
      Exit;
    End;

    recN := GetInfoRec(targetAdr);
    if Assigned(recN) then
    Begin
      if (recN.kind = ikVMT) and tsClassView.TabVisible then
      Begin
        ShowClassViewer(targetAdr);
        Exit;
      End
      else if recN.kind = ikResString then
      Begin
        FStringInfo.memStringInfo.Clear;
        FStringInfo.Caption := 'ResString context';
        FStringInfo.memStringInfo.Lines.Add(recN.rsInfo);
        FStringInfo.ShowModal;
        Exit;
      End
      else if recN.HasName then
      Begin
        use := KBase.GetTypeUses(PAnsiChar(recN.Name));
        idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(recN.Name));
        use:=Nil;
        if idx <> -1 then
        Begin
          idx := KBase.TypeOffsets[idx].NamId;
          if KBase.GetTypeInfo(idx, INFO_FIELDS or INFO_PROPS or INFO_METHODS or INFO_DUMP, tInfo) then
          Begin
            FTypeInfo.ShowKbInfo(tInfo);
            //as delete tInfo;
            Exit;
          End;
        End;
      End;
    End;
    //may be .
    adr := PInteger(Code + _pos)^;
    if IsValidImageAdr(adr) then
    Begin
      recN := GetInfoRec(adr);
      if Assigned(recN) then
      Begin
        if recN.kind = ikResString then
        Begin
          FStringInfo.memStringInfo.Clear;
          FStringInfo.Caption := 'ResString context';
          FStringInfo.memStringInfo.Lines.Add(recN.rsInfo);
          FStringInfo.ShowModal;
          Exit;
        End;
      End;
    End;

    //if in current proc
    if (CurProcAdr <= targetAdr) and (targetAdr < CurProcAdr + CurProcSize) then
    Begin
      rec.adr := CurProcAdr;
      rec.itemIdx := lbCode.ItemIndex;
      rec.xrefIdx := lbCXrefs.ItemIndex;
      rec.topIdx := lbCode.TopIndex;
      ShowCode(CurProcAdr, targetAdr, lbCXrefs.ItemIndex, -1);
      CodeHistoryPush(@rec);
      Exit;
    End;
    //Else show explorer
    FExplorer.tsCode.TabVisible := true;
    FExplorer.ShowCode(targetAdr, 1024);
    FExplorer.tsData.TabVisible := true;
    FExplorer.ShowData(targetAdr, 1024);
    FExplorer.tsString.TabVisible := true;
    FExplorer.ShowString(targetAdr, 1024);
    FExplorer.tsText.TabVisible := false;
    FExplorer.pc1.ActivePage := FExplorer.tsData;
    FExplorer.WAlign := -4;

    FExplorer.btnDefCode.Enabled := true;
    if IsFlagSet(cfCode, _pos) then FExplorer.btnDefCode.Enabled := false;
    FExplorer.btnUndefCode.Enabled := false;
    if IsFlagSet(cfCode or cfData, _pos) then FExplorer.btnUndefCode.Enabled := true;
    if FExplorer.ShowModal = mrOk then
    Begin
      if FExplorer.DefineAs = DEFINE_AS_CODE then
      Begin
        //Delete any information at this address
        recN := GetInfoRec(Pos2Adr(_pos));
        if Assigned(recN) then recN.Free;
        //Create new info about proc
        recN := InfoRec.Create(_pos, ikRefine);

        //AnalyzeProcInitial(targetAdr);
        AnalyzeProc1(targetAdr, #0, 0, 0, false);
        AnalyzeProc2(targetAdr, true, true);
        AnalyzeArguments(targetAdr);
        AnalyzeProc2(targetAdr, true, true);

        if not ContainsUnexplored(GetUnit(targetAdr)) then ShowUnits(true);
        ShowUnitItems(GetUnit(targetAdr), lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
        ShowCode(targetAdr, 0, -1, -1);
      End;
    End;
  End
  //Try picode
  else
  Begin
    sscanf(PAnsiChar(txt)+2,'%lX',[@adr]);
    recN := GetInfoRec(adr);
    if Assigned(recN) and Assigned(recN.pcode) and IsValidCodeAdr(recN.pcode.Offset) then
    Begin
      _pos := Adr2Pos(recN.pcode.Offset);
      if IsFlagSet(cfProcStart, _pos) then
      Begin
        rec.adr := CurProcAdr;
        rec.itemIdx := lbCode.ItemIndex;
        rec.xrefIdx := lbCXrefs.ItemIndex;
        rec.topIdx := lbCode.TopIndex;
        ShowCode(Pos2Adr(_pos), targetAdr, -1, -1);
        CodeHistoryPush(@rec);
        Exit;
      End;
    End;
  End;
end;

procedure TFMain.bEPClick(Sender : TObject);
var
  rec:PROCHISTORYREC;
begin
  rec.adr := CurProcAdr;
  rec.itemIdx := lbCode.ItemIndex;
  rec.xrefIdx := lbCXrefs.ItemIndex;
  rec.topIdx := lbCode.TopIndex;
  ShowCode(EP, 0, -1, -1);
  CodeHistoryPush(@rec);
end;

procedure TFMain.GoToAddress;
var
  _pos, gotoAdr:Integer;
  sAdr:AnsiString;
  rec:PROCHISTORYREC;
begin
  //if lbCode.ItemIndex <= 0 then Exit;

  sAdr := InputDialogExec('Enter Address', 'Address:', '');
  if sAdr <> '' then
  begin
    gotoAdr:=StrtoIntDef('$'+Trim(sAdr),0);
    if IsValidCodeAdr(gotoAdr) then
    begin
      _pos := Adr2Pos(gotoAdr);
      //Если импорт - ничего не отображаем
      if IsFlagSet(cfImport, _pos) then Exit;
      //Ищем, куда попадает адрес
      while _pos >= 0 do
      begin
        //Нашли начало процедуры
        if IsFlagSet(cfProcStart, _pos) then
        begin
          rec.adr := CurProcAdr;
          rec.itemIdx := lbCode.ItemIndex;
          rec.xrefIdx := lbCXrefs.ItemIndex;
          rec.topIdx := lbCode.TopIndex;
          ShowCode(Pos2Adr(_pos), gotoAdr, -1, -1);
          CodeHistoryPush(@rec);
          break;
        End;
        //Нашли начало типа
        if IsFlagSet(cfRTTI, _pos) then
        begin
          FTypeInfo.ShowRTTI(Pos2Adr(_pos));
          break;
        end;
        Dec(_pos);
      end;
    End;
  End;
end;

procedure TFMain.miGoToClick(Sender : TObject);
begin
  GoToAddress;
end;

procedure TFMain.miExploreAdrClick(Sender : TObject);
var
  _pos,size,viewAdr:Integer;
  txt,sAdr:AnsiString;
  recN:InfoRec;
begin
  txt:='';
  if lbCode.ItemIndex <= 0 then Exit;
  size := CodeGetTargetAdr(lbCode.Items[lbCode.ItemIndex], @viewAdr);
  if viewAdr<>0 then txt := Val2Str(viewAdr,8);
  sAdr := InputDialogExec('Enter Address', 'Address:', txt);
  if sAdr <> '' then
  Begin
    viewAdr:=StrToIntDef('$'+Trim(sAdr),0);
    if IsValidImageAdr(viewAdr) then
    Begin
      _pos := Adr2Pos(viewAdr);
      if _pos = -2 then Exit;
      if _pos = -1 then
      Begin
        ShowMessage('BSS');
        Exit;
      End;
      FExplorer.tsCode.TabVisible := true;
      FExplorer.ShowCode(viewAdr, 1024);
      FExplorer.tsData.TabVisible := true;
      FExplorer.ShowData(viewAdr, 1024);
      FExplorer.tsString.TabVisible := true;
      FExplorer.ShowString(viewAdr, 1024);
      FExplorer.tsText.TabVisible := false;
      FExplorer.pc1.ActivePage := FExplorer.tsCode;
      FExplorer.WAlign := -4;

      FExplorer.btnDefCode.Enabled := true;
      if IsFlagSet(cfCode, _pos) then FExplorer.btnDefCode.Enabled := false;
      FExplorer.btnUndefCode.Enabled := false;
      if IsFlagSet(cfCode or cfData, _pos) then FExplorer.btnUndefCode.Enabled := true;
      if FExplorer.ShowModal = mrOk then
        if FExplorer.DefineAs = DEFINE_AS_CODE then
        begin
          //Delete any information at this address
          recN := GetInfoRec(viewAdr);
          if Assigned(recN) then recN.Free;
          //Create new info about proc
          recN := InfoRec.Create(_pos, ikRefine);

          //AnalyzeProcInitial(viewAdr);
          AnalyzeProc1(viewAdr, #0, 0, 0, false);
          AnalyzeProc2(viewAdr, true, true);
          AnalyzeArguments(viewAdr);
          AnalyzeProc2(viewAdr, true, true);

          if not ContainsUnexplored(GetUnit(viewAdr)) then ShowUnits(true);
          ShowUnitItems(GetUnit(viewAdr), lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
          ShowCode(viewAdr, 0, -1, -1);
        end;
    End;
  End;
end;

procedure TFMain.NamePosition;
var
	_pos, _idx, size,	adr, nameAdr:Integer;
  recN:InfoRec;
  line, txt, sNameType, newName, newType:AnsiString;
begin
  txt:='';
  if lbCode.ItemIndex >= 1 then
  Begin
    line := lbCode.Items[lbCode.ItemIndex];
    size := CodeGetTargetAdr(line, @nameAdr);
  End;
  if IsValidImageAdr(nameAdr) then
  Begin
    _pos := Adr2Pos(nameAdr);
    recN := GetInfoRec(nameAdr);
    //VMT
    if Assigned(recN) and (recN.kind = ikVMT) then Exit;

    //if size = 4 then
    //Begin
      adr := PInteger(Code + _pos)^;
      if IsValidImageAdr(adr) then nameAdr := adr;
    //End;
  End
  else nameAdr := CurProcAdr;
  _pos := Adr2Pos(nameAdr);
  recN := GetInfoRec(nameAdr);
  if Assigned(recN) and recN.HasName then
  Begin
    txt := recN.Name;
    if recN._type <> '' then txt := recN.Name + ':' + recN._type;
  End;

  sNameType := InputDialogExec('Enter Name:Type (at ' + Val2Str(nameAdr,8) + ')', 'Name:Type', txt);
  if sNameType <> '' then
  Begin
    if Pos(':',sNameType)<>0 then
    Begin
      newName := Trim(ExtractName(sNameType));
      newType := Trim(ExtractType(sNameType));
    End
    else
    Begin
      newName := sNameType;
      newType := '';
    End;
    if newName = '' then Exit;

    //If call
    if (_pos >= 0) and IsFlagSet(cfProcStart, _pos) then
    Begin
      if not Assigned(recN) then recN := InfoRec.Create(_pos, ikRefine);
      recN.kind := ikProc;
      recN.Name:=newName;
      if newType <> '' then
      Begin
        recN.kind := ikFunc;
        recN._type := newType;
      End;
    End
    else
    Begin
      if _pos >= 0 then
      Begin
        //Address points to Data
        if not Assigned(recN) then recN := InfoRec.Create(_pos, ikUnknown);
        recN.Name:=newName;
        if newType <> '' then recN._type := newType;
      End
      else
      Begin
        _idx := BSSInfos.IndexOf(Val2Str(nameAdr,8));
        if _idx <> -1 then
        Begin
          recN := InfoRec(BSSInfos.Objects[_idx]);
          recN.Name:=newName;
          recN._type := newType;
        End
        else recN := AddToBSSInfos(nameAdr, newName, newType);
      End;
    End;
    RedrawCode;
    ShowUnitItems(GetUnit(CurUnitAdr), lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
    ProjectModified := true;
  End;
end;

procedure TFMain.miNameClick(Sender : TObject);
begin
  NamePosition;
end;

Function TFMain.GetNodeByName (AName:AnsiString):TTreeNode;
var
  n:Integer;
  txt:AnsiString;
Begin
  for n := 0 to tvClassesFull.Items.Count-1 do
  begin
    Result := tvClassesFull.Items[n];
    txt := Result.text;
    if AName[1] <> ' ' then
    begin
      if (txt[1] <> '<') and (txt[1] = AName[1]) and (txt[2] = AName[2]) and (Pos(AName,txt) = 1) then Exit;
    end
    else
    begin
      if (txt[1] <> '<') and (Pos(AName,txt)<>0) then Exit;
    end;
  end;
  Result:=Nil;
end;

Procedure TFMain.ClearTreeNodeMap;
Begin
  tvClassMap.clear;
end;

Function TFMain.FindTreeNodeByName (Const Aname:AnsiString):TTreeNode;
var
  idx:Integer;
Begin
  idx:=tvClassMap.IndexOf(Aname);
  if idx <> -1 then Result:=TTreeNode(tvClassMap.Objects[idx])
    else Result:=Nil;
end;

Procedure TFMain.AddTreeNodeWithName (node:TTreeNode; Const Aname:AnsiString);
Begin
  tvClassMap.AddObject(Aname,node);
end;

Procedure TFMain.ShowClassViewer (VmtAdr:Integer);
var
  vmtProc:Boolean;
  _dx, _bx, _si:Word;
  v,m, size,n,cnt, vmtOfs, _pos,ps,instrlen,autoNum,methodsNum,virtualsNum:Integer;
  intfsNum,parentAdr, adr, _adr,vAdr, iAdr,fieldsNum,dynamicsNum:Integer;
  vmtAdresses:Array [0..1023] of Integer;
  item,text,SelName, line, _name,clasName:AnsiString;
  fieldsNode,autoNode,intfsNode,selNode,node,methodsNode,dynamicsNode,virtualsNode:TTreeNode;
  recN:InfoRec;
  recM:PMethodRec;
  fInfo:FieldInfo;
  disInfo:TDisInfo;
  fieldsList:TList;
  tmpList:TStringList;
Begin
  adr:=VmtAdr;
  SelName:=GetClsName(VmtAdr);
  selNode:=Nil;
  if (SelName = '') or not IsValidImageAdr(VmtAdr) then Exit;
  if not tsClassView.Enabled then Exit;
  if ClassTreeDone then
  Begin
    node := GetNodeByName(SelName + ' #' + Val2Str(adr,8) + ' Sz=');
    if Assigned(node) then
    Begin
      node.Selected := true;
      node.Expanded := true;
      tvClassesFull.TopItem := node;
    End;
  End;

  fieldsList := TList.Create;
  tmpList := TStringList.Create;
  tmpList.Sorted := false;
  tvClassesShort.Items.Clear; 
  node := Nil;
  n:=0;
  while true do
  Begin
    parentAdr := GetParentAdr(adr);
    vmtAdresses[n] := adr;
    if parentAdr=0 then
    Begin
      while n >= 0 do
      Begin
        adr := vmtAdresses[n];
        Dec(n);
        clasName := GetClsName(adr);
        size := GetClassSize(adr); 
        if DelphiVersion >= 2009 then Inc(size, 4);
        text := clasName + ' #' + Val2Str(adr,8) + ' Sz=' + Val2Str(size);
        if not Assigned(node) then //Root
          node := tvClassesShort.Items.Add(Nil, text)
        else
          node := tvClassesShort.Items.AddChild(node, text);
        if (adr = VmtAdr) and SameText(clasName, SelName) then selNode := node;

        //Interfaces
        intfsNum := LoadIntfTable(adr, tmpList);
        if intfsNum<>0 then
          for m := 0 to intfsNum-1 do
          Begin
            item := tmpList[m];
            sscanf(PAnsiChar(item),'%lX',[@vAdr]);
            if IsValidCodeAdr(vAdr) then
            Begin
              ps := Pos(' ',item);
              intfsNode := tvClassesShort.Items.AddChild(node, '<I> ' + Copy(item,ps + 1, Length(item)));
              cnt := 0;
              ps := Adr2Pos(vAdr);
              v:=0;
              while true do
              Begin
                if IsFlagSet(cfVTable, ps) then Inc(cnt);
                if cnt = 2 then break;
                iAdr := PInteger(Code + ps)^;
                _adr := iAdr;
                _pos := Adr2Pos(_adr);
                vmtProc := false; 
                vmtOfs := 0;
                _dx := 0; 
                _bx := 0; 
                _si := 0;
                while true do
                Begin
                  instrlen := frmDisasm.Disassemble(Code + _pos, _adr, @disInfo, Nil);
                  if ((disInfo.OpType[0] = otMEM) or (disInfo.OpType[1] = otMEM)) and
                    (disInfo.BaseReg <> 20) //to exclude instruction 'xchg reg, [esp]'
                    then vmtOfs := disInfo.Offset;
                  if (disInfo.OpType[0] = otREG) and (disInfo.OpType[1] = otIMM) then
                  case disInfo.OpRegIdx[0] of
                    10: _dx := disInfo.Immediate;
                    11: _bx := disInfo.Immediate;
                    14: _si := disInfo.Immediate;
                  End;
                  if disInfo.Call then
                  Begin
                    recN := GetInfoRec(disInfo.Immediate);
                    if Assigned(recN) then
                    Begin
                      if recN.SameName('@CallDynaInst') or recN.SameName('@CallDynaClass') then
                      Begin
                        if DelphiVersion <= 5 then
                          GetDynaInfo(adr, _bx, iAdr)
                        else
                          GetDynaInfo(adr, _si, iAdr);
                        break;
                      End
                      else if recN.SameName('@FindDynaInst') or recN.SameName('@FindDynaClass') then
                      Begin
                        GetDynaInfo(adr, _dx, iAdr);
                        break;
                      End;
                    End;
                  End;
                  if disInfo.Branch and not disInfo.Conditional then
                  Begin
                    if IsValidImageAdr(disInfo.Immediate) then
                      iAdr := disInfo.Immediate
                    else
                    Begin
                      vmtProc := true;
                      iAdr := PInteger(Code + Adr2Pos(VmtAdr - VmtSelfPtr + vmtOfs))^;
                      recM := GetMethodInfo(VmtAdr, 'V', vmtOfs);
                      if Assigned(recM) then _name := recM.name;
                    End;
                    break;
                  End
                  else if disInfo.Ret then
                  Begin
                    vmtProc := true;
                    iAdr := PInteger(Code + Adr2Pos(VmtAdr - VmtSelfPtr + vmtOfs))^;
                    recM := GetMethodInfo(VmtAdr, 'V', vmtOfs);
                    if Assigned(recM) then _name := recM.name;
                    break;
                  End;
                  Inc(_pos, instrlen); 
                  Inc(_adr, instrlen);
                End;
                if not vmtProc and IsValidImageAdr(iAdr) then
                Begin
                  recN := GetInfoRec(iAdr);
                  if Assigned(recN) and recN.HasName then
                    _name := recN.Name
                  else
                    _name := '';
                End;
                line := 'I' + Val2Str(v,4) + ' #' + Val2Str(iAdr,8);
                if _name <> '' then line := line + ' ' + _name;
                tvClassesShort.Items.AddChild(intfsNode, line);
                Inc(ps, 4);
                Inc(v, 4);
              End;
            End
            else intfsNode := tvClassesShort.Items.AddChild(node, '<I> ' + item);
          End;
        //Automated
        autoNum := LoadAutoTable(adr, tmpList);
        if autoNum<>0 then
        Begin
          autoNode := tvClassesShort.Items.AddChild(node, '<A>');
          for m := 0 to autoNum-1 do
            tvClassesShort.Items.AddChild(autoNode, tmpList[m]);
        End;
        //Fields
        fieldsNum := LoadFieldTable(adr, fieldsList);
        if fieldsNum<>0 then
        Begin
          fieldsNode := tvClassesShort.Items.AddChild(node, '<F>');
          for m := 0 to fieldsNum-1 do
          Begin
              fInfo := fieldsList.Items[m];
              text := Val2Str(fInfo.Offset,5) + ' ';
              if fInfo.Name <> '' then
                text := text + fInfo.Name
              else
                text := text + '?';
              text := text + ':';
              if fInfo._Type <> '' then
                text := text + TrimTypeName(fInfo._Type)
              else
                text := text + '?';

              tvClassesShort.Items.AddChild(fieldsNode, text);
          End;
        End;
        //Events
        methodsNum := LoadMethodTable(adr, tmpList);
        if methodsNum<>0 then
        Begin
          tmpList.Sort;
          methodsNode := tvClassesShort.Items.AddChild(node, '<M>');
          for m := 0 to methodsNum-1 do
            tvClassesShort.Items.AddChild(methodsNode, tmpList[m]);
        End;
        dynamicsNum := LoadDynamicTable(adr, tmpList);
        if dynamicsNum<>0 then
        Begin
          tmpList.Sort;
          dynamicsNode := FMain.tvClassesShort.Items.AddChild(node, '<D>');
          for m := 0 to dynamicsNum-1 do
            tvClassesShort.Items.AddChild(dynamicsNode, tmpList[m]);
        End;
        //Virtual
        virtualsNum := LoadVirtualTable(adr, tmpList);
        if virtualsNum<>0 then
        Begin
          virtualsNode := tvClassesShort.Items.AddChild(node, '<V>');
          for m := 0 to virtualsNum-1 do
            tvClassesShort.Items.AddChild(virtualsNode, tmpList[m]);
        End;
      End;
      if Assigned(selNode) then
      Begin
        selNode.Selected := true;
        selNode.Expand(true);
        tvClassesShort.TopItem := selNode;
      End;
      break;
    End;
    adr := parentAdr;
    Inc(n);
  End;
  fieldsList.Free;
  tmpList.Free;

  pcWorkArea.ActivePage := tsClassView;
  if rgViewerMode.ItemIndex=0 then
  Begin
    tvClassesFull.BringToFront;
    //if tvClassesFull.CanFocus then ActiveControl := tvClassesFull;
  End
  else
  Begin
    tvClassesShort.BringToFront;
    //if tvClassesShort.CanFocus then ActiveControl := tvClassesShort;
  End;
end;

Function TFMain.LoadIntfTable (adr:Integer; dstList:TStringList):Integer;
var
  recN:InfoRec;
  n:Integer;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.interfaces) then
    for n := 0 to recN.vmtInfo.interfaces.Count-1 do
      dstList.Add(recN.vmtInfo.interfaces[n]);
  dstList.Sort;
  Result:=dstList.Count;
end;

Function TFMain.LoadAutoTable (adr:Integer; dstList:TStringList):Integer;
var
  recN:InfoRec;
  recM:PMethodRec;
  n:Integer;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    Begin
      recM:=recN.vmtInfo.methods[n];
      if recM.kind = 'A' then
        dstList.Add('A' + Val2Str(recM.id,4) + ' #' + Val2Str(recM.address,8) + ' ' + recM.name);
    end;
  dstList.Sort;
  Result:=dstList.Count;
end;

Function TFMain.LoadFieldTable (adr:Integer; dstList:TList):Integer;
Var
  m,n,parentSize:Integer;
  recN:InfoRec;
  fInfo,fInfo1:FieldInfo;
  exist:Boolean;
Begin
  dstList.Clear;
  parentSize := GetParentSize(adr);
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.fields) then
    for n := 0 to recN.vmtInfo.fields.Count-1 do
    begin
      fInfo := FieldInfo(recN.vmtInfo.fields[n]);
      if fInfo.Offset >= parentSize then
      begin
        exist := false;
        for m := 0 to dstList.Count-1 do
        begin
          fInfo1 := dstList.Items[m];
          if fInfo1.Offset = fInfo.Offset then
          begin
            exist := true;
            break;
          end;
        End;
        if not exist then dstList.Add(fInfo);
      end;
    end;
  {
  while true do
  begin
    recN := GetInfoRec(adr);
    if Assigned(recN) and Assigned(recN.info) and Assigned(recN.info.vmtInfo.fields) then
      for n := recN.info.vmtInfo.fields.Count - 1 downto 0 do
      begin
        fInfo := FieldInfo(recN.info.vmtInfo.fields[n]);
        if not GetVMTField(dstList, fInfo.offset) then dstList.Add(fInfo);
      end;
    //ParentAdr
    adr := GetParentAdr(adr);
    if adr=0 then break;
  end;
  }
  Result:=dstList.Count;
end;

Function TFMain.LoadMethodTable (adr:Integer; dstList:TList):Integer;
var
  recN:InfoRec;
  recM:PMethodRec;
  n:Integer;
  clsName:AnsiString;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
  begin
    clsName := GetClsName(adr) + '.';
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    begin
      recM := recN.vmtInfo.methods[n];
      if recM.kind = 'M' then
        if (Pos('.',recM.name) = 0) or (Pos(clsName,recM.name) = 1) then dstList.Add(recM);
    End;
  end;
  Result:=dstList.Count;
end;

Function TFMain.LoadMethodTable(adr:Integer; dstList:TStringList):Integer;
Var
  recN:InfoRec;
  recM:PMethodRec;
  n:Integer;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    begin
      recM := recN.vmtInfo.methods[n];
      if recM.kind = 'M' then
        dstList.Add('#' + Val2Str(recM.address,8) + ' ' + recM.name);
    End;
  Result:=dstList.Count;
end;

Function TFMain.LoadDynamicTable(adr:Integer; dstList:TList):Integer;
var
  recN:InfoRec;
  recM:PMethodRec;
  n:Integer;
  clsName:AnsiString;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
  begin
    clsName := GetClsName(adr) + '.';
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    begin
      recM := recN.vmtInfo.methods[n];
      if recM.kind = 'D' then
        if (Pos('.',recM.name) = 0) or (Pos(clsName,recM.name) = 1) then dstList.Add(recM);
    End;
  end;
  Result:=dstList.Count;
end;

Function TFMain.LoadDynamicTable(adr:Integer; dstList:TStringList):Integer;
var
  recN:InfoRec;
  recM:PMethodRec;
  n:Integer;
  clsName:AnsiString;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
  begin
    clsName := GetClsName(adr) + '.';
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    begin
      recM := recN.vmtInfo.methods[n];
      if recM.kind = 'D' then
        dstList.Add('D' + Val2Str(recM.id,4) + ' #' + Val2Str(recM.address,8) + ' ' + recM.name);
    End;
  end;
  Result:=dstList.Count;
end;

Function TFMain.LoadVirtualTable(adr:Integer; dstList:TList):Integer;
var
  recN:InfoRec;
  recM:PMethodRec;
  n:Integer;
  clsName:AnsiString;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
  begin
    clsName := GetClsName(adr) + '.';
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    begin
      recM := recN.vmtInfo.methods[n];
      if recM.kind = 'V' then
        if (Pos('.',recM.name) = 0) or (Pos(clsName,recM.name) = 1) then dstList.Add(recM);
    End;
  end;
  Result:=dstList.Count;
end;

Function TFMain.LoadVirtualTable(adr:Integer; dstList:TStringList):Integer;
var
  recN,recN1:InfoRec;
  recM:PMethodRec;
  n:Integer;
  line:AnsiString;
Begin
  dstList.Clear;
  recN := GetInfoRec(adr);
  if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
  begin
    recN.vmtInfo.methods.Sort(MethodsCmpFunction);
    for n := 0 to recN.vmtInfo.methods.Count-1 do
    begin
      recM := recN.vmtInfo.methods[n];
      if recM.kind = 'V' then // && recM.id >= -4)
      begin
        line := '';
        recN1 := GetInfoRec(recM.address);
        if recM.id < 0 then
          line := line + '-' + Val2Str(-recM.id,4)
        else
          line := line + 'V' + Val2Str(recM.id,4);
        line := line + ' #' + Val2Str(recM.address,8);
        if recM.name <> '' then
        begin
          line := line + ' ' + recM.name;
          if Assigned(recN1) and recN1.HasName and not recN1.SameName(recM.name) then
          begin
            //Change "@AbstractError" to "abstract"
            if SameText(recN1.Name, '@AbstractError') then
              line := line + ' (abstract)'
            else
              line := line + ' (' + recN1.Name + ')';
          end;
        end
        else if Assigned(recN1) and recN1.HasName then line := line + ' ' + recN1.Name;
        dstList.Add(line);
      End;
    End;
  end;
  Result:=dstList.Count;
end;

procedure TFMain.miViewProtoClick(Sender : TObject);
var
  instrlen,Idx,Adr:Integer;
  recN:InfoRec;
  pInfo:MProcInfo;
  item,proto:AnsiString;
  DisInfo:TDisInfo;
begin
  if lbCode.ItemIndex <= 0 then Exit;

  item := lbCode.Items[lbCode.ItemIndex];
  sscanf(PAnsiChar(item)+1,'%lX',[@Adr]);
  instrlen := frmDisasm.Disassemble(Code + Adr2Pos(Adr), Adr, @DisInfo, Nil);
  if instrlen=0 then Exit;

  proto := '';
  if DisInfo.Call then
  Begin
  	//Адрес задан явно
    if IsValidCodeAdr(DisInfo.Immediate) then
    Begin
      recN := GetInfoRec(DisInfo.Immediate);
      if Assigned(recN) then proto := recN.MakePrototype(DisInfo.Immediate, true, false, false, true, true);
    End
    //Адрес не задан, пробуем пи-код
    else
    Begin
    	recN := GetInfoRec(Adr);
      if Assigned(recN) and Assigned(recN.pcode) and IsValidCodeAdr(recN.pcode.Offset) then
        if KBase.GetProcInfo(PAnsiChar(recN.pcode.Name), INFO_ARGS, pInfo, Idx) then
          proto := KBase.GetProcPrototype(@pInfo);
    End;
  End;
  if proto <> '' then
  Begin
    FStringInfo.memStringInfo.Clear;
    FStringInfo.Caption := 'Prototype';
    FStringInfo.memStringInfo.Lines.Add(proto);
    FStringInfo.ShowModal;
  End;
end;

procedure TFMain.ShowCXrefsClick(Sender : TObject);
begin
  if lbCXrefs.Visible then
  begin
    ShowCXrefs.BevelOuter := bvRaised;
    lbCXrefs.Visible := false;
  end
  else
  begin
    ShowCXrefs.BevelOuter := bvLowered;
    lbCXrefs.Visible := true;
  End;
end;

procedure TFMain.bCodePrevClick(Sender : TObject);
var
  rec:PROCHISTORYREC;
  prec:PPROCHISTORYREC;
begin
	//first add to array current subroutine info (for ->)
  if CodeHistoryPtr = CodeHistorySize - 1 then
  begin
    Inc(CodeHistorySize, HISTORY_CHUNK_LENGTH);
    SetLength(CodeHistory, CodeHistorySize);
  end;
  rec.adr := CurProcAdr;
  rec.itemIdx := lbCode.ItemIndex;
  rec.xrefIdx := lbCXrefs.ItemIndex;
  rec.topIdx := lbCode.TopIndex;
  MoveMemory(@CodeHistory[CodeHistoryPtr + 1], @rec, sizeof(PROCHISTORYREC));
  //next pop from array
  prec := CodeHistoryPop;
  if Assigned(prec) then ShowCode(prec.adr, prec.itemIdx, prec.xrefIdx, prec.topIdx);
end;

procedure TFMain.bCodeNextClick(Sender : TObject);
var
  rec:PROCHISTORYREC;
  prec:PPROCHISTORYREC;
begin
  rec.adr := CurProcAdr;
  rec.itemIdx := lbCode.ItemIndex;
  rec.xrefIdx := lbCXrefs.ItemIndex;
  rec.topIdx := lbCode.TopIndex;

	Inc(CodeHistoryPtr);
  MoveMemory(@CodeHistory[CodeHistoryPtr], @rec, sizeof(PROCHISTORYREC));

	prec := @CodeHistory[CodeHistoryPtr + 1];
  ShowCode(prec.adr, prec.itemIdx, prec.xrefIdx, prec.topIdx);

  bCodePrev.Enabled := (CodeHistoryPtr >= 0);
  bCodeNext.Enabled := (CodeHistoryPtr < CodeHistoryMax);
end;

Procedure TFMain.CodeHistoryPush (rec:PPROCHISTORYREC);
Begin
  if CodeHistoryPtr = CodeHistorySize - 1 then
  begin
    Inc(CodeHistorySize, HISTORY_CHUNK_LENGTH);
    SetLength(CodeHistory, CodeHistorySize);
  End;

  Inc(CodeHistoryPtr);
  MoveMemory(@CodeHistory[CodeHistoryPtr], rec, sizeof(PROCHISTORYREC));

  CodeHistoryMax := CodeHistoryPtr;
  bCodePrev.Enabled := (CodeHistoryPtr >= 0);
  bCodeNext.Enabled := (CodeHistoryPtr < CodeHistoryMax);
end;

Function TFMain.CodeHistoryPop:PPROCHISTORYREC;
Begin
  Result:=Nil;
  if CodeHistoryPtr >= 0 then
  begin
    Result:= @CodeHistory[CodeHistoryPtr];
    Dec(CodeHistoryPtr);
  end;
  bCodePrev.Enabled := (CodeHistoryPtr >= 0);
  bCodeNext.Enabled := (CodeHistoryPtr < CodeHistoryMax);
end;

procedure TFMain.tvClassesDblClick(Sender : TObject);
var
  idx,adr,ps:Integer;
  tv:TTreeView;
  node:TTreeNode;
  rec:PROCHISTORYREC;
  tInfo:MTypeInfo;
  typeName,line:AnsiString;
  use:TWordDynArray;
begin
  //if (ActiveControl = tvClassesFull) or (ActiveControl = tvClassesShort) then
    tv := TTreeView(ActiveControl);
  node := tv.Selected;
  if Assigned(node) then
  Begin
    line := node.Text;
    ps := Pos('#',line);
    //Указан адрес
    if (ps<>0) and (Pos('Sz=',line)=0) then
    Begin
      sscanf(PAnsiChar(line)+ps,'%lX',[@adr]);
      if IsValidCodeAdr(adr) then
      Begin
        rec.adr := CurProcAdr;
        rec.itemIdx := lbCode.ItemIndex;
        rec.xrefIdx := lbCXrefs.ItemIndex;
        rec.topIdx := lbCode.TopIndex;
        ShowCode(adr, 0, -1, -1);
        CodeHistoryPush(@rec);
      End;
      Exit;
    End;
    //Указан тип поля
    if Pos(':',line)<>0 then
    Begin
      typeName := ExtractType(line);
      //Если тип задан в виде Unit.TypeName
      if Pos('.',typeName)<>0 then typeName := ExtractProcName(typeName);
      adr := GetClassAdr(typeName);
      if IsValidImageAdr(adr) then ShowClassViewer(adr)
      else
      Begin
        use := KBase.GetTypeUses(PAnsiChar(typeName));
        Idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(typeName));
        if Idx <> -1 then
        Begin
          Idx := KBase.TypeOffsets[Idx].NamId;
          if KBase.GetTypeInfo(Idx, INFO_FIELDS or INFO_PROPS or INFO_METHODS, tInfo) then
          Begin
            FTypeInfo.ShowKbInfo(tInfo);
            //as delete tInfo;
          End;
        End;
        use:=nil;
      End;
    End;
  End;
end;

procedure TFMain.tvClassesShortKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key = VK_RETURN then tvClassesDblClick(Sender);
end;

procedure TFMain.pmVMTsPopup(Sender : TObject);
var
  b:Boolean;
begin
	if ActiveControl = tvClassesFull then
  begin
    b := tvClassesFull.Items.Count <>0;
    miSearchVMT.Visible := b;
    miCollapseAll.Visible := b;
    miEditClass.Visible := false;
  end
  else if ActiveControl = tvClassesShort then
  begin
    b := tvClassesShort.Items.Count <> 0;
    miSearchVMT.Visible := b;
    miCollapseAll.Visible := b;
    miEditClass.Visible := not Assigned(AnalyzeThread) and b and Assigned(tvClassesShort.Selected);
  end;
end;

procedure TFMain.miViewClassClick(Sender : TObject);
var
  sName:AnsiString;
begin
  sName := InputDialogExec('Enter Name of Type', 'Name:', '');
  if sName <> '' then ShowClassViewer(GetClassAdr(sName));
end;

procedure TFMain.miSearchVMTClick(Sender : TObject);
var
  n:Integer;
begin
  WhereSearch := SEARCH_CLASSVIEWER;

  FFindDlg.cbText.Clear;
  for n := 0 to VMTsSearchList.Count-1 do
    FFindDlg.cbText.AddItem(VMTsSearchList[n], Nil);
  if (FFindDlg.ShowModal = mrOk) and (FFindDlg.cbText.Text <> '') then
  begin
    if ActiveControl = tvClassesFull then
    begin
      if Assigned(tvClassesFull.Selected) then
        TreeSearchFrom := tvClassesFull.Selected
      else
        TreeSearchFrom := tvClassesFull.Items[0];
    end
    else if ActiveControl = tvClassesShort then
    begin
      if Assigned(tvClassesShort.Selected) then
        BranchSearchFrom := tvClassesShort.Selected
      else
        BranchSearchFrom := tvClassesShort.Items[0];
    end;
    VMTsSearchText := FFindDlg.cbText.Text;
    if VMTsSearchList.IndexOf(VMTsSearchText) = -1 then VMTsSearchList.Add(VMTsSearchText);
    FindText(VMTsSearchText);
  end;
end;

procedure TFMain.miCollapseAllClick(Sender : TObject);
var
  tv:TTreeView;
  node,rootNode:TTreeNode;
  n,cnt:Integer;
begin
  if (ActiveControl = tvClassesFull) or (ActiveControl = tvClassesShort) then
  begin
    tv := TTreeView(ActiveControl);
    tv.Items.BeginUpdate;
    rootNode := tv.Items[0];
    cnt := rootNode.Count;
    for n := 0 to cnt-1 do
    begin
      node := rootNode.Item[n];
      if node.HasChildren and node.Expanded then node.Collapse(true);
    end;
    tv.Items.EndUpdate;
  end;
end;

procedure TFMain.miEditClassClick(Sender : TObject);
var
  node:TTreeNode;
  ps,vmtAdr,FieldOfs:Integer;
begin
	if ActiveControl = tvClassesShort then
  begin
    node := tvClassesShort.Selected;
    if Assigned(node) then
    begin
      FieldOfs := -1;
      if Pos('#',node.Text)=0 then
        FieldOfs:=StrtoIntDef('$'+Trim(node.Text),0);
      while Assigned(node) do
      begin
        ps := Pos('#',node.Text);
        //Указан адрес
        if (ps<>0) and (Pos('Sz=',node.Text)<>0) then
        begin
          sscanf(PAnsiChar(node.Text)+ps+1,'%lX',[@vmtAdr]);
          if IsValidImageAdr(vmtAdr) then
          begin
            FEditFieldsDlg.VmtAdr := vmtAdr;
            FEditFieldsDlg.FieldOffset := FieldOfs;
            if FEditFieldsDlg.Visible then FEditFieldsDlg.Close;
            FEditFieldsDlg.FormStyle := fsStayOnTop;
            FEditFieldsDlg.Show;
            Exit;
          end;
        End;
        node := node.GetPrev;
      End;
    End;
  End;
end;

procedure TFMain.miCopyCodeClick(Sender : TObject);
begin
  Copy2Clipboard(lbCode.Items, 1, true);
end;

procedure TFMain.lbFormsDblClick(Sender : TObject);
var
  dfm:TDfm;
begin
  dfm := ResInfo.FormList[lbForms.ItemIndex];
  if rgViewFormAs.ItemIndex=0 then
  begin
    //As Text
    FExplorer.tsCode.TabVisible := false;
    FExplorer.tsData.TabVisible := false;
    FExplorer.tsString.TabVisible := false;
    FExplorer.tsText.TabVisible := true;
    FExplorer.pc1.ActivePage := FExplorer.tsText;
    ResInfo.GetFormAsText(dfm, FExplorer.lbText.Items);
    FExplorer.ShowModal;
  end
  else if rgViewFormAs.ItemIndex=1 then
  begin
    //As Form
    if dfm.Open <> 2 then
    begin
      //Если есть открытые формы, закрываем их
      ResInfo.CloseAllForms;
      ShowDfm(dfm);
    end;
  end;
end;

Procedure TFMain.ShowDfm (dfm:TDfm);
var
  recU:PUnitRec;
Begin
  if not Assigned(dfm) then Exit;
  //if inherited find parent form
  if ((dfm.Flags and FF_INHERITED)<>0) and not Assigned(dfm.ParentDfm) then
    dfm.ParentDfm := ResInfo.GetParentDfm(dfm);

  dfm.Loader := IdrDfmLoader.Create(Nil);
  dfm.Form := dfm.Loader.LoadForm(dfm.MemStream, dfm);
  FreeAndNil(dfm.Loader);
  if Assigned(dfm.Form) then
  begin
    recU := GetUnit(GetClassAdr(dfm.ClassName));
    if Assigned(recU) then
      dfm.Form.Caption := Format('[#%.3d] %s',[recU.iniOrder, dfm.Form.Caption]);
    dfm.Open := 2;
    dfm.Form.Show;
    if not Assigned(AnalyzeThread) then
      sb.Panels.Items[0].Text := 'Press F11 to open form controls tree';
  end;
end;

procedure TFMain.lbFormsKeyDown(Sender : TObject; Var Key:Word; Shift:TShiftState);
begin
  if (lbForms.ItemIndex >= 0) and (Key = VK_RETURN) then lbFormsDblClick(Sender);
end;

procedure TFMain.lbCodeKeyDown(Sender : TObject; Var Key:Word; Shift:TShiftState);
begin
  case Key of
    VK_RETURN: lbCodeDblClick(Sender);
    VK_ESCAPE: bCodePrevClick(Sender);
  End;
end;

Procedure TFMain.StartProgress (text0, text1:AnsiString; steps:Integer);
Begin
  with pb do
  begin
    Min := 0;
    Max := steps;
    Step := 1;
    Position := 0;
    Update;
  end;
  with sb do
  begin
    Panels[0].Text := text0;
    Panels[1].Text := text1;
    Update;
  end;
end;

Procedure TFMain.CleanProject;
var
  n:Integer;
  recN:InfoRec;
  segInfo:PSegmentInfo;
  recE:PExportNameRec;
  recI:PImportNameRec;
  recU:PUnitRec;
  recT:PTypeRec;
Begin
  if Assigned(Image) Then
  Begin
    FreeMem(Image);
    Image:=Nil;
  end;
  if Assigned(FlagList) Then
  Begin
    FreeMem(FlagList);
    FlagList:=Nil;
  end;
  if Assigned(InfoList) then
  Begin
    for n := 0 to High(InfoList) do
      InfoList[n].Free;
    SetLength(InfoList,0);
  End;
  if Assigned(BSSInfos) then
  Begin
    for n := 0 to BSSInfos.Count-1 do
    Begin
      recN := InfoRec(BSSInfos.Objects[n]);
      recN.Free;
    End;
    FreeAndNil(BSSInfos);
  End;

  for n := 0 to SegmentList.Count-1 do
  Begin
    segInfo := SegmentList[n];
    Dispose(segInfo);
  End;
  SegmentList.Clear;

  for n := 0 to ExpFuncList.Count-1 do
  Begin
    recE := ExpFuncList[n];
    Dispose(recE);
  End;
  ExpFuncList.Clear;

  for n := 0 to ImpFuncList.Count-1 do
  Begin
    recI := ImpFuncList[n];
    Dispose(recI);
  End;
  ImpFuncList.Clear;
  VmtList.Clear;

  for n := 0 to UnitsNum-1 do
  Begin
    recU := Units[n];
    Dispose(recU);
  End;
  Units.Clear;
  UnitsNum := 0;

  for n := 0 to OwnTypeList.Count-1 do
  Begin
    recT := OwnTypeList[n];
    Dispose(recT);
  End;
  OwnTypeList.Clear;
end;

Procedure TFMain.CloseProject;
var
  n:Integer;
Begin
  CleanProject;
  ResInfo.CloseAllForms;
  for n := 0 to ResInfo.FormList.Count-1 do
    TDfm(ResInfo.FormList[n]).Free;

  ResInfo.FormList.Clear;
  ResInfo.Aliases.Clear;
  if ResInfo.hFormPlugin<>0 then
  begin
    FreeLibrary(ResInfo.hFormPlugin);
    ResInfo.hFormPlugin := 0;
  end;
  ResInfo.Counter := 0;
  OwnTypeList.Clear;
  UnitsSearchList.Clear;
  RTTIsSearchList.Clear;
  UnitItemsSearchList.Clear;
  VMTsSearchList.Clear;
  FormsSearchList.Clear;
  StringsSearchList.Clear;
  NamesSearchList.Clear;

  CodeHistoryPtr := -1;
  CodeHistoryMax := CodeHistoryPtr;
  SetLength(CodeHistory, 0);
  KBase.Close;
end;

procedure TFMain.tvClassesFullClick(Sender : TObject);
begin
  TreeSearchFrom := tvClassesFull.Selected;
  WhereSearch := SEARCH_CLASSVIEWER;
end;

procedure TFMain.tvClassesShortClick(Sender : TObject);
begin
  BranchSearchFrom := tvClassesShort.Selected;
  WhereSearch := SEARCH_CLASSVIEWER;
end;

procedure TFMain.FindText(str:AnsiString);
var
  n, ps, idx:Integer;
  line, msg:AnsiString;
  node:TTreeNode;
begin
  idx:=-1;
  if Text = '' then Exit;
  msg := 'Search string "' + Text + '" not found';
  case WhereSearch of
    SEARCH_UNITS:
      begin
        for n := UnitsSearchFrom to lbUnits.Items.Count-1 do
          if AnsiContainsText(lbUnits.Items.Strings[n], Text) then
          Begin
            idx := n;
            break;
          End;
        if idx = -1 then
          for n := 0 to UnitsSearchFrom-1 do
            if AnsiContainsText(lbUnits.Items.Strings[n], Text) then
            Begin
              idx := n;
              break;
            End;
        if idx <> -1 then
        Begin
        	if idx < lbUnits.Items.Count - 1 then UnitsSearchFrom := idx + 1
        	  else UnitsSearchFrom := 0;
          lbUnits.ItemIndex := idx;
          lbUnits.SetFocus;
        End
        else ShowMessage(msg);
      end;
    SEARCH_UNITITEMS:
      begin
        for n := UnitItemsSearchFrom to lbUnitItems.Items.Count-1 do
          if AnsiContainsText(lbUnitItems.Items.Strings[n], Text) then
          Begin
            idx := n;
            break;
          End;
        if idx = -1 then
          for n := 0 to UnitItemsSearchFrom-1 do
            if AnsiContainsText(lbUnitItems.Items.Strings[n], Text) then
            Begin
              idx := n;
              break;
            End;
        if idx <> -1 then
        Begin
        	if idx < lbUnitItems.Items.Count then UnitItemsSearchFrom := idx + 1
        	  else UnitItemsSearchFrom := 0;
          lbUnitItems.ItemIndex := idx;
          lbUnitItems.SetFocus;
        End
        else ShowMessage(msg);
      end;
    SEARCH_RTTIS:
      begin
        for n := RTTIsSearchFrom to lbRTTIs.Items.Count-1 do
          if AnsiContainsText(lbRTTIs.Items.Strings[n], Text) then
          Begin
          	idx := n;
            break;
          End;
        if idx = -1 then
          for n := 0 to RTTIsSearchFrom-1 do
            if AnsiContainsText(lbRTTIs.Items.Strings[n], Text) then
            Begin
            	idx := n;
              break;
            End;
        if idx <> -1 then
        Begin
        	if idx < lbRTTIs.Items.Count - 1 then RTTIsSearchFrom := idx + 1
        	  else RTTIsSearchFrom := 0;
          lbRTTIs.ItemIndex := idx;
        	lbRTTIs.SetFocus;
        End
        else ShowMessage(msg);
      end;
    SEARCH_FORMS:
      begin
        for n := FormsSearchFrom to lbForms.Items.Count-1 do
          if AnsiContainsText(lbForms.Items.Strings[n], Text) then
          Begin
          	idx := n;
            break;
          End;
        if idx = -1 then
          for n := 0 to FormsSearchFrom-1 do
            if AnsiContainsText(lbForms.Items.Strings[n], Text) then
            Begin
            	idx := n;
              break;
            End;
        if idx <> -1 then
        Begin
        	if idx < lbForms.Items.Count - 1 then FormsSearchFrom := idx + 1
        	  else FormsSearchFrom := 0;
          lbForms.ItemIndex := idx;
        	lbForms.SetFocus;
        End
        else ShowMessage(msg);
      end;
    SEARCH_CLASSVIEWER:
      begin
        if rgViewerMode.ItemIndex=0 then
        Begin
        	node := TreeSearchFrom;
          while Assigned(node) do
          Begin
          	line := node.Text;
            //Skip <>
            if (line[1] <> '<') and AnsiContainsText(line, Text) then
            Begin
              idx := 0;
              break;
            End;
            node := node.GetNext;
          End;
          if (idx = -1) and (tvClassesFull.Items.Count<>0) then
          Begin
          	node := tvClassesFull.Items[0];
          	while node <> TreeSearchFrom do
            Begin
              line := node.Text;
              //Skip <>
              if (line[1] <> '<') and AnsiContainsText(line, Text) then
              Begin
                idx := 0;
                break;
              End;
              node := node.GetNext;
            End;
          End;
          if idx <> -1 then
          Begin
            TreeSearchFrom := node.GetNext;
            if not Assigned(TreeSearchFrom) then TreeSearchFrom:= tvClassesFull.Items[0];
            node.Selected := true;
            node.Expanded := true;
            tvClassesFull.Show;
          End
          else ShowMessage(msg);
        End
        else
        Begin
        	node := BranchSearchFrom;
          while Assigned(node) do
          Begin
          	line := node.Text;
            //Skip <>
            if (line[1] <> '<') and AnsiContainsText(line, Text) then
            Begin
              idx := 0;
              break;
            End;
            node := node.GetNext;
          End;
          if (idx = -1) and (tvClassesShort.Items.Count<>0) then
          Begin
          	node := tvClassesShort.Items[0];
          	while node <> BranchSearchFrom do
            Begin
              line := node.Text;
              //Skip <>
              if (line[1] <> '<') and AnsiContainsText(line, Text) then
              Begin
                idx := 0;
                break;
              End;
              node := node.GetNext;
            End;
          End;
          if idx <> -1 then
          Begin
            BranchSearchFrom := node.GetNext;
            if not Assigned(BranchSearchFrom) then BranchSearchFrom:= tvClassesShort.Items[0];
            node.Selected := true;
            node.Expanded := true;
            tvClassesShort.Show;
          End
          else ShowMessage(msg);
        End;
      end;
    SEARCH_STRINGS:
      begin
        for n := StringsSearchFrom to lbStrings.Items.Count-1 do
        Begin
        	line := lbStrings.Items[n];
        	ps := Pos('''',line);
        	line := Copy(line,ps + 1, Length(line) - ps);
          if AnsiContainsText(line, Text) then
          Begin
            idx := n;
            break;
          End;
        End;
        if idx = -1 then
          for n := 0 to StringsSearchFrom-1 do
          Begin
            line := lbStrings.Items[n];
            ps := Pos('''',line);
            line := Copy(line,ps + 1, Length(line) - ps);
            if AnsiContainsText(line, Text) then
            Begin
              idx := n;
              break;
            End;
          End;
        if idx <> -1 then
        Begin
        	if idx < lbStrings.Items.Count - 1 then StringsSearchFrom := idx + 1
        	  else StringsSearchFrom := 0;
          lbStrings.ItemIndex := idx;
          lbStrings.SetFocus;
        End
        else ShowMessage(msg);
  	  end;
    SEARCH_NAMES:
      begin
        for n := NamesSearchFrom to lbNames.Items.Count-1 do
        Begin
        	line := lbNames.Items[n];
        	ps := Pos('''',line);
        	line := Copy(line,ps + 1, Length(line) - ps);
          if AnsiContainsText(line, Text) then
          Begin
            idx := n;
            break;
          End;
        End;
        if idx = -1 then
          for n := 0 to NamesSearchFrom-1 do
          Begin
            line := lbNames.Items[n];
            ps := Pos('''',line);
            line := Copy(line,ps + 1, Length(line) - ps);
            if AnsiContainsText(line, Text) then
            Begin
              idx := n;
              break;
            End;
          End;
        if idx <> -1 then
        Begin
        	if idx < lbNames.Items.Count - 1 then NamesSearchFrom := idx + 1
        	  else NamesSearchFrom := 0;
          lbNames.ItemIndex := idx;
          lbNames.SetFocus;
        End
        else ShowMessage(msg);
    	end;
  End;
end;

procedure TFMain.lbFormsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if lbForms.CanFocus then ActiveControl := lbForms;
end;

procedure TFMain.lbCodeMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if lbCode.CanFocus then ActiveControl := lbCode;
end;

procedure TFMain.tvClassesFullMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if tvClassesFull.CanFocus then ActiveControl := tvClassesFull;
end;

procedure TFMain.tvClassesShortMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if tvClassesShort.CanFocus then ActiveControl := tvClassesShort;
end;

procedure TFMain.rgViewerModeClick(Sender : TObject);
begin
  if rgViewerMode.ItemIndex=0 then tvClassesFull.BringToFront
    else tvClassesShort.BringToFront;
end;

procedure TFMain.miClassTreeBuilderClick(Sender : TObject);
begin
  miLoadFile.Enabled := false;
  miOpenProject.Enabled := false;
  miMRF.Enabled := false;
  miSaveProject.Enabled := false;
  miSaveDelphiProject.Enabled := false;
  miMapGenerator.Enabled := false;
  miCommentsGenerator.Enabled := false;
  miIDCGenerator.Enabled := false;
  miLister.Enabled := false;
  miClassTreeBuilder.Enabled := false;
  miKBTypeInfo.Enabled := false;
  miCtdPassword.Enabled := false;
  miHex2Double.Enabled := false;

  pb.Visible := true;

  AnalyzeThread := TAnalyzeThread.Create(FMain, false);
  AnalyzeThread.Resume;
end;

//-----------
//INI FILE
//-----------
Procedure TFMain.IniFileRead;
var
  n, m, ps, version:Integer;
  str, filename, ident:AnsiString;
  item:TMenuItem;
  iniFile:TIniFile;
  _font:TFont;
  _monitor:TMonitor;
Begin
  iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  _font := TFont.Create;
  _font.Name := iniFile.ReadString('Settings', 'FontName', 'Fixedsys');
  _font.Charset := iniFile.ReadInteger('Settings', 'FontCharset', 1);
  _font.Size := iniFile.ReadInteger('Settings', 'FontSize', 9);
  _font.Color := iniFile.ReadInteger('Settings', 'FontColor', 0);
  if iniFile.ReadBool('Settings', 'FontBold', False) then
    _font.Style := _font.Style + [fsBold];
  if iniFile.ReadBool('Settings', 'FontItalic', False) then
    _font.Style := _font.Style + [fsItalic];
  SetupAllFonts(_font);
  _font.Free;

  WrkDir := iniFile.ReadString('MainForm', 'WorkingDir', AppDir);
  for n := 0 to Screen.MonitorCount-1 do
  Begin
    _monitor := Screen.Monitors[n];
    if _monitor.Primary then
    Begin
      Left := iniFile.ReadInteger('MainForm', 'Left', _monitor.WorkareaRect.Left);
      Top := iniFile.ReadInteger('MainForm', 'Top', _monitor.WorkareaRect.Top);
      Width := iniFile.ReadInteger('MainForm', 'Width', _monitor.WorkareaRect.Right - Left);
      Height := iniFile.ReadInteger('MainForm', 'Height', _monitor.WorkareaRect.Bottom - Top);
      break;
    End;
  End;
  pcInfo.Width := iniFile.ReadInteger('MainForm', 'LeftWidth', pcInfo.Constraints.MinWidth);
  pcInfo.ActivePage := tsUnits;
  lbUnitItems.Height := iniFile.ReadInteger('MainForm', 'BottomHeight', lbUnitItems.Constraints.MinHeight);
  //Most Recent Files
  m:=0;
  for n := 0 to 7 do
  Begin
    ident := 'File' + IntToStr(n + 1);
    str := iniFile.ReadString('Recent Executable Files', ident, '');
    ps := LastDelimiter(',',str);
    if ps<>0 then
    Begin
      filename := Copy(str,1, ps - 1);
      version := StrToIntDef(Copy(str,ps + 1, Length(str) - ps),0);
    End
    else
    Begin
      filename := str;
      version := -1;
    End;
    if FileExists(filename) then
    Begin
      item := miMRF[m];
      Inc(m);
      item.Caption := filename;
      item.Tag := version;
      item.Visible := filename <> '';
      item.Enabled := true;
    End
    else iniFile.DeleteKey('Recent Executable Files', ident);
  End;
  m:=9;
  for n := 9 to 16 do
  Begin
    ident := 'File' + IntToStr(n - 8);
    filename := iniFile.ReadString('Recent Project Files', ident, '');
    if FileExists(filename) then
    Begin
      item := miMRF[m];
      Inc(m);
      item.Caption := filename;
      item.Tag := 0;
      item.Visible := item.Caption <> '';
      item.Enabled := true;
    End
    else iniFile.DeleteKey('Recent Project Files', ident);
  End;
  iniFile.Free;
end;

Procedure TFMain.IniFileWrite;
var
  iniFile:TIniFile;
  n:Integer;
  item:TMenuItem;
Begin
  iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  iniFile.WriteString('Settings', 'FontName', lbCode.Font.Name);
  iniFile.WriteInteger('Settings', 'FontCharset', lbCode.Font.Charset);
  iniFile.WriteInteger('Settings', 'FontSize', lbCode.Font.Size);
  iniFile.WriteInteger('Settings', 'FontColor', lbCode.Font.Color);
  iniFile.WriteBool('Settings', 'FontBold', fsBold in lbCode.Font.Style);
  iniFile.WriteBool('Settings', 'FontItalic', fsItalic in lbCode.Font.Style);

  iniFile.WriteString('MainForm', 'WorkingDir', WrkDir);
  iniFile.WriteInteger('MainForm', 'Left', Left);
  iniFile.WriteInteger('MainForm', 'Top', Top);
  iniFile.WriteInteger('MainForm', 'Width', Width);
  iniFile.WriteInteger('MainForm', 'Height', Height);
  iniFile.WriteInteger('MainForm', 'LeftWidth', pcInfo.Width);
  iniFile.WriteInteger('MainForm', 'BottomHeight', lbUnitItems.Height);

  //Delete all
  for n := 1 to 8 do
  begin
    iniFile.DeleteKey('Recent Executable Files', 'File' + IntToStr(n));
    iniFile.DeleteKey('Recent Project Files', 'File' + IntToStr(n));
  end;
  //Fill
  for n := 0 to 7 do
  Begin
    item := miMRF[n];
    if item.Visible and item.Enabled then iniFile.WriteString('Recent Executable Files', 'File' + IntToStr(n + 1), '"' + item.Caption + '",' + IntToStr(item.Tag));
  End;
  for n := 9 to 16 do
  Begin
    item := miMRF[n];
    if item.Visible and item.Enabled then iniFile.WriteString('Recent Project Files', 'File' + IntToStr(n - 8), '"' + item.Caption + '"');
  End;
  iniFile.Free;
end;

//---------------------
//LOAD EXE AND IDP
//---------------------
Function TFMain.IsExe (FileName:AnsiString):Boolean;
var
  DosHeader: IMAGE_DOS_HEADER;
  NTHeaders: IMAGE_NT_HEADERS;
  f:THandle;
  readed:Integer;
Begin
  Result:=False;
  f := FileOpen(FileName, fmOpenRead Or fmShareDenyNone);
  if f=0 then Exit;
  FileSeek(f, 0, Ord(soBeginning));
  //IDD_ERR_NOT_EXECUTABLE
  readed := FileRead(f,DosHeader, sizeof(IMAGE_DOS_HEADER));
  if (readed <> sizeof(IMAGE_DOS_HEADER)) or (DosHeader.e_magic <> IMAGE_DOS_SIGNATURE) then
  begin
    FileClose(f);
    Exit;
  end;
  FileSeek(f, DosHeader._lfanew, Ord(soBeginning));
  //IDD_ERR_NOT_PE_EXECUTABLE
  readed := FileRead(f,NTHeaders, sizeof(IMAGE_NT_HEADERS));
  FileClose(f);
  if (readed <> sizeof(IMAGE_NT_HEADERS)) or (NTHeaders.Signature <> IMAGE_NT_SIGNATURE) then Exit;
  Result:=true;
end;

Function TFMain.IsIdp (FileName:AnsiString):Boolean;
var
  buf:Array[0..12] of Char;
  f:THandle;
Begin
  Result:=False;
  f := FileOpen(FileName, fmOpenRead or fmShareDenyNone);
  if f=0 then Exit;
  FileSeek(f, 0, Ord(soBeginning));
  FileRead(f,buf, SizeOf(buf));
  buf[12] := #0;
  FileClose(f);
  if AnsiStrComp(buf, 'IDR proj v.3')=0 then Result:=true;
end;

procedure TFMain.miAutodetectVersionClick(Sender : TObject);
begin
  LoadDelphiFile(0);
end;

procedure TFMain.miDelphi2Click(Sender : TObject);
begin
  LoadDelphiFile(2);
end;

procedure TFMain.miDelphi3Click(Sender : TObject);
begin
  LoadDelphiFile(3);
end;

procedure TFMain.miDelphi4Click(Sender : TObject);
begin
  LoadDelphiFile(4);
end;

procedure TFMain.miDelphi5Click(Sender : TObject);
begin
  LoadDelphiFile(5);
end;

procedure TFMain.miDelphi6Click(Sender : TObject);
begin
  LoadDelphiFile(6);
end;

procedure TFMain.miDelphi7Click(Sender : TObject);
begin
  LoadDelphiFile(7);
end;

procedure TFMain.miDelphi2005Click(Sender : TObject);
begin
  LoadDelphiFile(2005);
end;

procedure TFMain.miDelphi2006Click(Sender : TObject);
begin
  LoadDelphiFile(2006);
end;

procedure TFMain.miDelphi2007Click(Sender : TObject);
begin
  LoadDelphiFile(2007);
end;

procedure TFMain.miDelphi2009Click(Sender : TObject);
begin
  LoadDelphiFile(2009);
end;

procedure TFMain.miDelphi2010Click(Sender : TObject);
begin
  LoadDelphiFile(2010);
end;

procedure TFMain.miDelphiXE1Click(Sender : TObject);
begin
  LoadDelphiFile(2011);
end;

procedure TFMain.miDelphiXE2Click(Sender : TObject);
begin
  LoadDelphiFile(2012);
end;

procedure TFMain.miDelphiXE3Click(Sender : TObject);
begin
  LoadDelphiFile(2013);
end;

procedure TFMain.miDelphiXE4Click(Sender : TObject);
Begin
  LoadDelphiFile(2014);
end;

Procedure TFMain.LoadFile (FileName:AnsiString; version:Integer);
var
  res:Integer;
Begin
  if ProjectModified then
  begin
    res := Application.MessageBox('Save active Project?', 'Confirmation', MB_YESNOCANCEL);
    if res = IDCANCEL then Exit;
    if res = IDYES then
    begin
      if IDPFile = '' then IDPFile := ChangeFileExt(SourceFile, '.idp');
      SaveDlg.InitialDir := WrkDir;
      SaveDlg.Filter := 'IDP|*.idp';
      SaveDlg.FileName := IDPFile;
      if SaveDlg.Execute then SaveProject(SaveDlg.FileName);
    end;
  end;
  if IsExe(FileName) then
  begin
    CloseProject;
    Init;
    LoadDelphiFile1(FileName, version, true, true);
  end
  else if IsIdp(FileName) then
  begin
    CloseProject;
    Init;
    OpenProject(FileName);
  end
  else ShowMessage('File "' + FileName + '" is not an executable or IDR project file');
end;

Procedure TFMain.LoadDelphiFile (version:Integer);
Begin
	DoOpenDelphiFile(version, '', true, true);
end;

//version: 0 for autodetect, else - exact version
Procedure TFMain.DoOpenDelphiFile (version:Integer; FileName:AnsiString; loadExp, loadImp:Boolean);
var
  res:Integer;
Begin
  if ProjectModified then
  begin
    res := Application.MessageBox('Save active Project?', 'Confirmation', MB_YESNOCANCEL);
    if res = IDCANCEL then exit;
    if res = IDYES then
    begin
      if IDPFile = '' then IDPFile := ChangeFileExt(SourceFile, '.idp');
      SaveDlg.InitialDir := WrkDir;
      SaveDlg.Filter := 'IDP|*.idp';
      SaveDlg.FileName := IDPFile;
      if SaveDlg.Execute then SaveProject(SaveDlg.FileName);
    end;
  End;
  if FileName = '' then
  begin
    OpenDlg.InitialDir := WrkDir;
    OpenDlg.FileName := '';
    OpenDlg.Filter := 'EXE, DLL|*.exe;*.dll|All files|*.*';
    if OpenDlg.Execute then FileName := OpenDlg.FileName;
  end;
  if FileName <> '' then
  begin
    if not FileExists(FileName) then ShowMessage('File "' + FileName + '" does not exist')
    else
    begin
      CloseProject;
      Init;
      WrkDir := ExtractFileDir(FileName);
      LoadDelphiFile1(FileName, version, loadExp, loadImp);
    end;
  end;
end;

Procedure TFMain.LoadDelphiFile1 (FileName:AnsiString; version:Integer; loadExp, loadImp:Boolean);
var
  ps, res:Integer;
  dprName, KBFileName:AnsiString;
  f:TFileStream;
Begin
  SourceFile := FileName;
  f:=Nil;
  Try
    f:=TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    Screen.Cursor := crHourGlass;
    res := LoadImage(f, loadExp, loadImp);
  Finally
    f.Free;
  End;
  if res <= 0 then
  Begin
    if res=0 then ShowMessage('LoadImage error');
    Screen.Cursor := crDefault;
    Exit;
  End;

  FindExports;
  FindImports;

  ResInfo.EnumResources(SourceFile);
  ResInfo.ShowResources(lbForms);
  tsForms.Enabled := lbForms.Items.Count > 0;

  if version = DELHPI_VERSION_AUTO then   //Autodetect
  Begin
    DelphiVersion := GetDelphiVersion;
    if DelphiVersion = 1 then
    Begin
      Screen.Cursor := crDefault;
      ShowMessage('File ' + FileName + ' is probably Delphi 4, 5, 6, 7, 2005, 2006 or 2007 file, try manual selection');
      FInputDlg.Caption := 'Enter number of version (4, 5, 6, 7, 2005, 2006 or 2007)';
      FInputDlg.edtName.Text := '';
      if FInputDlg.ShowModal = mrCancel then
      Begin
        CleanProject;
        Exit;
      End;
      if not TryStrToInt(Trim(FInputDlg.edtName.Text), DelphiVersion) then
      Begin
        CleanProject;
        Exit;
      End;
    End;
    if DelphiVersion = -1 then
    Begin
      Screen.Cursor := crDefault;
      ShowMessage('File ' + FileName + ' is probably not a Delphi executable');
      CleanProject;
      Exit;
    End;
  End
  else DelphiVersion := version;
  Screen.Cursor := crDefault;

  UserKnowledgeBase := false;
  if Application.MessageBox('Use native Knowledge Base?', 'Knowledge Base kind selection', MB_YESNO) = IDNO then
  Begin
    OpenDlg.InitialDir := WrkDir;
  	OpenDlg.FileName := '';
  	OpenDlg.Filter := 'BIN|*.bin|All files|*.*';
    if OpenDlg.Execute then
    Begin
      KBFileName := OpenDlg.FileName;
      UserKnowledgeBase := true;
    End;
  End
  else KBFileName := AppDir + 'kb' + IntToStr(DelphiVersion) + '.bin';

  if KBFileName = '' then
  Begin
    ShowMessage('Knowledge Base file not selected');
    CleanProject;
    Exit;
  End;

  Screen.Cursor := crHourGlass;
  if not KBase.Open(KBFileName) then
  Begin
    Screen.Cursor := crDefault;
    ShowMessage('Cannot open Knowledge Base file ' + KBFileName + ' (may be incorrect Version)');
    CleanProject;
    Exit;
  End;

  SetVmtConsts(DelphiVersion);
  InitSysProcs;

  dprName := ExtractFileName(FileName);
  ps := Pos('.',dprName);
  if ps<>0 then SetLength(dprName,ps - 1);
  if DelphiVersion = 2 then
    UnitsNum := GetUnits2(dprName)
  else
    UnitsNum := GetUnits(dprName);

  if UnitsNum > 0 then ShowUnits(false)
  else
  Begin
    //May be BCB file?
    UnitsNum := GetBCBUnits(dprName);
    if UnitsNum=0 then
    Begin
      Screen.Cursor := crDefault;
      ShowMessage('Cannot find table of initialization and finalization procedures');
      CleanProject;
      Exit;
    End;
  End;
  if DelphiVersion <= 2010 then
    Caption := 'Interactive Delphi Reconstructor by crypto: ' + SourceFile + ' (Delphi-' + IntToStr(DelphiVersion) + ')'
  else
    Caption := 'Interactive Delphi Reconstructor by crypto: ' + SourceFile + ' (Delphi-XE' + IntToStr(DelphiVersion - 2010) + ')';

  //Show code to allow user make something useful
  tsCodeView.Enabled := true;
  //ShowCode(EP, 0, -1, -1);

  bEP.Enabled := true;
  //disable menu items until file is completely loaded
  miLoadFile.Enabled := false;
  miOpenProject.Enabled := false;
  miMRF.Enabled := false;
  miSaveProject.Enabled := false;
  miSaveDelphiProject.Enabled := false;
  lbCXrefs.Enabled := false;
  pb.Visible := true;

  AnalyzeThread := TAnalyzeThread.Create(FMain, true);
  AnalyzeThread.Resume;

  WrkDir := ExtractFileDir(FileName);
  lbCode.ItemIndex := -1;
  Screen.Cursor := crDefault;
end;

//Actions after analyzing
Procedure TFMain.AnalyzeThreadDone (Sender:TObject);
Begin
  if not Assigned(AnalyzeThread) then Exit;

  AnalyzeThreadRetVal := AnalyzeThread.ReturnValue;
  if AnalyzeThread.all and (AnalyzeThreadRetVal >= LAST_ANALYZE_STEP) then
  begin
    ProjectLoaded := true;
    ProjectModified := true;
    AddExe2MRF(SourceFile);
  end;

  pb.Position := 0;
  pb.Visible := false;
  sb.Panels[0].Text := 'Completed!';
  sb.Panels[1].Text := '';
  //Восстанавливаем пункты меню
  miLoadFile.Enabled := true;
  miOpenProject.Enabled := true;
  miMRF.Enabled := true;
  miSaveProject.Enabled := true;
  miSaveDelphiProject.Enabled := true;
  lbCXrefs.Enabled := true;

  miEditFunctionC.Enabled := true;
  miEditFunctionI.Enabled := true;
  miFuzzyScanKB.Enabled := true;
  miSearchItem.Enabled := true;
  miName.Enabled := true;
  miViewProto.Enabled := true;
  bDecompile.Enabled := true;

  miMapGenerator.Enabled := true;
  miCommentsGenerator.Enabled := true;
  miIDCGenerator.Enabled := true;
  miLister.Enabled := true;
  miKBTypeInfo.Enabled := true;
  miCtdPassword.Enabled := IsValidCodeAdr(CtdRegAdr);
  miHex2Double.Enabled := true;

  FreeAndNil(AnalyzeThread);
end;

Function TFMain.LoadImage (f:TFileStream; loadExp, loadImp:Boolean):Integer;
var
  i, n, m, bytes, ps, SectionsNum, ExpNum, NameLength:Integer;
  num,DataEnd, Items,rsrcVA,relocVA,evalInitTable,evalEP:Integer;
  ExpRVA,dp,ExpFuncNamPos,ExpFuncAdrPos,ExpFuncOrdPos:Integer;
  EntryRVA,ImpRVA,ImpSize,ThunkRVA,LookupRVA,ThunkValue:Integer;
  msg,moduleName, modName, sEP,impFuncName:AnsiString;
  dw,Hints:Word;
  p,sp:PAnsiChar;
  segInfo:PSegmentInfo;
  recE:PExportNameRec;
  recI:PImportNameRec;
  recN:InfoRec;
  DosHeader:IMAGE_DOS_HEADER;
  NTHeaders:IMAGE_NT_HEADERS;
  ExportDescriptor:IMAGE_EXPORT_DIRECTORY;
  ImportDescriptor:IMAGE_IMPORT_DESCRIPTOR;
  SectionHeaders:Array of IMAGE_SECTION_HEADER;
  segname:String[IMAGE_SIZEOF_SHORT_NAME];
Begin
  Result:=0;
  f.seek(0, soBeginning);
  //IDD_ERR_NOT_EXECUTABLE
  if (f.read(DosHeader, sizeof(IMAGE_DOS_HEADER)) <> sizeof(IMAGE_DOS_HEADER)) or (DosHeader.e_magic <> IMAGE_DOS_SIGNATURE) then
  Begin
    ShowMessage('File is not executable');
    Exit;
  End;

  f.seek(DosHeader._lfanew, soBeginning);
  //IDD_ERR_NOT_PE_EXECUTABLE
  if (f.read(NTHeaders, sizeof(IMAGE_NT_HEADERS)) <> sizeof(IMAGE_NT_HEADERS)) or (NTHeaders.Signature <> IMAGE_NT_SIGNATURE) then
  Begin
    ShowMessage('File is not PE-executable');
    Exit;
  End;
  //IDD_ERR_INVALID_PE_EXECUTABLE
  if (NTHeaders.FileHeader.SizeOfOptionalHeader < sizeof(IMAGE_OPTIONAL_HEADER)) or
    (NTHeaders.OptionalHeader.Magic <> IMAGE_NT_OPTIONAL_HDR32_MAGIC) then
  Begin
    ShowMessage('File is invalid PE-executable');
    Exit;
  End;
  //IDD_ERR_INVALID_PE_EXECUTABLE
  SectionsNum := NTHeaders.FileHeader.NumberOfSections;
  if SectionsNum=0 then
  Begin
    ShowMessage('File is invalid PE-executable');
    Exit;
  End;
  //SizeOfOptionalHeader may be > than sizeof(IMAGE_OPTIONAL_HEADER)
  f.seek(NTHeaders.FileHeader.SizeOfOptionalHeader - sizeof(IMAGE_OPTIONAL_HEADER), soCurrent);
  SetLength(SectionHeaders,SectionsNum);
  if f.read(SectionHeaders[0], sizeof(IMAGE_SECTION_HEADER)*SectionsNum) <> sizeof(IMAGE_SECTION_HEADER)*SectionsNum then
  Begin
    ShowMessage('Invalid section headers');
    SectionHeaders:=Nil;
    Exit;
  End;

  ImageBase := NTHeaders.OptionalHeader.ImageBase;
  ImageSize := NTHeaders.OptionalHeader.SizeOfImage;
  EP := NTHeaders.OptionalHeader.AddressOfEntryPoint;

  TotalSize := 0;
  rsrcVA := NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_RESOURCE].VirtualAddress;
  relocVA := NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress;
  //Fill SegmentList
  for i := 0 to SectionsNum-1 do
  Begin
    New(segInfo);
    segInfo.Start := SectionHeaders[i].VirtualAddress + Cardinal(ImageBase);
    segInfo.Flags := SectionHeaders[i].Characteristics;
    
    if i + 1 < SectionsNum then
      segInfo.Size := SectionHeaders[i + 1].VirtualAddress - SectionHeaders[i].VirtualAddress
    else
      segInfo.Size := SectionHeaders[i].Misc.VirtualSize;

    if SectionHeaders[i].SizeOfRawData=0 then //uninitialized data
    Begin
      //segInfo.Size := SectionHeaders[i].Misc.VirtualSize;
      segInfo.Flags := segInfo.Flags or $80000;
    End
    else if (SectionHeaders[i].VirtualAddress = Cardinal(rsrcVA))
      or (SectionHeaders[i].VirtualAddress = Cardinal(relocVA)) then
    Begin
      //segInfo.Size := SectionHeaders[i].SizeOfRawData;
      segInfo.Flags := segInfo.Flags or $80000;
    End
    else
    Begin
      //segInfo.Size := SectionHeaders[i].SizeOfRawData;
      Inc(TotalSize, segInfo.Size);
    End;
    MoveMemory(@segname[1], @SectionHeaders[i].Name[0], IMAGE_SIZEOF_SHORT_NAME);
    segname[0]:=Chr(StrLen(@segname[1]));
    segInfo.Name := segname;
    SegmentList.Add(segInfo);
  End;
  //DataEnd := TotalSize;

  //Load Image into memory
  GetMem(Image,TotalSize);
  p := Image;
  for i := 0 to SectionsNum-1 do
  Begin
    if (SectionHeaders[i].VirtualAddress = Cardinal(rsrcVA))
      or (SectionHeaders[i].VirtualAddress = Cardinal(relocVA)) then continue;
    sp := p;
    f.seek(SectionHeaders[i].PointerToRawData, soBeginning);
    Items := SectionHeaders[i].SizeOfRawData;
    if Items<>0 then
    Begin
      n:=0;
      while Items >= MAX_ITEMS do
      Begin
        f.read(p^, MAX_ITEMS);
        Dec(Items, MAX_ITEMS);
        Inc(p, MAX_ITEMS);
        Inc(n);
      End;
      if Items<>0 then
      Begin
        f.read(p^, Items);
        Inc(p, Items);
      End;
      num := p - Image;
      if i + 1 < SectionsNum then
        p := sp + (SectionHeaders[i + 1].VirtualAddress - SectionHeaders[i].VirtualAddress);
    End;
  End;

  CodeStart := 0;
  Code := Image + CodeStart;
  Cardinal(CodeBase) := Cardinal(ImageBase) + SectionHeaders[0].VirtualAddress;

  evalInitTable := EvaluateInitTable(Image, TotalSize, Integer(CodeBase));
  evalEP := 0;
  //Find instruction mov eax,offset InitTable
  for n := 0 to TotalSize - 6 do
    if (Image[n] = #$B8) and (PInteger(Image + n + 1)^ = evalInitTable) then
    Begin
      evalEP := n;
      break;
    End;
  //Scan up until bytes 0x55 (push ebp) and 0x8B,0xEC (mov ebp,esp)
  if evalEP<>0 then
    while evalEP >= 0 do
    Begin
      if (Image[evalEP] = #$55) and (Image[evalEP + 1] = #$8B) and (Image[evalEP + 2] = #$EC) then break;
      Dec(evalEP);
    End;
  //Check evalEP
  if Cardinal(evalEP) + Cardinal(CodeBase) <> NTHeaders.OptionalHeader.AddressOfEntryPoint + Cardinal(ImageBase) then
  Begin
    if Application.MessageBox(
      PAnsiChar(Format('Possible invalid EP (NTHeader:%X, Evaluated:%X). Input valid EP?',
        [NTHeaders.OptionalHeader.AddressOfEntryPoint + Cardinal(ImageBase), evalEP + CodeBase])),
      'Confirmation', MB_YESNO) = IDYES then
    Begin
      sEP := InputDialogExec('New EP', 'EP:', Val2Str(Integer(NTHeaders.OptionalHeader.AddressOfEntryPoint) + ImageBase));
      if sEP <> '' then
      Begin
        EP:=StrToIntDef('$'+Trim(sEP),0);
        if not IsValidImageAdr(EP) then
        Begin
          SectionHeaders:=Nil;
          FreeMem(Image);
          Image := Nil;
          Exit;
        End;
      End
      else
      Begin
        SectionHeaders:=Nil;
        FreeMem(Image);
        Image := Nil;
        Exit;
      End;
    End
    else
    Begin
      SectionHeaders:=Nil;
      FreeMem(Image);
      Image := Nil;
      Exit;
    End;
  End
  else EP := Integer(NTHeaders.OptionalHeader.AddressOfEntryPoint) + ImageBase;

  //Find DataStart
  //DWORD _codeEnd := DataEnd;
  //DataStart := CodeStart;
  //for (i := 0; i < SectionsNum; i++)
  //Begin
  //    if (SectionHeaders[i].VirtualAddress + ImageBase > EP)
  //    Begin
  //        _codeEnd := SectionHeaders[i].VirtualAddress;
  //        DataStart := SectionHeaders[i].VirtualAddress;
  //        break;
  //    End;
  //End;
  SectionHeaders:=Nil;

  CodeSize := TotalSize; //_codeEnd - SectionHeaders[0].VirtualAddress;
  //DataSize := DataEnd - DataStart;
  //DataBase := ImageBase + DataStart;

  GetMem(FlagList,TotalSize*SizeOf(DWORD));
  FillMemory(FlagList, sizeof(DWORD) * TotalSize,cfUndef);
  SetLength(InfoList, TotalSize);
  FillMemory(@InfoList[0],TotalSize*SizeOf(InfoRec),0);
  BSSInfos := TStringList.Create;
  BSSInfos.Sorted := true;

  if loadExp then
  Begin
    //Load Exports
    ExpRVA := NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress;
    //DWORD ExpSize := NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].Size;

    if ExpRVA<>0 then
    Begin
      MoveMemory(@ExportDescriptor, (Image + Adr2Pos(ExpRVA + ImageBase)), sizeof(IMAGE_EXPORT_DIRECTORY));
      ExpNum := ExportDescriptor.NumberOfFunctions;
      ExpFuncNamPos := Integer(ExportDescriptor.AddressOfNames);
      ExpFuncAdrPos := Integer(ExportDescriptor.AddressOfFunctions);
      ExpFuncOrdPos := Integer(ExportDescriptor.AddressOfNameOrdinals);

      for i := 0 to ExpNum-1 do
      Begin
        New(recE);
        dp := PInteger(Image + Adr2Pos(ExpFuncNamPos + ImageBase))^;
        NameLength := StrLen(Image + Adr2Pos(dp + ImageBase));
        recE.name := MakeString(Image + Adr2Pos(dp + ImageBase), NameLength);

        dw := PWord(Image + Adr2Pos(ExpFuncOrdPos + ImageBase))^;
        recE.address := PInteger(Image + Adr2Pos(ExpFuncAdrPos + 4*dw + ImageBase))^ + ImageBase;
        recE.ord := dw + ExportDescriptor.Base;
        ExpFuncList.Add(recE);

        Inc(ExpFuncNamPos, 4);
        Inc(ExpFuncOrdPos, 2);
      End;
      ExpFuncList.Sort(ExportsCmpFunction);
    End;
  End;
  if loadImp then
  Begin
    //Load Imports
    EntryRVA := 0;		//next import decriptor RVA
    ImpRVA := 0;			//import directory RVA
    ImpSize := 0;		//import directory size
    ThunkRVA := 0;		//RVA очередного thunk'a (через FirstThunk)
    LookupRVA := 0;		//RVA очередного thunk'a (через OriginalFirstTunk или FirstThunk)
    ThunkValue := 0;		//значение очередного thunk'a (через OriginalFirstTunk или FirstThunk)

    Hints := 0;			//Ординал или хинт импортируемого символа

    //DWORD fnProc := 0;
    ImpRVA := NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
    ImpSize := NTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].Size;

    if (ImpRVA<>0) or (ImpSize<>0) then
    Begin
      // На первый import descriptor
      EntryRVA := ImpRVA;
      while true do
      Begin
        MoveMemory(@ImportDescriptor, Image + Adr2Pos(EntryRVA + ImageBase), sizeof(IMAGE_IMPORT_DESCRIPTOR));
        // Если все поля дескриптора нулевые, значит список кончился
        // Выходим из цикла
        if (ImportDescriptor.OriginalFirstThunk=0) and
          (ImportDescriptor.TimeDateStamp=0) and
          (ImportDescriptor.ForwarderChain=0) and
          (ImportDescriptor.DllNameRVA=0) and
          (ImportDescriptor.FirstThunk=0) then break;

        NameLength := StrLen(Image + Adr2Pos(ImportDescriptor.DllNameRVA + ImageBase));
        moduleName := MakeString(Image + Adr2Pos(ImportDescriptor.DllNameRVA + ImageBase), NameLength);
    
        ps := Pos('.',moduleName);
        if ps<>0 then
          modName := Copy(moduleName,1, ps - 1)
        else
          modName := moduleName;

        if ImpModuleList.IndexOf(moduleName) = -1 then ImpModuleList.Add(moduleName);

        //HINSTANCE hLib := LoadLibraryEx(moduleName.c_str(), 0, LOAD_LIBRARY_AS_DATAFILE);

        // Определяем, откуда будем брать имена импортов:
        // из OriginalFirstThunk или FirstThunk
        if ImportDescriptor.OriginalFirstThunk<>0 then
          LookupRVA := ImportDescriptor.OriginalFirstThunk
        else
          LookupRVA := ImportDescriptor.FirstThunk;

        // Thunk'и с адресами берем всегда из FirstThunk
        ThunkRVA := ImportDescriptor.FirstThunk;
        //Get Imported Functions
        while true do
        Begin
          // Имена или ординалы берем из LookupTable (которая может быть
          // как в OriginalFirstThunk, так и в FirstThunk)
          ThunkValue := PInteger(Image + Adr2Pos(LookupRVA + ImageBase))^;
          if ThunkValue=0 then break;

          //fnProc := 0;
          New(recI);
          if (ThunkValue and $80000000)<>0 then
          Begin
            // by ordinal
            Hints := ThunkValue and $FFFF;

            //if (hLib) fnProc := (DWORD)GetProcAddress(hLib, (char*)Hint);

            // Но адреса используем только из FirstThunk
            //recI.name := modName + '.' + String(Hint);
            recI.name := IntToStr(Hints);
          End
          else
          Begin
            // by name
            Hints := PWord(Image + Adr2Pos(ThunkValue + ImageBase))^;
            NameLength := StrLen(Image + Adr2Pos(ThunkValue + 2 + ImageBase));
            impFuncName := MakeString(Image + Adr2Pos(ThunkValue + 2 + ImageBase), NameLength);

            //if (hLib)
            //Begin
            //    fnProc := (DWORD)GetProcAddress(hLib, impFuncName.c_str());
            //    memmove((void*)(Image + ThunkRVA), (void*)&fnProc, sizeof(DWORD));
            //End;

            recI.name := impFuncName;
          End;
          recI.module := modName;
          recI.address := ImageBase + ThunkRVA;
          ImpFuncList.Add(recI);

          SetFlag(cfImport, Adr2Pos(recI.address));
          recN := InfoRec.Create(Adr2Pos(recI.address), ikData);
          recN.Name:=impFuncName;

          Inc(ThunkRVA, 4);
          Inc(LookupRVA, 4);
        End;
        Inc(EntryRVA, sizeof(IMAGE_IMPORT_DESCRIPTOR));

        //if (hLib)
        //Begin
        //    FreeLibrary(hLib);
        //    hLib := NULL;
        //End;
      End;
      ImpFuncList.Sort(ImportsCmpFunction);
    End;
  End;
  Result:= 1;
end;

procedure TFMain.miOpenProjectClick(Sender : TObject);
begin
	DoOpenProjectFile('');
end;

Procedure TFMain.DoOpenProjectFile (FileName:AnsiString);
var
  res:Integer;
Begin
  if ProjectModified then
  begin
    res := Application.MessageBox('Save active Project?', 'Confirmation', MB_YESNOCANCEL);
    if res = IDCANCEL then Exit;
    if res = IDYES then
    begin
      if IDPFile = '' then IDPFile := ChangeFileExt(SourceFile, '.idp');

      SaveDlg.InitialDir := WrkDir;
      SaveDlg.Filter := 'IDP|*.idp';
      SaveDlg.FileName := IDPFile;

      if SaveDlg.Execute then SaveProject(SaveDlg.FileName);
    end;
  end;
  if FileName = '' then
  begin
    OpenDlg.InitialDir := WrkDir;
    OpenDlg.FileName := '';
    OpenDlg.Filter := 'IDP|*.idp';
    if OpenDlg.Execute then FileName := OpenDlg.FileName;
  end;
  if FileName <> '' then
  begin
    if not FileExists(FileName) then ShowMessage('File "' + FileName + '" does not exist')
    else
    begin
      CloseProject;
      Init;
      WrkDir := ExtractFileDir(FileName);
      OpenProject(FileName);
    end;
  end;
end;

Procedure TFMain.ReadNode (stream:TStream; node:TTreeNode; buf:PAnsiChar);
var
  n,Len,itemCnt:Integer;
  snode:TTreeNode;
Begin
  stream.Read(itemCnt, sizeof(itemCnt));
  //Text
  stream.Read(len, sizeof(len));
  stream.Read(buf^, len);
  node.Text := MakeString(buf, len);
  pb.StepIt;
  for n := 0 to itemCnt-1 do
  begin
    snode := node.Owner.AddChild(node, '');
    ReadNode(stream, snode, buf);
  end;
  Application.ProcessMessages;
end;

Procedure TFMain.OpenProject (FileName:AnsiString);
var
  useFuzzy:Boolean;
  kind:LKind;
  adr,n, m, k, u, ps, len, num, cnum, evnum, size, infosCnt, bssCnt, _ver:Integer;
  Items,topIdxU, itemIdxU, topIdxI, itemIdxI, topIdxC,namesNum,nodesNum:Integer;
  KBFileName,adres:AnsiString;
  projectFile:THandle;
  recN:InfoRec;
  recT:PTypeRec;
  recU:PUnitRec;
  segInfo:PSegmentInfo;
  eInfo:PEventInfo;
  cInfo:PComponentInfo;
  buf,pImage:PAnsiChar;
  pFlags:PInteger;
  inStream:TMemoryStream;
  root:TTreeNode;
  dfm:TDfm;
  magic:Array[1..12] of Char;
Begin
  useFuzzy := true;
  IDPFile := FileName;

  Screen.Cursor := crHourGlass;
  projectFile := FileOpen(FileName, fmOpenRead or fmShareDenyNone);
  //Читаем версию Дельфи и максимальную длину буфера
  FileSeek(projectFile, 12, Ord(soBeginning));
  FileRead(projectFile,_ver, sizeof(_ver));

  DelphiVersion := _ver and not (USER_KNOWLEDGEBASE or SOURCE_LIBRARY);
  UserKnowledgeBase := false;
  SourceIsLibrary := (_ver and SOURCE_LIBRARY)<>0;
  if (_ver and USER_KNOWLEDGEBASE)<>0 then
  Begin
    ShowMessage('Choose original Knowledge Base');
    OpenDlg.InitialDir := WrkDir;
  	OpenDlg.FileName := '';
  	OpenDlg.Filter := 'BIN|*.bin|All files|*.*';
    if OpenDlg.Execute then
    Begin
      KBFileName := OpenDlg.FileName;
      UserKnowledgeBase := true;
    End
    else
    Begin
      ShowMessage('Native Knowledge Base will be used!');
      useFuzzy := false;
    End;
  End;
  if not UserKnowledgeBase then KBFileName := AppDir + 'kb' + IntToStr(DelphiVersion) + '.bin';
  
  MaxBufLen := 0;
  FileSeek(projectFile, -4, Ord(soEnd));
  FileRead(projectFile,MaxBufLen, sizeof(MaxBufLen));
  FileClose(projectFile);

  if not KBase.Open(KBFileName) then
  Begin
    Screen.Cursor := crDefault;
    ShowMessage('Cannot open KnowledgeBase (may be incorrect Version)');
    Exit;
  End;

  Caption := 'Interactive Delphi Reconstructor by crypto: ' + IDPFile + ' (D' + IntToStr(DelphiVersion) + ')';

  SetVmtConsts(DelphiVersion);

  //На время загрузки проекта отключаем пункты меню
  miLoadFile.Enabled := false;
  miOpenProject.Enabled := false;
  miMRF.Enabled := false;
  miSaveProject.Enabled := false;
  miSaveDelphiProject.Enabled := false;
  lbCXrefs.Enabled := false;

  pb.Visible := true;
  Update;

  GetMem(buf,MaxBufLen);
  inStream := TMemoryStream.Create; //new TFileStream(IDPFile, fmOpenRead);
  inStream.LoadFromFile(IDPFile);

  inStream.Read(magic[1], 12);
  inStream.Read(_ver, sizeof(_ver));
  DelphiVersion := _ver and not (USER_KNOWLEDGEBASE or SOURCE_LIBRARY);

  inStream.Read(EP, sizeof(EP));
  inStream.Read(ImageBase, sizeof(ImageBase));
  inStream.Read(ImageSize, sizeof(ImageSize));
  inStream.Read(TotalSize, sizeof(TotalSize));
  inStream.Read(CodeBase, sizeof(CodeBase));
  inStream.Read(CodeSize, sizeof(CodeSize));
  inStream.Read(CodeStart, sizeof(CodeStart));

  inStream.Read(DataBase, sizeof(DataBase));
  inStream.Read(DataSize, sizeof(DataSize));
  inStream.Read(DataStart, sizeof(DataStart));

  //SegmentList
  inStream.Read(num, sizeof(num));
  for n := 0 to num-1 do
  Begin
    New(segInfo);
    inStream.Read(segInfo.Start, sizeof(segInfo.Start));
    inStream.Read(segInfo.Size, sizeof(segInfo.Size));
    inStream.Read(segInfo.Flags, sizeof(segInfo.Flags));
    inStream.Read(len, sizeof(len));
    inStream.Read(buf^, len);
    segInfo.Name := MakeString(buf, len);
    SegmentList.Add(segInfo);
  End;

  GetMem(Image,TotalSize);
  Code := Image + CodeStart;
  Data := Image + DataStart;
  Items := TotalSize;
  pImage := Image;

  while Items >= MAX_ITEMS do
  Begin
    inStream.Read(pImage^, MAX_ITEMS);
    Inc(pImage, MAX_ITEMS);
    Dec(Items, MAX_ITEMS);
  End;
  if Items<>0 then inStream.Read(pImage^, Items);

  GetMem(FlagList,SizeOf(DWORD)*TotalSize);
  FillMemory(FlagList,SizeOf(DWORD)*TotalSize,0);
  Items := TotalSize;
  pFlags := PInteger(FlagList);

  while Items >= MAX_ITEMS do
  Begin
    inStream.Read(pFlags^, sizeof(DWORD)*MAX_ITEMS);
    Inc(pFlags, MAX_ITEMS);
    Dec(Items, MAX_ITEMS);
  End;
  if Items<>0 then inStream.Read(pFlags^, sizeof(DWORD)*Items);

  SetLength(InfoList,TotalSize);
  FillMemory(@InfoList[0],SizeOf(InfoRec)*TotalSize,0);

  inStream.Read(infosCnt, sizeof(infosCnt));
  StartProgress('Reading Infos Objects (number = '+IntToStr(infosCnt)+')...', '', TotalSize div 4096);
  for n := 0 to TotalSize-1 do
  Begin
    if (n and 4095) = 0 then
    Begin
      pb.StepIt;
      Application.ProcessMessages;
    End;
    inStream.Read(ps, sizeof(ps));
    if ps = -1 then break;
    inStream.Read(kind, sizeof(kind));
    recN := InfoRec.Create(ps, kind);
    recN.Load(inStream, buf);
  End;
  //BSSInfos
  BSSInfos := TStringList.Create;
  inStream.Read(bssCnt, sizeof(bssCnt));
  for n := 0 to bssCnt-1 do
  Begin
    inStream.Read(len, sizeof(len));
    inStream.Read(buf^, len);
    adres := MakeString(buf, len);
    inStream.Read(kind, sizeof(kind));
    recN := InfoRec.Create(-1, kind);
    recN.Load(inStream, buf);
    BSSInfos.AddObject(adres, TObject(recN));
  End;
  BSSInfos.Sorted := true;
  lbCXrefs.Enabled := true;

  //Units
  inStream.Read(num, sizeof(num));
  StartProgress('Reading Units (number = '+IntToStr(num)+')...', '', num);

  UnitsNum := num;
  for n := 0 to UnitsNum-1 do
  Begin
    pb.StepIt;
    Application.ProcessMessages;
    New(recU);
    with inStream, recU^ do
    begin
      Read(trivial, sizeof(trivial));
      Read(trivialIni, sizeof(trivialIni));
      Read(trivialFin, sizeof(trivialFin));
      Read(kb, sizeof(kb));
      Read(fromAdr, sizeof(fromAdr));
      Read(toAdr, sizeof(toAdr));
      Read(finadr, sizeof(finadr));
      Read(finSize, sizeof(finSize));
      Read(iniadr, sizeof(iniadr));
      Read(iniSize, sizeof(iniSize));
    end;
    recU.matchedPercent := 0;
    inStream.Read(recU.iniOrder, sizeof(recU.iniOrder));
    recU.names := TStringList.Create;
    namesNum := 0;
    inStream.Read(namesNum, sizeof(namesNum));
    for u := 0 to namesNum-1 do
    Begin
      inStream.Read(len, sizeof(len));
      inStream.Read(buf^, len);
      SetUnitName(recU, MakeString(buf, len));
    End;
    Units.Add(recU);
  End;
  UnitSortField := 0;
  CurUnitAdr := 0;
  topIdxI := 0;
  itemIdxI := -1;
  
  if UnitsNum<>0 then
  Begin
    inStream.Read(UnitSortField, sizeof(UnitSortField));
    inStream.Read(CurUnitAdr, sizeof(CurUnitAdr));
    inStream.Read(topIdxU, sizeof(topIdxU));
    inStream.Read(itemIdxU, sizeof(itemIdxU));
    //UnitItems
    if CurUnitAdr<>0 then
    Begin
 	  	inStream.Read(topIdxI, sizeof(topIdxI));
    	inStream.Read(itemIdxI, sizeof(itemIdxI));
    End;
  End;

  tsUnits.Enabled := true;
  ShowUnits(true);

  ShowUnitItems(GetUnit(CurUnitAdr), topIdxI, itemIdxI);

  miRenameUnit.Enabled := true;
  miSearchUnit.Enabled := true;
  miCopyList.Enabled := true;

  miEditFunctionC.Enabled := true;
  miEditFunctionI.Enabled := true;
  miFuzzyScanKB.Enabled := true;
  miSearchItem.Enabled := true;

  //Types
  inStream.Read(num, sizeof(num));
  for n := 0 to num-1 do
  Begin
    New(recT);
    inStream.Read(recT.kind, sizeof(recT.kind));
    inStream.Read(recT.adr, sizeof(recT.adr));
    inStream.Read(len, sizeof(len));
    inStream.Read(buf^, len);
    recT.name := MakeString(buf, len);
    OwnTypeList.Add(recT);
  End;
  RTTISortField := 0;
  if num<>0 then inStream.Read(RTTISortField, sizeof(RTTISortField));
  //UpdateRTTIs
  tsRTTIs.Enabled := true;
  miSearchRTTI.Enabled := true;
  miSortRTTI.Enabled := true;

  case RTTISortField of
    0:
      begin
        miSortRTTIsByAdr.Checked := true;
        miSortRTTIsByKnd.Checked := false;
        miSortRTTIsByNam.Checked := false;
      end;
    1:
      begin
        miSortRTTIsByAdr.Checked := false;
        miSortRTTIsByKnd.Checked := true;
        miSortRTTIsByNam.Checked := false;
      end;
    2:
      begin
        miSortRTTIsByAdr.Checked := false;
        miSortRTTIsByKnd.Checked := false;
        miSortRTTIsByNam.Checked := true;
      end;
  End;
  ShowRTTIs;

  //Forms
  inStream.Read(num, sizeof(num));
  for n := 0 to num-1 do
  Begin
    dfm := TDfm.Create;
    //Flags
    inStream.Read(dfm.Flags, sizeof(dfm.Flags));
    //ResName
    inStream.Read(len, sizeof(len));
    inStream.Read(buf^, len);
    dfm.ResName := MakeString(buf, len);
    //Name
    inStream.Read(len, sizeof(len));
    inStream.Read(buf^, len);
    dfm.Name := MakeString(buf, len);
    //ClassName
    inStream.Read(len, sizeof(len));
    inStream.Read(buf^, len);
    dfm.FormClass := MakeString(buf, len);
    //MemStream
    inStream.Read(size, sizeof(size));
    dfm.MemStream.Size := size;
    while size >= 4096 do
    Begin
      inStream.Read(buf^, 4096);
      dfm.MemStream.Write(buf^, 4096);
      Dec(size, 4096);
    End;
    if size<>0 then
    Begin
      inStream.Read(buf^, size);
      dfm.MemStream.Write(buf^, size);
    End;
    //Events
    dfm.Events := TList.Create;
    inStream.Read(evnum, sizeof(evnum));
    for m := 0 to evnum-1 do
    Begin
      New(eInfo);
      //EventName
      inStream.Read(len, sizeof(len));
      inStream.Read(buf^, len);
      eInfo.EventName := MakeString(buf, len);
      //ProcName
      inStream.Read(len, sizeof(len));
      inStream.Read(buf^, len);
      eInfo.ProcName := MakeString(buf, len);
      dfm.Events.Add(eInfo);
    End;
    //Components
    inStream.Read(cnum, sizeof(cnum));
    if cnum<>0 then
    Begin
    	dfm.Components := TList.Create;
      for m := 0 to cnum-1 do
      Begin
        New(cInfo);
        //Inherited
        inStream.Read(cInfo.Inherit, sizeof(cInfo.Inherit));
        //HasGlyph
        inStream.Read(cInfo.HasGlyph, sizeof(cInfo.HasGlyph));
        //Name
        inStream.Read(len, sizeof(len));
        inStream.Read(buf^, len);
        cInfo.Name := MakeString(buf, len);
        //ClassName
        inStream.Read(len, sizeof(len));
        inStream.Read(buf^, len);
        cInfo.ClasName := MakeString(buf, len);
        //Events
        cInfo.Events := TList.Create;
        inStream.Read(evnum, sizeof(evnum));
        for k := 0 to evnum-1 do
        Begin
          New(eInfo);
          //EventName
          inStream.Read(len, sizeof(len));
          inStream.Read(buf^, len);
          eInfo.EventName := MakeString(buf, len);
          //ProcName
          inStream.Read(len, sizeof(len));
          inStream.Read(buf^, len);
          eInfo.ProcName := MakeString(buf, len);
          cInfo.Events.Add(eInfo);
        End;
        dfm.Components.Add(cInfo);
      End;
    End;
    ResInfo.FormList.Add(dfm);
  End;
  //UpdateForms
  ResInfo.ShowResources(lbForms);
  //Aliases
  inStream.Read(num, sizeof(num));
  for n := 0 to num-1 do
  Begin
    inStream.Read(len, sizeof(len));
    inStream.Read(buf^, len);
    ResInfo.Aliases.Add(MakeString(buf, len));
  End;
  InitAliases(false);
  tsForms.Enabled := lbForms.Items.Count > 0;

  //CodeHistory
  inStream.Read(CodeHistorySize, sizeof(CodeHistorySize));
  inStream.Read(CodeHistoryPtr, sizeof(CodeHistoryPtr));
  inStream.Read(CodeHistoryMax, sizeof(CodeHistoryMax));
  bCodePrev.Enabled := CodeHistoryPtr >= 0;
  bCodeNext.Enabled := CodeHistoryPtr < CodeHistoryMax;

  SetLength(CodeHistory, CodeHistorySize);
  for n := 0 to CodeHistorySize-1 do
    inStream.Read(CodeHistory[n], sizeof(PROCHISTORYREC));

  inStream.Read(CurProcAdr, sizeof(CurProcAdr));
  inStream.Read(topIdxC, sizeof(topIdxC));

  //Important variables
  inStream.Read(HInstanceVarAdr, sizeof(HInstanceVarAdr));
  inStream.Read(LastTls, sizeof(LastTls));

  inStream.Read(Reserved, sizeof(Reserved));
  inStream.Read(LastResStrNo, sizeof(LastResStrNo));

  inStream.Read(CtdRegAdr, sizeof(CtdRegAdr));

  //UpdateVmtList
  FillVmtList;
  //UpdateCode
  tsCodeView.Enabled := true;
  miGoTo.Enabled := true;
  miExploreAdr.Enabled := true;
  miSwitchFlag.Enabled := cbMultipleSelection.Checked;
  bEP.Enabled := true;
  adr := CurProcAdr;
  CurProcAdr := 0;
  ShowCode(adr, 0, -1, topIdxC);
  //UpdateStrings
  tsStrings.Enabled := true;
  miSearchString.Enabled := true;
  ShowStrings(0);
  //UpdateNames
  tsNames.Enabled := true;
  ShowNames(0);
  Update;

  //Class Viewer
  //Total nodes num (for progress)
  inStream.Read(nodesNum, sizeof(nodesNum));
  if nodesNum<>0 then
  Begin
    StartProgress('Reading ClassViewer Tree Nodes (number = '+ IntToStr(nodesNum) +')...', '', nodesNum);
    tvClassesFull.Items.BeginUpdate;
    root := tvClassesFull.Items.Add(Nil, '');
    ReadNode(inStream, root, buf);
    tvClassesFull.Items.EndUpdate;
    ClassTreeDone := true;
  End;
  //UpdateClassViewer
  tsClassView.Enabled := true;
  miViewClass.Enabled := true;
  miSearchVMT.Enabled := true;
  miCollapseAll.Enabled := true;
  miEditClass.Enabled := true;

  if ClassTreeDone then
  Begin
    root := tvClassesFull.Items[0];
    root.Expanded := true;
    rgViewerMode.ItemIndex := 0;
    rgViewerMode.Enabled := true;
    tvClassesFull.BringToFront;
  End
  else
  Begin
    rgViewerMode.ItemIndex := 1;
    rgViewerMode.Enabled := false;
    tvClassesShort.BringToFront;
  End;
  miClassTreeBuilder.Enabled := true;

  //Для проверки
  inStream.Read(MaxBufLen, sizeof(MaxBufLen));

  if Assigned(buf) then FreeMem(buf);
  inStream.Free;

  ProjectLoaded := true;
  ProjectModified := false;

  AddIdp2MRF(FileName);

  pb.Position := 0;
  pb.Visible := false;
  sb.Panels[0].Text := '';
  sb.Panels[1].Text := '';
  //Восстанавливаем пункты меню
  miLoadFile.Enabled := true;
  miOpenProject.Enabled := true;
  miMRF.Enabled := true;
  miSaveProject.Enabled := true;
  miSaveDelphiProject.Enabled := true;

  miEditFunctionC.Enabled := true;
  miEditFunctionI.Enabled := true;
  miFuzzyScanKB.Enabled := useFuzzy;
  miSearchItem.Enabled := true;
  miName.Enabled := true;
  miViewProto.Enabled := true;
  bDecompile.Enabled := true;

  miMapGenerator.Enabled := true;
  miCommentsGenerator.Enabled := true;
  miIDCGenerator.Enabled := true;
  miLister.Enabled := true;
  miKBTypeInfo.Enabled := true;
  miCtdPassword.Enabled := IsValidCodeAdr(CtdRegAdr);
  miHex2Double.Enabled := true;

  WrkDir := ExtractFileDir(FileName);
  Screen.Cursor := crDefault;
end;

procedure TFMain.miExe1Click(Sender : TObject);
begin
  LoadFile(miExe1.Caption, miMRF[0].Tag);
end;

procedure TFMain.miExe2Click(Sender : TObject);
begin
  LoadFile(miExe2.Caption, miMRF[1].Tag);
end;

procedure TFMain.miExe3Click(Sender : TObject);
begin
  LoadFile(miExe3.Caption, miMRF[2].Tag);
end;

procedure TFMain.miExe4Click(Sender : TObject);
begin
  LoadFile(miExe4.Caption, miMRF[3].Tag);
end;

procedure TFMain.miExe5Click(Sender : TObject);
begin
  LoadFile(miExe5.Caption, miMRF[4].Tag);
end;

procedure TFMain.miExe6Click(Sender : TObject);
begin
  LoadFile(miExe6.Caption, miMRF[5].Tag);
end;

procedure TFMain.miExe7Click(Sender : TObject);
begin
  LoadFile(miExe7.Caption, miMRF[6].Tag);
end;

procedure TFMain.miExe8Click(Sender : TObject);
begin
  LoadFile(miExe8.Caption, miMRF[7].Tag);
end;

procedure TFMain.miIdp1Click(Sender : TObject);
begin
  LoadFile(miIdp1.Caption, -1);
end;

procedure TFMain.miIdp2Click(Sender : TObject);
begin
  LoadFile(miIdp2.Caption, -1);
end;

procedure TFMain.miIdp3Click(Sender : TObject);
begin
  LoadFile(miIdp3.Caption, -1);
end;

procedure TFMain.miIdp4Click(Sender : TObject);
begin
  LoadFile(miIdp4.Caption, -1);
end;

procedure TFMain.miIdp5Click(Sender : TObject);
begin
  LoadFile(miIdp5.Caption, -1);
end;

procedure TFMain.miIdp6Click(Sender : TObject);
begin
  LoadFile(miIdp6.Caption, -1);
end;

procedure TFMain.miIdp7Click(Sender : TObject);
begin
  LoadFile(miIdp7.Caption, -1);
end;

procedure TFMain.miIdp8Click(Sender : TObject);
begin
  LoadFile(miIdp8.Caption, -1);
end;

//----------------
//SAVE PROJECT
//----------------
procedure TFMain.miSaveProjectClick(Sender : TObject);
begin
  if IDPFile = '' Then IDPFile := ChangeFileExt(SourceFile, '.idp');

  SaveDlg.InitialDir := WrkDir;
  SaveDlg.Filter := 'IDP|*.idp';
  SaveDlg.FileName := IDPFile;

  if SaveDlg.Execute then SaveProject(SaveDlg.FileName);
end;

Procedure TFMain.WriteNode (stream:TStream; node:TTreeNode);
var
  itemCnt,Len,n:Integer;
Begin
  itemCnt := node.Count;
  stream.Write(itemCnt, sizeof(itemCnt));
  pb.StepIt;
  //Text
  len := Length(node.Text);
  if len > MaxBufLen then MaxBufLen := len;
  stream.Write(len, sizeof(len));
  stream.Write(node.Text[1], len);
  for n := 0 to itemCnt-1 do
    WriteNode(stream, node.Item[n]);
  Application.ProcessMessages;
end;

Procedure TFMain.SaveProject (FileName:AnsiString);
const
  magic:Array[1..12] of Char = 'IDR proj v.3';
var
  kind:LKind;
  ver:Cardinal;
  n, m, k, u,len, num, cnum, evnum, size, ps, res, infosCnt, topIdx, itemIdx:Integer;
  items,bssCnt,namesNum:Integer;
  pImage:PAnsiChar;
  pFlags:PInteger;
  recN:InfoRec;
  recU:PUnitRec;
  recT:PTypeRec;
  eInfo:PEventInfo;
  cInfo:PComponentInfo;
  dfm:TDfm;
  outStream:TMemoryStream;
  segInfo:PSegmentInfo;
  phRec:PROCHISTORYREC;
  root:TTreeNode;
  tmp:AnsiString;
  buf:Array[0..4095] of Byte;
Begin
  if FileExists(FileName) then
    if Application.MessageBox('File already exists. Overwrite?', 'Warning', MB_YESNO) = IDNO then Exit;

  Screen.Cursor := crHourGlass;
  IDPFile := FileName;
  try
    outStream := TMemoryStream.Create;
    pb.Visible := true;

    outStream.Write(magic[1], 12);
    ver := DelphiVersion;
    if UserKnowledgeBase then ver := ver or USER_KNOWLEDGEBASE;
    if SourceIsLibrary then ver := ver or SOURCE_LIBRARY;
    outStream.Write(ver, sizeof(ver));

    outStream.Write(EP, sizeof(EP));
    outStream.Write(ImageBase, sizeof(ImageBase));
    outStream.Write(ImageSize, sizeof(ImageSize));
    outStream.Write(TotalSize, sizeof(TotalSize));
    outStream.Write(CodeBase, sizeof(CodeBase));
    outStream.Write(CodeSize, sizeof(CodeSize));
    outStream.Write(CodeStart, sizeof(CodeStart));

    outStream.Write(DataBase, sizeof(DataBase));
    outStream.Write(DataSize, sizeof(DataSize));
    outStream.Write(DataStart, sizeof(DataStart));
    //SegmentList
    num := SegmentList.Count;
    outStream.Write(num, sizeof(num));
    for n := 0 to num-1 do
    Begin
      segInfo := SegmentList[n];
      outStream.Write(segInfo.Start, sizeof(segInfo.Start));
      outStream.Write(segInfo.Size, sizeof(segInfo.Size));
      outStream.Write(segInfo.Flags, sizeof(segInfo.Flags));
      len := Length(segInfo.Name); 
      if len > MaxBufLen then MaxBufLen := len;
      outStream.Write(len, sizeof(len));
      outStream.Write(segInfo.Name[1], len);
    End;

    Items := TotalSize;
    pImage := Image;
    StartProgress('Writing Image...', '', (Items + MAX_ITEMS - 1) div MAX_ITEMS);
    while Items >= MAX_ITEMS do
    Begin
      pb.StepIt;
      outStream.Write(pImage^, MAX_ITEMS);
      Inc(pImage, MAX_ITEMS);
      Dec(Items, MAX_ITEMS);
    End;
    if Items<>0 then outStream.Write(pImage^, Items);

    Items := TotalSize;
    pFlags := PInteger(FlagList);
    StartProgress('Writing Flags...', '', (Items + MAX_ITEMS - 1) div MAX_ITEMS);
    while Items >= MAX_ITEMS do
    Begin
      pb.StepIt;
      outStream.Write(pFlags^, sizeof(DWORD)*MAX_ITEMS);
      Inc(pFlags, MAX_ITEMS);
      Dec(Items, MAX_ITEMS);
    End;
    if Items<>0 then outStream.Write(pFlags^, sizeof(DWORD)*Items);

    infosCnt := 0;
    for n := 0 to TotalSize-1 do
    Begin
      recN := GetInfoRec(Pos2Adr(n));
      if Assigned(recN) then Inc(infosCnt);
    End;
    outStream.Write(infosCnt, sizeof(infosCnt));

    StartProgress('Writing Infos Objects (number = ' + IntToStr(infosCnt) + ')...', '', TotalSize div 4096);
    MaxBufLen := 0;
    try
      for n := 0 to TotalSize-1 do
      Begin
        if (n and 4095) = 0 then
        Begin
          pb.StepIt;
          Application.ProcessMessages;
        End;
        recN := GetInfoRec(Pos2Adr(n));
        if Assigned(recN) then
        Begin
          //Position
          ps := n;
          outStream.Write(ps, sizeof(ps));
          kind := recN.kind;
          outStream.Write(kind, sizeof(kind));
          recN.Save(outStream);
        End;
      End;
    Except
      on E:Exception do
        ShowMessage('Error at ' + Val2Str(Pos2Adr(n),8));
    end;
    //Last position := -1 . end of items
    ps := -1;
    outStream.Write(ps, sizeof(ps));

    //BSSInfos
    bssCnt := BSSInfos.Count;
    outStream.Write(bssCnt, sizeof(bssCnt));
    for n := 0 to bssCnt-1 do
    Begin
      tmp := BSSInfos[n];
      len := Length(tmp);
      if len > MaxBufLen then MaxBufLen := len;
      outStream.Write(len, sizeof(len));
      outStream.Write(tmp[1], len);
      recN := InfoRec(BSSInfos.Objects[n]);
      kind := recN.kind;
      outStream.Write(kind, sizeof(kind));
      recN.Save(outStream);
    End;

    //Units
    num := UnitsNum;
    StartProgress('Writing Units (number = '+ IntToStr(num) +')...', '', num);
    outStream.Write(num, sizeof(num));
    for n := 0 to num-1 do
    Begin
      pb.StepIt;
      Application.ProcessMessages;
      recU := Units[n];
      outStream.Write(recU.trivial, sizeof(recU.trivial));
      outStream.Write(recU.trivialIni, sizeof(recU.trivialIni));
      outStream.Write(recU.trivialFin, sizeof(recU.trivialFin));
      outStream.Write(recU.kb, sizeof(recU.kb));
      outStream.Write(recU.fromAdr, sizeof(recU.fromAdr));
      outStream.Write(recU.toAdr, sizeof(recU.toAdr));
      outStream.Write(recU.finadr, sizeof(recU.finadr));
      outStream.Write(recU.finSize, sizeof(recU.finSize));
      outStream.Write(recU.iniadr, sizeof(recU.iniadr));
      outStream.Write(recU.iniSize, sizeof(recU.iniSize));
      outStream.Write(recU.iniOrder, sizeof(recU.iniOrder));
      namesNum := recU.names.Count;
      outStream.Write(namesNum, sizeof(namesNum));
      for u := 0 to namesNum-1 do
      Begin
        len := Length(recU.names[u]);
        if len > MaxBufLen then MaxBufLen := len;
        outStream.Write(len, sizeof(len));
        tmp:=recU.names[u];
        outStream.Write(tmp[1], len);
      End;
    End;
    if num<>0 then
    Begin
      outStream.Write(UnitSortField, sizeof(UnitSortField));
      outStream.Write(CurUnitAdr, sizeof(CurUnitAdr));
      topIdx := lbUnits.TopIndex;
      outStream.Write(topIdx, sizeof(topIdx));
      itemIdx := lbUnits.ItemIndex;
      outStream.Write(itemIdx, sizeof(itemIdx));
      //UnitItems
      if CurUnitAdr<>0 then
      Begin
      	topIdx := lbUnitItems.TopIndex;
      	outStream.Write(topIdx, sizeof(topIdx));
        itemIdx := lbUnitItems.ItemIndex;
        outStream.Write(itemIdx, sizeof(itemIdx));
      End;
    End;

    //Types
    num := OwnTypeList.Count;
    StartProgress('Writing Types (number = '+ IntToStr(num) +')...', '', num);
    outStream.Write(num, sizeof(num));
    for n := 0 to num-1 do
    Begin
      pb.StepIt;
      Application.ProcessMessages;
      recT := OwnTypeList[n];
      outStream.Write(recT.kind, sizeof(recT.kind));
      outStream.Write(recT.adr, sizeof(recT.adr));
      len := Length(recT.name); 
      if len > MaxBufLen then MaxBufLen := len;
      outStream.Write(len, sizeof(len));
      outStream.Write(recT.name[1], len);
    End;
    if num<>0 then outStream.Write(RTTISortField, sizeof(RTTISortField));

    //Forms
    num := ResInfo.FormList.Count;
    StartProgress('Writing Forms (number = '+ IntToStr(num) +')...', '', num);
    outStream.Write(num, sizeof(num));
    for n := 0 to num-1 do
    Begin
      pb.StepIt;
      Application.ProcessMessages;
      dfm := TDfm(ResInfo.FormList[n]);
      //Flags
      outStream.Write(dfm.Flags, sizeof(dfm.Flags));
      //ResName
      len := Length(dfm.ResName); 
      if len > MaxBufLen then MaxBufLen := len;
      outStream.Write(len, sizeof(len));
      outStream.Write(dfm.ResName[1], len);
      //Name
      len := Length(dfm.Name); 
      if len > MaxBufLen then MaxBufLen := len;
      outStream.Write(len, sizeof(len));
      outStream.Write(dfm.Name[1], len);
      //ClassName
      len := Length(dfm.FormClass); 
      if len > MaxBufLen then MaxBufLen := len;
      outStream.Write(len, sizeof(len));
      outStream.Write(dfm.FormClass[1], len);
      //MemStream
      size := dfm.MemStream.Size;
      outStream.Write(size, sizeof(size));
      dfm.MemStream.SaveToStream(outStream);
      //Events
      if Assigned(dfm.Events) then evnum := dfm.Events.Count
        else evnum:= 0;
      outStream.Write(evnum, sizeof(evnum));
      for m := 0 to evnum-1 do
      Begin
      	eInfo := dfm.Events[m];
        //EventName
        len := Length(eInfo.EventName);
        if len > MaxBufLen then MaxBufLen := len;
        outStream.Write(len, sizeof(len));
        outStream.Write(eInfo.EventName[1], len);
        //ProcName
        len := Length(eInfo.ProcName); 
        if len > MaxBufLen then MaxBufLen := len;
        outStream.Write(len, sizeof(len));
        outStream.Write(eInfo.ProcName[1], len);
      End;
      //Components
      if Assigned(dfm.Components) then cnum := dfm.Components.Count
        else cnum:= 0;
      outStream.Write(cnum, sizeof(cnum));
      for m := 0 to cnum-1 do
      Begin
        cInfo := dfm.Components[m];
        //Inherited
        outStream.Write(cInfo.Inherit, sizeof(cInfo.Inherit));
        //HasGlyph
        outStream.Write(cInfo.HasGlyph, sizeof(cInfo.HasGlyph));
        //Name
        len := Length(cInfo.Name); 
        if len > MaxBufLen then MaxBufLen := len;
        outStream.Write(len, sizeof(len));
        outStream.Write(cInfo.Name[1], len);
        //ClassName
        len := Length(cInfo.ClasName); 
        if len > MaxBufLen then MaxBufLen := len;
        outStream.Write(len, sizeof(len));
        outStream.Write(cInfo.ClasName[1], len);
        //Events
        if Assigned(cInfo.Events) then evnum := cInfo.Events.Count
          else evnum:= 0;
        outStream.Write(evnum, sizeof(evnum));
        for k := 0 to evnum-1 do
        Begin
          eInfo := cInfo.Events[k];
          //EventName
          len := Length(eInfo.EventName); 
          if len > MaxBufLen then MaxBufLen := len;
          outStream.Write(len, sizeof(len));
          outStream.Write(eInfo.EventName[1], len);
          //ProcName
          len := Length(eInfo.ProcName); 
          if len > MaxBufLen then MaxBufLen := len;
          outStream.Write(len, sizeof(len));
          outStream.Write(eInfo.ProcName[1], len);
        End;
      End;
    End;
    //Aliases
    num := ResInfo.Aliases.Count;
    StartProgress('Writing Aliases  (number = '+ IntToStr(num) +')...', '', num);
    outStream.Write(num, sizeof(num));
    for n := 0 to num-1 do
    Begin
      pb.StepIt;
      Application.ProcessMessages;
      len := Length(ResInfo.Aliases[n]); 
      if len > MaxBufLen then MaxBufLen := len;
      outStream.Write(len, sizeof(len));
      tmp:=ResInfo.Aliases[n];
      outStream.Write(tmp[1], len);
    End;

    //CodeHistory
    outStream.Write(CodeHistorySize, sizeof(CodeHistorySize));
    outStream.Write(CodeHistoryPtr, sizeof(CodeHistoryPtr));
    outStream.Write(CodeHistoryMax, sizeof(CodeHistoryMax));
    StartProgress('Writing Code History Items (number = '+ IntToStr(CodeHistorySize) +')...', '', CodeHistorySize);
    for n := 0 to CodeHistorySize-1 do
    Begin
      pb.StepIt;
      Application.ProcessMessages;
      outStream.Write(CodeHistory[n], sizeof(PROCHISTORYREC));
    End;

    outStream.Write(CurProcAdr, sizeof(CurProcAdr));
    topIdx := lbCode.TopIndex;
    outStream.Write(topIdx, sizeof(topIdx));

    //Important variables
    outStream.Write(HInstanceVarAdr, sizeof(HInstanceVarAdr));
    outStream.Write(LastTls, sizeof(LastTls));

    outStream.Write(Reserved, sizeof(Reserved));
    outStream.Write(LastResStrNo, sizeof(LastResStrNo));

    outStream.Write(CtdRegAdr, sizeof(CtdRegAdr));

    //Class Viewer
    //Total nodes (for progress)
    num := 0;
    if ClassTreeDone then num := tvClassesFull.Items.Count;
    if (num<>0) and (Application.MessageBox('Save full Tree of Classes?', 'Warning', MB_YESNO) = IDYES) then
    Begin
      outStream.Write(num, sizeof(num));
      if num<>0 then
      Begin
        StartProgress('Writing ClassViewer Tree Nodes (number = '+ IntToStr(num) +')...', '', num);
        root := tvClassesFull.Items.GetFirstNode;
        WriteNode(outStream, root);
      End;
    End
    else
    Begin
      num := 0;
      outStream.Write(num, sizeof(num));
    End;
    //At end write MaxBufLen
    outStream.Write(MaxBufLen, sizeof(MaxBufLen));
    outStream.SaveToFile(IDPFile);
    outStream.Free;

    ProjectModified := false;
    AddIdp2MRF(FileName);

    pb.Position := 0;
    pb.Visible := false;
    sb.Panels[0].Text := '';
    sb.Panels[1].Text := '';
  except
    on E:EFCreateError do
      ShowMessage('Cannot open output file ' + IDPFile);
  end;
  Screen.Cursor := crDefault;
end;

Procedure TFMain.AddExe2MRF (FileName:AnsiString);
var
  n,m:Integer;
Begin
  for n := 0 to 7 do
    if SameText(FileName, miMRF[n].Caption) Then break;
  if n = 8 then Dec(n);
  for m := n downto 1 do
  Begin
    miMRF.Items[m].Caption := miMRF.Items[m - 1].Caption;
    miMRF.Items[m].Tag := miMRF.Items[m - 1].Tag;
    miMRF.Items[m].Visible := miMRF.Items[m].Caption <> '';
  end;
  miMRF.Items[0].Caption := FileName;
  miMRF.Items[0].Tag := DelphiVersion;
  miMRF.Items[0].Visible := true;
end;

Procedure TFMain.AddIdp2MRF (FileName:AnsiString);
var
  n,m:Integer;
Begin
  for n := 9 to 16 do
    if SameText(FileName, miMRF[n].Caption) then break;
  if n = 17 then Dec(n);
  for m := n downto 10 do
  begin
    miMRF.Items[m].Caption := miMRF.Items[m - 1].Caption;
    miMRF.Items[m].Visible := miMRF.Items[m].Caption <> '';
  end;
  miMRF.Items[9].Caption := FileName;
  miMRF.Items[9].Visible := true;
end;

procedure TFMain.miKBTypeInfoClick(Sender : TObject);
var
  idx:Integer;
  pInfo:MProcInfo;
  tInfo:MTypeInfo;
  clasName, propName, sName:AnsiString;
begin
  sName := InputDialogExec('Enter Type Name', 'Name:', '');
  if sName <> '' then
  begin
    //Procedure
    if KBase.GetKBProcInfo(PAnsiChar(sName), pInfo, idx) then
    begin
      FTypeInfo.memDescription.Clear;
      FTypeInfo.memDescription.Lines.Add(KBase.GetProcPrototype(@pInfo));
      FTypeInfo.ShowModal;
      Exit;
    end;
    //Type
    if KBase.GetKBTypeInfo(PAnsiChar(sName), tInfo) then
    begin
      FTypeInfo.ShowKbInfo(tInfo);
      Exit;
    end;
    //Property
    clasName := ExtractClassName(sName);
    propName := ExtractProcName(sName);
    while true do
    begin
      if KBase.GetKBPropertyInfo(PAnsiChar(clasName), propName, tInfo) then
      begin
        FTypeInfo.ShowKbInfo(tInfo);
        Exit;
      End;
      clasName := GetParentName(className);
      if clasName = '' then break;
    end;
  end;
end;

procedure TFMain.FormResize(Sender : TObject);
begin
  lbCode.Repaint;
end;

Procedure TFMain.EditFunction (Adr:Integer);
var
  rootAdr, n, m, a, cnt, size, ofs, offset, dotpos:Integer;
  recU:PUnitRec;
  recN, recN1:InfoRec;
  recX:PXrefRec;
  recV:PVmtListRec;
  recM:PMethodRec;
  aInfo:PARGINFO;
  p,line, _name, typeDef, clasName, procName:AnsiString;
Begin
  //if (Adr = EP) return;

  recU := GetUnit(Adr);
  if not Assigned(recU) then Exit;
  if (Adr = recU.iniadr) or (Adr = recU.finadr) then Exit;
  recN := GetInfoRec(Adr);
  if Assigned(recN) then
  Begin
    FEditFunctionDlg.Adr := Adr;
    if FEditFunctionDlg.ShowModal = mrOk then
    Begin
      //local vars
      if Assigned(recN.procInfo.locals) then
      Begin
        cnt := FEditFunctionDlg.lbVars.Count;
        recN.procInfo.DeleteLocals;
        for n := 0 to cnt-1 do
        Begin
          line := FEditFunctionDlg.lbVars.Items[n];
          //'-' = deleted line
          p := strtok(line, [' ']);
          //offset
          offset:=StrToIntDef('$'+p,0);
          //size
          p := strtok('', [' ']);
          size:=StrToIntDef('$'+p,0);
          //name
          p := strtok('', [' ',':']);
          if p <> '?' then _name := Trim(p)
            else _name := '';
          //type
          p := strtok('', [' ']);
          if p <> '?' then typeDef := Trim(p)
            else typeDef := '';
          recN.procInfo.AddLocal(-offset, size, name, typeDef);
        End;
      End;

      ClearFlag(cfPass2, Adr2Pos(Adr));
      AnalyzeProc2(Adr, false, false);
      AnalyzeArguments(Adr);

      //If virtual then propogate VMT names
      //!!! prototype !!!
      procName := ExtractProcName(recN.Name);
      if (recN.procInfo.flags and PF_VIRTUAL)<>0 then
      Begin
        cnt := recN.xrefs.Count;
        for n := 0 to cnt-1 do
        Begin
          recX := recN.xrefs[n];
          if recX._type = 'D' then
          Begin
            recN1 := GetInfoRec(recX.adr);
            ofs := GetMethodOfs(recN1, Adr);
            if ofs <> -1 then
            Begin
              //Down (to root)
              adr := recX.adr; 
              rootAdr := adr;
              while adr<>0 do
              Begin
                recM := GetMethodInfo(adr, 'V', ofs);
                if Assigned(recM) then rootAdr := adr;
                adr := GetParentAdr(adr);
              End;
              //Up (all classes that inherits rootAdr)
              for m := 0 to VmtList.Count-1 do
              Begin
                recV := VmtList[m];
                if IsInheritsByAdr(recV.vmtAdr, rootAdr) then
                Begin
                  recM := GetMethodInfo(recV.vmtAdr, 'V', ofs);
                  if Assigned(recM) then
                  Begin
                    clasName := GetClsName(recV.vmtAdr);
                    recM.name := clasName + '.' + procName;
                    if (recM.address <> Adr) and not recM._abstract then
                    Begin
                      recN1 := GetInfoRec(recM.address);
                      if not recN1.HasName then
                        recN1.Name:=clasName + '.' + procName
                      else
                      Begin
                        dotpos := Pos('.',recN1.Name);
                        recN1.Name:=Copy(recN1.Name,1, dotpos) + procName;
                      End;
                      //recN1.name := className + '.' + procName;
                      recN1.kind := recN.kind;
                      recN1._type := recN._type;
                      recN1.procInfo.flags := recN1.procInfo.flags or PF_VIRTUAL;
                      recN1.procInfo.DeleteArgs;
                      recN1.procInfo.AddArg($21, 0, 4, 'Self', clasName);
                      for a := 1 to recN.procInfo.args.Count-1 do
                      Begin
                        aInfo := recN.procInfo.args[a];
                        recN1.procInfo.AddArg(aInfo);
                      End;
                    End;
                  End;
                End;
              End;
            End;
          End;
        End;
      End;

      //DWORD adr := CurProcAdr;

      //Edit current proc
      if Adr = CurProcAdr then
      Begin
        RedrawCode;
        //Current proc from current unit
        if recU.fromAdr = CurUnitAdr then
          ShowUnitItems(recU, lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
      End
      else ShowUnitItems(recU, lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
      ProjectModified := true;
    End;
  End;
end;

procedure TFMain.miEditFunctionCClick(Sender : TObject);
begin
	EditFunction(CurProcAdr);
end;

procedure TFMain.miMapGeneratorClick(Sender : TObject);
var
  procName,mapName,moduleName:AnsiString;
  fMap:TextFile;
  n,adr:Integer;
  recN:InfoRec;
  recU:PUnitRec;
  exist:Boolean;
begin
  mapName:='';
  if SourceFile <> '' then mapName := ChangeFileExt(SourceFile, '.map');
  if IDPFile <> '' then mapName := ChangeFileExt(IDPFile, '.map');

  SaveDlg.InitialDir := WrkDir;
  SaveDlg.Filter := 'MAP|*.map';
  SaveDlg.FileName := mapName;

  if not SaveDlg.Execute then Exit;
  mapName := SaveDlg.FileName;
  exist:=FileExists(mapName);
  if exist then
    if Application.MessageBox('File already exists. Overwrite?', 'Warning', MB_YESNO) = IDNO then Exit;

  Screen.Cursor := crHourGlass;
  try
    AssignFile(fMap,mapName);
    if exist then Append(fMap)
      else Rewrite(fMap);
  except
    ShowMessage('Cannot open map file');
    Exit;
  End;
  WriteLn(fMap, #13#10+' Start         Length     Name                   Class');
  WriteLn(fMap, Format(' 0001:00000000 %.9XH CODE                   CODE', [CodeSize]));
  WriteLn(fMap, #13#10#13#10'  Address         Publics by Value');
  WriteLn(fMap);

  for n := 0 to CodeSize-1 do
  Begin
    if IsFlagSet(cfProcStart, n) and not IsFlagSet(cfEmbedded, n) then
    Begin
      adr := Pos2Adr(n);
      recN := GetInfoRec(adr);
      if Assigned(recN) then
      Begin
        if adr <> EP then
        Begin
          recU := GetUnit(adr);
          if Assigned(recU) then
          Begin
            moduleName := GetUnitName(recU);
            if adr = recU.iniadr then
              procName := 'Initialization'
            else if adr = recU.finadr then
              procName := 'Finalization'
            else
              procName := recN.MakeMapName(adr);

            WriteLn(fMap, Format(' 0001:%8.8X',[n]),'       ',moduleName,'.',procName);
            WriteLn(fMap, Format('%X',[adr]),' ', recN.MakePrototype(adr, true, true, false, true, false));
          End
          else
          Begin
            procName := recN.MakeMapName(adr);
            WriteLn(fMap, Format(' 0001:%8.8X',[n]),'       ', procName);
            WriteLn(fMap, Format('%X',[adr]),' ', recN.MakePrototype(adr, true, true, false, true, false));
          End;
        End
        else WriteLn(fMap, Format(' 0001:%8.8X       EntryPoint', [n]));
      End;
    End;
  End;
  WriteLn(fMap, #13#10,Format('Program entry point at 0001:%8.8X', [EP - Integer(CodeBase)]));
  CloseFile(fMap);
  Screen.Cursor := crDefault;
end;

procedure TFMain.miCommentsGeneratorClick(Sender : TObject);
var
  txtName:AnsiString;
  fLst:TextFile;
  ps,n,adr:Integer;
  recN:InfoRec;
  recU:PUnitRec;
  kind:LKind;
  exist:Boolean;
begin
  txtName:='';
  if SourceFile <> '' then txtName := ChangeFileExt(SourceFile, '.txt');
  if IDPFile <> '' then txtName := ChangeFileExt(IDPFile, '.txt');

  SaveDlg.InitialDir := WrkDir;
  SaveDlg.Filter := 'TXT|*.txt';
  SaveDlg.FileName := txtName;
  if not SaveDlg.Execute then Exit;

  txtName := SaveDlg.FileName;
  exist:=FileExists(txtName);
  if exist then
    if Application.MessageBox('File already exists. Overwrite?', 'Warning', MB_YESNO) = IDNO then Exit;

  Screen.Cursor := crHourGlass;
  try
    AssignFile(fLst,txtName);
    Rewrite(fLst);
    ///
    for n := 0 to CodeSize-1 do
    Begin
      recN := GetInfoRec(Pos2Adr(n));
      if Assigned(recN) and Assigned(recN.pcode) then
        WriteLn(fLst,Format('C %8.8X  %s',[CodeBase+n, MakeComment(recN.pcode)]));
    End;
    ///
    for n := 0 to UnitsNum-1 do
    Begin
      recU := Units[n];
      if recU.kb or recU.trivial then continue;

      for adr := recU.fromAdr to recU.toAdr-1 do
      Begin
        if adr = recU.finadr then
        Begin
          if not recU.trivialFin then OutputCode(fLst, adr, '', true);
          continue;
        End;
        if adr = recU.iniadr then
        Begin
          if not recU.trivialIni then OutputCode(fLst, adr, '', true);
          continue;
        End;
        ps := Adr2Pos(adr);
        recN := GetInfoRec(adr);
        if not Assigned(recN) then continue;

        kind := recN.kind;
        if (kind = ikProc) or
          (kind = ikFunc) or
          (kind = ikConstructor) or
          (kind = ikDestructor) then
        Begin
          OutputCode(fLst, adr, '', true);
          continue;
        End;

        if IsFlagSet(cfProcStart, ps) then
        Begin
          if recN.kind = ikConstructor then
            OutputCode(fLst, adr, '', true)
          else if recN.kind = ikDestructor then
            OutputCode(fLst, adr, '', true)
          else
            OutputCode(fLst, adr, '', true);
        End;
      End;
    End;
  Finally
    CloseFile(fLst);
    Screen.Cursor := crDefault;
  end;
end;

procedure TFMain.miIDCGeneratorClick(Sender : TObject);
const
  tmp = 'End;';
var
  idcName:AnsiString;
  fIdc:TFileStream;
  idcGen:TIDCGen;
  ps:Integer;
  recN:InfoRec;
  recU:PUnitRec;
  kind:LKind;
begin
  idcName:='';
  if SourceFile <> '' then idcName := ChangeFileExt(SourceFile, '.idc');
  if IDPFile <> '' then idcName := ChangeFileExt(IDPFile, '.idc');

  SaveDlg.InitialDir := WrkDir;
  SaveDlg.Filter := 'IDC|*.idc';
  SaveDlg.FileName := idcName;
  if not SaveDlg.Execute then Exit;

  idcName := SaveDlg.FileName;
  if FileExists(idcName) then
    if Application.MessageBox('File already exists. Overwrite?', 'Warning', MB_YESNO) = IDNO then Exit;

  Screen.Cursor := crHourGlass;
  fIdc:=Nil;
  idcGen:=Nil;
  try
    fIdc := TFileStream.Create(idcName, fmCreate or fmShareDenyWrite);
    fIdc.Seek(0, soFromEnd);
    idcGen := TIDCGen.Create(fIdc);
    idcGen.OutputHeader;

    ps := 0;
    while ps < TotalSize do
    Begin
      recN := GetInfoRec(Pos2Adr(ps));
      if not Assigned(recN) then
      begin
        Inc(ps);
        continue;
      end;
      kind := recN.kind;
      if IsFlagSet(cfRTTI, ps) then
      Begin
        recU := GetUnit(Pos2Adr(ps));
        if not Assigned(recU) then
        begin
          Inc(ps);
          continue;
        end;
        if recU.names.Count = 1 then
          idcGen.unitName := recU.names[0]
        else
          idcGen.unitName := '.Unit' + IntToStr(recU.iniOrder);

        case kind of
          ikInteger: //1
            idcGen.OutputRTTIInteger(kind, ps);
          ikChar: //2
            idcGen.OutputRTTIChar(kind, ps);
          ikEnumeration: //3
            idcGen.OutputRTTIEnumeration(kind, ps, pos2Adr(ps));
          ikFloat: //4
            idcGen.OutputRTTIFloat(kind, ps);
          ikString: //5
            idcGen.OutputRTTIString(kind, ps);
          ikSet: //6
            idcGen.OutputRTTISet(kind, ps);
          ikClass: //7
            idcGen.OutputRTTIClass(kind, ps);
          ikMethod: //8
            idcGen.OutputRTTIMethod(kind, ps);
          ikWChar: //9
            idcGen.OutputRTTIWChar(kind, ps);
          ikLString: //0xA
            idcGen.OutputRTTILString(kind, ps);
          ikWString: //0xB
            idcGen.OutputRTTIWString(kind, ps);
          ikVariant: //0xC
            idcGen.OutputRTTIVariant(kind, ps);
          ikArray: //0xD
            idcGen.OutputRTTIArray(kind, ps);
          ikRecord: //0xE
            idcGen.OutputRTTIRecord(kind, ps);
          ikInterface: //0xF
            idcGen.OutputRTTIInterface(kind, ps);
          ikInt64: //0x10
            idcGen.OutputRTTIInt64(kind, ps);
          ikDynArray: //0x11
            idcGen.OutputRTTIDynArray(kind, ps);
          ikUString: //0x12
            idcGen.OutputRTTIUString(kind, ps);
          ikClassRef: //0x13
            idcGen.OutputRTTIClassRef(kind, ps);
          ikPointer: //0x14
            idcGen.OutputRTTIPointer(kind, ps);
          ikProcedure: //0x15
            idcGen.OutputRTTIProcedure(kind, ps);
        End;
        Inc(ps);
        continue;
      End;
      if kind = ikVMT then
      Begin
        idcGen.OutputVMT(ps, recN);
        Inc(ps);
        continue;
      End
      else if kind = ikString then
      Begin
        idcGen.MakeShortString(ps);
        Inc(ps);
        continue;
      End
      else if kind = ikLString then
      Begin
        idcGen.MakeLString(ps);
        Inc(ps);
        continue;
      End
      else if kind = ikWString then
      Begin
        idcGen.MakeWString(ps);
        Inc(ps);
        continue;
      End
      else if kind = ikUString then
      Begin
        idcGen.MakeUString(ps);
        Inc(ps);
        continue;
      End
      else if kind = ikCString then
      Begin
        idcGen.MakeCString(ps);
        Inc(ps);
        continue;
      End
      else if kind = ikResString then
      Begin
        idcGen.OutputResString(ps, recN);
        Inc(ps);
        continue;
      End
      else if kind = ikGUID then
      Begin
        idcGen.MakeArray(ps, 16);
        Inc(ps);
        continue;
      End
      else if kind = ikData then
      Begin
        idcGen.OutputData(ps, recN);
        Inc(ps);
        continue;
      End;
      if IsFlagSet(cfProcStart, ps) then
        Inc(ps, idcGen.OutputProc(ps, recN, IsFlagSet(cfImport, ps)));
    End;
    fIdc.Write(tmp[1],Length(tmp));
  finally
    fIdc.Free;
    idcGen.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFMain.pmUnitsPopup(Sender : TObject);
var
  item:AnsiString;
  adr:Integer;
  recU:PUnitRec;
begin
  if lbUnits.ItemIndex < 0 then Exit;

  item := lbUnits.Items[lbUnits.ItemIndex];
  sscanf(PAnsiChar(item)+1,'%lX',[@adr]);
  recU := GetUnit(adr);
  miRenameUnit.Enabled := not recU.kb and (recU.names.Count <= 1);
end;

//MXXXXXXXXM   COP Op1, Op2, Op3;commentF
//XXXXXXXX - address
//F - flags (1:cfLoc; 2:cfSkip; 4:cfLoop; 8:jmp or jcc
procedure TFMain.lbCodeDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
var
  ib:Boolean;
  f, db:Byte;
  n, flag, textLen, len, sWid, cPos, offset, ap:Integer;
  dbPos, ddPos,  adr, _val, dd:Integer;
  col:TColor;
  lb:TListBox;
  canva:TCanvas;
  text, item:AnsiString;
  recN:InfoRec;
  disInfo:TDisInfo;
begin
  //After closing Project we cannot execute this handler (Code := 0)
  if Image=Nil then Exit;

  lb := TListBox(Control);
  canva := lb.Canvas;
  if Index < lb.Count then
  Begin
    flag := Control.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    if not Control.UseRightToLeftAlignment then
      Inc(Rect.Left, 2)
    else
      Dec(Rect.Right, 2);

    text := lb.Items[Index];
    textLen := Length(text);
    //lb.ItemHeight := canva.TextHeight('T');

    //First row (name of procedure with prototype) output without highlighting
    if Index=0 then
    Begin
      Rect.Right := Rect.Left;
      DrawOneItem(text, canva, Rect, 0, flag);
      Exit;
    End;
    //F
    f := Byte(text[textLen]);
    canva.Brush.Color := TColor($FFFFFF);
    if odSelected in State then
      canva.Brush.Color := TColor($FFFFC0)
    else if (f and 2)<>0 then //skip
      canva.Brush.Color := TColor($F5F5FF);
    canva.FillRect(Rect);

    //Width of space
    sWid := canva.TextWidth(' ');
    //Comment position
    cPos := Pos(';',text);
    //Sign for > (blue)
    item := Copy(text,1, 1);
    Rect.Right := Rect.Left;
    DrawOneItem(item, canva, Rect, TColor($FF8080), flag);

    //Address (loop is blue, loc is black, others are light gray)
    item := Copy(text,2, 8);
    adr := StrToInt('$' + item);
    //loop or loc
    if (f and 5)<>0 then
      col := TColor($FF8080)
    else
      col := TColor($BBBBBB); 	//LightGray
    DrawOneItem(item, canva, Rect, col, flag);

    //Sign for > (blue)
    item := Copy(text,10, 1);
    DrawOneItem(item, canva, Rect, TColor($FF8080), flag);

    //Data (case or exeption table)
    dbPos := Pos(' db ',text);
    ddPos := Pos(' dd ',text);
    if (dbPos<>0) or (ddPos<>0) then
    Begin
      Inc(Rect.Right, 7 * sWid);
      if dbPos<>0 then
      Begin
        DrawOneItem('db', canva, Rect, TColor(0), flag);
        //Spaces after db
        Inc(Rect.Right, (ASMMAXCOPLEN - 2) * sWid);
        db := Byte(Code[Adr2Pos(adr)]);
        DrawOneItem(Val2Str(db), canva, Rect, TColor($FF8080), flag);
      End
      else if ddPos<>0 then
      Begin
        DrawOneItem('dd', canva, Rect, TColor(0), flag);
        //Spaces after dd
        Inc(Rect.Right, (ASMMAXCOPLEN - 2) * sWid);
        dd := PInteger(Code + Adr2Pos(adr))^;
        DrawOneItem(Val2Str(dd,8), canva, Rect, TColor($FF8080), flag);
      End;
      //Comment (light gray)
      if cPos<>0 then
      Begin
        item := Copy(text,cPos, textLen);
        SetLength(item,Length(item) - 1);
        DrawOneItem(item, canva, Rect, TColor($BBBBBB), flag);
      End;
      Exit;
    End;
    //Get instruction tokens
    frmDisasm.Disassemble(Code + Adr2Pos(adr), adr, @disInfo, Nil);
    //repprefix
    len := 0;
    if disInfo.RepPrefix <> -1 then
    Begin
      item := RepPrefixTab[disInfo.RepPrefix];
      len := Length(item);
    End;
    Inc(Rect.Right, (6 - len) * sWid);
    if disInfo.RepPrefix <> -1 then
      DrawOneItem(item, canva, Rect, TColor(0), flag);
    Inc(Rect.Right, sWid);

    //Cop (black, if float then green)
    item := disInfo.Mnem;
    len := Length(item);
    if not disInfo.Float then
      col := TColor(0)
    else
      col := TColor($808000);
    if not SameText(item, 'movs') then
    Begin
      DrawOneItem(item, canva, Rect, col, flag);
      //Operands
      if disInfo.OpNum<>0 then
      Begin
        Inc(Rect.Right, (ASMMAXCOPLEN - len) * sWid);
        for n := 0 to disInfo.OpNum-1 do
        Begin
          if n<>0 then DrawOneItem(',', canva, Rect, TColor(0), flag);
          ib := (disInfo.BaseReg <> -1) or (disInfo.IndxReg <> -1);
          offset := disInfo.Offset;
          //Op1
          if disInfo.OpType[n] = otIMM then
          Begin
            _val := disInfo.Immediate;
            ap := Adr2Pos(_val);
            col := TColor($FF8080);
            if (ap >= 0) and (disInfo.Call or disInfo.Branch) then
            Begin
              recN := GetInfoRec(_val);
              if Assigned(recN) and recN.HasName then
              Begin
                item := recN.Name;
                col := TColor($C08000);
              End
              else item := Val2Str(_val,8);
            End
            else
            Begin
              if _val <= 9 then
                item := IntToStr(_val)
              else
              Begin
                item := Val2Str(_val);
                if not (item[1] in ['0'..'9']) then item := '0' + item;
              End;
            End;
            DrawOneItem(item, canva, Rect, col, flag);
          End
          else if (disInfo.OpType[n] = otREG) or (disInfo.OpType[n] = otFST) then
          Begin
            item := GetAsmRegisterName(disInfo.OpRegIdx[n]);
            DrawOneItem(item, canva, Rect, TColor($0000B0), flag);
          End
          else if disInfo.OpType[n] = otMEM then
          Begin
            if disInfo.MemSize<>0 then
            Begin
              item := disInfo.sSize + ' ptr ';
              DrawOneItem(item, canva, Rect, TColor(0), flag);
            End;
            if disInfo.SegPrefix <> -1 then
            Begin
              item := SegRegTab[disInfo.SegPrefix];
              DrawOneItem(item, canva, Rect, TColor($0000B0), flag);
              DrawOneItem(':', canva, Rect, TColor(0), flag);
            End;
            DrawOneItem('[', canva, Rect, TColor(0), flag);
            if ib then
            Begin
              if disInfo.BaseReg <> -1 then
              Begin
                item := GetAsmRegisterName(disInfo.BaseReg);
                DrawOneItem(item, canva, Rect, TColor($0000B0), flag);
              End;
              if disInfo.IndxReg <> -1 then
              Begin
                if disInfo.BaseReg <> -1 then
                  DrawOneItem('+', canva, Rect, TColor(0), flag);
                item := GetAsmRegisterName(disInfo.IndxReg);
                DrawOneItem(item, canva, Rect, TColor($0000B0), flag);
                if disInfo.Scale <> 1 then
                Begin
                  DrawOneItem('*', canva, Rect, TColor(0), flag);
                  item := IntToStr(disInfo.Scale);
                  DrawOneItem(item, canva, Rect, TColor($FF8080), flag);
                End;
              End;
              if offset<>0 then
              Begin
                if offset < 0 then
                Begin
                  item := '-';
                  offset := -offset;
                End
                else item := '+';
                DrawOneItem(item, canva, Rect, TColor(0), flag);
                if offset < 9 then
                  item := IntToStr(offset)
                else
                Begin
                  item := Val2Str(offset);
                  if not (item[1] in ['0'..'9']) then item := '0' + item;
                End;
                DrawOneItem(item, canva, Rect, TColor($FF8080), flag);
              End;
            End
            else
            Begin
              if offset < 0 then offset := -offset;
              if offset < 9 then
                item := IntToStr(offset)
              else
              Begin
                item := Val2Str(offset);
                if not (item[1] in ['0'..'9']) then item := '0' + item;
              End;
              DrawOneItem(item, canva, Rect, TColor($FF8080), flag);
            End;
            DrawOneItem(']', canva, Rect, TColor(0), flag);
          End;
        End;
      End;
    End
    //movsX
    else
    Begin
      item := item + disInfo.sSize;
      DrawOneItem(item, canva, Rect, col, flag);
    End;
    //Comment (light gray)
    if cPos<>0 then
    Begin
      item := Copy(text,cPos, textLen);
      SetLength(item,Length(item) - 1);
      DrawOneItem(item, canva, Rect, TColor($BBBBBB), flag);
    End;
  End;
end;

procedure TFMain.miListerClick(Sender : TObject);
var
  imp, emb:Boolean;
  kind:LKind;
	line, lstName:AnsiString;
  fLst:TextFile;
  ps,adr,n:Integer;
  recN:InfoRec;
  recU:PUnitRec;
begin
  lstName:='';
  if SourceFile <> '' then lstName := ChangeFileExt(SourceFile, '.lst');
  if IDPFile <> '' then lstName := ChangeFileExt(IDPFile, '.lst');

  SaveDlg.InitialDir := WrkDir;
  SaveDlg.Filter := 'LST|*.lst';
  SaveDlg.FileName := lstName;
  if not SaveDlg.Execute then Exit;

  lstName := SaveDlg.FileName;
  if FileExists(lstName) then
    if Application.MessageBox('File already exists. Overwrite?', 'Warning', MB_YESNO) = IDNO then Exit;

  Screen.Cursor := crHourGlass;
  try
    AssignFile(fLst,lstName);
    Rewrite(fLst);
    for n := 0 to UnitsNum-1 do
    Begin
      recU := Units[n];
      if recU.kb or recU.trivial then continue;
      WriteLn(fLst,'//======================================');
      Write(fLst,Format('//Unit%.3d', [recU.iniOrder]));
      if recU.names.Count<>0 then WriteLn(fLst,' (',recU.names[0],')');

      for adr := recU.fromAdr to recU.toAdr-1 do
      Begin
        if adr = recU.finadr then
        Begin
        	if not recU.trivialFin then
            OutputCode(fLst, adr, 'procedure Finalization;', false);
          continue;
        End
        else if adr = recU.iniadr then
        Begin
        	if not recU.trivialIni then
            OutputCode(fLst, adr, 'procedure Initialization;', false);
          continue;
        End;
        ps := Adr2Pos(adr);
        recN := GetInfoRec(adr);
        if not Assigned(recN) then continue;

        imp := false;
        emb := false;
        kind := recN.kind;
        if IsFlagSet(cfProcStart, ps) then
        Begin
          imp := IsFlagSet(cfImport, ps);
          emb := (recN.procInfo.flags and PF_EMBED)<>0;
        End;
        if kind = ikUnknown then continue;

        if (kind > ikUnknown) and (kind <= ikProcedure) and recN.HasName then
        Begin
        	if (kind = ikEnumeration) or (kind = ikSet) then
            WriteLn(fLst,recN.Name,' = ',FTypeInfo.GetRTTI(adr),';')
          else
            WriteLn(fLst,Format('%8.8X <%s> %s', [adr, TypeKind2Name(kind), recN.Name]));
          continue;
        End
        else if kind = ikResString then
        Begin
          Writeln(fLst,Format('%8.8X <ResString> %s=%s', [adr, recN.Name, recN.rsInfo]));
          continue;
        End
        else if kind = ikVMT then
        Begin
          Writeln(fLst,Format('%8.8X <VMT> %s', [adr, recN.Name]));
          continue;
        End
        else if kind = ikGUID then
        Begin
          Writeln(fLst,Format('%8.8X <TGUID> [''%s'']', [adr, GuidToString(PGUID(Code + ps)^)]));
          continue;
        End
        else if kind = ikConstructor then
        Begin
         	OutputCode(fLst, adr, recN.MakePrototype(adr, true, false, false, true, false), false);
          continue;
        End
        else if kind = ikDestructor then
        Begin
          OutputCode(fLst, adr, recN.MakePrototype(adr, true, false, false, true, false), false);
          continue;
        End
        else if kind = ikProc then
        Begin
        	line := '';
          if imp then
          	line := line + 'import '
          else if emb then
          	line := line + 'embedded ';
          line := line + recN.MakePrototype(adr, true, false, false, true, false);
          OutputCode(fLst, adr, line, false);
          continue;
        End
        else if kind = ikFunc then
        Begin
        	line := '';
          if imp then
          	line := line + 'import '
          else if emb then
          	line := line + 'embedded ';
          line := line + recN.MakePrototype(adr, true, false, false, true, false);
          OutputCode(fLst, adr, line, false);
          continue;
        End;
        if IsFlagSet(cfProcStart, ps) then
        Begin
          if kind = ikDestructor then
            OutputCode(fLst, adr, recN.MakePrototype(adr, true, false, false, true, false), false)
          else if kind = ikDestructor then
            OutputCode(fLst, adr, recN.MakePrototype(adr, true, false, false, true, false), false)
          else
          Begin
            line := '';
            if emb then line := line + 'embedded ';
            line := line + recN.MakePrototype(adr, true, false, false, true, false);
            OutputCode(fLst, adr, line, false);
          End;
        End;
      End;
    End;
  finally
    CloseFile(fLst);
    Screen.Cursor := crDefault;
  end;
end;

Procedure TFMain.OutputLine (Var outF:TextFile; flag:Byte; adr:Integer; content:AnsiString);
var
  p:Integer;
Begin
  //Ouput comments
  if (flag and $10)<>0 then
  begin
    p := Pos(';',Content);
    if p<>0 Then
    Begin
      Writeln(outF,Format('C %8.8X %s', [Adr, p + 1]));
      Exit;
    end;
  End
  //Jump direction
	Else if (flag and 4)<>0 then
    Write(OutF,'<')
  else if (flag and 8)<>0 then
    Write(OutF,'>')
  else
    Write(OutF,'        ');
  {
	if (flag and 1)<>0 then Write(outF,Format('%8.8X', [Adr]))
    else Write(OutF,'        ');
  }
  Write(outF,Format('%8.8X    %s', [Adr, Content]));
end;

procedure TFMain.OutputCode(Var outF:TextFile; fromAdr:Integer; prototype:AnsiString; onlyComments:Boolean);
var
  db,b1,b2,op, flags:Byte;
  NameInside:Boolean;
  row, num, instrLen, instrLen1, instrLen2,cTblAdr, jTblAdr:Integer;
  Adr, Adr1, Ps, lastMovAdr,outRows,NameInsideAdr,delta,targetAdr:Integer;
  k,fromPos, curPos, _procSize, _ap, _pos, _idx,CNum,NPos:Integer;
  curAdr, lastAdr:Integer;
  recN, recN1:InfoRec;
  _name, pname, _type, ptype,namei,comment,line:AnsiString;
  DisInfo, DisInfo1:TDisInfo;
  CTab:Array[0..255] of Byte;
Begin
  row:=0;
  lastMovAdr:=0;
  lastAdr:=0;
  fromPos := Adr2Pos(fromAdr);
  if fromPos < 0 then Exit;

  recN := GetInfoRec(fromAdr);
  outRows := MAX_DISASSEMBLE;
  if IsFlagSet(cfImport, fromPos) then outRows := 1;

  if not onlyComments and (prototype <> '') then
  Begin
    Writeln(outF, '//---------------------------------------------------------------------------');
    WriteLn(outF, '// ',prototype);
  End;
  _procSize := GetProcSize(fromAdr);
  curPos := fromPos; 
  curAdr := fromAdr;

  while row < outRows do
  Begin
    //End of procedure
    if (curAdr <> fromAdr) and (_procSize<>0) and (curAdr - fromAdr >= _procSize) then break;
    flags := 0;
    //Only comments?
    if onlyComments then flags := flags or $10;
    //Loc?
    if IsFlagSet(cfLoc, curPos) then flags := flags or 1;
    //Skip?
    if IsFlagSet(cfSkip or cfDSkip, curPos) then flags := flags or 2;

    //If exception table, output it
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      OutputLine(outF, flags, curAdr, 'dd          ' + IntToStr(num));
      Inc(row);
      Inc(curPos, 4); 
      Inc(curAdr, 4);

      for k := 0 to num-1 do
      Begin
        //dd offset ExceptionInfo
        Adr := PInteger(Code + curPos)^;
        line := 'dd          ' + Val2Str(Adr,8);
        //Name of Exception
        if IsValidCodeAdr(Adr) then
        Begin
          recN := GetInfoRec(Adr);
          if Assigned(recN) and recN.HasName then line := line + ';' + recN.Name;
        End;
        OutputLine(outF, flags, curAdr, line); 
        Inc(row);

        //dd offset ExceptionProc
        Inc(curPos, 4); 
        Inc(curAdr, 4);
        Adr := PInteger(Code + curPos)^;
        OutputLine(outF, flags, curAdr, 'dd          ' + Val2Str(Adr,8)); 
        Inc(row);
        Inc(curPos, 4); 
        Inc(curAdr, 4);
      End;
      continue;
    End;

    b1 := Byte(Code[curPos]);
    b2 := Byte(Code[curPos + 1]);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, @line);
    if instrLen=0 then
    Begin
      OutputLine(outF, flags, curAdr, '???'); 
      Inc(row);
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    op := frmDisasm.GetOp(DisInfo.Mnem);

    //Check inside instruction Fixup or ThreadVar
    NameInside := false;
    NameInsideAdr:=0;
    for k := 1 to instrLen-1 do
      if Assigned(InfoList[curPos + k]) then
      Begin
        NameInside := true;
        NameInsideAdr:= curAdr + k;
        break;
      End;
    if curAdr >= lastAdr then lastAdr := 0;

    //Proc end
    if DisInfo.Ret and ((lastAdr=0) or (curAdr = lastAdr)) then
    Begin
      OutputLine(outF, flags, curAdr, line); 
      Inc(row);
      break;
    End;

    if op = OP_MOV then lastMovAdr := DisInfo.Offset;
    if (b1 = $EB) or				 //short relative abs jmp or cond jmp
    	((b1 >= $70) and (b1 <= $7F)) or
      ((b1 = 15) and (b2 >= $80) and (b2 <= $8F)) then
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        if op = OP_JMP then
        Begin
          _ap := Adr2Pos(Adr);
          recN := GetInfoRec(Adr);
          if Assigned(recN) and IsFlagSet(cfProcStart, _ap) and recN.HasName then
            line := 'jmp         ' + recN.Name;
        End;
        flags := flags or 8;
        if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      OutputLine(outF, flags, curAdr, line); 
      Inc(row);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if b1 = $E9 then    //relative abs jmp or cond jmp
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        _ap := Adr2Pos(Adr);
        recN := GetInfoRec(Adr);
        if Assigned(recN) and IsFlagSet(cfProcStart, _ap) and recN.HasName then
          line := 'jmp         ' + recN.Name;
        flags := flags or 8;
        if not Assigned(recN) and (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      OutputLine(outF, flags, curAdr, line); 
      Inc(row);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if DisInfo.Call then  //call sub_XXXXXXXX
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        recN := GetInfoRec(Adr);
        if Assigned(recN) and recN.HasName then
        Begin
          line := 'call        ' + recN.Name;
          //Found @Halt0 - exit
          if recN.SameName('@Halt0') and (fromAdr = EP) and (lastAdr=0) then
          Begin
            OutputLine(outF, flags, curAdr, line); 
            Inc(row);
            break;
          End;
        End;
      End;
      recN := GetInfoRec(curAdr);
      if Assigned(recN) and Assigned(recN.pcode) then line := line + ';' + MakeComment(recN.pcode);
      OutputLine(outF, flags, curAdr, line); 
      Inc(row);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End
    else if (b1 = 255) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      OutputLine(outF, flags, curAdr, line); 
      Inc(row);
      if not IsValidCodeAdr(DisInfo.Offset) then break;
      //First instruction
      //if curAdr = fromAdr then break;
      cTblAdr := 0;
      jTblAdr := 0;
      Ps := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Table address - last 4 bytes of instruction
      jTblAdr := PInteger(Code + Ps - 4)^;
      //Analyze address range to find table cTbl
      if (Adr <= lastMovAdr) and (lastMovAdr < jTblAdr) then cTblAdr := lastMovAdr;
      //If exist cTblAdr, skip this table
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        for k := 0 to CNum-1 do
        Begin
          db := Byte(Code[Ps]);
          CTab[k] := db;
          OutputLine(outF, flags, curAdr, 'db          ' + Char(db)); 
          Inc(row);
          Inc(Ps); 
          Inc(Adr);
        End;
      End;
      //Check transitions by negative register values (in Delphi 2009)
      //bool neg := false;
      //Adr1 := *((DWORD*)(Code + Pos - 4));
      //if (IsValidCodeAdr(Adr1) and IsFlagSet(cfLoc, Adr2Pos(Adr1))) neg := true;

      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, Ps) then break;
        Adr1 := PInteger(Code + Ps)^;
        //Validate Adr1
        if not IsValidCodeAdr(Adr1) or (Adr1 < fromAdr) then break;

        //Add row to assembler listing
        OutputLine(outF, flags, curAdr, 'dd          ' + Val2Str(Adr1,8)); 
        Inc(row);
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        Inc(Ps, 4); 
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := Ps;
      curAdr := Adr;
      continue;
    End;
    //----------------------------------
    //PosTry: xor reg, reg
    //        push ebp
    //        push offset @1
    //        push fs:[reg]
    //        mov fs:[reg], esp
    //        ...
    //@2:     ...
    //At @1 various variants:
    //----------------------------------
    //@1:     jmp @HandleFinally
    //        jmp @2
    //----------------------------------
    //@1:     jmp @HandleAnyException
    //        call DoneExcept
    //----------------------------------
    //@1:     jmp HandleOnException
    //        dd num
    //Далее таблица из num записей вида
    //        dd offset ExceptionInfo
    //        dd offset ExceptionProc
    //----------------------------------
    if b1 = $68 then		//try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //check that next instruction is push fs:[reg] or retn
      if ((Code[NPos] = #$64) and
        (Code[NPos + 1] = #255) and
        (((Code[NPos + 2] >= #$30) and (Code[NPos + 2] <= #$37)) or (Code[NPos + 2] = #$75))
        ) or (Code[NPos] = #$C3) then
      Begin
        Adr := DisInfo.Immediate;      //Adr:=@1
        if IsValidCodeAdr(Adr) then
        Begin
          if Adr > lastAdr then lastAdr := Adr;
          Ps := Adr2Pos(Adr); 
          assert(Ps >= 0);
          delta := Ps - NPos;
          if delta >= 0 then // and delta < outRows)
          Begin
            if Code[Ps] = #$E9 then //jmp Handle...
            Begin
              //Disassemble jmp
              instrLen1 := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
              recN := GetInfoRec(DisInfo.Immediate);
              if Assigned(recN) then
              Begin
                if recN.SameName('@HandleFinally') then
                Begin
                  //jmp HandleFinally
                  Inc(Ps, instrLen1); 
                  Inc(Adr, instrLen1);
                  //jmp @2
                  instrLen2 := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
                  Inc(Adr, instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                  {
                  //@2
                  Adr1 := DisInfo.Immediate - 4;
                  Adr := PInteger(Code + Adr2Pos(Adr1))^;
                  if IsValidCodeAdr(Adr) and (Adr > lastAdr) then lastAdr := Adr;
                  }
                End
                else if recN.SameName('@HandleAnyException') or recN.SameName('@HandleAutoException') then
                Begin
                  //jmp HandleAnyException
                  Inc(Ps, instrLen1); 
                  Inc(Adr, instrLen1);
                  //call DoneExcept
                  instrLen2 := frmDisasm.Disassemble(Code + Ps, Adr, Nil, Nil);
                  Inc(Adr, instrLen2);
                  if Adr > lastAdr then lastAdr := Adr;
                End
                else if recN.SameName('@HandleOnException') then
                Begin
                  //jmp HandleOnException
                  Inc(Ps, instrLen1); 
                  Inc(Adr, instrLen1);
                  //Set flag cfETable to correct output data
                  SetFlag(cfETable, Ps);
                  //dd num
                  num := PInteger(Code + Ps)^; 
                  Inc(Ps, 4);
                  if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                  for k := 0 to num-1 do
                  Begin
                    //dd offset ExceptionInfo
                    Inc(Ps, 4);
                    //dd offset ExceptionProc
                    Inc(Ps, 4);
                  End;
                End;
              End;
            End;
          End;
          OutputLine(outF, flags, curAdr, line); 
          Inc(row);
          Inc(curPos, instrLen); 
          Inc(curAdr, instrLen);
          continue;
        End;
      End;
    End;

    //Name inside instruction (Fixip, ThreadVar)
    namei := '';
    comment := '';
    if NameInside then
    Begin
      recN := GetInfoRec(NameInsideAdr);
      if Assigned(recN) and recN.HasName then
      Begin
        namei := namei + recN.Name;
        if recN._type <> '' then namei := namei + ':' + recN._type;
      End;
    End;
    //comment
    recN := GetInfoRec(curAdr);
    if Assigned(recN) and Assigned(recN.pcode) then comment := MakeComment(recN.pcode);

    targetAdr := 0;
    if IsValidImageAdr(DisInfo.Immediate) then
    Begin
    	if not IsValidImageAdr(DisInfo.Offset) then targetAdr := DisInfo.Immediate;
    End
    else if IsValidImageAdr(DisInfo.Offset) then targetAdr := DisInfo.Offset;
    if targetAdr<>0 then
    Begin
      _name := '';
      pname := '';
      _type := '';
      ptype := '';
      _pos := Adr2Pos(targetAdr);
      if _pos >= 0 then
      Begin
        recN := GetInfoRec(targetAdr);
        if Assigned(recN) then
        Begin
          if recN.kind = ikResString then
            _name := recN.Name + ':PResStringRec'
          else
          Begin
            if recN.HasName then
            Begin
              _name := recN.Name;
              if recN._type <> '' then _type := recN._type;
            End
            else if IsFlagSet(cfProcStart, _pos) then
              _name := GetDefaultProcName(targetAdr);
          End;
        End
        //For Delphi2 pointers to VMT are distinct
        else if DelphiVersion = 2 then
        Begin
          recN := GetInfoRec(targetAdr + VmtSelfPtr);
          if Assigned(recN) and (recN.kind = ikVMT) and recN.HasName then
            name := recN.Name;
        End;
        Adr := PInteger(Code + _pos)^;
        if IsValidImageAdr(Adr) then
        Begin
          recN := GetInfoRec(Adr);
          if Assigned(recN) then
          Begin
            if recN.HasName then
            Begin
              pname := recN.Name;
              ptype := recN._type;
            End
            else if IsFlagSet(cfProcStart, _pos) then
              pname := GetDefaultProcName(Adr);
          End;
        End;
      End
      else
      Begin
        _idx := BSSInfos.IndexOf(Val2Str(targetAdr,8));
        if _idx <> -1 then
        Begin
          recN := InfoRec(BSSInfos.Objects[_idx]);
          _name := recN.Name;
          _type := recN._type;
        End;
      End;
    End;
    if SameText(comment, _name) then _name := '';
    if pname <> '' then
    Begin
      if comment <> '' then comment := comment + ' ';
      comment := comment + '^' + pname;
      if ptype <> '' then comment := comment + ':' + ptype;
    End
    else if _name <> '' then
    Begin
      if comment <> '' then comment := comment + ' ';
     	comment := comment + name;
      if _type <> '' then comment := comment + ':' + _type;
    End;
    if (comment <> '') or (namei <> '') then
    Begin
      line := line + ';';
      if comment <> '' then line := line + comment;
      if namei <> '' then line := line + 'Begin' + namei + 'End;';
    End;
    if Length(line) > MAXLEN then line := Copy(line,1, MAXLEN) + '...';
    OutputLine(outF, flags, curAdr, line);
    Inc(row);
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
end;

Procedure TFMain.wm_dropFiles (Var Msg:TWMDropFiles);
var
  fc:TFileDropper;
  i:Integer;
  droppedFile,ext:AnsiString;
Begin
  fc := TFileDropper.Create(msg.Drop);
  try
    try
      for i := 0 to fc.FileCount-1 do
      begin
        droppedFile := fc.Files[i];
        ext := ExtractFileExt(LowerCase(droppedFile));
        if SameText(ext, '.lnk') then
          DoOpenDelphiFile(DELHPI_VERSION_AUTO, GetFilenameFromLink(droppedFile), true, true)
        else if SameText(ext, '.idp') and miOpenProject.Enabled then
          DoOpenProjectFile(droppedFile)
        else if (SameText(ext, '.exe') or SameText(ext, '.bpl') or
          SameText(ext, '.dll') or SameText(ext, '.scr')) and miLoadFile.Enabled then
          DoOpenDelphiFile(DELHPI_VERSION_AUTO, droppedFile, true, true);

        //обработали 1й - и валим - пока не умеем > 1 файла одновременно
        break;
      end;
      //TPoint ptDrop = fc->DropPoint;
    Except
    end;
  Finally
    fc.Free;
  end;
  msg.Result := 0;
end;

procedure TFMain.miAboutClick(Sender : TObject);
begin
  FAboutDlg.ShowModal;
end;

procedure TFMain.miHelpClick(Sender : TObject);
begin
  ShellExecute(Handle, 'open', PAnsiChar(Application.HelpFile), Nil, Nil, 1);
end;

Function TFMain.ContainsUnexplored (recU:PUnitRec):Boolean;
Var
  unk:Boolean;
  adr,n:Integer;
  b0,b1,b2:Byte;
Begin
  Result:=False;
	if not Assigned(recU) then Exit;
	unk := false;
  adr := recU.fromAdr;
  while adr< recU.toAdr do
  begin
    n := Adr2Pos(adr);
    if FlagList[n]=0 then
    begin
      b0 := Byte(Code[n]);
      if not unk then
      begin
        b1 := Byte(Code[n + 1]);
        b2 := Byte(Code[n + 2]);
        if ((adr and 3) = 3) and ((b0 = 0) or (b0 = $90)) then
        begin
          Inc(adr);
          continue;
        end;
        if ((adr and 3) = 2) and (((b0 = 0) and (b1 = 0)) or ((b0 = $8B) and (b1 = $C0))) then
        begin
          Inc(adr,2);
          continue;
        End;
        if ((adr and 3) = 1) and (((b0 = 0) and (b1 = 0) and (b2 = 0)) or ((b0 = $8D) and (b1 = $40) and (b2 = 0))) then
        begin
          Inc(adr,3);
          continue;
        end;
        unk := true;
      end;
      Inc(adr);
      continue;
    end;
    if unk then
    Begin
      Result:=true;
      Exit;
    end;
    Inc(adr);
  end;
end;

Procedure TFMain.ShowUnits (showUnk:Boolean);
var
  oldItemIdx, selAdr, newItemIdx, wid, maxwid:Integer;
  oldTopIdx,i,u,newTopIdx:Integer;
  recU:PUnitRec;
  ci, cf:Char;
  item,line:AnsiString;
  vNode:PVirtualNode;
  uNode:PUnitNode;
Begin
  oldItemIdx:=lbUnits.ItemIndex;
  selAdr:=0;
  newItemIdx:=-1;
  maxwid:=0;
  if oldItemIdx <> -1 then
  Begin
    item := lbUnits.Items[oldItemIdx];
    sscanf(PAnsiChar(item)+1,'%lX',[@selAdr]);
  End;
  oldTopIdx := lbUnits.TopIndex;
  lbUnits.Clear;
  lbUnits.Items.BeginUpdate;
  vtUnit.Clear;
  vtUnit.BeginUpdate;

  if UnitsNum<>0 then
    case UnitSortField of
      0: Units.Sort(SortUnitsByAdr);
      1: Units.Sort(SortUnitsByOrd);
      2: Units.Sort(SortUnitsByNam);
    End;
  for i := 0 to UnitsNum-1 do
  Begin
    vNode:=vtUnit.AddChild(Nil);
    uNode:=vtUnit.GetNodeData(vNode);
    recU := Units[i];
    uNode.unit_index:=i;
    if recU.fromAdr = selAdr then newItemIdx := i;
    if not recU.trivialIni then ci:='I' else ci:=' ';
    if not recU.trivialFin then cf:='F' else cf:=' ';
    line:=Format(' %8.8X #%.3d %s%s ', [recU.fromAdr, recU.iniOrder, ci, cf]);
    if recU.names.Count<>0 then
      for u := 0 to recU.names.Count-1 do
      Begin
        if Length(line) + Length(recU.names[u]) > 255 then
        Begin
          unode.names:=unode.names + '...';
          line:=line + '...';
          break;
        End;
        if u<>0 then
        Begin
          line:=line+';';
          uNode.names:=unode.names+';'
        end;
        line:=line + recU.names[u];
        uNode.names:=unode.names + recU.names[u];
      End
    else
    Begin
      line:=line + Format('_Unit%d', [recU.iniOrder]);
      uNode.names:='_Unit'+IntToStr(recU.iniOrder);
    end;

    if i <> UnitsNum - 1 then
    Begin
      //Trivial units
      if recU.trivial then
      Begin
        line[1] := Chr(TRIV_UNIT);
        uNode.unit_type:=[ut_Trivial];
      end
      else if not recU.kb then
      Begin
        line[1] := Chr(USER_UNIT);
        uNode.unit_type:=[ut_User];
      end;
    End
    //Last unit is user's
    else
    Begin
      line[1] := Chr(USER_UNIT);
      uNode.unit_type:=[ut_User];
    end;

    //Unit has undefined bytes
    uNode.has_undef:=ContainsUnexplored(recU);
    if showUnk and ContainsUnexplored(recU) then
    Begin
      Byte(line[1]) := Byte(line[1]) or UNEXP_UNIT;
      Include(uNode.unit_type,ut_Unexplore);
    end;
    lbUnits.Items.Add(line);
    wid := lbUnits.Canvas.TextWidth(line);
    if wid > maxwid then maxwid := wid;
  End;
  if newItemIdx = -1 then lbUnits.TopIndex := oldTopIdx
  else
  Begin
    if newItemIdx <> oldItemIdx then
    Begin
      lbUnits.ItemIndex := newItemIdx;
      newTopIdx := newItemIdx - (oldItemIdx - oldTopIdx);
      if newTopIdx < 0 then newTopIdx := 0;
      lbUnits.TopIndex := newTopIdx;
    End
    else
    Begin
      lbUnits.ItemIndex := newItemIdx;
      lbUnits.TopIndex := oldTopIdx;
    End;
  End;
  lbUnits.ItemHeight := lbUnits.Canvas.TextHeight('T');
  lbUnits.ScrollWidth := maxwid + 2;
  lbUnits.Items.EndUpdate;
  vtUnit.EndUpdate;
end;

procedure TFMain.lbUnitsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if lbUnits.CanFocus then ActiveControl := lbUnits;
end;

procedure TFMain.lbUnitsClick(Sender : TObject);
begin
  UnitsSearchFrom := lbUnits.ItemIndex;
  WhereSearch := SEARCH_UNITS;
end;

procedure TFMain.lbUnitsDblClick(Sender : TObject);
var
  adr:Integer;
  item:AnsiString;
  recU:PUnitRec;
begin
  item := lbUnits.Items[lbUnits.ItemIndex];
  sscanf(PAnsiChar(item)+1,'%lX',[@adr]);
  recU := GetUnit(adr);
  if (CurUnitAdr=0) or (adr <> CurUnitAdr) then
  begin
    CurUnitAdr := adr;
    ShowUnitItems(recU, 0, -1);
  end
  else ShowUnitItems(recU, lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
  CurUnitAdr := adr;
end;

procedure TFMain.lbUnitsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key = VK_RETURN then lbUnitsDblClick(Sender);
end;

procedure TFMain.lbUnitsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
var
  p, flags, len:Integer;
  col:TColor;
  lb:TListBox;
  canva:TCanvas;
  text, str1, str2:AnsiString;
begin
  lb := TListBox(Control);
  canva := lb.Canvas;
  SaveCanvas(canva);
  if Index < lb.Count then
  Begin
    flags := Control.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    if not Control.UseRightToLeftAlignment then
      Inc(Rect.Left, 2)
    else
      Dec(Rect.Right, 2);

    text := lb.Items[Index];
    //lb.ItemHeight := canva.TextHeight(text);
    canva.FillRect(Rect);

    //*XXXXXXXX #XXX XX NAME
    p := PosEx(' ',text,2);
    len := p - 1;
    str1 := Copy(text,2, len - 1);
    str2 := Copy(text,len + 1, Length(text) - len);

    if not (odSelected in State) then
      col := TColor(0)        //Black
    else
      col := TColor($BBBBBB); //LightGray
    Rect.Right := Rect.Left;
    DrawOneItem(str1, canva, Rect, col, flags);

    //Unit name
    //Trivial unit - red
    if (Byte(text[1]) and TRIV_UNIT)<>0 then
    Begin
      if not (odSelected in State) then
        col := TColor($0000B0) //Red
      else
        col := TColor($BBBBBB); //LightGray
    End
    else
    Begin
      //User unit - green
      if (Byte(text[1]) and USER_UNIT)<>0 then
      Begin
        if not (odSelected in State) then
        Begin
      	if (Byte(text[1]) and UNEXP_UNIT)<>0 then
        	col := TColor($C0C0FF) //Light Red
        else
        	col := TColor($00B000); //Green
        End
        else col := TColor($BBBBBB); //LightGray
      End
      //From knowledge base - blue
      else
      Begin
        if not (odSelected in State) then
          col := TColor($C08000) //Blue
        else
          col := TColor($BBBBBB); //LightGray
      End;
    End;
    DrawOneItem(str2, canva, Rect, col, flags);
  End;
  RestoreCanvas(canva);
end;

procedure TFMain.miSearchUnitClick(Sender : TObject);
var
  n:Integer;
begin
  WhereSearch := SEARCH_UNITS;
  FFindDlg.cbText.Clear;
  for n := 0 to UnitsSearchList.Count-1 do
    FFindDlg.cbText.AddItem(UnitsSearchList[n], Nil);
  if (FFindDlg.ShowModal = mrOk) and (FFindDlg.cbText.Text <> '') then
  begin
    if lbUnits.ItemIndex = -1 then
      UnitsSearchFrom := 0
    else
      UnitsSearchFrom := lbUnits.ItemIndex;
    UnitsSearchText := FFindDlg.cbText.Text;
    if UnitsSearchList.IndexOf(UnitsSearchText) = -1 then UnitsSearchList.Add(UnitsSearchText);
    FindText(UnitsSearchText);
  end;
end;

procedure TFMain.miRenameUnitClick(Sender : TObject);
var
  adr,u:Integer;
  sName,item,txt:AnsiString;
  recU:PUnitRec;
begin
  if lbUnits.ItemIndex = -1 then Exit;

  item := lbUnits.Items[lbUnits.ItemIndex];
  sscanf(PAnsiChar(item)+1,'%lX',[@adr]);
  recU := GetUnit(adr);

  txt := '';
  for u := 0 to recU.names.Count-1 do
  begin
    if u<>0 then txt :=txt+ '+';
    txt:=txt + recU.names[u];
  End;
  sName := InputDialogExec('Enter UnitName', 'Name:', txt);
  if sName <> '' then
  begin
    recU.names.Clear;
    SetUnitName(recU, sName);
    ProjectModified := true;
    ShowUnits(true);
    lbUnits.SetFocus;
  end;
end;

Procedure TFMain.ShowUnitItems (recU:PUnitRec; topIdx, itemIdx:Integer);
var
  unk, imp, exp, emb, xref:Boolean;
  m,unknum, ps,adr,wid, maxwid:Integer;
  canva:TCanvas;
  recN:InfoRec;
  recX:PXrefRec;
  line, prefix:AnsiString;
  kind:LKind;
  b0,b1,b2:Byte;

  procedure rec_name;
  Begin
    if recN.HasName then
    Begin
      if recN.NameLength <= MAXLEN then
        line := line + recN.Name
      else
        line := line + Copy(recN.Name,1, MAXLEN) + '...';
    End;
  end;
Begin
  unk:=False;
  unknum:=0;
  maxwid:=0;
  canva:=lbUnitItems.Canvas;
  if CurUnitAdr=0 then Exit;

  //if (AnalyzeThread) AnalyzeThread.Suspend();
  lbUnitItems.Clear;
  lbUnitItems.Items.BeginUpdate;

  adr := recU.fromAdr; 
  while adr < recU.toAdr do
  Begin
    ps := Adr2Pos(adr);
    if not IsFlagSet(not Cardinal(cfLoc), ps) then
    Begin
      b0 := Byte(Code[ps]);
    	if not unk then
      Begin
        unknum := 0;
        b1 := Byte(Code[ps + 1]); 
        b2 := Byte(Code[ps + 2]);
        if ((adr and 3) = 3) and ((b0 = 0) or (b0 = $90)) then
        begin
          Inc(adr);
          continue;
        end;
        if ((adr and 3) = 2) and (((b0 = 0) and (b1 = 0)) or ((b0 = $8B) and (b1 = $C0)) or ((b0 = $90) and (b1 = $90))) then
        Begin
          Inc(adr,2);
          continue;
        End;
        if ((adr and 3) = 1) and (((b0 = 0) and (b1 = 0) and (b2 = 0)) or ((b0 = $8D) and (b1 = $40) and (b2 = 0)) or ((b0 = $90) and (b1 = $90) and (b2 = $90))) then
        Begin
          Inc(adr, 3);
          continue;
        End;
        line := ' ' + Val2Str(adr,8) + ' ????';
        Byte(line[1]) := Byte(line[1]) xor 1;
        line := line + ' ' + Val2Str(b0,2);
        Inc(unknum);
        unk := true;
      End
      else
      Begin
        if unknum <= 16 then
        Begin
          if unknum = 16 then
            line := line + '...'
          else
            line := line + ' ' + Val2Str(b0,2);
          Inc(unknum);
        End;
      End;
      Inc(adr);
      continue;
    End;
    if unk then
    Begin
      lbUnitItems.Items.Add(line);
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
      unk := false;
    End;
    if (adr = recU.iniadr) or (adr = recU.finadr) then
    begin
      Inc(adr);
      continue;
    end;
    //EP
    if adr = EP then
    Begin
      line := ' ' + Val2Str(adr,8) + ' <Proc> EntryPoint';
      lbUnitItems.Items.Add(line);
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
      Inc(adr);
      continue;
    End;

    recN := GetInfoRec(adr);
    if not Assigned(recN) then
    begin
      Inc(adr);
      continue;
    end;
    kind := recN.kind;
    //Skip calls, that are in the body of some asm-procs (for example, FloatToText from SysUtils)
    if (kind >= ikRefine) and (kind <= ikFunc) and Assigned(recN.procInfo)
      and ((recN.procInfo.flags and cfEmbedded)<>0) then
    begin
      Inc(adr);
      continue;
    end;
    imp := IsFlagSet(cfImport, ps);
    exp := IsFlagSet(cfExport, ps);
    emb := false;
    if IsFlagSet(cfProcStart, ps) then
    Begin
      if Assigned(recN.procInfo) then
        emb := (recN.procInfo.flags and PF_EMBED)<>0;
    End;
    xref := false;
    line := '';

    case kind of
	    ikInteger,
	    ikChar,
	    ikEnumeration,
	    ikFloat,
      ikSet,
      ikClass,
      ikMethod,
      ikWChar,
      ikLString,
      ikVariant,
      ikArray,
      ikRecord,
      ikInterface,
      ikInt64,
      ikDynArray,
      ikUString,
      ikClassRef,
      ikPointer,
      ikProcedure:
        begin
        	line := '<' + TypeKind2Name(kind) + '> ';
        	rec_name;
        end;
      ikString:
        begin
        	if not IsFlagSet(cfRTTI, ps) then
            line := '<ShortString> '
          else
            line := '<' + TypeKind2Name(kind) + '> ';
          rec_name;
        end;
      ikWString:
        begin
        	line := '<WideString> ';
        	rec_name;
        end;
      ikCString:
        begin
        	line := '<PAnsiChar> ';
        	rec_name;
        end;
      ikWCString:
        begin
        	line := '<PWideChar> ';
        	rec_name;
      	end;
      ikResString:
      	if recN.HasName then line := line + '<ResString> ' + recN.Name + ' = ' + recN.rsInfo;
      ikVMT:
        if recN.HasName then line := '<VMT> ' + recN.Name else line := '<VMT> ';
      ikConstructor:
        begin
          xref := true;
          line := '<Constructor> ' + recN.MakePrototype(adr, false, true, false, true, false);
        end;
      ikDestructor:
        begin
          xref := true;
          line := '<Destructor> ' + recN.MakePrototype(adr, false, true, false, true, false);
        end;
      ikProc:
        begin
          xref := true;
          line := '<';
          if imp then
            line := line + 'Imp'
          else if exp then
            line := line + 'Exp'
          else if emb then
            line := line + 'Emb';
          line := line + 'Proc> ' + recN.MakePrototype(adr, false, true, false, true, false);
        end;
      ikFunc:
        begin
          xref := true;
          line := '<';
          if imp then
            line := line + 'Imp'
          else if exp then
            line := line + 'Exp'
          else if emb then
            line := line + 'Emb';
          line := line + 'Func> ' + recN.MakePrototype(adr, false, true, false, true, false);
        end;
      ikGUID:
        if recN.HasName then line := '<TGUID> ' + recN.Name else line := '<TGUID> ';
      ikRefine:
        begin
          xref := true;
          line := '<';
          if imp then
            line := line + 'Imp'
          else if exp then
            line := line + 'Exp'
          else if emb then
            line := line + 'Emb';
          line := line + '?> ' + recN.MakePrototype(adr, false, true, false, true, false);
        end;
      else
      begin
        if IsFlagSet(cfProcStart, ps) then
        Begin
          xref := true;
          if recN.kind = ikConstructor then
            line := '<Constructor> ' + recN.MakePrototype(adr, false, true, false, true, false)
          else if recN.kind = ikDestructor then
            line := '<Destructor> ' + recN.MakePrototype(adr, false, true, false, true, false)
          else
          Begin
            line := '<';
            if emb then line := line + 'Emb';
            line := line + 'Proc> ' + recN.MakePrototype(adr, false, true, false, true, false);
          End;
        End;
      end;
    End;

    if (kind >= ikRefine) and (kind <= ikFunc) then
    Begin
      if (recN.procInfo.flags and PF_VIRTUAL)<>0 then line := line + ' virtual';
      if (recN.procInfo.flags and PF_DYNAMIC)<>0 then line := line + ' dynamic';
      if (recN.procInfo.flags and PF_EVENT)<>0 then   line := line + ' event';
    End;
    if line <> '' then
    Begin
      prefix := ' ' + Val2Str(adr,8);
      if xref and Assigned(recN.xrefs) and (recN.xrefs.Count<>0) then
      Begin
        Byte(prefix[1]) := Byte(prefix[1]) xor 2;
        for m := 0 to recN.xrefs.Count-1 do
        Begin
          recX := recN.xrefs[m];
          recU := GetUnit(recX.adr);
          if Assigned(recU) and not recU.kb then
          Begin
            Byte(prefix[1]) := Byte(prefix[1]) xor 4;
            break;
          End;
        End;
        prefix := prefix + ' ' + IntToStr(recN.xrefs.Count);
        if recN.xrefs.Count <= 9 then
          prefix := prefix + '  '
        else if recN.xrefs.Count <= 99 then
          prefix := prefix + ' ';
      End;
      line := prefix + ' ' + line;
      lbUnitItems.Items.Add(line);
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
    End;
    Inc(adr);
  End;

  //Add initialization procedure
  if recU.iniadr<>0 then
  Begin
    line := ' ' + Val2Str(recU.iniadr,8) + ' <Proc> Initialization;';
    lbUnitItems.Items.Add(line);
    wid := canva.TextWidth(line);
    if wid > maxwid then maxwid := wid;
  End;
  //Add finalization procedure
  if recU.finadr<>0 then
  Begin
    line := ' ' + Val2Str(recU.finadr,8) + ' <Proc> Finalization;';
    lbUnitItems.Items.Add(line);
    wid := canva.TextWidth(line);
    if wid > maxwid then maxwid := wid;
  End;
  with lbUnitItems do
  begin
    TopIndex := topIdx;
    ItemIndex := itemIdx;
    ScrollWidth := maxwid + 2;
    ItemHeight := Canvas.TextHeight('T');
    Items.EndUpdate;
  end;

  //if (AnalyzeThread) AnalyzeThread.Resume();
end;

procedure TFMain.lbUnitItemsDblClick(Sender : TObject);
var
  db:Byte;
  p1,p2,p3,bytes,ps,adr,idx, len, size, refCnt:Integer;
  use:TWordDynArray;
  tmpBuf:PAnsiChar;
  recN:InfoRec;
  tInfo:MTypeInfo;
  item,_name,typeName:AnsiString;
  rec:PROCHISTORYREC;
begin
  idx:=-1;
  if lbUnitItems.ItemIndex = -1 then Exit;

  item := lbUnitItems.Items[lbUnitItems.ItemIndex];
  //Xrefs?
  if (item[11] = '<') or (item[11] = '?') then
    sscanf(PAnsiChar(item)+1,'%lX%ls%ls',[@adr,@_name,@typeName])
  else
    sscanf(PAnsiChar(item)+1,'%lX%d%ls%ls',[@adr,@refCnt,@_name,@typeName]);
  if SameText(_name, '????') then
  Begin
    //Find end of unexplored Data
    bytes := 1024;
    ps := Adr2Pos(adr);
    //Get first byte (use later for filtering code?data)
    db := Byte(Code[ps]);

    with FExplorer do
    begin
      tsCode.TabVisible := true;
      ShowCode(adr, bytes);
      tsData.TabVisible := true;
      ShowData(adr, bytes);
      tsString.TabVisible := true;
      ShowString(adr, 1024);
      tsText.TabVisible := false;
      WAlign := 0;
      btnDefCode.Enabled := true;
      btnUndefCode.Enabled := false;
    end;
    if IsFlagSet(cfCode, ps) then FExplorer.btnDefCode.Enabled := false;
    if IsFlagSet(cfCode or cfData, ps) then FExplorer.btnUndefCode.Enabled := true;
    if (IsValidCode(adr) <> -1) and (db >= 15) then
    	FExplorer.pc1.ActivePage := FExplorer.tsCode
    else
    	FExplorer.pc1.ActivePage := FExplorer.tsData;
    if FExplorer.ShowModal = mrOk then
    case FExplorer.DefineAs of
      DEFINE_AS_CODE:
        begin
          recN := GetInfoRec(adr);
          if not Assigned(recN) then
            recN := InfoRec.Create(ps, ikRefine)
          else if (recN.kind < ikRefine) or (recN.kind > ikFunc) then
          Begin
            recN.Free;
            recN := InfoRec.Create(ps, ikRefine);
          End;

          //AnalyzeProcInitial(adr);
          AnalyzeProc1(adr, #0, 0, 0, false);
          AnalyzeProc2(adr, true, true);
          AnalyzeArguments(adr);
          AnalyzeProc2(adr, true, true);

          if not ContainsUnexplored(GetUnit(adr)) then ShowUnits(true);
          ShowUnitItems(GetUnit(adr), lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
          ShowCode(adr, 0, -1, -1);
        end;
      DEFINE_AS_STRING: ;
    End;
    Exit;
  End
  else if SameText(_name, '<VMT>') and tsClassView.TabVisible then
  Begin
    ShowClassViewer(adr);
    Exit;
  End
  else if SameText(_name, '<ResString>') then
  Begin
    FStringInfo.memStringInfo.Clear;
    FStringInfo.Caption := 'ResString';
    recN := GetInfoRec(adr);
    FStringInfo.memStringInfo.Lines.Add(recN.rsInfo);
    FStringInfo.ShowModal;
    Exit;
  End
  else if SameText(_name, '<ShortString>') or
    SameText(_name, '<AnsiString>')  or
    SameText(_name, '<WideString>')  or
    SameText(_name, '<PAnsiChar>')   or
    SameText(_name, '<PWideChar>') then
  Begin
    FStringInfo.memStringInfo.Clear;
    FStringInfo.Caption := 'String';
    recN := GetInfoRec(adr);
    FStringInfo.memStringInfo.Lines.Add(recN.Name);
    FStringInfo.ShowModal;
    Exit;
  End
  else if SameText(_name, '<UString>') then
  Begin
    FStringInfo.memStringInfo.Clear;
    FStringInfo.Caption := 'String';
    recN := GetInfoRec(adr);
    len := lstrlenw(PWideChar(Code) + Adr2Pos(adr));
    size := WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + Adr2Pos(adr), len, Nil, 0, Nil, Nil);
    if size<>0 then
    Begin
      GetMem(tmpBuf,size + 1);
      WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + Adr2Pos(adr), len, tmpBuf, len, Nil, Nil);
      FStringInfo.memStringInfo.Lines.Add(MakeString(tmpBuf, len));
      FreeMem(tmpBuf);
      FStringInfo.ShowModal;
    End;
    Exit;
  End
  else if SameText(_name, '<Integer>') or
    SameText(_name, '<Char>')        or
    SameText(_name, '<Enumeration>') or
    SameText(_name, '<Float>')       or
    SameText(_name, '<Set>')         or
    SameText(_name, '<Class>')       or
    SameText(_name, '<Method>')      or
    SameText(_name, '<WChar>')       or
    SameText(_name, '<Array>')       or
    SameText(_name, '<Record>')      or
    SameText(_name, '<Interface>')   or
    SameText(_name, '<Int64>')       or
    SameText(_name, '<DynArray>')    or
    SameText(_name, '<ClassRef>')    or
    SameText(_name, '<Pointer>')     or
    SameText(_name, '<Procedure>') then
  Begin
    use := KBase.GetTypeUses(PAnsiChar(typeName));
    idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(typeName));
    use:=Nil;
    if idx <> -1 then
    Begin
      idx := KBase.TypeOffsets[idx].NamId;
      if KBase.GetTypeInfo(idx, INFO_FIELDS or INFO_PROPS or INFO_METHODS, tInfo) then
      Begin
        FTypeInfo.ShowKbInfo(tInfo);
        //as delete tInfo;
      End;
    End
    else FTypeInfo.ShowRTTI(adr);
    Exit;
  End
  else if SameText(_name, '<Proc>') or
    SameText(_name, '<Func>')     	or
    SameText(_name, '<Constructor>') or
    SameText(_name, '<Destructor>')  or
    SameText(_name, '<EmbProc>') 	or
    SameText(_name, '<EmbFunc>')  	or
    SameText(_name, '<Emb?>')      or
    SameText(_name, '<ImpProc>')  	or
    SameText(_name, '<ExpProc>')  	or
    SameText(_name, '<ImpFunc>')  	or
    SameText(_name, '<ExpFunc>')   or
    SameText(_name, '<Imp?>')      or
    SameText(_name, '<Exp?>')      or
    SameText(_name, '<?>') then
  Begin
    rec.adr := CurProcAdr;
    rec.itemIdx := lbCode.ItemIndex;
    rec.xrefIdx := lbCXrefs.ItemIndex;
    rec.topIdx := lbCode.TopIndex;
    ShowCode(adr, 0, -1, -1);
    CodeHistoryPush(@rec);
    pcWorkArea.ActivePage := tsCodeView;
  End;
end;

procedure TFMain.lbUnitItemsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key = VK_RETURN then lbUnitItemsDblClick(Sender);
end;

procedure TFMain.lbUnitItemsClick(Sender : TObject);
begin
  UnitItemsSearchFrom := lbUnitItems.ItemIndex;
  WhereSearch := SEARCH_UNITITEMS;
end;

procedure TFMain.lbUnitItemsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
var
  flags:Integer;
  col:TColor;
  lb:TListBox;
  canva:TCanvas;
  text, str:AnsiString;
begin
  lb := TListBox(Control);
  canva := lb.Canvas;
  SaveCanvas(canva);
  if Index < lb.Count then
  begin
    flags := Control.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    if not Control.UseRightToLeftAlignment then
      Inc(Rect.Left, 2)
    else
      Dec(Rect.Right, 2);
    canva.FillRect(Rect);
    text := lb.Items[Index];
    //lb.ItemHeight := canva.TextHeight(text);
    str := Copy(text,2, Length(text) - 1);
    //Procs with Xrefs
    if (Byte(text[1]) and 6)<>0 then
    begin
      //Xrefs from user units
      if (Byte(text[1]) and 4)<>0 then
      begin
        if not (odSelected in State) then
          col := TColor($00B000) //Green
        else
          col := TColor($BBBBBB); //LightGray
      end
      //No Xrefs from user units, only from KB units
      else
      begin
        if not (odSelected in State) then
          col := TColor($C08000) //Blue
        else
          col := TColor($BBBBBB); //LightGray
      End;
    End
    //Unresolved items
    else if (Byte(text[1]) and 1)<>0 then
    begin
      if not(odSelected in State) then
        col := TColor($8080FF) //Red
      else
        col := TColor($BBBBBB); //LightGray
    end
    //Other
    else
    begin
      if not (odSelected in State) then
        col := TColor(0)        //Black
      else
        col := TColor($BBBBBB); //LightGray
    end;
    Rect.Right := Rect.Left;
    DrawOneItem(str, canva, Rect, col, flags);
  end;
  RestoreCanvas(canva);
end;

procedure TFMain.lbUnitItemsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if lbUnitItems.CanFocus then ActiveControl := lbUnitItems;
end;

procedure TFMain.miSearchItemClick(Sender : TObject);
Var
  n:Integer;
begin
  WhereSearch := SEARCH_UNITITEMS;
  FFindDlg.cbText.Clear;
  for n := 0 to UnitItemsSearchList.Count-1 do
    FFindDlg.cbText.AddItem(UnitItemsSearchList[n], Nil);
  if (FFindDlg.ShowModal = mrOk) and (FFindDlg.cbText.Text <> '') then
  begin
    if lbUnitItems.ItemIndex < 0 then
      UnitItemsSearchFrom := 0
    else
      UnitItemsSearchFrom := lbUnitItems.ItemIndex;
    UnitItemsSearchText := FFindDlg.cbText.Text;
    if UnitItemsSearchList.IndexOf(UnitItemsSearchText) = -1 then UnitItemsSearchList.Add(UnitItemsSearchText);
    FindText(UnitItemsSearchText);
  end;
end;

procedure TFMain.miEditFunctionIClick(Sender : TObject);
var
  p1,p2,refCnt, adr:Integer;
  item,_name:AnsiString;
begin
  if lbUnitItems.ItemIndex < 0 then Exit;

  item := lbUnitItems.Items[lbUnitItems.ItemIndex];
  //Xrefs?
  if (item[11] = '<') or (item[11] = '?') Then
    sscanf(PAnsiChar(item)+1,'%lX%ls',[@adr,@_name])
  else
    sscanf(PAnsiChar(item)+1,'%lX%d%ls',[@adr,@refCnt,@_name]);
  if SameText(_name, '<?>') or
    //SameText(_name, '<Imp?>') or
    //SameText(_name, '<Emb?>') or
    SameText(_name, '<Constructor>') or
    SameText(_name, '<Destructor>') or
    SameText(_name, '<Func>') or
    //SameText(_name, '<EmbFunc>') or
    SameText(_name, '<Proc>') //or
    //SameText(name, '<EmbProc>') or
    //SameText(name, '<ImpFunc>') or
    //SameText(name, '<ImpProc>')
  then EditFunction(adr);
end;

procedure TFMain.miCopyAddressIClick(Sender : TObject);
begin
  CopyAddress(lbUnitItems.Items[lbUnitItems.ItemIndex], 1, 8);
end;

Function SortRTTIsByAdr(item1, item2:Pointer):Integer;
var
  rec1:PTypeRec Absolute item1;
  rec2:PTypeRec Absolute item2;
begin
  if rec1.adr > rec2.adr then Result:=1
  else if rec1.adr < rec2.adr then Result:=-1
  else Result:=0;
end;

Function SortRTTIsByKnd(item1, item2:Pointer):Integer;
var
  rec1:PTypeRec Absolute item1;
  rec2:PTypeRec Absolute item2;
begin
  if rec1.kind > rec2.kind then Result:=1
  else if rec1.kind < rec2.kind then Result:=-1
  Else Result:=CompareText(rec1.name, rec2.name);
end;

Function SortRTTIsByNam(item1, item2:Pointer):Integer;
var
  rec1:PTypeRec Absolute item1;
  rec2:PTypeRec Absolute item2;
begin
  Result:= CompareText(rec1.name, rec2.name);
End;

Procedure TFMain.ShowRTTIs;
var
  n,wid, maxwid:Integer;
  canva:TCanvas;
  recT:PTypeRec;
  line:AnsiString;
Begin
  maxwid:=0;
  canva:=lbUnits.Canvas;
  lbRTTIs.Clear;
  //as
  lbRTTIs.Items.BeginUpdate;
  if OwnTypeList.Count<>0 then
  case RTTISortField of
    0: OwnTypeList.Sort(SortRTTIsByAdr);
    1: OwnTypeList.Sort(SortRTTIsByKnd);
    2: OwnTypeList.Sort(SortRTTIsByNam);
  end;
  for n := 0 to OwnTypeList.Count-1 do
  begin
    recT := OwnTypeList[n];
    if recT.kind = ikVMT then
      line := Val2Str(recT.adr,8) + ' <VMT> ' + recT.name
    else
      line := Val2Str(recT.adr,8) + ' <' + TypeKind2Name(recT.kind) + '> ' + recT.name;
    lbRTTIs.Items.Add(line);
    wid := canva.TextWidth(line);
    if wid > maxwid then maxwid := wid;
  end;
  lbRTTIs.Items.EndUpdate;
  lbRTTIs.ScrollWidth := maxwid + 2;
end;

procedure TFMain.lbRTTIsDblClick(Sender : TObject);
var
  p1,p2,adr:Integer;
  _name,typeName:AnsiString;
begin
  sscanf(PAnsiChar(lbRTTIs.Items[lbRTTIs.ItemIndex]),'%lX%ls%ls',[@adr,@_name,@typeName]);
  if SameText(_name, '<VMT>') and tsClassView.TabVisible then ShowClassViewer(adr)
    else FTypeInfo.ShowRTTI(adr);
end;

procedure TFMain.lbRTTIsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if lbRTTIs.CanFocus then ActiveControl := lbRTTIs;
end;

procedure TFMain.lbRTTIsClick(Sender : TObject);
begin
  RTTIsSearchFrom := lbRTTIs.ItemIndex;
  WhereSearch := SEARCH_RTTIS;
end;

procedure TFMain.lbRTTIsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key = VK_RETURN then lbRTTIsDblClick(Sender);
end;

procedure TFMain.miSearchRTTIClick(Sender : TObject);
var
  n:Integer;
begin
  WhereSearch := SEARCH_RTTIS;
  FFindDlg.cbText.Clear;
  for n := 0 to RTTIsSearchList.Count-1 do
    FFindDlg.cbText.AddItem(RTTIsSearchList[n], Nil);
  if (FFindDlg.ShowModal = mrOk) and (FFindDlg.cbText.Text <> '') then
  begin
    if lbRTTIs.ItemIndex < 0 then
      RTTIsSearchFrom := 0
    else
      RTTIsSearchFrom := lbRTTIs.ItemIndex;
    RTTIsSearchText := FFindDlg.cbText.Text;
    if RTTIsSearchList.IndexOf(RTTIsSearchText) = -1 then RTTIsSearchList.Add(RTTIsSearchText);
    FindText(RTTIsSearchText);
  end;
end;

procedure TFMain.pmRTTIsPopup(Sender : TObject);
begin
	if lbRTTIs.ItemIndex < 0 then Exit;
end;

procedure TFMain.miSortRTTIsByAdrClick(Sender : TObject);
begin
  miSortRTTIsByAdr.Checked := true;
  miSortRTTIsByKnd.Checked := false;
  miSortRTTIsByNam.Checked := false;
  RTTISortField := 0;
  ShowRTTIs;
end;

procedure TFMain.miSortRTTIsByKndClick(Sender : TObject);
begin
  miSortRTTIsByAdr.Checked := false;
  miSortRTTIsByKnd.Checked := true;
  miSortRTTIsByNam.Checked := false;
  RTTISortField := 1;
  ShowRTTIs;
end;

procedure TFMain.miSortRTTIsByNamClick(Sender : TObject);
begin
  miSortRTTIsByAdr.Checked := false;
  miSortRTTIsByKnd.Checked := false;
  miSortRTTIsByNam.Checked := true;
  RTTISortField := 2;
  ShowRTTIs;
end;

Procedure TFMain.ShowStrings (idx:Integer);
var
  n, wid, maxwid:Integer;
  recN:InfoRec;
  line, line1, str:AnsiString;
  canva:TCanvas;
Begin
  maxwid:=0;
  canva:=lbStrings.Canvas;
  lbStrings.Clear;
  lbStrings.Items.BeginUpdate;
  for n := 0 to CodeSize-1 do
  begin
    recN := GetInfoRec(Pos2Adr(n));
    if Assigned(recN) and Not IsFlagSet(cfRTTI, n) then
    begin
      if (recN.kind = ikResString) and (recN.rsInfo <> '') then
      begin
        line := ' ' + Val2Str(Pos2Adr(n),8) + ' <ResString> ' + recN.rsInfo;
        if Length(recN.rsInfo) <= MAXLEN then line1 := line
          else line1 := Copy(line,1, MAXLEN) + '...';
        Byte(line1[1]) := Byte(line1[1]) xor 1;
        lbStrings.Items.Add(line1);
        wid := canva.TextWidth(line1);
        if wid > maxwid then maxwid := wid;
        continue;
      end;
      if recN.HasName then
      begin
        case recN.kind of
          ikString: str := '<ShortString>';
          ikLString: str := '<AnsiString>';
          ikWString: str := '<WideString>';
          ikCString: str := '<PAnsiChar>';
          ikWCString: str := '<PWideChar>';
          ikUString:  str := '<UString>';
        Else str := '';
        end;
        if str <> '' then
        begin
          line := ' ' + Val2Str(Pos2Adr(n),8) + ' ' + str + ' ' + recN.Name;
          if recN.NameLength <= MAXLEN then line1 := line
            else line1 := Copy(line,1, MAXLEN) + '...';
          Byte(line1[1]):=Byte(line1[1]) xor 1;
          lbStrings.Items.Add(line1);
          wid := canva.TextWidth(line1);
          if wid > maxwid then maxwid := wid;
        end;
      end;
    end;
  end;
  with lbStrings do
  begin
    ItemIndex := idx;
    ScrollWidth := maxwid + 2;
    ItemHeight := Canvas.TextHeight('T');
    Items.EndUpdate;
  end;
end;

procedure TFMain.lbStringsClick(Sender : TObject);
var
  adr:Integer;
  line:AnsiString;
begin
  StringsSearchFrom := lbStrings.ItemIndex;
  WhereSearch := SEARCH_STRINGS;
  if lbStrings.ItemIndex >= 0 then
  begin
    line := lbStrings.Items[lbStrings.ItemIndex];
    sscanf(PAnsiChar(line)+1,'%lX',[@adr]);
    ShowStringXrefs(adr, -1);
  end;
end;

procedure TFMain.lbStringsDblClick(Sender : TObject);
var
  adr:Integer;
  line:AnsiString;
  recN:InfoRec;
begin
  line := lbStrings.Items[lbStrings.ItemIndex];
  sscanf(PAnsiChar(line)+1,'%lX',[@adr]);
  if IsValidImageAdr(adr) then
  With FStringInfo do
  begin
    recN := GetInfoRec(adr);
    if recN.kind = ikResString then
    begin
      Caption := 'ResString context';
      memStringInfo.Clear;
      memStringInfo.Lines.Add(recN.rsInfo);
      ShowModal;
    end
    else
    begin
      Caption := 'String context';
      memStringInfo.Clear;
      memStringInfo.Lines.Add(recN.Name);
      ShowModal;
    end;
  end;
end;

procedure TFMain.lbStringsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
var
  flags:Integer;
  col:TColor;
  lb:TListBox;
  canva:TCanvas;
  text, str:AnsiString;
begin
  lb := TListBox(Control);
  canva := lb.Canvas;
  SaveCanvas(canva);
  if Index < lb.Count then
  begin
    flags := Control.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    if not Control.UseRightToLeftAlignment then
      Inc(Rect.Left,2)
    else
      Dec(Rect.Right,2);
    canva.FillRect(Rect);
    text := lb.Items[Index];
    //lb.ItemHeight := canva.TextHeight(text);
    str := Copy(text,2, Length(text) - 1);

    //Long strings
    if (Byte(text[1]) and 1)<>0 then
      col := TColor($BBBBBB) //LightGray
    else
      col := TColor(0);//Black
    Rect.Right := Rect.Left;
    DrawOneItem(str, canva, Rect, col, flags);
  end;
  RestoreCanvas(canva);
end;

procedure TFMain.miSearchStringClick(Sender : TObject);
var
  n,adr:Integer;
  line:AnsiString;
begin
  WhereSearch := SEARCH_STRINGS;
  FFindDlg.cbText.Clear;
  for n := 0 to StringsSearchList.Count-1 do
    FFindDlg.cbText.AddItem(StringsSearchList[n], Nil);
  if (FFindDlg.ShowModal = mrOk) and (FFindDlg.cbText.Text <> '') then
  begin
    if lbRTTIs.ItemIndex < 0 then
      StringsSearchFrom := 0
    else
      StringsSearchFrom := lbStrings.ItemIndex;
    StringsSearchText := FFindDlg.cbText.Text;
    if StringsSearchList.IndexOf(StringsSearchText) = -1 then StringsSearchList.Add(StringsSearchText);
    FindText(StringsSearchText);
    line := lbStrings.Items[lbStrings.ItemIndex];
    sscanf(PAnsiChar(line)+1,'%lX',[@adr]);
    ShowStringXrefs(adr, -1);
  end;
end;

procedure TFMain.lbStringsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if lbStrings.CanFocus then ActiveControl := lbStrings;
end;

procedure TFMain.ShowSXrefsClick(Sender : TObject);
begin
  if lbSXrefs.Visible then
  begin
    ShowSXrefs.BevelOuter := bvRaised;
    lbSXrefs.Visible := false;
  end
  else
  begin
    ShowSXrefs.BevelOuter := bvLowered;
    lbSXrefs.Visible := true;
  end;
end;

Procedure TFMain.ShowStringXrefs (Adr:Integer; selIdx:Integer);
var
  recN:InfoRec;
  m,wid, maxwid,pAdr:Integer;
  canva:TCanvas;
  recX:PXrefRec;
  recU:PUnitRec;
  line:AnsiString;
  f:Byte;
Begin
  maxwid:=0;
  canva:=lbSXrefs.Canvas;
  pAdr:=0;
  f:=2;
  lbSXrefs.Clear;
  recN := GetInfoRec(Adr);
  if Assigned(recN) and Assigned(recN.xrefs) then
  begin
    lbSXrefs.Items.BeginUpdate;
    for m := 0 to recN.xrefs.Count-1 do
    begin
      recX := recN.xrefs[m];
      line := ' ' + Val2Str(recX.adr + recX.offset,8) + ' ' + recX._type;
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
      recU := GetUnit(recX.adr);
      if Assigned(recU) and recU.kb then Byte(line[1]):=Byte(line[1]) xor 1;
      if pAdr <> recX.adr then f:=f xor 2;
      Byte(line[1]):=Byte(line[1]) xor f;
      pAdr := recX.adr;
      lbSXrefs.Items.Add(line);
    end;
    with lbSXrefs do
    begin
      Items.EndUpdate;
      ScrollWidth := maxwid + 2;
      ItemIndex := selIdx;
    end;
  end;
end;

procedure TFMain.pmStringsPopup(Sender : TObject);
begin
  if lbStrings.ItemIndex < 0 then Exit;
end;

Procedure TFMain.ShowNames (idx:Integer);
var
  n, wid, maxwid:Integer;
  recN:InfoRec;
  line:AnsiString;
  canva:TCanvas;
Begin
  maxwid:=0;
  canva:=lbNames.Canvas;
  lbNames.Clear;
  lbNames.Items.BeginUpdate;
  for n := CodeSize to TotalSize-1 do
  begin
    if IsFlagSet(cfImport, n) then continue;
    recN := GetInfoRec(Pos2Adr(n));
    if Assigned(recN) and recN.HasName then
    begin
      line := Val2Str(Pos2Adr(n),8) + ' ' + recN.Name;
      if recN._type <> '' then line := line + ':' + recN._type;
      lbNames.Items.Add(line);
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
    end;
  End;
  for n := 0 to BSSInfos.Count-1 do
  begin
    recN := InfoRec(BSSInfos.Objects[n]);
    line := BSSInfos[n] + ' ' + recN.Name;
    if recN._type <> '' Then line :=line + ':' + recN._type;
    lbNames.Items.Add(line);
    wid := canva.TextWidth(line);
    if wid > maxwid then maxwid := wid;
  end;
  with lbNames do
  begin
    Items.EndUpdate;
    ItemIndex := idx;
    ScrollWidth := maxwid + 2;
  end;
end;

Procedure TFMain.ShowNameXrefs (Adr:Integer; selIdx:Integer);
var
  recN:InfoRec;
  recX:PXrefRec;
  recU:PUnitRec;
  m,wid, maxwid,pAdr:Integer;
  canva:TCanvas;
  line:AnsiString;
  f:Byte;
Begin
  maxwid:=0;
  canva:=lbNXrefs.Canvas;
  pAdr:=0;
  f:=2;
  lbNXrefs.Clear;
  recN := GetInfoRec(Adr);
  if Assigned(recN) and Assigned(recN.xrefs) Then
  Begin
    lbNXrefs.Items.BeginUpdate;
    for m := 0 to recN.xrefs.Count-1 do
    begin
      recX := recN.xrefs[m];
      line := ' ' + Val2Str(recX.adr + recX.offset,8) + ' ' + recX._type;
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
      recU := GetUnit(recX.adr);
      if Assigned(recU) and recU.kb then Byte(line[1]):=Byte(line[1]) xor 1;
      if pAdr <> recX.adr then f:=f xor 2;
      Byte(line[1]):=Byte(line[1]) xor f;
      pAdr := recX.adr;
      lbNXrefs.Items.Add(line);
    end;
    with lbNXrefs do
    begin
      Items.EndUpdate;
      ScrollWidth := maxwid + 2;
      ItemIndex := selIdx;
    end;
  end;
end;

procedure TFMain.lbNamesClick(Sender : TObject);
var
  adr:Integer;
  line:AnsiString;
begin
  //NamesSearchFrom := lbNames.ItemIndex;
  //WhereSearch := SEARCH_NAMES;

  if lbNames.ItemIndex >= 0 Then
  begin
    line := lbNames.Items[lbNames.ItemIndex];
    sscanf(PAnsiChar(line)+1,'%lX',[@adr]);
    ShowNameXrefs(adr, -1);
  end;
end;

Procedure TFMain.ShowCodeXrefs (Adr:Integer; selIdx:Integer);
var
  m,wid, maxwid,pAdr:Integer;
  canva:TCanvas;
  f:Byte;
  recN:InfoRec;
  recX:PXrefRec;
  recU:PUnitRec;
  line:AnsiString;
Begin
  maxwid:=0;
  canva:=lbCXrefs.Canvas;
  pAdr:=0;
  f:=2;
  lbCXrefs.Clear;
  recN := GetInfoRec(Adr);
  if Assigned(recN) and Assigned(recN.xrefs) then
  begin
    lbCXrefs.Items.BeginUpdate;
    for m := 0 to recN.xrefs.Count-1 do
    begin
      recX := recN.xrefs[m];
      line := ' ' + Val2Str(recX.adr + recX.offset,8) + ' ' + recX._type;
      wid := canva.TextWidth(line);
      if wid > maxwid then maxwid := wid;
      recU := GetUnit(recX.adr);
      if Assigned(recU) and recU.kb then Byte(line[1]):=Byte(line[1]) xor 1;
      if pAdr <> recX.adr then f:=f xor 2;
      Byte(line[1]):=Byte(line[1]) xor f;
      pAdr := recX.adr;
      lbCXrefs.Items.Add(line);
    end;
    with lbCXrefs do
    begin
      ScrollWidth := maxwid + 2;
      ItemIndex := selIdx;
      ItemHeight := Canvas.TextHeight('T');
      Items.EndUpdate;
    end;
  end;
end;

procedure TFMain.lbXrefsMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if TListBox(Sender).CanFocus then ActiveControl := TWinControl(Sender);
end;

procedure TFMain.lbXrefsDblClick(Sender : TObject);
var
  p1,adr,m:Integer;
  rec:PROCHISTORYREC;
  lb:TListBox;
  recN:InfoRec;
  _type:Array[1..2] of Char;
  txt,item:AnsiString;
begin
  lb:=TListBox(Sender);
  if lb.ItemIndex < 0 then Exit;
  item := lb.Items[lb.ItemIndex];
  sscanf(PAnsiChar(item)+1,'%lX%2c',[@adr,@_type]);
  if _type[1] = 'D' then
  begin
    recN := GetInfoRec(adr);
    if Assigned(recN) and (recN.kind = ikVMT) then
    begin
      ShowClassViewer(adr);
      WhereSearch := SEARCH_CLASSVIEWER;
      if rgViewerMode.ItemIndex=0 then
        TreeSearchFrom := tvClassesFull.Items[0]
      else
        BranchSearchFrom := tvClassesShort.Items[0];
      //Сначала ищем класс
      txt := '#' + Val2Str(adr,8);
      FindText(txt);
      //Потом - текущую процедуру
      if rgViewerMode.ItemIndex=0 then
      begin
        if Assigned(tvClassesFull.Selected) then
          TreeSearchFrom := tvClassesFull.Selected
        else
          TreeSearchFrom := tvClassesFull.Items[0];
      end
      else
      begin
        if Assigned(tvClassesShort.Selected) then
          BranchSearchFrom := tvClassesShort.Selected
        else
          BranchSearchFrom := tvClassesShort.Items[0];
      end;
      txt := '#' + Val2Str(CurProcAdr,8);
      FindText(txt);
      Exit;
    End;
  end;
  for m := Adr2Pos(adr) Downto 0 do
    if IsFlagSet(cfProcStart, m) then
    begin
      with rec do
      begin
        adr := CurProcAdr;
        itemIdx := lbCode.ItemIndex;
        xrefIdx := lbCXrefs.ItemIndex;
        topIdx := lbCode.TopIndex;
      end;
      ShowCode(Pos2Adr(m), adr, -1, -1);
      CodeHistoryPush(@rec);
      break;
    end;
end;

procedure TFMain.lbXrefsKeyDown(Sender : TObject; var Key:Word; Shift:TShiftState);
begin
  if Key = VK_RETURN then lbXrefsDblClick(Sender);
end;

procedure TFMain.lbXrefsDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
var
  flags:Integer;
  col:TColor;
  lb:TListBox;
  canva:TCanvas;
  text, str:AnsiString;
begin
  lb := TListBox(Control);
  canva := lb.Canvas;
  SaveCanvas(canva);
  if Index < lb.Count then
  begin
    flags := Control.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    if not Control.UseRightToLeftAlignment then
      Inc(Rect.Left,2)
    else
      Dec(Rect.Right, 2);

    text := lb.Items[Index];
    //lb.ItemHeight := canva.TextHeight(text);
    str := Copy(text,2, Length(text) - 1);
    if (Byte(text[1]) and 2)<>0 then
    begin
      if not (odSelected in State) then
        canva.Brush.Color := TColor($E7E7E7)
      else
        canva.Brush.Color := TColor($FF0000);
    end;
    canva.FillRect(Rect);

    //Xrefs to Kb units
    if (Byte(text[1]) and 1)<>0 then
    begin
      if not (odSelected in State) then
        col := TColor($C08000) //Blue
      else
        col := TColor($BBBBBB); //LightGray
    end
    //Others
    else
    begin
      if Not (odSelected in State) then
        col := TColor($00B000) //Green
      else
        col := TColor($BBBBBB); //LightGray
    end;
    Rect.Right := Rect.Left;
    DrawOneItem(str, canva, Rect, col, flags);
  end;
  RestoreCanvas(canva);
end;

//Create XRefs
//Scan procedure calls (include constructors and destructors)
//Calculate size of stack for arguments
Procedure TFMain.AnalyzeProc1 (fromAdr:Integer; xrefType:Char; xrefAdr:Integer; xrefOfs:Integer; maybeEmb:Boolean);
var
	op, b1, b2:Byte;
  bpBased,mbemb:Boolean;
  bpBase:Word;
  num, skipNum, instrLen, instrLen1, instrLen2, procSize,b,begPos, endPos:Integer;
  k,procAdr,fromPos, curPos, Pos0, Pos1, Pos2,cTblAdr,jTblAdr,codeValidity:Integer;
  curAdr, Adr, Adr1, finallyAdr, endAdr, maxAdr,CNum,hoStartPos:Integer;
  lastMovTarget, lastCmpPos, lastAdr,NPos,delta,hfStartPos:Integer;
  recN, recN1:InfoRec;
  recX:PXrefRec;
  DisInfo:TDisInfo;
  CTab:Array[0..255] of Byte;
Begin
If is_debug Then CodeSite.Send('ENTER; fromAdr = %d',[fromAdr]);
  bpBased:=False;
  bpBase:=4;
  lastMovTarget := 0;
  lastCmpPos := 0;
  lastAdr := 0;
  fromPos := Adr2Pos(fromAdr);
  if (fromPos < 0) or IsFlagSet(cfEmbedded, fromPos) then Exit;

  b1 := Byte(Code[fromPos]);
  b2 := Byte(Code[fromPos + 1]);
  if (b1=0) and (b2=0) then Exit;

  recN := GetInfoRec(fromAdr);
if is_debug then
  If Assigned(recN) Then CodeSite.Send('recN = %s',[recN.Name])
    else CodeSite.Send('recN = NIL');

  //Virtual constructor - don't analyze
  if Assigned(recN) and (Pos('class of ',recN._type) = 1) then Exit;

  if not Assigned(recN) then
    recN := InfoRec.Create(fromPos, ikRefine)
  else if (recN.kind = ikUnknown) or (recN.kind = ikData) then
  Begin
    recN.kind := ikRefine;
    recN.procInfo := InfoProcInfo.Create;
  End;

  //If xrefAdr <> 0, add it to recN.xrefs
  if xrefAdr<>0 then
  Begin
    recN.AddXref(xrefType, xrefAdr, xrefOfs);
    SetFlag(cfProcStart, Adr2Pos(xrefAdr));
  End;

  //Don't analyze imports
  if IsFlagSet(cfImport, fromPos) then Exit;
  //if (IsFlagSet(cfExport, fromPos)) return;

  //If Pass1 was set skip analyze
  if IsFlagSet(cfPass1, fromPos) then Exit;

  if not IsFlagSet(cfPass0, fromPos) then AnalyzeProcInitial(fromAdr);
  SetFlag(cfProcStart or cfPass1, fromPos);

  if maybeEmb and ((recN.procInfo.flags and PF_EMBED)=0) then
    Cardinal(recN.procInfo.flags) := Cardinal(recN.procInfo.flags) or PF_MAYBEEMBED;
  procSize := GetProcSize(fromAdr);
  curPos := fromPos; 
  curAdr := fromAdr;
  while true do
  Begin
    if curAdr >= Integer(CodeBase) + TotalSize then break;
    //---------------------------------- Try
    //        xor reg, reg               cfTry | cfSkip
    //        push ebp                   cfSkip
    //        push offset @1             cfSkip
    //        push fs:[reg]              cfSkip
    //        mov fs:[reg], esp          cfSkip
    //
    //---------------------------------- OnFinally
    //        xor reg, reg               cfFinally | cfSkip
    //        pop reg                    cfSkip
    //        pop reg                    cfSkip
    //        pop reg                    cfSkip
    //        mov fs:[reg], esp          cfSkip
    //Adr1-1: push offset @3             cfSkip
    //@2:     ...
    //        ret                        cfSkip
    //---------------------------------- Finally
    //@1:     jmp @HandleFinally         cfFinally | cfSkip
    //        jmp @2                     cfFinally | cfSkip
    //@3:     ...                        end of Finally Section
    //---------------------------------- Except
    //        xor reg, reg               cfExcept | cfSkip
    //        pop reg                    cfSkip
    //        pop reg                    cfSkip
    //        pop reg                    cfSkip
    //        mov fs:[reg], esp          cfSkip
    //        jmp @3 . End of Exception Section cfSkip
    //@1:     jmp @HandleAnyException    cfExcept | cfSkip
    //        ...
    //        call DoneExcept
    //        ...
    //@3:     ...
    //---------------------------------- Except (another variant, rear)
    //        pop fs:[0]                 cfExcept | cfSkip
    //        add esp,8                  cfSkip
    //        jmp @3 . End of Exception Section cfSkip
    //@1:     jmp @HandleAnyException    cfExcept | cfSkip
    //        ...
    //        call DoneExcept
    //        ...
    //@3:     ...
    //---------------------------------- OnExcept
    //        xor reg, reg               cfExcept | cfSkip
    //        pop reg                    cfSkip
    //        pop reg                    cfSkip
    //        pop reg                    cfSkip
    //        mov fs:[reg], esp          cfSkip
    //        jmp @3 . End of Exception Section cfSkip
    //@1:     jmp HandleOnException      cfExcept | cfSkip
    //        dd num                     cfETable
    //Table from num records:
    //        dd offset ExceptionInfo
    //        dd offset ExceptionProc
    //        ...
    //@3:     ...
    //----------------------------------
    //Is it try section begin (skipNum > 0)?
    skipNum := IsTryBegin(curAdr, finallyAdr) + IsTryBegin0(curAdr, finallyAdr);
    if skipNum > 0 then
    Begin
      Adr := finallyAdr;      //Adr:=@1
      if Adr > lastAdr then lastAdr := Adr;
      Pos0 := Adr2Pos(Adr); 
      assert(Pos0 >= 0);
      SetFlag(cfTry, curPos);
      SetFlags(cfSkip, curPos, skipNum);

      //Disassemble jmp
      instrLen1 := frmDisasm.Disassemble(Code + Pos0, Adr, @DisInfo, Nil);
      recN1 := GetInfoRec(DisInfo.Immediate);
      if Assigned(recN1) and recN1.HasName then
      Begin
        //jmp @HandleFinally
        if recN1.SameName('@HandleFinally') then
        Begin
          SetFlag(cfFinally, Pos0);//@1
          SetFlags(cfSkip, Pos0 - 1, instrLen1 + 1);   //ret + jmp HandleFinally
          Inc(Pos0, instrLen1); 
          Inc(Adr, instrLen1);
          //jmp @2
          instrLen2 := frmDisasm.Disassemble(Pos2Adr(Pos0), @DisInfo, Nil);
          SetFlag(cfFinally, Pos0);//jmp @2
          SetFlags(cfSkip, Pos0, instrLen2);//jmp @2
          Inc(Adr, instrLen2);
          if Adr > lastAdr then lastAdr := Adr;
          Pos0 := Adr2Pos(DisInfo.Immediate);//@2
          //Get prev (before Pos) instruction
          Pos1 := GetNearestUpInstruction(Pos0);
          instrLen2 := frmDisasm.Disassemble(Pos2Adr(Pos1), @DisInfo, Nil);
          //If push XXXXXXXX . set new lastAdr
          if frmDisasm.GetOp(DisInfo.Mnem) = OP_PUSH then
          Begin
            SetFlags(cfSkip, Pos1, instrLen2);
            if (DisInfo.OpType[0] = otIMM) and (DisInfo.Immediate > lastAdr) then lastAdr := DisInfo.Immediate;
          End;

          //Find nearest up instruction with segment prefix fs:
          Pos1 := GetNearestUpPrefixFs(Pos0);
          instrLen2 := frmDisasm.Disassemble(Pos2Adr(Pos1), @DisInfo, Nil);
          //pop fs:[0]
          if frmDisasm.GetOp(DisInfo.Mnem) = OP_POP then
            SetFlags(cfSkip, Pos1, Pos0 - Pos1)
          //mov fs:[0],reg
          else if (DisInfo.OpType[0] = otMEM) and (DisInfo.BaseReg = -1) and (DisInfo.Offset = 0) then
          Begin
            Pos2 := GetNthUpInstruction(Pos1, 3);
            SetFlag(cfFinally, Pos2);
            SetFlags(cfSkip, Pos2, Pos1 - Pos2 + instrLen2);
          End
          //mov fs:[reg1], reg2
          else
          Begin
            Pos2 := GetNthUpInstruction(Pos1, 4);
            SetFlag(cfFinally, Pos2);
            SetFlags(cfSkip, Pos2, Pos1 - Pos2 + instrLen2);
          End;
        End
        else if recN1.SameName('@HandleAnyException') or recN1.SameName('@HandleAutoException') then
        Begin
          SetFlag(cfExcept, Pos0);//@1
          //Find nearest up instruction with segment prefix fs:
          Pos1 := GetNearestUpPrefixFs(Pos0);
          instrLen2 := frmDisasm.Disassemble(Pos2Adr(Pos1), @DisInfo, Nil);
          //pop fs:[0]
          if frmDisasm.GetOp(DisInfo.Mnem) = OP_POP then
            SetFlags(cfSkip, Pos1, Pos0 - Pos1)
          //mov fs:[0],reg
          else if (DisInfo.OpType[0] = otMEM) and (DisInfo.BaseReg = -1) and (DisInfo.Offset = 0) then
          Begin
            Pos2 := GetNthUpInstruction(Pos1, 3);
            SetFlag(cfExcept, Pos2);
            SetFlags(cfSkip, Pos2, Pos1 - Pos2 + instrLen2);
          End
          //mov fs:[reg1], reg2
          else
          Begin
            Pos2 := GetNthUpInstruction(Pos1, 4);
            SetFlag(cfExcept, Pos2);
            SetFlags(cfSkip, Pos2, Pos1 - Pos2 + instrLen2);
          End;

          //Get prev (before Pos) instruction
          Pos1 := GetNearestUpInstruction(Pos0);
          frmDisasm.Disassemble(Pos2Adr(Pos1), @DisInfo, Nil);
          //If jmp . set new lastAdr
          if (frmDisasm.GetOp(DisInfo.Mnem) = OP_JMP) and (DisInfo.Immediate > lastAdr) then lastAdr := DisInfo.Immediate;
        End
        else if recN1.SameName('@HandleOnException') then
        Begin
          SetFlag(cfExcept, Pos0);//@1
          //Find nearest up instruction with segment prefix fs:
          Pos1 := GetNearestUpPrefixFs(Pos0);
          instrLen2 := frmDisasm.Disassemble(Pos2Adr(Pos1), @DisInfo, Nil);
          //pop fs:[0]
          if frmDisasm.GetOp(DisInfo.Mnem) = OP_POP then
            SetFlags(cfSkip, Pos1, Pos0 - Pos1)
          //mov fs:[0],reg
          else if (DisInfo.OpType[0] = otMEM) and (DisInfo.BaseReg = -1) and (DisInfo.Offset = 0) then
          Begin
            Pos2 := GetNthUpInstruction(Pos1, 3);
            SetFlag(cfExcept, Pos2);
            SetFlags(cfSkip, Pos2, Pos1 - Pos2 + instrLen2);
          End
          //mov fs:[reg1], reg2
          else
          Begin
            Pos2 := GetNthUpInstruction(Pos1, 4);
            SetFlag(cfExcept, Pos2);
            SetFlags(cfSkip, Pos2, Pos1 - Pos2 + instrLen2);
          End;

          //Get prev (before Pos) instruction
          Pos1 := GetNearestUpInstruction(Pos0);
          frmDisasm.Disassemble(Pos2Adr(Pos1), @DisInfo, Nil);
          //If jmp . set new lastAdr
          if (frmDisasm.GetOp(DisInfo.Mnem) = OP_JMP) and (DisInfo.Immediate > lastAdr) then lastAdr := DisInfo.Immediate;

          //Next instruction
          Inc(Pos0, instrLen1); 
          Inc(Adr, instrLen1);
          //Set flag cfETable
          SetFlag(cfETable, Pos0);
          //dd num
          num := PInteger(Code + Pos0)^;
          SetFlags(cfSkip, Pos0, 4); 
          Inc(Pos0, 4);
          if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
          for k := 0 to num-1 do
          Begin
            //dd offset ExceptionInfo
            SetFlags(cfSkip, Pos0, 4); 
            Inc(Pos0, 4);
            //dd offset ExceptionProc
            procAdr := PInteger(Code + Pos0)^;
            if IsValidCodeAdr(procAdr) then SetFlag(cfLoc, Adr2Pos(procAdr));
            SetFlags(cfSkip, Pos0, 4);
            Inc(Pos0, 4);
          End;
        End;
      End;
      Inc(curPos, skipNum);
      Inc(curAdr, skipNum);
      continue;
    End;
    //Is it finally section?
    skipNum := IsTryEndPush(curAdr, endAdr);
    if skipNum > 0 then
    Begin
      SetFlag(cfFinally, curPos);
      SetFlags(cfSkip, curPos, skipNum);
      if endAdr > lastAdr then lastAdr := endAdr;
      Inc(curPos, skipNum); 
      Inc(curAdr, skipNum);
      continue;
    End;
    //Finally section in if...then...else constructions
    skipNum := IsTryEndJump(curAdr, endAdr);
    if skipNum > 0 then
    Begin
      SetFlag(cfFinally or cfExcept, curPos);
      SetFlags(cfSkip, curPos, skipNum);
      if endAdr > lastAdr then lastAdr := endAdr;
      Inc(curPos, skipNum); 
      Inc(curAdr, skipNum);
      continue;
    End;
    //Int64NotEquality
    {
    skipNum := ProcessInt64NotEquality(curAdr, @maxAdr);
    if skipNum > 0 then
    Begin
      if maxAdr > lastAdr then lastAdr := maxAdr;
      Inc(curPos, skipNum);
      Inc(curAdr, skipNum);
      continue;
    End;
    //Int64Equality
    skipNum := ProcessInt64Equality(curAdr, @maxAdr);
    if skipNum > 0 then
    Begin
      if maxAdr > lastAdr then lastAdr := maxAdr;
      Inc(curPos, skipNum); 
      Inc(curAdr, skipNum);
      continue;
    End;
    }
    //Int64Comparison
    skipNum := ProcessInt64Comparison(curAdr, maxAdr);
    if skipNum > 0 then
    Begin
      if maxAdr > lastAdr then lastAdr := maxAdr;
      Inc(curPos, skipNum); 
      Inc(curAdr, skipNum);
      continue;
    End;
    //Int64ComparisonViaStack1
    skipNum := ProcessInt64ComparisonViaStack1(curAdr, maxAdr);
    if skipNum > 0 then
    Begin
      if maxAdr > lastAdr then lastAdr := maxAdr;
      Inc(curPos, skipNum);
      Inc(curAdr, skipNum);
      continue;
    End;
    //Int64ComparisonViaStack2
    skipNum := ProcessInt64ComparisonViaStack2(curAdr, maxAdr);
    if skipNum > 0 then
    Begin
      if maxAdr > lastAdr then lastAdr := maxAdr;
      Inc(curPos, skipNum); 
      Inc(curAdr, skipNum);
      continue;
    End;
    //Skip exception table
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      Inc(curPos, 4 + 8*num); 
      Inc(curAdr, 4 + 8*num);
      continue;
    End;
    b1 := Byte(Code[curPos]);
    b2 := Byte(Code[curPos + 1]);
    if (b1=0) and (b2=0) and (lastAdr=0) then break;

    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) break;
    if instrLen=0 then
    Begin
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    op := frmDisasm.GetOp(DisInfo.Mnem);
    //Code
    SetFlags(cfCode, curPos, instrLen);
    //Instruction begin
    SetFlag(cfInstruction, curPos);
    if curAdr >= lastAdr then lastAdr := 0;

    //Frame instructions
    if (curAdr = fromAdr) and (b1 = $55) then   //push ebp
      SetFlag(cfFrame, curPos);
    if (b1 = $8B) and (b2 = $EC) then          //mov ebp, esp
    Begin
    	bpBased := true;
      recN.procInfo.flags := recN.procInfo.flags or PF_BPBASED;
      recN.procInfo.bpBase := bpBase;
      SetFlags(cfFrame, curPos, instrLen);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if (b1 = $8B) and (b2 = $E5) then          //mov esp, ebp
    Begin
      SetFlags(cfFrame, curPos, instrLen);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if op = OP_JMP then
    Begin
      if curAdr = fromAdr then break;
      if DisInfo.OpType[0] = otMEM then
      Begin
        if (Adr2Pos(DisInfo.Offset) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
      End;
      if DisInfo.OpType[0] = otIMM then
      Begin
if is_debug then CodeSite.Send('OP_JMP; curAdr = %d',[curAdr]);
        Adr := DisInfo.Immediate;
        Pos0 := Adr2Pos(Adr);
        if (Pos0 < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        if (GetSegmentNo(Adr) <> 0) and (GetSegmentNo(fromAdr) <> GetSegmentNo(Adr))
          and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        SetFlag(cfLoc, Pos0);
        recN1 := GetInfoRec(Adr);
        if not Assigned(recN1) then recN1 := InfoRec.Create(Pos0, ikUnknown);
        recN1.AddXref('J', fromAdr, curAdr - fromAdr);
        if (Adr < fromAdr) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
      End;
    End;

    //End of procedure
    if DisInfo.Ret then
      if (lastAdr=0) or (curAdr = lastAdr) then
      Begin
        //Proc end
        //SetFlag(cfProcEnd, curPos + instrLen - 1);
        recN.procInfo.procSize := curAdr - fromAdr + instrLen;
        recN.procInfo.retBytes := 0;
        //ret N
        if DisInfo.OpNum<>0 then
          recN.procInfo.retBytes := DisInfo.Immediate;//num;
        break;
      End;
    //push
    if op = OP_PUSH then
    Begin
      SetFlag(cfPush, curPos);
      Inc(bpBase, 4);
    End
    //pop
    else if op = OP_POP then SetFlag(cfPop, curPos);
    //add (sub) esp,...
    if (DisInfo.OpRegIdx[0] = 20) and (DisInfo.OpType[1] = otIMM) then
    Begin
      if op = OP_ADD then Dec(bpBase, DisInfo.Immediate)
      else if op = OP_SUB then Inc(bpBase, DisInfo.Immediate);
      //skip
      SetFlags(cfSkip, curPos, instrLen);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    ////fstp [esp]
    //if (!memcmp(DisInfo.Mnem, 'fst', 3) and DisInfo.BaseReg = 20) SetFlag(cfFush, curPos);

    //skip
    if (DisInfo.Mnem = 'sahf') or (DisInfo.Mnem = 'wait') then
    Begin
      SetFlags(cfSkip, curPos, instrLen);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if op = OP_MOV then lastMovTarget := DisInfo.Offset
    else if op = OP_CMP then lastCmpPos := curPos;

    //Is instruction (not call and jmp), that contaibs operand [reg+xxx], where xxx is negative value
    if maybeEmb and not DisInfo.Call and not DisInfo.Branch and (DisInfo.Offset < 0) and
    	((DisInfo.IndxReg = -1) and (DisInfo.BaseReg in [16..19,22,23])) then
    Begin
    	//May be add condition that all Xrefs must points to one subroutine!!!!!!!!!!!!!
    	if (bpBased and (DisInfo.BaseReg <> 21)) or (not bpBased and (DisInfo.BaseReg <> 20)) then
        recN.procInfo.flags := recN.procInfo.flags or PF_EMBED;
    End;
    if (b1 = 255) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      if not IsValidCodeAdr(DisInfo.Offset) then
      Begin
        //SetFlag(cfProcEnd, curPos + instrLen - 1);
        recN.procInfo.procSize := curAdr - fromAdr + instrLen;
      	break;
      End;
      cTblAdr := 0;
      jTblAdr := 0;
      SetFlag(cfSwitch, lastCmpPos);
      SetFlag(cfSwitch, curPos);
      
      Pos0 := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Table address  - last 4 bytes of instruction
      jTblAdr := PInteger(Code + Pos0 - 4)^;
      //Scan gap to find table cTbl
      if (Adr <= lastMovTarget) and (lastMovTarget < jTblAdr) then cTblAdr := lastMovTarget;
      //If exists cTblAdr, skip it
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        SetFlags(cfSkip, Pos0, CNum);
        Inc(Pos0, CNum);
        Inc(Adr, CNum);
      End;
      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, Pos0) then break;
        Adr1 := PInteger(Code + Pos0)^;
        //Validate Adr1
        if not IsValidCodeAdr(Adr1) or (Adr1 < fromAdr) then break;
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        SetFlags(cfSkip, Pos0, 4);
        Inc(Pos0, 4); 
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := Pos0; 
      curAdr := Adr;
      continue;
    End;
    if b1 = $68 then		//try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //Check that next instruction is push fs:[reg] or retn
      if ((Code[NPos] = #$64) and (Code[NPos + 1] = #255) and (Code[NPos + 2] in [#$30..#$37,#$75]))
        or (Code[NPos] = #$C3) then
      Begin
If is_debug then CodeSite.Send('b1 = $68; curAdr = %d',[curAdr]);
        Adr := DisInfo.Immediate;      //Adr:=@1
        if Adr > lastAdr then lastAdr := Adr;
        Pos0 := Adr2Pos(Adr);
        assert(Pos0 >= 0);
        delta := Pos0 - NPos;
        if (delta>=0) and (delta < MAX_DISASSEMBLE) then
        Begin
If is_debug then CodeSite.Send('delta inside; curAdr = %d',[curAdr]);
          if Code[Pos0] = #$E9 then //jmp Handle...
          Begin
If is_debug then CodeSite.Send('code = $E9; curAdr = %d',[curAdr]);
            if Code[NPos + 2] = #$35 then
            Begin
              SetFlag(cfTry, NPos - 6);
              SetFlags(cfSkip, NPos - 6, 20);
            End
            else
            Begin
              SetFlag(cfTry, NPos - 8);
              SetFlags(cfSkip, NPos - 8, 14);
            End;
            //Disassemble jmp
            instrLen1 := frmDisasm.Disassemble(Code + Pos0, Adr, @DisInfo, Nil);
            recN1 := GetInfoRec(DisInfo.Immediate);
            if Assigned(recN1) and recN1.HasName then
            Begin
              //jmp @HandleFinally
              if recN1.SameName('@HandleFinally') then
              Begin
                SetFlag(cfFinally, Pos0);
                SetFlags(cfSkip, Pos0 - 1, instrLen1 + 1);   //ret + jmp HandleFinally
                Inc(Pos0, instrLen1); 
                Inc(Adr, instrLen1);
                //jmp @2
                instrLen2 := frmDisasm.Disassemble(Code + Pos0, Adr, @DisInfo, Nil);
                SetFlag(cfFinally, Pos0);
                SetFlags(cfSkip, Pos0, instrLen2);
                Inc(Adr, instrLen2);
                if Adr > lastAdr then lastAdr := Adr;
                //int hfEndPos := Adr2Pos(Adr);
                hfStartPos := Adr2Pos(DisInfo.Immediate); 
                assert(hfStartPos >= 0);
                Pos0 := hfStartPos - 5;

                if Code[Pos0] = #$68 then  //push offset @3       //Flags[Pos] & cfInstruction must be <> 0
                Begin
                  hfStartPos := Pos0 - 8;
                  SetFlags(cfSkip, hfStartPos, 13);
                End;
                SetFlag(cfFinally, hfStartPos);
              End
              else if recN1.SameName('@HandleAnyException') or recN1.SameName('@HandleAutoException') then
              Begin
                SetFlag(cfExcept, Pos0);
                hoStartPos := Pos0 - 10;
                SetFlags(cfSkip, hoStartPos, instrLen1 + 10);
                frmDisasm.Disassemble(Code + Pos0 - 10, Adr - 10, @DisInfo, Nil);
                if (frmDisasm.GetOp(DisInfo.Mnem) <> OP_XOR) or (DisInfo.OpRegIdx[0] <> DisInfo.OpRegIdx[1]) then
                Begin
                  hoStartPos := Pos0 - 13;
                  SetFlags(cfSkip, hoStartPos, instrLen1 + 13);
                End;
                //Find prev jmp
                Pos1 := hoStartPos;
                Adr1 := Pos2Adr(Pos1);
                for k := 0 to 5 do
                Begin
                  instrLen2 := frmDisasm.Disassemble(Code + Pos1, Adr1, @DisInfo, Nil);
                  Inc(Pos1, instrLen2);
                  Inc(Adr1, instrLen2);
                End;
                if DisInfo.Immediate > lastAdr then lastAdr := DisInfo.Immediate;
                //int hoEndPos := Adr2Pos(DisInfo.Immediate);
                SetFlag(cfExcept, hoStartPos);
              End
              else if recN1.SameName('@HandleOnException') then
              Begin
                SetFlag(cfExcept, Pos0);
                hoStartPos := Pos0 - 10;
                SetFlags(cfSkip, hoStartPos, instrLen1 + 10);
                frmDisasm.Disassemble(Code + Pos0 - 10, Adr - 10, @DisInfo, Nil);
                if (frmDisasm.GetOp(DisInfo.Mnem) <> OP_XOR) or (DisInfo.OpRegIdx[0] <> DisInfo.OpRegIdx[1]) then
                Begin
                  hoStartPos := Pos0 - 13;
                  SetFlags(cfSkip, hoStartPos, instrLen1 + 13);
                End;
                //Find prev jmp
                Pos1 := hoStartPos; 
                Adr1 := Pos2Adr(Pos1);
                for k := 0 to 5 do
                Begin
                  instrLen2 := frmDisasm.Disassemble(Code + Pos1, Adr1, @DisInfo, Nil);
                  Inc(Pos1, instrLen2);
                  Inc(Adr1, instrLen2);
                End;
                if DisInfo.Immediate > lastAdr then lastAdr := DisInfo.Immediate;
                //int hoEndPos := Adr2Pos(DisInfo.Immediate);
                SetFlag(cfExcept, hoStartPos);

                //Next instruction
                Inc(Pos0, instrLen1); 
                Inc(Adr , instrLen1);
                //Set flag cfETable
                SetFlag(cfETable, Pos0);
                //dd num
                num := PInteger(Code + Pos0)^;
                SetFlags(cfSkip, Pos0, 4); 
                Inc(Pos0, 4);
                if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                for k := 0 to num-1 do
                Begin
                  //dd offset ExceptionInfo
                  SetFlags(cfSkip, Pos0, 4); 
                  Inc(Pos0, 4);
                  //dd offset ExceptionProc
                  procAdr := PInteger(Code + Pos0)^;
                  if IsValidCodeAdr(procAdr) then SetFlag(cfLoc, Adr2Pos(procAdr));
                  SetFlags(cfSkip, Pos0, 4); 
                  Inc(Pos0, 4);
                End;
              End;
            End;
          End;
        End;
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
    End;
    if DisInfo.Call then
    Begin
If is_debug then CodeSite.Send('CALL; curAdr = %d',[curAdr]);
      SetFlag(cfCall, curPos);
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) and (Adr2Pos(Adr) >= 0) then
      Begin
If is_debug then CodeSite.Send('valid code; curAdr = %d',[curAdr]);
        SetFlag(cfLoc, Adr2Pos(Adr));
        //If after call exists instruction pop ecx, it may be embedded procedure
        mbemb := Code[curPos + instrLen] = #$59;
If is_debug then CodeSite.Send('AnalyzeProc_X = %d',[Adr]);
        AnalyzeProc1(Adr, 'C', fromAdr, curAdr - fromAdr, mbemb);
        recN1 := GetInfoRec(Adr);
        if Assigned(recN1) and Assigned(recN1.procInfo) then
        Begin
          //After embedded proc instruction pop ecx must be skipped
          if mbemb and ((recN1.procInfo.flags and PF_EMBED)<>0) then
            SetFlag(cfSkip, curPos + instrLen);
          if recN1.HasName then
          Begin
            if recN1.SameName('@Halt0') then
            Begin
              SetFlags(cfSkip, curPos, instrLen);
              if (fromAdr = EP) and (lastAdr=0) then
              Begin
                //SetFlag(cfProcEnd, curPos + instrLen - 1);
                recN.procInfo.procSize := curAdr - fromAdr + instrLen;
                recN.Name:='EntryPoint';
                recN.procInfo.retBytes := 0;
                break;
              End;
            End;
            //If called procedure is @ClassCreate, then current procedure is constructor
            if recN1.SameName('@ClassCreate') then
            Begin
              recN.kind := ikConstructor;
              //Code from instruction test... until this call is not sufficient (mark skipped)
              begPos := GetNearestUpInstruction1(curPos, fromPos, 'test');
              if begPos <> -1 then SetFlags(cfSkip, begPos, curPos + instrLen - begPos);
            End
            else if recN1.SameName('@AfterConstruction') then
            Begin
              begPos := GetNearestUpInstruction2(curPos, fromPos, 'test', 'cmp');
              endPos := GetNearestDownInstruction(curPos, 'add');
              if (begPos <> -1) and (endPos <> -1) then SetFlags(cfSkip, begPos, endPos - begPos);
            End
            else if recN1.SameName('@BeforeDestruction') then
              SetFlag(cfSkip, curPos)
            //If called procedure is @ClassDestroy, then current procedure is destructor
            else if recN1.SameName('@ClassDestroy') then
            Begin
              recN.kind := ikDestructor;
              begPos := GetNearestUpInstruction2(curPos, fromPos, 'test', 'cmp');
              if begPos <> -1 then SetFlags(cfSkip, begPos, curPos + instrLen - begPos);
            End;
          End;
        End;
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if (b1 in [$EB,$70..$7F]) or				 //short relative abs jmp or cond jmp
      ((b1 = 15) and (b2 in [$80..$8F])) then
    Begin
If is_debug then CodeSite.Send('COND JMP; curAdr = %d',[curAdr]);
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
If is_debug then CodeSite.Send('valid Adr = %d',[Adr]);
        Pos0 := Adr2Pos(Adr);
        if not IsFlagSet(cfEmbedded, Pos0) then //Possible branch to start of Embedded proc (for ex. in proc TextToFloat))
        Begin
If is_debug then CodeSite.Send('embedded, curAdr = %d',[curAdr]);
          SetFlag(cfLoc, Pos0);
          //Mark possible start of Loop
          if (Adr < curAdr) and not IsFlagSet(cfExcept or cfFinally, Adr2Pos(curAdr)) {and not IsFlagSet(cfExcept, Adr2Pos(curAdr))} then
            SetFlag(cfLoop, Pos0);
          recN1 := GetInfoRec(Adr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(Pos0, ikUnknown);
          recN1.AddXref('C', fromAdr, curAdr - fromAdr);
          if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
        End;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End
    else if b1 = $E9 then    //relative abs jmp or cond jmp
    Begin
If is_debug then CodeSite.Send('b1 = $E9; curAdr = %d',[curAdr]);
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
If is_debug then CodeSite.Send('valid Adr = %d',[Adr]);
        Pos0 := Adr2Pos(Adr);
        SetFlag(cfLoc, Pos0);
        //Mark possible start of Loop
        if (Adr < curAdr) and not IsFlagSet(cfExcept or cfFinally, Adr2Pos(curAdr)) {and not IsFlagSet(cfExcept, Adr2Pos(curAdr))} then
          SetFlag(cfLoop, Pos0);
        recN1 := GetInfoRec(Adr);
        if Assigned(recN1) and recN1.HasName then
          if recN1.SameName('@HandleFinally')     or
            recN1.SameName('@HandleAnyException') or
            recN1.SameName('@HandleOnException')  or
            recN1.SameName('@HandleAutoException') then
          begin
            recN1.AddXref('J', fromAdr, curAdr - fromAdr);
If is_debug then CodeSite.Send('recN1 = %s, Adr = %d',[recN1.Name,Adr]);
          end;
        if not Assigned(recN1) and (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    //Second operand - immediate and is valid address
    if DisInfo.OpType[1] = otIMM then
    Begin
If is_debug then CodeSite.Send('otIMM, curAdr = %d',[curAdr]);
      Pos0 := Adr2Pos(DisInfo.Immediate);
      //imm32 must be valid code address outside current procedure
      if (Pos0 >= 0) and IsValidCodeAdr(DisInfo.Immediate) and ((DisInfo.Immediate < fromAdr) or (DisInfo.Immediate >= fromAdr + procSize)) then
      Begin
If is_debug then CodeSite.Send('FlagList = %d',[FlagList[Pos0]]);
        //Position must be free
        if FlagList[Pos0]=0 then
        Begin
If is_debug then CodeSite.Send('InfoList = %p',[Pointer(InfoList[Pos0])]);
          //No Name
          if InfoList[Pos0]=Nil then
          Begin
If is_debug then CodeSite.Send('Imm = %d',[DisInfo.Immediate]);
            //Address must be outside current procedure
            if (DisInfo.Immediate < fromAdr) or (DisInfo.Immediate >= fromAdr + procSize) then
            Begin
              //If valid code lets user decide later
              codeValidity := IsValidCode(DisInfo.Immediate);
If is_debug then CodeSite.Send('validity = %d',[codeValidity]);
              if codeValidity = 1 then //Code
              begin
If is_debug then CodeSite.Send('AnalyzeProc_Y = %d',[DisInfo.Immediate]);
                AnalyzeProc1(DisInfo.Immediate, 'D', fromAdr, curAdr - fromAdr, false);
              End;
            End;
          End;
        End
        //If slot is not free (procedure is already loaded)
        else if IsFlagSet(cfProcStart, Pos0) then
          AnalyzeProc1(DisInfo.Immediate, 'D', fromAdr, curAdr - fromAdr, false);
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
if is_debug then CodeSite.Send('EXIT; curAdr = %d',[curAdr]);
end;

Procedure TFMain.AnalyzeProc2 (fromAdr:Integer; addArg, AnalyzeRetType:Boolean);
var
  sctx:TList;
  n:Integer;
Begin
  //saved context
  sctx := TList.Create;
  try
    for n := 0 to 2 do
      if not AnalyzeProc2(fromAdr, addArg, AnalyzeRetType, sctx) then break;
  finally
    for n:=0 to sctx.Count-1 do
      Dispose(PRContext(sctx[n]));
    sctx.Free;
  end;
end;


Function TFMain.AnalyzeProc2(fromAdr:Integer; addArg, AnalyzeRetType:Boolean; sctx:TList):Boolean;
var
	callKind,op, b1, b2:Byte;
  source:Char;
	addXref,NameInside,reset, bpBased, vmt, fContinue:Boolean;
  bpBase:Word;
  n, num, instrLen, instrLen1, instrLen2, _ap, _procSize,aofs:Integer;
  CNum,NPos,delta,dd,retBytes,dynAdr,cnt,arrAdr,reg1Idx, reg2Idx:Integer;
  sp, fromIdx:Integer; //fromIdx - индекс регистра в инструкции mov eax,reg (для обработки вызова @IsClass)
  b,fromPos, curPos, Ps, curAdr, lastMovAdr, procAdr, Val, Adr, Adr1,callOfs:Integer;
  cTblAdr,jTblAdr,k,reg, varAdr, classAdr, vmtAdr, lastAdr,aa,mm:Integer;
  recN, recN1:InfoRec;
  recM:PMethodRec;
  locInfo:PLocalInfo;
  aInfo:PArgInfo;
  fInfo:FieldInfo;
  rcinfo:PRContext;
  rtmp:RINFO;
  comment, typeName, clsName, varName, varType:AnsiString;
  fVal,retType,_eax_Type, _edx_Type, _ecx_Type, sType:AnsiString;
  registers:RegList;
  stack:Array[0..255] of RINFO;
  DisInfo, DisInfo1:TDisInfo;
  singleVal:Single;
  extendedVal:Extended;
  CTab:Array[0..255] of Byte;
Begin
  fContinue:=False;
  lastMovAdr:=0;
  lastAdr:=0;
  fInfo:=Nil;
  clsName:='';
  sp:=-1;
  fromIdx:=-1;
  fVal:='';
  fromPos := Adr2Pos(fromAdr);
  Result:=False;
  if (fromPos < 0) or
    IsFlagSet(cfPass2, fromPos) or
    IsFlagSet(cfEmbedded, fromPos) or
    IsFlagSet(cfExport, fromPos) then Exit;

  b1 := Byte(Code[fromPos]);
  b2 := Byte(Code[fromPos + 1]);
  if (b1=0) and (b2=0) then Exit;

  //Import - return ret type of function
  if IsFlagSet(cfImport, fromPos) then Exit;
  recN := GetInfoRec(fromAdr);

  //if recN := 0 (Interface Methods!!!) then return
  if not Assigned(recN) or not Assigned(recN.procInfo) then Exit;

  //Procedure from Knowledge Base not analyzed
  if Assigned(recN) and (recN.kbIdx <> -1) then Exit;

  //if (!IsFlagSet(cfPass1, fromPos))
  SetFlag(cfProcStart or cfPass2, fromPos);

  //If function name contains class name get it
  clsName := ExtractClassName(recN.Name);
  bpBased := (recN.procInfo.flags and PF_BPBASED)<>0;
  bpBase := recN.procInfo.bpBase;
  rtmp.result := 0;
  rtmp.source := #0;
  rtmp.value := 0; 
  rtmp._type := '';
  for n := Low(Registers) to High(Registers) do registers[n] := rtmp;

  //Get args
  _eax_Type := '';
  _edx_Type := '';
  _ecx_Type := '';
  callKind := recN.procInfo.flags and 7;
  if Assigned(recN.procInfo.args) and (callKind=0) then
  	for n := 0 to recN.procInfo.args.Count-1 do
    Begin
  	  aInfo := recN.procInfo.args[n];
      if aInfo.Ndx = 0 then
      Begin
      	if clsName <> '' then
          registers[16]._type := clsName
        else
      		registers[16]._type := aInfo.TypeDef;
        _eax_Type := registers[16]._type;
        //var
        if aInfo.Tag = $22 then registers[16].source := 'v';
        continue;
      End
      else if aInfo.Ndx = 1 then
      Begin
      	registers[18]._type := aInfo.TypeDef;
        _edx_Type := registers[18]._type;
        //var
        if aInfo.Tag = $22 then registers[18].source := 'v';
        continue;
      End
      else if aInfo.Ndx = 2 then
      Begin
     		registers[17]._type := aInfo.TypeDef;
        _ecx_Type := registers[17]._type;
        //var
        if aInfo.Tag = $22 then registers[17].source := 'v';
        continue;
      End
    	else break;
    End
  else if clsName <> '' then
  	registers[16]._type := clsName;

  _procSize := GetProcSize(fromAdr);
  curPos := fromPos; 
  curAdr := fromAdr;
  while true do
  Begin
    if curAdr >= Integer(CodeBase) + TotalSize then break;
    
    //Skip exception table
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      Inc(curPos, 4 + 8*num);
      Inc(curAdr, 4 + 8*num);
      continue;
    End;
    b1 := Byte(Code[curPos]);
    b2 := Byte(Code[curPos + 1]);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) break;
    if instrLen=0 then
    Begin
      Inc(curPos); 
      Inc(curAdr);
      continue;
    End;
    op := frmDisasm.GetOp(DisInfo.Mnem);
    //Code
    SetFlags(cfCode, curPos, instrLen);
    //Instruction begin
    SetFlag(cfInstruction, curPos);
    if curAdr >= lastAdr then lastAdr := 0;

    if op = OP_JMP then
    Begin
      if curAdr = fromAdr then break;
      if DisInfo.OpType[0] = otMEM then
      Begin
        if (Adr2Pos(DisInfo.Offset) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
      End;
      if DisInfo.OpType[0] = otIMM then
      Begin
        Adr := DisInfo.Immediate;
        if (Adr2Pos(Adr) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        if (GetSegmentNo(Adr) <> 0) and (GetSegmentNo(fromAdr) <> GetSegmentNo(Adr)) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        if (Adr < fromAdr) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
    End;
    if DisInfo.Ret then
    Begin
      //End of proc
      if (lastAdr=0) or (curAdr = lastAdr) then
      Begin
        if AnalyzeRetType then
        Begin
          //Если тип регистра eax не пустой, находим ближайшую сверху инструкцию его инциализации
          if registers[16]._type <> '' then
          Begin
            for Ps := curPos - 1 downto fromPos do
            Begin
              b := FlagList[Ps];
              if ((b and cfInstruction)<>0) and ((b and cfSkip)=0) then
              Begin
                frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps),@DisInfo, Nil);
                //If branch - break
                if DisInfo.Branch then break;
                //If call
                //Other cases (call [reg+Ofs]; call [Adr]) need to add
                if DisInfo.Call then
                Begin
                  Adr := DisInfo.Immediate;
                  if IsValidCodeAdr(Adr) then
                  Begin
                    recN1 := GetInfoRec(Adr);
                    if Assigned(recN1) and Assigned(recN1.procInfo) {recN1.kind = ikFunc} then
                    Begin
                      typeName := recN1._type;
                      recN1 := GetInfoRec(fromAdr);
                      if ((recN1.procInfo.flags and (PF_EVENT or PF_DYNAMIC))=0) and
                        (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
                      Begin
                        recN1.kind := ikFunc;
                        recN1._type := typeName;
                      End;
                    End;
                  End;
                End
                else if (b and cfSetA)<>0 then
                Begin
                  recN1 := GetInfoRec(fromAdr);
                  if ((recN1.procInfo.flags and (PF_EVENT or PF_DYNAMIC))=0) and
                    (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
                  Begin
                    recN1.kind := ikFunc;
                    recN1._type := registers[16]._type;
                  End;
                End;
              End;
            End;
          End;
        End;
        break;
      End;
      if not IsFlagSet(cfSkip, curPos) then sp := -1;
    End;

    //cfBracket
    if IsFlagSet(cfBracket, curPos) then
    Begin
    	if (op = OP_PUSH) and (sp < 255) then
      Begin
        reg1Idx := DisInfo.OpRegIdx[0];
        Inc(sp);
        stack[sp] := registers[reg1Idx];
      End
      else if (op = OP_POP) and (sp >= 0) then
      Begin
        reg1Idx := DisInfo.OpRegIdx[0];
        registers[reg1Idx] := stack[sp];
        Dec(sp);
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    //Проверим, не попал ли внутрь инструкции Fixup или ThreadVar
    NameInside := false;
    for k := 1 to instrLen-1 do
      if Assigned(InfoList[curPos + k]) then
      Begin
        NameInside := true;
        break;
      End;
    reset := (op and OP_RESET) <> 0;
    if op = OP_MOV then lastMovAdr := DisInfo.Offset;

    //If loc then try get context
    if (curAdr <> fromAdr) and IsFlagSet(cfLoc, curPos) then
    Begin
      rcinfo := GetCtx(sctx, curAdr);
      if Assigned(rcinfo) then
      Begin
        sp := rcinfo.sp;
        for n := Low(Registers) to High(Registers) do registers[n] := rcinfo.registers[n];
      End
      //context not found - set flag to continue on the next step
      else fContinue := true;
    End;
    if (b1 = $FF) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      if not IsValidCodeAdr(DisInfo.Offset) then break;
      cTblAdr := 0;
      jTblAdr := 0;
      Ps := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Адрес таблицы - последние 4 байта инструкции
      jTblAdr := PInteger(Code + Ps - 4)^;
      //Анализируем промежуток на предмет таблицы cTbl
      if (Adr <= lastMovAdr) and (lastMovAdr < jTblAdr) then cTblAdr := lastMovAdr;
      //Если есть cTblAdr, пропускаем эту таблицу
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        Inc(Ps, CNum); 
        Inc(Adr, CNum);
      End;
      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, Ps) then break;
        Adr1 := PInteger(Code + Ps)^;
        //Validate Adr1
        if not IsValidCodeAdr(Adr1) or (Adr1 < fromAdr) then break;
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        //Save context
        if GetCtx(sctx, Adr1)=Nil then
        Begin
          New(rcinfo);
          rcinfo.sp := sp;
          rcinfo.adr := Adr1;
          for n := Low(Registers) to High(Registers) do rcinfo.registers[n] := registers[n];
          sctx.Add(rcinfo);
        End;
        Inc(Ps, 4); 
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := Ps; 
      curAdr := Adr;
      continue;
    End;
    if b1 = $68 then		//try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //check that next instruction is push fs:[reg] or retn
      if ((Code[NPos] = #$64) and
        (Code[NPos + 1] = #255) and
        (((Code[NPos + 2] >= #$30) and (Code[NPos + 2] <= #$37)) or (Code[NPos + 2] = #$75))
        ) or (Code[NPos] = #$C3) then
      Begin
        Adr := DisInfo.Immediate;      //Adr:=@1
        if Adr > lastAdr then lastAdr := Adr;
        Ps := Adr2Pos(Adr); 
        assert(Ps >= 0);
        delta := Ps - NPos;
        if (delta >= 0) and (delta < MAX_DISASSEMBLE) then
        Begin
          if Code[Ps] = #$E9 then //jmp Handle...
          Begin
            //Disassemble jmp
            instrLen1 := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
            recN := GetInfoRec(DisInfo.Immediate);
            if Assigned(recN) then
            Begin
              if recN.SameName('@HandleFinally') then
              Begin
                //jmp HandleFinally
                Inc(Ps, instrLen1); 
                Inc(Adr, instrLen1);
                //jmp @2
                instrLen2 := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
                Inc(Adr, instrLen2);
                if Adr > lastAdr then lastAdr := Adr;
              End
              else if recN.SameName('@HandleAnyException') or recN.SameName('@HandleAutoException') then
              Begin
                //jmp HandleAnyException
                Inc(Ps, instrLen1); 
                Inc(Adr, instrLen1);
                //call DoneExcept
                instrLen2 := frmDisasm.Disassemble(Code + Ps, Adr, Nil, Nil);
                Inc(Adr, instrLen2);
                if Adr > lastAdr then lastAdr := Adr;
              End
              else if recN.SameName('@HandleOnException') then
              Begin
                //jmp HandleOnException
                Inc(Ps, instrLen1);
                Inc(Adr, instrLen1);
                //dd num
                num := PInteger(Code + Ps)^; 
                Inc(Ps, 4);
                if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                for k := 0 to num-1 do
                Begin
                  //dd offset ExceptionInfo
                  Adr := PInteger(Code + Ps)^; 
                  Inc(Ps, 4);
                  if IsValidImageAdr(Adr) then
                  Begin
                    recN1 := GetInfoRec(Adr);
                    if Assigned(recN1) and (recN1.kind = ikVMT) then clsName := recN1.Name;
                  End;
                  //dd offset ExceptionProc
                  procAdr := PInteger(Code + Ps)^; 
                  Inc(Ps, 4);
                  if IsValidImageAdr(procAdr) then
                  Begin
                    //Save context
                    if GetCtx(sctx, procAdr)=Nil then
                    Begin
                      New(rcinfo);
                      rcinfo.sp := sp;
                      rcinfo.adr := procAdr;
                      for n := Low(Registers) to High(Registers) do rcinfo.registers[n] := registers[n];
                      //eax
                      rcinfo.registers[16].value := GetClassAdr(clsName);
                      rcinfo.registers[16]._type := clsName;
                      sctx.Add(rcinfo);
                    End;
                  End;
                End;
              End;
            End;
          End;
        End;
      	Inc(curPos, instrLen); 
      	Inc(curAdr, instrLen);
      	continue;
      End;
    End;
    //branch
    if DisInfo.Branch then
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        _ap := Adr2Pos(Adr);
        //SetFlag(cfLoc, _ap);
        //recN1 := GetInfoRec(Adr);
        //if (!recN1) recN1 := new InfoRec(_ap, ikUnknown);
        //recN1.AddXref('C', fromAdr, curAdr - fromAdr);
        //Save context
        if GetCtx(sctx, Adr)=Nil then
        Begin
          New(rcinfo);
          rcinfo.sp := sp;
          rcinfo.adr := Adr;
          for n := Low(Registers) to High(Registers) do rcinfo.registers[n] := registers[n];
          sctx.Add(rcinfo);
        End;
        if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    if (registers[16]._type <> '') and (registers[16]._type[1] = '#') then
    Begin
      //Если был вызов функции @GetTls, смотрим след. инструкцию вида [eax+N]
      if registers[16]._type = '#TLS' then
      Begin
        //Если нет внутреннего имени (Fixup, ThreadVar)
        if not NameInside then
        Begin
          //Destination (GlobalLists ::= TList.Create)
          //Source (GlobalLists.Add)
          if ((DisInfo.OpType[0] = otMEM) or (DisInfo.OpType[1] = otMEM)) and (DisInfo.BaseReg = 16) then
          Begin
            _ap := Adr2Pos(curAdr); 
            assert(_ap >= 0);
            recN1 := GetInfoRec(curAdr + 1);
            if not Assigned(recN1) then recN1 := InfoRec.Create(_ap + 1, ikThreadVar);
            if not recN1.HasName then recN1.Name:='threadvar_' + IntToStr(DisInfo.Offset);
          End;
        End;
        SetRegisterValue(registers, 16, -1);
        registers[16]._type := '';
        Inc(curPos, instrLen); 
        Inc(curAdr, instrLen);
        continue;
      End;
    End;
    //Call
    if DisInfo.Call then
    Begin
      Adr := DisInfo.Immediate;
      if IsValidImageAdr(Adr) then
      Begin
      	recN := GetInfoRec(Adr);
        if Assigned(recN) and Assigned(recN.procInfo) then
        Begin
          retBytes := recN.procInfo.retBytes;
          if (retBytes <> -1) and (sp >= retBytes) then
            Dec(sp,retBytes)
          else
            sp := -1;
			    //for constructor type is in eax
          if recN.kind = ikConstructor then
          Begin
            //Если dl := 1, регистр eax после вызова используется
            if registers[2].value = 1 then
            Begin
              classAdr := GetClassAdr(registers[16]._type);
              if IsValidImageAdr(classAdr) then
              Begin
                //Add xref to vmt info
                recN1 := GetInfoRec(classAdr);
                recN1.AddXref('D', Adr, 0);
                comment := registers[16]._type + '.Create';
                AddPicode(curPos, OP_CALL, comment, 0);
                AnalyzeTypes(fromAdr, curPos, Adr, registers);
              End;
            End;
            SetFlag(cfSetA, curPos);
          End
          else
          Begin
            //Found @Halt0 - exit
            if recN.SameName('@Halt0') and (fromAdr = EP) and (lastAdr=0) then break;
            if recN.SameName('@ClassCreate') then
            Begin
               SetRegisterType(registers, 16, clsName);
               SetFlag(cfSetA, curPos);
            End
            else if recN.SameName('@CallDynaInst') or recN.SameName('@CallDynaClass') then
            Begin
              if DelphiVersion <= 5 then
                comment := GetDynaInfo(GetClassAdr(registers[16]._type), registers[11].value, dynAdr)	//bx
              else
                comment := GetDynaInfo(GetClassAdr(registers[16]._type), registers[14].value, dynAdr);	//si
              AddPicode(curPos, OP_CALL, comment, dynAdr);
            	SetRegisterType(registers, 16, '');
            End
            else if recN.SameName('@FindDynaInst') or recN.SameName('@FindDynaClass') then
            Begin
              comment := GetDynaInfo(GetClassAdr(registers[16]._type), registers[10].value, dynAdr);	//dx
              AddPicode(curPos, OP_CALL, comment, dynAdr);
              SetRegisterType(registers, 16, '');
            End
            //@XStrArrayClr
            else if recN.SameName('@LStrArrayClr') or recN.SameName('@WStrArrayClr') or recN.SameName('@UStrArrayClr') then
            Begin
              arrAdr := registers[16].value;
              cnt := registers[18].value;
              if IsValidImageAdr(arrAdr) then 
              Begin
                //Direct address???

              End
              //Local vars
              else if registers[16].source in ['L','l'] then
              Begin
                recN1 := GetInfoRec(fromAdr);
                aofs := registers[16].value;
                for aa := 0 to cnt-1 do 
                Begin
                  if recN.SameName('@LStrArrayClr') then
                    recN1.procInfo.AddLocal(aofs, 4, '', 'AnsiString')
                  else if recN.SameName('@WStrArrayClr') then
                    recN1.procInfo.AddLocal(aofs, 4, '', 'WideString')
                  else if recN.SameName('@UStrArrayClr') then
                    recN1.procInfo.AddLocal(aofs, 4, '', 'UString');
                  Inc(aofs, 4);
                End;
              End;
              SetRegisterType(registers, 16, '');
            End
            //@TryFinallyExit
            else if recN.SameName('@TryFinallyExit') then
            Begin
              //Find first jxxx
              for Ps := curPos - 1 downto fromPos do
              Begin
                b := FlagList[Ps];
                if (b and cfInstruction)<>0 then
                Begin
                  instrLen1 := frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps), @DisInfo, Nil);
                  if DisInfo.Conditional then break;
                  SetFlags(cfSkip or cfFinallyExit, Ps, instrLen1);
                End;
              End;
              //@TryFinallyExit + jmp XXXXXXXX
              Inc(instrLen, frmDisasm.Disassemble(Code + curPos + instrLen, Pos2Adr(curPos) + instrLen, @DisInfo, Nil));
              SetFlags(cfSkip or cfFinallyExit, curPos, instrLen);
            End
            else
            Begin
              retType := AnalyzeTypes(fromAdr, curPos, Adr, registers);
              recN1 := GetInfoRec(fromAdr);
              for mm := 16 to 18 do
              	if registers[mm].result = 1 then
                Begin
                	if registers[mm].source in ['L','l'] then
                  	recN1.procInfo.AddLocal(registers[mm].value, 4, '', registers[mm]._type)
                  else if registers[mm].source in ['A','a'] then
                  	recN1.procInfo.AddArg($21, registers[mm].value, 4, '', registers[mm]._type);
                End;
              SetRegisterType(registers, 16, retType);
            End;
          End;
        End
        else
        Begin
          sp := -1;
      		SetRegisterType(registers, 16, '');
        End;
      End
      //call Memory
      else if (DisInfo.OpType[0] = otMEM) and (DisInfo.IndxReg = -1) then
      Begin
        sp := -1;
        if DisInfo.BaseReg = -1 then
        Begin
          //call [Offset]

        End
        //call [BaseReg + Offset]
        else
        Begin
          classAdr := registers[DisInfo.BaseReg].value;
          SetRegisterType(registers, 16, '');
          if IsValidCodeAdr(classAdr) and (registers[DisInfo.BaseReg].source = 'V') then
          Begin
            recN := GetInfoRec(classAdr);
            if Assigned(recN) and Assigned(recN.vmtInfo) and Assigned(recN.vmtInfo.methods) then
              for mm := 0 to recN.vmtInfo.methods.Count-1 do
              Begin
                recM := recN.vmtInfo.methods[mm];
                if (recM.kind = 'V') and (recM.id = DisInfo.Offset) then
                Begin
                  recN1 := GetInfoRec(recM.address);
                  if recM.name <> '' then comment := recM.name
                  else
                  Begin
                    if recN1.HasName then
                      comment := recN1.Name
                    else
                      comment := GetClsName(classAdr) + '.sub_' + Val2Str(recM.address,8);
                  End;
                  AddPicode(curPos, OP_CALL, comment, recM.address);
                  recN1.AddXref('V', fromAdr, curAdr - fromAdr);
                  if recN1.kind = ikFunc then SetRegisterType(registers, 16, recN1._type);
                  break;
                End;
              End;
            registers[DisInfo.BaseReg].source := #0;
          End
          else
          Begin
          	callOfs := DisInfo.Offset;
          	typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
            if (typeName <> '') and (callOfs > 0) then
            Begin
            	Ps := GetNearestUpInstruction(curPos, fromPos, 1); 
            	Adr := Pos2Adr(Ps);
              instrLen1 := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
              if DisInfo.Offset = callOfs + 4 then
              Begin
                fInfo := GetField(typeName, callOfs, vmt, vmtAdr);
                if Assigned(fInfo) then
                Begin
                  if fInfo.Name <> '' then AddPicode(curPos, OP_CALL, typeName + '.' + fInfo.Name, 0);
                  if vmt then
                    AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C')
                  else
                    fInfo.Free;
                End
                else if vmt then
                Begin
                  fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, callOfs, -1, '', '');
                  if Assigned(fInfo) then AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
                End;
              End;
            End;
          End;
        End;
      End;
      SetRegisterSource(registers, 16, #0);
      SetRegisterSource(registers, 17, #0);
      SetRegisterSource(registers, 18, #0);
      SetRegisterValue(registers, 16, -1);
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    sType := DisInfo.sSize;
    //floating point operations
    if DisInfo.Float then
    Begin
      case DisInfo.MemSize of
        4: sType := 'Single';
        //Double or Comp???
        8: sType := 'Double';
        10: sType := 'Extended';
      else sType := 'Float';
      End;
  	  Adr := DisInfo.Offset;
      _ap := Adr2Pos(Adr);
    	//fxxx [Adr]
    	if (DisInfo.BaseReg = -1) and (DisInfo.IndxReg = -1) then
      Begin
        if IsValidImageAdr(Adr) then
        Begin
          if _ap >= 0 then
          Begin
            case DisInfo.MemSize of
              4:
                begin
                  singleVal := 0; 
                  MoveMemory(@singleVal, Code + _ap, 4);
                  fVal := FloatToStr(singleVal);
                end;
              //Double or Comp???
              8: ;
              10:
                try
                  extendedVal := 0; 
                  MoveMemory(@extendedVal, Code + _ap, 10);
                  fVal := FloatToStr(extendedVal);
                Except
                  on E:Exception do
                    fVal := 'Impossible!';
                end;
            End;
            SetFlags(cfData, _ap, DisInfo.MemSize);

            recN := GetInfoRec(Adr);
            if not Assigned(recN) then recN := InfoRec.Create(_ap, ikData);
            if not recN.HasName then recN.Name:=fVal;
            if recN._type = '' then recN._type := sType;
            if not IsValidCodeAdr(Adr) then recN.AddXref('D', fromAdr, curAdr - fromAdr);
          End
          else
          Begin
            recN := AddToBSSInfos(Adr, MakeGvarName(Adr), sType);
            if Assigned(recN) then recN.AddXref('C', fromAdr, curAdr - fromAdr);
          End;
        End;
      End
      else if DisInfo.BaseReg <> -1 then
      Begin
      	//fxxxx [BaseReg + Offset]
      	if DisInfo.IndxReg = -1 then
        Begin
          //fxxxx [ebp - Offset]
          if bpBased and (DisInfo.BaseReg = 21) and (DisInfo.Offset < 0) then
          Begin
            recN1 := GetInfoRec(fromAdr);
            recN1.procInfo.AddLocal(DisInfo.Offset, DisInfo.MemSize, '', sType);
          End
          //fxxx [esp + Offset]
          else if DisInfo.BaseReg = 20 then dummy := 1
          else
          Begin
            //fxxxx [BaseReg]
            if DisInfo.Offset=0 then
            Begin
              varAdr := registers[DisInfo.BaseReg].value;
              if IsValidImageAdr(varAdr) then
              Begin
                _ap := Adr2Pos(varAdr);
                if _ap >= 0 then
                Begin
                  recN1 := GetInfoRec(varAdr);
                  if not Assigned(recN1) then recN1 := InfoRec.Create(_ap, ikData);
                  MakeGvar(recN1, varAdr, curAdr);
                  recN1._type := sType;
                  if not IsValidCodeAdr(varAdr) then recN1.AddXref('D', fromAdr, curAdr - fromAdr);
                End
                else
                Begin
                  recN1 := AddToBSSInfos(varAdr, MakeGvarName(varAdr), sType);
                  if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                End;
              End;
            End
            //fxxxx [BaseReg + Offset]
            else if DisInfo.Offset > 0 then
            Begin
              typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
              if typeName <> '' then
              Begin
                fInfo := GetField(typeName, DisInfo.Offset, vmt, vmtAdr);
                if Assigned(fInfo) then
                Begin
                  if vmt then
                  Begin
                    if CanReplace(fInfo._Type, sType) then fInfo._Type := sType;
                    AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
                  End
                  else fInfo.Free;
                  //if (vmtAdr) typeName := GetClsName(vmtAdr);
                  AddPicode(curPos, 0, typeName, DisInfo.Offset);
                End
                else if vmt then
                Begin
                  fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, DisInfo.Offset, -1, '', sType);
                  if Assigned(fInfo) then
                  Begin
                    AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
                  	AddPicode(curPos, 0, typeName, DisInfo.Offset);
                  End;
                End;
              End;
            End
            else
            Begin
              //fxxxx [BaseReg - Offset]

            End;
          End;
        End
        else
        Begin
          //fxxxx [BaseReg + IndxReg*Scale + Offset]

        End;
      End;
      Inc(curPos, instrLen); 
      Inc(curAdr, instrLen);
      continue;
    End;
    //No operands
    if DisInfo.OpNum = 0 then
    Begin
    	//cdq
      if op = OP_CDQ then
      Begin
        SetRegisterSource(registers, 16, 'I');
      	SetRegisterValue(registers, 16, -1);
        SetRegisterType(registers, 16, 'Integer');
        SetRegisterSource(registers, 18, 'I');
        SetRegisterValue(registers, 18, -1);
        SetRegisterType(registers, 18, 'Integer');
      End;
    End
    //1 operand
    else if DisInfo.OpNum = 1 then
    Begin
    	//op Imm
      if DisInfo.OpType[0] = otIMM then
      Begin
      	if IsValidImageAdr(DisInfo.Immediate) then
        Begin
          _ap := Adr2Pos(DisInfo.Immediate);
          if _ap >= 0 then
          Begin
            recN1 := GetInfoRec(DisInfo.Immediate);
            if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
          End
          else
          Begin
            recN1 := AddToBSSInfos(DisInfo.Immediate, MakeGvarName(DisInfo.Immediate), '');
            if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
          End;
        End;
      End
      //op reg
      else if (DisInfo.OpType[0] = otREG) and (op <> OP_UNK) and (op <> OP_PUSH) then
      Begin
        reg1Idx := DisInfo.OpRegIdx[0];
        SetRegisterSource(registers, reg1Idx, #0);
        SetRegisterValue(registers, reg1Idx, -1);
        SetRegisterType(registers, reg1Idx, '');
      End
      //op [BaseReg + Offset]
      else if DisInfo.OpType[0] = otMEM then
      Begin
        if (DisInfo.BaseReg <> -1) and (DisInfo.IndxReg = -1) and (DisInfo.Offset > 0) then
        Begin
          typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
          if typeName <> '' then
          Begin
            fInfo := GetField(typeName, DisInfo.Offset, vmt, vmtAdr);
            if Assigned(fInfo) then
            Begin
              if vmt then
                AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C')
              else
                fInfo.Free;
              AddPicode(curPos, 0, typeName, DisInfo.Offset);
            End
            else if vmt then
            Begin
              fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, DisInfo.Offset, -1, '', sType);
              if Assigned(fInfo) then
              Begin
                AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
              	AddPicode(curPos, 0, typeName, DisInfo.Offset);
              End;
            End;
          End;
        End;
    	  if (op = OP_IMUL) or (op = OP_IDIV) then
        Begin
          SetRegisterSource(registers, 16, #0);
          SetRegisterValue(registers, 16, -1);
          SetRegisterType(registers, 16, 'Integer');
          SetRegisterSource(registers, 18, #0);
          SetRegisterValue(registers, 18, -1);
          SetRegisterType(registers, 18, 'Integer');
        End;
      End;
    End
    //2 or 3 operands
    else if DisInfo.OpNum >= 2 then
    Begin
      if (op and OP_A2)<>0 then
      //if (op = OP_MOV or op = OP_CMP or op = OP_LEA or op = OP_XOR or op = OP_ADD or op = OP_SUB or
      //    op = OP_AND or op = OP_TEST or op = OP_XCHG or op = OP_IMUL or op = OP_IDIV or op = OP_OR or
      //    op = OP_BT or op = OP_BTC or op = OP_BTR or op = OP_BTS)
      Begin
        if DisInfo.OpType[0] = otREG then	//cop reg,...
        Begin
          reg1Idx := DisInfo.OpRegIdx[0];
          source := registers[reg1Idx].source;
          SetRegisterSource(registers, reg1Idx, #0);
          if DisInfo.OpType[1] = otIMM then //cop reg, Imm
          Begin
          	if reset then
            Begin
              typeName := TrimTypeName(registers[reg1Idx]._type);
              SetRegisterValue(registers, reg1Idx, -1);
              SetRegisterType(registers, reg1Idx, '');

              if op = OP_ADD then
              Begin
              	if (typeName <> '') and (source <> 'v') then
                Begin
                  fInfo := GetField(typeName, DisInfo.Immediate, vmt, vmtAdr);
                  if Assigned(fInfo) then
                  Begin
                    registers[reg1Idx]._type := fInfo._Type;
                    if vmt then
                      AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C')
                    else
                      fInfo.Free;
                    //if (vmtAdr) typeName := GetClsName(vmtAdr);
                    AddPicode(curPos, 0, typeName, DisInfo.Immediate);
                  End
                  else if vmt then
                  Begin
                    fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, DisInfo.Immediate, -1, '', '');
                    if Assigned(fInfo) then
                    Begin
                      AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
                    	AddPicode(curPos, 0, typeName, DisInfo.Immediate);
                    End;
                  End;
                End;
              End
              else
              Begin
              	if op = OP_MOV then SetRegisterValue(registers, reg1Idx, DisInfo.Immediate);
                SetRegisterSource(registers, reg1Idx, 'I');
                if IsValidImageAdr(DisInfo.Immediate) then
                Begin
                  _ap := Adr2Pos(DisInfo.Immediate);
                  if _ap >= 0 then
                  Begin
                    recN1 := GetInfoRec(DisInfo.Immediate);
                    if Assigned(recN1) then
                    Begin
                      SetRegisterType(registers, reg1Idx, recN1._type);
                      addXref := false;
                      case recN1.kind of
                        ikString:
                          begin
                            SetRegisterType(registers, reg1Idx, 'ShortString');
                            addXref := true;
                          end;
                        ikLString:
                          begin
                            SetRegisterType(registers, reg1Idx, 'AnsiString');
                            addXref := true;
                          end;
                        ikWString:
                          begin
                            SetRegisterType(registers, reg1Idx, 'WideString');
                            addXref := true;
                          end;
                        ikCString:
                          begin
                            SetRegisterType(registers, reg1Idx, 'PAnsiChar');
                            addXref := true;
                          end;
                        ikWCString:
                          begin
                            SetRegisterType(registers, reg1Idx, 'PWideChar');
                            addXref := true;
                          end;
                        ikUString:
                          begin
                            SetRegisterType(registers, reg1Idx, 'UString');
                            addXref := true;
                          end;
                      End;
                      if addXref then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                    End;
                  End
                  else
                  Begin
                    recN1 := AddToBSSInfos(DisInfo.Immediate, MakeGvarName(DisInfo.Immediate), '');
                    if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                  End;
                End;
              End;
            End;
          End
          else if DisInfo.OpType[1] = otREG then	//cop reg, reg
          Begin
            reg2Idx := DisInfo.OpRegIdx[1];
          	if reset then
            Begin
              if op = OP_MOV then
              Begin
              	SetRegisterSource(registers, reg1Idx, registers[reg2Idx].source);
                SetRegisterValue(registers, reg1Idx, registers[reg2Idx].value);
                SetRegisterType(registers, reg1Idx, registers[reg2Idx]._type);
                if reg1Idx = 16 then fromIdx := reg2Idx;
              End
              else if op = OP_XOR then
              Begin
                SetRegisterValue(registers, reg1Idx, registers[reg1Idx].value xor registers[reg2Idx].value);
                SetRegisterType(registers, reg1Idx, '');
              End
              else if op = OP_XCHG then
              Begin
                rtmp := registers[reg1Idx];
                registers[reg1Idx] := registers[reg2Idx]; 
                registers[reg2Idx] := rtmp;
              End
              else if (op = OP_IMUL) or (op = OP_IDIV) then
              Begin
              	SetRegisterSource(registers, reg1Idx, #0);
                SetRegisterValue(registers, reg1Idx, -1);
                SetRegisterType(registers, reg1Idx, 'Integer');
                if reg1Idx <> reg2Idx then
                Begin
                	SetRegisterSource(registers, reg2Idx, #0);
                	SetRegisterValue(registers, reg2Idx, -1);
                	SetRegisterType(registers, reg2Idx, 'Integer');
              	End;
              End
              else
              Begin
                SetRegisterValue(registers, reg1Idx, -1);
                SetRegisterType(registers, reg1Idx, '');
              End;
            End;
          End
          else if DisInfo.OpType[1] = otMEM then	//cop reg, Memory
          Begin
          	if DisInfo.BaseReg = -1 then
            Begin
            	if DisInfo.IndxReg = -1 then //cop reg, [Offset]
              Begin
              	if reset then
                Begin
                  if op = OP_IMUL then
                  Begin
                    SetRegisterSource(registers, reg1Idx, #0);
                    SetRegisterValue(registers, reg1Idx, -1);
                    SetRegisterType(registers, reg1Idx, 'Integer');
                  End
                  else
                  Begin
                    SetRegisterValue(registers, reg1Idx, -1);
                    SetRegisterType(registers, reg1Idx, '');
                  End;
                End;
                Adr := DisInfo.Offset;
                if IsValidImageAdr(Adr) then
                Begin
                  _ap := Adr2Pos(Adr);
                  if _ap >= 0 then
                  Begin
                    recN := GetInfoRec(Adr);
                    if Assigned(recN) then
                    Begin
                      MakeGvar(recN, Adr, curAdr);
                      if recN.kind = ikVMT then
                      Begin
                        if reset then
                        Begin
                          SetRegisterType(registers, reg1Idx, recN.Name);
                          SetRegisterValue(registers, reg1Idx, Adr - VmtSelfPtr);
                        End;
                      End
                      else
                      Begin
                        if reset then registers[reg1Idx]._type := recN._type;
                        if reg1Idx < 24 then
                        Begin
                          if reg1Idx >= 16 then
                          Begin
                            if IsFlagSet(cfImport, _ap) then
                            Begin
                              recN1 := GetInfoRec(Adr);
                              AddPicode(curPos, OP_COMMENT, recN1.Name, 0);
                            End
                            else if not IsFlagSet(cfRTTI, _ap) then
                            Begin
                              Val := PInteger(Code + _ap)^;
                              if reset then SetRegisterValue(registers, reg1Idx, Val);
                              if IsValidImageAdr(Val) then
                              Begin
                                _ap := Adr2Pos(Val);
                                if _ap >= 0 then
                                Begin
                                  recN1 := GetInfoRec(Val);
                                  if Assigned(recN1) then
                                  Begin
                                    MakeGvar(recN1, Val, curAdr);
                                    varName := recN1.Name;
                                    if varName <> '' then recN.Name:='^' + varName;
                                    if recN._type <> '' then registers[reg1Idx]._type := recN._type;
                                    varType := recN1._type;
                                    if varType <> '' then
                                    Begin
                                      recN._type := varType;
                                      registers[reg1Idx]._type := varType;
                                    End;
                                  End
                                  else
                                  Begin
                                    recN1 := InfoRec.Create(_ap, ikData);
                                    MakeGvar(recN1, Val, curAdr);
                                    varName := recN1.Name;
                                    if varName <> '' then recN.Name:='^' + varName;
                                    if recN._type <> '' then registers[reg1Idx]._type := recN._type;
                                  End;
                                  if Assigned(recN) then recN.AddXref('C', fromAdr, curAdr - fromAdr);
                                End
                                else
                                Begin
                                  if recN.HasName then
                                    recN1 := AddToBSSInfos(Val, recN.Name, recN._type)
                                  else
                                    recN1 := AddToBSSInfos(Val, MakeGvarName(Val), recN._type);
                                  if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                                End;
                              End
                              else
                              Begin
                                AddPicode(curPos, OP_COMMENT, HEX_COMENT + Val2Str(Val), 0);
                                SetFlags(cfData, _ap, 4);
                              End;
                            End;
                          End
                          else
                          Begin
                            if reg1Idx <= 7 then
                              Val := Byte(Code[_ap])
                            else if reg1Idx <= 15 then
                              Val := PWord(Code + _ap)^;
                            AddPicode(curPos, OP_COMMENT, HEX_COMENT + Val2Str(Val), 0);
                            SetFlags(cfData, _ap, 4);
                          End;
                        End;
                      End;
                    End
                    else
                    Begin
                      recN := InfoRec.Create(_ap, ikData);
                      MakeGvar(recN, Adr, curAdr);
                      if reg1Idx < 24 then
                      Begin
                        if reg1Idx >= 16 then
                        Begin
                          Val := PInteger(Code + _ap)^;
                          if reset then SetRegisterValue(registers, reg1Idx, Val);
                          if IsValidImageAdr(Val) then
                          Begin
                            _ap := Adr2Pos(Val);
                            if _ap >= 0 then
                            Begin
                              recN.kind := ikPointer;
                              recN1 := GetInfoRec(Val);
                              if Assigned(recN1) then
                              Begin
                                MakeGvar(recN1, Val, curAdr);
                                varName := recN1.Name;
                                if (varName <> '') and ((recN1.kind = ikLString) or (recN1.kind = ikWString) or (recN1.kind = ikUString)) then
                                  varName := '"' + varName + '"';
                                if varName <> '' then recN.Name:='^' + varName;
                                if recN._type <> '' then registers[reg1Idx]._type := recN._type;
                                varType := recN1._type;
                                if varType <> '' then
                                Begin
                                  recN._type := varType;
                                  registers[reg1Idx]._type := varType;
                                End;
                              End
                              else
                              Begin
                                recN1 := InfoRec.Create(_ap, ikData);
                                MakeGvar(recN1, Val, curAdr);
                                varName := recN1.Name;
                                if (varName <> '') and ((recN1.kind = ikLString) or (recN1.kind = ikWString) or (recN1.kind = ikUString)) then
                                  varName := '"' + varName + '"';
                                if varName <> '' then recN.Name:='^' + varName;
                                if recN._type <> '' then registers[reg1Idx]._type := recN._type;
                              End;
                              if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                            End
                            else
                            Begin
                              recN1 := AddToBSSInfos(Val, MakeGvarName(Val), '');
                              if Assigned(recN1) then
                              Begin
                                recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                                if recN._type <> '' then recN._type := recN1._type;
                              End;
                            End;
                          End
                          else
                          Begin
                            AddPicode(curPos, OP_COMMENT, HEX_COMENT + Val2Str(Val), 0);
                            SetFlags(cfData, _ap, 4);
                          End;
                        End
                        else
                        Begin
                          if reg1Idx <= 7 then
                            Val := Byte(Code[_ap])
                          else if reg1Idx <= 15 then
                            Val := PWord(Code + _ap)^;
                          AddPicode(curPos, OP_COMMENT, HEX_COMENT + Val2Str(Val), 0);
                          SetFlags(cfData, _ap, 4);
                        End;
                      End;
                    End;
                  End
                  else
                  Begin
                    recN1 := AddToBSSInfos(Adr, MakeGvarName(Adr), '');
                    if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                  End;
                End;
              End
              else	//cop reg, [Offset + IndxReg*Scale]
              Begin
              	if reset then
                Begin
                  if op = OP_IMUL then
                  Begin
                    SetRegisterSource(registers, reg1Idx, #0);
                    SetRegisterValue(registers, reg1Idx, -1);
                    SetRegisterType(registers, reg1Idx, 'Integer');
                  End
                  else
                  Begin
                    SetRegisterValue(registers, reg1Idx, -1);
                    SetRegisterType(registers, reg1Idx, '');
                  End;
                End;
                Adr := DisInfo.Offset;
                if IsValidImageAdr(Adr) then
                Begin
                  _ap := Adr2Pos(Adr);
                  if _ap >= 0 then
                  Begin
                    recN := GetInfoRec(Adr);
                    if Assigned(recN) then
                    Begin
                      if recN.kind = ikVMT then
                        typeName := recN.Name
                      else
                        typeName := recN._type;
                      if reset then SetRegisterType(registers, reg1Idx, typeName);
                      if not IsValidCodeAdr(Adr) then recN.AddXref('C', fromAdr, curAdr - fromAdr);
                    End;
                  End
                  else
                  Begin
                    recN1 := AddToBSSInfos(Adr, MakeGvarName(Adr), '');
                    if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                  End;
                End;
              End;
            End
            else
            Begin
            	if DisInfo.IndxReg = -1 then
              Begin
              	if bpBased and (DisInfo.BaseReg = 21) then	//cop reg, [ebp + Offset]
                Begin
                  if DisInfo.Offset < 0 then //cop reg, [ebp - Offset]
                  Begin
                    if reset then
                    Begin
                      if op = OP_IMUL then
                      Begin
                        SetRegisterSource(registers, reg1Idx, #0);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, 'Integer');
                      End
                      else
                      Begin
                        if op = OP_LEA then SetRegisterSource(registers, reg1Idx, 'L')
                          else SetRegisterSource(registers, reg1Idx, 'l');
                        SetRegisterValue(registers, reg1Idx, DisInfo.Offset);
                        SetRegisterType(registers, reg1Idx, '');
                      End;
                    End;
                    //xchg ecx, [ebp-4] (ecx := 0, [ebp-4] := _ecx_)
                    if (DisInfo.Offset = -4) and (reg1Idx = 17) then
                    Begin
                      recN1 := GetInfoRec(fromAdr);
                      locInfo := recN1.procInfo.AddLocal(DisInfo.Offset, 4, '', '');
                      SetRegisterType(registers, reg1Idx, _ecx_Type);
                    End
                    else
                    Begin
                      recN1 := GetInfoRec(fromAdr);
                      locInfo := recN1.procInfo.AddLocal(DisInfo.Offset, DisInfo.MemSize, '', '');
                      //mov, xchg
                      if (op = OP_MOV) or (op = OP_XCHG) then
                        SetRegisterType(registers, reg1Idx, locInfo.TypeDef)
                      else if (op = OP_LEA) and (locInfo.TypeDef <> '') then
                      	SetRegisterType(registers, reg1Idx, locInfo.TypeDef);
                    End;
                  End
                  else	//cop reg, [ebp + Offset]
                  Begin
                    if reset then
                    Begin
                      if op = OP_IMUL then
                      Begin
                        SetRegisterSource(registers, reg1Idx, #0);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, 'Integer');
                      End
                      else
                      Begin
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, '');
                      End;
                    End;
                    if bpBased and addArg then
                    Begin
                      recN1 := GetInfoRec(fromAdr);
                      aInfo := recN1.procInfo.AddArg($21, DisInfo.Offset, 4, '', '');
                      if (op = OP_MOV) or (op = OP_LEA) or (op = OP_XCHG) then
                      Begin
                        if op = OP_LEA then SetRegisterSource(registers, reg1Idx, 'A')
                          else SetRegisterSource(registers, reg1Idx, 'a');
                        SetRegisterValue(registers, reg1Idx, DisInfo.Offset);
                        SetRegisterType(registers, reg1Idx, aInfo.TypeDef);
                      End;
                    End;
                  End;
                End
                else if DisInfo.BaseReg = 20 then	//cop reg, [esp + Offset]
                Begin
                  if reset then
                  Begin
                  	if op = OP_IMUL then
                    Begin
                    	SetRegisterSource(registers, reg1Idx, #0);
                      SetRegisterValue(registers, reg1Idx, -1);
                      SetRegisterType(registers, reg1Idx, 'Integer');
                    End
                    else
                    Begin
                    	SetRegisterValue(registers, reg1Idx, -1);
                    	SetRegisterType(registers, reg1Idx, '');
                    End;
                  End;
                End
                else	//cop reg, [BaseReg + Offset]
                Begin
                  if DisInfo.Offset=0 then	//cop reg, [BaseReg]
                  Begin
                    Adr := registers[DisInfo.BaseReg].value;
                    typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
                    if reset then
                    Begin
                      if op = OP_IMUL then
                      Begin
                        SetRegisterSource(registers, reg1Idx, #0);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, 'Integer');
                      End
                      else
                      Begin
                      	SetRegisterValue(registers, reg1Idx, -1);
                      	SetRegisterType(registers, reg1Idx, '');
                      End;
                      if typeName <> '' then
                      Begin
                      	if typeName[1] = '^' then typeName := Copy(typeName,2, Length(typeName) - 1);
                       	SetRegisterValue(registers, reg1Idx, GetClassAdr(typeName));
                        SetRegisterType(registers, reg1Idx, typeName); //???
                       	SetRegisterSource(registers, reg1Idx, 'V');	//Virtual table base (for calls processing)
                      End;
                      if IsValidImageAdr(Adr) then
                      Begin
                        _ap := Adr2Pos(Adr);
                        if _ap >= 0 then
                        Begin
                          recN := GetInfoRec(Adr);
                          if Assigned(recN) then
                          Begin
                            if recN.kind = ikVMT then
                            Begin
                              SetRegisterType(registers, reg1Idx, recN.Name);
                              SetRegisterValue(registers, reg1Idx, Adr - VmtSelfPtr);
                            End
                            else
                            Begin
                              SetRegisterType(registers, reg1Idx, recN._type);
                              if recN._type <> '' then SetRegisterValue(registers, reg1Idx, GetClassAdr(recN._type));
                            End;
                          End;
                        End
                        else AddToBSSInfos(Adr, MakeGvarName(Adr), '');
                      End;
                    End;
                  End
                  else if DisInfo.Offset > 0 then	//cop reg, [BaseReg + Offset]
                  Begin
                    typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
                    if reset then
                    Begin
                      if op = OP_IMUL then
                      Begin
                        SetRegisterSource(registers, reg1Idx, #0);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, 'Integer'); 
                        sType := 'Integer';
                      End
                      else
                      Begin
                    		SetRegisterValue(registers, reg1Idx, -1);
                      	SetRegisterType(registers, reg1Idx, '');
                      End;
                    End;
                    if typeName <> '' then
                    Begin
                      fInfo := GetField(typeName, DisInfo.Offset, vmt, vmtAdr);
                      if Assigned(fInfo) then
                      Begin
                        if (op = OP_MOV) or (op = OP_XCHG) then
                          registers[reg1Idx]._type := fInfo._Type;
                        if CanReplace(fInfo._Type, sType) then fInfo._Type := sType;
                        if vmt then
                          AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C')
                        else
                          fInfo.Free;
                        //if (vmtAdr) typeName := GetClsName(vmtAdr);
                        AddPicode(curPos, 0, typeName, DisInfo.Offset);
                      End
                      else if vmt then
                      Begin
                        fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, DisInfo.Offset, -1, '', sType);
                        if Assigned(fInfo) then
                        Begin
                          AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
                        	AddPicode(curPos, 0, typeName, DisInfo.Offset);
                        End;
                      End;
                    End;
                  End
                  else	//cop reg, [BaseReg - Offset]
                  Begin
                  	if reset then
                    Begin
                      if op = OP_IMUL then
                      Begin
                        SetRegisterSource(registers, reg1Idx, #0);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, 'Integer');
                      End
                      else
                      Begin
                    		SetRegisterValue(registers, reg1Idx, -1);
                    		SetRegisterType(registers, reg1Idx, '');
                      End;
                    End;
                  End;
                End;
              End
              else	//cop reg, [BaseReg + IndxReg*Scale + Offset]
              Begin
              	if DisInfo.BaseReg = 21 then	//cop reg, [ebp + IndxReg*Scale + Offset]
                Begin
                  if reset then
                  Begin
                    if op = OP_IMUL then
                    Begin
                      SetRegisterSource(registers, reg1Idx, #0);
                      SetRegisterValue(registers, reg1Idx, -1);
                      SetRegisterType(registers, reg1Idx, 'Integer');
                    End
                    else
                    Begin
                    	SetRegisterValue(registers, reg1Idx, -1);
                    	SetRegisterType(registers, reg1Idx, '');
                    End;
                  End;
                End
                else if DisInfo.BaseReg = 20 then	//cop reg, [esp + IndxReg*Scale + Offset]
                Begin
                  if reset then
                  Begin
                    if op = OP_IMUL then
                    Begin
                      SetRegisterSource(registers, reg1Idx, #0);
                      SetRegisterValue(registers, reg1Idx, -1);
                      SetRegisterType(registers, reg1Idx, 'Integer');
                    End
                    else
                    Begin
                    	SetRegisterValue(registers, reg1Idx, -1);
                    	SetRegisterType(registers, reg1Idx, '');
                    End;
                  End;
                End
                else	//cop reg, [BaseReg + IndxReg*Scale + Offset]
                Begin
                	typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
                	if reset then
                  Begin
                  	if op = OP_LEA then
                    Begin
                    	//BaseReg - points to class
                      if typeName <> '' then
                      Begin
                        SetRegisterSource(registers, reg1Idx, #0);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, '');
                      End
                      //Else - general arifmetics
                      else
                      Begin
                        SetRegisterSource(registers, reg1Idx, #0);
                        SetRegisterValue(registers, reg1Idx, -1);
                        SetRegisterType(registers, reg1Idx, 'Integer');
                      End;
                    End
                    else if op = OP_IMUL then
                    Begin
                      SetRegisterSource(registers, reg1Idx, #0);
                      SetRegisterValue(registers, reg1Idx, -1);
                      SetRegisterType(registers, reg1Idx, 'Integer');
                    End
                    else
                    Begin
                    	SetRegisterValue(registers, reg1Idx, -1);
                    	SetRegisterType(registers, reg1Idx, '');
                    End;
                  End;
                End;
              End;
            End;
          End;
        End
        //cop Mem,...
        else
        Begin
          //cop Mem, Imm
          if DisInfo.OpType[1] = otIMM then
          Begin
            //cop [Offset], Imm
            if (DisInfo.BaseReg = -1) and (DisInfo.IndxReg = -1) then
            Begin
              Adr := DisInfo.Offset;
              if IsValidImageAdr(Adr) then
              Begin
                _ap := Adr2Pos(Adr);
                if _ap >= 0 then
                Begin
                  recN1 := GetInfoRec(Adr);
                  if not Assigned(recN1) then recN1 := InfoRec.Create(_ap, ikData);
                  MakeGvar(recN1, Adr, curAdr);
                  if not IsValidCodeAdr(Adr) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                End
                else
                Begin
                  recN1 := AddToBSSInfos(Adr, MakeGvarName(Adr), '');
                  if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                End;
              End;
            End
            //cop [BaseReg + IndxReg*Scale + Offset], Imm
            else if DisInfo.BaseReg <> -1 then
            Begin
              //cop [BaseReg + Offset], Imm
              if DisInfo.IndxReg = -1 then
              Begin
                //cop [ebp - Offset], Imm
                if bpBased and (DisInfo.BaseReg = 21) and (DisInfo.Offset < 0) then
                Begin
                  recN1 := GetInfoRec(fromAdr);
                  recN1.procInfo.AddLocal(DisInfo.Offset, DisInfo.MemSize, '', '');
                End
                //cop [esp], Imm
                else if DisInfo.BaseReg = 20 then dummy := 1
                //other registers
                else
                Begin
                  //cop [BaseReg], Imm
                  if DisInfo.Offset=0 then
                  Begin
                    Adr := registers[DisInfo.BaseReg].value;
                    if IsValidImageAdr(Adr) then
                    Begin
                      _ap := Adr2Pos(Adr);
                      if _ap >= 0 then
                      Begin
                        recN := GetInfoRec(Adr);
                        if not Assigned(recN) then recN := InfoRec.Create(_ap, ikData);
                        MakeGvar(recN, Adr, curAdr);
                        if not IsValidCodeAdr(Adr) then recN.AddXref('C', fromAdr, curAdr - fromAdr);
                      End
                      else
                      Begin
                        recN1 := AddToBSSInfos(Adr, MakeGvarName(Adr), '');
                        if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                      End;
                    End;
                  End
                  //cop [BaseReg + Offset], Imm
                  else if DisInfo.Offset > 0 then
                  Begin
                    typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
                    if typeName <> '' then
                    Begin
                      fInfo := GetField(typeName, DisInfo.Offset, vmt, vmtAdr);
                      if Assigned(fInfo) then
                      Begin
                        if vmt then
                        Begin
                          if (op <> OP_CMP) and (op <> OP_TEST) then
                            AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'c')
                          else
                            AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
                        End
                        else fInfo.Free;
                        //if (vmtAdr) typeName := GetClsName(vmtAdr);
                        AddPicode(curPos, 0, typeName, DisInfo.Offset);
                      End
                      else if vmt then
                      Begin
                        fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, DisInfo.Offset, -1, '', sType);
                        if Assigned(fInfo) then
                        Begin
                          if (op <> OP_CMP) and (op <> OP_TEST) then
                            AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'c')
                          else
                            AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'C');
                        	AddPicode(curPos, 0, typeName, DisInfo.Offset);
                        End;
                      End;
                    End;
                  End
                  else
                  Begin
                    //cop [BaseReg - Offset], Imm

                  End;
                End;
              End
              else
              Begin
                //cop [BaseReg + IndxReg*Scale + Offset], Imm

              End;
            End
            else
            Begin
              //Other instructions

            End;
          End
          //cop Mem, reg
          else if DisInfo.OpType[1] = otREG then
          Begin
            reg2Idx := DisInfo.OpRegIdx[1];
            //op [Offset], reg
            if (DisInfo.BaseReg = -1) and (DisInfo.IndxReg = -1) then
            Begin
              varAdr := DisInfo.Offset;
              if IsValidImageAdr(varAdr) then
              Begin
                _ap := Adr2Pos(varAdr);
                if _ap >= 0 then
                Begin
                  recN1 := GetInfoRec(varAdr);
                  if not Assigned(recN1) then recN1 := InfoRec.Create(_ap, ikData);
                  MakeGvar(recN1, varAdr, curAdr);
                  if op = OP_MOV then
                  Begin
                    if registers[reg2Idx]._type <> '' then recN1._type := registers[reg2Idx]._type;
                  End;
                  if not IsValidCodeAdr(varAdr) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                End
                else
                Begin
                  recN1 := AddToBSSInfos(varAdr, MakeGvarName(varAdr), registers[reg2Idx]._type);
                  if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                End;
              End;
            End
            //cop [BaseReg + IndxReg*Scale + Offset], reg
            else if DisInfo.BaseReg <> -1 then
            Begin
              if DisInfo.IndxReg = -1 then
              Begin
                //cop [ebp - Offset], reg
                if bpBased and (DisInfo.BaseReg = 21) and (DisInfo.Offset < 0) then
                Begin
                  recN1 := GetInfoRec(fromAdr);
                  recN1.procInfo.AddLocal(DisInfo.Offset, 4, '', registers[reg2Idx]._type);
                End
                else if DisInfo.BaseReg = 20 then
                Begin
                  //esp

                End
                //other registers
                else
                Begin
                  //cop [BaseReg], reg
                  if DisInfo.Offset=0 then
                  Begin
                    varAdr := registers[DisInfo.BaseReg].value;
                    if IsValidImageAdr(varAdr) then
                    Begin
                      _ap := Adr2Pos(varAdr);
                      if _ap >= 0 then
                      Begin
                        recN1 := GetInfoRec(varAdr);
                        if not Assigned(recN1) then recN1 := InfoRec.Create(_ap, ikData);
                        MakeGvar(recN1, varAdr, curAdr);
                        if recN1._type = '' then recN1._type := registers[reg2Idx]._type;
                        if not IsValidCodeAdr(varAdr) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                      End
                      else
                      Begin
                        recN1 := AddToBSSInfos(varAdr, MakeGvarName(varAdr), registers[reg2Idx]._type);
                        if Assigned(recN1) then recN1.AddXref('C', fromAdr, curAdr - fromAdr);
                      End;
                    End
                    else
                    Begin
                      typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
                      if typeName <> '' then
                      Begin
                        if registers[reg2Idx]._type <> '' then sType := registers[reg2Idx]._type;
                        fInfo := GetField(typeName, DisInfo.Offset, vmt, vmtAdr);
                        if Assigned(fInfo) then
                        Begin
                          if vmt then
                          Begin
                            if CanReplace(fInfo._Type, sType) then fInfo._Type := sType;
                            AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'c');
                          End
                          else fInfo.Free;
                          AddPicode(curPos, 0, typeName, DisInfo.Offset);
                        End
                        else if vmt then
                        Begin
                          fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, DisInfo.Offset, -1, '', sType);
                          if Assigned(fInfo) then
                          Begin
                            AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'c');
                            AddPicode(curPos, 0, typeName, DisInfo.Offset);
                          End;
                        End;
                      End;
                    End;
                  End
                  //cop [BaseReg + Offset], reg
                  else if DisInfo.Offset > 0 then
                  Begin
                    typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
                    if typeName <> '' then
                    Begin
                    	if registers[reg2Idx]._type <> '' then sType := registers[reg2Idx]._type;
                      fInfo := GetField(typeName, DisInfo.Offset, vmt, vmtAdr);
                      if Assigned(fInfo) then
                      Begin
                        if vmt then
                        Begin
                          if CanReplace(fInfo._Type, sType) then fInfo._Type := sType;
                          AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'c');
                        End
                        else fInfo.Free;
                        //if (vmtAdr) typeName := GetClsName(vmtAdr);
                        AddPicode(curPos, 0, typeName, DisInfo.Offset);
                      End
                      else if vmt then
                      Begin
                        fInfo := AddField(fromAdr, curAdr - fromAdr, typeName, FIELD_PUBLIC, DisInfo.Offset, -1, '', sType);
                        if Assigned(fInfo) then
                        Begin
                          AddFieldXref(fInfo, fromAdr, curAdr - fromAdr, 'c');
                        	AddPicode(curPos, 0, typeName, DisInfo.Offset);
                        End;
                      End;
                    End;
                  End
                  else
                  Begin
                    //cop [BaseReg - Offset], reg

                  End;
                End;
              End
              //cop [BaseReg + IndxReg*Scale + Offset], reg
              else
              Begin
                if bpBased and (DisInfo.BaseReg = 21) and (DisInfo.Offset < 0) then
                Begin
                  //cop [BaseReg + IndxReg*Scale + Offset], reg

                End
                else if DisInfo.BaseReg = 20 then
                Begin
                  //esp

                End
                //other registers
                else
                Begin
                  if DisInfo.Offset=0 then
                  Begin
                    //[BaseReg]

                  End
                  //cop [BaseReg + IndxReg*Scale + Offset], reg
                  else if DisInfo.Offset > 0 then
                  Begin
                    typeName := TrimTypeName(registers[DisInfo.BaseReg]._type);
                  End
                  else
                  Begin
                    //cop [BaseReg - Offset], reg

                  End;
                End;
              End;
            End
            else
            Begin
              //Other instructions

            End;
          End;
        End;
      End
      else if (op = OP_ADC) or (op = OP_SBB) then
      Begin
        if DisInfo.OpType[0] = otREG then
        Begin
          reg1Idx := DisInfo.OpRegIdx[0];
          SetRegisterValue(registers, reg1Idx, -1);
          registers[reg1Idx]._type := '';
        End;
      End
      else if (op = OP_MUL) or (op = OP_DIV) then
      Begin
        //Clear register eax
        SetRegisterValue(registers, 16, -1);
        //Clear register edx
        SetRegisterValue(registers, 18, -1);
        for n := 0 to 4 do
          if n <> 3 then 
          begin
            registers[n*4]._type := ''; // EAX
            registers[2+n*4]._type := ''; // EDX
          end;
      End
      else
      Begin
        if DisInfo.OpType[0] = otREG then
        Begin
          reg1Idx := DisInfo.OpRegIdx[0];
          if registers[reg1Idx].source in ['L','l'] then SetRegisterValue(registers, reg1Idx, -1);
          registers[reg1Idx]._type := '';
        End;
      End;
      //SHL??? SHR???
    End;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
  Result:=fContinue;
end;

Function TFMain.AnalyzeTypes (parentAdr:Integer; callPos:Integer; callAdr:Integer; var registers:RegList):AnsiString;
Var
  callKind:Byte;
  _kind:LKind;
  codePage, elemSize:Word;
  n, wBytes, ps, pushn, itemPos, refcnt, len, regIdx,elTypeAdr:Integer;
  idx, ap, size, _pos,vmtAdr,refAdr,arrayAdr,intfAdr,elNum,resId:Integer;
  itemAdr, strAdr,wsize,ident,bytes,recAdr,recTypeAdr,dstArrayAdr:Integer;
  hInst:Cardinal;
  tmpBuf:PAnsiChar;
  recN, recN1:InfoRec;
  aInfo:PARGINFO;
  typeDef, typeName, retName, _vs:AnsiString;
  wStr:WideString;
  disInfo:TDisInfo;
  buf:Array[0..1024] Of Char;  //for LoadStr function
Begin
  elemSize:=1;
  Result:='';
  ap := Adr2Pos(callAdr);
  if ap < 0 then Exit;
  retName := '';
  recN := GetInfoRec(callAdr);
  //If procedure is skipped return
  if IsFlagSet(cfSkip, callPos) then
  Begin
    //@BeforeDestruction
    if recN.SameName('@BeforeDestruction') then Result:= registers[16]._type
      else Result:=recN._type;
    Exit;
  End;

  //cdecl, stdcall
  if (recN.procInfo.flags and 1)<>0 then
  Begin
  	if not Assigned(recN.procInfo.args) or (recN.procInfo.args.Count=0) then
    Begin
      Result:= recN._type;
      Exit;
    End;
    pushn := -1;
    for ps := callPos downto 0 do
    Begin
      if not IsFlagSet(cfInstruction, ps) then continue;
      if IsFlagSet(cfProcStart, ps) then break;
      //I cannot yet handle this situation
      if IsFlagSet(cfCall, ps) and (ps <> callPos) then break;
      if IsFlagSet(cfPush, ps) then
      Begin
        Inc(pushn);
        if pushn < recN.procInfo.args.Count then
        Begin
          frmDisasm.Disassemble(Code + ps, Pos2Adr(ps), @disInfo, Nil);
          itemAdr := disInfo.Immediate;
          if IsValidImageAdr(itemAdr) then
          Begin
            itemPos := Adr2Pos(itemAdr);
            aInfo := recN.procInfo.args[pushn];
            typeDef := aInfo.TypeDef;

            if SameText(typeDef, 'PAnsiChar') or SameText(typeDef, 'PChar') then
            Begin
              if itemPos >= 0 then
              Begin
                recN1 := GetInfoRec(itemAdr);
                if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikData);
                //var - use pointer
                if aInfo.Tag = $22 then
                Begin
                  strAdr := PInteger(Code + itemPos)^;
                  if strAdr=0 then
                  Begin
                    SetFlags(cfData, itemPos, 4);
                    MakeGvar(recN1, itemAdr, Pos2Adr(ps));
                    if typeDef <> '' then recN1._type := typeDef;
                  End
                  else
                  Begin
                    ap := Adr2Pos(strAdr);
                    if ap >= 0 then
                    Begin
                      len := StrLen(Code + ap);
                      SetFlags(cfData, ap, len + 1);
                    End
                    else if ap = -1 then
                    Begin
                      recN1 := AddToBSSInfos(strAdr, MakeGvarName(strAdr), typeDef);
                      if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
                    End;
                  End;
                End
                //val
                else if aInfo.Tag = $21 then
                Begin
                  recN1.kind := ikCString;
                  len := strlen(Code + itemPos);
                  if not recN1.HasName then
                  Begin
                    if IsValidCodeAdr(itemAdr) then
                      recN1.Name:=TransformString(Code + itemPos, len)
                    else
                    Begin
                      recN1.Name:=MakeGvarName(itemAdr);
                      if typeDef <> '' then recN1._type := typeDef;
                    End;
                  End;
                  SetFlags(cfData, itemPos, len + 1);
                End;
                if Assigned(recN1) then recN1.ScanUpItemAndAddRef(callPos, itemAdr, 'C', parentAdr);
              End
              else
              Begin
                recN1 := AddToBSSInfos(itemAdr, MakeGvarName(itemAdr), typeDef);
                if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
              End;
            End
            else if SameText(typeDef, 'PWideChar') then
            Begin
              if itemPos<>0 then
              Begin
                recN1 := GetInfoRec(itemAdr);
                if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikData);
                //var - use pointer
                if aInfo.Tag = $22 then
                Begin
                  strAdr := PInteger(Code + itemPos)^;
                  if strAdr=0 then
                  Begin
                    SetFlags(cfData, itemPos, 4);
                    MakeGvar(recN1, itemAdr, Pos2Adr(ps));
                    if typeDef <> '' then recN1._type := typeDef;
                  End
                  else
                  Begin
                    ap := Adr2Pos(strAdr);
                    if ap >= 0 then
                    Begin
                      len := lstrlenw(PWideChar(Code) + Adr2Pos(strAdr));
                      SetFlags(cfData, Adr2Pos(strAdr), 2*len + 1);
                    End
                    else if ap = -1 then
                    Begin
                      recN1 := AddToBSSInfos(strAdr, MakeGvarName(strAdr), typeDef);
                      if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
                    End;
                  End;
                End
                //val
                else if aInfo.Tag = $21 then
                Begin
                  recN1.kind := ikWCString;
                  len := lstrlenw(PWideChar(Code) + itemPos);
                  if not recN1.HasName then
                  Begin
                    if IsValidCodeAdr(itemAdr) then
                    Begin
                      wsize := WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + itemPos, len, Nil, 0, Nil, Nil);
                      if wsize<>0 then
                      Begin
                        GetMem(tmpBuf,wsize + 1);
                        WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + itemPos, len, tmpBuf, wsize, Nil, Nil);
                        recN1.Name:=TransformString(tmpBuf, wsize);
                        FreeMem(tmpBuf);
                        if recN.SameName('GetProcAddress') then retName := recN1.Name;
                      End;
                    End
                    else
                    Begin
                      recN1.Name:=MakeGvarName(itemAdr);
                      if typeDef <> '' then recN1._type := typeDef;
                    End;
                  End;
                  SetFlags(cfData, itemPos, 2*len + 1);
                End;
                recN1.AddXref('C', callAdr, callPos);
              End
              else
              Begin
                recN1 := AddToBSSInfos(itemAdr, MakeGvarName(itemAdr), typeDef);
                if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
              End;
            End
            else if SameText(typeDef, 'TGUID') then
            Begin
              if itemPos<>0 then
              Begin
                recN1 := GetInfoRec(itemAdr);
                if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikGUID);
                recN1.kind := ikGUID;
                SetFlags(cfData, itemPos, 16);
                if not recN1.HasName then
                Begin
                  if IsValidCodeAdr(itemAdr) then
                    recN1.Name:='['''+GuidToString(PGUID(Code + itemPos)^)+''']'
                  else
                  Begin
                    recN1.Name:=MakeGvarName(itemAdr);
                    if typeDef <> '' then recN1._type := typeDef;
                  End;
                End;
                recN1.AddXref('C', callAdr, callPos);
              End
              else
              Begin
                recN1 := AddToBSSInfos(itemAdr, MakeGvarName(itemAdr), typeDef);
                if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
              End;
            End;
          End;
          if pushn = recN.procInfo.args.Count - 1 then break;
        End;
      End;
    End;
    Result:=recN._type;
    Exit;
  End;
  if recN.HasName then
  Begin
    if recN.SameName('LoadStr') or recN.SameName('FmtLoadStr') or recN.SameName('LoadResString') then
    Begin
      ident := registers[16].value;  //eax := string ID
      if ident <> -1 then
      Begin
        hInst := LoadLibraryEx(PAnsiChar(SourceFile), 0, LOAD_LIBRARY_AS_DATAFILE);
        if hInst<>0 then
        Begin
          bytes := LoadString(hInst, ident, buf, SizeOf(Buf));
          if bytes<>0 then AddPicode(callPos, OP_COMMENT, COMENT_QUOTE + MakeString(buf, bytes) + COMENT_QUOTE, 0);
          FreeLibrary(hInst);
        End;
      End;
      Exit;
    End;
    if recN.SameName('TApplication.CreateForm') then
    Begin
      vmtAdr := registers[18].value + VmtSelfPtr; //edx
      refAdr := registers[17].value;        //ecx
      if IsValidImageAdr(refAdr) then
      Begin
        typeName := GetClsName(vmtAdr);
        ap := Adr2Pos(refAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(refAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikData);
          MakeGvar(recN1, refAdr, 0);
          if typeName <> '' then recN1._type := typeName;
        End
        else
        Begin
          _vs := Val2Str(refAdr,8);
          idx := BSSInfos.IndexOf(_vs);
          if idx <> -1 then
          Begin
            recN1 := InfoRec(BSSInfos.Objects[idx]);
            if typeName <> '' then recN1._type := typeName;
          End;
        End;
      End;
      Exit;
    End;
    if recN.SameName('@FinalizeRecord') then
    Begin
      recAdr := registers[16].value;        //eax
      recTypeAdr := registers[18].value;    //edx
      typeName := GetTypeName(recTypeAdr);
      //Address given directly
      if IsValidImageAdr(recAdr) then
      Begin
        ap := Adr2Pos(recAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(recAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikRecord);
          MakeGvar(recN1, recAdr, 0);
          if typeName <> '' then recN1._type := typeName;
          if not IsValidCodeAdr(recAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(recAdr, MakeGvarName(recAdr), typeName);
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End
      //Local variable
      else if registers[16].source in ['L','l'] then
      Begin
        if (registers[16]._type = '') and (typeName <> '') then registers[16]._type := typeName;
        registers[16].result := 1;
      End;
      Exit;
    End;
    if recN.SameName('@DynArrayAddRef') then
    Begin
      arrayAdr := registers[16].value;      //eax
      //Address given directly
      if IsValidImageAdr(arrayAdr) then
      Begin
        ap := Adr2Pos(arrayAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(arrayAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikDynArray);
          MakeGvar(recN1, arrayAdr, 0);
          if not IsValidCodeAdr(arrayAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(arrayAdr, MakeGvarName(arrayAdr), '');
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End
      //Local variable
      else if registers[16].source in ['L','l'] then
      Begin
        if registers[16]._type = '' then registers[16]._type := 'array of ?';
        registers[16].result := 1;
      End;
      Exit;
    End;
    if recN.SameName('DynArrayClear')    or
      recN.SameName('@DynArrayClear')    or
      recN.SameName('DynArraySetLength') or
      recN.SameName('@DynArraySetLength') then
    Begin
      arrayAdr := registers[16].value;      //eax
      elTypeAdr := registers[18].value;     //edx
      typeName := GetTypeName(elTypeAdr);
      //Address given directly
      if IsValidImageAdr(arrayAdr) then
      Begin
        ap := Adr2Pos(arrayAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(arrayAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikDynArray);
          MakeGvar(recN1, arrayAdr, 0);
          if (recN1._type = '') and (typeName <> '') then recN1._type := typeName;
          if not IsValidCodeAdr(arrayAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(arrayAdr, MakeGvarName(arrayAdr), typeName);
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End
      //Local variable
      else if registers[16].source in ['L','l'] then
      Begin
        if (registers[16]._type = '') and (typeName <> '') then registers[16]._type := typeName;
        registers[16].result := 1;
      End;
      Exit;
    End;
    if recN.SameName('@DynArrayCopy') then
    Begin
      arrayAdr := registers[16].value;      //eax
      elTypeAdr := registers[18].value;     //edx
      dstArrayAdr := registers[17].value;   //ecx
      typeName := GetTypeName(elTypeAdr);
      //Address given directly
      if IsValidImageAdr(arrayAdr) then
      Begin
        ap := Adr2Pos(arrayAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(arrayAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikDynArray);
          MakeGvar(recN1, arrayAdr, 0);
          if typeName <> '' then recN1._type := typeName;
          if not IsValidCodeAdr(arrayAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(arrayAdr, MakeGvarName(arrayAdr), typeName);
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End
      //Local variable
      else if registers[16].source in ['L','l'] then
      Begin
        if (registers[16]._type = '') and (typeName <> '') then registers[16]._type := typeName;
        registers[16].result := 1;
      End;
      //Address given directly
      if IsValidImageAdr(dstArrayAdr) then
      Begin
        ap := Adr2Pos(dstArrayAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(dstArrayAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikDynArray);
          MakeGvar(recN1, dstArrayAdr, 0);
          if typeName <> '' then recN1._type := typeName;
          if not IsValidCodeAdr(dstArrayAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(dstArrayAdr, MakeGvarName(dstArrayAdr), typeName);
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End
      //Local variable
      else if registers[17].source in ['L','l'] then
      Begin
        if (registers[17]._type = '') and (typeName <> '') then registers[17]._type := typeName;
        registers[17].result := 1;
      End;
      Exit;
    End;
    if recN.SameName('@IntfClear') then
    Begin
      intfAdr := registers[16].value;       //eax
      if IsValidImageAdr(intfAdr) then
      Begin
        ap := Adr2Pos(intfAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(intfAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikInterface);
          MakeGvar(recN1, intfAdr, 0);
          recN1._type := 'IInterface';
          if not IsValidCodeAdr(intfAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(intfAdr, MakeGvarName(intfAdr), 'IInterface');
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End;
      Exit;
    End;
    if recN.SameName('@FinalizeArray') then
    Begin
      arrayAdr := registers[16].value;      //eax
      elNum := registers[17].value;           //ecx
      elTypeAdr := registers[18].value;     //edx
      if IsValidImageAdr(arrayAdr) then
      Begin
        typeName := 'array[' + IntToStr(elNum) + '] of ' + GetTypeName(elTypeAdr);
        ap := Adr2Pos(arrayAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(arrayAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikArray);
          MakeGvar(recN1, arrayAdr, 0);
          recN1._type := typeName;
          if not IsValidCodeAdr(arrayAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(arrayAdr, MakeGvarName(arrayAdr), typeName);
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End;
      Exit;
    End;
    if recN.SameName('@VarClr') then
    Begin
      strAdr := registers[16].value;        //eax
      if IsValidImageAdr(strAdr) then
      Begin
        ap := Adr2Pos(strAdr);
        if ap >= 0 then
        Begin
          recN1 := GetInfoRec(strAdr);
          if not Assigned(recN1) then recN1 := InfoRec.Create(ap, ikVariant);
          MakeGvar(recN1, strAdr, 0);
          recN1._type := 'Variant';
          if not IsValidCodeAdr(strAdr) then recN1.AddXref('C', callAdr, callPos);
        End
        else
        Begin
          recN1 := AddToBSSInfos(strAdr, MakeGvarName(strAdr), 'Variant');
          if Assigned(recN1) then recN1.AddXref('C', callAdr, callPos);
        End;
      End;
      Exit;
    End;
    //@AsClass
    if recN.SameName('@AsClass') then
    Begin
      Result:=registers[18]._type;
      Exit;
    End
    //@IsClass
    else if recN.SameName('@IsClass') then Exit
    //@GetTls
    else if recN.SameName('@GetTls') then
    Begin
      Result:= '#TLS';
      Exit;
    End
    //@AfterConstruction
    else if recN.SameName('@AfterConstruction') then Exit;
  End;
  //try prototype
  callKind := recN.procInfo.flags and 7;
  if Assigned(recN.procInfo.args) and (callKind=0) then
  Begin
    registers[16].result := 0;
    registers[17].result := 0;
    registers[18].result := 0;

    for n := 0 to recN.procInfo.args.Count-1 do
    Begin
      aInfo := recN.procInfo.args[n];
      regIdx := -1;
      case aInfo.Ndx of
        0: regIdx := 16; // EAX
        1: regIdx := 18; // EDX
        2: regIdx := 17; // ECX
      end;
      if regIdx = -1 then continue;
      if aInfo.TypeDef = '' then
      Begin
      	if registers[regIdx]._type <> '' then
          aInfo.TypeDef := TrimTypeName(registers[regIdx]._type);
      End
      else
      Begin
      	if registers[regIdx]._type = '' then
        Begin
          registers[regIdx]._type := aInfo.TypeDef;
          //registers[regIdx].result := 1;
        End
        else
        Begin
        	typeName := GetCommonType(aInfo.TypeDef, TrimTypeName(registers[regIdx]._type));
          if typeName <> '' then aInfo.TypeDef := typeName;
        End;
        //Aliases ???????????
      End;
      typeDef := aInfo.TypeDef;
      //Local var (lea - remove ^ before type)
      if registers[regIdx].source = 'L' then
      Begin
      	if SameText(typeDef, 'Pointer') then
        	registers[regIdx]._type := 'Byte'
        else if SameText(typeDef, 'PAnsiChar') or SameText(typeDef, 'PChar') then
          registers[regIdx]._type := Copy(typeDef,2, Length(typeDef) - 1)
        else if (DelphiVersion >= 2009) and SameText(typeDef, 'AnsiString') then
        	registers[regIdx]._type := 'UnicodeString';
        registers[regIdx].result := 1;
        continue;
      End
      //Local var
      else if registers[regIdx].source = 'l' then continue
      //Arg
      else if registers[regIdx].source in ['A','a'] then continue;
      itemAdr := registers[regIdx].value;
      if IsValidImageAdr(itemAdr) then
      Begin
        itemPos := Adr2Pos(itemAdr);
        if itemPos >= 0 then
        Begin
          recN1 := GetInfoRec(itemAdr);
          if not Assigned(recN1) or (recN1.kind <> ikVMT) then
          Begin
            registers[regIdx].result := 1;
            if SameText(typeDef, 'PShortString') or SameText(typeDef, 'ShortString') then
            Begin
              recN1 := GetInfoRec(itemAdr);
              if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikData);
              //var - use pointer
              if aInfo.Tag = $22 then
              Begin
                strAdr := PInteger(Code + itemPos)^;
                if IsValidCodeAdr(strAdr) then
                Begin
                  ap := Adr2Pos(strAdr);
                  len := Byte(Code[ap]);
                  SetFlags(cfData, ap, len + 1);
                End
                else
                Begin
                  SetFlags(cfData, itemPos, 4);
                  MakeGvar(recN1, itemAdr, 0);
                  if typeDef <> '' then recN1._type := typeDef;
                End;
              End
              //val
              else if aInfo.Tag = $21 then
              Begin
                recN1.kind := ikString;
                len := Byte(Code[itemPos]);
                if not recN1.HasName then
                Begin
                  if IsValidCodeAdr(itemAdr) then
                    recN1.Name:=TransformString(Code + itemPos + 1, len)
                  else
                  Begin
                    recN1.Name:=MakeGvarName(itemAdr);
                    if typeDef <> '' then recN1._type := typeDef;
                  End;
                End;
                SetFlags(cfData, itemPos, len + 1);
              End;
            End
            else if SameText(typeDef, 'PAnsiChar') or SameText(typeDef, 'PChar') then
            Begin
              recN1 := GetInfoRec(itemAdr);
              if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikData);
              //var - use pointer
              if aInfo.Tag = $22 then
              Begin
                strAdr := PInteger(Code + itemPos)^;
                if IsValidCodeAdr(strAdr) then
                Begin
                  ap := Adr2Pos(strAdr);
                  len := strlen(Code + ap);
                  SetFlags(cfData, ap, len + 1);
                End
                else
                Begin
                  SetFlags(cfData, itemPos, 4);
                  MakeGvar(recN1, itemAdr, 0);
                  if typeDef <> '' then recN1._type := typeDef;
                End;
              End
              //val
              else if aInfo.Tag = $21 then
              Begin
                recN1.kind := ikCString;
                len := strlen(Code + itemPos);
                if not recN1.HasName then
                Begin
                  if IsValidCodeAdr(itemAdr) then
                    recN1.Name:=TransformString(Code + itemPos, len)
                  else
                  Begin
                    recN1.Name:=MakeGvarName(itemAdr);
                    if typeDef <> '' then recN1._type := typeDef;
                  End;
                End;
                SetFlags(cfData, itemPos, len + 1);
              End;
            End
            else if SameText(typeDef, 'AnsiString') or
              SameText(typeDef, 'String') or
              SameText(typeDef, 'UString') or
              SameText(typeDef, 'UnicodeString') then
            Begin
              recN1 := GetInfoRec(itemAdr);
              if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikData);
              //var - use pointer
              if aInfo.Tag = $22 then
              Begin
                strAdr := PInteger(Code + itemPos)^;
                ap := Adr2Pos(strAdr);
                if IsValidCodeAdr(strAdr) then
                Begin
                  refcnt := PInteger(Code + ap - 8)^;
                  len := PInteger(Code + ap - 4)^;
                  if (refcnt = -1) and (len >= 0) and (len < 25000) then
                  Begin
                    if DelphiVersion < 2009 then
                      SetFlags(cfData, ap - 8, (8 + len + 1 + 3) and (-4))
                    else
                    Begin
                      codePage := PWord(Code + ap - 12)^;
                      elemSize := PWord(Code + ap - 10)^;
                      SetFlags(cfData, ap - 12, (12 + (len + 1)*elemSize + 3) and (-4));
                    End;
                  End
                  else SetFlags(cfData, ap, 4);
                End
                else
                Begin
                  if ap >= 0 then
                  Begin
                    SetFlags(cfData, itemPos, 4);
                    MakeGvar(recN1, itemAdr, 0);
                    if typeDef <> '' then recN1._type := typeDef;
                  End
                  else if ap = -1 then
                    recN1 := AddToBSSInfos(itemAdr, MakeGvarName(itemAdr), typeDef);
                End;
              End
              //val
              else if aInfo.Tag = $21 then
              Begin
                refcnt := PInteger(Code + itemPos - 8)^;
                len := lstrlenw(PWideChar(Code) + itemPos);
                if DelphiVersion < 2009 then
                  recN1.kind := ikLString
                else
                Begin
                  codePage := PWord(Code + itemPos - 12)^;
                  elemSize := PWord(Code + itemPos - 10)^;
                  recN1.kind := ikUString;
                End;
                if (refcnt = -1) and (len >= 0) and (len < 25000) then
                Begin
                  if not recN1.HasName then
                  Begin
                    if IsValidCodeAdr(itemAdr) then
                    Begin
                      if DelphiVersion < 2009 then
                        recN1.Name:=TransformString(Code + itemPos, len)
                      else
                        recN1.Name:=TransformUString(codePage, PWideChar(Code) + itemPos, len);
                    End
                    else
                    Begin
                      recN1.Name:=MakeGvarName(itemAdr);
                      if typeDef <> '' then recN1._type := typeDef;
                    End;
                  End;
                  if DelphiVersion < 2009 then
                    SetFlags(cfData, itemPos - 8, (8 + len + 1 + 3) and (-4))
                  else
                    SetFlags(cfData, itemPos - 12, (12 + (len + 1)*elemSize + 3) and (-4));
                End
                else
                Begin
                  if not recN1.HasName then
                  Begin
                    if IsValidCodeAdr(itemAdr) then recN1.Name:=''
                    else
                    Begin
                      recN1.Name:=MakeGvarName(itemAdr);
                      if typeDef <> '' then recN1._type := typeDef;
                    End;
                  End;
                  SetFlags(cfData, itemPos, 4);
                End;
              End;
            End
            else if SameText(typeDef, 'WideString') then
            Begin
              recN1 := GetInfoRec(itemAdr);
              if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikData);
              //var - use pointer
              if aInfo.Tag = $22 then
              Begin
                strAdr := PInteger(Code + itemPos)^;
                ap := Adr2Pos(strAdr);
                if IsValidCodeAdr(strAdr) then
                Begin
                  len := PInteger(Code + ap - 4)^;
                  SetFlags(cfData, ap - 4, (4 + len + 1 + 3) and (-4));
                End
                else
                Begin
                  if ap >= 0 then
                  Begin
                    SetFlags(cfData, itemPos, 4);
                    MakeGvar(recN1, itemAdr, 0);
                    if typeDef <> '' then recN1._type := typeDef;
                  End
                  else if ap = -1 then
                    recN1 := AddToBSSInfos(itemAdr, MakeGvarName(itemAdr), typeDef);
                End;
              End
              //val
              else if aInfo.Tag = $21 then
              Begin
                recN1.kind := ikWString;
                len := lstrlenw(PWideChar(Code) + itemPos);
                if not recN1.HasName then
                Begin
                  if IsValidCodeAdr(itemAdr) then
                  Begin
                    wsize := WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + itemPos, len, Nil, 0, Nil, Nil);
                    if wsize<>0 then
                    Begin
                      GetMem(tmpBuf,wsize + 1);
                      WideCharToMultiByte(CP_ACP, 0, PWideChar(Code) + itemPos, len, tmpBuf, wsize, Nil, Nil);
                      recN1.Name:=TransformString(tmpBuf, wsize);    //???size - 1
                      FreeMem(tmpBuf);
                    End;
                  End
                  else
                  Begin
                    recN1.Name:=MakeGvarName(itemAdr);
                    if typeDef <> '' then recN1._type := typeDef;
                  End;
                End;
                SetFlags(cfData, itemPos - 4, (4 + len + 1 + 3) and (-4));
              End;
            End
            else if SameText(typeDef, 'TGUID') then
            Begin
              recN1 := GetInfoRec(itemAdr);
              if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikGUID);
              recN1.kind := ikGUID;
              SetFlags(cfData, itemPos, 16);
              if not recN1.HasName then
              Begin
                if IsValidCodeAdr(itemAdr) then
                  recN1.Name:='['''+GuidToString(PGUID(Code + itemPos)^)+''']'
                else
                Begin
                  recN1.Name:=MakeGvarName(itemAdr);
                  if typeDef <> '' then recN1._type := typeDef;
                End;
              End;
            End
            else if SameText(typeDef, 'PResStringRec') then
            Begin
              recN1 := GetInfoRec(itemAdr);
              if not Assigned(recN1) then
              Begin
                recN1 := InfoRec.Create(itemPos, ikResString);
                recN1._type := 'TResStringRec';
                recN1.ConcatName('SResString' + IntToStr(LastResStrNo));
                Inc(LastResStrNo);
                //Set Flags
                SetFlags(cfData, itemPos, 8);
                //Get Context
                hInst := LoadLibraryEx(PAnsiChar(SourceFile), 0, LOAD_LIBRARY_AS_DATAFILE);
                if hInst<>0 then
                Begin
                  resid := PInteger(Code + itemPos + 4)^;
                  if resid < $10000 then
                  Begin
                    Bytes := LoadString(hInst, resid, buf, SizeOf(Buf));
                    recN1.rsInfo := MakeString(buf, Bytes);
                  End;
                  FreeLibrary(hInst);
                End;
              End;
            End
            else
            Begin
              recN1 := GetInfoRec(itemAdr);
              if not Assigned(recN1) then recN1 := InfoRec.Create(itemPos, ikData);
              if not recN1.HasName and
                (recN1.kind <> ikProc)        and
                (recN1.kind <> ikFunc)        and
                (recN1.kind <> ikConstructor) and
                (recN1.kind <> ikDestructor)  and
                (recN1.kind <> ikRefine) then
              Begin
                if typeDef <> '' then recN1._type := typeDef;
              End;
            End;
          End;
        End
        else
        Begin
          _kind := GetTypeKind(typeDef, size);
          if (_kind = ikInteger)    or
            (_kind = ikChar)        or
            (_kind = ikEnumeration) or
            (_kind = ikFloat)       or
            (_kind = ikSet)         or
            (_kind = ikWChar) then
          Begin
            idx := BSSInfos.IndexOf(Val2Str(itemAdr,8));
            if idx <> -1 then
            Begin
              recN1 := InfoRec(BSSInfos.Objects[idx]);
              recN1.Free;
              BSSInfos.Delete(idx);
            End;
          End
          else recN1 := AddToBSSInfos(itemAdr, MakeGvarName(itemAdr), typeDef);
        End;
      End;
    End;
  End;
  if recN.kind = ikFunc then Result:= recN._type;
end;

Function TFMain.AnalyzeArguments (fromAdr:Integer):AnsiString;
var
	b1,b2,op:BYTE;
  kb, bpBased, emb, lastemb,argA, argD, argC, inAX, inDX, inCX,spRestored:Boolean;
  bpBase, retBytes,retb:Word;
  num, instrLen, instrLen1, instrLen2, _procSize,macroFrom, macroTo,cTblAdr,jTblAdr,delta:Integer;
  firstPopRegIdx, popBytes, procStackSize, fromPos, curPos, Ps, reg1Idx, reg2Idx, sSize:Integer;
  b, curAdr, Adr, Adr1, lastAdr, lastCallAdr, lastMovAdr, lastMovImm,sp,n,k,CNum,NPos:Integer;
  argSize:Integer;
  recN, recN1:InfoRec;
  recX:PXrefRec;
  aInfo:PARGINFO;
  stack:Array[0..255] of Integer;
  argType,minClassName, clsName, retType:AnsiString;
  DisInfo, DisInfo1:TDisInfo;
  CTab:Array[0..255] of Byte;
Begin
  spRestored:=False;
  firstPopRegIdx := -1;
  popBytes := 0;
  procStackSize := 0;
  lastAdr := 0;
  lastCallAdr := 0;
  lastMovAdr := 0;
  lastMovImm := 0;
  sp:=-1;
  clsName:='';
  retType:='';
  Result:='';
  fromPos := Adr2Pos(fromAdr);
  if (fromPos < 0) or
    IsFlagSet(cfEmbedded, fromPos) or
    IsFlagSet(cfExport, fromPos) then Exit;
  
  recN := GetInfoRec(fromAdr);
  if not Assigned(recN) or not Assigned(recN.procInfo) then Exit;

  //If cfPass is set exit
  if IsFlagSet(cfPass, fromPos) then
  begin
    Result:=recN._type;
    Exit;
  end;

  //Proc start
  SetFlag(cfProcStart or cfPass, fromPos);

  //Skip Imports
  if IsFlagSet(cfImport, fromPos) then
  begin
    Result:=recN._type;
    Exit;
  end;

  kb := (recN.procInfo.flags and PF_KBPROTO)<>0;
  bpBased := (recN.procInfo.flags and PF_BPBASED)<>0;
  emb := (recN.procInfo.flags and PF_EMBED)<>0;
  bpBase := recN.procInfo.bpBase;
  retBytes := recN.procInfo.retBytes;

  //If constructor or destructor get class name
  if (recN.kind = ikConstructor) or (recN.kind = ikDestructor) then
    clsName := ExtractClassName(recN.Name);
  //If ClassName not given and proc is dynamic, try to find minimal class
  if (clsName = '') and ((recN.procInfo.flags and PF_DYNAMIC)<>0) and Assigned(recN.xrefs) then
  Begin
    minClassName := '';
    for n := 0 to recN.xrefs.Count-1 do
    Begin
      recX := recN.xrefs[n];
      if recX._type = 'D' then
      Begin
        clsName := GetClsName(recX.adr);
        if (minClassName = '') or not IsInheritsByClassName(clsName, minClassName) then minClassName := clsName;
      End;
    End;
    if minClassName <> '' then clsName := minClassName;
  End;
  //If ClassName not given and proc is virtual, try to find minimal class
  if (clsName = '') and ((recN.procInfo.flags and PF_VIRTUAL)<>0) and Assigned(recN.xrefs) then
  Begin
    minClassName := '';
    for n := 0 to recN.xrefs.Count-1 do
    Begin
      recX := recN.xrefs[n];
      if recX._type = 'D' then
      Begin
        clsName := GetClsName(recX.adr);
        if (minClassName = '') or not IsInheritsByClassName(clsName, minClassName) then minClassName := clsName;
      End;
    End;
    if minClassName <> '' then clsName := minClassName;
  End;

  argA := true;
  argD := true;
  argC := true;  //On entry
  inAX := false;
  inDX := false;
  inCX := false;    //No arguments

  _procSize := GetProcSize(fromAdr);
  curPos := fromPos; 
  curAdr := fromAdr;
  while true do
  Begin
    if curAdr >= Integer(CodeBase) + TotalSize then break;
    //Skip exception table
    if IsFlagSet(cfETable, curPos) then
    Begin
      //dd num
      num := PInteger(Code + curPos)^;
      Inc(curPos, 4 + 8*num);
      Inc(curAdr, 4 + 8*num);
      continue;
    End;

    b1 := Byte(Code[curPos]);
    b2 := Byte(Code[curPos + 1]);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo, Nil);
    //if (!instrLen) break;
    if instrLen=0 then
    Begin
      Inc(curPos);
      Inc(curAdr);
      continue;
    End;
    op := frmDisasm.GetOp(DisInfo.Mnem);
    //Code
    SetFlags(cfCode, curPos, instrLen);
    //Instruction begin
    SetFlag(cfInstruction, curPos);
    if curAdr >= lastAdr then lastAdr := 0;
    if op = OP_JMP then
    Begin
      if curAdr = fromAdr then break;
      if DisInfo.OpType[0] = otMEM then
      Begin
        if (Adr2Pos(DisInfo.Offset) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
      End
      else if DisInfo.OpType[0] = otIMM then
      Begin
        Adr := DisInfo.Immediate;
        if (Adr2Pos(Adr) < 0) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        if (GetSegmentNo(Adr) <> 0) and (GetSegmentNo(fromAdr) <> GetSegmentNo(Adr)) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        if (Adr < fromAdr) and ((lastAdr=0) or (curAdr = lastAdr)) then break;
        Inc(curPos, instrLen);
        Inc(curAdr, instrLen);
        continue;
      End;
    End;
    if DisInfo.Ret then
    Begin
      //End of proc
      if (lastAdr=0) or (curAdr = lastAdr) then
      Begin
        //Get last instruction
        Dec(curPos, instrLen);
        if (DisInfo.Ret and not IsFlagSet(cfSkip, curPos)) or   //ret not in SEH
          IsFlagSet(cfCall, curPos) then                       //@Halt0
        Begin
          if IsFlagSet(cfCall, curPos) then spRestored := true;  //acts like mov esp, ebp
          sp := -1;
          SetFlags(cfFrame, curPos, instrLen);
          //ret - stop analyze output regs
          lastCallAdr := 0; 
          firstPopRegIdx := -1; 
          popBytes := 0;
          //define all pop registers (ret skipped)
          for Ps := curPos - 1 downto fromPos do 
          Begin
            b := FlagList[Ps];
            if (b and cfInstruction)<>0 then
            Begin
              //pop instruction
              if (b and cfPop)<>0 then
              Begin
                //pop ecx
                if (b and cfSkip)<>0 then break;
                instrLen1 := frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps), @DisInfo1, Nil);
                firstPopRegIdx := DisInfo1.OpRegIdx[0];
                Inc(popBytes, 4);
                SetFlags(cfFrame, Ps, instrLen1);
              End
              else
              Begin
                //skip frame instruction
                if (b and cfFrame)<>0 then continue;
                //set eax - function
                if (b and cfSetA)<>0 then
                Begin
                  recN1 := GetInfoRec(fromAdr);
                  recN1.procInfo.flags := recN1.procInfo.flags or PF_OUTEAX;
                  if not kb and ((recN1.procInfo.flags and (PF_EVENT or PF_DYNAMIC))=0) and
                    (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
                  Begin
                    recN1.kind := ikFunc;
                    frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps), @DisInfo1, Nil);
                    op := frmDisasm.GetOp(DisInfo1.Mnem);
                    //if setXX - return type is Boolean
                    if op = OP_SET then recN1._type := 'Boolean';
                  End;
                End;
                break;
              End;
            End;
          End;
        End;
        if firstPopRegIdx<> -1 then
        Begin
          //Skip pushed regs
          if spRestored then
          Begin
            Ps := fromPos;
            while true do 
            Begin
              b := FlagList[Ps];
              //Proc end
              //if (Pos <> fromPos and (b & cfProcEnd))
              if (_procSize<>0) and (Ps - fromPos + 1 >= _procSize) then break;
              if (b and cfInstruction)<>0 then
              Begin
                instrLen1 := frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps), @DisInfo1, Nil);
                SetFlags(cfFrame, Ps, instrLen1);
                if ((b and cfPush)<>0) and (DisInfo1.OpRegIdx[0] = firstPopRegIdx) then break;
              End;
              Inc(Ps);
            End;
          End
          else
          Begin
            for Ps := fromPos to TotalSize do
            Begin
              if popBytes=0 then break;
              b := FlagList[Ps];
              //End of proc
              //if (Pos <> fromPos and (b & cfProcEnd))
              if (_procSize<>0) and (Ps - fromPos + 1 >= _procSize) then break;
              if (b and cfInstruction)<>0 then
              Begin
                instrLen1 := frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps), @DisInfo1, Nil);
                op := frmDisasm.GetOp(DisInfo1.Mnem);
                SetFlags(cfFrame, Ps, instrLen1);
                //add esp,...
                if (op = OP_ADD) and (DisInfo1.OpRegIdx[0] = 20) then
                Begin
                  Inc(popBytes, DisInfo1.Immediate);
                  continue;
                End;
                //sub esp,...
                if (op = OP_SUB) and (DisInfo1.OpRegIdx[0] = 20) then
                Begin
                  Dec(popBytes, DisInfo1.Immediate);
                  continue;
                End;
                if (b and cfPush)<>0 then Dec(popBytes, 4);
              End;
            End;
          End;
        End;
        //If no prototype, try add information from analyze arguments result
        if not recN.HasName and (clsName <> '') then
        Begin
          //dynamic
          if (recN.procInfo.flags and PF_DYNAMIC)<>0 then
          Begin

          End;
        End;
        if not kb then
        Begin
          if inAX then
          Begin
            if clsName <> '' then
              recN.procInfo.AddArg($21, 0, 4, 'Self', clsName)
            else
              recN.procInfo.AddArg($21, 0, 4, '', '');
          End;
          if inDX then
          Begin
            if (recN.kind = ikConstructor) or (recN.kind = ikDestructor) then
              recN.procInfo.AddArg($21, 1, 4, '_Dv__', 'Boolean')
            else
              recN.procInfo.AddArg($21, 1, 4, '', '');
          End;
          if inCX then recN.procInfo.AddArg($21, 2, 4, '', '');
        End;
        break;
      End;
      if not IsFlagSet(cfSkip, curPos) then sp := -1;
    End;
    if op = OP_MOV then
    Begin
      lastMovAdr := DisInfo.Offset;
      lastMovImm := DisInfo.Immediate;
    End;
    //init stack via loop
    if IsFlagSet(cfLoc, curPos) then
    Begin
      recN1 := GetInfoRec(curAdr);
      if Assigned(recN1) and Assigned(recN1.xrefs) and (recN1.xrefs.Count = 1) then
      Begin
        recX := recN1.xrefs[0];
        Adr := recX.adr + recX.offset;
        if Adr > curAdr then
        Begin
          sSize := IsInitStackViaLoop(curAdr, Adr);
          if sSize<>0 then
          Begin
            inC(procStackSize, sSize * lastMovImm);
            //skip jne
            instrLen := frmDisasm.Disassemble(Code + Adr2Pos(Adr), Adr, Nil, Nil);
            curAdr := Adr + instrLen; 
            curPos := Adr2Pos(curAdr);
            SetFlags(cfFrame, fromPos, curAdr - fromAdr);
            continue;
          End;
        End;
      End;
    End;
    //add (sub) esp,...
    if (DisInfo.OpRegIdx[0] = 20) and (DisInfo.OpType[1] = otIMM) then
    Begin
      if op = OP_ADD then
      Begin
        if DisInfo.Immediate < 0 then Dec(procStackSize, DisInfo.Immediate);
      End
      else if op = OP_SUB then
      Begin
        if DisInfo.Immediate > 0 then Inc(procStackSize, DisInfo.Immediate);
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    {
    //dec reg
    if (op = OP_DEC) and (DisInfo.Op1Type = otREG) then
    Begin
      //Save (dec reg) address
      Adr := curAdr;
      //Look next instruction
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo1, Nil);
      //If jne @1, where @1 < adr of jne, when make frame from begin if Stack inited via loop
      if DisInfo1.Conditional and (DisInfo1.Immediate < curAdr) and (DisInfo1.Immediate >= fromAdr) then
      Begin
        if IsInitStackViaLoop(DisInfo1.Immediate, Adr) then
          SetFlags(cfFrame, fromPos, curPos + instrLen - fromPos + 1);
      End;
      continue;
    End;
    }

    //mov esp, ebp
    if (b1 = $8B) and (b2 = $E5) then spRestored := true;
    if not IsFlagSet(cfSkip, curPos) then
    Begin
      if IsFlagSet(cfPush, curPos) then
      Begin
        if (curPos <> fromPos) and (sp < 255) then
        Begin
          Inc(sp);
          stack[sp] := curPos;
        End;
      End;
      if IsFlagSet(cfPop, curPos) and (sp >= 0) then
      Begin
        macroFrom := stack[sp];
        SetFlag(cfBracket, macroFrom);
        macroTo := curPos;
        SetFlag(cfBracket, macroTo);
        Dec(sp);
      End;
    End;

    if (b1 = $FF) and ((b2 and $38) = $20) and (DisInfo.OpType[0] = otMEM) and IsValidImageAdr(DisInfo.Offset) then //near absolute indirect jmp (Case)
    Begin
      if not IsValidCodeAdr(DisInfo.Offset) then break;
      cTblAdr := 0;
      jTblAdr := 0;

      Ps := curPos + instrLen;
      Adr := curAdr + instrLen;
      //Taqble address - last 4 bytes of instruction
      jTblAdr := PInteger(Code + Ps - 4)^;
      //Analyze gap to find table cTbl
      if (Adr <= lastMovAdr) and (lastMovAdr < jTblAdr) then cTblAdr := lastMovAdr;
      //If cTblAdr exists, skip it
      if cTblAdr<>0 then
      Begin
        CNum := jTblAdr - cTblAdr;
        Inc(Ps, CNum);
        Inc(Adr, CNum);
      End;
      for k := 0 to 4095 do
      Begin
        //Loc - end of table
        if IsFlagSet(cfLoc, Ps) then break;
        Adr1 := PInteger(Code + Ps)^;
        //Validate Adr1
        if not IsValidCodeAdr(Adr1) or (Adr1 < fromAdr) then break;
        //Set cfLoc
        SetFlag(cfLoc, Adr2Pos(Adr1));
        Inc(Ps, 4);
        Inc(Adr, 4);
        if Adr1 > lastAdr then lastAdr := Adr1;
      End;
      if Adr > lastAdr then lastAdr := Adr;
      curPos := Ps;
      curAdr := Adr;
      continue;
    End;
    //----------------------------------
    //PosTry: xor reg, reg
    //        push ebp
    //        push offset @1
    //        push fs:[reg]
    //        mov fs:[reg], esp
    //        ...
    //@2:     ...
    //At @1 we have various situations:
    //----------------------------------
    //@1:     jmp @HandleFinally
    //        jmp @2
    //----------------------------------
    //@1:     jmp @HandleAnyException
    //        call DoneExcept
    //----------------------------------
    //@1:     jmp HandleOnException
    //        dd num
    //Follow the table of num records like:
    //        dd offset ExceptionInfo
    //        dd offset ExceptionProc
    //----------------------------------
    if b1 = $68 then		//try block	(push loc_TryBeg)
    Begin
      NPos := curPos + instrLen;
      //check that next instruction is push fs:[reg] or retn
      if ((Code[NPos] = #$64) and
        (Code[NPos + 1] = #255) and
        (((Code[NPos + 2] >= #$30) and (Code[NPos + 2] <= #$37)) or (Code[NPos + 2] = #$75))
        ) or (Code[NPos] = #$C3) then
      Begin
        Adr := DisInfo.Immediate;      //Adr:=@1
        if Adr > lastAdr then lastAdr := Adr;
        Ps := Adr2Pos(Adr); 
        assert(Ps >= 0);
        
        //recN1 := GetInfoRec(Adr);
        //if (!recN1) recN1 := new InfoRec(Pos, ikTry);
        //recN1.AddXref('C', fromAdr, Adr - fromAdr);
        delta := Ps - NPos;
        if (delta >= 0) and (delta < MAX_DISASSEMBLE) then
        Begin
          if Code[Ps] = #$E9 then //jmp Handle...
          Begin
            //Disassemble jmp
            instrLen1 := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
            recN1 := GetInfoRec(DisInfo.Immediate);
            if Assigned(recN1) then
            Begin
              if recN1.SameName('@HandleFinally') then
              Begin
                //ret + jmp HandleFinally
                Inc(Ps, instrLen1);
                Inc(Adr, instrLen1);
                //jmp @2
                instrLen2 := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
                Inc(Adr, instrLen2);
                if Adr > lastAdr then lastAdr := Adr;
              End
              else if recN1.SameName('@HandleAnyException') or recN1.SameName('@HandleAutoException') then
              Begin
                //jmp HandleAnyException
                Inc(Ps, instrLen1);
                Inc(Adr, instrLen1);
                //call DoneExcept
                instrLen2 := frmDisasm.Disassemble(Code + Ps, Adr, Nil, Nil);
                Inc(Adr, instrLen2);
                if Adr > lastAdr then lastAdr := Adr;
              End
              else if recN1.SameName('@HandleOnException') then
              Begin
                //jmp HandleOnException
                Inc(Ps, instrLen1);
                Inc(Adr, instrLen1);
                //dd num
                num := PInteger(Code + Ps)^; 
                Inc(Ps, 4);
                if Adr + 4 + 8 * num > lastAdr then lastAdr := Adr + 4 + 8 * num;
                for k := 0 to num-1 do
                Begin
                  //dd offset ExceptionInfo
                  Inc(Ps, 4);
                  //dd offset ExceptionProc
                  Inc(Ps, 4);
                End;
              End;
            End;
          End;
        End;
      	Inc(curPos, instrLen); 
      	Inc(curAdr, instrLen);
      	continue;
      End;
    End;
    while true do
    Begin
      //Call - stop analyze of arguments
      if DisInfo.Call then
      Begin
        lastemb := false;
        Adr := DisInfo.Immediate;
        if IsValidCodeAdr(Adr) then
        Begin
          recN1 := GetInfoRec(Adr);
          if Assigned(recN1) and Assigned(recN1.procInfo) then
          Begin
            lastemb := (recN1.procInfo.flags and PF_EMBED)<>0;
            //@XStrCatN
            if recN1.SameName('@LStrCatN') or
              recN1.SameName('@WStrCatN') or
              recN1.SameName('@UStrCatN') or
              recN1.SameName('Format') then retb := 0
            else retb := recN1.procInfo.retBytes;
            if (retb<>0) and (sp >= retb) then
              Dec(sp, retb)
            else
              sp := -1;
          End
          else sp := -1;
          //call not always preserve registers eax, edx, ecx
          if Assigned(recN1) then
          Begin
            //@IntOver, @BoundErr nothing change
            if not recN1.SameName('@IntOver') and not recN1.SameName('@BoundErr') then
            Begin
              argA := false;
              argD := false;
              argC := false;
            End;
          End
          else
          Begin
            argA := false;
            argD := false;
            argC := false;
          End;
        End
        else
        Begin
          argA := false;
          argD := false;
          argC := false;
          sp := -1;
        End;
        break;
      End;
      //jmp - stop analyze of output arguments
      if op = OP_JMP then
      Begin
        lastCallAdr := 0;
        break;
      End;
      //cop ..., [ebp + Offset]
      if not kb and bpBased and (DisInfo.BaseReg = 21) and (DisInfo.IndxReg = -1) and (DisInfo.Offset > 0) then
      Begin
        recN1 := GetInfoRec(fromAdr);
        //For embedded procs we have on1 additional argument (pushed on stack first), that poped from stack by instrcution pop ecx
        if not emb or (DisInfo.Offset <> retBytes + bpBase) then
        Begin
          argSize := DisInfo.MemSize;
          argType := '';
          if argSize = 10 then argType := 'Extended';
          //Each argument in stack has size 4*N bytes
          if argSize < 4 then argSize := 4;
          argSize := ((argSize + 3) div 4) * 4;
          recN1.procInfo.AddArg($21, DisInfo.Offset, argSize, '', argType);
        End;
      End;
      //Instruction pop reg always change reg
      if (op = OP_POP) and (DisInfo.OpType[0] = otREG) then
      Begin
        case DisInfo.OpRegIdx[0] of
          16: //eax
            Begin
              //Forget last call and set flag cfSkip, if it was call of embedded proc
              if lastCallAdr<>0 then
              Begin
                if lastemb then
                Begin
                  SetFlag(cfSkip, curPos);
                  lastemb := false;
                End;
                lastCallAdr := 0;
              End;
              if argA and not inAX then
              Begin
                argA := false;
                if not inDX then argD := false;
                if not inCX then argC := false;
              End;
            End;
          18: //edx
            if argD and not inDX then
            Begin
              argD := false;
              if not inCX then argC := false;
            End;
          17: //ecx
            if argC and not inCX then argC := false;
        end;
        break;
      End;
      //cdq always change edx; eax may be output argument of last call
      if op = OP_CDQ then
      Begin
        if lastCallAdr<>0 then
        Begin
          recN1 := GetInfoRec(lastCallAdr);
          if Assigned(recN1) and Assigned(recN1.procInfo) and
            ((recN1.procInfo.flags and (PF_KBPROTO or PF_EVENT or PF_DYNAMIC))=0) and
            (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
          Begin
            recN1.procInfo.flags := recN1.procInfo.flags or PF_OUTEAX;
            recN1.kind := ikFunc;
          End;
          lastCallAdr := 0;
        End;
        if argD and not inDX then
        Begin
          argD := false;
          if not inCX then argC := false;
        End;
        break;
      End;
      if DisInfo.Float then
      Begin
        //fstsw, fnstsw always change eax
        if (DisInfo.Mnem = 'fstsw') or (DisInfo.Mnem = 'fnstsw') then
        Begin
          if (DisInfo.OpType[0] = otREG) and (DisInfo.OpRegIdx[0] in [0,4,8,16]) then
          Begin
            {if lastCallAdr<>0 then} lastCallAdr := 0;
            if argA and not inAX then
            Begin
              argA := false;
              if not inDX then argD := false;
              if not inCX then argC := false;
            End;
          End;
          SetFlags(cfSkip, curPos, instrLen);
          break;
        End;
        //Instructions fst, fstp after call means that it was call of function
        if (DisInfo.Mnem = 'fst') or (DisInfo.Mnem = 'fstp') then
        Begin
          Ps := GetNearestUpInstruction(curPos, fromPos, 1);
          if (Ps <> -1) and IsFlagSet(cfCall, Ps) then
          Begin
            if lastCallAdr<>0 then
            Begin
              recN1 := GetInfoRec(lastCallAdr);
              if Assigned(recN1) and Assigned(recN1.procInfo) and
                ((recN1.procInfo.flags and (PF_KBPROTO or PF_EVENT or PF_DYNAMIC))=0) and
                (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
              Begin
                recN1.procInfo.flags := recN1.procInfo.flags or PF_OUTEAX;
                recN1.kind := ikFunc;
              End;
              lastCallAdr := 0;
            End;
          End;
          break;
        End;
      End;
      //mul, div ??????????????????????????
      //xor reg, reg always change register
      if (op = OP_XOR) and (DisInfo.OpType[0] = DisInfo.OpType[1]) and (DisInfo.OpRegIdx[0] = DisInfo.OpRegIdx[1]) then
      Begin
        if DisInfo.OpRegIdx[0] in [0,4,8,16] then
        Begin
          {if lastCallAdr<>0 then} lastCallAdr := 0;
        End;
        if DisInfo.OpRegIdx[0] in [2,6,10,18] then
        Begin
          {if lastCallAdr<>0 then} lastCallAdr := 0;
        End;

        //eax, ax, ah, al
        if DisInfo.OpRegIdx[0] in [0,4,8,16] then
        Begin
          SetFlag(cfSetA, curPos);
          if argA and not inAX then
          Begin
            argA := false;
            if not inDX then argD := false;
            if not inCX then argC := false;
          End;
        End;
        //edx, dx, dh, dl
        if DisInfo.OpRegIdx[0] in [2,6,10,18] then
        Begin
          SetFlag(cfSetD, curPos);
          if argD and not inDX then
          Begin
            argD := false;
            if not inCX then argC := false;
          End;
        End;
        //ecx, cx, ch, cl
        if DisInfo.OpRegIdx[0] in [1,5,9,17] then
        Begin
          SetFlag(cfSetC, curPos);
          if argC and not inCX then argC := false;
        End;
        break;
      End;
      //If eax, edx, ecx in memory address - always used as registers
      if (DisInfo.BaseReg <> -1) or (DisInfo.IndxReg <> -1) then
      Begin
        if (DisInfo.BaseReg = 16) or (DisInfo.IndxReg = 16) then
        Begin
          if lastCallAdr<>0 then
          Begin
            recN1 := GetInfoRec(lastCallAdr);
            if Assigned(recN1) and Assigned(recN1.procInfo) and
              ((recN1.procInfo.flags and (PF_KBPROTO or PF_EVENT or PF_DYNAMIC))=0) and
              (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
            Begin
              recN1.procInfo.flags := recN1.procInfo.flags or PF_OUTEAX;
              recN1.kind := ikFunc;
            End;
            lastCallAdr := 0;
          End;
          if argA and not inAX then
          Begin
            inAX := true;
            argA := false;
          End;
        End;
        if (DisInfo.BaseReg = 18) or (DisInfo.IndxReg = 18) then
        Begin
          if argD and not inDX then
          Begin
            inDX := true;
            argD := false;
            if not inAX then
            Begin
              inAX := true;
              argA := false;
            End;
          End;
        End;
        if (DisInfo.BaseReg = 17) or (DisInfo.IndxReg = 17) then
        Begin
          if argC and not inCX then
          Begin
            inCX := true;
            argC := false;
            if not inAX then
            Begin
              inAX := true;
              argA := false;
            End;
            if not inDX then
            Begin
              inDX := true;
              argD := false;
            End;
          End;
        End;
      End;
      //xchg
      if op = OP_XCHG then
      Begin
        if DisInfo.OpType[0] = otREG then
        Begin
          case DisInfo.OpRegIdx[0] of
            16: //eax
              Begin
                if lastCallAdr<>0 then
                Begin
                  recN1 := GetInfoRec(lastCallAdr);
                  if Assigned(recN1) and Assigned(recN1.procInfo) and
                    ((recN1.procInfo.flags and (PF_KBPROTO or PF_EVENT or PF_DYNAMIC))=0) and
                    (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
                  Begin
                    recN1.procInfo.flags := recN1.procInfo.flags or PF_OUTEAX;
                    recN1.kind := ikFunc;
                  End;
                  lastCallAdr := 0;
                End;
                SetFlag(cfSetA, curPos);
                if argA and not inAX then
                Begin
                  inAX := true;
                  argA := false;
                End;
              End;
            18: //edx
              Begin
                SetFlag(cfSetD, curPos);
                if argD and not inDX then
                Begin
                  inDX := true;
                  argD := false;
                  if not inAX then
                  Begin
                    inAX := true;
                    argA := false;
                  End;
                End;
              End;
            17: //ecx
              Begin
                SetFlag(cfSetC, curPos);
                //xchg ecx, [ebp...] - ecx used as argument
                if DisInfo.BaseReg = 21 then
                Begin
                  inCX := true;
                  argC := false;
                  if not inAX then
                  Begin
                    inAX := true;
                    argA := false;
                  End;
                  if not inDX then
                  Begin
                    inDX := true;
                    argD := false;
                  End;
                  //Set cfFrame upto start of procedure
                  SetFlags(cfFrame, fromPos, curPos + instrLen - fromPos);
                End
                else if argC and not inCX then
                Begin
                  inCX := true;
                  argC := false;
                  if not inAX then
                  Begin
                    inAX := true;
                    argA := false;
                  End;
                  if not inDX then
                  Begin
                    inDX := true;
                    argD := false;
                  End;
                End;
              End;
          End;
        End;
        if DisInfo.OpType[1] = otREG then
        Begin
          case DisInfo.OpRegIdx[1] of
            16: // EAX
              Begin
                if lastCallAdr<>0 then
                Begin
                  recN1 := GetInfoRec(lastCallAdr);
                  if Assigned(recN1) and Assigned(recN1.procInfo) and
                    ((recN1.procInfo.flags and (PF_KBPROTO or PF_EVENT or PF_DYNAMIC))=0) and
                    (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
                  Begin
                    recN1.procInfo.flags := recN1.procInfo.flags or PF_OUTEAX;
                    recN1.kind := ikFunc;
                  End;
                  lastCallAdr := 0;
                End;
                SetFlag(cfSetA, curPos);
                if argA and not inAX then
                Begin
                  inAX := true;
                  argA := false;
                End;
              End;
            18: // EDX
              Begin
                SetFlag(cfSetD, curPos);
                if argD and not inDX then
                Begin
                  inDX := true;
                  argD := false;
                  if not inAX then
                  Begin
                    inAX := true;
                    argA := false;
                  End;
                End;
              End;
            17: // ECX
              Begin
                SetFlag(cfSetC, curPos);
                if argC and not inCX then
                Begin
                  inCX := true;
                  argC := false;
                  if not inAX then
                  Begin
                    inAX := true;
                    argA := false;
                  End;
                  if not inDX then
                  Begin
                    inDX := true;
                    argD := false;
                  End;
                End;
              End;
          End;
        End;
        break;
      End;
      //cop ..., reg
      if DisInfo.OpType[1] = otREG then
      Begin
        if DisInfo.OpRegIdx[1] in [0,8,16] then
        Begin
          if lastCallAdr<>0 then
          Begin
            recN1 := GetInfoRec(lastCallAdr);
            if Assigned(recN1) and Assigned(recN1.procInfo) and
              ((recN1.procInfo.flags and (PF_KBPROTO or PF_EVENT or PF_DYNAMIC))=0) and
              (recN1.kind <> ikConstructor) and (recN1.kind <> ikDestructor) then
            Begin
              recN1.procInfo.flags := recN1.procInfo.flags or PF_OUTEAX;
              recN1.kind := ikFunc;
            End;
            lastCallAdr := 0;
          End;
        End;
        //eax, ax, ah, al
        if DisInfo.OpRegIdx[1] in [0,4,8,16] then
        Begin
          if argA and not inAX then
          Begin
            inAX := true;
            argA := false;
          End;
        End
        //edx, dx, dh, dl
        else if DisInfo.OpRegIdx[1] in [2,6,10,18] then
        Begin
          if argD and not inDX then
          Begin
            inDX := true;
            argD := false;
            if not inAX then
            Begin
              inAX := true;
              argA := false;
            End;
          End;
        End
        //ecx, cx, ch, cl
        else if DisInfo.OpRegIdx[1] in [1,5,9,17] then
        Begin
          if argC and not inCX then
          Begin
            inCX := true;
            argC := false;
            if not inAX then
            Begin
              inAX := true;
              argA := false;
            End;
            if not inDX then
            Begin
              inDX := true;
              argD := false;
            End;
          End;
        End;
      End;
      if (DisInfo.OpType[0] = otREG) and (op <> OP_UNK) and (op <> OP_PUSH) then
      Begin
        if (op <> OP_MOV) and (op <> OP_LEA) and (op <> OP_SET) then
        Begin
          //eax, ax, ah, al
          if DisInfo.OpRegIdx[0] in [0,4,8,16] then
          Begin
            if argA and not inAX then
            Begin
              inAX := true;
              argA := false;
            End;
          End
          //edx, dx, dh, dl
          else if DisInfo.OpRegIdx[0] in [2,6,10,18] then
          Begin
            if argD and not inDX then
            Begin
              inDX := true;
              argD := false;
              if not inAX then
              Begin
                inAX := true;
                argA := false;
              End;
            End;
          End
          //ecx, cx, ch, cl
          else if DisInfo.OpRegIdx[0] in [1,5,9,17] then
          Begin
            if argC and not inCX then
            Begin
              inCX := true;
              argC := false;
              if not inAX then
              Begin
                inAX := true;
                argA := false;
              End;
              if not inDX then
              Begin
                inDX := true;
                argD := false;
              End;
            End;
          End;
        End
        else
        Begin
          //eax, ax, ah, al
          if DisInfo.OpRegIdx[0] in [0,4,8,16] then
          Begin
            SetFlag(cfSetA, curPos);
            if argA and not inAX then
            Begin
              argA := false;
              if not inDX then argD := false;
              if not inCX then argC := false;
            End;
            {if lastCallAdr<>0 then} lastCallAdr := 0;
          End
          //edx, dx, dh, dl
          else if DisInfo.OpRegIdx[0] in [2,6,10,18] then
          Begin
            SetFlag(cfSetD, curPos);
            if argD and not inDX then
            Begin
              argD := false;
              if not inCX then argC := false;
            End;
            {if lastCallAdr<>0 then} lastCallAdr := 0;
          End
          //ecx, cx, ch, cl
          else if DisInfo.OpRegIdx[0] in [1,5,9,17] then
          Begin
            SetFlag(cfSetC, curPos);
            if argC and not inCX then argC := false;
          End;
        End;
      End;
      break;
    End;
    if DisInfo.Call then  //call sub_XXXXXXXX
    Begin
      lastCallAdr := 0;
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        retType := AnalyzeArguments(Adr);
        lastCallAdr := Adr;
        recN1 := GetInfoRec(Adr);
        if Assigned(recN1) and recN1.HasName then
        Begin
          //Hide some procedures
          //@Halt0 is not executed
          if recN1.SameName('@Halt0') then
          Begin
            SetFlags(cfSkip, curPos, instrLen);
            if (fromAdr = EP) and (lastAdr=0) then break;
          End
          //Procs together previous unstruction
          else if recN1.SameName('@IntOver') or
           recN1.SameName('@InitImports') or
           recN1.SameName('@InitResStringImports') then
          Begin
            Ps := GetNearestUpInstruction(curPos, fromPos, 1);
            if Ps <> -1 then SetFlags(cfSkip, Ps, curPos - Ps + instrLen);
          End
          //@BoundErr
          else if recN1.SameName('@BoundErr') then
          Begin
          	if IsFlagSet(cfLoc, curPos) then
            Begin
              Ps := GetNearestUpInstruction(curPos, fromPos, 1);
              frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps), @DisInfo1, Nil);
              if DisInfo1.Branch then
              Begin
              	Ps := GetNearestUpInstruction(Ps, fromPos, 3);
                SetFlags(cfSkip, Ps, curPos - Ps + instrLen);
              End;
            End
            else
            Begin
              Ps := GetNearestUpInstruction(curPos, fromPos, 1);
              frmDisasm.Disassemble(Code + Ps, Pos2Adr(Ps), @DisInfo1, Nil);
              if DisInfo1.Branch then
              Begin
                Ps := GetNearestUpInstruction(Ps, fromPos, 1);
                if IsFlagSet(cfPop, Ps) then
                 	Ps := GetNearestUpInstruction(Ps, fromPos, 3);
              	SetFlags(cfSkip, Ps, curPos - Ps + instrLen);
              End;
            End;
          End
          //Not in source code
          else if recN1.SameName('@_IOTest') or
           recN1.SameName('@InitExe') or
           recN1.SameName('@InitLib') or
      		 recN1.SameName('@DoneExcept') then SetFlags(cfSkip, curPos, instrLen);
        End;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    if (b1 in [$EB,$70..$7F]) or				 //short relative abs jmp or cond jmp
      ((b1 = $F) and (b2 in [$80..$8F])) then
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        if (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End
    else if b1 = $E9 then    //relative abs jmp or cond jmp
    Begin
      Adr := DisInfo.Immediate;
      if IsValidCodeAdr(Adr) then
      Begin
        recN1 := GetInfoRec(Adr);
        if not Assigned(recN1) and (Adr >= fromAdr) and (Adr > lastAdr) then lastAdr := Adr;
      End;
      Inc(curPos, instrLen);
      Inc(curAdr, instrLen);
      continue;
    End;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  End;
  //Check matching ret bytes and summary size of stack arguments
  if bpBased then
  Begin
    if Assigned(recN.procInfo.args) then
    Begin
      delta := retBytes;
      for n := 0 to recN.procInfo.args.Count-1 do
      Begin
        aInfo := recN.procInfo.args[n];
        if aInfo.Ndx > 2 then Dec(delta, aInfo.Size);
      End;
      if delta < 0 then
      Begin
      	//If delta between N bytes (in 'ret N' instruction) and total size of argumnets <> 0
        recN.procInfo.flags := recN.procInfo.flags or PF_ARGSIZEG;
        //delta := 4 and proc can be embbedded - allow that it really embedded
        if (delta = 4) and ((recN.procInfo.flags and PF_MAYBEEMBED)<>0) then
        Begin
        	//Ставим флажок PF_EMBED
          recN.procInfo.flags := recN.procInfo.flags or PF_EMBED;
          //Skip following after call instrcution 'pop ecx'
          for n := 0 to recN.xrefs.Count-1 do
          Begin
          	recX := recN.xrefs[n];
            if recX._type = 'C' then
            Begin
            	Adr := recX.adr + recX.offset; 
            	Ps := Adr2Pos(Adr);
          		instrLen := frmDisasm.Disassemble(Code + Ps, Adr, @DisInfo, Nil);
          		Inc(Ps, instrLen);
          		if Code[Ps] = #$59 then SetFlag(cfSkip, Ps);
            End;
          End;
        End;
      End
      //If delta < 0, then part of arguments can be unusable
      else if delta < 0 then recN.procInfo.flags := recN.procInfo.flags or PF_ARGSIZEL;
    End;
  End;
  recN := GetInfoRec(fromAdr);
  //if PF_OUTEAX not set - Procedure
  if not kb and ((recN.procInfo.flags and PF_OUTEAX)=0) then
  Begin
    if (recN.kind <> ikConstructor) and (recN.kind <> ikDestructor) then recN.kind := ikProc;
  End;
  recN.procInfo.stackSize := procStackSize + $1000;
  if lastCallAdr<>0 then Result:=retType;
end;

procedure TFMain.FormCloseQuery(Sender : TObject; Var CanClose:Boolean);
var
  res:Integer;
begin
  if Assigned(AnalyzeThread) then
  begin
    res := Application.MessageBox('Analysis is not yet completed. Do You really want to exit IDR?', 'Confirmation', MB_YESNO);
    if res = IDNO then
    begin
      CanClose := false;
      Exit;
    end;
    AnalyzeThread.Terminate;
  End;
  if ProjectLoaded and ProjectModified then
  begin
    res := Application.MessageBox('Save active Project?', 'Confirmation', MB_YESNOCANCEL);
    if res = IDCANCEL then
    begin
      CanClose := false;
      Exit;
    end;
    if res = IDYES then
    begin
      if IDPFile = '' then IDPFile := ChangeFileExt(SourceFile, '.idp');
      with SaveDlg do
      begin
        InitialDir := WrkDir;
        Filter := 'IDP|*.idp';
        FileName := IDPFile;
      end;
      if not SaveDlg.Execute then
      begin
        CanClose := false;
        Exit;
      end;
      SaveProject(SaveDlg.FileName);
    End;
    CloseProject;
  end;
  IniFileWrite;
  CanClose := true;
end;

procedure TFMain.miCtdPasswordClick(Sender : TObject);
Var
  //op:BYTE;
  //n,curPos,curAdr,instrLen, beg:Integer;
  ofs, pwdlen:Integer;
  pwds:AnsiString;
  //DisInfo:TDisInfo;
  recN:InfoRec;
  recX:PXrefRec;
  rec:PROCHISTORYREC;
begin
  pwdlen:=0;
  pwds:='';
	recN := GetInfoRec(CtdRegAdr);
  if recN.xrefs.Count <> 1 then Exit;
  recX := recN.xrefs[0];
  for ofs := recX.offset Downto 0 do
    if IsFlagSet(cfPush, Adr2Pos(recX.adr) + ofs) then break;
  {
  curPos = Adr2Pos(recX.adr) + ofs;
  curAdr = Pos2Adr(curPos);
  //pwdlen
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo);
  pwdlen := DisInfo.Immediate + 1;
  Inc(curPos,instrLen);
  Inc(curAdr,instrLen);
  //pwd
  beg := 128;
  n := 0;
  while n< pwdlen do
  begin
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @DisInfo);
    op = frmDisasm.GetOp(DisInfo.Mnem);
    //mov [ebp-Ofs], B
    if (op = OP_MOV) and (DisInfo.Op1Type = otMEM) and (DisInfo.Op2Type = otIMM)
      and (DisInfo.BaseReg = 21) and (DisInfo.Offset < 0) then
    begin
      ofs := DisInfo.Offset;
      if 128 + ofs < beg then beg = 128 + ofs;
      pwd[128 + ofs] := DisInfo.Immediate;
      Inc(n);
    end;
    Inc(curPos, instrLen);
    Inc(curAdr, instrLen);
  end;
  for n := beg to beg + pwdlen-1 do
    pwds:=pwds + Val2Str(pwd[n],2);
    //sb.Panels[1].Text := pwds;
  }
  with rec do
  begin
    adr := CurProcAdr;
    itemIdx := lbCode.ItemIndex;
    xrefIdx := lbCXrefs.ItemIndex;
    topIdx := lbCode.TopIndex;
  end;
  ShowCode(recX.adr, recX.adr + ofs, -1, -1);
  CodeHistoryPush(@rec);
end;

procedure TFMain.pmCodePanelPopup(Sender : TObject);
begin
  miEmptyHistory.Enabled := CodeHistoryPtr > 0;
end;

procedure TFMain.miEmptyHistoryClick(Sender : TObject);
begin
  MoveMemory(@CodeHistory[0], @CodeHistory[CodeHistoryPtr], sizeof(PROCHISTORYREC));
  CodeHistoryPtr := 0;
  CodeHistoryMax := CodeHistoryPtr;
end;

Function TFMain.GetField (TypeName:AnsiString; Offset:Integer; Var vmt:Boolean; Var vmtAdr:Integer):FieldInfo;
var
  scope:Byte;
  kind:LKind;
  n, idx, size, Ofs, classAdr,prevClassAdr:Integer;
  p:PAnsiChar;
  Len:Word;
  use:TWordDynArray;
  tInfo:MTypeInfo;
  recN:InfoRec;
  fInfo, fInfo1, fInfo2:FieldInfo;
Begin
  Result:=Nil;
  vmt := false; 
  vmtAdr := 0;
  classAdr := GetClassAdr(TypeName);
  if IsValidImageAdr(classAdr) then
  Begin
    vmt := true; 
    vmtAdr := classAdr; 
    prevClassAdr := 0;
  	while (classAdr<>0) and (Offset < GetClassSize(classAdr)) do
    Begin
    	prevClassAdr := classAdr;
    	classAdr := GetParentAdr(classAdr);
    End;
    classAdr := prevClassAdr;
    if classAdr<>0 then
    Begin
      recN := GetInfoRec(classAdr);
      if Assigned(recN) and Assigned(recN.vmtInfo.fields) then
      Begin
        if recN.vmtInfo.fields.Count = 1 then
        Begin
          fInfo := FieldInfo(recN.vmtInfo.fields[0]);
          if Offset = fInfo.Offset then
          Begin
            vmtAdr := classAdr;
            Result:=fInfo;
            Exit;
          End;
          Exit;
        End;
        for n := 0 to recN.vmtInfo.fields.Count - 2 do
        Begin
          fInfo1 := FieldInfo(recN.vmtInfo.fields[n]);
          fInfo2 := FieldInfo(recN.vmtInfo.fields[n + 1]);
          if (Offset >= fInfo1.Offset) and (Offset < fInfo2.Offset) then
          Begin
            if Offset = fInfo1.Offset then
            Begin
              vmtAdr := classAdr;
              Result:=fInfo1;
              Exit;
            End;
            kind := GetTypeKind(fInfo1._Type, size);
            if (kind = ikRecord) or (kind = ikArray) then
            Begin
              vmtAdr := classAdr;
              Result:= fInfo1;
              Exit;
            End;
          End;
        End;
        fInfo := FieldInfo(recN.vmtInfo.fields[recN.vmtInfo.fields.Count - 1]);
        if Offset >= fInfo.Offset then
        Begin
          if Offset = fInfo.Offset then
          Begin
            vmtAdr := classAdr;
            Result:= fInfo;
            Exit;
          End;
          kind := GetTypeKind(fInfo._Type, size);
          if (kind = ikRecord) or (kind = ikArray) then
          Begin
            vmtAdr := classAdr;
            Result:= fInfo;
            Exit;
          End;
        End;
      End;
    End;
    Exit;
  End;

  //try KB
  use := KBase.GetTypeUses(PAnsiChar(TypeName));
  idx := KBase.GetTypeIdxByModuleIds(use, PAnsiChar(TypeName));
  use:=Nil;
  if idx <> -1 then
  Begin
  	fInfo := Nil;
    idx := KBase.TypeOffsets[idx].NamId;
    if KBase.GetTypeInfo(idx, INFO_FIELDS, tInfo) then
    if Assigned(tInfo.Fields) then
    Begin
      p := tInfo.Fields;
      for n := 0 to tInfo.FieldsNum-1 do
      Begin
        //Scope
        scope := Byte(p^); 
        Inc(p);
        //offset
        Ofs := PInteger(p)^; 
        Inc(p, 4);
        if Ofs = Offset then
        Begin
        	fInfo:=FieldInfo.Create;
          fInfo.Scope := scope;
          fInfo._Case := PInteger(p)^; 
          Inc(p, 4);
          fInfo.xrefs := Nil;
          Len := PWord(p)^; 
          Inc(p, 2);
          fInfo.Name := MakeString(p, Len); 
          Inc(p, Len + 1);
          Len := PWord(p)^; 
          Inc(p, 2);
          fInfo._Type := TrimTypeName(MakeString(p, Len));
          break;
        End
        else
        Begin
          Inc(p, 4);
          Len := PWord(p)^; 
          Inc(p, 2);
          Inc(p, Len + 1);
          Len := PWord(p)^; 
          Inc(p, 2);
          Inc(p, Len + 1);
        End;
      End;
      Result:= fInfo;
      Exit;
    End;
  End;
end;

Function TFMain.AddField (ProcAdr:Integer; ProcOfs:Integer; TypeName:AnsiString; Scope:Byte; Offset, _Case:Integer; Name, _Type:AnsiString):FieldInfo;
var
  prevClassAdr,classAdr:Integer;
  recN:InfoRec;
Begin
  Result:=Nil;
  classAdr := GetClassAdr(TypeName);
  if IsValidImageAdr(classAdr) then
  begin
    if Offset < 4 then Exit;
    prevClassAdr := 0;
    while (classAdr<>0) and (Offset < GetClassSize(classAdr)) do
    begin
      prevClassAdr := classAdr;
      classAdr := GetParentAdr(classAdr);
    End;
    classAdr := prevClassAdr;
    if classAdr<>0 then
    begin
      recN := GetInfoRec(classAdr);
      if Assigned(recN) then Result:=recN.vmtInfo.AddField(ProcAdr, ProcOfs, Scope, Offset, _Case, Name, _Type);
      Exit;
    end;
  end;
end;

procedure TFMain.miUnitDumperClick(Sender : TObject);
begin
  //
end;

procedure TFMain.miFuzzyScanKBClick(Sender : TObject);
var
  recN:InfoRec;
  recU:PUnitRec;
  adr,fromAdr,toAdr,upIdx,dnIdx,upCnt,dnCnt:Integer;
begin
  FKBViewer.Position := -1;
  if CurProcAdr<>0 then
  Begin
    recN := GetInfoRec(CurProcAdr);
    if Assigned(recN) and (recN.kbIdx <> -1) then
    Begin
      FKBViewer.Position := recN.kbIdx;
      FKBViewer.ShowCode(CurProcAdr, recN.kbIdx);
      FKBViewer.Show;
      Exit;
    End;

    recU := GetUnit(CurProcAdr);
    if Assigned(recU) then
    Begin
      fromAdr := recU.fromAdr;
      toAdr := recU.toAdr;
      upIdx := -1;
      dnIdx := -1;
      upCnt := -1;
      dnCnt := -1;
      if true {recU.names.Count=0} then
      Begin
        if FKBViewer.cbUnits.Text <> '' then
          FKBViewer.cbUnitsChange(Self)
        else if recU.names.Count<>0 then
        Begin
          FKBViewer.cbUnits.Text := recU.names[0];
          FKBViewer.cbUnitsChange(Self);
        End;
        if FKBViewer.Position <> -1 then FKBViewer.Show
        else
        Begin
          for adr := CurProcAdr downto fromAdr do
          Begin
            if IsFlagSet(cfProcStart, Adr2Pos(adr)) then
            Begin
              Inc(upCnt);
              recN := GetInfoRec(adr);
              if Assigned(recN) and (recN.kbIdx <> -1) then
              Begin
                upIdx := recN.kbIdx;
                break;
              End;
            End;
          End;
          for adr := CurProcAdr to toAdr-1 do
          Begin
            if IsFlagSet(cfProcStart, Adr2Pos(adr)) then
            Begin
              Inc(dnCnt);
              recN := GetInfoRec(adr);
              if Assigned(recN) and (recN.kbIdx <> -1) then
              Begin
                dnIdx := recN.kbIdx;
                break;
              End;
            End;
          End;
          if upIdx <> -1 then
          Begin
            if dnIdx <> -1 then
            Begin
              //Up proc is nearest
              if upCnt < dnCnt then
              Begin
                FKBViewer.Position := upIdx + upCnt;
                FKBViewer.ShowCode(CurProcAdr, upIdx + upCnt);
                FKBViewer.Show;
              End
              //Down is nearest
              else
              Begin
                FKBViewer.Position := dnIdx - dnCnt;
                FKBViewer.ShowCode(CurProcAdr, dnIdx - dnCnt);
                FKBViewer.Show;
              End;
            End
            else
            Begin
              FKBViewer.Position := upIdx + upCnt;
              FKBViewer.ShowCode(CurProcAdr, upIdx + upCnt);
              FKBViewer.Show;
            End;
          End
          else if dnIdx <> -1 then
          Begin
            FKBViewer.Position := dnIdx - dnCnt;
            FKBViewer.ShowCode(CurProcAdr, dnIdx - dnCnt);
            FKBViewer.Show;
          End
          //Nothing found!
          else
          Begin
            FKBViewer.Position := -1;
            FKBViewer.ShowCode(CurProcAdr, -1);
            FKBViewer.Show;
          End;
        End;
        Exit;
      End;
    End;
  End;
end;

Procedure TFMain.InitAliases (find:Boolean);
var
  oldCursor:TCursor;
  n:Integer;
  item:AnsiString;
Begin
  oldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  if find then ResInfo.InitAliases;
  lClassName.Caption := '';
  lbAliases.Clear;
  for n := 0 to ResInfo.Aliases.Count-1 do
  begin
    item := ResInfo.Aliases[n];
    if Pos('=',item)<>0 then
      if item[Length(item)] <> '=' then lbAliases.Items.Add(item);
  end;
  cbAliases.Clear;
  n:=0;
  while true do
  begin
    if RegClasses[n].RegClass=Nil then break;
    if RegClasses[n].ClasName<>'' then
      cbAliases.Items.Add(RegClasses[n].ClasName);
    Inc(n);
  end;
  pnlAliases.Visible := false;
  lbAliases.Enabled := true;
  Screen.Cursor := oldCursor;
end;

procedure TFMain.lbAliasesDblClick(Sender : TObject);
var
  item:AnsiString;
  p:Integer;
begin
  lClassName.Caption := '';
  cbAliases.Text := '';
  item := lbAliases.Items[lbAliases.ItemIndex];
  p := Pos('=',item);
  if p<>0 then
  begin
    pnlAliases.Visible := true;
    lClassName.Caption := Copy(item,1, p - 1);
    cbAliases.Text := Copy(item,p + 1, Length(item) - p);
    lbAliases.Enabled := false;
  end;
end;

procedure TFMain.bApplyAliasClick(Sender : TObject);
begin
  ResInfo.Aliases.Values[lClassName.Caption] := cbAliases.Text;
  pnlAliases.Visible := false;
  lbAliases.Items[lbAliases.ItemIndex] := lClassName.Caption + '=' + cbAliases.Text;
  lbAliases.Enabled := true;

  //as: we any opened Forms . repaint (take into account new aliases)
  ResInfo.ReopenAllForms;
end;

procedure TFMain.bCancelAliasClick(Sender : TObject);
begin
  pnlAliases.Visible := false;
  lbAliases.Enabled := true;
end;

procedure TFMain.miLegendClick(Sender : TObject);
begin
  FLegend.ShowModal;
end;

procedure TFMain.miCopyListClick(Sender : TObject);
var
  n, m, k, u, dot, idx, usesNum:Integer;
  recN:InfoRec;
  recU:PUnitRec;
  pInfo:MProcInfo;
  outFile:TextFile;
  tmpList:TStringList;
  moduleName, importName:AnsiString;
  use:TWordDynArray;
begin
  SaveDlg.InitialDir := WrkDir;
  SaveDlg.FileName := 'units.lst';
  if SaveDlg.Execute then
  Begin
    if FileExists(SaveDlg.FileName) then
      if Application.MessageBox('File already exists. Overwrite?', 'Warning', MB_YESNO) = IDNO then Exit;
    try
      AssignFile(outFile,SaveDlg.FileName);
      Rewrite(outFile);
    except
      ShowMessage('Cannot save units list');
      Exit;
    End;
    Screen.Cursor := crHourGlass;
    tmpList := TStringList.Create;
    SetLength(use,128);
    for n := 0 to UnitsNum-1 do
    Begin
      recU := Units[n];
      for u := 0 to recU.names.Count-1 do
        if tmpList.IndexOf(recU.names[u]) = -1 then tmpList.Add(recU.names[u]);
      //Add Imports
      m := 0; 
      while m < CodeSize do 
      Begin
        if IsFlagSet(cfImport, m) then
        Begin
          recN := GetInfoRec(Pos2Adr(m));
          dot := Pos('.',recN.Name);
          importName := Copy(recN.Name,dot + 1, recN.NameLength);
          usesNum := KBase.GetProcUses(PAnsiChar(importName), use);
          for k := 0 to usesNum-1 do
          Begin
            idx := KBase.GetProcIdx(use[k], PAnsiChar(importName));
            if idx <> -1 then
            Begin
              idx := KBase.ProcOffsets[idx].NamId;
              if KBase.GetProcInfo(idx, INFO_ARGS, pInfo) then
              Begin
                moduleName := KBase.GetModuleName(pInfo.ModuleID);
                if tmpList.IndexOf(moduleName) = -1 then tmpList.Add(moduleName);
              End;
            End;
          End;
        End;
        Inc(m, 4);
      End;
      tmpList.Sort;
    End;
    //Output result
    for n := 0 to tmpList.Count-1 do
      WriteLn(outFile,tmpList[n]+'.dcu');
    use:=Nil;
    tmpList.Free;
    CloseFile(outFile);
    Screen.Cursor := crDefault;
  End;
end;

Procedure TFMain.wm_updAnalysisStatus (Var msg:TMessage);
var
  startOperation,updStatusBar:PThreadAnalysisData;
  isLastStep:BOOL;
  root:TTreeNode;
  adr:Integer;
Begin
  case ThreadAnalysisOperation(msg.WParam) of
    taStartPrBar:
      Begin
        startOperation := PThreadAnalysisData(msg.LParam);
        with pb do
        begin
          Step := 1;
          Position := 0;
          Min := 0;
        end;
        if Assigned(startOperation) then pb.Max := startOperation.pbSteps
          else pb.Max := 0;
        if Assigned(startOperation) then sb.Panels[0].Text := startOperation.sbText
          else sb.Panels[0].Text:='?';
        sb.Panels[1].Text := '';
        sb.Refresh;
        If Assigned(startOperation) then Dispose(startOperation);
      End;
    taUpdatePrBar: pb.StepIt;
    taStopPrBar:
      Begin
        pb.Position := 0;
        with sb do
        begin
          Panels[0].Text := '';
          Panels[1].Text := '';
          Refresh;
        end;
      End;
    taUpdateStBar:
      Begin
        updStatusBar := PThreadAnalysisData(msg.LParam);
        if Assigned(updStatusBar) then sb.Panels[1].Text := updStatusBar.sbText
          else sb.Panels[1].Text:='?';
        sb.Invalidate;
        if Assigned(updStatusBar) then Dispose(updStatusBar);
        Application.ProcessMessages;
      End;
    taUpdateUnits:
      Begin
        isLastStep := LongBool(msg.LParam);
        tsUnits.Enabled := true;
        ShowUnits(isLastStep);
        ShowUnitItems(GetUnit(CurUnitAdr), lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
      End;
    taUpdateRTTIs:
      Begin
        miSearchRTTI.Enabled := true;
        miSortRTTI.Enabled := true;
        tsRTTIs.Enabled := true;
        ShowRTTIs;
      End;
    taUpdateVmtList:
      Begin
        FillVmtList;
        InitAliases(true);
      End;
    taUpdateStrings:
      Begin
        tsStrings.Enabled := true;
        miSearchString.Enabled := true;
        ShowStrings(0);
        tsNames.Enabled := true;
        ShowNames(0);
      End;
    taUpdateCode:
      Begin
        tsCodeView.Enabled := true;
        bEP.Enabled := true;
        adr := CurProcAdr;
        CurProcAdr := 0;
        ShowCode(adr, lbCode.ItemIndex, -1, lbCode.TopIndex);
      End;
    taUpdateXrefs:
      Begin
        lbCXrefs.Enabled := true;
        miGoTo.Enabled := true;
        miExploreAdr.Enabled := true;
        miSwitchFlag.Enabled := cbMultipleSelection.Checked;
      End;
    taUpdateShortClassViewer:
      Begin
        tsClassView.Enabled := true;
        miViewClass.Enabled := true;
        miSearchVMT.Enabled := true;
        miCollapseAll.Enabled := true;

        rgViewerMode.ItemIndex := 1;
        rgViewerMode.Enabled := false;
      End;
    taUpdateClassViewer:
      Begin
        tsClassView.Enabled := true;
        miSearchVMT.Enabled := true;
        miCollapseAll.Enabled := true;
        if ClassTreeDone then
        Begin
          root := tvClassesFull.Items[0];
          root.Expanded := true;
          miViewClass.Enabled := true;
          rgViewerMode.ItemIndex := 0;
          rgViewerMode.Enabled := true;
        End
        else
        Begin
          miViewClass.Enabled := true;
          rgViewerMode.ItemIndex := 1;
          rgViewerMode.Enabled := false;
        End;
        miClassTreeBuilder.Enabled := true;
      End;
    taUpdateBeforeClassViewer:
      Begin
        miSearchUnit.Enabled := true;
        miRenameUnit.Enabled := true;
        miCopyList.Enabled := true;
        miKBTypeInfo.Enabled := true;
        miCtdPassword.Enabled := IsValidCodeAdr(CtdRegAdr);
        miName.Enabled := true;
        miViewProto.Enabled := true;
        miEditFunctionC.Enabled := true;
        miEditFunctionI.Enabled := true;
        miEditClass.Enabled := true;
      End;
    taFinished: AnalyzeThreadDone(Nil);
  end;
end;

Procedure TFMain.wm_dfmClosed (Var msg:TMessage);
Begin
  if not Assigned(AnalyzeThread) then sb.Panels[0].Text := '';
end;

//Fill ClassViewerTree for 1 class
Procedure TFMain.FillClassViewerOne (n:Integer; tmpList:TStringList; Var terminated:Boolean);
var
  vmtProc:Boolean;
  _dx, _bx, _si:Word;
  v,m, adr,size, sizeParent, ps, cnt, vmtOfs, _pos:Integer;
  vmtAdr, vmtAdrParent, vAdr, iAdr,intfsNum,instrlen:Integer;
  dynamicsNum,methodsNum,autoNum,virtualsNum:Integer;
  //fieldsNum:Integer;
  //fieldsNode:TTreeNode;
  //fInfo:FieldInfo;
  rootNode, node,intfsNode,autoNode,methodsNode,dynamicsNode,virtualsNode:TTreeNode;
  clsName, nodeTextParent, nodeText, line, _name:AnsiString;
  recN:InfoRec;
  recM:PMethodRec;
  recV:PVmtListRec;
  disInfo:TDisInfo;
Begin
  recV := VmtList[n];
  vmtAdr := recV.vmtAdr;
  clsName := GetClsName(vmtAdr);
  size := GetClassSize(vmtAdr); 
  if DelphiVersion >= 2009 then Inc(size, 4);

  vmtAdrParent := GetParentAdr(vmtAdr);
  sizeParent := GetClassSize(vmtAdrParent); 
  if DelphiVersion >= 2009 then Inc(sizeParent, 4);

  nodeTextParent := GetParentName(vmtAdr) + ' #' + Val2Str(vmtAdrParent,8) + ' Sz=' + Val2Str(sizeParent,1);
  nodeText := clsName + ' #' + Val2Str(vmtAdr,8) + ' Sz=' + Val2Str(size,1);
  node := FindTreeNodeByName(nodeTextParent);
  node := AddClassTreeNode(node, nodeText);

  rootNode := node;
  if Assigned(rootNode) then
  Begin
    //Interfaces
    intfsNum := LoadIntfTable(vmtAdr, tmpList);
    if intfsNum<>0 then
    Begin
      for m := 0 to intfsNum-1 do
      Begin
        if Terminated then Break;
        nodeText := tmpList[m];
        sscanf(PAnsiChar(nodeText),'%lX',[@vAdr]);
        if IsValidCodeAdr(vAdr) then
        Begin
          intfsNode := AddClassTreeNode(rootNode, '<I> ' + Copy(nodeText,Pos(' ',nodeText) + 1, Length(nodeText)));
          cnt := 0;
          ps := Adr2Pos(vAdr);
          v := 0;
          while true do
          Begin
            if IsFlagSet(cfVTable, ps) then Inc(cnt);
            if cnt = 2 then break;
            iAdr := PInteger(Code + ps)^;
            adr := iAdr;
            _pos := Adr2Pos(adr);
            vmtProc := false; 
            vmtOfs := 0;
            _dx := 0; 
            _bx := 0; 
            _si := 0;
            while true do
            Begin
              instrlen := frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
              if ((disInfo.OpType[0] = otMEM) or (disInfo.OpType[1] = otMEM)) and
                (disInfo.BaseReg <> 20) then //to exclude instruction 'xchg reg, [esp]'
                vmtOfs := disInfo.Offset;
              if (disInfo.OpType[0] = otREG) and (disInfo.OpType[1] = otIMM) then
              case disInfo.OpRegIdx[0] of
                10: _dx := disInfo.Immediate;
                11: _bx := disInfo.Immediate;
                14: _si := disInfo.Immediate;
              End;
              if disInfo.Call then
              Begin
                recN := GetInfoRec(disInfo.Immediate);
                if Assigned(recN) then
                Begin
                  if recN.SameName('@CallDynaInst') or recN.SameName('@CallDynaClass') then
                  Begin
                    if DelphiVersion <= 5 then
                      GetDynaInfo(vmtAdr, _bx, iAdr)
                    else
                      GetDynaInfo(vmtAdr, _si, iAdr);
                    break;
                  End
                  else if recN.SameName('@FindDynaInst') or recN.SameName('@FindDynaClass') then
                  Begin
                    GetDynaInfo(vmtAdr, _dx, iAdr);
                    break;
                  End;
                End;
              End;
              if disInfo.Branch and not disInfo.Conditional then
              Begin
                if IsValidImageAdr(disInfo.Immediate) then iAdr := disInfo.Immediate
                else
                Begin
                  vmtProc := true;
                  iAdr := PInteger(Code + Adr2Pos(vmtAdr - VmtSelfPtr + vmtOfs))^;
                  recM := GetMethodInfo(vmtAdr, 'V', vmtOfs);
                  if Assigned(recM) then _name := recM.name;
                End;
                break;
              End
              else if disInfo.Ret then
              Begin
                vmtProc := true;
                iAdr := PInteger(Code + Adr2Pos(vmtAdr - VmtSelfPtr + vmtOfs))^;
                recM := GetMethodInfo(vmtAdr, 'V', vmtOfs);
                if Assigned(recM) then _name := recM.name;
                break;
              End;
              Inc(_pos, instrlen); 
              Inc(adr, instrlen);
            End;
            if not vmtProc and IsValidImageAdr(iAdr) then
            Begin
              recN := GetInfoRec(iAdr);
              if Assigned(recN) and recN.HasName then
                _name := recN.Name
              else
                _name := '';
            End;
            line := 'I' + Val2Str(v,4) + ' #' + Val2Str(iAdr,8);
            if _name <> '' then line := line + ' ' + _name;
            AddClassTreeNode(intfsNode, line);
            Inc(ps, 4);
            Inc(v, 4);
          End;
        End
        else intfsNode := AddClassTreeNode(rootNode, '<I> ' + nodeText);
      End;
    End;
    if terminated then Exit;
    //Automated
    autoNum := LoadAutoTable(vmtAdr, tmpList);
    if autoNum<>0 then
    Begin
      nodeText := '<A>';
      autoNode := AddClassTreeNode(rootNode, nodeText);
      for m := 0 to autoNum-1 do 
      Begin
        if Terminated then Break;
        nodeText := tmpList[m];
        AddClassTreeNode(autoNode, nodeText);
      End;
    End;
    {
    //Fields
    fieldsNum := form.LoadFieldTable(vmtAdr, fieldsList);
    if fieldsNum<>0 then
    Begin
      node := rootNode;
      nodeText := '<F>';
      //node := form.tvClassesFull.Items.AddChild(node, nodeText);
      node := AddClassTreeNode(node, nodeText);
      TTreeNode* fieldsNode := node;
      for m := 0 to fieldsNum-1 do
      Begin
        if Terminated then Break;
        //node := fieldsNode;
        fInfo := fieldsList[m];
        nodeText := Val2Str(fInfo.Offset,5) + ' ';
        if fInfo.Name <> '' then
          nodeText := nodeText + fInfo.Name
        else
          nodeText := nodEtext + '?';
        nodeText := nodeText + ':';
        if fInfo._Type <> '' then
          nodeText := nodeText + fInfo._Type
        else
          nodeText := nodeText + '?';

        //node := form.tvClassesFull.Items.AddChild(node, nodeText);
        AddClassTreeNode(fieldsNode, nodeText);
      End;
    End;
    }
    if terminated then Exit;
    //Events
    methodsNum := LoadMethodTable(vmtAdr, tmpList);
    if methodsNum<>0 then
    Begin
      nodeText := '<E>';
      methodsNode := AddClassTreeNode(rootNode, nodeText);
      for m := 0 to methodsNum-1 do
      Begin
        if Terminated then Break;
        nodeText := tmpList[m];
        AddClassTreeNode(methodsNode, nodeText);
      End;
    End;
    if terminated then Exit;
    //Dynamics
    dynamicsNum := LoadDynamicTable(vmtAdr, tmpList);
    if dynamicsNum<>0 then
    Begin
      nodeText := '<D>';
      dynamicsNode := AddClassTreeNode(rootNode, nodeText);
      for m := 0 to dynamicsNum-1 do
      Begin
        if Terminated then Break;
        nodeText := tmpList[m];
        AddClassTreeNode(dynamicsNode, nodeText);
      End;
    End;
    if terminated then Exit;
    //Virtual
    virtualsNum := LoadVirtualTable(vmtAdr, tmpList);
    if virtualsNum<>0 then
    Begin
      nodeText := '<V>';
      virtualsNode := AddClassTreeNode(rootNode, nodeText);
      for m := 0 to virtualsNum-1 do
      Begin
        if Terminated then Break;
        nodeText := tmpList[m];
        AddClassTreeNode(virtualsNode, nodeText);
      End;
    End;
  End;
end;

Function TFMain.AddClassTreeNode (node:TTreeNode; nodeText:AnsiString):TTreeNode;
Begin
  Result:= Nil;
  if node=Nil then  //Root
    Result:= tvClassesFull.Items.Add(Nil, nodeText)
  else
    Result:= tvClassesFull.Items.AddChild(node, nodeText);
  AddTreeNodeWithName(Result, nodeText);
end;

procedure TFMain.miSaveDelphiProjectClick(Sender : TObject);
var
  _expExists,typePresent, _isForm, comment:Boolean;
  kind:LKind;
  n, m, num, dotpos, len, minValue, maxValue:Integer;
  adr, adr1, parentAdr:Integer;
  f:TextFile;
  tmpList:TList;
  intBodyLines, intUsesLines, unitsList, formList, publishedList, publicList:TStringList;
  sr:TSearchRec;
  _info:PMsgInfo;
  recU:PUnitRec;
  recN:InfoRec;
  recE:PExportNameRec;
  fInfo:FieldInfo;
  recM:PMethodRec;
  dfm:TDfm;
  cInfo:PComponentInfo;
  curDir, DelphiProjectPath, unitName, clsName, parentName, fieldName:AnsiString;
  typeName, procName, formName, dfmName, line:AnsiString;
begin
  curDir := GetCurrentDir;
  DelphiProjectPath := AppDir + 'Projects';
  if DirectoryExists(DelphiProjectPath) then
  Begin
    ChDir(DelphiProjectPath);
    if FindFirst('*.*', faArchive, sr)=0 then
    Begin
      repeat
        DeleteFile(sr.Name);
      until FindNext(sr)<>0;
      FindClose(sr);
    End;
  End
  else
  Begin
    if not CreateDir(DelphiProjectPath) then Exit;
    ChDir(DelphiProjectPath);
  End;
  Screen.Cursor := crHourGlass;
  //Save Forms
  for n := 0 to ResInfo.FormList.Count-1 do
  Begin
  	dfm := TDfm(ResInfo.FormList[n]);
    formList := TStringList.Create;
    ResInfo.GetFormAsText(dfm, formList);
    dfmName := dfm.Name;
    //If system name add F at start
    if SameText(dfmName, 'prn') then dfmName := 'F' + dfmName;
    formList.SaveToFile(dfmName + '.dfm');
    formList.Free;
  End;

  unitsList := TStringList.Create;
  for n := 0 to UnitsNum-1 do
  Begin
    recU := Units[n];
    if recU.trivial then continue;
    typePresent := false;
    _isForm := false;
    unitName := GetUnitName(recU);
    tmpList := TList.Create;
    intBodyLines := TStringList.Create;
    intUsesLines := TStringList.Create;
    //impBodyLines := TStringList.Create;
    //impUsesLines := TStringList.Create;
    publishedList := TStringList.Create;
    publicList := TStringList.Create;

    intUsesLines.Add('SysUtils');
    intUsesLines.Add('Classes');
    for adr := recU.fromAdr to recU.toAdr-1 do
    Begin
      recN := GetInfoRec(adr);
      if not Assigned(recN) then continue;
      kind := recN.kind;
      case kind of
        ikEnumeration,
        ikSet,
        ikMethod,
        ikArray,
        ikRecord,
        ikDynArray:
          begin
            typePresent := true;
            intBodyLines.Add('  '+recN.Name+' = '+FTypeInfo.GetRTTI(adr)+';');
          end;
        //class
        ikVMT:
          begin
            typePresent := true;
            clsName := recN.Name;
            publishedList.Clear;
            publicList.Clear;
 
            dfm := ResInfo.GetFormByClassName(clsName);
            if Assigned(dfm) then
            Begin
              _isForm := true;
              unitsList.Add(unitName+' in '''+unitName+'.pas'' {'+dfm.name+'};');
            End;
  
            parentAdr := GetParentAdr(adr);
            parentName := GetClsName(parentAdr);
            intBodyLines.Add('  '+clsName+' = class('+parentName+')');
  
            num := LoadFieldTable(adr, tmpList);
            for m := 0 to num-1 do
            Begin
              fInfo := FieldInfo(tmpList[m]);
              if fInfo.Name <> '' then
                fieldName := fInfo.Name
              else
                fieldName := 'f' + Val2Str(fInfo.Offset);
              if fInfo._Type <> '' then
              Begin
                comment := false;
                typeName := TrimTypeName(fInfo._Type);
              End
              else
              Begin
                comment := true;
                typeName := '?';
              End;
              if not comment then
                line := Format('    %s:%s;//f%X', [fieldName, typeName, fInfo.Offset])
              else
                line := Format('    //%s:%s;//f%X', [fieldName, typeName, fInfo.Offset]);
              if _isForm and Assigned(dfm) and dfm.IsFormComponent(fieldName) then
                publishedList.Add(line)
              else
                publicList.Add(line);
            End;
  
            num := LoadMethodTable(adr, tmpList);
            for m := 0 to num-1 do
            Begin
              recM := tmpList[m];
              recN := GetInfoRec(recM.address);
              procName := recN.MakePrototype(recM.address, true, false, false, false, false);
              if Pos(':?',procName)=0 then
                publishedList.Add('    '+ procName)
              else
                publishedList.Add('    //' + procName);
            End;
  
            num := LoadVirtualTable(adr, tmpList);
            for m := 0 to num-1 do
            Begin
              recM := tmpList[m];
              //Check if procadr from other class
              if not IsOwnVirtualMethod(adr, recM.address) then continue;
              recN := GetInfoRec(recM.address);
              procName := recN.MakeDelphiPrototype(recM.address, recM);

              line := '    ';
              if Pos(':?',procName)<>0 then line := line + '//';
              line:= line + procName;
              if recM.id >= 0 then line := line + '//v'+IntToHex(recM.id,8);
              line := line + Format('//%8.8X', [recM.address]);
              publicList.Add(line);
            End;
  
            num := LoadDynamicTable(adr, tmpList);
            for m := 0 to num-1 do
            Begin
              recM := tmpList[m];
              recN := GetInfoRec(recM.address);
              procName := recN.MakePrototype(recM.address, true, false, false, false, false);
              _info := GetMsgInfo(recM.id);
              if Assigned(_info) and (_info.msgname <> '') then
                procName := procname + ' message ' + _info.msgname + ';'
              else
                procName := procname + ' dynamic;';

              if Pos(':?',procName)=0 then
                publicList.Add('    '+ procName)
              else
                publicList.Add('    //'+ procName);
            End;
  
            if publishedList.Count<>0 then
            Begin
              intBodyLines.Add('  published');
              for m := 0 to publishedList.Count-1 do
                intBodyLines.Add(publishedList[m]);
            End;
            if publicList.Count<>0 then
            Begin
              intBodyLines.Add('  public');
              for m := 0 to publicList.Count-1 do
                intBodyLines.Add(publicList[m]);
            End;
  
            for adr1 := recU.fromAdr to recU.toAdr-1 do
            Begin
              //Skip Initialization and Finalization procs
              if (adr1 = recU.iniadr) or (adr1 = recU.finadr) then continue;
              recN := GetInfoRec(adr1);
              if not Assigned(recN) or not Assigned(recN.procInfo) then continue;
              dotpos := Pos('.',recN.Name);
              if (dotpos=0) or not SameText(clsName, Copy(recN.Name,1, dotpos - 1)) then continue;
              if ((recN.procInfo.flags and PF_VIRTUAL)<>0) or
                ((recN.procInfo.flags and PF_DYNAMIC)<>0) or
                ((recN.procInfo.flags and PF_EVENT)<>0) then
                continue;

              if (recN.kind = ikConstructor) or ((recN.procInfo.flags and PF_METHOD)<>0) then
              Begin
                procName := recN.MakePrototype(adr1, true, false, false, false, false);
                if Pos(':?',procName)=0 then
                  line := '    '+ procName
                else
                  line := '    //'+ procName;
                if intBodyLines.IndexOf(line) = -1 then
                  intBodyLines.Add(line);
              End;
            End;
            intBodyLines.Add('  end;');
            break;
          End;
      End;
      //Output information
      AssignFile(f,unitName + '.pas');
      Rewrite(f);
      OutputDecompilerHeader(f);
      WriteLn(f, 'Unit ',unitName,';');
      WriteLn(f);
      WriteLn(f, 'Interface');
      //Uses
      if intUsesLines.Count<>0 then
      Begin
        WriteLn(f, 'Uses');
        for m := 0 to intUsesLines.Count-1 do
        Begin
          if m<>0 then Write(f, ' , ');
          Write(f, intUsesLines[m]);
        End;
        WriteLn(f, ';');
        WriteLn(f);
      end;
    End;
    //Type
    if typePresent then WriteLn(f, 'Type');
    for m := 0 to intBodyLines.Count-1 do
      WriteLn(f, intBodyLines[m]);
    //Other procs (not class members)
    for adr := recU.fromAdr to recU.toAdr-1 do
    Begin
      //Skip Initialization and Finalization procs
      if (adr = recU.iniadr) or (adr = recU.finadr) then continue;
      recN := GetInfoRec(adr);
      if not Assigned(recN) or not Assigned(recN.procInfo) then continue;
      procName := recN.MakePrototype(adr, true, false, false, false, false);
      if Pos(':?',procName)=0 then
        line := '    '+ procName
      else
        line := '    //'+ procName;
      if intBodyLines.IndexOf(line) <> -1 then continue;
      WriteLn(f, line);
    End;
    WriteLn(f);
    WriteLn(f, 'Implementation');
    WriteLn(f);
    if _isForm then WriteLn(f, '{$R *.DFM}'+#13#10);
    for adr := recU.fromAdr to recU.toAdr-1 do
    Begin
      //Initialization and Finalization procs
      if (adr = recU.iniadr) or (adr = recU.finadr) then continue;
      recN := GetInfoRec(adr);
      if not Assigned(recN) or not Assigned(recN.procInfo) then continue;
      kind := recN.kind;
      if kind in [ikConstructor, ikDestructor, ikProc, ikFunc] then
      Begin
        WriteLn(f, Format('//%8.8X', [adr]));
        procName := recN.MakePrototype(adr, true, false, false, true, false);
        if Pos(':?',procName)=0 then
        Begin
          WriteLn(f, procName);
          WriteLn(f, 'Begin');
          WriteLn(f, '(*');
          OutputCode(f, adr, '', false);
          WriteLn(f, '*)');
          WriteLn(f, 'End;');
        End
        else
        Begin
          WriteLn(f, '(*',procName);
          WriteLn(f, 'Begin');
          OutputCode(f, adr, '', false);
          WriteLn(f, 'End;*)');
        End;
        WriteLn(f);
      End;
    End;

    if not recU.trivialIni or not recU.trivialFin then
    Begin
      WriteLn(f, 'Initialization');
      if not recU.trivialIni then
      Begin
        WriteLn(f, Format('//%8.8X', [recU.iniadr]));
        WriteLn(f, '(*');
        OutputCode(f, recU.iniadr, '', false);
        WriteLn(f, '*)');
      End;
      WriteLn(f, 'Finalization');
      if not recU.trivialFin then
      Begin
        WriteLn(f, Format('//%8.8X', [recU.finadr]));
        WriteLn(f, '(*');
        OutputCode(f, recU.finadr, '', false);
        WriteLn(f, '*)');
      End;
    End;

    Write(f, 'End.');
    CloseFile(f);
    tmpList.Free;
    intBodyLines.Free;
    intUsesLines.Free;
    //impBodyLines.Free;
    //impUsesLines.Free;
    publishedList.Free;
    publicList.Free;
  End;
  //dpr
  recU := Units[UnitsNum - 1];
  unitName := recU.names[0];
  AssignFile(f,unitName + '.dpr');
  Rewrite(f);
  OutputDecompilerHeader(f);

  if SourceIsLibrary then
    WriteLn(f, 'Library ',unitName,';')
  else
    WriteLn(f, 'Program ',unitName,';');
  WriteLn(f);
  WriteLn(f, 'Uses');
  WriteLn(f, '  SysUtils, Classes;');
  WriteLn(f);
  WriteLn(f, '{$R *.res}'+#13#10);
  if SourceIsLibrary then
  Begin
    _expExists := false;
    for n := 0 to ExpFuncList.Count-1 do
    Begin
      recE := ExpFuncList[n];
      adr := recE.address;
      if IsValidImageAdr(adr) then
      Begin
        WriteLn(f, Format('//%8.8X', [adr]));
        recN := GetInfoRec(adr);
        if Assigned(recN) then
        Begin
          WriteLn(f, recN.MakePrototype(adr, true, false, false, true, false));
          WriteLn(f, 'Begin');
          WriteLn(f, '(*');
          OutputCode(f, adr, '', false);
          WriteLn(f, '*)');
          WriteLn(f, 'End;'+#13#10);
          _expExists := true;
        End
        else WriteLn(f, '//No information'+#13#10);
      End;
    End;
    if _expExists then
    Begin
      WriteLn(f, 'Exports');
      for n := 0 to ExpFuncList.Count-1 do
      Begin
        recE := ExpFuncList[n];
        adr := recE.address;
        if IsValidImageAdr(adr) then
        Begin
          recN := GetInfoRec(adr);
          if Assigned(recN) then
          Begin
            Write(f, recN.Name);
            if n < ExpFuncList.Count - 1 then WriteLn(f, ',');
          End;
        End;
      End;
      WriteLn(f, ';'+#13#10);
    End;
  End;
  WriteLn(f, Format('//%8.8X', [EP]));
  WriteLn(f, 'Begin');
  WriteLn(f, '(*');
  OutputCode(f, EP, '', false);
  WriteLn(f, '*)');
  WriteLn(f, 'End.');
  CloseFile(f);
  unitsList.Free;

  ChDir(curDir);
  Screen.Cursor := crDefault;
end;

procedure TFMain.bDecompileClick(Sender : TObject);
var
  procSize:Integer;
  dEnv:TDecompileEnv;
begin
  procSize := GetProcSize(CurProcAdr);
  if procSize > 0 then
  begin
    dEnv := TDecompileEnv.Create(CurProcAdr, procSize, GetInfoRec(CurProcAdr));
    try
      dEnv.DecompileProc;
    except
      on E:Exception do
      begin
        ShowCode(dEnv.StartAdr, dEnv.ErrAdr, lbCXrefs.ItemIndex, -1);
        Application.ShowException(E);
      end;
    end;
    dEnv.OutputSourceCode;
    if dEnv.Alarm then
      tsSourceCode.Highlighted := true
    else
      tsSourceCode.Highlighted := false;
    if dEnv.ErrAdr=0 then pcWorkArea.ActivePage := tsSourceCode;
    dEnv.Free;
  end;
end;

procedure TFMain.miHex2DoubleClick(Sender : TObject);
begin
  FHex2DoubleDlg.ShowModal;
end;

procedure TFMain.acFontAllExecute(Sender : TObject);
begin
  FontsDlg.Font.Assign(lbCode.Font);
  if FontsDlg.Execute then SetupAllFonts(FontsDlg.Font);
end;

Procedure TFMain.SetupAllFonts (font:TFont);
Begin
  lbUnits.Font.Assign(font);
  lbRTTIs.Font.Assign(font);
  lbForms.Font.Assign(font);
  lbAliases.Font.Assign(font);
  lbCode.Font.Assign(font);
  lbStrings.Font.Assign(font);
  lbNames.Font.Assign(font);
  lbNXrefs.Font.Assign(font);
  lbSXrefs.Font.Assign(font);
  lbCXrefs.Font.Assign(font);
  lbSourceCode.Font.Assign(font);
  lbUnitItems.Font.Assign(font);

  tvClassesShort.Font.Assign(font);
  tvClassesFull.Font.Assign(font);
end;

procedure TFMain.pmUnitItemsPopup(Sender : TObject);
begin
  miEditFunctionI.Enabled := lbUnitItems.ItemIndex >= 0;
  miCopyAddressI.Enabled := lbUnitItems.ItemIndex >= 0;
end;

Procedure TFMain.CopyAddress (line:AnsiString; ofs, bytes:Integer);
var
  p:AnsiString;
Begin
  p:=Copy(line,ofs,bytes);
  Clipboard.Open;
  Clipboard.SetTextBuf(@p[1]);
  Clipboard.Close;
end;

procedure TFMain.miCopyAddressCodeClick(Sender : TObject);
begin
  if lbCode.ItemIndex<>0 Then CopyAddress(lbCode.Items[lbCode.ItemIndex], 2, 8);
end;

Procedure TFMain.ClearPassFlags;
Begin
  ClearFlags(cfPass0 or cfPass1 or cfPass2 or cfPass, 0, TotalSize);
end;

procedure TFMain.miCopySource2ClipboardClick(Sender : TObject);
begin
  Copy2Clipboard(lbSourceCode.Items, 0, false);
end;

procedure TFMain.pmCodePopup(Sender : TObject);
var
  ap,adr,n:Integer;
  disInfo:TDisInfo;
  recN:InfoRec;
  recX:PXrefRec;
  mi:TMenuItem;
begin
  miXRefs.Enabled := false;
  miXRefs.Clear;
  if ActiveControl = lbCode then
  begin
    if lbCode.ItemIndex <= 0 then Exit;
    sscanf(PAnsiChar(lbCode.Items[lbCode.ItemIndex])+2,'%lX',[@adr]);
    if (adr <> CurProcAdr) and IsFlagSet(cfLoc, Adr2Pos(adr)) then
    begin
      recN := GetInfoRec(adr);
      if Assigned(recN) and Assigned(recN.xrefs) and (recN.xrefs.Count > 0) then
      begin
        miXRefs.Enabled := true;
        miXRefs.Clear;
        for n := 0 to recN.xrefs.Count-1 do
        begin
          recX := recN.xrefs[n];
          adr := recX.adr + recX.offset;
          ap := Adr2Pos(adr);
          frmDisasm.Disassemble(Code + ap, adr, @disInfo, Nil);
          mi := TMenuItem.Create(pmCode);
          mi.Caption := Val2Str(adr,8) + ' ' + disInfo.Mnem;
          mi.Tag := adr;
          mi.OnClick := GoToXRef;
          miXRefs.Add(mi);
        end;
      end;
    end;
  end;
end;

Procedure TFMain.GoToXRef (Sender:TObject);
var
  mi:TMenuItem;
  adr:Integer;
  rec:PROCHISTORYREC;
Begin
  mi := TMenuItem(Sender);
  Adr := mi.Tag;
  if (Adr<>0) and IsValidCodeAdr(Adr) then
  begin
    with rec do
    begin
      adr := CurProcAdr;
      itemIdx := lbCode.ItemIndex;
      xrefIdx := lbCXrefs.ItemIndex;
      topIdx := lbCode.TopIndex;
    end;
    ShowCode(CurProcAdr, Adr, lbCXrefs.ItemIndex, -1);
    CodeHistoryPush(@rec);
  end;
end;

procedure TFMain.lbFormsClick(Sender : TObject);
begin
  RTTIsSearchFrom := lbRTTIs.ItemIndex;
  WhereSearch := SEARCH_FORMS;
end;

procedure TFMain.lbCodeClick(Sender : TObject);
var
  text,prevItem:AnsiString;
  wid,beg,stop,n,x,Len:Integer;
begin
  WhereSearch := SEARCH_CODEVIEWER;
  if lbCode.ItemIndex <= 0 then Exit;

  prevItem := SelectedAsmItem;
  SelectedAsmItem := '';
  text := lbCode.Items[lbCode.ItemIndex];
  Len := Length(text);
  x := lbCode.ScreenToClient(Mouse.CursorPos).x;
  wid:=0;
  for n := 1 to Len do
  begin
    if wid >= x then
    begin
      beg := n - 1;
      while beg >= 1 do
      begin
        if not (text[beg] in ['@','0'..'9','A'..'Z','a'..'z']) then
        begin
          Inc(beg);
          break;
        End;
        Dec(beg);
      end;
      stop:= beg;
      while stop <= Len do
      begin
        if not (text[stop] in ['@','0'..'9','A'..'Z','a'..'z']) then
        begin
          Dec(stop);
          break;
        end;
        Inc(stop);
      end;
      SelectedAsmItem := Copy(text,beg, stop - beg + 1);
      break;
    End;
    Inc(wid, lbCode.Canvas.TextWidth(text[n]));
  end;
  if SelectedAsmItem <> prevItem then lbCode.Invalidate;
end;

procedure TFMain.pcInfoChange(Sender : TObject);
begin
  case pcInfo.TabIndex of
    0: WhereSearch := SEARCH_UNITS;
    1: WhereSearch := SEARCH_RTTIS;
    2: WhereSearch := SEARCH_FORMS;
  end;
end;

procedure TFMain.pcWorkAreaChange(Sender : TObject);
begin
  case pcWorkArea.TabIndex of
    0: WhereSearch := SEARCH_CODEVIEWER;
    1: WhereSearch := SEARCH_CLASSVIEWER;
    2: WhereSearch := SEARCH_STRINGS;
    3: WhereSearch := SEARCH_NAMES;
    4: WhereSearch := SEARCH_SOURCEVIEWER;
  end;
end;

procedure TFMain.miSearchFormClick(Sender:TObject);
var
  n:Integer;
Begin
  WhereSearch := SEARCH_FORMS;
  FFindDlg.cbText.Clear;
  for n := 0 to FormsSearchList.Count-1 do
    FFindDlg.cbText.AddItem(FormsSearchList[n], Nil);
  if (FFindDlg.ShowModal = mrOk) and (FFindDlg.cbText.Text <> '') then
  begin
    if lbForms.ItemIndex = -1 then
      FormsSearchFrom := 0
    else
      FormsSearchFrom := lbForms.ItemIndex;
    FormsSearchText := FFindDlg.cbText.Text;
    if FormsSearchList.IndexOf(FormsSearchText) = -1 then FormsSearchList.Add(FormsSearchText);
    FindText(FormsSearchText);
  end;
end;

procedure TFMain.miSearchNameClick(Sender:TObject);
var
  n:Integer;
Begin
  WhereSearch := SEARCH_NAMES;
  FFindDlg.cbText.Clear;
  for n := 0 to NamesSearchList.Count-1 do
    FFindDlg.cbText.AddItem(NamesSearchList[n], Nil);
  if (FFindDlg.ShowModal = mrOk) and (FFindDlg.cbText.Text <> '') then
  begin
    if lbNames.ItemIndex = -1 then
      NamesSearchFrom := 0
    else
      NamesSearchFrom := lbNames.ItemIndex;
    NamesSearchText := FFindDlg.cbText.Text;
    if NamesSearchList.IndexOf(NamesSearchText) = -1 then NamesSearchList.Add(NamesSearchText);
    FindText(NamesSearchText);
  end;
end;

procedure TFMain.miPluginsClick(Sender : TObject);
var
  PluginsPath:AnsiString;
begin
  PluginsPath := AppDir + 'Plugins';
  if not DirectoryExists(PluginsPath) then
  begin
    if not CreateDir(PluginsPath) then
    begin
      ShowMessage('Cannot create subdirectory for plugins');
      Exit;
    end;
  end;
  ResInfo.FormPluginName := '';
  if ResInfo.hFormPlugin<>0 then
  begin
    FreeLibrary(ResInfo.hFormPlugin);
    ResInfo.hFormPlugin := 0;
  end;
  FPlugins.PluginsPath := PluginsPath;
  FPlugins.PluginName := '';
  if FPlugins.ShowModal = mrOk then ResInfo.FormPluginName := FPlugins.PluginName; //
end;

procedure TFMain.miCopyStringsClick(Sender : TObject);
begin
  Copy2Clipboard(lbStrings.Items, 0, false);
end;

procedure TFMain.miViewAllClick(Sender : TObject);
begin
  //
end;

procedure TFMain.lbSourceCodeMouseMove(Sender : TObject; Shift:TShiftState; X,Y:Integer);
begin
  if lbSourceCode.CanFocus then ActiveControl := lbSourceCode;
end;

procedure TFMain.cbMultipleSelectionClick(Sender : TObject);
begin
  //lbCode.MultiSelect := cbMultipleSelection.Checked;
  //miSwitchFlag.Enabled := cbMultipleSelection.Checked;
end;

procedure TFMain.lbSourceCodeDrawItem(Control: TWinControl; Index:Integer; Rect:TRect; State:TOwnerDrawState);
begin
{
  if (hHighlight<>0) and Assigned(HighlightDrawItem) then
    HighlightDrawItem(DelphiLbId, Index, Rect, false);
}
end;

procedure TFMain.miSwitchSkipFlagClick(Sender : TObject);
var
  adr,n:Integer;
begin
  if lbCode.SelCount > 0 then
  begin
    for n := 0 to lbCode.Count-1 do
      if lbCode.Selected[n] then
      begin
        sscanf(PAnsiChar(lbCode.Items[n])+2,'%lX',[@adr]);
        FlagList[Adr2Pos(adr)] :=FlagList[Adr2Pos(adr)] xor (cfDSkip or cfSkip);
      end;
    RedrawCode;
    ProjectModified := true;
  end;
end;

procedure TFMain.miSwitchFrameFlagClick(Sender : TObject);
var
  adr,n:Integer;
begin
  if lbCode.SelCount > 0 then
  begin
    for n := 0 to lbCode.Count-1 do
      if lbCode.Selected[n] then
      begin
        sscanf(PAnsiChar(lbCode.Items[n])+2,'%lX',[@adr]);
        FlagList[Adr2Pos(adr)] :=FlagList[Adr2Pos(adr)] xor cfFrame;
      end;
    RedrawCode;
    ProjectModified := true;
  end;
end;

procedure TFMain.cfTry1Click(Sender : TObject);
var
  adr,n:Integer;
begin
  if lbCode.SelCount > 0 then
  begin
    for n := 0 to lbCode.Count-1 do
      if lbCode.Selected[n] then
      begin
        sscanf(PAnsiChar(lbCode.Items[n])+2,'%lX',[@adr]);
        FlagList[Adr2Pos(adr)] :=FlagList[Adr2Pos(adr)] xor cfTry;
      end;
    RedrawCode;
    ProjectModified := true;
  end;
end;

procedure TFMain.miProcessDumperClick(Sender : TObject);
Begin
  FActiveProcesses.ShowProcesses;
  FActiveProcesses.ShowModal;
end;

procedure TFMain.vtUnitClick(Sender: TObject);
begin
  UnitsSearchFrom := Integer(vtUnit.FocusedNode);
  WhereSearch := SEARCH_UNITS;
end;

procedure TFMain.vtUnitCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  D1,D2:PUnitNode;
  U1,U2:PUnitRec;
begin
  D1:=Sender.GetNodeData(Node1);
  D2:=Sender.GetNodeData(Node2);
  U1:=Units[D1.unit_index];
  U2:=Units[D2.unit_index];
  Case Column Of
    0: // Address
      if U1.fromAdr < U2.fromAdr then Result:=-1
      else if U1.fromAdr > U2.fromAdr then Result:=1
      else Result:=0;
    1: // Initialization order
      if U1.iniOrder < U2.iniOrder then Result:=-1
      else if U1.iniOrder > U2.iniOrder then Result:=1
      else Result:=0;
    2: // names
      Result:=CompareStr(D1.names,D2.names);
  End;
end;

procedure TFMain.vtUnitDblClick(Sender: TObject);
var
  Data:PUnitNode;
  recU:PUnitRec;
begin
  if Assigned(vtUnit.FocusedNode) Then
  Begin
    Data:=vtUnit.GetNodeData(vtUnit.FocusedNode);
    if Assigned(Data) and Assigned(Units) Then
    Begin
      recU:=Units[Data.unit_index];
      if (CurUnitAdr=0) or (recU.fromAdr <> CurUnitAdr) then
      begin
        CurUnitAdr := recU.fromAdr;
        ShowUnitItems(recU, 0, -1);
      end
      else ShowUnitItems(recU, lbUnitItems.TopIndex, lbUnitItems.ItemIndex);
      CurUnitAdr := recU.fromAdr;
    end;
  end;
end;

procedure TFMain.vtUnitFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data:PUnitNode;
begin
  Data:=Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure TFMain.vtUnitGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  Data:PUnitNode;
  recU:PUnitRec;
begin
  CellText:='';
  Data:=Sender.GetNodeData(Node);
  if Assigned(Data) and Assigned(Units) then
  begin
    recU:=Units[Data^.unit_index];
    Case Column Of
      0: // Address
        CellText:=IntToHex(recU.fromAdr,8);
      1: // Initialization order
        CellText:=Format('.%.3d',[recU.iniOrder]);
      2: // names
        Begin
          CellText:='   '+Data.names;
          if not recU.trivialIni then CellText[1]:='I';
          if not recU.trivialFin then CellText[2]:='F';
        end;
    end;
  end;
end;

procedure TFMain.vtUnitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and Assigned(vtUnit.OnDblClick) then vtUnit.OnDblClick(Sender);
end;

procedure TFMain.vtUnitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if vtUnit.CanFocus then ActiveControl := vtUnit;
end;

procedure TFMain.vtUnitPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data:PUnitNode;
  recU:PUnitRec;
begin
  Data:=Sender.GetNodeData(Node);
  if (Column<>0) and Assigned(Data) and Assigned(Units) and Not (vsSelected in Node.States) Then
  Begin
    recU:=Units[Data^.unit_index];
    If ut_Trivial in Data.unit_type then TargetCanvas.Font.Color:=TColor($0000B0) // Dark Red
    else if ut_User in Data.unit_type then
    Begin
      If ut_Unexplore in Data.unit_type then TargetCanvas.Font.Color:=TColor($C0C0FF) //Light Red
        else TargetCanvas.Font.Color:=TColor($00B000); //Green
    end
    else TargetCanvas.Font.Color:=TColor($C08000); // Blue
  end;
end;

end.


