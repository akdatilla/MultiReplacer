(*
{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
*)
program MultiReplacer;



uses
  Forms,
  SysUtils,
  RepFrmU in 'RepFrmU.pas' {RepFrmF},
  RepMainU in 'RepMainU.pas' {RepMainF},
  ImportFilesU in 'ImportFilesU.pas' {ImportFilesF},
  WordEditU in 'WordEditU.pas' {WordEditF},
  RepConstU in 'RepConstU.pas',
  RepLib in 'RepLib.pas',
  ThunderbirdTreeMain in 'thbird\ThunderbirdTreeMain.pas',
  PrmU in 'PrmU.pas' {PrmF},
  NewPrjU in 'NewPrjU.pas' {NewPrjF},
  DiffUtilUB in 'DiffUtilUB.pas' {DiffUtilBF},
  RecycleBinU in 'RecycleBinU.pas' {RecycleBinF},
  RVStyle in 'richview\Source\RVStyle.pas',
  RepThreadU in 'RepThreadU.pas',
  DosyaGosterU in 'DosyaGosterU.pas' {DosyaGosterF},
  MarqueeProgressBar in 'MarqueeProgressBar.pas',
  MulRepMainU in 'MulRepMainU.pas' {MulRepMainF},
  SysImg in 'SysImg.pas',
  ProcessViewU in 'ProcessViewU.pas' {ProcessViewF},
  SelDirU in 'SelDirU.pas' {SelDirF},
  ExSelDirU in 'ExSelDirU.pas' {ExSelDirF},
  FileFormatSelU in 'FileFormatSelU.pas' {FileFormatSelF},
  CollapsePanel in 'CollapsePanel.pas',
  MatchesU in 'MatchesU.pas' {MatchesF},
  pc1 in 'LisansKayit\pc1.pas' {PC1Frm},
  WinAnahtarU in 'LisansKayit\WinAnahtarU.pas',
  MACAdress in 'LisansKayit\MACAdress.pas',
  ASCOfisTool in 'ASCOfisTool.pas',
  NicePreview in 'NicePreview.pas',
  PreviewU in 'PreviewU.pas' {PreviewF},
  AboutU in 'AboutU.pas' {AboutF},
  ProgressU in 'ProgressU.pas' {ProgressF},
  BMDThread in 'BMDThread.pas',
  RegExpr in 'RegExp\RegExpr.pas',
  MulTreeList in 'MulTreeList.pas',
  cUnicodeReader in 'FundamentalsUnicode416\cUnicodeReader.pas',
  DiffUtilU in 'DiffUtilU.pas' {DiffUtilF},
  DetailU in 'DetailU.pas' {DetailF},
  HexDataU in 'HexDataU.pas' {HexDataF};

{$R *.res}

procedure prjhidecnt;
var
   j:integer;
   f:String;
begin
     for j := 1 to ParamCount do
     begin
          f:=Trim(uppercase(ParamStr(j)));
          if f='-'+cmdHide then
          Begin
               RepMainF.vAutoHide:=True;
          end;

     end;
end;
begin
  Application.Initialize;
  Application.Title := 'Multi Replacer';
  Application.CreateForm(TMulRepMainF, MulRepMainF);
  Application.CreateForm(TPC1Frm, PC1Frm);
  RepMainF:=TRepMainF.Create(nil);
  prjhidecnt;
  if not RepMainF.vAutoHide then RepMainF.Show;
  //Application.ShowMainForm := false;
  Application.Run;
end.
