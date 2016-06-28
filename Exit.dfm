object FExit: TFExit
  Left = 482
  Top = 333
  BorderStyle = bsDialog
  Caption = 'Save Project'
  ClientHeight = 127
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 81
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 63
    Top = 100
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 175
    Top = 100
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object cbDontSaveProject: TCheckBox
    Left = 52
    Top = 40
    Width = 209
    Height = 17
    Caption = 'Don'#39't save Project'
    TabOrder = 2
  end
end
