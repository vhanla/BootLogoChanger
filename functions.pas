unit functions;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GR32_Image, Vcl.ExtDlgs, ShellApi, AccCtrl, AclApi,
  DragDrop, DragDropContext, DragDropHandler, DropTarget, DragDropFile,
  DropHandler, DropComboTarget, GR32_Resamplers, gr32, GR32_Layers, gr32_polygons, shlobj,
  Vcl.Buttons, imagehlp, Vcl.ExtCtrls, Vcl.ComCtrls, System.Types, JclSysInfo;

const
  SystemCodeIntegrityInformation = $67;
  CODEINTEGRITY_OPTION_TESTSIGN = 2;

type
  PCCERT_CONTEXT = type Pointer;
  HCRYPTPROV_LEGACY = type Pointer;
  PFN_CRYPT_GET_SIGNER_CERTIFICATE = type Pointer;

  CRYPT_VERIFY_MESSAGE_PARA = record
    cbSize: DWORD;
    dwMsgAndCertEncodingType: DWORD;
    hCryptProv: HCRYPTPROV_LEGACY;
    pfnGetSignerCertificate: PFN_CRYPT_GET_SIGNER_CERTIFICATE;
    pvGetArg: Pointer;
  end;

  TSystemInformationClass = (
    SystemBasicInformation = 0,
    SystemPerformanceInformation = 2,
    SystemTimeOfDayInformation = 3,
    SystemProcessInformation = 5,
    SystemProcessorPerformanceInformation = 8,
    SystemInterruptInformation = 23,
    SystemExceptionInformation = 33,
    SystemRegistryQuotaInformation = 37,
    SystemLookasideInformation = 45
  );
  TSystemCodeIntegrityInformation = record
    Length: ULONG;
    CodeIntegrityOptions: ULONG;
  end;

function FileVersionGet( const sgFileName : string ) : string;
function IsTestSigningModeOn: Boolean;
function VignetteBrightness(X,Y: Single): Single;
procedure Vignette(ASource: TBitmap32);

function ConvertStringSidToSid(StringSid: PWideChar; var Sid: PSID): Boolean; stdcall; external 'advapi32.dll' name
'ConvertStringSidToSidW';

function ConvertStringSidToSidA(StringSid: PANsiChar; var Sid: PSID): Boolean; stdcall; external 'advapi32.dll' name
'ConvertStringSidToSidA';

function NtQuerySystemInformation(SystemInformationClass: LongInt; SystemInformation: Pointer; SystemInformationLength: ULONG; ReturnLength: PDWORD): Integer; stdcall;
external 'ntdll.dll' name 'NtQuerySystemInformation';

function GetFirmwareEnvironmentVariableA(lpName, lpGuid: LPCSTR; pBuffer: Pointer;
  nSize: DWORD): DWORD; stdcall;
external kernel32 name 'GetFirmwareEnvironmentVariableA';

function ImageEnumerateCertificates(FileHandle: THandle; TypeFilter: WORD;
  out CertificateCount: DWORD; Indicies: PDWORD; IndexCount: Integer): BOOL; stdcall;
external 'Imagehlp.dll';

function ImageGetCertificateHeader(FileHandle: THandle; CertificateIndex: Integer;
  var CertificateHeader: TWinCertificate): BOOL; stdcall;
external 'Imagehlp.dll';

function ImageGetCertificateData(FileHandle: THandle; CertificateIndex: Integer;
  Certificate: PWinCertificate; var RequiredLength: DWORD): BOOL; stdcall;
external 'Imagehlp.dll';

function ImageRemoveCertificate(FileHandle: THandle; Index: DWORD): BOOL; stdcall;
external 'Imagehlp.dll';

function CryptVerifyMessageSignature(const pVerifyPara: CRYPT_VERIFY_MESSAGE_PARA;
  dwSignerIndex: DWORD; pbSignedBlob: PByte; cbSignedBlob: DWORD; pbDecoded: PByte;
  pcbDecoded: PDWORD; ppSignerCert: PCCERT_CONTEXT): BOOL; stdcall;
external 'Crypt32.dll';

function CertGetNameStringA(pCertContext: PCCERT_CONTEXT; dwType: DWORD; dwFlags: DWORD;
  pvTypePara: Pointer; pszNameString: PAnsiChar; cchNameString: DWORD): DWORD; stdcall;
external 'Crypt32.dll';

function CertFreeCertificateContext(pCertContext: PCCERT_CONTEXT): BOOL; stdcall;
external 'Crypt32.dll';

function CertCreateCertificateContext(dwCertEncodingType: DWORD; pbCertEncoded: PByte;
  cbCertEncoded: DWORD): PCCERT_CONTEXT; stdcall;
external 'Crypt32.dll';

function WinVerifyTrust(hwnd: HWND; const ActionID: TGUID; ActionData: Pointer): LongInt; stdcall;
external wintrust;

implementation

//http://stackoverflow.com/a/5722677
function FileVersionGet( const sgFileName : string ) : string;
var infoSize: DWORD;
var verBuf:   pointer;
var verSize:  UINT;
var wnd:      UINT;
var FixedFileInfo : PVSFixedFileInfo;
begin
  infoSize := GetFileVersioninfoSize(PChar(sgFileName), wnd);

  result := '';

  if infoSize <> 0 then
  begin
    GetMem(verBuf, infoSize);
    try
      if GetFileVersionInfo(PChar(sgFileName), wnd, infoSize, verBuf) then
      begin
        VerQueryValue(verBuf, '\', Pointer(FixedFileInfo), verSize);

        result := IntToStr(FixedFileInfo.dwFileVersionMS div $10000) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionMS and $0FFFF) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionLS div $10000) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionLS and $0FFFF);
      end;
    finally
      FreeMem(verBuf);
    end;
  end;
end;


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


function VignetteBrightness(X,Y: Single): Single;
var
  lDistance: Single;
  lInRad, lOutRad: Single;
begin
  lInRad := 35; //50;
  lOutRad := 55;//150;
//  X := X * 0.75;
  X := X * (115/129); // respecting logo scale ratio
  Y := Y * (129/115);

  // calculate the distance from the origin (center of the image)
  lDistance := Sqrt(Sqr(X) + Sqr(Y));

  if lDistance <= lInRad then
    Result := 1.0 // Brightness 100%
  else if lDistance <= lOutRad then
    //Result := (lDistance - lInRad) / (lOutRad - lInRad)
    Result := (lOutRad - lDistance) / (lOutRad - lInRad)
  else
    Result := 0.0; // it is dark outside the lOutRad (outer radius)
end;

procedure Vignette(ASource: TBitmap32);
  function ClampByte(Value: Integer): Byte;
  begin
    if Value > 255 then
      Result := 255
    (* not necessary when a pixel is multiplied with a positive value
    else if Value < 0
      Result := 0
    *)
    else
      Result := Byte(Value);
  end;
var
  Bits: PColor32Entry;
  I, J, XCenter, YCenter: Integer;
  Brightness: Single;
begin
  XCenter := ASource.Width div 2;
  YCenter := ASource.Height div 2;

  Bits := @ASource.Bits[0];

  for J := 0 to ASource.Height - 1 do
  begin
    for I := 0 to ASource.Width - 1 do
      begin
        Brightness := VignetteBrightness(I - XCenter, J - YCenter) * 0.5{= effect depth} + 0.0{0.3 basic brightness};

        Bits.R := ClampByte(Round(Bits.R * Brightness));
        Bits.G := ClampByte(Round(Bits.G * Brightness));
        Bits.B := ClampByte(Round(Bits.B * Brightness));
//        Bits.A := ClampByte(Round(Bits.A + Brightness));

        Inc(Bits);
      end;
  end;

    ASource.Changed;
end;

end.
