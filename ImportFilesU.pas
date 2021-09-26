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
 
unit ImportFilesU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls,FileCtrl, ExtCtrls,RepConstU, CheckLst;
const
     SELDIRHELP=1000;

type
  TImportFilesF = class(TForm)
    PGCtrl: TPageControl;
    TabSheet1: TTabSheet;
    ASCLabel1: TLabel;
    ASCLabel3: TLabel;
    InMaskE: TEdit;
    OkBtn1: TBitBtn;
    CancelBtn1: TBitBtn;
    DestL1: TLabel;
    DestBtn1: TBitBtn;
    DestE1: TEdit;
    DestOptionsR1: TRadioGroup;
    DestBevel1: TBevel;
    Bevel4: TBevel;
    Label1: TLabel;
    ExMaskE: TEdit;
    SubsChk: TCheckBox;
    BitBtn1: TBitBtn;
    SourceList: TCheckListBox;
    SelAllBtn: TBitBtn;
    DeSelAllBtn: TBitBtn;
    procedure DestOptionsR1Click(Sender: TObject);
    procedure DestBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtn1Click(Sender: TObject);
    procedure OkBtn1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure DeSelAllBtnClick(Sender: TObject);
    procedure SelAllBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function SelectDir(dir:ASCMRString):ASCMRString;
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
  ImportFilesF: TImportFilesF;

implementation

uses RepMainU,ExSelDirU;

{$R *.dfm}

procedure TImportFilesF.DestOptionsR1Click(Sender: TObject);
begin
     DestE1.Enabled:=DestOptionsR1.ItemIndex=1;
     DestBtn1.Enabled:=DestE1.Enabled;
end;

procedure TImportFilesF.BitBtn1Click(Sender: TObject);
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

procedure TImportFilesF.SelAllBtnClick(Sender: TObject);
var
  j: Integer;
begin
     for j := 0 to SourceList.Items.Count - 1 do
         SourceList.Checked[j]:=True;
end;

procedure TImportFilesF.DeSelAllBtnClick(Sender: TObject);
var
  j: Integer;
begin
     for j := 0 to SourceList.Items.Count - 1 do
         SourceList.Checked[j]:=False;
end;

procedure TImportFilesF.CancelBtn1Click(Sender: TObject);
begin
     SelResult:=False;
     Close;
end;

procedure TImportFilesF.DestBtn1Click(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=DestE1.Text;
     s:=SelectDir(sb);
     if s<>sb Then
     DestE1.Text:=s;
end;

procedure TImportFilesF.EditDisplay(FStyle: integer);
begin
     SelFStyle:=FStyle;
     case FStyle of
          1,3: //search
          Begin

               DestE1.Visible:=False;
               DestL1.Visible:=False;
               DestBtn1.Visible:=False;
               DestOptionsR1.Visible:=False;
               DestBevel1.Visible:=False;
               PGCtrl.Height:=316;
          end;
          else //replace
          begin
               PGCtrl.Height:=444;
               DestOptionsR1.Visible:=True;
               DestE1.Visible:=True;
               DestL1.Visible:=True;
               DestBtn1.Visible:=True;
               DestBevel1.Visible:=True;
          end;
     end;
end;

procedure TImportFilesF.FormActivate(Sender: TObject);
begin
     try
        if OkBtn1.CanFocus then  OkBtn1.SetFocus;
     except
     end;
end;

procedure TImportFilesF.FormCreate(Sender: TObject);
begin
     SelResult:=False;
     SelFStyle:=0;
     SelMinFileSize:=appdefaultsrec.MinFileSize;
     SelMaxFileSize:=appdefaultsrec.MAxFileSize;
     SelDateOption:=appdefaultsrec.DateOption;
     SelMinDate:=appdefaultsrec.MinDate;
     SelMaxDate:=appdefaultsrec.MaxDate;
     ExMaskE.Text:=appdefaultsrec.ExcFilePtr;
     InMaskE.Text:=appdefaultsrec.IncFilePtr;
     DestE1.Text:=appdefaultsrec.DestDir;
     SubsChk.Checked:=appdefaultsrec.SubDirs;

end;

procedure TImportFilesF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

procedure TImportFilesF.OkBtn1Click(Sender: TObject);
Var
   s1,s2,msg:ASCMRString;
begin
     msg:='';
     if (DestE1.Text='') and DestE1.Visible Then
     msg:=msgSelDestDir;
     if msg<>'' Then
     Begin
          ShowMessage(msg);
          exit;
     end;
     SelResult:=True;
     Close;
end;

function TImportFilesF.SelectDir(dir: ASCMRString): ASCMRString;
var
  fDir: String;
begin
  fDir := dir;
  if SelectDirectory(fDir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    Result := fDir
    Else
    Result:='';
end;

end.
