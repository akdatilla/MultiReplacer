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
 
unit ASCOfisTool;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ComObj, StdCtrls, shellapi,ActiveX, OleServer, WordXP, ComCtrls;
function ExcelSaveAsText(ExcelFile, TextFile: TFileName): Boolean;
function WordSaveAsText(WordFile, TextFile: TFileName): Boolean;
function PrgSaveAsText(PrgPath,Parametreler: TFileName): Boolean;

implementation
uses RepConstU;

function PrgSaveAsText(PrgPath,Parametreler: TFileName): Boolean;
var
   starttime:Cardinal;
   SEInfo: TShellExecuteInfo; //windows nt+ gereklidir
   PrgExitCode:DWord;
begin
     Result:=False;
     FillChar(SEInfo, SizeOf(SEInfo), 0);
     SEInfo.cbSize := SizeOf(TShellExecuteInfo);
     with SEInfo do
     begin
          fMask := SEE_MASK_NOCLOSEPROCESS;
          Wnd := Application.Handle;
          lpFile := PChar(PrgPath);
          lpParameters := PChar(Parametreler);
          // lpDirectory := PChar(StartInString) ;
          nShow := SW_HIDE;
     end;
     starttime:=GetTickCount;//bu komutun belirli aralýklarla sýfýrlandýðý göz ardý edilmemeli
     if ShellExecuteEx(@SEInfo) then
     begin
          repeat
                Application.ProcessMessages;
                GetExitCodeProcess(SEInfo.hProcess, PrgExitCode) ;
          until (PrgExitCode <> STILL_ACTIVE) or Application.Terminated or
          (starttime+PDFIsZamanAsimi<GetTickCount);
          if not(Application.Terminated or
          (starttime+PDFIsZamanAsimi<GetTickCount)) then
          Result:=true;
     end;
end;
function ExcelSaveAsText(ExcelFile, TextFile: TFileName): Boolean;
const
  xlText = -4158;//{$IF (ASCUniCodeUsing=1)} 42 {$ELSE} -4158{$IFEND};
var
  ExcelApp: OleVariant;
  vTemp1, vTemp2, vTemp3: OLEVariant;
begin
  Result := False;
  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    // Fehler beim öffnen von Excel...
    // Error occured...
    Exit;
  end;
  try
    ExcelApp.Workbooks.Open(ExcelFile);
    ExcelApp.DisplayAlerts := False;
    vTemp3 := False;
    vTemp2 := xlText;
    vTemp1 := TextFile;
    ExcelApp.ActiveWorkbook.SaveAs(vTemp1,vtemp2,vtemp3);

    Result := True;
  except
  end;
  try
    ExcelApp.Quit;
  except
  end;
  try
    ExcelApp := Unassigned;
  except
  end;
end;

function WordSaveAsText(WordFile, TextFile: TFileName): Boolean;
const
  wordText = {$IF (ASCUniCodeUsing=1)} 7{wdFormatUnicodeText}  {$ELSE} 3{$IFEND};
var
  WordApp: OleVariant;
  vTemp1, vTemp2: OLEVariant;
begin
  Result := False;
  try
    WordApp := CreateOleObject('Word.Application');
  except
    // Fehler beim öffnen von Excel...
    // Error occured...
    Exit;
  end;
  try
    WordApp.Documents.Open(WordFile);
    WordApp.DisplayAlerts := False;
    vTemp2 := wordText;
    vTemp1 := TextFile;
    WordApp.ActiveDocument.SaveAs(vTemp1,vTemp2);

    Result := True;
  except
  end;
  try
     WordApp.Quit;
  except
  end;
  try
     WordApp := Unassigned;
  except
  end;
end;

initialization
  CoInitialize(nil);
finalization
  CoUninitialize;
end.
