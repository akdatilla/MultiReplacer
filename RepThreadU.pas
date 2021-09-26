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
 
unit RepThreadU;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,RepLib,RepConstU,Masks,RegExpr,RVStyle,Grids,ComCtrls,ShellApi,BMDThread
  {$IF (ASCUniCodeUsing=1)}
  ,TntClasses,TntStdCtrls,TNTSysUtils,TNTGrids,TNTComCtrls
  {$IFEND}
  ;

type
  {$IF (ASCUniCodeUsing=1)}
  TASCMRStringList=TTntStringList;
  TASCMRStrings=TTntStrings;
  TASCMemo=TTNTMemo;
  TASCStringGrid=TTNTStringGrid;
  TASCRichEdit=TRichEdit;
  TASCRichEditB=TTNTRichEdit;
  {$ELSE}
  TASCMRStrings=TStrings;
  TASCMRStringList=TStringList;
  TASCMemo=TMemo;
  TASCStringGrid=TStringGrid;
  TASCRichEdit=TRichEdit;
  TASCRichEditB=TRichEdit;
  {$IFEND}
  TMainFileSearch = class;

  TOnFileFoundEvent =
    procedure(Sender: TObject; FileName: ASCMRString) of object;

  TOnReadyEvent =TNotifyEvent;

  TFileSearchThread = class(TBMDThread)
  public
    fscPath:ASCMRString;
  private
    fOwner: TMainFileSearch;
    fFileFound: TFileName;
    fOnFileFound: TOnFileFoundEvent;
    fOnNormally,fOnFileScanned:TNotifyEvent;
    fscCountChange,fMatchCountChange:TNotifyEvent;
    fOnReady: TOnReadyEvent;
    fList: TList;
    fFormStyleSwc:integer;
    fscCounter,fMatchCounter:integer;
    fStop:Boolean;
    RepFrmFHandle:THandle;
    procedure FileFound(Sender:TObject);
    procedure syncCounter(Sender:TObject);
    procedure FileScanned(Sender:TObject);
    procedure Ready(Sender:TObject);
    procedure SetscCounter(Value:integer);
    procedure SetMatchCounter(Value:integer);
    procedure BMDExecute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
  protected
    property scCounter:integer read fscCounter write SetscCounter;
    property MatchCounter:integer read fMatchCounter write SetMatchCounter;
    procedure Baslat(Owner: TMainFileSearch; fNormally:TNotifyEvent;
      fFileFound: TOnFileFoundEvent;fFileScanned:TNotifyEvent; fReady: TOnReadyEvent;
      fSwc:integer;fScnFileCountChange,fMatchCChange:TNotifyEvent;hndl:THandle);
  end;

  TQueueThread = class(TBMDThread)
  public
    fActive:Boolean;
    fExecute:TNotifyEvent;
    FStyleSwc:integer;
    fList: TList;
    repformid:integer;
    RegExObj:TRegExpr;
    MatchInFileCount:integer; //bulunan kelime sayýsý
    MatchesLinecount:integer; //bulunan satýrlarýn sayýsý
    FQStopAfterFMatchAllFlag:Boolean; //Eðer bir arama durdurma seçeneði çýkmýþsa bunu set edecek.
    qtFileNameOperation,OleIslemiTamamlandi,PDFTamamlandi:Boolean;
    OleIsBaslangici,PDFIsBaslangici:Cardinal;
    ScanFolder,
    ScanFile,fProcessFile,DestinationDir,
    ExtractedWords,
    ExtractedLines:ASCMRString;
    //fDisabled:Boolean;
    ExecType:TExecType;
    ErrMsgLst,SearchFileQueue:TASCMRStringList;//içnde arama yapýlacak dosyalar kuyruðu.
    FWordsList:TList; //aranacak kelimelerin bulunduðu grid link verilecek;
    //Arama yapýlmasý istenilen dosya özelliðine uyan dosyalar bu kuyruða atýlýr
    //sýrasý gelen dosya içinde arama yapýlýr. Eðer dosya içinde kelime bulunursa
    //ana listeye eklenir. Arama yapýlan dosya hemen kuyruktan atýlýr. Sýradakine bakýlýr.
    FRVStyle1: TRVStyle;
    FSearchStartTime:TDateTime;
    FEnabled,FReady,FPaused:Boolean;
    RepFrmFHandle:THandle;
  private
    procedure ExProc(Sender:TObject);
    procedure StartSrv(Sender:TObject);
    procedure SetActive(Value:Boolean);
    procedure MessageReceiver(var msg: TMessage); message ASCThread_MESSAGEB;
  protected
    vSeriNo2:dWord;
    procedure BMDExecute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
  public
    vSeriNo1:dWord;
    mesajalindi:boolean;
    Destructor Destroy;override;
  published
    procedure Baslat(suspended:boolean);
    property Active:Boolean read fActive write SetActive;
  end;

  TMainFileSearch = class(TComponent)
  private
    SearchThread: TFileSearchThread;
    fOnFileFound: TOnFileFoundEvent;
    fOnscnFileCountChange,fOnMatchFileCountChange:TNotifyEvent;
    fOnFileScanned,fOnNormally:TNotifyEvent;
    fOnReady: TOnReadyEvent;
    fPrepared,fPaused: Boolean;
    fStarted: Boolean;
    fMatchedFileCounter:integer;

    procedure OnTerminateEvt(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    function GetScannedPath:ASCMRString;
    function GetScannedFileCounter:integer;
    function GetMatchedFileCounter:integer;
    { Private declarations }
  public
    fScannedFileC:integer;
    RepFrmFHandle:THandle;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Prepare(fStyleSwc:integer);
    procedure Start(Const Lst:TList);
    procedure Pause;
    procedure Stop;
    procedure Resume;
    property Started: Boolean read fStarted;
    property Paused: Boolean read fPaused;
    property ScannedPath:ASCMRString read GetScannedPath;
    property ScannedFileCounter:integer read GetScannedFileCounter;
    property MatchedFileCounter:integer read GetMatchedFileCounter;
    property OnscnFileCountChange:TNotifyEvent read fOnscnFileCountChange write fOnscnFileCountChange;
    property OnMatchFileCountChange:TNotifyEvent read fOnMatchFileCountChange write fOnMatchFileCountChange;
    property OnFileScanned:TNotifyEvent read FOnFileScanned write FOnFileScanned;
    { Private declarations }
  published
    property OnFileFound: TOnFileFoundEvent read fOnFileFound write
      fOnFileFound;
    property OnReady: TOnReadyEvent read fOnReady write fOnReady;
    property OnNormally: TNotifyEvent read fOnNormally write fOnNormally;
    { Published declarations }
  end;

procedure Register;

function ListBirlestir(const lstana,lstek:TASCMRStringList;ciftkontrol:boolean):boolean;

implementation
uses ASCOfisTool;

function ListBirlestir(const lstana,lstek:TASCMRStringList;ciftkontrol:boolean):boolean;
var
   i:integer;
begin
     result:=false;
     if ciftkontrol then
     begin
          for i := 0 to lstek.Count - 1 do
          begin
               if lstana.IndexOf(lstek.Strings[i])<0 then
                  lstana.Add(lstek.Strings[i]);
          end;
     end else
     begin
          for i := 0 to lstek.Count - 1 do
          begin
               lstana.Add(lstek.Strings[i]);
          end;
     end;
     result:=true;
end;
constructor TMainFileSearch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fPrepared:=False;
  fPaused:= false;
end;

destructor TMainFileSearch.Destroy;
begin
  //if fPrepared then
  if Assigned(SearchThread) then
  try
     SearchThread.fStop:=True;
     SearchThread.Stop();
     SearchThread.Free;
     SearchThread:=Nil;
  except
  end;
  fPrepared:=false;
  inherited Destroy;
end;


function TMainFileSearch.GetMatchedFileCounter: integer;
begin
     if fPrepared and started and not paused then
     begin
          Result:=SearchThread.MatchCounter;
          fMatchedFileCounter:=Result;
     end
     else
     Result:=fMatchedFileCounter;
end;

function TMainFileSearch.GetScannedFileCounter: integer;
begin
     if fPrepared then
     Result:=SearchThread.scCounter
     else Result:=0;
end;

function TMainFileSearch.GetScannedPath: ASCMRString;
begin
     if fPrepared then
     Result:=SearchThread.fscPath
     else
     Result:='';
end;

procedure TMainFileSearch.OnTerminateEvt(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
begin
     fStarted:=False;
     fPaused:=False;
     fPrepared:=False;

end;

procedure TMainFileSearch.Start(Const Lst:TList);
begin
     if not fPrepared then exit;
  SearchThread.fStop:=True;
  SearchThread.fList:=Lst;
  fPaused:=False;
  SearchThread.fStop:=False;
  Resume;
end;

procedure TMainFileSearch.Pause;
begin
  if fPrepared then
  if not fPaused then
  begin
    fPaused:= true;
    fMatchedFileCounter:=SearchThread.MatchCounter;
    //SearchThread.fStop:=True;
    //if not SearchThread.Suspended then
    try
       SearchThread.Stop();
    except
    end;
  end;
end;

procedure TMainFileSearch.Prepare(fStyleSwc: integer);
begin
     if fPrepared then
     begin
          try
             SearchThread.Stop;
             SearchThread.Free;
          except
          end;
          SearchThread:=Nil;
          fPrepared:=False;
     end;
     SearchThread:=TFileSearchThread.Create(Self);
     SearchThread.Baslat(Self,fOnNormally,fOnFileFound,fOnFileScanned, fOnReady,
      fStyleSwc,fOnscnFileCountChange,fOnMatchFileCountChange,RepFrmFHandle);
     SearchThread.OnTerminate:=OnTerminateEvt;
     fPrepared:=True;
end;

procedure TMainFileSearch.Resume;
begin
  if fPrepared then
  //if fPaused then
  begin
    fPaused:= false;
    //SearchThread.fStop:=False;
    SearchThread.Start();
  end;
end;

{ TFileSearchThread }

procedure TFileSearchThread.Baslat(Owner: TMainFileSearch; fNormally:TNotifyEvent;
      fFileFound: TOnFileFoundEvent;fFileScanned:TNotifyEvent; fReady: TOnReadyEvent;
      fSwc:integer;fScnFileCountChange,fMatchCChange:TNotifyEvent;Hndl:THandle);
begin
  fStop:=True;
  fscCounter:=0;
  RepFrmFHandle:=Hndl;
  fMatchCounter:=0;
  fscPath:='';
  FList:=nil;
  fFormStyleSwc:=fSwc;
  fOwner:= Owner;
  fOnFileFound:= fFileFound;
  fOnFileScanned:=fFileScanned;
  fOnNormally:=fNormally;
  fscCountChange:=fScnFileCountChange;
  fMatchCountChange:=fMatchCChange;
  fOnReady:= fReady;
  OnExecute := BMDExecute;
  //FreeOnTerminate:= true;
  //Resume;
end;

procedure TQueueThread.Baslat(suspended:boolean);
begin
  mesajalindi:=false;
  FReady:=True;
  FEnabled:=True;
  vSeriNo1:=0;

  FQStopAfterFMatchAllFlag:=false;
  //RegExObj:=TRegExpr.Create(nil);
  ErrMsgLst:=TASCMRStringList.Create;
  SearchFileQueue:=TASCMRStringList.Create;
  ExtractedWords:='';
  ExtractedLines:='';
  //FreeOnTerminate:= false;
  fActive:=False;
  //Resume;
  OnExecute:= BMDExecute;
end;

destructor TQueueThread.Destroy;
begin
     //fDisabled:=True;
     {
     if Assigned(RegExObj) then
     Begin
          RegExObj.Free;
          RegExObj:=nil;
     end;
     }
     if Assigned(ErrMsgLst) then
     Begin
          ErrMsgLst.Free;
          ErrMsgLst:=nil;
     end;
     if Assigned(SearchFileQueue) then
     Begin
          SearchFileQueue.Free;
          SearchFileQueue:=nil;
     end;
     inherited;
end;

procedure TQueueThread.BMDExecute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
label repeat1;
var
   err, //okuma hatasý deðiþkeni
   msji:integer;
   fexcepted:boolean;
   ///matchlist için
   fcntl:TList;
   mtchsr:^TASCMatchSearchRec;
   ThreadMsgTxt:String;///sadece send message için kullanýlacak
   ffileext:ASCMRString;
   vfile:TextFile;
    procedure preparematchlistfile(masj:integer;mtchfilename,srcstr: ASCMRString);
    Var
       linej, //satýr no
       oldlinej, //daha önceki satýr no
       linep, //bulunan satýrýn string içindeki karakte olarak pos nosu
       fcur, //file cursor
       tmpcur, //geçici cursor
       flen,//file length
       oldsrl,//bulunan son kelimenin uzunluðu
       j,k,wstyle,
       LinePFirst,//Ýþlem yapýlan satýrýn baþlangýç pos
       LinePLast,  //Ýþlem yapýlan satýrýn bitiþ pos
       stylej,      //style için geçici döngü deðiþkeni
       lineh,        //ekrana yazýlacak bilginin kaç satýr olduðu tutulacak (bir ifade birden fazla satýrý kaplayabilir)
       linejp        //satýr sayýsý hesabý için kullanýlan deðiþken
       :integer;

       sfpth:ASCMRString;
       styledstr, //grid içine yazýlacak formatlý string
       linestr,    //iþlem yapýlacak satýr
       linestyle  //iþlem yapýlacak satýrýn renk bilgisi
       :ASCMRString;
       StrGrd1:TASCMRStringList;
       thvis:Boolean;
       sr:TASCSearchRec;
       TmpChr:ASCMRChar;
       function getfirstword:TASCSearchRec;
       var
          gfwj,
          gfp, //bulunan en yakýn kelimenin pozisyonu
          igfwj //bulunan en yakýn kelimenin gfwj si
          :integer;
       begin
            Result.p:=0;
            Result.l:=0;
            gfp:=0;
            igfwj:=0;
            for gfwj:=0 to fcntl.Count-1 do
            Begin
                 mtchsr:=fcntl.Items[gfwj];
                 if (mtchsr^.P>fcur) and ((mtchsr^.P<gfp) or (gfp=0)) then
                 Begin
                      wstyle:=mtchsr^.W;
                      gfp:=mtchsr^.P;
                      igfwj:=gfwj;
                 end;
            end;
            if gfp>0 then
            begin
                 mtchsr:=fcntl.Items[igfwj];
                 Result.l:=mtchsr^.L;
                 Result.p:=gfp;
                 Dispose(mtchsr);
                 fcntl.Delete(igfwj);
            end;

       end;

       procedure WriteLineToGrid(wlineno:integer);
       Var
          oldstyleval:ASCMRchar;
          wlj,wlstart,wllen:integer;
       begin
            if LineStyle='' then  exit;

            oldstyleval:=LineStyle[1];
            styledstr:='';
            wlstart:=1;
            wllen:=Length(Linestr);
            for wlj := 2 to wllen  do
            begin
                 if length(LineStyle)<wlj then
                 begin
                      //ShowMessage('Error :length(LineStyle)<'+inttostr(wlj));
                      continue;
                 end;
                 if LineStyle[wlj]<>oldstyleval then
                 begin

                      if oldstyleval=#0 then
                      styledstr:=styledstr+inttostr(clBlack)+','+
                      inttostr(clWhite)+';'+csvPrepareColumnASCMR(copy(linestr,wlstart,wlj-wlstart))+';'
                      else
                      styledstr:=styledstr+inttostr(FRVStyle1.TextStyles.Items[
                      (ord(oldstyleval) mod maxstyle)+1].Color)+','+
                      inttostr(clWhite)+';'+csvPrepareColumnASCMR(copy(linestr,wlstart,wlj-wlstart))+';';
                      oldstyleval:=LineStyle[wlj];
                      wlstart:=wlj;
                 end;
            end;
            if wlstart<=wllen then
            begin
                 if oldstyleval=#0 then
                 styledstr:=styledstr+inttostr(clBlack)+','+
                 inttostr(clWhite)+';'+csvPrepareColumnASCMR(copy(linestr,wlstart,wllen-wlstart+1))+';'
                 else
                 styledstr:=styledstr+inttostr(FRVStyle1.TextStyles.Items[
                 (ord(oldstyleval) mod maxstyle)+1].Color)+','+
                 inttostr(clWhite)+';'+csvPrepareColumnASCMR(copy(linestr,wlstart,wllen-wlstart+1))+';';
            end;
            StrGrd1.Add(inttostr(wlineno)+';'+styledstr);

       end;
    begin
         matcheslinecount:=0;
         StrGrd1:=TASCMRStringList.Create;
         fcur:=0;
         flen:=length(srcstr);
         oldlinej:=-1;
         linej:=-1;
         oldsrl:=0;
         lineh:=1;
         LinePFirst:=1;
         LinePLast:=flen;
         linejp:=0;//satýr sayýsý hesabý için kullanýlan pozisyon deðiþkeni sýfýrlandý
         while fcur<=flen do
         begin
              wstyle:=1;
              sr:=getfirstword;
              if sr.p>0 then//en yakýn kelimeyi bul
              begin
                   if linej<0 then
                      linej:=0;
                   linej:=GetWordCountFPosLeft(srcstr,#13#10,linejp,sr.p,linep,linej);
                   if linej+lineh-1>oldlinej then
                   Begin
                        if oldlinej>-1 then
                        Begin
                             WriteLineToGrid(OldLineJ+1);
                        end;
                        linejp:=linep;
                        lineh:=1;
                        linestr:=GetLineFromPosASCMR(srcstr,sr.P,LinePFirst,LinePLast);
                        linestyle:=SetStrLength('',#0,Length(LineStr),1);
                        {
                           iþlem yapýlan satýr okundu bundan sonra sadece stil bilgisi iþlenmeli
                        }

                        styledstr:='';
                        oldlinej:=linej;
                   end;
                   //bulunan renkli yazýlacak
                   for stylej := sr.P-LinePFirst+1 to sr.P-LinePFirst+sr.L do
                   Begin
                        if Length(LineStyle)<stylej then
                        Begin
                             linestr:=LineStr+#13#10+GetLineFromPosASCMR(srcstr,LinePLast+3,LinePFirst,LinePLast);
                             TmpChr:=#0;
                             if Length(LineStr)<stylej+1 then
                             SetMRStrLengthP(linestyle,TmpChr,stylej+1,1)
                             else
                             SetMRStrLengthP(linestyle,TmpChr,Length(LineStr),1);
                             inc(lineh);
                        end;
                        try
                          {$IF (ASCUniCodeUsing=1)}
                           LineStyle[stylej]:=widechar(chr((wstyle mod maxstyle)+1));
                          {$ELSE}
                           LineStyle[stylej]:=chr((wstyle mod maxstyle)+1);
                          {$IFEND} 
                        except
                           err:=-2;
                        end;
                   end;
                   fcur:=sr.p; //+1
              end else
              Begin
                   if linej>-1 then
                   Begin
                        WriteLineToGrid(LineJ+1);
                   end;
                   break;
              end;
         end;
         matcheslinecount:=StrGrd1.Count;
         if StrGrd1.Count>0 then
         StrGrd1.SaveToFile(TempDir+'matches'+inttostr(repformid)+'_'+DblToText(masj,'NNNNNN')+'.tmp')
         else
         if FileExists(TempDir+'matches'+inttostr(repformid)+'_'+DblToText(masj,'NNNNNN')+'.tmp') then
         SysUtils.DeleteFile(TempDir+'matches'+inttostr(repformid)+'_'+DblToText(masj,'NNNNNN')+'.tmp');

         StrGrd1.Free;
         StrGrd1:=Nil;
    end;

    function ASCSearcText(WordIdx:integer;Var s:ASCMRString;f,submatch,r:ASCMRString;sfpth:ASCMRString;CaseSensitiveSwc,KeepCaseSwc,WordsOnlySwc,
    StopAfterMatchSwc,Replace:Boolean;areainfo,start1,start2,stop1,stop2:integer;
    csvchar:ASCMRString;UseRegEx,SearchStarter,SearchStopper:Boolean;Var S_StartPos,S_StopPos:integer):integer;
    Var
       j,
       RegExObjStart,RegExObjStop,
       tmpi1,tmpi2:integer;
       sv,fstr,news,newtxt,chstr:ASCMRString;
       srclf:File of TASCSearchRec;
       sr:TASCSearchRec;
       srcwithfile:Boolean;
       deletedcols,linenum,currentcol,//csv ile arama iþleminde belirli pozisyona kadar olan
       //bilgi siliniyor onun için bu deðiþkene ihtiyaç duyuldu.
       tmpp1, tmpp2,tmpp3, ///extract lines için kullanýldý
       extlineendp  //cikartilan satirin son karakter pozisyonu
       :integer;
       lastlinestr:ASCMRString; //bilgi kesilmesi durumunda yarýda kalan bir satýr olma ihtimali için
       //son satýr hafýzaya alýnýr.
         lastlinestart,lastlineend:integer;

       //areainfo:bilgi arama konum seçenekleri 0:normal,1:dosya baþýndan itibaren baþlangýç start1,
       //karakter sayýsý stop1;2:Satýr numarasý olarak start1 ve stop 1;
       //3:sutun olarak start1,uzunluk stop1;
       //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
       //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
       //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
       //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
       //,start1,start2,stop1,stop2
       SearchPos,//arama pozisyonu
       CutterPos, //arama sonucunda kesme noktalarý
       startstoppos,startstopposb:TPoint;

       fnextsearch:boolean;
       procedure CutChars(cuti:integer);
       begin
            if Replace then
               news:=news+Copy(s,1,cuti);
            if ((lastlinestr='') or (lastlineend=0) or (lastlineend<cuti)) then
            begin
                 if lastlineend>cuti then
                 dec(lastlineend,cuti)
                 else
                 lastlineend:=0;
                 if (extlineendp>cuti) then
                 dec(extlineendp,cuti)
                 else
                 begin
                      extlineendp:=0;
                      lastlinestr:=GetLineFromPosASCMR(s,cuti+sr.P,lastlinestart,lastlineend);
                      if (sr.P>0) and (lastlineend>0) then
                      begin
                           dec(lastlinestart,sr.P);
                           dec(lastlineend,sr.P);
                      end;
                      if lastlineend>cuti then dec(lastlineend,cuti) else
                      begin
                           lastlinestr:='';
                           lastlineend:=0;
                      end;
                 end;
            end else
            begin
                 if (lastlineend>0) then dec(lastlineend,cuti);
            end;
            Delete(sv,1,cuti);
            sr.P:=sr.P+cuti;
       end;

    begin
         extlineendp:=0;
         lastlinestr:='';
         lastlinestart:=0;
         lastlineend:=0;
         Result:=0;
         deletedcols:=0;
         currentcol:=1;
         if submatch<>'' then
         Begin
              newtxt:=f;
              ASCSearcText(-1,newtxt,submatch,'',r,'',CaseSensitiveSwc,KeepCaseSwc,False,False,True,
              0,0,0,0,0,';',(ASCUniCodeUsing=1),False,False,tmpi1,tmpi2);
         End else newtxt:=r;

         if sfpth<>'' then
         Begin
              AssignFile(srclf,sfpth);
              {$I-}Rewrite(srclf);{$I+}
              if ioresult<>0 then exit;
              srcwithfile:=True;
         End else srcwithfile:=False;

         if CaseSensitiveSwc then
         Begin
              sv:=s;
              fstr:=f;
         end else
         Begin
              {$IF (ASCUniCodeUsing=1)}
              sv:=Tnt_WideUpperCase(s);
              fstr:=Tnt_WideUpperCase(f);
              {$ELSE}
              sv:=AnsiUpperCase(s);
              fstr:=AnsiUpperCase(f);
              {$IFEND}
         end;
         sr.L:=Length(fstr);
         sr.P:=0;
         news:='';

         linenum:=1; //sutuna göre arama yapmak için aranacak satýr sýfýrlandý
         startstoppos.x:=0;
         startstoppos.y:=0;
         startstopposb.x:=0;
         startstopposb.y:=0;
         CutterPos.x:=0;
         CutterPos.y:=0;
         SearchPos.x:=1;
         SearchPos.y:=Length(sv);
         Case areainfo of
              1://dosya baþýndan itibaren baþlangýç start1,
                 //karakter sayýsý stop1
              begin
                   if (start1<SearchPos.y) and (start1>0) then
                   SearchPos.x:=start1;
                   if (start1+stop1<SearchPos.y) and (stop1>0) then
                   SearchPos.y:=start1+stop1;
                   if (S_StartPos>-1) and (S_StartPos>SearchPos.x) then SearchPos.x:=S_StartPos;
                   if (S_StopPos>-1) and (S_StopPos<SearchPos.y) then SearchPos.y:=S_StopPos;
                   if SearchPos.y<SearchPos.x then SearchPos.y:=SearchPos.x;


              end;
              2://2:Satýr numarasý olarak start1 ve stop 1
              begin
                   SearchPos:=GetLinePos(sv,start1,stop1);


              end;
              4,7://satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
              begin
                   linenum:=start1;
              end;
         end;
         if SearchPos.x>1 then
         begin
              CutChars(SearchPos.x-1);
              Dec(SearchPos.y,SearchPos.x-1);
              SearchPos.x:=1;

         end;

         j:=0;
         fnextsearch:=true;

         if UseRegEx then
         begin
              RegExObj.ModifierI:=not CaseSensitiveSwc;
              RegExObj.Expression:=fstr;
              RegExObj.InputString:=sv;
              //RegExObj.Replacement:=r;
              RegExObjStart:=0;
              RegExObjStop:=length(sv);
         end;



         if sr.L>0 then
         while sv<>'' do
         Begin
              if (areainfo in [3,4,5,6,7]) then
              begin
                   if fnextsearch then
                   begin
                        fnextsearch:=false;
                        j:=0;
                        case areainfo of
                             3://sutun olarak start1,uzunluk stop1;
                             begin
                                  startstoppos:=GetNextLinePos(sv,startstoppos.y);
                                  if (startstoppos.x<=0) then
                                  begin
                                       //aramayý bitir
                                       if Replace then
                                       news:=news+s;
                                       break;
                                  end;
                                  inc(linenum);
                                  if startstoppos.y-startstoppos.x<1 then
                                  begin
                                       if linenum>stop1 then
                                       begin
                                            //aramayý bitir
                                            if Replace then
                                            news:=news+s;
                                            break;
                                       end;
                                       fnextsearch:=True;
                                       continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                                  end;
                                  CutterPos.x:=StartStopPos.x;
                                  CutterPos.y:=StartStopPos.y;
                                  if (startstoppos.y-startstoppos.x)>start1+stop1 then
                                     startstoppos.y:=startstoppos.x+start1+stop1-2;
                                  startstoppos.x:=startstoppos.x+start1-1;
                                  SearchPos:=startstoppos;
                             end;

                             4://satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý
                             //start2,karakter sayýsý stop2;
                             begin
                                  if linenum=start1 then
                                  startstoppos:=GetLinePos(sv,linenum,linenum)
                                  else
                                  startstoppos:=GetNextLinePos(sv,startstoppos.y);
                                  if (startstoppos.x=0) then
                                  begin
                                       //aramayý bitir
                                       if Replace then
                                       news:=news+s;
                                       break;
                                  end;
                                  if linenum>stop1 then
                                  begin
                                       //aramayý bitir
                                       if Replace then
                                       news:=news+s;
                                       break;
                                  end;
                                  inc(linenum);
                                  if startstoppos.y-startstoppos.x<start2 then
                                  begin
                                       fnextsearch:=True;
                                       continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                                  end;
                                  CutterPos.x:=StartStopPos.x;
                                  CutterPos.y:=StartStopPos.y;
                                  if (startstoppos.y-startstoppos.x)>start2+stop2-1 then    //BURADA SUTUN KOORDÝANSYONU YAPILIYOR
                                     startstoppos.y:=startstoppos.x+start2+stop2-2;
                                  startstoppos.x:=startstoppos.x+start2-1;
                                  SearchPos:=startstoppos;
                             end;
                             5://csv ile ayrýlmýþ dosyada start1 kolonunda ara
                             begin
                                  startstoppos:=GetNextLinePos(sv,startstoppos.y);
                                  if (startstoppos.x=0) then
                                  begin
                                       //aramayý bitir
                                       if Replace then
                                       news:=news+s;
                                       break;
                                  end;
                                  inc(linenum);
                                  CutterPos.x:=StartStopPos.x;
                                  CutterPos.y:=StartStopPos.y;
                                  startstopposb:=GetxsvPosB_MR(sv,csvchar[1],Start1,startstoppos.x,startstoppos.y);
                                  //x=y oluyor
                                  if startstopposb.y-startstopposb.x<0 then
                                  begin
                                       fnextsearch:=True;
                                       continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                                  end;
                                  SearchPos:=startstopposb;
                             end;
                             6://csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
                             begin
                                  if startstopposb.x=0 then
                                  begin
                                       startstoppos:=GetNextLinePos(sv,0);
                                       if (startstoppos.x=0) then //aramayý bitir
                                       begin
                                            //aramayý bitir
                                            if Replace then
                                            news:=news+s;
                                            break;
                                       end;
                                       inc(linenum);
                                       currentcol:=Start1;
                                       CutterPos.x:=StartStopPos.x;
                                       CutterPos.y:=StartStopPos.y;
                                  end;
                                  if currentcol>Stop1 then
                                  begin
                                       startstopposb.x:=0;
                                       startstopposb.y:=0;
                                       fnextsearch:=True;

                                       CutChars(CutterPos.y);

                                       continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                                  end;
                                  if currentcol>start1 then
                                  startstopposb:=GetxsvPosB_MR(sv,csvchar[1],1,startstoppos.x,startstoppos.y)
                                  else
                                  startstopposb:=GetxsvPosB_MR(sv,csvchar[1],currentcol,startstoppos.x,startstoppos.y);
                                  currentcol:=currentcol+1;
                                  if startstopposb.y-startstopposb.x<0 then
                                  begin
                                       startstopposb.x:=0;
                                       startstopposb.y:=0;
                                       fnextsearch:=True;
                                       CutChars(CutterPos.y);
                                       continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                                  end;
                                  SearchPos:=startstopposb;
                             end;
                             7://csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
                             begin
                                  if startstopposb.x=0 then
                                  begin
                                       if linenum>stop1 then
                                       begin
                                            //aramayý bitir
                                            if Replace then
                                            news:=news+s;
                                            break;
                                       end;
                                       if linenum=start1 then
                                       begin
                                            startstoppos:=GetLinePos(sv,linenum,linenum);
                                            if startstoppos.x>1 then
                                            begin
                                                 CutChars(startstoppos.x-1);
                                                 startstoppos.y:=startstoppos.y-startstoppos.x+1;
                                                 startstoppos.x:=1;
                                            end;
                                       end
                                       else
                                       startstoppos:=GetNextLinePos(sv,0);
                                       inc(linenum);
                                       currentcol:=Start2;
                                       CutterPos.x:=StartStopPos.x;
                                       CutterPos.y:=StartStopPos.y;
                                       if (startstoppos.x=0) then
                                       begin
                                            //aramayý bitir
                                            if Replace then
                                            news:=news+s;
                                            break;
                                       end;
                                  end;
                                  if currentcol>Stop2 then
                                  begin
                                       startstopposb.x:=0;
                                       startstopposb.y:=0;
                                       fnextsearch:=True;

                                       CutChars(CutterPos.y);

                                       continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                                  end;
                                  if currentcol>start2 then
                                  startstopposb:=GetxsvPosB_MR(sv,csvchar[1],1,startstoppos.x,startstoppos.y)
                                  else
                                  startstopposb:=GetxsvPosB_MR(sv,csvchar[1],currentcol,startstoppos.x,startstoppos.y);
                                  currentcol:=currentcol+1;
                                  if startstopposb.y-startstopposb.x<0 then
                                  begin
                                       startstopposb.x:=0;
                                       startstopposb.y:=0;
                                       fnextsearch:=True;
                                       CutChars(CutterPos.y);
                                       continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                                  end;
                                  SearchPos:=startstopposb;
                             end;
                        end;
                        if SearchPos.x>1 then
                        begin
                             CutChars(SearchPos.X-1);
                             Dec(SearchPos.y,SearchPos.x-1);
                             if startstopposb.x>1 then Dec(startstopposb.x,SearchPos.x-1);
                             if startstopposb.y>1 then Dec(startstopposb.y,SearchPos.x-1);

                             if startstoppos.x>1 then Dec(startstoppos.x,SearchPos.x-1);
                             if startstoppos.y>1 then Dec(startstoppos.y,SearchPos.x-1);

                             if CutterPos.x>1 then
                             begin
                                  Dec(CutterPos.x,SearchPos.x-1);
                                  if CutterPos.x<1 then CutterPos.x:=1;
                             end;
                             if CutterPos.y>1 then
                             begin
                                  Dec(CutterPos.y,SearchPos.x-1);
                                  if CutterPos.y<1 then CutterPos.y:=1;
                             end;

                             SearchPos.x:=1;
                        end;
                   end;

              end;
              //27 aðustos2009 normal arama ile regexarama birleþti.burada seçim yapýlýyor.
              if UseRegEx then
              begin

                   {if svarCurCell=f then
                   begin
                        j:=1;
                        sr.l:=SearchPos.y;
                   end else
                   begin
                   }
                        RegExObj.InputString:=sv;
                        RegExObjStart:=0;
                        RegExObjStop:=SearchPos.y+1;
                        try
                           //RegExObj.Compile;
                           if not RegExObj.ExecPos(RegExObjStart+1) then
                           begin
                             j:=0;
                           end else
                           begin
                             j:=RegExObj.MatchPos[0];
                             sr.l:=RegExObj.MatchLen[0];
                           end;
                        except
                           j:=-1;
                        end;
                   //end;
              end
              else
              begin

                   {if svarCurCell=f then
                   begin
                        j:=1;
                        sr.l:=SearchPos.y;
                   end else
                   begin
                   }    j:=AnsiPos(fstr,sv);
                        if j=0 then
                        j:=Pos(fstr,sv);
                   //end;
              end;
              if (j>0) or ((j=0) and UseRegEx and (Areainfo>0)) then
              Begin
                   if (j>0) then
                   begin
                        if sr.L>0 then
                           ExtractedWords:=ExtractedWords+copy(s,j+sr.P,sr.l)+#13#10;
                        if j>extlineendp then
                        begin

                             if (lastlinestr<>'') and (lastlineend>j) then
                             begin
                                  ExtractedLines:=ExtractedLines+lastlinestr+#13#10;
                                  extlineendp :=lastlineend-j;
                                  lastlinestr:='';
                                  lastlineend:=0;
                                  lastlinestart:=0;
                             end else
                             begin
                                  tmpp3:=j;
                                  tmpp2:=0;

                                  while tmpp2<j+sr.L do
                                  begin
                                       ExtractedLines:=ExtractedLines+GetLineFromPosASCMR(s,tmpp3+sr.P,tmpp1,tmpp2)+#13#10;
                                       if (sr.P>0) and (tmpp2>0) then
                                       begin
                                            dec(tmpp2,sr.P);
                                            dec(tmpp1,sr.P);
                                       end;
                                       tmpp3:=tmpp2+1;
                                  end;
                                  extlineendp:=tmpp3;
                             end;
                        end;
                   end;
                   if Areainfo>0 then
                   if (j+sr.L-1>SearchPos.y) or (UseRegEx and (j=0))
                      or
                      (
                           ///Search Starter kontrolleri
                           (S_StartPos>0) and (sr.P+j<S_StartPos)
                      )
                      or
                      (
                           ///Search Starter kontrolleri
                           (S_StopPos>0) and (sr.P+j>S_StopPos)
                      )
                   then
                   begin
                        Case AreaInfo of
                             1,2:
                             begin
                                  if Replace then
                                  news:=news+s;
                                  break;
                             end;
                        end;
                        if (S_StopPos>0) and (sr.P+j>S_StopPos) then
                        begin
                             if Replace then
                             news:=news+s;
                             break;
                        end;


                        if AreaInfo in [6,7] then
                        begin

                        end else
                        begin
                             if CutterPos.y>SearchPos.y then SearchPos.y:=CutterPos.y;
                        end;
                        CutChars(SearchPos.y);
                        if CutterPos.x>0 then
                        begin
                             if CutterPos.x>SearchPos.y then
                             Dec(CutterPos.x,SearchPos.y)
                             else
                             CutterPos.x:=1;
                        end;
                        if CutterPos.y>0 then
                        begin
                             if CutterPos.y>SearchPos.y then
                             Dec(CutterPos.y,SearchPos.y)
                             else
                             CutterPos.y:=1;
                        end;

                        if startstopposb.x>0 then
                        begin
                             if startstopposb.x>SearchPos.y then
                             Dec(startstopposb.x,SearchPos.y)
                             else
                             startstopposb.x:=1;
                        end;
                        if startstopposb.y>0 then
                        begin
                             if startstopposb.y>SearchPos.y then
                             Dec(startstopposb.y,SearchPos.y)
                             else
                             startstopposb.y:=1;
                        end;

                        if startstoppos.x>0 then
                        begin
                             if startstoppos.x>SearchPos.y then
                             Dec(startstoppos.x,SearchPos.y)
                             else
                             startstoppos.x:=1;
                        end;
                        if startstoppos.y>0 then
                        begin
                             if startstoppos.y>SearchPos.y then
                             Dec(startstoppos.y,SearchPos.y)
                             else
                             startstoppos.y:=0;
                        end;
                        SearchPos.y:=Length(sv);
                        SearchPos.x:=1;

                        fnextsearch:=True;
                        continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön

                   end;

                        ///Search Stopper kontrolleri
                   if (S_StopPos>0) and (sr.P+j>S_StopPos) then
                   begin
                        if Replace then
                        news:=news+s;
                        break;
                   end;

                   ///Search Starter kontrolleri
                   if (S_StartPos>0) and (sr.P+j<S_StartPos) then
                   begin
                        if Replace then
                        news:=news+Copy(s,1,j);

                        if (lastlineend>j) then
                        dec(lastlineend,j)
                        else
                        lastlineend:=0;

                        if (extlineendp>j) then
                        dec(extlineendp,j)
                        else
                        extlineendp:=0;

                        Delete(sv,1,j);
                        sr.P:=sr.P+j;
                        Continue;
                   end;


                   if WordsOnlySwc then
                   Begin
                        if j>1 then chstr:=copy(sv,j-1,1) else chstr:='';
                        chstr:=chstr+copy(sv,j+sr.L,1);

                        chstr:=TextFilter(appdefaultsrec.WordsOnlyChars,chstr);
                        if chstr<>'' then
                        Begin
                             if Replace then
                                news:=news+Copy(s,1,j);

                             if (lastlineend>j) then
                             dec(lastlineend,j)
                             else
                             lastlineend:=0;

                             if (extlineendp>j) then
                             dec(extlineendp,j)
                             else
                             extlineendp:=0;

                             Delete(sv,1,j);
                             sr.P:=sr.P+j;
                             Continue;
                        end;
                   end;

                   if Replace then
                   Begin
                        news:=news+Copy(s,1,j-1)+newtxt;
                   end;


                   if (lastlineend>j+sr.L-1) then
                   dec(lastlineend,(j+sr.L-1))
                   else
                   lastlineend:=0;

                   if (extlineendp>j+sr.L-1) then
                   dec(extlineendp,(j+sr.L-1))
                   else
                   extlineendp:=0;
                   sr.P:=sr.P+j;

                   if srcwithfile and (sr.L>0) then
                   Begin
                        write(srclf,sr);
                        ///add to match list
                        new(mtchsr);
                        mtchsr^.W:=WordIdx;
                        mtchsr^.P:=sr.P;
                        mtchsr^.L:=sr.L;
                        fcntl.Add(mtchsr);
                   end;

                   if SearchStarter then
                   begin
                        S_StartPos:=sr.P;
                   end else
                   if SearchStopper then
                   begin
                        S_StopPos:=sr.P;
                   end;

                   Delete(sv,1,j+sr.L-1);

                   if (startstopposb.x>1) then
                   begin
                        if (startstopposb.x>j+sr.L-1) then Dec(startstopposb.x,j+sr.L-1)
                        else
                        startstopposb.x:=1;
                   end;
                   if (startstopposb.y>1) then
                   begin
                        if (startstopposb.y>j+sr.L-1) then Dec(startstopposb.y,j+sr.L-1)
                        else
                        startstopposb.y:=1;
                   end;
                   if (startstoppos.x>0) then
                   begin
                        if (startstoppos.x>j+sr.L-1) then Dec(startstoppos.x,j+sr.L-1)
                        else
                        startstoppos.x:=0;
                   end;
                   if (startstoppos.y>0) then
                   begin
                        if (startstoppos.y>j+sr.L-1) then Dec(startstoppos.y,j+sr.L-1)
                        else
                        startstoppos.y:=0;
                   end;
                   if (SearchPos.x>1) then
                   begin
                        if (SearchPos.x>j+sr.L-1) then Dec(SearchPos.x,j+sr.L-1)
                        else
                        SearchPos.x:=1;
                   end;
                   if (SearchPos.y>1) then
                   begin
                        if (SearchPos.y>j+sr.L-1) then Dec(SearchPos.y,j+sr.L-1)
                        else
                        SearchPos.y:=1;
                   end;
                   if (CutterPos.x>1) then
                   begin
                        if (CutterPos.x>j+sr.L-1) then Dec(CutterPos.x,j+sr.L-1)
                        else
                        CutterPos.x:=1;
                   end;
                   if (CutterPos.y>1) then
                   begin
                        if (CutterPos.y>j+sr.L-1) then Dec(CutterPos.y,j+sr.L-1)
                        else
                        CutterPos.y:=1;
                   end;


                   if sr.l>0 then
                   begin
                        sr.P:=sr.P+sr.L-1;
                        Result:=Result+1;
                   end;
                   if StopAfterMatchSwc or SearchStarter or SearchStopper  then
                   begin
                        if Replace then
                           news:=news+s;
                        Break;
                   end;
              end else
              Begin
                   if Replace then
                      news:=news+s;
                   break;
              end;
         end;
         if srcwithfile then closeFile(srclf);
         if Replace then
            s:=news;
    end;

    {$IF (ASCUniCodeUsing=1)}
    function ReadFileData(radfn:TFileName;Var s:ASCMRString):integer;
    var
       ls:TASCMRStringList;
       EFM:Byte;
    begin
         EFM:=FileMode;
         try
         FileMode:=fmOpenRead;
         ls:=TASCMRStringList.Create;
         ls.LoadFromFile(radfn);
         s:=ls.Text;
         ls.Free;
         ls:=nil;
         except
            s:='';
         end;
         result:=length(s);
         FileMode:=EFM;
    end;
    {$ELSE}
    function ReadFileData(radfn:TFileName;Var s:ASCMRString):integer;
    Var
       filedata:File;
       d:Array [1..MaxMRChar] of ASCMRChar;
       c,r,ts:integer;
       EFM:Byte;
    begin
         Result:=0;
         if qtFileNameOperation then
         begin
              s:=ExtractFileName(radfn);
              Result:=Length(s);
              exit;
         end;
         s:='';
         EFM:=FileMode;
         try
            FileMode:=fmOpenRead;
            AssignFile(filedata,radfn);
            {$I-}Reset(filedata,1);{$I+}
            if IOResult<>0 then
            begin
                 err:=-1;
                 FileMode:=EFM;
                 exit;
            end;
            ts:=FileSize(fileData);
            if (appdefaultsrec.GenMaxFileSize>0) and (ts>1048576*appdefaultsrec.GenMaxFileSize) then
            begin
                 closeFile(filedata);
                 err:=-2;
                 exit;
            end;
            while ts>0 do
            begin
                 r:=0;
                 if ts>MaxMRChar then c:=MaxMRChar else c:=ts;
                 blockread(filedata,d,c,r);
                 sleep(0);
                 if r>0 then
                 begin
                      dec(ts,r);
                      ExecType:=ext_ReadingFile;
                      if Thread.Terminated then
                      begin
                           closeFile(filedata);
                           FileMode:=EFM;
                           exit;
                      end;
                      //Thread.Synchronize(ExProc);
                      ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
                      SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
                 end else
                 begin
                      break;
                 end;
                 s:=s+copy(d,1,r);
            end;
            Result:=Length(s);
            closeFile(filedata);
         except
         end;
         FileMode:=EFM;
    end;
    {$IFEND}
    procedure SearchInFile(forjname,fprcssname:ASCMRString);
    label
         matchlistclear;
    Var
       sfpth,srcdir,destdir,maskstr:ASCMRString;f,smatch,r:ASCMRString;
       ferr,caseswc,KeepCase,RegExSwc:Boolean;
       b:int64;
       fwc,j,k,l:Integer;
       filedatastr
       :ASCMRString;

       p:PSrcFileSelRec;
       pWObj,pWObjB:PWordObj;

       ItemsSwitchs:Array of boolean;   //bu dizinin elemanlarý iþlem yapýlmýþ elemanlarýn bilinmesini saðlayacak
       grno,grcount:integer;
       Groups:Array of TMRWordGroup;
       reqj,reqk,Gr_j: Integer;

       //Standart variable deðiþkenleri
       vTargetText,vSearchText,vSubMatchText,vReplaceText:ASCMRString;
       svfname,svfnnoex,svfex,svfdir,
       svfmyear,svfmmonth,svfmday
       :ASCMRString;
       svfmdate:Double;
       svfmyear2,svfmmonth2,svfmday2:word;
       svfsize:int64;
       //////////////

       procedure ApplyStandartVariable;
       var
          svfname,svfnnoex,svfex,svfdir,
          svfmyear,svfmmonth,svfmday
          :ASCMRString;
          svfmdate:TDateTime;
          svCurYear,svCurMonth,svCurDay,svfmyear2,svfmmonth2,svfmday2:word;
          svfsize:int64;
       begin
               ////Standart deðiþkenler dikkate alýnýyor
               if Pos(svarPatern,vTargetText)>0 then
               Begin
                    ExtractFileItems(forjname,svfname,svfnnoex,svfex,svfdir);
                    svfsize:=GetFileSize(forjname);
                    if not DSiGetModifyDate(forjname,svfmdate) then
                       svfmdate:=0;
                    DecodeDate(svfmdate,svfmyear2,svfmmonth2,svfmday2);
                    svfmyear:=DblToText(svfmyear2,'NNNN');
                    svfmmonth:=DblToText(svfmmonth2,'NN');
                    svfmday:=DblToText(svfmday2,'NN');
                    ReplaceTextP_MR(vTargetText,svarPFN,forjname);
                    ReplaceTextP_MR(vTargetText,svarFileNameWithExt,svfname);
                    ReplaceTextP_MR(vTargetText,svarFileDir,svfdir);
                    ReplaceTextP_MR(vTargetText,svarFileNameNoExt,svfnnoex);
                    ReplaceTextP_MR(vTargetText,svarFEX,svfex);
                    ReplaceTextP_MR(vTargetText,svarFileSIZE,inttostr(svfsize));
                    ReplaceTextP_MR(vTargetText,svarFMDATE,DateToStr(svfmdate));
                    ReplaceTextP_MR(vTargetText,svarFMYEAR,svfmyear);
                    ReplaceTextP_MR(vTargetText,svarFMMONTH,svfmmonth);
                    ReplaceTextP_MR(vTargetText,svarFMDAY,svfmday);
                    ReplaceTextP_MR(vTargetText,svarCurDATE,DateToStr(FSearchStartTime));
                    DecodeDate(date,svCurYear,svCurMonth,svCurDay);
                    ReplaceTextP_MR(vTargetText,svarCurYEAR,inttostr(svCuryear));
                    ReplaceTextP_MR(vTargetText,svarCurMONTH,SetStrLength(inttostr(svCurmonth),'0',2,0));
                    ReplaceTextP_MR(vTargetText,svarCurDAY,SetStrLength(inttostr(svCurDay),'0',2,0));
                    ReplaceTextP_MR(vTargetText,svarCurTime,TimeToStr(FSearchStartTime));

               end;
               ////////////

       end;

       procedure cokluislemci(ino:integer);
       var
          k,j:integer;
          hdd,lsn,trh:ASCMRString;
          gtmr:cardinal;
          r:integer;
       begin

            {$IF (DemoVersiyon=0)}
            {
            if vSeriNo1=0 then
            begin
                 if Thread.Terminated then  exit;

                 //Thread.Synchronize(StartSrv);
                 ThreadMsgTxt := 'bilgisayaroku;;';
                 SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
                 sleep(0);
                 gtmr:=GetTickCount;
                 while True do
                 begin
                      if (vSeriNo1<>0) or (gtmr+1000<GetTickCount) then break;
                      sleep(2);
                 end;
            end;
            }
            if vSeriNo1=0 then exit;

            if Thread.Terminated then  exit;
            r:=ino;
            lsn:=inttostr(strtoint('$'+RegSeriNo));
            hdd:=inttostr(vSeriNo1);
            trh:=ascdatestr(RegTarih);

            case lsn[2] of
                 '0':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+1]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+7]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+10]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+8]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[3]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[8]));
                 end;
                 '1':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+8]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[6]) mod 9)+10]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[1]) mod 9)+17]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+4]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[1]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[6]));
                 end;
                 '2':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+1]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+13]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+9]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+11]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[5]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[10]));
                 end;
                 '3':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+5]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+22]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+13]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+13]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[2]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[9]));
                 end;
                 '4':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+11]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+25]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+17]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+24]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[4]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[11]));
                 end;
                 '5':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+16]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+13]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+23]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+12]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[6]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[12]));
                 end;
                 '6':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+13]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+14]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+27]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+27]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[7]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[11]));
                 end;
                 '7':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+21]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+18]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+21]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+25]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[2]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[8]));
                 end;
                 '8':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+25]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+20]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+19]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+23]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[1]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[9]));
                 end;
                 '9':
                 begin
                      r:=r-(((strtoint(OzelKodlar[(strtoint(lsn[2]) mod 9)+19]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[5]) mod 9)+2]) mod 9)+9)+
                      ((strtoint(OzelKodlar[(strtoint(lsn[4]) mod 9)+3]) mod 9)+1)+((strtoint(OzelKodlar[(strtoint(lsn[3]) mod 9)+15]) mod 9)+1)+
                      ((strtoint(RegKeyVal1[(strtoint(lsn[3]) mod 9)+1]) mod 9)+1)+ord(uygulamaadi[8]));
                 end;

            end;


            case lsn[3] of
                 '0':
                 begin
                      r:=r-(((strtoint(hdd[4]) mod 6)+1)*((strtoint(lsn[3]) mod 8)+1)+strtoint(lsn[6])+strtoint(trh[3]));
                 end;
                 '1':
                 begin
                      r:=r-(((strtoint(hdd[3]) mod 7)+1)*((strtoint(trh[2]) mod 5)+1)+((strtoint(lsn[5]) mod 3)+1)*((strtoint(lsn[2]) mod 9)+1));
                 end;
                 '2':
                 begin
                      r:=r-(strtoint(lsn[2])+((strtoint(trh[4]) mod 7)+1)*((strtoint(hdd[1]) mod 9)+1)+strtoint(lsn[6])+strtoint(trh[2]));
                 end;
                 '3':
                 begin
                      r:=r-(((strtoint(hdd[5]) mod 6)+1)*((strtoint(lsn[1]) mod 9)+1)+strtoint(lsn[4])+strtoint(trh[1]));
                 end;
                 '4':
                 begin
                      r:=r-(strtoint(trh[2])+strtoint(lsn[5])+((strtoint(lsn[6])  mod 10)+1)+((strtoint(hdd[1]) mod 10)+1));
                 end;
                 '5':
                 begin
                      r:=r-(((strtoint(hdd[5]) mod 7)+1)*((strtoint(trh[5]) mod 10)+1)+strtoint(lsn[2])+strtoint(trh[1]));
                 end;
                 '6':
                 begin
                      r:=r-(strtoint(lsn[4])+strtoint(trh[1])+strtoint(lsn[4])+((strtoint(lsn[2]) mod 4)+1)*((strtoint(trh[1])+strtoint(trh[2]) mod 4)+1));
                 end;
                 '7':
                 begin
                      r:=r-(strtoint(hdd[5])*strtoint(lsn[1])+((strtoint(lsn[4]) mod 4)+1)*((strtoint(lsn[2])+strtoint(trh[3]) mod 4)+1)+strtoint(trh[2]));
                 end;
                 '8':
                 begin
                      r:=r-(+strtoint(trh[2])+strtoint(hdd[4])+((strtoint(lsn[4]) mod 6)+1)*((strtoint(trh[1])+strtoint(trh[2]) mod 9)+1));
                 end;
                 '9':
                 begin
                      r:=r-(((strtoint(hdd[5]) mod 10)+1)*((strtoint(lsn[1]) mod 9)+1)+((strtoint(lsn[4]) mod 10)+1)+((strtoint(trh[1]) mod 10)+1));
                 end;
            end;


            r:=r-(((strtoint(hdd[2]) mod 10)+1)*((strtoint(lsn[2]) mod 9)+1)+((strtoint(lsn[3]) mod 10)+1)+((strtoint(trh[2]) mod 10)+1));
            r:=r-(((strtoint(hdd[4]) mod 10)+1)+((strtoint(lsn[5]) mod 9)+1)+((strtoint(trh[3]) mod 10)+1)+((strtoint(trh[4]) mod 10)+1));
            r:=r-(((strtoint(hdd[1]) mod 10)+1)*((strtoint(lsn[6]) mod 9)+1)+((strtoint(hdd[3]) mod 10)+1)+((strtoint(hdd[5]) mod 10)+1));






            {$ELSE}
            r:=clcdegerleri[ino];
            {$IFEND}

            case r of
                 7:
                 begin
                      err:=0;
                      if Thread.Terminated or not fActive then
                      begin
                           err:=-1;
                           exit;
                      end;
                      if err<0 then exit;
                      try
                         ReadFileData(fprcssname,filedatastr);
                      except
                         err:=-1;
                      end;
                 end;
                 13:
                 begin
                      if Thread.Terminated or not fActive then
                      begin
                           err:=-1;
                           exit;
                      end;
                      if err<0 then exit;
                      ////gruplama iþlemi1
                      grno:=-1;
                      grcount:=0;
                      SetLength(Groups,0);
                      SetLength(ItemsSwitchs,FWordsList.Count);
                      For k:=0 to FWordsList.Count-1 do
                      ItemsSwitchs[k]:=False;
                 end;
                 27:
                 begin
                      MatchInFileCount:=0; //bu dosyada henüz kelime bulunmadý
                      fcntl:=TList.Create;
                      if err<0 then exit;
                 end;
                 33:
                 begin
                      if Thread.Terminated or not fActive then
                      begin
                           err:=-1;
                           exit;
                      end;

                      if (err<0) and (err<>-2{Genel maxfilesize sýnýrýna uygun deðilse}) then
                      begin
                           ErrMsgLst.Add('Can not reading file "'+forjname+'".');
                           ExecType:=ext_ErrFile;

                           //Thread.Synchronize(ExProc);
                           ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
                           SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
                           sleep(0);
                           exit;
                      end;
                 end;
                 37:
                 begin
                      if Thread.Terminated or not fActive then err:=-1;
                      if err<0 then exit;
                        ////gruplama iþlemi2
                      For k:=1 to FWordsList.Count do
                      Begin
                           if ItemsSwitchs[k-1] then Continue; //iþlenmiþ elemanlarý geç
                           pWObj:=FWordsList.Items[k-1];
                           grcount:=grcount+1;
                           SetLength(Groups,grcount);
                           grno:=pWObj^.GroupNumber;
                           Groups[grcount-1].GrpNo:=grno;

                           if FWordsList.Count>k then
                           for j := k+1 to FWordsList.Count do
                           begin
                                pWObjB:=FWordsList.Items[j-1];
                                if pWObjB^.GroupNumber=grno then
                                ItemsSwitchs[j-1]:=True;
                           end;
                      end;

                 end;
            end;
       end;

       procedure SleepForActive;
       begin
            while not FACtive Do
            Begin
                 ExecType:=ext_Normally;
                 if Thread.Terminated then exit;
                 //Thread.Synchronize(ExProc);
                 ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
                 SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
                 sleep(2);
            end;
       end;
       procedure CokluCalistirici(i: integer);
       var
          j,k,v:integer;
          s,s2:ASCMRString;
       begin
            {$IF (DemoVersiyon=0)}
            for j := 0 to MainScrTextA.Count - 1 do
            begin
                 s:=MainScrTextA.Strings[j];
                 if Pos(inttostr(i)+',',s)=1 then
                 begin
                      for k := 2 to 1000 do
                      begin
                           s2:=xsvData(s,',',k);
                           if s2<>'' then
                           begin
                                v:=TextToInt(s2);
                                cokluislemci(v);
                           end else break;
                      end;
                 end;
            end;
            for j := 0 to MainScrTextB.Count - 1 do
            begin
                 s:=MainScrTextB.Strings[j];
                 if Pos(inttostr(i)+',',s)=1 then
                 begin
                      for k := 2 to 1000 do
                      begin
                           s2:=xsvData(s,',',k);
                           if s2<>'' then
                           begin
                                v:=TextToInt(s2);
                                cokluislemci(v);
                           end else break;
                      end;
                 end;
            end;
            {$ELSE}
            case i of
                 9:
                 begin
                      cokluislemci(24);
                      cokluislemci(21);
                      cokluislemci(10);
                      cokluislemci(15);
                      cokluislemci(13);
                      cokluislemci(25);
                      cokluislemci(1);
                      cokluislemci(27);
                      cokluislemci(34);
                 end;
                 11:
                 begin
                      cokluislemci(25);
                      cokluislemci(5);
                      cokluislemci(33);
                      cokluislemci(11);
                      cokluislemci(12);
                 end;
                 8:
                 begin
                      cokluislemci(9);
                      cokluislemci(35);
                 end;
                 6:
                 begin
                      cokluislemci(8);
                      cokluislemci(14);
                      cokluislemci(36);
                      cokluislemci(41);
                 end;
                 7:
                 begin
                      cokluislemci(42);
                      cokluislemci(37);
                 end;
                 10:
                 begin
                      cokluislemci(43);
                      cokluislemci(24);
                      cokluislemci(21);
                      cokluislemci(10);
                      cokluislemci(15);
                      cokluislemci(13);
                      cokluislemci(25);
                      cokluislemci(34);
                 end;
            end;
            {$IFEND}
       end;
    begin
         err:=-7;
         CokluCalistirici(11);
         (*
         ///coklu 7
         err:=0;
         ReadFileData(fprcssname,filedatastr);
         ////////
         ///coklu 33
         if err<0 then
         begin
              ErrMsgLst.Add('Can not reading file "'+fprcssname+'".');
              ExecType:=ext_ErrFile;
              //Thread.Synchronize(ExProc);

              ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
              SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
              sleep(0);
              exit;
         end;
         /////////////

         //coklu 27
         MatchInFileCount:=0; //bu dosyada henüz kelime bulunmadý

         fcntl:=TList.Create;
         /////////////////

         ///coklu 13
           ////gruplama iþlemi1
         grno:=-1;
         grcount:=0;
         SetLength(Groups,0);
         SetLength(ItemsSwitchs,FWordsList.Count);
         For k:=0 to FWordsList.Count-1 do
         ItemsSwitchs[k]:=False;
         /////////////////

         ///coklu 37
           ////gruplama iþlemi2
         For k:=1 to FWordsList.Count do
         Begin
              if ItemsSwitchs[k-1] then Continue; //iþlenmiþ elemanlarý geç
              pWObj:=FWordsList.Items[k-1];
              grcount:=grcount+1;
              SetLength(Groups,grcount);
              grno:=pWObj^.GroupNumber;
              Groups[grcount-1]:=grno;
              if FWordsList.Count>k then
              for j := k+1 to FWordsList.Count do
              begin
                   pWObjB:=FWordsList.Items[j-1];
                   if pWObjB^.GroupNumber=grno then
                   ItemsSwitchs[j-1]:=True;
              end;
         end;
         ///////end gruplama iþlemleri
         //////////////////////////////
         *)  //coklucalistirici(11) sonu
         if not fActive then goto matchlistclear;
         if err<0 then goto matchlistclear;


         ///Bulunan gruplar icinde dongu kuruluyor
         if GrCount>0 then
         Begin
              For k:=0 to FWordsList.Count-1 do
              ItemsSwitchs[k]:=False; //Once hangi elemanlarýn iþlenmiþ olduðunu
              //7tutacak dizi sýfýrlanýyor


              for Gr_j := 0 to GrCount - 1 do
              Begin
                   if not fActive then goto matchlistclear;
                   Groups[Gr_j].GrReqDevam:=True;
                   Groups[Gr_j].Gr_StartPos:=-1;
                   Groups[Gr_j].Gr_StopPos:=-1;
                   Groups[Gr_j].GrStartStopStatus:=-1; //bilinmiyor durumuna geldi
                   For l:=1 to FWordsList.Count do
                   Begin
                        if ItemsSwitchs[l-1] then Continue; //iþlenmiþ elemaný geç

                        pWObj:=FWordsList.Items[l-1];
                        if pwObj^.GroupNumber<>Groups[Gr_j].GrpNo then Continue; //Farklý grubun elemanlarýna bakma
                        if pwObj^.SearchStarter or pwObj^.SearchStopper then
                        begin
                             Groups[Gr_j].GrStartStopStatus:=1;
                             break;
                        end;
                        Continue; //eðer reqj=0 ise sadece gerekliliði olanlara bakýlacak
                   end;
                   if Groups[Gr_j].GrStartStopStatus<0 then Groups[Gr_j].GrStartStopStatus:=0;


                   for reqj := 0 to 1 do  ///0 ise gerekliliði olanlar iþlenecek
                   ///  bu sayede gerekliiði olanlar içinde herhangi birisi gereklilik
                   ///  þartýna uygun deðilse o grupta dosya aramasý duracak. buda hýzlý aramayý
                   ///  saðlayacak
                   begin
                        if not ((reqj=0) or (Groups[Gr_j].GrStartStopStatus=0)) then
                        ///search starter uygulamasý durumunda
                        begin
                             for reqk := 1 to 2 do
                             ///1.adým baþlangýç noktasý bulunacak
                             ///2.adým bitiþ noktasý bulunacak
                             For k:=1 to FWordsList.Count do
                             Begin
                                  if not fActive then goto matchlistclear;
                                  if ItemsSwitchs[k-1] then Continue; //iþlenmiþ elemaný geç

                                  pWObj:=FWordsList.Items[k-1];
                                  if (pwObj^.GroupNumber<>Groups[Gr_j].GrpNo) then continue;
                                  if ((reqk=1) and (not pwObj^.SearchStarter)) then Continue;
                                  if ((reqk=2) and (not pwObj^.SearchStopper)) then Continue;
                                  ItemsSwitchs[k-1]:=True;//Bu noktadan sonra arama yapýlacaðý için
                                  ///bu kelime iþaretlensin ki bir daha arama yapmasýn

                                  //dosyada ilgili kelimenin bulunmamasý þartý aranýyorsa,onunla ilgili kayýt tutmasýn
                                     if pWObj^.uMatchReq then
                                        sfpth:=''
                                     else
                                        sfpth:=TempDir+'sf'+inttostr(repformid)+'_'+DblToText(flist.Count,'NNNNNN')+
                                        DblToText(k,'NNNNN')+'.tmp';

                                  if (pWObj^.SearchTxt='') Then
                                  begin
                                       if FileExists(sfpth) then SysUtils.DeleteFile(sfpth);
                                       continue;
                                  end;

                                  ////Standart deðiþkenler dikkate alýnýyor
                                  vSearchText:=pWObj^.SearchTxt;
                                  vSubMatchText:=pWObj^.SubMatchTxt;
                                  vReplaceText:=pWObj^.ReplaceTxt;

                                  vTargetText:=vSearchText;
                                  ApplyStandartVariable;
                                  vSearchText:=vTargetText;
                                  vTargetText:=vSubMatchText;
                                  ApplyStandartVariable;
                                  vSubMatchText:=vTargetText;
                                  vTargetText:=vReplaceText;
                                  ApplyStandartVariable;
                                  vReplaceText:=vTargetText;

                                  ////////////

                                  fwc:=
                                  ASCSearcText(k-1,filedatastr,vSearchText,vSubMatchText,vReplaceText,
                                  sfpth,pWObj^.CaseSwc,pWObj^.KeepCase,pWObj^.WordsOnly,pWObj^.StopAfterFMatchThisFile,
                                  False,pWObj^.areainfo,pWObj^.start1,pWObj^.start2,pWObj^.stop1,pWObj^.stop2,
                                  pWObj^.csvchar,pWObj^.RegEx,pWObj^.SearchStarter,pWObj^.SearchStopper,
                                  Groups[Gr_j].Gr_StartPos,Groups[Gr_j].Gr_StopPos);
                                  if not fActive then goto matchlistclear;
                                  if fwc<=0 then  //kelime bulunamadýysa
                                  Begin
                                     if FileExists(sfpth) then SysUtils.DeleteFile(sfpth);
                                     if pwObj^.MatchReq then Groups[Gr_j].GrReqDevam:=False; ///eðer Arama Sonucu kelimenin
                                       ///  bulunmasý gerekliyse bu grupta aramayý durdur
                                  end else      //kelime bulunduysa
                                  begin
                                       if pwObj^.StopAfterFMatchAll then FQStopAfterFMatchAllFlag:=true;
                                       if pwObj^.uMatchReq then
                                       begin
                                            Groups[Gr_j].GrReqDevam:=False; ///eðer Arama Sonucu kelimenin
                                            ///  bulunmamasý gerekliyse bu grupta aramayý durdur
                                       end else
                                       MatchInFileCount:=MatchInFileCount+fwc;



                                  end;
                                  if not Groups[Gr_j].GrReqDevam then
                                     Break;


                             end;
                        end; //End search starter and search stooper kontrol
                        //else
                        //begin
                             For k:=1 to FWordsList.Count do
                             Begin
                                  if not fActive then goto matchlistclear;
                                  if ItemsSwitchs[k-1] then Continue; //iþlenmiþ elemaný geç

                                  pWObj:=FWordsList.Items[k-1];
                                  if pwObj^.GroupNumber<>Groups[Gr_j].GrpNo then Continue;
                                   //Farklý grubun elemanlarýna bakma

                                  if (reqj=0) and (not (pwObj^.MatchReq or pWObj^.uMatchReq)) then
                                     Continue; //eðer reqj=0 ise sadece gerekliliði olanlara bakýlacak


                                  ItemsSwitchs[k-1]:=True;//Bu noktadan sonra arama yapýlacaðý için
                                  ///bu kelime iþaretlensin ki bir daha arama yapmasýn
                                  {case S_StartStopStatus of
                                       1:
                                       begin
                                       end;
                                       2:
                                       begin
                                       end;

                                  end;}


                                  //dosyada ilgili kelimenin bulunmamasý þartý aranýyorsa,onunla ilgili kayýt tutmasýn
                                     if pWObj^.uMatchReq then
                                        sfpth:=''
                                     else
                                        sfpth:=TempDir+'sf'+inttostr(repformid)+'_'+DblToText(flist.Count,'NNNNNN')+
                                        DblToText(k,'NNNNN')+'.tmp';


                                  if (pWObj^.SearchTxt='') Then
                                  begin
                                       if FileExists(sfpth) then
                                       begin
                                            try
                                               SysUtils.DeleteFile(sfpth);
                                            except
                                            end;
                                       end;
                                       continue;
                                  end;



                                  ////Standart deðiþkenler dikkate alýnýyor
                                  vSearchText:=pWObj^.SearchTxt;
                                  vSubMatchText:=pWObj^.SubMatchTxt;
                                  vReplaceText:=pWObj^.ReplaceTxt;

                                  vTargetText:=vSearchText;
                                  ApplyStandartVariable;
                                  vSearchText:=vTargetText;
                                  vTargetText:=vSubMatchText;
                                  ApplyStandartVariable;
                                  vSubMatchText:=vTargetText;
                                  vTargetText:=vReplaceText;
                                  ApplyStandartVariable;
                                  vReplaceText:=vTargetText;

                                  ////////////

                                  fwc:=
                                  ASCSearcText(k-1,filedatastr,vSearchText,vSubMatchText,vReplaceText,
                                  sfpth,pWObj^.CaseSwc,pWObj^.KeepCase,pWObj^.WordsOnly,pWObj^.StopAfterFMatchThisFile,
                                  False,pWObj^.areainfo,pWObj^.start1,pWObj^.start2,pWObj^.stop1,pWObj^.stop2,
                                  pWObj^.csvchar,pWObj^.RegEx,pWObj^.SearchStarter,pWObj^.SearchStopper,
                                  Groups[Gr_j].Gr_StartPos,Groups[Gr_j].Gr_StopPos);
                                  if not fActive then goto matchlistclear;
                                  if fwc<=0 then  //kelime bulunamadýysa
                                  Begin
                                     if FileExists(sfpth) then
                                     begin
                                          try
                                             SysUtils.DeleteFile(sfpth);
                                          except
                                          end;
                                     end;
                                     if pwObj^.MatchReq then Groups[Gr_j].GrReqDevam:=False; ///eðer Arama Sonucu kelimenin
                                       ///  bulunmasý gerekliyse bu grupta aramayý durdur
                                  end else      //kelime bulunduysa
                                  begin
                                       if pwObj^.StopAfterFMatchAll then FQStopAfterFMatchAllFlag:=true;

                                       if pwObj^.uMatchReq then Groups[Gr_j].GrReqDevam:=False ///eðer Arama Sonucu kelimenin
                                       ///  bulunmamasý gerekliyse bu grupta aramayý durdur
                                       else
                                       MatchInFileCount:=MatchInFileCount+fwc;


                                  end;
                                  if not Groups[Gr_j].GrReqDevam then
                                     Break;
                             end;  //End for k
                             if not Groups[Gr_j].GrReqDevam then
                                Break;
                        //end;

                   end; ///end for reqj

              end; ///end for Gr_j to grcount
         end; //end if GrCount>0
         if not fActive then goto matchlistclear;

         //match list yazýlýyor
         preparematchlistfile(flist.Count,forjname,filedatastr);


         matchlistclear:
         /////////matchlist boþaltýlýyor
         for k := fcntl.Count - 1 downto 0 do
         begin
              mtchsr:=fcntl.Items[k];
              Dispose(mtchsr);
         end;
         fcntl.Clear;
         fcntl.Free;
         fcntl:=nil;

         if (MatchInFileCount>0) then
         Begin
              ExecType:=ext_FoundFile;
              if Thread.Terminated then exit;
              if not fActive then
              SleepForActive;
              if Thread.Terminated then exit;
              //Thread.Synchronize(ExProc);
              ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
              mesajalindi:=false;
              SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
              msji:=0;
              repeat

                 sleep(0);
                 inc(msji);
              until ((msji>100) or mesajalindi)
         end else
         Begin

         end;

    end;


    Procedure SearchProcess;
    var
       fSrch:Boolean;
       sfqs1:String;
    begin
         if FQStopAfterFMatchAllFlag then
         begin
              if SearchFileQueue.Count>0 then
              try
                 SearchFileQueue.Clear;
              except
              end;
              fActive:=False;
         end;
         fSrch:=fActive;
         if fSrch then
            fSrch:=SearchFileQueue.Count>0;
         if fSrch then
         Begin
              try
                 sfqs1:=SearchFileQueue.Strings[0];
              except
                 sfqs1:='';
              end;
              ScanFile:=csvData(sfqs1,1);
              fProcessFile:=scanfile;
              DestinationDir:=csvData(sfqs1,2);
              qtFileNameOperation:=csvData(sfqs1,3)='Y';
              ScanFolder:=ExtractFilePath(ScanFile);
              ExecType:=ext_NewSearch;
              if Thread.Terminated then exit;
              if not fActive then exit;
              //Thread.Synchronize(ExProc);
              ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
              SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
              sleep(0);
              if not fActive then exit;
              FReady:=False;
              //////Word ve Excel dosyalari icin kontrol kodlari
              ffileext:=LowerCase(ExtractFileExt(scanfile));
              if appdefaultsrec.UsePDFFiles then
              begin
                   if (Pos('pdf',ffileext)>0)  then
                   begin
                        fProcessFile:=TempDir+'prcs'+inttostr(repformid)+'_'+
                        DblToText(flist.Count,'NNNNNN')+'.txt';
                        if FileExists(fProcessFile) then
                           SysUtils.DeleteFile(fProcessFile);
                        ExecType:=ext_pdftotext;
                        //Thread.Synchronize(ExProc);
                        ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
                        PDFTamamlandi:=False;
                        PDFIsBaslangici:=GetTickCount;
                        SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
                        while (not PDFTamamlandi) and ((GetTickCount>=PDFIsBaslangici) and (GetTickCount<PDFIsBaslangici+PDFIsZamanAsimi)) do
                        begin
                             sleep(2);
                        end;
                   end;
              end;
              if appdefaultsrec.UseOLEAutomation then
              begin
                   if (Pos('xls',ffileext)>0) or (Pos('xlsx',ffileext)>0) then
                   begin
                        fProcessFile:=TempDir+'prcs'+inttostr(repformid)+'_'+
                        DblToText(flist.Count,'NNNNNN')+'.txt';
                        if FileExists(fProcessFile) then
                           SysUtils.DeleteFile(fProcessFile);
                        ExecType:=ext_ExcelFileToText;
                        ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
                        OleIslemiTamamlandi:=False;
                        OleIsBaslangici:=GetTickCount;
                        SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
                        while (not OleIslemiTamamlandi) and ((GetTickCount>=OleIsBaslangici) and (GetTickCount<OleIsBaslangici+OleIsZamanAsimi)) do
                        begin
                             sleep(2);
                        end;
                   end else
                   if (Pos('doc',ffileext)>0) or (Pos('docx',ffileext)>0) or
                      (Pos('dotm',ffileext)>0) or (Pos('wpd',ffileext)>0) or
                      (Pos('wps',ffileext)>0) or (Pos('rtf',ffileext)>0) then
                   begin
                        fProcessFile:=TempDir+'prcs'+inttostr(repformid)+'_'+
                        DblToText(flist.Count,'NNNNNN')+'.txt';
                        if FileExists(fProcessFile) then
                           SysUtils.DeleteFile(fProcessFile);
                        ExecType:=ext_WordFileToText;
                        ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
                        OleIslemiTamamlandi:=False;
                        OleIsBaslangici:=GetTickCount;
                        SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
                        while (not OleIslemiTamamlandi) and ((GetTickCount>=OleIsBaslangici) and (GetTickCount<OleIsBaslangici+OleIsZamanAsimi)) do
                        begin
                             sleep(2);
                        end;
                   end;
              end;


              /////////////////////////////////////////////////
              SearchInFile(scanfile,fProcessFile);
              if not fActive then exit;

              if SearchFileQueue.Count>0 then  //baþka bir konumda liste boþaltýlabilir
              begin
                   try
                      SearchFileQueue.Delete(0);
                   except
                   end;
              end;
              FReady:=True;
         End else
         begin
              FReady:=True;
              if fActive then
              ExecType:=ext_QueueStopping
              else
              begin
                   sleep(50);
                   ExecType:=ext_Normally;
              end;
              if Thread.Terminated then exit;
              //Thread.Synchronize(ExProc);
              ThreadMsgTxt := 'QExProc;'+inttostr(integer(ExecType))+';';
              SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
              sleep(0);
              //ExProc;
              //Active:=False;
         end;
    end;
begin
  repeat1:
  fexcepted:=False;
  //try
    while not Thread.Terminated do
    begin
         //if not fDisabled then
            SearchProcess;
         //if not fActive then Terminate;
    end;
  {
  except
    fexcepted:=True;
  end;
  if fexcepted then goto repeat1;
  }

end;
procedure TQueueThread.ExProc(Sender:TObject);
begin
     //if ExecType=ext_QueueStopping then
        //fDisabled:=True;
     if Assigned(fExecute) then
     fExecute(self);
end;


procedure TQueueThread.MessageReceiver(var msg: TMessage);
var
  txt: PChar;
  s,cmd,fn:ASCMRString;
begin
     if not assigned(self) then exit;
     txt := PChar(msg.lParam);
     cmd:=csvData(txt,1);
     msg.Result := 1;
     if cmd='FileFound' then
     begin
          s:=txt;
          CutcsvDataASCMR(s);
          fn:=s;

     end;
end;

procedure TQueueThread.SetActive(Value: Boolean);
begin
     if fActive=Value Then exit;
     if Value and ((not FEnabled) or FPaused) then exit;

     fActive:=Value;
     if Value then Start() else
     begin
          Stop();
          //fDisabled:=False;
     end;
end;

procedure TQueueThread.StartSrv(Sender: TObject);
var
          FileInfo: SHFILEINFO;

          DiskRoot: array [0..20] of Char;
          Volume: array [0..255] of Char;
          sVolume:String;

          MaxFileCLen:dWord;
          FSystemFlag:dWord;
          FSystemName:array [0..255] of Char;
          s:String;
begin
            s:=GetEnvironmentVariable('HOMEDRIVE');
            if s='' then s:=GetEnvironmentVariable('SystemDrive');
            if s='' then s:=GetEnvironmentVariable('windir');

            if s='' then s:='C:';
            if not (s[1] in ['A'..'Z']) then s[1]:='C';
            DiskRoot[0]:=s[1];
            DiskRoot[1]:=':';
            DiskRoot[2]:='\';
            try
               GetVolumeInformation(DiskRoot,Volume,255,@vSeriNo1,MaxFileCLen,FSystemFlag,FSystemName,255);
            except
               vSeriNo1:=0;
               Volume:='';
            end;
            sVolume:=Volume;

end;

procedure TFileSearchThread.BMDExecute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
label repeat1;
var
   fexcepted:Boolean;
    lj: Integer;

    procedure STGetFileList(SrList:TASCMRStringList;incMask,ExcMask:ASCMRString;SubDirSwc:Boolean;
    MinFileSize,MaxFileSize:int64;MinDate,MaxDate:Double;FFileNameOperation:Boolean);
    Var
       sr: TSearchRec;
       j,DAttr:Integer;
       GdStr,Gdstr2:TASCMRStringList;
       s,s2:ASCMRString;
       fFirstDir:Boolean;
       FMD:TDateTime;
       Procedure GetFilesProc(SubDirStr,SubDestDirStr:ASCMRString;Var OutFList:TASCMRStringList);
       var
          ss,ss2:ASCMRString;
       Begin
            OutFList.Clear;
            if fStop or Thread.Terminated Then exit;
            if SysUtils.FindFirst(SubDirStr+'*.*', $3f, sr) = 0 then
            begin
                 if not ((sr.Name='.') or (sr.Name='..')) Then
                 Begin


                      if (Sr.Attr and $10<>0) and SubDirSwc Then
                         OutFList.Add(SubDirStr+sr.Name+';'+SubDestDirStr+sr.Name+';')
                      Else
                      Begin
                        fscPath:=SubDirStr;
                        if Thread.Terminated then
                        begin
                             SysUtils.FindClose(sr);
                             exit;
                        end;
                        scCounter:=scCounter+1;//Thread.Synchronize(syncCounter);
                        if csvMatchesMask(sr.Name,incMask) Then
                        Begin
                             if (excMask='') or
                                (not csvMatchesMask(sr.Name,excMask)) Then
                             Begin
                                  DSiGetModifyDate(sr.Name,FMD);
                                  if
                                      /////filesize check

                                          (
                                            (
                                              (MinFileSize=MaxFileSize) and (MinFileSize=0)
                                            ) or
                                            (
                                               ((sr.Size>=MinFileSize) or (MinFileSize=0)) and
                                               ((sr.Size<=MaxFileSize) or(MaxFileSize=0))
                                            )
                                          ) and
                                     /////file modify date check
                                     (
                                       ((MinDate=MaxDate) and (MinDate=0)) or
                                       ((FMD>=MinDate) and ((FMD<=MaxDate) or (MaxDate=0)))
                                     )
                                     then
                                  begin
                                       fFileFound:=SubDirStr+sr.Name+';'+SubDestDirStr+';'+BoolToStrYN(FFileNameOperation)+';';
                                       if Thread.Terminated then
                                       begin
                                            SysUtils.FindClose(sr);
                                            exit;
                                       end;
                                       FileFound(nil);//Thread.Synchronize(FileFound);
                                  end;
                             end;
                        end;
                      End;
                 End;
                 while SysUtils.FindNext(sr) = 0 do
                 begin
                      if fStop or Thread.Terminated Then
                      begin
                           SysUtils.FindClose(sr);
                           exit;
                      end;
                      if not ((sr.Name='.') or (sr.Name='..')) Then
                      Begin

                           if (Sr.Attr and $10<>0) and SubDirSwc Then
                              OutFList.Add(SubDirStr+sr.Name+';'+SubDestDirStr+sr.Name+';')
                           Else
                           Begin
                                fscPath:=SubDirStr;
                                scCounter:=scCounter+1;
                                if Thread.Terminated then exit;
                                FileScanned(nil);//Thread.Synchronize(FileScanned);
                                if csvMatchesMask(sr.Name,incMask) Then
                                begin
                                     if excMask<>'' then
                                       if csvMatchesMask(sr.Name,excMask) Then  Continue;
                                     DSiGetModifyDate(sr.Name,FMD);
                                     if
                                         /////filesize check
                                          
                                          (
                                             ((MinFileSize=MaxFileSize) and (MinFileSize=0)) or
                                             (((sr.Size>=MinFileSize) or (MinFileSize=0)) and ((sr.Size<=MaxFileSize) or(MaxFileSize=0)))
                                          ) and
                                        /////file modify date check
                                        (
                                          ((MinDate=MaxDate) and (MinDate=0)) or
                                          ((FMD>=MinDate) and ((FMD<=MaxDate) or (MaxDate=0)))
                                        )
                                        then
                                     begin
                                          fFileFound:=SubDirStr+sr.Name+';'+SubDestDirStr+';'+BoolToStrYN(FFileNameOperation)+';';
                                          if Thread.Terminated then
                                          begin
                                               SysUtils.FindClose(sr);
                                               exit;
                                          end;
                                          FileFound(nil);//Thread.Synchronize(FileFound);
                                     end;
                                end;
                           End;
                      End;
                 End;
                 SysUtils.FindClose(sr);
            End;
       End;

    Begin
         if fStop Then exit;
         if SrList.Count=0 Then Exit;
         GdStr:=TASCMRStringList.Create;
         GdStr.Clear;
         GdStr2:=TASCMRStringList.Create;
         GdStr2.Clear;
         fFirstDir:=True;
         For j:=0 to SrList.Count-1 do
         begin
              if fStop Then Exit;
              s:=csvData(SrList.Strings[j],1);
              if s='' then continue;
              if Copy(s,Length(s),1)='\' then SetLength(s,Length(s)-1);
              s2:=csvData(SrList.Strings[j],2);
              GdStr.Add(s+';'+s2+';');
         end;
         while GdStr.Count>0 do
         Begin
              if fStop Then exit;
              s:=csvData(GdStr.Strings[0],1);
              s2:=csvData(GdStr.Strings[0],2);
              DAttr:=SysUtils.FileGetAttr(s);

              if (DAttr and $10<>0) Then
              Begin
                   if SubDirSwc or fFirstDir then
                      GetFilesProc(GetDirName(s),GetDirName(s2),GdStr2);
                   if fStop Then exit;
                   if GDStr.Count>0 then
                   begin
                        try
                           GdStr.Delete(0);
                        except
                        end;
                   end;
                   if (SubDirSwc or fFirstDir) and (GdStr2.count>0) Then
                   Begin
                        For j:=0 to GdStr2.Count-1 do
                            GdStr.Add(GdStr2.Strings[j]);
                   End;
              End Else
              Begin
                   if SysUtils.FindFirst(s, $3f, sr) = 0 then
                   begin
                        scCounter:=scCounter+1;
                        if Thread.Terminated then exit;
                        FileScanned(nil);//Thread.Synchronize(FileScanned);
                        fscPath:=ExtractFilePath(s);
                        if csvMatchesMask(s,incMask) Then
                        Begin
                             if (excMask='') or (not csvMatchesMask(sr.Name,excMask)) Then
                                     if
                                         /////filesize check
                                        (
                                          ((MinFileSize=MaxFileSize) and (MinFileSize=0)) or
                                          (((sr.Size>=MinFileSize) or (MinFileSize=0)) and ((sr.Size<=MaxFileSize) or(MaxFileSize=0)))
                                        ) and
                                        /////file modify date check
                                        (
                                          ((MinDate=MaxDate) and (MinDate=0)) or
                                          ((FMD>=MinDate) and ((FMD<=MaxDate) or (MaxDate=0)))
                                        )
                                        then
                                     begin
                                          if fStop or Thread.Terminated Then
                                          begin
                                               SysUtils.FindClose(sr);
                                               exit;
                                          end;
                                          fFileFound:=s+';'+s2+';'+BoolToStrYN(FFileNameOperation)+';'+BoolToStrYN(FFileNameOperation)+';';
                                          FileFound(nil);//Thread.Synchronize(FileFound);
                                     end;
                        end;
                   End;
                   SysUtils.FindClose(sr);
                   if GDStr.Count>0 then
                   begin
                      try
                         GdStr.Delete(0);
                      except
                      end;
                   end;
              End;
              fFirstDir:=False;
         End;
         GdStr.Free;
         GdStr:=Nil;
         GdStr2.Free;
         GdStr2:=Nil;
    End;

    procedure PreSearchSrcFileList;
    Var
       src,srcdir,dest,destdir,incmaskstr,excmaskstr:ASCMRString;
       f,r:ASCMRString;
       b:int64;
       i,k,l,dslCount:Integer;
       srl,dsl:TASCMRStringList;
       p:PSrcFileSelRec;
       exMinFileSize,exMaxFileSize:int64;exMinDate,exMaxDate:Double;
       fnormally:Boolean;
    begin
         if fstop then
            fnormally:=true
         else
            fnormally:=False;
         if (flist=nil) then
            fnormally:=True;
         if not fnormally then
            if flist.Count=0 then
               fnormally:=True;
         if fnormally then
         begin
              //if Assigned(fOnNormally) then fOnNormally(nil);
              sleep(50);
              //if not Suspended then Suspend;
              exit;
         end;
         k:=0;
         For i:=0 to fList.Count-1 do
         Begin
              if fStop Then Break;
              p:=fList.Items[i];
              srcdir:=p^.Src;
              destdir:=p^.Dest;
              if ((fFormStyleSwc=2) or (fFormStyleSwc=4)) and (destdir='') then continue;
              if srcdir='' then
                   Continue;
              inc(k);
         end;
         if k<1 then
         Begin
              //RepMainF.AppShowMessage(ErrAddFileSelection);
              exit;
         end;
         For i:=0 to fList.Count-1 do
         Begin
              if fStop Then exit;
              p:=fList.Items[i];
              src:=p^.Src+p^.ifileptr;
              Dest:=p^.Dest;
              srcdir:=p^.Src;
              destdir:=p^.Dest;
              incmaskstr:=p^.ifileptr;
              excmaskstr:=p^.exfileptr;
              exMinFileSize:=p^.srMinFileSize;
              exMaxFileSize:=p^.srMaxFileSize;
              exMinDate:=p^.srMinDate;
              exMaxDate:=p^.srMaxDate;
              if ((fFormStyleSwc=2) or (fFormStyleSwc=4)) and (destdir='') then continue;
              if (srcdir='') then  continue;
              if Copy(srcdir,Length(srcdir),1)<>'\' Then srcdir:=srcdir+'\';
              if Copy(destdir,Length(destdir),1)<>'\' Then destdir:=destdir+'\';
              srl:=TASCMRStringList.Create;
              srl.Add(srcdir+';'+destdir+';');
              dsl:=TASCMRStringList.Create;
              STGetFileList(srl,incmaskstr,excmaskstr,p^.subfiles='Y',
              exMinFileSize,exMaxFileSize,exMinDate,exMaxDate,p^.FileNameOperation);
         end;
         if Assigned(fOnReady) then
         begin
              Ready(Self);//fOnReady(Self);
              sleep(1000);
         end;

    end;
    ////////////////////////////////////





begin // function FindFile

  if not Thread.Terminated then
  fscCounter:=0; //belirli aralýklarla taranan dosya sayýsý belirtilecek
  {
  repeat1:
  fexcepted:=False;
  try
  }
    while not Thread.Terminated do
    begin
         PreSearchSrcFileList;
    end;
  {
  except
    fexcepted:=True;
  end;
  if fexcepted then goto repeat1;
  }
end;

procedure TFileSearchThread.FileFound(Sender:TObject);
var
   ThreadMsgTxt:String;
begin
    ThreadMsgTxt := 'FileFound;'+fFileFound+';';
    SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
    sleep(0);
  //if Assigned(fOnFileFound) then
    //fOnFileFound(Self, fFileFound);
end;

procedure TFileSearchThread.FileScanned(Sender:TObject);
var
   ThreadMsgTxt:String;
begin

    ThreadMsgTxt := 'FileScanned;'+';';
    SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
    sleep(0);
  //if Assigned(fOnFileScanned) then
    //fOnFileScanned(Self);

end;

procedure TFileSearchThread.Ready(Sender:TObject);
var
   ThreadMsgTxt:String;
begin
    ThreadMsgTxt := 'Ready;;';
    SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
    sleep(0);
end;

procedure TFileSearchThread.SetMatchCounter(Value: integer);
begin
     fMatchCounter:=Value;
     if Value mod 10=0 then
     fMatchCountChange(self);
end;

procedure TFileSearchThread.SetscCounter(Value: integer);
var
   ThreadMsgTxt:String;
begin
     fscCounter:=Value;
     if Value mod 10=0 then
     begin
          ThreadMsgTxt := 'scCounter;'+inttostr(Value)+';';
          SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));
          sleep(0);
          //fscCountChange(self);
     end;
end;

procedure TFileSearchThread.syncCounter(Sender:TObject);
begin
     scCounter:=scCounter+1;
end;

procedure Register;
begin
  RegisterComponents('ASCSearch', [TMainFileSearch]);
end;

procedure TMainFileSearch.Stop;
begin
     //if fPrepared then
     begin
          if SearchThread=nil then exit;
          
          SearchThread.fStop:=True;
          SearchThread.Stop();
     end;
end;


end.

