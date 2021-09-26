unit RepConstU;

interface
uses windows,Messages, Classes,SysUtils,Variants, Graphics,Controls, Forms,
Math,ClipBrd,StrUtils;
Const
     DemoVersiyon=2;// 0: Normal , 1:Demo ,2:Lite
     ASCUniCodeUsing=0; ///0:Not using,1:Using WideString,TNTUniCode Companents.
     ASCProductName='Multi Replacer';
     {$IF (DemoVersiyon=0)}
         msgDenemeSurumuSonu='Demo version has expired.';
        {$IF (ASCUniCodeUsing=1)}
        ASCAppName='Unicode Multi Replacer';
        {$ELSE}
        ASCAppName='Multi Replacer';
        {$IFEND}
     {$ELSEIF (DemoVersiyon=2)}
        msgDenemeSurumuSonu='Demo version has expired.';
        clcdegerleri:array [1..43] of integer=(9,11,17,20,33,50,18,23,30,2,13,37,{13.}3,
        25,6,16,26{17},71,42,63,1,15,47,5{24},7,35,10,39,51,{30}61,30,25,27,8,40,24,{37}22,
        19,55,13,14,16,4);
        {
        (33,37,26,50,47,11,15,20,23,25,24,14,
        16,22,30,40,5,1,2,6,3,7,9,10,8,4,5,1,2,6,3,7,8,7,33,27,13,37);
        }
        {$IF (ASCUniCodeUsing=1)}
        ASCAppName='Unicode Multi Replacer Lite';
        {$ELSE}
        ASCAppName='Multi Replacer Lite';
        {$IFEND}
        DemoProgramMsj1='This version is limited usege. If you want to do this process you need to buy the full version of MULTI REPLACER.';
     {$ELSE}
        DenemeGunSay=30;
        msgDenemeSurumuSonu='Demo version has expired.';
        clcdegerleri:array [1..43] of integer=(9,11,17,20,33,50,18,23,30,2,13,37,{13.}3,
        25,6,16,26{17},71,42,63,1,15,47,5{24},7,35,10,39,51,{30}61,30,25,27,8,40,24,{37}22,
        19,55,13,14,16,4);
        {
        (33,37,26,50,47,11,15,20,23,25,24,14,
        16,22,30,40,5,1,2,6,3,7,9,10,8,4,5,1,2,6,3,7,8,7,33,27,13,37);
        }
        {$IF (ASCUniCodeUsing=1)}
        ASCAppName='Unicode Multi Replacer - Demo';
        {$ELSE}
        ASCAppName='Multi Replacer - Demo';
        {$IFEND}
        DemoVerFRC=4; //Dosya Kaynaðý Sýnýrý
        DemoVerFRW=8; //Word Sýnýrý
        DemoProgramMsj1='Demo version is limited usege. If you want to do this process you need to buy the full version of MULTI REPLACER.';
     {$IFEND}
     ASCThread_MESSAGE = WM_USER + 4213;
     ASCThread_MESSAGEB = WM_USER + 4214;
     CompilerOpt=1;//0:D7,1:bds
     OleIsZamanAsimi=30000;//30 saniye
     PDFIsZamanAsimi=30000;//30 saniye
     GenFileSizeLimit=1650;//Açýlabilecek en fazla dosya boyutu MB
     GenFileSizeLMaxError='Max filesize must be less than $size'; //tekrar tercüme edilmeli
     GenFileSizeLMinError='Max filesize must be up to 0'; //tekrar tercüme edilmeli
    {$IF (ASCUniCodeUsing=1)}
     RDF_FileSign='Unicode Multi Replacer File';
     ReplacerExt='umrf';
    {$ELSE}
     RDF_FileSign='Multi Replacer File';
     ReplacerExt='mrf';
    {$IFEND}
     RDF_FileList='File List';
     RDF_FileVer='FileVer 1.0';
     RDF_WordList='Word List';
     RDF_RemovedList='Removed Files';
     RegistrationFileName='multirep.req';
     FileDeleteRowsQueryStr='Are you sure want to delete?';
     FileDeleteRowQueryStr='Are you sure want to delete?';
     FileSelectARowMsgStr='A row should be selected';
     FileSelectEmptyMsgStr='File selection list is empty.';
     WordDeleteRowsQueryStr='Are you sure want to delete?';
     WordDeleteRowQueryStr='Are you sure want to delete?';
     WordSelectARowMsgStr='Please select a word';
     CheckCompletedNoWrongRowFond='Check Completed.';
     PageRowCounthint='ever page consist of max 1000 lines.';

     wrongrowfound=' a faulty row is found';
     wrongrowsfound=' faulty row'#39's found';
     wronggroupnumber='Wrong group number. Group number must be 0 or positive value.';  //Grup numarasý yanlýþ. Grup no 0 veya pozitif sayý olmalýdýr.

     SelFileisRemovedFromList='Selected file(s) "$file" is removed from list.';
     openfileversionerr='File version error. Do you want to continue?';
     openfilebadformat='Bad file format !';
     CanNotReadingFile='The file can not be reading ($filename).';
     ErrAddFileSelection='File selection list is empty.';
     QuerySaveAndExit='Do you want to save this project ?';
     msgPreSearchSrcFileList='Getting file list';
     msgStartSearch='Starting search progress...';
     msgSearching='Searching in the files...';
     msgPreFoundFileList='Preparing the list of founded files';
     msgPreMatchList='Preparing List of matches';
     RepFileTypes:Array [0..3] of string=('Single Search','Single Replace','Multi Search','Multi Replace');

     msgOperationTypes:Array [0..3] of string=('Operation Type:Single Search','Operation Type:Single Replace',
     'Operation Type:Multi Search','Operation Type:Multi Replace');
     msgSrcProps='Searching Properties';
     msgSrcPropFileSources='File Sources';
     msgSrcPropSearchDirItm='File Source $FileSourceNo'#13#10+
     'Source Directory="$FileSrc"'#13#10+
     'Inculude FilePattern="$IncFileptr"'#13#10+
     'Exculude File Pattern="$ExcFileptr"'#13#10+
     'Sub Files="$SubFiles"'#13#10+
     'Min.File Size="$MinSize",Max.File Size="$MaxSize"'#13#10+
     'File date of Modify="$Date"';

     msgSrcPropSearchFileItm='File Source $FileSourceNo'#13#10+
     'Source File="$FileSrc"';

     msgSrcPropReplaceDirItm='File Source $FileSourceNo'#13#10+
     'Source Directory="$FileSrc"'#13#10+
     'Destination Dir="$DestDir"'#13#10+
     'Inculude FilePattern="$IncFileptr"'#13#10+
     'Exculude File Pattern="$ExcFileptr"'#13#10+
     'Sub Files="$SubFiles"'#13#10+
     'Min.File Size="$MinSize",Max.File Size="$MaxSize"'#13#10+
     'File Modify Dates="$Date"';
     msgUnlimitedSize='Unlimited';
     msgSrcPropReplaceFileItm='File Source $FileSourceNo'#13#10+
     'Source File="$FileSrc"'#13#10+
     'Destination Directory="$DestDir"';

     msgSrcPropTexts=#13#10+'Search and Replace Informations';
     msgSrcPropSearchTextItem='Text Item $TextNo'#13#10+
     'Search Text="$SearchText"'#13#10+'Case Sensitive="$CaseSens"'#13#10+
     'Regular Expressions="$RegExUse"';
     msgSrcPropReplaceTextItem='Text Item $TextNo'#13#10+
     'Search Text="$SearchText"'#13#10+'Sub Match Text="$SubMatchText"'#13#10+
     'Replace Text="$ReplaceText"'#13#10+
     'Case Sensitive="$CaseSens"'#13#10+
     'Keep Character Case Sensitive="$KeepCaseSens"'#13#10+
     'Regular Expressions="$RegExUse"';
     msgSrcPropRegExInfo=#13#10+'Regular Expressions Properties'#13#10+
     'Greedy="$RegExGreedy",Multi Line="$RegExMultiLine",'+
     'Single Line="$RegExSingleLine",Extended="$RegExExtended"'+
     //'Anchored="$RegExAnchored"'
     #13#10;

     MsgSearchStart='Search operation is started at $Tarih.';
     msgSearchComplete='Search operation is Completed.';
     msgReplaceStarted='Replace operation is started at $Tarih.';
     msgReplaceComplete='Replace operation is Completed at $Tarih..';
     MsgNoReplace='No files replaced.';
     MsgRepFilesandWordsCount='$wcount words replaced in $count files.';
     MsgNoReadFilesCount='$count files could not read.';
     MsgFilesScanned='$count files are scanned';
     MsgFilesMatched='$count files are matched the file patterns';
     MsgFilesSelWithMatches='$count files are selected with matches';
     MsgMatchesCount='$count matched as a result of search operations.';
     MsgSearchStop='Search operation is Completed at $Tarih.';
     MsgSearchTimeTaken='Search time is $Time totaly.';
     msgDosyaAcmaUyarisi='Are you sure open the file "$dosyaadi" ?';
     msgReady='Ready';
     MsgSwitchToMultiForThis='This operation requires multi search system. Do yow want to continue?';
     msgEnterSearchTxt= 'Please enter the search text.';

     ////regtool
     msgGenandSaveLbl='Generate and Save "MRCdata.dat".'; //ozlbsl5
     msgKytArcLbl1='Manuel registration process is done basically with 3 steps. ';//bsl1
     msgKytArcLbl2='';//bsl2
     msgKytArcLbl3='Please cilick the following button,than save the file produced by button to the removable envoirement. ';//bsl3
     msgKytArcLbl4='For example in a flash disk or CD.';//bsl4
     msgSaveMyInfoBtn='Save the file "MRCdata.dat"';//SaveMyInfoBtn
     msgKytArcLbl6='Generate Activation File'; //bsl6
     msgKytArcLbl7='Please click following button to open "MRCdata.dat" on target computer.';//bsl7
     msgKytArcLbl8='Please fill in the gap to correct information and click to "Generate Activation File" button.';//bsl8
     msgGenActCodeBtn='Generate Activation File';//GenActCodeBtn
     msgKytArcLbl9='Notice: You should do this prosess at source computer';//bsl9
     //msgKytArcLbl10='Aktivasyon dosyasýný kullanarak kayýt iþlemini tamamla';//bsl10
     msgKytArcLbl11='Please click following button and chose "activation.dat"  file from Source Computer.';//bsl11
     msgKytAracuyari1='To your entrance information, your registration process '+
     'will do via the internet. Do you accept?';
     {'Girdiðiniz bilgilere göre internet üzerinden kayýt iþleminiz yapýlacaktýr.'+
     'Devam edilsin mi?';  }
     msgKytAracuyari2='Activation file ready. '+
     'Now this file will transfer to be target machine and which use for registration process.';
     msgUyari3='To your chose activation code is not mach this computer.';//'Seçilen activasyon dosyasý bu makinaya ait deðil !';
     msgUyari4='Registration operation completed successfully.'; //ingilizce dogrumu
     msgUyari5=msgKytAracuyari1;

     msgUyari6='Please complete the require information.';
     msgUyari7='The file damaged or incorrect.';

     msgDropDownAreaAck='Put the files here you want to use by Drag&&Drop.';
     msgDropDownAreaLbl='Drag&&Drop Area';
     msgKytOkuHata1='Error ! MultiReplacer default settings can not read from your registry.';
     msgKytYazHata1='Error ! MultiReplacer default settings can not save to your registry';

     msgSelSrcDir='Please select source directory.';
     msgSelDestDir='Please select destination directory.';
     msgSelSrcFile='Please select source file.';


     //repfrmsayfa baþlýklarý
     msgSingleSearchPg='Single Search';  //basit arama sayfa baþlýðý
     msgSingleReplacePg='Single Search';  //basit arama sayfa baþlýðý
     msgFileSelectionPg='File Selection List'; //
     msgWordsPg='Words'; //Words sayfasý;
     msgControlsPg='Controls';
     msgFileListPg='File List';
     msgReportPg='Report';

     msgonmatchedlbl=' on matched';
     msgCheckReplaceOpr='  Check replace operation';
     msgCheckSearchOpr='  Check search operation';

     msgWrongRowsLbl='  False Rows';
     msgCheckResultLbl='  Check Result';
     msgControlPgNotLbl='  Notice: This page is used to find faulty records. '+
     'Especially as results of Regular Expressions there may be some lines that can be seen here faulty '+
     'In this case check the lines seen as faulty. '+
     'If there is any faulty record , start the search operation.';
       {Continue scanning
Bir dosyada bir kez arama yap
Bulunan ilk dosyadan sonra aramayý durdur
Bir dosyada bir kez arama yap. Bulunduðunda aramayý da durdur.
Use Search Starter
Use Search Stopper
    }
     msgOnMatchingCmb1='Continue scanning';
     msgOnMatchingCmb2='Search within one file only once';
     msgOnMatchingCmb3='Stop the search operation after the first file found';
     msgOnMatchingCmb4='Search within one file only once. Stop searching when found';

     msgOnMatchingCmb5='Use Search Starter';
     msgOnMatchingCmb6='Use Search Stopper';


     msgExSelHata1='Error ! Check file sizes ("This size or bigger">=0).';
     msgExSelHata2='Error ! Check file sizes ("This size or smaller">=0).';
     msgExSelHata3='Error ! Check file sizes ("This size or bigger"<"This size or smaller").';

     msgFileModifyAfterChk='Modified on or after';
     msgFileModifyBeforeChk='Modified on or before';

     msgReplacePrjBsl='New Project';
     msgUniRepFileFiltre='Unicode Multi Replacer Files';
     msgMulRepFileFiltre='Multi Replacer Data Files';
     errSrcEqTarget='Source and target file name should not be same "$filename".';
     errWriteErrOnFile='Can not overwrite on the file "$filename".';
     errCSVCharacterbirkarakterolmali='"Seperate Character for csv formats" length error.(only 1 character length).';
     errCantStartBcsWordsReq='This operation Can not start. Because word list is empty.';
     errCantStartChkBcsWordsReq='check operation Can not start. Because word list is empty.';
     errCantStartBcsSearchTextReq=' this operation Can not start. Because "Search Text" is empty.';
     msgLutfenDosyaKaynaklariniEkleyiniz='You must add source files to list.';
     msgKelimeleriEkleyiniz='You must add words to list.';
     ShowInWiewIntval=1/17280;//5 sn aralýkla bulunan bilgiler listelenecek
     PageLineCount=1000;///Bir matchlist sayfasýnda gösterilecek satýr sayýsý

     msgDiffViewErr1=' this Diff view Can not show';
     msgDiffViewErr2='MS Office file´s can not replace operation.';
     msgHexDataTo='Hex Data (To)';
     msgAsciiTo='ASCII Data (To)';
     msgDiffCol='Diff';
     msgDiffView='Diff View';

     msgHexDataFrom='Hex Data (From)';
     msgAsciiDFrom='ASCII Data (From)';
     msgFromData='From Data';
     msgToData='To Data';
     msgToLineNo='To Ln';
     msgFromLineNo='From LN';
     msgHexData='Hex Data';
     msgAsciiData='ASCII Data';
     msgData='Data';
     msgAddress='Address';
     msgTextData='Text Data';
     msgSeksenCTxt='Displays as 80 column';

     ///fileformatSelF formu form uzerinden cevir

     msgExtLines='Matched Lines';
     msgExtWords='matched Words';
     msgBirSaatIcinde='Within an hour';
     msgSearchText='Search Text';
     msgCaseSens='Case Sensitive';
     msgRegExp='Regular Expressions';
     msgSubMatchText='Sub Match Text';
     msgReplaceText='Replace Text';
     msgSelSourceItem='Please select a source item.';

     //diff view
     msgBeforRepTxt='Before Replaced';
     msgAfterRepTxt='After Replaced';
     {

     }
     //command line parametreler
     {
     "F:\Programlar\A Software\Temp" -subs -incptr=*.txt -search=ABBASOV -keepcase -destdir=F:\test -startsearch -SUBMATCHTEXT=bas -NEWTEXT=xyz -StartReplace -AutoClose -hide
     [<MRFile><Search files>] [<Search folders>]
     [-Subs] [-NoSubs] [-IncPtr=<patterns>]
     [-DestDir=<destination>]
     [-ExcPtr=<patterns>]
     [-DMAnyTime] [-DMWithinanhour] [-DMToday] [-DMYesterday] [-DMThisweek] [-DMThismonth] [-DMThisYear]
     [-CDMAfter=<date>] [-CDMBefore=<date>]
     [-MinFileSize=<bytes count>] [-MaxFileSize=<bytes count>]
     [-Search=<text>] [-Case] [-NoCase] [-Regex] [-NoRegex]
     [-RepSubMatch=<text>]
     [-NewText=<text>]
     [-StartSearch] [-StartReplace] [-AutoClose]
     }
     cmdSubs='SUBS';                cmdSSubs='S';                //alt dizinlerle birlikte
     cmdNoSubs='NOSUBS';            cmdSNoSubs='NS';            //alt dizinler hariç
     cmdIncPtr='INCPTR';            cmdSIncPtr='IP';            //dahil edilen dosya paterni
     cmdExcPtr='EXCPTR';            cmdSExcPtr='EP';            //hariç olan dosya paterni
     cmdSearch='SEARCHTEXT';            cmdSSearch='STX';            //Aranacak bilgi
     cmdCase='CASE';                cmdSCase='C';                //küçük büyük harf ayrýmý yap
     cmdNoCase='NOCASE';            cmdSNoCase='NC';            //küçük büyük harf ayrýmý yapma
     cmdKeepCase='KEEPCASE';        cmdSKeepCase='KC';        //küçük buyuk harf yapisini koru
     cmdNoKeepCase='NOKEEPCASE';    cmdSNoKeepCase='NKC';    //küçük büyük harf yapisini koruma
     cmdRegex='REGEX';              cmdSRegex='RX';              //RegEx kullan
     cmdNoRegex='NOREGEX';          cmdSNoRegex='NRX';          //RegEx kullanma
     cmdRepSubMatch='SUBMATCHTEXT'; cmdSRepSubMatch='SMT';  // aranýlan bilgi içeriside deðiþtirilecek bilgi için 2.bir arama ifadesi belirtir
     cmdNewText='REPLACETEXT';          cmdSNewText='RTX';           //Yeni bilgi
     cmdDestDir='DESTDIR';          cmdSDestDir='DD';           //Hedef dizin
     cmdStartSearch='STARTSEARCH';  cmdSStartSearch='STS';   // Aramaya baþla
     cmdStartReplace='STARTREPLACE';cmdSStartReplace='STR'; // Ara ve deðiiþtir
     cmdAutoClose='AUTOCLOSE';      cmdSAutoClose='AC';       // iþlem bitince programý kapat
     cmdIgnoreErrors='IGNERR';      cmdSIgnoreErrors='IE';       // hatalara aldýrma
     cmdHide='HIDE';                cmdSHide='H';                 ///Formlarý gizle(AutoClose gereklidir.
     cmdWordsOnly='WORDSONLY';      cmdSWordsOnly='WO';       // sadece tam kelimelerde ara
     cmdStopAfterMatchThisFile='STOPAFTERFIRSTFOUND'; cmdSStopAfterMatchThisFile='SAMTHIS';  //bulunca aramayý durdur her bir dosya için
     cmdStopAfterMatchAll='STOPAFTERMATCHALL'; cmdSStopAfterMatchAll='SAMALL';  //DÜÞÜNÜLECEK//bulunca aramayý tamamen durdur

     cmdDMAnyTime='DMANYTIME';           cmdSDMAnyTime='DMANY';        //dosya herhangi bir zamanda deðiþtirlmiþ olabilir
     cmdDMWithinanhour='DMWITHINANHOUR'; cmdSDMWithinanhour='DMH';     //dosya 1 saat içerisinde deðiþtirlmiþ olabilir
     cmdDMToday='DMTODAY';               cmdSDMToday='DMD';            //dosya bugun içerisinde deðiþtirlmiþ olabilir
     cmdDMYesterday='DMYESTERDAY';       cmdSDMYesterday='DMY';        //dosya dün deðiþtirlmiþ olabilir
     cmdDMThisweek='DMTHISWEEK';         cmdSDMThisweek='DMW';         //dosya bu hafta deðiþtirlmiþ olabilir
     cmdDMThismonth='DMTHISMONTH';       cmdSDMThismonth='DMM';        //dosya bu ay deðiþtirlmiþ olabilir
     cmdDMThisYear='DMTHISYEAR';         cmdSDMThisYear='DMTY';        //dosya bu yýl deðiþtirlmiþ olabilir
     cmdCDMAfter='CDMAFTER';             cmdSCDMAfter='CDMA';          //dosya ..tarihinden sonra deðiþtirlmiþ olabilir
     cmdCDMDBefore='CDMBEFORE';          cmdSCDMDBefore='CDMB';        //dosya ..tarihinden önce deðiþtirlmiþ olabilir
     cmdMinFileSize='MINFILESIZE';       cmdSMinFileSize='MIN';        //dosya en az .. kb dir
     cmdMaxFileSize='MAXFILESIZE';       cmdSMaxFileSize='MAX';        //dosya en çok .. kb dir

     cmdExtWordFile='MATCHEDWORDSFILE';  cmdSExtWordFile='EXWF';    //Cikartilan kelimelerin yazilacagi dosya
     cmdExtLinesFile='MATCHEDLINESFILE'; cmdSExtLinesFile='EXLF';   //Cikartilan satirlarin yazilacagi dosya
     cmdReportFile='REPORTFILE';           cmdSReportFile='RF';       //Rapor bilgilerinin yazdýrýlacaðý dosya
     ///cmdline parametre hatalarý
     errNoDestDir='-Error:Destiation Directory is empty.'#13#10;
     errNoExcPtr='-Error:Exclude File Patern is empty.'#13#10;
     errNoIncPtr='-Error:Include File Patern is empty.'#13#10;
     errNoExWordFile='-Error:Extracted Words File is empty.'#13#10;
     errNoExLineFile='-Error:Extracted Lines File is empty.'#13#10;
     errNoReportFile='-Error:Report File is empty.'#13#10;
     errNoCMDAfter='-Error:Custom File Modify Date (After) is empty.'#13#10;
     errNoCMDBefore='-Error:Custom File Modify Date (Before) is empty.'#13#10;
     errNoMinFileSize='-Error:Custom file size (Minimum) is empty.'#13#10;
     errNoMaxFileSize='-Error:Custom file size (Maximum) is empty.'#13#10;
     errNoSearch='-Error:Search text is empty.'#13#10;
     errNoRepSubMatchText='-Error:Sub match text is empty.'#13#10;
     errNoNewText='-Error:New text is empty.'#13#10;
     errNoFilesOrDirs='-Error:File or Directory parameter required.';

     svarPatern='@sv';
     svarPFN='@svFULLFILENAME';//Variable Directory+File Name

     svarFileNameNoExt='@svFILENAMENOEXT';
     svarFileNameWithExt='@svFILENAMEWITHEXT';
     svarFileDir='@svFILEDIR';
     //svarFileSubDir='@svFILESUBDIR';  //dosyanýn arama dizini altýndan itibaren alt dizin adý
     svarCurDate='@svCURRENTDATE';
     svarCurTime='@svCURRENTTIME';
     svarCurYear='@svCURRENTYEAR';
     svarCurMonth='@svCURRENTMONTH';
     svarCurDay='@svCURRENTDAY';
     svarFileModifyDate='@svFILEMODIFYDATE';
     svarFEX='@svFILEEX';//File Extension
     svarFileSIZE='@svFILESIZE';//File Size
     svarFMDATE='@svFILEMODIFYDATE';//File Modify Date
     svarFMYEAR='@svFILEMODIFYYEAR';//File Modify Year;
     svarFMMONTH='@svFILEMODIFYMONTH';//File Modify Month;
     svarFMDAY='@svFILEMODIFYDAY';//File Modify Day;
     svarCurCell='@svCURCELL';
     //svarFoundedText='@svFOUNDEDTEXT';
     {
     OzelKodlar='538716801724396839274394294720'+
     '4521854562128892737995737959379592380345814232150965329878434583215621843'+
     '9845626354187377831025897135987426256018974389127956379146980359807654913'+
     '2983497165498724681975621669834259874510326987542698348169739078937903891';
     }
     OzelKodlar='538716801724396839274394294720'+
     '4521854562128892737995737959379592380345814232150965329878434583215621843'+
     '9845626354187377831025897135987426256018974389127956379146980359807654913'+
     '5260383471068273518296807149326931825924351027392641839415236104235178327'+
     '2983497165498724681975621669834259874510326987542698348169739078937903891';

     //Detail View Types
     ascVTNormal=0;
     ascVTHex=1;
     ascVTASC80=3;
     //////////////////
    {$IF (ASCUniCodeUsing=1)}
    MaxMRChar=16384;
    {$ELSE}
    MaxMRChar=32768;
    {$IFEND}
Type
    {$IF (ASCUniCodeUsing=1)}
    ASCMRString=widestring;
    ASCMRChar=widechar;
    {$ELSE}
    ASCMRString=String;
    ASCMRChar=Char;
    {$IFEND}
    TDiffLink=Record
       i, //rowindex
       Op //kayýt tipi 1:aþaðýya kayma durumunda aþaðýdaki satýrlarýn iþaretinde kullanýlýr,
          //           2:Yukarý kayma durumunda aþaðýdaki satýrlarýn iþaretinde kullanýlýr,
       :integer;
    end;
    TMRWordGroup=Record
      GrpNo:integer;
      GrReqDevam:Boolean;
      Gr_StartPos,  //Search Start Pos
      Gr_StopPos,
      GrStartStopStatus //-1:Bilinmiyor,0:Kulanýlmýyor,1:Kullanýlacak-Baþlamadý,2:Kullanýlacak-Baþladý
      :integer;
    End;
    TAppDefRec=Record
      IncFilePtr,ExcFilePtr,
      SourceDir,
      DestDir,
      WarmBeforeOpenPtr,    //Iþletim sistemi ile çift týklanýnca açýlmadan önce uyarýlmasý gerekli dosya paterni (*.exe;*.bat)
      WordsOnlyChars        ///Kelime baþlangýç ve bitiþlerini ayýrmak için kullanýlan karakterler
      :ASCMRString;
      OnExitAskSaveChk,    //çýkýþta kayýt edilsin mi diye uyarsýn mý
      CaseSensChk,KeepCaseChk,RegExUseChk,RegExGreedyChk,RegExMultiLineChk,RegExSingleLineChk,
      RegExExtendedChk,RegExAnchoredChk,
      SubDirs:Boolean;
      FileSizeOption,
      {0:Any Size,1:Up To 1 KB,2:Up To 100 KB,3:Up To 1 MB,4:Over 25 KB,
      5:Over 100 KB,6:Over 1 MB,7:Custom
      }
      MinFileSize,MaxFileSize:int64;
      DateOption:integer;  {0:Any time,1:Within an hour,2:Today,3:Yesterday,4:This week,5:This month,6:This Year,7:Custom}
      MinDate,MaxDate:Double;
      UsePDFFiles,UseOLEAutomation:Boolean;  ///Word ve Excel gibi dosyalari text dosya olarak kullanmak icin
      GenMaxFileSize:integer;  ///Çok büyük dosyalarýn yüklenmesi hafýza hatasýna sebep olduðu ve aramada yavaþlamasýna
      //sebep olmaktadýr. Büyük dosyalarda arama yapmak için bu sayý 1600'e kadar arttýrýlabilir. 

  end;

var
  TempDir,AppPath:ASCMRString;
  appdefaultsrec:TAppDefRec;
  CurrentFormID:integer=1;
  RegSerino,RegKeyVal1,RegKeyVal2,uygulamaadi:ASCMRString;

  RegTarih:Double;
  MainScrTextA,MainScrTextB:TStringList; /////2 sunucudan 2 ayrý script var, hesaplamasý farklý
  Section1,Section2   : TRTLCriticalSection;
implementation

end.
