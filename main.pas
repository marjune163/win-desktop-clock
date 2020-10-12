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
    procedure timerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    timeManager:TTimeManager;
    { Private declarations }
    procedure UpdateLayout;
    procedure UpdateTime;
    procedure WMDisplayChange(var Message: TWMDisplayChange); message WM_DISPLAYCHANGE;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation


{$R *.dfm}

procedure TfrmMain.UpdateLayout;
begin
  MoveWindow(self.Handle, 0, Top, Screen.Width, Height, False);
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
  self.timeManager:=TTimeManager.Create;
  self.DoubleBuffered:=true;
  UpdateLayout();
  UpdateTime();
end;

procedure TfrmMain.timerTimer(Sender: TObject);
begin
  UpdateTime();
end;

procedure TfrmMain.WMDisplayChange(var Message: TWMDisplayChange);
begin
  // resolution changed
  self.UpdateLayout;
end;

end.
