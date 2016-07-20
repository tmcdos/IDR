object Form1: TForm1
  Left = 474
  Top = 266
  Width = 612
  Height = 240
  Caption = 'Form1'
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object panel2: TPanel
    Left = 0
    Top = 0
    Width = 604
    Height = 65
    Align = alTop
    TabOrder = 0
    object btnLoad: TButton
      Left = 16
      Top = 7
      Width = 89
      Height = 22
      Caption = 'Choose IDP file'
      TabOrder = 0
      OnClick = btnLoadClick
    end
    object btnUpdate: TButton
      Left = 232
      Top = 34
      Width = 89
      Height = 25
      Caption = 'Save IDP-3'
      TabOrder = 3
      OnClick = btnUpdateClick
    end
    object btnText: TButton
      Left = 124
      Top = 34
      Width = 75
      Height = 25
      Caption = 'Save TXT'
      TabOrder = 2
      OnClick = btnTextClick
    end
    object txt1: TEdit
      Left = 124
      Top = 8
      Width = 313
      Height = 21
      AutoSize = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
  end
  object panel3: TPanel
    Left = 0
    Top = 65
    Width = 604
    Height = 28
    Align = alTop
    TabOrder = 1
    object txtInfos: TLabel
      Left = 60
      Top = 6
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Info objects'
    end
    object progInfos: TProgressBar
      Left = 124
      Top = 1
      Width = 479
      Height = 26
      Align = alRight
      TabOrder = 0
    end
  end
  object panel4: TPanel
    Left = 0
    Top = 93
    Width = 604
    Height = 28
    Align = alTop
    TabOrder = 2
    object txtBSS: TLabel
      Left = 62
      Top = 6
      Width = 56
      Height = 13
      Alignment = taRightJustify
      Caption = 'BSS objects'
    end
    object progBSS: TProgressBar
      Left = 124
      Top = 1
      Width = 479
      Height = 26
      Align = alRight
      TabOrder = 0
    end
  end
  object panel5: TPanel
    Left = 0
    Top = 121
    Width = 604
    Height = 28
    Align = alTop
    TabOrder = 3
    object txtUnit: TLabel
      Left = 89
      Top = 6
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Types'
    end
    object progUnit: TProgressBar
      Left = 124
      Top = 1
      Width = 479
      Height = 26
      Align = alRight
      TabOrder = 0
    end
  end
  object panel6: TPanel
    Left = 0
    Top = 177
    Width = 604
    Height = 28
    Align = alTop
    TabOrder = 5
    object txtType: TLabel
      Left = 89
      Top = 6
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Forms'
    end
    object progType: TProgressBar
      Left = 124
      Top = 1
      Width = 479
      Height = 26
      Align = alRight
      TabOrder = 0
    end
  end
  object panel7: TPanel
    Left = 0
    Top = 149
    Width = 604
    Height = 28
    Align = alTop
    TabOrder = 4
    object txtForm: TLabel
      Left = 94
      Top = 6
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = 'Units'
    end
    object progForm: TProgressBar
      Left = 124
      Top = 1
      Width = 479
      Height = 26
      Align = alRight
      TabOrder = 0
    end
  end
  object dlgOpen1: TOpenDialog
    DefaultExt = '.IDP'
    Filter = 'IDR projects|*.idp'
    Options = [ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofShareAware, ofEnableIncludeNotify, ofEnableSizing]
    Left = 512
    Top = 12
  end
  object dlgSave1: TSaveDialog
    DefaultExt = '.TXT'
    Filter = 'Text files|*.TXT'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofEnableIncludeNotify, ofEnableSizing]
    Left = 556
    Top = 12
  end
end
