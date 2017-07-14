object FEditFunctionDlg: TFEditFunctionDlg
  Left = 374
  Top = 200
  BorderStyle = bsToolWindow
  Caption = 'Edit Prototype'
  ClientHeight = 509
  ClientWidth = 713
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 472
    Width = 713
    Height = 37
    Align = alBottom
    TabOrder = 0
    object bEdit: TButton
      Left = 20
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 0
      OnClick = bEditClick
    end
    object bAdd: TButton
      Left = 116
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Add'
      Default = True
      Enabled = False
      TabOrder = 1
      OnClick = bAddClick
    end
    object bRemoveSelected: TButton
      Left = 212
      Top = 5
      Width = 100
      Height = 25
      Caption = 'Remove Selected'
      TabOrder = 2
      OnClick = bRemoveSelectedClick
    end
    object bOk: TButton
      Left = 625
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 3
      OnClick = bOkClick
    end
    object bRemoveAll: TButton
      Left = 368
      Top = 5
      Width = 97
      Height = 25
      Caption = 'Remove All'
      TabOrder = 4
      OnClick = bRemoveAllClick
    end
  end
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 713
    Height = 472
    ActivePage = tsType
    Align = alClient
    TabOrder = 1
    OnChange = pcChange
    object tsType: TTabSheet
      Caption = 'Type'
      object Label1: TLabel
        Left = 14
        Top = 403
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'RetBytes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lRetBytes: TLabel
        Left = 78
        Top = 403
        Width = 5
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 9
        Top = 421
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'ArgsBytes:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lArgsBytes: TLabel
        Left = 78
        Top = 421
        Width = 5
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbEmbedded: TCheckBox
        Left = 30
        Top = 317
        Width = 111
        Height = 17
        Caption = 'Embedded'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object mType: TMemo
        Left = 143
        Top = 33
        Width = 560
        Height = 377
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WantReturns = False
      end
      object rgCallKind: TRadioGroup
        Left = 11
        Top = 170
        Width = 126
        Height = 144
        Caption = 'Function Call Kind: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'fastcall'
          'cdecl'
          'pascal'
          'stdcall'
          'safecall')
        ParentFont = False
        TabOrder = 2
      end
      object bApplyType: TButton
        Left = 325
        Top = 416
        Width = 75
        Height = 24
        Caption = 'Apply'
        Default = True
        TabOrder = 8
        OnClick = bApplyTypeClick
      end
      object bCancelType: TButton
        Left = 455
        Top = 416
        Width = 75
        Height = 25
        Caption = 'Cancel'
        Default = True
        TabOrder = 9
        OnClick = bCancelTypeClick
      end
      object rgFunctionKind: TRadioGroup
        Left = 11
        Top = 14
        Width = 126
        Height = 144
        Caption = 'Function Kind: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Items.Strings = (
          'constructor'
          'destructor'
          'procedure'
          'function')
        ParentFont = False
        TabOrder = 1
      end
      object cbVmtCandidates: TComboBox
        Left = 280
        Top = 7
        Width = 423
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 7
      end
      object cbMethod: TCheckBox
        Left = 156
        Top = 7
        Width = 111
        Height = 20
        Caption = 'Method of Class:'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = cbMethodClick
      end
      object lEndAdr: TLabeledEdit
        Left = 43
        Top = 345
        Width = 92
        Height = 21
        EditLabel.Width = 31
        EditLabel.Height = 13
        EditLabel.Caption = 'End: '
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'MS Sans Serif'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        LabelPosition = lpLeft
        ParentFont = False
        TabOrder = 4
      end
      object lStackSize: TLabeledEdit
        Left = 43
        Top = 371
        Width = 92
        Height = 21
        EditLabel.Width = 34
        EditLabel.Height = 13
        EditLabel.Caption = 'Stack'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'MS Sans Serif'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        LabelPosition = lpLeft
        ParentFont = False
        TabOrder = 5
      end
    end
    object tsArgs: TTabSheet
      Caption = 'Arguments'
      object lbArgs: TListBox
        Left = 0
        Top = 0
        Width = 705
        Height = 444
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Fixedsys'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 0
      end
    end
    object tsVars: TTabSheet
      Caption = 'Var'
      ImageIndex = 1
      object lbVars: TListBox
        Left = 0
        Top = 0
        Width = 705
        Height = 298
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Fixedsys'
        Font.Style = []
        ItemHeight = 16
        MultiSelect = True
        ParentFont = False
        TabOrder = 0
        OnClick = lbVarsClick
      end
      object pnlVars: TPanel
        Left = 0
        Top = 298
        Width = 705
        Height = 146
        Align = alBottom
        TabOrder = 1
        object rgLocBase: TRadioGroup
          Left = 260
          Top = 2
          Width = 260
          Height = 32
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Items.Strings = (
            'ESP-based'
            'EBP-based')
          ParentFont = False
          TabOrder = 0
        end
        object edtVarOfs: TLabeledEdit
          Left = 111
          Top = 39
          Width = 468
          Height = 21
          EditLabel.Width = 39
          EditLabel.Height = 13
          EditLabel.Caption = 'Offset:'
          EditLabel.Font.Charset = RUSSIAN_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -11
          EditLabel.Font.Name = 'MS Sans Serif'
          EditLabel.Font.Style = [fsBold]
          EditLabel.ParentFont = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          LabelPosition = lpLeft
          ParentFont = False
          TabOrder = 1
        end
        object edtVarSize: TLabeledEdit
          Left = 111
          Top = 65
          Width = 468
          Height = 21
          EditLabel.Width = 29
          EditLabel.Height = 13
          EditLabel.Caption = 'Size:'
          EditLabel.Font.Charset = RUSSIAN_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -11
          EditLabel.Font.Name = 'MS Sans Serif'
          EditLabel.Font.Style = [fsBold]
          EditLabel.ParentFont = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          LabelPosition = lpLeft
          ParentFont = False
          TabOrder = 2
        end
        object edtVarName: TLabeledEdit
          Left = 111
          Top = 91
          Width = 468
          Height = 21
          EditLabel.Width = 37
          EditLabel.Height = 13
          EditLabel.Caption = 'Name:'
          EditLabel.Font.Charset = RUSSIAN_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -11
          EditLabel.Font.Name = 'MS Sans Serif'
          EditLabel.Font.Style = [fsBold]
          EditLabel.ParentFont = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          LabelPosition = lpLeft
          ParentFont = False
          TabOrder = 3
        end
        object edtVarType: TLabeledEdit
          Left = 111
          Top = 117
          Width = 468
          Height = 21
          EditLabel.Width = 33
          EditLabel.Height = 13
          EditLabel.Caption = 'Type:'
          EditLabel.Font.Charset = RUSSIAN_CHARSET
          EditLabel.Font.Color = clWindowText
          EditLabel.Font.Height = -11
          EditLabel.Font.Name = 'MS Sans Serif'
          EditLabel.Font.Style = [fsBold]
          EditLabel.ParentFont = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          LabelPosition = lpLeft
          ParentFont = False
          TabOrder = 4
        end
        object bApplyVar: TButton
          Left = 592
          Top = 59
          Width = 74
          Height = 24
          Caption = 'Apply'
          Default = True
          TabOrder = 5
          OnClick = bApplyVarClick
        end
        object bCancelVar: TButton
          Left = 592
          Top = 91
          Width = 74
          Height = 25
          Caption = 'Cancel'
          Default = True
          TabOrder = 6
          OnClick = bCancelVarClick
        end
      end
    end
  end
end
