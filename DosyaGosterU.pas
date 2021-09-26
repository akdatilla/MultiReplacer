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
 
unit DosyaGosterU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, shellapi,Menus,RepLib,MulRepMainU,RepConstU,RichEdit,RepThreadU;

type
  TDosyaGosterF = class(TForm)
    ContentRE: TRichEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    SaveAs1: TMenuItem;
    Print1: TMenuItem;
    Close1: TMenuItem;
    sd1: TSaveDialog;
    OD1: TOpenDialog;

    procedure SaveAs1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations }
  public
    { Public declarations }
    FRepFrm:TForm;
    TNTContentRE:TASCRichEditB;
    function ConvertASCRichEdit(Edt:TRichEdit):TASCRichEditB;
  end;

var
  DosyaGosterF: TDosyaGosterF;

implementation

uses RepMainU,RepFrmU;

{$R *.dfm}



procedure TDosyaGosterF.Close1Click(Sender: TObject);
begin
     Close;
end;

function TDosyaGosterF.ConvertASCRichEdit(Edt: TRichEdit): TASCRichEditB;
Var
   N:ASCMRString;
   v:ASCMRString;
   TabOrderNo:integer;
begin
     Result:=TASCRichEditB.Create(self);
     n:=Edt.Name;
     TabOrderNo:=Edt.TabOrder;
     Result.Parent:=Edt.Parent;
     Result.Left:=Edt.Left;
     Result.Top:=Edt.Top;
     Result.Width:=Edt.Width;
     Result.Height:=Edt.Height;
     Result.Align:=Edt.Align;
     Result.Font.Assign(Edt.Font);
     Result.ScrollBars:=Edt.ScrollBars;
     v:=Edt.Lines.Text;
     Edt.Free;
     Result.Name:=n;
     Result.Lines.Text:=v;
     Result.TabOrder:=TabOrderNo;

end;

procedure TDosyaGosterF.CreateParams(var Params: TCreateParams);
begin
     inherited;
     Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
     Params.WndParent := GetDesktopWindow;

end;

procedure TDosyaGosterF.Print1Click(Sender: TObject);
begin
     TNTContentRE.Print(Caption);
end;

procedure TDosyaGosterF.SaveAs1Click(Sender: TObject);
begin
     //
     if sd1.Execute then
     begin
          if ExtractFileExt(sd1.FileName)='' then
          begin
               if sd1.FilterIndex=1 then
               sd1.FileName:=sd1.FileName+'.txt'
               else
               if sd1.FilterIndex=2 then
               sd1.FileName:=sd1.FileName+'.rtf';
          end;
          if Pos('RTF',uppercase(ExtractFileExt(sd1.FileName)))<1 then     
          TNTContentRE.PlainText:=True
          else
          TNTContentRE.PlainText:=False;

          TNTContentRE.Lines.SaveToFile(sd1.FileName);
     end;
end;

end.
