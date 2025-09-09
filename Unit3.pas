unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WinSVC, ComCtrls, StdCtrls, Unit1;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

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

procedure TForm3.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  Beep;
  if Edit1.Text = '' then begin
  MessageDlg('Type Service to Uninstall.',mtInformation, [mbOK], 0);
  Exit;
  end;

  if MessageBox(Handle,'Uninstall Service'+#13+
                'Are you sure, would you like to continue?','Bestätigen',MB_YESNO) = IDYES then
    BEGIN
      Screen.Cursor := crHourGlass;
      UninstallService(PChar(Edit1.Text), 10);
      StatusBar1.Panels[1].Text := 'Progress, please wait..';
      Sleep(500);
    END;

    Form1.StatusBar1.Panels[2].Text := 'Service found : ' + IntToStr(Form1.ListView1.Items.Count);
    Screen.Cursor := crDefault;
    MessageDlg('Restart Program to Update Service List.',mtInformation, [mbOK], 0);
    StatusBar1.Panels[1].Text := 'Progress finish.';
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Edit1.Enabled := false;
  try
    Edit1.Text := Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[0];
  except
  end;
end;

procedure TForm3.RadioButton1Click(Sender: TObject);
begin
  Edit1.ReadOnly := true;
  Edit1.Enabled := false;
  try
    Edit1.Text := Form1.ListView1.Items[Form1.ListView1.ItemIndex].SubItems[0];
  except
  end;
end;

procedure TForm3.RadioButton2Click(Sender: TObject);
begin
  Edit1.ReadOnly := false;
  Edit1.Enabled := true;
end;

end.
