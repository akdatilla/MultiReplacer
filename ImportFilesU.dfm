object ImportFilesF: TImportFilesF
  Left = 84
  Top = 182
  AutoSize = True
  Caption = 'Select File Source'
  ClientHeight = 454
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PGCtrl: TPageControl
    Left = 0
    Top = 0
    Width = 461
    Height = 454
    ActivePage = TabSheet1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Select Directory'
      DesignSize = (
        453
        426)
      object DestBevel1: TBevel
        Left = 11
        Top = 254
        Width = 438
        Height = 130
      end
      object Bevel4: TBevel
        Left = 12
        Top = 8
        Width = 437
        Height = 239
      end
      object ASCLabel1: TLabel
        Left = 18
        Top = 13
        Width = 425
        Height = 18
        AutoSize = False
        Caption = '  Source List'
        Color = 15658734
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
      end
      object ASCLabel3: TLabel
        Left = 17
        Top = 200
        Width = 104
        Height = 21
        AutoSize = False
        Caption = '  Include File Patern'
        Color = 15658734
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
      end
      object DestL1: TLabel
        Left = 18
        Top = 333
        Width = 425
        Height = 18
        AutoSize = False
        Caption = '  Destination Directory'
        Color = 15658734
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
      end
      object Label1: TLabel
        Left = 173
        Top = 200
        Width = 104
        Height = 21
        AutoSize = False
        Caption = '  Exclude File Patern'
        Color = 15658734
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
      end
      object InMaskE: TEdit
        Left = 123
        Top = 200
        Width = 45
        Height = 21
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '*.*'
      end
      object OkBtn1: TBitBtn
        Left = 273
        Top = 387
        Width = 87
        Height = 33
        Anchors = [akRight, akBottom]
        Caption = 'OK'
        TabOrder = 10
        OnClick = OkBtn1Click
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
        NumGlyphs = 2
      end
      object CancelBtn1: TBitBtn
        Left = 362
        Top = 387
        Width = 81
        Height = 33
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 11
        OnClick = CancelBtn1Click
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
        NumGlyphs = 2
      end
      object DestBtn1: TBitBtn
        Left = 399
        Top = 352
        Width = 41
        Height = 25
        TabOrder = 9
        OnClick = DestBtn1Click
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF46BCEB
          3DB6EB3DB6EB3DB6EB3DB6EB3DB6EB37B2EB37B2EB37B2EB37B2EB37B2EB37B2
          EB32AEEBFFFFFFFFFFFFFFFFFF46BCEBC4F3FDCFF4FCCFF4FCC4F3FDC3EEFBBD
          EAF9B5EAF8B0E6F6AAE3F6AAE3F6BDEAF932AEEBFFFFFFFFFFFFFFFFFF46BCEB
          C4F3FDACEEFCACEEFCA1E9F997E4F78DE0F683DBF376D5F169CEED69CEEDAAE3
          F632AEEBFFFFFFFFFFFFFFFFFF51C6EBCFF4FCACEEFCACEEFCACEEFCA1E9F997
          E4F78DE0F683DBF376D5F176D5F1B0E6F632AEEBFFFFFFFFFFFFFFFFFF51C6EB
          D3F6FFB6F3FEB6F3FEACEEFCACEEFCA1E9F997E4F78DE0F683DBF383DBF3B5EA
          F832AEEBFFFFFFFFFFFFFFFFFF51C6EBF3FBFFF3FBFFF3FBFFE8F7FCACEEFCAC
          EEFCA1E9F997E4F797E4F78DE0F6C3EEFB32AEEBFFFFFFFFFFFFFFFFFF51C6EB
          51C6EB51C6EB51C6EB51C6EBE8F7FCE8F7FCE8F7FCC3EEFBC3EEFBB5EAF8C4F3
          FD32AEEBFFFFFFFFFFFFFFFFFF8CD1EBF3FBFFCEF7FFCEF7FFC5F7FF51C6EB46
          BCEB46BCEB46BCEB3DB6EB3DB6EB37B2EB32AEEBFFFFFFFFFFFFFFFFFF98D3EB
          FFFFFFCEF7FFCEF7FFCEF7FFC5F7FFC5F7FFC5F7FFC5F7FFB6F3FEB6F3FEC5F7
          FF31CFEBFFFFFFFFFFFFFFFFFF98D3EBFFFFFFCEF7FFCEF7FFCEF7FFC5F7FF69
          CEED51C6EB51C6EB31CFEB31CFEB31CFEB31CFEBFFFFFFFFFFFFFFFFFFFFFFFF
          98D3EB98D3EB8BCFEB79CDEB79CDEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      end
      object DestE1: TEdit
        Left = 18
        Top = 353
        Width = 378
        Height = 24
        Color = clWhite
        Font.Charset = TURKISH_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
      object DestOptionsR1: TRadioGroup
        Left = 18
        Top = 260
        Width = 215
        Height = 65
        Caption = 'Destination Directory Options'
        ItemIndex = 0
        Items.Strings = (
          'Default Destination Directory'
          'Specific Destination Directory')
        TabOrder = 7
        OnClick = DestOptionsR1Click
      end
      object ExMaskE: TEdit
        Left = 279
        Top = 200
        Width = 53
        Height = 21
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object SubsChk: TCheckBox
        Left = 24
        Top = 225
        Width = 169
        Height = 17
        Caption = 'Sub Directories'
        TabOrder = 6
      end
      object BitBtn1: TBitBtn
        Left = 338
        Top = 198
        Width = 105
        Height = 25
        Caption = 'Other Properties'
        TabOrder = 5
        OnClick = BitBtn1Click
      end
      object SourceList: TCheckListBox
        Left = 24
        Top = 40
        Width = 419
        Height = 129
        ItemHeight = 13
        TabOrder = 0
      end
      object SelAllBtn: TBitBtn
        Left = 26
        Top = 172
        Width = 105
        Height = 25
        Caption = 'Select All'
        TabOrder = 1
        OnClick = SelAllBtnClick
      end
      object DeSelAllBtn: TBitBtn
        Left = 138
        Top = 172
        Width = 105
        Height = 25
        Caption = 'Unselect All'
        TabOrder = 2
        OnClick = DeSelAllBtnClick
      end
    end
  end
end
