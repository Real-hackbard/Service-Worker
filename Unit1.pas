unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, ImgList, WinSvc, ShellApi;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    S2: TMenuItem;
    P1: TMenuItem;
    C1: TMenuItem;
    N1: TMenuItem;
    R1: TMenuItem;
    R2: TMenuItem;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    description1: TMenuItem;
    N2: TMenuItem;
    Panel2: TPanel;
    Edit1: TEdit;
    Label3: TLabel;
    I1: TMenuItem;
    U1: TMenuItem;
    N3: TMenuItem;
    E1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChgEtatService(Sender: TObject);
    procedure Rafraichir(Sender: TObject);
    procedure Recreate1Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure description1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure U1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    SC : THandle;
  end;

var
  Form1: TForm1;
  user : Widestring;

const
    SrvAccess = SERVICE_INTERROGATE or SERVICE_PAUSE_CONTINUE or
                SERVICE_START or SERVICE_STOP or SERVICE_QUERY_STATUS;

type
  SERVICE_DESCRIPTION = packed record 
    lpDescription: PWChar; 
  end; 
  PSERVICE_DESCRIPTION = ^SERVICE_DESCRIPTION; 

function QueryServiceConfig2(hService: THandle; dwInfoLevel: DWORD; lpBuffer: Pointer; cbBufSize: DWORD; var 
  pcbBytesNeeded: DWORD): LongBool; stdcall; external 'advapi32.dll' name 'QueryServiceConfig2W';

implementation

uses Unit2, Unit3;

{$R *.dfm}

function  UninstallService(aServiceName: String; aTimeOut: Cardinal): Boolean;
var
    ComputerName: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
    ComputerNameLength, StartTickCount: Cardinal;
    SCM: SC_HANDLE;
    ServiceHandle: SC_HANDLE;
    ServiceStatus: TServiceStatus;

begin
    Result:= False;
    ComputerNameLength:= MAX_COMPUTERNAME_LENGTH + 1;
    if (Windows.GetComputerName(ComputerName, ComputerNameLength)) then
    begin
        SCM:= OpenSCManager(ComputerName, nil, SC_MANAGER_ALL_ACCESS);
        if (SCM <> 0) then
        begin
            try
                ServiceHandle:= OpenService(SCM, PChar(aServiceName), SERVICE_ALL_ACCESS);
                if (ServiceHandle <> 0) then
                begin

                    // make sure service is stopped
                    QueryServiceStatus(ServiceHandle, ServiceStatus);
                    if (not (ServiceStatus.dwCurrentState in [0, SERVICE_STOPPED])) then
                    begin
                        // Stop service
                        ControlService(ServiceHandle, SERVICE_CONTROL_STOP, ServiceStatus);
                    end;

                    // wait for service to be stopped
                    StartTickCount:= GetTickCount;
                    QueryServiceStatus(ServiceHandle, ServiceStatus);
                    if (ServiceStatus.dwCurrentState <> SERVICE_STOPPED) then
                    begin
                        repeat
                            Sleep(1000);
                            QueryServiceStatus(ServiceHandle, ServiceStatus);
                        until (ServiceStatus.dwCurrentState = SERVICE_STOPPED) or ((GetTickCount - StartTickCount) > aTimeout);
                    end;

                    Result:= DeleteService(ServiceHandle);
                    CloseServiceHandle(ServiceHandle);
                end;
            finally
                CloseServiceHandle(SCM);
            end;
        end;
    end;
end;

function InstallService(Machine, ServiceName, DisplayName, FilePath: String): Boolean;
var
  bCreated: Boolean;
  SCManHandle: SC_Handle;
  SvcHandle: SC_Handle;

begin
  //init
  bCreated := False;

  //Service Manager open
  SCManHandle := OpenSCManager(PChar(Machine), nil, SC_MANAGER_ALL_ACCESS);
  if SCManHandle > 0 then begin

    //Service create (Service install)
    SvcHandle := CreateService(SCManHandle, PChar(ServiceName), PChar(DisplayName), SC_MANAGER_CONNECT or SC_MANAGER_ENUMERATE_SERVICE or SC_MANAGER_MODIFY_BOOT_CONFIG or SC_MANAGER_QUERY_LOCK_STATUS or STANDARD_RIGHTS_READ, SERVICE_WIN32_OWN_PROCESS, SERVICE_AUTO_START, SERVICE_ERROR_NORMAL, PChar(FilePath), nil, nil, nil, nil, nil);
    if SvcHandle > 0 then begin

      //Flag set
      bCreated := True;

      //Handle release
      CloseServiceHandle(SvcHandle);
    end;{if}

    //Handle release
    CloseServiceHandle(SCManHandle);
  end;{if}

  //result
  result := bCreated;

end;{InstallService}

function GetServiceExecutablePath(strMachine: string; strServiceName: string): String;
var
  hSCManager,hSCService: SC_Handle;
  lpServiceConfig: PQueryServiceConfigA;
  nSize, nBytesNeeded: DWord;
begin
  Result := '';
  hSCManager := OpenSCManager(PChar(strMachine), nil, SC_MANAGER_CONNECT);
  if (hSCManager > 0) then
  begin
    hSCService := OpenService(hSCManager, PChar(strServiceName), SERVICE_QUERY_CONFIG);
    if (hSCService > 0) then
    begin
      QueryServiceConfig(hSCService, nil, 0, nSize);
      lpServiceConfig := AllocMem(nSize);
      try
        if not QueryServiceConfig(
          hSCService, lpServiceConfig, nSize, nBytesNeeded) Then Exit;
          Result := lpServiceConfig^.lpBinaryPathName;
      finally
        Dispose(lpServiceConfig);
      end;
      CloseServiceHandle(hSCService);
    end;
  end;
end;

function SysErrorMessage(ErrorCode: Integer): string;
var
  Len               : Integer;
  Buffer            : array[0..255] of Char;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
    SizeOf(Buffer), nil);
  while (Len > 0) and (Buffer[Len - 1] in [#0..#32, '.']) do
    Dec(Len);
  SetString(Result, Buffer, Len);
end; 

function GetServiceDesciption(Computer, Servicename: PWChar; var Description: WideString): Boolean;
var 
  sc                : THandle; 
  os                : THandle; 
  sd                : Boolean; 
  dwNeeded          : DWORD; 
  Buffer            : Pointer; 
begin 
  dwNeeded := 0; 
  Buffer := nil; 
  sc := OpenSCManagerW(Computer, nil, SC_MANAGER_CONNECT); 
  if sc <> 0 then 
  begin 
    os := OpenServiceW(sc, Servicename, SERVICE_QUERY_CONFIG); 
    if os <> 0 then 
    begin 
      sd := QueryServiceConfig2(os, 1, nil, 0, dwNeeded); 
      if (not sd) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then 
      begin 
        try 
          GetMem(Buffer, dwNeeded); 
          result := QueryServiceConfig2(os, 1, Buffer, dwNeeded, dwNeeded); 
          if result then 
          begin 
            Description := PSERVICE_DESCRIPTION(Buffer)^.lpDescription; 
          end; 
        finally 
          FreeMem(Buffer, dwNeeded); 
        end; 
      end 
      else 
        result := False; 
    end 
    else 
      result := False; 
  end 
  else 
    result := False;
end;

function GetUsername: String;
var
  Buffer: array[0..255] of Char;
  Size: DWord;
begin
  Size := SizeOf(Buffer);
  if not Windows.GetUserName(Buffer, Size) then
    RaiseLastOSError; //RaiseLastWin32Error; {Bis D5};
  SetString(Result, Buffer, Size - 1);
end;

function CurrState(State : dword) : string;
Begin
  Case State Of
    SERVICE_STOPPED: Result := 'STOP';
    SERVICE_START_PENDING: Result := 'starting';
    SERVICE_STOP_PENDING: Result := 'stopping';
    SERVICE_RUNNING: Result := 'RUN';
    SERVICE_CONTINUE_PENDING: Result := 'continuing';
    SERVICE_PAUSE_PENDING: Result := 'pausing';
    SERVICE_PAUSED: Result := 'PAUSE';
  End;
End;

function ErrSt(Err : dword) : string;
Begin
  Case Err of
    SERVICE_ERROR_IGNORE: Result := 'ignore';
    SERVICE_ERROR_NORMAL: Result := 'normal';
    SERVICE_ERROR_SEVERE: Result := 'SEVERE';
    SERVICE_ERROR_CRITICAL: Result := 'CRITICAL';
   else  Result := '?';
  End;
End;

function StartSt(St : dword) : string;
Begin
  Case St of
    SERVICE_BOOT_START   : Result := 'BOOT';
    SERVICE_SYSTEM_START : Result := 'SYSTEM';
    SERVICE_AUTO_START   : Result := ' auto ';
    SERVICE_DEMAND_START : Result := 'Manual';
    SERVICE_DISABLED     : Result := 'Disabled';
   else  Result := '?';
  End;
End;

procedure TForm1.FormCreate(Sender: TObject);
begin
  user := GetUsername;
  ListView1.DoubleBuffered := true;
  SC := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  Recreate1Click(Sender);
  StatusBar1.Panels[2].Text := 'Service found : ' + IntToStr(ListView1.Items.Count);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  CloseServiceHandle(SC);
end;

procedure TForm1.ChgEtatService(Sender: TObject);
var x : Integer;
    OS : THandle;
    SrvName : string;
    lpServiceStatus : _SERVICE_STATUS;
begin
  Screen.Cursor := crHourGlass;
  Timer1.Enabled := False;
  With ListView1, Items do
  If Count > 0 Then
    for x := 0 to Count-1 do
    With Item[x] do
      If Selected Then
      Begin
        SrvName := SubItems.Strings[0];
        OS := OpenService(SC, PChar(SrvName), SrvAccess);
        If Sender = S1 Then StartService(OS, 0, PChar(nil^))
        else if Sender = S2 Then ControlService(OS, SERVICE_CONTROL_STOP, lpServiceStatus)
        else if Sender = C1 Then ControlService(OS, SERVICE_CONTROL_CONTINUE, lpServiceStatus)
        else if Sender = P1 Then ControlService(OS, SERVICE_CONTROL_PAUSE, lpServiceStatus);
        CloseServiceHandle(OS);
      End;

      //R2.OnClick(self);
      R1.OnClick(self);
      Application.ProcessMessages;
      Sleep(1000);
      R2.OnClick(self);
  //Timer1.Enabled := True;
  Screen.Cursor := crDefault;
end;

procedure TForm1.Rafraichir(Sender: TObject);
var Tbl : array[1..500] of TEnumServiceStatus;
    card, card2, nbsvc, x : cardinal;

  function TrouverItem(Caption : string) : TListItem;
  var n : Integer;
  begin
    n := Memo1.Lines.IndexOf(Caption);
    With ListView1 do
      TrouverItem := Items.Item[n];
  end;

begin
  card2 := 0;
  nbsvc := 0;
  EnumServicesStatus(SC, SERVICE_WIN32, SERVICE_STATE_ALL,
    Tbl[1], SizeOf(Tbl), card, nbsvc, card2);
  If nbsvc > 0 Then
  for x := 1 to nbsvc do
    With Tbl[x], ServiceStatus do
    try
      TrouverItem(lpServiceName).SubItems.Strings[1] :=
        CurrState(dwCurrentState);
    except
      showmessage('Unable to Update '+
          lpServiceName+'. Recreate the list !');
    end;
    ListView1.OnClick(Sender);
end;

procedure TForm1.Recreate1Click(Sender: TObject);
var Tbl : array[1..500] of TEnumServiceStatus;
    card, card2, nbsvc, x : cardinal;
    item : TListItem;

    description : WideString;
    s : Widestring;
begin
  ListView1.Clear;
  Memo1.Clear;

  card2 := 0;
  nbsvc := 0;
  EnumServicesStatus(SC, SERVICE_WIN32, SERVICE_STATE_ALL,
    Tbl[1], SizeOf(Tbl), card, nbsvc, card2);
  If nbsvc > 0 Then

  try

  item := ListView1.Items.Add;
  item.ImageIndex := 0;

  for x := 1 to nbsvc do
    With Tbl[x], ServiceStatus, ListView1.Items, Add do
    Begin
        Caption := StrPas(lpDisplayName);
        SubItems.Add(StrPas(lpServiceName));

     if CurrState(dwCurrentState) = 'STOP' then item[x].ImageIndex := 0;
     if CurrState(dwCurrentState) = 'RUN' then item[x].ImageIndex := 1;
     if CurrState(dwCurrentState) = 'PAUSE' then item[x].ImageIndex := 2;

        SubItems.Add(CurrState(dwCurrentState));

        s := lpServiceName;
        GetServiceDesciption(PWideChar(user), PWideChar(s), description);
        SubItems.Add(PWideChar(description));
     Memo1.Lines.Add(lpServiceName);
    End;

    finally
    item.Free;
    Timer1.Enabled := true;
    Sleep(300);
    StatusBar1.Panels[2].Text := 'Service found : ' + IntToStr(ListView1.Items.Count);
    end;
    Timer1.Enabled := false;
end;

procedure TForm1.ListView1Click(Sender: TObject);
var
  ServicePath : string;
begin
  if ListView1.Selected <> nil then begin
  StatusBar1.Panels[1].Text := ListView1.Selected.Caption;
  StatusBar1.Panels[0].Text := ListView1.Items[ListView1.ItemIndex].SubItems[1];
  end;

  try
    ServicePath := GetServiceExecutablePath('', ListView1.Items[ListView1.ItemIndex].SubItems[0]);
    Edit1.Text := ServicePath;
  except
  end;

end;

procedure TForm1.ListView1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
   with Sender.Canvas do begin
    if SubItem = 1 then Font.Color := clBlue;
    if SubItem = 2 then Font.Color := clMaroon;
    if SubItem = 3 then Font.Color := clBlack;
  end;
end;

procedure TForm1.description1Click(Sender: TObject);
var 
  description : WideString;
  s : Widestring;
begin
  if ListView1.Selected <> nil then begin
  s := ListView1.Items[ListView1.ItemIndex].SubItems[0];
  end;

  if not GetServiceDesciption(PWideChar(user), PWideChar(s), description) then
  begin
    Writeln(SysErrorMessage(GetLastError));
    Readln;
  end
  else
    MessageBoxW(0, PWideChar(description), 'Service Description', 0);
end;

procedure TForm1.I1Click(Sender: TObject);
begin
  try
    form2 := TForm2.Create(nil);
    form2.ShowModal;
  finally
  end;
end;

procedure TForm1.U1Click(Sender: TObject);
begin
  try
    form3 := TForm3.Create(nil);
    form3.ShowModal;
  finally
  end;
end;

procedure TForm1.E1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open','services.msc', nil, nil, SW_SHOWNORMAL) ;
end;

end.
