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
 
unit FileFormatSelU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,RepMainU, ComCtrls, ToolWin, StdCtrls,RepConstU;

type
  TFileFormatSelF = class(TForm)
    ToolBar1: TToolBar;
    ToolButton3: TToolButton;
    SaveBtn: TToolButton;
    CloseBtn: TToolButton;
    ToolButton2: TToolButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    NormalSecLbl: TLabel;
    SecNormal: TRadioButton;
    SecKarakterAra: TRadioButton;
    SecIkiSatir: TRadioButton;
    SecSatirSutun: TRadioButton;
    SecCsvTekli: TRadioButton;
    SecCsvIkili: TRadioButton;
    SecCsvSatCol: TRadioButton;
    KarakterAra1: TEdit;
    KarakterAra2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    IkiSatir1: TEdit;
    Label6: TLabel;
    IkiSatir2: TEdit;
    Label7: TLabel;
    SatirSutun1: TEdit;
    Label8: TLabel;
    SatirSutun2: TEdit;
    Label9: TLabel;
    SatirSutun3: TEdit;
    Label10: TLabel;
    SatirSutun4: TEdit;
    Label11: TLabel;
    CsvTekli1: TEdit;
    CsvIkili1: TEdit;
    CsvIkili2: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    CsvSatCol1: TEdit;
    Label15: TLabel;
    CsvSatCol2: TEdit;
    Label16: TLabel;
    CsvSatCol3: TEdit;
    Label17: TLabel;
    CsvSatCol4: TEdit;
    Label2: TLabel;
    Label18: TLabel;
    SecIkiSutun: TRadioButton;
    IkiSutun1: TEdit;
    IkiSutun2: TEdit;
    Label19: TLabel;
    CSVCharacter: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure SecNormalClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Cevap:integer;
  end;

var
  FileFormatSelF: TFileFormatSelF;

implementation

{$R *.dfm}

procedure TFileFormatSelF.FormCreate(Sender: TObject);
begin
     Cevap:=0;
end;

procedure TFileFormatSelF.SaveBtnClick(Sender: TObject);
begin
     if ((CSVCharacter.Text<>'SPACE') and (CSVCharacter.Text<>'TAB') and (Length(CSVCharacter.Text)<>1)) and
     (CSVCharacter.Enabled) then
     begin
          showmessage(errCSVCharacterbirkarakterolmali);
          exit;
     end;
     Cevap:=1;
     Close;
end;

procedure TFileFormatSelF.CloseBtnClick(Sender: TObject);
begin
     Close;
end;

procedure TFileFormatSelF.SecNormalClick(Sender: TObject);
begin
     CSVCharacter.Enabled:=False;
          if SecKarakterAra.Checked then
          begin
               KarakterAra1.Enabled:=True;
               KarakterAra2.Enabled:=True;
          end else
          begin
               KarakterAra1.Enabled:=False;
               KarakterAra2.Enabled:=False;
          end;
          if SecIkiSatir.Checked then
          begin
               IkiSatir1.Enabled:=True;
               IkiSatir2.Enabled:=True;
          end else
          begin
               IkiSatir1.Enabled:=False;
               IkiSatir2.Enabled:=False;
          end;
          if SecIkiSutun.Checked then
          begin
               IkiSutun1.Enabled:=True;
               IkiSutun2.Enabled:=True;
          end else
          begin
               IkiSutun1.Enabled:=False;
               IkiSutun2.Enabled:=False;
          end;
          if SecSatirSutun.Checked then
          begin
               SatirSutun1.Enabled:=True;
               SatirSutun2.Enabled:=True;
               SatirSutun3.Enabled:=True;
               SatirSutun4.Enabled:=True;
          end else
          begin
               SatirSutun1.Enabled:=False;
               SatirSutun2.Enabled:=False;
               SatirSutun3.Enabled:=False;
               SatirSutun4.Enabled:=False;
          end;
          if SecCsvTekli.Checked then
          begin
               CsvTekli1.Enabled:=True;
               CSVCharacter.Enabled:=True;
          end else
          begin
               CsvTekli1.Enabled:=False;
          end;
          if SecCsvIkili.Checked then
          begin
               CsvIkili1.Enabled:=True;
               CsvIkili2.Enabled:=True;
               CSVCharacter.Enabled:=True;
          end else
          begin
               CsvIkili1.Enabled:=False;
               CsvIkili2.Enabled:=False;
          end;
          if SecCsvSatCol.Checked then
          begin
               CsvSatCol1.Enabled:=True;
               CsvSatCol2.Enabled:=True;
               CsvSatCol3.Enabled:=True;
               CsvSatCol4.Enabled:=True;
               CSVCharacter.Enabled:=True;
          end else
          begin
               CsvSatCol1.Enabled:=False;
               CsvSatCol2.Enabled:=False;
               CsvSatCol3.Enabled:=False;
               CsvSatCol4.Enabled:=False;
          end;

end;


procedure TFileFormatSelF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);
     if Shift=[] then
     Case key of
          VK_ESCAPE:Close;
     end;

end;

end.
