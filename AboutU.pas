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
unit AboutU;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, jpeg;

type
  TAboutF = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Bevel1: TBevel;
    Image1: TImage;
    Image3: TImage;
    Image2: TImage;
    UrunAdiL: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RecUserLBsl: TLabel;
    RegUserL: TLabel;
    Label5: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutF: TAboutF;

implementation

{$R *.dfm}
uses RepMainU,RepConstU;
procedure TAboutF.FormCreate(Sender: TObject);
begin
     UrunAdiL.Caption:=ASCProductName;
     {$IF (DemoVersiyon=0)}
     RegUserL.Caption:=RepMainF.RegisterHeader.RegistrationName;
     {$ELSE}
     UrunAdiL.Font.Color:=$FF;
     RegUserL.Visible:=False;
     RecUserLBsl.Visible:=False;
     {$IFEND}

end;

procedure TAboutF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

end.
 
