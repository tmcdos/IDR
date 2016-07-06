object FMain: TFMain
  Left = 283
  Top = 152
  Width = 1129
  Height = 829
  Caption = 'Interactive Delphi Reconstructor'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SplitterH1: TSplitter
    Left = 0
    Top = 599
    Width = 1121
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Color = clNavy
    MinSize = 100
    ParentColor = False
  end
  object SplitterV1: TSplitter
    Left = 215
    Top = 0
    Height = 584
    AutoSnap = False
    Color = clNavy
    MinSize = 3
    ParentColor = False
  end
  object pcWorkArea: TPageControl
    Left = 218
    Top = 0
    Width = 903
    Height = 584
    ActivePage = tsStrings
    Align = alClient
    TabOrder = 1
    OnChange = pcWorkAreaChange
    object tsCodeView: TTabSheet
      Caption = 'CodeViewer (F6)'
      object lbCode: TListBox
        Left = 0
        Top = 25
        Width = 785
        Height = 531
        Cursor = crIBeam
        Style = lbOwnerDrawFixed
        AutoComplete = False
        Align = alClient
        Color = clWhite
        ExtendedSelect = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        ParentShowHint = False
        PopupMenu = pmCode
        ShowHint = False
        TabOrder = 0
        OnClick = lbCodeClick
        OnDblClick = lbCodeDblClick
        OnDrawItem = lbCodeDrawItem
        OnKeyDown = lbCodeKeyDown
        OnMouseMove = lbCodeMouseMove
      end
      object CodePanel: TPanel
        Left = 0
        Top = 0
        Width = 895
        Height = 25
        Align = alTop
        PopupMenu = pmCodePanel
        TabOrder = 1
        object lProcName: TLabel
          Left = 128
          Top = 6
          Width = 59
          Height = 13
          Caption = 'ProcName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object bEP: TButton
          Left = 2
          Top = 2
          Width = 22
          Height = 22
          Hint = 'Go to Program Entry Point'
          Caption = 'EP'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = bEPClick
        end
        object bCodePrev: TButton
          Left = 24
          Top = 2
          Width = 23
          Height = 22
          Hint = 'Previous Subroutine'
          Caption = '<-'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = bCodePrevClick
        end
        object ShowCXrefs: TPanel
          Left = 783
          Top = 1
          Width = 111
          Height = 23
          Align = alRight
          BevelOuter = bvLowered
          Caption = 'XRefs'
          TabOrder = 2
          OnClick = ShowCXrefsClick
        end
        object bCodeNext: TButton
          Left = 47
          Top = 2
          Width = 23
          Height = 22
          Hint = 'Next Subroutine'
          Caption = '->'
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = bCodeNextClick
        end
        object bDecompile: TButton
          Left = 70
          Top = 2
          Width = 23
          Height = 22
          Hint = 'Decompiled source code'
          Caption = 'Src'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = bDecompileClick
        end
        object cbMultipleSelection: TCheckBox
          Left = 98
          Top = 7
          Width = 13
          Height = 13
          Hint = 'Multiple Selection'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = cbMultipleSelectionClick
        end
      end
      object lbCXrefs: TListBox
        Left = 785
        Top = 25
        Width = 110
        Height = 531
        Style = lbOwnerDrawFixed
        Align = alRight
        Color = clWhite
        Constraints.MinWidth = 100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 2
        OnDblClick = lbXrefsDblClick
        OnDrawItem = lbXrefsDrawItem
        OnKeyDown = lbXrefsKeyDown
        OnMouseMove = lbXrefsMouseMove
      end
    end
    object tsClassView: TTabSheet
      Caption = 'ClassViewer (F7)'
      ImageIndex = 1
      object tvClassesFull: TTreeView
        Left = 0
        Top = 40
        Width = 895
        Height = 516
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        HideSelection = False
        Indent = 19
        ParentFont = False
        PopupMenu = pmVMTs
        ReadOnly = True
        TabOrder = 0
        ToolTips = False
        OnClick = tvClassesFullClick
        OnDblClick = tvClassesDblClick
        OnMouseMove = tvClassesFullMouseMove
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 895
        Height = 40
        Align = alTop
        TabOrder = 1
        object rgViewerMode: TRadioGroup
          Left = 1
          Top = 1
          Width = 185
          Height = 38
          Align = alLeft
          Columns = 2
          ItemIndex = 1
          Items.Strings = (
            'Tree'
            'Branch')
          TabOrder = 0
          OnClick = rgViewerModeClick
        end
      end
      object tvClassesShort: TTreeView
        Left = 0
        Top = 40
        Width = 895
        Height = 516
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        HideSelection = False
        Indent = 22
        ParentFont = False
        PopupMenu = pmVMTs
        ReadOnly = True
        TabOrder = 2
        ToolTips = False
        OnClick = tvClassesShortClick
        OnDblClick = tvClassesDblClick
        OnKeyDown = tvClassesShortKeyDown
        OnMouseMove = tvClassesShortMouseMove
      end
    end
    object tsStrings: TTabSheet
      Caption = 'Strings (F8)'
      ImageIndex = 2
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 895
        Height = 25
        Align = alTop
        TabOrder = 0
        object ShowSXrefs: TPanel
          Left = 784
          Top = 1
          Width = 110
          Height = 23
          Align = alRight
          BevelOuter = bvLowered
          Caption = 'XRefs'
          TabOrder = 0
          OnClick = ShowSXrefsClick
        end
      end
      object lbSXrefs: TListBox
        Left = 785
        Top = 25
        Width = 110
        Height = 531
        Style = lbOwnerDrawFixed
        Align = alRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 1
        OnDblClick = lbXrefsDblClick
        OnDrawItem = lbXrefsDrawItem
        OnKeyDown = lbXrefsKeyDown
        OnMouseMove = lbXrefsMouseMove
      end
      object vtString: TVirtualStringTree
        Left = 0
        Top = 25
        Width = 785
        Height = 531
        Align = alClient
        DefaultText = 'Node'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Header.AutoSizeIndex = 2
        Header.Columns = <
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 0
            Text = 'Address'
            Width = 80
          end
          item
            Hint = 'Kind of string'
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 1
            Text = 'Type'
            Width = 90
          end
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coAllowFocus, coDisableAnimatedResize]
            Position = 2
            Text = 'String value'
            Width = 200
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoShowHint, hoShowSortGlyphs, hoVisible, hoFullRepaintOnResize, hoHeaderClickAutoSort]
        Header.SortColumn = 0
        Margin = 0
        ParentFont = False
        ParentShowHint = False
        PopupMenu = pmStrings
        ScrollBarOptions.AlwaysVisible = True
        ShowHint = True
        TabOrder = 2
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toFullRowDrag]
        TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect, toSimpleDrawSelection, toAlwaysSelectNode]
        OnClick = vtStringClick
        OnCompareNodes = vtStringCompareNodes
        OnDblClick = vtStringDblClick
        OnFocusChanged = vtStringFocusChanged
        OnFreeNode = vtStringFreeNode
        OnGetText = vtStringGetText
        OnPaintText = vtStringPaintText
        OnMouseMove = vtUnitMouseMove
      end
    end
    object tsItems: TTabSheet
      Caption = 'Items'
      ImageIndex = 3
      TabVisible = False
      object sgItems: TStringGrid
        Left = 0
        Top = 0
        Width = 853
        Height = 462
        Align = alClient
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        ColWidths = (
          64
          64
          64
          538
          21)
      end
    end
    object tsNames: TTabSheet
      Caption = 'Names (F9)'
      ImageIndex = 4
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 895
        Height = 25
        Align = alTop
        TabOrder = 0
        object ShowNXrefs: TPanel
          Left = 784
          Top = 1
          Width = 110
          Height = 23
          Align = alRight
          BevelOuter = bvLowered
          Caption = 'XRefs'
          TabOrder = 0
          OnClick = ShowSXrefsClick
        end
      end
      object lbNXrefs: TListBox
        Left = 785
        Top = 25
        Width = 110
        Height = 531
        Style = lbOwnerDrawFixed
        Align = alRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 1
        OnDblClick = lbXrefsDblClick
        OnDrawItem = lbXrefsDrawItem
        OnKeyDown = lbXrefsKeyDown
        OnMouseMove = lbXrefsMouseMove
      end
      object vtName: TVirtualStringTree
        Left = 0
        Top = 25
        Width = 785
        Height = 531
        Align = alClient
        DefaultText = 'Node'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Header.AutoSizeIndex = 1
        Header.Columns = <
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 0
            Text = 'Address'
            Width = 80
          end
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 1
            Text = 'Name'
            Width = 200
          end
          item
            Hint = 'Item typedef'
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coAllowFocus, coDisableAnimatedResize]
            Position = 2
            Text = 'Type'
            Width = 60
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoShowHint, hoShowSortGlyphs, hoVisible, hoFullRepaintOnResize, hoHeaderClickAutoSort]
        Header.SortColumn = 0
        Margin = 0
        ParentFont = False
        ParentShowHint = False
        ScrollBarOptions.AlwaysVisible = True
        ShowHint = True
        TabOrder = 2
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toFullRowDrag]
        TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect, toSimpleDrawSelection, toAlwaysSelectNode]
        OnClick = vtNameClick
        OnCompareNodes = vtNameCompareNodes
        OnFocusChanged = vtNameFocusChanged
        OnFreeNode = vtNameFreeNode
        OnGetText = vtNameGetText
        OnMouseMove = vtUnitMouseMove
      end
    end
    object tsSourceCode: TTabSheet
      Caption = 'SourceCode (F10)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 5
      ParentFont = False
      object lbSourceCode: TListBox
        Left = 0
        Top = 0
        Width = 895
        Height = 544
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        IntegralHeight = True
        ItemHeight = 15
        ParentFont = False
        PopupMenu = pmSourceCode
        TabOrder = 0
        OnDrawItem = lbSourceCodeDrawItem
        OnMouseMove = lbSourceCodeMouseMove
      end
    end
  end
  object pcInfo: TPageControl
    Left = 0
    Top = 0
    Width = 215
    Height = 584
    ActivePage = tsRTTIs
    Align = alLeft
    Constraints.MinWidth = 200
    TabOrder = 0
    OnChange = pcInfoChange
    object tsUnits: TTabSheet
      Caption = 'Units (F2)'
      object vtUnit: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 207
        Height = 556
        Align = alClient
        DefaultText = 'Node'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Header.AutoSizeIndex = 2
        Header.Columns = <
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 0
            Text = 'Address'
            Width = 80
          end
          item
            Hint = 'Initialization order'
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 1
            Text = 'Order'
          end
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coAllowFocus, coDisableAnimatedResize]
            Position = 2
            Text = 'Name'
            Width = 57
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoShowHint, hoShowSortGlyphs, hoVisible, hoFullRepaintOnResize, hoHeaderClickAutoSort]
        Header.SortColumn = 0
        Margin = 0
        ParentFont = False
        ParentShowHint = False
        PopupMenu = pmUnits
        ScrollBarOptions.AlwaysVisible = True
        ShowHint = True
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toFullRowDrag]
        TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect, toSimpleDrawSelection, toAlwaysSelectNode]
        OnClick = vtUnitClick
        OnCompareNodes = vtUnitCompareNodes
        OnDblClick = vtUnitDblClick
        OnFreeNode = vtUnitFreeNode
        OnGetText = vtUnitGetText
        OnPaintText = vtUnitPaintText
        OnKeyDown = vtUnitKeyDown
        OnMouseMove = vtUnitMouseMove
      end
    end
    object tsRTTIs: TTabSheet
      Caption = 'Types (F4)'
      ImageIndex = 1
      object vtRTTI: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 207
        Height = 556
        Align = alClient
        DefaultText = 'Node'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Header.AutoSizeIndex = 2
        Header.Columns = <
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 0
            Text = 'Address'
            Width = 80
          end
          item
            Hint = 'Item typedef'
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
            Position = 1
            Text = 'Type'
            Width = 80
          end
          item
            Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coAllowFocus, coDisableAnimatedResize]
            Position = 2
            Text = 'Name'
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoShowHint, hoShowSortGlyphs, hoVisible, hoFullRepaintOnResize, hoHeaderClickAutoSort]
        Header.SortColumn = 0
        HintMode = hmHint
        Margin = 0
        ParentFont = False
        ParentShowHint = False
        PopupMenu = pmRTTIs
        ScrollBarOptions.AlwaysVisible = True
        ShowHint = True
        TabOrder = 0
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toFullRowDrag]
        TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect, toSimpleDrawSelection, toAlwaysSelectNode]
        OnClick = vtRTTIClick
        OnCompareNodes = vtRTTICompareNodes
        OnDblClick = vtRTTIDblClick
        OnFreeNode = vtRTTIFreeNode
        OnGetText = vtRTTIGetText
        OnGetHint = vtRTTIGetHint
        OnKeyDown = vtUnitKeyDown
        OnMouseMove = vtUnitMouseMove
      end
    end
    object tsForms: TTabSheet
      Caption = 'Forms (F5)'
      ImageIndex = 3
      object Splitter1: TSplitter
        Left = 0
        Top = 382
        Width = 207
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        Color = clGray
        MinSize = 3
        ParentColor = False
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 207
        Height = 40
        Align = alTop
        TabOrder = 0
        object rgViewFormAs: TRadioGroup
          Left = 1
          Top = 1
          Width = 205
          Height = 38
          Align = alClient
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Text'
            'Form')
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
        end
      end
      object lbForms: TListBox
        Left = 0
        Top = 40
        Width = 207
        Height = 342
        AutoComplete = False
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        OnClick = lbFormsClick
        OnDblClick = lbFormsDblClick
        OnKeyDown = lbFormsKeyDown
        OnMouseMove = lbFormsMouseMove
      end
      object Panel4: TPanel
        Left = 0
        Top = 386
        Width = 207
        Height = 170
        Align = alBottom
        TabOrder = 2
        object lbAliases: TListBox
          Left = 1
          Top = 1
          Width = 205
          Height = 75
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ItemHeight = 15
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          Sorted = True
          TabOrder = 0
          OnDblClick = lbAliasesDblClick
        end
        object pnlAliases: TPanel
          Left = 1
          Top = 76
          Width = 205
          Height = 93
          Align = alBottom
          TabOrder = 1
          Visible = False
          DesignSize = (
            205
            93)
          object lClassName: TLabel
            Left = 7
            Top = 5
            Width = 35
            Height = 15
            Caption = 'Type='
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
          end
          object cbAliases: TComboBox
            Left = 12
            Top = 31
            Width = 181
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier New'
            Font.Style = []
            ItemHeight = 15
            ParentFont = False
            Sorted = True
            TabOrder = 0
          end
          object bApplyAlias: TButton
            Left = 53
            Top = 63
            Width = 52
            Height = 25
            Caption = 'OK'
            Default = True
            TabOrder = 1
            OnClick = bApplyAliasClick
          end
          object bCancelAlias: TButton
            Left = 144
            Top = 63
            Width = 52
            Height = 25
            Cancel = True
            Caption = 'Cancel'
            TabOrder = 2
            OnClick = bCancelAliasClick
          end
        end
      end
    end
  end
  object sb: TStatusBar
    Left = 0
    Top = 763
    Width = 1121
    Height = 20
    Constraints.MaxHeight = 20
    Constraints.MinHeight = 20
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
    SizeGrip = False
  end
  object pb: TProgressBar
    Left = 0
    Top = 584
    Width = 1121
    Height = 15
    Align = alBottom
    Smooth = True
    TabOrder = 3
    Visible = False
  end
  object vtProc: TVirtualStringTree
    Left = 0
    Top = 603
    Width = 1121
    Height = 160
    Align = alBottom
    Constraints.MinHeight = 160
    DefaultText = 'Node'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Fixedsys'
    Font.Style = []
    Header.AutoSizeIndex = 3
    Header.Columns = <
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
        Position = 0
        Text = 'Address'
        Width = 80
      end
      item
        Alignment = taRightJustify
        Hint = 'Initialization order'
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
        Position = 1
        Text = 'Xref'
      end
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
        Position = 2
        Text = 'Kind'
        Width = 80
      end
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coAllowFocus, coDisableAnimatedResize]
        Position = 3
        Text = 'Prototype'
        Width = 821
      end
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coDisableAnimatedResize]
        Position = 4
        Text = 'Flags'
        Width = 70
      end>
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoShowHint, hoShowSortGlyphs, hoVisible, hoFullRepaintOnResize, hoHeaderClickAutoSort]
    Header.SortColumn = 0
    Margin = 0
    ParentFont = False
    ParentShowHint = False
    PopupMenu = pmUnitItems
    ScrollBarOptions.AlwaysVisible = True
    ScrollBarOptions.ScrollBars = ssVertical
    ShowHint = True
    TabOrder = 4
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toFullRowDrag]
    TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect, toSimpleDrawSelection, toAlwaysSelectNode]
    OnClick = vtProcClick
    OnCompareNodes = vtProcCompareNodes
    OnDblClick = vtProcDblClick
    OnFreeNode = vtProcFreeNode
    OnGetText = vtProcGetText
    OnPaintText = vtProcPaintText
    OnKeyDown = vtUnitKeyDown
    OnMouseMove = vtUnitMouseMove
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    Left = 916
    Top = 72
    object miFile: TMenuItem
      Caption = '&File'
      object miLoadFile: TMenuItem
        Caption = 'Load File'
        object miAutodetectVersion: TMenuItem
          Caption = 'Autodetect Version'
          OnClick = miAutodetectVersionClick
        end
        object miDelphi2: TMenuItem
          Caption = 'Delphi2'
          Enabled = False
          OnClick = miDelphi2Click
        end
        object miDelphi3: TMenuItem
          Caption = 'Delphi3'
          Enabled = False
          OnClick = miDelphi3Click
        end
        object miDelphi4: TMenuItem
          Caption = 'Delphi4'
          Enabled = False
          OnClick = miDelphi4Click
        end
        object miDelphi5: TMenuItem
          Caption = 'Delphi5'
          Enabled = False
          OnClick = miDelphi5Click
        end
        object miDelphi6: TMenuItem
          Caption = 'Delphi6'
          Enabled = False
          OnClick = miDelphi6Click
        end
        object miDelphi7: TMenuItem
          Caption = 'Delphi7'
          Enabled = False
          OnClick = miDelphi7Click
        end
        object miDelphi2005: TMenuItem
          Caption = 'Delphi2005'
          Enabled = False
          OnClick = miDelphi2005Click
        end
        object miDelphi2006: TMenuItem
          Caption = 'Delphi2006'
          Enabled = False
          OnClick = miDelphi2006Click
        end
        object miDelphi2007: TMenuItem
          Caption = 'Delphi2007'
          Enabled = False
          OnClick = miDelphi2007Click
        end
        object miDelphi2009: TMenuItem
          Caption = 'Delphi2009'
          Enabled = False
          OnClick = miDelphi2009Click
        end
        object miDelphi2010: TMenuItem
          Caption = 'Delphi2010'
          Enabled = False
          OnClick = miDelphi2010Click
        end
        object miDelphiXE1: TMenuItem
          Caption = 'DelphiXE1'
          Enabled = False
          OnClick = miDelphiXE1Click
        end
        object miDelphiXE2: TMenuItem
          Caption = 'DelphiXE2'
          Enabled = False
          OnClick = miDelphiXE2Click
        end
        object miDelphiXE3: TMenuItem
          Caption = 'DelphiXE3'
          Enabled = False
          OnClick = miDelphiXE3Click
        end
        object miDelphiXE4: TMenuItem
          Caption = 'DelphiXE4'
          Enabled = False
          OnClick = miDelphiXE4Click
        end
      end
      object miOpenProject: TMenuItem
        Caption = 'Open Project'
        OnClick = miOpenProjectClick
      end
      object miMRF: TMenuItem
        Caption = 'Recent Files'
        object miExe1: TMenuItem
          Visible = False
          OnClick = miExe1Click
        end
        object miExe2: TMenuItem
          Visible = False
          OnClick = miExe2Click
        end
        object miExe3: TMenuItem
          Visible = False
          OnClick = miExe3Click
        end
        object miExe4: TMenuItem
          Visible = False
          OnClick = miExe4Click
        end
        object miExe5: TMenuItem
          Visible = False
          OnClick = miExe5Click
        end
        object miExe6: TMenuItem
          Visible = False
          OnClick = miExe6Click
        end
        object miExe7: TMenuItem
          Visible = False
          OnClick = miExe7Click
        end
        object miExe8: TMenuItem
          Visible = False
          OnClick = miExe8Click
        end
        object N1: TMenuItem
          Caption = '-'
        end
        object miIdp1: TMenuItem
          Visible = False
          OnClick = miIdp1Click
        end
        object miIdp2: TMenuItem
          Visible = False
          OnClick = miIdp2Click
        end
        object miIdp3: TMenuItem
          Visible = False
          OnClick = miIdp3Click
        end
        object miIdp4: TMenuItem
          Visible = False
          OnClick = miIdp4Click
        end
        object miIdp5: TMenuItem
          Visible = False
          OnClick = miIdp5Click
        end
        object miIdp6: TMenuItem
          Visible = False
          OnClick = miIdp6Click
        end
        object miIdp7: TMenuItem
          Visible = False
          OnClick = miIdp7Click
        end
        object miIdp8: TMenuItem
          Visible = False
          OnClick = miIdp8Click
        end
      end
      object miSaveProject: TMenuItem
        Caption = 'Save Project'
        OnClick = miSaveProjectClick
      end
      object miSaveDelphiProject: TMenuItem
        Caption = 'Save Delphi Project'
        OnClick = miSaveDelphiProjectClick
      end
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = miExitClick
      end
    end
    object miTools: TMenuItem
      Caption = 'Too&ls'
      object miProcessDumper: TMenuItem
        Caption = 'Process &Dumper'
        OnClick = miProcessDumperClick
      end
      object miMapGenerator: TMenuItem
        Caption = '&MAP Generator'
        OnClick = miMapGeneratorClick
      end
      object miCommentsGenerator: TMenuItem
        Caption = '&Comments Generator'
        OnClick = miCommentsGeneratorClick
      end
      object miIDCGenerator: TMenuItem
        Caption = '&IDC Generator'
        OnClick = miIDCGeneratorClick
      end
      object miLister: TMenuItem
        Caption = 'Lister'
        OnClick = miListerClick
      end
      object miClassTreeBuilder: TMenuItem
        Caption = 'Class Tree &Builder'
        OnClick = miClassTreeBuilderClick
      end
      object miKBTypeInfo: TMenuItem
        Caption = 'KB TypeInfo &Viewer'
        OnClick = miKBTypeInfoClick
      end
      object miCtdPassword: TMenuItem
        Caption = 'Citadel Password &Finder'
        OnClick = miCtdPasswordClick
      end
      object miHex2Double: TMenuItem
        Caption = '&Hex->Double'
        OnClick = miHex2DoubleClick
      end
    end
    object miTabs: TMenuItem
      Caption = '&Tabs'
      object Units1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Units'
        ShortCut = 113
        OnClick = Units1Click
      end
      object RTTI1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Types'
        ShortCut = 115
        OnClick = RTTI1Click
      end
      object Forms1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Forms'
        ShortCut = 116
        OnClick = Forms1Click
      end
      object CodeViewer1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Code Viewer'
        ShortCut = 117
        OnClick = CodeViewer1Click
      end
      object ClassViewer1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Class Viewer'
        ShortCut = 118
        OnClick = ClassViewer1Click
      end
      object Strings1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Strings'
        ShortCut = 119
        OnClick = Strings1Click
      end
      object Names1: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Names'
        ShortCut = 120
        OnClick = Names1Click
      end
      object SourceCode1: TMenuItem
        Caption = 'SourceCode'
        ShortCut = 121
        OnClick = SourceCode1Click
      end
    end
    object miPlugins: TMenuItem
      Caption = 'Plu&gins'
      OnClick = miPluginsClick
    end
    object miInformation: TMenuItem
      Caption = '&Program'
      object miAbout: TMenuItem
        AutoHotkeys = maManual
        Caption = '&About...'
        OnClick = miAboutClick
      end
      object miHelp: TMenuItem
        AutoHotkeys = maManual
        Caption = 'Help'
        ShortCut = 112
        OnClick = miHelpClick
      end
      object miLegend: TMenuItem
        Caption = 'Legend'
        OnClick = miLegendClick
      end
      object miSettings: TMenuItem
        Caption = 'Settings'
        object miacFontAll: TMenuItem
          Caption = 'Fonts'
          OnClick = acFontAllExecute
        end
      end
    end
  end
  object OpenDlg: TOpenDialog
    Left = 916
    Top = 124
  end
  object pmCode: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmCodePopup
    Left = 328
    Top = 96
    object miGoTo: TMenuItem
      Caption = 'GoTo Address'
      Enabled = False
      OnClick = miGoToClick
    end
    object miExploreAdr: TMenuItem
      Caption = 'Explore Address'
      Enabled = False
      OnClick = miExploreAdrClick
    end
    object miName: TMenuItem
      Caption = 'Name Position'
      Enabled = False
      OnClick = miNameClick
    end
    object miViewProto: TMenuItem
      Caption = 'View Prototype'
      Enabled = False
      OnClick = miViewProtoClick
    end
    object miEditFunctionC: TMenuItem
      Caption = 'Edit Prototype'
      Enabled = False
      OnClick = miEditFunctionCClick
    end
    object miCopyCode: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = miCopyCodeClick
    end
    object miFuzzyScanKB: TMenuItem
      Caption = 'Fuzzy scan KB'
      Enabled = False
      OnClick = miFuzzyScanKBClick
    end
    object miCopyAddressCode: TMenuItem
      Caption = 'Copy Address'
      OnClick = miCopyAddressCodeClick
    end
    object miXRefs: TMenuItem
      Caption = 'XRefs'
      Enabled = False
    end
    object miSwitchFlag: TMenuItem
      Caption = 'Switch flag'
      Enabled = False
      object miSwitchSkipFlag: TMenuItem
        Caption = 'cfSkip'
        OnClick = miSwitchSkipFlagClick
      end
      object miSwitchFrameFlag: TMenuItem
        Caption = 'cfFrame'
        OnClick = miSwitchFrameFlagClick
      end
      object cfTry1: TMenuItem
        Caption = 'cfTry'
        OnClick = cfTry1Click
      end
    end
  end
  object SaveDlg: TSaveDialog
    Left = 916
    Top = 176
  end
  object pmUnits: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmUnitsPopup
    Left = 24
    Top = 96
    object miRenameUnit: TMenuItem
      Caption = 'Rename Unit'
      Enabled = False
      OnClick = miRenameUnitClick
    end
    object miSearchUnit: TMenuItem
      Caption = 'Search Unit'
      Enabled = False
      OnClick = miSearchUnitClick
    end
    object miUnitDumper: TMenuItem
      Caption = 'Unit Dumper'
      Enabled = False
      Visible = False
      OnClick = miUnitDumperClick
    end
    object miCopyList: TMenuItem
      Caption = 'Save Units List'
      Enabled = False
      OnClick = miCopyListClick
    end
  end
  object pmRTTIs: TPopupMenu
    AutoHotkeys = maManual
    Left = 80
    Top = 96
    object miSearchRTTI: TMenuItem
      Caption = 'Search Type'
      Enabled = False
      OnClick = miSearchRTTIClick
    end
    object Appearance2: TMenuItem
      Caption = 'Appearance'
      object Showbar2: TMenuItem
        Action = acShowBar
      end
      object Showhorizontalscroll2: TMenuItem
        Action = acShowHoriz
      end
      object Defaultcolumns2: TMenuItem
        Action = acDefCol
      end
      object Fontall2: TMenuItem
        Caption = 'Font (all)'
        OnClick = acFontAllExecute
      end
      object Colorsthis2: TMenuItem
        Caption = 'Colors (this)'
      end
      object Colorsall2: TMenuItem
        Caption = 'Colors (all)'
      end
    end
  end
  object pmVMTs: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmVMTsPopup
    Left = 372
    Top = 96
    object miViewClass: TMenuItem
      Caption = 'View Class'
      Enabled = False
      OnClick = miViewClassClick
    end
    object miSearchVMT: TMenuItem
      Caption = 'Search'
      Enabled = False
      OnClick = miSearchVMTClick
    end
    object miCollapseAll: TMenuItem
      Caption = 'Collapse All'
      Enabled = False
      OnClick = miCollapseAllClick
    end
    object miEditClass: TMenuItem
      Caption = 'Edit'
      Enabled = False
      OnClick = miEditClassClick
    end
  end
  object pmUnitItems: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmUnitItemsPopup
    Left = 428
    Top = 684
    object miSearchItem: TMenuItem
      Caption = 'Search Item'
      Enabled = False
      OnClick = miSearchItemClick
    end
    object miEditFunctionI: TMenuItem
      Caption = 'Edit Prototype'
      Enabled = False
      OnClick = miEditFunctionIClick
    end
    object miCopyAddressI: TMenuItem
      Caption = 'Copy Address'
      Enabled = False
      OnClick = miCopyAddressIClick
    end
    object miViewAll: TMenuItem
      Caption = 'View All'
      Enabled = False
      OnClick = miViewAllClick
    end
  end
  object pmStrings: TPopupMenu
    AutoHotkeys = maManual
    Left = 424
    Top = 96
    object miSearchString: TMenuItem
      Caption = 'Search'
      OnClick = miSearchStringClick
    end
    object miCopyStrings: TMenuItem
      Caption = 'Copy To Clipboard'
      OnClick = miCopyStringsClick
    end
  end
  object pmCodePanel: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = pmCodePanelPopup
    Left = 1056
    Top = 72
    object miEmptyHistory: TMenuItem
      Caption = 'Empty History'
      OnClick = miEmptyHistoryClick
    end
  end
  object alMain: TActionList
    Left = 920
    Top = 288
    object acOnTop: TAction
      Category = 'Appearance'
      Caption = 'Always on top'
    end
    object acShowBar: TAction
      Category = 'Appearance'
      Caption = 'Show bar'
    end
    object acShowHoriz: TAction
      Category = 'Appearance'
      Caption = 'Show horizontal scroll'
    end
    object acDefCol: TAction
      Category = 'Appearance'
      Caption = 'Default columns'
    end
  end
  object FontsDlg: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 916
    Top = 232
  end
  object pmSourceCode: TPopupMenu
    Left = 488
    Top = 96
    object miCopySource2Clipboard: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = miCopySource2ClipboardClick
    end
  end
end
