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
 
unit SelDirU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls,FileCtrl, ExtCtrls,RepConstU,RepLib;
const
     SELDIRHELP=1000;

type
  TSelDirF = class(TForm)
    PGCtrl: TPageControl;
    AdvTabSheet1: TTabSheet;
    AdvTabSheet2: TTabSheet;
    ASCLabel1: TLabel;
    ASCLabel3: TLabel;
    DirBtn: TBitBtn;
    DirE: TEdit;
    InMaskE: TEdit;
    FileBtn: TBitBtn;
    FileNameE: TEdit;
    OkBtn2: TBitBtn;
    CancelBtn2: TBitBtn;
    OkBtn1: TBitBtn;
    CancelBtn1: TBitBtn;
    DestL1: TLabel;
    DestBtn1: TBitBtn;
    DestE1: TEdit;
    DestBtn2: TBitBtn;
    DestE2: TEdit;
    ASCLabel2: TLabel;
    DestL2: TLabel;
    DestOptionsR2: TRadioGroup;
    DestBevel2: TBevel;
    Bevel2: TBevel;
    DestOptionsR1: TRadioGroup;
    DestBevel1: TBevel;
    Bevel4: TBevel;
    Label1: TLabel;
    ExMaskE: TEdit;
    SubsChk: TCheckBox;
    BitBtn1: TBitBtn;
    FileNameOprChk1: TCheckBox;
    procedure DestOptionsR2Click(Sender: TObject);
    procedure DestOptionsR1Click(Sender: TObject);
    procedure DestBtn2Click(Sender: TObject);
    procedure FileBtnClick(Sender: TObject);
    procedure DestBtn1Click(Sender: TObject);
    procedure DirBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtn1Click(Sender: TObject);
    procedure OkBtn1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    function SelectFile(F:ASCMRString):ASCMRString;
  public
    { Public declarations }
    SelResult:Boolean;
    SelMinFileSize,SelMaxFileSize:int64;
    SelDateOption:integer;  {0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom}
    SelMinDate,SelMaxDate:Double;
    SelFStyle:integer;
    procedure EditDisplay(FStyle:integer);
  end;

var
  SelDirF: TSelDirF;

implementation

uses RepMainU,ExSelDirU;

{$R *.dfm}

procedure TSelDirF.DestBtn2Click(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=DestE2.Text;
     s:=RepMainF.SelectDir(sb);
     if s<>sb Then
     DestE2.Text:=s;
end;

procedure TSelDirF.DestOptionsR1Click(Sender: TObject);
begin
     DestE1.Enabled:=DestOptionsR1.ItemIndex=1;
     DestBtn1.Enabled:=DestE1.Enabled;
end;

procedure TSelDirF.DestOptionsR2Click(Sender: TObject);
begin
     DestE2.Enabled:=DestOptionsR2.ItemIndex=1;
     DestBtn2.Enabled:=DestE2.Enabled;
end;

procedure TSelDirF.BitBtn1Click(Sender: TObject);
begin
     ExSelDirF:=TExSelDirF.Create(Nil);
     ExSelDirF.MinFileSize:=SelMinFileSize;
     ExSelDirF.MaxFileSize:=SelMaxFileSize;
     ExSelDirF.DateOption:=SelDateOption;
     ExSelDirF.MinDate:=SelMinDate;
     ExSelDirF.MaxDate:=SelMaxDate;
     ExSelDirF.ReadSettings;
     ExSelDirF.ShowModal;
     if ExSelDirF.Sonuc=1 then
     begin
          SelMinFileSize:=ExSelDirF.MinFileSize;
          SelMaxFileSize:=ExSelDirF.MaxFileSize;
          SelDateOption:=ExSelDirF.DateOption;
          SelMinDate:=ExSelDirF.MinDate;
          SelMaxDate:=ExSelDirF.MaxDate;
     end;
     ExSelDirF.Free;
     ExSelDirF:=nil;
end;

procedure TSelDirF.CancelBtn1Click(Sender: TObject);
begin
     SelResult:=False;
     Close;
end;

procedure TSelDirF.DestBtn1Click(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=DestE1.Text;
     s:=RepMainF.SelectDir(sb);
     if s<>'' then
        if s<>sb Then
           DestE1.Text:=s;
end;

procedure TSelDirF.DirBtnClick(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=DirE.Text;
     s:=RepMainF.SelectDir(sb);
     if s<>sb Then DirE.Text:=GetDirectory(s);
end;

procedure TSelDirF.EditDisplay(FStyle: integer);
begin
     SelFStyle:=FStyle;
     case FStyle of
          1,3: //search
          Begin

               DestE1.Visible:=False;
               DestL1.Visible:=False;
               DestBtn1.Visible:=False;
               DestOptionsR1.Visible:=False;
               DestOptionsR2.Visible:=False;
               DestE2.Visible:=False;
               DestL2.Visible:=False;
               DestBtn2.Visible:=False;
               DestBevel1.Visible:=False;
               DestBevel2.Visible:=False;
               PGCtrl.Height:=185;
          end;
          else //replace
          begin
               DestOptionsR1.Visible:=True;
               DestOptionsR2.Visible:=True;
               DestE1.Visible:=True;
               DestL1.Visible:=True;
               DestBtn1.Visible:=True;
               DestE2.Visible:=True;
               DestL2.Visible:=True;
               DestBtn2.Visible:=True;
               DestBevel1.Visible:=True;
               DestBevel2.Visible:=True;
               PGCtrl.Height:=308;
          end;
     end;
end;

procedure TSelDirF.FileBtnClick(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=FileNameE.Text;
     s:=SelectFile(sb);
     if s<>sb Then FileNameE.Text:=s;
end;

procedure TSelDirF.FormCreate(Sender: TObject);
begin
     SelResult:=False;
     SelFStyle:=0;
     FileNameOprChk1.Checked:=False;
     SelMinFileSize:=appdefaultsrec.MinFileSize;
     SelMaxFileSize:=appdefaultsrec.MAxFileSize;
     SelDateOption:=appdefaultsrec.DateOption;
     SelMinDate:=appdefaultsrec.MinDate;
     SelMaxDate:=appdefaultsrec.MaxDate;
     DirE.Text:=appdefaultsrec.SourceDir;
     ExMaskE.Text:=appdefaultsrec.ExcFilePtr;
     InMaskE.Text:=appdefaultsrec.IncFilePtr;
     DestE1.Text:=appdefaultsrec.DestDir;
     DestE2.Text:=appdefaultsrec.DestDir;
     SubsChk.Checked:=appdefaultsrec.SubDirs;
     PGCtrl.ActivePageIndex:=0;
     DestOptionsR1Click(nil);
end;

procedure TSelDirF.OkBtn1Click(Sender: TObject);
Var
   s1,s2,msg:ASCMRString;
begin
     msg:='';
     if PGCtrl.ActivePageIndex=0 Then
     Begin
          if DirE.Text='' Then
          msg:=msgSelSrcDir
          else
          if (DestE1.Text='') and DestE1.Visible Then
          msg:=msgSelDestDir;
     end else
     Begin
          if FileNameE.Text='' Then
          msg:=msgSelSrcFile
          else
          if (DestE2.Text='') and DestE2.Visible Then
          msg:=msgSelDestDir;
     end;
     if msg<>'' Then
     Begin
          ShowMessage(msg);
          exit;
     end;
     SelResult:=True;
     Close;
end;

function TSelDirF.SelectFile(F: ASCMRString): ASCMRString;
var
  d: ASCMRString;
begin
     if F<>'' then
     Begin
          d:=ExtractFilePath(F);
          if d<>'' Then
          RepMainF.OD3.InitialDir:=d;
          RepMainF.OD3.FileName:=F;
     end else
     RepMainF.OD3.FileName:='';
     if RepMainF.OD3.Execute then
     Begin
          Result := RepMainF.OD3.FileName;
     end Else
       Result:='';
end;

procedure TSelDirF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);
     if Shift=[] then
     Case key of
          VK_ESCAPE:Close;
     end;
end;

end.
