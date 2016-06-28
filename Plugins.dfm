object FPlugins: TFPlugins
  Left = 550
  Top = 365
  Width = 548
  Height = 233
  Caption = 'Plugins'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cklbPluginsList: TCheckListBox
    Left = 0
    Top = 0
    Width = 540
    Height = 170
    OnClickCheck = cklbPluginsListClickCheck
    Align = alTop
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = cklbPluginsListDblClick
  end
  object bOk: TButton
    Left = 117
    Top = 176
    Width = 61
    Height = 20
    Caption = 'Ok'
    TabOrder = 1
    OnClick = bOkClick
  end
  object bCancel: TButton
    Left = 260
    Top = 176
    Width = 61
    Height = 20
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = bCancelClick
  end
end
