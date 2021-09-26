{ 
 Multi Replacer
 A very capable Windows Grep, search, replace and data extraction tool. www.multireplacer.com
 
 Programmed by Atilla YARALI.  www.atillayarali.com

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 }
 
unit PreviewU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, NicePreview, ComCtrls,Grids,RepThreadU, Buttons;

type
  TPreviewF = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    DefaultBtn: TBitBtn;
    ZoomInBtn: TBitBtn;
    ZoomOutBtn: TBitBtn;
    FitToWidthBtn: TBitBtn;
    WholePageBtn: TBitBtn;
    TwoPagesBtn: TBitBtn;
    FourPagesBtn: TBitBtn;
    ActualSizeBtn: TBitBtn;
    PrintBtn: TBitBtn;
    DragBtn: TBitBtn;
    PrintDialog1: TPrintDialog;

    procedure NicePreview1Change(Sender: TObject);
    procedure DefaultBtnClick(Sender: TObject);
    procedure ZoomInBtnClick(Sender: TObject);
    procedure ZoomOutBtnClick(Sender: TObject);
    procedure FitToWidthBtnClick(Sender: TObject);
    procedure WholePageBtnClick(Sender: TObject);
    procedure TwoPagesBtnClick(Sender: TObject);
    procedure FourPagesBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActualSizeBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure DragBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }
  public
    NicePreview1: TNicePreview;
    procedure RenderTexts;
    procedure RenderGrids;
    procedure RenderGraphics;
  end;

var
  PreviewF: TPreviewF;

implementation

{$R *.dfm}
uses RepMainU;

procedure TPreviewF.NicePreview1Change(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Page ' + IntToStr(NicePreview1.PageIndex + 1) +
    ' of ' + IntToStr(NicePreview1.PageCount);
  StatusBar1.Panels[1].Text := 'Magnification ' + IntToStr(Round(NicePreview1.Magnification * 100)) + '%';
end;

procedure TPreviewF.DefaultBtnClick(Sender: TObject);
begin
  NicePreview1.PreviewMode := pmNormal;
end;

procedure TPreviewF.ZoomInBtnClick(Sender: TObject);
begin
  NicePreview1.PreviewMode := pmZoomIn;
end;

procedure TPreviewF.ZoomOutBtnClick(Sender: TObject);
begin
  NicePreview1.PreviewMode := pmZoomOut;
end;

procedure TPreviewF.DragBtnClick(Sender: TObject);
begin
  NicePreview1.PreviewMode := pmDrag;
end;

procedure TPreviewF.ActualSizeBtnClick(Sender: TObject);
begin
  NicePreview1.ViewActualSize;
end;

procedure TPreviewF.FitToWidthBtnClick(Sender: TObject);
begin
  NicePreview1.ViewFitToWidth;
end;

procedure TPreviewF.WholePageBtnClick(Sender: TObject);
begin
  NicePreview1.ViewWholePage;
end;

procedure TPreviewF.TwoPagesBtnClick(Sender: TObject);
begin
  NicePreview1.ViewTwoPage;
end;

procedure TPreviewF.FourPagesBtnClick(Sender: TObject);
begin
  NicePreview1.ViewFourPage;
end;

procedure TPreviewF.FormCreate(Sender: TObject);
var
  x: Integer;
begin
  NicePreview1:= TNicePreview.Create(self);
  NicePreview1.Parent:=Self;
  NicePreview1.Align:=alClient;


end;

procedure TPreviewF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

procedure TPreviewF.RenderTexts;
var
  ACanvas: TCanvas;
  h: Integer;
  th: Integer;
  i, j: Integer;
  t: TASCMRStringList;

begin

  NicePreview1.Clear;

  t := TASCMRStringList.Create;
  try
    t.LoadFromFile('..\License.txt');
  except
    ShowMessage('File ..\License.txt doesn''t exist. Unable to render preview.'#13 +
      'If you run this file from ZIP extractor program, extract all files first and rerun.');
  end;

  if (t.Count = 0) then
  begin
    t.Free;
    Exit;
  end;

  with NicePreview1 do
  begin
    th := PageHeight - MarginTop - MarginBottom;
  end;

  i := 0;
  j := -1;
  h := 0;
  ACanvas := nil;

  repeat

    if (j < h) then
    begin
      if (ACanvas <> nil)
        then NicePreview1.EndPage;
      ACanvas := NicePreview1.BeginPage;
      with ACanvas do
      begin
        Font.Name := 'Lucida Console';
        Font.Size := 8;
        h := TextHeight('Ag');
      end;
      j := th;
    end;

    ACanvas.TextOut(NicePreview1.MarginLeft, NicePreview1.MarginTop + (th - j), t[i]);

    Inc(i);
    Dec(j, h);

  until (i >= t.Count);

  NicePreview1.EndPage;

  t.Free;

end;

procedure TPreviewF.RenderGraphics;
const
  Str1 = 'Looks Familiar?';
  Str2 = 'This is copy of your desktop window!';

var
  Bmp: TBitmap;
  DeskDC: HDC;
  DeskWnd: HWND;
  w, h: Integer;
  x, y: Integer;

begin
  Bmp := TBitmap.Create;

  with NicePreview1 do
  begin
    w := PageWidth - MarginLeft - MarginRight;
    h := Round((w / Screen.DesktopWidth) * Screen.DesktopHeight);
    x := (PageWidth - w) div 2;
    y := (PageHeight - h) div 2;
  end;

  Bmp.Width := w;
  Bmp.Height := h;

  DeskWnd := GetDesktopWindow;
  DeskDC := GetDC(DeskWnd);
  StretchBlt(Bmp.Canvas.Handle, 0, 0, w, h,
    DeskDC, 0, 0, Screen.DesktopWidth, Screen.DesktopHeight, SRCCOPY);
  ReleaseDC(DeskWnd, DeskDC);


  NicePreview1.Clear;
  with NicePreview1.BeginPage, NicePreview1 do
  begin
    Draw(x, y, Bmp);

    Font.Name := 'Courier New';
    Font.Size := 18;
    Font.Style := [];
    Font.Color := clRed;
    w := TextWidth(Str2);
    h := TextHeight(Str2);
    x := (PageWidth - w) div 2;
    y := y - 50 - h;
    TextOut(x, y, Str2);

    Font.Name := 'Arial';
    Font.Size := 24;
    Font.Style := [fsBold];
    Font.Color := clBlack;
    w := TextWidth(Str1);
    h := TextHeight(Str1);
    x := (PageWidth - w) div 2;
    y := y - 5 - h;
    TextOut(x, y, Str1);

  end;
  NicePreview1.EndPage;



  Bmp.Free;
end;


procedure TPreviewF.RenderGrids;
const
  Str1 = 'This is a grid test.';
  Str2 = 'All like drawing on ordinary screen canvas.';
var
  x, y, w, h: Integer;
  R: TRect;
  ax, ay: Integer;
  DeltaX: Integer;

begin

  NicePreview1.Clear;

  with NicePreview1.BeginPage do
  begin

    Font.Name := 'Arial';
    Font.Size := 24;
    Font.Style := [fsBold];
    Font.Color := clBlack;
    w := TextWidth(Str1);
    h := TextHeight(Str1);
    x := (NicePreview1.PageWidth - w) div 2;
    y := NicePreview1.MarginTop;
    TextOut(x, y, Str1);
    y := y + h + 5;

    Font.Name := 'Courier New';
    Font.Size := 16;
    Font.Style := [];
    Font.Color := clRed;
    w := TextWidth(Str2);
    h := TextHeight(Str2);
    x := (NicePreview1.PageWidth - w) div 2;
    TextOut(x, y, Str2);
    y := y + h + 30;

    Font.Name := 'Arial';
    Font.Size := 8;
    Font.Style := [];
    Font.Color := clBlack;
    w := (NicePreview1.PageWidth - NicePreview1.MarginLeft - nicePreview1.MarginRight) div 10;
    h := TextHeight('Ag') + 3;
    DeltaX := (NicePreview1.PageWidth - (w * 10)) div 2;
    Brush.Style := bsClear;

    for ax := 0 to 9 do
    begin
      for ay := 0 to 29 do
      begin
        R := Rect(ax * w, ay * h, ((ax + 1) * w) + 1, ((ay + 1) * h) + 1);
        OffsetRect(R, DeltaX, y);
        Brush.Style := bsSolid;
        Rectangle(R);
        Brush.Style := bsClear;
        TextRect(R, R.Left + 5, R.Top + 3, IntToStr(ax) + ',' + IntToStr(ay));
      end;
    end;

  end;

  NicePreview1.EndPage;

end;


procedure TPreviewF.PrintBtnClick(Sender: TObject);
var
   j:integer;
begin

  PrintDialog1.MinPage:=1;
  PrintDialog1.MaxPage:=NicePreview1.PageCount;
  if PrintDialog1.Execute then
  begin
       case PrintDialog1.PrintRange of
            prAllPages:
            begin
                 NicePreview1.PrintAll;
            end;
            prPageNums:
            begin
                 if (PrintDialog1.FromPage>0) and (PrintDialog1.ToPage>0) then
                 begin
                      NicePreview1.PrintPageRange(PrintDialog1.FromPage,PrintDialog1.ToPage);
                 end;

            end;
            prSelection:
            begin
                 NicePreview1.PrintPage(NicePreview1.PageIndex);


            end;
       end;
  end;

end;

end.
