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
 
unit HexDataU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  THexDataF = class(TForm)
    HexMemo1: TMemo;
    SearchL: TLabel;
    Panel1: TPanel;
    OkBtn1: TBitBtn;
    CancelBtn1: TBitBtn;
    Label1: TLabel;
    procedure CancelBtn1Click(Sender: TObject);
    procedure OkBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Durum:Boolean;
  end;

var
  HexDataF: THexDataF;

implementation

{$R *.dfm}

procedure THexDataF.CancelBtn1Click(Sender: TObject);
begin
     Close;
end;

procedure THexDataF.FormCreate(Sender: TObject);
begin
     Durum:=false;
end;

procedure THexDataF.OkBtn1Click(Sender: TObject);
begin
     Durum:=true;
     Close;
end;

end.
