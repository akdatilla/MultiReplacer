object FileFormatSelF: TFileFormatSelF
  Left = 5
  Top = 147
  Caption = 'File Format Options'
  ClientHeight = 489
  ClientWidth = 595
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
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 595
    Height = 48
    ButtonHeight = 44
    ButtonWidth = 46
    Caption = 'ToolBar1'
    Images = RepMainF.MenuImages
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 0
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
      Caption = '&Ok'
      ImageIndex = 32
      OnClick = SaveBtnClick
    end
    object CloseBtn: TToolButton
      Left = 54
      Top = 0
      Caption = '&Cancel'
      ImageIndex = 31
      OnClick = CloseBtnClick
    end
    object ToolButton2: TToolButton
      Left = 100
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 2
      Style = tbsSeparator
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 48
    Width = 595
    Height = 441
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'File Format Options'
      object NormalSecLbl: TLabel
        Left = 40
        Top = 33
        Width = 409
        Height = 29
        AutoSize = False
        Caption = 
          'If the files searched contain plain text lines or there isn'#39't an' +
          'y format, then this option should be checked (default option).'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 40
        Top = 86
        Width = 82
        Height = 13
        Caption = 'First char position'
      end
      object Label4: TLabel
        Left = 40
        Top = 110
        Width = 33
        Height = 13
        Caption = 'Length'
      end
      object Label5: TLabel
        Left = 40
        Top = 158
        Width = 77
        Height = 13
        Caption = 'First row number'
      end
      object Label6: TLabel
        Left = 40
        Top = 182
        Width = 78
        Height = 13
        Caption = 'Last row number'
      end
      object Label7: TLabel
        Left = 40
        Top = 302
        Width = 77
        Height = 13
        Caption = 'First row number'
      end
      object Label8: TLabel
        Left = 40
        Top = 326
        Width = 78
        Height = 13
        Caption = 'Last row number'
      end
      object Label9: TLabel
        Left = 40
        Top = 353
        Width = 94
        Height = 13
        Caption = 'First column number'
      end
      object Label10: TLabel
        Left = 40
        Top = 377
        Width = 33
        Height = 13
        Caption = 'Length'
      end
      object Label11: TLabel
        Left = 344
        Top = 94
        Width = 60
        Height = 13
        Caption = 'Field number'
      end
      object Label12: TLabel
        Left = 344
        Top = 166
        Width = 79
        Height = 13
        Caption = 'First field number'
      end
      object Label13: TLabel
        Left = 344
        Top = 190
        Width = 80
        Height = 13
        Caption = 'Last field number'
      end
      object Label14: TLabel
        Left = 344
        Top = 254
        Width = 77
        Height = 13
        Caption = 'First row number'
      end
      object Label15: TLabel
        Left = 344
        Top = 278
        Width = 78
        Height = 13
        Caption = 'Last row number'
      end
      object Label16: TLabel
        Left = 344
        Top = 305
        Width = 79
        Height = 13
        Caption = 'First field number'
      end
      object Label17: TLabel
        Left = 344
        Top = 329
        Width = 80
        Height = 13
        Caption = 'Last field number'
      end
      object Label2: TLabel
        Left = 40
        Top = 230
        Width = 74
        Height = 13
        Caption = 'First col number'
      end
      object Label18: TLabel
        Left = 40
        Top = 254
        Width = 54
        Height = 13
        Caption = 'Field length'
      end
      object Label19: TLabel
        Left = 328
        Top = 360
        Width = 168
        Height = 13
        Caption = 'Seperate Character for CSV formats'
      end
      object SecNormal: TRadioButton
        Left = 24
        Top = 16
        Width = 113
        Height = 17
        Caption = 'Normal'
        TabOrder = 0
        OnClick = SecNormalClick
      end
      object SecKarakterAra: TRadioButton
        Left = 24
        Top = 64
        Width = 185
        Height = 17
        Caption = 'Within a particular character range'
        TabOrder = 1
        OnClick = SecNormalClick
      end
      object SecIkiSatir: TRadioButton
        Left = 24
        Top = 135
        Width = 177
        Height = 17
        Caption = 'Within Range of Two Lines'
        TabOrder = 4
        OnClick = SecNormalClick
      end
      object SecSatirSutun: TRadioButton
        Left = 24
        Top = 280
        Width = 217
        Height = 17
        Caption = 'By Specifying Line and Column Range'
        TabOrder = 10
        OnClick = SecNormalClick
      end
      object SecCsvTekli: TRadioButton
        Left = 312
        Top = 72
        Width = 193
        Height = 17
        Caption = 'Search in a column of CSV format file'
        TabOrder = 15
        OnClick = SecNormalClick
      end
      object SecCsvIkili: TRadioButton
        Left = 312
        Top = 144
        Width = 241
        Height = 17
        Caption = 'Search in 2 Column Range in CSV format file'
        TabOrder = 17
        OnClick = SecNormalClick
      end
      object SecCsvSatCol: TRadioButton
        Left = 312
        Top = 219
        Width = 250
        Height = 24
        Caption = 'Search By Specifying Line and Column Range in CSV File'
        TabOrder = 20
        WordWrap = True
        OnClick = SecNormalClick
      end
      object KarakterAra1: TEdit
        Left = 135
        Top = 82
        Width = 55
        Height = 21
        TabOrder = 2
        Text = '0'
      end
      object KarakterAra2: TEdit
        Left = 135
        Top = 106
        Width = 55
        Height = 21
        TabOrder = 3
        Text = '0'
      end
      object IkiSatir1: TEdit
        Left = 135
        Top = 154
        Width = 55
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object IkiSatir2: TEdit
        Left = 135
        Top = 178
        Width = 55
        Height = 21
        TabOrder = 6
        Text = '0'
      end
      object SatirSutun1: TEdit
        Left = 135
        Top = 298
        Width = 55
        Height = 21
        TabOrder = 11
        Text = '0'
      end
      object SatirSutun2: TEdit
        Left = 135
        Top = 322
        Width = 55
        Height = 21
        TabOrder = 12
        Text = '0'
      end
      object SatirSutun3: TEdit
        Left = 135
        Top = 349
        Width = 55
        Height = 21
        TabOrder = 13
        Text = '0'
      end
      object SatirSutun4: TEdit
        Left = 135
        Top = 373
        Width = 55
        Height = 21
        TabOrder = 14
        Text = '0'
      end
      object CsvTekli1: TEdit
        Left = 439
        Top = 90
        Width = 55
        Height = 21
        TabOrder = 16
        Text = '0'
      end
      object CsvIkili1: TEdit
        Left = 439
        Top = 162
        Width = 55
        Height = 21
        TabOrder = 18
        Text = '0'
      end
      object CsvIkili2: TEdit
        Left = 439
        Top = 186
        Width = 55
        Height = 21
        TabOrder = 19
        Text = '0'
      end
      object CsvSatCol1: TEdit
        Left = 439
        Top = 250
        Width = 55
        Height = 21
        TabOrder = 21
        Text = '0'
      end
      object CsvSatCol2: TEdit
        Left = 439
        Top = 274
        Width = 55
        Height = 21
        TabOrder = 22
        Text = '0'
      end
      object CsvSatCol3: TEdit
        Left = 439
        Top = 301
        Width = 55
        Height = 21
        TabOrder = 23
        Text = '0'
      end
      object CsvSatCol4: TEdit
        Left = 439
        Top = 325
        Width = 55
        Height = 21
        TabOrder = 24
        Text = '0'
      end
      object SecIkiSutun: TRadioButton
        Left = 24
        Top = 208
        Width = 153
        Height = 17
        Caption = 'Search in Column Range'
        TabOrder = 7
        OnClick = SecNormalClick
      end
      object IkiSutun1: TEdit
        Left = 135
        Top = 226
        Width = 55
        Height = 21
        TabOrder = 8
        Text = '0'
      end
      object IkiSutun2: TEdit
        Left = 135
        Top = 250
        Width = 55
        Height = 21
        TabOrder = 9
        Text = '0'
      end
      object CSVCharacter: TComboBox
        Left = 344
        Top = 376
        Width = 77
        Height = 21
        ItemHeight = 13
        MaxLength = 1
        TabOrder = 25
        Text = ';'
        Items.Strings = (
          ';'
          ','
          'TAB'
          'SPACE'
          '')
      end
    end
  end
end
