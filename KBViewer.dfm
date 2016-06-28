object FKBViewer: TFKBViewer
  Left = 340
  Top = 178
  BorderStyle = bsToolWindow
  Caption = 'KBViewer'
  ClientHeight = 566
  ClientWidth = 821
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 378
    Top = 27
    Width = 2
    Height = 563
    Align = alNone
  end
  object lbKB: TListBox
    Left = 378
    Top = 33
    Width = 380
    Height = 533
    AutoComplete = False
    Align = alClient
    Color = 15597544
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ItemHeight = 16
    MultiSelect = True
    ParentFont = False
    TabOrder = 2
  end
  object lbIDR: TListBox
    Left = 0
    Top = 33
    Width = 378
    Height = 533
    AutoComplete = False
    Align = alLeft
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ItemHeight = 16
    MultiSelect = True
    ParentFont = False
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 758
    Top = 33
    Width = 63
    Height = 533
    Align = alRight
    TabOrder = 3
    object lPosition: TLabel
      Left = 7
      Top = 237
      Width = 52
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Position'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lKBIdx: TLabel
      Left = 4
      Top = 10
      Width = 52
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'KB Index'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object bPrev: TButton
      Left = 7
      Top = 186
      Width = 52
      Height = 24
      Caption = 'Prev'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = bPrevClick
    end
    object bNext: TButton
      Left = 7
      Top = 284
      Width = 52
      Height = 24
      Caption = 'Next'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = bNextClick
    end
    object btnOk: TButton
      Left = 7
      Top = 477
      Width = 52
      Height = 24
      Cursor = crHandPoint
      Caption = 'Use'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 7
      Top = 503
      Width = 52
      Height = 24
      Cursor = crHandPoint
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object edtCurrIdx: TEdit
      Left = 5
      Top = 26
      Width = 53
      Height = 21
      TabOrder = 4
      OnChange = edtCurrIdxChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 821
    Height = 33
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 143
      Top = 9
      Width = 48
      Height = 13
      Caption = 'KB Unit:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblKbIdxs: TLabel
      Left = 631
      Top = 7
      Width = 3
      Height = 13
    end
    object cbUnits: TComboBox
      Left = 195
      Top = 7
      Width = 430
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = cbUnitsChange
    end
  end
end
