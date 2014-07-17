unit MapImage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Math,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Main, FGX.VirtualKeyboard, System.Actions, FMX.ActnList, FMX.Objects,
  FMX.Effects, FMX.ListBox, FMX.Layouts;

type
  TFMain1 = class(TFMain)
    Image1: TImage;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Rectangle3: TRectangle;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Image3: TImage;
    procedure Image1Gesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure Rectangle2Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    minHeight, minWidth, maxHeight, maxWidth: Single;
    procedure VerificaPosicaoTamanhoMinimo;
    procedure ZoomImage(Size, X, Y: Single);
  public
    { Public declarations }
    FLastPosition: TPointF;
    FLastDistance: Integer;
    procedure AddPicture(files: TStrings);
    procedure handlePan(EventInfo: TGestureEventInfo);
    procedure handleZoom(EventInfo: TGestureEventInfo);
    procedure handleRotate(EventInfo: TGestureEventInfo);
  end;

var
  FMain1: TFMain1;

implementation

{$R *.fmx}

procedure TFMain1.AddPicture(files: TStrings);
begin

end;

procedure TFMain1.FormCreate(Sender: TObject);
begin
  inherited;
  minHeight := Rectangle2.Height;
  minWidth := Rectangle2.Width;

  maxHeight := Rectangle2.Height * 2;
  maxWidth := Rectangle2.Width * 2;
end;

procedure TFMain1.handlePan(EventInfo: TGestureEventInfo);
begin
  if not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then begin

    Rectangle2.Position.X := Rectangle2.Position.X +
      (EventInfo.Location.X - FLastPosition.X);

    Rectangle2.Position.Y := Rectangle2.Position.Y +
      (EventInfo.Location.Y - FLastPosition.Y);

    VerificaPosicaoTamanhoMinimo;

  end;

  FLastPosition := EventInfo.Location;

end;

procedure TFMain1.handleRotate(EventInfo: TGestureEventInfo);
begin
  Image1.RotationAngle := RadToDeg(-EventInfo.Angle);
end;

procedure TFMain1.VerificaPosicaoTamanhoMinimo;
begin
  if Rectangle2.Position.X > 0 then
    Rectangle2.Position.X := 0;

  if Rectangle2.Position.Y > 0 then
    Rectangle2.Position.Y := 0;
  if Rectangle2.Height < minHeight then
    Rectangle2.Height := minHeight;

  if Rectangle2.Width < minWidth then
    Rectangle2.Width := minWidth;

  if Rectangle2.Width > maxWidth then
    Rectangle2.Width := maxWidth;

  if Rectangle2.Height > maxHeight then
    Rectangle2.Height := maxHeight;

  if Rectangle2.Position.Y < RectClient.Height - Rectangle2.Height then
    Rectangle2.Position.Y := RectClient.Height - Rectangle2.Height;

  if Rectangle2.Position.X < RectClient.Width - Rectangle2.Width then
    Rectangle2.Position.X := RectClient.Width - Rectangle2.Width;

end;

procedure TFMain1.ZoomImage(Size, X, Y: Single);
var
  eventDistance, widthDistance, heightDistance: Single;
begin
  eventDistance := Size / 10;
  widthDistance := (eventDistance * (Rectangle2.Width / 100));
  heightDistance := (eventDistance * (Rectangle2.Height / 100));

  Rectangle2.Width := Rectangle2.Width + widthDistance;
  Rectangle2.Height := Rectangle2.Height + heightDistance;

  if (Rectangle2.Width < maxWidth) and (Rectangle2.Height < maxHeight) then
  begin
    Rectangle2.Position.X := Rectangle2.Position.X -
      ((X / Self.Width) * widthDistance);

    Rectangle2.Position.Y := Rectangle2.Position.Y -
      ((Y / Self.Height) * heightDistance);
  end;

  VerificaPosicaoTamanhoMinimo;
end;

procedure TFMain1.handleZoom(EventInfo: TGestureEventInfo);
begin

  if not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
    ZoomImage(EventInfo.Distance - FLastDistance, EventInfo.Location.X,
      EventInfo.Location.Y);

  FLastDistance := EventInfo.Distance;

end;

procedure TFMain1.Image1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  inherited;

  // else if EventInfo.GestureID = igiRotate then
  // handleRotate(EventInfo);
  // else if EventInfo.GestureID = igiPressAndTap then
  // handlePressAndTap(EventInfo);
end;

procedure TFMain1.Rectangle2Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  circle: TImage;
begin
  inherited;
  if EventInfo.GestureID = igiPan then
    handlePan(EventInfo)
  else if EventInfo.GestureID = igiZoom then
    handleZoom(EventInfo)
  else if EventInfo.GestureID = igiDoubleTap then begin

    circle := TImage.Create(Rectangle2);
    circle.MultiResBitmap[0].Bitmap := Image3.MultiResBitmap[0].Bitmap;
    circle.Width := 40;
    circle.Height := 67;

    circle.Position.X := EventInfo.Location.X - Rectangle2.Position.X -
      (circle.Width / 2);

    circle.Position.Y := EventInfo.Location.Y - Rectangle2.Position.Y -
      circle.Height - RectClient.Position.Y;

    circle.Parent := Rectangle2;
    circle.BringToFront;
    circle.Anchors := [];

    circle.AnimateFloatDelay('Position.Y', circle.Position.Y - 50, 0.2, 0.1);
    circle.AnimateFloatDelay('Position.Y', EventInfo.Location.Y -
      Rectangle2.Position.Y - circle.Height - RectClient.Position.Y, 0.2, 0.4);

  end;

end;

procedure TFMain1.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  ZoomImage(50, Self.Width / 2, Self.Height / 2);
end;

procedure TFMain1.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  ZoomImage(-50, Self.Width / 2, Self.Height / 2);
end;

end.
