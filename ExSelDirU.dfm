object ExSelDirF: TExSelDirF
  Left = 60
  Top = 203
  Caption = 'File Search Properties'
  ClientHeight = 455
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 48
    Width = 616
    Height = 407
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = 'File Search Properties'
      ImageIndex = 1
      object FileModifyR: TRadioGroup
        Left = 24
        Top = 11
        Width = 249
        Height = 141
        Caption = 'File modified dates'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Any time'
          'Within an hour'
          'Today'
          'Yesterday'
          'This week'
          'This month'
          'This Year'
          'Custom')
        TabOrder = 0
        OnClick = FileModifyRClick
      end
      object FileSizeR: TRadioGroup
        Left = 24
        Top = 158
        Width = 249
        Height = 147
        Caption = 'File Sizes'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Any Size'
          'Up To 1 KB'
          'Up To 100 KB'
          'Up To 1 MB'
          'Over 25 KB'
          'Over 100 KB'
          'Over 1 MB'
          'Custom')
        TabOrder = 1
        OnClick = FileSizeRClick
      end
      object CustomFileModifyG: TGroupBox
        Left = 280
        Top = 16
        Width = 289
        Height = 136
        Caption = 'Custom File Modified Dates'
        TabOrder = 2
        Visible = False
        object FileModifyAfterChk: TCheckBox
          Left = 16
          Top = 18
          Width = 129
          Height = 17
          Caption = 'Modified on or after'
          TabOrder = 0
        end
        object FileModifyBeforeChk: TCheckBox
          Left = 16
          Top = 82
          Width = 129
          Height = 17
          Caption = 'Modified on or before'
          TabOrder = 1
        end
        object FileModifyAfterTime: TDateTimePicker
          Left = 116
          Top = 41
          Width = 81
          Height = 21
          Date = 39763.361189756940000000
          Time = 39763.361189756940000000
          Kind = dtkTime
          TabOrder = 2
        end
        object FileModifyBeforeTime: TDateTimePicker
          Left = 116
          Top = 105
          Width = 81
          Height = 21
          Date = 39763.361189756940000000
          Time = 39763.361189756940000000
          Kind = dtkTime
          TabOrder = 3
        end
        object FileModifyAfterDate: TDateTimePicker
          Left = 34
          Top = 41
          Width = 81
          Height = 21
          Date = 39763.361189756940000000
          Time = 39763.361189756940000000
          TabOrder = 4
        end
        object FileModifyBeforeDate: TDateTimePicker
          Left = 34
          Top = 105
          Width = 81
          Height = 21
          Date = 39763.361189756940000000
          Time = 39763.361189756940000000
          TabOrder = 5
        end
      end
      object CustomFileSizeG: TGroupBox
        Left = 279
        Top = 158
        Width = 289
        Height = 147
        Caption = 'Custom File Sizes'
        TabOrder = 3
        Visible = False
        object CustomFileSizeBiggerChk: TCheckBox
          Left = 24
          Top = 48
          Width = 127
          Height = 17
          Caption = 'This size or bigger (KB)'
          TabOrder = 0
        end
        object CustomFileSizeBiggerE: TEdit
          Left = 159
          Top = 45
          Width = 74
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object UpDown1: TUpDown
          Left = 233
          Top = 45
          Width = 16
          Height = 21
          Associate = CustomFileSizeBiggerE
          TabOrder = 2
        end
        object CustomFileSizeSmallerChk: TCheckBox
          Left = 24
          Top = 88
          Width = 127
          Height = 17
          Caption = 'This size or smaller (KB)'
          TabOrder = 3
        end
        object CustomFileSizeSmallerE: TEdit
          Left = 159
          Top = 85
          Width = 74
          Height = 21
          TabOrder = 4
          Text = '0'
        end
        object UpDown2: TUpDown
          Left = 233
          Top = 85
          Width = 16
          Height = 21
          Associate = CustomFileSizeSmallerE
          TabOrder = 5
        end
      end
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 616
    Height = 48
    ButtonHeight = 44
    ButtonWidth = 57
    Caption = 'ToolBar1'
    Images = RepMainF.MenuImages
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 1
    Wrapable = False
    object ToolButton3: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object SaveBtn: TToolButton
      Left = 8
      Top = 0
      Caption = 'Ok'
      ImageIndex = 32
      OnClick = SaveBtnClick
    end
    object CloseBtn: TToolButton
      Left = 65
      Top = 0
      Caption = '   Cancel   '
      ImageIndex = 31
      OnClick = CloseBtnClick
    end
    object ToolButton2: TToolButton
      Left = 122
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 2
      Style = tbsSeparator
    end
  end
end
