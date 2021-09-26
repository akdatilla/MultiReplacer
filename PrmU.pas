unit PrmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FileCtrl, ComCtrls, StdCtrls,Registry,RepConstU, ExtCtrls, Buttons, ToolWin,
  ImgList;

type
  TPrmF = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    OnExitAskSave1: TCheckBox;
    CaseSens1: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    RegExUse1: TCheckBox;
    Label4: TLabel;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    WarmBeforeOpenPtr1: TEdit;
    FileModifyR: TRadioGroup;
    FileSizeR: TRadioGroup;
    CustomFileModifyG: TGroupBox;
    FileModifyAfterChk: TCheckBox;
    FileModifyBeforeChk: TCheckBox;
    FileModifyAfterTime: TDateTimePicker;
    FileModifyBeforeTime: TDateTimePicker;
    CustomFileSizeG: TGroupBox;
    CustomFileSizeBiggerChk: TCheckBox;
    CustomFileSizeBiggerE: TEdit;
    CustomFileSizeSmallerChk: TCheckBox;
    CustomFileSizeSmallerE: TEdit;
    TabSheet3: TTabSheet;
    Bevel3: TBevel;
    Bevel4: TBevel;
    ASCLabel1: TLabel;
    ASCLabel3: TLabel;
    DestL1: TLabel;
    Label5: TLabel;
    DirBtn: TBitBtn;
    DirE: TEdit;
    InMaskE: TEdit;
    DestBtn1: TBitBtn;
    DestE1: TEdit;
    ExMaskE: TEdit;
    SubsChk: TCheckBox;
    TabSheet4: TTabSheet;
    Label6: TLabel;
    RegExGreedy1: TCheckBox;
    Label7: TLabel;
    RegExMultiLineChk1: TCheckBox;
    Label8: TLabel;
    RegExSingleLineChk1: TCheckBox;
    Label9: TLabel;
    RegExExtendedChk1: TCheckBox;
    Label10: TLabel;
    RegExAnchoredChk1: TCheckBox;
    Label11: TLabel;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton3: TToolButton;
    SaveBtn: TToolButton;
    ToolButton2: TToolButton;
    CloseBtn: TToolButton;
    ToolButton6: TToolButton;
    FileModifyAfterDate: TDateTimePicker;
    FileModifyBeforeDate: TDateTimePicker;
    Label12: TLabel;
    OleChk: TCheckBox;
    Label13: TLabel;
    PDFCheck: TCheckBox;
    Label14: TLabel;
    MaxFileSizeE: TEdit;
    procedure FileSizeRClick(Sender: TObject);
    procedure FileModifyRClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DirBtnClick(Sender: TObject);
    procedure DestBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SaveSettings;
    procedure ReadSettings;
    function SelectDir(dir:ASCMRString):ASCMRString;
  end;

var
  PrmF: TPrmF;

implementation

{$R *.dfm}

uses RepLib,RepMainU;
{ TPrmF }

procedure TPrmF.CloseBtnClick(Sender: TObject);
begin
     Close;
end;

procedure TPrmF.FileModifyRClick(Sender: TObject);
begin
     CustomFileModifyG.Visible:=FileModifyR.ItemIndex=7;
end;

procedure TPrmF.FileSizeRClick(Sender: TObject);
begin
     CustomFileSizeG.Visible:=FileSizeR.ItemIndex=7;
end;

procedure TPrmF.FormCreate(Sender: TObject);
begin
     ReadSettings;

end;

procedure TPrmF.ReadSettings;
Var
   errswc:Boolean;
   keyname:ASCMRString;
   Reg:TRegistry;
   SaveRec:TAppDefRec;
begin
     with appdefaultsrec do
     begin
          InMaskE.Text:=IncFilePtr;
          ExMaskE.Text:=ExcFilePtr;
          DirE.Text:=SourceDir;
          SubsChk.Checked:=SubDirs;
          DestE1.Text:=DestDir;
          WarmBeforeOpenPtr1.Text:=WarmBeforeOpenPtr;
          OnExitAskSave1.Checked:=OnExitAskSaveChk;
          CaseSens1.Checked:=CaseSensChk;
          RegExUse1.Checked:=RegExUseChk;
          RegExGreedy1.Checked:=RegExGreedyChk;
          RegExMultiLineChk1.Checked:=RegExMultiLineChk;
          RegExSingleLineChk1.Checked:=RegExSingleLineChk;
          RegExExtendedChk1.Checked:=RegExExtendedChk;
          RegExAnchoredChk1.Checked:=RegExAnchoredChk;
          FileModifyR.ItemIndex:=DateOption;
          if Int(MinDate)=0 then
             FileModifyAfterDate.Date:=Date
          else
             FileModifyAfterDate.Date:=Int(MinDate);
          FileModifyAfterChk.Checked:=(Int(MinDate)>0);
          FileModifyBeforeChk.Checked:=(Int(MaxDate)>0);
          FileModifyAfterTime.Time:=Frac(MinDate);
          if Int(MaxDate)=0 then
          FileModifyBeforeDate.Date:=Date
          else
          FileModifyBeforeDate.Date:=Int(MaxDate);
          FileModifyBeforeTime.Time:=Frac(MaxDate);
          if MinFileSize>0 then
          begin
               CustomFileSizeBiggerE.Text:=inttostr(MinFileSize);
               CustomFileSizeBiggerChk.Checked:=True;
          end else
          begin
               CustomFileSizeBiggerE.Text:='0';
               CustomFileSizeBiggerChk.Checked:=False;
          end;
          if MaxFileSize>0 then
          begin
               CustomFileSizeSmallerChk.Checked:=True;
               CustomFileSizeSmallerE.Text:=inttostr(MaxFileSize);
          end else
          begin
               CustomFileSizeSmallerChk.Checked:=False;
               CustomFileSizeSmallerE.Text:='0';
          end;
          FileSizeR.ItemIndex:=FileSizeOption;
          OleChk.Checked:=UseOLEAutomation;
          PDFCheck.Checked:=UsePDFFiles;
          MaxFileSizeE.Text:=inttostr(GenMaxFileSize);
     end;

end;

procedure TPrmF.SaveBtnClick(Sender: TObject);
begin
     SaveSettings;
end;

procedure TPrmF.SaveSettings;
Var
   errswc:Boolean;
   msj,keyname:ASCMRString;
   Reg:TRegistry;
   SaveRec:TAppDefRec;

begin
     msj:='';
     if TextToInt(MaxFileSizeE.Text)>=GenFileSizeLimit then
        msj:=ReplaceText_MR(GenFileSizeLMaxError,'$size',inttostr(GenFileSizeLimit));

     if (msj='') and (TextToInt(MaxFileSizeE.Text)<=0) then
        msj:=GenFileSizeLMinError;

     if msj<>'' then
     begin
          MessageDlg(msj,mtError,[mbOk],0);
          exit;
     end;
     with SaveRec do
     Begin
          IncFilePtr:=InMaskE.Text;
          ExcFilePtr:=ExMaskE.Text;
          SourceDir:=DirE.Text;
          DestDir:=DestE1.Text;
          SubDirs:=SubsChk.Checked;
          WarmBeforeOpenPtr:=WarmBeforeOpenPtr1.Text;
          OnExitAskSaveChk:=OnExitAskSave1.Checked;
          CaseSensChk:=CaseSens1.Checked;
          RegExUseChk:=RegExUse1.Checked;
          RegExGreedyChk:=RegExGreedy1.Checked;
          RegExMultiLineChk:=RegExMultiLineChk1.Checked;
          RegExSingleLineChk:=RegExSingleLineChk1.Checked;
          RegExExtendedChk:=RegExExtendedChk1.Checked;
          RegExAnchoredChk:=RegExAnchoredChk1.Checked;
          FileSizeOption:=FileSizeR.ItemIndex;
          DateOption:=FileModifyR.ItemIndex;
          UseOLEAutomation:=OleChk.Checked;
          UsePDFFiles:=PDFCheck.Checked;
          case FileModifyR.ItemIndex of
               //0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom
               0..6:
               Begin
                    MinDate:=0;
                    MaxDate:=0;
               End;
               7:
               begin
                    if FileModifyAfterChk.Checked Then
                    MinDate:=int(FileModifyAfterDate.Date)+Frac(FileModifyAfterTime.Time)
                    else
                    MinDate:=0;
                    if FileModifyBeforeChk.Checked then
                    MaxDate:=int(FileModifyBeforeDate.Date)+Frac(FileModifyBeforeTime.Time)
                    else
                    MaxDate:=0;
               end;
          end;
          case FileSizeR.ItemIndex of
          {0:Any Size,1:Up To 1 KB,2:Up To 100 KB,3:Up To 1 MB,4:Over 25 KB,
           5:Over 100 KB,6:Over 1 MB,7:Custom }
               0:
               Begin
                    MinFileSize:=0;
                    MaxFileSize:=0;
               End;
               1:
               Begin
                    MinFileSize:=1024;
                    MaxFileSize:=0;
               End;
               2:
               Begin
                    MinFileSize:=102400;
                    MaxFileSize:=0;
               End;
               3:
               Begin
                    MinFileSize:=1048576;
                    MaxFileSize:=0;
               End;
               4:
               Begin
                    MinFileSize:=0;
                    MaxFileSize:=25600;
               End;
               5:
               Begin
                    MinFileSize:=0;
                    MaxFileSize:=102400;
               End;
               6:
               Begin
                    MinFileSize:=0;
                    MaxFileSize:=1048576;
               End;
               7:
               Begin
                    MinFileSize:=TextToInt(CustomFileSizeBiggerE.Text);
                    MaxFileSize:=TextToInt(CustomFileSizeSmallerE.Text);
               End;
          end;
          if MinFileSize<0 then
          Begin
               MessageDlg(msgExSelHata1,mtError,[mbOK],0);
               exit;
          end;
          if MaxFileSize<0 then
          Begin
               MessageDlg(msgExSelHata2,mtError,[mbOK],0);
               exit;
          end;
          if (MaxFileSize>0) and (MinFileSize>0) and (MinFileSize>=MaxFileSize) then
          Begin
               MessageDlg(msgExSelHata3,mtError,[mbOK],0);
               exit;
          end;

          GenMaxFileSize:=TextToInt(MaxFileSizeE.Text);
     end;
     errswc:=False;
     keyname:='Software\Asyncronous\MultiReplacer';
     Reg:=TRegistry.Create;
     try
        Reg.RootKey:=HKEY_CURRENT_USER;
        if not Reg.OpenKey(keyname,True) then
        Begin
             MessageDlg(msgKytYazHata1,mtError,[mbOK],0);
             errswc:=true;
        end else
        Begin
             with SaveRec do
             Begin
                  Reg.WriteString('IncFilePtr',IncFilePtr);
                  Reg.WriteString('ExcFilePtr',ExcFilePtr);
                  Reg.WriteString('SourceDir',SourceDir);
                  Reg.WriteString('DestDir',DestDir);
                  Reg.WriteBool('SubDirs',SubDirs);
                  Reg.WriteString('WarmBeforeOpenPtr',WarmBeforeOpenPtr);
                  Reg.WriteBool('OnExitAskSaveChk',OnExitAskSaveChk);
                  Reg.WriteBool('CaseSensChk',CaseSensChk);
                  Reg.WriteBool('RegExUseChk',RegExUseChk);
                  Reg.WriteBool('RegExGreedyChk',RegExGreedyChk);
                  Reg.WriteBool('RegExMultiLineChk',RegExMultiLineChk);
                  Reg.WriteBool('RegExSingleLineChk',RegExSingleLineChk);
                  Reg.WriteBool('RegExExtendedChk',RegExExtendedChk);
                  Reg.WriteBool('RegExAnchoredChk',RegExAnchoredChk);
                  Reg.WriteInteger('MinFileSize',MinFileSize);
                  Reg.WriteInteger('MaxFileSize',MaxFileSize);
                  Reg.WriteDateTime('MinDate',MinDate);
                  Reg.WriteDateTime('MaxDate',MaxDate);
                  Reg.WriteInteger('DateOption',DateOption);
                  Reg.WriteInteger('FileSizeOption',FileSizeOption);
                  Reg.WriteBool('UseOLEAutomation',UseOLEAutomation);
                  Reg.WriteBool('UsePDFFiles',UsePDFFiles);
                  Reg.WriteInteger('GenMaxFileSize',GenMaxFileSize);
             end;
             Reg.CloseKey;
        end;
    except
          on E: Exception do
          begin
               MessageDlg(E.Message,mtError,[mbOK,mbHelp], E.HelpContext);

               //MessageDlg('Error ! Can not saving MultiReplacer default '+
                //'settings to your registry.',mtError,[mbOK],0);
               errswc:=True;
          end;
    end;
    Reg.Free;
    if not errswc then appdefaultsrec:=SaveRec;
    Close;
end;

procedure TPrmF.DirBtnClick(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=DirE.Text;
     s:=SelectDir(sb);
     if s<>sb Then DirE.Text:=s;

end;

function TPrmF.SelectDir(dir: ASCMRString): ASCMRString;
var
  fDir: String;
begin
  fDir := dir;
  if SelectDirectory(fDir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    Result := fDir
    Else
    Result:='';

end;

procedure TPrmF.DestBtn1Click(Sender: TObject);
Var
   s,sb:ASCMRString;
begin
     sb:=DestE1.Text;
     s:=SelectDir(sb);
     if s<>sb Then
     DestE1.Text:=s;
end;

procedure TPrmF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);
     if Shift=[] then
     Case key of
          VK_ESCAPE:Close;
     end;

end;

procedure TPrmF.FormShow(Sender: TObject);
begin
     TabSheet2.DoubleBuffered:=true;

end;

end.
