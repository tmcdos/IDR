object FLegend: TFLegend
  Left = 452
  Top = 306
  BorderStyle = bsDialog
  Caption = 'Legend'
  ClientHeight = 228
  ClientWidth = 245
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object gb1: TGroupBox
    Left = 4
    Top = 3
    Width = 235
    Height = 105
    Caption = 'Unit colors'
    TabOrder = 0
    object Label1: TLabel
      Left = 79
      Top = 19
      Width = 109
      Height = 13
      Caption = 'Standard unit (from KB)'
    end
    object Label2: TLabel
      Left = 79
      Top = 40
      Width = 42
      Height = 13
      Caption = 'User unit'
    end
    object Label3: TLabel
      Left = 79
      Top = 61
      Width = 48
      Height = 13
      Caption = 'Trivial unit'
    end
    object Label5: TLabel
      Left = 79
      Top = 83
      Width = 125
      Height = 13
      Caption = 'Unrecognized bytes in unit'
    end
    object lblUnitStd: TLabel
      Left = 7
      Top = 19
      Width = 65
      Height = 16
      AutoSize = False
      Caption = 'system'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblUnitUser: TLabel
      Left = 7
      Top = 39
      Width = 65
      Height = 16
      AutoSize = False
      Caption = 'Unit5'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblUnitTrivial: TLabel
      Left = 7
      Top = 60
      Width = 65
      Height = 16
      AutoSize = False
      Caption = 'Unit25'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblUnitUserUnk: TLabel
      Left = 7
      Top = 81
      Width = 65
      Height = 16
      AutoSize = False
      Caption = 'dlgPass'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object gb2: TGroupBox
    Left = 4
    Top = 112
    Width = 235
    Height = 84
    Caption = 'Unit types'
    TabOrder = 1
    object Label4: TLabel
      Left = 79
      Top = 19
      Width = 128
      Height = 13
      Caption = 'Non trivial Initializaiton proc'
    end
    object Label6: TLabel
      Left = 79
      Top = 40
      Width = 126
      Height = 13
      Caption = 'Non trivial Finalization proc'
    end
    object Label7: TLabel
      Left = 79
      Top = 61
      Width = 43
      Height = 13
      Caption = 'ask me :)'
    end
    object lblInit: TLabel
      Left = 7
      Top = 19
      Width = 65
      Height = 16
      AutoSize = False
      Caption = 'I'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblFin: TLabel
      Left = 7
      Top = 39
      Width = 65
      Height = 16
      AutoSize = False
      Caption = 'F'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblUnk: TLabel
      Left = 7
      Top = 60
      Width = 65
      Height = 16
      AutoSize = False
      Caption = '?'
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object btnOK: TButton
    Left = 82
    Top = 200
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
end
