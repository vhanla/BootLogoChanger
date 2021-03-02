{
B10t Logo Changer for Windows 10
--------------------------------
This is an update for Windows 10, which has different approach, not so different but
it needs to modify some other files, too.

}
unit BootLogoChanger_src;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GR32_Image, Vcl.ExtDlgs, ShellApi, AccCtrl, AclApi,
  DragDrop, DragDropContext, DragDropHandler, DropTarget, DragDropFile,
  DropHandler, DropComboTarget, GR32_Resamplers, gr32, GR32_Layers, gr32_polygons, shlobj,
  Vcl.Buttons, imagehlp, Vcl.ExtCtrls, Vcl.ComCtrls, System.Types, JclSysInfo,
  JclCompression;

const
  {$EXTERNALSYM WIN_CERT_REVISION_1_0}
  WIN_CERT_REVISION_1_0 = $0100;
  CERT_SECTION_TYPE_ANY = $FF; // any certificate type
  CERT_NAME_SIMPLE_DISPLAY_TYPE = 4;
  PKCS_7_ASN_ENCODING = $00010000;
  X509_ASN_ENCODING = $00000001;

  WINTRUST_ACTION_GENERIC_VERIFY_V2: TGUID = '{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}';
  WTD_CHOICE_FILE = 1;
  WTD_REVOKE_NONE = 0;
  WTD_UI_NONE = 2;

type

  PWinTrustFileInfo = ^TWinTrustFileInfo;
  TWinTrustFileInfo = record
    cbStruct: DWORD;          // = SizeOf(WINTRUST_FILE_INFO)
    pcwszFilePath: PWideChar; // required, file name to be verified
    hFile: THandle;           // optional, open handle to pcwszFilePath
    pgKnownSubject: PGUID;    // optional, fill if the subject type is known
  end;

  PWinTrustData = ^TWinTrustData;
  TWinTrustData = record
    cbStruct: DWORD;
    pPolicyCallbackData: Pointer;
    pSIPClientData: Pointer;
    dwUIChoice: DWORD;
    fdwRevocationChecks: DWORD;
    dwUnionChoice: DWORD;
    pFile: PWinTrustFileInfo;
    dwStateAction: DWORD;
    hWVTStateData: THandle;
    pwszURLReference: PWideChar;
    dwProvFlags: DWORD;
    dwUIContext: DWORD;
  end;

  TSeleccionador = class(TRubberbandLayer)
    private
      FFillColor: TColor32;
      FLineColor: TColor32;
      procedure SetFillColor(Value: TColor32);
      procedure SetLineColor(Value: TColor32);
      procedure GetResize(Sender: TObject;
        const OldLocation: TFloatRect;
        var NewLocation: TFloatRect;
        DragState: TRBDragState;
        Shift: TShiftState);
    protected
      procedure Paint(Buffer: TBitmap32); override;
    public
      property FillColor: TColor32 read FFillColor write SetFillColor;
      property LineColor: TColor32 read FLineColor write SetLineColor;
  end;

type
  TWin8BootLogo = class(TForm)
    lstOriginalPics: TListBox;
    ImgView321: TImgView32;
    btnCancel: TButton;
    btnBackupRestore: TButton;
    btnApply: TButton;
    lblBackupedFiles: TLabel;
    btnLoadPic: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Label2: TLabel;
    btnPreview: TButton;
    DropComboTarget1: TDropComboTarget;
    lblOriginalPics: TLabel;
    lblEditedPictures: TLabel;
    lstEditedPics: TListBox;
    btnCreatePictures: TButton;
    btnReload: TButton;
    BalloonHint1: TBalloonHint;
    btnRePack: TButton;
    btnTestMode: TButton;
    Label5: TLabel;
    Label6: TLabel;
    btnHelp: TButton;
    pages: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    lblTestSigning: TLabel;
    lblTestSigningDescription: TLabel;
    btnBkpShell32Mui: TButton;
    btnPatchShell32Mui: TButton;
    btnBkpBasebrdmui: TButton;
    btnPatchBasebrdMui: TButton;
    lstShell32Mui: TListBox;
    lstBasebrdMui: TListBox;
    btnRestartExplorer: TButton;
    btnExit: TButton;
    PageControl1: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Splitter1: TSplitter;
    lblOS: TLabel;
    lblBIOS: TLabel;
    lblTest: TLabel;
    lblCurShell: TLabel;
    lblBkpShell: TLabel;
    lblBootres: TLabel;
    lblBkpBootres: TLabel;
    mmLog: TMemo;
    cbVignette: TCheckBox;

    procedure lstOriginalPicsDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoadPicClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnBackupRestoreClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure DropComboTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: Integer);
    procedure btnReloadClick(Sender: TObject);
    procedure btnCreatePicturesClick(Sender: TObject);
    procedure lstEditedPicsDblClick(Sender: TObject);
    procedure btnRePackClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTestModeClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnPatchShell32MuiClick(Sender: TObject);
    procedure btnPatchBasebrdMuiClick(Sender: TObject);
    procedure btnBkpShell32MuiClick(Sender: TObject);
    procedure btnBkpBasebrdmuiClick(Sender: TObject);
    procedure btnRestartExplorerClick(Sender: TObject);
  private
    { Private declarations }
    procedure AppMsg(var msg: TMsg; var Handled: Boolean);
    procedure LogMsg(const text: String);
    function IsCodeSigned(const fn: string): Boolean;
    function IsCompanySigningCertificate(const fn, cn: string): Boolean;
    function GetCertCompanyName(const fn: string): string;
    function StripAuthenticode(const fn: string): Boolean;
  public
    { Public declarations }
    Seleccionador: TSeleccionador;
  end;

var
  Back: TForm;
  Win8BootLogo: TWin8BootLogo;
  BootResDLL : string;
  OriginalDLL : string;

  ElevationType: Integer;
  Elevation: DWord;

  Domain, Username : string;

  WorkFolder: string;
  LoadedPicture: string;

  ResLanguage: Word;
  ResLanguageMUI: Word;

  anchos: array [0..5] of integer =
  (
  82,
  102,
  129,
  98,
  242,
  321
  );
  altos : array [0..5] of integer =
  (
  72,
  90,
  115,
  115,
  214,
  284
  );
  nombres : array [0..5] of string =
  (
  'winlogo1.bmp',
  'winlogo2.bmp',
  'winlogo3.bmp',
  'winlogo3n.bmp',
  'winlogo4.bmp',
  'winlogo5.bmp'
  );

const
  About = '8oot Logo Changer 1.2'+
          #13'Copyright © Codigobit 2013 Victor Alberto Gil <vhanla>'+
          #13'All rights reserved'+
          #13+
          #13+'Acknowledgements: (third party tools used)'+
          #13+'Signer written by Jeff Bush - Codeforlife.com'+
//          #13+'Delcert written by Depreed' +
          #13+'Sevenzip library by 7-zip.org © Igor Pavlov'+
          #13+'And Krutonium at Winmatrix'+
          #13+
          #13'This application should only be distributed at codigobit.net';

  Help = '8oot Logo How to use:'+
         #13+
         #13'0: MAKE A BACKUP!'+
         #13'1: Open or drop any picture you want to use as the Windows 8/8.1 boot logo'+
         #13'2: Select the area to use and create the bitmaps with button [>]'+
         #13'3: Generate the bootres.dll, this will be located in a temporary folder'+
         #13'4: Click Apply and this will replace it'+#13+
         #13'Notice: Testsigning mode must be enabled to see it working, otherwise it will be blank :-/'+
         #13#13'That''s all, now you will be able to watch your custom boot logo.'+
         #13#13'More at http://codigobit.net';


const
  FILE_READ_DATA = $0001;
  FILE_WRITE_DATA = $0002;
  FILE_APPEND_DATA = $0004;
  FILE_READ_EA = $0008;
  FILE_WRITE_EA = $0010;
  FILE_EXECUTE = $0020;
  FILE_READ_ATTRIBUTES = $0080;
  FILE_WRITE_ATTRIBUTES = $0100;
  FILE_GENERIC_READ = (STANDARD_RIGHTS_READ or FILE_READ_DATA or
    FILE_READ_ATTRIBUTES or FILE_READ_EA or SYNCHRONIZE);
  FILE_GENERIC_WRITE = (STANDARD_RIGHTS_WRITE or FILE_WRITE_DATA or
    FILE_WRITE_ATTRIBUTES or FILE_WRITE_EA or FILE_APPEND_DATA or SYNCHRONIZE);
  FILE_GENERIC_EXECUTE = (STANDARD_RIGHTS_EXECUTE or FILE_READ_ATTRIBUTES or
    FILE_EXECUTE or SYNCHRONIZE);
  FILE_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or $1FF;



implementation

{$R *.dfm}

uses sevenzip, frmPreview_src, functions;

function IsTestSigningModeOn: Boolean;
var
  rel: DWORD;
  sci: TSystemCodeIntegrityInformation;
  br: ULONG;
begin
  Result := False;
  sci.Length := SizeOf(sci);
  rel := NTQuerySystemInformation(SystemCodeIntegrityInformation, @sci, SizeOf(sci), @br);
  //showmessage(inttohex(rel));
  if Succeeded(rel) then
  begin
    //showmessage(inttohex(sci.CodeIntegrityOptions));
    if sci.CodeIntegrityOptions and CODEINTEGRITY_OPTION_TESTSIGN = CODEINTEGRITY_OPTION_TESTSIGN then
    begin
      Result := True;
    end;
  end;
end;

function IsUEFI: Boolean;
begin
  try
    GetFirmwareEnvironmentVariableA('', '{00000000-0000-0000-0000-000000000000}', nil, 0);
    if (GetLastError = ERROR_INVALID_FUNCTION) then
      Result := False // Legacy BIOS
    else
      Result := True;
  except
    //on E: Exception do
  end;
end;

function GetWindowsDir: string;
const
  (* The length of the directory buffer. Usually 64 or even 16 is enough
    **
    ** Must be DWORD type.
  *)
dwLength: DWORD = MAX_PATH;
var
pcWinDir: PChar;
begin
  GetMem(pcWinDir, dwLength);
  //GetSystemDirectory(pcWinDir, dwLength);
  GetWindowsDirectory(pcWinDir,dwLength);
  Result := string(pcWinDir)+'\';
  FreeMem(pcWinDir, dwLength);
end;

function Is64BitOS: Boolean;
type
  TIsWow64Process = function(Handle:THandle; var IsWow64 : BOOL) : BOOL; stdcall;
var
  hKernel32 : Integer;
  IsWow64Process : TIsWow64Process;
  IsWow64 : BOOL;
begin
  // we can check if the operating system is 64-bit by checking whether
  // we are running under Wow64 (we are 32-bit code). We must check if this
  // function is implemented before we call it, because some older versions
  // of kernel32.dll (eg. Windows 2000) don't know about it.
  // see http://msdn.microsoft.com/en-us/library/ms684139%28VS.85%29.aspx
  Result := False;
  hKernel32 := LoadLibrary('kernel32.dll');
  if (hKernel32 = 0) then RaiseLastOSError;
  @IsWow64Process := GetProcAddress(hkernel32, 'IsWow64Process');
  if Assigned(IsWow64Process) then begin
    IsWow64 := False;
    if (IsWow64Process(GetCurrentProcess, IsWow64)) then begin
      Result := IsWow64;
    end
    else RaiseLastOSError;
  end;
  FreeLibrary(hKernel32);
end;

//http://www.swissdelphicenter.ch/en/showcode.php?id=1241
//usage : if MyMessageDialog('How much...?', mtConfirmation, mbOKCancel,
//    ['1', '2']) = mrOk then
//    ShowMessage('"1" clicked')
//  else
//    ShowMessage('"2" clicked');
function MyMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; Captions: array of string): Integer;
var
  aMsgDlg: TForm;
  i: Integer;
  dlgButton: TButton;
  CaptionIndex: Integer;
begin
  { Create the Dialog }
  { Dialog erzeugen }
  aMsgDlg := CreateMessageDialog(Msg, DlgType, Buttons);
  captionIndex := 0;
  { Loop through Objects in Dialog }
  { Über alle Objekte auf dem Dialog iterieren}
  for i := 0 to aMsgDlg.ComponentCount - 1 do
  begin
   { If the object is of type TButton, then }
   { Wenn es ein Button ist, dann...}
    if (aMsgDlg.Components[i] is TButton) then
    begin
      dlgButton := TButton(aMsgDlg.Components[i]);
      if CaptionIndex > High(Captions) then Break;
      { Give a new caption from our Captions array}
      { Schreibe Beschriftung entsprechend Captions array}
      dlgButton.Caption := Captions[CaptionIndex];
      Inc(CaptionIndex);
    end;
  end;
  Result := aMsgDlg.ShowModal;
end;


{--------[MUI START]---------}

{There is a MUI file blocking the updateresource}
procedure ExtractMUI(muifile: string);
var
  rs: TResourceStream;
  h: hinst;
begin
  h:=LoadLibrary(pchar(muifile));
  try
    rs:=TResourceStream.CreateFromID(h,1,'MUI');
    try
      rs.Position:=0;
      rs.SaveToFile(pchar(WorkFolder+'\'+ExtractFileName(muifile)+'.lock'));
    finally
      rs.Free;
    end;
  finally
    FreeLibrary(h);
  end;
end;

{Delete MUI}
function EnumResLangProcMUI(hModule: HMODULE; lpType, lpName: PChar; wIDLanguage: Word;
  lParam: Longint): BOOL; stdcall;
begin
  ResLanguageMUI := wIDLanguage;
  Result := False;
end;
(*
Function: GETRESOURCELANGUAGE from imageres.dll
Returns: if there was a language value
Stores: ResLanguage keeps the language
*)
function GetResourceLanguageMUI(muifile: string):boolean;
var
  hModule: THandle;
  ErrorMode: UINT;
begin
  Result:=True;

  ErrorMode:=SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    hModule := LoadLibrary(PChar(muifile));
  finally
    SetErrorMode(ErrorMode);
  end;

  try
    if Win32Check(Bool(hModule)) then
    begin
      EnumResourceLanguages(hModule, 'MUI', MAKEINTRESOURCE(1), @EnumResLangProcMUI, 0);
    end
    else Result:=False;
  finally
    FreeLibrary(hModule);
  end;
end;

(*
Deletes the resource called MUI by passing null values
Returns: "true" if successful, else "false"
*)
function DeleteMUI(muifile:string):boolean;
var
 hUpdate: THandle;
begin
  Result:=True; //everything ok assumed

  hUpdate := BeginUpdateResource(PChar(muifile), False);
  if hUpdate <> 0 then
  begin

    if UpdateResource(hUpdate,MAKEINTRESOURCE('MUI'), MAKEINTRESOURCE(1), ResLanguageMUI, nil, 0) then
    begin
      if not EndUpdateResource(hUpdate, False) then
        Result:=False;
    end
    else Result:=False;

  end
  else
    Result:=False; //failed cowardly


end;

procedure RestoreMUI(muifile:string);
var
  hUpdate: THandle;
  fs: TFileStream;
  Data: Pointer;
begin
  Data := nil;

  hUpdate := BeginUpdateResource(PChar(muifile), False);

  try
    if hUpdate = 0 then
      RaiseLastOSError;
    fs := TFileStream.Create(PChar(WorkFolder+'\'+ExtractFileName(muifile)+'.lock'), fmOpenRead);

    Data := AllocMem(fs.Size);
    fs.Read(Data^, fs.Size);

    if not UpdateResource(hUpdate,MAKEINTRESOURCE('MUI'), MAKEINTRESOURCE(1), ResLanguageMUI, Data, fs.Size) then
      RaiseLastOSError;

    if not EndUpdateResource(hUpdate, False) then
      RaiseLastOSError;
  finally
    if Data <> nil then
      FreeMem(Data);

    FreeAndNil(fs);

  end;
end;

{--------[MUI END]---------}


function GetSpecialFolderPath(Folder: Integer; CanCreate: Boolean): string;

// Gets path of special system folders
//
// Call this routine as follows:
// GetSpecialFolderPath (CSIDL_PERSONAL, false)
//        returns folder as result
//
var
   FilePath: array [0..MAX_PATH] of char;

begin
 SHGetSpecialFolderPath(0, @FilePath[0], FOLDER, CanCreate);
 Result := FilePath;
end;

(*
 Returns: 0 or 32 or 64 values to tell if Imageres.dll is a valid DLL and which bit version is
*)
function BootresVersion:integer;
var
  fs: TFileStream;
  signature: DWORD;
  dos_header: IMAGE_DOS_HEADER;
  pe_header: IMAGE_FILE_HEADER;
begin
  // let's find out if the IMAGERES.DLL is 32bit/64bit
  fs:= TFileStream.Create(OriginalDLL,fmOpenRead or fmShareDenyNone);
  try
    fs.Read(dos_header, SizeOf(dos_header));
    if dos_header.e_magic <> IMAGE_DOS_SIGNATURE then
    exit;

    fs.Seek(dos_header._lfanew,soFromBeginning);
    fs.Read(signature, SizeOf(signature));
    if signature <> IMAGE_NT_SIGNATURE then
    begin
      raise Exception.Create('Invalid PE Header');
      exit;
    end;
    fs.Read(pe_header,SizeOf(pe_header));

    Result:=0;
    case pe_header.Machine of
      IMAGE_FILE_MACHINE_I386:  Result:=32;
      IMAGE_FILE_MACHINE_IA64:  Result:=64;
      IMAGE_FILE_MACHINE_AMD64: Result:=64;
    end;


  finally
    fs.Free;
  end;

end;


procedure DimBackground(ParentForm: TForm;Enabled:Boolean=True);
var
  i: Byte;
begin
  if Enabled then
  begin
    try
      Back.Position := ParentForm.Position;
      Back.BorderStyle := bsnone;//ParentForm.BorderStyle;
      Back.BorderIcons := [];
      Back.AlphaBlend := true;
      Back.AlphaBlendValue := 0;
      Back.Color := clBlack;
      with ParentForm do Back.SetBounds(Left, Top, Width, Height);
      Back.Show;
      Back.Canvas.Brush.Color:=clBlack;
      Back.Canvas.FillRect(rect(0,0,ParentForm.Width,ParentForm.Height));
      Back.Canvas.Pen.Color := clWhite;
      Back.Canvas.Font.Name := 'Segoe UI';
      Back.Canvas.Font.Size := 14;
      Back.Canvas.TextOut(Back.Width div 2, Back.Height div 2, 'PLEASE WAIT...');
      for i := 1 to 100 do
      begin
        Back.AlphaBlendValue := i;
        Sleep(2)
      end;
    finally
      ParentForm.BringToFront
    end
  end
  else
  begin
    Back.Hide;
  end;
end;

function RunAsAdmin(hWnd: HWND; filename: string; Parameters: string): Boolean;
{
    See Step 3: Redesign for UAC Compatibility (UAC)
    http://msdn.microsoft.com/en-us/library/bb756922.aspx
}
var
    sei: TShellExecuteInfo;
begin
    if (ElevationType = 2) and (Elevation <> 0)then
    begin
      //is running as admin with full privileges
      ShellExecute(hWnd,'OPEN',PChar(filename),PChar(Parameters),nil,SW_HIDE);
      Result:=True;
    end
    else
    begin

    ZeroMemory(@sei, SizeOf(sei));
    sei.cbSize := SizeOf(TShellExecuteInfo);
    sei.Wnd := hwnd;
    sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
    sei.lpVerb := PChar('runas');
    sei.lpFile := PChar(Filename); // PAnsiChar;
    if parameters <> '' then
        sei.lpParameters := PChar(parameters); // PAnsiChar;
    sei.nShow := SW_HIDE;// SW_SHOWNORMAL; //Integer;

    Result := ShellExecuteEx(@sei);
    end;
end;


function IsBackupThere:boolean;
begin
  if FileExists(GetWindowsDir+'bootres.bkp') then
  Result := True
  else Result  := False;

end;

function IsShell32BackupThere:boolean;
begin
  if FileExists(GetWindowsDir+'shell32.dll.mui.bkp') then
  Result := True
  else Result  := False;

end;

function IsBasebrdBackupThere:boolean;
begin
  if FileExists(GetWindowsDir+'basebrd.dll.mui.bkp') then
  Result := True
  else Result  := False;

end;

//http://stackoverflow.com/questions/6908152/how-to-get-permission-level-of-a-folder
function CheckFileAccess(const FileName: string; const CheckedAccess: Cardinal): Cardinal;
var Token: THandle;
    Status: LongBool;
    Access: Cardinal;
    SecDescSize: Cardinal;
    PrivSetSize: Cardinal;
    PrivSet: PRIVILEGE_SET;
    Mapping: GENERIC_MAPPING;
    SecDesc: PSECURITY_DESCRIPTOR;
begin
  Result := 0;
  GetFileSecurity(PChar(Filename), OWNER_SECURITY_INFORMATION or GROUP_SECURITY_INFORMATION or DACL_SECURITY_INFORMATION, nil, 0, SecDescSize);
  SecDesc := GetMemory(SecDescSize);

  if GetFileSecurity(PChar(Filename), OWNER_SECURITY_INFORMATION or GROUP_SECURITY_INFORMATION or DACL_SECURITY_INFORMATION, SecDesc, SecDescSize, SecDescSize) then
  begin
    ImpersonateSelf(SecurityImpersonation);
    OpenThreadToken(GetCurrentThread, TOKEN_QUERY, False, Token);
    if Token <> 0 then
    begin
      Mapping.GenericRead := FILE_GENERIC_READ;
      Mapping.GenericWrite := FILE_GENERIC_WRITE;
      Mapping.GenericExecute := FILE_GENERIC_EXECUTE;
      Mapping.GenericAll := FILE_ALL_ACCESS;

      MapGenericMask(Access, Mapping);
      PrivSetSize := SizeOf(PrivSet);
      AccessCheck(SecDesc, Token, CheckedAccess, Mapping, PrivSet, PrivSetSize, Access, Status);
      CloseHandle(Token);
      if Status then
        Result := Access;
    end;
  end;

  FreeMem(SecDesc, SecDescSize);
end;

function GetFileOwner(FileName: string;
  var Domain, Username: string): Boolean;
var
  SecDescr: PSecurityDescriptor;
  SizeNeeded, SizeNeeded2: DWORD;
  OwnerSID: PSID;
  OwnerDefault: BOOL;
  OwnerName, DomainName: PChar;
  OwnerType: SID_NAME_USE;
begin
  GetFileOwner := False;
  GetMem(SecDescr, 1024);
  GetMem(OwnerSID, SizeOf(PSID));
  GetMem(OwnerName, 1024);
  GetMem(DomainName, 1024);
  try
    if not GetFileSecurity(PChar(FileName),
      OWNER_SECURITY_INFORMATION,
      SecDescr, 1024, SizeNeeded) then
      Exit;
    if not GetSecurityDescriptorOwner(SecDescr,
      OwnerSID, OwnerDefault) then
      Exit;
    SizeNeeded  := 1024;
    SizeNeeded2 := 1024;
    if not LookupAccountSID(nil, OwnerSID, OwnerName,
      SizeNeeded, DomainName, SizeNeeded2, OwnerType) then
      Exit;
    Domain   := DomainName;
    Username := OwnerName;
  finally
    FreeMem(SecDescr);
    FreeMem(OwnerName);
    FreeMem(DomainName);
  end;
  GetFileOwner := True;
end;

function GetUserFromWindows: string;
Var
   UserName : string;
   UserNameLen : Dword;
Begin
   UserNameLen := 255;
   SetLength(userName, UserNameLen) ;
   If GetUserName(PChar(UserName), UserNameLen) Then
     Result := Copy(UserName,1,UserNameLen - 1)
   Else
     Result := 'Administrator';
End;

//http://www.delphipraxis.net/401983-post.html
function AddAccessRights(lpszFileName: PChar; lpszAccountName: PChar; dwAccessMask: DWORD): boolean;
const
  HEAP_ZERO_MEMORY = $00000008;
  ACL_REVISION = 2;
  ACL_REVISION2 = 2;
  INHERITED_ACE = $10;
type
  ACE_HEADER = record
    AceType,
    AceFlags: Byte;
    AceSize: WORD;
  end;

  PACE_HEADER = ^ACE_HEADER;

  ACCESS_ALLOWED_ACE = record
    Header: ACE_HEADER;
    Mask: ACCESS_MASK;
    SidStart: DWORD;
  end;

  PACCESS_ALLOWED_ACE = ^ACCESS_ALLOWED_ACE;

  ACL_SIZE_INFORMATION = record
    AceCount,
    AclBytesInUse,
    AclBytesFree: DWORD;
  end;

  SetSecurityDescriptorControlFnPtr =
   function (pSecurityDescriptor: PSecurityDescriptor;
             ControlBitsOfInterest: SECURITY_DESCRIPTOR_CONTROL;
             ControlBitsToSet: SECURITY_DESCRIPTOR_CONTROL): boolean; stdcall;
var
  //SID variables
  snuType: SID_NAME_USE;
  szDomain: PChar;
  cbDomain: DWORD;
  pUserSID: pointer;
  cbUserSID: DWORD;

  //File SD variables
  pFileSD: PSecurityDescriptor;
  cbFileSD: DWORD;

  // New SD variables
  newSD: TSecurityDescriptor;

  // ACL variables
  ptrACL: PACL;
  fDaclPresent,
  fDaclDefaulted: BOOL;
  AclInfo: ACL_SIZE_INFORMATION;

  // New ACL variables
  pNewACL : PACL;
  cbNewACL: DWORD;

  //Temporary ACE
  pTempAce: Pointer;
  CurrentAceIndex,
  newAceIndex: UINT;

  // Assume function will fail
  fResult,
  fAPISuccess: boolean;

  secInfo: SECURITY_INFORMATION;

  // New APIs available only in Windows 2000 and above for setting
  // SD control
  _SetSecurityDescriptorControl : SetSecurityDescriptorControlFnPtr;

  controlBitsOfInterest,
  controlBitsToSet,
  oldControlBits: SECURITY_DESCRIPTOR_CONTROL;
  dwRevision: DWORD;

  AceFlags: BYTE;
function myheapalloc(x: integer): Pointer;
begin
  Result := HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, x);
end;

function myheapfree(x: Pointer): boolean;
begin
  Result := HeapFree(GetProcessHeap, 0, x);
end;

function SetFileSecurityRecursive(lpFileName: PChar;
                                  SecurityInformation: SECURITY_INFORMATION;
                                  pSecurityDescriptor: PSecurityDescriptor): BOOL;
var
  sr: TSearchRec;
begin
  Result := SetFileSecurity(lpFileName, SecurityInformation, pSecurityDescriptor);

  if not Result then
    Exit;

  if (FileGetAttr(lpFileName) and faDirectory) = faDirectory then
  begin
    // recursion begin
    if FindFirst(IncludeTrailingPathDelimiter(lpFileName)+'*',$EFFF,sr)=0 then
    begin
      repeat
      // msp 07.10.2004
      // if ((sr.a....
      if (sr.Name <> '.') and (sr.Name<>'..') then
        SetFileSecurityRecursive(PChar(IncludeTrailingPathDelimiter(lpFileName)+sr.Name), SecurityInformation, pSecurityDescriptor);
      until FindNext(sr)<>0;
        FindClose(sr);
    end;
  end;
end;

begin
  // Init
  szDomain := nil;
  cbDomain := 0;
  pUserSID := nil;
  cbUserSID := 0;

  // File SD variables
  pFileSD := nil;
  cbFileSD := 0;

  // ACL variables
  ptrACL := nil;

  // New ACL variables
  pNewACL := nil;
  cbNewACL := 0;

  // Temporary ACE
  pTempAce := nil;
  CurrentAceIndex := 0;

  newAceIndex := 0;

  // Assume function will fail
  fResult := False;

  secInfo := DACL_SECURITY_INFORMATION;

  // New APIs available only in Windows 2000 and above for setting
  // SD control
  _SetSecurityDescriptorControl := nil;

  // Delphi-Result
  Result := False;

  try
    //
    // STEP 1: Get SID of the account name specified.
    //
    fAPISuccess := LookupAccountName(nil, lpszAccountName, pUserSID, cbUserSID, szDomain, cbDomain, snuType);

    // API should have failed with insufficient buffer
    if (not fAPISuccess) and (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then
      raise Exception.Create('LookupAccountName Error = '+IntToStr(GetLastError));
    pUserSID := myheapalloc(cbUserSID);
    if pUserSID = nil then
      raise Exception.Create('myheapalloc Error=' + IntToStr(GetLastError()));

    szDomain := PChar(myheapalloc(cbDomain * sizeof(PChar)));
    if szDomain = nil then
      raise Exception.Create('myheapalloc Error=' + IntToStr(GetLastError()));

    fAPISuccess := LookupAccountName(nil, lpszAccountName,
                                     pUserSID, cbUserSID, szDomain,
                                     cbDomain, snuType);
    if not fAPISuccess then
      raise Exception.Create('LookupAccountName Error=' +
                             IntToStr(GetLastError()));

    //
    // STEP 2: Get security descriptor (SD) of the file specified.
    //
    fAPISuccess := GetFileSecurity(lpszFileName,
                                   secInfo, pFileSD, 0, cbFileSD);

    // API should have failed with insufficient buffer.
    if (not fAPISuccess) and (GetLastError() <> ERROR_INSUFFICIENT_BUFFER) then
      raise Exception.Create('GetFileSecurity Error=' +
                             IntToStr(GetLastError()));

    pFileSD := myheapalloc(cbFileSD);
    if pFileSD = nil then
      raise Exception.Create('myheapalloc Error=' + IntToStr(GetLastError()));

    fAPISuccess := GetFileSecurity(lpszFileName,
                                   secInfo, pFileSD, cbFileSD, cbFileSD);
    if not fAPISuccess then
      raise Exception.Create('GetFileSecurity Error=' +
                             IntToStr(GetLastError()));

    //
    // STEP 3: Initialize new SD.
    //
    if not InitializeSecurityDescriptor(@newSD,
                                        SECURITY_DESCRIPTOR_REVISION) then
      raise Exception.Create('InitializeSecurityDescriptor Error=' +
                             IntToStr(GetLastError()));

    //
    // STEP 4: Get DACL from the old SD.
    //
    if not GetSecurityDescriptorDacl(pFileSD, fDaclPresent, ptrACL,
                                     fDaclDefaulted) then
      raise Exception.Create('GetSecurityDescriptorDacl Error=' +
                             IntToStr(GetLastError()));

    //
    // STEP 5: Get size information for DACL.
    //
    AclInfo.AceCount := 0; // Assume NULL DACL.
    AclInfo.AclBytesFree := 0;
    AclInfo.AclBytesInUse := sizeof(ACL);

    if ptrACL = nil then
      fDaclPresent := false;

    // If not NULL DACL, gather size information from DACL.
    if fDaclPresent then
      if not GetAclInformation(ptrACL^, @AclInfo, sizeof(ACL_SIZE_INFORMATION),
                               AclSizeInformation) then
        raise Exception.Create('GetAclInformation ' + IntToStr(GetLastError()));

    //
    // STEP 6: Compute size needed for the new ACL.
    //
    cbNewACL := AclInfo.AclBytesInUse + sizeof(ACCESS_ALLOWED_ACE) +
                GetLengthSid(pUserSID) - sizeof(DWORD);

    //
    // STEP 7: Allocate memory for new ACL.
    //
    pNewACL := PACL(myheapalloc(cbNewACL));
    if pNewACL = nil then
      raise Exception.Create('myheapalloc ' + IntToStr(GetLastError()));

    //
    // STEP 8: Initialize the new ACL.
    //
    if not InitializeAcl(pNewACL^, cbNewACL, ACL_REVISION2) then
      raise Exception.Create('InitializeAcl ' + IntToStr(GetLastError()));

    //
    // STEP 9 If DACL is present, copy all the ACEs from the old DACL
    // to the new DACL.
    //
    // The following code assumes that the old DACL is
    // already in Windows 2000 preferred order. To conform
    // to the new Windows 2000 preferred order, first we will
    // copy all non-inherited ACEs from the old DACL to the
    // new DACL, irrespective of the ACE type.
    //

    newAceIndex := 0;

    if (fDaclPresent) and (AclInfo.AceCount > 0) then
    begin
      for CurrentAceIndex := 0 to AclInfo.AceCount - 1 do
      begin
        //
        // STEP 10: Get an ACE.
        //
        if not GetAce(ptrACL^, CurrentAceIndex, pTempAce) then
          raise Exception.Create('GetAce ' + IntToStr(GetLastError()));

        //
        // STEP 11: Check if it is a non-inherited ACE.
        // If it is an inherited ACE, break from the loop so
        // that the new access allowed non-inherited ACE can
        // be added in the correct position, immediately after
        // all non-inherited ACEs.
        //
        if PACCESS_ALLOWED_ACE(pTempAce)^.Header.AceFlags and
            INHERITED_ACE > 0 then
          break;

        //
        // STEP 12: Skip adding the ACE, if the SID matches
        // with the account specified, as we are going to
        // add an access allowed ACE with a different access
        // mask.
        //
        if EqualSid(pUserSID, @(PACCESS_ALLOWED_ACE(pTempAce)^.SidStart)) then
          continue;

        //
        // STEP 13: Add the ACE to the new ACL.
        //
        if not AddAce(pNewACL^, ACL_REVISION, MAXDWORD, pTempAce,
                      PACE_HEADER(pTempAce)^.AceSize) then
          raise Exception.Create('AddAce ' + IntToStr(GetLastError()));

        Inc(newAceIndex);
      end;
    end;

    //
    // STEP 14: Add the access-allowed ACE to the new DACL.
    // The new ACE added here will be in the correct position,
    // immediately after all existing non-inherited ACEs.
    //
    AceFlags := $1 (* OBJECT_INHERIT_ACE *)
             or $2 (* CONTAINER_INHERIT_ACE *)
             or $10 (* INHERITED_ACE*);

    if not AddAccessAllowedAceEx(pNewACL^, ACL_REVISION2, AceFlags, dwAccessMask,
                                 pUserSID) then
      raise Exception.Create('AddAccessAllowedAce ' + IntToStr(GetLastError()));

    //
    // STEP 15: To conform to the new Windows 2000 preferred order,
    // we will now copy the rest of inherited ACEs from the
    // old DACL to the new DACL.
    //
    if (fDaclPresent) and (AclInfo.AceCount > 0) then
    begin
      while CurrentAceIndex < AclInfo.AceCount do
      begin
        //
        // STEP 16: Get an ACE.
        //
        if not GetAce(ptrACL^, CurrentAceIndex, pTempAce) then
          raise Exception.Create('GetAce ' + IntToStr(GetLastError()));

        //
        // STEP 17: Add the ACE to the new ACL.
        //
        if not AddAce(pNewACL^, ACL_REVISION, MAXDWORD, pTempAce,
                      PACE_HEADER(pTempAce)^.AceSize) then
          raise Exception.Create('AddAce ' + IntToStr(GetLastError()));

        Inc(CurrentAceIndex);
      end;
    end;

    //
    // STEP 18: Set the new DACL to the new SD.
    //
    if not SetSecurityDescriptorDacl(@newSD, TRUE, pNewACL, FALSE) then
      raise Exception.Create('SetSecurityDescriptorDacl ' +
                             IntToStr(GetLastError()));

    //
    // STEP 19: Copy the old security descriptor control flags
    // regarding DACL automatic inheritance for Windows 2000 or
    // later where SetSecurityDescriptorControl() API is available
    // in advapi32.dll.
    //
    _SetSecurityDescriptorControl := SetSecurityDescriptorControlFnPtr(
                                     GetProcAddress(GetModuleHandle(
                                     'advapi32.dll'),
                                     'SetSecurityDescriptorControl'));
    if @_SetSecurityDescriptorControl <> nil then
    begin
      controlBitsOfInterest := 0;
      controlBitsToSet := 0;
      oldControlBits := 0;
      dwRevision := 0;

      if not GetSecurityDescriptorControl(pFileSD, oldControlBits,
                                          dwRevision) then
        raise Exception.Create('GetSecurityDescriptorControl ' +
                               IntToStr(GetLastError()));

      if (oldControlBits and SE_DACL_AUTO_INHERITED) <> 0 then
      begin
        controlBitsOfInterest := SE_DACL_AUTO_INHERIT_REQ or
                                 SE_DACL_AUTO_INHERITED;
        controlBitsToSet := controlBitsOfInterest;
      end else
      if (oldControlBits and SE_DACL_PROTECTED) <> 0 then
      begin
        controlBitsOfInterest := SE_DACL_PROTECTED;
        controlBitsToSet := controlBitsOfInterest;
      end;

      if controlBitsOfInterest <> 0 then
        if not _SetSecurityDescriptorControl(@newSD, controlBitsOfInterest,
                                             controlBitsToSet) then
          raise Exception.Create('SetSecurityDescriptorControl ' +
                                 IntToStr(GetLastError()));
    end;

    //
    // STEP 20: Set the new SD to the File.
    //
    // msp 07.09.2004: Set to all objects including subdirectories
    // if Not SetFileSecurity(lpszFileName, secInfo, @newSD) then
    if not SetFileSecurityRecursive(lpszFileName, secInfo, @newSD) then
      raise Exception.Create('SetFileSecurity ' + IntToStr(GetLastError()));
  except
    on E:Exception do
    begin
      MessageDlg(E.Message, mtError, [mbAbort], -1);
      Exit;
    end;
  end;

  //
  // STEP 21: Free allocated memory
  //
  if pUserSID <> nil then
    myheapfree(pUserSID);

  if szDomain <> nil then
    myheapfree(szDomain);

  if pFileSD <> nil then
    myheapfree(pFileSD);

  if pNewACL <> nil then
    myheapfree(pNewACL);

  fResult := true;

end;

procedure ChangeFolderPermission;
var
 Sid: PSID;
 peUse: DWORD;
 cchDomain: DWORD;
 cchName: DWORD;
 Name: array of Char;
 Domain: array of Char;
 pDACL: PACL;
 pEA: PEXPLICIT_ACCESS_W;
 R: DWORD;
 foldername: String; //Temp to hardcode
begin
 foldername := 'C:\WINDOWS\BOOT\RESOURCES'; //Temp to hardcode
 Sid := nil;
 Win32Check(ConvertStringSidToSid(PChar('S-1-1-0'), Sid));
 cchName := 0;
 cchDomain := 0;
 //Get Length
 if (not LookupAccountSid(nil, Sid, nil, cchName, nil, cchDomain, peUse)) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
 begin
  SetLength(Name, cchName);
  SetLength(Domain, cchDomain);
  if LookupAccountSid(nil, Sid, @Name[0], cchName, @Domain[0], cchDomain, peUse) then
  begin
   pEA := AllocMem(SizeOf(EXPLICIT_ACCESS));
   BuildExplicitAccessWithName(pEA, PChar(Name), GENERIC_ALL{GENERIC_READ},GRANT_ACCESS, SUB_CONTAINERS_AND_OBJECTS_INHERIT{NO_INHERITANCE});
   R := SetEntriesInAcl(1, pEA, nil, pDACL);
   if R = ERROR_SUCCESS then
   begin
    if SetNamedSecurityInfo(pchar(foldername), SE_FILE_OBJECT,DACL_SECURITY_INFORMATION, nil, nil, pDACL, nil) <> ERROR_SUCCESS then ShowMessage('SetNamedSecurityInfo failed: ' + SysErrorMessage(GetLastError));
    LocalFree(Cardinal(pDACL));
   end
   else ShowMessage('SetEntriesInAcl failed: ' + SysErrorMessage(R));
  end;
 end;
end;



(* Seleccionador *)
procedure TSeleccionador.Paint(Buffer: TBitmap32);
var
  Cx,Cy: integer;
  R: TRect;

  procedure DrawHandle(X,Y:integer);
  var
    A,R:Double;
    AFP:TArrayOfFixedPoint;
    i,res: Integer;
    xf,yf: Double;
  begin
    R:=(HandleSize * 2);
    res:=Round(R);
    if R <= 16 then res:=32;
    if R <= 8 then res:=16;
    if R <= 4 then res:=8;
    SetLength(AFP,res);
    for I := 0   to  res -1 do
    begin
      A:=(i / res)*2*PI;
      xf:=Cos(A)*R;
      yf:=Sin(A)*R;
      AFP[i]:=FixedPoint(xf+X,yf+Y);
    end;
    PolygonXS(Buffer,AFP,FLineColor);

    SetLength(AFP,0);

    R:=(HandleSize*2)-1;
    res:=Round(R);
    if R <= 16 then res := 32;
    if R <= 8 then res := 16;
    if R <= 4 then res := 8;

    SetLength(AFP, res);
    for i := 0 to res - 1 do
    begin
      A := (i / res) * 2*PI;
      xf := Cos(A) * R;
      yf := Sin(A) * R;
      AFP[i] := FixedPoint(xf + X, yf + Y);
    end;
    PolygonXS(Buffer, AFP, FFillColor);
  end;
begin
  R:=MakeRect(GetAdjustedRect(Location));
  with R do
  begin
    if rhFrame in Handles then
    begin
      Buffer.FrameRectS(Left,Top,Right,Bottom,FFillColor);
(*      if fullpic then
        //let's divide it
        Buffer.FrameRectS(Left,Top+(trunc((Bottom-Top)/2*0.73)),Right,Bottom-(trunc((Bottom-Top)/2*0.27)),color32(123,153,0))
      else
        Buffer.FrameRectS(Left,Top+(trunc((Bottom-Top)*0.73)),Right,Bottom-(trunc((Bottom-Top)*0.27)),color32(123,153,0));*)
    end;
    if rhCorners in Handles then
    begin
      if not (rhNotTLCorner in Handles) then DrawHandle(Left, Top);
      if not (rhNotTRCorner in Handles) then DrawHandle(Right, Top);
      if not (rhNotBLCorner in Handles) then DrawHandle(Left, Bottom);
      if not (rhNotBRCorner in Handles) then DrawHandle(Right, Bottom);
    end;
    if rhSides in Handles then
    begin
      Cx:=(Left+Right) div 2;
      Cy:=(Top+Bottom) div 2;
      if not (rhNotTopSide in Handles) then DrawHandle(Cx+1, Top);
      if not (rhNotLeftSide in Handles) then DrawHandle(Left, Cy+1);
      if not (rhNotRightSide in Handles) then DrawHandle(Right, Cy+1);
      if not (rhNotBottomSide in Handles) then DrawHandle(Cx+1, Bottom);
    end;
  end;
end;

procedure TSeleccionador.SetFillColor(Value: TColor32);
begin
  FFillColor:=Value;
  Update;
end;

procedure TSeleccionador.SetLineColor(Value: TColor32);
begin
  FLineColor:=Value;
  Update;
end;

procedure TSeleccionador.GetResize(Sender: TObject;
  const OldLocation: TFloatRect;
  var NewLocation: TFloatRect;
  DragState: TRBDragState;
  Shift: TShiftState);
var
  frame: TRect;
begin
  //evitamos que se extienda mucho el ancho
  frame:=Win8BootLogo.ImgView321.GetBitmapRect; //obtiene  los márgenes relativos de la imagen

  if NewLocation.Left < Frame.Left then
  begin
    NewLocation.Right := NewLocation.Right+Abs(Frame.Left-NewLocation.Left);
    NewLocation.Left := Frame.Left;
  end;

  if NewLocation.Top < Frame.Top then
  begin
    NewLocation.Bottom := NewLocation.Bottom+Abs(Frame.Top-NewLocation.Top);
    NewLocation.Top := Frame.Top;
  end;

  if NewLocation.Right > Frame.Left+Frame.Width then //Form1.ImgView321.Width then
  begin
    NewLocation.Left := NewLocation.Left - (NewLocation.Right - (Frame.Left+Frame.Width)); //Form1.ImgView321.Width);
    NewLocation.Right := Frame.Left+Frame.Width;//Form1.ImgView321.Width;
  end;

  if NewLocation.Bottom > Frame.Top+Frame.Height then //Form1.ImgView321.Height then
  begin
    NewLocation.Top := NewLocation.Top - (NewLocation.Bottom - (Frame.Top+Frame.Height) );//Form1.ImgView321.Height);
    NewLocation.Bottom := frame.Top+Frame.Height; //Form1.ImgView321.Height;
  end;


end;


////READONMEMORYONLY////
// the following procedure will only load the bitmaps from the original location file in memoryç
// uncompress to stream the wim file
// and again uncompress that win file to show the pictures
//procedure LoadBootRes;
//var
//  bootresfile: TFileStream;
//  reader: TBinaryReader;
//  value : Integer;
//
//  Arch : I7zInArchive;
//  I:integer;
//begin
//  if FileExists(BootResDLL) then
//  begin
//    bootresfile:= TFileStream.Create(BootResDLL, fmOpenRead or fmShareDenyWrite);
//    try
//      reader := TBinaryReader.Create(bootresfile);
//      try
//        value := reader.ReadInteger;
//      finally
//        reader.Free;
//      end;
//      //read on memory
//      Arch := CreateInArchive(CLSID_CFormatPe, '7zip.dll');
//
//    finally
//      bootresfile.Free;
//    end;
//  end;
//end;


// it will extract the bootres.dll wim file into work folder
procedure ExtractBootResWim;
var
  Arch : TJclDecompressArchive;
  I: Integer;
  Dex: TMemoryStream;
  Signature: TStringStream;
begin
  if FileExists(OriginalDLL) then
  begin
    Win8BootLogo.lstOriginalPics.Items.Clear;
    try
      Arch := TJclPeDecompressArchive.Create(OriginalDLL, 0, False);
      try
        Arch.ListFiles;
        for I := 0 to Arch.ItemCount - 1 do
          if not Arch.Items[I].Directory then
          begin
            //lets extract it
            Dex := TMemoryStream.Create;
            try
              Arch.Items[I].Stream := Dex;
              Arch.Items[I].OwnsStream := False;
              Arch.Items[I].Selected := True;
              Arch.ExtractSelected();
              //Unselect after to ignore in next loop
              Arch.Items[I].Selected := False;
              //Dex.SaveToFile(ExtractFilePath(ParamStr(0))+'bitmaps.wim');
              Dex.Position := 0;
              Signature := TStringStream.Create;
              try
                Signature.CopyFrom(Dex, 5);
                if Signature.DataString = 'MSWIM' then
                begin
                  Dex.SaveToFile(WorkFolder+'\bootres.wim');
                  Continue;
                end;
              finally
                Signature.Free;
              end;
            finally
              Dex.Free;
            end;

          end;
      finally
        FreeAndNil(Arch);
      end;
    except
      on E:Exception do
      begin
        raise Exception.Create(Format('ERROR: [%s] %s', [E.ClassName, E.Message]));
      end;
    end;
  end
  else
    raise Exception.Create('BootRes.DLL not found in your installation!');

end;

//extract in listbox the current bitmaps
procedure ExtractBitmapOnListBoxOnly;
var
  Arch : TJclDecompressArchive;
  I: Integer;
  Dex: TMemoryStream;
begin
  if FileExists(BootResDLL) then
  begin
    Win8BootLogo.lstOriginalPics.Items.Clear;
    try
      Arch := TJclWimDecompressArchive.Create(BootResDLL, 0, False);
      try
        Arch.ListFiles;
        for I := 0 to Arch.ItemCount - 1 do
          if not Arch.Items[I].Directory then
          begin
            Win8BootLogo.lstOriginalPics.Items.Add(Arch.Items[I].PackedName);
            //lets load by default the 3rd picture in the viewer
            //if I = 2 then
            if string(Arch.Items[I].PackedName).Contains('winlogo3.bmp') then
            begin
              Dex := TMemoryStream.Create;
              try
                Arch.Items[I].Stream := Dex;
                Arch.Items[I].OwnsStream := False;
                Arch.Items[I].Selected := True;
                Arch.ExtractSelected();
                Arch.Items[I].Selected := True;
                //Dex.SaveToFile(ExtractFilePath(ParamStr(0))+'bitmaps.wim');
                Dex.Position := 0;
                Win8BootLogo.ImgView321.Bitmap.LoadFromStream(Dex);
                //frmPreview.Image321.Bitmap := ImgView321.Bitmap;
                //lets find out the dimensions
                Win8BootLogo.Label2.Caption := 'Width : '+IntToStr(Win8BootLogo.ImgView321.Bitmap.BoundsRect.Width)+
                                  ' Height: '+IntToStr(Win8BootLogo.ImgView321.Bitmap.BoundsRect.Height);
              finally
                Dex.Free;
              end;
            end;
          end;
      finally
        FreeAndNil(Arch);
      end;
    except
      on E:Exception do
      begin
        raise Exception.Create(Format('ERROR: [%s] %s', [E.ClassName, E.Message]));
      end;
    end;
  end
  else
    raise Exception.Create('RCDATA_1.WIM not found!');

end;

//loadlist of present bitmaps
procedure LoadListofBMPs;
var
  I: Integer;
begin
  Win8BootLogo.lstEditedPics.Items.Clear;
  for I := 0 to 5 do
  begin
    if FileExists(WorkFolder+'\'+nombres[I]) then
    begin
      Win8BootLogo.lstEditedPics.Items.Add(nombres[I]);
    end;
  end;
end;


{
Usage:
UpdateResource('c:\windows\system32\imageres.dll','c:\mypics\newpic.png','PNG',PChar(10000));
}
function UpdateResourceBin(const ModulePath, FileName: string; ResourceType, ResourceName: PChar):boolean;
var
  hUpdate: THandle;
  fs: TFileStream;
  Data: Pointer;
begin
  Result:=True;
  if FileExists(FileName) then
  begin
    Data := nil;
    hUpdate := BeginUpdateResource(PChar(ModulePath), False);
    try
      if hUpdate <> 0 then
      begin
        fs := TFileStream.Create(FileName, fmOpenRead);

        Data := AllocMem(fs.Size);
        fs.Read(Data^, fs.Size);

        if UpdateResource(hUpdate,MAKEINTRESOURCE(ResourceType), Pchar(ResourceName), ResLanguage, Data, fs.Size) then
        begin
          Result:=EndUpdateResource(hUpdate, False);
        end
        else Result:=False;
      end
      else Result:=False;
    finally
      if Data <> nil then
        FreeMem(Data);

      FreeAndNil(fs);
    end;
  end
  else Result:=False; //no file
end;

function EnumResLangProc(hModule: HMODULE; lpType, lpName: PChar; wIDLanguage: Word;
  lParam: Longint): BOOL; stdcall;
begin
  ResLanguage := wIDLanguage;
  Result := False;
end;
(*
Function: GETRESOURCELANGUAGE from imageres.dll
Returns: if there was a language value
Stores: ResLanguage keeps the language
*)
function GetResourceLanguage:boolean;
var
  hModule: THandle;
  ErrorMode: UINT;
begin
  Result:=True;

  ErrorMode:=SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    hModule := LoadLibrary(PChar(WorkFolder+'\bootres.dll'));
  finally
    SetErrorMode(ErrorMode);
  end;

  try
    if Win32Check(Bool(hModule)) then
    begin
      EnumResourceLanguages(hModule, RT_RCDATA, MAKEINTRESOURCE(1), @EnumResLangProc, 0);
    end
    else Result:=False;
  finally
    FreeLibrary(hModule);
  end;
end;

procedure PatchWIM;
var
  hUpdate: THandle;
  fs: TFileStream;
  Data: Pointer;
begin
  if FileExists(WorkFolder+'\bootres0.wim') then
  begin
    Data := nil;
    hUpdate := BeginUpdateResource(PChar(WorkFolder+'\bootres.dll'), False);
    if hUpdate = 0 then
      raise Exception.Create('Couldn''t update resource of bootres.dll');
    try
      fs := TFileStream.Create(WorkFolder+'\bootres0.wim', fmOpenRead);
      Data := AllocMem(fs.Size);
      fs.Read(Data^, fs.Size);
      if not UpdateResource(hUpdate
                  , RT_RCDATA
                  , MAKEINTRESOURCE(1)
                  , ResLanguage
                  , Data
                  , fs.Size) then
        raise Exception.Create('Couldn''t update resource!');
    finally
      EndUpdateResource(hUpdate, False);
      if Data <> nil then
        FreeMem(Data);
      FreeAndNil(fs);
    end;
  end;
end;

//http://www.delphibasics.info/home/delphibasicssnippets/updatepechecksumbysteve10120
function UpdateChecksum(szFile:string; dwNewCheckSum:DWORD):Boolean;
var
  hFile:  DWORD;
  IDH:    TImageDosHeader;
  INH:    TImageNtHeaders;
  null:   DWORD;
begin
  Result := FALSE;
  hFile := CreateFile(PChar(szFile), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    ReadFile(hFile, IDH, 64, null, nil);
    if IDH.e_magic = IMAGE_DOS_SIGNATURE then
    begin
      SetFilePointer(hFile, IDH._lfanew, nil, FILE_BEGIN);
      ReadFile(hFile, INH, 248, null, nil);
      if INH.Signature = IMAGE_NT_SIGNATURE then
      begin
        INH.OptionalHeader.CheckSum := dwNewCheckSum;
        SetFilePointer(hFile, IDH._lfanew, nil, FILE_BEGIN);
        WriteFile(hFile, INH, 248, null, nil);
        CloseHandle(hFile);
        Result := TRUE;
      end;
    end;
  end;
end;

function IsCheckSumValid(szFile:string; bUpdate:Boolean):Boolean;
var
  hFile:    DWORD;
  hMapping: DWORD;
  pMap:     Pointer;
  dwSize:   DWORD;
  dwOldSum: DWORD;
  dwNewSum: DWORD;
begin
  Result := TRUE;
  hFile := CreateFile(PChar(szFile), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    dwSize := GetFileSize(hFile, nil);
    hMapping := CreateFileMapping(hFile, nil, PAGE_READONLY, 0, dwSize, nil);
    if hMapping <> 0 then
    begin
      pMap := MapViewOfFile(hMapping, FILE_MAP_READ, 0, 0, 0);
      if pMap <> nil then
      begin
        CheckSumMappedFile(pMap, dwSize, @dwOldSum, @dwNewSum);
        CloseHandle(hFile);
        if dwOldSum <> dwNewSum then
        begin
          Result := FALSE;
          if bUpdate = TRUE then
            UpdateChecksum(szFile, dwNewSum);
        end;
        UnMapViewOfFile(pMap);
      end;
      CloseHandle(hMapping);
    end;
  end;
end;

////////////////////////////////////TFORM///////////////////////////////////////



procedure TWin8BootLogo.btnApplyClick(Sender: TObject);
begin
  if IsBackupThere then
  begin
    //this would not work ~> AddAccessRights(PChar(GetWindowsDir+'Boot\Resources\bootres.dll'),PChar(GetUserFromWindows),$FFFFFFFF);

    if FileExists(WorkFolder+'\bootres.dll') then
    begin
    //let's change file permissions and replace after that restore file permission
    ShellExecute(Handle, 'RunAs', 'cmd', pchar('/t:0A /c '
      +'echo Windows 8 Boot Logo Changer by vhanla&&'
      +'echo.&&echo Changing bootres.dll permissions&&'
      +'takeown /f '+GetWindowsDir+'Boot\Resources\bootres.dll&&'
      +'icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /grant '+GetUserFromWindows+':f&&'
      +'echo.&&echo Changing bootres.dll&&'
      +'copy /Y "'+WorkFolder+'\bootres.dll" "'+GetWindowsDir+'Boot\Resources\bootres.dll"&&echo bootress.dll copied!&&'
      +'echo.&&echo Restoring file ownership&&'
      +'icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
      +'icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /remove '+GetUserFromWindows+'&&'
      +'pause'),nil,sw_show);
    end
    else
      raise Exception.Create('Generate bootres.dll first.');

  end
  else
  MessageDlg('You must create a backup before proceeding.',mtWarning,[mbOK],0);
end;

procedure TWin8BootLogo.btnBackupRestoreClick(Sender: TObject);
var
  d,u: string;
begin
  // if there is no backup and caption says to backup then lets backup
  if not IsBackupThere and (btnBackupRestore.Caption = '&Backup') then
  begin
(*    RunAsAdmin(Handle,pchar(GetWindowsDir+'System32\cmd.exe'),
            pchar('/t:0A /c '
            +'echo Windows 8 Boot Logo Changer by vhanla&&'
            +'echo.&&echo Making backup of BootRes.dll&&'
            +'cd "'+GetWindowsDir+'Boot\Resources'
            +'"&&copy bootres.dll bootres.bkp&&echo Backup done!&&pause'));
  *)
//  WinExec(pansichar('runas.exe /user:'+GetEnvironmentVariable('COMPUTERNAME')+'\administrator cmd.exe'),sw_show);

  ShellExecute(handle, 'RunAs', 'cmd', pchar('/t:0A /c '
            +'echo Windows 8 Boot Logo Changer by vhanla&&'
            +'echo.&&echo Making backup of BootRes.dll&&'
            +'copy "'+GetWindowsDir+'Boot\Resources\bootres.dll" "'+GetWindowsDir+'bootres.bkp"&&echo Backup done!&&pause'),nil,sw_show);

(*  ShellExecute(handle, 'RunAs', 'cmd', pchar('/t:0A /c '
            +'takeown /f '+GetWindowsDir+'Boot\Resources\bootres.dll'
            +'&&icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /grant '+GetUserFromWindows+':f'),nil,sw_hide);*)


//by default bootres.dll is trustedinstaller belong
(*  ShellExecute(handle, 'RunAs', 'cmd', pchar('/t:0A /c '
            +'takeown /f '+GetWindowsDir+'Boot\Resources\bootres.dll'
            +'&&icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /grant '+GetUserFromWindows+':f'),nil,sw_hide);*)

  //remove assigned user
  (*ShellExecute(handle, 'open', 'cmd', pchar('/t:0A /c '
            +'takeown /f '+GetWindowsDir+'Boot\Resources\bootres.dll'
            +'&&icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /remove '+GetUserFromWindows+'&&pause'),nil,sw_show);*)
  //restore to TrustedInstaller
(*  ShellExecute(handle, 'RunAs', 'cmd', pchar('/t:0A /c '
            +'takeown /f '+GetWindowsDir+'Boot\Resources\bootres.dll'
            +'&&icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /setowner "NT Service\TrustedInstaller" /T /C'),nil,sw_hide);*)

(*    GetFileOwner(GetWindowsDir+'Boot',d,u);
    //ShowMessage(u);
    ChangeFolderPermission;
    //AddAccessRights(PChar(GetWindowsDir+'Boot'),PChar(GetUserFromWindows),$FFFFFFFF);

    CopyFile(PChar(GetWindowsDir+'Boot\Resources\bootres.dll'),PChar(GetWindowsDir+'Boot\Resources\bootres.bkp'), True);
    if IsBackupThere then
      btnBackupRestore.Caption :='&Restore'; *)
  end
  else if IsBackupThere and (btnBackupRestore.Caption = '&Restore') then
  begin
    //let's change file permissions and replace after that restore file permission
    ShellExecute(Handle, 'RunAs', 'cmd', pchar('/t:0A /c '
      +'echo Windows 8 Boot Logo Changer by vhanla&&'
      +'echo.&&echo Changing bootres.dll permissions&&'
      +'takeown /f '+GetWindowsDir+'Boot\Resources\bootres.dll&&'
      +'icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /grant '+GetUserFromWindows+':f&&'
      +'echo.&&echo Restoring bootres.dll&&'
      +'copy /Y "'+GetWindowsDir+'bootres.bkp" "'+GetWindowsDir+'Boot\Resources\bootres.dll"&&echo Restore done!&&'
      +'echo.&&echo Restoring file ownership&&'
      +'icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
      +'icacls '+GetWindowsDir+'Boot\Resources\bootres.dll'+' /remove '+GetUserFromWindows+'&&'
      +'pause'),nil,sw_show);
  end;
end;

procedure TWin8BootLogo.btnCancelClick(Sender: TObject);
begin
close
end;

function GetWindowsLanguage: string;
var
  WinLanguage: array [0..50] of char;
begin
  VerLanguageName(GetSystemDefaultLangID, WinLanguage, 50);
  Result := StrPas(WinLanguage);
end;

function GetWindowsCurrentLocalizationFolder: string;
var
  lngId: WORD;
  loc: string;
  si:integer;
begin
//  lngId := GetUserDefaultLangID;
  lngId := GetUserDefaultUILanguage; // it seems better than previous commented out method
  case lngId of
    1025: Result := 'ar-SA';
    1026: Result := 'bg-BG';
    1028: Result := 'zh-TW';
    1029: Result := 'cs-CZ';
    1030: Result := 'da-DK';
    1031: Result := 'de-DE';
    1032: Result := 'el-GR';
    1033: Result := 'en-US';
    1035: Result := 'fi-FI';
    1036: Result := 'fr-FR';
    1037: Result := 'he-IL';
    1038: Result := 'hu-HU';
    1040: Result := 'it-IT';
    1041: Result := 'ja-JP';
    1042: Result := 'ko-KR';
    1043: Result := 'nl-NL';
    1044: Result := 'nb-NO';
    1045: Result := 'pl-PL';
    1046: Result := 'pt-BR';
    1048: Result := 'ro-RO';
    1049: Result := 'ru-RU';
    1050: Result := 'hr-HR';
    1051: Result := 'sk-SK';
    1053: Result := 'sv-SE';
    1054: Result := 'th-TH';
    1055: Result := 'tr-TR';
    1058: Result := 'uk-UA';
    1060: Result := 'sl-SI';
    1061: Result := 'et-EE';
    1062: Result := 'lv-LV';
    1063: Result := 'lt-LT';
    2052: Result := 'zh-CN';
    2057: Result := 'en-GB';
    2058: Result := 'es-MX';
    2070: Result := 'pt-PT';
    2074: Result := 'sr-Latn-CS';
    3076: Result := 'zh-HK';
    3082: Result := 'es-ES';
    9242: Result := 'sr-Latn-RS';
  else
    Result := 'unknown';
  end;
end;

procedure TWin8BootLogo.btnCreatePicturesClick(Sender: TObject);
var
  Area : TFloatRect;
  d: TDraftResampler;
  xr,yr: Single;
  dest: TBitmap32;
  bmp: TBitmap;
  I: Integer;
begin
  // process selected area in picture if loaded new picture
  if Seleccionador.Visible then
  begin
    DimBackground(Self);
    xr:=ImgView321.Bitmap.BoundsRect.Width / ImgView321.GetBitmapRect.Width;
    yr:=ImgView321.Bitmap.BoundsRect.Height / ImgView321.GetBitmapRect.Height;
    Area := Seleccionador.GetAdjustedLocation;

    d := TDraftResampler.Create(ImgView321.Bitmap);
    dest := TBitmap32.Create;
    try
      for I := 0 to 5 do
      begin
        dest.SetSize(anchos[I],altos[I]);
        ImgView321.Bitmap.DrawTo(dest,dest.BoundsRect,
          Rect(
            trunc( ( Area.Left-ImgView321.GetBitmapRect.Left  )*xr),
            trunc( ( Area.Top-ImgView321.GetBitmapRect.Top    )*yr),
            trunc( ( Area.Right-ImgView321.GetBitmapRect.Left )*xr),
            trunc( ( Area.Bottom-ImgView321.GetBitmapRect.Top )*yr))
        );
        // TODO; fix vignette effect same for all
        if cbVignette.Checked then
          Vignette(dest);
        //lets save it as p24 bit bitmap
        bmp := TBitmap.Create;
        try
          bmp.Assign(dest);
          bmp.PixelFormat := pf24bit;
          bmp.SaveToFile(WorkFolder+'\'+nombres[I]);
        finally
          bmp.Free;
        end;
      end;
    finally
      dest.Free;
    end;
  end
  else
  begin
    frmPreview.Image321.Bitmap := ImgView321.Bitmap;
  end;

  LoadListofBMPs;

  Back.Hide;
end;

procedure TWin8BootLogo.btnPreviewClick(Sender: TObject);
var
  Area : TFloatRect;
  d: TDraftResampler;
  xr,yr: Single;
begin
//  ShowMessage(GetWindowsCurrentLocalizationFolder);

  // process selected area in picture if loaded new picture
  if Seleccionador.Visible then
  begin
    xr:=ImgView321.Bitmap.BoundsRect.Width / ImgView321.GetBitmapRect.Width;
    yr:=ImgView321.Bitmap.BoundsRect.Height / ImgView321.GetBitmapRect.Height;
    Area := Seleccionador.GetAdjustedLocation;
    frmPreview.Image321.Bitmap.SetSize(129,115);
    d := TDraftResampler.Create(ImgView321.Bitmap);
    ImgView321.Bitmap.DrawTo(frmPreview.Image321.Bitmap,frmPreview.Image321.Bitmap.BoundsRect,
      Rect(
        trunc( ( Area.Left-ImgView321.GetBitmapRect.Left  )*xr),
        trunc( ( Area.Top-ImgView321.GetBitmapRect.Top    )*yr),
        trunc( ( Area.Right-ImgView321.GetBitmapRect.Left )*xr),
        trunc( ( Area.Bottom-ImgView321.GetBitmapRect.Top )*yr))
    );

  end
  else
  begin
    frmPreview.Image321.Bitmap := ImgView321.Bitmap;
  end;

  if cbVignette.Checked then
      Vignette(frmPreview.Image321.Bitmap);

  frmPreview.ShowModal;
end;

procedure TWin8BootLogo.btnRePackClick(Sender: TObject);
var
  Arch: TJclCompressArchive;
  ArchClass: TJclCompressArchiveClass;
  fn: string;
  i: Integer;
begin
  //let's first create a new file that will contain the new wim bmp resources
  //WHATTTTTTTT this was wrong in the first place, it shouldn't be replaced entirely
  (* for this version i will use the following method using 7zip
  +------------------------------------------------------+
  | 7z.exe u bootres0.wim winlogo1.bmp winlogo2.bmp ...  |
  +------------------------------------------------------+

  if FileExists(WorkFolder+'\bootres0.wim') then
    if not DeleteFile(WorkFolder+'\bootres0.wim') then
      raise Exception.Create('Couldn''t write the new bitmaps into bootres0.wim');

  //let's add one by one
  try
    Arch := CreateOutArchive(CLSID_CFormatWim, '7zip.dll');
    for i := 0 to 5 do
    begin
      if FileExists(WorkFolder+'\'+nombres[i]) then
      begin
        Arch.AddFile(WorkFolder+'\'+nombres[i], nombres[i]);
      end;
    end;
    //SetCompressionLevel(Arch, 5);
    //SevenZipSetCompressionMethod(Arch, m7LZMA);
    //SetCompressionMethod(Arch,mzCopy);

    //http://stackoverflow.com/questions/14321197/using-7zip-delphi-wrapper-from-c-builder
    Arch.SaveToFile(WorkFolder+'\bootres0.wim');
  except
    on E:Exception do
    begin
      raise Exception.Create(Format('ERROR: [%s] %s', [E.ClassName, E.Message]));
    end;
  end;
   *)
  DimBackground(Self);
  fn := WorkFolder + '\bootres0.wim';
  // * TEMPORARY METHOD
  if FileExists(fn) then
    if not DeleteFile(fn) then
      raise Exception.Create('Couldn''t write the new bitmaps into bootres0.wim');
    if not CopyFile(PChar(WorkFolder + '\bootres.wim'),PChar(fn),False) then
      raise Exception.Create('Couldn''t create bootres0.wim to work with');

  if FileExists(WorkFolder+'\'+nombres[0])
  and FileExists(WorkFolder+'\'+nombres[1])
  and FileExists(WorkFolder+'\'+nombres[2])
  and FileExists(WorkFolder+'\'+nombres[3])
  and FileExists(WorkFolder+'\'+nombres[4])
  and FileExists(WorkFolder+'\'+nombres[5])
  then
  begin

  end
  else
  begin
    MessageDlg('You should create the replacing bitmaps with the button [>] up left first!', mtWarning,[mbOK],0);
    Back.Hide;
    Exit;
  end;

//// update edited pictures in bootres0.wim
////  ArchClass := GetArchiveFormats.FindUpdateFormat(fn);
////  if ArchClass <> nil then
//  begin
//  //  Arch := ArchClass.Create(fn, 0, False);
//    Arch := TJcl7zCompressArchive(fn);
//
//    if FileExists(fn) then
//      (Arch as TJclWimCompressArchive).ListFiles; // without this call deletes all previous files in the archive
//
//    (Arch as TJcl7zUpdateArchive).AddFile(nombres[0], WorkFolder+'\'+nombres[0]);
//    (Arch as TJcl7zUpdateArchive).AddFile(nombres[1], WorkFolder+'\'+nombres[1]);
//    (Arch as TJcl7zUpdateArchive).AddFile(nombres[2], WorkFolder+'\'+nombres[2]);
//    (Arch as TJcl7zUpdateArchive).AddFile(nombres[3], WorkFolder+'\'+nombres[3]);
//    (Arch as TJcl7zUpdateArchive).AddFile(nombres[4], WorkFolder+'\'+nombres[4]);
//    (Arch as TJcl7zUpdateArchive).AddFile(nombres[5], WorkFolder+'\'+nombres[5]);
//
//    try
//      (Arch as TJcl7zUpdateArchive).Compress;
//    finally
//      FreeAndNil(Arch);
//    end;
//  end;

  ShellExecute(Handle
    , 'OPEN'
    , PChar(ExtractFilePath(ParamStr(0))+'bin\7z.exe')
    , PChar('u "'+WorkFolder+'\bootres0.wim'
    +'" "'+WorkFolder+'\'+nombres[0]
    +'" "'+WorkFolder+'\'+nombres[1]
    +'" "'+WorkFolder+'\'+nombres[2]
    +'" "'+WorkFolder+'\'+nombres[3]
    +'" "'+WorkFolder+'\'+nombres[4]
    +'" "'+WorkFolder+'\'+nombres[5]+'"')
    , PChar(ExtractFilePath(ParamStr(0))+'bin')
    , SW_HIDE);
  // TEMPORARY METHOD *
  Sleep(2000);

  //SECOND STEP - LET'S REPLACE THAT RESOURCE IN BOOTRES.DLL
  //let's copy the bootres.dll file to workfolder

  if FileExists(WorkFolder+'\bootres.dll') then
    if not DeleteFile(WorkFolder + '\bootres.dll') then
      raise Exception.Create('File bootres.dll in temporary folder is locked!');
//but first make sure to use the backuped file 'cause it is original
  if IsBackupThere then
  begin
    if not CopyFile(PChar(GetWindowsDir + 'bootres.bkp'),PChar(WorkFolder+'\bootres.dll'),True) then
      raise Exception.Create('Couldn''t copy bootres.dll to path!');
  end
  else
  begin
    if not CopyFile(PChar(GetWindowsDir + 'Boot\Resources\bootres.dll'),PChar(WorkFolder+'\bootres.dll'),True) then
      raise Exception.Create('Couldn''t copy bootres.dll to path!');
  end;

  //now let's patch RCDATA 1 (1033);

  //lets remove the certificate
//  ShellExecute(Handle
//    , 'OPEN'
//    , PChar(ExtractFilePath(ParamStr(0))+'bin\delcert.exe')
//    , PChar(WorkFolder+'\bootres.dll')
//    , nil
//    , SW_HIDE);
  StripAuthenticode(WorkFolder + '\bootres.dll');


  //let's first make sure the language of the resource
  sleep(3000);
  GetResourceLanguage;
  PatchWIM;
(*  if not IsCheckSumValid(WorkFolder+'\bootres.dll', True) then
  ShowMessage('INVALID');

  if IsCheckSumValid(WorkFolder+'\bootres.dll', False) then
  ShowMessage('FIXED');*)
  //now lets sign it
  if not FileExists(ExtractFilePath(ParamStr(0))+'bin\signer.exe') then
    MessageDlg('Error, signer.exe not found in bin directory, please add it!', mtError, [mbOK], 0);
  ShellExecute(Handle
    , 'OPEN'
    , PChar(ExtractFilePath(ParamStr(0))+'bin\signer.exe')
    , PChar('/sign Codigobit "'+WorkFolder+'\bootres.dll'+'"')
    , nil
    , SW_HIDE);
  DimBackground(Self, False);
end;

procedure TWin8BootLogo.btnTestModeClick(Sender: TObject);
begin
    if MyMessageDialog('It is recommended to use Testsigning mode on.'+#13+'However it will show a watermark in the right bottom part of your desktop.',mtConfirmation,[mbYes, mbNo],['ON','OFF'])=mrYes then
    begin
      ShellExecute(Handle, 'RunAs', 'bcdedit.exe', pchar('/set TESTSIGNING ON'),nil,SW_HIDE);
    end
    else
    begin
      ShellExecute(Handle, 'RunAs', 'bcdedit.exe', pchar('/set TESTSIGNING OFF'),nil,SW_HIDE);
    end;
end;

procedure TWin8BootLogo.btnReloadClick(Sender: TObject);
begin
  if FileExists(LoadedPicture) then
  begin
    Seleccionador.Visible := True;
    btnCreatePictures.Enabled := True;
    btnReload.Enabled := True;
    ImgView321.Bitmap.LoadFromFile(LoadedPicture);
  end;
end;

procedure TWin8BootLogo.btnHelpClick(Sender: TObject);
begin
      MessageDlg(Help,mtInformation,[mbOK],0);
end;

procedure TWin8BootLogo.btnBkpShell32MuiClick(Sender: TObject);
begin
  // if there is no backup and caption says to backup then lets backup
  if not IsShell32BackupThere and (btnBkpShell32Mui.Caption = 'Backup shell32.dll.mui') then
  begin
    ShellExecute(handle, 'RunAs', 'cmd', pchar('/t:0A /c '
            +'echo Windows 8 Boot Logo Changer by vhanla&&'
            +'echo.&&echo Making backup of shell32.dll.mui&&'
            +'copy "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui" "'+GetWindowsDir+'shell32.dll.mui.bkp"&&echo Backup done!&&pause'),nil,sw_show);
    IsShell32BackupThere;
  end
  else if IsShell32BackupThere and (btnBkpShell32Mui.Caption = 'Restore shell32.dll.mui') then
  begin
    //it only matters to rename it back to .mui the .bkp file, patched can't be deleted for some unknown reason
    if FileExists(GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.bkp') then
    begin
      ShellExecute(Handle, 'RunAs', 'cmd', pchar('/t:0A /c '
      +'echo Windows 8 Boot Logo Changer by vhanla&&'
      +'echo.&&echo Changing shell32.dll.mui permissions&&'
      +'takeown /f '+GetWindowsDir+'System32\shell32.dll&&'
      +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /grant '+GetUserFromWindows+':f&&'
      +'takeown /f '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui&&'
      +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /grant '+GetUserFromWindows+':f&&'
      +'echo.&&echo Restoring shell32.dll.mui&&'
      +'ren "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui" shell32.dll.patched&&echo Patch done!&&'
      +'ren "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.bkp" shell32.dll.mui&&echo Restored!&&'
      +'echo.&&echo Restoring file ownership&&'
      +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
      +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /remove '+GetUserFromWindows+'&&'
      +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
      +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /remove '+GetUserFromWindows+'&&echo.&&ALL DONE!, now you can restart explorer.exe to see changes.'
      +'pause'),nil,sw_show);
    end
    else
    begin
      if (FileExists(GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.patched'))
      and not FileExists(GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.bkp') then
        MessageDlg('Already restored!.',mtWarning,[mbOK],0)
      else
        MessageDlg('Sorry, but it seems that shell32.dll.bkp files has been deleted or you might have used another patcher.',mtWarning,[mbOK],0);
    end;
  end;
end;

//http://stackoverflow.com/a/1499526
procedure UpdateResString(AFileName, ANewString: string; AStringIdent: Integer);
  procedure WriteToArray(AArray: TByteDynArray; AData: Word; var APos: Integer);
  begin
    AArray[APos] := Lo(AData);
    AArray[APos + 1] := Hi(AData);
    Inc(APos, 2);
  end;

  function ReadFromArray(AArray: TByteDynArray; APos: Integer): Word;
  begin
    Result := AArray[APos] + AArray[APos + 1] * 16;
  end;

var
  hModule, hResInfo, hUpdate: THandle;
  ResData, TempData: TByteDynArray;
  wsNewString: WideString;
  iSection, iIndexInSection: Integer;
  i, iLen, iSkip, iPos: Integer;
begin
  hModule := LoadLibrary(PChar(AFileName));
  if hModule = 0 then
    raise Exception.CreateFmt('file %s failed to load.', [AFileName]);

  // Calculate the resource string area and the string index in that area
  iSection := AStringIdent div 16 + 1;
  iIndexInSection := AStringIdent mod 16;

  // If the resource already exists, then read it out of the original data
  hResInfo := FindResource(hModule, MakeIntResource(iSection), RT_STRING);
  if hResInfo <> 0 then
  begin
    iLen := SizeOfResource(hModule, hResInfo);
    SetLength(ResData, iLen);
    CopyMemory(ResData, LockResource(LoadResource(hModule, hResInfo)), iLen);
  end;
  // Should first close the file, and then update
  FreeLibrary(hModule);
  // Calculate the new data is written to location
  wsNewString := WideString(ANewString);
  iLen := Length(wsNewString);
  iPos := 0;
  for i := 0 to iIndexInSection do
  begin
    if iPos > High(ResData) then
      SetLength(ResData, iPos + 2);
    if i <> iIndexInSection then
    begin
      iSkip := (ReadFromArray(ResData, iPos) + 1) * 2;
      Inc(iPos, iSkip);
    end;
  end;

  // Delete the original data and the data behind the temporary
  // storage of data to be added
  iSkip := (ReadFromArray(ResData, iPos) + 1) * 2;
  TempData := Copy(ResData, iPos + iSkip, Length(ResData) - iSkip);
  SetLength(ResData, iPos);
  SetLength(ResData, iPos + (iLen + 1) * 2 + Length(TempData));

  // Write new data
  WriteToArray(ResData, iLen, iPos);
  for i := 1 to iLen do
    WriteToArray(ResData, Ord(wsNewString[i]), iPos);
  // Write back to the original data
  for i := 0 to High(TempData) do
    ResData[iPos + i] := TempData[i];

  // Write the data back to file
  hUpdate := BeginUpdateResource(PChar(AFileName), False);
  if hUpdate = 0 then
    raise Exception.CreateFmt(
      'cannot write file %s. Please check whether it is open or set read-only.',
      [AFileName]);

  UpdateResource(hUpdate, RT_STRING, MakeIntResource(iSection), 1033,
    ResData, Length(ResData));
  EndUpdateResource(hUpdate, False);
end;

//this will load the strings in listbox3 and listbox4
procedure LoadMUIStrings;
var
  hmui: Cardinal;
  buff: array[0..1024] of char;
  res : HRSRC;
begin
  //loadstring from system32.dll.mui
  Win8BootLogo.lstShell32Mui.Items.Clear;
  hmui := LoadLibrary(PChar(GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'));
  try
    res := LoadString(hmui, 33088, buff, sizeof(buff));
    Win8BootLogo.lstShell32Mui.Items.Add(buff);
    res := LoadString(hmui, 33108, buff, sizeof(buff));
    Win8BootLogo.lstShell32Mui.Items.Add(buff);
    res := LoadString(hmui, 33109, buff, sizeof(buff));
    Win8BootLogo.lstShell32Mui.Items.Add(buff);
    res := LoadString(hmui, 33110, buff, sizeof(buff));
    Win8BootLogo.lstShell32Mui.Items.Add(buff);
  finally
    FreeLibrary(hmui);
  end;
  //loadstring from basbrd.dll.mui
  Win8BootLogo.lstBasebrdMui.Items.Clear;
  hmui := LoadLibrary(PChar(GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'));
  try
    res := LoadString(hmui, 12, buff, sizeof(buff));
    Win8BootLogo.lstBasebrdMui.Items.Add(buff);
    res := LoadString(hmui, 13, buff, sizeof(buff));
    Win8BootLogo.lstBasebrdMui.Items.Add(buff);
  finally
    FreeLibrary(hmui);
  end;
end;

procedure TWin8BootLogo.btnPatchShell32MuiClick(Sender: TObject);
var
  shell32muifile: string; //workfolder editable file
begin
  shell32muifile := WorkFolder+'\shell32.dll.mui';
  CopyFile(PChar(GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'),PChar(shell32muifile),False);
  GetResourceLanguageMUI(shell32muifile);
  ExtractMUI(shell32muifile);
  DeleteMUI(shell32muifile);
  UpdateResString(WorkFolder+'\shell32.dll.mui','             ',33088);
  UpdateResString(WorkFolder+'\shell32.dll.mui','             ',33108);
  UpdateResString(WorkFolder+'\shell32.dll.mui','                ',33109);
  UpdateResString(WorkFolder+'\shell32.dll.mui','                          ',33110);
  RestoreMUI(shell32muifile);

  if IsShell32BackupThere then
  begin
    //lets first kill explorer
//    PostMessage(FindWindow('Shell_TrayWnd',nil),WM_USER+436,0,0);
//    Sleep(3000);
    if not FileExists(GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.bkp') then
    begin
      if FileExists(GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.patched') then
      begin
        //if there is already there the patched file, then we just rename them
        ShellExecute(Handle, 'RunAs', 'cmd', pchar('/t:0A /c '
        +'echo Windows 8 Boot Logo Changer by vhanla&&'
        +'echo.&&echo Changing shell32.dll.mui permissions&&'
        +'takeown /f '+GetWindowsDir+'System32\shell32.dll&&'
        +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /grant '+GetUserFromWindows+':f&&'
        +'takeown /f '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui&&'
        +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /grant '+GetUserFromWindows+':f&&'
        +'echo.&&echo Patching shell32.dll.mui&&'
        +'ren "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui" shell32.dll.bkp&&echo Patch done!&&'
        +'ren "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.patched" shell32.dll.mui&&echo Patch done!&&'
        +'echo.&&echo Restoring file ownership&&'
        +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
        +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /remove '+GetUserFromWindows+'&&'
        +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
        +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /remove '+GetUserFromWindows+'&&echo.&&echo ALL DONE!, now you can restart explorer.exe to see changes.'
        +'pause'),nil,sw_show);
      end
      else
      begin
        ShellExecute(Handle, 'RunAs', 'cmd', pchar('/t:0A /c '
        +'echo Windows 8 Boot Logo Changer by vhanla&&'
        +'echo.&&echo Changing shell32.dll.mui permissions&&'
        +'takeown /f '+GetWindowsDir+'System32\shell32.dll&&'
        +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /grant '+GetUserFromWindows+':f&&'
        +'takeown /f '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui&&'
        +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /grant '+GetUserFromWindows+':f&&'
        +'echo.&&echo Patching shell32.dll.mui&&'
        +'copy /Y "'+WorkFolder+'\shell32.dll.mui" "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell33.dll.mui"&&echo Patch done!&&'
        +'ren "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui" shell32.dll.bkp&&echo Patch done!&&'
        +'ren "'+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell33.dll.mui" shell32.dll.mui&&echo Patch done!&&'
        +'echo.&&echo Restoring file ownership&&'
        +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
        +'icacls '+GetWindowsDir+'System32\'+GetWindowsCurrentLocalizationFolder+'\shell32.dll.mui'+' /remove '+GetUserFromWindows+'&&'
        +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
        +'icacls '+GetWindowsDir+'System32\shell32.dll'+' /remove '+GetUserFromWindows+'&&echo.&&echo ALL DONE!, now you can restart explorer.exe to see changes.'
        +'pause'),nil,sw_show);
      end;
    end
    else
    begin //it means is already patched
      MessageDlg('Your shell32.dll.mui file has already been patched!',mtInformation,[mbOK],0);
    end;

//    MessageDlg('Wait till it completes the command line and asks you to press your any key.'#13'Then hit OK button',mtInformation, [mbOK],0);

//    WinExec('explorer.exe',SW_NORMAL); //y volvemos a ejecutar explorer
  end
  else
    MessageDlg('You should make a backup of shell32.dll.mui first!',mtError,[mbOK],0);
end;

procedure TWin8BootLogo.btnBkpBasebrdmuiClick(Sender: TObject);
begin
  // if there is no backup and caption says to backup then lets backup
  if not IsBasebrdBackupThere and (btnBkpBasebrdmui.Caption = 'Backup basebrd.dll.mui') then
  begin
    ShellExecute(handle, 'RunAs', 'cmd', pchar('/t:0A /c '
            +'echo Windows 8 Boot Logo Changer by vhanla&&'
            +'echo.&&echo Making backup of basebrd.dll.mui&&'
            +'copy "'+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui" "'+GetWindowsDir+'basebrd.dll.mui.bkp"&&echo Backup done!&&pause'),nil,sw_show);
    IsBasebrdBackupThere;
  end
  else if IsBasebrdBackupThere and (btnBkpBasebrdmui.Caption = 'Restore basebrd.dll.mui') then
  begin
    //let's change file permissions and replace after that restore file permission
    ShellExecute(Handle, 'RunAs', 'cmd', pchar('/t:0A /c '
      +'echo Windows 8 Boot Logo Changer by vhanla&&'
      +'echo.&&echo Changing basebrd.dll.mui permissions&&'
      +'takeown /f '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui&&'
      +'icacls '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'+' /grant '+GetUserFromWindows+':f&&'
      +'echo.&&echo Restoring basebrd.dll.mui&&'
      +'copy /Y "'+GetWindowsDir+'basebrd.dll.mui.bkp" "'+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui"&&echo Restore done!&&'
      +'echo.&&echo Restoring file ownership&&'
      +'icacls '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
      +'icacls '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'+' /remove '+GetUserFromWindows+'&&'
      +'pause'),nil,sw_show);
  end;
end;

procedure TWin8BootLogo.btnLoadPicClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    LoadedPicture := OpenPictureDialog1.FileName;
    Seleccionador.Visible := True;
    btnCreatePictures.Enabled := True;
    btnReload.Enabled := True;
    ImgView321.Bitmap.LoadFromFile(LoadedPicture);
  end;
end;


procedure TWin8BootLogo.btnPatchBasebrdMuiClick(Sender: TObject);
var
  basebrdmuifile : string;
begin
  basebrdmuifile := WorkFolder+'\basebrd.dll.mui';
  CopyFile(PChar(GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'),PChar(basebrdmuifile),False);
  GetResourceLanguageMUI(WorkFolder+'\basebrd.dll.mui');
  ExtractMUI(WorkFolder+'\basebrd.dll.mui');
  DeleteMUI(WorkFolder+'\basebrd.dll.mui');
  UpdateResString(WorkFolder+'\basebrd.dll.mui','                      ',12);
  UpdateResString(WorkFolder+'\basebrd.dll.mui','                      ',13);
  RestoreMUI(WorkFolder+'\basebrd.dll.mui');

  if IsBasebrdBackupThere then
  begin
    ShellExecute(Handle, 'RunAs', 'cmd', pchar('/t:0A /c '
      +'echo Windows 8 Boot Logo Changer by vhanla&&'
      +'echo.&&echo Changing basebrd.dll.mui permissions&&'
      +'takeown /f '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui&&'
      +'icacls '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'+' /grant '+GetUserFromWindows+':f&&'
      +'echo.&&echo Patching basebrd.dll.mui&&'
      +'copy /Y "'+WorkFolder+'\basebrd.dll.mui" "'+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui"&&echo Restore done!&&'
      +'echo.&&echo Restoring file ownership&&'
      +'icacls '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'+' /setowner "NT Service\TrustedInstaller" /T /C&&'
      +'icacls '+GetWindowsDir+'Branding\Basebrd\'+GetWindowsCurrentLocalizationFolder+'\basebrd.dll.mui'+' /remove '+GetUserFromWindows+'&&'
      +'pause'),nil,sw_show);
  end
  else
    MessageDlg('You have to make a backup of basebrd.dll.mui file',mtError, [mbOK], 0);

end;

procedure TWin8BootLogo.btnRestartExplorerClick(Sender: TObject);
begin
  if MessageDlg('This will close all explorer instances and after that will restart it. Continue?',mtInformation,mbYesNo,0)=mrYes then
  begin
    repeat
      PostMessage(FindWindow('Shell_TrayWnd',nil),WM_USER+436,0,0);
      Sleep(1000);
    until (FindWindow('Shell_TrayWnd',nil) = 0);
    WinExec('explorer.exe',SW_NORMAL); //y volvemos a ejecutar explorer
    LoadMUIStrings;
  end;
end;

procedure TWin8BootLogo.DropComboTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
begin
  if DropComboTarget1.Files.Count <> 1 then
    MessageDlg('You should not drag more than one picture file.',mtError, [mbOK], 0)
  else
  begin
    try
      LoadedPicture := DropComboTarget1.Files[0];
      Seleccionador.Visible := True;
      btnCreatePictures.Enabled := True;
      btnReload.Enabled := True;
      ImgView321.Bitmap.LoadFromFile(LoadedPicture);
    except
     on e:Exception do
     begin
      raise Exception.Create(e.Message);
     end;
    end;
  end;

end;

procedure TWin8BootLogo.FormCreate(Sender: TObject);
var
  exebit: DWORD;
  weare64bit : BOOL;
var
  hMenu : THandle;
begin
  LogMsg('App started.');
//  ShowMessage(GetUserFromWindows);
  weare64bit := False;
(*  if exebit = SCS_32BIT_BINARY then
    weare64bit := False
  else if exebit = SCS_64BIT_BINARY then
    weare64bit := True;*)//<<<- this tricks seems not to work properly

  //little trick from http://helloacm.com/a-quick-check-if-32-or-64-bit-os/
  if SizeOf(Pointer)=8 then
  weare64bit := True;

  if not CheckWin32Version(6,2) then
  begin
    ShowMessage('This tool is only for Windows 8 or newer');
    Application.Terminate;
  end;
  lblOS.Caption := 'System Version: ' + JclSysInfo.GetWindowsVersionString
  + ' ' + JclSysInfo.GetWindowsEditionString;
  if JclSysInfo.IsWindows64 then lblOS.Caption := lblOS.Caption + ' 64bit' else
    lblOS.Caption := lblOS.Caption + ' 32bit';
  LogMsg('OS version detected -> '+ lblOS.Caption);

  if IsUEFI then
    lblBIOS.Caption := 'BIOS boot mode: UEFI'
  else
    lblBIOS.Caption := 'BIOS boot mode: Legacy';
  LogMsg('BIOS mode detected -> ' + lblBIOS.Caption);

  if IsTestSigningModeOn then
    lblTest.Caption := 'TestSigning: ON'
  else
    lblTest.Caption := 'TestSigning: OFF';
  LogMsg('TestSigning detected -> ' + lblTest.Caption);

  //set work folder
  //use current if not in programfiles folder

  if (Pos(GetSpecialFolderPath(CSIDL_PROGRAM_FILES,False), ExtractFilePath(ParamStr(0))) = 1)
  or (Pos(GetSpecialFolderPath(CSIDL_PROGRAM_FILESX86,False), ExtractFilePath(ParamStr(0))) = 1)
  then
  begin
    if not DirectoryExists(GetSpecialFolderPath(CSIDL_APPDATA, False)+'\8ootLogoChanger') then
      if not CreateDir(GetSpecialFolderPath(CSIDL_APPDATA, False)+'\8ootLogoChanger') then
      begin
        raise Exception.Create('Couldn''t create work directory, we cannot proceed.');
        Application.Terminate;
      end;
    WorkFolder := GetSpecialFolderPath(CSIDL_APPDATA, False)+'\8ootLogoChanger';
  end
  else
  begin
    if not DirectoryExists(ExtractFilePath(ParamStr(0))+'temp') then
      if not CreateDir(ExtractFilePath(ParamStr(0))+'temp') then
      begin
        raise Exception.Create('Couldn''t create work directory, we cannot proceed.');
        Application.Terminate;
      end;
    WorkFolder := ExtractFilePath(ParamStr(0))+'temp';
  end;

  if IsBackupThere then
  begin
    OriginalDLL := GetWindowsDir+'bootres.bkp';
    if IsCodeSigned(OriginalDLL) then
      lblBkpBootres.Caption := 'Backup Bootres.dll: signed by ' + GetCertCompanyName(OriginalDLL)
      +' File Version: ' + FileVersionGet(OriginalDLL);
  end
  else
    OriginalDLL := GetWindowsDir+'Boot\Resources\bootres.dll';

  if IsCodeSigned(GetWindowsDir+'Boot\Resources\bootres.dll') then
    lblBootres.Caption := 'Current Bootres.dll: signed by ' + GetCertCompanyName(GetWindowsDir+'Boot\Resources\bootres.dll');
    

//  BootResDLL := ExtractFilePath(ParamStr(0))+'bootres.dll';
  BootResDLL := WorkFolder+'\bootres.wim';

  if weare64bit then
  begin
    if BootresVersion = 64 then
    begin
      //all is good
    end
    else if BootresVersion = 32 then
    begin
      raise Exception.Create('Bootres.dll is a 32bit dll file, and you''re on Windows 64bits, something weird is happening, fix it with SFC /SCANNOW');
      Application.Terminate;
    end;

  end
  else
  begin
    if BootresVersion = 32 then
    begin
    //cool
    end
    else if BootresVersion = 64 then
    begin
      raise Exception.Create('Bootres.dll is a 64bit dll file, you need to use the 64bit compatible tool, get it at codigobit.net');
      Application.Terminate;
    end;
  end;

  //if everything good, lets continue

  hMenu := GetSystemMenu(Application.Handle,False);
  AppendMenu(hMenu,mf_Separator,0,'');
  AppendMenu(hMenu,mf_Enabled,$E010,'Item de Aplicacion');
  hMenu := GetSystemMenu(Win8BootLogo.Handle,False);
  AppendMenu(hMenu,mf_Separator,0,'');
  AppendMenu(hMenu,mf_Enabled,$E020,'About 8oot Logo Changer...');

  Application.OnMessage := AppMsg;


  if FileExists(GetWindowsDir + 'Boot\Resources\bootres.dll') then
  begin
    var ca := 'none';
    if IsCodeSigned(GetWindowsDir+'Boot\Resources\bootres.dll') then
      ca := GetCertCompanyName(GetWindowsDir+'Boot\Resources\bootres.dll');
      
    GetFileOwner(GetWindowsDir + 'Boot\Resources\bootres.dll',Domain, Username);
      lblBackupedFiles.Caption := 'File : '+GetWindowsDir+'Boot\Resources\bootres.dll'+
      #13'File Architecture : '+IntToStr(BootresVersion)+' bit'+
      #13'File owner : '+Username+
      #13'File version : '+FileVersionGet(GetWindowsDir + 'Boot\Resources\bootres.dll')+
      #13'File Digital Signature : ' + ca;
  end;

  if IsBackupThere then
    btnBackupRestore.Caption := '&Restore'
  else
    btnBackupRestore.Caption := '&Backup';

  if IsShell32BackupThere then
    btnBkpShell32Mui.Caption := 'Restore shell32.dll.mui'
  else
    btnBkpShell32Mui.Caption := 'Backup shell32.dll.mui';

  if IsBasebrdBackupThere then
    btnBkpBasebrdmui.Caption := 'Restore basebrd.dll.mui'
  else
    btnBkpBasebrdmui.Caption := 'Backup basebrd.dll.mui';

   DropComboTarget1.Formats := [mfFile];

   //let's create the seleccionador
   Seleccionador := TSeleccionador.Create(ImgView321.Layers);
   Seleccionador.MinHeight := 72;
   Seleccionador.MinWidth := 82;
   Seleccionador.Location := FloatRect(0,0,81, 71);
   Seleccionador.FillColor := Color32(49,101,185);
   Seleccionador.Handles:= Seleccionador.Handles-[rhSides];
   Seleccionador.Options:= [roProportional, roConstrained];
   Seleccionador.OnResizing:=Seleccionador.GetResize;
   Seleccionador.HandleSize := 3;
   Seleccionador.Visible := False;
   btnCreatePictures.Enabled := False;
   ImgView321.ScaleMode := smOptimalScaled;

  //lets extract the actual bootres wim file to work folder
  if FileExists(WorkFolder+'\bootres.wim') then
  begin
    if DeleteFile(WorkFolder+'\bootres.wim') then
      ExtractBootResWim;
  end
  else
    ExtractBootResWim;

  ExtractBitmapOnListBoxOnly;
  LoadListofBMPs;

  Back := TForm.Create(nil);

  LoadMUIStrings;
end;

procedure TWin8BootLogo.FormDestroy(Sender: TObject);
begin
  Back.Free;
end;

function TWin8BootLogo.GetCertCompanyName(const fn: string): string;
var
  hExe: HMODULE;
  Cert: PWinCertificate;
  CertContext: PCCERT_CONTEXT;
  CertCount: DWORD;
  CertName: AnsiString;
  CertNameLen: DWORD;
  VerifyParams: CRYPT_VERIFY_MESSAGE_PARA;
begin
  Result := '';
  // Verify that the exe was signed by our private key
  hExe := CreateFile(PChar(fn), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS, 0);
  if hExe = INVALID_HANDLE_VALUE then
    Exit;
  try
    // There should only be one certificate associated with the exe
    if (not ImageEnumerateCertificates(hExe, CERT_SECTION_TYPE_ANY, CertCount, nil, 0)) or
      (CertCount <> 1) then
      Exit;
    // Read the certificate hader so we can get the size needed for the full cert
    GetMem(Cert, SizeOf(TWinCertificate) + 3); // ImageGetCertificateHeader writes a DWORD at bCertificate for some reason
    try
      Cert.dwLength := 0;
      Cert.wRevision := WIN_CERT_REVISION_1_0;
      if not ImageGetCertificateHeader(hExe, 0, Cert^) then
        Exit;
      // Read the full certificate
      ReallocMem(Cert, SizeOf(TWinCertificate) + Cert.dwLength);
      if not ImageGetCertificateData(hExe, 0, Cert, Cert.dwLength) then
        Exit;
      // Get the certificate context. CryptVerifyMessageSignature has the
      // side effect of creating a context for the signing certificate.
      FillChar(VerifyParams, SizeOf(VerifyParams), 0);
      VerifyParams.cbSize := SizeOf(VerifyParams);
      VerifyParams.dwMsgAndCertEncodingType := X509_ASN_ENCODING or PKCS_7_ASN_ENCODING;
      if not CryptVerifyMessageSignature(VerifyParams, 0, @Cert.bCertificate,
        Cert.dwLength, nil, nil, @CertContext) then
        Exit;
      try
        // Extract and compare the certificate's subject names. Don't
        // compare the entire certificate or the public key as those will
        // change when the certificate is renewed.
        CertNameLen := CertGetNameStringA(CertContext,
          CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, nil, nil, 0);
        SetLength(CertName, CertNameLen - 1);
        CertGetNameStringA(CertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0,
          nil, PAnsiChar(CertName), CertNameLen);
        Result := CertName;
        if CertName <> '' then
          Exit;
      finally
        CertFreeCertificateContext(CertContext);
      end;
    finally
      FreeMem(Cert);
    end;
  finally
    CloseHandle(hExe);
  end;
end;

function TWin8BootLogo.IsCodeSigned(const fn: string): Boolean;
var
  file_info: TWinTrustFileInfo;
  trust_data: TWinTrustData;
begin
  // Verify that the exe is signed and the checksum matches
  FillChar(file_info, SizeOf(file_info), 0);
  file_info.cbStruct := SizeOf(file_info);
  file_info.pcwszFilePath := PWideChar(WideString(fn));
  FillChar(trust_data, SizeOf(trust_data),0);
  trust_data.cbStruct := SizeOf(trust_data);
  trust_data.dwUIChoice := WTD_UI_NONE;
  trust_data.fdwRevocationChecks := WTD_REVOKE_NONE;
  trust_data.dwUnionChoice := WTD_CHOICE_FILE;
  trust_data.pFile := @file_info;
  Result := WinVerifyTrust(INVALID_HANDLE_VALUE, WINTRUST_ACTION_GENERIC_VERIFY_V2,
  @trust_data) = ERROR_SUCCESS;
end;

function TWin8BootLogo.IsCompanySigningCertificate(const fn,
  cn: string): Boolean;
var
  hExe: HMODULE;
  Cert: PWinCertificate;
  CertContext: PCCERT_CONTEXT;
  CertCount: DWORD;
  CertName: AnsiString;
  CertNameLen: DWORD;
  VerifyParams: CRYPT_VERIFY_MESSAGE_PARA;
begin
  // Returns TRUE if the SubjectName on the certificate used to sign the exe is
  // "Company Name". Should prevent a cracker from modifying the file and
  // re-signing it with their own certificate.
  //
  // Microsoft has an example that does this using CryptQueryObject and
  // CertFinCertificateInStore instead of CryptVerifyMessageSignature, but
  // CryptQueryObject is NT-Only. Using CertCreateCertificateContext doesn't work
  // either, though I don't know why.
  Result := False;
  // Verify that the exe was signed by our private key
  hExe := CreateFile(PChar(fn), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS, 0);
  if hExe = INVALID_HANDLE_VALUE then
    Exit;
  try
    // There should only be one certificate associated with the exe
    if (not ImageEnumerateCertificates(hExe, CERT_SECTION_TYPE_ANY, CertCount, nil, 0)) or
      (CertCount <> 1) then
      Exit;
    // Read the certificate header so we can get the size needed for the full cert
    GetMem(Cert, SizeOf(TWinCertificate) + 3); // ImageGetCertificateHeader writes a DWORD at bCertificate for some reason
    try
      Cert.dwLength := 0;
      Cert.wRevision := WIN_CERT_REVISION_1_0;
      if not ImageGetCertificateHeader(hExe, 0, Cert^) then
        Exit;
      // Read the full certificate
      ReallocMem(Cert, SizeOf(TWinCertificate) + Cert.dwLength);
      if not ImageGetCertificateData(hExe, 0, Cert, Cert.dwLength) then
        Exit;
      // Get the certificate context. CryptVerifyMessageSignature has the
      // side effect of creating a context for the signing certificate.
      FillChar(VerifyParams, SizeOf(VerifyParams), 0);
      VerifyParams.cbSize := SizeOf(VerifyParams);
      VerifyParams.dwMsgAndCertEncodingType := X509_ASN_ENCODING or PKCS_7_ASN_ENCODING;
      if not CryptVerifyMessageSignature(VerifyParams, 0, @Cert.bCertificate,
        Cert.dwLength, nil, nil, @CertContext) then
        Exit;
      try
        // Extract and compare the certificate's subject names. Don't
        // compare the entire certificate or the public key as those will
        // change when the certificate is renewed.
        CertNameLen := CertGetNameStringA(CertContext,
          CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, nil, nil, 0);
        SetLength(CertName, CertNameLen - 1);
        CertGetNameStringA(CertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0,
          nil, PAnsiChar(CertName), CertNameLen);
        if CertName <> cn then
          Exit;
      finally
        CertFreeCertificateContext(CertContext);
      end;
    finally
      FreeMem(Cert);
    end;
  finally
    CloseHandle(hExe);
  end;
  Result := True;
end;

procedure TWin8BootLogo.Label5Click(Sender: TObject);
begin
  ShellExecute(Handle, 'OPEN', PChar('http://codigobit.net'),nil,nil,SW_SHOWNORMAL);
end;

procedure TWin8BootLogo.lstOriginalPicsDblClick(Sender: TObject);
const
  BytesToCopy = 90113;
var
  Arch : TJclDecompressArchive;
  I :Integer;
  Dex: TMemoryStream;
  bmp : TBitmap;
  bitdepth: string;
begin
  with lstOriginalPics do
  begin
    if (ItemIndex >= 0) and (Items.Count > ItemIndex) then
    begin
      //ShowMessage(IntToStr(ItemIndex));
      //Lets extract that picture
      if FileExists(BootResDLL) then
      begin
        try
          Arch := TJclWimDecompressArchive.Create(BootResDLL, 0, False);
          try
            Arch.ListFiles;
            for I := 0 to Arch.ItemCount - 1 do
            begin
              if not Arch.Items[I].Directory then
              begin
                if Arch.Items[I].PackedName = Items[ItemIndex] then
                begin
                  Dex := TMemoryStream.Create;
                  try
                    Arch.Items[I].Stream := Dex;
                    Arch.Items[I].OwnsStream := False;
                    Arch.Items[I].Selected := True;
                    Arch.ExtractSelected();
                    Arch.Items[I].Selected := True;
                    //Dex.SaveToFile(ExtractFilePath(ParamStr(0))+'bitmaps.wim');
                    Dex.Position := 0;
                    ImgView321.Bitmap.LoadFromStream(Dex);

                    //disable seleccionador visibility
                    Seleccionador.Visible := False;
                    btnCreatePictures.Enabled := False;
                    //frmPreview.Image321.Bitmap := ImgView321.Bitmap;
                    //lets find out the dimensions
                    bmp := TBitmap.Create;
                    try
                      Dex.Position := 0;
                      bmp.LoadFromStream(Dex);
                      case bmp.PixelFormat of
                        pfDevice: bitdepth := 'Device';
                        pf1bit: bitdepth := '1bit';
                        pf4bit: bitdepth := '4bit';
                        pf8bit: bitdepth := '8bit';
                        pf15bit: bitdepth := '15bit';
                        pf16bit: bitdepth := '16bit';
                        pf24bit: bitdepth := '24bit';
                        pf32bit: bitdepth := '32bit';
                        pfCustom: bitdepth := 'Custom';
                      end;

                    Label2.Caption := 'Width : '+IntToStr(ImgView321.Bitmap.BoundsRect.Width)+
                                      ' Height: '+IntToStr(ImgView321.Bitmap.BoundsRect.Height)+
                                      ' Bit: '+bitdepth;
                    finally
                      bmp.Free;
                    end;
                  finally
                    Dex.Free;
                  end;
                end;
              end;
            end;
          finally
            FreeAndNil(Arch);
          end;
        except
          on e:Exception do
          begin
            raise Exception.Create(Format('ERROR: [%s] %s', [E.ClassName, E.Message]));Raise;
          end;
        end;
      end;
    end;
  end;
end;

procedure TWin8BootLogo.lstEditedPicsDblClick(Sender: TObject);
var
  I :Integer;
  bmp : TBitmap;
  bitdepth: string;
begin
  with lstEditedPics do
  begin
    if (ItemIndex >= 0) and (Items.Count > ItemIndex) then
    begin
      if FileExists(WorkFolder+'\'+Items[ItemIndex]) then
      begin
        ImgView321.Bitmap.LoadFromFile(WorkFolder+'\'+Items[ItemIndex]);
        //disable seleccionador visibility
        Seleccionador.Visible := False;
        btnCreatePictures.Enabled := False;
        bmp := TBitmap.Create;
        try
          bmp.LoadFromFile(WorkFolder+'\'+Items[ItemIndex]);
          case bmp.PixelFormat of
            pfDevice: bitdepth := 'Device';
            pf1bit: bitdepth := '1bit';
            pf4bit: bitdepth := '4bit';
            pf8bit: bitdepth := '8bit';
            pf15bit: bitdepth := '15bit';
            pf16bit: bitdepth := '16bit';
            pf24bit: bitdepth := '24bit';
            pf32bit: bitdepth := '32bit';
            pfCustom: bitdepth := 'Custom';
          end;

        Label2.Caption := 'Width : '+IntToStr(ImgView321.Bitmap.BoundsRect.Width)+
                          ' Height: '+IntToStr(ImgView321.Bitmap.BoundsRect.Height)+
                          ' Bit: '+bitdepth;
        finally
          bmp.Free;
        end;
      end;
    end;
  end;
end;

procedure TWin8BootLogo.LogMsg(const text: String);
begin
  mmLog.Lines.Add(text);
  mmLog.Perform(EM_SCROLL, SB_LINEDOWN, 0);
end;

function TWin8BootLogo.StripAuthenticode(const fn: string): Boolean;
var
  hExe: HMODULE;
begin
  Result := False;
  hExe := CreateFile(PChar(fn), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS, 0);
  if hExe = INVALID_HANDLE_VALUE then
    Exit;
  try
    Result := ImageRemoveCertificate(hExe, 0);
  finally
    CloseHandle(hExe);
  end;
end;

procedure TWin8BootLogo.AppMsg(var msg: tagMSG; var Handled: Boolean);
begin
  if msg.message = WM_SYSCOMMAND then
  begin
    if msg.wParam = $E020 then
    begin
      Handled := True;
      MessageDlg(About,mtInformation,[mbOK],0);
    end;

  end;

end;



end.
