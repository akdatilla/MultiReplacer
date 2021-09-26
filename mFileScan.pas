{
----------------------------------------------------------
MAS-CompMaker was used to generate this code
MAS-CompMaker, 2000-2001® Mats Asplund
----------------------------------------------------------

Component Name: TmFileScan
        Author: Mats Asplund
      Creation: 2002-10-10
       Version: 3.0
   Description: A component that scans a whole device or part of it,
                and outputs the fullpath filenames, corresponding to
                searchfilter settings. Multiple filters can be set.
        Credit:
        E-mail: masprod@telia.com
          Site: http://go.to/masdp
  Legal issues: All rights reserved 2002® by Mats Asplund

         Usage: This software is provided 'as-is', without any express or
                implied warranty.  In no event will the author be held liable
                for any  damages arising from the use of this software.

                Permission is granted to anyone to use this software for any
                purpose, including commercial applications, and to alter it
                and redistribute it freely, subject to the following
                restrictions:

                1. The origin of this software must not be misrepresented,
                   you must not claim that you wrote the original software.
                   If you use this software in a product, an acknowledgment
                   in the product documentation would be appreciated but is
                   not required.

                2. Altered source versions must be plainly marked as such, and
                   must not be misrepresented as being the original software.

                3. This notice may not be removed or altered from any source
                   distribution.

                4. If you decide to use this software in any of your applications.
                   Send me an EMail and tell me about it.

Quick Reference:
  TmFileScan inherits from TComponent.

    SearchResult:   StringList with the resulting files.

  Key-Properties:
    Paths:          Which filepaths to scan (TStringList). Multiple paths can be
                    used.

    Filters:        The filesearch roules. Use wildcard. Multiple filters can be
                    used.
                    Ex.
                      mFileScan1.Paths.Clear;
                      mFileScan1.Filters.Clear;
                      mFileScan1.Paths.Add('c:\');
                      mFileScan1.Paths.Add('c:\tmp');
                      mFileScan1.SubDirs:= false;
                      mFileScan1.Filters.Add('a*.exe');
                      mFileScan1.Filters.Add('*a*.txt');
                      mFileScan1.Start;

                      ...will search on root-dir and c:\tmp for exe-files
                      with filenames beginning with the letter 'a' and all
                      text-files with an 'a' in the filename.

    SubDirs:        If true, subdirectories will be scanned.

  Key-Events:
    OnFileFound:    Use this event if you want the resulting filelist to be
                    updated each time a file is found.

    OnReady:        Use this event if you want the whole filelist to be
                    updated when the scan is ready.

  Key-Methods:
    Start:          Starts the filescan.

    Pause:          Pauses the filescan. Searchthread is suspended.

    Resume:         Resumes the filescan. Searchthread is resumed.

--------------------------------------------------------------------------------
}
unit mFileScan;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,RepLib;

type
  TmFileScan = class;

  TOnFileFoundEvent =
    procedure(Sender: TObject; FileName: string) of object;

  TOnReadyEvent =
    procedure(Sender: TObject; SearchResult: TStringList) of object;

  TSearchThread = class(TThread)
  private
    ffOwner: TmFileScan;
    ffSubDir: Boolean;
    ffFilters: TStrings;
    ffPaths: TStrings;
    ffFileFound: TFileName;
    ffOnFileFound: TOnFileFoundEvent;
    ffOnReady: TOnReadyEvent;
    ffList: TStringList;
    procedure FileFound;
    procedure Ready;
  protected
    constructor Create(Owner: TmFileScan; SubDir, Started: Boolean;
      FilePaths, Filter: TStrings; fOnFileFound: TOnFileFoundEvent;
      fOnReady: TOnReadyEvent);
    procedure Execute; override;
  end;

  TmFileScan = class(TComponent)
  private
    SearchThread: TSearchThread;
    fOnFileFound: TOnFileFoundEvent;
    fOnReady: TOnReadyEvent;
    fFilters: TStrings;
    fSubDir: Boolean;
    fAbout: string;
    fPaths: TStrings;
    fPaused: Boolean;
    fStarted: Boolean;
    procedure SetAbout(Value: string);
    procedure SetFilters(const Value: TStrings);
    procedure SetPaths(const Value: TStrings);
    { Private declarations }
  public
    SearchResult: TStringList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure Pause;
    procedure Resume;
    property Started: Boolean read fStarted;
    { Private declarations }
  published
    property Paths: TStrings read fPaths write SetPaths;
    property Filters: TStrings read fFilters write SetFilters;
    property SubDirs: Boolean read fSubDir write fSubDir;
    property OnFileFound: TOnFileFoundEvent read fOnFileFound write
      fOnFileFound;
    property OnReady: TOnReadyEvent read fOnReady write fOnReady;
    property About: string read fAbout write SetAbout;
    { Published declarations }
  end;

procedure Register;

implementation

constructor TmFileScan.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fFilters:= TStringList.Create;
  fPaths:= TStringList.Create;
  SearchResult:= TStringList.Create;
  fSubDir:= true;
  fPaused:= false;
  fAbout:= 'Version 3.0, 2002® Mats Asplund, Site: http://go.to/masdp';
end;

destructor TmFileScan.Destroy;
begin
  fFilters.Free;
  fPaths.Free;
  SearchResult.Free;
  inherited Destroy;
end;

procedure TmFileScan.SetAbout(Value: string);
begin
  Exit;
end;

procedure TmFileScan.SetFilters(const Value: TStrings);
begin
  fFilters.Assign(Value);
end;

procedure TmFileScan.Start;
begin
  if not fStarted then
    SearchThread:=
      TSearchThread.Create(Self, fSubDir, fStarted, fPaths, fFilters,
      fOnFileFound, fOnReady);
  fStarted:= true;
end;

procedure TmFileScan.Pause;
begin
  if not fPaused then
  begin
    fPaused:= true;
    SearchThread.Suspend;
  end;
end;

procedure TmFileScan.Resume;
begin
  if fPaused then
  begin
    fPaused:= false;
    SearchThread.Resume;
  end;
end;

procedure TmFileScan.SetPaths(const Value: TStrings);
begin
  fPaths.Assign(Value);
end;

{ TSearchThread }

constructor TSearchThread.Create(Owner: TmFileScan; SubDir, Started: Boolean;
  FilePaths, Filter: TStrings; fOnFileFound: TOnFileFoundEvent;
  fOnReady: TOnReadyEvent);
begin
  inherited Create(true);
  ffOwner:= Owner;
  ffPaths:= TStringList.Create;
  ffFilters:= TStringList.Create;
  ffSubDir:= SubDir;
  ffPaths.Text:= FilePaths.Text;
  ffFilters.Text:= Filter.Text;
  ffOnFileFound:= fOnFileFound;
  ffOnReady:= fOnReady;
  FreeOnTerminate:= true;
  Resume;
end;

procedure TSearchThread.Execute;
var
  Spec: string;
  n, q: Integer;

  function BackSlashFix(Folder: string): string;
  begin
    if Copy(Folder, Length(Folder), 1) = '\' then
    begin
      Result:= Folder;
      Exit;
    end
    else
      Result:= Folder + '\';
  end;

  procedure RFindFile(const Folder: string);
  var
    SearchRec: TSearchRec;
  begin
    if FindFirst(Folder + Spec, faAnyFile, SearchRec) = 0 then
    begin
      try
        repeat
          if (SearchRec.Attr and faDirectory = 0) or
            (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
          begin
            ffFileFound:= Folder + SearchRec.Name;
            ffList.Add(ffFileFound);
            Synchronize(FileFound);
          end;
        until (FindNext(SearchRec) <> 0);
      except
        SysUtils.FindClose(SearchRec);
        raise;
      end;
      SysUtils.FindClose(SearchRec);
    end;
    if ffSubDir then
    begin
      if FindFirst(Folder + '*', faAnyFile, SearchRec) = 0 then
      begin
        try
          repeat
            if ((SearchRec.Attr and faDirectory) <> 0) and
              (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
              RFindFile(Folder + SearchRec.Name + '\');
          until FindNext(SearchRec) <> 0;
        except
          SysUtils.FindClose(SearchRec);
          raise;
        end;
        SysUtils.FindClose(SearchRec);
      end;
    end;
  end; // procedure RFindFile inside of FindFile

begin // function FindFile
  ffList:= TStringList.Create;
  try
    while not Terminated do
    begin
      for q:= 0 to ffPaths.Count - 1 do
      begin
        for n:= 0 to ffFilters.Count - 1 do
        begin
          Spec:= ffFilters[n];
          RFindFile(BackSlashFix(ffPaths[q]));
        end;
      end;
      Synchronize(Ready);
      Terminate;
    end;
  finally
    ffList.Free;
  end;
end;

procedure TSearchThread.FileFound;
begin
  if Assigned(ffOnFileFound) then
    ffOnFileFound(Self, ffFileFound);
end;

procedure TSearchThread.Ready;
begin
  ffOwner.fStarted:= false;
  if Assigned(ffOnReady) then
    ffOnReady(Self, ffList);
end;

procedure Register;
begin
  RegisterComponents('MAs Prod.', [TmFileScan]);
end;

end.

