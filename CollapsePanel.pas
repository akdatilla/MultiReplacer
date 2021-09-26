unit CollapsePanel;

{****************************************************************************
          COLLAPSE PANEL ver 1.11   - Copyright (c) Lindsay D'Penha

Disclaimer: This component is freeware so I take no responsibility for any
problems or losses that may occur, use at your own risk

This component is freeware, but if you modify anything send me the changes.
If you modify the
compenent you may then include your copyright along with the original one.
You are free to distribute this component provided this readme file is not
modified or removed from the distribution.
This component cannot be used in a commercial application without my written approval.
i.e. you cannot include this component in an application that you are making
money from, without my approval.

Programmer: Lindsay D'Penha
Date Created: 01/10/2001
Date Modified: 01/18/2001

Collapse Panel is a simple drop down panel component.
It has a header and a button to allow it to expand and collapse.

Main Properties
****************
HeaderCaption     Set the Headers Caption
AutoClose         If True then it will autoclose AutoCloseTime millisecs after the mouse is out of the panel   default is false
AutoCloseTime     Sets the time after which the the panle will close default is 1500

If Auto Close is true then the collapse button acts as a stay on top button
*****************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Buttons,
  ExtCtrls;

const
  cCloseUpGovernor = 300;  // when the panel reaches this limit, the animation redraws less frequently


type
  TCollapsePanel = class(TPanel)
  private
    { Private declarations }
    FExpandedHeight:Integer;
    FCloseUpTimer:TTimer;
    FAutoCloseTime:Integer;
    FAbout:String;
    IsCollapsed:Boolean;
    StayOpen:Boolean;
    FAutoClose:Boolean;
    function ApplyDark(Color: TColor; HowMuch: Byte): TColor;
    Procedure PullDown;
    Procedure CloseUp;
    procedure CloseUpTimerTimer(Sender: TObject);
    procedure SetAutoCloseTime(Value:Integer);
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure OnAutoClose(AutoClose:Boolean);
    procedure SetAbout(value:String);
    procedure setCollapse(value: boolean);
  protected
    { Protected declarations }
    HeaderPanel:TPanel;
    Collapser:TSpeedButton;
    function GetHeaderCaption:TCaption;
    procedure SetHeaderCaption(Value:TCaption);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CollapserClick(Sender: TObject);
    Procedure Paint; override;
  published
    { Published declarations }
    property HeaderCaption:TCaption read GetHeaderCaption write SetHeaderCaption;
    property AutoClose:Boolean read FAutoClose write OnAutoClose default False;
    property AutoCloseTime:Integer read FAutoCloseTime write SetAutoCloseTime default 1500;
    property Collapsed:Boolean read IsCollapsed write setCollapse default False;
    property About:String read FAbout Write SetAbout;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LDComp', [TCollapsePanel]);
end;

{ TCollapsePanel }

constructor TCollapsePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAbout:= '(C) Lindsay DPenha (iamlinz@hotmail.com)';

  Caption:='';
  HeaderPanel:=TPanel.Create(self);
  HeaderPanel.Parent:= self;
  HeaderPanel.Align:= alTop;
  HeaderPanel.Height:= 16;
  HeaderPanel.Color:= ApplyDark(Color,100);
  HeaderPanel.ParentFont:=True;
  HeaderPanel.Alignment:=taLeftJustify;
  FCloseUpTimer:=TTimer.create(self);
  FCloseUpTimer.Enabled:=False;
  FAutoCloseTime:=1500;
  FCloseUpTimer.Interval:=FAutoCloseTime;


  Collapser:=TSpeedButton.create(self);
  Collapser.Parent:=HeaderPanel;
  Collapser.Font.Name:='Courier';
  Collapser.Font.Size:=10;
  Collapser.Font.Style:=[fsBold];
  Collapser.Height:=15;
  Collapser.Width:=15;
  Collapser.Top:= 0;
  Collapser.Left:= 0;
  Collapser.Caption:='-';
  Collapser.Flat:=False;



  Collapser.OnClick:= CollapserClick;
  FCloseUpTimer.OnTimer:= CloseUpTimerTimer;
  FExpandedHeight:=Height;

  IsCollapsed:=False;
  Collapsed:=False;
  StayOpen:=False;
  AutoClose:=False;

  Caption:= '';
end;


procedure TCollapsePanel.setCollapse(value:boolean);
begin
 if value<>IsCollapsed then
 begin
   if value then
   CloseUp
   else
   PullDown;
 end;
end;

procedure TCollapsePanel.CollapserClick(Sender: TObject);
begin
if FAutoClose then
StayOpen:=Collapser.Down
else
begin
  if IsCollapsed then
  PullDown
  else
  CloseUp;
end;
end;

Function TCollapsePanel.ApplyDark(Color:TColor; HowMuch:Byte):TColor;
Var r,g,b:Byte;
Begin
	Color:=ColorToRGB(Color);
	r:=GetRValue(Color);
	g:=GetGValue(Color);
	b:=GetBValue(Color);
	if r>HowMuch then r:=r-HowMuch else r:=0;
	if g>HowMuch then g:=g-HowMuch else g:=0;
	if b>HowMuch then b:=b-HowMuch else b:=0;
	result:=RGB(r,g,b);
End;

procedure TCollapsePanel.Paint;
begin
  inherited;
  HeaderPanel.Color:= ApplyDark(Color,20);
end;

function TCollapsePanel.GetHeaderCaption: TCaption;
begin
with HeaderPanel do
begin
 result:= HeaderPanel.Caption;
end;
end;

procedure TCollapsePanel.SetHeaderCaption(Value: TCaption);
begin
with HeaderPanel do
begin
 if Value<>Caption then
 Caption:=Value;
end;
end;

procedure TCollapsePanel.CMMouseEnter(var Msg: TMessage);
begin
 if FAutoClose then
 begin
 FCloseUpTimer.Enabled:=False;
 if IsCollapsed then PullDown;
 end;
end;

procedure TCollapsePanel.CMMouseLeave(var Msg: TMessage);
begin
  if FAutoClose = False then exit;
  if IsCollapsed then exit;
  if StayOpen then exit;
  FCloseUpTimer.Enabled:=True;
end;

procedure TCollapsePanel.CloseUp;
var I:Integer;
begin
  if not IsCollapsed then
   begin
     IsCollapsed:=True;
     FExpandedHeight:=Height;
     Height:=HeaderPanel.Height;
     {
     for I:= FExpandedHeight downto (HeaderPanel.Height+1) do   // Simple Scrolling effect
     begin
       if FExpandedHeight < cCloseUpGovernor then
       Height:=I
       else if(I mod 4)=0 then
       begin
       Height:=I;
       end;
     end;
     }
     Height:=HeaderPanel.Height+1;
     Collapser.Caption:='+';
   end;
   invalidate;
end;

procedure TCollapsePanel.PullDown;
var I:Integer;
begin
  if IsCollapsed then
   begin
     IsCollapsed:=False;
     Height:=FExpandedHeight;
     {
     for I:= (HeaderPanel.Height+1) to  FExpandedHeight do    // Simple logic for Scrolling effect, with diff accelerations
     begin
       if FExpandedHeight < 300 then
       Height:=I
       else if (I mod 4)=0 then    // if height larger than 300 then write to screen only when mod =0 is true, works like a step it in the for loop
       Height:=I;
     end;
       Height:= FExpandedHeight;  // if the mod didnt get to the final value
     }
     Collapser.Caption:='-';
   end;
   invalidate; 
end;

procedure TCollapsePanel.CloseUpTimerTimer;
begin
 CloseUp;
 FCloseUpTimer.Enabled:=False;
end;

procedure TCollapsePanel.OnAutoClose(AutoClose: Boolean);
begin
if FAutoClose<>AutoClose then
FAutoClose:= AutoClose;

if AutoClose then
begin
  Collapser.GroupIndex:= -1;
  Collapser.AllowAllUp:=True;
end
else
begin
  Collapser.GroupIndex:=0;
  Collapser.AllowAllUp:=False;
end;
end;


procedure TCollapsePanel.SetAutoCloseTime(Value: Integer);
begin
 FAutoCloseTime:=Value;
 FCloseUpTimer.Interval:=FAutoCloseTime;
end;


procedure TCollapsePanel.SetAbout(value: String);
begin
  FAbout:= '(C) Lindsay DPenha (iamlinz@hotmail.com)';
end;

end.



