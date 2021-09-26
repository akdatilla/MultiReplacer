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
 
unit MulRepMainU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList;

type
  TMulRepMainF = class(TForm)
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MulRepMainF: TMulRepMainF;

implementation

{$R *.dfm}

procedure TMulRepMainF.CreateParams(var Params: TCreateParams);
begin
     inherited;
     Params.ExStyle := Params.ExStyle OR WS_EX_NOACTIVATE;
     Params.WndParent := GetDesktopWindow;

end;

procedure TMulRepMainF.FormCreate(Sender: TObject);
begin
     Left:=-300;Top:=-100;
end;

end.
