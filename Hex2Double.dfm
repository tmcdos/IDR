object FHex2DoubleDlg: TFHex2DoubleDlg
  Left = 384
  Top = 341
  BorderStyle = bsDialog
  Caption = 'Hex->Double Converter'
  ClientHeight = 77
  ClientWidth = 655
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object rgDataViewStyle: TRadioGroup
    Left = 0
    Top = 0
    Width = 655
    Height = 40
    Align = alTop
    Columns = 6
    ItemIndex = 0
    Items.Strings = (
      'Hex'
      'Single (32bit)'
      'Double (64)'
      'Extended (80)'
      'Real (32)'
      'Comp (64)')
    TabOrder = 0
    OnClick = rgDataViewStyleClick
  end
  object edtValue: TLabeledEdit
    Left = 65
    Top = 46
    Width = 566
    Height = 24
    EditLabel.Width = 48
    EditLabel.Height = 16
    EditLabel.Caption = 'Value:'
    EditLabel.Font.Charset = RUSSIAN_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'Fixedsys'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    LabelPosition = lpLeft
    ParentFont = False
    TabOrder = 1
    OnEnter = edtValueEnter
  end
end
