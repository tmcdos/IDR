object FindDlg: TFFindDlg
  Left = 487
  Top = 325
  BorderStyle = bsToolWindow
  Caption = 'Find'
  ClientHeight = 96
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 345
    Height = 49
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 60
    Height = 13
    Caption = 'Text to find:'
  end
  object OKBtn: TButton
    Left = 115
    Top = 68
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 195
    Top = 68
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cbText: TComboBox
    Left = 88
    Top = 20
    Width = 249
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnEnter = cbTextEnter
  end
end
