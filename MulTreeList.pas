{
  Multi-column Treeview component for Borland Delphi 7

  Name: pTree
  Version: 1.10
  Created: 06/25/2005
  E-mail: qinmaofan@21cn.com
  Copyright (C) 2005 Afan Tim

  This is a simple multi-column treeview component base on Michal Mecinski's
  Multi-Column Tree View (VC++ project)
  (http://www.codeguru.com/Cpp/controls/treeview/multiview/article.php/c3985)

  I didn't want to use Virtual Treeview as it is too complex and too big. So I
  decide to wrote a simple one.

  It still has some bugs in vertical and horizontal scrollbars. Send one copy
  to me if you have make any modification. Thanks in advance.
}

{
Control '' has no parent window 错误地解决方法：
  在 Constructor 中调用 Handle 时注意点即可。
}

unit MulTreeList;

interface

uses
  Windows, SysUtils, Classes, Controls, ComCtrls, messages, ExtCtrls, Graphics,
  CommCtrl, math, Forms;

const
  WM_ENDDRAGHEADER = WM_USER + 380;
  WM_HEADERWIDTH =   WM_USER + 381;

type
  Tmyheader = class(THeaderControl)
  private
    trHandle: THandle;
    procedure CNNotify(var msg: TWMNotify); message CN_NOTIFY;
  public
    Constructor Create(AOwner:TComponent);override;
end;


type
  TTreeList = class(TTreeView)
  private
    //m_cyHeader,         { 列头高度 }
    m_xPos,               { 水平滚动条当前位置 }
    m_xOffset:  integer;  { rect的水平偏移 }
    arrColWidths: array of DWORD;  { 列头的各列宽度，发送消息获取 }
    FHeaderFont: TFont;
    FHighlightColor: TColor;
    FChildHighlightTextColor: TColor;
    FHighlightText: TColor;
    FMaskColor: TColor;
    FSeperator: char;
    FColCount: integer;
    FColsWidth: integer;
    Function GetNodeTextFromItem(hItem: HTreeItem; var NodeText: string): boolean;
    procedure SetColumnSeperator(Value: char);
    procedure DoDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
    procedure CNNotify(var msg: TWMNotify); message CN_NOTIFY;
  Protected

  public
    constructor Create(AOwner: TComponent); override;
    Procedure SetColArray(_arr: array of integer);
    Procedure HideHScroll;
  Published
    Property Seperator: char read FSeperator write SetColumnSeperator;
    Property ColCount: integer  read FColCount  write FColCount;
    Property ColsWidth: integer read FColsWidth write FColsWidth;
  end;


type
  TpTree = class(TPanel)
  private
    m_xPos: integer;
    m_cxTotal: integer;
    m_cyHeader: integer;
    m_xOffset: integer;
    FTV: TTreeList;
    FHDR: Tmyheader;
    Fhds: THeaderSections;
    Procedure MsgHeaderWidth(var msg:Tmessage); message WM_HEADERWIDTH;
    Function AllColumnWidth: integer;
    Procedure MsgDragSection(var msg:Tmessage); message WM_ENDDRAGHEADER;
    procedure OnHScroll(var msg:TWMHScroll); message WM_HSCROLL;
    Procedure myOnSize(var msg:TWMSize); message WM_SIZE;
    Procedure RepositionControls;
  Protected
    procedure UpdateScroller;
  public
    constructor Create(AOwner: TComponent); override;
    Procedure UpdateColumns;
    Procedure HideTVHScrollBar;
    Procedure SetHDSectionWidth(const index, HdsWidth: integer);
    Function SubItemAdd(nParent, nChild: TTreeNode; const sItem: string): TTreeNode;
    Procedure Clear; 
  Published
    property tv: TTreeList read FTV write FTV;
    property hdr: Tmyheader read Fhdr write Fhdr;
    property ColumnsWidth: integer read AllColumnWidth;
    property HeaderSections: THeaderSections  read Fhds write Fhds;
  end;


procedure Register;

type
  pDLLVERSIONINFO = ^DLLVERSIONINFO;
  DLLVERSIONINFO = record
   cbSize : integer;
   dwMajor : integer;
   dwMinor : integer;
   dwBuildNumber : integer;
   dwPlatformID : integer;
end;

{ 取文件版本信息的结构 }
type
  PFixedFileInfo = ^TFixedFileInfo;
  TFixedFileInfo = record
     dwSignature       : DWORD;
     dwStrucVersion    : DWORD;
     wFileVersionMS    : WORD;  // 次版本号
     wFileVersionLS    : WORD;  // 主版本号
     wProductVersionMS : WORD;  // 建立次数(build)
     wProductVersionLS : WORD;  // 发行次数(release)
     dwFileFlagsMask   : DWORD;
     dwFileFlags       : DWORD;
     dwFileOS          : DWORD;
     dwFileType        : DWORD;
     dwFileSubtype     : DWORD;
     dwFileDateMS      : DWORD;
     dwFileDateLS      : DWORD;
  end;

const
    TVS_NOHSCROLL = $8000;
    Node_Text_Len_1 = 128;
    Node_Text_Len_2 = 512;


implementation

{ 缩减矩形面积 }
Procedure DeflateRect(var rect:TRECT; w,h:integer);
begin
  Inc(rect.Left, w);
  Dec(rect.Right, w);
  Inc(rect.Top, h);
  Dec(rect.Bottom, h);
end;

//下面是取版本信息函数
Function FileVersionInfo( const FileName:String; var Major:DWORD):boolean;
var
  dwHandle, dwVersionSize, pulen : DWORD;
  strSubBlock             : String;
  pTemp                   : Pointer;
  pData                   : Pointer;
  FixedFileInfo           : pFixedFileInfo;
begin
  result:= false;
  strSubBlock := '\';
  // 取得文件版本信息的大小
  dwVersionSize := GetFileVersionInfoSize(PChar(FileName), dwHandle );
  if dwVersionSize <> 0 then  begin
    GetMem(pTemp, dwVersionSize);
    try
    //取文件版本信息
   if GetFileVersionInfo(PChar( FileName ),dwHandle,dwVersionSize,pTemp ) then
     if VerQueryValue(pTemp,PChar( strSubBlock ),pData,pulen) then begin
       Result := true;
       FixedFileInfo:= pData;
       Major:= FixedFileInfo^.wFileVersionLS;
     end;
    finally
      FreeMem(pTemp, dwVersionSize);
    end;
  end;
end;

Function FullPath(fname:string): string;
var
  filepart,buffer:pchar;
  err,cbLen: dword;
begin
  result:= '';
  cbLen:= 0;
  cbLen:= Searchpath(nil, pchar(fname), nil, 0, nil, filepart);
  if cbLen = 0 then exit;
  GetMem(buffer, cbLen + 1);
  err:= Searchpath(nil, pchar(fname), nil, cbLen, buffer, filepart);
  if err <> 0 then
    result:= string(buffer);
  freemem(buffer);
end;

procedure Register;
begin
  RegisterComponents('Samples', [TpTree]);
end;


//============================================================================//
{ TTreeList }

constructor TTreeList.Create(AOwner: TComponent);
var
  bIsComCtl6: boolean;
  v: dword;
  s: string;
  size: TSize;
  sect: THeaderSection;
begin
  inherited Create(AOwner);
  ToolTips:= false;
  Readonly:= true;

  //HideHScroll;
  SetLength(arrColWidths, 1);

  FSeperator := '|';

	// check if the common controls library version 6.0 is available
	bIsComCtl6 := FALSE;
  v:= 0;
  s:= Fullpath('comctl32.dll');
  if s <> '' then
    if FileVersionInfo(s, v) and (v >=6) then
      bIsComCtl6:= true;

  if bIsComCtl6 then
    m_xOffset:= 9
  else
    m_xOffset := 6;
	m_xPos := 0;

  //OnAdvancedCustomDrawItem:= DoDrawItem;
end;

procedure TTreeList.SetColumnSeperator(Value: char);
begin
  FSeperator := Value;
end;

{ 核心部分，绘画各个节点，要考虑水平滚动条 }
{ Core codes. Redraw all items. }
procedure TTreeList.DoDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
var
  rcLabel,rcText,rcTmp: TRECT;
  dc: hDC;
  clrText,clrBackground: dword;
  i,k,xOffset,MainWidth: integer;
  sText,strNode,strSub: string;
  uDrawMode:UINT ;
begin
  DefaultDraw := true;
  PaintImages := true;

  if node = nil then exit;

  if Stage = cdPostPaint then begin
    DefaultDraw := false;
    PaintImages := true;
    dc:= canvas.Handle ;
    rcLabel:= node.DisplayRect(true);
    clrText:= GetSysColor(COLOR_WINDOWTEXT);        { 字体颜色和背景色 }
    clrBackground:= GetSysColor(COLOR_WINDOW);

    { 发送消息到父窗体，然后在父窗体中设置好组件的各个属性 }
    if not Boolean(SendMessage(Parent.Handle, WM_HEADERWIDTH, 0, 0)) then
      exit;
    if FColCount = 0 then exit;

    if cdsSelected in State then begin
      clrBackground := GetSysColor(COLOR_BTNFACE);
      clrText := GetSysColor(COLOR_WINDOWTEXT);
    end;
    if cdsFocused in State then begin
      clrBackground := GetSysColor(COLOR_HIGHLIGHT);
      clrText := GetSysColor(COLOR_HIGHLIGHTTEXT);
    end;

    //SetBkColor(DC, clrBackground);
    //canvas.Brush.Style:= bsSolid ;
    //canvas.Brush.Color:=  clWindow;
    //canvas.FillRect(rcLabel);
   { clear the original label rectangle }
    FillRect(dc, rcLabel, clrBackground);

    strNode:= Node.Text ;
    strSub:= '';
    if node.HasChildren then
      strSub:= strNode
    else begin
      k:= Pos(FSeperator, strNode);
      if k > 0 then begin
        strSub:= Copy(strNode, 1, k-1);
        System.Delete(strNode, 1, k);
      end
      else begin
        strSub:= strNode;
        strNode:= '';
      end;
    end;
    // calculate main label's size
    ZeroMemory(@rcText, SizeOf(rcText));
    DrawText(DC, pchar(strSub), Length(StrSub), rcText, DT_NOPREFIX or DT_CALCRECT);
    MainWidth:= min(rcLabel.left + rcText.right + 4, arrColWidths[0] - 4);
    rcLabel.Right := FColsWidth - 2;
    if rcLabel.right - rcLabel.Left < 0 then
      clrText := clrBackground;
    // draw label's background
    if clrText <> clrBackground then
      FillRect(dc, rcLabel, clrText);
    SetTextColor(dc, clrText);
    // draw main label
    rcText := rcLabel;
    if not node.HasChildren then
      rcText.Right := MainWidth;
    DeflateRect(rcText, 2, 1);
    DrawText(DC, pchar(strSub), Length(StrSub), rcText, DT_NOPREFIX or DT_END_ELLIPSIS);

    xOffset := arrColWidths[0];
    SetBkMode(dc, TRANSPARENT);

    if not node.HasChildren then begin
      //SetTextColor(dc, clrText);
      for i:= 1 to Length(arrColWidths) - 1 do begin
        k:= Pos(FSeperator, strNode);
        if k > 0 then begin
          strSub:= Copy(strNode, 1, k-1);
          System.Delete(strNode, 1, k);
        end
        else begin
          strSub:= strNode;
          strNode:= '';
        end;
        rcText := rcLabel;
        rcText.left := xOffset;
        rcText.right := xOffset + arrColWidths[I];
        Inc(rcText.Left, m_xOffset);
        Dec(rcText.Right, 1);
        Inc(rcText.Top, 2);
        Dec(rcText.Bottom, 1);
        DrawText(DC, pchar(strSub), Length(strsub), rcText, DT_NOPREFIX or DT_END_ELLIPSIS);
        Inc(xOffset, arrColWidths[I]);
      end; {of FOR}
    end;

{
			// draw focus rectangle if necessary
			if cdsFocused in State then
				DrawFocusRect(dc, rcLabel);
}

  end;
end;

procedure TTreeList.SetColArray(_arr: array of integer);
var
  i,len: integer;
begin
  len:= Length(_arr);
  SetLength(arrColWidths, len);
  ZeroMemory(@arrColWidths[0], SizeOf(arrColWidths));
  For i:= low(_arr) to high(_arr) do
    arrColWidths[I]:= _arr[I];
end;


procedure TTreeList.CNNotify(var msg: TWMNotify);
var
  nmDraw: pNMCUSTOMDRAW;
  tvDraw: pNMTVCustomDraw;
  hItem: HTREEITEM;
  aBrush,OldBrush: hBrush;
  rcLabel,rcText,rcItem: TRECT;
  dc: hDC;
  crTextBk,crWnd,crText: dword;
  i,k,xOffset,MainWidth: integer;
  strNode,strSub: string;
  uDrawMode:UINT ;
  HasChildren: boolean;
begin
  if msg.NMHdr.code <> NM_CUSTOMDRAW then begin
    inherited;
    exit;
  end;


  nmDraw:=  pNMCUSTOMDRAW(pointer(msg.NMHdr));
  tvDraw:=  pNMTVCUSTOMDRAW(pointer(msg.NMHdr));

  case nmDraw.dwDrawStage of
    CDDS_PREPAINT:
      msg.Result := CDRF_NOTIFYITEMDRAW;

    CDDS_ITEMPREPAINT:
      msg.Result := CDRF_DODEFAULT or CDRF_NOTIFYPOSTPAINT;

    CDDS_ITEMPOSTPAINT:
    begin
      rcItem:= nmDraw.rc;
      if IsRectEmpty(rcItem) then begin
        msg.Result := CDRF_DODEFAULT;
        exit;
      end;

      hItem:= HTreeItem(nmDraw.dwItemSpec);
      if not GetNodeTextFromItem(hItem, strNode) then begin
        exit;
      end;
      strSub:= '';
      //HasChildren:= TreeView_GetChild(handle, hItem) <> nil;
      HasChildren:= Pos(FSeperator, strNode) = 0;

      { Send message to parent window to get header information }
      if not Boolean(SendMessage(Parent.Handle, WM_HEADERWIDTH, 0, 0)) then
        exit;
      if FColCount = 0 then exit;

      dc:= nmDraw.hdc;
      Treeview_GetItemRect(handle, hItem, rcLabel, true);
      if rcLabel.Right >= Width then
        HideHScroll;
      crTextBk:= tvDraw.clrTextBk;
      //clrText:= GetSysColor(COLOR_WINDOWTEXT);           { font and background color }
      crWnd:= GetSysColor(COLOR_WINDOW);
     { clear the original label rectangle }
      aBrush:= CreateSolidBrush(crWnd);
      //OldBrush:= SelectObject(dc, aBrush);
      rcLabel.Right := max(FColsWidth - 2, rcLabel.Right);
      FillRect(dc, rcLabel, aBrush);
      DeleteObject(aBrush);
      //SelectObject(dc, OldBrush);

{
      if nmDraw.dwDrawStage and CDIS_SELECTED = CDIS_SELECTED then begin
        //clrBackground := GetSysColor(COLOR_BTNFACE);
        crText := GetSysColor(COLOR_WINDOWTEXT);
      end;
      if nmDraw.dwDrawStage and CDIS_FOCUS = CDIS_FOCUS then begin
        //clrBackground := GetSysColor(COLOR_HIGHLIGHT);
        crText := GetSysColor(COLOR_HIGHLIGHTTEXT);
      end;
}

      if HasChildren then
        strSub:= strNode
      else begin
        k:= Pos(FSeperator, strNode);
        if k > 0 then begin
          strSub:= Copy(strNode, 1, k-1);
          System.Delete(strNode, 1, k);
        end
        else begin
          strSub:= strNode;
          strNode:= '';
        end;
      end;

      // calculate main label's size
      ZeroMemory(@rcText, SizeOf(rcText));
      DrawText(DC, pchar(strSub), Length(StrSub), rcText, DT_NOPREFIX or DT_CALCRECT);
      MainWidth:= min(rcLabel.left + rcText.right + 4, arrColWidths[0] - 4);
      rcLabel.Right := FColsWidth - 2;
      SetBkColor(dc, crTextBk);                                { 如果没有这行，view中第一个节点显示就有问题 }
      if rcLabel.right - rcLabel.Left < 0 then
        crTextBk := crWnd;
      // draw label's background
      if crTextBk <> crWnd then begin
        aBrush:= CreateSolidBrush(crTextBk);
        FillRect(dc, rcLabel, aBrush);
        DeleteObject(aBrush);
      end;
      SetTextColor(dc, tvDraw.clrText);
      //SetTextColor(dc, crText);
      // draw main label
      rcText := rcLabel;
      if not HasChildren then
        rcText.Right := MainWidth;
      DeflateRect(rcText, 2, 1);
      DrawText(DC, pchar(strSub), Length(StrSub), rcText, DT_NOPREFIX or DT_END_ELLIPSIS);

      xOffset := arrColWidths[0];
      SetBkMode(dc, TRANSPARENT);

      if not HasChildren then begin
        //SetTextColor(dc, GetSysColor(COLOR_WINDOWTEXT));
        for i:= 1 to Length(arrColWidths) - 1 do begin
          k:= Pos(FSeperator, strNode);
          if k > 0 then begin
            strSub:= Copy(strNode, 1, k-1);
            System.Delete(strNode, 1, k);
          end
          else begin
            strSub:= strNode;
            strNode:= '';
          end;
          rcText := rcLabel;
          rcText.left := xOffset;
          rcText.right := xOffset + arrColWidths[I];
          Inc(rcText.Left, m_xOffset);
          Dec(rcText.Right, 1);
          Inc(rcText.Top, 2);
          Dec(rcText.Bottom, 1);
          DrawText(DC, pchar(strSub), Length(strsub), rcText, DT_NOPREFIX or DT_END_ELLIPSIS);
          Inc(xOffset, arrColWidths[I]);
        end; {of FOR}
      end;

{
        // draw focus rectangle if necessary
        if nmDraw.uItemState and CDIS_FOCUS = CDIS_FOCUS then
          DrawFocusRect(dc, rcLabel);
}


      msg.Result := CDRF_DODEFAULT;
    end;
    else
      msg.Result := CDRF_DODEFAULT;
  end; {of CASE}
end;

{ 获取节点的文字 }
function TTreeList.GetNodeTextFromItem(hItem: HTreeItem; var NodeText: string): boolean;
var
  tvi: TTVItem;
begin
  result:= true;
  NodeText:= '';
  Fillchar(tvi, SizeOf(tvi), 0);
  tvi.hItem:= hItem;
  tvi.mask := TVIF_TEXT;
  tvi.cchTextMax:= Node_Text_Len_1;
  GetMem(tvi.pszText, Node_Text_Len_1);
  if not Treeview_GetItem(handle, tvi) then begin
    FreeMem(tvi.pszText);
    result:= false;
    exit;
  end;
  NodeText:= Trim(tvi.pszText);
  FreeMem(tvi.pszText);

  if Length(NodeText) >= Node_Text_Len_1 - 1 then begin
    Fillchar(tvi, SizeOf(tvi), 0);
    tvi.hItem:= hItem;
    tvi.mask := TVIF_TEXT;
    tvi.cchTextMax:= Node_Text_Len_2;
    GetMem(tvi.pszText, Node_Text_Len_2);
    if not Treeview_GetItem(handle, tvi) then begin
      FreeMem(tvi.pszText);
      exit;
    end;
    NodeText:= Trim(tvi.pszText);
    FreeMem(tvi.pszText);
  end;
end;


procedure TTreeList.HideHScroll;
begin
  ShowScrollBar(Handle, SB_HORZ, false);
end;

//===========================================================================//
{ Tmyheader }

constructor Tmyheader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure Tmyheader.CNNotify(var msg: TWMNotify);
var
  code: integer;
  hditem: HD_ITEM;
begin
  inherited;

  code:= PHDNotify(msg.NMHdr)^.Hdr.code;
  if (code = HDN_ENDTRACKW) or (code = HDN_ENDTRACK) then begin
    { 列头的宽度不应该在这里求，没有变 }
    { Post message to get columns width }
    PostMessage(Parent.Handle, WM_ENDDRAGHEADER, 0, 0);
  end;
end;

//===========================================================================//
{ TpnlTreeview }

constructor TpTree.Create(AOwner: TComponent);
var
  bIsComCtl6: boolean;
  v: DWORD;
  s: string;
begin
  inherited Create(AOwner);
  caption:= '';
  BevelInner:= bvNone;
  BevelOuter:= bvNone;
  Self.BorderStyle:= bsSingle;

  m_xPos:= 0;
  m_cxTotal:= 0;

  Fhdr:= Tmyheader.Create(self);
  with Fhdr do begin
    Parent := Self;
    Align := alTop;
    Name := 'Header1';
    Fhds:= Sections;
  end;

  Ftv:= TTreeList.Create(self);
  with Ftv do begin
    Parent := Self;
    HideSelection:= false;
    RowSelect:= true;
    Align := alClient;
    BevelInner:= bvNone;
    BevelOuter:= bvNone;
    BorderStyle:= bsNone;
    BevelEdges:= [];
    Ctl3D := false;
    Name := 'Treeview1';
    //HideHScroll;
  end;

  Fhdr.Align := alNone;
  Ftv.Align := alNone;
  Ftv.Width:=Width-5;
	// check if the common controls library version 6.0 is available
	bIsComCtl6 := FALSE;
  v:= 0;
  s:= Fullpath('comctl32.dll');
  if s <> '' then
    if FileVersionInfo(s, v) and (v >=6) then
      bIsComCtl6:= true;

  if bIsComCtl6 then
    m_xOffset:= 9
  else
    m_xOffset := 6;
	m_xPos := 0;

  if bIsComCtl6 then
    m_cyHeader:= 7
  else
    m_cyHeader:= 4;

  //UpdateColumns;
end;

{ Header发送列头改变的消息给父组件，然后父组件处理滚动条和treeview重绘 }
{ This event notified by Header }
procedure TpTree.MsgDragSection(var msg: Tmessage);
begin
  UpdateColumns();
  Ftv.Invalidate;
end;

{ 子控件发送消息要求取列头宽度数据 }
{ Get columns width in Header }
procedure TpTree.MsgHeaderWidth(var msg: Tmessage);
var
  arr: array of integer;
  i,k,w: integer;
  hdItem: HD_ITEM;
begin
  k:= Fhdr.Sections.Count ;
  w:= 0;
  SetLength(arr, k);
  for i:= 0 to k - 1 do begin
    Fillchar(hdItem, SizeOf(hdItem), 0);
    hdItem.Mask:= HDI_WIDTH;
    if Header_GetItem(Fhdr.Handle , i, hdItem) then begin
      arr[I]:= hdItem.cxy;
      Inc(w, hdItem.cxy);
    end;
  end;
  Ftv.ColCount:= k;
  Ftv.ColsWidth:= w;
  Ftv.SetColArray(arr);
  msg.Result := 1;
end;

function TpTree.AllColumnWidth: integer;
var
  i,k: integer;
  hdItem: HD_ITEM;
begin
  result:= 0;
  k:= Fhdr.Sections.Count ;
  for i:= 0 to k - 1 do begin
    Fillchar(hdItem, SizeOf(hdItem), 0);
    hdItem.Mask:= HDI_WIDTH;
    if Header_GetItem(Fhdr.Handle , i, hdItem) then
      Inc(result, hdItem.cxy);
  end;
end;


{ Panel大小改变时，更新滚动条和重新定位字控件的位置 }
{ Update scrollbar, Header, Treeview after panel's size changed }
procedure TpTree.myOnSize(var msg: TWMSize);
begin
  inherited;
	UpdateScroller();
	RepositionControls();
end;

{ 设置水平滚动条 }
procedure TpTree.OnHScroll(var msg: TWMHScroll);
var
  xLast: integer;
begin
  xLast:= m_xPos;
  case msg.ScrollCode of
    SB_LINELEFT:
      Dec(m_xPos, 15);
    SB_LINERIGHT:
      Inc(m_xPos, 15);
    SB_PAGELEFT:
      Dec(m_xPos, width);
    SB_PAGERIGHT:
      Inc(m_xPos, width);
    SB_LEFT:
      m_xPos := 0;
    SB_RIGHT:
      m_xPos := m_cxTotal - width;
    SB_THUMBTRACK:
      m_xPos := msg.Pos;
  end;

  if m_xPos < 0 then
    m_xPos:= 0
  else if m_xPos > m_cxTotal - width then
    m_xPos:= m_cxTotal - width;
  if xLast = m_xPos then exit;

  SetScrollPos(handle, SB_HORZ, m_xPos, true);
  RepositionControls();
end;

{ 移动 Treeview 和 header 的位置 }
{ Move Header and Treeview in panel while scrolling }
procedure TpTree.RepositionControls;
var
  x,cx,cy: integer;
begin
  if self.HandleAllocated then begin
    cx:= Width-5;
    cy:= Height-5;
    x:= 0;
    if cx < m_cxTotal then begin
      x := GetScrollPos(handle, SB_HORZ);
      Inc(cx, x);
    end;
    MoveWindow(Fhdr.Handle, -x, 0, cx, Fhdr.Height, true);
    MoveWindow(Ftv.Handle, -x, Fhdr.Height, cx, cy - Fhdr.Height, true);
  end;
end;

procedure TpTree.UpdateColumns;
begin
  if not HandleAllocated then exit;
  m_cxTotal:= AllColumnWidth ;
  Ftv.Width := max(m_cxTotal, Fhdr.Width);
	UpdateScroller();
	RepositionControls();
end;

{ 更新水平滚动条 }
procedure TpTree.UpdateScroller;
var
  si: ScrollInfo;
  i: integer;
begin
  if m_xPos > m_cxTotal - width then
    m_xPos:= m_cxTotal - width;
  if m_xPos < 0 then
    m_xPos:= 0;

  FillChar(si, sizeof(si), 0);
	si.cbSize := sizeof(si);
	si.fMask := SIF_PAGE or SIF_POS or SIF_RANGE;
	si.nPage := width;
	si.nMin := 0;
	si.nMax := m_cxTotal;
	si.nPos := m_xPos;
	SetScrollInfo(handle, SB_HORZ, si, true);
end;

procedure TpTree.HideTVHScrollBar;
begin
  ShowScrollBar(Ftv.Handle, SB_HORZ, false);
end;

{ Change header section' width and invalidate }
procedure TpTree.SetHDSectionWidth(const index, Hdswidth: integer);
begin
  if HeaderSections.Count > index then
    if HeaderSections[index].Width <> HdsWidth then begin
      HeaderSections[Index].Width:= HdsWidth;
      Ftv.Invalidate;
    end;
end;

{ Clear all items in treeview }
procedure TpTree.Clear;
begin
  Ftv.Items.Clear;
end;

{ Add column item (child node) to nParent treenode  }
function TpTree.SubItemAdd(nParent, nChild: TTreeNode; const sItem: string): TTreeNode;
var
  s: string;
begin
  { The first column }
  if nChild = nil then
    result:= Ftv.Items.AddChild(nParent, sItem)
  { Other column }
  else begin
    s:= nChild.Text ;
    s:= s + tv.Seperator + sItem;
    nChild.Text := s;
  end;
end;

end.

