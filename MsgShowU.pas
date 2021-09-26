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
 
unit MsgShowU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons,RepLib;

type
  TMsgShowF = class(TForm)
    MsgLbl: TLabel;
    BtnYes: TBitBtn;
    BtnCancel: TBitBtn;
    BtnNo: TBitBtn;
    ChkAll: TCheckBox;
    Timer1: TTimer;
    BtnActivate: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure BtnYesClick(Sender: TObject);
    procedure BtnNoClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnActivateTimer(Sender: TObject);
  private
  public
    { Public declarations }
    DlgResult:rsTypes;
    DlgType:msTypes;
  end;

var
  MsgShowF: TMsgShowF;

implementation

{$R *.DFM}


procedure TMsgShowF.Timer1Timer(Sender: TObject);
begin
     Timer1.Enabled:=false;
     Close;
end;

procedure TMsgShowF.BtnYesClick(Sender: TObject);
begin
     if ChkAll.Checked Then DlgResult:=rsAllYes Else
     DlgResult:=rsYes;
     Timer1.Enabled:=True;
end;

procedure TMsgShowF.BtnNoClick(Sender: TObject);
begin
     if ChkAll.Checked Then DlgResult:=rsAllNo Else
     DlgResult:=rsNo;
     Timer1.Enabled:=True;
end;

procedure TMsgShowF.BtnCancelClick(Sender: TObject);
begin
     DlgResult:=rsCancel;
     Timer1.Enabled:=True;
end;

procedure TMsgShowF.FormShow(Sender: TObject);
begin
     DlgResult:=rsCancel;
     Case DlgType of
          msOk:
          Begin
               BtnNo.Visible:=False;
               BtnCancel.Visible:=False;
               BtnYes.Left:=180;
               BtnYes.Caption:='OK';
          End;
          msOkCancel:
          Begin
               BtnNo.Caption:='Cancel';
               BtnCancel.Visible:=False;
               BtnYes.Left:=116;
               BtnNo.Left:=244;
          End;
          msYesNo:
          Begin
               BtnCancel.Visible:=False;
               BtnYes.Left:=116;
               BtnNo.Left:=244;
          End;
          msAllYNC:
          Begin
               ChkAll.Visible:=True;
          End;
     End;

end;

procedure TMsgShowF.FormCreate(Sender: TObject);
begin
     BtnActivate.Enabled:=True;
end;

procedure TMsgShowF.BtnActivateTimer(Sender: TObject);
begin
     BtnActivate.enabled:=False;
     BtnYes.Enabled:=True;
     BtnNo.Enabled:=True;
     BtnCancel.Enabled:=True;
     if BtnYes.Visible Then BtnYes.SetFocus;
end;

end.
