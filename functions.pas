unit functions;

interface

uses GR32;

function VignetteBrightness(X,Y: Single): Single;
procedure Vignette(var ASource: TBitmap32);

implementation


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

procedure Vignette(var ASource: TBitmap32);
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
