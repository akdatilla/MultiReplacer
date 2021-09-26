object WordEditF: TWordEditF
  Left = 28
  Top = 69
  BorderStyle = bsToolWindow
  Caption = 'Add Word'
  ClientHeight = 396
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  DesignSize = (
    454
    396)
  PixelsPerInch = 96
  TextHeight = 16
  object SearchL: TLabel
    Left = 8
    Top = 14
    Width = 91
    Height = 21
    AutoSize = False
    Caption = ' Search Text'
    Transparent = False
    Layout = tlCenter
  end
  object NewL: TLabel
    Left = 8
    Top = 151
    Width = 91
    Height = 21
    AutoSize = False
    Caption = ' Replace Text'
    Transparent = False
    Layout = tlCenter
  end
  object SubMatchL: TLabel
    Left = 8
    Top = 89
    Width = 114
    Height = 21
    AutoSize = False
    Caption = ' Sub Match Text'
    Transparent = False
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 12
    Top = 300
    Width = 91
    Height = 21
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'O&n matched'
    FocusControl = SingleOnMatching
    Transparent = False
    Layout = tlCenter
  end
  object Label1: TLabel
    Left = 12
    Top = 252
    Width = 91
    Height = 21
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'Re&quirement'
    FocusControl = MatchReqC
    Transparent = False
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 164
    Top = 251
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = '&Group No '
    FocusControl = GroupE
    Transparent = False
    Layout = tlCenter
  end
  object SysVarL1: TLabel
    Left = 59
    Top = 63
    Width = 58
    Height = 15
    AutoSize = False
    Caption = 'Use Sys.Var'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    OnClick = SysVarL1Click
  end
  object SysVarL2: TLabel
    Left = 56
    Top = 127
    Width = 58
    Height = 15
    AutoSize = False
    Caption = 'Use Sys.Var'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    OnClick = SysVarL2Click
  end
  object SysVarL3: TLabel
    Left = 59
    Top = 183
    Width = 58
    Height = 15
    AutoSize = False
    Caption = 'Use Sys.Var'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    OnClick = SysVarL3Click
  end
  object HexLbl1: TLabel
    Left = 49
    Top = 50
    Width = 64
    Height = 11
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Enter Hex Data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    OnClick = HexLbl1Click
  end
  object HexLbl2: TLabel
    Left = 49
    Top = 113
    Width = 64
    Height = 11
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Enter Hex Data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    OnClick = HexLbl2Click
  end
  object HexLbl3: TLabel
    Left = 52
    Top = 172
    Width = 64
    Height = 11
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Enter Hex Data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
    OnClick = HexLbl3Click
  end
  object SubMatchE: TMemo
    Left = 128
    Top = 88
    Width = 313
    Height = 53
    TabOrder = 1
  end
  object OkBtn: TBitBtn
    Left = 125
    Top = 348
    Width = 109
    Height = 39
    Anchors = [akLeft, akBottom]
    Caption = '&Ok'
    TabOrder = 13
    OnClick = OkBtnClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    Margin = 8
    NumGlyphs = 2
  end
  object CancelBtn: TBitBtn
    Left = 239
    Top = 348
    Width = 108
    Height = 39
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 14
    OnClick = CancelBtnClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    Margin = 8
    NumGlyphs = 2
  end
  object CaseChk: TCheckBox
    Left = 12
    Top = 208
    Width = 121
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Case Sensitive'
    TabOrder = 3
  end
  object RegExChk: TCheckBox
    Left = 141
    Top = 208
    Width = 154
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Regular Expressions'
    TabOrder = 4
  end
  object OldE: TMemo
    Left = 128
    Top = 8
    Width = 313
    Height = 73
    TabOrder = 0
  end
  object NewE: TMemo
    Left = 128
    Top = 149
    Width = 313
    Height = 52
    TabOrder = 2
  end
  object SingleWordsOnlyChk: TCheckBox
    Left = 303
    Top = 208
    Width = 144
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Whole Words Only'
    TabOrder = 5
  end
  object SingleOnMatching: TComboBox
    Left = 8
    Top = 321
    Width = 433
    Height = 24
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 12
    Text = 'Continue scanning'
    Items.Strings = (
      'Continue scanning'
      'Bir dosyada bir kez arama yap'
      'Bulunan ilk dosyadan sonra aramay'#305' durdur'
      'Bir dosyada bir kez arama yap. Bulundu'#287'unda aramay'#305' da durdur.'
      'Use Search Starter'
      'Use Search Stopper')
  end
  object FileFormatOptBtn: TBitBtn
    Left = 290
    Top = 267
    Width = 147
    Height = 32
    Anchors = [akLeft, akBottom]
    Caption = '&File Format Options'
    TabOrder = 11
    OnClick = FileFormatOptBtnClick
  end
  object SearchOnlyChk: TCheckBox
    Left = 11
    Top = 231
    Width = 121
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Search Only'
    TabOrder = 6
  end
  object KeepCaseChk: TCheckBox
    Left = 141
    Top = 231
    Width = 142
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Keep Case Option'
    TabOrder = 7
  end
  object MatchReqC: TComboBox
    Left = 8
    Top = 272
    Width = 137
    Height = 24
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 8
    Text = 'Not Required'
    Items.Strings = (
      'Not Required'
      'Match Required'
      'No Match Required')
  end
  object GroupE: TEdit
    Left = 170
    Top = 273
    Width = 49
    Height = 24
    Anchors = [akLeft, akBottom]
    TabOrder = 9
    Text = '0'
  end
  object GroupUpDown: TUpDown
    Left = 219
    Top = 273
    Width = 16
    Height = 24
    Anchors = [akLeft, akBottom]
    Associate = GroupE
    Max = 10000
    TabOrder = 10
  end
  object SysVarPUP: TPopupMenu
    Left = 168
    Top = 40
    object FileInformations1: TMenuItem
      Caption = 'File Informations'
      object svpupsecFILEDIR: TMenuItem
        Caption = 'File Directory'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFULLFILENAME: TMenuItem
        Caption = 'Full File Name'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILENAMEWITHEXT: TMenuItem
        Caption = 'File Name With Extension'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILENAMENOEXT: TMenuItem
        Caption = 'File Name Without Extension'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILEEX: TMenuItem
        Caption = 'File Extension'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILESIZE: TMenuItem
        Caption = 'File Size'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILEMODIFYDATE: TMenuItem
        Caption = 'Modify Date'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILEMODIFYYEAR: TMenuItem
        Caption = 'Modify Year'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILEMODIFYMONTH: TMenuItem
        Caption = 'Modify Month'
        OnClick = svpupsecMenuClick
      end
      object svpupsecFILEMODIFYDAY: TMenuItem
        Caption = 'Modify Day'
        OnClick = svpupsecMenuClick
      end
    end
    object CurrentDateTime1: TMenuItem
      Caption = 'Current DateTime'
      object svpupsecCURRENTDATE: TMenuItem
        Caption = 'Current Date'
        OnClick = svpupsecMenuClick
      end
      object svpupsecCURRENTYEAR: TMenuItem
        Caption = 'Current Year'
        OnClick = svpupsecMenuClick
      end
      object svpupsecCURRENTMONTH: TMenuItem
        Caption = 'Current Month'
        OnClick = svpupsecMenuClick
      end
      object svpupsecCURRENTDAY: TMenuItem
        Caption = 'Current Day'
        OnClick = svpupsecMenuClick
      end
      object svpupsecCURRENTTIME: TMenuItem
        Caption = 'Current Time'
        OnClick = svpupsecMenuClick
      end
    end
  end
end
