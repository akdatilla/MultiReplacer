unit RecycleBinU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,MulTreeList, ImgList,ComCtrls,ShellApi,
  RepLib,RepConstU,RepFrmU;

type
  TRecycleBinF = class(TForm)
    FileBtnPnl: TPanel;
    RestoreBtn: TBitBtn;
    PBar1: TProgressBar;
    SBar1: TStatusBar;
    CloseBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure RestoreBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    DirList1:TpTree;
    DirListTV1:TTreeList;
  public
    { Public declarations }
    RepFLink:TRepFrmF;
    Sonuc:integer;
    procedure prerepareremoveds;
    procedure AddRemovedFilesToList(ListView: TpTree);
    procedure ShowInfo(msj:ASCMRString);
    procedure ShowProgress(msj:ASCMRString;p:integer);
  end;

var
  RecycleBinF: TRecycleBinF;

implementation

{$R *.dfm}
uses RepMainU;
procedure TRecycleBinF.AddRemovedFilesToList(ListView: TpTree);
var
   j,
   i: Integer;
   Icon: TIcon;
   SearchRec: TSearchRec;
   mainitm,ListItem,chitm: TTreeNode;
   FileInfo: SHFILEINFO;
   str:ASCMRString;
   d:Double;
   strpath,oldpath,strfn:ASCMRString;
   p:PSrcFileRec;
begin
     mainitm:=nil;
     ListItem:=nil;
     chitm:=nil;
     Icon := TIcon.Create;
     oldpath:='';
     try
        ListView.Visible:=False;
        PBar1.Max:=RepFLink.srcfilereclist.Count;
        for j:=0 to RepFLink.srcfilereclist.Count-1 do
        Begin
             p:=RepFLink.srcfilereclist.Items[j];
             if not p^.Removed then continue;
             strfn:=p^.OrjFileName;
             strpath:=ExtractFilePath(strfn);
             if (oldpath<>strpath) or (oldpath='*') Then
             Begin
                  mainitm:=ListView.tv.Items.Add(nil,strpath);
                  mainitm.ImageIndex:=RepFLink.DirIconIndex;
                  mainitm.SelectedIndex:=RepFLink.DirIconIndex;
                  oldpath:=strpath;
             end;
             str:=p^.shortname+'|'+
             GetSizeDescription(p^.FileSize)+'|';
             if p^.ModifyDate>0 then
             str:=str+DateToStr(p^.ModifyDate);
             str:=str+'|';
             str:=str+p^.FileType+'|';
             //Get Icon From File
             ListItem := ListView.tv.Items.AddChild(mainitm,str);
             ListItem.ImageIndex := p^.iconindex;
             ListItem.SelectedIndex:=ListItem.ImageIndex;
             ListItem.Data:=p;
             ShowProgress(msgPreFoundFileList,j);
        end;
        ShowProgress(msgPreFoundFileList,RepFLink.srcfilereclist.Count);
        sleep(50);
        ShowProgress('',0);
        ListView.tv.FullCollapse;
        ListView.Visible:=True;
     finally
       Icon.Free;
     end;
end;

procedure TRecycleBinF.CloseBtnClick(Sender: TObject);
begin
     Close;
end;

procedure TRecycleBinF.FormCreate(Sender: TObject);
begin
     Sonuc:=0;

end;

procedure TRecycleBinF.FormDestroy(Sender: TObject);
begin
     if Assigned(DirListTV1) then DirListTV1.Free;
     DirListTV1:=Nil;
     if Assigned(DirList1) then DirList1.Free;
     DirList1:=Nil;
end;

procedure TRecycleBinF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

procedure TRecycleBinF.FormResize(Sender: TObject);
begin
     DirList1.Align:=alClient;
     FileBtnPnl.Align:=alBottom;
end;

procedure TRecycleBinF.prerepareremoveds;
Var
   j:integer;
begin
     DirList1:=TpTree.Create(Self);
     DirList1.Parent:=Self;
     DirList1.Width:=630;
     DirList1.Height:=400;

     DirListTV1:=TTreeList.Create(DirList1);
     DirListTV1.Parent:=DirList1;
     DirListTV1.MultiSelect:=True;
     DirList1.tv:=DirListTV1;
     DirListTV1.Images :=RepFLink.SysImg1;
     DirListTV1.OnDblClick:=RestoreBtnClick;

     with DirList1.HeaderSections.Add do
     Begin
          Width:=200;
          Text:='File';
          Alignment:=taLeftJustify;
     end;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=80;
          Text:='Size';
          Alignment:=taRightJustify;
     end;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=150;
          Text:='Modify Date';
          Alignment:=taCenter;
     end;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=180;
          Text:='File Type';
          Alignment:=taLeftJustify;
     end;
     DirList1.UpdateColumns;
     DirList1.Align:=alClient;
     FileBtnPnl.Align:=alBottom;


     DirList1.Clear;
     AddRemovedFilesToList(DirList1);
     DirList1.UpdateColumns;
end;

procedure TRecycleBinF.RestoreBtnClick(Sender: TObject);
Var
   fn:ASCMRString;
   p:PSrcFileRec;
   i:integer;
begin
     if DirListTV1.SelectionCount>0 then
     begin
          for i := DirListTV1.SelectionCount - 1 downto 0 do
          begin
               if not Assigned(DirListTV1.Selections[i]) Then continue;
               if DirListTV1.Selections[i].Data=nil then exit;
               p:=DirListTV1.Selections[i].Data;
               p^.Removed:=False;
               DirListTV1.Items.Delete(DirListTV1.Selections[i]);

          end;
          Sonuc:=1;
     end else
     Begin
          if not Assigned(DirListTV1.Selected) Then exit;
          if DirListTV1.Selected.Data=nil then exit;
          p:=DirListTV1.Selected.Data;
          p^.Removed:=False;
          DirListTV1.Items.Delete(DirListTV1.Selected);
          Sonuc:=1;
     End;
end;

procedure TRecycleBinF.ShowInfo(msj: ASCMRString);
begin
     sbar1.Panels[0].Text:=msj;
end;

procedure TRecycleBinF.ShowProgress(msj: ASCMRString; p: integer);
begin
     PBar1.Position:=p;
     ShowInfo(msj);
     PBar1.Repaint;
     SBar1.Repaint;
end;

end.
