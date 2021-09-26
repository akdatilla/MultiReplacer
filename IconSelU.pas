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
 
unit IconSelU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, ExtDlgs,math,RepConstU;

type
  TIconSelF = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    DosyayaKaydetBtn: TBitBtn;
    SimgeEkleBtn: TBitBtn;
    SimgeCikarBtn: TBitBtn;
    ImgList1: TImageList;
    OPD1: TOpenPictureDialog;
    SD1: TSaveDialog;
    DegistirBtn: TBitBtn;
    TamamBtn: TBitBtn;
    IptalBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure IptalBtnClick(Sender: TObject);
    procedure TamamBtnClick(Sender: TObject);
    procedure DegistirBtnClick(Sender: TObject);
    procedure DosyayaKaydetBtnClick(Sender: TObject);
    procedure SimgeCikarBtnClick(Sender: TObject);
    procedure SimgeEkleBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ChangeOptions,Cevap:integer;

    procedure imglist;
  end;

var
  IconSelF: TIconSelF;

  function imagelistLoadAll(imgList:TimageList;FileName:ASCMRString):Boolean;
  function imagelistSaveAll(imgList:TimageList;FileName:ASCMRString):Boolean;
  function GetTranperentColor(Bmp:TBitmap):integer;
  function isEmptyBmp(Bmp:TBitmap;F:Boolean):Boolean;
  
implementation

{$R *.dfm}


function imagelistSaveAll(imgList:TimageList;FileName:ASCMRString):Boolean;
Var
   sw,sh,w,h,j,k,l:integer;
   img,isr:TBitmap;
begin
     Result:=False;
     if imgList.Count<1 then exit;
     w:=Round(ceil(sqrt(imgList.Count)));
     h:=imgList.Count div w;
     if (imgList.Count mod w)>0 then w:=w+1;
     if h<1 then h:=1;
     if w<1 then w:=1;
     sw:=w*imgList.Width;
     sh:=h*imgList.Height;
     img:=TBitmap.Create;
     img.Width:=sw;
     img.Height:=sh;
     img.Canvas.Brush.Color:=clFuchsia;
     img.Canvas.FillRect(rect(0,0,sw,sh));
     l:=0;
     for k := 0 to h - 1 do
         for j := 0 to w - 1 do
         Begin
              isr:=TBitmap.Create;
              imgList.Draw(img.Canvas,j*imgList.Width,k*imgList.Height,l,
              dsTransparent,itImage,True);
              inc(l);
         end;
     Try
        img.SaveToFile(FileName);
        Result:=True;
     Except
        Result:=False;
     end;
     img.Free;
     img:=Nil;
End;
function isEmptyBmp(Bmp:TBitmap;F:Boolean):Boolean;
Var
   r:TColor;
   j,k,dw,dh,w,h,x,y:integer;
Begin
     Result:=True;
     if Assigned(Bmp) then
     if Bmp.Empty Then exit;
     Begin
          r:=Bmp.Canvas.Pixels[0,0];
          if F then
          Begin
               for j := 0 to Bmp.Width - 1 do
               for k := 0 to Bmp.Height - 1 do
               Begin
                    if Bmp.Canvas.Pixels[j,k]<>r then
                    Begin
                             Result:=False;
                             exit;
                    end;
               end;
          end;

          if (Bmp.Width>1) and (Bmp.Height>1) then
          Begin
               case Bmp.Width of
                    2..3:dw:=1;
                    4..6:dw:=2;
                    7..12:dw:=3;
                    13..16:dw:=6;
                    17..32:dw:=8;
                    else dw:=12;
               end;
               case Bmp.Height of
                    2..3:dh:=1;
                    4..6:dh:=2;
                    7..12:dh:=3;
                    13..16:dh:=4;
                    17..32:dh:=6;
                    else dh:=8;
               end;
               if dw=1 then
               w:=Bmp.Width div 2
               else
               w:=Bmp.Width div dw;

               if dh=1 then
               h:=Bmp.Height div 2
               else
               h:=Bmp.Height div dh;
               for j := 1 to dw do
                   for k := 1 to dh do
                   Begin
                        y:=(k*h)-1;
                        x:=(j*w)-1;
                        if x>=Bmp.Width-1 then Continue;
                        if y>=Bmp.Height-1 then Continue;
                        if Bmp.Canvas.Pixels[x,y]<>r then
                        Begin
                             Result:=False;
                             exit;
                        end;

                   end;

          end;
     end;
end;
function GetTranperentColor(Bmp:TBitmap):integer;
Var
   zr:Array [0..3] of TColor;
   cr:Array [0..3] of byte;
   j,k:integer;
Begin
     Result:=clWhite;
     if Assigned(Bmp) then
     if (Bmp.Width>1) and (Bmp.Height>1) then
     Begin
          zr[0]:=Bmp.Canvas.Pixels[0,0];
          Result:=zr[0];
          zr[1]:=Bmp.Canvas.Pixels[Bmp.Width-1,0];
          zr[2]:=Bmp.Canvas.Pixels[0,Bmp.Height-1];
          zr[3]:=Bmp.Canvas.Pixels[Bmp.Width-1,Bmp.Height-1];
          for j:=0 to 2 do
           for k:=j+1 to 3 do
           Begin
                if j=k then continue;
                if zr[j]=zr[k] then
                Begin
                     Result:=zr[j];
                     exit;
                end;
           end;
     end;

end;


function imagelistLoadAll(imgList:TimageList;FileName:ASCMRString):Boolean;
Var
   img:TPicture;
   bmp:TBitmap;
   j,k:integer;
   rbmp,rsrc:TRect;
   I: Integer;
begin
     Result:=False;
     if FileExists(FileName) then
     Begin
          img:=TPicture.Create;
          img.LoadFromFile(FileName);
          bmp:=TBitmap.Create;
          Bmp.Width:=16;
          Bmp.Height:=16;
          rbmp.Left:=0;
          rbmp.Top:=0;
          rbmp.Bottom:=16;
          rbmp.Right:=16;
          if Assigned(img.Bitmap) Then
          for k := 0 to (img.Bitmap.Height div 16) - 1 do
          for j := 0 to (img.Bitmap.Width div 16) - 1 do
          Begin
               With rsrc Do
               Begin
                    Left:=j*16;
                    Top:=k*16;
                    Bottom:=Top+16;
                    Right:=Left+16;
               end;
               bmp.Canvas.CopyRect(rbmp,img.Bitmap.Canvas,rsrc);
               //bmp.SaveToFile('Z:\Software\Servis\Build\Temp\den'+inttostr(j)+inttostr(k)+'.bmp');
               if isEmptyBmp(bmp,False) Then
               if isEmptyBmp(bmp,True) Then Continue;
               Begin
                    Result:=True;
                    imgList.AddMasked(Bmp,GetTranperentColor(Bmp));
               end;
          end
          else
          Begin
               exit;
          end;
          img.Free;
          img:=Nil;
          Bmp.Free;
          bmp:=Nil;

     End;

End;

procedure TIconSelF.FormCreate(Sender: TObject);
begin
     ChangeOptions:=-1;
     Cevap:=-1;
end;

procedure TIconSelF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case key of
          27:IptalBtnClick(nil);

     end;
end;

procedure TIconSelF.FormShow(Sender: TObject);
begin
     DosyayaKaydetBtn.Enabled:=ChangeOptions>=0;
     SimgeEkleBtn.Enabled:=ChangeOptions>=0;
     SimgeCikarBtn.Enabled:=ChangeOptions>=0;
     DegistirBtn.Enabled:=ChangeOptions>=0;
end;

procedure TIconSelF.DegistirBtnClick(Sender: TObject);
Var
   img:TPicture;
   j:integer;
Begin
     if ListView1.Selected<>nil then
     Begin
          if MessageDLg('Seçili simge deðiþecek ! Emin misiniz ?',
          mtWarning,[mbYes,mbNo],0{$IF (CompilerOpt=1)},mbNo{$IFEND})=mrYes then
          Begin
               j:=ListView1.Selected.ImageIndex;
               if OPD1.Execute then
               Begin
                    img:=TPicture.Create;
                    img.LoadFromFile(OPD1.FileName);
                    if Assigned(img.Bitmap) Then
                    Begin
                         ImgList1.ReplaceMasked(j,img.Bitmap,img.Bitmap.Canvas.Pixels[0,0]);
                         ChangeOptions:=1;
                    end
                    else
                    if Assigned(img.Icon) Then
                    Begin
                         ImgList1.ReplaceIcon(j,img.Icon);
                         ChangeOptions:=1;
                    end
                    else
                    Begin
                         Showmessage('Simge deðiþtirilemedi !');
                    end;
                    img.Free;
                    img:=Nil;
               end;
          end;
     End;
     imglist;

end;

procedure TIconSelF.DosyayaKaydetBtnClick(Sender: TObject);
Var
   sw,sh,w,h,j,k,l:integer;
   img,isr:TBitmap;
begin
     if ImgList1.Count<1 then exit;
     if SD1.Execute then
     Begin
          if imagelistSaveAll(ImgList1,SD1.FileName) Then
          ShowMessage('Simgeler dosyaya kayýt edildi.')
          Else
          ShowMessage('Simgeler dosyaya kayýt edilemedi !');
     end;
end;

procedure TIconSelF.SimgeEkleBtnClick(Sender: TObject);
Var
   img:TPicture;
begin
     if OPD1.Execute then
     Begin
          if imagelistLoadAll(ImgList1,OPD1.FileName) Then
          ChangeOptions:=1;
     End;
     imglist;
end;

procedure TIconSelF.SimgeCikarBtnClick(Sender: TObject);
Var
   j:integer;
begin
     if ListView1.Selected<>nil then
     Begin
          if MessageDLg('Seçili simge silinecek ! Emin misiniz ?',
          mtWarning,[mbYes,mbNo],0{$IF (CompilerOpt=1)},mbNo{$IFEND})=mrYes then
          Begin
               j:=ListView1.Selected.ImageIndex;
               ImgList1.Delete(j);
               ListView1.Items.Delete(j);
               ChangeOptions:=1;
          end;
     end;
end;

procedure TIconSelF.imglist;
Var
   j:integer;
begin
     for j := 0 to ImgList1.Count - 1 do
     Begin
          if ListView1.Items.Count<=j then
          With ListView1.Items.Add Do
          Begin
               ImageIndex:=j;
          end;
     end;
     if ImgList1.Count<ListView1.Items.Count then

     for j := ListView1.Items.Count-1 downto ImgList1.Count do
     ListView1.Items.Delete(j);
end;

procedure TIconSelF.IptalBtnClick(Sender: TObject);
begin
     Cevap:=-1;
     Close;
end;

procedure TIconSelF.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          13:TamamBtnClick(nil);
          VK_INSERT:if ChangeOptions>=0 Then SimgeEkleBtnClick(nil);
          VK_DELETE:if ChangeOptions>=0 Then SimgeCikarBtnClick(nil);
     end;
end;

procedure TIconSelF.TamamBtnClick(Sender: TObject);
begin
     if ListView1.ItemIndex>=0 Then
     Begin
          Cevap:=ListView1.ItemIndex;
          Close;
     end Else
     ShowMessage('Bir simge seçiniz.'#13#10+
     'Eðer seçim yapmayý istemiyorsanýz Ýptal butonuna týklayýnýz.');
end;

end.
