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
 
unit RepFrmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,FileCtrl, StdCtrls, Buttons, Grids,
  ExtCtrls, ComCtrls,RepConstU,RegExpr,RepLib,ClipBrd, ImgList,
  MulTreeList, RVScroll, RichView,
  RVStyle,MarqueeProgressBar, StrUtils,RepThreadU,ToolWin,
  SysImg,ProcessViewU,DateUtils,ActnList, XPStyleActnCtrls,
  CollapsePanel, ActnMan,   Menus,cUnicodeReader,Masks
  {$IF (ASCUniCodeUsing=1)}
  ,TntStdCtrls,TntClasses,TNTSysUtils
  {$IFEND}
  ;
type
  TRepFrmF = class(TForm)
    od1: TOpenDialog;
    SD1: TSaveDialog;
    PGCtrl: TPageControl;
    FileSelectionPg: TTabSheet;
    WordsPg: TTabSheet;
    ControlsPg: TTabSheet;
    ChangePg: TTabSheet;
    Panel1: TPanel;
    WordsSayfaLbl: TLabel;
    Panel2: TPanel;
    Next3Btn: TBitBtn;
    CheckHeadL: TLabel;
    Panel3: TPanel;
    KontrolBtn: TBitBtn;
    Panel4: TPanel;
    WrongRowsLbl: TLabel;
    Panel5: TPanel;
    Splitter1: TSplitter;
    CheckResultLbl: TLabel;
    ErrMsgBox: TMemo;
    AddWordBtn: TBitBtn;
    EditWordBtn: TBitBtn;
    EraseWordBtn: TBitBtn;
    WordGrid: TStringGrid;
    WrongRowsGrid: TStringGrid;
    SearchBtn: TBitBtn;
    FileListPg: TTabSheet;
    FileBtnPnl: TPanel;
    RemoveBtn: TBitBtn;
    ViewDetailBtn: TBitBtn;
    Next4Btn: TBitBtn;
    ViewDiffBtn: TBitBtn;
    SingleSearchPg: TTabSheet;
    Panel7: TPanel;
    ProjectDestDirPan: TPanel;
    Label1: TLabel;
    ProjectDestE1: TEdit;
    DestBtn1: TBitBtn;
    Panel8: TPanel;
    SelList1: TStringGrid;
    Panel6: TPanel;
    SrcAddBtn: TBitBtn;
    SrcEditBtn: TBitBtn;
    SrcDelBtn: TBitBtn;
    SrcNext1Btn: TBitBtn;
    FileSelPgLbl: TLabel;
    SingleWordPan: TPanel;
    SearchL: TLabel;
    SingleNewL: TLabel;
    SingleCaseChk: TCheckBox;
    SingleRegExChk: TCheckBox;
    SingleOldE: TMemo;
    SingleNewE: TMemo;
    SingleFilePan: TPanel;
    SingleSourceL: TLabel;
    SingleSourceE: TEdit;
    SingleSelDirBtn: TBitBtn;
    SingleDestL1: TLabel;
    SingleDestinationE: TEdit;
    BitBtn4: TBitBtn;
    SingleSearchBtn: TBitBtn;
    ReportPg: TTabSheet;
    ReportRE: TRichEdit;
    Panel9: TPanel;
    CloseBtn: TBitBtn;
    Panel10: TPanel;
    BitBtn1: TBitBtn;
    Degistir: TBitBtn;
    SaveReportBtn: TBitBtn;
    PrintReportBtn: TBitBtn;
    Label3: TLabel;
    QueueTimer: TTimer;
    SBar1: TStatusBar;
    Panel11: TPanel;
    ToolBar1: TToolBar;
    SaveBtn: TToolButton;
    CloseBtnT: TToolButton;
    SaveAsBtn: TToolButton;
    OpenBtn: TToolButton;
    PrcViewBtn: TToolButton;
    SubMatchL: TLabel;
    SubMatchE: TMemo;
    SingleOnMatching: TComboBox;
    onmatchedlbl: TLabel;
    SingleWordsOnlyChk: TCheckBox;
    BitBtn3: TBitBtn;
    ActionManager1: TActionManager;
    OpenAct: TAction;
    SaveAct: TAction;
    SaveAsAct: TAction;
    ShwPrcViewAct: TAction;
    CloseAct: TAction;
    SearchAct: TAction;
    StartRepAct: TAction;
    CheckBtn: TAction;
    AddAct: TAction;
    EditAct: TAction;
    DeleteAct: TAction;
    NextAct: TAction;
    ViewDetailAct: TAction;
    ViewDiffAct: TAction;
    ShowRemovedAct: TAction;
    SaveReportAct: TAction;
    PrintAct: TAction;
    SaveRepSD: TSaveDialog;
    SingleKeepCase: TCheckBox;
    RemoveAct: TAction;
    OtherActBtn: TBitBtn;
    ShowMatchesAct: TAction;
    ThreadStopper: TTimer;
    ViewDetPUP: TPopupMenu;
    ViewNormal1: TMenuItem;
    ViewHex1: TMenuItem;
    ViewDetPBtn: TBitBtn;
    ControlPgNotLbl: TLabel;
    PrintBtn: TBitBtn;
    BackAck: TAction;
    View80ColumnText1: TMenuItem;
    SysVarL1: TLabel;
    SysVarL2: TLabel;
    SysVarL3: TLabel;
    SysVarPUP: TPopupMenu;
    svpupsecFILEDIR: TMenuItem;
    svpupsecFULLFILENAME: TMenuItem;
    svpupsecFILENAMEWITHEXT: TMenuItem;
    svpupsecFILENAMENOEXT: TMenuItem;
    svpupsecCURRENTDATE: TMenuItem;
    svpupsecCURRENTTIME: TMenuItem;
    svpupsecCURRENTYEAR: TMenuItem;
    svpupsecCURRENTMONTH: TMenuItem;
    svpupsecCURRENTDAY: TMenuItem;
    svpupsecFILEEX: TMenuItem;
    svpupsecFILESIZE: TMenuItem;
    FileInformations1: TMenuItem;
    svpupsecFILEMODIFYDATE: TMenuItem;
    svpupsecFILEMODIFYYEAR: TMenuItem;
    svpupsecFILEMODIFYMONTH: TMenuItem;
    svpupsecFILEMODIFYDAY: TMenuItem;
    CurrentDateTime1: TMenuItem;
    ThreadIslemleriTmr: TTimer;
    ViewDiffPUP: TPopupMenu;
    ViewDiffNormalMI: TMenuItem;
    ViewDiff80ColumnMI: TMenuItem;
    ViewDiffHexMI: TMenuItem;
    ViewDiffPBtn: TBitBtn;
    OtherActPUP: TPopupMenu;
    ShowRemovedFilesMI: TMenuItem;
    ShowMatchesForm1: TMenuItem;
    ExportFileList1: TMenuItem;
    extFileOnlyFileNamesWithoutpathnames1: TMenuItem;
    extFileOnlyfilenameswithfilepaths1: TMenuItem;
    extFileDetailedlist1: TMenuItem;
    CSVFileDetailedlist1: TMenuItem;
    ViewDiffPAct: TAction;
    ShowExtractedWords1: TMenuItem;
    ShowExtractedLines1: TMenuItem;
    HexLbl1: TLabel;
    HexLbl2: TLabel;
    HexLbl3: TLabel;
    SOpenAct: TAction;
    Action11: TMenuItem;
    ShOpenAct: TAction;
    svpupsecCURCELL: TMenuItem;
    Specific1: TMenuItem;
    procedure SelList1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SelList1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SingleSearchBtnClick(Sender: TObject);
    procedure SingleSelDirBtnClick(Sender: TObject);
    procedure ViewDiffBtnClick(Sender: TObject);
    procedure ViewDetailBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure Next4BtnClick(Sender: TObject);
    procedure Next3BtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);

    procedure SearchBtnClick(Sender: TObject);
    procedure WrongRowsGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SelList1RowMoved(Sender: TObject; FromIndex, ToIndex: Integer);
    procedure WordGridRowMoved(Sender: TObject; FromIndex, ToIndex: Integer);
    procedure SrcDelBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure SrcNext1BtnClick(Sender: TObject);
    procedure EraseWordBtnClick(Sender: TObject);
    procedure EditWordBtnClick(Sender: TObject);
    procedure AddWordBtnClick(Sender: TObject);
    procedure SrcEditBtnClick(Sender: TObject);
    procedure SrcAddBtnClick(Sender: TObject);
    procedure DegistirClick(Sender: TObject);
    procedure KontrolBtnClick(Sender: TObject);
    procedure SelList1DropMsg (var Msg : TMessage) ;
    procedure SelListWndProc(var Message: TMessage);
    procedure SelListWndProc2(var Message: TMessage);
    procedure FileListClick(Sender:TObject);
    procedure RemovedsBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormDestroy(Sender: TObject);
    procedure SearchFileFound(Sender: TObject; FileName: ASCMRstring);
    procedure SearchCompleteEvent(Sender:TObject);
    procedure QueueTimerTimer(Sender: TObject);
    procedure SearchScanningNotify(Sender:TObject);
    procedure CloseBtnTClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveAsBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure PrcViewBtnClick(Sender: TObject);
    procedure SelList1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn3Click(Sender: TObject);
    procedure OnFileScannedEvent(Sender: TObject);
    procedure StartSearchCmd(Sender:TObject);
    procedure AddActExecute(Sender: TObject);
    procedure EditActExecute(Sender: TObject);
    procedure DeleteActExecute(Sender: TObject);
    procedure NextActExecute(Sender: TObject);
    procedure SaveReportBtnClick(Sender: TObject);
    procedure PrintReportBtnClick(Sender: TObject);
    procedure WrongRowsGridDblClick(Sender: TObject);
    procedure ShowMatchesActExecute(Sender: TObject);
    procedure ThreadStopperTimer(Sender: TObject);
    procedure StopSearch(Sender:TObject);
    procedure ViewNormal1Click(Sender: TObject);
    procedure ViewHex1Click(Sender: TObject);
    procedure ViewDetPBtnClick(Sender: TObject);
    procedure DestBtn1Click(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure BackAckExecute(Sender: TObject);
    procedure View80ColumnText1Click(Sender: TObject);
    procedure svpupsecMenuClick(Sender: TObject);
    procedure SysVarL1Click(Sender: TObject);
    procedure SysVarL2Click(Sender: TObject);
    procedure SysVarL3Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ThreadIslemleriTmrTimer(Sender: TObject);
    procedure EST1Click(Sender: TObject);
    procedure ViewDiffNormalMIClick(Sender: TObject);
    procedure ViewDiff80ColumnMIClick(Sender: TObject);
    procedure ViewDiffHexMIClick(Sender: TObject);
    procedure ViewDiffPBtnClick(Sender: TObject);
    procedure OtherActBtnClick(Sender: TObject);
    procedure extFileOnlyFileNamesWithoutpathnames1Click(Sender: TObject);
    procedure extFileOnlyfilenameswithfilepaths1Click(Sender: TObject);
    procedure extFileDetailedlist1Click(Sender: TObject);
    procedure CSVFileDetailedlist1Click(Sender: TObject);
    procedure ViewDiffActUpdate(Sender: TObject);
    procedure ShowExtractedWords1Click(Sender: TObject);
    procedure ShowExtractedLines1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HexLbl1Click(Sender: TObject);
    procedure HexLbl2Click(Sender: TObject);
    procedure HexLbl3Click(Sender: TObject);
    procedure ShellFileOpen1Click(Sender: TObject);
    procedure OtherActPUPPopup(Sender: TObject);
  protected
    RegExObj:TRegExpr;
    DirList1:TpTree;
    DirListTV1:TTreeList;
    {$IF DetailObject=1}
    RichView1: TRichView;
    {$IFEND}
    ColorTbl:Array of TColor;
    OldSelListWndProc,OldSelListWndProc2:TWndMethod;
    MFileSearchObj:TMainFileSearch;
    MFileSearching:Boolean;
    MQueueThread:TQueueThread;
    ASCRegExSubMatch:ASCMRString;
    SelectedSysVarPUP:integer; //1:Search Text ,2:Sub Match Text,3:ReplaceText
    ASCRegExKeepCase:Boolean;
    FileSearchNormallyTag, //Bu dosya arama thread boþtayken FileSearchNormallyEvt ile kullanýlýr
    RMatchedFileCounter:integer;  //Dosya arama kriterlerine uygun olan ve arama listesine eklenen dosya sayisi
    procedure ASCRegExOnReplace(Sender: TObject; var ReplaceWith: ASCMRstring);
    procedure FileSearchNormallyEvt(Sender:TObject);//Bu dosya arama thread boþtayken çalýþýr.
  private
    { Private declarations }
    procedure WMPaste(var Msg:TMessage); message WM_PASTE;
    procedure MessageReceiver(var msg: TMessage); message ASCThread_MESSAGE;
  public
    { Public declarations }
    ExtWordLst,        //bulunan kelimelerin yazýlacaðý liste
    ExtLineLst         //bulunan satýrlarýn yazýlacaðý liste
    :TASCMRStringList;
    FFormModified,RefreshMatchesForm:Boolean;
    MBar1:TMarqueeProgressBar;
    SysImg1:TSysImageList;
    DirIconIndex,repformid,
    ScannedFCount,FoundedFCount,MatchesCount,NotReadedFileCount:integer;
    RepSabitDSeri:ASCMRString;  //Disk Seri no
    frepfilename,lastfoundfilename:ASCMRString;
    oldremoveds:TASCMRStringList;    //bu listeye çýkarýlan dosya adlarý yazýlýr
    presearchfilelist//bu listeye seçilen dosya filtrelerine uygun dosya adlarý yazýlacak
    :TASCMRStringList;
    srcfilereclist,          //bu listeye içinde aranan kelime bulunan dosyalar yazýlacak
    SrcFileSelReclist,
    WordsList                //aranacak kelimeler bu listeye TWordObj recordu ile eklenecek
    :TList;
    FormStyleSwc:integer; //1:single search,2:single replace,3:Multi Search,4:Multi Replace

    LastAddedFilePath:ASCMRString;
    Lastmainitm: TTreeNode;
    LastAddedIndex:integer;
    LastAddedTime:double;
    FileScannedCount:integer;

    PrcViewF:TProcessViewF;
    FileSaveRequered:Boolean;
    SearchStartTime:TDateTime;
    fStartReplace:Boolean;//auto start replace , cmd line ile çalýþmasý için
    SrcEditBmp,SrcDelBmp:TBitmap;
    FMatchesF:TForm;
    MQueueThreadExecType:TExecType;
    TNTSingleOldE: TASCMemo;
    TNTSingleNewE: TASCMemo;
    TNTSubMatchE: TASCMemo;
    TNTReportRE:TASCRichEdit;
    TNTWordGrid: TASCStringGrid;
    TNTWrongRowsGrid: TASCStringGrid;
    TNTSelList1:TASCStringGrid;
    ThreadIslemleriTags:Array [1..5] of integer;
    function DizinSectir(dzn:ASCMRstring):ASCMRstring;
    procedure OpenRepFile;
    function SaveRepFile:Boolean;
    function SaveProjectDialog:Boolean;
    procedure WriteToSelList(idx:integer);
    procedure AddSelectedFilesToSrc;
    procedure AddEditRepList(ind:integer;Src,Dest,ifileptr,exfileptr:ASCMRString;FileOrDir,subfiles:Char;
    MinFileSize,MaxFileSize,DateOption:integer;MinDate,MaxDate:Double;FFileNameOperation:Boolean);
    procedure RemoveFromRepList(i:integer);
    //procedure SearchInFile(fname:ASCMRstring);//kullanýlmýyor
     {$IF (DemoVersiyon=0)}
    function ReplaceItem(p:PSrcFileRec;TmpRepOpr:boolean):integer;
     {$IFEND}
    Procedure SelListPaint;
    Procedure WordListPaint;
    procedure SngDataToWordList;
    procedure RemoveGridRows(FGrd:TASCStringGrid;rFrom,rTo:integer);
    procedure ClearGrid(FGrd:TASCStringGrid);


    function AddToWordList(SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
    CaseSwc,KeepCase,RegEx,WordsOnly,
    MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
    uMatchReq {Ýçermeyen(Bütün dosyalar için)},
    SearchOnly{(for replace projects)},
    StopAfterFMatchThisFile, //bulduðunda o dosya içinde baþka arama yapma
    StopAfterFMatchAll,SearchStarter,SearchStopper:boolean;  //bulunduðunda aramayý tamamen durdur
    areainfo,start1,start2,stop1,stop2:integer;
    csvchar:ASCMRString;GroupNumber:integer):boolean;
     //Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq,
     //Ýçermeyen(Bütün dosyalar için)uMatchReq,Search Only(for replace projects),7:Stop after first matched

     //areainfo:bilgi arama konum seçenekleri 0:normal,1:dosya baþýndan itibaren baþlangýç start1,
     //karakter sayýsý stop1;2:Satýr numarasý olarak start1 ve stop 1;3:sutun olarak start1,uzunluk stop1;
     //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
     //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
     //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
     //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
     //,start1,start2,stop1,stop2
    function ASCSearcText(Var s:ASCMRstring;f,submatch,r:ASCMRString;sfpth:ASCMRstring;CaseSensitiveSwc,KeepCaseSwc,WordsOnlySwc,
    StopAfterMatchSwc,Replace:Boolean;areainfo,start1,start2,stop1,stop2:integer;
    csvchar:ASCMRString;UseRegEx,SearchStarter,SearchStopper:Boolean;Var S_StartPos,S_StopPos:integer):integer;
    function RegExSearcText(Var s:ASCMRstring;f,submatch,r:ASCMRString;sfpth:ASCMRstring;CaseSensitiveSwc,
    KeepCaseSwc,WordsOnlySwc,StopAfterMatchSwc,Replace:Boolean;areainfo,
    start1,start2,stop1,stop2:integer;csvchar:ASCMRString;GroupNumber:integer):integer;
    procedure AddFilesToList(ListView: TpTree);
    procedure AddFileItemToList(ListView: TpTree;j:integer);
    procedure preparefilelist;
    function preparefilecontents(var fArrASCFilecnt:TASCFileCntArr;const sv:TMemoryStream;
    p:PSrcFileRec;var indexes:TIndxArray;ViewType{0:Normal,1:Hex}:integer;const funixrowlist:TList):boolean;
    procedure DropFileData;
    procedure DropFileSelData;
    procedure EditDisplay;
    procedure ShowInfo(msj:ASCMRstring);
    function AddToSrcFileList(Orjfile,ProcessFile:ASCMRString;MatchCount,MatchLineCount:integer;Destination:ASCMRString;ShowInView,FFileNameOperation:Boolean):boolean;
    function FindInSrcFileList(fn:ASCMRstring):integer;
    procedure PrepareSelFileList; //özellikle file modify zamanlarýný ayarlar
    procedure EraseTempFiles;
    procedure ClearWordList;
    procedure ApplySingleWordChanges;
    procedure WordGridRepaintRow(i:integer);

    procedure multicalc(i:integer);
    procedure MultiExec(i:integer);
    procedure ViewDetailProc(ViewType{0:Normal,1:Hex}:integer);
    procedure ViewDiffProc(ViewType{0:Normal,1:Hex}:integer);
    function ConvertASCMemo(Edt:TMemo):TASCMemo;
    function ConvertASCRichEdit(Edt:TRichEdit):TASCRichEdit;
    function ConvertASCStringGrid(Grid:TStringGrid):TASCStringGrid;
    procedure StartSrv(sender:TObject);
    procedure SozlukYukle;
  end;

var
  RepFrmF: TRepFrmF;

implementation

uses RepMainU,ShellApi,DiffUtilU,DiffUtilUB,RecycleBinU,DetailU,MatchesU,ASCOfisTool,
PreviewU,ProgressU,DosyaGosterU;

{$R *.dfm}

{ TForm1 }


function TRepFrmF.DizinSectir(dzn: ASCMRstring): ASCMRstring;
var
  Dir:string;
begin
  Dir := dzn;
  if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    Result := Dir
  Else
    Result:='';
end;

procedure TRepFrmF.DropFileData;
Var
   j:integer;
   p:PSrcFileRec;
begin
     for j:=srcfilereclist.Count-1 downto 0 do
     begin
          p:=srcfilereclist.Items[j];
          Dispose(p);
     end;
     srcfilereclist.Clear;
end;

procedure TRepFrmF.DropFileSelData;
Var
   j:integer;
   p:PSrcFileSelRec;
begin
     for j:=SrcFileSelReclist.Count-1 downto 0 do
     begin
          p:=SrcFileSelReclist.Items[j];
          Dispose(p);
     end;
     SrcFileSelReclist.Clear;
end;

procedure TRepFrmF.EditActExecute(Sender: TObject);
begin
     Case PGCtrl.ActivePageIndex of
          1:SrcEditBtnClick(Sender);
          2:EditWordBtnClick(Sender);
     End;

end;

procedure TRepFrmF.EditDisplay;
var
   j:integer;
begin
     MFileSearchObj.Prepare(FormStyleSwc);
     case FormStyleSwc of
          1://single search
          begin
               //multi blok 1
               MultiExec(1);
               {
               ///multi 33
               TNTSelList1.ColCount:=8;
               TNTWordGrid.ColCount:=4;
               j:=1;
               TNTWordGrid.ColWidths[j]:=140;inc(j);
               TNTWordGrid.ColWidths[j]:=80;inc(j);
               TNTWordGrid.ColWidths[j]:=110;inc(j);
               Degistir.Visible:=False;
               Next3Btn.Caption:='Search';
               CheckHeadL.Caption:='Check search operation';
               ControlsPg.TabVisible:=False;
               ControlsPg.Visible:=False;
               ProjectDestDirPan.Visible:=False;
               SingleDestL1.Visible:=False;
               ////

               ////multi 37
               SingleDestinationE.Visible:=False;
               SingleNewL.Visible:=False;
               TNTSubMatchE.Visible:=False;
               SubMatchL.Visible:=False;
               TNTSingleNewE.Visible:=False;
               SingleKeepCase.Visible:=False;

               SingleFilePan.Height:=70;
               SingleWordPan.Height:=171;
               FileSelectionPg.Visible:=False;
               FileSelectionPg.TabVisible:=False;
               ////////////

               //multi 26
               WordsPg.Visible:=False;
               WordsPg.TabVisible:=False;
               SingleSearchPg.Visible:=True;
               SingleSearchPg.TabVisible:=True;
               ChangePg.TabVisible:=False;
               ViewDiffAct.Enabled:=False;
               Next4Btn.Caption:='Show Report';
               SingleSearchPg.Caption:='Single Search';
               //////////
               }
               SOpenAct.Enabled:=True;
               SOpenAct.Enabled:=True;
          end;
          2://single replace
          begin
               //multi blok 2
               MultiExec(2);
               {
               ///multi 50
               TNTSelList1.ColCount:=9;
               TNTWordGrid.ColCount:=6;
               j:=1;
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=80;inc(j);
               TNTWordGrid.ColWidths[j]:=110;inc(j);
               Degistir.Visible:=True;
               Next3Btn.Caption:='Search';
               CheckHeadL.Caption:='Check replace operation';
               ///////////

               ///////multi 47
               ControlsPg.TabVisible:=False;
               ControlsPg.Visible:=False;
               ProjectDestDirPan.Visible:=False;
               SingleDestL1.Visible:=True;
               SingleDestinationE.Visible:=True;
               SingleNewL.Visible:=True;
               TNTSubMatchE.Visible:=True;
               SubMatchL.Visible:=True;
               TNTSingleNewE.Visible:=True;
               SingleKeepCase.Visible:=True;
               //////

               }

               SingleFilePan.Height:=116;
               SingleWordPan.Height:=281;
               FileSelectionPg.Visible:=False;
               FileSelectionPg.TabVisible:=False;
               WordsPg.Visible:=False;
               WordsPg.TabVisible:=False;
               SingleSearchPg.Visible:=True;
               SingleSearchPg.TabVisible:=True;
               ChangePg.TabVisible:=True;
               Next4Btn.Caption:='Next';
               ViewDiffAct.Enabled:=True;
               SOpenAct.Enabled:=True;
               SOpenAct.Enabled:=True;
               SingleSearchPg.Caption:=msgSingleReplacePg;
          end;
          3: //multi search
          begin
               TNTSelList1.ColCount:=8;
               TNTWordGrid.ColCount:=4;
               j:=1;
               TNTWordGrid.ColWidths[j]:=140;inc(j);
               TNTWordGrid.ColWidths[j]:=80;inc(j);
               TNTWordGrid.ColWidths[j]:=110;inc(j);
               Degistir.Visible:=False;
               Next3Btn.Caption:='Next';
               CheckHeadL.Caption:=msgCheckSearchOpr;
               ControlsPg.TabVisible:=True;
               ControlsPg.Visible:=True;
               ProjectDestDirPan.Visible:=False;
               SingleSearchPg.Visible:=False;
               SingleSearchPg.TabVisible:=False;
               FileSelectionPg.Visible:=True;
               FileSelectionPg.TabVisible:=True;
               ChangePg.TabVisible:=False;
               Next4Btn.Caption:='Show Report';
               ViewDiffAct.Enabled:=False;
               SOpenAct.Enabled:=True;
               SOpenAct.Enabled:=True;
               ClearGrid(TNTWrongRowsGrid);
               TNTWrongRowsGrid.RowCount:=2;
               TNTWrongRowsGrid.Cells[0,0]:='Line No';
               TNTWrongRowsGrid.Cells[1,0]:='Search Text';
               TNTWrongRowsGrid.Cells[2,0]:='Line No';
               TNTWrongRowsGrid.Cells[3,0]:='Search Text';

               TNTWrongRowsGrid.Cells[0,1]:='';
               TNTWrongRowsGrid.Cells[1,1]:='';
               TNTWrongRowsGrid.Cells[2,1]:='';
               TNTWrongRowsGrid.Cells[3,1]:='';
               ErrMsgBox.Lines.Clear;
               SOpenAct.Enabled:=True;
               SOpenAct.Enabled:=True;
               WordsPg.Visible:=True;
               WordsPg.TabVisible:=True;
          end;
          4: //multi replace
          begin
               TNTSelList1.ColCount:=9;
               TNTWordGrid.ColCount:=6;
               j:=1;
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=80;inc(j);
               TNTWordGrid.ColWidths[j]:=110;inc(j);
               Degistir.Visible:=True;
               Next3Btn.Caption:='Next';
               CheckHeadL.Caption:=msgCheckReplaceOpr;
               ControlsPg.TabVisible:=True;
               ControlsPg.Visible:=True;
               ProjectDestDirPan.Visible:=True;
               SingleSearchPg.Visible:=False;
               SingleSearchPg.TabVisible:=False;
               FileSelectionPg.Visible:=True;
               FileSelectionPg.TabVisible:=True;
               ChangePg.TabVisible:=True;
               ViewDiffAct.Enabled:=True;
               SOpenAct.Enabled:=True;
               SOpenAct.Enabled:=True;
               Next4Btn.Caption:='Next';
               ClearGrid(TNTWrongRowsGrid);
               TNTWrongRowsGrid.RowCount:=2;
               TNTWrongRowsGrid.Cells[0,0]:='Line No';
               TNTWrongRowsGrid.Cells[1,0]:='Search Text';
               TNTWrongRowsGrid.Cells[2,0]:='Line No';
               TNTWrongRowsGrid.Cells[3,0]:='Search Text';

               TNTWrongRowsGrid.Cells[0,1]:='';
               TNTWrongRowsGrid.Cells[1,1]:='';
               TNTWrongRowsGrid.Cells[2,1]:='';
               TNTWrongRowsGrid.Cells[3,1]:='';
               ErrMsgBox.Lines.Clear;
               WordsPg.Visible:=True;
               WordsPg.TabVisible:=True;
               SOpenAct.Enabled:=True;
               SOpenAct.Enabled:=True;
          end;
     end;
     j:=0;
     TNTSelList1.ColWidths[j]:=50;inc(j);//row num
     TNTSelList1.ColWidths[j]:=34;inc(j);//edit btn
     TNTSelList1.ColWidths[j]:=34;inc(j);//del btn
     TNTSelList1.ColWidths[j]:=130;inc(j);//src dir
     TNTSelList1.ColWidths[j]:=65;inc(j);//inc.file ptr
     TNTSelList1.ColWidths[j]:=65;inc(j);//exc.file ptr
     TNTSelList1.ColWidths[j]:=30;inc(j);//F/D
     TNTSelList1.ColWidths[j]:=50;inc(j);//Sub Dirs
     if (FormStyleSwc=2) or (FormStyleSwc=4) then
     TNTSelList1.ColWidths[j]:=130;inc(j);

     SelListPaint;
     WordListPaint;
end;

procedure TRepFrmF.EditWordBtnClick(Sender: TObject);
Var
   k:integer;
   p:PWordObj;
   wobj:TWordObj;
   ssearchstr,ssubmatchtxt,sreplacetxt,scasestr,sregexstr:ASCMRString;
begin
     if (TNTWordGrid.Row>0) and(WordsList.Count>=TNTWordGrid.Row)  then
     Begin
          k:=1;
          p:=WordsList.Items[TNTWordGrid.Row-1];
          wobj:=p^;
          if RepMainF.EditWords(FormStyleSwc,wobj.SearchTxt,wobj.SubMatchTxt,wobj.ReplaceTxt,
          wobj.CaseSwc,wobj.KeepCase,wobj.RegEx,wobj.WordsOnly,wobj.MatchReq,wobj.uMatchReq,wobj.SearchOnly,
          wobj.StopAfterFMatchThisFile,wobj.StopAfterFMatchAll,wobj.SearchStarter,wobj.SearchStopper,
          wobj.areainfo,wobj.start1,
          wobj.start2,wobj.stop1,wobj.stop2,wobj.csvchar,wobj.GroupNumber) Then
          Begin
               p^:=wobj;
               WordGridRepaintRow(TNTWordGrid.Row-1);
          end;
     end else ShowMessage(WordSelectARowMsgStr);
end;

procedure TRepFrmF.EraseTempFiles;
Var
   masj,k:integer;
   sfpth,fn:ASCMRString;
   p:PSrcFileRec;
begin
     if not assigned(self) then exit;

         For masj:=0 to srcfilereclist.Count-1 do
         Begin
              p:=srcfilereclist.Items[masj];
              try
                 fn:=TempDir+'matches'+inttostr(repformid)+'_'+DblToText(masj,'NNNNNN')+'.tmp';
                 if fileexists(fn) then
                    DeleteFile(fn);
              except

              end;
              for k := 1 to TNTWordGrid.RowCount - 1 do
              begin
                   try
                      sfpth:=TempDir+'sf'+inttostr(repformid)+'_'+DblToText(p^.fileindex,'NNNNNN')+
                      DblToText(k,'NNNNN')+'.tmp';
                      if fileexists(sfpth) then
                         DeleteFile(sfpth);
                   except

                   end;
              end;
         End;


end;

procedure TRepFrmF.EraseWordBtnClick(Sender: TObject);
var
   p:PWordObj;
   a,b,j:integer;
begin
     if TNTWordGrid.Selection.Bottom-TNTWordGrid.Selection.Top>0 Then
     Begin
          if WordsList.Count=0 then
          Begin
               ShowMessage(WordSelectARowMsgStr);
               exit;
          end;

          if not (RepMainF.AppDlg(msYNC,WordDeleteRowsQueryStr)=rsYes) Then exit;

          if TNTWordGrid.Selection.Top<=TNTWordGrid.Selection.Bottom then
          begin
               a:=TNTWordGrid.Selection.Top;
               b:=TNTWordGrid.Selection.Bottom;
          end else
          begin
               b:=TNTWordGrid.Selection.Top;
               a:=TNTWordGrid.Selection.Bottom;
          end;
          for j := b downto a do
          begin
               if j<WordsList.Count then
               begin
                    p:=WordsList.Items[j-1];
                    dispose(p);
                    WordsList.Delete(j);
               end;
          end;

          RemoveGridRows(TNTWordGrid,TNTWordGrid.Selection.Top,TNTWordGrid.Selection.Bottom);
     end else
     Begin
          if (TNTWordGrid.Row>0) and (TNTWordGrid.Row<=WordsList.Count) then
          Begin
               a:=TNTWordGrid.Row;
               if RepMainF.AppDlg(msYNC,WordDeleteRowQueryStr)<>rsYes Then exit;
               RemoveGridRows(TNTWordGrid,TNTWordGrid.Row,TNTWordGrid.Row);
               p:=WordsList.Items[a-1];
               dispose(p);
               WordsList.Delete(a-1);
          end else
          Begin
               ShowMessage(WordSelectARowMsgStr);
               exit;
          end;
     end;
     WordListPaint;
end;

procedure TRepFrmF.EST1Click(Sender: TObject);
var
   rdr:TUnicodeFileReader;
   j:integer;
begin
     {
     j:=0;
     TNTSingleOldE.Lines.LoadFromFile('C:\apache2triad\htdocs\gost-test\ru\sertifika1n.php');
     exit;
     rdr:=TUnicodeFileReader.Create('C:\apache2triad\htdocs\gost-test\ru\test1.txt');
     while (not rdr.EOF) and (j<100) do
     begin
          inc(j);
          TNTSingleOldE.Lines.Text:=TNTSingleOldE.Lines.Text+rdr.ReadWideStr(100);
     end;
     }
end;

procedure TRepFrmF.extFileDetailedlist1Click(Sender: TObject);
var
   exf,fn:ASCMRString;
   j:integer;
   p:PSrcFileRec;
   lst:TASCMRStringList;
begin
     SD1.FileName:='';
     SD1.Filter:='Text Files|*.txt|Any File|*.*';
     RepMainF.vAutoClose:=False;
     if SD1.Execute then
     if SD1.FileName='' Then exit;
     fn:=SD1.FileName;
     exf:=ExtractFileExt(fn);
     if exf='' then
     fn:=ChangeFileExt(fn,'.txt');
     lst:=TASCMRStringList.Create;
     lst.Add(SetStrLength('File Name',' ',60,1)+' '+SetStrLength('File Type',' ',20,1)+' '+
          SetStrLength('Size',' ',10,1)+' '+SetStrLength('Modify Date',' ',14,1)+' '+
          SetStrLength('Match Count',' ',12,0));
     For j:=0 to srcfilereclist.Count-1 do
     Begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then continue;

          lst.Add(SetStrLength(p^.OrjFileName,' ',60,1)+' '+SetStrLength(p^.FileType,' ',20,1)+' '+
          SetStrLength(GetSizeDescription(p^.FileSize),' ',10,0)+' '+SetStrLength(DateToStr(p^.ModifyDate),' ',14,1)+' '+
          SetStrLength(inttostr(p^.MatchCount),' ',10,0)+'  ');
     End;
     try
        lst.SaveToFile(fn);
     except
        on E: Exception do MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);
     end;
     lst.Free;
     lst:=Nil;

end;

procedure TRepFrmF.extFileOnlyfilenameswithfilepaths1Click(Sender: TObject);
var
   exf,fn:ASCMRString;
   j:integer;
   p:PSrcFileRec;
   lst:TASCMRStringList;
begin
     SD1.FileName:='';
     SD1.Filter:='Text Files|*.txt|Any File|*.*';
     RepMainF.vAutoClose:=False;
     if SD1.Execute then
     if SD1.FileName='' Then exit;
     fn:=SD1.FileName;
     exf:=ExtractFileExt(fn);
     if exf='' then
     fn:=ChangeFileExt(fn,'.txt');
     lst:=TASCMRStringList.Create;
     For j:=0 to srcfilereclist.Count-1 do
     Begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then continue;
          lst.Add(p^.OrjFileName);
     End;
     try
        lst.SaveToFile(fn);
     except
        on E: Exception do MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);
     end;
     lst.Free;
     lst:=Nil;

end;

procedure TRepFrmF.extFileOnlyFileNamesWithoutpathnames1Click(Sender: TObject);
var
   exf,fn:ASCMRString;
   j:integer;
   p:PSrcFileRec;
   lst:TASCMRStringList;
begin
     SD1.FileName:='';
     SD1.Filter:='Text Files|*.txt|Any File|*.*';
     RepMainF.vAutoClose:=False;
     if SD1.Execute then
     if SD1.FileName='' Then exit;
     fn:=SD1.FileName;
     exf:=ExtractFileExt(fn);
     if exf='' then
     fn:=ChangeFileExt(fn,'.txt');
     lst:=TASCMRStringList.Create;
     For j:=0 to srcfilereclist.Count-1 do
     Begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then continue;
          lst.Add(ExtractFileName( p^.OrjFileName));
     End;
     try
        lst.SaveToFile(fn);
     except
        on E: Exception do MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);
     end;
     lst.Free;
     lst:=Nil;
end;

procedure TRepFrmF.FileListClick(Sender: TObject);
Var
   p:PSrcFileRec;
begin
     (*if not Assigned(DirListTV1.Selected) Then exit;
     if DirListTV1.Selected.Data=nil then exit;
     p:=DirListTV1.Selected.Data;
     preparefilecontents({$IF DetailObject=1}
     RichView1
     {$ELSE}
     ContentRE
     {$IFEND}
     ,p);
     *)
end;

procedure TRepFrmF.FileSearchNormallyEvt(Sender: TObject);
begin
     FileSearchNormallyTag:=FileSearchNormallyTag+1;
     if (FileSearchNormallyTag<1) or (FileSearchNormallyTag>7) then FileSearchNormallyTag:=1;
     
     case FileSearchNormallyTag of
          1,5:sbar1.Panels[2].Text:='-';
          2,6:sbar1.Panels[2].Text:='\';
          3,7:sbar1.Panels[2].Text:='|';
          4:sbar1.Panels[2].Text:='/';

     end;
end;

function TRepFrmF.FindInSrcFileList(fn: ASCMRstring): integer;
Var
   j:integer;
   p:PSrcFileRec;
begin
     result:=-1;
     for j := 0 to srcfilereclist.Count-1 do
     begin
          p:=srcfilereclist.Items[j];
          if p^.OrjFileName=fn then
          begin
               result:=j;
               exit;
          end;
     end;
end;

procedure TRepFrmF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     if not assigned(self) then exit;

     if not RepMainF.vAutoClose then
     if appdefaultsrec.OnExitAskSaveChk then
     Begin
          if FFormModified then
          case RepMainF.AppDlg(msYNC,QuerySaveAndExit) of
               rsYes:
               Begin
                    if not SaveProjectDialog then
                    Begin
                         Action:=caNone;
                         Show;
                         exit;
                    End;
               End;
               rsCancel:
               Begin
                    Action:=caNone;
                    Show;
                    exit;
               End;
          end;


     End;
     if ThreadStopper.Tag=0 then
     begin
          Enabled:=False;
          ThreadStopper.Tag:=1;
          ThreadStopper.Enabled:=True;
          Action:=caNone;
          if not RepMainF.vAutoHide then Show else hide;
          exit;
     end;
     Action:=caFree;
     if Assigned(RepMainF) then
     Begin
          if RepMainF.vAutoClose then
          begin

               RepMainF.Close;
          end else
          RepMainF.Show;
     End;

end;

procedure TRepFrmF.FormCreate(Sender: TObject);
begin
     Self.DoubleBuffered:=true;
     SearchStartTime:=now;
     NotReadedFileCount:=0;
     RMatchedFileCounter:=0;
     FileScannedCount:=0;
     RefreshMatchesForm:=True;
     fStartReplace:=False;//komut satýrýndan verilen otomatik baþlatma komutu
     repformid:=CurrentFormID;
     CurrentFormID:=CurrentFormID+1;
     {$IF (DemoVersiyon=0)}
          RegSerino:=RepMainF.RegisterHeader.SerialNo;
          RegTarih:=RepMainF.RegisterHeader.RegDate;
    {$IFEND}
     WordsList:=TList.Create;
     ProjectDestE1.Text:=appdefaultsrec.DestDir;
     SingleDestinationE.Text:=appdefaultsrec.DestDir;
     SysImg1:=TSysImageList.Create(self);
     DirIconIndex := SysImg1.ImageIndexOf(AppPath,false);
     FormStyleSwc:=0;//0:Only Search,1:Replace
     RepSabitDSeri:='';
     LastAddedFilePath:='';
     lastfoundfilename:='';
     LastAddedIndex:=-1;
     LastAddedTime:=now;
     TNTSingleOldE:=ConvertASCMemo(SingleOldE);
     TNTSubMatchE:=ConvertASCMemo(SubMatchE);
     TNTSingleNewE:=ConvertASCMemo(SingleNewE);

     TNTReportRE:=ConvertASCRichEdit(ReportRE);
     TNTWordGrid:=ConvertASCStringGrid(WordGrid);
     TNTWrongRowsGrid:=ConvertASCStringGrid(WrongRowsGrid);
     TNTSelList1:=ConvertASCStringGrid(SelList1);
     TNTSelList1.DefaultRowHeight:=34;

     MFileSearching:=False;
     MFileSearchObj:=TMainFileSearch.Create(nil);
     MFileSearchObj.OnFileFound:=SearchFileFound;
     MFileSearchObj.OnReady:=SearchCompleteEvent;
     MFileSearchObj.OnscnFileCountChange:=SearchScanningNotify;
     MFileSearchObj.OnMatchFileCountChange:=SearchScanningNotify;
     MFileSearchObj.OnFileScanned:=OnFileScannedEvent;
     MFileSearchObj.RepFrmFHandle:=Self.Handle;
     //MFileSearchObj.OnNormally:=FileSearchNormallyEvt;
     Lastmainitm:=nil;
     ScannedFCount:=0;
     FoundedFCount:=0;
     MatchesCount:=0;
     srcfilereclist:=TList.Create;
     SrcFileSelReclist:=TList.Create;
     oldremoveds:=TASCMRStringList.Create;
     presearchfilelist:=TASCMRStringList.Create;
     ExtWordLst:=TASCMRStringList.Create;        //bulunan kelimelerin yazýlacaðý liste
     ExtLineLst:=TASCMRStringList.Create;        //bulunan satýrlarýn yazýlacaðý liste


     RegExObj:=TRegExpr.Create;
     ASCRegExSubMatch:='';
     ASCRegExKeepCase:=False;
     //RegExObj.OnReplace:=ASCRegExOnReplace;

     RegExObj.ModifierG:=appdefaultsrec.RegExGreedyChk;

     RegExObj.ModifierM:=appdefaultsrec.RegExMultiLineChk;

     RegExObj.ModifierS:=appdefaultsrec.RegExSingleLineChk;
     RegExObj.ModifierX:=appdefaultsrec.RegExExtendedChk;
     {
     if appdefaultsrec.RegExAnchoredChk and (not (preAnchored in RegExObj.Options)) then
        RegExObj.Options:=RegExObj.Options+[preAnchored]
     else
     if (not appdefaultsrec.RegExAnchoredChk) and (preAnchored in RegExObj.Options) then
     RegExObj.Options:=RegExObj.Options-[preAnchored];
     }
     SingleCaseChk.Checked:=appdefaultsrec.CaseSensChk;
     SingleKeepCase.Checked:=appdefaultsrec.KeepCaseChk;
     SingleRegExChk.Checked:=appdefaultsrec.RegExUseChk or (ASCUniCodeUsing=1);
     SingleRegExChk.Enabled:=(ASCUniCodeUsing<>1);
     View80ColumnText1.Enabled:=(ASCUniCodeUsing<>1);
     ViewHex1.Enabled:=(ASCUniCodeUsing<>1);
     ViewDiff80ColumnMI.Enabled:=(ASCUniCodeUsing<>1);
     ViewDiffHexMI.Enabled:=(ASCUniCodeUsing<>1);

     MQueueThread:=TQueueThread.Create(nil);
     MQueueThread.RepFrmFHandle:=Self.Handle;
     MQueueThread.Baslat(true);
     MQueueThread.fExecute:=QueueTimerTimer;
     MQueueThread.RegExObj:=RegExObj;
     MQueueThread.FWordsList:=WordsList;
     MQueueThread.FStyleSwc:=FormStyleSwc;
     MQueueThread.SearchFileQueue.Clear;
     MQueueThread.fList:=srcfilereclist;
     MQueueThread.repformid:=repformid;
     MQueueThread.FSearchStartTime:=SearchStartTime;
     StartSrv(nil);
     ////MQueueThread.FRVStyle1:=RVStyle1;RVStyle sonra tanýmlanýyor

     frepfilename:='';
     PGCtrl.ActivePageIndex:=0;
     SelListPaint;
     WordListPaint;
     OldSelListWndProc:=TNTSelList1.WindowProc;
     TNTSelList1.WindowProc:=SelListWndProc;

     OldSelListWndProc2:=SingleSourceE.WindowProc;
     SingleSourceE.WindowProc:=SelListWndProc2;


     DragAcceptFiles(TNTSelList1.Handle, True);
     DragAcceptFiles(SingleSourceE.Handle, True);



     DirList1:=TpTree.Create(FileListPg);
     DirList1.Parent:=FileListPg;
     DirList1.Width:=630;
     DirList1.Height:=400;
     DirList1.Visible:=False;

     DirListTV1:=TTreeList.Create(DirList1);
     DirListTV1.Parent:=DirList1;
     DirList1.tv:=DirListTV1;
     DirListTV1.Images := SysImg1;
     DirListTV1.OnClick:=FileListClick;
     DirListTV1.MultiSelect:=True;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=200;
          Text:='File';
          Alignment:=taLeftJustify;
     end;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=80;
          Text:='Matches';
          Alignment:=taCenter;
     end;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=80;
          Text:='Size';
          Alignment:=taRightJustify;
     end;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=150;
          Text:='Modify Date';
          Alignment:=taCenter;
     end;
     with DirList1.HeaderSections.Add do
     Begin
          Width:=180;
          Text:='File Type';
          Alignment:=taLeftJustify;
     end;
     DirList1.UpdateColumns;

     {$IF DetailObject=1}
     RichView1:=TRichView.Create(FileListPg);
     RichView1.Parent:=FContentsPg;
     RichView1.Style:=RVStyle1;
     RichView1.Align:=alClient;
     {$ELSE}

     {$IFEND}


     MQueueThread.FRVStyle1:=RepMainF.RVStyle1;

     DirList1.Align:=alClient;
     FileBtnPnl.Align:=alBottom;
     //WindowState:=wsMaximized;

     MBar1:=TMarqueeProgressBar.Create(self);
     MBar1.Parent:=Self;
     MBar1.Left:=SBar1.Left+3+SBar1.Panels[0].Width;
     MBar1.Top:=SBar1.Top+1;
     MBar1.Height:=SBar1.Height-2;
     MBar1.Anchors:=[akLeft,akBottom];
     MBar1.Width:=SBar1.Panels[1].Width;
     MBar1.Active:=False;
     MBar1.Visible:=False;
     PrcViewF:=TProcessViewF.Create(nil);
     PrcViewF.MrqBar1:=MBar1;
     PrcViewF.MSrcObj:=MFileSearchObj;
     PrcViewF.MQThread:=MQueueThread;
     PrcViewF.FStopEvent:=StopSearch;
     PrcViewF.MFileSearching:=@MFileSearching;
     FileSaveRequered:=False;

     SrcEditBmp:=TBitmap.Create;
     SrcEditBmp.Assign(SrcEditBtn.Glyph);
     SrcEditBmp.TransparentColor:=SrcEditBmp.Canvas.Pixels[0,1];
     SrcEditBmp.Transparent:=True;
     SrcDelBmp:=TBitmap.Create;
     SrcDelBmp.Assign(SrcDelBtn.Glyph);
     SrcDelBmp.TransparentColor:=SrcDelBmp.Canvas.Pixels[0,0];
     SrcDelBmp.Transparent:=True;
     SOpenAct.Enabled:=True;
     SOpenAct.Enabled:=True;

     SozlukYukle;
     SingleOnMatching.ItemIndex:=0;
end;

procedure TRepFrmF.FormDestroy(Sender: TObject);
begin
     if not assigned(self) then exit;

     if Assigned(PrcViewF) then
     Begin
          PrcViewF.Free;
          PrcViewF:=nil;
     End;
     if Assigned(FMatchesF) then
     begin
          FMatchesF.Free;
          FMatchesF:=Nil;
     end;
     if Assigned(SysImg1) then
     begin
          SysImg1.Free;
          SysImg1:=nil;
     end;
     MFileSearching:=False;

     {$IF DetailObject=1}
     if Assigned(RichView1) then
     begin
          try
          RichView1.Free;
          except
          end;
          RichView1:=Nil;
     end;
     {$IFEND}
     if Assigned(RegExObj) then
     begin
          try
          RegExObj.Free;
          except
          end;
          RegExObj:=nil;
     end;


     EraseTempFiles; //geçici dosyalar siliniyor
     DropFileData;
     DropFileSelData;
     if Assigned(srcfilereclist) then
        srcfilereclist.Free;
     srcfilereclist:=nil;

     if Assigned(SrcFileSelReclist) then
     SrcFileSelReclist.Free;
     SrcFileSelReclist:=nil;

     if Assigned(presearchfilelist) then
     presearchfilelist.Free;
     presearchfilelist:=nil;

     if Assigned(ExtWordLst) then
     ExtWordLst.Free;
     ExtWordLst:=Nil;

     if Assigned(ExtLineLst) then
     ExtLineLst.Free;
     ExtLineLst:=Nil;

     if Assigned(TNTSelList1) Then TNTSelList1.Free;
     TNTSelList1:=Nil;
     if Assigned(SingleSourceE) Then SingleSourceE.Free;
     SingleSourceE:=Nil;

     if Assigned(WordsList) then
     begin
          ClearWordList;
          FreeAndNil(WordsList);
     end;
     if Assigned(SrcEditBmp) then
        FreeAndNil(SrcEditBmp);
     if Assigned(SrcDelBmp) then
        FreeAndNil(SrcDelBmp);
end;

procedure TRepFrmF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

procedure TRepFrmF.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     {
     if SingleCaseChk.Visible then
     begin
          SingleCaseChk.Refresh;
          SingleCaseChk.Repaint;
     end;
     if SingleRegExChk.Visible then
     begin
          SingleRegExChk.Refresh;
          SingleRegExChk.Repaint;
     end;
     if SingleWordsOnlyChk.Visible then
     begin
          SingleWordsOnlyChk.Refresh;
          SingleWordsOnlyChk.Repaint;
     end;
     if SingleKeepCase.Visible then
     begin
          SingleKeepCase.Refresh;
          SingleKeepCase.Repaint;
     end;
     }
end;

procedure TRepFrmF.FormResize(Sender: TObject);
begin

     DirList1.Visible:=True;
     DirList1.Align:=alClient;
     DirList1.UpdateColumns;

     FileBtnPnl.Align:=alBottom;

end;

procedure TRepFrmF.HexLbl1Click(Sender: TObject);
begin
     RepMainF.HexDataTool(TNTSingleOldE.Lines);
end;

procedure TRepFrmF.HexLbl2Click(Sender: TObject);
begin
     RepMainF.HexDataTool(TNTSubMatchE.Lines);

end;

procedure TRepFrmF.HexLbl3Click(Sender: TObject);
begin
     RepMainF.HexDataTool(TNTSingleNewE.Lines);
end;

procedure TRepFrmF.WordGridRowMoved(Sender: TObject; FromIndex, ToIndex: Integer);
begin
     if (WordsList.Count>=FromIndex) and (WordsList.Count>=ToIndex) and (WordsList.Count>1) then
     begin
          WordsList.Move(FromIndex-1,ToIndex-1);
     end;
     WordListPaint;
end;

procedure TRepFrmF.ClearGrid(FGrd: TASCStringGrid);
Var
   c,r:integer;
begin

     for r:=0 to FGrd.RowCount-1 do
     for c:=0 to FGrd.ColCount-1 do
     Begin
          FGrd.Cells[c,r]:='';
     end;
end;

procedure TRepFrmF.CloseBtnClick(Sender: TObject);
begin
     Close;
end;

procedure TRepFrmF.CreateParams(var Params: TCreateParams);
begin
     inherited;
     Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
     Params.WndParent := GetDesktopWindow;
end;

procedure TRepFrmF.CSVFileDetailedlist1Click(Sender: TObject);
var
   exf,fn:ASCMRString;
   j:integer;
   p:PSrcFileRec;
   lst:TASCMRStringList;
begin
     SD1.FileName:='';
     SD1.Filter:='CSV Files|*.csv|Text Files|*.txt|Any File|*.*';
     RepMainF.vAutoClose:=False;
     if SD1.Execute then
     if SD1.FileName='' Then exit;
     fn:=SD1.FileName;
     exf:=ExtractFileExt(fn);
     if exf='' then
     fn:=ChangeFileExt(fn,'.csv');
     lst:=TASCMRStringList.Create;
     lst.Add('File Name;File Type;Size;Modify Date;Match Count;');
     For j:=0 to srcfilereclist.Count-1 do
     Begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then continue;

          lst.Add(p^.OrjFileName+';'+p^.FileType+';'+GetSizeDescription(p^.FileSize)+';'+DateToStr(p^.ModifyDate)+';'+
          inttostr(p^.MatchCount)+';');
     End;
     try
        lst.SaveToFile(fn);
     except
        on E: Exception do MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);
     end;
     lst.Free;
     lst:=Nil;

end;

procedure TRepFrmF.AddWordBtnClick(Sender: TObject);
Var
   SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
   CaseSwc,KeepCase,RegEx,WordsOnly,
   MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
   uMatchReq {Ýçermeyen(Bütün dosyalar için)},
   SearchOnly{(for replace projects)},
   StopAfterFMatchThisFile,StopAfterFMatchAll,SearchStarter,SearchStopper:boolean;
   areainfo,start1,start2,stop1,stop2:integer;
   csvchar:ASCMRString;
   GroupNumber:integer;
begin
     if not RepMainF.AddWords(FormStyleSwc,SearchTxt,SubMatchTxt,ReplaceTxt,
     CaseSwc,KeepCase,RegEx,WordsOnly,
     MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
     uMatchReq {Ýçermeyen(Bütün dosyalar için)},
     SearchOnly{(for replace projects)},
     StopAfterFMatchThisFile,StopAfterFMatchAll,SearchStarter,SearchStopper,
     areainfo,start1,start2,stop1,stop2,csvchar,GroupNumber) then exit;
     AddToWordList(SearchTxt,SubMatchTxt,ReplaceTxt,CaseSwc,KeepCase,RegEx,WordsOnly,MatchReq,
     uMatchReq {Ýçermeyen(Bütün dosyalar için)},
     SearchOnly{(for replace projects)},
     StopAfterFMatchThisFile,StopAfterFMatchAll,SearchStarter,SearchStopper,
     areainfo,start1,start2,stop1,stop2,csvchar,GroupNumber);
end;

procedure TRepFrmF.ASCRegExOnReplace(Sender: TObject; var ReplaceWith: ASCMRstring);
Var
   tmpi1,tmpi2,j:integer;
   s,newtxt:ASCMRstring;
   caseswc:Boolean;
begin
     if ASCRegExSubMatch<>'' then
     Begin
          s:=Copy(RegExObj.InputString,RegExObj.MatchPos[0], RegExObj.MatchLen[0]);
          newtxt:=ReplaceWith;
          caseswc:=not (RegExObj.ModifierI);

          ASCSearcText(s,ASCRegExSubMatch,'',newtxt,'',caseswc,ASCRegExKeepCase,False,False,true,
          0,0,0,0,0,';',False,False,False,tmpi1,tmpi2);
          ReplaceWith:=s;
     End;
end;

function TRepFrmF.ASCSearcText(Var s:ASCMRstring;f,submatch,r:ASCMRString;sfpth:ASCMRstring;CaseSensitiveSwc,KeepCaseSwc,WordsOnlySwc,
    StopAfterMatchSwc,Replace:Boolean;areainfo,start1,start2,stop1,stop2:integer;
    csvchar:ASCMRString;UseRegEx,SearchStarter,SearchStopper:Boolean;Var S_StartPos,S_StopPos:integer):integer;
Var
       j,tmpi1,tmpi2:integer;
       sv,fstr,news,newtxt,chstr:ASCMRString;
       //srclf:File of TASCSearchRec;
       sr:TASCSearchRec;
       //srcwithfile:Boolean;
       RegExObjStart,RegExObjStop,
       deletedcols,linenum,currentcol:integer; //csv ile arama iþleminde belirli pozisyona kadar olan
       //bilgi siliniyor onun için bu deðiþkene ihtiyaç duyuldu.

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
       smplestr,smplestr2:ASCMRString;
       fnextsearch:boolean;
       lcaseswc,l,l2,casej:integer;

       procedure CutChars(cuti:integer);
       begin
            if Replace then
               news:=news+Copy(s,1,cuti);
            Delete(sv,1,cuti);
            if Replace then
               Delete(s,1,cuti);
            sr.P:=sr.P+cuti;
       end;

begin
         Result:=0;
         deletedcols:=0;
         if submatch<>'' then
         Begin

              newtxt:=f;

              ASCSearcText(newtxt,submatch,'',r,'',CaseSensitiveSwc,KeepCaseSwc,False,False,True,
              0,0,0,0,0,';',(ASCUniCodeUsing=1),False,False,tmpi1,tmpi2);
         End else newtxt:=r;
         (*
         if sfpth<>'' then
         Begin

              AssignFile(srclf,sfpth);
              {$I-}Rewrite(srclf);{$I+}
              if ioresult<>0 then exit;
              srcwithfile:=True;
         End else srcwithfile:=False;
         *)
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
                   RegExObj.InputString:=sv;
                   RegExObjStart:=0;
                   RegExObjStop:=SearchPos.y+1;
                   //RegExObj.Compile;
                   if not RegExObj.ExecPos(RegExObjStart+1) then
                   begin
                        j:=0;
                   end else
                   begin
                        j:=RegExObj.MatchPos[0];
                        sr.l:=RegExObj.MatchLen[0];
                   end;

              end
              else
              begin
                   j:=AnsiPos(fstr,sv);
                   if j=0 then
                   j:=Pos(fstr,sv);
              end;
              if (j>0) or ((j=0) and UseRegEx and (Areainfo>0)) then
              Begin
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
                        Delete(sv,1,j);
                        if Replace then
                           Delete(s,1,j);
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
                             Delete(sv,1,j);
                             if Replace then
                                Delete(s,1,j);
                             sr.P:=sr.P+j;
                             Continue;
                        end;
                   end;

                   if Replace then
                   Begin
                        news:=news+Copy(s,1,j-1);
                        if KeepCaseSwc then
                        begin
                             smplestr2:=copy(s,j,sr.l);
                             l:=Length(newtxt);
                             l2:=Length(smplestr2);
                             lcaseswc:=0;
                             for casej := 1 to l do
                             begin
                                  {$IF (ASCUniCodeUsing=1)}
                                  if casej<=l2 then
                                  begin
                                       smplestr:=Copy(smplestr2,casej,1);
                                       lcaseswc:=0;
                                       if Tnt_WideLowerCase(smplestr)=smplestr then
                                       begin
                                            if Tnt_WideUpperCase(smplestr)<>smplestr then
                                            lcaseswc:=1;
                                       end else
                                       begin
                                            if Tnt_WideUpperCase(smplestr)=smplestr then
                                            lcaseswc:=2;
                                       end;
                                  end;

                                  smplestr:=Copy(newtxt,casej,1);
                                  case lcaseswc of
                                       1:news:=news+Tnt_WideLowerCase(smplestr);
                                       2:news:=news+Tnt_WideUpperCase(smplestr);
                                       else news:=news+smplestr;
                                  end;
                                  {$ELSE}
                                  if casej<=l2 then
                                  begin
                                       smplestr:=Copy(smplestr2,casej,1);
                                       lcaseswc:=0;
                                       if Ansilowercase(smplestr)=smplestr then
                                       begin
                                            if Ansiuppercase(smplestr)<>smplestr then
                                            lcaseswc:=1;
                                       end else
                                       begin
                                            if Ansiuppercase(smplestr)=smplestr then
                                            lcaseswc:=2;
                                       end;
                                  end;

                                  smplestr:=Copy(newtxt,casej,1);
                                  case lcaseswc of
                                       1:news:=news+Ansilowercase(smplestr);
                                       2:news:=news+AnsiUppercase(smplestr);
                                       else news:=news+smplestr;
                                  end;
                                  {$IFEND}
                             end;
                        end else
                        begin
                             news:=news+newtxt;
                        end;
                        Delete(s,1,j+sr.L-1);
                   end;
                   sr.P:=sr.P+j;

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



                   sr.P:=sr.P+sr.L-1;
                   Result:=Result+1;
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
         //if srcwithfile then closeFile(srclf);
         if Replace then
            s:=news;
end;

procedure TRepFrmF.AddActExecute(Sender: TObject);
begin
     Case PGCtrl.ActivePageIndex of
          1:SrcAddBtnClick(Sender);
          2:AddWordBtnClick(Sender);
     End;
end;

procedure TRepFrmF.AddEditRepList(ind: integer; Src,Dest,ifileptr,exfileptr:ASCMRString;FileOrDir,subfiles:Char;
MinFileSize,MaxFileSize,DateOption:integer;MinDate,MaxDate:Double;FFileNameOperation:Boolean);
Var
   vSrc,vDest,vifileptr,vexfileptr:ASCMRString;
   vFileOrDir,vsubfiles:Char;
   p:PSrcFileSelRec;
   i:integer;
begin
     vSrc:=csvPrepareColumn(Src);
     vDest:=csvPrepareColumn(Dest);
     if (ind<0) or (ind>=SrcFileSelReclist.Count) then
     Begin
          {$IF (DemoVersiyon=0) or (DemoVersiyon=2)}
          new(p);
          i:=SrcFileSelReclist.Add(p);
          {$ELSE}
          if SrcFileSelReclist.Count>=DemoVerFRC then
          begin
               MessageDlg(DemoProgramMsj1,mtInformation,[mbOK],0);
               exit;
          end else
          begin
               new(p);
               i:=SrcFileSelReclist.Add(p);
          end;
          {$IFEND}
     end else
     Begin
          p:=SrcFileSelReclist.Items[ind];
          i:=ind;
     end;
     p^.Src:=Src;
     p^.Dest:=Dest;
     p^.ifileptr:=ifileptr;
     p^.exfileptr:=exfileptr;
     p^.FileOrDir:=FileOrDir;
     p^.subfiles:=subfiles;
     with p^ do
     begin
          srMinFileSize:=MinFileSize;
          srMaxFileSize:=MaxFileSize;
          srDateOption:=DateOption;
          srMinDate:=MinDate;
          srMaxDate:=MaxDate;
     end;
     p^.FileNameOperation:=FFileNameOperation;
     WriteToSelList(i);
     FileSaveRequered:=True;
end;

procedure TRepFrmF.AddSelectedFilesToSrc;
Var
   j,k:integer;
   s,sd,Src,Dest,ifileptr,exfileptr,FileOrDir,subfiles:String;
   f:Boolean;
   p:PSrcFileSelRec;
   MinFileSize,MaxFileSize:int64;DateOption:integer;MinDate,MaxDate:Double;
   FFileNameOperation:Boolean;
begin
     if FormStyleSwc<3 then  //single saerch or singel replace
     Begin
          if RepMainF.SelFileList.Count>1 then
          begin
               Case RepMainF.AppDlg(msYNC,MsgSwitchToMultiForThis) of
                    rsYes:
                    Begin
                         ApplySingleWordChanges;
                         FormStyleSwc:=FormStyleSwc+2;
                         EditDisplay;
                         PGCtrl.ActivePageIndex:=1;
                    End;
                    rsNo:
                    Begin
                         for j := RepMainF.SelFileList.Count - 1 downto 1 do
                         RepMainF.SelFileList.Delete(j);
                    end;
                    else Exit;
               End;
          end;

     End;
     if FormStyleSwc<3 then  //single saerch or singel replace
     Begin
          if RepMainF.SelFileList.Count>0 then
          Begin
               DropFileSelData; //öncekiler boþaltýlýr
               sd:=RepMainF.SelFileList.Strings[0];
               s:=CutcsvData(sd);
               src:=csvRePrepareColumn(s);
               s:=CutcsvData(sd);
               Dest:=csvRePrepareColumn(s);
               s:=CutcsvData(sd);
               ifileptr:=csvRePrepareColumn(s);
               s:=CutcsvData(sd);
               exfileptr:=csvRePrepareColumn(s);
               s:=CutcsvData(sd);
               fileordir:=csvRePrepareColumn(s);
               s:=CutcsvData(sd);
               subfiles:=csvRePrepareColumn(s);
               if not ((Copy(FileOrDir,1,1)='F') or (Copy(FileOrDir,1,1)='D'))then FileOrDir:='D';
               if not ((Copy(subfiles,1,1)='Y') or (Copy(subfiles,1,1)='N'))then subfiles:='N';
               s:=CutcsvData(sd);
               MinFileSize:=TextToInt(s);
               s:=CutcsvData(sd);
               MaxFileSize:=TextToInt(s);
               s:=CutcsvData(sd);
               DateOption:=TextToInt(s);
               s:=CutcsvData(sd);
               MinDate:=TextToDbl(s,asfDateTime);
               s:=CutcsvData(sd);
               MaxDate:=TextToDbl(s,asfDateTime);
               s:=CutcsvData(sd);
               FFileNameOperation:=uppercase(s)='Y';

               AddEditRepList(-1,Src,Dest,ifileptr,exfileptr,FileOrDir[1],subfiles[1],
               MinFileSize,MaxFileSize,DateOption,MinDate,MaxDate,FFileNameOperation);

               if fileordir='F' then
               SingleSourceE.Text:=src+ifileptr
               else
               SingleSourceE.Text:=src+' +('+ifileptr+') -('+exfileptr+') /Sub Dirs='+subfiles;
               SingleDestinationE.Text:=Dest;

          end;

     end;
     //dosyalarýn listeye eklenmesi single search için de geçerli
     for j:=0 to RepMainF.SelFileList.Count-1 do
     Begin
          sd:=RepMainF.SelFileList.Strings[j];
          s:=CutcsvData(sd);
          src:=csvRePrepareColumn(s);
          s:=CutcsvData(sd);
          Dest:=csvRePrepareColumn(s);
          s:=CutcsvData(sd);
          ifileptr:=csvRePrepareColumn(s);
          s:=CutcsvData(sd);
          exfileptr:=csvRePrepareColumn(s);
          s:=CutcsvData(sd);
          fileordir:=csvRePrepareColumn(s);
          s:=CutcsvData(sd);
          subfiles:=csvRePrepareColumn(s);
          if not ((Copy(FileOrDir,1,1)='F') or (Copy(FileOrDir,1,1)='D'))then FileOrDir:='D';
          if not ((Copy(subfiles,1,1)='Y') or (Copy(subfiles,1,1)='N'))then subfiles:='N';

          s:=CutcsvData(sd);
          MinFileSize:=TextToInt(s);
          s:=CutcsvData(sd);
          MaxFileSize:=TextToInt(s);
          s:=CutcsvData(sd);
          DateOption:=TextToInt(s);
          s:=CutcsvData(sd);
          MinDate:=TextToDbl(s,asfDateTime);
          s:=CutcsvData(sd);
          MaxDate:=TextToDbl(s,asfDateTime);
          s:=CutcsvData(sd);
          FFileNameOperation:=uppercase(s)='Y';

          f:=False;
          for k:=0 to SrcFileSelReclist.Count-1 do
          Begin
               p:=SrcFileSelReclist.Items[k];
               if (p^.Src=src) and (p^.ifileptr=ifileptr) Then
               Begin
                    f:=True;
                    AddEditRepList(k,Src,Dest,ifileptr,exfileptr,FileOrDir[1],subfiles[1],
                    MinFileSize,MaxFileSize,DateOption,MinDate,MaxDate,FFileNameOperation);
                    Break;
               end;
          end;
          if f then Continue;
          AddEditRepList(-1,Src,Dest,ifileptr,exfileptr,FileOrDir[1],subfiles[1],
          MinFileSize,MaxFileSize,DateOption,MinDate,MaxDate,FFileNameOperation);
     end;
end;

function TRepFrmF.AddToSrcFileList(Orjfile,ProcessFile: ASCMRString; MatchCount,MatchLineCount: integer;
  Destination: ASCMRString;ShowInView,FFileNameOperation:Boolean):boolean;
Var
   i: Integer;
   //Icon: TIcon;
   SearchRec: TSearchRec;
   FileInfo: SHFILEINFO;
   strpath,fext:ASCMRString;
   d:TDateTime;
   p:PSrcFileRec;
   fcs:boolean;
begin
     Result:=False;
     {$IF (DemoVersiyon=0) or (DemoVersiyon=2)}
     {$ELSE}
     if (srcfilereclist.Count>=100) then exit;
     {$IFEND}

     new(p);
     p^.Removed:=False;
     p^.OrjFileName:=OrjFile;
     p^.ProcessFile:=ProcessFile;
     p^.MatchCount:=MatchCount;
     p^.MatchLineCount:=MatchLineCount;
     strpath:=ExtractFilePath(OrjFile);
     p^.shortname:=ExtractFileName(OrjFile);
     p^.Destination:=Destination;
     i := FindFirst(OrjFile, faAnyFile, SearchRec);
     p^.FileSize:=0;
     p^.FileNameOperation:=FFileNameOperation;
     if i=0 then
     Begin
          if ((SearchRec.Attr and FaDirectory <> FaDirectory)
          {and (SearchRec.Attr and FaVolumeId <> FaVolumeID)}) then
          begin
               p^.FileSize:=SearchRec.Size;
          end;
     end;
     if not DSiGetModifyDate(strPath+SearchRec.Name,d) then d:=0;
     p^.ModifyDate:=d;
     p^.fileindex:=srcfilereclist.Count;
     srcfilereclist.Add(P);
     Result:=True;
     if ShowInView then
     begin
          if (LastAddedIndex<srcfilereclist.Count-2) and
          (LastAddedTime<now-ShowInWiewIntval) then
          Begin
               fcs:=DirList1.Focused;
               DirList1.Visible:=False;

               LastAddedTime:=now;
               for i := LastAddedIndex+1 to srcfilereclist.Count - 1 do
               begin
                    p:=srcfilereclist.Items[i];
                    strpath:=ExtractFilePath(p^.OrjFileName);
                    fext:='*'+ExtractFileExt(p^.OrjFileName);
                    if SHGetFileInfo(PChar(fext), FILE_ATTRIBUTE_NORMAL, FileInfo,
                    SizeOf(FileInfo), SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES)<>0 then
                    p^.FileType:=FileInfo.szTypeName else p^.FileType:='';
                    if (Uppercase(fext)='*.EXE') or (Uppercase(fext)='*.ICO') then
                    fext:=p^.OrjFileName;

                    //SHGetFileInfo(PChar(strPath + SearchRec.Name), 0, FileInfo,
                    //SizeOf(FileInfo), SHGFI_ICON or SHGFI_SMALLICON);
                    //Icon := TIcon.Create;
                    Try
                       //icon.Handle := FileInfo.hIcon;
                       P^.iconindex := SysImg1.ImageIndexOf(fext,false);
                    except
                       P^.iconindex:=-1;
                    End;
                    //icon.Free;
                    //icon:=nil;
                    //DestroyIcon(FileInfo.hIcon);



                    AddFileItemToList(DirList1,i);
               end;
               LastAddedIndex:=srcfilereclist.Count - 1;

               DirList1.Visible:=True;
               if fcs and DirList1.CanFocus then
               DirList1.SetFocus;

          End;
     end;
end;

function TRepFrmF.AddToWordList(SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
    CaseSwc,KeepCase,RegEx,WordsOnly,
    MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
    uMatchReq {Ýçermeyen(Bütün dosyalar için)},
    SearchOnly{(for replace projects)},
    StopAfterFMatchThisFile, //bulduðunda o dosya içinde baþka arama yapma
    StopAfterFMatchAll,SearchStarter,SearchStopper:boolean;  //bulunduðunda aramayý tamamen durdur
    areainfo,start1,start2,stop1,stop2:integer;
    csvchar:ASCMRString;GroupNumber:integer):boolean;
Var
   j,k:integer;
   p:PWordObj;
begin
     result:=false;
     (*
     SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
     CaseSwc,KeepCase,RegEx,WordsOnly,
     MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
     uMatchReq {Ýçermeyen(Bütün dosyalar için)},
     SearchOnly{(for replace projects)},
     StopAfterFMatchThisFile, //bulduðunda o dosya içinde baþka arama yapma
     StopAfterFMatchAll,//bulunduðunda aramayý tamamen durdur
     SearchStarter,SearchStopper
     :boolean;

     areainfo,start1,start2,stop1,stop2:integer;
     csvchar:ASCMRString;
     GroupNumber:integer;
     *)
     {$IF (DemoVersiyon=0) or (DemoVersiyon=2)}
     new(p);
     {$ELSE}
          if WordsList.Count>=DemoVerFRW then
          begin
               MessageDlg(DemoProgramMsj1,mtInformation,[mbOK],0);
               exit;
          end else
          begin
               new(p);
          end;
          {$IFEND}
     p^.SearchTxt:=SearchTxt;
     p^.SubMatchTxt:=SubMatchTxt;
     p^.ReplaceTxt:=ReplaceTxt;

     p^.CaseSwc:=CaseSwc;
     p^.KeepCase:=KeepCase;
     p^.RegEx:=RegEx;
     p^.WordsOnly:=WordsOnly;
     p^.MatchReq:=MatchReq;
     p^.uMatchReq:=uMatchReq;
     p^.SearchOnly:=SearchOnly;
     p^.StopAfterFMatchThisFile:=StopAfterFMatchThisFile;
     p^.StopAfterFMatchAll:=StopAfterFMatchAll;
     p^.SearchStarter:=SearchStarter;
     p^.SearchStopper:=SearchStopper;
     p^.areainfo:=areainfo;
     p^.start1:=start1;
     p^.start2:=start2;
     p^.stop1:=stop1;
     p^.stop2:=stop2;
     p^.csvchar:=csvchar;
     p^.GroupNumber:=GroupNumber;
     if p^.SearchTxt='' Then exit;
     if FormStyleSwc<3 then
     Begin
          if WordsList.Count>0 then ClearWordList;
          WordsList.Add(p);
          TNTSingleOldE.Lines.Text:=p^.SearchTxt;
          TNTSubMatchE.Lines.Text:=p^.SubMatchTxt;
          TNTSingleNewE.Lines.Text:=p^.ReplaceTxt;
          SingleCaseChk.Checked:=p^.CaseSwc;
          SingleKeepCase.Checked:=p^.KeepCase;
          SingleRegExChk.Checked:=p^.RegEx or (ASCUniCodeUsing=1);
          SingleWordsOnlyChk.Checked:=p^.WordsOnly;
          if (p^.StopAfterFMatchThisFile and p^.StopAfterFMatchAll) then
          SingleOnMatching.ItemIndex:=3
          else
          if (p^.StopAfterFMatchThisFile) then
          SingleOnMatching.ItemIndex:=1
          else
          if (p^.StopAfterFMatchAll) then
          SingleOnMatching.ItemIndex:=2
          else
          SingleOnMatching.ItemIndex:=0;
          WordGridRepaintRow(0);
     end else
     Begin
          k:=WordsList.Add(p);
          if TNTWordGrid.RowCount<WordsList.Count+1 then TNTWordGrid.RowCount:=WordsList.Count+1;
          WordGridRepaintRow(k);
     end;
     FileSaveRequered:=true;
     result:=true;
end;

procedure TRepFrmF.DegistirClick(Sender: TObject);
Var
   j,bulkelimesay,toplamkelimesay,islenen:integer;
   rprstr:string;
   p:PSrcFileRec;
   PrcsF:TProgressF;
   fRepCancel:Boolean;
begin
     {$IF (DemoVersiyon=0)}
     //Replace iþleminin baþlangýç bilgisi rapora ekleniyor
       TNTReportRE.Lines.Add(RepLib.ReplaceText(msgReplaceStarted,'$Tarih',DateTimeToStr(now)));
     PrcsF:=TProgressF.Create(nil);
     PrcsF.Caption:='Processing...';
     if not RepMainF.vAutoHide then PrcsF.Show;
     try
     Self.Enabled:=False;
     fRepCancel:=False;
     PrcsF.PB1.Max:=srcfilereclist.Count;
     islenen:=0;
     toplamkelimesay:=0;
     For j:=0 to srcfilereclist.Count-1 do
     Begin
          p:=srcfilereclist.Items[j];

          bulkelimesay:=ReplaceItem(p,false);
          if bulkelimesay>=0 then
          begin
               inc(islenen);
               toplamkelimesay:=toplamkelimesay+bulkelimesay;
          end;
          if Assigned(PrcsF) then
          begin
               PrcsF.PB1.Position:=j;
               if PrcsF.fCancelled then
               begin
                    fRepCancel:=true;
                    break;
               end;
          end;
          Application.ProcessMessages;
     end;
     finally
        Self.Enabled:=True;
     end;
     if Assigned(PrcsF) then
     begin
          PrcsF.Free;
          PrcsF:=Nil;
     end;
     //Replace iþleminin tamamlanma bilgisi rapora ekleniyor
       TNTReportRE.Lines.Add(RepLib.ReplaceText(msgReplaceComplete,'$Tarih',DateTimeToStr(now)));
     //toplam iþlem yapýlan dosya ve bulunan kelime sayýsý rapora ekleniyor.
     if islenen=0 then
       TNTReportRE.Lines.Add(MsgNoReplace)
     else
     begin
          rprstr:=RepLib.ReplaceText(MsgRepFilesandWordsCount,'$count',inttostr(islenen));
          TNTReportRE.Lines.Add(RepLib.ReplaceText(rprstr,'$wcount',inttostr(toplamkelimesay)));
     end;
     PGCtrl.ActivePage:=ReportPg;
     if RepMainF.vAutoClose then
     begin
          if RepMainF.ReportFile<>'' then
          begin
               try
                  if Pos('RTF',uppercase(ExtractFileExt(RepMainF.ReportFile)))<1 then
                  TNTReportRE.PlainText:=False
                  else
                  TNTReportRE.PlainText:=True;
                  TNTReportRE.Lines.SaveToFile(RepMainF.ReportFile);
               except
               end;
          end;
          Close;
     end;
     {$ELSE}
       MessageDlg(DemoProgramMsj1,mtInformation,[mbOK],0);
     {$IFEND}
end;

procedure TRepFrmF.DeleteActExecute(Sender: TObject);
begin
     Case PGCtrl.ActivePageIndex of
          1:SrcDelBtnClick(Sender);
          2:EraseWordBtnClick(Sender);
     End;
end;

procedure TRepFrmF.DestBtn1Click(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=ProjectDestE1.Text;
     s:=RepMainF.SelectDir(sb);
     if s<>'' then
        if s<>sb Then
           ProjectDestE1.Text:=s;

end;

procedure TRepFrmF.KontrolBtnClick(Sender: TObject);
Var
   fnd,j,k,r,foundc,tmpi1,tmpi2:Integer;
   s,s2:ASCMRString;
   p,p2:PWordObj;
   caseswc,fKeepCase,fWordsOnly,fUseRegEx:Boolean;
begin
     if WordsList.Count=0 then
     begin
          MessageDlg(errCantStartChkBcsWordsReq,mtError,[mbOk],0);
          exit;
     end;
     ErrMsgBox.Clear;
     fnd:=0;
     ClearGrid(TNTWrongRowsGrid);
     TNTWrongRowsGrid.RowCount:=2;
     TNTWrongRowsGrid.Cells[0,0]:='Line No';
     TNTWrongRowsGrid.Cells[1,0]:='Search Text';
     TNTWrongRowsGrid.Cells[2,0]:='Line No';
     TNTWrongRowsGrid.Cells[3,0]:='Search Text';

     TNTWrongRowsGrid.Cells[0,1]:='';
     TNTWrongRowsGrid.Cells[1,1]:='';
     TNTWrongRowsGrid.Cells[2,1]:='';
     TNTWrongRowsGrid.Cells[3,1]:='';
     For j:=0 to WordsList.Count-1 do
     Begin
          p:=WordsList.Items[j];
          s:=p^.SearchTxt;
          For k:=J+1 to WordsList.Count-1 do
          Begin
               if j=k Then Continue;
               p2:=WordsList.Items[k];
               s2:=p2^.SearchTxt;
               caseswc:=p2^.CaseSwc;
               fWordsOnly:=p2^.WordsOnly;
               fUseRegEx:=p2^.RegEx;
               foundc:=ASCSearcText(s2,s,'','','',caseswc,false,fWordsOnly,False,false,
               0,0,0,0,0,';',fUseRegEx,False,False,tmpi1,tmpi2);
               if foundc>0 Then
               Begin
                    if TNTWrongRowsGrid.Cells[0,1]<>'' then
                    TNTWrongRowsGrid.RowCount:=TNTWrongRowsGrid.RowCount+1;
                    r:=0;
                    TNTWrongRowsGrid.Cells[r,TNTWrongRowsGrid.RowCount-1]:=inttostr(j);inc(r);
                    TNTWrongRowsGrid.Cells[r,TNTWrongRowsGrid.RowCount-1]:=s;inc(r);
                    TNTWrongRowsGrid.Cells[r,TNTWrongRowsGrid.RowCount-1]:=inttostr(k);inc(r);
                    TNTWrongRowsGrid.Cells[r,TNTWrongRowsGrid.RowCount-1]:=s2;inc(r);
                    inc(fnd);
               End;
          End;
     End;
     if fnd=0 then
     ErrMsgBox.Lines.Add(CheckCompletedNoWrongRowFond)
     else
     if fnd=1 then
     ErrMsgBox.Lines.Add(inttostr(fnd)+wrongrowfound)
     else
     ErrMsgBox.Lines.Add(inttostr(fnd)+wrongrowsfound);
end;


procedure TRepFrmF.ViewDiffHexMIClick(Sender: TObject);
begin
     ViewDiffProc(ascVTHex);
end;

procedure TRepFrmF.MessageReceiver(var msg: TMessage);
var
  txt: PChar;
  s,cmd,fn:ASCMRString;
begin
     if not assigned(self) then exit;

  txt := PChar(msg.lParam);
  cmd:=csvData(txt,1);
  msg.Result := 1;
  if cmd='QExProc' then
  begin
       MQueueThreadExecType:=TExecType(Texttoint(csvData(txt,2)));
       if MQueueThreadExecType in [ext_WordFileToText,ext_ExcelFileToText,ext_pdftotext] then
       QueueTimer.Enabled:=True
       else
       QueueTimerTimer(nil);
  end else
  if cmd='bilgisayaroku' then
  begin
       ThreadIslemleriTags[3]:=1;
       ThreadIslemleriTmr.Enabled:=True;
  end else
  if cmd='Ready' then
  begin
       ThreadIslemleriTags[2]:=1;
       ThreadIslemleriTmr.Enabled:=True;

  end else
  if cmd='scCounter' then
  begin
       ThreadIslemleriTags[1]:=1;
       ThreadIslemleriTmr.Enabled:=True;
       //SearchScanningNotify(nil);
  end
  else
  if cmd='FileScanned' then
     OnFileScannedEvent(nil)
  else
  if cmd='FileFound' then
  begin
       s:=txt;
       CutcsvDataASCMR(s);
       fn:=s;
       if fn<>'' then
         SearchFileFound(nil,fn);
  end else
  begin

  end;
end;

procedure TRepFrmF.multicalc(i: integer);
Var
   j,k,r:integer;
   p:PSrcFileRec;
   RmvBtn:Boolean;

   psel:PSrcFileSelRec;
   mr_s:ASCMRString;
   nr_s:String;
   s1,s2,s3,s4,smatch,strpath,fext:ASCMRstring;
   pWOj:PWordObj;
   RegExSwc,errf:Boolean;

   FileInfo: SHFILEINFO;
   hdd,lsn,trh:ASCMRString;
   DiskRoot: array [0..20] of Char;
   Volume: array [0..255] of Char;
   sVolume:ASCMRString;
   vSeriNo1,vSeriNo2:dWord;
   MaxFileCLen:dWord;
   FSystemFlag:dWord;
   FSystemName:array [0..255] of Char;
   tmplst:TASCMRStringList;
   ThreadMsgTxt:String;///sadece send message için kullanýlacak
   errc:integer;
begin
     if not assigned(self) then exit;
     {$IF (DemoVersiyon=0)}
     r:=-1;
     lsn:=inttostr(strtoint('$'+RepMainF.RegisterHeader.SerialNo));;
     if RepSabitDSeri='' then
     begin
          nr_s:=GetEnvironmentVariable('HOMEDRIVE');
          if nr_s='' then nr_s:=GetEnvironmentVariable('SystemDrive');
          if nr_s='' then nr_s:=GetEnvironmentVariable('windir');
          if nr_s='' then nr_s:='C:';
          if not (nr_s[1] in ['A'..'Z']) then nr_s[1]:='C';
          DiskRoot[0]:=nr_s[1];
          DiskRoot[1]:=':';
          DiskRoot[2]:='\';
          try
             GetVolumeInformation(DiskRoot,Volume,255,@vSeriNo1,MaxFileCLen,FSystemFlag,FSystemName,255);
          except
             vSeriNo1:=0;
             Volume:='';
          end;
          //5035819        ''1556161046''
          sVolume:=Volume;
          hdd:=inttostr(vSeriNo1);
          RepSabitDSeri:=hdd;
     end else
     begin
          hdd:=RepSabitDSeri;
     end;
     if length(lsn)<7 then exit;
     trh:=ascdatestr(RepMainF.RegisterHeader.RegDate);
     r:=i;

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
                      r:=r-(((strtoint(hdd[4]) mod 6)+1)*((strtoint(lsn[3]) mod 8)+1)+strtoint(lsn[6])+strtoint(trh[3]));   //58
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
            r:=clcdegerleri[i];
     {$IFEND}

     case r of
          /////////SearchBtnClick
          1:EraseTempFiles;
          2:DropFileData;
          3:
          begin

               DirList1.Clear;
               DirList1.UpdateColumns;

          end;
          4:
          begin
               NotReadedFileCount:=0;
               FileScannedCount:=0;
               RMatchedFileCounter:=0;
               TNTReportRE.Lines.Clear;
               ExtWordLst.Clear;
               ExtLineLst.Clear;
               SearchStartTime:=now;
               MQueueThread.FSearchStartTime:=SearchStartTime;
               TNTReportRE.Lines.Add(ReplaceText(MsgSearchStart,'$Tarih',DateTimeToStr(SearchStartTime)));

          end;
          5:
          begin
               RmvBtn:=False;
               oldremoveds.Clear;
               for j := 0 to srcfilereclist.Count - 1 do
               begin
                    p:=srcfilereclist.Items[j];
                    if p^.Removed then
                    Begin
                         oldremoveds.Add(p^.OrjFileName);
                    End;
               end;

          end;
          6:
          begin
               Lastmainitm:=nil;
               LastAddedFilePath:='';
               LastAddedIndex:=-1;
               LastAddedTime:=now;

          end;
          7:
          begin
               ShowInfo(msgStartSearch);
               Sleep(50);
               FoundedFCount:=0;
               ScannedFCount:=0;
               MatchesCount:=0;
               PrcViewF.vpFoundedFC:='0';
               PrcViewF.vpScannedFC:='0';
               PrcViewF.vpNotReadedFC:='0';
               PrcViewF.vpFileQueue:='0';
               PrcViewF.vpMatchedFC:='0';
               PrcViewF.vpScanFolder:='';
               PrcViewF.vpScanFile:='';

          end;
          8:
          begin
               MQueueThread.FStyleSwc:=FormStyleSwc;
               MFileSearchObj.Prepare(FormStyleSwc);
               MQueueThread.FQStopAfterFMatchAllFlag:=False;
               MFileSearchObj.Start(SrcFileSelReclist);
               MFileSearching:=True;
               if RepMainF.vAutoClose and RepMainF.vAutoHide then PrcViewF.Hide else PrcViewF.Show;
               with PrcViewF do
               begin
                    PlayBtn.Visible:=False;PauseBtn.Visible:=True;
                    PlayBtn.Enabled:=True;
                    PauseBtn.Enabled:=True;
                    StopBtn.Enabled:=True;
               end;
               ShowInfo(msgSearching);
               MBar1.Active:=True;
               MBar1.Visible:=True;
          end;
          9:
          ApplySingleWordChanges;
          10:
          begin
               TNTReportRE.Lines.Add(msgSrcPropTexts);
               RegExSwc:=False;
               for j:=1 to WordsList.Count do
               Begin
                         pWOj:=WordsList.Items[j-1];
                         k:=1;
                         if (FormStyleSwc=2) or (FormStyleSwc=4) then
                         Begin
                         end else
                         Begin
                              pWOj^.SubMatchTxt:='';
                              pWOj^.ReplaceTxt:='';
                         End;
                         s3:=TNTWordGrid.Cells[k,j];inc(k);//case
                         s4:=TNTWordGrid.Cells[k,j];inc(k);//regex
                         if (k=2) or (k=4) then //replace
                         mr_s:=msgSrcPropReplaceTextItem
                         else
                         mr_s:=msgSrcPropSearchTextItem;

                         mr_s:=ReplaceText_MR(mr_s,'$TextNo',inttostr(j));
                         mr_s:=ReplaceText_MR(mr_s,'$SearchText',pWOj^.SearchTxt);
                         mr_s:=ReplaceText_MR(mr_s,'$SubMatchText',pWOj^.SubMatchTxt);
                         mr_s:=ReplaceText_MR(mr_s,'$ReplaceText',pWOj^.ReplaceTxt);
                         mr_s:=ReplaceText_MR(mr_s,'$CaseSens',BoolToStrYN(pWOj^.CaseSwc));
                         mr_s:=ReplaceText_MR(mr_s,'$RegExUse',BoolToStrYN(pWOj^.RegEx));
                         mr_s:=ReplaceText_MR(mr_s,'$KeepCaseSens',BoolToStrYN(pWOj^.KeepCase));
                         TNTReportRE.Lines.Add(mr_s);
                         if pWOj^.RegEx Then RegExSwc:=True;
               end;
               if RegExSwc then
               begin
                    mr_s:=msgSrcPropRegExInfo;{=#13#10Regular Expressions Properties'#13#10+
                    'Greedy="$RegExGreedy",Multi Line="$RegExMultiLine",'+
                    'Single Line="$RegExSingleLine",Extended="$RegExExtended",'+
                    'Anchored="$RegExAnchored"'}
                    if appdefaultsrec.RegExGreedyChk then s1:='Y' Else s1:='N';
                    mr_s:=ReplaceText_MR(mr_s,'$RegExGreedy',s1);
                    if appdefaultsrec.RegExMultiLineChk then s1:='Y' Else s1:='N';
                    mr_s:=ReplaceText_MR(mr_s,'$RegExMultiLine',s1);
                    if appdefaultsrec.RegExSingleLineChk then s1:='Y' Else s1:='N';
                    mr_s:=ReplaceText_MR(mr_s,'$RegExSingleLine',s1);
                    if appdefaultsrec.RegExExtendedChk then s1:='Y' Else s1:='N';
                    mr_s:=ReplaceText_MR(mr_s,'$RegExExtended',s1);
                    {
                    if appdefaultsrec.RegExAnchoredChk then s1:='Y' Else s1:='N';
                    mr_s:=ReplaceText(mr_s,'$RegExAnchored',s1);
                    }
                    TNTReportRE.Lines.Add(mr_s);
               end;


          end;

          11:
          begin
               PrcViewF.vpScanFile:=Mince(MQueueThread.ScanFile,PrcViewF.CFileNameSize);
          end;
          14:
          begin
               if RepMainF.ExtWordFile<>'' then
               begin
                    try
                       ExtWordLst.SaveToFile(RepMainF.ExtWordFile);
                    except
                    end;
               end;
               if RepMainF.ExtLineFile<>'' then
               begin
                    try
                       ExtLineLst.SaveToFile(RepMainF.ExtLineFile);
                    except
                    end;
               end;
               if fStartReplace then
               begin
                    DegistirClick(nil);
               end;

          end;
          15:
          begin
               tmplst:=TASCMRStringList.Create;
               if MQueueThread.ExtractedWords<>'' then
               begin
                    tmplst.Text:=MQueueThread.ExtractedWords;
                    ListBirlestir(ExtWordLst,tmplst,true);
               end;
               if MQueueThread.ExtractedLines<>'' then
               begin
                    tmplst.Text:=MQueueThread.ExtractedLines;
                    ListBirlestir(ExtLineLst,tmplst,true);
               end;
               tmplst.Free;
               tmplst:=nil;
               MQueueThread.ExtractedWords:='';
               MQueueThread.ExtractedLines:='';
               if AddToSrcFileList(MQueueThread.ScanFile,MQueueThread.fProcessFile,MQueueThread.MatchInFileCount,
               MQueueThread.MatchesLinecount,MQueueThread.DestinationDir,
               True{Bulunduðu anda ekranda gösterilir},MQueueThread.qtFileNameOperation) then //kelime bulunanlara eklendi
               begin
                    FoundedFCount:=FoundedFCount+1;
                    MatchesCount:=MatchesCount+MQueueThread.MatchInFileCount;
                    PrcViewF.vpFoundedFC:=DblToText(FoundedFCount,asfF);
                    if MQueueThread.FQStopAfterFMatchAllFlag then
                    Begin
                         StopSearch(nil);
                    end;
               end;
               MQueueThread.mesajalindi:=true;
          end;
          16:
          begin
               PrcViewF.vpScannedFC:=DblToText(FileScannedCount,asfF);
               PrcViewF.vpScanFolder:='';
               MFileSearching:=False;
               MFileSearchObj.Stop;

          end;
          20:
          begin
               NotReadedFileCount:=NotReadedFileCount+1;
               PrcViewF.vpNotReadedFC:=DblToText(NotReadedFileCount,asfF);
          end;
          22:
          begin
               if not MQueueThread.Active then
               Begin
                    MQueueThreadExecType:=ext_QueueStopping;
                    QueueTimerTimer(nil);
               End;
          end;
          23:
          begin
                    TNTReportRE.Lines.Add(ReplaceText(MsgFilesScanned,'$count',inttostr(FileScannedCount{MFileSearchObj.ScannedFileCounter})));
                    TNTReportRE.Lines.Add(ReplaceText(MsgFilesMatched,'$count',inttostr(RMatchedFileCounter)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgFilesSelWithMatches,'$count',inttostr(FoundedFCount)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgMatchesCount,'$count',inttostr(MatchesCount)));
                    if NotReadedFileCount>0 then
                    TNTReportRE.Lines.Add(ReplaceText(MsgNoReadFilesCount,'$count',inttostr(NotReadedFileCount)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgSearchStop,'$Tarih',DateTimeToStr(now)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgSearchTimeTaken,'$Time',TimeToStr(now-SearchStartTime)));
                    RmvBtn:=False;
                    ShowInfo(msgPreFoundFileList);
          end;
          24:
          begin
                    LastAddedIndex:=srcfilereclist.Count - 1;
                    LastAddedTime:=now;
                    //preparefilelist;
                    //ShowInfo(msgPreMatchList);

                    ///burada tmp dosya adlarý kullanýlarak bulunan dosyalar ekranda detaylý olarak gösterilecek
                    if PGCtrl.ActivePageIndex<PGCtrl.PageCount-1 then
                    PGCtrl.SelectNextPage(True,True);
                    ShowInfo(msgSearchComplete);
                    oldremoveds.Clear; //dosya ilk açýldýðýnda çýkarýlan dosyalar yüklenmiþ olabilir ancak çýkarýlan
                    //dosyalar srcfilereclist listesine alýnmýþtýr. Bir sonraki aramada srcfilereclist listesinden çýkarýlanlar bulunur
                    //MQueueThread.Active:=False;
                    if not MFileSearching then
                    Begin
                         MBar1.Active:=False;
                         MBar1.Visible:=False;
                         PrcViewF.Hide;
                    end;

          end;
          25:
          begin
                    for k := 0 to srcfilereclist.Count - 1 do
                    begin
                         p:=srcfilereclist.Items[k];
                         j:=oldremoveds.IndexOf(p^.OrjFileName);
                         if j>=0 then
                         begin
                              p^.Removed:=True;
                              RmvBtn:=True;
                         end;
                    End;
                    ShowRemovedAct.Enabled:=RmvBtn;

                    if LastAddedIndex<srcfilereclist.Count-1 then
                    for k := LastAddedIndex+1 to srcfilereclist.Count - 1 do
                    begin
                         p:=srcfilereclist.Items[k];
                         s1:=p^.OrjFileName;
                         strpath:=ExtractFilePath(p^.OrjFileName);
                         SHGetFileInfo(PChar(s1), 0, FileInfo,
                         SizeOf(FileInfo), SHGFI_TYPENAME);
                         p^.FileType:=FileInfo.szTypeName;
                         fext:='*'+ExtractFileExt(p^.OrjFileName);
                         if (Uppercase(fext)='*.EXE') or (Uppercase(fext)='*.ICO') then
                         fext:=p^.OrjFileName;

                         //SHGetFileInfo(PChar(strPath + SearchRec.Name), 0, FileInfo,
                         //SizeOf(FileInfo), SHGFI_ICON or SHGFI_SMALLICON);
                         //Icon := TIcon.Create;
                         Try
                            //icon.Handle := FileInfo.hIcon;
                            P^.iconindex := SysImg1.ImageIndexOf(fext,false);
                         except
                            P^.iconindex:=-1;
                         End;


                         AddFileItemToList(DirList1,k);
                    end;

          end;
          26:
          begin
               WordsPg.Visible:=False;
               WordsPg.TabVisible:=False;
               SingleSearchPg.Visible:=True;
               SingleSearchPg.TabVisible:=True;
               ChangePg.TabVisible:=False;
               ViewDiffAct.Enabled:=False;
               Next4Btn.Caption:='Show Report';
               SingleSearchPg.Caption:=msgSingleSearchPg;

          end;
          30:
          Begin
              //ThreadMsgTxt := 'foundfile;'+lastfoundfilename;
              //SendMessage(RepFrmFHandle, ASCThread_MESSAGE, 0, DWORD(PChar(ThreadMsgTxt)));

               errc:=0;

               errf:=false;
               repeat
                     EnterCriticalSection(Section1);

                     RMatchedFileCounter:=RMatchedFileCounter+1;
                     try
                        i:=MQueueThread.SearchFileQueue.IndexOf(lastfoundfilename);
                        if i<0 then
                           MQueueThread.SearchFileQueue.Add(lastfoundfilename);
                        PrcViewF.vpFileQueue:=Inttostr(MQueueThread.SearchFileQueue.Count);
                        errf:=false;
                     except
                        errf:=true;
                        //ShowMessage(inttostr(i)+','+lastfoundfilename)
                     end;
                     if errf then
                     begin
                          sleep(2);
                     end;

               until (not errf) or (errc>5);
               LeaveCriticalSection(Section1);
          End;
          33:
          begin
               TNTSelList1.ColCount:=8;
               TNTWordGrid.ColCount:=4;
               j:=1;
               TNTWordGrid.ColWidths[j]:=140;inc(j);
               TNTWordGrid.ColWidths[j]:=80;inc(j);
               TNTWordGrid.ColWidths[j]:=110;inc(j);
               Degistir.Visible:=False;
               Next3Btn.Caption:='Search';
               CheckHeadL.Caption:=msgCheckSearchOpr;
               ControlsPg.TabVisible:=False;
               ControlsPg.Visible:=False;
               ProjectDestDirPan.Visible:=False;
               SingleDestL1.Visible:=False;
          end;
          37:
          begin
               SingleDestinationE.Visible:=False;
               SingleNewL.Visible:=False;
               TNTSubMatchE.Visible:=False;
               SubMatchL.Visible:=False;
               TNTSingleNewE.Visible:=False;
               SingleKeepCase.Visible:=False;
               HexLbl2.Visible:=TNTSubMatchE.Visible;
               HexLbl3.Visible:=TNTSubMatchE.Visible;
               SysVarL2.Visible:=TNTSubMatchE.Visible;
               SysVarL3.Visible:=TNTSubMatchE.Visible;

               SingleFilePan.Height:=70;
               SingleWordPan.Height:=171;
               FileSelectionPg.Visible:=False;
               FileSelectionPg.TabVisible:=False;

          end;
          40:
          begin
               if MFileSearchObj.Paused or (not MQueueThread.FEnabled) then exit;
               MQueueThread.Active:=True;
          end;
          47:
          begin
               ControlsPg.TabVisible:=False;
               ControlsPg.Visible:=False;
               ProjectDestDirPan.Visible:=False;
               SingleDestL1.Visible:=True;
               SingleDestinationE.Visible:=True;
               SingleNewL.Visible:=True;
               TNTSubMatchE.Visible:=True;
               SubMatchL.Visible:=True;
               TNTSingleNewE.Visible:=True;
               SingleKeepCase.Visible:=True;
               SysVarL2.Visible:=TNTSubMatchE.Visible;
               SysVarL3.Visible:=TNTSubMatchE.Visible;
               HexLbl2.Visible:=TNTSubMatchE.Visible;
               HexLbl3.Visible:=TNTSubMatchE.Visible;

          end;
          50:
          begin
               TNTSelList1.ColCount:=9;
               TNTWordGrid.ColCount:=6;
               j:=1;
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=130;inc(j);
               TNTWordGrid.ColWidths[j]:=80;inc(j);
               TNTWordGrid.ColWidths[j]:=110;inc(j);
               Degistir.Visible:=True;
               Next3Btn.Caption:='Search';
               CheckHeadL.Caption:=msgCheckReplaceOpr;

          end;
     end;
end;

procedure TRepFrmF.MultiExec(i: integer);
var
   j,k,v:integer;
   s,s2:ASCMRString;
begin
     {$IF (DemoVersiyon=0)}
     if not assigned(self) then exit;
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
                         multicalc(v);
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
                         multicalc(v);
                    end else break;
               end;
          end;
     end;
     {$ELSE}
         case i of
              3:
              begin
                   multicalc(2);
              end;
              5:
              begin
                   multicalc(4);
              end;
              1:
              begin
                   multicalc(5);
                   multicalc(12);
                   multicalc(17);
              end;
              4:
              begin
                   multicalc(22);
              end;
              2:
              begin
                   multicalc(6);
                   multicalc(23);
              end;
                 9:
                 begin
                      multicalc(24);
                      multicalc(21);
                      multicalc(10);
                      multicalc(15);
                      multicalc(13);
                      multicalc(25);
                      multicalc(1);
                      multicalc(27);
                      multicalc(34);
                 end;
                 8:
                 begin
                      multicalc(9);
                      multicalc(35);
                 end;
                 6:
                 begin
                      multicalc(8);
                      multicalc(14);
                      multicalc(36);
                      multicalc(41);
                 end;
                 7:
                 begin
                      multicalc(42);
                      multicalc(37);
                 end;
                 10:
                 begin
                      multicalc(43);
                      multicalc(24);
                      multicalc(21);
                      multicalc(10);
                      multicalc(15);
                      multicalc(13);
                      multicalc(25);
                      multicalc(34);
                 end;
                 11:
                 begin
                      multicalc(25);
                      multicalc(5);
                      multicalc(33);
                      multicalc(11);
                      multicalc(12);
                 end;
         end;
     {$IFEND}
end;

procedure TRepFrmF.Next3BtnClick(Sender: TObject);
begin
     case FormStyleSwc of
          1,2:SearchBtnClick(nil);//Single search/single replace
          else
          begin
               if PGCtrl.ActivePageIndex<PGCtrl.PageCount-1 then
               PGCtrl.SelectNextPage(True,True);
          end;
     end;


end;

procedure TRepFrmF.Next4BtnClick(Sender: TObject);
begin
     case FormStyleSwc of
          2,4:PGCtrl.ActivePage:=ChangePg;
          else
          PGCtrl.ActivePage:=ReportPg;
     end;

end;

procedure TRepFrmF.NextActExecute(Sender: TObject);
begin
     Case PGCtrl.ActivePageIndex of
          1:SrcNext1BtnClick(Sender);
          2:
          Begin
               if WordsList.Count>0 then
               Next3BtnClick(Sender)
               else
               begin
                    MessageDlg(msgKelimeleriEkleyiniz,mtError,[mbOk],0);
               end;
          End;
          4:Next4BtnClick(Sender);
     End;

end;

procedure TRepFrmF.OpenBtnClick(Sender: TObject);
begin
     RepMainF.Open1Click(Sender);
end;

procedure TRepFrmF.OpenRepFile;
Var
   s,s1,s2,s3,s4,smatch:ASCMRString;
   ls:TASCMRStringList;
   r,j:integer;
   opt,err,fswc:integer;


   SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
   CaseSwc,KeepCase,RegEx,WordsOnly,
   MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
   uMatchReq {Ýçermeyen(Bütün dosyalar için)},
   SearchOnly{(for replace projects)},
   StopAfterFMatchThisFile,StopAfterFMatchAll,
   SearchStarter,SearchStopper:boolean;
   areainfo,start1,start2,stop1,stop2:ASCMRString;
   csvchar:ASCMRString;
   fdestdir:ASCMRString;
   GroupNumber:integer;
begin
     opt:=0;
     err:=0;
     RepMainF.SelFileList.Clear;
     oldremoveds.Clear; //her ihtimale karþý çýkarýlanlar listesi boþaltýlýr
     ls:=TASCMRStringList.Create;
     try
        ls.LoadFromFile(frepfilename);
     except
        err:=-5;
     end;
     if err=0 then
     if ls.Count<5 then err:=-1
     else
     if ls.Strings[0]<>RDF_FileSign Then err:=-2
     else
     if ls.Strings[1]<>RDF_FileVer then err:=-3
     else
     if Pos('Type=',ls.Strings[2])<1 then err:=-4;

     if err<0 then
     begin
          case err of
               -3:
               Begin
                    if RepMainF.AppDlg(msYNC,openfileversionerr)<>rsYes then
                    begin
                         AddSelectedFilesToSrc;
                         WordListPaint;
                         FileSaveRequered:=false;
                         Caption:=frepfilename;
                         exit;
                    end;
               end;
               -5:
               Begin
                    RepMainF.AppShowMessage(ReplaceText_MR(CanNotReadingFile,'$filename',frepfilename));
                    AddSelectedFilesToSrc;
                    WordListPaint;
                    FileSaveRequered:=false;
                    Caption:=frepfilename;
                    exit;
               End;
               else
               Begin
                    AddSelectedFilesToSrc;
                    WordListPaint;
                    FileSaveRequered:=false;
                    Caption:=frepfilename;
                    RepMainF.AppShowMessage(openfilebadformat);
                    exit;
               end;
          end;

     end;
     fswc:=0;
     for j := 0 to high(RepFileTypes) do
         if ls.Strings[2]='Type='+RepFileTypes[j] then fswc:=j+1;
     if FormStyleSwc=0 then //eðer daha önce proje þekli belirtilmediyse
     begin
          FormStyleSwc:=fswc;
          EditDisplay;
     end;
     r:=3;
     fdestdir:=appdefaultsrec.DestDir;
     if r<ls.Count then
     begin
          s:=ls.Strings[r];
          if Pos('destination directory=',lowercase(s))=1 then
          begin
               fdestdir:=xsvData(s,'=',2);
               inc(r);
          end;
     end;
     ProjectDestE1.Text:=fdestdir;
     SingleDestinationE.Text:=fdestdir;
     for j:=r to ls.Count-1 do
     Begin
          s:=ls.Strings[j];
          if s='['+RDF_FileList+']' then opt:=1
          else
          if s='['+RDF_WordList+']' then opt:=2
          else
          if s='['+RDF_RemovedList+']' then opt:=3
          else
          if opt=1 then //add to file list
          Begin
               RepMainF.SelFileList.Add(s);
          end else
          if opt=2 then //add to word list
          Begin
               SearchTxt:=csvRePrepareColumnASCMR(CutcsvDataASCMR(s));

               if (fswc=2) or (fswc=4) then
               Begin
                    SubMatchTxt:=csvRePrepareColumnASCMR(CutcsvDataASCMR(s));
                    ReplaceTxt:=csvRePrepareColumnASCMR(CutcsvDataASCMR(s));
               End
               else
               Begin
                    smatch:='';
                    s2:=s1;
               End;
               CaseSwc:=StrYNToBool(cutcsvdataASCMR(s));
               RegEx:=StrYNToBool(cutcsvdataASCMR(s));
               WordsOnly:=StrYNToBool(cutcsvdataASCMR(s));
               MatchReq:=StrYNToBool(cutcsvdataASCMR(s));
               uMatchReq:=StrYNToBool(cutcsvdataASCMR(s));
               SearchOnly:=StrYNToBool(cutcsvdataASCMR(s));
               StopAfterFMatchThisFile:=StrYNToBool(cutcsvdataASCMR(s));
               StopAfterFMatchAll:=StrYNToBool(cutcsvdataASCMR(s));
               areainfo:=csvRePrepareColumnASCMR(cutcsvdataASCMR(s));
               start1:=csvRePrepareColumnASCMR(cutcsvdataASCMR(s));
               start2:=csvRePrepareColumnASCMR(cutcsvdataASCMR(s));
               stop1:=csvRePrepareColumnASCMR(cutcsvdataASCMR(s));
               stop2:=csvRePrepareColumnASCMR(cutcsvdataASCMR(s));
               csvchar:=csvRePrepareColumnASCMR(cutcsvdataASCMR(s));
               KeepCase:=StrYNToBool(cutcsvdataASCMR(s));
               GroupNumber:=TextToInt(cutcsvdataASCMR(s));
               SearchStarter:=StrYNToBool(cutcsvdataASCMR(s));
               SearchStopper:=StrYNToBool(cutcsvdataASCMR(s));

               if not AddToWordList(SearchTxt,SubMatchTxt,ReplaceTxt,
               CaseSwc,KeepCase,RegEx,WordsOnly,
               MatchReq ,
               uMatchReq ,
               SearchOnly,
               StopAfterFMatchThisFile,StopAfterFMatchAll,
               SearchStarter,SearchStopper,
               TextToInt(areainfo),TextToInt(start1),TextToInt(start2),
               TextToInt(stop1),TextToInt(stop2),csvchar,GroupNumber) then break;
          end else
          if opt=3 then
          Begin
               oldremoveds.Add(s);
          end;
     end;
     ls.Free;
     ls:=nil;
     AddSelectedFilesToSrc;
     WordListPaint;
     FileSaveRequered:=false;
     Caption:=frepfilename;
end;


procedure TRepFrmF.OtherActBtnClick(Sender: TObject);
begin
     OtherActPUP.Popup(OtherActBtn.ClientOrigin.X+OtherActBtn.Width,OtherActBtn.ClientOrigin.Y);

end;

procedure TRepFrmF.OtherActPUPPopup(Sender: TObject);
begin
     SOpenAct.Enabled:=True;
     SOpenAct.Enabled:=True;
end;

procedure TRepFrmF.PrcViewBtnClick(Sender: TObject);
begin
     PrcViewF.Show;
end;

procedure TRepFrmF.AddFileItemToList(ListView: TpTree; j: integer);
var
   i: Integer;
   ListItem: TTreeNode;
   str:ASCMRstring;
   strpath,strfn:ASCMRString;
   p:PSrcFileRec;
   FileInfo: SHFILEINFO;
   fext:string;
begin
     //ListView.Visible:=False;
     if (j>=0) and (j<srcfilereclist.Count) then
     Begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then exit;
          strfn:=p^.OrjFileName;
          strpath:=ExtractFilePath(strfn);
          if (LastAddedFilePath<>strpath) or (LastAddedFilePath='*') Then
          Begin
               Lastmainitm:=ListView.tv.Items.Add(nil,strpath);
               Lastmainitm.ImageIndex:=DirIconIndex;
               Lastmainitm.SelectedIndex:=DirIconIndex;
               LastAddedFilePath:=strpath;
          end;
          str:=p^.shortname+'|'+inttostr(p^.MatchCount)+'|'+
          GetSizeDescription(p^.FileSize)+'|';
          if p^.ModifyDate>0 then
          str:=str+DateToStr(p^.ModifyDate);
          str:=str+'|';
          strfn:=p^.OrjFileName;
          fext:='*'+ExtractFileExt(strfn);
          if SHGetFileInfo(PChar(fext), FILE_ATTRIBUTE_NORMAL, FileInfo,
          SizeOf(FileInfo), SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES)<>0 then
          p^.FileType:=FileInfo.szTypeName else p^.FileType:='';
          str:=str+p^.FileType+'|';
          ListItem := ListView.tv.Items.AddChild(Lastmainitm,str);
          ListItem.ImageIndex := p^.iconindex;
          ListItem.SelectedIndex:=ListItem.ImageIndex;
          ListItem.Data:=P;
          //ShowInfo(msgPreFoundFileList);
     end;
     //ShowInfo(msgPreFoundFileList);
     //sleep(50);

     //ListView.tv.FullCollapse;
     //ListView.Visible:=True;
end;

procedure TRepFrmF.AddFilesToList(ListView: TpTree);
var
   FileInfo: SHFILEINFO;
   j,
   i: Integer;
   mainitm,ListItem: TTreeNode;
   str:ASCMRstring;
   strpath,oldpath,strfn:ASCMRString;
   p:PSrcFileRec;
   fn,fext:string;
begin
     ListView.Visible:=False;
     oldpath:='';
     mainitm:=nil;
     for j:=0 to srcfilereclist.Count-1 do
     Begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then continue;
          strfn:=p^.OrjFileName;
          strpath:=ExtractFilePath(strfn);
          if (oldpath<>strpath) or (oldpath='*') Then
          Begin
               mainitm:=ListView.tv.Items.Add(nil,strpath);
               mainitm.ImageIndex:=DirIconIndex;
               mainitm.SelectedIndex:=DirIconIndex;
               oldpath:=strpath;
          end;
          str:=p^.shortname+'|'+inttostr(p^.MatchCount)+'|'+
          GetSizeDescription(p^.FileSize)+'|';
          if p^.ModifyDate>0 then
          str:=str+DateToStr(p^.ModifyDate);
          str:=str+'|';
          fn:=p^.OrjFileName;
          fext:='*'+ExtractFileExt(fn);
          if SHGetFileInfo(PChar(fext), FILE_ATTRIBUTE_NORMAL, FileInfo,
          SizeOf(FileInfo), SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES)<>0 then
          p^.FileType:=FileInfo.szTypeName else p^.FileType:='';

          str:=str+p^.FileType+'|';
          ListItem := ListView.tv.Items.AddChild(mainitm,str);
          ListItem.ImageIndex := p^.iconindex;
          ListItem.SelectedIndex:=ListItem.ImageIndex;
          ListItem.Data:=P;
          ShowInfo(msgPreFoundFileList);
     end;
     ShowInfo(msgPreFoundFileList);
     sleep(50);

     ListView.tv.FullCollapse;
     ListView.Visible:=True;
end;

function TRepFrmF.preparefilecontents(Var fArrASCFilecnt:TASCFileCntArr;const sv:TMemoryStream;
    p:PSrcFileRec;var indexes:TIndxArray;ViewType{0:Normal,1:Hex}:integer;const funixrowlist:TList):boolean;
Var
   fcur, //file cursor
   flen,//file length
   j,k,wstyle,
   idxlen   ///bulunan kelimelerin indexleri alýnacak. bunun için kayit no sayacý
   :integer;
   fn,sfpth,tmpstr:ASCMRString;
   srclf:File of TASCSearchRec;
   sr:TASCSearchRec;
   floadcancel:Boolean;
   buf:Array [1..1024] of ASCMRChar;

    function ReadFileData(fn:TFileName):integer;
    Var
       filedata:File;
       dw, //yazýlacak data  (normal text dosya açinde satýr sonu karakteri unix formatýnda tek msdos da çift karakter birisi #10 diðer #13#10
       dr //okunan data
       :Array [1..MaxMRChar] of ASCMRChar;
       c,r,ts,pj,
       rj, //okunan data for dongu
       ri, //okunan data gecici dongu
       fri //dosya okunan toplam data
       :integer;
       EFM:Byte;
       PrcsF:TProgressF;
       vPrcs:Boolean;
       lastwch:ASCMRchar;  //son yazýlan deðer
    begin
         Result:=0;
         lastwch:=#0;
         pj:=0;
         fri:=0;  ///dosyadan okunan toplam data sýfýrlanýyor
         EFM:=FileMode;
         try
            vPrcs:=False;
            FileMode:=fmOpenRead;
            AssignFile(filedata,fn);
            {$I-}Reset(filedata,1);{$I+}
            if IOResult<>0 then
            begin
                 FileMode:=EFM;
                 exit;
            end;
            ts:=FileSize(fileData);
            if ts>99000 then
            begin
                 PrcsF:=TProgressF.Create(nil);
                 PrcsF.Show;
                 PrcsF.PB1.Max:=ts;
                 vPrcs:=True;
            end;
            while ts>0 do
            begin
                 r:=0;

                 if ViewType=ascVTNormal then
                 begin
                      if ts>16384 then
                      {$IF (ASCUniCodeUsing=1)}
                      c:=8192
                      {$ELSE}
                      c:=16384
                      {$IFEND}
                      else c:=ts;
                      blockread(filedata,dr,c,r);
                      ri:=1;
                      if r>0 then
                      begin
                           if dr[1]=#10 then
                           begin
                                dw[ri]:=#13;inc(ri);
                                funixrowlist.Add(pointer(fri+1)) ;
                           end;
                           if (sv.Position=0) and ((dr[1]='{') or (dr[1]='}')) then
                           begin
                                dw[ri]:=#32;inc(ri);
                                funixrowlist.Add(pointer(fri+1)) ;
                           end;
                           dw[ri]:=dr[1];inc(ri);
                           if r>1 then
                            for rj := 2 to r  do
                            begin
                                if (dr[rj]=#10) and (dr[rj-1]<>#13) then //onunde #13 karakteri olmayan #10 varsa
                                begin
                                     dw[ri]:=#13;inc(ri);
                                     funixrowlist.Add(pointer(fri+rj));
                                end;
                                if (lastwch=#13) and (dr[rj]<>#10) then //onunde #13 karakteri olmayan #10 varsa
                                begin
                                     dw[ri]:=#10;inc(ri);
                                     funixrowlist.Add(pointer(fri+rj));
                                end;
                                (*
                                if (dr[rj]='{') or (dr[rj]='}') then
                                begin
                                     dw[ri]:='/';inc(ri);
                                end;
                                *)
                                dw[ri]:=dr[rj];inc(ri);
                                lastwch:=dr[rj];
                            end;
                      end;
                      inc(fri,r); //dosyadan okunan toplam data sayýsý deðiþkeni guncelleniyor.

                      r:=ri-1;   ///dosyadan okunan data sayýsý belleðe yazýlacak data sayýsýna çevriliyor
                      if r>0 then
                      begin
                           dec(ts,r);
                           if vPrcs then
                           begin
                                inc(pj);
                                if (pj mod 3)=2 then
                                begin
                                     PrcsF.PB1.Position:=PrcsF.PB1.Max-ts;
                                     Application.ProcessMessages;
                                     if PrcsF.fCancelled then
                                     begin
                                          floadcancel:=true;
                                          break;
                                     end;
                                end;
                           end;
                      end else
                      begin
                           break;
                      end;
                      sv.Write(dw,r);

                 end else
                 begin
                      if ts>MaxMRChar then c:=MaxMRChar else c:=ts;
                      blockread(filedata,dw,c,r);
                      if r>0 then
                      begin
                           dec(ts,r);
                           if vPrcs then
                           begin
                                inc(pj);
                                if (pj mod 3)=2 then
                                begin
                                     PrcsF.PB1.Position:=PrcsF.PB1.Max-ts;
                                     Application.ProcessMessages;
                                     if PrcsF.fCancelled then
                                     begin
                                          floadcancel:=true;
                                          break;
                                     end;
                                end;
                           end;
                      end else
                      begin
                           break;
                      end;
                      sv.Write(dw,r);
                 end;
            end;
            Result:=sv.Size;
            closeFile(filedata);
         except
                 on E: Exception do MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);
         end;
         FileMode:=EFM;
         if vPrcs then
         begin
              if Assigned(PrcsF) then
              begin
                   PrcsF.Free;
                   PrcsF:=Nil;
              end;
         end;
    end;



    function ReadFileDataB(fn:TFileName):integer;
    Var
       filedata:File;
       dw, //yazýlacak data  (normal text dosya açinde satýr sonu karakteri unix formatýnda tek msdos da çift karakter birisi #10 diðer #13#10
       dr //okunan data
       :Array [1..MaxMRChar] of Char;
       c,r,ts,pj,
       rj, //okunan data for dongu
       ri, //okunan data gecici dongu
       fri //dosya okunan toplam data
       :integer;
       EFM:Byte;
       PrcsF:TProgressF;
       vPrcs:Boolean;
       lastwch:char;  //son yazýlan deðer
    begin
         Result:=0;
         lastwch:=#0;
         pj:=0;
         fri:=0;  ///dosyadan okunan toplam data sýfýrlanýyor
         EFM:=FileMode;
         try
            vPrcs:=False;
            FileMode:=fmOpenRead;
            AssignFile(filedata,fn);
            {$I-}Reset(filedata,1);{$I+}
            if IOResult<>0 then
            begin
                 FileMode:=EFM;
                 exit;
            end;
            ts:=FileSize(fileData);
            if ts>99000 then
            begin
                 PrcsF:=TProgressF.Create(nil);
                 PrcsF.Show;
                 PrcsF.PB1.Max:=ts;
                 vPrcs:=True;
            end;
            while ts>0 do
            begin
                 r:=0;

                 if ViewType=ascVTNormal then
                 begin
                      if ts>16384 then c:=16384 else c:=ts;
                      blockread(filedata,dr,c,r);
                      ri:=1;
                      if r>0 then
                      begin
                           if dr[1]=#10 then
                           begin
                                dw[ri]:=#13;inc(ri);
                                funixrowlist.Add(pointer(fri+1)) ;
                           end;
                           dw[ri]:=dr[1];inc(ri);
                           if r>1 then
                            for rj := 2 to r  do
                            begin
                                if (dr[rj]=#10) and (dr[rj-1]<>#13) then //onunde #13 karakteri olmayan #10 varsa
                                begin
                                     dw[ri]:=#13;inc(ri);
                                     funixrowlist.Add(pointer(fri+rj));
                                end;
                                if (lastwch=#13) and (dr[rj]<>#10) then //onunde #13 karakteri olmayan #10 varsa
                                begin
                                     dw[ri]:=#10;inc(ri);
                                     funixrowlist.Add(pointer(fri+rj));
                                end;
                                dw[ri]:=dr[rj];inc(ri);
                                lastwch:=dr[rj];
                            end;
                      end;
                      inc(fri,r); //dosyadan okunan toplam data sayýsý deðiþkeni guncelleniyor.

                      r:=ri-1;   ///dosyadan okunan data sayýsý belleðe yazýlacak data sayýsýna çevriliyor
                      if r>0 then
                      begin
                           dec(ts,r);
                           if vPrcs then
                           begin
                                inc(pj);
                                if (pj mod 3)=2 then
                                begin
                                     PrcsF.PB1.Position:=PrcsF.PB1.Max-ts;
                                     Application.ProcessMessages;
                                     if PrcsF.fCancelled then
                                     begin
                                          floadcancel:=true;
                                          break;
                                     end;
                                end;
                           end;
                      end else
                      begin
                           break;
                      end;
                      sv.Write(dw,r);

                 end else
                 begin
                      if ts>MaxMRChar then c:=MaxMRChar else c:=ts;
                      blockread(filedata,dw,c,r);
                      if r>0 then
                      begin
                           dec(ts,r);
                           if vPrcs then
                           begin
                                inc(pj);
                                if (pj mod 3)=2 then
                                begin
                                     PrcsF.PB1.Position:=PrcsF.PB1.Max-ts;
                                     Application.ProcessMessages;
                                     if PrcsF.fCancelled then
                                     begin
                                          floadcancel:=true;
                                          break;
                                     end;
                                end;
                           end;
                      end else
                      begin
                           break;
                      end;
                      sv.Write(dw,r);
                 end;
            end;
            Result:=sv.Size;
            closeFile(filedata);
         except
            on E: Exception do MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);
         end;
         FileMode:=EFM;
         if vPrcs then
         begin
              if Assigned(PrcsF) then
              begin
                   PrcsF.Free;
                   PrcsF:=Nil;
              end;
         end;
    end;


begin
     Result:=False;
     if p=nil then exit;
     floadcancel:=False;
     fn:=p^.ProcessFile;
     if p^.FileNameOperation then
     begin

          tmpstr:=ExtractFileName(p^.OrjFileName);
          for k := 1 to length(tmpstr) do
            buf[k]:=tmpstr[k];
          sv.Write(buf,length(tmpstr));
     end
     else
     begin
          if ViewType=0 then
          ReadFileData(p^.ProcessFile)
          else
          ReadFileDataB(p^.ProcessFile);
     end;

     if floadcancel then
     begin
          exit;
     end;
     //ContentLbl.Caption:=fn;
     if FormStyleSwc<3 then
     Begin
          setlength(fArrASCFilecnt,1);
          For k:=1 to 1 do
          Begin
               if TNTSingleOldE.Lines.Text='' Then
               Begin
                    fArrASCFilecnt[k-1].p:=0;
                    SetLength(fArrASCFilecnt[k-1].sr,0);
                    continue;
               end;
               sfpth:=TempDir+'sf'+inttostr(repformid)+'_'+DblToText(p^.fileindex,'NNNNNN')+
               DblToText(k,'NNNNN')+'.tmp';
               AssignFile(srclf,sfpth);
               {$I-}Reset(srclf);{$I+}
               if ioresult<>0 then Continue;
               SetLength(fArrASCFilecnt[k-1].sr,filesize(srclf));
               fArrASCFilecnt[k-1].p:=0;
               j:=0;
               while not eof(srclf) do
               Begin
                    read(srclf,fArrASCFilecnt[k-1].sr[j]);
                    inc(j);
               end;
               closefile(srclf);
          end;
     end else
     Begin
          setlength(fArrASCFilecnt,TNTWordGrid.RowCount);
          For k:=1 to TNTWordGrid.RowCount-1 do
          Begin
               if TNTWordGrid.Cells[1,k]='' Then
               Begin
                    fArrASCFilecnt[k-1].p:=0;
                    SetLength(fArrASCFilecnt[k-1].sr,0);
                    continue;
               end;
               sfpth:=TempDir+'sf'+inttostr(repformid)+'_'+DblToText(p^.fileindex,'NNNNNN')+
               DblToText(k,'NNNNN')+'.tmp';
               AssignFile(srclf,sfpth);
               {$I-}Reset(srclf);{$I+}
               if ioresult<>0 then Continue;
               SetLength(fArrASCFilecnt[k-1].sr,filesize(srclf));
               fArrASCFilecnt[k-1].p:=0;
               j:=0;
               while not eof(srclf) do
               Begin
                    read(srclf,fArrASCFilecnt[k-1].sr[j]);
                    inc(j);
               end;
               closefile(srclf);
          end;
     end;
     Result:=true;
end;

procedure TRepFrmF.preparefilelist;
Var
   j:integer;
begin

     DirList1.Clear;
     AddFilesToList(DirList1);
     DirList1.UpdateColumns;
     
end;


procedure TRepFrmF.PrepareSelFileList;
Var
   i:integer;
   p:PSrcFileSelRec;
   dnow,idnow:double;
begin
     dnow:=now;
     idnow:=int(dnow);
     for I := 0 to SrcFileSelReclist.Count - 1 do
     begin
          p:=SrcFileSelReclist.Items[i];
          Case p^.srDateOption of
               {0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom}
               1:
               begin
                    p^.srMinDate:=dnow-(1/24);
                    p^.srMaxDate:=0;
               end;
               2:
               begin
                    p^.srMinDate:=idnow;
                    p^.srMaxDate:=0;
               end;
               3:
               begin
                    p^.srMinDate:=idnow-(1.00);
                    p^.srMaxDate:=idnow;
               end;
               4:
               begin
                    p^.srMinDate:=StartOfTheWeek(dnow);
                    p^.srMaxDate:=EndOfTheWeek(dnow);
               end;
               5:
               begin
                    p^.srMinDate:=StartOfTheMonth(dnow);
                    p^.srMaxDate:=EndOfTheMonth(dnow);
               end;
               6:
               begin
                    p^.srMinDate:=StartOfTheYear(dnow);
                    p^.srMaxDate:=EndOfTheYear(dnow);
               end;
               7:
               begin
                    //p^.srMinDate:=dnow-(1/24);
                    //p^.srMaxDate:=0;
               end;
          End;
     end;
end;

procedure TRepFrmF.PrintReportBtnClick(Sender: TObject);
begin
     TNTReportRE.Margins.Left:=20;
     TNTReportRE.Margins.Top:=20;
     TNTReportRE.Print(Caption);
end;

procedure TRepFrmF.QueueTimerTimer(Sender: TObject);
Var
   p:PSrcFileRec;
   mqc,j,k:integer;
   RmvBtn:Boolean;
   FileInfo: SHFILEINFO;
   s,strpath,fext:ASCMRString;
begin
     if not assigned(self) then exit;

     if not MQueueThread.FEnabled then exit;
     QueueTimer.Enabled:=False;
     case MQueueThreadExecType of
          ext_WordFileToText:
          begin
               //MQueueThread.fProcessFile
               if not WordSaveAsText(MQueueThread.ScanFile,MQueueThread.fProcessFile) then
               begin
                    if FileExists(MQueueThread.fProcessFile) then
                       SysUtils.DeleteFile(MQueueThread.fProcessFile);
               end;
               MQueueThread.OleIslemiTamamlandi:=true;

          end;
          ext_ExcelFileToText:
          begin
               if not ExcelSaveAsText(MQueueThread.ScanFile,MQueueThread.fProcessFile) then
               begin
                    if FileExists(MQueueThread.fProcessFile) then
                       SysUtils.DeleteFile(MQueueThread.fProcessFile);
               end;
               MQueueThread.OleIslemiTamamlandi:=True;

          end;
          ext_pdftotext:
          begin
               MQueueThreadExecType:=ext_pdftotextr;  //aþaðýdaki  fonksiyon
               //application.processmessages kullanýyor. bunun için tekrar ayný komutun
               //çalýþtýrýlmamasý gerekli.

               if not PrgSaveAsText(AppPath+RepMainF.pdfprogrami,'"'+MQueueThread.ScanFile+
               '" "'+MQueueThread.fProcessFile+'"') then
               begin
                    if FileExists(MQueueThread.fProcessFile) then
                       SysUtils.DeleteFile(MQueueThread.fProcessFile);
               end;
               MQueueThread.PDFTamamlandi:=True;

          end;
          ext_NewSearch:
          begin
               MultiExec(3);
               {
               //vpScanFolder:=MQueueThread.ScanFolder;
               //multi 11
               PrcViewF.vpScanFile:=Mince(MQueueThread.ScanFile,PrcViewF.CFileNameSize);
               //////////
               }
          end;
          ext_ReadingFile:
          begin

               EnterCriticalSection(Section2);
               try
                  PrcViewF.vpScanFile:=Mince(MQueueThread.ScanFile,PrcViewF.CFileNameSize);
                  PrcViewF.vpFileQueue:=Inttostr(MQueueThread.SearchFileQueue.Count);
               except
               end;
               LeaveCriticalSection(Section2);
          end;
          ext_SearchInFile:
          begin
               try
                  PrcViewF.vpScanFile:=Mince(MQueueThread.ScanFile,PrcViewF.CFileNameSize);
                  PrcViewF.vpFileQueue:=Inttostr(MQueueThread.SearchFileQueue.Count);
               except
               end;
          end;
          ext_FoundFile:
          begin
               //multi blok 4
               MultiExec(4);
               (*
               ///multi15
               AddToSrcFileList(MQueueThread.ScanFile,MQueueThread.fProcessFile,MQueueThread.MatchInFileCount,
               MQueueThread.MatchesLinecount,MQueueThread.DestinationDir,
               True{Bulunduðu anda ekranda gösterilir},MQueueThread.qtFileNameOperation); //kelime bulunanlara eklendi
               FoundedFCount:=FoundedFCount+1;
               MatchesCount:=MatchesCount+MQueueThread.MatchInFileCount;
               PrcViewF.vpFoundedFC:=DblToText(FoundedFCount,asfF);
               if MQueueThread.FQStopAfterFMatchAllFlag then
               Begin
                    MFileSearchObj.Stop;
                    MQueueThread.SearchFileQueue.Clear;
               end;
               //////////
               *)
               Try
                  PrcViewF.vpFileQueue:=Inttostr(MQueueThread.SearchFileQueue.Count);
               except
               end;
          end;
          ext_ErrFile:
          begin
               //multi blok 5
               MultiExec(5);
               {
               //multi 20
               NotReadedFileCount:=NotReadedFileCount+1;
               PrcViewF.vpNotReadedFC:=DblToText(NotReadedFileCount,asfF);
               //////
               }
               try
                  PrcViewF.vpFileQueue:=Inttostr(MQueueThread.SearchFileQueue.Count);
               except
               end;
          end;
          ext_QueueStopping:
          Begin
               try
                  mqc:=MQueueThread.SearchFileQueue.Count;
               except
                  mqc:=0;
               end;
               PrcViewF.vpFileQueue:=Inttostr(mqc);
               PrcViewF.vpMatchedFC:=DblToText(RMatchedFileCounter,asfF);  //MFileSearchObj.MatchedFileCounter
               if ((mqc=0) and (not MFileSearching)) or
                  MQueueThread.FQStopAfterFMatchAllFlag then
               Begin
                    MQueueThread.FEnabled:=False;
                    MQueueThread.Active:=False;
                    MFileSearchObj.Stop;
                    MQueueThread.SearchFileQueue.Clear;
                    MFileSearching:=False;

                    with PrcViewF do
                    begin
                         PlayBtn.Visible:=False;PauseBtn.Visible:=True;
                         PlayBtn.Enabled:=False;
                         PauseBtn.Enabled:=False;
                         StopBtn.Enabled:=False;
                    end;
                    PrcViewF.Hide;

                    //multi blok 6
                    MultiExec(6);
                    (*
                    //multi 23
                    TNTReportRE.Lines.Add(ReplaceText(MsgFilesScanned,'$count',inttostr(FileScannedCount{MFileSearchObj.ScannedFileCounter})));
                    TNTReportRE.Lines.Add(ReplaceText(MsgFilesMatched,'$count',inttostr(RMatchedFileCounter)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgFilesSelWithMatches,'$count',inttostr(FoundedFCount)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgMatchesCount,'$count',inttostr(MatchesCount)));
                    if NotReadedFileCount>0 then
                    TNTReportRE.Lines.Add(ReplaceText(MsgNoReadFilesCount,'$count',inttostr(NotReadedFileCount)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgSearchStop,'$Tarih',DateTimeToStr(now)));
                    TNTReportRE.Lines.Add(ReplaceText(MsgSearchTimeTaken,'$Time',TimeToStr(now-SearchStartTime)));
                    RmvBtn:=False;
                    ShowInfo(msgPreFoundFileList);
                    ///////////

                    //////multi 25
                    for k := 0 to srcfilereclist.Count - 1 do
                    begin
                         p:=srcfilereclist.Items[k];
                         j:=oldremoveds.IndexOf(p^.OrjFileName);
                         if j>=0 then
                         begin
                              p^.Removed:=True;
                              RmvBtn:=True;
                         end;
                    End;
                    ShowRemovedAct.Enabled:=RmvBtn;

                    if LastAddedIndex<srcfilereclist.Count-1 then
                    for k := LastAddedIndex+1 to srcfilereclist.Count - 1 do
                    begin
                         p:=srcfilereclist.Items[k];
                         strpath:=ExtractFilePath(p^.OrjFileName);
                         SHGetFileInfo(PChar(p^.OrjFileName), 0, FileInfo,
                         SizeOf(FileInfo), SHGFI_TYPENAME);
                         p^.FileType:=FileInfo.szTypeName;
                         fext:='*'+ExtractFileExt(p^.OrjFileName);
                         if (Uppercase(fext)='*.EXE') or (Uppercase(fext)='*.ICO') then
                         fext:=p^.OrjFileName;

                         //SHGetFileInfo(PChar(strPath + SearchRec.Name), 0, FileInfo,
                         //SizeOf(FileInfo), SHGFI_ICON or SHGFI_SMALLICON);
                         //Icon := TIcon.Create;
                         Try
                            //icon.Handle := FileInfo.hIcon;
                            P^.iconindex := SysImg1.ImageIndexOf(fext,false);
                         except
                            P^.iconindex:=-1;
                         End;


                         AddFileItemToList(DirList1,k);
                    end;
                    /////////////////////

                    //multi 24
                    LastAddedIndex:=srcfilereclist.Count - 1;
                    LastAddedTime:=now;
                    //preparefilelist;
                    //ShowInfo(msgPreMatchList);

                    ///burada tmp dosya adlarý kullanýlarak bulunan dosyalar ekranda detaylý olarak gösterilecek
                    if PGCtrl.ActivePageIndex<PGCtrl.PageCount-1 then
                    PGCtrl.SelectNextPage(True,True);
                    ShowInfo(msgSearchComplete);
                    oldremoveds.Clear; //dosya ilk açýldýðýnda çýkarýlan dosyalar yüklenmiþ olabilir ancak çýkarýlan
                    //dosyalar srcfilereclist listesine alýnmýþtýr. Bir sonraki aramada srcfilereclist listesinden çýkarýlanlar bulunur
                    //MQueueThread.Active:=False;
                    if not MFileSearching then
                    Begin
                         MBar1.Active:=False;
                         MBar1.Visible:=False;
                         PrcViewF.Hide;
                    end;
                    ///////////

                    //multi 14
                    if fStartReplace then
                    begin
                         DegistirClick(nil);
                    end;
                    ////////////
                    *)

               end;


          End;
          ext_Normally:
          begin
               ShowInfo(msgReady);
          end;
     end;


end;

function TRepFrmF.RegExSearcText(Var s:ASCMRstring;f,submatch,r:ASCMRString;sfpth:ASCMRstring;CaseSensitiveSwc,
KeepCaseSwc,WordsOnlySwc,StopAfterMatchSwc,Replace:Boolean;areainfo,
start1,start2,stop1,stop2:integer;csvchar:ASCMRString;GroupNumber:integer):integer;
Var
   j,linenum,currentcol,
   RegExObjStart,RegExObjStop
   :integer;
   //sv,
   fstr,frstr,chstr:ASCMRString;
   srclf:File of TASCSearchRec;
   sr:TASCSearchRec;
   //areainfo:bilgi arama konum seçenekleri 0:normal,1:dosya baþýndan itibaren baþlangýç start1,
   //karakter sayýsý stop1;2:Satýr numarasý olarak start1 ve stop 1;
   //3:sutun olarak start1,uzunluk stop1;
   //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
   //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
   //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
   //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
   //,start1,start2,stop1,stop2
   startstoppos,startstopposb:TPoint;
   fnextsearch:boolean;
   OnRepStr:ASCMRString;
begin
     Result:=0;
     currentcol:=1;
     sr.L:=Length(f);
     AssignFile(srclf,sfpth);
     {$I-}Rewrite(srclf);{$I+}
     if ioresult<>0 then exit;
     //sv:=s;
     fstr:=f;
     frstr:=r;
     sr.P:=0;
     RegExObj.ModifierI:=not CaseSensitiveSwc;
     RegExObj.Expression:=fstr;
     RegExObj.InputString:=s;//sv;
     //RegExObj.Replacement:=frstr;
     RegExObjStart:=0;
     RegExObjStop:=0;
     linenum:=1; //sutuna göre arama yapmak için aranacak satýr sýfýrlandý
     startstoppos.x:=0;
     startstoppos.y:=0;
     startstopposb.x:=0;
     startstopposb.y:=0;
     Case areainfo of
          1://dosya baþýndan itibaren baþlangýç start1,
             //karakter sayýsý stop1
          begin
               RegExObjStart:=start1;
               RegExObjStop:=stop1;
          end;
          2://2:Satýr numarasý olarak start1 ve stop 1
          begin
               startstoppos:=GetLinePos(s,start1,stop1);
               RegExObjStart:=startstoppos.X;
               RegExObjStop:=startstoppos.Y;
          end;
          4,7://satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
          begin
               linenum:=start1;
          end;
     end;
     j:=0;
     fnextsearch:=true;
     if sr.L>0 then
     while RegExObj.InputString{sv}<>'' do
     Begin
          if (areainfo=3) or (areainfo=4) then
          begin
               if fnextsearch then
               begin
                    fnextsearch:=false;
                    j:=0;
                    case areainfo of
                         3://sutun olarak start1,uzunluk stop1;
                         begin
                              startstoppos:=GetNextLinePos(RegExObj.InputString,startstoppos.y);
                              if (startstoppos.x=0) then break; //aramayý bitir
                              inc(linenum);
                              if startstoppos.y-startstoppos.x<1 then
                              begin
                                   if linenum>stop1 then break; //aramayý bitir
                                   fnextsearch:=True;
                                   continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                              end;
                              RegExObjStart:=startstoppos.X;
                              RegExObjStop:=startstoppos.Y;
                         end;

                         4://satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý
                         //start2,karakter sayýsý stop2;
                         begin
                              if linenum=start1 then
                              startstoppos:=GetLinePos(RegExObj.InputString,linenum,linenum)
                              else
                              startstoppos:=GetNextLinePos(RegExObj.InputString,startstoppos.y);
                              if (startstoppos.x=0) then break; //aramayý bitir
                              inc(linenum);
                              if startstoppos.y-startstoppos.x<start2 then
                              begin
                                   if linenum>stop1 then break; //aramayý bitir
                                   fnextsearch:=True;
                                   continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                              end;
                              if (startstoppos.y-startstoppos.x)>start2+stop2 then
                                 startstoppos.y:=startstoppos.x+start2+stop2;
                              startstoppos.x:=startstoppos.x+start2-1;
                              RegExObjStart:=startstoppos.X;
                              RegExObjStop:=startstoppos.Y;
                         end;
                         5://csv ile ayrýlmýþ dosyada start1 kolonunda ara
                         begin
                              startstoppos:=GetNextLinePos(RegExObj.InputString,startstoppos.y);
                              if (startstoppos.x=0) then break; //aramayý bitir
                              inc(linenum);
                              startstopposb:=GetxsvPosB_MR(RegExObj.InputString,csvchar[1],Start1,startstoppos.x,startstoppos.y);
                              if startstopposb.y-startstopposb.x<1 then
                              begin
                                   fnextsearch:=True;
                                   continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                              end;
                              RegExObjStart:=startstopposb.X;
                              RegExObjStop:=startstopposb.Y;
                         end;
                         6://csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
                         begin
                              if startstopposb.x=0 then
                              begin
                                   startstoppos:=GetNextLinePos(RegExObj.InputString,startstoppos.y);
                                   if (startstoppos.x=0) then break; //aramayý bitir
                                   inc(linenum);
                                   currentcol:=Start1;
                              end;
                              if currentcol>Stop1 then
                              begin
                                   startstopposb.x:=0;
                                   startstopposb.y:=0;
                                   fnextsearch:=True;
                                   continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                              end;
                              startstopposb:=GetxsvPosB_MR(RegExObj.InputString,csvchar[1],currentcol,startstoppos.x,startstoppos.y);
                              currentcol:=currentcol+1;
                              if startstopposb.y-startstopposb.x<1 then
                              begin
                                   fnextsearch:=True;
                                   continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                              end;
                              RegExObjStart:=startstopposb.X;
                              RegExObjStop:=startstopposb.Y;
                         end;
                         7://csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
                         begin
                              if startstopposb.x=0 then
                              begin
                                   if linenum=start1 then
                                   startstoppos:=GetLinePos(RegExObj.InputString,linenum,linenum)
                                   else
                                   startstoppos:=GetNextLinePos(RegExObj.InputString,startstoppos.y);
                                   if (startstoppos.x=0) then break; //aramayý bitir
                                   inc(linenum);
                                   currentcol:=Start2;
                              end;
                              if currentcol>Stop2 then
                              begin
                                   startstopposb.x:=0;
                                   startstopposb.y:=0;
                                   if linenum>stop1 then break; //aramayý bitir
                                   fnextsearch:=True;
                                   continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                              end;
                              startstopposb:=GetxsvPosB_MR(RegExObj.InputString,csvchar[1],currentcol,startstoppos.x,startstoppos.y);
                              currentcol:=currentcol+1;
                              if startstopposb.y-startstopposb.x<1 then
                              begin
                                   fnextsearch:=True;
                                   continue; //bir sonraki satýrda arama yapmak üzere döngü baþýna dön
                              end;
                              RegExObjStart:=startstopposb.X;
                              RegExObjStop:=startstopposb.Y;

                         end;
                    end;
               end;

          end;
          if j=0 then
          Begin
               if not RegExObj.ExecPos(RegExObjStart+1) then
               begin
                    if areainfo<=2 then break
                    else
                    begin
                         fnextsearch:=True;
                         continue; //bir sonraki pozisyonda arama yapmak üzere döngü baþýna dön
                    end;
               end;
          end else
          Begin
               if not RegExObj.ExecPos(RegExObjStart+1) then
               begin
                    if areainfo<=2 then break
                    else
                    begin
                         fnextsearch:=True;
                         continue; //bir sonraki pozisyonda arama yapmak üzere döngü baþýna dön
                    end;
               end;
          end;


          j:=RegExObj.MatchPos[0];
          sr.l:=RegExObj.MatchLen[0];
          if j>0 then
          Begin
               if WordsOnlySwc then
               Begin
                    chstr:='';
                    if j>1 then chstr:=copy(RegExObj.InputString,j-1,1);
                    chstr:=chstr+copy(RegExObj.InputString,j+sr.L-1,1);

                    chstr:=TextFilter(appdefaultsrec.WordsOnlyChars,chstr);
                    if chstr<>'' then
                    Begin
                         RegExObjStart:=j+1;
                         Continue;
                    end;
               end;

          End;
          ASCRegExKeepCase:=KeepCaseSwc;
          if Replace Then
          Begin
               s:=RegExObj.InputString;
               ASCRegExSubMatch:=submatch;
               OnRepStr:=Copy(s,j,sr.L);
               ASCRegExOnReplace(nil,OnRepStr);
               Delete(s,j,Sr.L);
               Insert(OnRepStr,s,j);
               RegExObj.InputString:=s;
          End else
          ASCRegExSubMatch:='';
          j:=RegExObj.MatchPos[0];
          sr.p:=j;
          sr.l:=RegExObj.MatchLen[0];
          if j>0 then
          Begin
               write(srclf,sr);
               Result:=Result+1;
               if StopAfterMatchSwc then break;
          end else
          begin
               if areainfo<=2 then break
               else
               begin
                    fnextsearch:=True;
                    continue; //bir sonraki pozisyonda arama yapmak üzere döngü baþýna dön
               end;
          end;
     end;
     closeFile(srclf);
     if Replace Then s:=RegExObj.InputString;
end;

procedure TRepFrmF.RemoveBtnClick(Sender: TObject);
Var
   fn,srfn:ASCMRstring;
   p:PSrcFileRec;
   fnc,j:integer;
   n:TTreenode;
   pnl:^TCollapsePanel;
   fnd:Boolean;
   procedure RemoveItm;
   var
      i:integer;
   begin
     inc(fnc);
     if fnc=4 then
     fn:=fn+#13#10+'...'#13#10;
     if fnc<5 then
     begin
          fn:=fn+#13#10;
          fn:=fn+p^.OrjFileName;
     end;
     p^.Removed:=True;
     fnd:=True;
     DirListTV1.Items.Delete(n);
     if Assigned(FMatchesF) then
     with (FMatchesF as TMatchesF) do
     begin
          for i := 0 to MatchesPanels.Count - 1 do
          begin
               pnl:=MatchesPanels.Items[i];
               if pnl^.HeaderCaption=p^.OrjFileName then
               begin
                    pnl^.Free;
                    pnl^:=Nil;
                    dispose(pnl);
                    MatchesPanels.Delete(i);
                    break;
               end;
          end;
     end;
   end;
begin
     fn:='';
     fnc:=0;
     fnd:=false;

     if not Assigned(DirListTV1.Selected) Then exit;
     if DirListTV1.SelectionCount>0 then
     begin
          for j := DirListTV1.SelectionCount - 1 downto 0 do
          begin

               p:=DirListTV1.Selections[j].Data;
               if p=nil then Continue;
               n:=DirListTV1.Selections[j];
               RemoveItm;
          end;
     end else
     begin
          if DirListTV1.Selected.Data=nil then exit;
          p:=DirListTV1.Selected.Data;
          if p=nil then exit;
          n:=DirListTV1.Selected;
          RemoveItm;
     end;

     if fnd then
     begin
          ShowRemovedAct.Enabled:=True;
          ShowMessage(ReplaceText(SelFileisRemovedFromList,'$file',fn));
     end;
end;

procedure TRepFrmF.RemovedsBtnClick(Sender: TObject);
Var
   j,searchfilecount:integer;
   p:PSrcFileRec;
   fnd:boolean;
begin
     RecycleBinF:=TRecycleBinF.Create(nil);
     RecycleBinF.RepFLink:=Self;
     RecycleBinF.prerepareremoveds;
     RecycleBinF.ShowModal;
     fnd:=RecycleBinF.Sonuc=1;
     RecycleBinF.Free;
     RecycleBinF:=Nil;
     if fnd then
     Begin
          searchfilecount:=0;
          for j := 0 to srcfilereclist.Count - 1 do
          begin
               p:=srcfilereclist.Items[j];
               if p^.Removed then Continue;
               inc(searchfilecount);
          end;

          ShowInfo(msgPreFoundFileList);
          preparefilelist;
          if Assigned(FMatchesF) then (FMatchesF as TMatchesF).preparematchlist;
          ShowInfo(msgSearchComplete);
     end;


end;

procedure TRepFrmF.RemoveFromRepList(i: integer);
Var
   p:PSrcFileSelRec;
begin
     if (SrcFileSelReclist.Count<=i) or (i<0) then exit;
     if SrcFileSelReclist.Count=1 Then
     Begin
          DropFileSelData;
          ClearGrid(TNTSelList1);
          TNTSelList1.RowCount:=2;
          TNTSelList1.FixedRows:=1;
     end else
     Begin
          p:=SrcFileSelReclist.Items[i];
          Dispose(p);
          SrcFileSelReclist.Delete(i);
          RemoveGridRows(TNTSelList1,i+1,i+1);
     End;
     SelListPaint;
     FileSaveRequered:=True;
end;

procedure TRepFrmF.RemoveGridRows(FGrd: TASCStringGrid;rFrom,rTo:integer);
Var
   j,k,a,c:integer;
   p:PWordObj;
begin
     if rTo<rFrom then exit;
     if rFrom<FGrd.RowCount-1 then
     Begin
          a:=rTo-rFrom;
          c:=FGrd.ColCount-1;
          For j:=rFrom to FGrd.RowCount-2 do
          Begin
               for k:=0 to c do
               Begin
                    FGrd.Cells[k,j]:=FGrd.Cells[k,j+a+1];
               end;
          end;
          FGrd.RowCount:=FGrd.RowCount-a-1;
     end else
     Begin
          if (rFrom>1) then
          begin
               FGrd.RowCount:=rFrom;
          end else
          begin
               FGrd.RowCount:=2;
               c:=FGrd.ColCount-1;
               for k:=0 to c do
               Begin
                    FGrd.Cells[k,1]:='';
               end;
          end;
     end;
     if FGrd.FixedRows<1 then FGrd.FixedRows:=1;
end;
procedure TRepFrmF.SearchScanningNotify(Sender: TObject);
begin
     PrcViewF.vpScannedFC:=DblToText(FileScannedCount,asfF);
     PrcViewF.vpMatchedFC:=DblToText(RMatchedFileCounter,asfF);  //MFileSearchObj.MatchedFileCounter
     PrcViewF.vpScanFolder:=Mince(MFileSearchObj.ScannedPath,PrcViewF.CFileNameSize);
end;

{$IF (DemoVersiyon=0)}
function TRepFrmF.ReplaceItem(p:PSrcFileRec;TmpRepOpr:boolean):integer;
Var
   sfpth,s,srcFile,fn,destfile,destdir:ASCMRString;
   f{searchtext},smatch{submatchtxt},r{newtext}:ASCMRString;
   ferr,caseswc,KeepCase,RegExSwc,WordsOnlySwc,StopAfterMatchOpt:Boolean;
   b,j,k,l,fndinfile,fnd:Integer;
   mrfiledata:TASCMRStringList;
   pw,pWObj,pWObjB:PWordObj;
   areainfo,start1,start2,stop1,stop2:integer;
   csvchar:ASCMRString;
   Err,GroupNumber:integer;

   ItemsSwitchs:Array of boolean;   //bu dizinin elemanlarý iþlem yapýlmýþ elemanlarýn bilinmesini saðlayacak
   grno,grcount:integer;
   Groups:Array of TMRWordGroup;
   reqj,reqk,Gr_j: Integer;
   NotSearchOnly:Boolean;

   vTargetText,vSearchText,vSubMatchText,vReplaceText:ASCMRString;




   procedure ApplyStandartVariable;
   var
       svfname,svfnnoex,svfex,svfdir,
       svfmyear,svfmmonth,svfmday
       :ASCMRString;
       svCuryear,svCurmonth,svCurday:Word;
       svfmdate:TDateTime;
       svfmyear2,svfmmonth2,svfmday2:word;
       svfsize:int64;
   begin
               ////Standart deðiþkenler dikkate alýnýyor
               if Pos(svarPatern,vTargetText)>0 then
               Begin
                    ExtractFileItems(srcfile,svfname,svfnnoex,svfex,svfdir);
                    svfsize:=GetFileSize(srcfile);
                    if not DSiGetModifyDate(srcfile,svfmdate) then
                       svfmdate:=0;
                    DecodeDate(svfmdate,svfmyear2,svfmmonth2,svfmday2);
                    svfmyear:=DblToText(svfmyear2,'NNNN');
                    svfmmonth:=DblToText(svfmmonth2,'NN');
                    svfmday:=DblToText(svfmday2,'NN');
                    ReplaceTextP_MR(vTargetText,svarPFN,srcfile);
                    ReplaceTextP_MR(vTargetText,svarFileNameWithExt,svfname);
                    ReplaceTextP_MR(vTargetText,svarFileDir,svfdir);
                    ReplaceTextP_MR(vTargetText,svarFileNameNoExt,svfnnoex);
                    ReplaceTextP_MR(vTargetText,svarFEX,svfex);
                    ReplaceTextP_MR(vTargetText,svarFileSIZE,inttostr(svfsize));
                    ReplaceTextP_MR(vTargetText,svarFMDATE,DateToStr(svfmdate));
                    ReplaceTextP_MR(vTargetText,svarFMYEAR,svfmyear);
                    ReplaceTextP_MR(vTargetText,svarFMMONTH,svfmmonth);
                    ReplaceTextP_MR(vTargetText,svarFMDAY,svfmday);
                    ReplaceTextP_MR(vTargetText,svarCurDATE,DateToStr(SearchStartTime));
                    DecodeDate(SearchStartTime,svCurYear,svCurMonth,svCurDay);
                    ReplaceTextP_MR(vTargetText,svarCurYEAR,inttostr(svCuryear));
                    ReplaceTextP_MR(vTargetText,svarCurMONTH,SetStrLength(inttostr(svCurmonth),'0',2,0));
                    ReplaceTextP_MR(vTargetText,svarCurDAY,SetStrLength(inttostr(svCurDay),'0',2,0));
                    ReplaceTextP_MR(vTargetText,svarCurTime,TimeToStr(SearchStartTime));
                    {
                    svarPFN='svDFN';//Variable Directory+File Name
                    svarFN='svFN';//File Name
                    svarDN='svDN';//Directory Name
                    svarFNNOEX='svFNNOEX';//File Name ,NoExtension
                    svarFEX='@svFILEEX';//File Extension
                    svarFileSIZE='@svFILESIZE';//File Size
                    svarFMDATE='@svFILEMODIFYDATE';//File Modify Date
                    svarFMYEAR='@svFILEMODIFYYEAR';//File Modify Year;
                    svarFMMONTH='@svFILEMODIFYMONTH';//File Modify Month;
                    svarFMDAY='@svFILEMODIFYDAY';//File Modify Day;

                    }
               end;
               ////////////

   end;


    {$IF (ASCUniCodeUsing=1)}
    function ReadFileData(radfn:TFileName;Var s:ASCMRString):integer;
    var
       ls:TASCMRStringList;
    begin
         ls:=TASCMRStringList.Create;
         ls.LoadFromFile(radfn);
         s:=ls.Text;
         result:=length(s);
         ls.Free;
         ls:=nil;
    end;
    function SaveFileData(radfn:TFileName;Var s:ASCMRString):integer;
    var
       ls:TASCMRStringList;
    begin
         ls:=TASCMRStringList.Create;
         ls.Text:=s;
         ls.SaveToFile(radfn);
         result:=length(s);
         ls.Free;
         ls:=nil;
    end;
    {$ELSE}
    function SaveFileData(radfn:TFileName;Var s:ASCMRString):integer;
    Var
       filev:File;
       d:Array [1..MaxMRChar] of ASCMRChar;
       i,c,r,ts,wc:integer;
       EFM:Byte;
    begin
         Result:=0;
         EFM:=FileMode;
         try
            FileMode:=fmOpenReadWrite;
            AssignFile(filev,radfn);
            {$I-}Rewrite(filev,1);{$I+}
            if IOResult<>0 then
            begin
                 FileMode:=EFM;
                 Result:=-1;
                 exit;
            end;
            ts:=length(s);
            c:=0;
            i:=1;
            while i<=ts do
            begin
                 inc(c);
                 d[c]:=s[i];
                 if (c>=MaxMRChar) or (i=ts) then
                 begin
                      BlockWrite(filev,d,c,wc);
                      if (wc<c) then
                      begin
                           if wc>0 then  //eðer eksik yazýldýysa
                           dec(i,c-wc)
                           else        //eðer hiç yazýlamadýysa
                           begin
                                Result:=-2;
                                break;
                           end;
                      end;
                      c:=0;
                 end;
                 inc(i);
            end;
         except
            Result:=-3;
         end;
         try
            closeFile(filev);
         except
            if Result=0 then
            begin
                 Result:=-4;
            end;
         end;
    end;

    function ReadFileData(radfn:TFileName;Var s:ASCMRString):integer;
    Var
       filev:File;
       d:Array [1..MaxMRChar] of ASCMRChar;
       c,r,ts:integer;
       EFM:Byte;
    begin
         Result:=0;
         s:='';
         EFM:=FileMode;
         try
            FileMode:=fmOpenRead;
            AssignFile(filev,radfn);
            {$I-}Reset(filev,1);{$I+}
            if IOResult<>0 then
            begin
                 err:=-1;
                 FileMode:=EFM;
                 exit;
            end;
            ts:=FileSize(filev);
            while ts>0 do
            begin
                 r:=0;
                 if ts>MaxMRChar then c:=MaxMRChar else c:=ts;
                 blockread(filev,d,c,r);
                 sleep(0);
                 if r>0 then
                 begin
                      dec(ts,r);
                      if Application.Terminated then
                      begin
                           try
                              closeFile(filev);
                           except
                           end;
                           FileMode:=EFM;
                           exit;
                      end;
                      //Thread.Synchronize(ExProc);
                      Application.ProcessMessages;
                 end else
                 begin
                      break;
                 end;
                 s:=s+copy(d,1,r);
            end;
            Result:=Length(s);
         except
            err:=-3;
         end;
         try
            closeFile(filev);
         except
         end;
         FileMode:=EFM;
    end;
    {$IFEND}

   //Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq,
   //Ýçermeyen(Bütün dosyalar için)uMatchReq,Search Only(for replace projects),7:Stop after first matched

   //areainfo:bilgi arama konum seçenekleri 0:normal,1:dosya baþýndan itibaren baþlangýç start1,
   //karakter sayýsý stop1;2:Satýr numarasý olarak start1 ve stop 1;3:sutun olarak start1,uzunluk stop1;
   //4:satýr ve sutun olarak satýr:start1 sutun:start2,bitiþ satýrý start2,karakter sayýsý stop2;
   //5:csv ile ayrýlmýþ dosyada start1 kolonunda ara
   //6:csv ile ayrýlmýþ dosyada start1,kolonundan stop1 kadar kolonda ara
   //7:csv ile ayrýlmýþ dosyada start1,stop1 satýrlarýnda ,start2 kolonundan stop2 kadar kolonda ara
   //,start1,start2,stop1,stop2
begin
     Result:=-1;
     pWObj:=nil;
     if p=nil then exit;

     if ((FormStyleSwc=1) or (FormStyleSwc=3)) then exit;
     if p^.Removed then exit;
     if p^.OrjFileName<>p^.ProcessFile then
     begin
          Result:=-2;
          exit; ///word ve excel dosyalarýnda iþlem yapma

     end;
     mrfiledata:=TASCMRStringList.Create;

     srcfile:=p^.OrjFileName;
     Destfile:=p^.Destination+p^.shortname;
     destdir:=p^.Destination;
     if p^.Removed or          //eðer listeden çýkartýlmýþsa iþlem yapmasýn
     (p^.OrjFileName<>p^.ProcessFile)  //eðer ole dosyasý ise iþlem yapma
     then exit;

     fndinfile:=0; //bu dosyada henüz kelime bulunmadý
     ferr:=False;

     if p^.FileNameOperation then
     begin
          mrfiledata.Text:=extractfilename(srcfile);
          s:=extractfilename(srcfile);
     end
     else
     begin
          ReadFileData(srcfile,s);
          if err<0 then ferr:=true;

          {
          Try
             filedata.LoadFromFile(srcfile);
          except
             TNTReportRE.Lines.Add('Can not reading file "'+srcfile+'".');
             ferr:=True;
          end;
          s:=filedata.Text;
          }
     end;

     mrfiledata.Clear;

     if ferr Then exit;


     ////gruplama iþlemi
     grno:=-1;
     grcount:=0;
     SetLength(Groups,0);
     SetLength(ItemsSwitchs,WordsList.Count);
     For k:=0 to WordsList.Count-1 do
     ItemsSwitchs[k]:=False;


     For k:=1 to WordsList.Count do
     Begin
          if ItemsSwitchs[k-1] then Continue; //iþlenmiþ elemanlarý geç
          pWObj:=WordsList.Items[k-1];
          grcount:=grcount+1;
          SetLength(Groups,grcount);
          grno:=pWObj^.GroupNumber;
          Groups[grcount-1].GrpNo:=grno;
          if WordsList.Count>k then
          for j := k+1 to WordsList.Count do
          begin
               pWObjB:=WordsList.Items[j-1];
               if pWObjB^.GroupNumber=grno then
               ItemsSwitchs[j-1]:=True;
          end;
     end;
     ///////end gruplama iþlemleri
     ///Bulunan gruplar icinde dongu kuruluyor
     if GrCount>0 then
     Begin
          For k:=0 to WordsList.Count-1 do
          ItemsSwitchs[k]:=False; //Once hangi elemanlarýn iþlenmiþ olduðunu
          //7tutacak dizi sýfýrlanýyor


          for Gr_j := 0 to GrCount - 1 do
          Begin
               Groups[Gr_j].GrReqDevam:=True;

                   Groups[Gr_j].Gr_StartPos:=-1;
                   Groups[Gr_j].Gr_StopPos:=-1;
                   Groups[Gr_j].GrStartStopStatus:=-1; //bilinmiyor durumuna geldi
                   For l:=1 to WordsList.Count do
                   Begin
                        if ItemsSwitchs[l-1] then Continue; //iþlenmiþ elemaný geç

                        pWObj:=WordsList.Items[l-1];
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
                         For k:=1 to WordsList.Count do
                         Begin
                              if ItemsSwitchs[k-1] then Continue; //iþlenmiþ elemaný geç

                              pw:=WordsList.Items[k-1];
                              if pw^.GroupNumber<>Groups[Gr_j].GrpNo then Continue; //Farklý grubun elemanlarýna bakma
                              if ((reqk=1) and (not pw^.SearchStarter)) then Continue;
                              if ((reqk=2) and (not pw^.SearchStopper)) then Continue;


                              ItemsSwitchs[k-1]:=True;//Bu noktadan sonra arama yapýlacaðý için
                              ///bu kelime iþaretlensin ki bir daha arama yapmasýn

                                  //dosyada ilgili kelimenin bulunmamasý þartý aranýyorsa,onunla ilgili kayýt tutmasýn
                                     if pw^.uMatchReq then
                                        sfpth:=''
                                     else
                                        sfpth:=TempDir+'sf'+inttostr(repformid)+'_'+DblToText(p^.fileindex,'NNNNNN')+
                                        DblToText(k,'NNNNN')+'.tmp';

                                  if (pw^.SearchTxt='') Then
                                  begin
                                       if FileExists(sfpth) then SysUtils.DeleteFile(sfpth);
                                       continue;
                                  end;

                              f:=pw^.SearchTxt;
                              if (FormStyleSwc=2) or (FormStyleSwc=4) then
                              begin
                                   smatch:=pw^.SubMatchTxt;
                                   r:=pw^.ReplaceTxt;
                              end else
                              begin
                                   smatch:='';
                                   r:='';
                              end;

                              caseswc:=pw^.CaseSwc;
                              KeepCase:=pw^.KeepCase;
                              RegExswc:=pw^.RegEx;
                              WordsOnlySwc:=pw^.WordsOnly;
                              StopAfterMatchOpt:=pw^.StopAfterFMatchThisFile;
                              areainfo:=pw^.areainfo;
                              start1:=pw^.start1;
                              start2:=pw^.start2;
                              stop1:=pw^.stop1;
                              stop2:=pw^.stop2;
                              csvchar:=pw^.csvchar;
                              GroupNumber:=pw^.GroupNumber;
                              if csvchar='' then csvchar:=';';
                              NotSearchOnly:=not pw^.SearchOnly;

                              vSearchText:=f;
                              vSubMatchText:=smatch;
                              vReplaceText:=r;

                              vTargetText:=vSearchText;
                              ApplyStandartVariable;
                              vSearchText:=vTargetText;
                              vTargetText:=vSubMatchText;
                              ApplyStandartVariable;
                              vSubMatchText:=vTargetText;
                              vTargetText:=vReplaceText;
                              ApplyStandartVariable;
                              vReplaceText:=vTargetText;


                              fndinfile:=fndinfile+ASCSearcText(s,vSearchText,vSubMatchText,
                              vReplaceText,sfpth,caseswc,KeepCase,
                              pw^.WordsOnly,pw^.StopAfterFMatchThisFile,
                              NotSearchOnly{Sadece Search Only olanlara replace yapýlmaz},
                              areainfo,start1,start2,stop1,stop2,csvchar,RegExSwc,
                              pw^.SearchStarter,pw^.SearchStopper,Groups[Gr_j].Gr_StartPos,Groups[Gr_j].Gr_StopPos);
                              if fndinfile<=0 then  //kelime bulunamadýysa
                              Begin
                                 if FileExists(sfpth) then SysUtils.DeleteFile(sfpth);
                                 if pw^.MatchReq then Groups[Gr_j].GrReqDevam:=False; ///eðer Arama Sonucu kelimenin
                                   ///  bulunmasý gerekliyse bu grupta aramayý durdur
                              end else      //kelime bulunduysa
                              begin
                                   {
                                   if pw^.StopAfterFMatchAll then StopAfterFMatchAllFlag:=true;
                                   MatchInFileCount:=MatchInFileCount+fwc;
                                   }
                                   if pw^.uMatchReq then Groups[Gr_j].GrReqDevam:=False; ///eðer Arama Sonucu kelimenin
                                   ///  bulunmamasý gerekliyse bu grupta aramayý durdur

                              end;
                              if not Groups[Gr_j].GrReqDevam then
                                 Break;

                         end;  //End for k

                    end; //End search starter and search stooper kontrol

                    For k:=1 to WordsList.Count do
                    Begin
                         if ItemsSwitchs[k-1] then Continue; //iþlenmiþ elemaný geç

                         pw:=WordsList.Items[k-1];
                         if pw^.GroupNumber<>Groups[Gr_j].GrpNo then Continue; //Farklý grubun elemanlarýna bakma

                         if (reqj=0) and (not (pw^.MatchReq or pw^.uMatchReq)) then
                            Continue; //eðer reqj=0 ise sadece gerekliliði olanlara bakýlacak

                         ItemsSwitchs[k-1]:=True;//Bu noktadan sonra arama yapýlacaðý için bu kelime iþaretlensin ki bir daha arama yapmasýn
                         pw:=WordsList.Items[k-1];
                         f:=pw^.SearchTxt;
                         if (FormStyleSwc=2) or (FormStyleSwc=4) then
                         begin
                              smatch:=pw^.SubMatchTxt;
                              r:=pw^.ReplaceTxt;
                         end else
                         begin
                              smatch:='';
                              r:='';
                         end;
                         sfpth:=TempDir+'sf'+inttostr(repformid)+'_'+DblToText(p^.fileindex,'NNNNNN')+
                         DblToText(k,'NNNNN')+'.tmp';


                         if (f='') Then
                         Begin
                              if FileExists(sfpth) then DeleteFile(sfpth);
                              continue;
                         end;
                         caseswc:=pw^.CaseSwc;
                         KeepCase:=pw^.KeepCase;
                         RegExswc:=pw^.RegEx;
                         WordsOnlySwc:=pw^.WordsOnly;
                         StopAfterMatchOpt:=pw^.StopAfterFMatchThisFile;
                         areainfo:=pw^.areainfo;
                         start1:=pw^.start1;
                         start2:=pw^.start2;
                         stop1:=pw^.stop1;
                         stop2:=pw^.stop2;
                         csvchar:=pw^.csvchar;
                         GroupNumber:=pw^.GroupNumber;
                         if csvchar='' then csvchar:=';';
                         NotSearchOnly:=not pw^.SearchOnly;

                         vSearchText:=f;
                         vSubMatchText:=smatch;
                         vReplaceText:=r;

                         vTargetText:=vSearchText;
                         ApplyStandartVariable;
                         vSearchText:=vTargetText;
                         vTargetText:=vSubMatchText;
                         ApplyStandartVariable;
                         vSubMatchText:=vTargetText;
                         vTargetText:=vReplaceText;
                         ApplyStandartVariable;
                         vReplaceText:=vTargetText;

                         fnd:=ASCSearcText(s,vSearchText,vSubMatchText,vReplaceText,sfpth,caseswc,KeepCase,
                         pw^.WordsOnly,pw^.StopAfterFMatchThisFile,
                         NotSearchOnly{Sadece Search Only olanlara replace yapýlmaz},
                         areainfo,start1,start2,stop1,stop2,csvchar,RegExSwc,
                         pw^.SearchStarter,pw^.SearchStopper,Groups[Gr_j].Gr_StartPos,Groups[Gr_j].Gr_StopPos);

                         if fnd<=0 then  //kelime bulunamadýysa
                         Begin
                            if FileExists(sfpth) then SysUtils.DeleteFile(sfpth);
                            if pw^.MatchReq then Groups[Gr_j].GrReqDevam:=False; ///eðer Arama Sonucu kelimenin
                              ///  bulunmasý gerekliyse bu grupta aramayý durdur
                         end else      //kelime bulunduysa
                         begin
                              {
                              if pw^.StopAfterFMatchAll then StopAfterFMatchAllFlag:=true;
                              MatchInFileCount:=MatchInFileCount+fwc;
                              }
                              if pw^.uMatchReq then
                              Groups[Gr_j].GrReqDevam:=False ///eðer Arama Sonucu kelimenin
                              ///  bulunmamasý gerekliyse bu grupta aramayý durdur
                              else
                              fndinfile:=fndinfile+fnd;
                         end;
                         if not Groups[Gr_j].GrReqDevam then
                            Break;

                    end;  //End for k
                    if not Groups[Gr_j].GrReqDevam then
                       Break;
               end; ///end for reqj

          end; ///end for Gr_j to grcount
     end; //end if GrCount>0

     if TmpRepOpr then
     Begin
          SaveFileData(TempDir+'replaced'+inttostr(repformid)+'.tmp',s);
          Result:=fndinfile;
          exit;
     end;
     if srcfile=Destfile Then
     Begin
          TNTReportRE.Lines.Add(RepLib.ReplaceText(errSrcEqTarget,'$filename',destfile));
     End else
     begin
          Try
             if not DirectoryExists(DestDir) then ForceDirectories(DestDir);
          Except
          End;
          if p^.FileNameOperation then
          begin
               destfile:=trim(s);
               if destfile<>'' then
               destfile:= DestDir+destfile;
               CopyFile(pchar(srcFile),pchar(destfile),false);
          end
          else
          begin

              {$IF (ASCUniCodeUsing=1)}
               Try
                  mrfiledata.Text:=s;
                  mrfiledata.SaveToFile(destfile);
               Except
                  TNTReportRE.Lines.Add(RepLib.ReplaceText(errWriteErrOnFile,'$filename',destfile));
               End;
               {$ELSE}
               if SaveFileData(destfile,s)<0 then
               begin
                    fndinfile:=-1;
                    TNTReportRE.Lines.Add(RepLib.ReplaceText(errWriteErrOnFile,'$filename',destfile));
               end;
               {$IFEND}
          end;
     end;
     mrfiledata.Free;
     mrfiledata:=nil;
     Result:=fndinfile;
end;
////////end replaceitem proc
{$IFEND}



procedure TRepFrmF.SaveAsBtnClick(Sender: TObject);
var
   exf:ASCMRString;
begin
          RepMainF.vAutoClose:=False;
          if RepMainF.SD1.Execute then
          frepfilename:=RepMainF.SD1.FileName;
          if frepfilename='' Then exit;
          exf:=ExtractFileExt(frepfilename);
          if exf='' then
          frepfilename:=ChangeFileExt(frepfilename,'.'+ReplacerExt);
          SaveRepFile;

end;

procedure TRepFrmF.SaveBtnClick(Sender: TObject);
begin
     RepMainF.vAutoClose:=False;
     SaveProjectDialog;
end;

function TRepFrmF.SaveProjectDialog: Boolean;
Var
   exf:ASCMRString;
begin
     Result:=False;
          if frepfilename='' then
          Begin
               if RepMainF.SD1.Execute then
               frepfilename:=RepMainF.SD1.FileName;
               if frepfilename='' Then exit;
          end;
          exf:=ExtractFileExt(frepfilename);
          if exf='' then
          frepfilename:=ChangeFileExt(frepfilename,'.'+ReplacerExt);
          Result:=SaveRepFile;

end;

function TRepFrmF.SaveRepFile:Boolean;
Var
   s:ASCMRString;
   ls:TASCMRStringList;
   j,k,l:integer;
   p:PSrcFileRec;
   notremovedf:boolean;
   pf:PSrcFileSelRec;

   wobj:TWordObj;
   pw:PWordObj;
begin
     Result:=False;
     ls:=TASCMRStringList.Create;
     ls.Add(RDF_FileSign);
     ls.Add(RDF_FileVer);
     ls.Add('Type='+RepFileTypes[FormStyleSwc-1]);
     if (FormStyleSwc=2) or (FormStyleSwc=4) then
     begin
          if FormStyleSwc=2 then
          ls.Add('destination directory='+SingleDestinationE.Text)
          else
          ls.Add('destination directory='+ProjectDestE1.Text);
     end;
     ls.Add('['+RDF_FileList+']');
     for j:=0 to SrcFileSelReclist.Count-1 do
     Begin
          pf:=SrcFileSelReclist.Items[j];
          s:=csvPrepareColumnASCMR(pf^.Src)+';';
          s:=s+csvPrepareColumnASCMR(pf^.Dest)+';';
          s:=s+csvPrepareColumnASCMR(pf^.ifileptr)+';';
          s:=s+csvPrepareColumnASCMR(pf^.exfileptr)+';';
          s:=s+csvPrepareColumnASCMR(pf^.FileOrDir)+';';
          s:=s+csvPrepareColumnASCMR(pf^.subfiles)+';';
          s:=s+inttostr(pf^.srMinFileSize)+';';
          s:=s+inttostr(pf^.srMaxFileSize)+';';
          s:=s+inttostr(pf^.srDateOption)+';';
          s:=s+DblToText(pf^.srMinDate,asfDateTime)+';';
          s:=s+DblToText(pf^.srMaxDate,asfDateTime)+';';
          s:=s+BoolToStrYN(pf^.FileNameOperation)+';';
          ls.Add(s);
     End;
     ls.Add('['+RDF_WordList+']');
     if FormStyleSwc<3 then
     Begin
          ApplySingleWordChanges;
     end;
     for j:=1 to WordsList.Count do
     begin
         pw:=WordsList.Items[j-1];
         if pw^.SearchTxt<>'' Then
         Begin
              s:=csvPrepareColumnASCMR(pw^.SearchTxt)+';';
              if (FormStyleSwc=2) or (FormStyleSwc=4) then
              s:=s+csvPrepareColumnASCMR(pw^.SubMatchTxt)+';'+csvPrepareColumnASCMR(pw^.ReplaceTxt)+';';

              s:=s+BoolToStrYN(pw^.CaseSwc)+';'+BoolToStrYN(pw^.RegEx)+';'+
              BoolToStrYN(pw^.WordsOnly)+';'+BoolToStrYN(pw^.MatchReq)+';'+
              BoolToStrYN(pw^.UMatchReq)+';'+BoolToStrYN(pw^.SearchOnly)+';'+
              BoolToStrYN(pw^.StopAfterFMatchThisFile)+';'+
              BoolToStrYN(pw^.StopAfterFMatchAll)+';'+
              inttostr(pw^.areainfo)+';'+inttostr(pw^.start1)+';'+
              inttostr(pw^.Start2)+';'+inttostr(pw^.Stop1)+';'+
              inttostr(pw^.Stop2)+';'+csvPrepareColumnASCMR(pw^.csvchar)+';'+
              BoolToStrYN(pw^.KeepCase)+';'+inttostr(pw^.GroupNumber)+';'+
              BoolToStrYN(pw^.SearchStarter)+';'+BoolToStrYN(pw^.SearchStopper)+';';
              ls.Add(s);
         end;
     end;
     notremovedf:=True;
     for j := 0 to srcfilereclist.Count - 1 do
     begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then
          Begin
               if notremovedf then
               begin
                    notremovedf:=False;
                    ls.Add('['+RDF_RemovedList+']');
               end;
               ls.Add(p^.OrjFileName);
          End;
     end;

     try
        ls.SaveToFile(frepfilename);
        Result:=True;
     except
        Result:=False;
     end;
     ls.Free;
     ls:=Nil;
     FileSaveRequered:=False;
     Caption:=frepfilename;
end;

procedure TRepFrmF.SearchCompleteEvent(Sender: TObject);
Begin
     //multi blok 7
     MultiExec(7);

     {
     ///multi 16
     PrcViewF.vpScannedFC:=DblToText(FileScannedCount,asfF);
     PrcViewF.vpScanFolder:='';
     MFileSearching:=False;
     /////////

     ///multi 22
     if not MQueueThread.Active then
     Begin
          MQueueThreadExecType:=ext_QueueStopping;
          QueueTimerTimer(nil);
     End;
     ////////
     }
end;

procedure TRepFrmF.SearchFileFound(Sender: TObject; FileName: ASCMRString);
begin
     lastfoundfilename:=filename;
     //multi blok 8
     MultiExec(8);
     {
     //multi 30
     RMatchedFileCounter:=RMatchedFileCounter+1;
     MQueueThread.SearchFileQueue.Add(lastfoundfilename);
     PrcViewF.vpFileQueue:=Inttostr(MQueueThread.SearchFileQueue.Count);
     //multi 40
     if MFileSearchObj.Paused then exit;
     MQueueThread.Active:=True;
     //////////
     }
end;

procedure TRepFrmF.SelList1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
     if ARow>0 then
     case ACol of
          1:
          Begin
               TNTSelList1.Canvas.FillRect(Rect);
               if Assigned(SrcEditBmp) then
               TNTSelList1.Canvas.Draw(Rect.Left+1,Rect.Top+1,SrcEditBmp);
          end;
          2:
          Begin
               TNTSelList1.Canvas.FillRect(Rect);
               if Assigned(SrcDelBmp) then
               TNTSelList1.Canvas.Draw(Rect.Left+1,Rect.Top+1,SrcDelBmp);

          end;
     end;
end;

procedure TRepFrmF.SelList1DropMsg(var Msg: TMessage);
var
  pcFileName: PChar;
  i, iSize, iFileCount: integer;
  sd,s:ASCMRString;
  ls:TStringList;
begin
     ls:=TStringList.Create;
     pcFileName := ''; // to avoid compiler warning message
     iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
     for i := 0 to iFileCount - 1 do
     begin
          iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
          pcFileName := StrAlloc(iSize);
          DragQueryFile(Msg.wParam, i, pcFileName, iSize);
          if (FileExists(pcFileName)) or (DirectoryExists(pcFileName)) then
          Begin
               sd:=pcFileName;
               ls.Add(sd);
          end;
          StrDispose(pcFileName);
     end;
     DragFinish(Msg.wParam);
     if ls.Count>0 Then
        if RepMainF.ImportFiles(ls,FormStyleSwc,ProjectDestE1.Text) Then AddSelectedFilesToSrc;
     ls.Free;
     ls:=nil;
end;

procedure TRepFrmF.SelList1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
   ls:TStringList;
   j:integer;
   s,sd:ASCMRString;
   yapistir:Boolean;
begin
     yapistir:=False;
     Case Key of
          86: //V
          begin
               if Shift=[ssCtrl] then
                 yapistir:=True;
          end;
          45:  //insert
          begin
               if Shift=[ssShift] then
                 yapistir:=True;
          end;
     End;

     {
     if not ClipBoard.HasFormat(CF_TEXT) then
     Exit;
     }
     if Yapistir then

     Begin
               ls:=TStringList.Create;
               GetClipBrdFiles(LS);
               if LS.Count>0 Then
               Begin
                    if RepMainF.ImportFiles(ls,FormStyleSwc,ProjectDestE1.Text) Then AddSelectedFilesToSrc;
               end;
               ls.Free;
               ls:=nil;
     end;

end;

procedure TRepFrmF.SelList1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
   j,k,itmp,col,row:integer;
begin
     if button<>mbLeft then exit;

     TNTSelList1.MouseToCell(x,y,col,row);
     if not ((Col>0) and (col<3) and (Row>0)) then exit;
     TNTSelList1.Col:=col;
     TNTSelList1.Row:=row;
     Case col of
          1:SrcEditBtnClick(nil);
          2:SrcDelBtnClick(nil);
     end;
end;

procedure TRepFrmF.SelList1RowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
     if (SrcFileSelReclist.Count>=FromIndex) and (SrcFileSelReclist.Count>=ToIndex) and
     (SrcFileSelReclist.Count>1) then
     begin
          SrcFileSelReclist.Move(FromIndex-1,ToIndex-1);

     end;
     SelListPaint;
end;

procedure TRepFrmF.SelListPaint;
Var
   j:integer;
begin
     TNTSelList1.Cells[0,0]:='ID';//Row Num.
     //1:Edit
     //2:Delete
     j:=3;
     TNTSelList1.Cells[j,0]:='Source';inc(j);
     TNTSelList1.Cells[j,0]:='Inc.File Ptr';inc(j);
     TNTSelList1.Cells[j,0]:='Exc.File Ptr';inc(j);
     TNTSelList1.Cells[j,0]:='F/D';inc(j);
     TNTSelList1.Cells[j,0]:='Sub Dirs';inc(j);
     if (FormStyleSwc=2) or (FormStyleSwc=4) then
     TNTSelList1.Cells[j,0]:='Destination Dir.';inc(j);

     for j:=1 to TNTSelList1.RowCount-1 do
         TNTSelList1.Cells[0,j]:=inttostr(j);

end;

procedure TRepFrmF.SelListWndProc(var Message: TMessage);
begin
     if Message.Msg = WM_DROPFILES then
        SelList1DropMsg(Message)
     else
     if Message.Msg=WM_PASTE Then
        WMPaste(Message)
     else
        OldSelListWndProc(Message);
end;

procedure TRepFrmF.SelListWndProc2(var Message: TMessage);
begin
     if Message.Msg = WM_DROPFILES then
        SelList1DropMsg(Message)
     else
     if Message.Msg=WM_PASTE Then
        WMPaste(Message)
     else
        OldSelListWndProc2(Message);
end;

procedure TRepFrmF.ShellFileOpen1Click(Sender: TObject);
Var
   p:PSrcFileRec;
   msj,msk,s,f:String;
begin

     if not Assigned(DirListTV1.Selected) Then exit;
     if DirListTV1.Selected.Data=nil then exit;
     p:=DirListTV1.Selected.Data;
     f:=p^.OrjFileName;;
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

end;

procedure TRepFrmF.ShowExtractedLines1Click(Sender: TObject);
var
   df:TDosyaGosterF;
   i:integer;
begin
     df:=TDosyaGosterF.Create(nil);
     df.TNTContentRE:=df.ConvertASCRichEdit(df.ContentRE);
     df.Caption:=msgExtLines;
     df.TNTContentRE.Lines.Clear;
     for i := 0 to ExtLineLst.Count - 1 do
     begin
          try
          df.TNTContentRE.Lines.Add(ExtLineLst.Strings[i]);
          except
          end;
     end;
     df.Show;

end;

procedure TRepFrmF.ShowExtractedWords1Click(Sender: TObject);
var
   df:TDosyaGosterF;
begin
     df:=TDosyaGosterF.Create(nil);
     df.TNTContentRE:=df.ConvertASCRichEdit(df.ContentRE);
     df.Caption:=msgExtWords;
     df.TNTContentRE.Lines.Text:=ExtWordLst.Text;
     df.Show;
end;

procedure TRepFrmF.ShowInfo(msj: ASCMRString);
begin
     sbar1.Panels[0].Text:=msj;
end;

procedure TRepFrmF.ShowMatchesActExecute(Sender: TObject);
begin
     if not Assigned(FMatchesF) then
     Begin
          FMatchesF:=TMatchesF.Create(nil);
          (FMatchesF as TMatchesF).FRepFrm:=Self;
          RefreshMatchesForm:=True;
     End;
     if RefreshMatchesForm then
     with (FMatchesF as TMatchesF) do
     begin
          preparematchpages;
     end;
     FMatchesF.Show;
     (FMatchesF as TMatchesF).PGosterTim.Enabled:=True;
     //(FMatchesF as TMatchesF).preparematchlist;
end;

procedure TRepFrmF.SingleSearchBtnClick(Sender: TObject);
Var
   j,k,searchfilecount:integer;
   p:PSrcFileRec;
   psel:PSrcFileSelRec;
   RmvBtn:Boolean;
   s,s1,s2,s3,s4,smatch:ASCMRstring;
   pWOj:PWordObj;
   RegExSwc:Boolean;
begin
     if FormStyleSwc>2 then
     begin
          if WordsList.Count=0 then
          begin
               MessageDlg(errCantStartBcsWordsReq,mtError,[mbOk],0);
               exit;
          end;
     end else
     begin
          if TNTSingleOldE.Lines.Count=0 then
          begin
               MessageDlg(errCantStartBcsSearchTextReq,mtError,[mbOk],0);
               exit;
          end;
     end;
     searchfilecount:=0;
     NotReadedFileCount:=0;
     RMatchedFileCounter:=0;
     FileScannedCount:=0;
     TNTReportRE.Lines.Clear;
     SearchStartTime:=now;
     MQueueThread.FSearchStartTime:=SearchStartTime;
     RefreshMatchesForm:=True;
     MQueueThread.FQStopAfterFMatchAllFlag:=False;
     MQueueThread.fEnabled:=True;
     ExtWordLst.Clear;
     ExtLineLst.Clear;
     MQueueThread.ExtractedWords:='';
     MQueueThread.ExtractedLines:='';
     TNTReportRE.Lines.Add(ReplaceText(MsgSearchStart,'$Tarih',DateTimeToStr(SearchStartTime)));

     k:=FormStyleSwc;
     if (k<1) or (k>4) then k:=1;

     TNTReportRE.Lines.Add(msgOperationTypes[k-1]);
     TNTReportRE.Lines.Add(msgSrcProps);
     TNTReportRE.Lines.Add(msgSrcPropFileSources);
     for j := 0 to SrcFileSelReclist.Count - 1 do
     Begin
          psel:=SrcFileSelReclist.Items[j];
          {Src,Dest,ifileptr,exfileptr: ASCMRString;
          FileOrDir,subfiles:Char;
          srMinFileSize,srMaxFileSize:int64;
          srDateOption:integer;
          //0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom
          srMinDate,srMaxDate
          FileNameOperation:Boolean
          }
          s:='';
          if psel^.FileOrDir='F' Then
          Begin
               if (k=2) or (k=4) then //replace
               s:=msgSrcPropReplaceFileItm//'File Source $FileSourceNo'#13#10+
               //'Source File="$FileSrc"'#13#10+
               else
               s:=msgSrcPropSearchFileItm;//'File Source $FileSourceNo'#13#10+
               //'Source File="$FileSrc"'
               s:=ReplaceText_MR(s,'$FileSrc',ExtractFilePath(psel^.Src)+psel^.iFilePtr);
               s:=ReplaceText_MR(s,'$DestDir',ExtractFilePath(psel^.Dest));
               s:=ReplaceText_MR(s,'$FileSourceNo',inttostr(j+1));
          End else
          Begin
               if (k=2) or (k=4) then //replace
               s:=msgSrcPropReplaceDirItm
               {'File Source $FileSourceNo'#13#10+
               'Source Directory="$FileSrc"'#13#10+
               'Destination Dir="$DestDir"'#13#10+
               'Inculude FilePattern="$IncFileptr"'#13#10+
               'Exculude File Pattern="$ExcFileptr"'#13#10+
               'Sub Files="$SubFiles"'#13#10+
               'Min.File Size="$MinSize",Max.File Size="$MaxSize"'#13#10+
               File Modify Dates="$Date';}
               else
               s:=msgSrcPropSearchDirItm;{='File Source $FileSourceNo'#13#10+
               'Source Directory="$FileSrc"'#13#10+
               'Inculude FilePattern="$IncFileptr"'#13#10+
               'Exculude File Pattern="$ExcFileptr"'#13#10+
               'Sub Files="$SubFiles"'#13#10+
               'Min.File Size="$MinSize",Max.File Size="$MaxSize"'#13#10+
               'File Modify Dates="$MinDate".."$MaxDate"';
               }
               s:=ReplaceText_MR(s,'$FileSrc',ExtractFilePath(psel^.Src));
               s:=ReplaceText_MR(s,'$DestDir',ExtractFilePath(psel^.Dest));
               s:=ReplaceText_MR(s,'$IncFileptr',psel^.iFilePtr);
               s:=ReplaceText_MR(s,'$ExcFileptr',psel^.ExFilePtr);

               s:=ReplaceText_MR(s,'$SubFiles',psel^.SubFiles);
               if psel^.srMinFileSize<=0 then
               s:=ReplaceText_MR(s,'$MinSize','0')
               else
               s:=ReplaceText_MR(s,'$MinSize',GetSizeDescription(psel^.srMinFileSize));

               if psel^.srMaxFileSize<=0 then
               s:=ReplaceText_MR(s,'$MaxSize',msgUnlimitedSize)
               else
               s:=ReplaceText_MR(s,'$MaxSize',GetSizeDescription(psel^.srMaxFileSize));

               case psel^.srDateOption of
                    //0:Any time,1:Within an hour,
                    1:s1:=msgBirSaatIcinde;
                    2:s1:='Today';
                    3:s1:='Yesterday';
                    4:s1:='This week';
                    5:s1:='This month';
                    6:s1:='This Year';
                    7://Custom
                    Begin
                         s1:=DateTimeToStr(psel^.srMinDate)+'..'+
                         DateTimeToStr(psel^.srMaxDate);
                    End;
                    else
                    s1:='Any Time';
               end;
               s:=ReplaceText_MR(s,'$Date',s1);
               s:=ReplaceText_MR(s,'$FileSourceNo',inttostr(j+1));
          End;
          TNTReportRE.Lines.Add(s);
     End;
     ////raporlama kelimelerle devam edecek

     //////////daha önceki bulunan dosya listesi ile yeni liste karþýlaþtýrýlacak
     //removed listler güncellencek

     //multi blok 9
     MultiExec(9);
     (*
     //multi 5
     RmvBtn:=False;
     oldremoveds.Clear;
     for j := 0 to srcfilereclist.Count - 1 do
     begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then
          Begin
               oldremoveds.Add(p^.FileName);
          End;
     end;

     ///multi 1
     EraseTempFiles; ///geçici dosyalar siliniyor

     //multi 2
     DropFileData;//eski silinen dosyalar okunduktan sonra bütün dosya bilgileri
     /////yeniden oluþturulmak üzere siliniyor

     //multi 6
     Lastmainitm:=nil;
     LastAddedFilePath:='';
     LastAddedIndex:=-1;
     LastAddedTime:=now;
     /////////////

     ///multi 3
     DirList1.Clear;
     DirList1.UpdateColumns;
     ///////////////


     //multi 7
     ShowInfo(msgStartSearch);
     Sleep(50);
     FoundedFCount:=0;
     ScannedFCount:=0;
     MatchesCount:=0;
     PrcViewF.vpFoundedFC:='0';
     PrcViewF.vpScannedFC:='0';
     PrcViewF.vpNotReadedFC:='0';
     PrcViewF.vpFileQueue:='0';
     PrcViewF.vpMatchedFC:='0';
     PrcViewF.vpScanFolder:='';
     PrcViewF.vpScanFile:='';
     ///////////////


     //multi 9
     ApplySingleWordChanges;


     //multi 10
     TNTReportRE.Lines.Add(msgSrcPropTexts);
     RegExSwc:=False;
     for j:=1 to WordsList.Count do
     Begin
               pWOj:=WordsList.Items[j-1];
               k:=1;
               if (FormStyleSwc=2) or (FormStyleSwc=4) then
               Begin
               end else
               Begin
                    pWOj^.SubMatchTxt:='';
                    pWOj^.ReplaceTxt:='';
               End;
               s3:=TNTWordGrid.Cells[k,j];inc(k);//case
               s4:=TNTWordGrid.Cells[k,j];inc(k);//regex
               if (k=2) or (k=4) then //replace
               s:=msgSrcPropReplaceTextItem
               else
               s:=msgSrcPropSearchTextItem;

               s:=ReplaceText_MR(s,'$TextNo',inttostr(j));
               s:=ReplaceText_MR(s,'$SearchText',pWOj^.SearchTxt);
               s:=ReplaceText_MR(s,'$SubMatchText',pWOj^.SubMatchTxt);
               s:=ReplaceText_MR(s,'$ReplaceText',pWOj^.ReplaceTxt);
               s:=ReplaceText_MR(s,'$CaseSens',BoolToStrYN(pWOj^.CaseSwc));
               s:=ReplaceText_MR(s,'$RegExUse',BoolToStrYN(pWOj^.RegEx));
               s:=ReplaceText_MR(s,'$KeepCaseSens',BoolToStrYN(pWOj^.KeepCase));
               TNTReportRE.Lines.Add(s);
               if pWOj^.RegEx Then RegExSwc:=True;
     end;
     if RegExSwc then
     begin
          s:=msgSrcPropRegExInfo;{=#13#10Regular Expressions Properties'#13#10+
          'Greedy="$RegExGreedy",Multi Line="$RegExMultiLine",'+
          'Single Line="$RegExSingleLine",Extended="$RegExExtended",'+
          'Anchored="$RegExAnchored"'}
          if appdefaultsrec.RegExGreedyChk then s1:='Y' Else s1:='N';
          s:=ReplaceText_MR(s,'$RegExGreedy',s1);
          if appdefaultsrec.RegExMultiLineChk then s1:='Y' Else s1:='N';
          s:=ReplaceText_MR(s,'$RegExMultiLine',s1);
          if appdefaultsrec.RegExSingleLineChk then s1:='Y' Else s1:='N';
          s:=ReplaceText_MR(s,'$RegExSingleLine',s1);
          if appdefaultsrec.RegExExtendedChk then s1:='Y' Else s1:='N';
          s:=ReplaceText_MR(s,'$RegExExtended',s1);
          if appdefaultsrec.RegExAnchoredChk then s1:='Y' Else s1:='N';
          s:=ReplaceText_MR(s,'$RegExAnchored',s1);
          TNTReportRE.Lines.Add(s);
     end;
     //////////

     ///multi 8
     MQueueThread.FStyleSwc:=FormStyleSwc;
     MFileSearchObj.Start(SrcFileSelReclist,FormStyleSwc);
     MFileSearching:=True;
     PrcViewF.Show;
     MBar1.Active:=True;
     MBar1.Visible:=True;
     PrcViewF.PlayPauseBtn.Caption:='Pause';
     ShowInfo(msgSearching);
     ////////////
     *)
end;

procedure TRepFrmF.SearchBtnClick(Sender: TObject);
Var
   j,k:integer;
   p:PSrcFileRec;
   RmvBtn:Boolean;
begin
     if FormStyleSwc>2 then
     begin
          if WordsList.Count=0 then
          begin
               MessageDlg(errCantStartBcsWordsReq,mtError,[mbOk],0);
               exit;
          end;
     end else
     begin
          if TNTSingleOldE.Lines.Count=0 then
          begin
               MessageDlg(errCantStartBcsSearchTextReq,mtError,[mbOk],0);
               exit;
          end;
     end;

     //multi blok 10
     MQueueThread.fEnabled:=True;
     MultiExec(10);
     RefreshMatchesForm:=true;

     (*
     ////multi 4
     NotReadedFileCount:=0;
     FileScannedCount:=0;
     RMatchedFileCounter:=0;
     TNTReportRE.Lines.Clear;
     SearchStartTime:=now;
     TNTReportRE.Lines.Add(ReplaceText(MsgSearchStart,'$Tarih',DateTimeToStr(SearchStartTime)));
     ///////////////////////

     //////////daha önceki bulunan dosya listesi ile yeni liste karþýlaþtýrýlacak
     ///removed listler güncellencek

     ///Multi 5
     RmvBtn:=False;
     oldremoveds.Clear;
     for j := 0 to srcfilereclist.Count - 1 do
     begin
          p:=srcfilereclist.Items[j];
          if p^.Removed then
          Begin
               oldremoveds.Add(p^.FileName);
          End;
     end;
     //////////////////

     ///multi 1
     EraseTempFiles; ///geçici dosyalar siliniyor

     //multi 2
     DropFileData;//eski silinen dosyalar okunduktan sonra bütün dosya bilgileri
     /////yeniden oluþturulmak üzere siliniyor

     //multi 6
     Lastmainitm:=nil;
     LastAddedFilePath:='';
     LastAddedIndex:=-1;
     LastAddedTime:=now;
     /////////////

     ///multi 3
     DirList1.Clear;
     DirList1.UpdateColumns;
     ///////////////

     //multi 7
     ShowInfo(msgStartSearch);
     Sleep(50);
     FoundedFCount:=0;
     ScannedFCount:=0;
     MatchesCount:=0;
     PrcViewF.vpFoundedFC:='0';
     PrcViewF.vpScannedFC:='0';
     PrcViewF.vpNotReadedFC:='0';
     PrcViewF.vpFileQueue:='0';
     PrcViewF.vpMatchedFC:='0';
     PrcViewF.vpScanFolder:='';
     PrcViewF.vpScanFile:='';
     ///////////////

     //multi 8
     MFileSearchObj.Start(SrcFileSelReclist,FormStyleSwc);
     MFileSearching:=True;
     PrcViewF.Show;
     with PrcViewF do
     begin
          PlayBtn.Visible:=False;PauseBtn.Visible:=True;
          PlayBtn.Enabled:=True;
          PauseBtn.Enabled:=True;
     end;
     ShowInfo(msgSearching);
     //////////
     *)
end;


procedure TRepFrmF.SingleSelDirBtnClick(Sender: TObject);

Var
   i:integer;
   vSrc,vDest,vifileptr,vexfileptr:ASCMRString;
   vFileOrDir,vsubfiles:Char;
   MinFileSize,MaxFileSize:int64;DateOption:integer;MinDate,MaxDate:Double;
   FFileNameOperation:Boolean;
   p:PSrcFileSelRec;

begin
     if SrcFileSelReclist.Count=0 then
     begin
          if RepMainF.SelectFiles(SingleDestinationE.Text,FormStyleSwc) Then AddSelectedFilesToSrc;
     end
     else
     Begin
          i:=1;
          p:=SrcFileSelReclist.Items[0];
          vSrc:=p^.Src;
          vDest:=p^.Dest;
          vifileptr:=p^.ifileptr;
          vexfileptr:=p^.exfileptr;
          vfileordir:=p^.FileOrDir;
          vsubfiles:=p^.subfiles;
          MinFileSize:=p^.srMinFileSize;
          MaxFileSize:=p^.srMaxFileSize;
          DateOption:=p^.srDateOption;
          MinDate:=p^.srMinDate;
          MaxDate:=p^.srMaxDate;
          FFileNameOperation:=p^.FileNameOperation;
          if RepMainF.EditFileSelect(SingleDestinationE.Text,FormStyleSwc,vSrc,vDest,vifileptr,vexfileptr,vFileOrDir,vsubfiles,
          MinFileSize,MaxFileSize,DateOption,MinDate,MaxDate,FFileNameOperation) then
          Begin
               AddEditRepList(0,vSrc,vDest,vifileptr,vexfileptr,vFileOrDir,vsubfiles,
               MinFileSize,MaxFileSize,DateOption,MinDate,MaxDate,FFileNameOperation);
          end;


     end;

end;

procedure TRepFrmF.SngDataToWordList;
var
   j,k:integer;
begin
          if TNTWordGrid.RowCount<>2 then TNTWordGrid.RowCount:=2;
          j:=1;
          k:=1;
          TNTWordGrid.Cells[k,j]:=TNTSingleOldE.Lines.Text;inc(k);
          if (FormStyleSwc=2) or (FormStyleSwc=4) then
          Begin
               TNTWordGrid.Cells[k,j]:=TNTSubMatchE.Lines.Text;inc(k);
               TNTWordGrid.Cells[k,j]:=TNTSingleNewE.Lines.Text;inc(k);
          end;
          if SingleCaseChk.Checked then TNTWordGrid.Cells[k,j]:='Y' else TNTWordGrid.Cells[k,j]:='N';inc(k);
          if SingleRegExChk.Checked then TNTWordGrid.Cells[k,j]:='Y' else TNTWordGrid.Cells[k,j]:='N';inc(k);

end;

procedure TRepFrmF.SozlukYukle;
begin
     SingleSearchPg.Caption:=msgSingleSearchPg;
     FileSelectionPg.Caption:='   '+msgFileSelectionPg;
     FileSelPgLbl.Caption:=msgFileSelectionPg;
     WordsPg.Caption:=msgWordsPg;
     WordsSayfaLbl.Caption:=msgWordsPg;
     ControlsPg.Caption:=msgControlsPg;
     FileListPg.Caption:=msgFileListPg;

     onmatchedlbl.Caption:=msgonmatchedlbl;
     CheckResultLbl.Caption:=msgCheckResultLbl;
     ControlPgNotLbl.Caption:=msgControlPgNotLbl;

     SingleOnMatching.Items.Clear;
     SingleOnMatching.Items.Add(msgOnMatchingCmb1);
     SingleOnMatching.Items.Add(msgOnMatchingCmb2);
     SingleOnMatching.Items.Add(msgOnMatchingCmb3);
     SingleOnMatching.Items.Add(msgOnMatchingCmb4);

end;

procedure TRepFrmF.WMPaste(var Msg: TMessage);
Var
   ls:TStringList;
   j:integer;
   s,sd,dd:ASCMRString;
begin
     if not assigned(self) then exit;
     {
     if not ClipBoard.HasFormat(CF_TEXT) then
     Exit;
     }
     Case PGCtrl.ActivePageIndex Of
          0,1:
          Begin
               if PGCtrl.ActivePageIndex=1 then
               dd:=ProjectDestE1.Text
               else
               dd:=SingleDestinationE.Text;
               ls:=TStringList.Create;
               GetClipBrdFiles(LS);
               if LS.Count>0 Then
               Begin
                    if RepMainF.ImportFiles(ls,FormStyleSwc,dd) Then
                    AddSelectedFilesToSrc;
               end;
               ls.Free;
               ls:=nil;
          end;
     end;

end;

procedure TRepFrmF.WordListPaint;
Var
   j:integer;
begin
     j:=1;
     case FormStyleSwc of
          1://single search
          begin
               TNTWordGrid.Cells[j,0]:=msgSearchText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgCaseSens;inc(j);
               TNTWordGrid.Cells[j,0]:=msgRegExp;inc(j);
          end;
          2://single Replace
          begin
               TNTWordGrid.Cells[j,0]:=msgSearchText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgSubMatchText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgReplaceText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgCaseSens;inc(j);
               TNTWordGrid.Cells[j,0]:=msgRegExp;inc(j);
          end;
          3://multi search
          begin
               TNTWordGrid.Cells[j,0]:=msgSearchText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgCaseSens;inc(j);
               TNTWordGrid.Cells[j,0]:=msgRegExp;inc(j);
          end;
          0,4://multi Replace
          begin
               TNTWordGrid.Cells[j,0]:=msgSearchText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgSubMatchText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgReplaceText;inc(j);
               TNTWordGrid.Cells[j,0]:=msgCaseSens;inc(j);
               TNTWordGrid.Cells[j,0]:=msgRegExp;inc(j);
          end;
     end;
     for j:=1 to TNTWordGrid.RowCount-1 do
         TNTWordGrid.Cells[0,j]:=inttostr(j);
end;

procedure TRepFrmF.WriteToSelList(idx: integer);
Var
   j:integer;
   p:PSrcFileSelRec;
begin
     if idx<0 then exit;
     if idx+1>TNTSelList1.RowCount-1 then
      TNTSelList1.RowCount:=idx+2;
     //0:RowNo
     //1:Edit
     //2:Delete
     j:=3;
     p:=SrcFileSelReclist.Items[idx];
     TNTSelList1.Cells[j,idx+1]:=p^.Src;inc(j);
     TNTSelList1.Cells[j,idx+1]:=p^.ifileptr;inc(j);
     TNTSelList1.Cells[j,idx+1]:=p^.exfileptr;inc(j);
     TNTSelList1.Cells[j,idx+1]:=p^.FileOrDir;inc(j);
     TNTSelList1.Cells[j,idx+1]:=p^.subfiles;inc(j);
     if (FormStyleSwc=2) or (FormStyleSwc=4) Then
     TNTSelList1.Cells[j,idx+1]:=p^.Dest;inc(j);
     SelListPaint;


     if FormStyleSwc<3 then  //single saerch or singel replace
     Begin
          if RepMainF.SelFileList.Count>0 then
          Begin
               if p^.FileOrDir='F' then
               SingleSourceE.Text:=p^.Src+p^.ifileptr
               else
               SingleSourceE.Text:=p^.src+' +('+p^.ifileptr+') -('+p^.exfileptr+') /Sub Dirs='+p^.subfiles;
               SingleDestinationE.Text:=p^.Dest;
          end;

     end;



end;

procedure TRepFrmF.WrongRowsGridDblClick(Sender: TObject);
Var
   fr:integer;
begin
     if TNTWrongRowsGrid.Row>0 then
     Begin
          if TNTWrongRowsGrid.Col<2 Then
          Begin
               fr:=Texttoint(TNTWrongRowsGrid.Cells[0,TNTWrongRowsGrid.Row]);
               if (fr>=0) and (fr<TNTWordGrid.RowCount) then
               begin
                    TNTWordGrid.Row:=fr+1;
                    PGCtrl.ActivePage:=WordsPg;
                    if TNTWordGrid.CanFocus then
                       TNTWordGrid.SetFocus;
               end;
          End else
          Begin
               fr:=Texttoint(TNTWrongRowsGrid.Cells[2,TNTWrongRowsGrid.Row]);
               if (fr>=0) and (fr<TNTWordGrid.RowCount) then
               Begin
                    TNTWordGrid.Row:=fr+1;
                    PGCtrl.ActivePage:=WordsPg;
                    if TNTWordGrid.CanFocus then
                       TNTWordGrid.SetFocus;
               end;
          End;
     End;

end;

procedure TRepFrmF.WrongRowsGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
Var
   fr:integer;
begin
     if ACol in [0,2] Then
     Begin
          if TNTWrongRowsGrid.Cells[ACol,ARow]='' then Exit;
          
          
          fr:=strtoint(TNTWrongRowsGrid.Cells[ACol,ARow]);
          TNTWordGrid.Row:=fr+1;
     End;
end;

procedure TRepFrmF.SrcAddBtnClick(Sender: TObject);
begin
     if RepMainF.SelectFiles(ProjectDestE1.Text,FormStyleSwc) Then AddSelectedFilesToSrc;
end;

procedure TRepFrmF.SrcDelBtnClick(Sender: TObject);
Var
   j,k,itmp:integer;
   p:PSrcFileSelRec;
begin
     {

     if TNTSelList1.Selection.Bottom-TNTSelList1.Selection.Top>0 Then
     Begin

          if RepMainF.AppDlg(msYNC,FileDeleteRowsQueryStr)=rsYes Then
          Begin
               for j := TNTSelList1.Selection.Bottom-1 downto TNTSelList1.Selection.Top-1 do
                   if j<SrcFileSelReclist.Count then
                      SrcFileSelReclist.Delete(j);
               RemoveGridRows(TNTSelList1,TNTSelList1.Selection.Top,TNTSelList1.Selection.Bottom);

          End;
     end else
     Begin
     }
          if TNTSelList1.Row>0 then
          Begin
               if (SrcFileSelReclist.Count=0) then
               begin
                    ShowMessage(FileSelectEmptyMsgStr);
                    exit;
               end;
               if (TNTSelList1.Row<1) or (SrcFileSelReclist.Count<TNTSelList1.Row) Then
               Begin
                    ShowMessage(msgSelSourceItem);
                    exit;
               end;
               if RepMainF.AppDlg(msYNC,FileDeleteRowQueryStr)=rsYes Then
               Begin
                    RemoveFromRepList(TNTSelList1.Row-1);
                    //RemoveGridRows(TNTSelList1,TNTSelList1.Row,TNTSelList1.Row);
                    //p:=SrcFileSelReclist.Items[TNTSelList1.Row-1];
                    //Dispose(p);
               End;
          end else
          Begin
               ShowMessage(FileSelectARowMsgStr);
               exit;
          end;
     //end;
     //SelListPaint;
end;

procedure TRepFrmF.SrcEditBtnClick(Sender: TObject);
Var
   i:integer;
   vSrc,vDest,vifileptr,vexfileptr:ASCMRString;
   vFileOrDir,vsubfiles:Char;
   MinFileSize,MaxFileSize:int64;DateOption:integer;MinDate,MaxDate:Double;
   FFileNameOperation:Boolean;
   p:PSrcFileSelRec;
begin
     if (SrcFileSelReclist.Count=0) then
     begin
          AddActExecute(nil);
          exit;
     end;
     if (TNTSelList1.Row<1) or (SrcFileSelReclist.Count<TNTSelList1.Row) Then
     Begin
          ShowMessage(msgSelSourceItem);
          exit;
     end;
     i:=1;
     p:=SrcFileSelReclist.Items[TNTSelList1.Row-1];
     vSrc:=p^.Src;
     vDest:=p^.Dest;
     vifileptr:=p^.ifileptr;
     vexfileptr:=p^.exfileptr;
     vfileordir:=p^.FileOrDir;
     vsubfiles:=p^.subfiles;
     MinFileSize:=p^.srMinFileSize;
     MaxFileSize:=p^.srMaxFileSize;
     DateOption:=p^.srDateOption;
     MinDate:=p^.srMinDate;
     MaxDate:=p^.srMaxDate;
     FFileNameOperation:=p^.FileNameOperation;
     if RepMainF.EditFileSelect(ProjectDestE1.Text, FormStyleSwc,vSrc,vDest,vifileptr,vexfileptr,vFileOrDir,vsubfiles,
     MinFileSize,MaxFileSize,DateOption,MinDate,MaxDate,FFileNameOperation) then
     Begin
          AddEditRepList(TNTSelList1.Row-1,vSrc,vDest,vifileptr,vexfileptr,vFileOrDir,vsubfiles,
          MinFileSize,MaxFileSize,DateOption,MinDate,MaxDate,FFileNameOperation);
     end;
end;

procedure TRepFrmF.SrcNext1BtnClick(Sender: TObject);
begin
     if (SrcFileSelReclist.Count<1) then
     begin
          MessageDlg(msgLutfenDosyaKaynaklariniEkleyiniz,mtError,[mbOK],0);
          exit;
     end;
     if PGCtrl.ActivePageIndex<PGCtrl.PageCount-1 then
        PGCtrl.SelectNextPage(True,True);
end;

procedure TRepFrmF.StartSearchCmd(Sender: TObject);
begin
     Case PGCtrl.ActivePageIndex of
          0:SingleSearchBtnClick(Sender);
          else
          SearchBtnClick(Sender);
     End;
end;

procedure TRepFrmF.StartSrv(sender: TObject);
var
   j:integer;
          FileInfo: SHFILEINFO;

          DiskRoot: array [0..20] of Char;
          Volume: array [0..255] of Char;
          sVolume:String;

          MaxFileCLen:dWord;
          FSystemFlag:dWord;
          FSystemName:array [0..255] of Char;
          s:String;
          vSeriNo1:DWORD;
begin
     s:=GetEnvironmentVariable('HOMEDRIVE');
     if s='' then s:=GetEnvironmentVariable('SystemDrive');
     if s='' then s:=GetEnvironmentVariable('windir');
     if s='' then s:='C:';
     if not (s[1] in ['A'..'Z']) then s[1]:='C';
     for j := 0 to 20 do
         DiskRoot[j]:=#0;
     for j := 0 to 255 do
       Volume[j]:=#0;
     DiskRoot[0]:=s[1];
     DiskRoot[1]:=':';
     DiskRoot[2]:='\';
     vSeriNo1:=0;
     try
        GetVolumeInformation(DiskRoot,Volume,255,@vSeriNo1,MaxFileCLen,FSystemFlag,FSystemName,255);
     except
         vSeriNo1:=0;
     end;
     MQueueThread.vSeriNo1:=vSeriNo1;

end;

procedure TRepFrmF.StopSearch(Sender: TObject);
begin
     MQueueThread.FEnabled:=False;
     MQueueThread.Active:=False;
     MFileSearchObj.Stop;
     MQueueThread.SearchFileQueue.Clear;
     MFileSearching:=False;
     MQueueThreadExecType:=ext_QueueStopping;
     MQueueThread.FEnabled:=True;
     QueueTimerTimer(nil);
end;             

procedure TRepFrmF.svpupsecMenuClick(Sender: TObject);
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
                    1:TNTSingleOldE.Lines.Text:=TNTSingleOldE.Lines.Text+s;
                    2:TNTSubMatchE.Lines.Text:=TNTSubMatchE.Lines.Text+s;
                    3:TNTSingleNewE.Lines.Text:=TNTSingleNewE.Lines.Text+s;
               End;

          end;
     end;
end;

procedure TRepFrmF.SysVarL1Click(Sender: TObject);
begin
     SelectedSysVarPUP:=1;
     svpupsecCURCELL.Enabled:=True;
     SysVarPUP.Popup(SysVarL1.ClientOrigin.X,SysVarL1.ClientOrigin.Y+SysVarL1.Height);
end;

procedure TRepFrmF.SysVarL2Click(Sender: TObject);
begin
     SelectedSysVarPUP:=2;
     svpupsecCURCELL.Enabled:=False;
     SysVarPUP.Popup(SysVarL2.ClientOrigin.X,SysVarL2.ClientOrigin.Y+SysVarL2.Height);

end;

procedure TRepFrmF.SysVarL3Click(Sender: TObject);
begin
     SelectedSysVarPUP:=3;
     svpupsecCURCELL.Enabled:=False;
     SysVarPUP.Popup(SysVarL3.ClientOrigin.X,SysVarL3.ClientOrigin.Y+SysVarL3.Height);

end;

procedure TRepFrmF.ThreadStopperTimer(Sender: TObject);
begin
     if not assigned(self) then exit;

     Case ThreadStopper.Tag of
          1:
          begin
               MFileSearchObj.Stop;
               MQueueThread.FEnabled:=False;
               MQueueThread.Active:=False;
               try
                  MQueueThread.Stop();
               except
               end;
               ThreadStopper.Tag:=2;
          end;
          2:
          begin
               if not MQueueThread.Active then
               begin
                    //MQueueThread.Terminate;
                    ThreadStopper.Tag:=3;
                    try
                       TNTSelList1.WindowProc:=OldSelListWndProc;
                    except
                    end;
                    try
                    SingleSourceE.WindowProc:=OldSelListWndProc2;
                    except
                    end;
                    try
                    DragAcceptFiles(TNTSelList1.Handle, False);
                    except
                    end;
                    try
                    DragAcceptFiles(SingleSourceE.Handle, False);
                    except
                    end;


                    if Assigned(DirListTV1) then DirListTV1.Free;
                    DirListTV1:=Nil;
                    if Assigned(DirList1) then DirList1.Free;
                    DirList1:=Nil;
                    
               end;
          end;
          3:
          begin
               ThreadStopper.Tag:=4;
               if assigned(MFileSearchObj) then
               begin
                    MFileSearchObj.Free;
                    MFileSearchObj:=nil;
               end;
               if Assigned(MQueueThread) then
               begin
                    MQueueThread.Free;
                    MQueueThread:=Nil;
               end;

          end;
          4:
          begin
               ThreadStopper.Enabled:=False;

               close;
          end;
     End;
end;

procedure TRepFrmF.ThreadIslemleriTmrTimer(Sender: TObject);
var
   tagj:integer;
   devam:Boolean;
begin
     devam:=false;
     for tagj := 1 to 5 do
     begin
          if ThreadIslemleriTags[tagj]>0 then
          begin
               Case tagj of
                    1:SearchScanningNotify(nil);
                    2:SearchCompleteEvent(nil);
                    3:StartSrv(nil);
               End;
               ThreadIslemleriTags[tagj]:=ThreadIslemleriTags[tagj]-1;
               devam:=true;
          end;
     end;
     if devam then
     ThreadIslemleriTmr.Enabled:=devam;

end;

procedure TRepFrmF.CloseBtnTClick(Sender: TObject);
begin
     Close;
end;
function TRepFrmF.ConvertASCRichEdit(Edt:TRichEdit):TASCRichEdit;
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
     Result.Alignment:=Edt.Alignment;
     Result.Align:=Edt.Align;
     Result.Font.Assign(Edt.Font);
     v:=Edt.Lines.Text;
     Result.ScrollBars:=Edt.ScrollBars;
     Edt.Free;
     Result.Name:=n;
     Result.Lines.Text:=v;
     Result.TabOrder:=TabOrderNo;
end;

function TRepFrmF.ConvertASCMemo(Edt:TMemo):TASCMemo;
Var
   N:ASCMRString;
   v:ASCMRString;
   TabOrderNo:integer;
begin
     Result:=TASCMemo.Create(self);
     n:=Edt.Name;
     TabOrderNo:=Edt.TabOrder;
     Result.Parent:=Edt.Parent;
     Result.Left:=Edt.Left;
     Result.Top:=Edt.Top;
     Result.Width:=Edt.Width;
     Result.Height:=Edt.Height;
     Result.Font.Assign(Edt.Font);
     v:=Edt.Lines.Text;
     Result.ScrollBars:=Edt.ScrollBars;
     Edt.Free;
     Result.Name:=n;
     Result.Lines.Text:=v;
     Result.TabOrder:=TabOrderNo;
end;
function TRepFrmF.ConvertASCStringGrid(Grid:TStringGrid):TASCStringGrid;
Var
   N:ASCMRString;
   v:ASCMRString;
   i,TabOrderNo:integer;
begin
     Result:=TASCStringGrid.Create(self);
     n:=Grid.Name;
     TabOrderNo:=Grid.TabOrder;
     Result.Parent:=Grid.Parent;
     Result.Align:=Grid.Align;
     Result.Left:=Grid.Left;
     Result.Top:=Grid.Top;
     Result.Width:=Grid.Width;
     Result.Height:=Grid.Height;
     Result.Font.Assign(Grid.Font);
     Result.ColCount:=Grid.ColCount;
     Result.RowCount:=Grid.RowCount;
     Result.OnDrawCell:=Grid.OnDrawCell;
     Result.OnKeyDown:=Grid.OnKeyDown;
     Result.OnMouseUp:=Grid.OnMouseUp;
     Result.OnMouseDown:=Grid.OnMouseDown;
     Result.OnRowMoved:=Grid.OnRowMoved;
     Result.OnClick:=Grid.OnClick;
     Result.OnDblClick:=Grid.OnDblClick;
     Result.OnSelectCell:=Grid.OnSelectCell;
     Result.Options:=Grid.Options;
     Result.DefaultRowHeight:=Grid.DefaultRowHeight;
     for i := 0 to Grid.ColCount - 1 do
     begin
          Result.ColWidths[i]:=Grid.ColWidths[i];
     end;
     Grid.Free;
     Result.Name:=n;
     Result.TabOrder:=TabOrderNo;


end;

procedure TRepFrmF.View80ColumnText1Click(Sender: TObject);
begin
     ViewDetailProc(ascVTASC80);
end;

procedure TRepFrmF.ViewDetailBtnClick(Sender: TObject);
Begin
     ViewDetailProc(ascVTNormal);
end;

procedure TRepFrmF.ViewDetailProc(ViewType: integer);
Var
   df:TDetailF;
   p:PSrcFileRec;
begin

     if not Assigned(DirListTV1.Selected) Then exit;
     if DirListTV1.Selected.Data=nil then exit;
     p:=DirListTV1.Selected.Data;


     df:=TDetailF.Create(nil);
     if ViewType=ascVTNormal then
     begin
          df.TNTContentRE:=df.ConvertASCRichEdit(df.ContentRE);
     end;
     df.Caption:='Detail View - '+p^.OrjFileName;
     df.DtlFileName:=p^.OrjFileName;;
     if preparefilecontents(df.fArrASCFilecnt, df.FileDataStr,p,
     df.Wordindexes,ViewType,df.unixrowlist) then
     begin

          if df.prepareviewer(p,df.Wordindexes,ViewType) then
          df.Show
          else
          begin
               df.Free;
               df:=nil;
          end;

     end
     else
     begin
          df.Free;
          df:=nil;
     end;
end;

procedure TRepFrmF.ViewDetPBtnClick(Sender: TObject);
begin
     ViewDetPUP.Popup(ViewDetPBtn.ClientOrigin.X+ViewDetPBtn.Width,ViewDetailBtn.ClientOrigin.Y);
end;

procedure TRepFrmF.ViewDiff80ColumnMIClick(Sender: TObject);
begin
     ViewDiffProc(ascVTASC80);
end;

procedure TRepFrmF.ViewDiffActUpdate(Sender: TObject);
begin
     ViewDiffPAct.Enabled:=ViewDiffAct.Enabled;
end;

procedure TRepFrmF.ViewDiffBtnClick(Sender: TObject);
begin
     ViewDiffProc(ascVTNormal);
end;

procedure TRepFrmF.ViewDiffNormalMIClick(Sender: TObject);
begin
     ViewDiffProc(ascVTNormal);
end;

procedure TRepFrmF.ViewDiffPBtnClick(Sender: TObject);
begin
     ViewDiffPUP.Popup(ViewDiffPBtn.ClientOrigin.X+ViewDiffPBtn.Width,ViewDiffPBtn.ClientOrigin.Y);
end;

procedure TRepFrmF.ViewDiffProc(ViewType: integer);
Var
   srcdata_uni,repdata_uni:TASCMRStringList;
   srcdata_ms,repdata_ms:TMemoryStream;
   srcdata_strA:ASCMRString;
   srcdata_strB:String;
   p:PSrcFileRec;
   findex,rsnc:integer;
   fn:ASCMRString;
   err:integer;
    function ReadFileDataA(radfn:TFileName;Var s:ASCMRString):integer;
    Var
       filev:File;
       d:Array [1..MaxMRChar] of ASCMRChar;
       c,r,ts:integer;
       EFM:Byte;
    begin
         Result:=0;
         s:='';
         EFM:=FileMode;
         try
            FileMode:=fmOpenRead;
            AssignFile(filev,radfn);
            {$I-}Reset(filev,1);{$I+}
            if IOResult<>0 then
            begin
                 err:=-1;
                 FileMode:=EFM;
                 exit;
            end;
            ts:=FileSize(filev);
            while ts>0 do
            begin
                 r:=0;
                 if ts>MaxMRChar then c:=MaxMRChar else c:=ts;
                 blockread(filev,d,c,r);
                 sleep(0);
                 if r>0 then
                 begin
                      dec(ts,r);
                      if Application.Terminated then
                      begin
                           try
                              closeFile(filev);
                           except
                           end;
                           FileMode:=EFM;
                           exit;
                      end;
                      //Thread.Synchronize(ExProc);
                      Application.ProcessMessages;
                 end else
                 begin
                      break;
                 end;
                 s:=s+copy(d,1,r);
            end;
            Result:=Length(s);
         except
            err:=-3;
         end;
         try
            closeFile(filev);
         except
         end;
         FileMode:=EFM;
    end;
    function ReadFileDataB(radfn:TFileName;strm:TMemoryStream):integer;
    Var
       filev:File;
       d:Array [1..MaxMRChar] of Char;
       c,r,ts:integer;
       EFM:Byte;
    begin
         Result:=0;
         strm.Position:=0;
         EFM:=FileMode;
         try
            FileMode:=fmOpenRead;
            AssignFile(filev,radfn);
            {$I-}Reset(filev,1);{$I+}
            if IOResult<>0 then
            begin
                 err:=-1;
                 FileMode:=EFM;
                 exit;
            end;
            ts:=FileSize(filev);
            while ts>0 do
            begin
                 r:=0;
                 if ts>MaxMRChar then c:=MaxMRChar else c:=ts;
                 blockread(filev,d,c,r);
                 strm.Write(d,r);
                 sleep(0);
                 if r>0 then
                 begin
                      dec(ts,r);
                      if Application.Terminated then
                      begin
                           try
                              closeFile(filev);
                           except
                           end;
                           FileMode:=EFM;
                           exit;
                      end;
                      //Thread.Synchronize(ExProc);
                      Application.ProcessMessages;
                 end else
                 begin
                      break;
                 end;
            end;
            Result:=strm.Size;
         except
            err:=-3;
         end;
         try
            closeFile(filev);
         except
         end;
         FileMode:=EFM;
    end;

begin
   {$IF (DemoVersiyon=0)}
     if not Assigned(DirListTV1.Selected) Then exit;
     if DirListTV1.Selected.Data=nil then exit;
     p:=DirListTV1.Selected.Data;

     findex:=p^.FileIndex;

     fn:=p^.ProcessFile;
     repdata_uni:=TASCMRStringList.Create;
     srcdata_uni:=TASCMRStringList.Create;
     rsnc:=ReplaceItem(p,true);
     Case rsnc of
          -1:
          begin
               MessageDlg(msgDiffViewErr1,mtError,[mbOK],0);
               exit;
          end;
          -2:
          begin
               MessageDlg(msgDiffViewErr2,mtError,[mbOK],0);
               exit;
          end;
     End;

    {$IF (ASCUniCodeUsing=1)}
     try
        srcdata_uni.LoadFromFile(fn);
        repdata_uni.LoadFromFile(TempDir+'replaced'+inttostr(repformid)+'.tmp');
     except
        on E: Exception do MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);
     end;
    {$ELSE}
       if ViewType=ascVTNormal then
       begin
            ReadFileDataA(fn,srcdata_strA);
            srcdata_uni.Text:=srcdata_strA;
            srcdata_strA:='';
            ReadFileDataA(TempDir+'replaced'+inttostr(repformid)+'.tmp',srcdata_strA);
            repdata_uni.Text:=srcdata_strA;
            srcdata_strA:='';
       end
       else
       Begin
            srcdata_ms:=TMemoryStream.Create;
            repdata_ms:=TMemoryStream.Create;
            ReadFileDataB(fn,srcdata_ms);
            ReadFileDataB(TempDir+'replaced'+inttostr(repformid)+'.tmp',repdata_ms);
            srcdata_uni.Text:=srcdata_strB;
            srcdata_strB:='';
       End;
    {$IFEND}
    if ViewType=ascVTNormal then
    begin
         ViewDiff(p^.OrjFileName,srcdata_uni,repdata_uni,ViewType);
         repdata_uni.Free;
         repdata_uni:=Nil;
         srcdata_uni.Free;
         srcdata_uni:=Nil;
    end
    else
    begin
         ViewDiffB(p^.OrjFileName,srcdata_ms,repdata_ms,ViewType);
         repdata_uni.Free;
         repdata_uni:=Nil;
         srcdata_uni.Free;
         srcdata_uni:=Nil;
    end;
   {$ELSE}
         MessageDlg(DemoProgramMsj1,mtInformation,[mbOK],0);
   {$IFEND}
end;

procedure TRepFrmF.ViewHex1Click(Sender: TObject);
begin
     ViewDetailProc(ascVTHex);
end;

procedure TRepFrmF.ViewNormal1Click(Sender: TObject);
Begin
     ViewDetailProc(ascVTNormal);
end;

procedure TRepFrmF.ApplySingleWordChanges;
Var
   SearchTxt,SubMatchTxt,ReplaceTxt:ASCMRString;
   CaseSwc,KeepCase,RegEx,WordsOnly,
   MatchReq {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq},
   uMatchReq {Ýçermeyen(Bütün dosyalar için)},
   SearchOnly{(for replace projects)},
   StopAfterFMatchThisFile,StopAfterFMatchAll,
   SearchStarter,SearchStopper:boolean;
   areainfo,start1,start2,stop1,stop2:integer;
   csvchar:ASCMRString;
   GroupNumber:integer;
   p:PWordObj;
begin
     SearchTxt:=TNTSingleOldE.Lines.Text;
     SubMatchTxt:=TNTSubMatchE.Lines.Text;
     ReplaceTxt:=TNTSingleNewE.Lines.Text;
     CaseSwc:=SingleCaseChk.Checked;
     KeepCase:=SingleKeepCase.Checked;
     RegEx:=SingleRegExChk.Checked;
     WordsOnly:=SingleWordsOnlyChk.Checked;
     GroupNumber:=0;
     MatchReq:=False; {Ýçeren (Bütün dosyalar için).Match Require All Files MatchReq}
     uMatchReq:=False; {Ýçermeyen(Bütün dosyalar için)}
     SearchOnly:=False;{(for replace projects)}
     SearchStarter:=False;
     SearchStopper:=False;
     StopAfterFMatchThisFile:=(SingleOnMatching.ItemIndex=1) or (SingleOnMatching.ItemIndex=3);
     StopAfterFMatchAll:=(SingleOnMatching.ItemIndex>=2);
     if WordsList.Count>0 then
     begin
          p:=WordsList.Items[0];
          areainfo:=p^.areainfo;
          start1:=p^.start1;
          start2:=p^.start2;
          stop1:=p^.stop1;
          stop2:=p^.stop2;
          csvchar:=p^.csvchar;
     end else
     begin
          areainfo:=0;
          start1:=0;
          start2:=0;
          stop1:=0;
          stop2:=0;
          csvchar:=';';
     end;
     AddToWordList(SearchTxt,SubMatchTxt,ReplaceTxt,CaseSwc,KeepCase,RegEx,WordsOnly,MatchReq,
     uMatchReq {Ýçermeyen(Bütün dosyalar için)},
     SearchOnly{(for replace projects)},
     StopAfterFMatchThisFile,StopAfterFMatchAll,SearchStarter,SearchStopper,
     areainfo,start1,start2,stop1,stop2,csvchar,GroupNumber);
end;
procedure TRepFrmF.ClearWordList;
var
   j:integer;
   p:PWordObj;
Begin
     if WordsList.Count>0 then
     for j:=WordsList.Count-1 downto 0 do
     begin
          p:=WordsList.Items[j];
          dispose(p);
     end;
     WordsList.Clear;
end;

procedure TRepFrmF.WordGridRepaintRow(i: integer);
var
   p:PWordObj;
   k,l:integer;
begin
     if (i>=0) and(WordsList.Count>i)  then
     Begin
          p:=WordsList.Items[i];
          k:=0;
          l:=i+1;
          TNTWordGrid.Cells[k,l]:=inttostr(l); inc(k);
          TNTWordGrid.Cells[k,l]:=p^.SearchTxt;inc(k);
          if (FormStyleSwc=2) or (FormStyleSwc=4) then
          Begin
               TNTWordGrid.Cells[k,l]:=p^.SubMatchTxt;inc(k);
               TNTWordGrid.Cells[k,l]:=p^.ReplaceTxt;inc(k);
          end;
          TNTWordGrid.Cells[k,l]:=BoolToStrYN(p^.CaseSwc);inc(k);
          TNTWordGrid.Cells[k,l]:=BoolToStrYN(p^.RegEx);inc(k);
     end;

end;

procedure TRepFrmF.SaveReportBtnClick(Sender: TObject);
begin
     if SaveRepSD.Execute then
     begin
          if ExtractFileExt(SaveRepSD.FileName)='' then
          begin
               if SaveRepSD.FilterIndex=1 then
               SaveRepSD.FileName:=SaveRepSD.FileName+'.txt'
               else
               if SaveRepSD.FilterIndex=2 then
               SaveRepSD.FileName:=SaveRepSD.FileName+'.rtf';
          end;
          if Pos('RTF',uppercase(ExtractFileExt(SaveRepSD.FileName)))<1 then
          TNTReportRE.PlainText:=True
          else
          TNTReportRE.PlainText:=False;

          TNTReportRE.Lines.SaveToFile(SaveRepSD.FileName);
     end;

end;

procedure TRepFrmF.PrintBtnClick(Sender: TObject);
var
   j,k,l,m,ml,mt,mb,mr,sth:integer;
   p:^TCollapsePanel;
   Grd:TStringGrid;
   r:TRect;
   St: TGridDrawState;
   ACanvas:TCanvas;
   POpen:Boolean;
   MatchPrvF:TPreviewF;
begin
     MatchPrvF:=TPreviewF.Create(nil);
     MatchPrvF.Show;
     MatchPrvF.NicePreview1.Clear;
     ACanvas:=MatchPrvF.NicePreview1.BeginPage;

     St:=[];
     ml:=MatchPrvF.NicePreview1.MarginLeft;
     mt:=MatchPrvF.NicePreview1.MarginTop;
     mb:=MatchPrvF.NicePreview1.PageHeight - MatchPrvF.NicePreview1.MarginBottom;
     mr:=MatchPrvF.NicePreview1.PageWidth-MatchPrvF.NicePreview1.MarginRight;
     r.Top:=mt;
     r.Left:=ml;
     sth:=ACanvas.TextHeight('A');
     r.Right:=r.Left+mr;

     ////baþlýklar
     for k := 0 to DirList1.HeaderSections.Count-1  do
     begin
          ACanvas.TextOut(r.Left,r.Top,DirList1.HeaderSections.Items[k].Text);
          r.Left:=r.Left+DirList1.HeaderSections.Items[k].Width;
     end;

     //////
     r.Top:=r.Top+sth;
     r.Left:=ml;
     r.Right:=r.Left+mr;

     for j:=0 to DirList1.tv.Items.Count-1 do
     begin

          if r.Top+sth>mb then
          begin
               r.Top:=mt;
               MatchPrvF.NicePreview1.EndPage;
               ACanvas := MatchPrvF.NicePreview1.BeginPage;
               ////baþlýklar
               r.Top:=mt;
               r.Left:=ml;
               sth:=ACanvas.TextHeight('A');
               r.Right:=r.Left+mr;
               for k := 0 to DirList1.HeaderSections.Count-1  do
               begin
                    ACanvas.TextOut(r.Left,r.Top,DirList1.HeaderSections.Items[k].Text);
                    r.Left:=r.Left+DirList1.HeaderSections.Items[k].Width;
               end;
               r.Top:=r.Top+sth;
               r.Left:=ml;
               r.Right:=r.Left+mr;
               //////////////////
          end;
          r.Bottom:=r.Top+sth;
          r.Left:=ml;
          if DirList1.tv.Items[j].Level>0 then
          begin
               for k := 0 to DirList1.HeaderSections.Count-1  do
               begin
                    ACanvas.TextOut(r.Left,r.Top,xsvData(DirList1.tv.Items[j].Text,'|',k+1));
                    r.Left:=r.Left+DirList1.HeaderSections.Items[k].Width;
               end;
          end else
          ACanvas.TextOut(r.Left,r.Top,DirList1.tv.Items[j].Text);
          r.Top:=r.Top+sth;

     end;

     MatchPrvF.NicePreview1.EndPage;
end;

procedure TRepFrmF.BackAckExecute(Sender: TObject);
begin
     if PGCtrl.ActivePageIndex>0 then
     Begin
          PGCtrl.SelectNextPage(false,true);
     End;
end;

procedure TRepFrmF.BitBtn3Click(Sender: TObject);
var
   pWObj:PWordObj;
begin
     ApplySingleWordChanges;
     if WordsList.Count=0 then exit;
     pWObj:=WordsList.Items[0];
     RepMainF.FileFormatSelDialog(pWObj^.areainfo,pWObj^.start1,pWObj^.start2,
     pWObj^.stop1,pWObj^.stop2,pWObj^.csvchar);

end;


procedure TRepFrmF.OnFileScannedEvent(Sender: TObject);
begin
     FileScannedCount:=FileScannedCount+1;
end;

end.
