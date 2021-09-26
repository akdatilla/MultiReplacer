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
 
unit DetailU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, shellapi,Menus,RepLib,MulRepMainU,RepConstU,
  RichEdit,RepThreadU,Masks,TntComCtrls;

type
  TDetailF = class(TForm)
    ContentRE: TRichEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ShellOpen1: TMenuItem;
    SaveAs1: TMenuItem;
    Print1: TMenuItem;
    Close1: TMenuItem;
    sd1: TSaveDialog;
    OD1: TOpenDialog;
    Edit1: TMenuItem;
    Next1: TMenuItem;
    PriorWord1: TMenuItem;
    FirstWord1: TMenuItem;
    LastWord1: TMenuItem;

    procedure SaveAs1Click(Sender: TObject);
    procedure ShellOpen1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Next1Click(Sender: TObject);
    procedure PriorWord1Click(Sender: TObject);
    procedure LastWord1Click(Sender: TObject);
    procedure FirstWord1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DtlFileName:ASCMRString;
    Wordindexes:TIndxArray;
    DetFormStyleSwc,ViewType{0:Normal,1:Hex}:integer;
    FileDataStr:TMemoryStream;
    FRepFrm:TForm;
    fArrASCFilecnt:TASCFileCntArr;
    unixrowlist:TList; //unix satýrlarý tek karakter msdos satýrlarý çift karakter olduðu için unix satýrlarý iþaretlenmeli
    TNTContentRE:TASCRichEdit;
    LastLineP,LastLineJP,lastlinej:integer;
    procedure HexLoad;
    procedure ASCII80Load;
    Procedure ASCIINormFillArea(ChangeColor:Boolean;Rch:TASCRichEdit;StrPos,StrLen,Color:Integer;var hfascstart:integer;Style:TFontStyles);
    function prepareviewer(p:PSrcFileRec;var indexes:TIndxArray;
    FViewType{0:Normal,1:Hex,2:ASCII 80Column}:integer):boolean;
    function ConvertASCRichEdit(Edt:TRichEdit):TASCRichEdit;
  end;

var
  DetailF: TDetailF;

implementation

uses RepMainU,RepFrmU,ProgressU;

{$R *.dfm}

CONST
     HexLineLen=80;
     ASC80LineLen=82;
var
   ASCCursor,ASCWidth:integer;
   FStreamSize : Longint;
   FProgBar : TProgressBar;
procedure DoProgBar(Value: Longint);
begin
     if Assigned(FProgBar) then
     begin
          FProgBar.Position := Round( (Value /FStreamSize) *100 );
          FProgBar.Update;
     end;
end;
// Callback function for EM_STREAMOUT
//
function EditStreamOut(dwCookie: Longint; pbBuff: PByte;
cb: Longint; var pcb: Longint): Longint; stdcall;
begin
     // This will write the contents of the RichEdit to a stream.
     // dwCookie is Application-defined, so we're passing the blob stream.
     pcb := TStream(dwCookie).Write(pbBuff^, cb);
     Result := 0;
end;

// Callback function for EM_STREAMIN
//

function EditStreamReader(dwCookie: DWORD; pBuff: Pointer;
  cb: LongInt; pcb: PLongInt): DWORD; stdcall;
begin
  Result := $0000;  // assume no error
  try
    pcb^ := TStream(dwCookie).Read(pBuff^, cb); // read data from stream
  except
    Result := $FFFF;  // indicates error to calling routine
  end;
end;
{
function EditStreamIn(dwCookie: Longint; pbBuff: PByte;
cb: Longint; var pcb: Longint): Longint; stdcall;
var
   theStream: TStream;
begin
     // This will write the contents of a stream to a RichEdit.
     // dwCookie is Application-defined, so we're passing the stream containing
     // the formatted text to be added.
     theStream := TStream(dwCookie);
     Result := 0;

     with theStream do
     begin
          if (Size - Position) <= cb then
          begin
               pcb := Size;
               Read(pbBuff^, Size);
          end
          else
          begin
               pcb := cb;
               Read(pbBuff^, cb);
          end;

          //progress bar...
          DoProgBar(pcb);
     end;
end;
}
procedure SaveRichText(RE: TASCRichEdit; Stream: TStream);
// Saves the (formatted) contents of the RichEdit to a stream.
var
   editStream: TEditStream;
   numChars: integer;
begin
     Stream.Size := 0;
     // Set up the edit stream.
     //
     editStream.dwCookie := longint(Stream);
     editStream.dwError := 0;
     editStream.pfnCallback := @EditStreamOut;

     // Send the EM_STREAMOUT message.
     //
     numChars := SendMessage(RE.Handle, EM_STREAMOUT,
     SF_RTF, longint(@editStream));
end;

procedure LoadRichText(RE: TASCRichEdit; Stream: TStream);
// Loads the (formatted) contents of the stream to the RichEdit.
var
   editStream: TEditStream;
   numChars: integer;
begin
     RE.Lines.BeginUpdate;
     RE.MaxLength := Stream.Size;

     Stream.Seek(0, soFromBeginning);

     // Set up the edit stream.
     //
     editStream.dwCookie := DWORD(Stream);
     editStream.dwError := 0;
     editStream.pfnCallback := @editStreamreader;// EditStreamIn;

     // Send the EM_STREAMIN message.
     //
     RE.Perform(
      EM_STREAMIN,
      SFF_SELECTION or SF_RTF or SFF_PLAINRTF, LPARAM(@EditStream)
    );

     //numChars := SendMessage(RE.Handle, EM_STREAMIN,
     //SF_RTF or SFF_SELECTION, longint(@editStream));
     // So long as SelLength is 0 this-^ causes the text to inserted at the
     // position of SelStart (should be at the end for appending):
     RE.Lines.EndUpdate;

end;

Procedure HexFillArea(ChangeColor:Boolean;Rch:TRichEdit;StrPos,StrLen,Color:Integer;var hfascstart:integer;Style:TFontStyles);
var
   j,LenLeft,line,col,colb,bline,bcol,HexStart,HexLen,ASCIIStart,ASCIILen:integer;
   s:ASCMRString;
begin
     LenLeft:=StrLen;
     line:=StrPos div 16;
     col:=StrPos mod 16;
     hfascstart:=-1;
     while LenLeft>0 do
     begin

          ASCIIStart:=Line*HexLineLen+62+Col;
          ASCCursor:=ASCIIStart;
          if hfascstart=-1 then hfascstart:=ASCIIStart;

          HexStart:=Line*HexLineLen+9+(Col*3)+((Col div 4))-1;
          if LenLeft+col>15 then
          begin
               colb:=16;
               HexLen:=(Line*HexLineLen+9+(Colb*3)+((Colb div 4)))-HexStart;
               ASCIILen:=colb-col;
          end  else
          begin
               colb:=col+LenLeft;
               HexLen:=(Line*HexLineLen+9+(Colb*3)+((Colb div 4)))-HexStart;
               ASCIILen:=colb-col;

          end;
          Rch.SelStart:=HexStart;
          Rch.SelLength:=HexLen-1;
          if ChangeColor then
          begin
               Rch.SelAttributes.Color:=Color;
               Rch.SelAttributes.Style:=Style;
          end;
          Rch.SelStart:=ASCIIStart;
          Rch.SelLength:=ASCIILen;
          ASCWidth:=ASCIILen;
          if ChangeColor then
          begin
               Rch.SelAttributes.Color:=Color;
               Rch.SelAttributes.Style:=Style;
          end;
          if LenLeft+col>15 then Dec(LenLeft,(16-col)) else lenleft:=0;
          inc(Line);
          Col:=0;
     end;
end;

Procedure TDetailF.ASCIINormFillArea(ChangeColor:Boolean;Rch:TASCRichEdit;StrPos,StrLen,Color:Integer;var hfascstart:integer;Style:TFontStyles);
var
   j,oldline:integer;
begin
     hfascstart:=strpos;
     for j := 0 to  unixrowlist.Count- 1 do
     begin
          if (integer(unixrowlist.Items[j])<strpos) then inc(hfascstart);
     end;
     {$IF (ASCUniCodeUsing=1)}
     (*
     if lastlinej=0 then
     begin
          {
          Rch.SelStart:=0;
          Rch.SelLength := Length(Rch.Lines.Text);
          }
          //lastlinej:=GetWordCountFPosLeft(rch.Lines.Text,#13#10,LastLineJP,hfascstart,LastLineP,lastlinej);
          ASCTntLastLine:=0;
          Rch.SelStart := hfascstart;//Rch.Perform(EM_LINEINDEX, (lastlinej+1), 0) + (hfascstart-LastLineP);
          Rch.SelStart:=ASCTntLastLine;//TntComCtrls altýnda;
          Rch.SelLength := Strlen;
     end else
     begin

          oldline:=lastlinej;
          lastlinej:=GetWordCountFPosLeft(rch.Lines.Text,#13#10,LastLineJP,hfascstart,LastLineP,lastlinej);
          Rch.SelStart := Rch.Perform(EM_LINEINDEX, lastlinej - oldline , 0) + (hfascstart-LastLineP)
          + (lastlinej - oldline); // adjusted for TntRichEdit wierdness
          Rch.SelLength := Strlen;

     end;

     //Rch.SelStart:=hfascstart ;
     ASCCursor:=hfascstart;
     //Rch.SelLength:=StrLen;
     ASCWidth:=StrLen;
     *)
     Rch.SelStart:=hfascstart ;
     ASCCursor:=hfascstart;
     Rch.SelLength:=StrLen;
     ASCWidth:=StrLen;

     {$ELSE}
     Rch.SelStart:=hfascstart ;
     ASCCursor:=hfascstart;
     Rch.SelLength:=StrLen;
     ASCWidth:=StrLen;
     {$IFEND}
     if ChangeColor then
     begin
          Rch.SelAttributes.Color:=Color;
          Rch.SelAttributes.Style:=Style;
     end;

end;
Procedure ASCII80FillArea(ChangeColor:Boolean;Rch:TRichEdit;StrPos,StrLen,Color:Integer;var hfascstart:integer;Style:TFontStyles);
var
   j,LenLeft,line,col,colb,bline,bcol,ASCIIStart,ASCIILen:integer;
   s:ASCMRString;
begin
     LenLeft:=StrLen;
     line:=StrPos div 80;
     col:=StrPos mod 80;
     hfascstart:=-1;
     while LenLeft>0 do
     begin

          ASCIIStart:=Line*ASC80LineLen+Col;
          ASCCursor:=ASCIIStart;
          if hfascstart=-1 then hfascstart:=ASCIIStart;
          if LenLeft+col>80 then
          begin
               colb:=80;
               ASCIILen:=colb-col;
          end  else
          begin
               colb:=col+LenLeft;
               ASCIILen:=colb-col;
          end;

          Rch.SelStart:=ASCIIStart;
          Rch.SelLength:=ASCIILen;
          ASCWidth:=ASCIILen;
          if ChangeColor then
          begin
               Rch.SelAttributes.Color:=Color;
               Rch.SelAttributes.Style:=Style;
          end;
          if LenLeft+col>80 then Dec(LenLeft,(80-col)) else lenleft:=0;
          inc(Line);
          Col:=0;
     end;
end;

procedure TDetailF.Close1Click(Sender: TObject);
begin
     Close;
end;

function TDetailF.ConvertASCRichEdit(Edt: TRichEdit): TASCRichEdit;
Var
   N:ASCMRString;
   v:ASCMRString;
   TabOrderNo:integer;
begin
     Result:=TASCRichEdit.Create(self);
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

procedure TDetailF.CreateParams(var Params: TCreateParams);
begin
     inherited;
     Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
     Params.WndParent := GetDesktopWindow;

end;

procedure TDetailF.FirstWord1Click(Sender: TObject);
var
   hfastart,j,l,p:integer;
begin
     l:=High(Wordindexes);
     p:=0;
     for j := 0 to l  do
     begin
          if Wordindexes[j].Start>=p then
          begin
               if ViewType=0 then
               begin
                    TNTContentRE.SelStart:=Wordindexes[j].ASCStart;
                    TNTContentRE.SelLength:=Wordindexes[j].ASCLen;
               end else
               begin
                    ContentRE.SelStart:=Wordindexes[j].ASCStart;
                    ContentRE.SelLength:=Wordindexes[j].ASCLen;
               end;
               keybd_event(VK_LEFT,0,0,0);
               keybd_event(VK_LEFT,0,KEYEVENTF_KEYUP,0);
               break;
          end;
     end;

end;

procedure TDetailF.FormCreate(Sender: TObject);
begin
     FileDataStr:=TMemoryStream.Create;
     unixrowlist:=TList.Create;
     ASCCursor:=0;
     ASCWidth:=0;
end;

procedure TDetailF.FormDestroy(Sender: TObject);
begin
     unixrowlist.Clear;
     unixrowlist.Free;
     unixrowlist:=nil;
     if FileDataStr<>nil then FileDataStr.Free;
     FileDataStr:=Nil;
end;

procedure TDetailF.LastWord1Click(Sender: TObject);
var
   hfastart,j,l,p,fnd:integer;
begin
     l:=High(Wordindexes);
     fnd:=-1;
     for j := 0 to l  do
     begin
               if fnd<0 then
               fnd:=j
               else
               begin
                    if Wordindexes[j].ASCStart>Wordindexes[fnd].ASCStart then
                    fnd:=j;
               end;
     end;
     if fnd>=0 then
     begin
          if ViewType=0 then
          begin
               TNTContentRE.SelStart:=Wordindexes[fnd].ASCStart;
               TNTContentRE.SelLength:=Wordindexes[fnd].ASCLen;
          end else
          begin
               ContentRE.SelStart:=Wordindexes[fnd].ASCStart;
               ContentRE.SelLength:=Wordindexes[fnd].ASCLen;
          end;

          keybd_event(VK_LEFT,0,0,0);
          keybd_event(VK_LEFT,0,KEYEVENTF_KEYUP,0);
     end;

end;

procedure TDetailF.HexLoad;
var
    strm:TMemoryStream;
    s2:String;//ASCMRString;
    buffer:Array [1..200] of Char;//ASCMRChar;
    buf:array [1..16] of Char;//ASCMRchar;
    Rslt,i,n:integer;
begin
  Rslt := 0;
  FileDataStr.Position:=0;
  n:=1;
  strm:=TMemoryStream.Create;
  while n>0 do
  begin
       s2:='';
       s2:=s2+Format(';%.5x  ',[FileDataStr.Position]);
       n:=FileDataStr.Read(buf,16);
       if n = 0 then break;
       for i := 1 to n do
         begin
           s2:=s2+IntToHex(ord(buf[i]),2)+' ';
           if i mod 4 = 0 then s2:=s2+' ';
         end;
       s2:=s2+StringOfChar(' ',62-length(s2));
       for i := 1 to n do
         begin
           if (buf[i] < #32) or (buf[i] > #126) then
             buf[i] := '.';
           s2:=s2+buf[i];
         end;
       s2:=s2+#13#10;
       for i := 1 to length(s2) do
       buffer[i]:=s2[i];
       strm.Write(buffer,length(s2));
       //if StreamPosition and $FFF = 0 then MainForm.Progress(StreamPosition);
  end;
  Rslt := strm.Size;
  strm.Position:=0;
  FStreamSize := strm.Size;
  ContentRE.Lines.LoadFromStream(strm);
  //LoadRichText(TNTContentRE,strm);
end;

procedure TDetailF.ASCII80Load;
var
    strm:TMemoryStream;
    s2:String;//ASCMRString;
    buffer:Array [1..200] of Char;//ASCMRChar;
    buf:array [1..90] of Char;//ASCMRChar;
    Rslt,i,n:integer;
begin
  Rslt := 0;
  FileDataStr.Position:=0;
  n:=1;
  strm:=TMemoryStream.Create;
  while n>0 do
  begin
       s2:='';
       //if (idata) > 127 then result:=false; binary olduðunu analar
       //AppendStr(s2,Format(';%.5x  ',[FileDataStr.Position]));
       n:=FileDataStr.Read(buf,80);
       for i := 1 to n do
         begin
           if (buf[i] < #32) or (buf[i] > #126) or (buf[i]='{') or (buf[i]='}') then
             buf[i] := '.';
           s2:=s2+buf[i];
         end;
       s2:=s2+#13#10;
       for i := 1 to length(s2) do
       buffer[i]:=s2[i];
       strm.Write(buffer,length(s2));
       //if StreamPosition and $FFF = 0 then MainForm.Progress(StreamPosition);
  end;
  Rslt := strm.Size;
  strm.Position:=0;
  FStreamSize := strm.Size;
  ContentRE.Lines.LoadFromStream(strm);
  //LoadRichText(TNTContentRE,strm);
end;

procedure TDetailF.Next1Click(Sender: TObject);
var
   j,l,p,hfastart:integer;
   fnd:Boolean;
begin
     l:=High(Wordindexes);

     if ViewType=0 then
          p:=TNTContentRE.SelStart
     else
          p:=ContentRE.SelStart;
     fnd:=false;
     for j := 0 to l  do
     begin
          if Wordindexes[j].ASCStart>p then
          begin
               if ViewType=0 then
               begin
                    TNTContentRE.SelStart:=Wordindexes[j].ASCStart;
                    TNTContentRE.SelLength:=Wordindexes[j].ASCLen;
               end else
               begin
                    ContentRE.SelStart:=Wordindexes[j].ASCStart;
                    ContentRE.SelLength:=Wordindexes[j].ASCLen;
               end;
               fnd:=True;
               break;
          end;

     end;
     if fnd then
     begin
     keybd_event(VK_LEFT,0,0,0);
     keybd_event(VK_LEFT,0,KEYEVENTF_KEYUP,0);
     {
     keybd_event(VK_RIGHT,0,0,0);
     keybd_event(VK_RIGHT,0,KEYEVENTF_KEYUP,0);
     }
     end;
end;

function TDetailF.prepareviewer(
  p: PSrcFileRec; var indexes: TIndxArray;
  FViewType: integer):boolean;
label
     gofinish;
Var
   fcur, //file cursor
   flen,//file length
   j,k,wstyle,
   idxlen,   ///bulunan kelimelerin indexleri alýnacak. bunun için kayit no sayacý
   WRowCount,
   ghstrt
   :integer;
   sfpth:ASCMRString;
   srclf:File of TASCSearchRec;
   sr:TASCSearchRec;
   PrcsF:TProgressF;
   vPrcs:Boolean;
   newprcpos:int64;
   buf:Array [1..16] of char;
   n,bi:integer;
   wbuf:Char;
   function getfirstword:TASCSearchRec;
   var
      gfwj:integer;
      gfwk,
      gfp, //bulunan en yakýn kelimenin pozisyonu
      igfwj //bulunan en yakýn kelimenin gfwj si
      :int64;

   begin
        Result.p:=0;
        Result.l:=0;
        gfp:=0;
        igfwj:=0;
        for gfwj:=0 to high(fArrASCFilecnt) do
        Begin
             if (fArrASCFilecnt[gfwj].p<=high(fArrASCFilecnt[gfwj].sr)) then
             begin
                  if (
                        (fArrASCFilecnt[gfwj].sr[fArrASCFilecnt[gfwj].p].p>fcur) and
                        (fArrASCFilecnt[gfwj].sr[fArrASCFilecnt[gfwj].p].p<gfp)
                     ) or (gfp=0) then
                  Begin
                       wstyle:=gfwj;
                       gfp:=fArrASCFilecnt[gfwj].sr[fArrASCFilecnt[gfwj].p].p;
                       igfwj:=gfwj;
                  end;
             end;
        end;


        if gfp>0 then
        begin
             Result.l:=fArrASCFilecnt[igfwj].sr[fArrASCFilecnt[igfwj].p].l;
             Result.p:=gfp;
             fArrASCFilecnt[igfwj].p:=fArrASCFilecnt[igfwj].p+1;
             wstyle:=igfwj;
        end;

   end;
   procedure AddText(Txt:ASCMRString;StyleId:integer);
   Begin
        {$IF DetailObject=1}
        ContentRE.AddText(Txt,StyleId);
        {$ELSE}
        if FViewType=0 then
        begin
             TNTContentRE.DefAttributes.Color:=RepMainF.RVStyle1.TextStyles.Items[StyleId].Color;
             TNTContentRE.DefAttributes.Style:=RepMainF.RVStyle1.TextStyles.Items[StyleId].Style;
             TNTContentRE.Lines.Text:=TNTContentRE.Lines.Text+Txt;
        end else
        begin
             ContentRE.DefAttributes.Color:=RepMainF.RVStyle1.TextStyles.Items[StyleId].Color;
             ContentRE.DefAttributes.Style:=RepMainF.RVStyle1.TextStyles.Items[StyleId].Style;
             ContentRE.Lines.Text:=ContentRE.Lines.Text+Txt;
        end;
        {$IFEND}
   end;
begin
     {$IF (ASCUniCodeUsing=1)}
     ASCTntLastLine:=0;
     {$IFEND}
     result:=false;
     vPrcs:=False;
     ViewType:=FViewType;
     if FViewType=0 then
     begin
          TNTContentRE.Visible:=False;
          TNTContentRE.Clear;
     end else
     begin
          ContentRE.Visible:=False;
          ContentRE.Clear;
     end;
     if p=nil then exit;
     fcur:=0;
     flen:=FileDataStr.Size;
     wbuf:='.';
     if flen>0 then
        FileDataStr.Position:=0;
     if flen>99000 then
     begin
                 PrcsF:=TProgressF.Create(nil);
                 PrcsF.Caption:='Processing....';
                 PrcsF.Show;
                 PrcsF.PB1.Max:=100;
                 FProgBar:=PrcsF.PB1;
                 vPrcs:=True;
     end else FProgBar:=nil;
     if FViewType=ascVTNormal then
     begin
          n:=0;
          bi:=1;
          if flen>0 then
          for k := 1 to flen do
          begin
               if n=0 then
               begin
                    FileDataStr.Position:=k-1;
                    n:=FileDataStr.Read(buf,16);
                    if n=0 then
                       break;
                    bi:=1;
               end;
               if bi>0 then
               case buf[bi] of
                    #0..#8,#11,#12,#14..#31:
                    begin
                         FileDataStr.Position:=k;
                         FileDataStr.Write(wbuf,1);
                    end;
                    //#170..#255:FileDataStr[k]:='_';
               end;
               inc(bi);
               if bi>n then
                  n:=0;
          end;
          k:=pos('{\rtf',lowercase(copy(buf,1,n)));
          if k=1 then
          begin
               FileDataStr.Position:=0;
               for j := 1 to 5 do
                 buf[j]:='.';
               FileDataStr.Write(buf,5);
          end;

     end;
     {$IF DetailObject=2}
     Case FViewType of
          ascVTHex:HexLoad;
          ascVTASC80:ASCII80Load;
          else
          begin
               FileDataStr.Position:=0;
               FStreamSize := FileDataStr.Size;
               TNTContentRE.Lines.LoadFromStream(FileDataStr);
               //LoadRichText(TNTContentRE,FileDataStr);
          end;
     end;
     {$IFEND}
     if vprcs then
     begin
          PrcsF.PB1.Position:=60;
     end;
     idxlen:=0;
     while fcur<=flen do
     begin
          wstyle:=1;
          sr:=getfirstword;
          if fcur=0 then
          fcur:=1;
          {$IF DetailObject=2}
          if sr.p>0 then//en yakýn kelimeyi bul
          begin
               inc(idxlen);
               SetLength(indexes,idxlen);

               Case FViewType of
                    ascVTHex:
                    begin
                         HexFillArea(true,ContentRE,sr.p-1,sr.L,RepMainF.RVStyle1.TextStyles.Items[(wstyle mod maxstyle)+1].Color,
                         ghstrt,RepMainF.RVStyle1.TextStyles.Items[(wstyle mod maxstyle)+1].Style);
                         indexes[idxlen-1].Start:=sr.p-1;
                         indexes[idxlen-1].ASCStart:= ASCCursor;
                         indexes[idxlen-1].ASCLen:= ASCWidth;
                         indexes[idxlen-1].Len:=1;//sr.L;
                    end;
                    ascVTASC80:
                    begin
                         ASCII80FillArea(true,ContentRE,sr.p-1,sr.L,RepMainF.RVStyle1.TextStyles.Items[(wstyle mod maxstyle)+1].Color,
                         ghstrt,RepMainF.RVStyle1.TextStyles.Items[(wstyle mod maxstyle)+1].Style);
                         indexes[idxlen-1].Start:=sr.p-1;
                         indexes[idxlen-1].ASCStart:= ASCCursor;
                         indexes[idxlen-1].ASCLen:= ASCWidth;
                         indexes[idxlen-1].Len:=1;//sr.L;
                    end;
                    else
                    begin
                         ASCIINormFillArea(true,TNTContentRE,sr.p-1,sr.L,RepMainF.RVStyle1.TextStyles.Items[(wstyle mod maxstyle)+1].Color,
                         ghstrt,RepMainF.RVStyle1.TextStyles.Items[(wstyle mod maxstyle)+1].Style);

                         indexes[idxlen-1].Start:=sr.p-1;
                         indexes[idxlen-1].ASCStart:= ASCCursor;
                         indexes[idxlen-1].ASCLen:=ASCWidth;
                         indexes[idxlen-1].Len:=1;
                    end;
               end;
               fcur:=sr.p+1;//sr.l;
          end else
          Begin
               break;
          end;
          {$ELSE}
          if sr.p>0 then//en yakýn kelimeyi bul
          begin
               if sr.p>fcur then
                  AddText(copy(FileDataStr,fcur,sr.p-fcur),0);
               ////////////////asagida index bilgisi yaziliyor
               inc(idxlen);
               SetLength(indexes,idxlen);
               indexes[idxlen-1].Len:=sr.L;
               indexes[idxlen-1]:=sr.p-1;
               ///////////////////////////
               AddText(copy(FileDataStr,sr.p,sr.l),(wstyle mod maxstyle)+1);
               fcur:=sr.p+sr.l;
               if sr.p>fcur then
                  AddText(copy(FileDataStr,fcur,sr.p-fcur),0);

               AddText(copy(FileDataStr,sr.p,sr.l),(wstyle mod maxstyle)+1);
               fcur:=sr.p+sr.l;
          end else
          Begin
               if fcur+1<flen then
                  AddText(copy(FileDataStr,fcur,flen-fcur+1),0);
               break;
          end;
          {$IFEND}

          if vprcs then
          begin
               newprcpos:=round((fcur/flen)*40);
               if PrcsF.PB1.Position+2<newprcpos then
               begin
                    PrcsF.PB1.Position:=60+newprcpos;
                    Application.ProcessMessages;
                    if PrcsF.fCancelled then
                    begin
                         result:=False;
                         goto goFinish;
                    end;

               end;
          end;

     end;
     {$IF DetailObject=1}
     ContentRE.Format;
     {$IFEND}
     if FViewType=0 then
     TNTContentRE.Visible:=True
     else
     ContentRE.Visible:=True;
     Result:=true;
     gofinish:
     if vPrcs then
     begin
          if Assigned(PrcsF) then
          begin
               PrcsF.Free;
               PrcsF:=Nil;
          end;
     end;
end;

procedure TDetailF.Print1Click(Sender: TObject);
begin
     if ViewType=0 then
     TNTContentRE.Print(Caption)
     else
     ContentRE.Print(Caption);
end;

procedure TDetailF.PriorWord1Click(Sender: TObject);
var
   j,l,p,hfastart,fnd,linej:integer;
begin
     l:=High(Wordindexes);
     if ViewType=0 then
     p:=TNTContentRE.SelStart
     else
     p:=ContentRE.SelStart;
     fnd:=-1;
     for j := 0 to l  do
     begin
          if Wordindexes[j].ASCStart<p then
          begin
               if fnd<0 then
               fnd:=j
               else
               begin
                    if p-Wordindexes[j].ASCStart<p-Wordindexes[fnd].ASCStart then
                    fnd:=j;
               end;
          end;
     end;
     if fnd>=0 then
     begin
          if ViewType=0 then
          begin
               TNTContentRE.SelStart:=Wordindexes[fnd].ASCStart;
               TNTContentRE.SelLength:=Wordindexes[fnd].ASCLen;
          end else
          begin
               ContentRE.SelStart:=Wordindexes[fnd].ASCStart;
               ContentRE.SelLength:=Wordindexes[fnd].ASCLen;
          end;
          keybd_event(VK_LEFT,0,0,0);
          keybd_event(VK_LEFT,0,KEYEVENTF_KEYUP,0);
     end;
end;

procedure TDetailF.SaveAs1Click(Sender: TObject);
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
          if ViewType=0 then
          begin
               if Pos('RTF',uppercase(ExtractFileExt(sd1.FileName)))<1 then
               TNTContentRE.PlainText:=True
               else
               TNTContentRE.PlainText:=False;

               TNTContentRE.Lines.SaveToFile(sd1.FileName);
          end else
          begin
               if Pos('RTF',uppercase(ExtractFileExt(sd1.FileName)))<1 then
               ContentRE.PlainText:=True
               else
               ContentRE.PlainText:=False;

               ContentRE.Lines.SaveToFile(sd1.FileName);
          end;
     end;
end;

procedure TDetailF.ShellOpen1Click(Sender: TObject);
var
   msj:String;
   f,msk,s:string;
begin
     msj:='';

     f:=DtlFileName;
     s:=appdefaultsrec.WarmBeforeOpenPtr;
     while s<>'' do
     begin
          msk:=CutcsvData(s);
          if trim(msk)='' then Continue;

          if MatchesMask(f,msk) then
             msj:=ReplaceText(msgDosyaAcmaUyarisi,'$dosyaadi',f);
     end;
     if msj<>'' then
        if MessageDlg(msj,mtWarning,[mbYes,mbNo],0,mbNo)<>mrYes then exit;
     ShellExecute( 0, nil, PChar( f ),
                 Nil, Nil, SW_NORMAL );
     {
     if OD1.Execute then
     begin
          TNTContentRE.Lines.LoadFromFile(od1.FileName);
     end;
     }
end;

end.
