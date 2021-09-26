unit RepMainU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList,Registry,ExtCtrls,RepConstU,RepLib,MsgShowU, XPMan,
  StdCtrls, Buttons,ShellApi,WinAnahtarU,RVStyle,MACAdress,FileCtrl, jpeg,RepThreadU
  {$IF (ASCUniCodeUsing=1)}
  ,TntClasses,TNTSysUtils
  {$IFEND}
  ;
type
  TRepMainF = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    EditMI: TMenuItem;
    About1: TMenuItem;
    MainImages: TImageList;
    DefImages: TImageList;
    SD1: TSaveDialog;
    OD2: TOpenDialog;
    OptionsM: TMenuItem;
    OD3: TOpenDialog;
    FirstTimer: TTimer;
    XPManifest1: TXPManifest;
    MenuImages: TImageList;
    Panel1: TPanel;
    StartBtn1: TBitBtn;
    StartBtn2: TBitBtn;
    StartBtn3: TBitBtn;
    StartBtn4: TBitBtn;
    ExitBtn: TBitBtn;
    Single1: TMenuItem;
    MultiSearch1: TMenuItem;
    SingleReplace1: TMenuItem;
    MultiReplace1: TMenuItem;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    DropDownAreaPnl: TPanel;
    DropDownAreaLbl: TLabel;
    Image1: TImage;
    InvalidTimer: TTimer;
    Image2: TImage;
    AnaMenuImgs: TImageList;
    Image3: TImage;
    ImageList1: TImageList;
    BtnImages: TImageList;
    DenemeSrmTim: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FirstTimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Exit1Click(Sender: TObject);
    procedure OptionsMClick(Sender: TObject);
    procedure StartBtn1Click(Sender: TObject);
    procedure DropDownAreaWndProc(var Message: TMessage);
    procedure DropDownAreaPaste(var Msg:TMessage);
    procedure DropDownAreaDropMsg(var Msg : TMessage) ;
    procedure InvalidTimerTimer(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StartBtn4Click(Sender: TObject);
    procedure DenemeSrmTimTimer(Sender: TObject);
  private
    { Private declarations }
    OldDropDownAreaWndProc:TWndMethod;
  public
    { Public declarations }
    RecDate:Double;
    pdfprogrami,
    ExtWordFile,        //bulunan kelimelerin yazýlacaðý liste
    ExtLineFile,         //bulunan satýrlarýn yazýlacaðý liste
    ReportFile           //rapor dosyasýnýn yazdýrýlacaðý dosya
    :String;
    SelFileList, ///Dosyalari yuklemek icin kullaniliyor
    DropDownItemLst:TStringList;///Suruklenip birakýlan dosylar tutuluyor
    ProcessCounter, //Yeni accilan her forma bir numara vermek icin kullaniliyor
    FirstTimerTag:integer;  ///Ana formun ilk acilisi esnasinda bazi islemleri ardi ardina yapmak icin sayac numarasi
    /////  asagidaki degiskenler acilisda bazý parametreleri belirliyor
    vStartSearch,      //acilisda arama islemini baþlatýyor
    vStartReplace,     //acilisda degistirme islemini baþlatýyor
    vAutoClose,        //eðer arama veya degiðtime baþlamýþsa iþ  bitiminde programý kapatýyor
    vIgnoreErrors,     //iþlemler esnasýnda bir hata olmuþsa hatalarý gormezden geliyor
                        //bu autoclose komutunun calismasi icin gerekli olabilir
    vAutoHide           //formlarý gizler(Auto close gerekli)

    :Boolean;
    //////////

    RegisterHeader:TRegisterHeader; //ozellikle lisans bilgilerini tutar

    RVStyle1: TRVStyle;

    procedure GetAppDefaults; //programýn default deðerlerini okuyor
    function SelectFiles(DstDir:ASCMRString;FrmStyle:integer):Boolean;  ///Dosya veya dosyalarý seçmek icin kullanýlýyor
    function ImportFiles(lst:TStringList;FrmStyle:integer;FDestinationDir:String):Boolean; //Surukle birak komutu
    procedure ImportFromParams; //acilis parametrelerini isler
    function EditFileSelect(FDefDestDir:ASCMRString;FrmStyle:integer;
    Var src,dest,ifileptr,exfileptr:ASCMRstring;var FileOrDir,subfiles:Char;
    var MinFileSize,MaxFileSize:int64;var DateOption:integer;var MinDate,MaxDate:Double;
    Var FFileNameOperation:Boolean):Boolean; //Dosya secim komutu. Coklu veya tekli dosya secebilir
    ///Dosya secerken dosya ozellikleri ile ilgili kriterlerde belirtilebiliyor
    function AddWords(FrmStyle:integer;Var SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
    var CaseSwc,KeepCase,RegEx,WordsOnly,
    MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
    uMatchReq {Ýçermeyen(Bütün dosyalar için)},
    SearchOnly{(for replace projects)},
    StopAfterFMatchThisFile, // eger iþaretliyse dosya icerisinde ilk bulma iþleminden sonra o dosya icerisinde
                             ////arama yapmayý býrakýr
    StopAfterFMatchAll,      //iþaretliyse dosya içerisinde bilgi bulundu ise baþka dosyalarda arama yapmaz.
             //Yukarýdaki iki deðiþken iþaretliyse bir dosyada hem bir kere arama yapar hemde kelime bulununca
             //arama iþlemi durdurulur.
    ///aþaðýdaki 2 parametre ozellikle çoklu arama/deðiþtirmede kullanýlýr
    SearchStarter,//iþaretliyse dosya içerisinde bu kelime bulunduktan sonraki pozisyonlarda diðer arama
    //iþlemleri yapýlýr. Yani aramanýn baþlayacaðý bir nokta belirlemeyi saðlar
    SearchStopper:boolean; //yukarýdakine benzer þekilde aramanýn sonlanacaðý pozisyonu belirleyecek kelimede kullanýlýr
    var areainfo,start1,start2,stop1,stop2:integer;  //dosya formatý belirlemek icin kullanýlýr (csv gibi)
    var csvchar:ASCMRString;var GroupNumber:integer):Boolean;  //Aranacak bilgi ekleme komutu.

    ///aþaðýdaki komut AddWordsun duzeltme komutu
    function EditWords(FrmStyle:integer;Var SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
    var CaseSwc,KeepCase,RegEx,WordsOnly,
    MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
    uMatchReq {Ýçermeyen(Bütün dosyalar için)},
    SearchOnly{(for replace projects)},
    StopAfterFMatchThisFile,StopAfterFMatchAll,SearchStarter,SearchStopper:boolean;
    var areainfo,start1,start2,stop1,stop2:integer;
    var csvchar:ASCMRString;var GroupNumber:integer):Boolean;
    function AppDlg(ms:msTypes;m:ASCMRString):rsTypes;
    procedure AppShowMessage(mstr:ASCMRString);
    procedure OpenRDFFile(f:ASCMRString;FStartSearchSwc,FStartRepSwc:Boolean);
    procedure FileFormatSelDialog(var areainfo,start1,start2,stop1,stop2:integer;
    var csvchar:ASCMRString);
    function NewEmptyRepFrm:Boolean;
    function SelectDir(dir:ASCMRstring):ASCMRstring;
    procedure HexDataTool(const Obj:TASCMRStrings);
    procedure SozlukYukle;
  end;

  procedure Win7UpdateFix(Form: TForm; CharCode: Word);

var
  RepMainF: TRepMainF;
implementation

uses SelDirU,RepFrmU, WordEditU,NewPrjU, MulRepMainU,ImportFilesU,
FileFormatSelU, PrmU, AboutU,HexDataU;

{$R *.dfm}
const
     DefaultMacNo='00-22-FA-1A-21-A6';


procedure Win7UpdateFix(Form: TForm; CharCode: Word);
var i: Integer;
begin
  if Assigned(Form) and (Win32MajorVersion >= 6) and (Win32Platform = VER_PLATFORM_WIN32_NT) then //Vista, Win7
  begin
    case CharCode of
      VK_MENU, VK_TAB:  //Alt or Tab
      begin
        for i := 0 to Form.ComponentCount-1 do
        begin
          if Form.Components[i] is TWinControl then
          begin
            //COntrols that disappear - Buttons, Radio buttons, Checkboxes
            if (Form.Components[i] is TButton)
            or (Form.Components[i] is TRadioButton)
            or (Form.Components[i] is TRadioGroup)
            or (Form.Components[i] is TCheckBox) then
              TWinControl(Form.Components[i]).Invalidate;
          end;
        end;
      end;
    end;
  end;
end;
procedure TRepMainF.About1Click(Sender: TObject);
begin
     AboutF:=TAboutF.Create(nil);
     AboutF.ShowModal;
     AboutF.Free;
     AboutF:=Nil;
end;

function TRepMainF.AddWords(FrmStyle:integer;Var SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
var CaseSwc,KeepCase,RegEx,WordsOnly,
MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
uMatchReq {Ýçermeyen(Bütün dosyalar için)},
SearchOnly{(for replace projects)},
StopAfterFMatchThisFile,StopAfterFMatchAll,SearchStarter,
    SearchStopper:boolean;
var areainfo,start1,start2,stop1,stop2:integer;
var csvchar:ASCMRString;var GroupNumber:integer): Boolean;
begin
     //Case,2:RegEx,3:WordsOnly,4:MatchReq Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq,
     //uMatchReq 5:Ýçermeyen(Bütün dosyalar için),6:SearchOnly(for replace projects)
     //7:StopAfterFMatch ilk bulunma anýnda dur

     //areainfo:bilgi arama konum seçenekleri 0:normal,1:dosya baþýndan itibaren baþlangýç start1,
     //karakter sayýsý stop1;2:Satýr numarasý olarak start1 ve stop 1;3:sutun olarak start1,uzunluk stop1;
     //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
     //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
     //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
     //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
     //,start1,start2,stop1,stop2
     searchtxt:='';
     replacetxt:='';
     SubMatchtxt:='';
     CaseSwc:=appdefaultsrec.CaseSensChk;
     KeepCase:=appdefaultsrec.KeepCaseChk;
     RegEx:=appdefaultsrec.RegExUseChk;
     WordsOnly:=False;
     MatchReq:=False; {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq}
     uMatchReq:=False; {Ýçermeyen(Bütün dosyalar için)}
     SearchOnly:=False;{(for replace projects)}
     StopAfterFMatchThisFile:=False;
     StopAfterFMatchAll:=False;
     SearchStarter:=False;
     SearchStopper:=False;
     areainfo:=0;
     start1:=0;
     start2:=0;
     stop1:=0;
     stop2:=0;
     csvchar:=';';
     GroupNumber:=0;



     WordEditF:=TWordEditF.Create(Nil);
     With WordEditF Do
     Begin
          WordEditF.Caption:='Add Word';
          SelResult:=False;
          if (FrmStyle=1) or (FrmStyle=3) then
          begin
               TNTSubMatchE.Visible:=False;
               SubMatchL.Visible:=False;

               TNTNewE.Visible:=False;
               NewL.Visible:=False;
               SearchOnlyChk.Visible:=False;
               KeepCaseChk.Visible:=False;
          end;

          SysVarL2.Visible:=TNTNewE.Visible;
          SysVarL3.Visible:=TNTNewE.Visible;
          HexLbl2.Visible:=TNTNewE.Visible;
          HexLbl3.Visible:=TNTNewE.Visible;
          TNTOldE.Lines.Text:=searchtxt;
          TNTSubMatchE.Lines.Text:=submatchtxt;
          TNTNewE.Lines.Text:=replacetxt;
          CaseChk.Checked:=CaseSwc;
          KeepCaseChk.Checked:=KeepCase;
          RegExChk.Checked:=RegEx or (ASCUniCodeUsing=1);
          RegExChk.Enabled:=(ASCUniCodeUsing<>1);
          SingleWordsOnlyChk.Checked:=WordsOnly;
          SearchOnlyChk.Checked:=SearchOnly;
          if (StopAfterFMatchThisFile and StopAfterFMatchAll) then
          SingleOnMatching.ItemIndex:=3
          else
          if (StopAfterFMatchThisFile) then
          SingleOnMatching.ItemIndex:=1
          else
          if (StopAfterFMatchAll) then
          SingleOnMatching.ItemIndex:=2
          else
          if (SearchStarter) then
          SingleOnMatching.ItemIndex:=4
          else
          if (SearchStopper) then
          SingleOnMatching.ItemIndex:=5
          else
          SingleOnMatching.ItemIndex:=0;
          GroupUpDown.Position:=GroupNumber;
          if MatchReq then
           MatchReqC.ItemIndex:=1
          else
          if uMatchReq then
           MatchReqC.ItemIndex:=2
          else
           MatchReqC.ItemIndex:=0;

          v_areainfo:=areainfo;
          v_start1:=start1;
          v_start2:=start2;
          v_stop1:=stop1;
          v_stop2:=stop2;
          v_csvchar:=csvchar;


          ShowModal;


          searchtxt:=TNTOldE.Lines.Text;
          if (FrmStyle=1) or (FrmStyle=3) then
          Begin
               submatchtxt:='';
               replacetxt:=searchtxt;
          end else
          Begin
               submatchtxt:=TNTSubMatchE.Lines.Text;
               replacetxt:=TNTNewE.Lines.Text;
          End;


          CaseSwc:=CaseChk.Checked;
          KeepCase:=KeepCaseChk.Checked;
          RegEx:=RegExChk.Checked;
          SearchOnly:=SearchOnlyChk.Checked;
          WordsOnly:=SingleWordsOnlyChk.Checked;

          StopAfterFMatchThisFile:=((SingleOnMatching.ItemIndex=1) or (SingleOnMatching.ItemIndex=3));
          StopAfterFMatchAll:=((SingleOnMatching.ItemIndex=2) or (SingleOnMatching.ItemIndex=3));
          SearchStarter:=(SingleOnMatching.ItemIndex=4);
          SearchStopper:=(SingleOnMatching.ItemIndex=5);
          areainfo:=v_areainfo;
          start1:=v_start1;
          start2:=v_start2;
          stop1:=v_stop1;
          stop2:=v_stop2;
          csvchar:=v_csvchar;

          MatchReq:=MatchReqC.ItemIndex=1;
          uMatchReq:=MatchReqC.ItemIndex=2;
          GroupNumber:=GroupUpDown.Position;

          Result:=SelResult;
     end;
end;


function TRepMainF.AppDlg(ms: msTypes; m: ASCMRString): rsTypes;
begin
       Result:=rsCancel;
       MsgShowF:=TMsgShowF.Create(nil);
       MsgShowF.DlgType:=ms;
       MsgShowF.MsgLbl.Caption:=m;
       MsgShowF.Showmodal;
       Result:=MsgShowF.DlgResult;
       MsgShowF.Free;
       MsgShowF:=Nil;
end;

procedure TRepMainF.AppShowMessage(mstr: ASCMRString);
begin
     AppDlg(msOk,mstr);
end;

procedure TRepMainF.CreateParams(var Params: TCreateParams);
begin
     inherited;
     Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
     Params.WndParent := GetDesktopWindow;

end;

procedure TRepMainF.DropDownAreaDropMsg(var Msg: TMessage);
var
  nrf:TRepFrmF;
  pcFileName: PChar;
  i, iSize, iFileCount: integer;
  sd,s:ASCMRString;
  ls:TASCMRStringList;
begin
     pcFileName := ''; // to avoid compiler warning message
     iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
     if iFileCount>0 then
          DropDownItemLst.Clear;

     for i := 0 to iFileCount - 1 do
     begin
          iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
          pcFileName := StrAlloc(iSize);
          DragQueryFile(Msg.wParam, i, pcFileName, iSize);


          if (FileExists(pcFileName)) or (DirectoryExists(pcFileName)) then
          Begin

               sd:=pcFileName;
               s:=lowercase(ExtractFileExt(sd));
               if s='.'+lowercase(ReplacerExt) then
               begin
                    vAutoClose:=False;

                    ProcessCounter:=ProcessCounter+1;

                    nrf:=TRepFrmF.Create(Self);
                    with nrf do
                    Begin
                         Caption:=msgReplacePrjBsl+inttostr(ProcessCounter);
                         frepfilename:=sd;
                         OpenRepFile;
                         Show;
                    end;


               end else
               DropDownItemLst.Add(sd);
          end;
          StrDispose(pcFileName);
     end;
     DragFinish(Msg.wParam);

end;

procedure TRepMainF.DropDownAreaPaste(var Msg: TMessage);
begin
     GetClipBrdFiles(DropDownItemLst);
end;

procedure TRepMainF.DropDownAreaWndProc(var Message: TMessage);
begin
     if Message.Msg = WM_DROPFILES then
        DropDownAreaDropMsg(Message)
     {
     else
     if Message.Msg=WM_PASTE Then
        DropDownAreaPaste(Message)
     }
     else
        OldDropDownAreaWndProc(Message);

end;

function TRepMainF.EditFileSelect(FDefDestDir:ASCMRString;FrmStyle:integer;
    Var src,dest,ifileptr,exfileptr:ASCMRstring;
    Var FileOrDir,subfiles:Char;
    var MinFileSize,MaxFileSize:int64;var DateOption:integer;var MinDate,MaxDate:Double;
    Var FFileNameOperation:Boolean): Boolean;
Var
   s1,s2,s3,s4:ASCMRString;
   s6,s5:Char;
begin
     SelDirF:=TSelDirF.Create(Nil);
     With SelDirF Do
     Begin
          SelMinFileSize:=MinFileSize;
          SelMaxFileSize:=MaxFileSize;
          SelDateOption:=DateOption;
          SelMinDate:=MinDate;
          SelMaxDate:=MaxDate;
          if FDefDestDir=Dest then
          DestOptionsR1.ItemIndex:=0
          else
          DestOptionsR1.ItemIndex:=1;
          DestOptionsR2.ItemIndex:=DestOptionsR1.ItemIndex;
          DestE1.Text:=ExtractFilePath(Dest);
          DestE2.Text:=ExtractFilePath(Dest);
          if FileOrDir='F' then
          Begin
               FileNameE.Text:=ExtractFilePath(Src)+ifileptr; //dosya adý file paterne geliyor
               InMaskE.Text:='*.*';
               ExMaskE.Text:='';
               PGCtrl.ActivePageIndex:=1;
               SubsChk.Checked:=True;
               FileNameOprChk1.Checked:=False;
          end else
          Begin
               DirE.Text:=ExtractFilePath(Src);
               InMaskE.Text:=ifileptr;
               ExMaskE.Text:=exfileptr;
               SubsChk.Checked:=subfiles='Y';
               PGCtrl.ActivePageIndex:=0;
               FileNameOprChk1.Checked:=FFileNameOperation;
          end;
          SelResult:=False;
          EditDisplay(FrmStyle);
          ShowModal;
          s6:='N';
          if PGCtrl.ActivePageIndex=0 Then
          Begin
               s1:=ExtractFilePath(DirE.Text);
               if DestOptionsR1.ItemIndex=0 then
               s2:=GetDirectory(FDefDestDir)
               else
               s2:=GetDirectory(DestE1.Text);

               s3:=InMaskE.Text;
               s4:=ExMaskE.Text;
               s5:='D';
               if SubsChk.Checked then s6:='Y';
               FFileNameOperation:=FileNameOprChk1.Checked;
          end else
          Begin
               s1:=ExtractFilePath(FileNameE.Text);
               if DestOptionsR2.ItemIndex=0 then
               s2:=GetDirectory(FDefDestDir)
               else
               s2:=GetDirectory(DestE2.Text);
               s3:=ExtractFileName(FileNameE.Text);//file patern dosya adýný alýr
               s4:='';
               s5:='F';
               s6:='N';
               FFileNameOperation:=False;
          end;
          if (Trim(s3)<>'') and ((Trim(s2)<>'') or (FrmStyle=3) or (FrmStyle=1)) Then
          Begin
               Src:=s1;
               Dest:=s2;
               ifileptr:=s3;
               exfileptr:=s4;
               FileOrDir:=s5;
               subfiles:=s6;

               MinFileSize:=SelMinFileSize;
               MaxFileSize:=SelMaxFileSize;
               DateOption:=SelDateOption;
               MinDate:=SelMinDate;
               MaxDate:=SelMaxDate;

          end;
          Result:=SelResult;
     end;
end;

function TRepMainF.EditWords(FrmStyle:integer;Var SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
    var CaseSwc,KeepCase,RegEx,WordsOnly,
    MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
    uMatchReq {Ýçermeyen(Bütün dosyalar için)},
    SearchOnly{(for replace projects)},
    StopAfterFMatchThisFile,StopAfterFMatchAll,SearchStarter,SearchStopper:boolean;
    var areainfo,start1,start2,stop1,stop2:integer;
    var csvchar:ASCMRString;var GroupNumber:integer): Boolean;
begin
     WordEditF:=TWordEditF.Create(Nil);
     With WordEditF Do
     Begin
          WordEditF.Caption:='Edit Word';
          SelResult:=False;
          TNTOldE.Lines.Text:=searchtxt;
          TNTSubMatchE.Lines.Text:=submatchtxt;
          TNTNewE.Lines.Text:=replacetxt;
          CaseChk.Checked:=CaseSwc;
          KeepCaseChk.Checked:=KeepCase;
          RegExChk.Checked:=RegEx or (ASCUniCodeUsing=1);
          SingleWordsOnlyChk.Checked:=WordsOnly;
          SearchOnlyChk.Checked:=SearchOnly;
          if (StopAfterFMatchThisFile and StopAfterFMatchAll) then
          SingleOnMatching.ItemIndex:=3
          else
          if (StopAfterFMatchThisFile) then
          SingleOnMatching.ItemIndex:=1
          else
          if (StopAfterFMatchAll) then
          SingleOnMatching.ItemIndex:=2
          else
          if (SearchStarter) then
          SingleOnMatching.ItemIndex:=4
          else
          if (SearchStopper) then
          SingleOnMatching.ItemIndex:=5
          else
          SingleOnMatching.ItemIndex:=0;


          if (FrmStyle=1) or (FrmStyle=3) then
          begin
               TNTSubMatchE.Visible:=False;
               SubMatchL.Visible:=False;
               KeepCaseChk.Visible:=False;
               TNTNewE.Visible:=False;
               NewL.Visible:=False;
               SearchOnlyChk.Visible:=False;
          end;
          SysVarL2.Visible:=TNTNewE.Visible;
          SysVarL3.Visible:=TNTNewE.Visible;
          HexLbl2.Visible:=TNTNewE.Visible;
          HexLbl3.Visible:=TNTNewE.Visible;

          v_areainfo:=areainfo;
          v_start1:=start1;
          v_start2:=start2;
          v_stop1:=stop1;
          v_stop2:=stop2;
          v_csvchar:=csvchar;
          GroupUpDown.Position:=GroupNumber;
          if MatchReq then
           MatchReqC.ItemIndex:=1
          else
          if uMatchReq then
           MatchReqC.ItemIndex:=2
          else
           MatchReqC.ItemIndex:=0;


          ShowModal;
          searchtxt:=WordEditF.TNTOldE.Lines.Text;
          if (FrmStyle=1) or (FrmStyle=3) then
          Begin
               submatchtxt:='';
               replacetxt:=searchtxt;
          end else
          Begin
               submatchtxt:=WordEditF.TNTSubMatchE.Lines.Text;
               replacetxt:=WordEditF.TNTNewE.Lines.Text;
          End;


          CaseSwc:=WordEditF.CaseChk.Checked;
          KeepCase:=WordEditF.KeepCaseChk.Checked;
          RegEx:=WordEditF.RegExChk.Checked;
          SearchOnly:=WordEditF.SearchOnlyChk.Checked;
          WordsOnly:=WordEditF.SingleWordsOnlyChk.Checked;

          StopAfterFMatchThisFile:=((SingleOnMatching.ItemIndex=1) or (SingleOnMatching.ItemIndex=3));
          StopAfterFMatchAll:=((SingleOnMatching.ItemIndex=2) or (SingleOnMatching.ItemIndex=3));
          SearchStarter:=(SingleOnMatching.ItemIndex=4);
          SearchStopper:=(SingleOnMatching.ItemIndex=5);

          areainfo:=v_areainfo;
          start1:=v_start1;
          start2:=v_start2;
          stop1:=v_stop1;
          stop2:=v_stop2;
          csvchar:=v_csvchar;

          MatchReq:=MatchReqC.ItemIndex=1;
          uMatchReq:=MatchReqC.ItemIndex=2;
          GroupNumber:=GroupUpDown.Position;

          Result:=SelResult;
     end;
end;

procedure TRepMainF.Exit1Click(Sender: TObject);
begin
     Close;
end;

procedure TRepMainF.FileFormatSelDialog(var areainfo, start1, start2,
  stop1, stop2: integer; var csvchar: ASCMRString);
var
   f:TFileFormatSelF;
begin
     f:=TFileFormatSelF.Create(nil);
     //areainfo:bilgi arama konum seçenekleri 0:normal,
     //1:dosya baþýndan itibaren baþlangýç start1,karakter sayýsý stop1;
     //2:Satýr numarasý olarak start1 ve stop 1;
     //3:sutun olarak start1,uzunluk stop1;
     //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
     //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
     //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
     //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
     //,start1,start2,stop1,stop2
     if csvchar=#9 then
     f.CSVCharacter.Text:='TAB'
     else
     if csvchar=#32 then
     f.CSVCharacter.Text:='SPACE'
     else
     f.CSVCharacter.Text:=csvchar;
     Case areainfo of
          1:
          begin
               f.SecKarakterAra.Checked:=True;
               f.KarakterAra1.Text:=inttostr(start1);
               f.KarakterAra2.Text:=inttostr(stop1);
          end;
          2:
          begin
               f.SecIkiSatir.Checked:=True;
               f.IkiSatir1.Text:=inttostr(start1);
               f.IkiSatir2.Text:=inttostr(stop1);
          end;
          3:
          begin
               f.SecIkiSutun.Checked:=True;
               f.IkiSutun1.Text:=inttostr(start1);
               f.IkiSutun2.Text:=inttostr(stop1);
          end;
          4:
          begin
               f.SecSatirSutun.Checked:=True;
               f.SatirSutun1.Text:=inttostr(Start1);
               f.SatirSutun2.Text:=inttostr(Stop1);
               f.SatirSutun3.Text:=inttostr(Start2);
               f.SatirSutun4.Text:=inttostr(Stop2);

          end;
          5:
          begin
               f.SecCsvTekli.Checked:=True;
               f.CsvTekli1.Text:=inttostr(Start1);
          end;
          6:
          begin
               f.SecCsvIkili.Checked:=True;
               f.CsvIkili1.Text:=Inttostr(Start1);
               f.CsvIkili2.Text:=Inttostr(Stop1);
          end;
          7:
          begin
               f.SecCsvSatCol.Checked:=True;
               f.CsvSatCol1.Text:=Inttostr(Start1);
               f.CsvSatCol2.Text:=Inttostr(stop1);
               f.CsvSatCol3.Text:=Inttostr(start2);
               f.CsvSatCol4.Text:=Inttostr(stop2);
          end;
          else f.SecNormal.Checked:=True;
     end;

     f.ShowModal;
     if f.Cevap=1 then
     begin
          start1:=0;
          stop1:=0;
          start2:=0;
          stop2:=0;
          if f.SecNormal.Checked then areainfo:=0
          else
          if f.SecKarakterAra.Checked then
          begin
               areainfo:=1;
               start1:=TextToInt(f.KarakterAra1.Text);
               stop1:=TextToInt(f.KarakterAra2.Text);
          end else
          if f.SecIkiSatir.Checked then
          begin
               areainfo:=2;
               start1:=TextToInt(f.IkiSatir1.Text);
               stop1:=TextToInt(f.IkiSatir2.Text);
          end else
          if f.SecIkiSutun.Checked then
          begin
               areainfo:=3;
               start1:=TextToInt(f.IkiSutun1.Text);
               stop1:=TextToInt(f.IkiSutun2.Text);
          end else
          if f.SecSatirSutun.Checked then
          begin
               areainfo:=4;
               start1:=TextToInt(f.SatirSutun1.Text);
               stop1:=TextToInt(f.SatirSutun2.Text);
               start2:=TextToInt(f.SatirSutun3.Text);
               stop2:=TextToInt(f.SatirSutun4.Text);

          end else
          if f.SecCsvTekli.Checked then
          begin
               areainfo:=5;
               start1:=TextToInt(f.CsvTekli1.Text);
          end else
          if f.SecCsvIkili.Checked then
          begin
               areainfo:=6;
               start1:=TextToInt(f.CsvIkili1.Text);
               stop1:=TextToInt(f.CsvIkili2.Text);
          end else
          if f.SecCsvSatCol.Checked then
          begin
               areainfo:=7;
               start1:=TextToInt(f.CsvSatCol1.Text);
               stop1:=TextToInt(f.CsvSatCol2.Text);
               start2:=TextToInt(f.CsvSatCol3.Text);
               stop2:=TextToInt(f.CsvSatCol4.Text);
          end else
          areainfo:=0;
          if f.CSVCharacter.Enabled then
          begin
               if (Length(f.CSVCharacter.Text)=1) then
               begin
                    csvchar:=f.CSVCharacter.Text;
               end else
               if f.CSVCharacter.Text='TAB' then
                  csvchar:=#9
               else
               if f.CSVCharacter.Text='SPACE' then
                  csvchar:=#32;
                  
          end;

     end;

     f.free;
     f:=nil;




end;

procedure TRepMainF.FirstTimerTimer(Sender: TObject);
var
   EFM:Byte;
   f:TextFile;
   s,readstr,s2,s3:String;
   j,k,l:integer;
   DiskRoot: array [0..20] of Char;
   Volume: array [0..255] of Char;
   MaxFileCLen:dWord;
   FSystemFlag:dWord;
   FSystemName:array [0..255] of Char;
   vSeriNo1,vSeriNo2:dWord;
   RegOzelKod,ProgStr,
   sSeriNo1,sSeriNo2,
   FMacNo,sDiskKod,webDiskKod,sVolume:String;

   procedure cozucub(b:Byte);
   begin
        Case RegisterHeader.ComputerVal[b] of
             '0':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])+3+(Ord(progstr[3])*2)+1  ) mod 255);
             '1':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])+13+(Ord(progstr[6])*2)+9  ) mod 255);
             '2':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])-(Ord(progstr[1])-17)+7+(Ord(progstr[3])*2)+2  ) mod 255);
             '3':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])+8+(Ord(progstr[5])*2)-5  ) mod 255);
             '4':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])-(Ord(progstr[4]) div 3)+11+(Ord(progstr[8])*2)+3  ) mod 255);
             '5':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])+5+(Ord(progstr[2])*2) div 3  ) mod 255);
             '6':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])+2+(Ord(progstr[4])*2)+12  ) mod 255);
             '7':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])-(Ord(progstr[3]) div 2)+(Ord(progstr[5])*2)-8  ) mod 255);
             '8':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])+27+(Ord(progstr[7])*2)+4  ) mod 255);
             '9':sDiskKod[b]:=Chr(  (  Ord(sDiskKod[b])+19+(Ord(progstr[1])*2)+10  ) mod 255);
        end;
   end;

   procedure wcozucu(b:Byte);
   begin
        Case RegisterHeader.ComputerVal[b] of
             '1':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])+47+(Ord(progstr[5])*3)+9  ) mod 10)+48);
             '2':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])+13+(Ord(progstr[7])*2)+12  ) mod 10)+48);
             '3':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])-(Ord(progstr[3]) div 3)+23+(Ord(progstr[6])*2)-3  ) mod 10)+48);
             '4':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])-(Ord(progstr[8])-17)-7+(Ord(progstr[1])*2)+2  ) mod 10)+48);
             '5':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])+21+(Ord(progstr[2])*2)-2  ) mod 10)+48);
             '6':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])+13+(Ord(progstr[1])*2)-4  ) mod 10)+48);
             '7':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])+11+(Ord(progstr[6])*2)+15  ) mod 10)+48);
             '8':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])+3+(Ord(progstr[3])*2)-5  ) mod 10)+48);
             '9':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])+17+(Ord(progstr[7])*3) div 3  ) mod 10)+48);
             '0':webDiskKod[b]:=Chr((  (Ord(webDiskKod[b])-(Ord(progstr[4]) div 2)+(Ord(progstr[2])*2)-8  ) mod 10)+48);
        end;
   end;

  Procedure genkodcoz;
  var
     b,c,l:integer;
     sx:ASCMRstring;
  Begin
       RegOzelKod:='';
       sx:=RegisterHeader.SerialNo;
       l:=length(sx);
       for b:=1 to l do
       begin
             Case b of
                  1:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) * 3+$21) mod 255)+1];
                  2:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B])+Ord(sx[B+4]) xor $45+12) mod 255)+1];
                  3:RegOzelKod:=RegOzelKod+OzelKodlar[(((Ord(sx[B])+Ord(sx[B+1]) + 24) div 2+35) mod 255)+1];
                  4:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B])*2+$38) mod 255)+1];
                  5:RegOzelKod:=RegOzelKod+OzelKodlar[(((Ord(sx[B])+Ord(sx[B-3]) - 41)+1) mod 255)+1];
                  6:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) div 2+47) mod 255)+1];
                  7:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B])+Ord(sx[B-1])-7) mod 255)+1];
                  8:RegOzelKod:=RegOzelKod+OzelKodlar[((((Ord(sx[B]) or 1)) * 2-2) mod 255)+1];
                  9:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) - 6) mod 255)+1];
                  else RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) div 3+29) mod 255)+1];
             End;
             Case b of
                  1:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B])-(Ord(sx[B+3]) div 3)+7) mod 255)+1];
                  2:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) div 13+22) mod 255)+1];
                  3:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B])-(Ord(sx[B+4]) div 4)+22) mod 255)+1];
                  4:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) xor $95+17) mod 255)+1];
                  5:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) * 2+Ord(sx[B-1])+18) mod 255)+1];
                  6:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B])+Ord(sx[B+1])+24) mod 255)+1];
                  7:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) div 2+Ord(sx[B-4])+13) mod 255)+1];
                  8:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) * 2+17) mod 255)+1];
                  9:RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) div 2+47) mod 255)+1];
                  else RegOzelKod:=RegOzelKod+OzelKodlar[((Ord(sx[B]) * 3+26) mod 255)+1];
             End;
       end;
  end;

begin

     FirstTimerTag:=FirstTimerTag+1;
     case FirstTimerTag of
          1:
          begin
               ShowWindow(Application.Handle, SW_HIDE);
               MulRepMainF.Hide;
               GetAppDefaults;

               RVStyle1:=TRVStyle.Create(nil);
               RVStyle1.TextStyles.Clear;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[];
                    Color:=clBlack;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=clGreen;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=clBlue;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=clPurple;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=clRed;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=clTeal;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=clNavy;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=$00AE5626;
               end;
               with RVStyle1.TextStyles.Add do
               Begin
                    FontName:='Arial';
                    Size:=10;
                    Style:=[fsBold,fsUnderline];
                    Color:=clFuchsia;
               end;


          end;
          2:
          begin
               {$IF (DemoVersiyon=0)}
               EFM:=FileMode;
               FileMode:=fmOpenRead;

               AssignFile(f,AppPath+RegistrationFileName);
               {$I-}Reset(f);{$I+}
               //if ioresult<>0 then
               readstr:='';
               try
               Readln(f,readstr);
               except
               end;
               try
               closefile(f);
               except
               end;
               if trim(readstr)='' then
               begin
                    InvalidTimer.Tag:=1;
                    InvalidTimer.Enabled:=True;
                    exit;
               end;
               FileMode:=EFM;
               with RegisterHeader do
               begin
                    ProgName:=Cutcsvdata(readstr);
                    Ver:=Cutcsvdata(readstr);
                    RegDate:=TextToInt(Cutcsvdata(readstr));
                    UserName:=Cutcsvdata(readstr);
                    SerialNo:=Cutcsvdata(readstr);
                    UserNamePass:=Cutcsvdata(readstr);
                    PasswordPass:=Cutcsvdata(readstr);
                    SerialNoPass1:=Cutcsvdata(readstr);
                    SerialNoPass2:=Cutcsvdata(readstr);
                    HddSerial:=Cutcsvdata(readstr);
                    HddPass:=hexdatatostr(Cutcsvdata(readstr));
                    RegistrationName:=Cutcsvdata(readstr);
                    MacNo:=Cutcsvdata(readstr);
                    RegKey1:=Cutcsvdata(readstr);
                    RegKey2:=Cutcsvdata(readstr);
                    Options:=Cutcsvdata(readstr);
                    ComputerVal:=Cutcsvdata(readstr);
               end;



               s:=GetEnvironmentVariable('HOMEDRIVE');
               if s='' then s:=GetEnvironmentVariable('SystemDrive');
               if s='' then s:=GetEnvironmentVariable('windir');

               if s='' then s:='C:';
               if not (s[1] in ['A'..'Z']) then s[1]:='C';
               DiskRoot[0]:=s[1];
               DiskRoot[1]:=':';
               DiskRoot[2]:='\';
               GetVolumeInformation(DiskRoot,Volume,255,@vSeriNo1,MaxFileCLen,FSystemFlag,FSystemName,255);
               sVolume:=Volume;
               sSeriNo1:=inttohex(vSeriNo1,8);
               sDiskKod:=sSeriNo1;
               webDiskKod:=sSeriNo1;

               ProgStr:='';
               for k := 1 to 8  do
               Begin
                    Case k of
                         1:ProgStr:=ProgStr+Copy(ASCProductName,k,1)+#67;
                         2:ProgStr:=ProgStr+Copy(ASCProductName,k,1)+#143;
                         3:ProgStr:=ProgStr+Copy(ASCProductName,k,1)+#62;
                         4:ProgStr:=ProgStr+Copy(ASCProductName,k,1)+#115;
                         5:ProgStr:=ProgStr+Copy(ASCProductName,k,1)+#42;
                         6:ProgStr:=ProgStr+Copy(ASCProductName,k,1)+#56;
                    End;
               End;

               for l := 1 to 8 do
               begin
                    cozucub(l);
               end;

               ProgStr:=ASCProductName;
               for l := 1 to 8 do
               begin
                    wcozucu(l);
               end;
               sDiskKod:=ReplaceText(csvPrepareColumn(sDiskKod),'#','*');
               RegisterHeader.WndNo:=View_Win_Key;

               FMacNo:=GetMACAdress('');
               if FMacNo='' then
               FMacNo:=DefaultMacNo;
               //////////////eger cift ethernet varsa veya aga bagli degilse macno farkli olabilir
               ///  bu sebeple macno kontrolu devre dýþý býrakýldý
               if (RegisterHeader.MacNo<>'') and (RegisterHeader.MacNo<>FMacNo) then
                  FMacNo:=RegisterHeader.MacNo;
               /////////////////////////////////////////////////////////////////////

               GenKodCoz;
               MainScrTextA.Clear;
               MainScrTextB.Clear;
               if (RegOzelKod=RegisterHeader.RegKey2) and (RegisterHeader.HddSerial=sSeriNo1) and
                  (RegisterHeader.HddPass=sDiskKod) then
               begin
                    RegKeyVal1:=RegisterHeader.RegKey1;
                    RegKeyVal2:=RegisterHeader.RegKey2;
                    s3:=Cutcsvdata(readstr);

                    //2 sunucudan 2 ayrý script var, hesaplamasý farklý
                    s2:=ReplaceText( xsvData(s3,'J',1),'R',';');  //1.script
                    s2:=ReplaceText( s2,'C',',');
                    while s2<>'' do
                    MainScrTextA.add(cutcsvdata(s2));

                    s2:=ReplaceText( xsvData(s3,'J',2),'R',';');  //2.script
                    s2:=ReplaceText( s2,'C',',');
                    while s2<>'' do
                    MainScrTextB.add(cutcsvdata(s2));

                    uygulamaadi:=RegisterHeader.ProgName;
               end else
               begin
                    InvalidTimer.Tag:=1;
                    InvalidTimer.Enabled:=True;
               end;
               {$ELSE}
               {$IFEND}
          end;

          3:
          begin
               {$IF (DemoVersiyon=0) or (DemoVersiyon=2)}
               //showmessage('x');
               ImportFromParams;
               if vAutoClose and vAutoHide then RepMainF.Hide else
               begin
                    RepMainF.show;
                    if RepMainF.CanFocus then
                       RepMainF.SetFocus;
               end;
               {$ELSE}
               {$IFEND}
          end;

     end;
end;

procedure TRepMainF.FormClose(Sender: TObject; var Action: TCloseAction);
Var
   j:integer;
begin



     for j := Self.MDIChildCount-1 downto 0 do
     Begin
          Self.MDIChildren[j].Close;
     end;
     Application.ProcessMessages;
     if Self.MDIChildCount>0 then
     Action:=caNone else Action:=caFree;
end;

procedure TRepMainF.FormCreate(Sender: TObject);
var
   FileInfo: SHFILEINFO;
begin
     FirstTimerTag:=0;
     ProcessCounter:=0;
     ReportFile:='';
     ExtWordFile:='';
     ExtLineFile:='';
     Caption:=ASCAppName;
     RecDate:=Date;
     pdfprogrami:='pdftotext.exe';
     if ASCUniCodeUsing=1 then
     OD2.Filter:=msgUniRepFileFiltre+' *.'+ReplacerExt+'|*.'+ReplacerExt
     else
     OD2.Filter:=msgMulRepFileFiltre+' *.'+ReplacerExt+'|*.'+ReplacerExt;
     SD1.Filter:=OD2.Filter;
     MainScrTextA:=TStringList.Create;
     MainScrTextB:=TStringList.Create;
     OldDropDownAreaWndProc:=DropDownAreaPnl.WindowProc;
     DropDownAreaPnl.WindowProc:=DropDownAreaWndProc;
     DragAcceptFiles(DropDownAreaPnl.Handle, True);
     SelFileList:=TStringList.Create;
     DropDownItemLst:=TStringList.Create;
     AppPath:=ExtractFilePAth(Application.ExeName);
     TempDir:=AppPath+'Temp\';
     if not DirectoryExists(TempDir) then ForceDirectories(TempDir);

     InitializeCriticalSection(Section1);
     InitializeCriticalSection(Section2);
     SozlukYukle;
     FirstTimer.Enabled:=True;

end;

procedure TRepMainF.FormDestroy(Sender: TObject);
begin
     if Assigned(RVStyle1) then
     begin
          RVStyle1.Free;
          RVStyle1:=Nil;
     end;
     DragAcceptFiles(DropDownAreaPnl.Handle, False);
     DropDownAreaPnl.WindowProc:=OldDropDownAreaWndProc;

     if Assigned(SelFileList) Then SelFileList.Free;
     SelFileList:=Nil;

     if Assigned(DropDownItemLst) Then DropDownItemLst.Free;
     DropDownItemLst:=Nil;

     if Assigned(MulRepMainF) then
     MulRepMainF.Close;
     if Assigned(MainScrTextA) then
     MainScrTextA.Free;
     MainScrTextA:=nil;
     if Assigned(MainScrTextB) then
     MainScrTextB.Free;
     MainScrTextB:=nil;
     DeleteCriticalSection(Section1);
     DeleteCriticalSection(Section2);
end;

procedure TRepMainF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);
end;

procedure TRepMainF.GetAppDefaults;
Var
   keyname,s:ASCMRString;
   Reg: TRegistry;
   errswc:Boolean;
begin
     with appdefaultsrec do
     begin
          IncFilePtr:='*.*';
          ExcFilePtr:='';
          SourceDir:='C:\';
          DestDir:='C:\';
          SubDirs:=True;
          WarmBeforeOpenPtr:='*.exe;*.bat';
          WordsOnlyChars:=' .,;:!?*%+-/=<>\@$#&^~({[]})_|`´"'+#39+#13+#10;
          OnExitAskSaveChk:=True;
          CaseSensChk:=False;
          RegExUseChk:=True;
          RegExGreedyChk:=True;
          MinFileSize:=0;
          MaxFileSize:=0;
          GenMaxFileSize:=64;
          DateOption:=0;
          FileSizeOption:=0;
          MinDate:=0;
          MaxDate:=0;
          UseOLEAutomation:=True;
          UsePDFFiles:=True;
     end;

     errswc:=False;
     keyname:='Software\Asyncronous\MultiReplacer';
     Reg:=TRegistry.Create;
     try
        Reg.RootKey:=HKEY_CURRENT_USER;
        if not Reg.OpenKey(keyname,True) then
        Begin
             MessageDlg(msgKytOkuHata1,mtError,[mbOK],0);
             errswc:=true;
        end else
        Begin
             {$IF (DemoVersiyon=0)or(DemoVersiyon=2)}
             {$ELSE}
             if Reg.ValueExists('RecExp') then
             begin
                  if Reg.ReadInteger('RecExp')=1 then
                  DenemeSrmTim.Enabled:=true;

             End;
             if Reg.ValueExists('RecDate') then
             begin
                  RecDate:=Reg.ReadDate('RecDate');
             end else
             begin
                  RecDate:=Date;
                  Reg.WriteDate('RecDate',RecDate);
             end;
             if Date>=RecDate+DenemeGunSay then
             begin
                  DenemeSrmTim.Enabled:=True;
                  Reg.WriteInteger('RecExp',1);
                   exit;
             end;
             {$IFEND}

             with appdefaultsrec do
             Begin
                  if Reg.ValueExists('IncFilePtr') then
                  IncFilePtr:=Reg.ReadString('IncFilePtr');

                  if Reg.ValueExists('ExcFilePtr') then
                  ExcFilePtr:=Reg.ReadString('ExcFilePtr');
                  if Reg.ValueExists('SourceDir') then
                  SourceDir:=Reg.ReadString('SourceDir');
                  if Reg.ValueExists('DestDir') then
                  DestDir:=Reg.ReadString('DestDir');
                  if Reg.ValueExists('SubDirs') then
                  SubDirs:=Reg.ReadBool('SubDirs');
                  if Reg.ValueExists('WarmBeforeOpenPtr') then
                  WarmBeforeOpenPtr:=Reg.ReadString('WarmBeforeOpenPtr');
                  if Reg.ValueExists('OnExitAskSaveChk') then
                  OnExitAskSaveChk:=Reg.ReadBool('OnExitAskSaveChk');
                  if Reg.ValueExists('CaseSensChk') then
                  CaseSensChk:=Reg.ReadBool('CaseSensChk');
                  if Reg.ValueExists('RegExUseChk') then
                  RegExUseChk:=Reg.ReadBool('RegExUseChk');
                  if Reg.ValueExists('RegExGreedyChk') then
                  RegExGreedyChk:=Reg.ReadBool('RegExGreedyChk');

                  if Reg.ValueExists('RegExMultiLineChk') then
                  RegExMultiLineChk:=Reg.ReadBool('RegExMultiLineChk');
                  if Reg.ValueExists('RegExSingleLineChk') then
                  RegExSingleLineChk:=Reg.ReadBool('RegExSingleLineChk');
                  if Reg.ValueExists('RegExExtendedChk') then
                  RegExExtendedChk:=Reg.ReadBool('RegExExtendedChk');
                  if Reg.ValueExists('RegExAnchoredChk') then
                  RegExAnchoredChk:=Reg.ReadBool('RegExAnchoredChk');

                  if Reg.ValueExists('FileSizeOption') then
                  FileSizeOption:=Reg.ReadInteger('FileSizeOption');
                  if Reg.ValueExists('MinFileSize') then
                  MinFileSize:=Reg.ReadInteger('MinFileSize');
                  if Reg.ValueExists('MaxFileSize') then
                  MaxFileSize:=Reg.ReadInteger('MaxFileSize');
                  if Reg.ValueExists('DateOption') Then
                  DateOption:=Reg.ReadInteger('DateOption');

                  if Reg.ValueExists('MinDate') then
                  MinDate:=Reg.ReadDateTime('MinDate');
                  if Reg.ValueExists('MaxDate') then
                  MaxDate:=Reg.ReadDateTime('MaxDate');

                  if Reg.ValueExists('UseOLEAutomation') then
                  UseOLEAutomation:=Reg.ReadBool('UseOLEAutomation');
                  if Reg.ValueExists('UsePDFFiles') then
                  UsePDFFiles:=Reg.ReadBool('UsePDFFiles');
                  if Reg.ValueExists('GenMaxFileSize') then
                  GenMaxFileSize:=Reg.ReadInteger('GenMaxFileSize');

             end;
             Reg.CloseKey;
        end;
    except
          MessageDlg(msgKytOkuHata1,mtError,[mbOK],0);
          errswc:=True;
    end;
    Reg.Free;

end;



procedure TRepMainF.HexDataTool(const Obj: TASCMRStrings);
var
   HDF:THexDataF;
   s:String;
begin
     HDF:=THexDataF.Create(nil);
     s:=Obj.Text;
     HDF.HexMemo1.Lines.Text:=dec2tohex(s);
     HDF.ShowModal;
     if HDF.Durum then
     begin

          Obj.Text:=hexdatatostr(HDF.HexMemo1.Lines.Text);
     end;
     HDF.Free;
     HDF:=Nil;
end;

function TRepMainF.ImportFiles(lst:TStringList;FrmStyle: integer;FDestinationDir:String): Boolean;
Var
   s,Src,Dest,ifileptr,exfileptr,FileOrDir,subfiles,msg:ASCMRString;
   MinFileSize,MaxFileSize:int64;DateOption:integer;MinDate,MaxDate:Double;
  j: integer;
begin

     Result:=False;
     SelFileList.Clear;
     if Lst.Count<1 then exit;
     ImportFilesF:=TImportFilesF.Create(Nil);
     With ImportFilesF Do
     Begin
          DestE1.Text:=FDestinationDir;
          SelResult:=False;
          SourceList.Items.Assign(lst);
          SelAllBtnClick(nil);
          EditDisplay(FrmStyle);
          ShowModal;
          subfiles:='N';

          if DestOptionsR1.ItemIndex=0 then
          dest:=GetDirectory(FDestinationDir)
          else
          dest:=GetDirectory(DestE1.Text);

          MinFileSize:=SelMinFileSize;
          MaxFileSize:=SelMaxFileSize;
          DateOption:=SelDateOption;
          MinDate:=SelMinDate;
          MaxDate:=SelMaxDate;

          for j := 0 to SourceList.Count - 1 do
          Begin
               if not SourceList.Checked[j] then continue;

               s:=SourceList.Items.Strings[j];
               if FileExists(s) then
               Begin
                    src:=ExtractFilePath(s);
                    ifileptr:=ExtractFileName(s);//file patern dosya adýný alýr
                    exfileptr:='';
                    fileordir:='F';
                    subfiles:='N';
               End else
               Begin
                    src:=GetDirectory(s);
                    ifileptr:=InMaskE.Text;
                    exfileptr:=ExMaskE.Text;
                    fileordir:='D';
                    if SubsChk.Checked then subfiles:='Y' else subfiles:='N';
               End;
               SelFileList.Add(csvPrepareColumn(src)+';'+csvPrepareColumn(dest)+';'+
               csvPrepareColumn(ifileptr)+';'+csvPrepareColumn(exfileptr)+';'+
               csvPrepareColumn(fileorDir)+';'+csvPrepareColumn(subfiles)+';'+
               Inttostr(MinFileSize)+';'+Inttostr(MaxFileSize)+';'+Inttostr(DateOption)+
               ';'+DblToText(MinDate,asfDateTime)+';'+DblToText(MaxDate,asfDateTime)+';');
          End;
          Result:=SelResult;
     end;
end;

procedure TRepMainF.ImportFromParams;
Var
   s,Src,Dest,ifileptr,exfileptr,FileOrDir,subfiles,msg:ASCMRString;
   MinFileSize,MaxFileSize:int64;DateOption:integer;MinDate,MaxDate:Double;
   j: integer;


   f,f1,f2:ASCMRString;
   frmopened:Boolean;
   vPrjCount,lf,eqp,lf1,fswc:integer;
   vProjects,
   vIncPtr,
   vExcPtr,
   vSearch,
   vRepSubMatch,
   vNewText,
   vDestDir,
   vCaseStr,
   vRegExStr,
   vOptionsStr,
   vAreaInfoStr,
   vStart1Str,
   vStart2Str,
   vStop1Str,
   vStop2Str,
   vcsvcstr,
   vWordsOnlyStr,
   vMatchReqOpt,
   vUMatchReqOpt,
   vSearchOnlyOpt

     //Options:32bit 1.Case,2:RegEx,3:Words Only,4:Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq,
     //5:Ýçermeyen(Bütün dosyalar için)uMatchReq,6:Search Only(for replace projects),7:Stop after first matched

     //areainfo:bilgi arama konum seçenekleri 0:normal,1:dosya baþýndan itibaren baþlangýç start1,
     //karakter sayýsý stop1;2:Satýr numarasý olarak start1 ve stop 1;3:sutun olarak start1,uzunluk stop1;
     //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
     //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
     //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
     //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
     //,start1,start2,stop1,stop2

   :ASCMRString;
   vCaseSwc,
   vKeepCase,
   vSubs,
   vRegex,

   vWordsOnly,
   vMatchReq,
   vUMatchReq,
   vSearchOnly,
   vStopAfterMatchThisFile,
   vStopAfterMatchAll,
   vSearchStarter,vSearchStopper
   :boolean;
   ForDirReq,vGroupNumber:integer;
   ls,errlst:TASCMRStringList;

   newFrm:TRepFrmF;

   vPrmMinFileSize,vPrmMaxFileSize:int64;vPrmDateOption:integer;vPrmMinDate,vPrmMaxDate:Double;

begin
     ForDirReq:=0;
     vPrmMinFileSize:=appdefaultsrec.MinFileSize;
     vPrmMaxFileSize:=appdefaultsrec.MAxFileSize;
     vPrmDateOption:=appdefaultsrec.DateOption;
     vPrmMinDate:=appdefaultsrec.MinDate;
     vPrmMaxDate:=appdefaultsrec.MaxDate;


     vWordsOnly:=False;
     vMatchReq:=False;
     vUMatchReq:=False;
     vSearchOnly:=False;
     vStopAfterMatchThisFile:=False;
     vStopAfterMatchAll:=False;
     vSearchStarter:=False;
     vSearchStopper:=False;
     vGroupNumber:=0;

     vPrjCount:=0;
     vProjects:='';//proje dosyalarý
     vSubs:=False;
     vIncPtr:=appdefaultsrec.IncFilePtr;
     vExcPtr:=appdefaultsrec.ExcFilePtr;
     vSearch:='';
     vRepSubMatch:='';
     vNewText:='';
     vDestDir:=appdefaultsrec.DestDir;

     vOptionsStr:='';
     vAreaInfoStr:='';
     vStart1Str:='';
     vStart2Str:='';
     vStop1Str:='';
     vStop2Str:='';
     vcsvcstr:=';';


     vCaseSwc:=False;
     vKeepCase:=False;
     vStartSearch:=False;
     vStartReplace:=False;
     vAutoClose:=False;
     vAutoHide:=false;
     vIgnoreErrors:=False;

     SelFileList.Clear;
     frmopened:=False;
     FirstTimer.Enabled:=False;
     errlst:=TASCMRStringList.Create;
     ls:=TASCMRStringList.Create;
     for j := 1 to ParamCount do
     begin
          f:=Trim(ParamStr(j));
          //showmessage(f);
          lf:=Length(f);
          if Pos('-',f)=1 then f1:=Copy(f,2,lf) else f1:='';
          eqp:=Pos('=',f1);
          lf1:=Length(f1);
          if eqp>1 then
          begin
               f2:=Copy(f1,eqp+1,lf1);
               f1:=Copy(f1,1,eqp-1);
          end else f2:='';                
          {$IF (ASCUniCodeUsing=1)}
          f1:=Tnt_WideUpperCase(f1);
          {$ELSE}
          f1:=AnsiUpperCase(f1);
          {$IFEND}
          if f1<>'' then
          begin
               if ForDirReq=0 then ForDirReq:=1;
               if (f1=cmdSubs) or (f1=cmdSSubs) then
               Begin
                    vSubs:=True;
               end else
               if (f1=cmdNoSubs) or (f1=cmdSNoSubs) then
               Begin
                    vSubs:=False;
               end else
               if (f1=cmdExtWordFile) or (f1=cmdSExtWordFile) then
               Begin
                    if f2='' then errlst.Add(errNoExWordFile)
                    else
                    ExtWordFile:=f2;
               end else
               if (f1=cmdExtLinesFile) or (f1=cmdSExtLinesFile) then
               Begin
                    if f2='' then errlst.Add(errNoExLineFile)
                    else
                    ExtLineFile:=f2;
               end else
               if (f1=cmdReportFile) or (f1=cmdSReportFile) then
               Begin
                    if f2='' then errlst.Add(errNoReportFile)
                    else
                    ReportFile:=f2;
               end else
               if (f1=cmdIncPtr) or (f1=cmdSIncPtr) then
               Begin
                    if f2='' then errlst.Add(errNoIncPtr)
                    else
                    vIncPtr:=f2;
               end else
               if (cmdExcPtr=f1) or (cmdSExcPtr=f1) then
               Begin
                    if f2='' then errlst.Add(errNoExcPtr)
                    else
                    vExcPtr:=f2;
               end else
               if (cmdSearch=f1) or (cmdSSearch=f1) then
               Begin
                    vSearch:=f2;
               end else
               if (cmdCase=f1) or (cmdSCase=f1)then
               Begin
                    vCaseSwc:=True;
               end else
               if (cmdNoCase=f1) or (cmdSNoCase=f1) then
               Begin
                    vCaseSwc:=False;
               end else
               if (cmdKeepCase=f1) or (cmdSKeepCase=f1) then
               Begin
                    vKeepCase:=True;
               end else
               if (cmdNoKeepCase=f1) or (cmdSNoKeepCase=f1) then
               Begin
                    vKeepCase:=False;
               end else
               if (cmdRegex=f1) or (cmdSRegex=f1) then
               Begin
                    vRegEx:=True;
               end else
               if (cmdNoRegex=f1) or (cmdSNoRegex=f1) then
               Begin
                    vRegEx:=False;
               end else

{   vWordsOnly,
   vMatchReq,
   vUMatchReq,
   vSearchOnly,
   vStopAfterMatch
}               if (cmdWordsOnly=f1) or (cmdSWordsOnly=f1) then
               Begin
                    vWordsOnly:=True;
               end else
               if (cmdStopAfterMatchThisFile=f1) or (cmdSStopAfterMatchThisFile=f1) then
               Begin
                    vStopAfterMatchThisFile:=True;
               end else
               if (cmdStopAfterMatchAll=f1)  or (cmdSStopAfterMatchAll=f1) then
               Begin
                    vStopAfterMatchAll:=True;
               end else
               if (cmdRepSubMatch=f1) or (cmdSRepSubMatch=f1) then
               Begin
                    if f2='' then errlst.Add(errNoRepSubMatchText)
                    else
                    vRepSubMatch:=f2;
               end else
               if (cmdNewText=f1) or (cmdSNewText=f1) then
               Begin
                    if f2='' then errlst.Add(errNoNewText)
                    else
                    vNewText:=f2;
               end else
               if (cmdDestDir=f1) or (cmdSDestDir=f1) then
               Begin
                    if f2='' then errlst.Add(errNoDestDir)
                    else
                    vDestDir:=f2;
               end else
               //{dateoptions 0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom}
               if (cmdDMAnyTime=f1) or (cmdSDMAnyTime=f1) then
               Begin
                    vPrmDateOption:=0;
               end else
               if (cmdDMWithinanhour=f1) or (cmdSDMWithinanhour=f1)then
               Begin
                    vPrmDateOption:=1;
               end else
               if (cmdDMToday=f1) or (cmdSDMToday=f1) then
               Begin
                    vPrmDateOption:=2;
               end else
               if (cmdDMYesterday=f1) or (cmdSDMYesterday=f1) then
               Begin
                    vPrmDateOption:=3;
               end else
               if (cmdDMThisweek=f1) or (cmdSDMThisweek=f1) then
               Begin
                    vPrmDateOption:=4;
               end else
               if (cmdDMThismonth=f1) or (cmdSDMThismonth=f1) then
               Begin
                    vPrmDateOption:=5;
               end else
               if (cmdDMThisYear=f1) or (cmdSDMThisYear=f1) then
               Begin
                    vPrmDateOption:=6;
               end else
               if (cmdCDMAfter=f1) or (cmdSCDMAfter=f1) then
               Begin
                    if f2='' then errlst.Add(errNoCMDAfter)
                    else
                    Begin
                         vPrmDateOption:=7;
                         vPrmMinDate:=TextToDbl(f2,asfDate);
                    End;
               end else
               if (cmdCDMDBefore=f1) or (cmdSCDMDBefore=f1) then
               Begin
                    if f2='' then errlst.Add(errNoCMDBefore)
                    else
                    Begin
                         vPrmDateOption:=7;
                         vPrmMaxDate:=TextToDbl(f2,asfDate);
                    End;
               end else

               if (cmdMinFileSize=f1) or (cmdSMinFileSize=f1) then
               Begin
                    if f2='' then errlst.Add(errNoMinFileSize)
                    else
                    vPrmMinFileSize:=TextToInt(f2);
               end else
               if (cmdMaxFileSize=f1) or (cmdSMaxFileSize=f1) then
               Begin
                    if f2='' then errlst.Add(errNoMaxFileSize)
                    else
                    vPrmMaxFileSize:=TextToInt(f2);
               end else
               {
                    cmdDMAnyTime='DMANYTIME';
                    cmdDMWithinanhour='DMWITHINANHOUR';
                    cmdDMToday='DMTODAY';
                    cmdDMYesterday='DMYESTERDAY';
                    cmdDMThisweek='DMTHISWEEK';
                    cmdDMThismonth='DMTHISMONTH';
                    cmdDMThisYear='DMTHISYEAR';
                    cmdCDMAfter='CDMAFTER';
                    cmdCDMDBefore='CDMBEFORE';
                    cmdMinFileSize='MINFILESIZE';
                    cmdMaxFileSize='MAXFILESIZE';
               }
               if (cmdIgnoreErrors=f1) or (cmdSIgnoreErrors=f1) then
               Begin
                    vIgnoreErrors:=True;
               end else
               if (cmdStartSearch=f1) or (cmdSStartSearch=f1) then
               Begin
                    vStartSearch:=True;
               end else
               if (cmdStartReplace=f1) or (cmdSStartReplace=f1) then
               Begin
                    vStartReplace:=True;
               end else
               if (cmdAutoClose=f1) or (cmdSAutoClose=f1) then
               Begin
                    vAutoClose:=True;
               end else
               if (cmdHide=f1) or (cmdSHide=f1) then
               Begin
                    vAutoHide:=True;
               end;
          end else
          Begin
               if f<>'' Then
               Begin
                    if ExtractFileExt(f)='.'+ReplacerExt Then
                    Begin
                         ForDirReq:=-1;
                         vProjects:=vProjects+f+';';
                         vPrjCount:=vPrjCount+1;
                    end else
                    Begin
                         ls.Add(f);//dosya ve diznler import ediliyor
                         ForDirReq:=1;
                    End;
               End;

          end;
     end;
     if vPrjCount>0 then
     for j := 1 to vPrjCount do
     begin
          f:=csvData(vProjects,j);
          OpenRDFFile(f,vStartSearch, vStartReplace);
     end;

     if (ls.Count>0) then
     begin
          if vNewText<>'' then
          fswc:=2 else fswc:=1;
          if ls.Count>1 then
          fswc:=fswc+2;

          ProcessCounter:=ProcessCounter+1;
          frmopened:=True;
          newFrm:=TRepFrmF.Create(Self);
          With newFrm Do
          Begin
               FormStyleSwc:=fswc;
               EditDisplay;
               case fswc of
                    2,4:Caption:=msgReplacePrjBsl+inttostr(ProcessCounter);
                    else Caption:=msgReplacePrjBsl+inttostr(ProcessCounter);
               end;
               fStartReplace:=vStartReplace;
               Show;
          end;
          if not (vStartSearch or vStartReplace) then
          Begin
               ImportFilesF:=TImportFilesF.Create(Nil);
               With ImportFilesF Do
               Begin
                    SelResult:=False;
                    SourceList.Items.Assign(ls);
                    EditDisplay(fswc);
                    SelAllBtnClick(nil);
                    SelMinFileSize:=vPrmMinFileSize;
                    SelMaxFileSize:=vPrmMAxFileSize;
                    SelDateOption:=vPrmDateOption;
                    SelMinDate:=vPrmMinDate;
                    SelMaxDate:=vPrmMaxDate;
                    ExMaskE.Text:=vExcPtr;
                    InMaskE.Text:=vIncPtr;
                    DestE1.Text:=vDestDir;
                    SubsChk.Checked:=vSubs;

                    ShowModal;
                    subfiles:='N';

                    if DestOptionsR1.ItemIndex=0 then
                    dest:=GetDirectory(appdefaultsrec.DestDir)
                    else
                    dest:=GetDirectory(DestE1.Text);

                    MinFileSize:=SelMinFileSize;
                    MaxFileSize:=SelMaxFileSize;
                    DateOption:=SelDateOption;
                    MinDate:=SelMinDate;
                    MaxDate:=SelMaxDate;

                    for j := 0 to SourceList.Count - 1 do
                    Begin
                         s:=SourceList.Items.Strings[j];
                         if FileExists(s) then
                         Begin
                              src:=ExtractFilePath(s);
                              ifileptr:=ExtractFileName(s);//file patern dosya adýný alýr
                              exfileptr:='';
                              fileordir:='F';
                              subfiles:='N';
                         End else
                         Begin
                              src:=GetDirectory(s);
                              ifileptr:=InMaskE.Text;
                              exfileptr:=ExMaskE.Text;
                              fileordir:='D';
                              if SubsChk.Checked then subfiles:='Y' else subfiles:='N';
                         End;
                         SelFileList.Add(csvPrepareColumn(src)+';'+csvPrepareColumn(dest)+';'+
                         csvPrepareColumn(ifileptr)+';'+csvPrepareColumn(exfileptr)+';'+
                         csvPrepareColumn(fileorDir)+';'+csvPrepareColumn(subfiles)+';'+
                         Inttostr(MinFileSize)+';'+Inttostr(MaxFileSize)+';'+Inttostr(DateOption)+
                         ';'+DblToText(MinDate,asfDateTime)+';'+DblToText(MaxDate,asfDateTime)+';');
                    End;
                    if SelResult then newFrm.AddSelectedFilesToSrc;

                    if (ASCUniCodeUsing=1) then vRegEx:=True;
                    if vRegex  then vRegExStr:='1' Else vRegExStr:='0';
                    if vCaseSwc then vCaseStr:='1' Else vCaseStr:='0';


                    if vWordsOnly then vWordsOnlyStr:='1' Else vWordsOnlyStr:='0';
                    if vMatchReq then vMatchReqOpt:='1' Else vMatchReqOpt:='0';
                    if vUMatchReq then vUMatchReqOpt:='1' Else vUMatchReqOpt:='0';
                    if vSearchOnly then vSearchOnlyOpt:='1' Else vSearchOnlyOpt:='0';

                    {
                    SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
                    CaseSwc,KeepCase,RegEx,WordsOnly,
                    MatchReq ,
                    uMatchReq ,
                    SearchOnly,
                    StopAfterFMatch:boolean;
                    areainfo,start1,start2,stop1,stop2,csvchar:ASCMRString}
                    newFrm.AddToWordList(vSearch,vRepSubMatch,vNewText,vCaseSwc,vKeepCase,vRegEx,vWordsOnly,
                    vMatchReq,vUMatchReq,vSearchOnly,vStopAfterMatchThisFile,vStopAfterMatchAll,
                    vSearchStarter,vSearchStopper,
                    TextToInt(vAreaInfoStr),TextToInt(vStart1Str),TextToInt(vStart2Str),
                    TextToInt(vStop1Str),TextToInt(vStop2Str),vcsvcstr,vGroupNumber);
               end;

          End else  //eðer hemen iþlem baþlayacaksa bilgiler tamamen parametrelerden alýnýr
          Begin
                    if vSubs then
                    subfiles:='Y'
                    else
                    subfiles:='N';
                    if vDestDir='' then
                    dest:=GetDirectory(appdefaultsrec.DestDir)
                    else
                    dest:=GetDirectory(vDestDir);

                    MinFileSize:=vPrmMinFileSize;
                    MaxFileSize:=vPrmMaxFileSize;
                    DateOption:=vPrmDateOption;
                    MinDate:=vPrmMinDate;
                    MaxDate:=vPrmMaxDate;

                    for j := 0 to ls.Count - 1 do
                    Begin
                         s:=ls.Strings[j];
                         if FileExists(s) then
                         Begin
                              src:=ExtractFilePath(s);
                              ifileptr:=ExtractFileName(s);//file patern dosya adýný alýr
                              exfileptr:='';
                              fileordir:='F';
                              subfiles:='N';
                         End else
                         Begin
                              src:=GetDirectory(s);
                              ifileptr:=vIncPtr;
                              exfileptr:=vExcPtr;
                              fileordir:='D';
                              if vSubs then subfiles:='Y' else subfiles:='N';
                         End;
                         SelFileList.Add(csvPrepareColumn(src)+';'+csvPrepareColumn(dest)+';'+
                         csvPrepareColumn(ifileptr)+';'+csvPrepareColumn(exfileptr)+';'+
                         csvPrepareColumn(fileorDir)+';'+csvPrepareColumn(subfiles)+';'+
                         Inttostr(MinFileSize)+';'+Inttostr(MaxFileSize)+';'+Inttostr(DateOption)+
                         ';'+DblToText(MinDate,asfDateTime)+';'+DblToText(MaxDate,asfDateTime)+';');
                    End;
                    newFrm.AddSelectedFilesToSrc;
                    if (ASCUniCodeUsing=1) then vRegEx:=True;
                    if vRegex then vRegExStr:='Y' Else vRegExStr:='N';
                    if vCaseSwc then vCaseStr:='Y' Else vCaseStr:='N';


                    if vWordsOnly then vWordsOnlyStr:='1' Else vWordsOnlyStr:='0';
                    if vMatchReq then vMatchReqOpt:='1' Else vMatchReqOpt:='0';
                    if vUMatchReq then vUMatchReqOpt:='1' Else vUMatchReqOpt:='0';
                    if vSearchOnly then vSearchOnlyOpt:='1' Else vSearchOnlyOpt:='0';

                    {
                    SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
                    CaseSwc,KeepCase,RegEx,WordsOnly,
                    MatchReq ,
                    uMatchReq ,
                    SearchOnly,
                    StopAfterFMatch:boolean;
                    areainfo,start1,start2,stop1,stop2,csvchar:ASCMRString}
                    newFrm.AddToWordList(vSearch,vRepSubMatch,vNewText,vCaseSwc,vKeepCase,vRegEx,vWordsOnly,
                    vMatchReq,vUMatchReq,vSearchOnly,vStopAfterMatchThisFile,vStopAfterMatchAll,
                    vSearchStarter,vSearchStopper,
                    TextToInt(vAreaInfoStr),TextToInt(vStart1Str),TextToInt(vStart2Str),
                    TextToInt(vStop1Str),TextToInt(vStop2Str),vcsvcstr,vGroupNumber);

                    if (vSearch<>'') and ((fswc in [1,3]) or (vNewText<>'')) and (vIgnoreErrors or (errlst.Count=0))then
                       if fswc<3 then newFrm.SingleSearchBtnClick(nil) else newFrm.SearchBtnClick(nil);
                    if vAutoHide and vAutoClose then newFrm.Hide;

          End;
     end else
     if ForDirReq>0 then
     begin
          errlst.Add(errNoFilesOrDirs);
     end;

     ls.Free;
     ls:=nil;

     if (errlst.Count>0) and (not vIgnoreErrors) then
     begin
          MessageDlg(ErrLst.Text,mtError,[mbOK],0);

     end else
     begin
          if vAutoHide and vAutoClose then Hide;
     end;
     errlst.Free;
     errlst:=nil;
     //if not frmopened then New1Click(nil);



end;

procedure TRepMainF.InvalidTimerTimer(Sender: TObject);
begin
     //Program lisansli degil
     if InvalidTimer.Tag=1 then
     begin
          InvalidTimer.Tag:=0;
          WinExec(PChar(AppPath+'RegTool.exe'),SW_SHOWNORMAL);
     end
     else
     Close;
end;

function TRepMainF.NewEmptyRepFrm: Boolean;
begin
     NewEmptyRepFrm:=False;
     ProcessCounter:=ProcessCounter+1;
     try
     With TRepFrmF.Create(Self) Do
     Begin
          FormStyleSwc:=0;
          Show;
     end;
     except
           exit;
     end;
     NewEmptyRepFrm:=True;
end;

procedure TRepMainF.Open1Click(Sender: TObject);
Var
   o:integer;
   nrf:TRepFrmF;
begin
     {$IF (DemoVersiyon=0) or (DemoVersiyon=2)}
     vAutoClose:=False;

     ProcessCounter:=ProcessCounter+1;
     if not OD2.Execute then exit;
     if OD2.FileName='' then exit;

     nrf:=TRepFrmF.Create(Self);
     with nrf do
     Begin
          Caption:=msgReplacePrjBsl+inttostr(ProcessCounter);
          frepfilename:=OD2.FileName;
          OpenRepFile;
          Show;
     end;
     {$ELSE}
       MessageDlg(DemoProgramMsj1,mtInformation,[mbOK],0);
     {$IFEND}
end;

procedure TRepMainF.OpenRDFFile(f: ASCMRString;FStartSearchSwc,FStartRepSwc:Boolean);
var
   nrf:TRepFrmF;
begin
     if f='' Then exit;

     nrf:=TRepFrmF.Create(Self);
     with nrf do
     Begin
          Caption:=msgReplacePrjBsl+inttostr(ProcessCounter);
          frepfilename:=f;
          OpenRepFile;
          fStartReplace:=FStartRepSwc;
          if FStartSearchSwc or fStartReplace then
          if FormStyleSwc<3 then SingleSearchBtnClick(nil) else SearchBtnClick(nil);
          if vAutoClose and vAutoHide then Hide else Show;
     end;
end;

function TRepMainF.SelectDir(dir: ASCMRstring): ASCMRstring;
var
  fDir: string;
begin
  fDir := dir;
  if SelectDirectory(fDir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    Result := fDir
    Else
    Result:='';

end;

function TRepMainF.SelectFiles(DstDir:ASCMRString;FrmStyle:integer): Boolean;
Var
   Src,Dest,ifileptr,exfileptr,FileOrDir,subfiles,msg:ASCMRString;
   MinFileSize,MaxFileSize:int64;DateOption:integer;MinDate,MaxDate:Double;
   FFileNameOperation:Boolean;
begin
     SelFileList.Clear;
     SelDirF:=TSelDirF.Create(Nil);
     With SelDirF Do
     Begin
          SelResult:=False;
          DestE1.Text:=DstDir;
          DestE2.Text:=DstDir;
          EditDisplay(FrmStyle);
          ShowModal;
          subfiles:='N';
          if PGCtrl.ActivePageIndex=0 Then
          Begin
               src:=GetDirectory(DirE.Text);
               if DestOptionsR1.ItemIndex=0 then
               dest:=GetDirectory(DstDir)
               else
               dest:=GetDirectory(DestE1.Text);
               ifileptr:=InMaskE.Text;
               exfileptr:=ExMaskE.Text;
               fileordir:='D';
               if SubsChk.Checked then subfiles:='Y';
               FFileNameOperation:=FileNameOprChk1.Checked;
          end else
          Begin
               src:=ExtractFilePath(FileNameE.Text);
               if DestOptionsR2.ItemIndex=0 then
               dest:=GetDirectory(DstDir)
               else
               dest:=GetDirectory(DestE2.Text);
               ifileptr:=ExtractFileName(FileNameE.Text);//file patern dosya adýný alýr
               exfileptr:='';
               fileordir:='F';
               FFileNameOperation:=False;
          end;

          MinFileSize:=SelMinFileSize;
          MaxFileSize:=SelMaxFileSize;
          DateOption:=SelDateOption;
          MinDate:=SelMinDate;
          MaxDate:=SelMaxDate;

          SelFileList.Add(csvPrepareColumn(src)+';'+csvPrepareColumn(dest)+';'+
          csvPrepareColumn(ifileptr)+';'+csvPrepareColumn(exfileptr)+';'+
          csvPrepareColumn(fileorDir)+';'+csvPrepareColumn(subfiles)+';'+
          Inttostr(MinFileSize)+';'+Inttostr(MaxFileSize)+';'+Inttostr(DateOption)+
          ';'+DblToText(MinDate,asfDateTime)+';'+DblToText(MaxDate,asfDateTime)+';'+
          BoolToStrYN(FFileNameOperation)+';');
          Result:=SelResult;
     end;
end;

procedure TRepMainF.SozlukYukle;
begin
     DropDownAreaPnl.Caption:=msgDropDownAreaAck;
     DropDownAreaLbl.Caption:=msgDropDownAreaLbl;

end;

procedure TRepMainF.StartBtn1Click(Sender: TObject);
Var
   i:integer;
begin
     i:=0;
     if Sender is TBitBtn then
     i:=(Sender as TBitBtn).Tag
     else
     if Sender is TMenuItem then
     i:=(Sender as TMenuItem).Tag;

     if i<1 then exit;

     ProcessCounter:=ProcessCounter+1;
     With TRepFrmF.Create(Self) Do
     Begin
          FormStyleSwc:=i;

          EditDisplay;
          case i of
               2,4:Caption:=msgReplacePrjBsl+inttostr(ProcessCounter);
               else Caption:=msgReplacePrjBsl+inttostr(ProcessCounter);
          end;
          if DropDownItemLst.Count>0 then
          begin
               if RepMainF.ImportFiles(DropDownItemLst,FormStyleSwc,appdefaultsrec.DestDir) Then
               begin
                    AddSelectedFilesToSrc;
                    DropDownItemLst.Clear;
               end;
          end;
          Show;
     end;

end;

procedure TRepMainF.StartBtn4Click(Sender: TObject);
begin
     {$IF (DemoVersiyon=0) or (DemoVersiyon=2)}
     StartBtn1Click(Sender);
     {$ELSE}
       MessageDlg(DemoProgramMsj1,mtInformation,[mbOK],0);
     {$IFEND}

end;

procedure TRepMainF.DenemeSrmTimTimer(Sender: TObject);
begin
     DenemeSrmTim.Enabled:=False;
     MessageDlg(msgDenemeSurumuSonu,mtInformation,[mbOk],0);
     Close;

end;

procedure TRepMainF.OptionsMClick(Sender: TObject);
begin
     PrmF:=TPrmF.Create(nil);
     PrmF.FileModifyRClick(nil);
     PrmF.FileSizeRClick(nil);
     PrmF.ShowModal;
     PrmF.Free;
     PrmF:=Nil;
end;

end.
