object DosyaGosterF: TDosyaGosterF
  Left = 0
  Top = 0
  Caption = 'Details'
  ClientHeight = 664
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ContentRE: TRichEdit
    Left = 0
    Top = 0
    Width = 697
    Height = 664
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object MainMenu1: TMainMenu
    Images = MulRepMainF.ImageList1
    Left = 184
    Top = 136
    object File1: TMenuItem
      Caption = 'File'
      ImageIndex = 25
      object SaveAs1: TMenuItem
        Caption = 'Save As'
        ImageIndex = 7
        ShortCut = 24659
        OnClick = SaveAs1Click
      end
      object Print1: TMenuItem
        Caption = 'Print'
        ImageIndex = 20
        ShortCut = 16464
        OnClick = Print1Click
      end
      object Close1: TMenuItem
        Caption = 'Close'
        ImageIndex = 11
        OnClick = Close1Click
      end
    end
  end
  object sd1: TSaveDialog
    Filter = 'Text File|*.txt|Rich Text Formatted File|*.rtf|Any File|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 96
    Top = 72
  end
  object OD1: TOpenDialog
    Filter = 'Text File|*.txt|Rich Text Formatted File|*.rtf|Any File|*.*'
    Left = 136
    Top = 72
  end
end
