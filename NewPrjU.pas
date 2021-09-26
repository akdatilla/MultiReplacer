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
 
unit NewPrjU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TNewPrjF = class(TForm)
    CancelBtn: TBitBtn;
    StartBtn1: TBitBtn;
    StartBtn2: TBitBtn;
    StartBtn3: TBitBtn;
    StartBtn4: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure StartBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Ret:integer;
  end;

var
  NewPrjF: TNewPrjF;

implementation

{$R *.dfm}

uses RepMainU;

procedure TNewPrjF.CancelBtnClick(Sender: TObject);
begin
     Ret:=0;
     Close;
end;

procedure TNewPrjF.FormCreate(Sender: TObject);
begin
     Ret:=0;
     

end;

procedure TNewPrjF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

procedure TNewPrjF.StartBtn1Click(Sender: TObject);
Var
   i:integer;
begin
     i:=0;
     if Sender is TBitBtn then
     i:=(Sender as TBitBtn).Tag;
     if i>0 then
     Begin
          Ret:=i;
          Close;
     End;
end;

end.
