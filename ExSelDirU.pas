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
 
unit ExSelDirU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,Registry,RepConstU, ExtCtrls, Buttons, ToolWin,
  ImgList,RepLib,RepMainU;

type
  TExSelDirF = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    FileModifyR: TRadioGroup;
    FileSizeR: TRadioGroup;
    CustomFileModifyG: TGroupBox;
    FileModifyAfterChk: TCheckBox;
    FileModifyBeforeChk: TCheckBox;
    FileModifyAfterTime: TDateTimePicker;
    FileModifyBeforeTime: TDateTimePicker;
    CustomFileSizeG: TGroupBox;
    CustomFileSizeBiggerChk: TCheckBox;
    CustomFileSizeBiggerE: TEdit;
    UpDown1: TUpDown;
    CustomFileSizeSmallerChk: TCheckBox;
    CustomFileSizeSmallerE: TEdit;
    UpDown2: TUpDown;
    ToolBar1: TToolBar;
    ToolButton3: TToolButton;
    SaveBtn: TToolButton;
    ToolButton2: TToolButton;
    CloseBtn: TToolButton;
    FileModifyAfterDate: TDateTimePicker;
    FileModifyBeforeDate: TDateTimePicker;
    procedure FileSizeRClick(Sender: TObject);
    procedure FileModifyRClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    SelFileSizeMin,SelFileSizeMax:integer;
    Sonuc:integer;

    MinFileSize,MaxFileSize:int64;
    FileSizeOption,
    {0:Any Size,1:Up To 1 KB,2:Up To 100 KB,3:Up To 1 MB,4:Over 25 KB,
    5:Over 100 KB,6:Over 1 MB,7:Custom
    }
    DateOption:integer;  {0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom}

    MinDate,MaxDate:Double;

    procedure SaveSettings;
    procedure ReadSettings;
    procedure SozlukYukle;
  end;

var
  ExSelDirF: TExSelDirF;

implementation

{$R *.dfm}

{ TPrmF }

procedure TExSelDirF.CloseBtnClick(Sender: TObject);
begin
     Close;
end;

procedure TExSelDirF.FileModifyRClick(Sender: TObject);
begin
     CustomFileModifyG.Visible:=FileModifyR.ItemIndex=7;
end;

procedure TExSelDirF.FileSizeRClick(Sender: TObject);
begin
     CustomFileSizeG.Visible:=FileSizeR.ItemIndex=7;
end;

procedure TExSelDirF.FormCreate(Sender: TObject);
begin
     Sonuc:=0;
end;

procedure TExSelDirF.ReadSettings;
begin
          SelFileSizeMin:=MinFileSize;
          SelFileSizeMax:=MaxFileSize;

          {0:Any Size,1:Up To 1 KB,2:Up To 100 KB,3:Up To 1 MB,4:Over 25 KB,
           5:Over 100 KB,6:Over 1 MB,7:Custom }
           if (SelFileSizeMin<0) then SelFileSizeMin:=0;
           if (SelFileSizeMax<0) then SelFileSizeMax:=0;
           if (SelFileSizeMin=0) and ((SelFileSizeMax=0) or (SelFileSizeMax>34000000)) then FileSizeOption:=0
           else
           if (SelFileSizeMin=1024) and (SelFileSizeMax=0) then FileSizeOption:=1
           else
           if (SelFileSizeMin=102400) and (SelFileSizeMax=0) then FileSizeOption:=2
           else
           if (SelFileSizeMin=1048576) and (SelFileSizeMax=0) then FileSizeOption:=3
           else
           if (SelFileSizeMin=0) and (SelFileSizeMax=25600) then FileSizeOption:=4
           else
           if (SelFileSizeMin=0) and (SelFileSizeMax=102400) then FileSizeOption:=5
           else
           if (SelFileSizeMin=0) and (SelFileSizeMax=1048576) then FileSizeOption:=6
           else
           FileSizeOption:=7;

          FileSizeR.ItemIndex:=FileSizeOption;
          FileModifyR.ItemIndex:=DateOption;
          FileModifyAfterDate.Date:=Int(MinDate);
          FileModifyAfterTime.Time:=Frac(MinDate);
          FileModifyBeforeDate.Date:=Int(MaxDate);
          FileModifyBeforeTime.Time:=Frac(MaxDate);
          CustomFileSizeBiggerE.Text:=inttostr(SelFileSizeMin);
          CustomFileSizeSmallerE.Text:=inttostr(SelFileSizeMax);
end;

procedure TExSelDirF.SaveBtnClick(Sender: TObject);
begin
     SaveSettings;
end;

procedure TExSelDirF.SaveSettings;
Var
   errswc:Boolean;
   keyname:ASCMRString;
   Reg:TRegistry;
begin
          MinFileSize:=SelFileSizeMin;
          MaxFileSize:=SelFileSizeMax;
          FileSizeOption:=FileSizeR.ItemIndex;
          DateOption:=FileModifyR.ItemIndex;
          case FileModifyR.ItemIndex of
               //0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom
               0..6:
               Begin
                    MinDate:=0;
                    MaxDate:=0;
               End;
               7:
               begin
                    MinDate:=int(FileModifyAfterDate.Date)+Frac(FileModifyAfterTime.Time);
                    MaxDate:=int(FileModifyBeforeDate.Date)+Frac(FileModifyBeforeTime.Time);
               end;
          end;
          case FileSizeR.ItemIndex of
          {0:Any Size,1:Up To 1 KB,2:Up To 100 KB,3:Up To 1 MB,4:Over 25 KB,
           5:Over 100 KB,6:Over 1 MB,7:Custom }
               0:
               Begin
                    SelFileSizeMin:=0;
                    SelFileSizeMax:=0;
               End;
               1:
               Begin
                    SelFileSizeMin:=1024;
                    SelFileSizeMax:=0;
               End;
               2:
               Begin
                    SelFileSizeMin:=102400;
                    SelFileSizeMax:=0;
               End;
               3:
               Begin
                    SelFileSizeMin:=1048576;
                    SelFileSizeMax:=0;
               End;
               4:
               Begin
                    SelFileSizeMin:=0;
                    SelFileSizeMax:=25600;
               End;
               5:
               Begin
                    SelFileSizeMin:=0;
                    SelFileSizeMax:=102400;
               End;
               6:
               Begin
                    SelFileSizeMin:=0;
                    SelFileSizeMax:=1048576;
               End;
               7:
               Begin
                    SelFileSizeMin:=TextToInt(CustomFileSizeBiggerE.Text)*1024;
                    SelFileSizeMax:=TextToInt(CustomFileSizeSmallerE.Text)*1024;
               End;
          end;
          if SelFileSizeMin<0 then
          Begin
               MessageDlg(msgExSelHata1,mtError,[mbOK],0);
               exit;
          end;
          if SelFileSizeMax<0 then
          Begin
               MessageDlg(msgExSelHata2,mtError,[mbOK],0);
               exit;
          end;
          if (SelFileSizeMax>0) and (SelFileSizeMin>0) and (SelFileSizeMin>=SelFileSizeMax) then
          Begin
               MessageDlg(msgExSelHata3,mtError,[mbOK],0);
               exit;
          end;

          MinFileSize:=SelFileSizeMin;
          MaxFileSize:=SelFileSizeMax;
          FileSizeOption:=FileSizeR.ItemIndex;
          DateOption:=FileModifyR.ItemIndex;

     Sonuc:=1;
     Close;

end;

procedure TExSelDirF.SozlukYukle;
begin
     FileModifyAfterChk.Caption:=msgFileModifyAfterChk;
     FileModifyBeforeChk.Caption:=msgFileModifyBeforeChk;
     FileModifyR.Items.Strings[1]:=msgBirSaatIcinde;
end;

procedure TExSelDirF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);
     if Shift=[] then
     Case key of
          VK_ESCAPE:Close;
     end;
end;

end.
