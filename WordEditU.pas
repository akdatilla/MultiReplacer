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
 
unit WordEditU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls,RepConstU, Menus,TntStdCtrls,RepThreadU;

type
  TWordEditF = class(TForm)
    SearchL: TLabel;
    NewL: TLabel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    CaseChk: TCheckBox;
    RegExChk: TCheckBox;
    OldE: TMemo;
    NewE: TMemo;
    SubMatchE: TMemo;
    SubMatchL: TLabel;
    SingleWordsOnlyChk: TCheckBox;
    Label4: TLabel;
    SingleOnMatching: TComboBox;
    FileFormatOptBtn: TBitBtn;
    SearchOnlyChk: TCheckBox;
    KeepCaseChk: TCheckBox;
    MatchReqC: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupE: TEdit;
    GroupUpDown: TUpDown;
    SysVarPUP: TPopupMenu;
    FileInformations1: TMenuItem;
    svpupsecFILEDIR: TMenuItem;
    svpupsecFULLFILENAME: TMenuItem;
    svpupsecFILENAMEWITHEXT: TMenuItem;
    svpupsecFILENAMENOEXT: TMenuItem;
    svpupsecFILEEX: TMenuItem;
    svpupsecFILESIZE: TMenuItem;
    svpupsecFILEMODIFYDATE: TMenuItem;
    svpupsecFILEMODIFYYEAR: TMenuItem;
    svpupsecFILEMODIFYMONTH: TMenuItem;
    svpupsecFILEMODIFYDAY: TMenuItem;
    CurrentDateTime1: TMenuItem;
    svpupsecCURRENTDATE: TMenuItem;
    svpupsecCURRENTYEAR: TMenuItem;
    svpupsecCURRENTMONTH: TMenuItem;
    svpupsecCURRENTDAY: TMenuItem;
    svpupsecCURRENTTIME: TMenuItem;
    SysVarL1: TLabel;
    SysVarL2: TLabel;
    SysVarL3: TLabel;
    HexLbl1: TLabel;
    HexLbl2: TLabel;
    HexLbl3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FileFormatOptBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure svpupsecMenuClick(Sender: TObject);
    procedure SysVarL1Click(Sender: TObject);
    procedure SysVarL2Click(Sender: TObject);
    procedure SysVarL3Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HexLbl1Click(Sender: TObject);
    procedure HexLbl2Click(Sender: TObject);
    procedure HexLbl3Click(Sender: TObject);
  private
    { Private declarations }
    SelectedSysVarPUP:integer; //1:Search Text ,2:Sub Match Text,3:ReplaceText
  public
    { Public declarations }
    SelResult:Boolean;
    v_areainfo,v_start1,v_start2,v_stop1,v_stop2:integer;
    v_csvchar:ASCMRString;
    TNTOldE: TASCMemo;
    TNTNewE: TASCMemo;
    TNTSubMatchE: TASCMemo;

    procedure EditDisplay;
    function ConvertTNTMemo(Edt:TMemo):TASCMemo;
    procedure SozlukYukle;
  end;

var
  WordEditF: TWordEditF;

implementation

{$R *.dfm}
uses repmainu;

procedure TWordEditF.CancelBtnClick(Sender: TObject);
begin
     SelResult:=False;
     Close;
end;

function TWordEditF.ConvertTNTMemo(Edt: TMemo): TASCMemo;
Var
   N:String;
begin
     Result:=TASCMemo.Create(self);
     n:=Edt.Name;
     Result.Parent:=Edt.Parent;
     Result.Left:=Edt.Left;
     Result.Top:=Edt.Top;
     Result.Width:=Edt.Width;
     Result.Height:=Edt.Height;
     Result.Font.Assign(Edt.Font);
     Result.Lines.Text:=Edt.Lines.Text;
     Edt.Free;
     Result.Name:=n;

end;

procedure TWordEditF.EditDisplay;
begin
     if TNTNewE.Visible then
     Begin
          Height:=420;
     end else
     Begin
          Height:=301;
     end;

end;

procedure TWordEditF.FormCreate(Sender: TObject);
begin
     Self.DoubleBuffered:=true;
     TNTOldE:=ConvertTNTMemo(OldE);
     TNTSubMatchE:=ConvertTNTMemo(SubMatchE);
     TNTNewE:=ConvertTNTMemo(NewE);
     SelResult:=False;
     TNTOldE.TabOrder:=0;
     TNTSubMatchE.TabOrder:=1;
     TNTNewE.TabOrder:=2;
     SozlukYukle;
end;

procedure TWordEditF.FormShow(Sender: TObject);
begin
     EditDisplay;
end;

procedure TWordEditF.HexLbl1Click(Sender: TObject);
begin
     RepMainF.HexDataTool(TNTOldE.Lines);
end;

procedure TWordEditF.HexLbl2Click(Sender: TObject);
begin
     RepMainF.HexDataTool(TNTSubMatchE.Lines);
end;

procedure TWordEditF.HexLbl3Click(Sender: TObject);
begin
     RepMainF.HexDataTool(TNTNewE.Lines);
end;

procedure TWordEditF.OkBtnClick(Sender: TObject);
Var
   msg:ASCMRString;
begin
     if GroupUpDown.Position<0 then msg:=wronggroupnumber
     else
     if TNTOldE.Text='' Then msg:=msgEnterSearchTxt
     //else
     //if (TNTNewE.Text='') and (TNTNewE.Visible) Then msg:='Please enter replace text.'
     else msg:='';
     if msg<>'' Then
     Begin
          ShowMessage(msg);
          exit;
     end;
     SelResult:=True;
     Close;
end;

procedure TWordEditF.SozlukYukle;
begin
     SingleOnMatching.Items.Clear;
     SingleOnMatching.Items.Add(msgOnMatchingCmb1);
     SingleOnMatching.Items.Add(msgOnMatchingCmb2);
     SingleOnMatching.Items.Add(msgOnMatchingCmb3);
     SingleOnMatching.Items.Add(msgOnMatchingCmb4);
     SingleOnMatching.Items.Add(msgOnMatchingCmb5);
     SingleOnMatching.Items.Add(msgOnMatchingCmb6);
end;

procedure TWordEditF.svpupsecMenuClick(Sender: TObject);
var
   s:ASCMRString;
begin
     //
     if Sender is TMenuItem then
     begin
          s:=(Sender as TMenuItem).Name;
          if Pos('svpupsec',s)=1 then
          begin
               Delete(s,1,8);
               insert('@sv',s,1);
               Case SelectedSysVarPUP of
                    1:TNTOldE.Lines.Text:=TNTOldE.Lines.Text+s;
                    2:TNTSubMatchE.Lines.Text:=TNTSubMatchE.Lines.Text+s;
                    3:TNTNewE.Lines.Text:=TNTNewE.Lines.Text+s;
               End;

          end;
     end;

end;

procedure TWordEditF.SysVarL1Click(Sender: TObject);
begin
     SelectedSysVarPUP:=1;
     SysVarPUP.Popup(SysVarL1.ClientOrigin.X,SysVarL1.ClientOrigin.Y+SysVarL1.Height);
end;

procedure TWordEditF.SysVarL2Click(Sender: TObject);
begin
     SelectedSysVarPUP:=2;
     SysVarPUP.Popup(SysVarL2.ClientOrigin.X,SysVarL2.ClientOrigin.Y+SysVarL2.Height);
end;

procedure TWordEditF.SysVarL3Click(Sender: TObject);
begin
     SelectedSysVarPUP:=3;
     SysVarPUP.Popup(SysVarL3.ClientOrigin.X,SysVarL3.ClientOrigin.Y+SysVarL3.Height);
end;

procedure TWordEditF.FileFormatOptBtnClick(Sender: TObject);
begin
     RepMainF.FileFormatSelDialog(v_areainfo,v_start1,v_start2,
     v_stop1,v_stop2,v_csvchar);
end;

procedure TWordEditF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

     if Shift=[] then
     Case key of
          VK_ESCAPE:Close;
     end;

end;

procedure TWordEditF.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     {
     if CaseChk.Visible then
     begin
          CaseChk.Refresh;
          CaseChk.Repaint;
     end;
     if RegExChk.Visible then
     begin
          RegExChk.Refresh;
          RegExChk.Repaint;
     end;
     if SingleWordsOnlyChk.Visible then
     begin
          SingleWordsOnlyChk.Refresh;
          SingleWordsOnlyChk.Repaint;
     end;
     if SearchOnlyChk.Visible then
     begin
          SearchOnlyChk.Refresh;
          SearchOnlyChk.Repaint;
     end;
     if KeepCaseChk.Visible then
     begin
          KeepCaseChk.Refresh;
          KeepCaseChk.Repaint;
     end;
     }
end;

end.
