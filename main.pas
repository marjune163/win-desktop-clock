unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, timeMan;

type
  TfrmMain = class(TForm)
    timer: TTimer;
    lblTime: TLabel;
    pnlPadLeft: TPanel;
    pnlPadRight: TPanel;
    pnlPadBottom: TPanel;
    pnlPadTop: TPanel;
    procedure timerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    isFadeIn:boolean;
    timeManager:TTimeManager;
    { Private declarations }
    procedure UpdateLayout;
    procedure UpdateTime;
    procedure WMDisplayChange(var Message: TWMDisplayChange); message WM_DISPLAYCHANGE;
    procedure FadeIn;
    procedure FadeOut;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation


{$R *.dfm}

procedure TfrmMain.UpdateLayout;
begin
  MoveWindow(self.Handle, 0, Top, Screen.Width, lblTime.Height+pnlPadTop.Height+pnlPadBottom.Height, False);
end;

procedure TfrmMain.UpdateTime();
var
  str:string;
begin
  str:=self.timeManager.GetHhMmSs;
  if Length(str)>0 then begin
    lblTime.Caption:=str;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // hide from task bar
  SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);

  self.timeManager:=TTimeManager.Create;
  self.DoubleBuffered:=true;
  UpdateLayout;
  FadeOut;
end;

procedure TfrmMain.timerTimer(Sender: TObject);
begin
  UpdateTime;
end;

procedure TfrmMain.WMDisplayChange(var Message: TWMDisplayChange);
begin
  // resolution changed
  self.UpdateLayout;
end;

procedure TfrmMain.FadeIn;
begin
  timer.Enabled:=true;
  UpdateTime;

  Top:=0;
  AlphaBlendValue:=192;
end;

procedure TfrmMain.FadeOut;
begin
  timer.Enabled:=false;

  Top:=1-Height;
  AlphaBlendValue:=1;
end;

procedure TfrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  OffsetX, OffsetY: integer;
  Control: TControl;
begin
  OffsetX:=X;
  OffsetY:=Y;

  Control:=Sender as TControl;
  while not (Control is TForm) do begin
    Inc(OffsetX, Control.Left);
    Inc(OffsetY, Control.Top);
    Control:=Control.Parent;
  end;

  // timer.Enabled:=False;
  // lblTime.Caption:='isFadeIn:' + BoolToStr(isFadeIn)+', OffsetX:' + IntToStr(OffsetX) + ', OffsetY:' + IntToStr(OffsetY) + ', Left:' + IntToStr(Left) + ', Top:' + IntToStr(top) + ', Width:' + IntToStr(width) + ', Height:' + IntToStr(height);

  if (isFadeIn=False) and (OffsetX>=0) and (OffsetX<Width) and (OffsetY>=0) and (OffsetY<Height) then begin
    isFadeIn:=True;
    SetCapture(self.Handle);
    FadeIn;
  end else if isFadeIn and ((OffsetX<0) or (OffsetX>=Width) or (OffsetY<0) or (OffsetY>=Height)) then begin
    isFadeIn:=false;
    ReleaseCapture;
    FadeOut;
  end;
end;

end.
