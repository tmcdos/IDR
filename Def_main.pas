unit Def_main;

interface

Uses Messages, Classes;

Type
  NameVersion = (nvPrimary, nvAfterScan, nvByUser);
  TChars = Set of Char;
  //Float Type
  TFloatKind = (FT_NONE, FT_SINGLE, FT_DOUBLE, FT_EXTENDED, FT_REAL, FT_COMP);
  TUnit_type = (
    ut_Trivial,  //Trivial unit
    ut_User,     //User unit
    ut_Unexplore //Unit has undefined bytes
  );
  TUnitTypes = set of TUnit_type;

//Delphi2
//(tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet,
//tkClass, tkMethod, tkWChar, tkLString, tkLWString, tkVariant)

  LKind = (
  ikUnknown,//       = $00;    //UserDefined!
  ikInteger,//       = $01;
  ikChar,//          = $02;
  ikEnumeration,//   = $03;
  ikFloat,//         = $04;
  ikString,//        = $05;   //ShortString
  ikSet,//           = $06;
  ikClass,//         = $07;
  ikMethod,//        = $08;
  ikWChar,//         = $09;
  ikLString,//       = $0A;   //String, AnsiString
  ikWString,//       = $0B;   //WideString
  ikVariant,//       = $0C;
  ikArray,//         = $0D;
  ikRecord,//        = $0E;
  ikInterface,//     = $0F;
  ikInt64,//         = $10;
  ikDynArray,//      = $11;
//>=2009
  ikUString,//		    = $12;    //UnicodeString
//>=2010
  ikClassRef,//		  = $13;
  ikPointer,//		    = $14;
  ikProcedure,//		  = $15;

  ik16,ik17,ik18,ik19,ik1A,ik1B,ik1C,ik1D,ik1E,ik1F,

// additional types
  ikCString,//       = $20;    //PChar, PAnsiChar
  ikWCString,//      = $21;    //PWideChar

  ikResString,//     = $22;
  ikVMT,//           = $23;    //VMT
  ikGUID,//          = $24;
  ikRefine,//        = $25;    //Code, but what - procedure or function?
  ikConstructor,//   = $26;
  ikDestructor,//    = $27;
  ikProc,//			    = $28;
  ikFunc,//			    = $29;

  ikLoc,//           = $2A;
  ikData,//          = $2B;
  ikDataLink,//      = $2C;    //Link to variable from other module
  ikExceptName,//    = $2D;
  ikExceptHandler,// = $2E;
  ikExceptCase,//    = $2F;
  ikSwitch,//        = $30;
  ikCase,//          = $31;
  ikFixup,//         = $32;    //Fixup (for example, TlsLast)
  ikThreadVar,//     = $33;
  ikTry//			      = $34;  	//!!!Deleted - old format!!!
  );

  ExportNameRec = record
    name:AnsiString;
    address:Integer;
    ord:WORD;
  End;
  PExportNameRec = ^ExportNameRec;

  ImportNameRec = record
    module:AnsiString;
    name:AnsiString;
    address:Integer;
  End;
  PImportNameRec = ^ImportNameRec;

  SegmentInfo = record
    Start:Integer;
    Size:Integer;
    Flags:Integer;
    Name:AnsiString;
  End;
  PSegmentInfo = ^SegmentInfo;

  FuncListRec = record
    name:AnsiString;
    codeOfs:Integer;
    codeLen:Integer;
  End;
  PFuncListRec = ^FuncListRec;

  UnitRec = record
    //~UnitRec() = delete names;
    trivial:Boolean;        //Trivial unit
	  trivialIni:Boolean;     //Initialization procedure is trivial
    trivialFin:Boolean;	    //Finalization procedure is trivial
    kb:Boolean;             //Unit is in knowledge base
    fromAdr:Integer;        //From Address
    toAdr:Integer;	        //To Address
    finadr:Integer;         //Finalization procedure address
    finSize:Integer;        //Finalization procedure size
    iniadr:Integer;         //Initialization procedure address
    iniSize:Integer;        //Initialization procedure size
    matchedPercent:Single;  //Matching procent of code in unit
    iniOrder:Integer;       //Initialization procs order
    names:TStringList;      //Possible names list
  End;
  PUnitRec = ^UnitRec;

  TypeRec = record
    kind:LKind;
    adr:Integer;
    name:AnsiString;
  end;
  PTypeRec = ^TypeRec;

  VmtListRec = record
    height:Integer;
    vmtAdr:Integer;
    vmtName:AnsiString;
  end;
  PVmtListRec = ^VmtListRec;

  //Proc navigation history record
  PROCHISTORYREC = record
    adr:Integer;            //Procedure Address
    itemIdx:Integer;      //Selected Item Index
    xrefIdx:Integer;      //Selected Xref Index
    topIdx:Integer;       //TopIndex of ListBox
  End;
  PPROCHISTORYREC = ^PROCHISTORYREC;

  //Information about registry
  RINFO = record
    result:Byte; //0 - nothing, 1 - type was set, 2 - type mismatch
    source:Char; //0 - not defined; 'L' - local var; 'A' - argument; 'M' - memory; 'I' - immediate
    value:Integer;
    _type:AnsiString;
  End;
  PRINFO = ^RINFO;
  RegList = Array[0..31] of RINFO;

  SysProcInfo = record
    name:AnsiString;
    impAdr:Integer;
  End;

  RepNameInfo = record
    index:Integer;      //Index of name in names
    counter:Integer;
  end;
  PRepNameInfo = ^RepNameInfo;

  DwordArr = Array[0..$10000000] of LongWord;
  PDWordArr = ^DWordArr;

  DelphiBplVersionRec = record
    vcl_ver:AnsiString; //digital part of version present in vclXXX file name
    rtl_ver:AnsiString; //digital part of version present in rtlXXX file name
    ver_str:AnsiString; //full string of vcl/rtl bpl from file properties
    idr_ver:Integer; //value that returns to caller
  End;

  MsgInfo = record
    id:Integer;
    typname:AnsiString;
    msgname:AnsiString;
  end;
  PMsgInfo = ^MsgInfo;

  IMAGE_IMPORT_DESCRIPTOR = packed Record
    OriginalFirstThunk:Integer;
    TimeDateStamp:Integer;
    ForwarderChain:Integer;
    DllNameRVA:Integer;
    FirstThunk:Integer;
  end;

  //structure for saving context of all registers (branch instruction)
  RContext = record
    sp:Integer;
    adr:Integer;
    registers:Array[0..31] of RINFO;
  End;
  PRContext = ^RContext;

  vtUnitNode = Record
    unit_index:Integer; // index into Units array
    has_undef:Boolean; // contains Unexplored bytes
    unit_type:TUnitTypes;
    names:AnsiString;
  end;
  PUnitNode = ^vtUnitNode;

  vtNameNode = record
    adr:Integer;
    item_name,item_type:AnsiString;
  End;
  PNameNode = ^vtNameNode;

  vtStringNode = record
    adr:Integer;
    item_name,item_type:AnsiString;
    is_resource:Boolean;
  End;
  PStringNode = ^vtStringNode;

Const
  USER_KNOWLEDGEBASE    = $80000000;
  SOURCE_LIBRARY        = $40000000;
  WM_UPDANALYSISSTATUS  = WM_USER + 100;
  WM_DFMCLOSED          = WM_USER + 101;
  DELHPI_VERSION_AUTO   = 0;

  //Internal unit types
  drStop              = 0;
  drStop_a            = $61;    //'a' - Last Tag in all files
  drStop1             = $63;    //'c'
  drUnit              = $64;    //'d'
  drUnit1             = $65;    //'e' - in implementation
  drImpType           = $66;    //'f'
  drImpVal            = $67;    //'g'
  drDLL               = $68;    //'h'
  drExport            = $69;    //'i'
  drEmbeddedProcStart = $6A;    //'j'
  drEmbeddedProcEnd   = $6B;    //'k'
  drCBlock            = $6C;    //'l'
  drFixUp             = $6D;    //'m'
  drImpTypeDef        = $6E;    //'n' - import of type definition by "A = type B"
  drUnit2             = $6F;    //'o' - ??? for D2010
  drSrc               = $70;    //'p'
  drObj               = $71;    //'q'
  drRes               = $72;    //'r'
  drAsm               = $73;    //'s' - Found in D5 Debug versions
  drStop2             = $9F;    //'_'
  drConst             = $25;    //'%'
  drResStr            = $32;    //'2'
  drType              = $2A;    //'*'
  drTypeP             = $26;    //'&'
  drProc              = $28;    //'('
  drSysProc           = $29;    //')'
  drVoid              = $40;    //'@'
  drVar               = $20;    //' '
  drThreadVar         = $31;    //'1'
  drVarC              = $27;    //'''
  drBoolRangeDef      = $41;    //'A'
  drChRangeDef        = $42;    //'B'
  drEnumDef           = $43;    //'C'
  drRangeDef          = $44;    //'D'
  drPtrDef            = $45;    //'E'
  drClassDef          = $46;    //'F'
  drObjVMTDef         = $47;    //'G'
  drProcTypeDef       = $48;    //'H'
  drFloatDef          = $49;    //'I'
  drSetDef            = $4A;    //'J'
  drShortStrDef       = $4B;    //'K'
  drArrayDef          = $4C;    //'L'
  drRecDef            = $4D;    //'M'
  drObjDef            = $4E;    //'N'
  drFileDef           = $4F;    //'O'
  drTextDef           = $50;    //'P'
  drWCharRangeDef     = $51;    //'Q' - WideChar
  drStringDef         = $52;    //'R'
  drVariantDef        = $53;    //'S'
  drInterfaceDef      = $54;    //'T'
  drWideStrDef        = $55;    //'U'
  drWideRangeDef      = $56;    //'V'

  cfUndef        = $00000000;
  cfCode         = $00000001;
  cfData         = $00000002;
  cfImport       = $00000004;
  cfCall         = $00000008;
  cfProcStart    = $00000010;
  cfProcEnd		   = $00000020;
  cfRTTI			   = $00000040;
  cfEmbedded     = $00000080;  //Calls in range of one proc (for ex. calls in FormatBuf)
  cfPass0        = $00000100;  //Initial Analyze was done
  cfFrame        = $00000200;
  cfSwitch       = $00000400;
  cfPass1        = $00000800;  //Analyze1 was done
  cfETable       = $00001000;  //Exception Table
  cfPush         = $00002000;
  cfDSkip        = $00004000;  //For Decompiler
  cfPop          = $00008000;
  cfSetA         = $00010000;  //eax setting
  cfSetD         = $00020000;  //edx setting
  cfSetC         = $00040000;  //ecx setting
  cfBracket		   = $00080000;	//Bracket (ariphmetic operation)
  cfPass2        = $00100000;  //Analyze2 was done
  cfExport       = $00200000;
  cfPass         = $00400000;  //Pass Flag (for AnalyzeArguments and Decompiler)
  cfLoc          = $00800000;  //Loc_ position
  cfTry          = $01000000;
  cfFinally      = $02000000;
  cfExcept       = $04000000;
  cfLoop         = $08000000;
  cfFinallyExit  = $10000000;  //Exit section (from try...finally construction)
  cfVTable       = $20000000;	//Flags for Interface entries (to mark start end finish of VTables)
  cfSkip         = $40000000;
  cfInstruction  = $80000000;  //Instruction begin

//XRef Type
  XREF_UNKNOWN   = $20;    //Black
  XREF_CALL      = 1;       //Blue
  XREF_JUMP      = 2;       //Green
  XREF_CONST     = 3;       //Light red

//Common
  MAXLEN		            = 100;
  MAXLINE               = 1024;
  MAXNAME               = 1024;
  MAXSTRBUFFER          = 10000;
  MAXBINTEMPLATE        = 1000;
  MAX_DISASSEMBLE       = 250000;
  MAX_ITEMS             = $10000;    //Max items number for read-write
  HISTORY_CHUNK_LENGTH  = 256;
//Search
  SEARCH_UNITS        = 0;
  SEARCH_UNITITEMS    = 1;
  SEARCH_RTTIS        = 2;
  SEARCH_CLASSVIEWER  = 3;
  SEARCH_STRINGS		  = 4;
  SEARCH_FORMS        = 5;
  SEARCH_CODEVIEWER   = 6;
  SEARCH_NAMES        = 7;
  SEARCH_SOURCEVIEWER = 8;

  DelphiVersions:Array [1..15] of Integer = (2, 3, 4, 5, 6, 7, 2005, 2006, 2007, 2009, 2010, 2011, 2012, 2013, 2014);

  delphiBplVer:Array [1..10] of DelphiBplVersionRec = (
    (vcl_ver:'vcl30.dpl';  rtl_ver:'';          ver_str:'3.0.5.53';        idr_ver:3), //no rtl30.dpl!
    (vcl_ver:'vcl40.bpl';  rtl_ver:'';          ver_str:'4.0.5.38';        idr_ver:4), //no rtl40.bpl!
    (vcl_ver:'vcl60.bpl';  rtl_ver:'rtl60.bpl'; ver_str:'6.0.6.240';       idr_ver:6),
    (vcl_ver:'vcl60.bpl';  rtl_ver:'rtl60.bpl'; ver_str:'6.0.6.243';       idr_ver:6),
    (vcl_ver:'vcl70.bpl';  rtl_ver:'rtl70.bpl'; ver_str:'7.0.4.453';       idr_ver:7),
    (vcl_ver:'vcl90.bpl';  rtl_ver:'rtl90.bpl'; ver_str:'9.0.1761.24408';  idr_ver:2005),
    (vcl_ver:'vcl100.bpl'; rtl_ver:'rtl100.bpl';ver_str:'10.0.2151.25345'; idr_ver:2006), //SP2
    (vcl_ver:'vcl100.bpl'; rtl_ver:'rtl100.bpl';ver_str:'11.0.2627.5503';  idr_ver:2007), //CodeGear
    (vcl_ver:'vcl100.bpl'; rtl_ver:'rtl100.bpl';ver_str:'11.0.2902.10471'; idr_ver:2007),
    (vcl_ver:'vcl120.bpl'; rtl_ver:'rtl120.bpl';ver_str:'12.0.3210.17555'; idr_ver:2009) //Embarcadero
  );

  WindowsMsgTab:Array [1..164] of MsgInfo = (
    (id:1;    typname:'WMCreate';               msgname:'WM_CREATE'),
    (id:2;    typname:'WMDestroy';              msgname:'WM_DESTROY'),
    (id:3;    typname:'WMMove';                 msgname:'WM_MOVE'),
    (id:5;    typname:'WMSize';                 msgname:'WM_SIZE'),
    (id:6;    typname:'WMActivate';             msgname:'WM_ACTIVATE'),
    (id:7;    typname:'WMSetFocus';             msgname:'WM_SETFOCUS'),
    (id:8;    typname:'WMKillFocus';            msgname:'WM_KILLFOCUS'),
    (id:$A;   typname:'WMEnable';               msgname:'WM_ENABLE'),
    (id:$B;   typname:'WMSetRedraw';            msgname:'WM_SETREDRAW'),
    (id:$C;   typname:'WMSetText';              msgname:'WM_SETTEXT'),
    (id:$D;   typname:'WMGetText';              msgname:'WM_GETTEXT'),
    (id:$E;   typname:'WMGetTextLength';        msgname:'WM_GETTEXTLENGTH'),
    (id:$F;   typname:'WMPaint';                msgname:'WM_PAINT'),
    (id:$10;  typname:'WMClose';                msgname:'WM_CLOSE'),
    (id:$11;  typname:'WMQueryEndSession';      msgname:'WM_QUERYENDSESSION'),
    (id:$12;  typname:'WMQuit';                 msgname:'WM_QUIT'),
    (id:$13;  typname:'WMQueryOpen';            msgname:'WM_QUERYOPEN'),
    (id:$14;  typname:'WMEraseBkgnd';           msgname:'WM_ERASEBKGND'),
    (id:$15;  typname:'WMSysColorChange';       msgname:'WM_SYSCOLORCHANGE'),
    (id:$16;  typname:'WMEndSession';           msgname:'WM_ENDSESSION'),
    (id:$17;  typname:'WMSystemError';          msgname:'WM_SYSTEMERROR'),
    (id:$18;  typname:'WMShowWindow';           msgname:'WM_SHOWWINDOW'),
    (id:$19;  typname:'WMCtlColor';             msgname:'WM_CTLCOLOR'),
    (id:$1A;  typname:'WMSettingChange';        msgname:'WM_SETTINGCHANGE'),
    (id:$1B;  typname:'WMDevModeChange';        msgname:'WM_DEVMODECHANGE'),
    (id:$1C;  typname:'WMActivateApp';          msgname:'WM_ACTIVATEAPP'),
    (id:$1D;  typname:'WMFontChange';           msgname:'WM_FONTCHANGE'),
    (id:$1E;  typname:'WMTimeChange';           msgname:'WM_TIMECHANGE'),
    (id:$1F;  typname:'WMCancelMode';           msgname:'WM_CANCELMODE'),
    (id:$20;  typname:'WMSetCursor';            msgname:'WM_SETCURSOR'),
    (id:$21;  typname:'WMMouseActivate';        msgname:'WM_MOUSEACTIVATE'),
    (id:$22;  typname:'WMChildActivate';        msgname:'WM_CHILDACTIVATE'),
    (id:$23;  typname:'WMQueueSync';            msgname:'WM_QUEUESYNC'),
    (id:$24;  typname:'WMGetMinMaxInfo';        msgname:'WM_GETMINMAXINFO'),
    (id:$26;  typname:'WMPaintIcon';            msgname:'WM_PAINTICON'),
    (id:$27;  typname:'WMEraseBkgnd';           msgname:'WM_ICONERASEBKGND'),
    (id:$28;  typname:'WMNextDlgCtl';           msgname:'WM_NEXTDLGCTL'),
    (id:$2A;  typname:'WMSpoolerStatus';        msgname:'WM_SPOOLERSTATUS'),
    (id:$2B;  typname:'WMDrawItem';             msgname:'WM_DRAWITEM'),
    (id:$2C;  typname:'WMMeasureItem';          msgname:'WM_MEASUREITEM'),
    (id:$2D;  typname:'WMDeleteItem';           msgname:'WM_DELETEITEM'),
    (id:$2E;  typname:'WMVKeyToItem';           msgname:'WM_VKEYTOITEM'),
    (id:$2F;  typname:'WMCharToItem';           msgname:'WM_CHARTOITEM'),
    (id:$30;  typname:'WMSetFont';              msgname:'WM_SETFONT'),
    (id:$31;  typname:'WMGetFont';              msgname:'WM_GETFONT'),
    (id:$32;  typname:'WMSetHotKey';            msgname:'WM_SETHOTKEY'),
    (id:$33;  typname:'WMGetHotKey';            msgname:'WM_GETHOTKEY'),
    (id:$37;  typname:'WMQueryDragIcon';        msgname:'WM_QUERYDRAGICON'),
    (id:$39;  typname:'WMCompareItem';          msgname:'WM_COMPAREITEM'),
    //($3D; '?'; 'WM_GETOBJECT'),             
    (id:$41;  typname:'WMCompacting';           msgname:'WM_COMPACTING'),
    //($44; '?'; 'WM_COMMNOTIFY'),            
    (id:$46;  typname:'WMWindowPosChangingMsg'; msgname:'WM_WINDOWPOSCHANGING'),
    (id:$47;  typname:'WMWindowPosChangedMsg';  msgname:'WM_WINDOWPOSCHANGED'),
    (id:$48;  typname:'WMPower';                msgname:'WM_POWER'),
    (id:$4A;  typname:'WMCopyData';             msgname:'WM_COPYDATA'),
    //($4B; '?'; 'WM_CANCELJOURNAL'),
    (id:$4E;  typname:'WMNotify';               msgname:'WM_NOTIFY'),
    //($50; '?'; 'WM_INPUTLANGCHANGEREQUEST'),
    //($51; '?'; 'WM_INPUTLANGCHANGE'),
    //($52; '?'; 'WM_TCARD'),          
    (id:$53;  typname:'WMHelp';                 msgname:'WM_HELP'),
    //($54; '?'; 'WM_USERCHANGED'),    
    (id:$55;  typname:'WMNotifyFormat';         msgname:'WM_NOTIFYFORMAT'),
    (id:$7B;  typname:'WMContextMenu';          msgname:'WM_CONTEXTMENU'),
    (id:$7C;  typname:'WMStyleChanging';        msgname:'WM_STYLECHANGING'),
    (id:$7D;  typname:'WMStyleChanged';         msgname:'WM_STYLECHANGED'),
    (id:$7E;  typname:'WMDisplayChange';        msgname:'WM_DISPLAYCHANGE'),
    (id:$7F;  typname:'WMGetIcon';              msgname:'WM_GETICON'),
    (id:$80;  typname:'WMSetIcon';              msgname:'WM_SETICON'),
    (id:$81;  typname:'WMNCCreate';             msgname:'WM_NCCREATE'),
    (id:$82;  typname:'WMNCDestroy';            msgname:'WM_NCDESTROY'),
    (id:$83;  typname:'WMNCCalcSize';           msgname:'WM_NCCALCSIZE'),
    (id:$84;  typname:'WMNCHitTest';            msgname:'WM_NCHITTEST'),
    (id:$85;  typname:'WMNCPaint';              msgname:'WM_NCPAINT'),
    (id:$86;  typname:'WMNCActivate';           msgname:'WM_NCACTIVATE'),
    (id:$87;  typname:'WMGetDlgCode';           msgname:'WM_GETDLGCODE'),
    (id:$A0;  typname:'WMNCMouseMove';          msgname:'WM_NCMOUSEMOVE'),
    (id:$A1;  typname:'WMNCLButtonDown';        msgname:'WM_NCLBUTTONDOWN'),
    (id:$A2;  typname:'WMNCLButtonUp';          msgname:'WM_NCLBUTTONUP'),
    (id:$A3;  typname:'WMNCLButtonDblClk';      msgname:'WM_NCLBUTTONDBLCLK'),
    (id:$A4;  typname:'WMNCRButtonDown';        msgname:'WM_NCRBUTTONDOWN'),
    (id:$A5;  typname:'WMNCRButtonUp';          msgname:'WM_NCRBUTTONUP'),
    (id:$A6;  typname:'WMNCRButtonDblClk';      msgname:'WM_NCRBUTTONDBLCLK'),
    (id:$A7;  typname:'WMNCMButtonDown';        msgname:'WM_NCMBUTTONDOWN'),
    (id:$A8;  typname:'WMNCMButtonUp';          msgname:'WM_NCMBUTTONUP'),
    (id:$A9;  typname:'WMNCMButtonDblClk';      msgname:'WM_NCMBUTTONDBLCLK'),
    (id:$100; typname:'WMKeyDown';              msgname:'WM_KEYDOWN'),
    (id:$101; typname:'WMKeyUp';                msgname:'WM_KEYUP'),
    (id:$102; typname:'WMChar';                 msgname:'WM_CHAR'),
    (id:$103; typname:'WMDeadChar';             msgname:'WM_DEADCHAR'),
    (id:$104; typname:'WMSysKeyDown';           msgname:'WM_SYSKEYDOWN'),
    (id:$105; typname:'WMSysKeyUp';             msgname:'WM_SYSKEYUP'),
    (id:$106; typname:'WMSysChar';              msgname:'WM_SYSCHAR'),
    (id:$107; typname:'WMSysDeadChar';          msgname:'WM_SYSDEADCHAR'),
    //($108; '?'; 'WM_KEYLAST'),              
    //($10D; '?'; 'WM_IME_STARTCOMPOSITION'), 
    //($10E; '?'; 'WM_IME_ENDCOMPOSITION'), 
    //($10F; '?'; 'WM_IME_COMPOSITION'),
    (id:$110; typname:'WMInitDialog';           msgname:'WM_INITDIALOG'),
    (id:$111; typname:'WMCommand';              msgname:'WM_COMMAND'),
    (id:$112; typname:'WMSysCommand';           msgname:'WM_SYSCOMMAND'),
    (id:$113; typname:'WMTimer';                msgname:'WM_TIMER'),
    (id:$114; typname:'WMHScroll';              msgname:'WM_HSCROLL'),
    (id:$115; typname:'WMVScroll';              msgname:'WM_VSCROLL'),
    (id:$116; typname:'WMInitMenu';             msgname:'WM_INITMENU'),
    (id:$117; typname:'WMInitMenuPopup';        msgname:'WM_INITMENUPOPUP'),
    (id:$11F; typname:'WMMenuSelect';           msgname:'WM_MENUSELECT'),
    (id:$120; typname:'WMMenuChar';             msgname:'WM_MENUCHAR'),
    (id:$121; typname:'WMEnterIdle';            msgname:'WM_ENTERIDLE'),
    //($122; '?'; 'WM_MENURBUTTONUP'),  
    //($123; '?'; 'WM_MENUDRAG'),       
    //($124; '?'; 'WM_MENUGETOBJECT'),  
    //($125; '?'; 'WM_UNINITMENUPOPUP'),
    //($126; '?'; 'WM_MENUCOMMAND'),    
    (id:$127; typname:'WMChangeUIState';        msgname:'WM_CHANGEUISTATE'),
    (id:$128; typname:'WMUpdateUIState';        msgname:'WM_UPDATEUISTATE'),
    (id:$129; typname:'WMQueryUIState';         msgname:'WM_QUERYUISTATE'),
    (id:$132; typname:'WMCtlColorMsgBox';       msgname:'WM_CTLCOLORMSGBOX'),
    (id:$133; typname:'WMCtlColorEdit';         msgname:'WM_CTLCOLOREDIT'),
    (id:$134; typname:'WMCtlColorListBox';      msgname:'WM_CTLCOLORLISTBOX'),
    (id:$135; typname:'WMCtlColorBtn';          msgname:'WM_CTLCOLORBTN'),
    (id:$136; typname:'WMCtlColorDlg';          msgname:'WM_CTLCOLORDLG'),
    (id:$137; typname:'WMCtlColorScrollBar';    msgname:'WM_CTLCOLORSCROLLBAR'),
    (id:$138; typname:'WMCtlColorStatic';       msgname:'WM_CTLCOLORSTATIC'),
    (id:$200; typname:'WMMouseMove';            msgname:'WM_MOUSEMOVE'),
    (id:$201; typname:'WMLButtonDown';          msgname:'WM_LBUTTONDOWN'),
    (id:$202; typname:'WMLButtonUp';            msgname:'WM_LBUTTONUP'),
    (id:$203; typname:'WMLButtonDblClk';        msgname:'WM_LBUTTONDBLCLK'),
    (id:$204; typname:'WMRButtonDown';          msgname:'WM_RBUTTONDOWN'),
    (id:$205; typname:'WMRButtonUp';            msgname:'WM_RBUTTONUP'),
    (id:$206; typname:'WMRButtonDblClk';        msgname:'WM_RBUTTONDBLCLK'),
    (id:$207; typname:'WMMButtonDown';          msgname:'WM_MBUTTONDOWN'),
    (id:$208; typname:'WMMButtonUp';            msgname:'WM_MBUTTONUP'),
    (id:$209; typname:'WMMButtonDblClk';        msgname:'WM_MBUTTONDBLCLK'),
    (id:$20A; typname:'WMMouseWheel';           msgname:'WM_MOUSEWHEEL'),
    (id:$210; typname:'WMParentNotify';         msgname:'WM_PARENTNOTIFY'),
    (id:$211; typname:'WMEnterMenuLoop';        msgname:'WM_ENTERMENULOOP'),
    (id:$212; typname:'WMExitMenuLoop';         msgname:'WM_EXITMENULOOP'),
    //($213; '?'; 'WM_NEXTMENU'),
    //($214; '?'; 'WM_SIZING'),        
    //($215; '?'; 'WM_CAPTURECHANGED'),
    //($216; '?'; 'WM_MOVING'),        
    //($218; '?'; 'WM_POWERBROADCAST'),
    //($219; '?'; 'WM_DEVICECHANGE'),  
    (id:$220; typname:'WMMDICreate';            msgname:'WM_MDICREATE'),
    (id:$221; typname:'WMMDIDestroy';           msgname:'WM_MDIDESTROY'),
    (id:$222; typname:'WMMDIActivate';          msgname:'WM_MDIACTIVATE'),
    (id:$223; typname:'WMMDIRestore';           msgname:'WM_MDIRESTORE'),
    (id:$224; typname:'WMMDINext';              msgname:'WM_MDINEXT'),
    (id:$225; typname:'WMMDIMaximize';          msgname:'WM_MDIMAXIMIZE'),
    (id:$226; typname:'WMMDITile';              msgname:'WM_MDITILE'),
    (id:$227; typname:'WMMDICascade';           msgname:'WM_MDICASCADE'),
    (id:$228; typname:'WMMDIIconArrange';       msgname:'WM_MDIICONARRANGE'),
    (id:$229; typname:'WMMDIGetActive';         msgname:'WM_MDIGETACTIVE'),
    (id:$230; typname:'WMMDISetMenu';           msgname:'WM_MDISETMENU'),
    //($231; '?'; 'WM_ENTERSIZEMOVE'),       
    //($232; '?'; 'WM_EXITSIZEMOVE'),        
    (id:$233; typname:'WMDropFiles';            msgname:'WM_DROPFILES'),
    (id:$234; typname:'WMMDIRefreshMenu';       msgname:'WM_MDIREFRESHMENU'),
    //($281; '?'; 'WM_IME_SETCONTEXT'),      
    //($282; '?'; 'WM_IME_NOTIFY'),          
    //($283; '?'; 'WM_IME_CONTROL'),         
    //($284; '?'; 'WM_IME_COMPOSITIONFULL'), 
    //($285; '?'; 'WM_IME_SELECT'), 
    //($286; '?'; 'WM_IME_CHAR'),   
    //($288; '?'; 'WM_IME_REQUEST'),
    //($290; '?'; 'WM_IME_KEYDOWN'),
    //($291; '?'; 'WM_IME_KEYUP'), 
    //($2A1; '?'; 'WM_MOUSEHOVER'),
    //($2A3; '?'; 'WM_MOUSELEAVE'),
    (id:$300; typname:'WMCut';                  msgname:'WM_CUT'),
    (id:$301; typname:'WMCopy';                 msgname:'WM_COPY'),
    (id:$302; typname:'WMPaste';                msgname:'WM_PASTE'),
    (id:$303; typname:'WMClear';                msgname:'WM_CLEAR'),
    (id:$304; typname:'WMUndo';                 msgname:'WM_UNDO'),
    (id:$305; typname:'WMRenderFormat';         msgname:'WM_RENDERFORMAT'),
    (id:$306; typname:'WMRenderAllFormats';     msgname:'WM_RENDERALLFORMATS'),
    (id:$307; typname:'WMDestroyClipboard';     msgname:'WM_DESTROYCLIPBOARD'),
    (id:$308; typname:'WMDrawClipboard';        msgname:'WM_DRAWCLIPBOARD'),
    (id:$309; typname:'WMPaintClipboard';       msgname:'WM_PAINTCLIPBOARD'),
    (id:$30A; typname:'WMVScrollClipboard';     msgname:'WM_VSCROLLCLIPBOARD'),
    (id:$30B; typname:'WMSizeClipboard';        msgname:'WM_SIZECLIPBOARD'),
    (id:$30C; typname:'WMAskCBFormatName';      msgname:'WM_ASKCBFORMATNAME'),
    (id:$30D; typname:'WMChangeCBChain';        msgname:'WM_CHANGECBCHAIN'),
    (id:$30E; typname:'WMHScrollClipboard';     msgname:'WM_HSCROLLCLIPBOARD'),
    (id:$30F; typname:'WMQueryNewPalette';      msgname:'WM_QUERYNEWPALETTE'),
    (id:$310; typname:'WMPaletteIsChanging';    msgname:'WM_PALETTEISCHANGING'),
    (id:$311; typname:'WMPaletteChanged';       msgname:'WM_PALETTECHANGED'),
    (id:$312; typname:'WMHotKey';               msgname:'WM_HOTKEY'),
    //($317; '?'; 'WM_PRINT'),
    //($318; '?'; 'WM_PRINTCLIENT'),
    //($358; '?'; 'WM_HANDHELDFIRST'),
    //($35F; '?'; 'WM_HANDHELDLAST'),
    //($380; '?'; 'WM_PENWINFIRST'),
    //($38F; '?'; 'WM_PENWINLAST'),
    //($390; '?'; 'WM_COALESCE_FIRST'),
    //($39F; '?'; 'WM_COALESCE_LAST'),
    (id:$3E0; typname:'WMDDE_Initiate';         msgname:'WM_DDE_INITIATE'),
    (id:$3E1; typname:'WMDDE_Terminate';        msgname:'WM_DDE_TERMINATE'),
    (id:$3E2; typname:'WMDDE_Advise';           msgname:'WM_DDE_ADVISE'),
    (id:$3E3; typname:'WMDDE_UnAdvise';         msgname:'WM_DDE_UNADVISE'),
    (id:$3E4; typname:'WMDDE_Ack';              msgname:'WM_DDE_ACK'),
    (id:$3E5; typname:'WMDDE_Data';             msgname:'WM_DDE_DATA'),
    (id:$3E6; typname:'WMDDE_Request';          msgname:'WM_DDE_REQUEST'),
    (id:$3E7; typname:'WMDDE_Poke';             msgname:'WM_DDE_POKE'),
    (id:$3E8; typname:'WMDDE_Execute';          msgname:'WM_DDE_EXECUTE')
  );

  VCLControlsMsgTab:Array[1..70] of MsgInfo = (
    (id:$B000; typname:'CMActivate';              msgname:'CM_ACTIVATE'),
    (id:$B001; typname:'CMDeactivate';            msgname:'CM_DEACTIVATE'),
    (id:$B002; typname:'CMGotFocus';              msgname:'CM_GOTFOCUS'),
    (id:$B003; typname:'CMLostFocus';             msgname:'CM_LOSTFOCUS'),
    (id:$B004; typname:'CMCancelMode';            msgname:'CM_CANCELMODE'),
    (id:$B005; typname:'CMDialogKey';             msgname:'CM_DIALOGKEY'),
    (id:$B006; typname:'CMDialogChar';            msgname:'CM_DIALOGCHAR'),
    (id:$B007; typname:'CMFocusChenged';          msgname:'CM_FOCUSCHANGED'),
    (id:$B008; typname:'CMParentFontChanged';     msgname:'CM_PARENTFONTCHANGED'),
    (id:$B009; typname:'CMParentColorChanged';    msgname:'CM_PARENTCOLORCHANGED'),
    (id:$B00A; typname:'CMHitTest';               msgname:'CM_HITTEST'),
    (id:$B00B; typname:'CMVisibleChanged';        msgname:'CM_VISIBLECHANGED'),
    (id:$B00C; typname:'CMEnabledChanged';        msgname:'CM_ENABLEDCHANGED'),
    (id:$B00D; typname:'CMColorChanged';          msgname:'CM_COLORCHANGED'),
    (id:$B00E; typname:'CMFontChanged';           msgname:'CM_FONTCHANGED'),
    (id:$B00F; typname:'CMCursorChanged';         msgname:'CM_CURSORCHANGED'),
    (id:$B010; typname:'CMCtl3DChanged';          msgname:'CM_CTL3DCHANGED'),
    (id:$B011; typname:'CMParentCtl3DChanged';    msgname:'CM_PARENTCTL3DCHANGED'),
    (id:$B012; typname:'CMTextChanged';           msgname:'CM_TEXTCHANGED'),
    (id:$B013; typname:'CMMouseEnter';            msgname:'CM_MOUSEENTER'),
    (id:$B014; typname:'CMMouseLeave';            msgname:'CM_MOUSELEAVE'),
    (id:$B015; typname:'CMMenuChanged';           msgname:'CM_MENUCHANGED'),
    (id:$B016; typname:'CMAppKeyDown';            msgname:'CM_APPKEYDOWN'),
    (id:$B017; typname:'CMAppSysCommand';         msgname:'CM_APPSYSCOMMAND'),
    (id:$B018; typname:'CMButtonPressed';         msgname:'CM_BUTTONPRESSED'),
    (id:$B019; typname:'CMShowingChanged';        msgname:'CM_SHOWINGCHANGED'),
    (id:$B01A; typname:'CMEnter';                 msgname:'CM_ENTER'),
    (id:$B01B; typname:'CMExit';                  msgname:'CM_EXIT'),
    (id:$B01C; typname:'CMDesignHitTest';         msgname:'CM_DESIGNHITTEST'),
    (id:$B01D; typname:'CMIconChanged';           msgname:'CM_ICONCHANGED'),
    (id:$B01E; typname:'CMWantSpecialKey';        msgname:'CM_WANTSPECIALKEY'),
    (id:$B01F; typname:'CMInvokeHelp';            msgname:'CM_INVOKEHELP'),
    (id:$B020; typname:'CMWondowHook';            msgname:'CM_WINDOWHOOK'),
    (id:$B021; typname:'CMRelease';               msgname:'CM_RELEASE'),
    (id:$B022; typname:'CMShowHintChanged';       msgname:'CM_SHOWHINTCHANGED'),
    (id:$B023; typname:'CMParentShowHintChanged'; msgname:'CM_PARENTSHOWHINTCHANGED'),
    (id:$B024; typname:'CMSysColorChange';        msgname:'CM_SYSCOLORCHANGE'),
    (id:$B025; typname:'CMWinIniChange';          msgname:'CM_WININICHANGE'),
    (id:$B026; typname:'CMFontChange';            msgname:'CM_FONTCHANGE'),
    (id:$B027; typname:'CMTimeChange';            msgname:'CM_TIMECHANGE'),
    (id:$B028; typname:'CMTabStopChanged';        msgname:'CM_TABSTOPCHANGED'),
    (id:$B029; typname:'CMUIActivate';            msgname:'CM_UIACTIVATE'),
    (id:$B02A; typname:'CMUIDeactivate';          msgname:'CM_UIDEACTIVATE'),
    (id:$B02B; typname:'CMDocWindowActivate';     msgname:'CM_DOCWINDOWACTIVATE'),
    (id:$B02C; typname:'CMControlLIstChange';     msgname:'CM_CONTROLLISTCHANGE'),
    (id:$B02D; typname:'CMGetDataLink';           msgname:'CM_GETDATALINK'),
    (id:$B02E; typname:'CMChildKey';              msgname:'CM_CHILDKEY'),
    (id:$B02F; typname:'CMDrag';                  msgname:'CM_DRAG'),
    (id:$B030; typname:'CMHintShow';              msgname:'CM_HINTSHOW'),
    (id:$B031; typname:'CMDialogHanlde';          msgname:'CM_DIALOGHANDLE'),
    (id:$B032; typname:'CMIsToolControl';         msgname:'CM_ISTOOLCONTROL'),
    (id:$B033; typname:'CMRecreateWnd';           msgname:'CM_RECREATEWND'),
    (id:$B034; typname:'CMInvalidate';            msgname:'CM_INVALIDATE'),
    (id:$B035; typname:'CMSysFontChanged';        msgname:'CM_SYSFONTCHANGED'),
    (id:$B036; typname:'CMControlChange';         msgname:'CM_CONTROLCHANGE'),
    (id:$B037; typname:'CMChanged';               msgname:'CM_CHANGED'),
    (id:$B038; typname:'CMDockClient';            msgname:'CM_DOCKCLIENT'),
    (id:$B039; typname:'CMUndockClient';          msgname:'CM_UNDOCKCLIENT'),
    (id:$B03A; typname:'CMFloat';                 msgname:'CM_FLOAT'),
    (id:$B03B; typname:'CMBorderChanged';         msgname:'CM_BORDERCHANGED'),
    (id:$B03C; typname:'CMBiDiModeChanged';       msgname:'CM_BIDIMODECHANGED'),
    (id:$B03D; typname:'CMParentBiDiModeChanged'; msgname:'CM_PARENTBIDIMODECHANGED'),
    (id:$B03E; typname:'CMAllChildrenFlipped';    msgname:'CM_ALLCHILDRENFLIPPED'),
    (id:$B03F; typname:'CMActionUpdate';          msgname:'CM_ACTIONUPDATE'),
    (id:$B040; typname:'CMActionExecute';         msgname:'CM_ACTIONEXECUTE'),
    (id:$B041; typname:'CMHintShowPause';         msgname:'CM_HINTSHOWPAUSE'),
    (id:$B044; typname:'CMDockNotification';      msgname:'CM_DOCKNOTIFICATION'),
    (id:$B043; typname:'CMMouseWheel';            msgname:'CM_MOUSEWHEEL'),
    (id:$B044; typname:'CMIsShortcut';            msgname:'CM_ISSHORTCUT'),
    (id:$B045; typname:'CMRawX11Event';           msgname:'CM_RAWX11EVENT')
  );

  IMAGE_NT_OPTIONAL_HDR32_MAGIC = $10B;

  TRIV_UNIT  = 1;	//Trivial unit
  USER_UNIT  = 2; //User unit
  UNEXP_UNIT = 4; //Unit has undefined bytes

  HEX_COMENT = '0x'; // or '$'
  COMENT_QUOTE = ''''; // or '"'

var
  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

Function GetCtx(Ctx:TList;Adr:Integer):PRContext;
procedure SetRegisterValue(var regs:RegList;Idx,Value:Integer);
procedure SetRegisterType(var regs:RegList;Idx:Integer;const Value:AnsiString);
procedure SetRegisterSource(Var regs:RegList;Idx:Integer;Value:Char);

implementation

Function GetCtx(Ctx:TList;Adr:Integer):PRContext;
var
  n:Integer;
Begin
  for n:=0 to Ctx.Count-1 do
  Begin
    Result:=Ctx[n];
    if Result.adr = Adr then Exit;
  end;
  Result:=Nil;
end;

procedure SetRegisterValue(var regs:RegList;Idx,Value:Integer);
Begin
  if (Idx >= 16) and (Idx <= 19) then
  begin
    regs[Idx - 16].value := Value;
    regs[Idx - 12].value := Value;
    regs[Idx - 8].value := Value;
    regs[Idx].value := Value;
  end
  Else if (Idx >= 20) and (Idx <= 23) then
  begin
    regs[Idx - 8].value := Value;
    regs[Idx].value := Value;
  end
  Else if (Idx >= 0) and (Idx <= 3) then
  begin
    regs[Idx].value := Value;
    regs[Idx + 8].value := Value;
    regs[Idx + 16].value := Value;
  end
  else if (Idx >= 4) and (Idx <= 7) then
  begin
    regs[Idx].value := Value;
    regs[Idx + 4].value := Value;
    regs[Idx + 12].value := Value;
  end
  else if (Idx >= 8) and (Idx <= 11) then
  begin
    regs[Idx - 8].value := Value;
    regs[Idx - 4].value := Value;
    regs[Idx].value := Value;
    regs[Idx + 8].value := Value;
  end
  else if (Idx >= 12) and (Idx <= 15) then
  begin
    regs[Idx].value := Value;
    regs[Idx + 8].value := Value;
  end;
end;

procedure SetRegisterType(var regs:RegList;Idx:Integer;const Value:AnsiString);
Begin
  if (Idx >= 16) and (Idx <= 19) then
  begin
    regs[Idx - 16]._type := Value;
    regs[Idx - 12]._type := Value;
    regs[Idx - 8]._type := Value;
    regs[Idx]._type := Value;
  end
  Else if (Idx >= 20) and (Idx <= 23) then
  begin
    regs[Idx - 8]._type := Value;
    regs[Idx]._type := Value;
  end
  else if (Idx >= 0) and (Idx <= 3) then
  begin
    regs[Idx]._type := Value;
    regs[Idx + 8]._type := Value;
    regs[Idx + 16]._type := Value;
  end
  else if (Idx >= 4) and (Idx <= 7) then
  begin
    regs[Idx]._type := Value;
    regs[Idx + 4]._type := Value;
    regs[Idx + 12]._type := Value;
  end
  else if (Idx >= 8) and (Idx <= 11) then
  begin
    regs[Idx - 8]._type := Value;
    regs[Idx - 4]._type := Value;
    regs[Idx]._type := Value;
    regs[Idx + 8]._type := Value;
  end
  else if (Idx >= 12) and (Idx <= 15) then
  begin
    regs[Idx]._type := Value;
    regs[Idx + 8]._type := Value;
  end;
end;

//Possible values
//'V' - Virtual table base (for calls processing)
//'v' - var
//'L' - lea local var
//'l' - local var
//'A' - lea argument
//'a' - argument
//'I' - Integer
procedure SetRegisterSource(var regs:RegList;Idx:Integer;Value:Char);
Begin
  if (Idx >= 16) and (Idx <= 19) then
  begin
    regs[Idx - 16].source := Value;
    regs[Idx - 12].source := Value;
    regs[Idx - 8].source := Value;
    regs[Idx].source := Value;
  end
  else if (Idx >= 20) and (Idx <= 23) then
  begin
    regs[Idx - 8].source := Value;
    regs[Idx].source := Value;
  end
  Else if (Idx >= 0) and (Idx <= 3) then
  begin
    regs[Idx].source := Value;
    regs[Idx + 8].source := Value;
    regs[Idx + 16].source := Value;
  end
  Else if (Idx >= 4) and (Idx <= 7) then
  begin
    regs[Idx].source := Value;
    regs[Idx + 4].source := Value;
    regs[Idx + 12].source := Value;
  end
  else if (Idx >= 8) and (Idx <= 11) then
  begin
    regs[Idx - 8].source := Value;
    regs[Idx - 4].source := Value;
    regs[Idx].source := Value;
    regs[Idx + 8].source := Value;
  end
  Else if (Idx >= 12) and (Idx <= 15) then
  begin
    regs[Idx].source := Value;
    regs[Idx + 8].source := Value;
  End;
end;

end.
