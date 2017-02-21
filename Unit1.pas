unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,math,PSAPI, TlHelp32, ComCtrls,CommCtrl, Grids, ExtCtrls,
  Menus,Unit2;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Timer3: TTimer;
    Timer2: TTimer;
    procedure Getinfo(Sender: TObject);
    procedure WMNCHitTest (var M: TWMNCHitTest); message wm_NCHitTest;
    procedure N1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure exp(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
 end;

var
Form1: TForm1;
wpid,count : Cardinal;
HP,TR,TRP,p1,p2,p3,p4,p5,p6,p7,p8,p9,AddrTR,AddrTRP,AddrHP,hstar,i,Ex1,Ex2: Cardinal;
addr0,addr1:Cardinal;
buff: DWORD;
bf:byte;
ht:string; hastar,timkill,sec:integer;  targ,e1,e2,estr:String;
WindowName,ThreadId,ProcessId: integer;

implementation

{$R *.dfm}

function GetModuleBase(const hProc: Cardinal; const sModuleName: string): DWORD;
var
  pModules, pTmp: PDWORD;
  szBuf: array[0..MAX_PATH] of Char;
  cModules: DWORD;
  i, aLen, CharsCount: integer;
begin
  Result := INVALID_HANDLE_VALUE;
  pModules := nil;
  if EnumProcessModules(hProc, pModules, 0, cModules) then
   begin
    GetMem(pModules, cModules);
    try
     pTmp := pModules;
     aLen := Length(sModuleName);
     if EnumProcessModules(hProc, pModules, cModules, cModules) then
      for i := 1 to (cModules div SizeOf(DWORD)) do
       begin
        CharsCount := GetModuleBaseName(hProc, pTmp^, szBuf, SizeOf(szBuf));
        if CharsCount = aLen then
         if CompareText(sModuleName, szBuf) = 0 then
          begin
           Result := pTmp^;
           Break;
          end;
        inc(pTmp);
       end;
     finally
      FreeMem(pModules);
     end;
   end;
end;


procedure TForm1.N1Click(Sender: TObject);
begin
 close;
end;


procedure TForm1.Timer2Timer(Sender: TObject);
begin
sec:=sec+1;
end;

procedure TForm1.WMNCHitTest (var M:TWMNCHitTest);
begin
  inherited;
  if M.Result = htClient then
    M.Result := htCaption;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
sec:=0;
   ShowWindow(Application.Handle, SW_HIDE);

   WindowName:=FindWindow(nil,'AION Client');
   ThreadId := GetWindowThreadProcessId(WindowName,@ProcessId);
   wpid:= OpenProcess(PROCESS_ALL_ACCESS,False,ProcessId);
   addr0 := GetModuleBase(wpid, 'game.dll');
   addr1 := Cardinal(DWord(addr0));

   Ex1:=addr1+$A329A0;
      ReadProcessMemory(wpid,Pointer(Ex1),@buff,4, count);
      estr:=Format('%.8d', [buff]);
end;


procedure TForm1.Getinfo(Sender: TObject);
begin
 hstar:=addr1+$639BC4;
        ReadProcessMemory(wpid,Pointer(hstar),@bf,1, count);
        ht:=Format('%.1d', [bf]); hastar:=StrToInt(ht);
     if hastar <> 1 then
       begin
         Label2.Caption:='';
         Label1.Caption:='';
        end
       else
     begin

   HP:=addr1+$639BBC;
       ReadProcessMemory(wpid, Pointer(HP), @AddrHP, 4, count);
       p4:=AddrHP+$1C4;
       ReadProcessMemory(wpid, Pointer(p4), @p5, 4, count);
       p6:=p5+$F48;
       ReadProcessMemory(wpid, Pointer(p6), @buff,sizeof(buff), count);
       Label2.Caption:=Format('%.4d', [buff]);

   TRP := addr1+$639BBC;
       ReadProcessMemory(wpid, Pointer(TRP), @AddrTRP, 4, count);
       p7:=AddrTRP+$1C4;
       ReadProcessMemory(wpid, Pointer(p7), @p8, 4, count);
       p9:=p8+$34;
       ReadProcessMemory(wpid, Pointer(p9), @bf,1, count);
       Form2.Label1.Caption:=IntToStr(bf)+'%';
   if (bf<=99) and (bf>0) then
   Timer2.Enabled:=True;
   if bf =0 then
   begin
   Timer2.Enabled:=False;
   Timer3.Enabled:=True;
   end;
   AddrHP:=0;P4:=0;p5:=0;p6:=0;

   TR := addr1+$639BBC;
       ReadProcessMemory(wpid, Pointer(TR), @AddrTR, 4, count);
       p1:=AddrTR+$1C4;
       ReadProcessMemory(wpid, Pointer(p1), @p2, 4, count);
       p3:=p2+$32;
       ReadProcessMemory(wpid, Pointer(p3), @bf,1, count);
    if (bf <= 50) and (bf<>00) then
       Label1.Caption:=Format('%.2d', [bf]);
     end;
end;

procedure TForm1.exp(Sender: TObject);
var
edif,minlv,min,hour,exsec,extolvl:integer;
begin
     Ex2:=addr1+$A32990;
        ReadProcessMemory(wpid,Pointer(Ex2),@buff,4, count);
        e2:=Format('%.8d', [buff]);
     Ex1:=addr1+$A329A0;
        ReadProcessMemory(wpid,Pointer(Ex1),@buff,4, count);
        e1:=Format('%.8d', [buff]);
        edif:=strtoint(e1)-strtoint(estr);     //разница между —тартовымопытом и теперешним(после убийвства)
        extolvl:=strtoint(e2)-strtoint(e1);    //сколько осталось до лала( отн€ли от требуемого дл€ лвла опыта , текущий)
     if edif > 0 then
     begin
        extolvl:=extolvl-edif;  // от оставшегос€ , отн€ли полученный за моба
        exsec:=round(edif/sec);  //получили експу в сек.
        minlv:=round((extolvl/exsec)/40);   // поидее в минуту..
        hour:=minlv div 60;
        min:=minlv mod 60;
        Form2.Label3.Caption:='ƒо лвла : '+IntTostr(hour)+'ч '+IntTostr(min)+'м';
      end;
Timer3.Enabled:=False;
end;




end.
