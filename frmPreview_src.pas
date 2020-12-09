unit frmPreview_src;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GR32_Image, Vcl.Themes, Vcl.ExtCtrls, gifimg, pngimage, jpeg,
  Vcl.StdCtrls;

type

  TfrmPreview = class(TForm)

    Image321: TImage32;
    Timer1: TTimer;
    JvGIFAnimator1: TImgView32;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Image321Click(Sender: TObject);
    procedure JvGIFAnimator1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPreview: TfrmPreview;
  gif: TGIFImage;
  gir: TGIFRenderer;
implementation

{$R *.dfm}
uses BootLogoChanger_src;

procedure TfrmPreview.FormClick(Sender: TObject);
begin
    Timer1.Enabled := False;
    JvGIFAnimator1.Visible := False;
    ShowCursor(True);
  close;
end;

procedure TfrmPreview.FormCreate(Sender: TObject);
var
  gif: TGIFImage;
  rs: TResourceStream;
begin
  rs := TResourceStream.Create(HInstance,pchar('LOADING'),RT_RCDATA);
  rs.Position := 0;
  gif := TGIFImage.Create;
  try
    gif.LoadFromStream(rs);
    rs.Position := 0;
    JvGIFAnimator1.Bitmap.Width := gif.Width;
    JvGIFAnimator1.Bitmap.Height := gif.Height;
    JvGIFAnimator1.Width := gif.Width;
    JvGIFAnimator1.Height := gif.Height;
    gir := TGIFRenderer.Create(gif);
    Timer1.Interval := gif.AnimationSpeed;
  finally
//    gif.Free;
  end;
end;

procedure TfrmPreview.FormDestroy(Sender: TObject);
begin
  gir.Free;
  gif.Free;
end;

procedure TfrmPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(27) then
  begin
    Timer1.Enabled := False;
    JvGIFAnimator1.Visible := False;
    ShowCursor(True);
  close;
  end;
end;

procedure TfrmPreview.FormResize(Sender: TObject);
begin

  Image321.Width := 129;
  Image321.Height := 115;
  Image321.Top :=height div 2 - image321.height - 35;//(Height - Image321.Height) div 3 + Image321.Height div 2;
  JvGIFAnimator1.Top := Height - (Height div 4)+10;//Height - (Height - JvGIFAnimator1.Height) div 3;

  Image321.Left := (Width - Image321.Width) div 2;
  JvGIFAnimator1.Left := (Width - JvGIFAnimator1.Width) div 2;
end;

procedure TfrmPreview.FormShow(Sender: TObject);
begin
//  TStyleManager.Engine.RegisterStyleHook(TfrmPreview, TStyleHook);

  Color := clBlack;
  Timer1.Enabled := True;
  JvGIFAnimator1.Visible := True;
  ShowCursor(False);
end;

procedure TfrmPreview.Image321Click(Sender: TObject);
begin
    Timer1.Enabled := False;
    JvGIFAnimator1.Visible := False;
    ShowCursor(True);
  close;
end;

procedure TfrmPreview.JvGIFAnimator1Click(Sender: TObject);
begin
    Timer1.Enabled := False;
    JvGIFAnimator1.Visible := False;
    ShowCursor(True);
  close;
end;

procedure TfrmPreview.Timer1Timer(Sender: TObject);
begin
//  try
    gir.Draw(JvGIFAnimator1.Bitmap.Canvas, JvGIFAnimator1.Bitmap.Canvas.ClipRect);
//  except
//  end;
  Timer1.Interval := gir.FrameDelay;
  gir.NextFrame;
end;

end.
