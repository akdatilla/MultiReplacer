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
 
unit MatchesU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,CollapsePanel, Grids,RepLib,RepConstU,RepFrmU,
  Buttons,RepThreadU;

type
  TMatchesF = class(TForm)
    MatchPnl: TPanel;
    ScrollBox1: TScrollBox;
    Panel12: TPanel;
    Label9: TLabel;
    PageRowsHintL: TLabel;
    MatchListPageE: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PGosterTim: TTimer;
    procedure MatchListPageEChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MatchLstGrdDrawProc(Sender:TObject; ACol, ARow: Integer;
    R: TRect; State: TGridDrawState);
    procedure MatchLstGrdPrintProc(Sender:TObject; ACanvas:TCanvas;ACol, ARow: Integer;
    R: TRect; State: TGridDrawState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PGosterTimTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FRepFrm:TRepFrmF;
    MatchesPanels:TList;
    MatchListPager:TASCMatchListPager;
    procedure preparematchlist;
    procedure DropMatchesPanels;
    procedure preparematchpages;
  end;

var
  MatchesF: TMatchesF;

implementation

{$R *.dfm}
uses PreviewU, NicePreview,RepMainU;

procedure TMatchesF.BitBtn1Click(Sender: TObject);
var
   j,k,l,m,ml,mt,mb,mr:integer;
   p:^TCollapsePanel;
   Grd:TASCStringGrid;
   r:TRect;
   St: TGridDrawState;
   ACanvas:TCanvas;
   POpen:Boolean;
   MatchPrvF:TPreviewF;
begin
     MatchPrvF:=TPreviewF.Create(nil);
     MatchPrvF.Show;
     MatchPrvF.NicePreview1.Clear;
     ACanvas:=MatchPrvF.NicePreview1.BeginPage;

     St:=[];
     ml:=MatchPrvF.NicePreview1.MarginLeft;
     mt:=MatchPrvF.NicePreview1.MarginTop;
     mb:=MatchPrvF.NicePreview1.PageHeight - MatchPrvF.NicePreview1.MarginBottom;
     mr:=MatchPrvF.NicePreview1.PageWidth-MatchPrvF.NicePreview1.MarginRight;
     r.Top:=mt;
     r.Left:=ml;
     for j:=MatchesPanels.Count-1 downto 0 do
     begin
          p:=MatchesPanels.Items[j];
          if p^.ControlCount>0 then
          for k := 0 to p^.ControlCount - 1 do
          begin
               if p^.Controls[k] is TASCStringGrid then
               begin

                    grd:=(p^.Controls[k] as TASCStringGrid);
                    ACanvas.Font.Assign(grd.Font);
                    r.Left:=ml;
                    ACanvas.Font.Color:=clBlack;
                    ACanvas.Font.Style:=[fsBold];
                    r.Bottom:=r.Top+ACanvas.TextHeight(p^.HeaderCaption)+4;
                    r.Right:=r.Left+ACanvas.TextWidth(p^.HeaderCaption)+4;
                    if r.Right>mr then
                    r.Right:=mr;
                    WriteText(ACanvas, p^.HeaderCaption, R, 2, 2,taRightJustify,false,clBlack,clWhite);
                    r.Top:=r.Bottom;
                    ACanvas.Font.Style:=[];
                    with grd do
                    begin

                         for l:=0 to RowCount-1 do
                         begin
                             if r.Top+RowHeights[l]>mb then
                             begin
                                  r.Top:=mt;
                                  MatchPrvF.NicePreview1.EndPage;
                                  ACanvas := MatchPrvF.NicePreview1.BeginPage;
                             end;
                             r.Bottom:=r.Top+RowHeights[l];
                             r.Left:=ml;
                             for m := 0 to ColCount - 1 do
                             begin
                                  r.Right:=r.Left+ColWidths[m];
                                  MatchLstGrdPrintProc(grd,ACanvas,m,l,r,st);

                                  r.Left:=r.Left+ColWidths[m];

                             end;
                             r.Top:=r.Top+RowHeights[l];
                         end;
                    end;
               end;
          end;

     end;
     MatchPrvF.NicePreview1.EndPage;
end;

procedure TMatchesF.BitBtn2Click(Sender: TObject);
begin
     Close;
end;

procedure TMatchesF.DropMatchesPanels;
var
   j:integer;
   p:^TCollapsePanel;
begin
     for j:=0 to MatchesPanels.Count-1 do
     begin
          p:=MatchesPanels.Items[j];
          p^.Free;
          p^:=Nil;
          dispose(p);
     end;
     MatchesPanels.Clear;

end;

procedure TMatchesF.FormCreate(Sender: TObject);
begin
     PageRowsHintL.Caption:=PageRowCounthint;
     MatchesPanels:=TList.Create;

end;

procedure TMatchesF.FormDestroy(Sender: TObject);
begin

     DropMatchesPanels;
     FRepFrm.FMatchesF:=Nil;
     MatchesPanels.Free;
     MatchesPanels:=Nil;

end;

procedure TMatchesF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

procedure TMatchesF.MatchListPageEChange(Sender: TObject);
begin
     if MatchListPageE.Enabled then
     preparematchlist;
end;

procedure TMatchesF.MatchLstGrdDrawProc(Sender: TObject; ACol, ARow: Integer;
  R: TRect; State: TGridDrawState);
Var
   s,sv,sv2:ASCMRString;
   fc,bc,x,x2,y,w,ww:integer;
begin
     if not (Sender is TASCStringGrid) then exit;
     with (Sender as TASCStringGrid) do
     Begin
          if Parent.ClientWidth-80>530 then
             ColWidths[1]:=Parent.ClientWidth-80;
          s:=Cells[Acol,ARow];
          x:=R.Left;
          x2:=2;
          y:=R.Top;
          w:=R.Right-x;
          Case ACol of
               0:WriteText(Canvas, s, R, 2, 2,taRightJustify,false,clBlack,clWhite);
               1:
               Begin
                    WriteText(Canvas, '', R, 2, 2,taRightJustify,false,clBlack,clWhite);
                    if s='' Then
                         exit;
                    while true do
                    Begin
                         sv:=CutcsvDataASCMR(s);//stil
                         if sv='' then break;
                         sv2:=CutcsvDataASCMR(s);//text
                         fc:=TextToInt(xsvDataASCMR(sv,',',1));
                         bc:=TextToInt(xsvDataASCMR(sv,',',2));
                         sv:=csvRePrepareColumnASCMR(sv2);
                         ww:=Canvas.TextWidth(sv);
                         if x+ww>r.Right then ww:=r.Right-x-1;
                         WriteText(Canvas, sv, Rect(x,y,x+ww+x2,R.Bottom), x2, 2,taLeftJustify,false,fc,bc);
                         x:=x+ww+x2;
                         x2:=0;
                         if x+3>r.Right then break;
                    end;
               end;

          end;
     end;

end;

procedure TMatchesF.MatchLstGrdPrintProc(Sender: TObject; ACanvas:TCanvas;ACol, ARow: Integer;
  R: TRect; State: TGridDrawState);
Var
   s,sv,sv2:ASCMRString;
   fc,bc,x,x2,y,w,ww:integer;
begin
     if not (Sender is TASCStringGrid) then exit;
     with (Sender as TASCStringGrid) do
     Begin
          s:=Cells[Acol,ARow];
          x:=R.Left;
          x2:=2;
          y:=R.Top;
          w:=R.Right-x;
          Case ACol of
               0:WriteText(ACanvas, s, R, 2, 2,taRightJustify,false,clBlack,clWhite);
               1:
               Begin
                    WriteText(ACanvas, '', R, 2, 2,taRightJustify,false,clBlack,clWhite);
                    if s='' Then
                         exit;
                    while true do
                    Begin
                         sv:=CutcsvDataASCMR(s);//stil
                         if sv='' then break;
                         sv2:=CutcsvDataASCMR(s);//text
                         fc:=TextToInt(xsvDataASCMR(sv,',',1));
                         bc:=TextToInt(xsvDataASCMR(sv,',',2));
                         sv:=csvRePrepareColumnASCMR(sv2);
                         ww:=ACanvas.TextWidth(sv);
                         if x+ww>r.Right then ww:=r.Right-x-1;
                         WriteText(ACanvas, sv, Rect(x,y,x+ww+x2,R.Bottom), x2, 2,taLeftJustify,false,fc,bc);
                         x:=x+ww+x2;
                         x2:=0;
                         if x+3>r.Right then break;
                    end;
               end;

          end;
     end;

end;

procedure TMatchesF.PGosterTimTimer(Sender: TObject);
begin
     PGosterTim.Enabled:=False;
     preparematchlist;
end;

procedure TMatchesF.preparematchlist;
Var
   masj, //ana dosya döngüsü
   k,
   err,
   pg,
   starti,
   finishi,
   startl,//sayfalama sebeiyle sýradaki dosyanýn okunacaðý baþlangýç ve bitiþ satýrlarý
   finishl
   :integer;
   p:PSrcFileRec;
   StrGrd1:TASCStringGrid;
   thvis:Boolean;
   linenum,datastr:ASCMRString;
   fn:ASCMRString;
   pnl:^TCollapsePanel;
   {$IF (ASCUniCodeUsing=1)}
    procedure ReadFileData(fn:TFileName);
    Var
       frj:integer;
       filedata:TASCMRStringList;
       s:ASCMRString;
       curl,r:integer;
    begin
         s:='';
         filedata:=TASCMRStringList.Create;
         try
            filedata.LoadFromFile(fn);
         except
              filedata.Free;
              filedata:=nil;
              err:=-1;
              exit;
         end;
         r:=0;
         curl:=0;
         for frj := 0 to filedata.Count - 1 do
         begin
              s:=filedata.Strings[frj];
              inc(curl);
              if (starti=masj) and (curl<startl) then continue;
              if (finishi>=masj) and (curl>finishl) then Break;
              linenum:=CutcsvDataASCMR(s);
              datastr:=s;
              StrGrd1.RowCount:=StrGrd1.RowCount+1;
              StrGrd1.Cells[0,r]:=linenum;
              StrGrd1.Cells[1,r]:=s;
              inc(r);
         end;
         if r>10 then Pnl^.Height:=10*StrGrd1.DefaultRowHeight+40 else
         if r<2 then Pnl^.Height:=StrGrd1.DefaultRowHeight+40 else
         Pnl^.Height:=r*StrGrd1.DefaultRowHeight+40;
         filedata.Free;
         filedata:=nil;
    end;
   {$ELSE}
    procedure ReadFileData(fn:TFileName);
    Var
       filedata:TextFile;
       s:ASCMRString;
       curl,r:integer;
    begin
         s:='';
         AssignFile(filedata,fn);
         {$I-}Reset(filedata);{$I+}
         if IOResult<>0 then
         begin
              err:=-1;
              exit;
         end;
         r:=0;
         curl:=0;
         while not Eof(filedata) do
         begin
              ReadLn(FileData,s);
              inc(curl);
              if (starti=masj) and (curl<startl) then continue;
              if (finishi>=masj) and (curl>finishl) then Break;

              linenum:=CutcsvDataASCMR(s);
              datastr:=s;
              StrGrd1.RowCount:=StrGrd1.RowCount+1;
              StrGrd1.Cells[0,r]:=linenum;
              StrGrd1.Cells[1,r]:=s;
              inc(r);
         end;
         if r>10 then Pnl^.Height:=10*StrGrd1.DefaultRowHeight+40 else
         if r<2 then Pnl^.Height:=StrGrd1.DefaultRowHeight+40 else
         Pnl^.Height:=r*StrGrd1.DefaultRowHeight+40;



         closeFile(filedata);
    end;
    {$IFEND}
begin
     //Exit;
     thvis:=False;
     ScrollBox1.Visible:=False;
     DropMatchesPanels;

     if FRepFrm.srcfilereclist.count<1 then exit;
     pg:=MatchListPageE.ItemIndex;
     if High(MatchListPager.PagePositions)<pg then exit;
     starti:=MatchListPager.PagePositions[pg].StartFileIdx;
     finishi:=MatchListPager.PagePositions[pg].FinishFileIdx;
     startl:=MatchListPager.PagePositions[pg].StartLine;
     Finishl:=MatchListPager.PagePositions[pg].FinishLine;
     for masj:=finishi downto starti do
     Begin
          p:=FRepFrm.srcfilereclist.items[masj];
          if p^.Removed then continue;

          fn:=TempDir+'matches'+inttostr(FRepFrm.repformid)+'_'+DblToText(masj,'NNNNNN')+'.tmp';

          if FileExists(fn) then
          Begin
               new(pnl);
               pnl^:=TCollapsePanel.Create(ScrollBox1);
               pnl^.Parent:=ScrollBox1;
               MatchesPanels.Add(pnl);
               pnl^.HeaderCaption:= p^.OrjFileName;
               if masj=starti then startl:=MatchListPager.PagePositions[pg].StartLine
               else
               startl:=1;

               if masj=finishi then Finishl:=MatchListPager.PagePositions[pg].FinishLine else
               Finishl:=p^.MatchCount;
               StrGrd1:=TASCStringGrid.Create(pnl^);
               StrGrd1.Parent:=pnl^;
               StrGrd1.OnDrawCell:=MatchLstGrdDrawProc;
               StrGrd1.Font.Name:='Courier New';
               StrGrd1.Font.Size:=10;
               with StrGrd1 do
               Begin
                    ColCount:=2;
                    DefaultRowHeight:=20;
                    FixedCols:=0;
                    FixedRows:=0;
                    ColWidths[0]:=58;
                    ColWidths[1]:=530;
                    RowCount:=0;
               end;
               pnl^.Collapsed:=False;
               ReadFileData(fn);
               pnl^.Align:=alTop;
               StrGrd1.Align:=alClient;
               pnl^.Top:=0;
               thvis:=True;
               //Application.ProcessMessages;
          End
          else Continue;

     end;

     //ShowInfo(msgPreFoundFileList);
     //Sleep(50);

     //MatchPnl.Repaint;
     if thvis then
     begin
     end;
     ScrollBox1.Visible:=True;
end;

procedure TMatchesF.preparematchpages;
var
   p:PSrcFileRec;
   masj, //Dosya kaynaklarý içinde dongu degiskeni
   pn,  //sayfa no
   Startl, //sayfa baþlangýç satýrno
   fStartl, //dosyadaki baþlangýç satýrno
   finishl,//sayfa bitiþ satýr no
   startfi,  //sayfa baþlangýç dosya kaynak no
   finishfi, //sayfa bitiþ dosya kaynak no
   linec,     //sayfa satýr sayýsý
   PMC
   :integer;
   nomatch:boolean;
begin
     MatchListPager.PageCount:=0;
     MatchListPager.FirstPage:=0;
     MatchListPager.LastPage:=0;
     MatchListPageE.Items.Clear;
     nomatch:=true;
     SetLength(MatchListPager.PagePositions,0);
     pn:=0;
     Startl:=0;
     fStartl:=0;
     finishl:=0;
     startfi:=-1;
     finishfi:=-1;
     linec:=0;
     for masj:=0 to FRepFrm.srcfilereclist.Count-1 do
     Begin
          p:=FRepFrm.srcfilereclist.items[masj];
          if p^.Removed then continue;
          fStartl:=0;
          if (startfi=-1) then
          begin
               startfi:=masj;
               startl:=0;
          end;
          PMC:=p^.MatchLineCount;

          while linec+PMC>PageLineCount do
          begin
               nomatch:=false;
               finishl:=fStartl+(PageLineCount-linec);
               PMC:=PMC-(PageLineCount-linec);
               inc(pn);
               SetLength(MatchListPager.PagePositions,pn);
               with MatchListPager.PagePositions[pn-1] do
               Begin
                    StartFileIdx:=startfi;
                    StartLine:=startl;
                    FinishFileIdx:=masj;
                    FinishLine:=finishl;
               End;
               linec:=0;
               startl:=finishl+1;
               fstartl:=startl;
               finishl:=startl;
               startfi:=masj;
               finishfi:=masj;
          end;
          if PMC>0 then
          begin
               linec:=linec+PMC;
               finishl:=finishl+PMC;
               fstartl:=0;  //bir sonraki dosyanýn birinci satýrýna konumlan
               finishfi:=masj;
          end;
     End;
     if linec>0 then
     begin
          nomatch:=false;
          p:=FRepFrm.srcfilereclist.items[finishfi];
          inc(pn);
          SetLength(MatchListPager.PagePositions,pn);
          with MatchListPager.PagePositions[pn-1] do
          Begin
               StartFileIdx:=startfi;
               StartLine:=startl;
               FinishFileIdx:=finishfi;
               FinishLine:=p^.MatchLineCount;
          End;
     end;
     if pn>0 then
     begin
          MatchListPager.PageCount:=pn;
          MatchListPager.FirstPage:=1;
          MatchListPager.LastPage:=pn;
          for masj := 1 to pn do
          MatchListPageE.Items.Add(inttostr(masj));
          MatchListPageE.ItemIndex:=0;
     end else
     begin
          MatchListPageE.Items.Add('1');
          MatchListPageE.ItemIndex:=0;
     end;

end;


end.
