
{-------------------------------------------------------------------------------

The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.


     The Original Code is NicePreview.pas released at April 11st, 2003.
     The Original Code is a part of NicePreview component.
     The Initial Developer of the Original Code is Priyatna.
     (Website: http://www.priyatna.org/ Email: me@priyatna.org)
     All Rights Reserved.


Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

-------------------------------------------------------------------------------}


unit NicePreview;

interface

uses
  Windows, Messages, Classes, Graphics, ExtCtrls, Forms, Controls, Contnrs,
  Printers, Math, SysUtils,RepConstU;

type
  TPageAnchor = record
    Page: Integer;
    X, Y: Integer;
  end;

  TPreviewMode = (pmNormal, pmDrag, pmZoomIn, pmZoomOut);
  TZoomMode = (zmFitToWidth, zmActualSize, zmWholePage, zmTwoPages, zmFourPages, zmCustom);

  TNicePreview = class(TCustomPanel)
  private
    LastZoom: TZoomMode;
    LastCanvas: TMetafileCanvas;
    IsWholePage: Boolean;
    Buffer: TBitmap;
    ClientRect: TRect;
    HorzOffset: Integer;
    VertOffset: Integer;
    MaxHScroll: Integer;
    MaxVScroll: Integer;
    SmallChange: Integer;
    LargeChange: Integer;
    PageCol: Integer;
    PageRow: Integer;
    DeltaX: Integer;
    IsDragging: Boolean;
    LastX, LastY: Integer;
    LastOffX, LastOffY: Integer;
    Pages: TObjectList;

    FPageIndex: Integer;
    FPageWidth: Integer;
    FPageHeight: Integer;
    FTitle: ASCMRString;
    FMarginLeft: Integer;
    FMarginTop: Integer;
    FMarginRight: Integer;
    FMarginBottom: Integer;
    FMagnification: Single;
    FPageAnchor: TPageAnchor;
    FPreviewMode: TPreviewMode;
    FOnChange: TNotifyEvent;

    procedure DoPaint;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMMouseWheel(var Msg: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMSize(var Msg: TMessage); message WM_SIZE;
    procedure WMEraseBkGnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure SetScrollBar(AKind, AMax, APos, AMask: Integer);
    procedure ShowHideScrollBar(HorzVisible, VertVisible: Boolean);
    procedure ResetScrollBar;
    procedure Recalculate;
    function GetPageRect(Index: Integer): TRect;
    procedure DropAnchor(X, Y: Integer);

    function GetPageCount: Integer;
    procedure SetPageIndex(Value: Integer);
    procedure SetMagnification(Value: Single);
    procedure SetPreviewMode(Value: TPreviewMode);
    function GetScrollTrackPos(Kind: Cardinal): Integer;
    function GetMagnification(Mode: TZoomMode): Single;

  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadPrinterConfig;
    procedure Clear;
    function BeginPage: TCanvas;
    procedure EndPage;
    property PageIndex: Integer read FPageIndex write SetPageIndex;
    property PageCount: Integer read GetPageCount;
    property PageWidth: Integer read FPageWidth;
    property PageHeight: Integer read FPageHeight;
    property Magnification: Single read FMagnification write SetMagnification;
    property PreviewMode: TPreviewMode read FPreviewMode write SetPreviewMode;
    procedure ViewActualSize;
    procedure ViewFitToWidth;
    procedure ViewWholePage;
    procedure ViewTwoPage;
    procedure ViewFourPage;
    procedure SaveToMetafile(FileName: ASCMRString; Page: Integer);
    procedure PrintPage(Page: Integer);
    procedure PrintPageRange(PageFrom,PageTo: Integer);
    procedure PrintAll;

  published
    property Title: ASCMRString read FTitle write FTitle;
    property MarginLeft: Integer read FMarginLeft write FMarginLeft;
    property MarginTop: Integer read FMarginTop write FMarginTop;
    property MarginRight: Integer read FMarginRight write FMarginRight;
    property MarginBottom: Integer read FMarginBottom write FMarginBottom;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    property Color default clBtnShadow;
    property Anchors;
    property Align;
    property BevelKind;
    property BorderStyle default bsSingle;
    property BevelOuter default bvNone;
    property BevelInner;

  end;


  procedure Register;


implementation

{$R NicePreview.res}


const
  BETWEENPAGE = 30;

  crHandDrag = 111;
  crZoomIn  = 112;
  crZoomOut = 113;



procedure Register;
begin
  RegisterComponents('priyatna.org', [TNicePreview]);
end;


{ TPrintPreview }


constructor TNicePreview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clBtnShadow;
  BevelOuter := bvNone;
  BorderStyle := bsSingle;
  Width := 200;
  Height := 200;
  TabStop := True;
  TabOrder := 0;

  Screen.Cursors[crHandDrag] := LoadCursor(hInstance, 'CR_HANDDRAG');
  Screen.Cursors[crZoomIn] := LoadCursor(hInstance, 'CR_ZOOMIN');
  Screen.Cursors[crZoomOut] := LoadCursor(hInstance, 'CR_ZOOMOUT');

  Buffer := TBitmap.Create;
  Buffer.Width := 200;
  Buffer.Height := 200;
  ClientRect := Rect(0, 0, 200, 200);
  HorzOffset  := 0;
  VertOffset  := 0;
  MaxHScroll  := 0;
  MaxVScroll  := 0;
  SmallChange := 5;
  LargeChange := 20;
  PageCol := 1;
  PageRow := 0;
  DeltaX := 0;
  LastZoom := zmFitToWidth;

  Pages := TObjectList.Create;
  FMagnification := 1.0;
  FPageIndex := -1;
  FPageWidth := 816;    // default page at 360 printer dpi, 96 screen dpi
  FPageHeight := 1056;
  FMarginLeft := 96;    // 1 inch margins
  FMarginTop := 96;
  FMarginRight := 96;
  FMarginBottom := 96;
  IsWholePage := False;
  FPreviewMode := pmNormal;
  FTitle := 'Printing ...';

end;

destructor TNicePreview.Destroy;
begin
  Pages.Clear;
  Pages.Free;
  Buffer.Free;
  inherited Destroy;
end;

procedure TNicePreview.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_HSCROLL or WS_VSCROLL;
end;

procedure TNicePreview.CreateWnd;
begin
  inherited CreateWnd;
  ShowHideScrollBar(False, False);
end;

procedure TNicePreview.SetScrollBar(AKind, AMax, APos, AMask: Integer);
var Info: TScrollInfo;
begin
  FillChar(Info, SizeOf(TScrollInfo), 0);
  Info.cbSize := SizeOf(TScrollInfo);
  Info.nMin := 0;
  Info.nMax := AMax;
  Info.nPos := APos;
  Info.fMask := AMask;
  SetScrollInfo(Handle, AKind, Info, TRUE);
end;

procedure TNicePreview.ShowHideScrollBar(HorzVisible, VertVisible: Boolean);
begin
  ShowScrollBar(Handle, SB_HORZ, HorzVisible);
  ShowScrollBar(Handle, SB_VERT, VertVisible);
end;

procedure TNicePreview.ResetScrollBar;
begin
  HorzOffset := 0;
  VertOffset := 0;
  SetScrollBar(SB_HORZ, 0, 0, SIF_POS);
  SetScrollBar(SB_VERT, 0, 0, SIF_POS);
end;

function TNicePreview.GetScrollTrackPos(Kind: Cardinal): Integer;
var
  Info: TScrollInfo;
begin
  Info.cbSize := SizeOf(TScrollInfo);
  Info.fMask := SIF_TRACKPOS;
  GetScrollInfo(Handle, Kind, Info);
  Result := Info.nTrackPos;
end;

procedure TNicePreview.WMHScroll(var Msg: TWMVScroll);
var
  Old: Integer;
begin
  Old := HorzOffset;
  case Msg.ScrollCode of
    SB_LINELEFT:
      HorzOffset := Max(0, HorzOffset - SmallChange);
    SB_LINERIGHT:
      HorzOffset := Min(MaxHScroll, HorzOffset + SmallChange);
    SB_PAGELEFT:
      HorzOffset := Max(0, HorzOffset - LargeChange);
    SB_PAGERIGHT:
      HorzOffset := Min(MaxHScroll, HorzOffset + LargeChange);
    SB_THUMBTRACK:
      HorzOffset := GetScrollTrackPos(SB_HORZ);
    SB_THUMBPOSITION:
      HorzOffset := GetScrollTrackPos(SB_HORZ);
  end;
  if (HorzOffset <> Old) then
  begin
    SetScrollBar(SB_HORZ, 0, HorzOffset, SIF_POS);
    DoPaint;
  end;  
end;

procedure TNicePreview.WMVScroll(var Msg: TWMHScroll);
var
  Old: Integer;
begin
  Old := VertOffset;
  case Msg.ScrollCode of
    SB_LINEUP:
      VertOffset := Max(0, VertOffset - SmallChange);
    SB_LINEDOWN:
      VertOffset := Min(MaxVScroll, VertOffset + SmallChange);
    SB_PAGEUP:
      VertOffset := Max(0, VertOffset - LargeChange);
    SB_PAGEDOWN:
      VertOffset := Min(MaxVScroll, VertOffset + LargeChange);
    SB_THUMBTRACK:
      VertOffset := GetScrollTrackPos(SB_VERT);
    SB_THUMBPOSITION:
      VertOffset := GetScrollTrackPos(SB_VERT);
  end;
  if (VertOffset <> Old) then
  begin
    SetScrollBar(SB_VERT, 0, VertOffset, SIF_POS);
    DoPaint;
  end;  
end;

procedure TNicePreview.WMMouseWheel(var Msg: TWMMouseWheel);
var
  Old: Integer;
begin
  Old := VertOffset;
  VertOffset := Max(0, Min(MaxVScroll, VertOffset - Msg.WheelDelta));
  if (VertOffset <> Old) then
  begin
    SetScrollBar(SB_VERT, 0, VertOffset, SIF_POS);
    DoPaint;
  end;  
end;

procedure TNicePreview.WMSize(var Msg: TMessage);
begin
  inherited;
  Buffer.Width := ClientWidth;
  Buffer.Height := ClientHeight;
  ClientRect := Rect(0, 0, Buffer.Width, Buffer.Height);
  Recalculate;
end;

procedure TNicePreview.Paint;
begin
  DoPaint;
end;

procedure TNicePreview.DoPaint;
var
  x: Integer;
  R, R2: TRect;
  Dummy: TRect;

begin
  with Buffer.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    FillRect(Rect(0, 0, Buffer.Width, Buffer.Height));
  end;

  if (Pages.Count > 0) then
  begin
    for x := 0 to Pages.Count-1 do
    begin
      R := GetPageRect(x);
      if InterSectRect(Dummy, R, ClientRect) then
      begin

        with Buffer.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := clWhite;
          FillRect(R);
          Brush.Style := bsClear;
          if (x = FPageIndex)
            then Pen.Color := clRed
            else Pen.Color := clBlack;
          Rectangle(R);

          // Page Shadow
          Brush.Style := bsSolid;
          Brush.Color := clBlack;
          R2 := Rect(R.Right, R.Top + 4, R.Right + 4, R.Bottom + 4);
          FillRect(R2);
          R2 := Rect(R.Left + 4, R.Bottom, R.Right, R.Bottom + 4);
          FillRect(R2);

          StretchDraw(R, TMetafile(Pages[x]));

        end;

      end;

    end;
  end;

  BitBlt(Canvas.Handle, 0, 0, Buffer.Width, Buffer.Height,
    Buffer.Canvas.Handle, 0, 0, SRCCOPY);
end;

function TNicePreview.GetPageCount: Integer;
begin
  Result := Pages.Count;
end;

procedure TNicePreview.SetPageIndex(Value: Integer);
begin
  if (FPageIndex <> Value) then
  begin
    FPageIndex := Value;
    DoPaint;
    if Assigned(FOnChange)
      then FOnChange(Self);
  end;
end;

procedure TNicePreview.Clear;
begin
  Pages.Clear;
  FPageIndex := -1;
  ResetScrollBar;
  Recalculate;
  DoPaint;
end;

procedure TNicePreview.ReadPrinterConfig;
var
  PrinterDpiWidth, PrinterDpiHeight: Integer;
  PrinterPageWidth, PrinterPageHeight: Integer;
  ScreenDpiWidth, ScreenDpiHeight: Integer;
  Dc: HDC;
begin
  try
    PrinterDpiWidth   := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
    PrinterDpiHeight  := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    PrinterPageWidth  := GetDeviceCaps(Printer.handle, PHYSICALWIDTH);
    PrinterPageHeight := GetDeviceCaps(Printer.handle, PHYSICALHEIGHT);
  except
    PrinterDpiWidth   := 360;    // Assumption
    PrinterDpiHeight  := 360;    // This happens when no printer installed.
    PrinterPageWidth  := 3060;
    PrinterPageHeight := 3960;
  end;
  Dc := GetDC(0);
  ScreenDpiWidth  := GetDeviceCaps(Dc, LOGPIXELSX);
  ScreenDpiHeight := GetDeviceCaps(Dc, LOGPIXELSY);
  ReleaseDc(0, Dc);
  FPageWidth  := Round((PrinterPageWidth / PrinterDpiWidth) * ScreenDpiWidth);
  FPageHeight := Round((PrinterPageHeight / PrinterDpiHeight) * ScreenDpiHeight);
end;

procedure TNicePreview.SetMagnification(Value: Single);
begin
  if (Value > 0.1) and (Value < 5.0) then
  begin
    if (FMagnification <> Value) then
    begin
      FMagnification := Value;
      if (FPageAnchor.Page = -1) then
      begin
        FPageAnchor.Page := FPageIndex;
        FPageAnchor.X := PageWidth div 2;
        FPageAnchor.Y := 0;
      end;
      Recalculate;
      DoPaint;
    end;
  end;  
end;

procedure TNicePreview.Recalculate;
var
  w: Integer;
  mw, mh: Integer;
  TotWidth, TotHeight: Integer;
  HVisible, VVisible: Boolean;
  ax, ay, x, y: Integer;

begin

  if (Pages.Count = 0) then
  begin
    FPageIndex := -1;
    ResetScrollBar;
    ShowHideScrollBar(False, False);
  end else
  begin

    if (LastZoom <> zmCustom)
      then FMagnification := GetMagnification(LastZoom);

    mw := Round(FPageWidth * FMagnification);
    mh := Round(FPageHeight * FMagnification);
    
    PageCol := 1;
    w := ClientWidth - (BETWEENPAGE + mw + BETWEENPAGE);
    while (w > (mw + BETWEENPAGE)) do
    begin
      Inc(PageCol);
      w := w - (mw + BETWEENPAGE);
    end;

    if IsWholePage
      then PageCol := 1;

    PageRow := Pages.Count div PageCol;
    if ((Pages.Count mod PageCol) > 0)
      then PageRow := PageRow + 1;
    
    TotWidth  := (mw * PageCol) + (BETWEENPAGE * (PageCol + 1));
    TotHeight := (mh * PageRow) + (BETWEENPAGE * (PageRow + 1));
    
    HVisible := False;
    VVisible := False;
    
    if (TotWidth > ClientWidth) then
    begin
      ShowScrollBar(Handle, SB_HORZ, True);
      HVisible := True;
    end else
    begin
      HorzOffset := 0;
      ShowScrollBar(Handle, SB_HORZ, False);
    end;
    
    if (TotHeight > ClientHeight) then
    begin
      ShowScrollBar(Handle, SB_VERT, True);
      VVisible := True;
    end else
    begin
      VertOffset := 0;
      ShowScrollBar(Handle, SB_VERT, False);
    end;
    
    DeltaX := Max(0, (ClientWidth - TotWidth) div 2);
    MaxHScroll := Max(0, TotWidth - ClientWidth);
    MaxVScroll := Max(0, TotHeight - ClientHeight);
    
    if HVisible then
    begin
      ax := FPageAnchor.Page mod PageCol;
      x := (ax * mw) + (BETWEENPAGE * (ax + 1));
      x := x + Round(FPageAnchor.X * FMagnification);
      x := x - (ClientWidth div 2);
      HorzOffset := Min(MaxHScroll, Max(0, x));
    end;
    
    if VVisible then
    begin
      ay := FPageAnchor.Page div PageCol;
      y := (ay * mh) + (BETWEENPAGE * (ay + 1));
      y := y + Round(FPageAnchor.Y * FMagnification);
      y := y - (ClientHeight div 2);
      VertOffset := Min(MaxVScroll, Max(0, y));
    end;
    
    SetScrollBar(SB_HORZ, MaxHScroll, HorzOffset, SIF_RANGE or SIF_POS);
    SetScrollBar(SB_VERT, MaxVScroll, VertOffset, SIF_RANGE or SIF_POS);

  end;

  if Assigned(FOnChange)
    then FOnChange(Self);

end;

function TNicePreview.GetPageRect(Index: Integer): TRect;
var
  mw, mh: Integer;
  ax, ay: Integer;
  l, t: Integer;
begin
  mw := Round(FPageWidth * FMagnification);
  mh := Round(FPageHeight * FMagnification);
  ax := Index mod PageCol;
  ay := Index div PageCol;
  l := (ax * mw) + (BETWEENPAGE * (ax + 1));
  t := (ay * mh) + (BETWEENPAGE * (ay + 1));
  l := l - HorzOffset + DeltaX;
  t := t - VertOffset;
  Result := Rect(l, t, l + mw, t + mh);
end;


function TNicePreview.BeginPage: TCanvas;
var
  Wmf: TMetafile;
begin
  Wmf := TMetafile.Create;
  Wmf.Width := PageWidth;
  Wmf.Height := PageHeight;
  Pages.Add(Wmf);
  Recalculate;
  LastCanvas := TMetafileCanvas.Create(Wmf, 0);
  Result := LastCanvas;
end;

procedure TNicePreview.EndPage;
begin
  LastCanvas.Free;
  DoPaint;
end;

procedure TNicePreview.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
    DropAnchor(X, Y);
    if (FPageAnchor.Page <> -1) then
    begin
      PageIndex := FPageAnchor.Page;
      case FPreviewMode of
        pmNormal: ;
        pmDrag:
          begin
            IsDragging := True;
            LastX := X;
            LastY := Y;
            LastOffX := HorzOffset;
            LastOffY := VertOffset;
          end;
        pmZoomIn:
          begin
            IsWholePage := False;
            Magnification := Min(5.0, Magnification + 0.1);
          end;
        pmZoomOut:
          begin
            IsWholePage := False;
            Magnification := Max(0.1, Magnification - 0.1);
          end;
      end;
    end;
  end;
  SetFocus;
  inherited;
end;

procedure TNicePreview.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  OldX, OldY: Integer;
begin
  if IsDragging then
  begin
    OldX := HorzOffset;
    OldY := VertOffset;
    HorzOffset := Max(0, Min(MaxHScroll, LastOffX + (LastX - X)));
    VertOffset := Max(0, Min(MaxVScroll, LastOffY + (LastY - Y)));
    if (OldX <> HorzOffset) or (OldY <> VertOffset) then
    begin
      SetScrollBar(SB_HORZ, 0, HorzOffset, SIF_POS);
      SetScrollBar(SB_VERT, 0, VertOffset, SIF_POS);
      DoPaint;
    end;
  end;
  inherited;
end;

procedure TNicePreview.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsDragging := False;
  inherited;
end;

procedure TNicePreview.SetPreviewMode(Value: TPreviewMode);
begin
  if (FPreviewMode <> Value) then
  begin
    FPreviewMode := Value;
    case FPreviewMode of
      pmNormal:  Cursor := crDefault;
      pmDrag:    Cursor := crHandDrag;
      pmZoomIn:
        begin
          Cursor := crZoomIn;
          LastZoom := zmCustom;
        end;
      pmZoomOut:
        begin
          Cursor := crZoomOut;
          LastZoom := zmCustom;
        end;
    end;
    if Assigned(FOnChange)
      then FOnChange(Self);
  end;
end;

procedure TNicePreview.DropAnchor(X, Y: Integer);
var
  mw, mh: Integer;
  ax, ay: Integer;
  px, py: Integer;
  nx, ny: Integer;
begin
  ax := X + HorzOffset - DeltaX;
  ay := Y + VertOffset;
  mw := Round(PageWidth * FMagnification);
  mh := Round(PageHeight * FMagnification);
  px := mw + BETWEENPAGE;
  py := mh + BETWEENPAGE;
  nx := ax div px;
  ny := ay div py;
  FPageAnchor.Page := (ny * PageCol) + nx;
  FPageAnchor.X := Round(((ax mod px) - BETWEENPAGE) / FMagnification);
  FPageAnchor.Y := Round(((ay mod py) - BETWEENPAGE) / FMagnification);
  if not PtInRect(Rect(0, 0, PageWidth, PageHeight), Point(FPageAnchor.X, FPageAnchor.Y)) then
  begin
    FPageAnchor.Page := -1;
    FPageAnchor.X := -1;
    FPageAnchor.Y := -1;
  end;
end;

function TNicePreview.GetMagnification(Mode: TZoomMode): Single;
var
  H, V: Single;
begin
  Result := 1;
  case Mode of
    zmFitToWidth:
      Result := (ClientWidth - (2 * BETWEENPAGE) - GetSystemMetrics(SM_CXVSCROLL)) / PageWidth;
    zmActualSize:
      Result := 1.0;
    zmWholePage:
      begin
        H := (ClientWidth - (2 * BETWEENPAGE) - GetSystemMetrics(SM_CXVSCROLL)) / PageWidth;
        V := (ClientHeight - (2 * BETWEENPAGE) - GetSystemMetrics(SM_CYHSCROLL)) / PageHeight;
        Result := Min(H, V);
      end;
    zmTwoPages:
      Result := ((ClientWidth - (3 * BETWEENPAGE) - GetSystemMetrics(SM_CXVSCROLL)) / 2) / PageWidth;
    zmFourPages:
      Result := ((ClientWidth - (5 * BETWEENPAGE) - GetSystemMetrics(SM_CXVSCROLL)) / 4) / PageWidth;
  end;
end;

procedure TNicePreview.ViewFitToWidth;
begin
  IsWholePage := False;
  LastZoom := zmFitToWidth;
  Magnification := GetMagnification(zmFitToWidth);
end;

procedure TNicePreview.ViewFourPage;
begin
  IsWholePage := False;
  LastZoom := zmFourPages;
  Magnification := GetMagnification(zmFourPages);
end;

procedure TNicePreview.ViewTwoPage;
begin
  IsWholePage := False;
  LastZoom := zmTwoPages;
  Magnification := GetMagnification(zmTwoPages);
end;

procedure TNicePreview.ViewWholePage;
begin
  IsWholePage := True;
  LastZoom := zmWholePage;
  Magnification := GetMagnification(zmWholePage);
end;

procedure TNicePreview.ViewActualSize;
begin
  IsWholePage := False;
  LastZoom := zmActualSize;
  Magnification := GetMagnification(zmActualSize);
end;

procedure TNicePreview.PrintAll;
var
  Wmf: TMetafile;
  x: Integer;
begin
  if (Pages.Count > 0) then
  begin
    with Printer do
    begin
      Title := FTitle;
      BeginDoc;
      for x := 0 to Pages.Count-1 do
      begin
        Wmf := TMetafile(Pages[x]);
        Canvas.StretchDraw(Rect(0, 0, PageWidth, PageHeight), Wmf);
        if (x <> Pages.Count-1)
          then NewPage;
      end;
      EndDoc;
    end;
  end;
end;

procedure TNicePreview.PrintPage(Page: Integer);
var
  Wmf: TMetafile;
begin
  Wmf := TMetafile(Pages[Page]);
  with Printer do
  begin
    Title := FTitle + ' - Page ' + IntToStr(Page + 1);
    BeginDoc;
    Canvas.StretchDraw(Rect(0, 0, PageWidth, PageHeight), Wmf);
    EndDoc;
  end;
end;

procedure TNicePreview.PrintPageRange(PageFrom, PageTo: Integer);
var
  Wmf: TMetafile;
  x: Integer;
begin
  if (Pages.Count > 0) then
  begin
    with Printer do
    begin
      Title := FTitle;
      BeginDoc;
      for x := PageFrom to PageTo do
      begin
        Wmf := TMetafile(Pages[x]);
        Canvas.StretchDraw(Rect(0, 0, PageWidth, PageHeight), Wmf);
        if (x <> PageTo)
          then NewPage;
      end;
      EndDoc;
    end;
  end;
end;

procedure TNicePreview.SaveToMetafile(FileName: ASCMRString; Page: Integer);
begin
  TMetafile(Pages[Page]).SaveToFile(FileName);
end;

procedure TNicePreview.WMEraseBkGnd(var Msg: TMessage);
begin
  Msg.Result := 1;
end;

end.
