unit Suarez_VolRen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons, ExtCtrls, ExtDlgs;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button2: TButton;
    Button1: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
const
  N = 500;
  M = 500;
  L = 100;
type
 TRGB = record
            r:integer;
            g:integer;
            b:integer;
  end;

  TCubo = array [1..N,1..M,1..L] of real;

var
  Vox:TCubo;
function pack(pixel:TRGB) : TColor;
begin
  pack := RGB(pixel.r, pixel.g, pixel.b);
end;

function unpack(Color: TColor):TRGB;
var
  aux:TRGB;
begin
  aux.r := Color and $ff;
  aux.g := (Color and $ff00) shr 8;
  aux.b := (Color and $ff0000) shr 16;
  unpack := aux;
end;

procedure TForm1.Button1Click(Sender: TObject);
  var
    i,j,k:integer;
    maximo,minimo:real;
begin
Memo1.Clear;
minimo:=5;
maximo:=240;

 for i:=1 to N do
  begin
    for j:=1 to M do
      begin
        for k:=1 to L do
          begin
            Vox[i,j,k]:=sqrt(sqr(251-i)+sqr(251-j)+sqr(51-k));

            if Vox[i,j,k]>maximo then
                maximo:=Vox[i,j,k];

            if Vox[i,j,k]<minimo then
                minimo:=Vox[i,j,k];
          end;
      end;
  end;
  Vox[251,251,51]:=1;
  Memo1.lines.add('Cubo de datos cargado!');
  Memo1.lines.add('Maximo: '+floattostr(maximo));
  Memo1.lines.add('Minimo: '+floattostr(minimo));
end;

Procedure TransferGrey( escalar:real ; var pixel:TRGB ; var a:integer);
begin
   a:=120;
   pixel.r:=trunc(escalar*255/358);
   pixel.g:=trunc(escalar*255/358);
   pixel.b:=trunc(escalar*255/358);
end;

Procedure TransferJet( v,vmax,vmin:real ; var c:TRGB ; var a:integer);
begin
  a:=120;

  if (-0.75 > v) then
  begin
    c.b := trunc(abs(1.75 + v));
    end
  else
  begin
    if (0.25 > v) then
    begin
      c.b := trunc(abs(0.25 - v));
      end
    else
    begin
      c.b := 1;
      end;
   end;

  if ( -0.5 > v) then
  begin
    c.g := 1;
    end
  else
  begin
    if (0.5 > v) then
    begin
      c.g := trunc(abs(1 - 2*v));
      end
    else
    begin
      c.g := 0;  //
      end;
  end;
  if ( -0.25 > v) then
  begin
    c.r := 0;
    end
  else
  begin
    if (0.75 > v) then
    begin
      c.r := trunc(abs(0.25 + v));
      end
    else
    begin
      c.r :=trunc(abs( 1.75 - v));
      end;
  end;

    c.r:=c.r*255;
    c.g:=c.g*255;
    c.b:=c.b*255;

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  a:integer;
  Color:TRGB;
begin
transferjet(0,1,358,color,a);
Memo1.Lines.Add('Blue');
Memo1.Lines.Add(inttostr(color.r));
Memo1.Lines.Add(inttostr(color.g));
Memo1.Lines.Add(inttostr(color.b));

transferjet(358,1,358,color,a);
Memo1.Lines.Add('Red');
Memo1.Lines.Add(inttostr(color.r));
Memo1.Lines.Add(inttostr(color.g));
Memo1.Lines.Add(inttostr(color.b));

transferjet(358/2,1,358,color,a);
Memo1.Lines.Add('Green');
Memo1.Lines.Add(inttostr(color.r));
Memo1.Lines.Add(inttostr(color.g));
Memo1.Lines.Add(inttostr(color.b));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    i,j,k,r,a:Integer;
    pixel,coloractual:TRGB;
    a_real,maximo,minimo:real;
begin
Memo1.clear;

 for i:=1 to N do
  begin
    for j:=1 to M do
      begin
        pixel := unpack(Image1.canvas.Pixels[i,j]);

        for k:=1 to L do
          begin
           //TransferGrey(Vox[i,j,k],maximo,minimo,coloractual,a);
            TransferJet(Vox[i,j,k],maximo,minimo,coloractual,a);


            a_real:= a/255;

            pixel.r  := trunc(a_real*coloractual.r + (1-a_real)*pixel.r);
            pixel.g := trunc(a_real*coloractual.g + (1-a_real)*pixel.g);
            pixel.b := trunc(a_real*coloractual.b + (1-a_real)*pixel.b);


            if (i=500) and (j=500) and (k=100) then
          Memo1.lines.add('Listo');
          end;
         if (pixel.r>255) then
            pixel.r:=(pixel.r div 255);

        Image1.canvas.Pixels[i,j]:=pack(pixel);

       end;
  end;
end;
procedure TForm1.Image1Click(Sender: TObject);
var
  pt : tPoint;
  pixel:TRGB;
begin
  pt := TPanel(Sender).ScreenToClient(Mouse.CursorPos);
  pixel:=unpack(Image1.canvas.Pixels[pt.X,pt.Y]);
  Memo1.lines.add('R: '+IntToStr(pixel.r));
  Memo1.lines.add('G: '+IntToStr(pixel.g));
  Memo1.lines.add('B: '+IntToStr(pixel.b));
end;


procedure TForm1.Button4Click(Sender: TObject);
  var
    i:integer;
begin
Memo1.Clear;
for i:=1 to L do
begin
Memo1.lines.add(floattostr(Vox[250,251,i]));
end;
end;
end.
