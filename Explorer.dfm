object FExplorer: TFExplorer
  Left = 422
  Top = 205
  BorderStyle = bsToolWindow
  Caption = 'Explorer'
  ClientHeight = 527
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pc1: TPageControl
    Left = 0
    Top = 0
    Width = 655
    Height = 527
    ActivePage = tsCode
    Align = alClient
    PopupMenu = pm1
    TabOrder = 0
    object tsCode: TTabSheet
      Caption = 'Code'
      object lbCode: TListBox
        Left = 0
        Top = 0
        Width = 647
        Height = 458
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        PopupMenu = pm1
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 0
        Top = 458
        Width = 647
        Height = 41
        Align = alBottom
        TabOrder = 1
        object btnDefCode: TButton
          Left = 223
          Top = 9
          Width = 89
          Height = 24
          Cursor = crHandPoint
          Caption = 'Define'
          TabOrder = 0
          OnClick = btnDefCodeClick
        end
        object btnUndefCode: TButton
          Left = 344
          Top = 9
          Width = 87
          Height = 24
          Cursor = crHandPoint
          Caption = 'Undefine'
          TabOrder = 1
          OnClick = btnUndefCodeClick
        end
      end
    end
    object tsData: TTabSheet
      Caption = 'Data'
      ImageIndex = 1
      object lbData: TListBox
        Left = 0
        Top = 41
        Width = 647
        Height = 458
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        PopupMenu = pm1
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 647
        Height = 41
        Align = alTop
        TabOrder = 1
        object rgDataViewStyle: TRadioGroup
          Left = 1
          Top = 1
          Width = 645
          Height = 39
          Align = alClient
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
      end
    end
    object tsString: TTabSheet
      Caption = 'String'
      ImageIndex = 2
      object rgStringViewStyle: TRadioGroup
        Left = 0
        Top = 358
        Width = 647
        Height = 100
        Align = alClient
        Caption = ' String Styles '
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'PAnsiChar'
          'PWideChar'
          'ShortString'
          'AnsiString'
          'WideString')
        TabOrder = 0
        OnClick = rgStringViewStyleClick
      end
      object lbString: TMemo
        Left = 0
        Top = 0
        Width = 647
        Height = 358
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 0
        Top = 458
        Width = 647
        Height = 41
        Align = alBottom
        TabOrder = 2
        object btnDefString: TButton
          Left = 223
          Top = 9
          Width = 89
          Height = 24
          Cursor = crHandPoint
          Caption = 'Define'
          Enabled = False
          TabOrder = 0
          OnClick = btnDefStringClick
        end
        object btnUndefString: TButton
          Left = 344
          Top = 9
          Width = 87
          Height = 24
          Cursor = crHandPoint
          Caption = 'Undefine'
          Enabled = False
          TabOrder = 1
        end
      end
    end
    object tsText: TTabSheet
      Caption = 'Text'
      ImageIndex = 4
      object lbText: TListBox
        Left = 0
        Top = 0
        Width = 647
        Height = 499
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        PopupMenu = pm1
        TabOrder = 0
      end
    end
  end
  object pm1: TPopupMenu
    Left = 576
    Top = 336
    object miCopy2Clipboard: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = miCopy2ClipboardClick
    end
  end
end
