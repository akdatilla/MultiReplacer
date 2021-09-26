unit ProcessViewU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MarqueeProgressBar, StdCtrls, Buttons, ExtCtrls,RepThreadU;

type
  TProcessViewF = class(TForm)
    SearchPan1: TPanel;
    ScannedFCL: TLabel;
    FoundedFCL: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ScnFolderHL: TLabel;
    Label5: TLabel;
    ScanFolderL: TLabel;
    ScanFileL: TLabel;
    Label8: TLabel;
    FileQueueL: TLabel;
    Shape1: TShape;
    PauseBtn: TBitBtn;
    BitBtn1: TBitBtn;
    MatchedFCL: TLabel;
    Label2: TLabel;
    NotReadedFCL: TLabel;
    Label3: TLabel;
    StopBtn: TBitBtn;
    PlayBtn: TBitBtn;
    FormRefreshTim: TTimer;
    procedure PauseBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormRefreshTimTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MSrcObj:TMainFileSearch;
    MQThread:TQueueThread;
    MrqBar1:TMarqueeProgressBar;
    CFileNameSize:integer;
    FStopEvent:TNotifyEvent;
    MFileSearching:^Boolean;
    vpScanFile,vpFoundedFC,vpScannedFC,
    vpNotReadedFC,vpFileQueue,vpMatchedFC,
    vpScanFolder:String;
  end;

var
  ProcessViewF: TProcessViewF;

implementation

{$R *.dfm}
Uses RepMainU;

procedure TProcessViewF.BitBtn1Click(Sender: TObject);
begin
     Close;
end;

procedure TProcessViewF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action:=caNone;
     Self.Hide;
end;

procedure TProcessViewF.FormCreate(Sender: TObject);
begin
     PlayBtn.Visible:=False;
     PlayBtn.Top:=PauseBtn.Top;
     PlayBtn.Left:=PauseBtn.Left;
     CFileNameSize:=40;
     vpScanFile:='';
     vpFoundedFC:='0';
     vpScannedFC:='0';
     vpNotReadedFC:='0';
     vpFileQueue:='0';
     vpMatchedFC:='0';
     vpScanFolder:='';
end;

procedure TProcessViewF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     Win7UpdateFix(Self,Key);

end;

procedure TProcessViewF.FormRefreshTimTimer(Sender: TObject);
begin
     FoundedFCL.Caption:=vpFoundedFC;
     ScannedFCL.Caption:=vpScannedFC;
     NotReadedFCL.Caption:=vpNotReadedFC;
     FileQueueL.Caption:=vpFileQueue;
     MatchedFCL.Caption:=vpMatchedFC;
     ScanFolderL.Caption:=vpScanFolder;
     ScanFileL.Caption:=vpScanFile;

end;

procedure TProcessViewF.FormResize(Sender: TObject);
begin
     CFileNameSize:=Round(ScanFolderL.Width/ScanFolderL.Canvas.TextWidth('A'));
     if CFileNameSize<25 then CFileNameSize:=25;
end;

procedure TProcessViewF.PauseBtnClick(Sender: TObject);
begin
     if (MFileSearching^) then
     Begin
          if MSrcObj.Paused then
          Begin
               //if MQThread.SearchFileQueue.Count>0 then

               //MQThread.Active:=True;
               MQThread.FPaused:=False;
               MQThread.Resume;



               MSrcObj.Resume;
               PlayBtn.Visible:=False;PauseBtn.Visible:=True;
               MrqBar1.Active:=True;
          end else
          Begin
               MSrcObj.Pause;
               MQThread.FPaused:=True;
               MQThread.Resume;
               PlayBtn.Visible:=true;PauseBtn.Visible:=False;
               MrqBar1.Active:=False;
          End;
     End else
     if (MQThread.SearchFileQueue.Count>0)  then
     begin
          MQThread.FPaused:=not MQThread.FPaused;
          MQThread.Active:=not MQThread.FPaused;
          MrqBar1.Active:=MQThread.Active;
          if MQThread.Active then
          begin
               PlayBtn.Visible:=False;PauseBtn.Visible:=True;
          end
          else
          Begin
               PlayBtn.Visible:=True;PauseBtn.Visible:=False;

          End;
     end;
end;

procedure TProcessViewF.StopBtnClick(Sender: TObject);
begin
     if Assigned(FStopEvent) then FStopEvent(Sender);

end;

end.
