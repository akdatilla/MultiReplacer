unit ProgressU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TProgressF = class(TForm)
    PB1: TProgressBar;
    CancelBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fCancelled:Boolean;
  end;

var
  ProgressF: TProgressF;

implementation

{$R *.dfm}

procedure TProgressF.CancelBtn1Click(Sender: TObject);
begin
     fCancelled:=True;
     CancelBtn1.Enabled:=False;
end;

procedure TProgressF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action:=caNone;
     CancelBtn1Click(nil);
end;

procedure TProgressF.FormCreate(Sender: TObject);
begin
     fCancelled:=False;
end;

end.
