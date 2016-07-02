object Form1: TForm1
  Left = 263
  Top = 138
  Width = 612
  Height = 380
  Caption = 'Form1'
  Color = clBtnFace
  Constraints.MinHeight = 380
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
    object btn1: TButton
      Left = 16
      Top = 7
      Width = 89
      Height = 22
      Caption = 'Choose IDP file'
      TabOrder = 0
      OnClick = btn1Click
    end
    object btn2: TButton
      Left = 16
      Top = 36
      Width = 89
      Height = 22
      Caption = 'Choose TXT file'
      TabOrder = 1
      OnClick = btn2Click
    end
    object btn3: TButton
      Left = 448
      Top = 20
      Width = 75
      Height = 25
      Caption = 'Convert'
      TabOrder = 4
      OnClick = btn3Click
    end
    object txt1: TEdit
      Left = 124
      Top = 8
      Width = 313
      Height = 21
      AutoSize = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object txt2: TEdit
      Left = 124
      Top = 36
      Width = 313
      Height = 21
      AutoSize = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
  end
  object progBar1: TProgressBar
    Left = 0
    Top = 65
    Width = 604
    Height = 16
    Align = alTop
    TabOrder = 1
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
