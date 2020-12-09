program Change8ootLogo;





{$R *.dres}

uses
  Vcl.Forms,
  BootLogoChanger_src in 'BootLogoChanger_src.pas' {Win8BootLogo},
  Vcl.Themes,
  Vcl.Styles,
  frmPreview_src in 'frmPreview_src.pas' {frmPreview};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //http://stackoverflow.com/questions/8598728/how-to-disable-vcl-styles-in-delphi
  //disable theme on this form
  TStyleManager.TrySetStyle('Light');
  TStyleManager.Engine.RegisterStyleHook(TfrmPreview, TStyleHook);
  Application.CreateForm(TWin8BootLogo, Win8BootLogo);
  Application.CreateForm(TfrmPreview, frmPreview);
  Application.Run;
end.
