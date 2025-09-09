unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Unit1, WinSVC, StdCtrls, ComCtrls, XPMan;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
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

      //Handle freigeben
      CloseServiceHandle(SvcHandle);
    end;{if}

    //Handle
    CloseServiceHandle(SCManHandle);
  end;{if}

  //Result
  result := bCreated;
  Sleep(300);
  Screen.Cursor := crDefault;
  Form2.StatusBar1.Panels[1].Text := 'Service : ' + Form2.Edit2.Text + ' installed done.';
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Edit1.Text := GetUsername;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if (Edit1.Text = '') or (Edit2.Text = '') or (Edit3.Text = '') or
     (Edit4.Text = '') then begin
     Beep;
     MessageDlg('Fill all Boxes to Install Service.',mtInformation, [mbOK], 0);
     Exit;
  end;

  if not FileExists(Edit4.Text) then begin
     Beep;
     MessageDlg('File dont exists, abort install Service.',mtInformation, [mbOK], 0);
     Exit;
  end;

  if MessageBox(Handle,'This will Install Service : ' +#13+
                'Are you sure, would you like to continue?','Confirm',MB_YESNO) = IDYES then
  BEGIN
  Screen.Cursor := crHourGlass;
  StatusBar1.Panels[1].Text := 'Init Service..,please wait.';
  InstallService(PChar(Edit1.Text), Edit2.Text, Edit3.Text, Edit4.Text);
  END;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
 if OpenDialog1.Execute then Edit4.Text := OpenDialog1.FileName;
end;

end.
