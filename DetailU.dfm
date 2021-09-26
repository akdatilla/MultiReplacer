object DetailF: TDetailF
  Left = 0
  Top = 0
  Caption = 'Details'
  ClientHeight = 712
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ContentRE: TRichEdit
    Left = 0
    Top = 0
    Width = 697
    Height = 712
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
      object ShellOpen1: TMenuItem
        Caption = 'Shell Open'
        ImageIndex = 19
        ShortCut = 24589
        OnClick = ShellOpen1Click
      end
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
    object Edit1: TMenuItem
      Caption = 'Edit'
      ImageIndex = 3
      object Next1: TMenuItem
        Caption = 'Next Match'
        ImageIndex = 21
        ShortCut = 116
        OnClick = Next1Click
      end
      object PriorWord1: TMenuItem
        Caption = 'Prior Word'
        ImageIndex = 22
        ShortCut = 117
        OnClick = PriorWord1Click
      end
      object FirstWord1: TMenuItem
        Caption = 'First Word'
        ImageIndex = 24
        ShortCut = 118
        OnClick = FirstWord1Click
      end
      object LastWord1: TMenuItem
        Caption = 'Last Word'
        ImageIndex = 23
        ShortCut = 119
        OnClick = LastWord1Click
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
