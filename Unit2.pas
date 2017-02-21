unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,math,PSAPI, TlHelp32, ComCtrls,CommCtrl, Grids, ExtCtrls,
  Menus;

type
  TForm2 = class(TForm)
    Label3: TLabel;
    Label1: TLabel;
    Timer1: TTimer;
    procedure WMNCHitTest (var M: TWMNCHitTest); message wm_NCHitTest;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


procedure TForm2.FormCreate(Sender: TObject);
begin
Form2.FormStyle:=fsStayOnTop;
Form2.BringToFront;
ShowWindow(Application.Handle, SW_HIDE);
Form2.AlphaBlendValue:=150;
end;

procedure TForm2.WMNCHitTest (var M:TWMNCHitTest);
begin
  inherited;
  if M.Result = htClient then
    M.Result := htCaption;
end;

end.
