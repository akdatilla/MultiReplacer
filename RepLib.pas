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
 
unit RepLib;

interface
uses windows,Messages, Classes,SysUtils,Variants, Graphics,Controls, Forms,
Math,ClipBrd,shellapi,masks,StrUtils,RepConstU
  {$IF (ASCUniCodeUsing=1)},TNTWindows,TNTSysUtils,TNTClasses
{$IFEND};
Type
  rsTypes=(rsOk,rsYes,rsNo,rsCancel,rsAllYes,rsAllNo,rsNew,rsChange);
  msTypes=(msOk,msOkCancel,msYesNo,msYNC,msAllYNC,msNewChange);
  TPagePos=Record
      StartFileIdx,StartLine,FinishFileIdx,FinishLine:integer;
  end;
  TASCMatchListPager=Record
      PageCount,FirstPage,LastPage:integer;
      PagePositions:Array of TPagePos;
  end;
  TASCSearchRec=Record
       P,L:integer;
  end;
  TASCMatchSearchRec=Record
       W,P,L:integer;
  end;
  PSrcFileSelRec=^TSrcFileSelRec;
  TSrcFileSelRec=Record
      Src,Dest,ifileptr,exfileptr: ASCMRString;
      FileOrDir,subfiles:Char;
      srMinFileSize,srMaxFileSize:int64;
      srDateOption:integer;  {0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom}
      srMinDate,srMaxDate:Double;
      FileNameOperation:Boolean; //true ise arama deðiþtirme iþlemi dosya adýnda yapýlýr
  end;
  TASCFileCnt=Record
      p:integer;//ilk deðeri 0 kullanýldýkca p artacak
      sr:Array of TASCSearchRec;
  end;
  TASCFileCntArr=Array of TASCFileCnt;
  PSrcFileRec=^TSrcFileRec;
  TSrcFileRec=Record
      OrjFileName,ProcessFile,Destination:String[250];
      FileType:String[80];
      shortname:string[40];
      FileSize:int64;
      iconindex,MatchCount,MatchLineCount,fileindex:integer;
      ModifyDate:Double;
      Removed,   //eðer listeden çýkarýldýysa true
      TxtConverted,
      FileNameOperation
      :Boolean;
  end;
  PWordObj=^TWordObj;
  TWordObj=Record
    SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
    CaseSwc,RegEx,WordsOnly,
    MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
    uMatchReq {Ýçermeyen(Bütün dosyalar için)},
    SearchOnly{(for replace projects)},
    StopAfterFMatchThisFile, //bulduðunda o dosya içinde baþka arama yapma
    StopAfterFMatchAll,  //bulunduðunda aramayý tamamen durdur
    KeepCase, //Kucuk buyuk harf ozelliðini koru
    SearchStarter,
    SearchStopper
    :boolean;
    areainfo,start1,start2,stop1,stop2:integer;
    GroupNumber:integer;
    csvchar:ASCMRString;
  end;

  TRegisterHeader=Record
    ProgName:ASCMRString;
    Ver:ASCMRString;
    RegDate:Double;
    UserName,SerialNo:ASCMRString;
    UserNamePass,PasswordPass,SerialNoPass1,SerialNoPass2:ASCMRString;
    HddSerial,HddPass:ASCMRString;
    RegistrationName:ASCMRString;//Kisi Adý/Firma
    RegKey1,RegKey2,Options:ASCMRString; //ozel program anahtarý
    ComputerVal:ASCMRString;
    UserCount,
    WndNo,MacNo
    :ASCMRString;

  End;
  TIndxArray=Array of Record Start,ASCStart,ASCLen,Len:integer;end;
     //Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq,
     //Ýçermeyen(Bütün dosyalar için)uMatchReq,Search Only(for replace projects),7:Stop after first matched

     //areainfo:bilgi arama konum seçenekleri 0:normal,1:dosya baþýndan itibaren baþlangýç start1,
     //karakter sayýsý stop1;2:Satýr numarasý olarak start1 ve stop 1;3:sutun olarak start1,uzunluk stop1;
     //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
     //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
     //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
     //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
     //,start1,start2,stop1,stop2


  TExecType=(ext_NewSearch,ext_ReadingFile,ext_SearchInFile,ext_FoundFile,ext_ErrFile,
  ext_QueueStopping,ext_Normally,ext_WordFileToText,ext_ExcelFileToText,ext_pdftotext,ext_pdftotextr{pdf calisti});
Const
     SELDIRHELP=1000;
     maxstyle=8;

     DetailObject=2;//1:RichView;2:RichEdit
     asfDate='GGAAYYYY';
     asfTime='SADASN';
     asfDateTime='GGAAYYYYSADASN';
     asfShortDate='GGAAYY';
     asfMonthYear='AAYYYY';
     asfShMonthYear='AAYY';
     asfMinSec='DASN';
     asfHourMin='SADA';
     asfDayMonth='GGAA';
     asfMonth='AA';
     asfF='N';
     asfI='I';
     asfCur='C';
     asfDay='GG';
     asfYY='YY';
     asfYYYY='YYYY';
     asfMSec='SL';
     asfS='S';
     asfHour='SA';
     asfMin='DA';
     asfSec='SN';
     asfR='R';

     DateSep:Char='.';
     CursorChr:Char='|';

     FracDigitCount=3;


     StrSafe:Array [0..255] of String=(
     '#00','#01','#02','#03','#04','#05','#06','#07','#08','#09','#10','#11','#12','#13',
     '#14','#15','#16','#17','#18','#19','#20','#21','#22','#23','#24','#25',
     '#26','#27','#28','#29','#30','#31',#32,'#33','#34','#35','#36','#37','#38','#39',
     '#40','#41','#42','#43','#44','#45','#46','#47',#48,#49,#50,#51,#52,#53,#54,
     #55,#56,#57,'#58',
     '#59','#60','#61','#62','#63','#64',#65,#66,#67,#68,#69,#70,#71,#72,#73,#74,
     #75,#76,#77,#78,#79,#80,#81,#82,#83,#84,#85,#86,#87,#88,#89,#90,'#91','#92','#93',
     '#94','#95','#96',#97,#98,#99,#100,#101,#102,#103,#104,#105,#106,#107,#108,#109,
     #110,#111,#112,#113,#114,#115,#116,#117,#118,#119,#120,#121,#122,
     '#65',  '#66' ,'#67', '#68',  '#69',
     //#123, #124,  #125,  #126,   #127,

     #128,#129,#130,#131,#132,#133,#134,#135,#136,#137,#138,#139,
     #140,#141,#142,#143,#144,#145,#146,#147,#148,#149,#150,#151,#152,#153,#154,
     #155,#156,#157,#158,#159,#160,#161,#162,#163,#164,#165,#166,#167,#168,#169,
     #170,#171,#172,#173,#174,#175,#176,#177,#178,#179,#180,#181,#182,#183,#184,
     #185,#186,#187,#188,#189,#190,#191,#192,#193,#194,#195,#196,#197,#198,#199,
     #200,#201,#202,#203,#204,#205,#206,#207,#208,#209,#210,#211,#212,#213,#214,
     #215,#216,#217,#218,#219,#220,#221,#222,#223,#224,#225,#226,#227,#228,#229,
     #230,#231,#232,#233,#234,#235,#236,#237,#238,#239,#240,#241,#242,#243,#244,
     #245,#246,#247,#248,#249,#250,#251,#252,#253,#254,
     '#99'//#255
     );

Function CutcsvData(Var s:String):String;
Function CutcsvDataASCMR(Var s:ASCMRString):ASCMRString;
Function csvData(s:String;Col:Integer):String;
Function xsvData(s:String;x:Char;K:Integer):String;
Function xsvDataASCMR(s:ASCMRString;x:ASCMRChar;K:Integer):ASCMRString;
function csvPrepareColumn(s:String):String;
function csvPrepareColumnASCMR(s:ASCMRString):ASCmrString;
function csvRePrepareColumn(s:String):String;
function csvRePrepareColumnASCMR(s:ASCmrString):ASCmrString;
function TimeToSecond(v:Extended):integer;
Function TextToDbl(sval,Format:String):Extended;
Function TextToInt(T:String):Integer;
Function DblToText(P:Extended;Format:String):String;
Function NumericText(Text:String;V,isaret:Boolean):String;
Function NumericTextC(Text:String;V,isaret:Boolean):String;
Function NumGetValidStr(S:String):String;
Function ReplaceText(s:String;f,r:String):String;
Function ReplaceText_MR(s:ASCMRString;f,r:ASCMRString):ASCmrString;
Procedure ReplaceTextP(Var s:String;F,R:String);
Procedure ReplaceTextP_MR(Var s:ASCMRString;F,R:ASCMRString);
Function SetStrLength(s:String;Ch:Char;Boyut,Yon:Integer):String;
Function SetStrLengthP(var s:String;Ch:Char;Boyut,Yon:Integer):boolean;
Function SetMRStrLengthP(var s:ASCMRString;Ch:ASCMRChar;Boyut,Yon:Integer):boolean;
function MonthDayCount(y,m:integer):integer;
Function PrmListGetVal(L:TStringList;P,PrmSep:String):String;
procedure WriteText(Cnvs: TCanvas; const Str: ASCMRstring; Rct: TRect; P_X, P_Y: Integer;
  Alignment: TAlignment;WordWrap:Boolean;FC,BC:TColor);
function GetDirectory(d:String):String;
procedure GetClipBrdFiles(Var DsList:TStringList);
Procedure GetFileList(SrList:TStringList;Var DsList:TStringList;Var TotalSize:Int64;Mask:String;SubDirSwc:Boolean);
function GetSizeDescription(const IntSize : Int64) : String;
function GetFileModifyDate(const fn: string;Var ModifyDate:Double):Boolean;
function GetModifyDateFromFD(FindData : TWin32FindData):Double;
function  DSiGetFileTimes(const fileName: string; var creationTime, lastAccessTime,
  lastModificationTime: TDateTime): boolean;
function  DSiGetModifyDate(const fileName: string; var lastModificationTime: TDateTime): boolean;
function GetDirName(s:string):String;
function GetWordCountFromLeft(const sv,w:ascmrstring;P:integer;var linep:integer):integer;
function GetWordCountFPosLeft(const sv,w:ascmrstring;fp,P:integer;var linep:integer;LC:integer):integer;
function GetLineFromPos(const sv:string;P:integer;Var PFirst,PLast:integer):String;
function GetLineFromPosASCMR(const sv:ASCMRString;P:integer;Var PFirst,PLast:integer):ASCMRString;

function GetLinePos(const sv:ASCMRstring;startline,stopline:integer):TPoint;
function GetNextLinePos(const sv:ascmrstring;startpos:integer):TPoint;
Function GetxsvPos(s:String;x:Char;K:Integer):TPoint;
Function GetxsvPosB(s:String;x:Char;K,vfrom,vto:Integer):TPoint;
Function GetxsvPosB_MR(s:ASCMRString;x:ASCMRChar;K,vfrom,vto:Integer):TPoint;
function GetFileSize(fn:string):int64;
function FileSizeCheck(fn:string;Min,Max:int64):Boolean;
function Mince(PathToMince :String; InSpace :Integer): String;
Function TextFilter(F,Src:String):String; //F:Filitre,Src:Kaynak; Src içinde filtre karakterlerini siler
Function TextFilterB(F,Src:String):String; //F:Filitre,Src:Kaynak; Src içinde filtre karakterleri dýþýndakileri siler
Function BoolToStrYN(c:Boolean):String;
function StrYNToBool(s:String):Boolean;
procedure ExtractFileItems(fn:ASCMRString;Var fname,fnnoex,fex,fdir:ASCMRString);
function ascdatestr(d:Double):String;
procedure Shuffle(var aArray; aItemCount: Integer; aItemSize: Integer) ;
{$IF (ASCUniCodeUsing=1)}
function LoadUnicode(f:string;b:boolean=true):widestring;
Procedure LoadUnicodeFile( const filename: String; strings: TTNTStrings );
{$IFEND}
function ASCMRPosEx(c,s:ascmrstring;ofset:integer):integer;
function ASCMRPosExB(s:ascmrstring;ofset:integer):integer;
Function DeleteInvChars(s,dc:String):String;
function hexdatatostr(s:string):String;
Function dec2tohex(s:String):String;
function csvMatchesMask(data,csvMask:String):Boolean;
implementation
uses dateutils;
var
  DrwBMP: TBitmap;


function csvMatchesMask(data,csvMask:String):Boolean;
var
   s,msk:String;
begin
     result:=false;
     s:=csvMask;
     while s<>'' do
     begin
          msk:=CutcsvData(s);
          if trim(msk)='' then Continue;

          if MatchesMask(data,msk) then
          begin
               result:=true;
               exit;
          end;
     end;

end;
procedure WriteText(Cnvs: TCanvas; const Str: ASCMRString; Rct: TRect; P_X, P_Y: Integer;
  Alignment: TAlignment;WordWrap:Boolean;FC,BC:TColor);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT {or DT_WORDBREAK }or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT {or DT_WORDBREAK} or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER {or DT_WORDBREAK} or DT_EXPANDTABS or DT_NOPREFIX );
  RTL: array [Boolean] of Integer = (0, DT_RTLREADING);
var
  B, R: TRect;
  Hold, Left: Integer;
  I: TColorRef;
  AF:integer;
begin
     AF:=AlignFlags[Alignment];
     if WordWrap then AF:=AF or DT_WORDBREAK;
     I := ColorToRGB(Cnvs.Brush.Color);
    DrwBMP.Canvas.Lock;
    try
      with DrwBMP, Rct do { Use offscreen bitmap to eliminate flicker and }
      begin                     { brush origin tics in painting / scrolling.    }
        Width := Max(Width, Right - Left);
        Height := Max(Height, Bottom - Top);
        R := Rect(P_X, P_Y, Right - Left - 1, Bottom - Top - 1);
        B := Rect(0, 0, Right - Left, Bottom - Top);

      end;
      with DrwBMP.Canvas do
      begin
        Font := Cnvs.Font;
        Font.Color := FC;
        Brush := Cnvs.Brush;
        Brush.Style := bsSolid;
        Brush.Color:=BC;
        FillRect(B);
        SetBkMode(Handle, TRANSPARENT);
        {$IF (ASCUniCodeUsing=1)}
        Tnt_DrawTextW(Handle, PWideChar(Str), Length(Str), R,
          AlignFlags[Alignment] or RTL[false{ARightToLeft}]);
        {$ELSE}
        DrawText(Handle, PChar(Str), Length(Str), R,AF);
        {$IFEND}


      end;
      if (Cnvs.CanvasOrientation = coRightToLeft) then
      begin
        Hold := Rct.Left;
        Rct.Left := Rct.Right;
        Rct.Right := Hold;
      end;
      Cnvs.CopyRect(Rct, DrwBMP.Canvas, B);
    finally
      DrwBMP.Canvas.Unlock;
    end;

end;

Function PrmListGetVal(L:TStringList;P,PrmSep:String):String;
Var
   ss,sp,s:String;
   j,i:Integer;
Begin
     ss:='';
     if L<>Nil Then
          if L.Count>0 Then
               For j:=0 To L.Count-1 Do
               Begin
                    s:=L.Strings[j];
                    sp:='';
                    i:=Pos(PrmSep,s);
                    if i>1 Then sp:=Copy(s,1,i-1);
                    if sp=P Then
                    Begin
                         if (i<Length(s)) and (i>1) Then ss:=Copy(s,i+1,Length(s)-i);
                         Break;
                    End;
               End;
     Result:=ss;
End;

Function CutcsvData(Var s:String):String;
Var
   j:Integer;
Begin
     j:=Pos(';',s);
     if j>0 Then
     Begin
          Result:=Copy(s,1,j-1);
          Delete(s,1,j);
     End else
     Begin
          Result:=s;
          s:='';
     End;
End;
Function CutcsvDataASCMR(Var s:ASCMRString):ASCMRString;
Var
   j:Integer;
Begin
     j:=Pos(';',s);
     if j>0 Then
     Begin
          Result:=Copy(s,1,j-1);
          Delete(s,1,j);
     End else
     Begin
          Result:=s;
          s:='';
     End;
End;
Function csvData(s:String;Col:Integer):String;
Var
   sv:String;
   j,i:Integer;
Begin
     Result:='';
     sv:='';
     i:=1;
     if s='' Then Exit;
     For j:=1 to Length(s) do
     Begin
          if s[j]=';' Then
          Begin
               if i>=Col Then break;
               i:=i+1;
          End Else
          Begin
               if i=Col Then sv:=sv+s[j];
          End;
     End;
     Result:=sv;
End;
Function xsvData(s:String;x:Char;K:Integer):String;
Var
   sv:String;
   j,i:Integer;
Begin
     Result:='';
     sv:='';
     i:=1;
     if s='' Then Exit;
     For j:=1 to Length(s) do
     Begin
          if s[j]=x Then
          Begin
               if i>=k Then break;
               i:=i+1;
          End Else
          Begin
               if i=k Then sv:=sv+s[j];
          End;
     End;
     Result:=sv;
End;
Function xsvDataASCMR(s:ASCMRString;x:ASCMRChar;K:Integer):ASCMRString;
Var
   sv:ASCMRString;
   j,i:Integer;
Begin
     Result:='';
     sv:='';
     i:=1;
     if s='' Then Exit;
     For j:=1 to Length(s) do
     Begin
          if s[j]=x Then
          Begin
               if i>=k Then break;
               i:=i+1;
          End Else
          Begin
               if i=k Then sv:=sv+s[j];
          End;
     End;
     Result:=sv;
End;

function TimeToSecond(v:Extended):integer;
Var
   h,m,s,ms:word;
Begin
     DecodeTime(v,h,m,s,ms);
     Result:=h*3600+60*m+s;
end;
function MonthDayCount(y,m:integer):integer;  
Begin  
     case m of  
          1,3,5,7,8,10,12:result:=31;  
          2:  
          Begin  
               if ((y mod 4)=0) then result:=29 else result:=28;  
          end;  
          else result:=30;  
     end;  
end;
Function ReplaceText(s:String;f,r:String):String;
Begin
     Result:=StringReplace(s,f,r,[rfReplaceAll]);
End;
Function ReplaceText_MR(s:ASCMRString;f,r:ASCMRString):ASCmrString;
begin
  {$IF (ASCUniCodeUsing=1)}
     Result:=Tnt_WideStringReplace(s,f,r,[rfReplaceAll]);
  {$ELSE}
     Result:=StringReplace(s,f,r,[rfReplaceAll]);
  {$IFEND}
end;
Procedure ReplaceTextP(Var s:String;F,R:String);
Begin
     s:=StringReplace(s,f,r,[rfReplaceAll])
End;
Procedure ReplaceTextP_MR(Var s:ASCMRString;F,R:ASCMRString);
Begin
  {$IF (ASCUniCodeUsing=1)}
     s:=Tnt_WideStringReplace(s,f,r,[rfReplaceAll]);
  {$ELSE}
     s:=StringReplace(s,f,r,[rfReplaceAll]);
  {$IFEND}
End;
Function NumericTextC(Text:String;V,Isaret:Boolean):String;
Var
   s:String;
   j:Integer;
   vy,udt:Boolean;
Begin
     s:='';
     vy:=True;
     if Length(Text)>0 Then
     Begin
          udt:=Pos('__',Text)=1;
          if not udt Then
          if (Text[1]='-') and isaret Then s:=s+'-';
          For j:=1 To Length(Text) do
          Begin
               if udt and (Text[j]='-') then s:=s+'0'
               Else
               if Text[j] in ['0'..'9'] Then s:=s+Text[j];
               if v Then
               if (Text[j] in [',']) and vy Then
               Begin
                    s:=s+Text[j];
                    vy:=False;
               End;
          End;
     End;
     if s='' Then s:='0';
     Result:=s;
End;

Function NumericText(Text:String;V,Isaret:Boolean):String;
Var
   s:String;
   j:Integer;
   vy,udt:Boolean;
Begin
     s:='';
     vy:=True;
     udt:=Pos('__',Text)=1;
     if Length(Text)>0 Then
     Begin
          if (Text[1]='-') and isaret and (not udt) Then s:=s+'-';
          For j:=1 To Length(Text) do
          Begin
               if Text[j] in ['0'..'9'] Then s:=s+Text[j];
               if v Then
               if (Text[j] in [',']) and vy Then
               Begin
                    s:=s+Text[j];
                    vy:=False;
               End;
          End;
     End;
     if s='' Then s:='0';
     Result:=s;
End;
Function NumGetValidStr(S:String):String;
Var
   s2:String;
   j:Integer;
Begin
     s2:=s;
     If Length(s2)>0 Then
     For j:=Length(s2) downto 1 do
     Begin
          Case s2[j] of
               '0':Delete(s2,j,1);
               ',':Begin
                        Delete(s2,j,1);
                        Break;
               End;
               '1'..'9':
                   Break;
          End;
     End;
     Result:=S2;
End;
Function SetStrLengthP(var s:String;Ch:Char;Boyut,Yon:Integer):boolean;
Var
   j,k:Integer;
Begin
     Result:=True;
     if Boyut=0 Then
     Begin
          Exit;
     End;
     if Length(s)>Boyut Then
     Begin
          if Yon=1 Then Setlength(s,Boyut) Else Delete(s,1,Length(s)-Boyut);
     End
     Else
     Begin
          k:=Length(s);
          if k<Boyut Then
          Begin
               if Yon=1 Then For j:=1 to Boyut-k do s:=s+ch
               Else
               For j:=1 to Boyut-k do Insert(Ch,s,1);
          End;
     End;
End;

Function SetMRStrLengthP(var s:ASCMRString;Ch:ASCMRChar;Boyut,Yon:Integer):boolean;
Var
   j,k:Integer;
Begin
     Result:=True;
     if Boyut=0 Then
     Begin
          Exit;
     End;
     if Length(s)>Boyut Then
     Begin
          if Yon=1 Then Setlength(s,Boyut) Else Delete(s,1,Length(s)-Boyut);
     End
     Else
     Begin
          k:=Length(s);
          if k<Boyut Then
          Begin
               if Yon=1 Then For j:=1 to Boyut-k do s:=s+ch
               Else
               For j:=1 to Boyut-k do Insert(Ch,s,1);
          End;
     End;
End;

Function SetStrLength(s:String;Ch:Char;Boyut,Yon:Integer):String;
Var
   j,k:Integer;
   sv:String;
Begin
     sv:=s;
     if Boyut=0 Then
     Begin
          Result:=sv;
          Exit;
     End;
     if Length(sv)>Boyut Then
     Begin
          if Yon=1 Then Setlength(sv,Boyut) Else Delete(sv,1,Length(sv)-Boyut);
     End
     Else
     Begin
          k:=Length(sv);
          if k<Boyut Then
          Begin
               if Yon=1 Then For j:=1 to Boyut-k do sv:=sv+ch
               Else
               For j:=1 to Boyut-k do Insert(Ch,sv,1);
          End;
     End;
     Result:=sv;
End;


Function TextToInt(T:String):Integer;
Begin
     Result:=Round(TextToDbl(T,asfF));
End;

Function TextToDbl(sval,Format:String):Extended;
Var
   j:Integer;
   UKCh,FndDecSep:Boolean;
   RDbl:Extended;
   NSv,sv,es,s,s3:String;
   DecStep:Extended;
   isNum:Boolean;
   ThisYear:Word;
   w1,w2,w3,w4,w5,w6:integer;
Begin
  if Format='' Then
  Begin
          Result:=0;
          Exit;
  end;
  sv:=sval;
  if (Format=asfF) or (Format=asfR) or (Format='S') or (Format='') or
  (Format=asfI) or (Format=asfCur) Then
  Begin
     s:=sv;
     FndDecSep:=False;
     RDbl:=0;
     DecStep:=1;
     If Length(s)>0 Then
     Begin
         For j:=1 To Length(s) Do
         Begin
              If (not FndDecSep)and (S[j]=',') Then
              Begin
                   FndDecSep:=True;
              End
              Else
              If (S[j] in ['0'..'9'{,'?'}]) And (not((J=1) and (S[1]='0'))) Then
              Begin
                   If FndDecSep Then
                   Begin
                        DecStep:=DecStep*10;
                        RDbl:=RDbl+(Strtofloat(S[j])/DecStep);
                   End
                   Else
                   Begin
                        RDbl:=RDbl*10+(Strtofloat(S[j])/DecStep);
                   End;
              end;
         End;
     end;
     If Pos('-',sv)>0 Then RDbl:=RDbl*-1;
     Result:=RDbl;
  End Else
  Begin
       RDbl:=0;
       UKCh:=Pos('__',sv)>0;
       es:=sv;
       if Pos(asfF,Format)=1 Then
       Begin
            j:=0;
            s:=Format;
            While true do
            Begin
                 if s[j+1]<>asfF Then Break;
                 inc(j);
                 if Length(s)<=j Then Break;
            End;
            s:=NumericText(sv,False,True);
            if Length(s)>j Then Delete(s,j+1,Length(s)-j);
            RDbl:=strtoFloat(s);
            Result:=RDbl;
            exit;
       End;
       ThisYear:=YearOf(date);
       s:=NumericText(sv,False,True);
       if UKCh and (ReplaceText(s,'0','')<>'') then
       Begin
            s:=NumericTextC(sv,False,True);
            sv:=s;
       end;
       NSv:=NumericText(sv,False,False);


       if Format=asfDay Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>31 Then w1:=31;
            if w1<1 Then w1:=1;
            RDbl:=w1;
       End else
       if Format=asfHour Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>23 Then w1:=23;
            if w1<0 Then w1:=0;
            RDbl:=w1;
       End else
       if (Format=asfMin) or (Format=asfSec) Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>59 Then w1:=59;
            if w1<0 Then w1:=0;
            RDbl:=w1;
       End else
       if Format=asfMSec Then
       Begin
            s:=Copy(NSv,1,3);
            w1:=strtoint(s);
            if w1>999 Then w1:=999;
            if w1<0 Then w1:=0;
            RDbl:=w1;
       End else
       if Format=asfYY Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1<0 Then w1:=0;
            RDbl:=w1;
       End else
       if Format=asfYYYY Then
       Begin
            s:=Copy(NSv,1,4);
            w1:=strtoint(s);
            if w1<0 Then w1:=0;
            RDbl:=w1;
       End else
       if Format=asfMonth Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>12 Then w1:=12;
            if w1<1 Then w1:=1;
            RDbl:=w1;
       End else
       if Format=asfDayMonth Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>31 Then w1:=31;
            if w1<1 Then w1:=1;

            s:=Copy(NSv,3,2);
            if s='' then s:='0';
            w2:=strtoint(s);
            if w2>12 Then w2:=12;
            if w2<1 Then w2:=1;
            if (w2=2) and (w1>29) Then w1:=29;
            if MonthDayCount(ThisYear,w2)<w1 Then w1:=MonthDayCount(ThisYear,w2);
            RDbl:=StrToDate(inttostr(w1)+'.'+inttostr(w2)+'.'+ inttostr(thisyear));
       End else
       if Format=asfHourMin Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>23 Then w1:=23;
            if w1<0 Then w1:=0;

            s:=Copy(NSv,3,2);
            if s='' then s:='0';
            w2:=strtoint(s);
            if w2>59 Then w2:=59;
            if w2<0 Then w2:=0;
            RDbl:=StrToTime(inttostr(w1)+':'+inttostr(w2)+':00');
       End else
       if Format=asfMinSec Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>59 Then w1:=59;
            if w1<0 Then w1:=0;

            s:=Copy(NSv,3,2);
            if s='' then s:='0';
            w2:=strtoint(s);
            if w2>59 Then w2:=59;
            if w2<0 Then w2:=0;
            RDbl:=StrToTime('0:'+inttostr(w1)+':'+inttostr(w2));
       End else
       if Format=asfShMonthYear Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>12 Then w1:=12;
            if w1<1 Then w1:=1;

            s:=Copy(NSv,3,2);
            if s='' then s:='0';
            w2:=strtoint(s);
            if w2<0 Then w2:=0;
            RDbl:=StrToDate('01.'+inttostr(w1)+'.'+inttostr(w2));
       End else
       if Format=asfMonthYear Then
       Begin
            s:=Copy(NSv,1,2);
            w1:=strtoint(s);
            if w1>12 Then w1:=12;
            if w1<1 Then w1:=1;

            s:=Copy(NSv,3,4);
            if s='' then s:='0';
            w2:=strtoint(s);
            if w2<0 Then w2:=0;
            RDbl:=StrToDate('01.'+inttostr(w1)+'.'+inttostr(w2));
       End else
       if Format=asfShortDate Then
       Begin
            if (s='')  or (s='0') Then
            Begin
                 RDbl:=0;//Int(Date);
            End Else
            Begin
                 s:=Copy(NSv,1,2);
                 w1:=strtoint(s);
                 if w1<1 then w1:=1;

                 s:=Copy(NSv,3,2);
                 if s='' then s:='0';
                 w2:=strtoint(s);

                 s:=Copy(NSv,5,2);
                 if s='' then s:='0';
                 w3:=strtoint(s);
                 if w3<0 Then w3:=0;

                 if w2>12 Then w2:=12;
                 if w2<1 Then w2:=1;

                 if MonthDayCount(w3,w2)<w1 Then w1:=MonthDayCount(w3,w2);

                 Try
                    RDbl:=StrToDate(inttostr(w1)+'.'+inttostr(w2)+'.'+inttostr(w3));
                 Except
                    if w2=2 Then
                    RDbl:=StrToDate('28.'+inttostr(w2)+'.'+inttostr(w3))
                    Else
                    RDbl:=StrToDate('30.'+inttostr(w2)+'.'+inttostr(w3));
                 End;
            End;
       End else
       if Format=asfDate Then
       Begin
            if (s='')  or (s='0') Then
            Begin
                 RDbl:=0;//Int(Date);
            End Else
            Begin
                 s:=Copy(NSv,1,2);
                 w1:=strtoint(s);
                 if w1<1 then w1:=1;

                 s:=Copy(NSv,3,2);
                 if s='' then s:='0';
                 w2:=strtoint(s);

                 s:=Copy(NSv,5,4);
                 if s='' then s:='0';
                 w3:=strtoint(s);
                 if w3<0 Then w3:=0;

                 if w2>12 Then w2:=12;
                 if w2<1 Then w2:=1;

                 if MonthDayCount(w3,w2)<w1 Then w1:=MonthDayCount(w3,w2);

                 Try
                    RDbl:=StrToDate(inttostr(w1)+'.'+inttostr(w2)+'.'+inttostr(w3));
                 Except
                    if w2=2 Then
                    RDbl:=StrToDate('28.'+inttostr(w2)+'.'+inttostr(w3))
                    Else
                    RDbl:=StrToDate('30.'+inttostr(w2)+'.'+inttostr(w3));
                 End;
            End;
       End else
       if Format=asfTime Then
       Begin
            if (s='')  or (s='0') Then
            Begin
                 RDbl:=0;//Frac(Time);
            End Else
            Begin
                 s:=Copy(NSv,1,2);
                 w1:=strtoint(s);
                 if w1>23 Then w1:=23;
                 if w1<0 Then w1:=0;

                 s:=Copy(NSv,3,2);
                 if s='' then s:='0';
                 w2:=strtoint(s);
                 if w2<0 Then w2:=0;
                 if w2>59 Then w2:=59;

                 s:=Copy(NSv,5,2);
                 if s='' then s:='0';
                 w3:=strtoint(s);

                 if w3<0 Then w3:=0;
                 if w3>59 Then w3:=59;


                 RDbl:=StrToTime(inttostr(w1)+':'+inttostr(w2)+':'+inttostr(w3));
            End;
       End else
       if Format=asfDate+asfTime Then
       Begin
            if (s='')  or (s='0') Then
            Begin
                 RDbl:=0;//Now;
            End Else
            Begin
                 s:=Copy(NSv,1,2);
                 w1:=strtoint(s);
                 if w1<1 then w1:=1;

                 s:=Copy(NSv,3,2);
                 if s='' then s:='0';
                 w2:=strtoint(s);

                 s:=Copy(NSv,5,4);
                 if s='' then s:='0';
                 w3:=strtoint(s);
                 if w3<0 Then w3:=0;

                 if w2>12 Then w2:=12;
                 if w2<1 Then w2:=1;

                 if w2=2 then
                 if w1>29 Then w1:=28
                 else
                 if w1>31 Then w1:=31;
                 if w1<1 Then w1:=1;


                 s:=Copy(NSv,9,2);
                 if s='' then s:='0';
                 w4:=strtoint(s);
                 if w4>23 Then w4:=23;
                 if w4<0 Then w4:=0;

                 s:=Copy(NSv,11,2);
                 if s='' then s:='0';
                 w5:=strtoint(s);
                 if w5<0 Then w5:=0;
                 if w5>59 Then w5:=59;

                 s:=Copy(NSv,13,2);
                 if s='' then s:='0';
                 w6:=strtoint(s);

                 if w6<0 Then w6:=0;
                 if w6>59 Then w6:=59;
                 if MonthDayCount(w3,w2)<w1 Then w1:=MonthDayCount(w3,w2);

                 Try
                    RDbl:=StrToDateTime(inttostr(w1)+'.'+inttostr(w2)+'.'+inttostr(w3)+
                    ' '+inttostr(w4)+':'+inttostr(w5)+':'+inttostr(w6));
                 Except
                    if w2=2 Then
                    RDbl:=StrToDateTime('28.'+inttostr(w2)+'.'+inttostr(w3)+
                    ' '+inttostr(w4)+':'+inttostr(w5)+':'+inttostr(w6))
                    Else
                    RDbl:=StrToDateTime('30.'+inttostr(w2)+'.'+inttostr(w3)+
                    ' '+inttostr(w4)+':'+inttostr(w5)+':'+inttostr(w6));
                 End;


            End;
       End;

       Result:=RDbl;

  End;
End;

Function DblToText(P:Extended;Format:String):String;
Var j,k:Integer;
    SGec,Sgec2:String;
    Onda:Extended;
    s,ss:String;
    PG:Extended;
    Gercek:Extended;
    vdD,ay,vdY,SA,DA,SN,sl:Word;
Begin
  Onda:=0;
  if Format=asfCur then
  Begin
       result:=Trim(sysutils.format('%8.2n',[p]));
       exit;
  end;
  if (Format=asfR) or (Format=asfF) or (Format=asfS) or (Format='') Then
  Begin

     PG:=P;
     If PG<0 Then PG:=PG*-1;
     s:=Floattostr(Int(PG));
     k:=1;
     SGec:='';
     If Length(S)=0 Then Exit;
     For j:=Length(s) downto 1 do
     Begin
          If (k >3) And ((j>1) or ( (j=1) and ((Length(s) mod 3)>0)))  Then
          Begin
               k:=1;
               Insert('.',SGec,1);
          End;
          Insert(Copy(s,j,1),SGec,1);
          inc(k);
     End;
     S:=SGec;
     if (Format=asfF) Then
     Onda:=Round(Frac(PG)*1000)
     Else if (Format=asfR) Then Onda:=Round(Frac(PG)*100000000000000.0);

     If Onda>0 Then
     Begin
          sgec:=Floattostr(Onda);
          While true Do
          Begin
               If (Length(Sgec)>=FracDigitCount) and (Format=asfF) Then Break;
               If (Length(Sgec)>=14) and (Format=asfR) Then Break;
               sgec2:='0'+sgec;
               sgec:=sgec2
          End;
          s:=s+','+NumGetValidStr(sgec);
     End;
     If P<0 Then
       Result:='-'+S
     Else
       Result:=S;
  End Else
  Begin
       ss:='';
       Gercek:=P;
       if Pos(asfF,Format)=1 Then
       Begin
            j:=0;
            s:=Format;
            While true do
            Begin
                 if s[j+1]<>asfF Then Break;
                 inc(j);
                 if Length(s)<=j Then Break;
            End;
            s:=Floattostr(Round(Gercek));
            ss:=SetStrLength(s,'0',j,0);
       End;
       if Format=asfI Then
       Begin
            s:=Floattostr(Round(Gercek));
            ss:=NumericText(s,False,False);
       End;
       if (Format=asfDay) or (Format=asfYY) or (Format=asfMonth) or (Format=asfHour) or (Format=asfMin) or (Format=asfSec) Then
       Begin
            s:=Floattostr(Round(Gercek));
            ss:=SetStrLength(s,'0',2,0);
       End;
       if Format=asfMSec Then
       Begin
            DecodeTime(Gercek,sa,da,sn,sl);
            s:=Inttostr((sn*1000)+sl);
            ss:=s;
       End;
       if (Format=asfYYYY) Then
       Begin
            s:=Floattostr(Round(Gercek));
            ss:=SetStrLength(s,'0',4,0);
       End;
       if Format=asfDayMonth Then
       Begin
            DecodeDate(Gercek,vdY,Ay,vdD);

            s:=Inttostr(vdD);
            ss:=SetStrLength(s,'0',2,0)+DateSep;
            s:=Inttostr(Ay);
            ss:=ss+SetStrLength(s,'0',2,0);
       End;

       if Format=asfHourMin Then
       Begin
            DecodeTime(Gercek,sa,da,sn,sl);
            s:=Inttostr(sa);
            ss:=SetStrLength(s,'0',2,0)+':';
            s:=Inttostr(Da);
            ss:=ss+SetStrLength(s,'0',2,0);
       End;

       if Format=asfMinSec Then
       Begin
            DecodeTime(Gercek,sa,da,sn,sl);
            s:=Inttostr(da);
            ss:=SetStrLength(s,'0',2,0)+':';
            s:=Inttostr(sn);
            ss:=ss+SetStrLength(s,'0',2,0);
       End;

       if Format=asfTime Then
       Begin
            DecodeTime(Gercek,sa,da,sn,sl);
            s:=Inttostr(sa);
            ss:=SetStrLength(s,'0',2,0)+':';
            s:=Inttostr(da);
            ss:=ss+SetStrLength(s,'0',2,0)+':';
            s:=Inttostr(sn);
            ss:=ss+SetStrLength(s,'0',2,0);
       End;

       if Format=asfShMonthYear Then
       Begin
            DecodeDate(Gercek,vdY,Ay,vdD);

            ss:='';
            s:=Inttostr(Ay);
            ss:=ss+SetStrLength(s,'0',2,0);
            s:=Inttostr(vdY);
            if Length(s)=4 Then Delete(s,1,2);
            ss:=ss+DateSep+s;
       End;

       if Format=asfMonthYear Then
       Begin
            DecodeDate(Gercek,vdY,Ay,vdD);

            ss:='';
            s:=Inttostr(Ay);
            ss:=ss+SetStrLength(s,'0',2,0);
            s:=Inttostr(vdY);
            ss:=ss+DateSep+SetStrLength(s,'0',4,0);
       End;

       if Format=asfShortDate Then
       Begin
            if Gercek=0 then
            ss:='__'+DateSep+'__'+DateSep+'__'
            Else
            Begin
                 DecodeDate(Gercek,vdY,Ay,vdD);
                 s:=Inttostr(vdD);
                 ss:=SetStrLength(s,'0',2,0)+DateSep;
                 s:=Inttostr(Ay);
                 ss:=ss+SetStrLength(s,'0',2,0);
                 s:=Inttostr(vdY);
                 if Length(s)=4 Then Delete(s,1,2);
                 ss:=ss+DateSep+SetStrLength(s,'0',2,0);

            end;
       End;

       if Format=asfDate Then
       Begin
            if Gercek=0 then
            ss:='__'+DateSep+'__'+DateSep+'____'
            Else
            Begin
                 DecodeDate(Gercek,vdY,Ay,vdD);

                 s:=Inttostr(vdD);
                 ss:=SetStrLength(s,'0',2,0)+DateSep;
                 s:=Inttostr(Ay);
                 ss:=ss+SetStrLength(s,'0',2,0);
                 s:=Inttostr(vdY);
                 ss:=ss+DateSep+SetStrLength(s,'0',4,0);
            end;
       End;

       if Format=asfDate+asfTime Then
       Begin
            if Gercek=0 then
            ss:='__'+DateSep+'__'+DateSep+'_______:__:__'
            Else
            Begin
                 DecodeDate(Gercek,vdY,Ay,vdD);

                 s:=Inttostr(vdD);
                 ss:=SetStrLength(s,'0',2,0)+DateSep;
                 s:=Inttostr(Ay);
                 ss:=ss+SetStrLength(s,'0',2,0);
                 s:=Inttostr(vdY);
                 ss:=ss+DateSep+SetStrLength(s,'0',4,0);

                 DecodeTime(Gercek,sa,da,sn,sl);
                 s:=Inttostr(sa);
                 ss:=ss+' '+SetStrLength(s,'0',2,0)+':';
                 s:=Inttostr(da);
                 ss:=ss+SetStrLength(s,'0',2,0)+':';
                 s:=Inttostr(sn);
                 ss:=ss+SetStrLength(s,'0',2,0);
            end;
       End;

       Result:=ss;

  End;
End;


function GetDirectory(d:String):String;
Begin
     Result:=d;
     if d='' Then exit;
     if Copy(d,length(d),1)<>'\' then Result:=d+'\';
End;
procedure GetClipBrdFiles(Var DsList:TStringList);
var
   f: THandle;
   buffer: Array [0..MAX_PATH] of Char;
   i, numFiles: Integer;
begin
   if not Assigned(DsList) Then DsList:=TStringList.Create;
   DsList.Clear;
   Clipboard.Open;
   try
     f:= Clipboard.GetAsHandle( CF_HDROP ) ;
     If f <> 0 Then Begin
       numFiles := DragQueryFile( f, $FFFFFFFF, nil, 0 ) ;

       for i:= 0 to numfiles - 1 do begin
         buffer[0] := #0;
         DragQueryFile( f, i, buffer, sizeof(buffer)) ;
         DsList.add( buffer ) ;
       end;
     end;
   finally
     Clipboard.close;
   end;
end;


function csvPrepareColumn(s:String):String;
Var
   sb:string;
   j,ln:integer;
Begin
     sb:='';
     ln:=Length(s);
     for j := 1 to ln do
     sb:=sb+StrSafe[ord(s[j])];
     result:=sb;
{
Var
   sb:string;
Begin
     sb:=s;
     ReplaceTextP(sb,'.','#46');
     ReplaceTextP(sb,',','#44');
     ReplaceTextP(sb,#13,'#13');
     ReplaceTextP(sb,#10,'#10');
     ReplaceTextP(sb,';','#59');
     ReplaceTextP(sb,'"','#34');
     ReplaceTextP(sb,#39,'#39');
     ReplaceTextP(sb,'=','#61');
     result:=sb;
}
end;
function csvPrepareColumnASCMR(s:ASCMRString):ASCmrString;
Var
   sb:ASCMRString;
Begin
     sb:=s;
     ReplaceTextP_MR(sb,'#','$+35');
     ReplaceTextP_MR(sb,'.','#46');
     ReplaceTextP_MR(sb,',','#44');
     ReplaceTextP_MR(sb,#13,'#13');
     ReplaceTextP_MR(sb,#10,'#10');
     ReplaceTextP_MR(sb,';','#59');
     ReplaceTextP_MR(sb,'"','#34');
     ReplaceTextP_MR(sb,#39,'#39');
     ReplaceTextP_MR(sb,'=','#61');
     result:=sb;
end;
function csvRePrepareColumnASCMR(s:ASCmrString):ASCmrString;
Var
   sb:ASCMRString;
begin
     sb:=s;
     ReplaceTextP_MR(sb,'#46','.');
     ReplaceTextP_MR(sb,'#44',',');
     ReplaceTextP_MR(sb,'#13',#13);
     ReplaceTextP_MR(sb,'#10',#10);
     ReplaceTextP_MR(sb,'#59',';');
     ReplaceTextP_MR(sb,'#34','"');
     ReplaceTextP_MR(sb,'#39',#39);
     ReplaceTextP_MR(sb,'#61','=');
     ReplaceTextP_MR(sb,'$+35','#');
     result:=sb;

end;
function csvRePrepareColumn(s:String):String;
Var
   sb,sd:string;
   j,ln,ch:integer;
Begin
     sb:='';
     ln:=Length(s);
     j:=1;
     while j<=ln do
     Begin
          if s[j]='#' then
          begin
               ch:=Texttoint(copy(s,j+1,2));

               case ch of
                    65..69:sb:=sb+chr(58+ch);
                    99:sb:=sb+#255;
                    0:
                    begin
                         if copy(s,j+1,2)<>'00' then  //eðer # karakteri yanýnda rakam deðilde harf varsa
                         begin
                              sb:=sb+s[j];
                              inc(j);
                              Continue;
                         end else
                         sb:=sb+chr(ch);
                    end;
                    //1..64,91..96:          @?>=<;:9-,+*
                    else sb:=sb+chr(ch);
               end;
               inc(j,3);
          end else
          begin
               sb:=sb+s[j];
               inc(j);
          end;
     End;
     result:=sb;
     {
     sb:=s;
     ReplaceTextP(sb,'#46','.');
     ReplaceTextP(sb,'#44',',');
     ReplaceTextP(sb,'#13',#13);
     ReplaceTextP(sb,'#10',#10);
     ReplaceTextP(sb,'#59',';');
     ReplaceTextP(sb,'#34','"');
     ReplaceTextP(sb,'#39',#39);
     ReplaceTextP(sb,'#61','=');
     result:=sb;
     }
end;

Procedure GetFileList(SrList:TStringList;Var DsList:TStringList;Var TotalSize:Int64;Mask:String;SubDirSwc:Boolean);
Var
   j,DAttr:Integer;
   GdStr,Gdstr2:TStringList;
   sr: TSearchRec;
   s:string;
   fFirstDir:Boolean;
   Procedure GetFilesProc(SubDirStr:String;Var OutFList:TStringList);
   Begin
        OutFList.Clear;
        if FindFirst(SubDirStr+'*.*', $3f, sr) = 0 then
        begin
             if not ((sr.Name='.') or (sr.Name='..')) Then
             Begin

                  if (Sr.Attr=$10) and SubDirSwc Then
                     OutFList.Add(SubDirStr+sr.Name)
                  Else
                  Begin
                    if MatchesMask(sr.Name,Mask) Then
                       DsList.Add(SubDirStr+sr.Name);
                  End;
             End;
             while FindNext(sr) = 0 do
             begin
                  if not ((sr.Name='.') or (sr.Name='..')) Then
                  Begin
                       if (Sr.Attr=$10) and SubDirSwc Then
                          OutFList.Add(SubDirStr+sr.Name)
                       Else
                       Begin
                            if MatchesMask(sr.Name,Mask) Then
                            DsList.Add(SubDirStr+sr.Name);
                       End;
                  End;
             End;
             FindClose(sr);
        End;
   End;

Begin
     TotalSize:=0;
     DsList.Clear;
     if SrList.Count=0 Then Exit;
     GdStr:=TStringList.Create;
     GdStr.Clear;
     GdStr2:=TStringList.Create;
     GdStr2.Clear;
     fFirstDir:=True;
     For j:=0 to SrList.Count-1 do
     begin
          s:=SrList.Strings[j];
         if s='' then continue;
         if Copy(s,Length(s),1)='\' then SetLength(s,Length(s)-1);

         GdStr.Add(s);
     end;
     while GdStr.Count>0 do
     Begin
          DAttr:=FileGetAttr(GdStr.Strings[0]);
          if DAttr=$10 Then
          Begin
               if SubDirSwc or fFirstDir then
                  GetFilesProc(GetDirName(GdStr.Strings[0]),GdStr2);
               GdStr.Delete(0);
               if (SubDirSwc or fFirstDir) and (GdStr2.count>0) Then
               Begin
                    For j:=0 to GdStr2.Count-1 do
                        GdStr.Add(GdStr2.Strings[j]);
               End;
          End Else
          Begin
               if FindFirst(GdStr.Strings[0], $3f, sr) = 0 then
               begin
                    TotalSize:=TotalSize+Sr.Size;
                    if MatchesMask(GdStr.Strings[0],Mask) Then
                    DsList.Add(GdStr.Strings[0]);
               End;
               GdStr.Delete(0);
               FindClose(sr);
          End;
          fFirstDir:=False;
     End;
     GdStr.Free;
     GdStr:=Nil;
     GdStr2.Free;
     GdStr2:=Nil;
End;

function GetSizeDescription(const IntSize : Int64) : String;
begin
     if IntSize < 1024 then Result := IntToStr(IntSize)+' bytes'
     else
     if IntSize < (1024 * 1024) then Result := FormatFloat('####0.##',IntSize / 1024)+' Kb'
     else
     if IntSize < (1024 * 1024 * 1024) then
        Result := FormatFloat('####0.##',IntSize / 1024 / 1024)+' Mb'
     else
        Result := FormatFloat('####0.##',IntSize / 1024 / 1024 / 1024)+' Gb';
end;


function GetDirName(s:string):String;
Begin
     if Copy(s,Length(s),1)<>'\' Then
     Result:=s+'\' else result:=s;
end;
function GetFileModifyDate(const fn: string;Var ModifyDate:Double):Boolean;
var
  FileH : THandle;
  LocalFT : TFileTime;
  DosFT : DWORD;
  LastAccessedTime : TDateTime;
  FindData : TWin32FindData;
begin
     Result:=False;
     FileH := FindFirstFile(PChar(fn), FindData);
     if FileH <> INVALID_HANDLE_VALUE then
     begin
          Windows.FindClose(FileH);
          if (FindData.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY) = 0 then
          begin
               FileTimeToLocalFileTime(FindData.ftLastWriteTime,LocalFT);
               FileTimeToDosDateTime(LocalFT,LongRec(DosFT).Hi,LongRec(DosFT).Lo);

               if DosFT<>0 then
               try
                  ModifyDate:=FileDateToDateTime(DosFT);
               except
                  ModifyDate:=now;
               end;
               Result:=True;
          end;
     end;
end;

function GetModifyDateFromFD(FindData : TWin32FindData):Double;
var
  LocalFT : TFileTime;
  DosFT : DWORD;

begin
     Result:=0;
     if (FindData.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY) = 0 then
     begin
          try
             FileTimeToLocalFileTime(FindData.ftLastWriteTime,LocalFT);
             FileTimeToDosDateTime(LocalFT,LongRec(DosFT).Hi,LongRec(DosFT).Lo);
             Result:=FileDateToDateTime(DosFT);
          except
             Result:=dosft;


          end;
     end;
end;


function DSiFileTimeToDateTime(fileTime: TFileTime; var dateTime: TDateTime): boolean;
var
  sysTime: TSystemTime;
begin
  Result := FileTimeToSystemTime(fileTime, sysTime);
  if Result then
    dateTime := SystemTimeToDateTime(sysTime);
end; { DSiFileTimeToDateTime }
function  DSiGetModifyDate(const fileName: string; var lastModificationTime: TDateTime): boolean;
var
  fileHandle            : cardinal;
  fsCreationTime        : TFileTime;
  fsLastAccessTime      : TFileTime;
  fsLastModificationTime: TFileTime;
begin
  Result := false;
  fileHandle := CreateFile(PChar(fileName), GENERIC_READ, FILE_SHARE_READ, nil,
    OPEN_EXISTING, 0, 0);
  if fileHandle <> INVALID_HANDLE_VALUE then try
    Result :=
      GetFileTime(fileHandle, @fsCreationTime, @fsLastAccessTime,
         @fsLastModificationTime) and
      DSiFileTimeToDateTime(fsLastModificationTime, lastModificationTime);
  finally
    CloseHandle(fileHandle);
  end;
end;
function  DSiGetFileTimes(const fileName: string; var creationTime, lastAccessTime,
  lastModificationTime: TDateTime): boolean;
var
  fileHandle            : cardinal;
  fsCreationTime        : TFileTime;
  fsLastAccessTime      : TFileTime;
  fsLastModificationTime: TFileTime;
begin
  Result := false;
  fileHandle := CreateFile(PChar(fileName), GENERIC_READ, FILE_SHARE_READ, nil,
    OPEN_EXISTING, 0, 0);
  if fileHandle <> INVALID_HANDLE_VALUE then try
    Result :=
      GetFileTime(fileHandle, @fsCreationTime, @fsLastAccessTime,
         @fsLastModificationTime) and
      DSiFileTimeToDateTime(fsCreationTime, creationTime) and
      DSiFileTimeToDateTime(fsLastAccessTime, lastAccessTime) and
      DSiFileTimeToDateTime(fsLastModificationTime, lastModificationTime);
  finally
    CloseHandle(fileHandle);
  end;
end; { DSiGetFileTimes }


function GetWordCountFromLeft(const sv,w:ascmrstring;P:integer;var linep:integer):integer;
Var
   j,k:integer;
Begin
     Result:=0;
     j:=1;
     linep:=j;
     while j<P Do
     Begin
          k:=ASCMRPosEx(w,sv,j);
          if k>0 then
          Begin
               if k>p then exit;
               inc(Result);
               j:=k+1;
               linep:=j;
          end else break;
     end;
end;

{$IF (ASCUniCodeUsing=1)}
function WideCountChar(const Ch: WideChar; const S: WideString;idx,p:integer;var linep:integer): Integer;
var Q : PWideChar;
    I,p2 : Integer;
begin
  Result := 0;
  Q := PWideChar(S);
  if not Assigned(Q) then
    exit;
  if idx>1 then
     inc(Q,(idx-1));
  if Length(S)<p then p2:=Length(S)-idx else p2:=p-idx;

  for I := 1 to p2 do
    begin
      if Q^ = Ch then
      begin
           linep:=idx+i;
           Inc(Result);
      end;
      Inc(Q);
    end;
end;
{$ELSE}
function WideCountChar(const Ch: Char; const S: String;idx,p:integer;var linep:integer): Integer;
var
    I ,p2: Integer;
begin
  Result := 0;
  for I := idx to p do
    begin
      if S[i] = Ch then
      begin
           linep:=i+1;
           Inc(Result);
      end;
    end;
end;
{$IFEND}

function GetWordCountFPosLeft(const sv{kaynak},w:ASCMRstring;fp{Baþlangýç Pos},P{Bitiþ Pos}:integer;var linep:integer;LC:integer):integer;
Var
   j,k,i:integer;
   tmpsv:ascmrstring;
Begin
     Result:=LC; //daha önce belirlenmiþtir
     if fp<1 then j:=1 else j:=fp; //fp pozisyonundan itibaren iþlem baþlayacak
     i:=WideCountChar(#13,sv,j,P,linep);
     Result:=LC+i;
     {
     while j<P Do
     Begin
          k:=ASCMRPosExB(sv,j);
          if k>0 then
          Begin
               if k>p then exit;
               inc(Result);
               j:=k+1;
               linep:=j;
          end else break;
     end;
     }
end;

function GetLineFromPosASCMR(const sv:ASCMRString;P:integer;Var PFirst,PLast:integer):ASCMRString;
Var
   j,k,l:integer;
Begin
     //PFirst
     PFirst:=P;
     if (p>1) and (length(sv)>=p-1) then
     begin
          for j := P-1 downto 1 do
          Begin
               if sv[j]=#10 then
               Begin
                    PFirst:=j+1;
                    break;
               end else  if j=1 then PFirst:=j;
          end;
     end;
     //PLast
     l:=Length(sv);
     PLast:=ASCMRPosEx(#13,sv,p+1); //posex offset 1dan baþlýyor
     if PLast<1 then
     PLast:=l else PLast:=Plast-1;
     Result:=Copy(sv,PFirst,Plast-PFirst+1);
end;
function GetLineFromPos(const sv:string;P:integer;Var PFirst,PLast:integer):String;
Var
   j,k,l:integer;
Begin
     //PFirst
     PFirst:=P;
     if p>1 then
     for j := P-1 downto 1 do
     Begin
          if sv[j]=#10 then
          Begin
               PFirst:=j+1;
               break;
          end else  if j=1 then PFirst:=j;
     end;
     //PLast
     l:=Length(sv);
     PLast:=PosEx(#13,sv,P+1);
     if PLast<1 then
     PLast:=l else PLast:=Plast-1;
     Result:=Copy(sv,PFirst,Plast-PFirst+1);
end;
function GetLinePos(const sv:ASCMRstring;startline,stopline:integer):TPoint;
var
   j,k,l,j1,j2:integer;
begin
     Result.X:=0;
     Result.Y:=0;
     if length(sv)=0 then
     begin
          exit;
     end;
     k:=length(sv);
     l:=1;
     j1:=0;
     while l<startline do
     begin
          j2:=ASCMRPosEx(#10,sv,j1+1);
          if j2>0 then
          begin
               j1:=j2;
               inc(l);
          end else break;
     end;
     if l<startline then exit;
     Result.X:=j1+1;

     while l<stopline do
     begin
          j2:=ASCMRPosEx(#10,sv,j1+1);
          if j2>0 then
          begin
               j1:=j2;
               inc(l);
          end else break;
     end;
     if l<stopline then
     Result.Y:=k
     else
     begin
          j2:=ASCMRPosEx(#10,sv,j1+1);
          if j2>0 then
          Result.Y:=j2 else Result.Y:=k;
     end;

end;

function GetNextLinePos(const sv:ascmrstring;startpos:integer):TPoint;
var
   j,k,l,j1,j2:integer;
begin
     if length(sv)<startpos+1 then
     begin
          Result.x:=0;
          Result.y:=0;
          exit;
     end;
     Result.X:=startpos+1;
     Result.Y:=length(sv);
     j2:=ASCMRPosEx(#10,sv,Result.x);
     if j2>0 then
     begin
          Result.Y:=j2;
     end;
end;
Function GetxsvPos(s:String;x:Char;K:Integer):TPoint;
Var
   j,i:Integer;
Begin
     Result.x:=0;
     Result.y:=0;
     i:=1;
     if s='' Then Exit;
     For j:=1 to Length(s) do
     Begin
          if s[j]=x Then
          Begin
               if i>=k Then break;
               i:=i+1;
          End Else
          Begin
               if i=k Then
               begin
                    if Result.x<1 then Result.x:=j;
                    Result.y:=k;
               end;
          End;
     End;

end;

Function GetxsvPosB(s:String;x:Char;K,vfrom,vto:Integer):TPoint;
Var
   j,i:Integer;
Begin
     Result.x:=0;
     Result.y:=-1;
     i:=1;
     if s='' Then Exit;
     For j:=vfrom to vto do
     Begin
          if s[j]=x Then
          Begin
               if i>=k Then
               begin
                    if Result.x<1 then
                    begin
                      Result.x:=j;
                    end;
                    Result.y:=j;
                    break;
               end;
               i:=i+1;
          End Else
          Begin
               if i=k Then
               begin
                    if Result.x<1 then Result.x:=j;
                    Result.y:=j;
               end;
          End;
     End;

end;

Function GetxsvPosB_MR(s:ASCMRString;x:ASCMRChar;K,vfrom,vto:Integer):TPoint;
Var
   j,i:Integer;
Begin
     Result.x:=0;
     Result.y:=-1;
     i:=1;
     if s='' Then Exit;
     For j:=vfrom to vto do
     Begin
          if s[j]=x Then
          Begin
               if i>=k Then
               begin
                    if Result.x<1 then
                    begin
                      Result.x:=j;
                    end;
                    Result.y:=j;
                    break;
               end;
               i:=i+1;
          End Else
          Begin
               if i=k Then
               begin
                    if Result.x<1 then Result.x:=j;
                    Result.y:=j;
               end;
          End;
     End;

end;

function GetFileSize(fn:string):int64;
Var
   i:integer;
   SearchRec: TSearchRec;
Begin
     Result:=0;
     i := FindFirst(fn, faAnyFile, SearchRec);
     if i<>0 then exit;
     if ((SearchRec.Attr and FaDirectory <> FaDirectory)
         { and (SearchRec.Attr and FaVolumeId <> FaVolumeID)}) then
     begin
          Result:=SearchRec.Size;
     end;

end;
function FileSizeCheck(fn:string;Min,Max:int64):Boolean;
var
   i:int64;
begin
     if (Min=Max) and (min=0) then
     begin
          Result:=True;
          exit;
     end;

     i:=GetFileSize(fn);
     Result:=(i>=Min) and (i<=Max);

end;
procedure ExtractFileItems(fn:ASCMRString;Var fname,fnnoex,fex,fdir:ASCMRString);
var
   s2,s3:String;
   j:integer;
begin
     fdir:=ExtractFileDir(fn);
     fname:=ExtractFileName(fn);
     fex:=ExtractFileExt(fn);
     j:=Length(fname)-Length(fex); //1234.234;
     fnnoex:=Copy(fname,1,j);
     {
     j:=Pos(fex,s2);
     if j>0 then
     fnnoex:=copy(fname,1,j-1)
     else
     fnnoex:=fname;
     }
end;
function Mince(PathToMince :String; InSpace :Integer): String;
{
For example
"C:\Program Files\Delphi\DDrop\TargetDemo\main.pas"
is desired to be seen as
"C:\Program F....Demo\main.pas"
then the following "Mince" function could be used.
}
var TotalLength, FLength : Integer;
begin
  TotalLength := Length(PathToMince) ;
  if TotalLength > InSpace then
  begin
   FLength := (Inspace Div 2) - 2;
   Result := Copy(PathToMince, 0, fLength)
             + '...'
             + Copy(PathToMince,
                   TotalLength-fLength,
                   TotalLength) ;
  end
  else
    Result := PathToMince;
end;

Function TextFilter(F,Src:String):String;
Var
   s:String;
   j,k:Integer;
Begin
     s:=Src;
     if (F<>'') And (s<>'') Then
     For j:=Length(s) downto 1 Do
     Begin
          For k:=1 To Length(F) do
          Begin
               if s[j]=F[k] Then
               Begin
                    Delete(s,j,1);
                    Break;
               End;
          End;
     End;
     Result:=s;
End;
Function TextFilterB(F,Src:String):String;
Var
   fnd:boolean;
   s:String;
   j,k:Integer;
Begin
     s:=Src;
     if (F<>'') And (s<>'') Then
     For j:=Length(s) downto 1 Do
     Begin
          fnd:=False;
          For k:=1 To Length(F) do
          Begin
               if s[j]=F[k] Then
               Begin
                    fnd:=true;
                    Break;
               End;
          End;
          if not fnd then
             Delete(s,j,1);
     End;
     Result:=s;
End;

Function BoolToStrYN(c:Boolean):String;
Begin
     if c then Result:='Y'
     else
     Result:='N';
end;
function StrYNToBool(s:String):Boolean;
Begin
     Result:=UpperCase(s)='Y';
end;

function ascdatestr(d:Double):String;
var

   wd,wm,wy:Word;
begin
     decodedate(d,wy,wm,wd);
     Result:=DblToText(wd,'NN')+DblToText(wm,'NN')+DblToText(wy,'NNNN');
end;

procedure Shuffle(
   var aArray;
   aItemCount: Integer;
   aItemSize: Integer) ;
var
   Inx: Integer;
   RandInx: Integer;
   SwapItem: PByteArray;
   A: TByteArray absolute aArray;
begin
   if (aItemCount > 1) then
   begin
     GetMem(SwapItem, aItemSize) ;
     try
       for Inx := 0 to (aItemCount - 2) do
       begin
         RandInx := Random(aItemCount - Inx) ;
         Move(A[Inx * aItemSize], SwapItem^, aItemSize) ;
         Move(A[RandInx * aItemSize],
              A[Inx * aItemSize], aItemSize) ;
         Move(SwapItem^, A[RandInx * aItemSize],
              aItemSize) ;
       end;
     finally
       FreeMem(SwapItem, aItemSize) ;
     end;
   end;
end;
{$IF (ASCUniCodeUsing=1)}
function LoadUnicode(f:string;b:boolean=true):widestring;
var
ms:TMemoryStream;
hs:String;
ws:WideString;
begin
Result:='';
if not FileExists(f) then exit;
ms:=TMemoryStream.Create;
ms.LoadFromFile(f);
if b then begin
SetLength(hs,2);
ms.Read(hs[1],2);
if hs<>#$FF#$FE then begin ms.Free; exit; end;
SetLength(ws,(ms.Size-2) div 2);
ms.Read(ws[1],ms.Size-2);
end else begin
SetLength(ws,ms.Size div 2);
ms.Read(ws[1],ms.Size);
end;
Result:=ws;
ms.Free;
end;
Procedure LoadUnicodeFile( const filename: String; strings: TTNTStrings );
     Procedure SwapWideChars( p: PWideChar );
     Begin
          While p^ <> #0000 Do
          Begin
               // p^ := Swap( p^ ); //<<< D3
               p^ := WideChar( Swap( Word(p^)));
               Inc( p );
          End; { While }
     End; { SwapWideChars }


Var
   ms: TMemoryStream;
   wc: WideChar;
   pWc: PWideChar;
Begin
     ms:= TMemoryStream.Create;
     try
        ms.LoadFromFile( filename );
        ms.Seek( 0, soFromend );
        wc := #0000;
        ms.Write( wc, sizeof(wc));

        pWC := ms.Memory;

        If pWc^ = #$FEFF Then // normal byte order mark
           Inc(pWc)
        Else If pWc^ = #$FFFE Then
        Begin // byte order is big-endian

              SwapWideChars( pWc );
              Inc( pWc );
        End { If }
        Else; // no byte order mark
              strings.Text:=WideString(pWc);
        //strings.Text := WideChartoString( pWc );
     finally
        ms.free;
     end;
End;
{$IFEND}

function WidePosChar(const F: WideChar; const S: WideString; const StartIndex: Integer): Integer;
var P : PWideChar;
    I, L : Integer;
begin
  L := Length(S);
  if (StartIndex > L) or (StartIndex < 1) then
    begin
      Result := 0;
      exit;
    end;
  P := Pointer(S);
  Inc(P, StartIndex - 1);
  for I := StartIndex to L do
    if P^ = F then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := 0;
end;

function WidePMatch(const M: WideString; const P: PWideChar): Boolean;
var I, L : Integer;
    Q, R : PWideChar;
begin
  L := Length(M);
  if L = 0 then
    begin
      Result := False;
      exit;
    end;
  R := Pointer(M);
  Q := P;
  for I := 1 to L do
    if R^ <> Q^ then
      begin
        Result := False;
        exit;
      end else
      begin
        Inc(R);
        Inc(Q);
      end;
  Result := True;
end;

function WidePos(const F: WideString; const S: WideString; const StartIndex: Integer): Integer;
var P : PWideChar;
    I, L : Integer;
begin
  L := Length(S);
  if (StartIndex > L) or (StartIndex < 1) then
    begin
      Result := 0;
      exit;
    end;
  P := Pointer(S);
  Inc(P, StartIndex - 1);
  for I := StartIndex to L do
    if WidePMatch(F, P) then
      begin
        Result := I;
        exit;
      end
    else
      Inc(P);
  Result := 0;
end;

function ASCMRPosExB(s:ascmrstring;ofset:integer):integer;
var
   tmpsv:ascmrstring;
begin
     {$IF (ASCUniCodeUsing=1)}
     Result:=WidePosChar(#13,s,ofset+1);
     {
     tmpsv:=copy(s,ofset,length(s)-ofset+1);
     result:=Pos(#13,tmpsv);
     if result>0 then result:=result+ofset-1;
     }
     {$ELSE}
     result:=PosEx(#13,s,ofset); //posex offset 0dan baþlýyor
     {$IFEND}
end;
function ASCMRPosEx(c,s:ascmrstring;ofset:integer):integer;
var
   tmpsv:ascmrstring;
begin
     {$IF (ASCUniCodeUsing=1)}
     Result:=WidePos(c,s,ofset);
     {
     tmpsv:=copy(s,ofset,length(s)-ofset+1);
     result:=Pos(c,tmpsv);
     if result>0 then result:=result+ofset-1;
     }
     {$ELSE}
     result:=PosEx(c,s,ofset); //posex offset 0dan baþlýyor
     {$IFEND}
end;
Function DeleteInvChars(s,dc:String):String;
Var
   j,k,c:Integer;
   v:String;
Begin
     Result:=s;
     if (s='') or (dc='') then Exit;
     c:=Length(s);
     v:='';
     for k :=c downto 1 do
     Begin
          if Pos(copy(s,k,1),dc)>0 then
          v:=s[k]+v;
     end;
     Result:=v;
end;

Function dec2tohex(s:String):String;
Var
   j:Integer;
   sv:String;
Begin
     sv:='';
     j:=1;
     While Length(s)>=j do
     Begin
          sv:=sv+inttohex(Ord(s[j]),2);
          inc(j);
     End;
     result:=sv;
End;

function hexdatatostr(s:string):String;
Var
   j,jb:byte;
   k:integer;
   sc,sw:string;
Begin
     Result:='';
     sc:=DeleteInvChars(s,'0123456789ABCDEF');
     while sc<>'' do
     Begin
          sw:=copy(sc,1,2);
          Delete(sc,1,2);

          if sw<>'' then
          Begin
               j:=0;
               for k := 1 to Length(sw) do
               Begin
                    jb:=StrToInt('$'+copy(sw,k,1));
                    j:=j shl 4;
                    j:=j or jb;
               end;
               Result:=Result+Chr(j);
          end;
     end;

end;

initialization
     DecimalSeparator:=',';
     ThousandSeparator:='.';
     DateSeparator:='.';
     TimeSeparator:=':';
     CurrencyFormat:=3;
     NegCurrFormat:=8;
     CurrencyDecimals:=2;
     ShortDateFormat:='dd.MM.yyyy';
     LongDateFormat:='dd MMMM yyyy dddd';
     TimeSeparator:=':';
     TimeAMString:='';
     TimePMString:='';
     ShortTimeFormat:='hh:mm';
     LongTimeFormat:='hh:mm:ss';
     SysLocale.DefaultLCID:=1055;
     SysLocale.PriLangID:=31;
     SysLocale.SubLangID:=1;
     SysLocale.FarEast:=False;
     SysLocale.MiddleEast:=True;
     EraNames[1]:='';
     EraYearOffsets[1]:=0;
     EraNames[2]:='';
     EraYearOffsets[2]:=0;
     EraNames[3]:='';
     EraYearOffsets[3]:=0;
     EraNames[4]:='';
     EraYearOffsets[4]:=0;
     EraNames[5]:='';
     EraYearOffsets[5]:=0;
     EraNames[6]:='';
     EraYearOffsets[6]:=0;
     EraNames[7]:='';
     EraYearOffsets[7]:=0;
     TwoDigitYearCenturyWindow:=50;
     ListSeparator:=';';
     DrwBMP := TBitmap.Create;
Finalization
     DrwBMP.Free;
end.
