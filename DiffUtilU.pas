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
 
unit DiffUtilU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Grids, StdCtrls, ExtCtrls, ImgList,ClipBrd, Menus,RepConstU,RepThreadU,
  ActnList, XPStyleActnCtrls, ActnMan,RepLib,shellapi,Masks;

const
     /// DiffUtilU ile DiffUtilUB arasýndaki farklar
     ///  1: DifUtilType: DiffUtilU için 1 DiffUtilUB için 2 olacak
     ///  2: Form class name: DiffUtilU için TDiffUtilF DiffUtilUB için TDiffUtilBF
     DifUtilType=1;
     /////////////////
type
  TDiffUtilF = class(TForm)
    diffimglist: TImageList;
    Splitter2: TSplitter;
    ToolBar1: TToolBar;
    DiffBtn: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    od1: TOpenDialog;
    ToolButton4: TToolButton;
    sd1: TSaveDialog;
    ToolButton3: TToolButton;
    pg1: TPageControl;
    Sayfa1: TTabSheet;
    TabSheet2: TTabSheet;
    FromGrd: TStringGrid;
    Grd1: TStringGrid;
    TabSheet3: TTabSheet;
    ToGrd: TStringGrid;
    ToolButton5: TToolButton;
    PopupMenu1: TPopupMenu;
    ToolButton6: TToolButton;
    BothShows1: TMenuItem;
    Combined1: TMenuItem;
    N1: TMenuItem;
    FullDiff1: TMenuItem;
    ContextDiff1: TMenuItem;
    DiffsOnly1: TMenuItem;
    loadcanceltim: TTimer;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    EditPUP: TPopupMenu;
    NextChange1: TMenuItem;
    PreviousChange1: TMenuItem;
    LastChange1: TMenuItem;
    FirstChange1: TMenuItem;
    BtnActions: TActionManager;
    BothViewAct: TAction;
    CombinedViewAct: TAction;
    FullDiffAct: TAction;
    ContextDiffAct: TAction;
    DiffsOnlyAct: TAction;
    DiffAct: TAction;
    MenuActions: TActionManager;
    NextChangeAct: TAction;
    PreviousChangeAct: TAction;
    FirstChangeAct: TAction;
    LastChangeAct: TAction;
    CloseAct: TAction;
    ResizeTim: TTimer;
    ShellOpenBtn: TToolButton;
    procedure ToolButton6Click(Sender: TObject);
    procedure DiffsOnly1Click(Sender: TObject);
    procedure ContextDiff1Click(Sender: TObject);
    procedure FullDiff1Click(Sender: TObject);
    procedure Combined1Click(Sender: TObject);
    procedure BothShows1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Grd1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure ToolButton5Click(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure Grd1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Grd1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Grd1Click(Sender: TObject);
    procedure DiffBtnClick(Sender: TObject);
    procedure loadcanceltimTimer(Sender: TObject);
    procedure NextChange1Click(Sender: TObject);
    procedure PreviousChange1Click(Sender: TObject);
    procedure LastChange1Click(Sender: TObject);
    procedure FirstChange1Click(Sender: TObject);
    procedure ResizeTimTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ShellOpenBtnClick(Sender: TObject);
  private
    { Private declarations }
    function ConvertASCStringGrid(Grid:TStringGrid):{$IF DifUtilType=1}TASCStringGrid{$ELSE}TStringGrid{$IFEND};
  public
    { Public declarations }
   floadcancel:boolean; //yükleme esnasýnda kullanýcý iptal ederse
   lookcolumn, //Kaynak grid üzerinde verilerin kontrol edileceði kolon baþlangýcý
   lookcolcount, //kaynak grid üzerinde verilerin kontrol edileceði kolon sayýsý
   ColDiff, //Grid üzerinde diff durumunun gösterileceði kolon
   ColFromData,//Grid üzerinde from data gösterileceði kolon
   ColToData,//Grid üzerinde to data gösterileceði kolon
   ColFromLineNum,//Grid üzerinde FromLineNum gösterileceði kolon
   ColToLineNum:integer;//Grid üzerinde ToLineNum gösterileceði kolon


    DifFile:ASCMRString;
    ContextMaxLine,
    DifFilterStyle, //1:Full,2:Context,3:Diff's only
    DifViewStyle:integer;//1:tek kolon,2:Çift kolon
    DifViewType:integer;
    {$IF DifUtilType=1}
    TNTFromGrd: TASCStringGrid;
    TNTGrd1: TASCStringGrid;
    TNTToGrd: TASCStringGrid;
    {$ELSE}
    TNTFromGrd: TStringGrid;
    TNTGrd1: TStringGrid;
    TNTToGrd: TStringGrid;
    {$IFEND}
    procedure HexLoad(FileDataStr:TMemoryStream;Grid:{$IF DifUtilType=1}TASCStringGrid{$ELSE}TStringGrid{$IFEND});
    procedure ASCII80Load(FileDataStr:TMemoryStream;Grid:{$IF DifUtilType=1}TASCStringGrid{$ELSE}TStringGrid{$IFEND});
    procedure RefreshCols;
  end;

var
  DiffUtilF: TDiffUtilF;
  {$IF DifUtilType=1}
  procedure ViewDiff(DifFileName:ASCMRString;fromstr,tostr:TASCMRStringList;ViewType: integer);
  {$ELSE}
  procedure ViewDiffB(DifFileName:ASCMRString;fromstr,tostr:TMemoryStream;ViewType: integer);
  {$IFEND}
implementation

{$R *.dfm}

uses ProgressU,MulRepMainU;
{$IF DifUtilType=1}
procedure ViewDiff(DifFileName:ASCMRString;fromstr,tostr:TASCMRStringList;ViewType: integer);
Var
   df:TDiffUtilF;
   i:integer;
Begin
     if not(Assigned(fromstr) and assigned(ToStr)) then exit;
     df:=nil;
     df:=TDiffUtilF.Create(nil);
     with df do
     begin
          DifViewType:=ViewType;
          TNTFromGrd:=ConvertASCStringGrid(FromGrd);
          TNTGrd1:=ConvertASCStringGrid(Grd1);
          TNTToGrd:=ConvertASCStringGrid(ToGrd);

          df.Caption:=msgDiffView+' - '+DifFileName;
          DifFile:=DifFileName;
          TNTFromGrd.RowCount:=FromStr.Count+1;
          TNTFromGrd.Cells[0,0]:=msgBeforRepTxt;
          for I := 0 to FromStr.Count - 1 do
          begin
               TNTFromGrd.Cells[0,i+1]:=FromStr.Strings[i];
          end;
          TNTToGrd.RowCount:=ToStr.Count+1;
          TNTToGrd.Cells[0,0]:=msgAfterRepTxt;
          for I := 0 to ToStr.Count - 1 do
          begin
               TNTToGrd.Cells[0,i+1]:=ToStr.Strings[i];
          end;
          DiffBtnClick(nil);
          Show;
     end;
end;
{$ELSE}
procedure ViewDiffB(DifFileName:ASCMRString;fromstr,tostr:TMemoryStream;ViewType: integer);
Var
   df:TDiffUtilF;
   i:integer;
Begin
     if not(Assigned(fromstr) and assigned(ToStr)) then exit;
     df:=nil;
     df:=TDiffUtilF.Create(nil);
     with df do
     begin
          DifViewType:=ViewType;
          TNTFromGrd:=ConvertASCStringGrid(FromGrd);
          TNTGrd1:=ConvertASCStringGrid(Grd1);
          TNTToGrd:=ConvertASCStringGrid(ToGrd);

          df.Caption:=msgDiffView+' - '+DifFileName;
          DifFile:=DifFileName;
          Case ViewType of
               ascVTHex:
               begin
                    HexLoad(fromstr,TNTFromGrd);
                    HexLoad(tostr,TNTToGrd);
               end;
               ascVTASC80:
               begin
                    ASCII80Load(fromstr,TNTFromGrd);
                    ASCII80Load(tostr,TNTToGrd);
               end;
          End;

          DiffBtnClick(nil);
          Show;
     end;
end;
{$IFEND}

procedure TDiffUtilF.BothShows1Click(Sender: TObject);
begin
     DifViewStyle:=2;
     DiffBtnClick(nil);
end;

procedure TDiffUtilF.Combined1Click(Sender: TObject);
begin
     DifViewStyle:=1;
     DiffBtnClick(nil);
end;

procedure TDiffUtilF.ContextDiff1Click(Sender: TObject);
begin
     DifFilterStyle:=2;
     DiffBtnClick(nil);
end;

function TDiffUtilF.ConvertASCStringGrid(Grid: TStringGrid): {$IF DifUtilType=1}TASCStringGrid{$ELSE}TStringGrid{$IFEND};
Var
   N:ASCMRString;
   v:ASCMRString;
   TabOrderNo,i:integer;
begin
     {$IF DifUtilType=1}
     Result:=TASCStringGrid.Create(self);
     {$ELSE}
     Result:=TStringGrid.Create(self);
     {$IFEND}
     n:=Grid.Name;
     TabOrderNo:=Grid.TabOrder;
     Result.Parent:=Grid.Parent;
     Result.Align:=Grid.Align;
     Result.Left:=Grid.Left;
     Result.Top:=Grid.Top;
     Result.Width:=Grid.Width;
     Result.Height:=Grid.Height;
     Result.Font.Assign(Grid.Font);
     Result.ColCount:=Grid.ColCount;
     Result.RowCount:=Grid.RowCount;
     Result.OnDrawCell:=Grid.OnDrawCell;
     Result.OnKeyDown:=Grid.OnKeyDown;
     Result.OnMouseUp:=Grid.OnMouseUp;
     Result.OnMouseDown:=Grid.OnMouseDown;
     Result.OnRowMoved:=Grid.OnRowMoved;
     Result.OnClick:=Grid.OnClick;
     Result.OnDblClick:=Grid.OnDblClick;
     Result.OnSelectCell:=Grid.OnSelectCell;
     Result.DefaultRowHeight:=Grid.DefaultRowHeight;
     for i := 0 to Grid.ColCount - 1 do
     begin
          Result.ColWidths[i]:=Grid.ColWidths[i];
     end;
     Grid.Free;
     Result.Name:=n;
     Result.TabOrder:=TabOrderNo;
end;

procedure TDiffUtilF.CreateParams(var Params: TCreateParams);
begin
     inherited;
     Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
     Params.WndParent := GetDesktopWindow;

end;

procedure TDiffUtilF.DiffBtnClick(Sender: TObject);
const
     DfEsit=0;
     DfKaynakEksik=1;
     DfKaynakFazla=2;
     DfHedefEksik=3;
     DfHedefFazla=4;
     DfKaynakFarkli=5;
     DfHedefFarkli=6;
     DfHedefAsagi=7;
     DfHedefYukari=8;
     dfKaynakAsagi=9;
     dfKaynakYukari=10;
     DfFarkli=11; //çift satýr görüntülerken
Var
   PrcsF:TProgressF;
   vPrcs:Boolean; //progressbar kullanýlýyormu
   prcsi, //ana while dongusunde progressbar yenilemesi için döngü deðiþkeni

   GrdLineC,//Diff grid satýr sayýsý
   FndLinkOpt,//Link bulunduðunda kullanýlýr

   c, //kolon no deðiþkeni
   tj, //temp j
   j1,//kaynak satýr no
   j2,//hedef satýr no
   k1,//iç kaynak satýr no
   k2,//iç hedef satýr no
   k1b,//iç kaynak satýr no
   k2b,//iç hedef satýr no
   lookresult, //iç arama sonucu
   l1, //iç arama sonucu aktarma deðiþkeni 1
   l2, //iç arama sonucu aktarma deðiþkeni 2
   DfStatus, //satýr ekleme durumu
   LinkCount, //link sayýsý
   NearLinkedRow, //en yakýn link satýrý
   ContextLineCount, //Context viewde bir diff için yazýlmýþ satýr sayýsý
   ContextLastLF,//Context view için kaynaktan yazýlan son farklý satýr
   ContextLastLT//Context view için hedeften yazýlan son farklý satýr

   :integer;
   s1,s2:ASCMRString; //satýr 1 satýr 2
   eof1,eof2:Boolean; //dosya sonu 1 dosya sonu 2
   Links:Array of TDiffLink; //linkler
   procedure AddGridLine;
   var
      ContextJ,//context dongü deðiþkeni
      k, //k dongü deðiþkeni
      CMDist, //Context Max Line div 2 -- bir grup satýrýn yarýsý
      dfs:integer;//geçici bir deðiþken
   begin
        if (dfstatus=dfEsit) and (DifFilterStyle>1) Then
        Begin
             if (DifFilterStyle=3) or (ContextLineCount=0) then exit;
             if (ContextLineCount>ContextMaxLine) then
             Begin
                  ContextLineCount:=0;
                  exit;
             end;
        end;

        if (DifFilterStyle=2) Then
        Begin
             if (ContextLineCount=0) and (DfStatus<>DfEsit) then
             Begin

                  CMDist:=ContextMaxLine div 2;

                  if j1-ContextLastLF>j2-ContextLastLT then
                  Begin
                       if j2-ContextLastLT<=CMDist then CMDist:=j2-ContextLastLT-1;
                  end else
                  Begin
                       if j1-ContextLastLT<=CMDist then CMDist:=j1-ContextLastLT-1;
                  end;

                  ///göstermelik olarak farklý olan satýrdan önceki eþit olan birkaç satýr ekleniyor
                  for ContextJ := 1 to CMDist do
                  begin
                       inc(GrdLineC);
                       if GrdLineC>=TNTGrd1.RowCount then  TNTGrd1.RowCount:=GrdLineC+1;

                       TNTGrd1.Cells[ColDiff,GrdLineC]:=inttostr(DfEsit);

                       TNTGrd1.Cells[ColFromLineNum,GrdLineC]:=inttostr(j1-CMDist+ContextJ-1);
                       TNTGrd1.Cells[ColToLineNum,GrdLineC]:=inttostr(j2-CMDist+ContextJ-1);

                       for k := 1 to lookcolcount  do
                       begin
                            TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:=TNTFromGrd.Cells[lookcolumn+k-1,j1-CMDist+ContextJ-1];
                            if DifViewStyle=2 then
                            TNTGrd1.Cells[ColToData+k-1,GrdLineC]:=TNTToGrd.Cells[lookcolumn+k-1,j2-CMDist+ContextJ-1];
                       end;
                       inc(ContextLineCount); //göstermelik satýr sayýsý arttýrýlýyor
                  end;
                  inc(ContextLineCount); //bu farklý olan ilk satýr için
             end;
        end;

        inc(GrdLineC);
        if GrdLineC>=TNTGrd1.RowCount then  TNTGrd1.RowCount:=GrdLineC+1;

        if DfStatus=11 then dfs:=6 else dfs:=DfStatus; //çift satýrlý gösterimde satýr farklý ise þekil 6 seç
        TNTGrd1.Cells[ColDiff,GrdLineC]:=inttostr(dfs);

        if ((DfStatus=DfHedefFarkli) and (DifViewStyle=1)) then
        TNTGrd1.Cells[ColFromLineNum,GrdLineC]:='h'+inttostr(j1)
        else
        TNTGrd1.Cells[ColFromLineNum,GrdLineC]:=inttostr(j1);

        if ((DfStatus=DfKaynakFarkli) and (DifViewStyle=1)) then
        TNTGrd1.Cells[ColToLineNum,GrdLineC]:='h'+inttostr(j2) Else
        TNTGrd1.Cells[ColToLineNum,GrdLineC]:=inttostr(j2);

        case DfStatus of
             DfEsit:
             Begin
                  if (DifFilterStyle=2) then  inc(ContextLineCount);
                  for k := 1 to lookcolcount  do
                  begin
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:=TNTFromGrd.Cells[lookcolumn+k-1,j1];
                       if DifViewStyle=2 then
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:=TNTToGrd.Cells[lookcolumn+k-1,j2];
                  end;
             end;
             DfKaynakAsagi:
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:=TNTFromGrd.Cells[lookcolumn+k-1,j1];
                       if DifViewStyle=2 then
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:='';
                  end;
             end;
             DfKaynakYukari:
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:=TNTFromGrd.Cells[lookcolumn+k-1,j1];
                       if DifViewStyle=2 then
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:='';
                  end;
             end;
             DfHedefAsagi:
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       if DifViewStyle=2 then
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:='';
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:=TNTToGrd.Cells[lookcolumn+k-1,j2];
                  end;
             end;
             DfHedefYukari:
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       if DifViewStyle=2 then
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:='';
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:=TNTToGrd.Cells[lookcolumn+k-1,j2];
                  end;
             end;
             DfKaynakFarkli: //bu sadece tek satýr gösterimde olabilir
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:=TNTFromGrd.Cells[lookcolumn+k-1,j1];
                  end;
             end;
             DfHedefFarkli: //bu sadece tek satýr gösterimde olabilir
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:=TNTToGrd.Cells[lookcolumn+k-1,j2];
                  end;
             end;
             DfKaynakFazla:
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:=TNTFromGrd.Cells[lookcolumn+k-1,j1];
                       if DifViewStyle=2 then
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:='';
                  end;
             end;
             DfHedefFazla:
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       if DifViewStyle=2 then
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:='';
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:=TNTToGrd.Cells[lookcolumn+k-1,j2];
                  end;
             end;
             DfFarkli: //bu sadece çift satýr gösterimde olabilir
             Begin
                  for k := 1 to lookcolcount  do
                  begin
                       TNTGrd1.Cells[ColFromData+k-1,GrdLineC]:=TNTFromGrd.Cells[lookcolumn+k-1,j1];
                       TNTGrd1.Cells[ColToData+k-1,GrdLineC]:=TNTToGrd.Cells[lookcolumn+k-1,j2];
                  end;
             end;
        end;
        ContextLastLF:=j1;
        ContextLastLT:=j2;
   end;
   procedure lookrows(direction:integer); // 0:kaynak sabit hedefte ilerle,1:Hedef sabit kaynakta ilerle
   var
      lrs1,lrs2:ASCMRString;
   begin
        lookresult:=-1;
        k1:=j1;
        k2:=j2;
        lrs1:=s1;
        lrs2:=s2;

        case direction of
             0:
             begin
                  inc(k2); //hedeften yeni satýr okunarak kontrol edilecek     
                  if (k1<TNTFromGrd.RowCount) and (k2<TNTToGrd.RowCount) then
                  begin
                       lrs1:=TNTFromGrd.Cells[lookcolumn,k1];
                       lrs2:=TNTToGrd.Cells[lookcolumn,k2];
                       if (lrs1=lrs2) then
                       begin
                            inc(lookresult);
                            inc(k1);//sonraki satýr kontrol edilecek
                       end;
                  end;
                  if lookresult>=0 then
                  begin
                       Dec(k2,lookresult+1);
                  end;
             end;
             1:
             begin
                  inc(k1); //kaynaktan yeni satýr okunarak kontrol edilecek     
                  if (k1<TNTFromGrd.RowCount) and (k2<TNTToGrd.RowCount) then
                  begin
                       lrs1:=TNTFromGrd.Cells[lookcolumn,k1];
                       lrs2:=TNTToGrd.Cells[lookcolumn,k2];
                       if (lrs1=lrs2) then
                       begin
                            inc(lookresult);
                            inc(k2);//sonraki satýr kontrol edilecek
                       end;
                  end;
                  if lookresult>=0 then
                  begin
                       Dec(k1,lookresult+1);
                  end;
             end;
        end;
   end;
   procedure Droplinkedrow(li:integer);
   var
      nj:integer;
   begin
        if li<LinkCount-1 then
        for nj := li to LinkCount-1 do
        begin
             Links[nj].i:=Links[nj+1].i;
             Links[nj].Op:=Links[nj+1].Op;
        end;
        Dec(LinkCount);
        NearLinkedRow:=-1;
        for nj := 0 to LinkCount - 1 do
        begin
             if (Links[nj].i>=0) and ((Links[nj].i<NearLinkedRow) or (NearLinkedRow<0)) then
               NearLinkedRow:=Links[nj].i;
        end;
   end;
begin
     if DifViewType=ascVTHex then
     begin
          lookcolumn:=1;
          lookcolcount:=2;
     end
     else
     begin
          lookcolumn:=0;
          lookcolcount:=1;
     end;
     //if DifViewType=ascVTNormal then
     //begin
          TNTGrd1.Visible:=False;
          TNTGrd1.RowCount:=2;

     {
     end else
     begin
          Grd1.Visible:=False;
          Grd1.RowCount:=2;
     end;
     }
     ContextLineCount:=0; //Context sayacý sýfýrlandý
     ContextLastLF:=0;
     ContextLastLT:=0;
     RefreshCols;
     j1:=1;
     j2:=1;
     GrdLineC:=0;
     LinkCount:=0;
     NearLinkedRow:=-1;
     eof1:=False;
     eof2:=False;
     if (TNTFromGrd.RowCount>90) or (TNTToGrd.RowCount>90) then
     vPrcs:=true else vPrcs:=false;
     if vPrcs then
     begin
          PrcsF:=TProgressF.Create(nil);
          PrcsF.Show;
          Application.ProcessMessages;
          if TNTFromGrd.RowCount>=TNTToGrd.RowCount then
          PrcsF.PB1.Max:=TNTFromGrd.RowCount
          else
          PrcsF.PB1.Max:=TNTToGrd.RowCount;
     end;
     prcsi:=0;
     while true do
     begin
          inc(prcsi);
          if vPrcs and (prcsi>5) then
          begin
               prcsi:=0;
               if TNTFromGrd.RowCount>=TNTToGrd.RowCount then
               PrcsF.PB1.Position:=j1-1
               else
               PrcsF.PB1.Position:=j2-1;
               Application.ProcessMessages;
               if PrcsF.fCancelled then
               begin
                    floadcancel:=true;
                    loadcanceltim.Enabled:=true;
                    break;
               end;
          end;

          if j1<TNTFromGrd.RowCount then
          begin
               s1:=TNTFromGrd.Cells[lookcolumn,j1];
          end else
          begin
               s1:='';
               eof1:=true;
          end;
          if j2<TNTToGrd.RowCount then
          begin
               s2:=TNTToGrd.Cells[lookcolumn,j2];
          end else
          begin
               eof2:=true;
               s2:='';
          end;
          if eof1 and eof2 then
          break;
          if (s1=s2) and not (eof1 or eof2) then
          begin
               DfStatus:=DfEsit;
               AddGridLine;//(j1,j2,DfEsit,s1);
               inc(j1);
               inc(j2);
          end else
          begin
               FndLinkOpt:=-1;
               if (LinkCount>0) and ((NearLinkedRow=j1) or (NearLinkedRow=j2)) then
               begin
                    for tj := 0 to LinkCount - 1 do
                    begin
                         if (Links[tj].i=j1) and (Links[tj].Op=2) then //aþaðýdaki kaynak satýr
                         begin
                              FndLinkOpt:=Links[tj].Op;
                              DfStatus:=dfKaynakYukari;
                              AddGridLine;
                              inc(j1);
                              Droplinkedrow(tj);
                              break;
                         end else
                         if (Links[tj].i=j2) and (Links[tj].Op=1) then //aþaðýdaki hedef satýr
                         begin
                              FndLinkOpt:=Links[tj].Op;
                              DfStatus:=dfHedefAsagi;
                              AddGridLine;
                              inc(j2);
                              Droplinkedrow(tj);
                              break;
                         end;
                    end;
               end;
               if FndLinkOpt>0 then Continue;

               //j1.satýr hedefte aranacak.
               lookrows(0);
               l1:=lookresult;
               if l1>=0 then
               //eðer hedefte 1den fazla bulunmuþsa hedefte bulunan satýr sayýsý kadar olanlar eksik olabilir,
               // veya taþýnmýþ olabilir
               begin
                    k1b:=k1;
                    k2b:=k2;
                    DfStatus:=DfHedefFazla;
                    AddGridLine;
                    inc(j2);
               end else
               begin
                    //j2.hedef kaynak üzerinde aranacak
                    lookrows(1);
                    l2:=lookresult;
                    if l2>=0 then    //eðer hedefteki satýr kaynakta varsa hedefte eksiklik vardýr
                    begin
                         DfStatus:=DfKaynakFazla;
                         AddGridLine;
                         inc(j1);
                    end else  //eðer hedefteki satýr kaynakta yoksa satýr deðiþmiþ demektir
                    begin
                         if DifViewStyle=1 then //tek kolon ise
                         Begin
                              DfStatus:=DfKaynakFarkli;
                              AddGridLine;
                              inc(j1);
                              DfStatus:=DfHedefFarkli;
                              AddGridLine;
                              inc(j2);
                         end else
                         Begin
                              DfStatus:=DfFarkli;
                              AddGridLine;
                              inc(j1);
                              inc(j2);
                         end;
                    end;
               end;
          end;

     end;
     if vPrcs then
     begin
          if Assigned(PrcsF) then
          begin
               PrcsF.Free;
               PrcsF:=Nil;
          end;
     end;
     TNTGrd1.Visible:=True;
     pg1.ActivePageIndex:=2;
end;


procedure TDiffUtilF.DiffsOnly1Click(Sender: TObject);
begin
     DifFilterStyle:=3;
     DiffBtnClick(nil);
end;


procedure TDiffUtilF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     DiffUtilF:=Nil;

end;

procedure TDiffUtilF.FormCreate(Sender: TObject);
begin
     floadcancel:=false;
     ContextMaxLine:=5;
     DifFilterStyle:=1;
     DifViewStyle:=2;
end;

procedure TDiffUtilF.FormResize(Sender: TObject);
begin
     ResizeTim.Enabled:=True;
end;

procedure TDiffUtilF.FullDiff1Click(Sender: TObject);
begin
     DifFilterStyle:=1;
     DiffBtnClick(nil);
end;

procedure TDiffUtilF.Grd1Click(Sender: TObject);
Var
   r1,r2:integer;
   s1,s2:ASCMRString;
begin
     if TNTGrd1.Row>0 then
     begin
          s1:=TNTGrd1.Cells[ColFromLineNum,TNTGrd1.Row];
          s2:=TNTGrd1.Cells[ColToLineNum,TNTGrd1.Row];
          if Pos('h',s1)>0 then Delete(s1,1,1);
          if Pos('h',s2)>0 then Delete(s2,1,1);

          if s1<>'' then
              r1:=strtoint(s1)
          else
              r1:=0;
          if s2<>'' then
              r2:=strtoint(s2)
          else
              r2:=0;
          if (r1>0) and (r1<TNTFromGrd.RowCount) then
             TNTFromGrd.Row:=r1;
          if (r2>0) and (r2<TNTToGrd.RowCount) then
             TNTToGrd.Row:=r2;
     end;
end;

procedure TDiffUtilF.Grd1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
Var
   i:integer;
   cell:ASCMRString;
begin

     if ARow>0 then
     case DifViewStyle of
          1://tek kolon
          begin
               cell:=TNTGrd1.Cells[ACol,Arow];
               if (ACOl=ColFromLineNum) or (ACol=ColToLineNum) then
               Begin
                    if Pos('h',cell)=1 then
                    TNTGrd1.Canvas.FillRect(Rect);
               End else
               if (ACol=ColDiff) and (Arow>0) then
               begin
                    if TNTGrd1.Cells[ACol,Arow]='' then i:=0
                    else
                    i:=strtoint(TNTGrd1.Cells[ACol,Arow]);

                    TNTGrd1.Canvas.FillRect(Rect);
                    if i>0 then
                       diffimglist.Draw(TNTGrd1.Canvas,Rect.Left+1,Rect.Top+1,i);
               end;
          end;
          2://Çift kolon
          begin
               if (ACol=ColDiff) and (Arow>0) then
               begin
                    if TNTGrd1.Cells[ACol,Arow]='' then i:=0
                    else
                    i:=strtoint(TNTGrd1.Cells[ACol,Arow]);

                    TNTGrd1.Canvas.FillRect(Rect);
                    if i>0 then
                       diffimglist.Draw(TNTGrd1.Canvas,Rect.Left+1,Rect.Top+1,i);
               end;

          end;
     end;

end;

procedure TDiffUtilF.Grd1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key in [vk_up,vk_down,vk_prior,vk_next] then
        Grd1Click(Sender);
end;

procedure TDiffUtilF.Grd1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
     Grd1Click(Sender);
end;


procedure TDiffUtilF.ASCII80Load(FileDataStr:TMemoryStream;Grid:{$IF DifUtilType=1}TASCStringGrid{$ELSE}TStringGrid{$IFEND});
var
    s2:String;//ASCMRString;
    buffer:Array [1..200] of Char;//ASCMRChar;
    buf:array [1..90] of Char;//ASCMRChar;
    r,Rslt,i,n:integer;
begin
  FileDataStr.Position:=0;
  n:=1;
  r:=1;
  Grid.ColCount:=1;
  Grid.FixedCols:=0;
  if Grid.ClientWidth>200 then
  Grid.ColWidths[0]:=Grid.ClientWidth-80
  else
  Grid.ColWidths[0]:=200;//AscKod
  Grid.RowCount:=2;
  Grid.Cells[0,0]:=msgSeksenCTxt;
  while n>0 do
  begin
       s2:='';
       n:=FileDataStr.Read(buf,80);
       for i := 1 to n do
         begin
           if (buf[i] < #32) or (buf[i] > #126) then
             buf[i] := '.';
           s2:=s2+buf[i];
         end;
       Grid.RowCount:=r+1;
       Grid.Cells[0,r]:=s2;
       inc(r);

  end;
end;
procedure TDiffUtilF.HexLoad(FileDataStr:TMemoryStream;Grid:{$IF DifUtilType=1}TASCStringGrid{$ELSE}TStringGrid{$IFEND});
var
    s2:String;//ASCMRString;
    buffer:Array [1..200] of Char;//ASCMRChar;
    buf:array [1..16] of Char;//ASCMRchar;
    i,n,FPosition,r:integer;
begin
  FileDataStr.Position:=0;
  n:=1;

  Grid.ColCount:=3;
  Grid.FixedCols:=1;
  Grid.ColWidths[0]:=50;//Adres
  Grid.ColWidths[1]:=330;//HexKod
  Grid.ColWidths[2]:=130;//AscKod
  Grid.RowCount:=2;
  Grid.Cells[0,0]:=msgAddress;
  Grid.Cells[1,0]:=msgHexData;
  Grid.Cells[2,0]:=msgTextData;
  r:=1;
  while n>0 do
  begin
       Grid.RowCount:=r+1;
       s2:='';
       //s2:=s2+Format(';%.5x  ',[FileDataStr.Position]);
       Grid.Cells[0,r]:=Format(';%.5x  ',[FileDataStr.Position]);
       n:=FileDataStr.Read(buf,16);
       if n = 0 then break;
       for i := 1 to n do
         begin
           s2:=s2+IntToHex(ord(buf[i]),2)+' ';
           if i mod 4 = 0 then s2:=s2+' ';
         end;
       s2:=s2+StringOfChar(' ',62-length(s2));
       Grid.Cells[1,r]:=s2;
       s2:='';
       for i := 1 to n do
         begin
           if (buf[i] < #32) or (buf[i] > #126) then
             buf[i] := '.';
           s2:=s2+buf[i];
         end;
       Grid.Cells[2,r]:=s2;
       inc(r);
       //if StreamPosition and $FFF = 0 then MainForm.Progress(StreamPosition);
  end;

end;


procedure TDiffUtilF.loadcanceltimTimer(Sender: TObject);
begin
     loadcanceltim.Enabled:=False;
     Close;
end;

procedure TDiffUtilF.NextChange1Click(Sender: TObject);
Var
   i,j:integer;
begin
     for i:=TNTGrd1.Row+1 to TNTGrd1.RowCount-1 do
     begin
                    if TNTGrd1.Cells[ColDiff,i]='' then
                       continue;
                    j:=strtoint(TNTGrd1.Cells[ColDiff,i]);
                    if j<>0 then
                    begin
                         TNTGrd1.Row:=i;
                         exit;
                    end;
     end;
end;
procedure TDiffUtilF.PreviousChange1Click(Sender: TObject);
Var
   i,j:integer;
begin
     for i:=TNTGrd1.Row-1 downto 1 do
     begin
                    if TNTGrd1.Cells[ColDiff,i]='' then
                       continue;
                    j:=strtoint(TNTGrd1.Cells[ColDiff,i]);
                    if j<>0 then
                    begin
                         TNTGrd1.Row:=i;
                         exit;
                    end;
     end;

end;
procedure TDiffUtilF.RefreshCols;
var
   c:integer;
begin
     case DifViewStyle of
          1://tek kolon
          begin
               if DifViewType=ascVTHex then
               TNTGrd1.ColCount:=5
               else
               TNTGrd1.ColCount:=4;
               TNTGrd1.FixedCols:=3;
               TNTGrd1.ColWidths[0]:=43;//1.Satýr
               TNTGrd1.ColWidths[1]:=43;//2.Satýr
               TNTGrd1.ColWidths[2]:=30;//Diff

               //Satýr içeriði
               if DifViewType=ascVTHex then
               begin
                    TNTGrd1.ColWidths[3]:=300;
                    TNTGrd1.ColWidths[4]:=220;
               end else
               begin
                    if TNTGrd1.Width>200 then
                    TNTGrd1.ColWidths[3]:=TNTGrd1.ClientWidth-125
                    else
                    TNTGrd1.ColWidths[3]:=100;
               end;
               ColDiff:=2;
               ColFromData:=3;
               ColToData:=3;
               ColFromLineNum:=0;
               ColToLineNum:=1;
               TNTGrd1.Cells[0,0]:=msgFromLineNo;
               TNTGrd1.Cells[1,0]:=msgToLineNo;
               TNTGrd1.Cells[2,0]:=msgDiffCol;
               if DifViewType=ascVTHex then
               begin
                    TNTGrd1.Cells[3,0]:=msgHexData;
                    TNTGrd1.Cells[4,0]:=msgAsciiData;
               end else
               begin
                    TNTGrd1.Cells[3,0]:=msgData;
               end;

          end;
          2://Çift kolon
          begin
               if DifViewType=ascVTHex then
               begin
                    TNTGrd1.ColCount:=7;
               end else
               TNTGrd1.ColCount:=5;
               TNTGrd1.FixedCols:=1;
               c:=0;
               TNTGrd1.ColWidths[c]:=43;//1.Satýr
               TNTGrd1.Cells[c,0]:=msgFromLineNo;
               ColFromLineNum:=c;
               inc(c);

               ColFromData:=c;
               if DifViewType=ascVTHex then
               begin
                    //1.Satýr içeriði
                    TNTGrd1.ColWidths[c]:=280;
                    TNTGrd1.Cells[c,0]:=msgHexDataFrom;
                    inc(c);
                    TNTGrd1.ColWidths[c]:=175;
                    TNTGrd1.Cells[c,0]:=msgAsciiDFrom;
                    inc(c);
               end else
               begin
                    //1.Satýr içeriði
                    if TNTGrd1.Width>200 then
                    TNTGrd1.ColWidths[c]:=(TNTGrd1.ClientWidth-125) div 2
                    else
                    TNTGrd1.ColWidths[c]:=100;
                    TNTGrd1.Cells[c,0]:=msgFromData;
                    inc(c);
               end;
               TNTGrd1.ColWidths[c]:=30;//Diff
               TNTGrd1.Cells[c,0]:=msgDiffCol;
               ColDiff:=c;
               inc(c);

               TNTGrd1.ColWidths[c]:=43;//2.Satýr
               TNTGrd1.Cells[c,0]:=msgToLineNo;
               ColToLineNum:=c;
               inc(c);
               //2.Satýr içeriði
               ColToData:=c;
               if DifViewType=ascVTHex then
               begin
                    TNTGrd1.ColWidths[c]:=280;
                    TNTGrd1.Cells[c,0]:=msgHexDataTo;
                    inc(c);
                    TNTGrd1.ColWidths[c]:=175;
                    TNTGrd1.Cells[c,0]:=msgAsciiTo;
                    inc(c);
               end else
               begin
                    if TNTGrd1.Width>200 then
                    TNTGrd1.ColWidths[c]:=(TNTGrd1.ClientWidth-125) div 2
                    else
                    TNTGrd1.ColWidths[c]:=100;
                    TNTGrd1.Cells[c,0]:=msgToData;
                    inc(c);
               end;
          end;
     end;

end;

procedure TDiffUtilF.ResizeTimTimer(Sender: TObject);
begin
     ResizeTim.Enabled:=false;
     RefreshCols;
end;

procedure TDiffUtilF.ShellOpenBtnClick(Sender: TObject);
var
   msj:String;
   f,msk,s:string;
begin
     msj:='';

     f:=DifFile;
     s:=appdefaultsrec.WarmBeforeOpenPtr;
     while s<>'' do
     begin
          msk:=CutcsvData(s);
          if trim(msk)='' then Continue;

          if MatchesMask(f,msk) then
             msj:=ReplaceText(msgDosyaAcmaUyarisi,'$dosyaadi',f);
     end;
     if msj<>'' then
        if MessageDlg(msj,mtWarning,[mbYes,mbNo],0,mbNo)<>mrYes then exit;
     ShellExecute( 0, nil, PChar( f ),
                 Nil, Nil, SW_NORMAL );
end;

procedure TDiffUtilF.LastChange1Click(Sender: TObject);
Var
   i,j:integer;
begin
     for i:=TNTGrd1.RowCount-1 downto 1 do
     begin
                    if TNTGrd1.Cells[ColDiff,i]='' then
                       continue;
                    j:=strtoint(TNTGrd1.Cells[ColDiff,i]);
                    if j<>0 then
                    begin
                         TNTGrd1.Row:=i;
                         exit;
                    end;
     end;

end;
procedure TDiffUtilF.FirstChange1Click(Sender: TObject);
Var
   i,j:integer;
begin
     for i:=1 to TNTGrd1.RowCount-1 do
     begin
                    if TNTGrd1.Cells[ColDiff,i]='' then
                       continue;
                    j:=strtoint(TNTGrd1.Cells[ColDiff,i]);
                    if j<>0 then
                    begin
                         TNTGrd1.Row:=i;
                         exit;
                    end;
     end;

end;

procedure TDiffUtilF.PasteBtnClick(Sender: TObject);
Var
   lst:TASCMRStringList;
   i:integer;
begin
     lst:=TASCMRStringList.Create;
     lst.Text:=Clipboard.AsText;
     if pg1.ActivePageIndex=1 then
     begin
          TNTToGrd.RowCount:=Lst.Count+1;
          for I := 0 to Lst.Count - 1 do
          begin
               TNTToGrd.Cells[0,i+1]:=Lst.Strings[i];
          end;

     end else
     begin
          TNTFromGrd.RowCount:=Lst.Count+1;
          for I := 0 to Lst.Count - 1 do
          begin
               TNTFromGrd.Cells[0,i+1]:=Lst.Strings[i];
          end;
     end;
     lst.Free;
     lst:=nil;

end;


procedure TDiffUtilF.ToolButton5Click(Sender: TObject);
var

   Grd:{$IF DifUtilType=1}TASCStringGrid{$ELSE}TStringGrid{$IFEND};

begin
     if TNTFromGrd.Focused then
     Grd:=TNTFromGrd
     else
     if TNTToGrd.Focused then
     Grd:=TNTToGrd
     else
     Grd:=TNTGrd1;

     if SD1.Execute then
     begin

     end;
end;

procedure TDiffUtilF.ToolButton6Click(Sender: TObject);
begin
     Close;
end;

end.
