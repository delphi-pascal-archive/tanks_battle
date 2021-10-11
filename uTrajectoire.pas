unit uTrajectoire;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,math, StdCtrls, ComCtrls;

type
  TLave = record
     pos:Tpoint;
     Actif:boolean;
     Naissance:integer;
     end;
  TForm1 = class(TForm)
    Aire: TPaintBox;
    Button5: TButton;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1: TTimer;
    Image1: TImage;
    img1Up: TImage;
    img1Down: TImage;
    img1Right: TImage;
    img1Left: TImage;
    Image2: TImage;
    img2Up: TImage;
    img2Left: TImage;
    img2Down: TImage;
    img2Right: TImage;
    tb1Force: TTrackBar;
    tb2Force: TTrackBar;
    Label5: TLabel;
    Label3: TLabel;
    edtAngle: TEdit;
    edtForce: TEdit;
    edtVent: TEdit;
    label2: TLabel;
    Label4: TLabel;
    edtGravite: TEdit;
    cbArme: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button9: TButton;
    Panel3: TPanel;
    chkChute: TCheckBox;
    Memo1: TMemo;
    Panel4: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button10: TButton;
    Button11: TButton;
    chkLave: TCheckBox;
    Label1: TLabel;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    function DessinerTrajectoire(offset:Tpoint;tInit:integer):integer;
    procedure Tir(Refaire:boolean);
    procedure DessinerBackground(StartX:integer);
    procedure FormCreate(Sender: TObject);
    Procedure PositionnerJoueur2(x,y:integer);
    procedure FormShow(Sender: TObject);
    procedure Init;
    procedure Button3Click(Sender: TObject);
    procedure Impact(joueur:integer;offset:tpoint;x,y:integer);
    procedure Button5Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Button1Click(Sender: TObject);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    function EnCollision(joueur:smallint;offset:Tpoint;x,y:integer):boolean;
    procedure Button4Click(Sender: TObject);
    procedure ChuteMontagne(offset:Tpoint;x,y:integer);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    Procedure Copier(offset:tpoint;x,y:integer);
    procedure Button8Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PutBullet(x,y:integer);
    procedure initBullet;
    procedure DessinerBullet(Redessine:boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure edtAngleChange(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure img1LeftClick(Sender: TObject);
    procedure img1RightClick(Sender: TObject);
    procedure img1UpClick(Sender: TObject);
    procedure img1DownClick(Sender: TObject);
    procedure img2UpClick(Sender: TObject);
    procedure img2DownClick(Sender: TObject);
    procedure img2RightClick(Sender: TObject);
    procedure img2LeftClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tb2ForceChange(Sender: TObject);
    procedure tb1ForceChange(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
        var AllowChange: Boolean);
    procedure ChuteJoueur;
    procedure Memo1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Lave(Zone:tpoint);
    procedure EffacerLave;
    procedure Button11Click(Sender: TObject);
    procedure AireMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label1Click(Sender: TObject);
    procedure AutoDetect(NbJoueur:smallint;x,y:integer);
    procedure SuperTomate;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function ChangerEcran(joueur:smallint):boolean;
    procedure cbArmeChange(Sender: TObject);
   // procedure MiseAJourImgMontagne2;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
       angle,vent,gravite,puissance:real;
       PosAire:integer;
       PosJoueur1,PosJoueur2:tpoint;
       depart:tpoint;
       Joueur:smallint;
       imgMontagne,imgJoueur1,imgJoueur2:tbitmap;
       Bulletpos:array[1..400] of Tpoint;
       tmpimage:timage;
       tmpImage2:timage;
       imgMontagne2,imgAireSource:TImage;
       Quitter:boolean;
       TripleTirIndex:smallint;
       Listeimpact:Array[1..5] of Tpoint;
       ChuteEnCours:boolean;
       Targeting:boolean;
       Lava:array[1..8000] of tLave;
       IndexLave:integer;
       touche:char;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



procedure TForm1.FormCreate(Sender: TObject);
begin
ChuteEnCours:=false;
angle:=55*PI/360;
Puissance:=200;
Vent:=0/200;
Gravite:=1/300;
PosAire:=0;
Joueur:=1;
tmpImage:=Timage.create(self);;
tmpImage.Picture.LoadFromFile('.\bitmap\blanc.bmp');
tmpImage2:=Timage.create(self);
tmpImage.Picture.LoadFromFile('.\bitmap\blanc2.bmp');
imgMontagne2:=Timage.create(self);
imgMontagne2.Picture.LoadFromFile('.\bitmap\Montagne3.bmp');
imgAireSource:=Timage.create(self);
imgAireSource.Picture.LoadFromFile('.\bitmap\BackLarge3.bmp');


//Aire.ControlStyle := Aire.ControlStyle + [csOpaque];
  imgmontagne := TBitmap.Create;
  imgmontagne.LoadFromFile('.\bitmap\montagne.bmp');
  imgmontagne.Transparent := True;
  imgmontagne.TransParentColor := clwhite;
  imgJoueur1 := TBitmap.create;
  imgJoueur1.LoadFromFile('.\bitmap\Char gauche2.bmp');
  imgJoueur1.transparent := True;
  imgJoueur1.TransParentColor := clwhite;
  imgJoueur2 := TBitmap.Create;
  imgJoueur2.LoadFromFile('.\bitmap\Char Droit2.bmp'); //Char Droit2.bmp');
  imgJoueur2.transparent := True;
  imgJoueur2.TransParentColor := clwhite;
PosJoueur2.x:=1880;  //2080
PosJoueur2.y:=80; //207
PosJoueur1.x:=300;
PosJoueur1.y:=213; //86
end;

Procedure TForm1.InitBullet;
var
   i:integer;
begin
for i:=1 to 400 do
    begin
    Bulletpos[i].x:=0;
    Bulletpos[i].y:=0;
    end;
end;

procedure Tform1.PutBullet(x,y:integer);
var
   i:integer;
begin
for i:=1 to 399 do
    begin
    Bulletpos[i].x:=Bulletpos[i+1].x;
    Bulletpos[i].y:=Bulletpos[i+1].y;
    end;
Bulletpos[400].x:=x;
Bulletpos[400].y:=y;
end;

procedure Tform1.DessinerBullet(ReDessine:boolean);
begin
if ReDessine=true then
case cbArme.ItemIndex of

     0,2,3:
       begin
       Aire.canvas.pixels[Bulletpos[340].x,Bulletpos[340].y]:=clgray;
       Aire.canvas.pixels[Bulletpos[340].x,Bulletpos[340].y+1]:=clgray;
       Aire.canvas.pixels[Bulletpos[400].x,Bulletpos[400].y]:=clred;
       Aire.canvas.pixels[Bulletpos[400].x,Bulletpos[400].y+1]:=clred;
       Aire.canvas.pixels[Bulletpos[399].x,Bulletpos[399].y]:=clred;
       Aire.canvas.pixels[Bulletpos[399].x,Bulletpos[399].y+1]:=clred;
       Aire.canvas.pixels[Bulletpos[398].x,Bulletpos[398].y]:=clred;
       Aire.canvas.pixels[Bulletpos[398].x,Bulletpos[398].y+1]:=clred;
       end;
     1:
       begin
       Aire.canvas.pixels[Bulletpos[400].x,Bulletpos[400].y]:=clred;
       Aire.canvas.pixels[Bulletpos[400].x,Bulletpos[400].y+1]:=clred;
       Aire.canvas.pixels[Bulletpos[350].x,Bulletpos[350].y]:=clgray;
       Aire.canvas.pixels[Bulletpos[350].x,Bulletpos[350].y+1]:=clgray;

       Aire.canvas.pixels[Bulletpos[200].x,Bulletpos[200].y]:=clred;
       Aire.canvas.pixels[Bulletpos[200].x,Bulletpos[200].y+1]:=clred;
       Aire.canvas.pixels[Bulletpos[150].x,Bulletpos[150].y]:=clgray;
       Aire.canvas.pixels[Bulletpos[150].x,Bulletpos[150].y+1]:=clgray;

       Aire.canvas.pixels[Bulletpos[50].x,Bulletpos[50].y]:=clred;
       Aire.canvas.pixels[Bulletpos[50].x,Bulletpos[50].y+1]:=clred;
       Aire.canvas.pixels[Bulletpos[1].x,Bulletpos[1].y]:=clgray;
       Aire.canvas.pixels[Bulletpos[1].x,Bulletpos[1].y+1]:=clgray;
       end;
     end;
if redessine=false then
   begin
   Aire.canvas.pixels[Bulletpos[399].x,Bulletpos[399].y]:=clgray;
   Aire.canvas.pixels[Bulletpos[399].x,Bulletpos[399].y+1]:=clgray;
   end;
end;

Procedure TForm1.AutoDetect(NbJoueur:smallint;x,y:integer);
var
   i,j:integer;
begin
for j:=1 to 4 do
begin
i:=0;
while(y+i<450-PosJoueur2.y) do
    begin
    inc(i);
    if i/15-floor(i/15)=0 then sleep(1);
    Aire.canvas.pixels[x-PosaIre,y+i]:=clred;
    end;
DessinerBackGround(PosAire);
end;
end;

function TForm1.DessinerTrajectoire(offset:Tpoint;tInit:integer):integer;
var
   PIx,PIy:Real;
   x,y:integer;
   t:longint;
  // Persistance:integer;
//   depart:tpoint;
begin
InitBullet;
PIx:=COS(angle)*puissance;
PIy:=SIN(angle)*puissance;
//Persistance:=0;
t:=0;
for t:=0 to 700000 do
    begin
    if (t/4-floor(t/4)=0) then
    begin
    x:=floor( (PIx*t+(0.1)*vent*t*t)/10000 );
    y:=floor( (PIy*t-(1/2)*gravite*t*t)/5000);
    //EdtX.text:=inttostr(offset.x+x);
    //EdtY.text:=inttostr(450-y);
    //application.processmessages;
    if Joueur=1 then
    if y+PosJoueur1.x<0 then
       begin
       result:=700000;
       //Edit1.text:=inttostr(x+Posaire);
       exit;
       end;
    if Joueur=2 then
    if y+PosJoueur2.y<0 then
       begin
       result:=700000;
       //Edit1.text:=inttostr(x+Posaire);
       exit;
       end;

    if (offset.x+x>770) and (joueur=1) then
       begin
       //Edit1.text:=inttostr(x);
       result:=t;
       exit;
       end;
    {if (offset.x-x<0) and (joueur=2) and (Posaire<400) then
       begin
       result:=700000;
       exit;
       end;   }
    if (PosAire=0) and (joueur=2) and (offset.x-x<0) then
       begin
       result:=700000;
       exit;
       end;
    if (offset.x-x<=40) and (joueur=2) then
       begin
       result:=t;
       exit;
       end;
    if cbArme.ItemIndex=3 then
       begin
       if (offset.x+x+PosAIre>PosJoueur2.x+28) and (joueur=1) then
          begin
          result:=700000;
          Autodetect(2,offset.x+x+PosAire,450-(offset.y+y));
          exit;
          end;
       if (offset.x-x+PosAIre>PosJoueur1.x+31) and (joueur=2) then
          begin
          result:=700000;
          Autodetect(1,offset.x-x+PosAire,450-(offset.y+y));
          exit;
          end;

       end;
    if EnCollision(joueur,offset,x,y)=true then
        begin
        //Edit1.text:='Impact';
        result:=700000;
        if (cbArme.itemindex=0) or (cbArme.itemindex=1) or (
           (cbArme.itemindex=2) and (chkLave.checked=true) )then
           impact(joueur,offset,x,y);
        DessinerBackGround(PosAire);
        if cbArme.itemindex=0 then
           ChuteMontagne(offset,x,y);
        if cbArme.ItemIndex=1 then
           begin
           inc(TripleTirindex);
           ListeImpact[TripleTirIndex].x:=x;
           ListeImpact[TripleTirIndex].y:=y;
           if TripleTirIndex>=3 then
              begin
              ChuteMontagne(offset,ListeImpact[3].x,ListeImpact[3].y);
              ChuteEnCours:=true;
              //Button1.enabled:=false;
//              while (ChuteEnCours=true) do application.processmessages;
              ChuteMontagne(offset,ListeImpact[2].x,ListeImpact[2].y);
              //Button1.enabled:=false;
//              while (ChuteEnCours=true) do application.processmessages;
              ChuteMontagne(offset,ListeImpact[1].x,ListeImpact[1].y);
              //if Joueur=1 then Joueur:=2 else Joueur:=1;
              //ChuteJoueur;
              exit;
              end;
           end;
        if cbArme.itemindex=0 then
            exit;
        if cbArme.itemIndex=2 then
           begin
           ChuteJoueur;
           if joueur=1 then     // pas bien car fonction pas comme les autres
              offset.x:=offset.x+x
           else
               offset.x:=offset.x-x;
           offset.y:=450-(offset.y+y);
           Lave(offset);
           exit;
           end;
        if cbArme.itemindex=3 then
           begin
           exit;
           end;
        end;
     application.processmessages;
     if joueur=1 then
       begin
       PutBullet(offset.x+x,450-(offset.y+y));
         //Aire.Canvas.Pixels[offset.x+x,450-(offset.y+y)]:=clred;
       end;
    if Joueur=2 then
       PutBullet(offset.x-x,450-(offset.y+y));
       //Aire.Canvas.Pixels[offset.x-x,450-(offset.y+y)]:=clred;
    //DessinerBullet;
    if (t>=tInit) then
       begin
       DessinerBullet(true);
       if (t/200-floor(t/200)=0) then
          begin
          sleep(20);
          end;
       end
    else
        DessinerBullet(false);
    //application.processmessages;
    end;
    end;
result:=t;
end;

Function Tform1.EnCollision(joueur:smallint;offset:Tpoint;x,y:integer):boolean;
var
   pos:tpoint;
begin
result:=false;
if Joueur=1 then pos.x:=PosAire+offset.x+x;
if joueur=2 then pos.x:=PosAire+offset.x-x;
pos.y:=450-(offset.y+y);
if imgMontagne2.Canvas.Pixels[pos.x,pos.y]=clgreen then
   result:=true;
if result<>true then
   begin
   if joueur=1 then
      begin
      if (pos.x>PosJoueur2.x+3) and (Pos.x<PosJoueur2.x+59) and
         (pos.y<450-PosJoueur2.y+23) and (Pos.y>450-PosJoueur2.y+2) then
         begin
         //Aire.canvas.pen.color:=clred;
         //Aire.canvas.Rectangle(PosJoueur2.x+3-PosaIre,450-(PosJoueur2.y+2),PosJoueur2.x+59-PosaIre,450-(PosJoueur2.y)+23);
         //Edit1.text:='Dans le mille';
         result:=true
         end
      else
          Edit1.text:='';
      end;
   if joueur=2 then
      begin
      if (pos.x>PosJoueur1.x+1) and (Pos.x<PosJoueur1.x+55) and
         (pos.y<450-PosJoueur1.y+23) and (Pos.y>450-PosJoueur1.y+3) then
         begin
         Edit1.text:='Dans le mille';
         result:=true
         end
      else
          Edit1.text:='';

      end;
   end;
end;

procedure Tform1.PositionnerJoueur2(x,y:integer);
begin
PosJoueur2.x:=x;
PosJoueur2.y:=y;
end;

function TForm1.ChangerEcran(joueur:smallint):boolean;
begin
Result:=true;
   if joueur=1 then
      begin
      if PosAire=2000 then result:=false;
      PosAire:=PosAire+400;
      if Posaire>2000 then
         begin
         depart.x:=depart.x-(Posaire-2000);
         PosAire:=2000;
         end
      else
          depart.x:=depart.x-400;
      end;
   if joueur=2 then
      begin
      if PosAire=0 then result:=false;
      PosAire:=PosAire-400;
      if PosAire<0 then
         begin
         depart.x:=depart.x-(PosAire);
         PosAire:=0;
         end
      else
          depart.x:=depart.x+400;
      end;
if PosAire<0 then PosAire:=0;
if Posaire>2500 then PosAire:=2000;

end;


procedure TForm1.Tir(Refaire:boolean);
var
   tfinal:integer;
   PIx:real;
begin
TripletirIndex:=0;
if joueur=1 then
   begin
   Depart.x:=PosJoueur1.x-PosAire+30;
   Depart.y:=PosJoueur1.y;
   end;
if joueur=2 then
   begin
   Depart.x:=POsJoueur2.x-PosAire+30;
   Depart.y:=PosJoueur2.y;
   end;
tFinal:=DessinerTrajectoire(depart,0);
while (tFinal<300000) do
   begin
   ChangerEcran(joueur);
   DessinerBackground(PosAire);
   Tfinal:=DessinerTrajectoire(depart,tFinal);
   end;
ChuteJoueur;
if cbArme.ItemIndex=2 then
   EffacerLave;
DessinerBackGround(PosAire);
end;

procedure TForm1.DessinerBackground(StartX:integer);
var
   Source,dest:trect;
begin
tmpImage.Width:=770;
tmpImage.Height:=450;
source.top:=0;
source.Left:=StartX;
source.right:=StartX+770;
source.bottom:=450;
dest.left:=0;
dest.top:=0;
dest.right:=770;
dest.bottom:=450;
// debut dessin verdure
tmpimage.canvas.copymode:=cmsrccopy;
tmpimage.Canvas.CopyRect(dest,imgAireSource.canvas,source);
// fin dessin verdure
imgmontagne.canvas.copymode:=cmsrcCopy;
imgMontagne.Canvas.CopyRect(dest,imgMontagne2.canvas,source);
tmpimage.Canvas.draw(0,0,imgmontagne);

if true then
   begin
   tmpimage.canvas.draw(PosJoueur2.x-PosAire,430-PosJoueur2.y,imgJoueur2);
   end;
if (StartX<PosJoueur1.x) and ( (StartX+770) > PosJoueur1.x) then
   begin
   tmpimage.canvas.draw(PosJoueur1.x-PosAire,430-PosJoueur1.y,imgJoueur1);
   end;

source.top:=0;
source.Left:=0;
source.right:=770;
source.bottom:=450;
dest.left:=0;
dest.top:=0;
dest.right:=770;
dest.bottom:=450;
Aire.canvas.CopyRect(dest,tmpimage.Canvas,source);
end;



procedure TForm1.FormShow(Sender: TObject);
begin
tb1ForceChange(self);
tb2ForceChange(self);
DessinerBackground(PosAire);
end;

procedure TForm1.Init;
begin
PosAire:=0;
if Joueur=2 then
     Posaire:=1730;
DessinerBackground(PosAire);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
PosAire:=PosAire-400;
if PosAire<0 then
    PosAire:=0;
DessinerBackground(PosAire);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
   offset:tpoint;
begin
offset.x:=0;
offset.y:=0;
impact(1,offset,220,300);
DessinerBackGround(PosAire);
end;

procedure Tform1.Impact(joueur:integer;offset:tpoint;x,y:integer);
var
   Demitaille:smallint;
begin
DemiTaille:=30;
if joueur=1 then
   begin
   x:=PosAire+offset.x+x;
   end
else
    begin
    x:=PosAire+offset.x-x;
    end;
y:=450-(offset.y+y);
with imgmontagne2.canvas do  //FLOP
     begin
     pen.color:=clwhite;
     brush.color:=clwhite;
     brush.style:=bssolid;
     Ellipse(x-DemiTaille,y-DemiTaille,x+DemiTaille,y+DemiTaille);
     end;
end;

procedure TForm1.EffacerLave;
var
   i:integer;
begin
for i:=1 to indexLave do
    begin
    ImgMontagne2.Canvas.pixels[Lava[i].pos.x,Lava[i].pos.y]:=clgreen;
    end;
end;


procedure TForm1.Lave(zone:tpoint);

var
   i,j:integer;
   moved:boolean;
   Startx,Starty:integer;
   oldx,oldy:integer;
begin
for i:=1 to 8000 do
    begin
    Lava[i].Actif:=true;
    Lava[i].Naissance:=1;
    end;
moved:=false;
indexLave:=1;
StartX:=PosAire+Zone.x;
Starty:=Zone.y-20;
Lava[1].pos.x:=StartX;
Lava[1].pos.y:=StartY;
//Aire.canvas.pixels[sTartx-Posaire,StartY]:=clred;;
application.processmessages;

for j:=1 to 1000 do
    begin
    if j/20-floor(j/20)=0 then
       dessinerBackground(Posaire);
    with imgMontagne2.canvas do
    for i:=indexlave downto 1 do
        begin
        Moved:=false;
        oldx:=lava[i].pos.x;
        oldy:=lava[i].pos.y;
        if (j-lava[i].Naissance>300) and (lava[i].naissance<>9999) then
           begin
           Lava[i].Naissance:=9999;
           Lava[i].Actif:=false;
           imgMontagne2.canvas.pixels[lava[i].pos.x,Lava[i].pos.y]:=clgreen;
           end;
        if lava[i].naissance<>9999 then
           begin
           if (pixels[lava[i].pos.x,lava[i].pos.y+1]=clwhite) and (pixels[lava[i].pos.x,lava[i].pos.y+1]<>clred) and
              (lava[i].actif=true) then
              begin
              Lava[i].pos.y:=lava[i].pos.y+1;
              Moved:=true;
              end
           else if (pixels[lava[i].pos.x-1,lava[i].pos.y]=clwhite) and (pixels[lava[i].pos.x-1,lava[i].pos.y]<>clRed) and
                   (lava[i].actif=true) then
                   begin
                   Lava[i].pos.x:=lava[i].pos.x-1;
                   Moved:=true;
                   end;
           if (moved=false) and (Pixels[lava[i].pos.x+1,lava[i].pos.y]=clwhite) and (Pixels[lava[i].pos.x+1,lava[i].pos.y]<>clRed) and
              (lava[i].actif=true) then
              begin
              Lava[i].pos.x:=lava[i].pos.x+1;
              moved:=true;
              end;
           if moved=true then
              begin
              pixels[oldx,oldy]:=clwhite;
              pixels[lava[i].pos.x,lava[i].pos.y]:=clRed;
              end;
           end;
        end;
    if indexlave<5999 then
       begin
       inc(indexlave);
       lava[indexlave].pos.x:=StartX;
       Lava[indexlave].pos.y:=StartY;
       Lava[indexLave].Naissance:=j;
       inc(indexlave);
       lava[indexlave].pos.x:=StartX;
       Lava[indexlave].pos.y:=StartY;
       Lava[indexLave].Naissance:=j;
       inc(indexlave);
       lava[indexlave].pos.x:=StartX;
       Lava[indexlave].pos.y:=StartY;
       Lava[indexLave].Naissance:=j;
       inc(indexlave);
       lava[indexlave].pos.x:=StartX;
       Lava[indexlave].pos.y:=StartY;
       Lava[indexLave].Naissance:=j;

       end;
    end;
end;


procedure TForm1.ChuteJoueur;
var
   Encours:boolean;
   i:integer;
begin
Encours:=true;
if true then//joueur=1 then
   begin
   while (EnCours=true) do
   begin
   for i:=20 to 30 do
       begin
       if imgMontagne2.Canvas.Pixels[PosJoueur1.x+i,450-(PosJoueur1.y-23)]<>clwhite then
          begin
          Encours:=false;
          end;
       end;
   if EnCours=true then
      begin
      PosJoueur1.y:=PosJoueur1.y-1;
      DessinerBackGround(PosAire);
      application.processmessages;
      end;
   end;
   end;
Encours:=true;
if true then//joueur=2 then
   begin
   while (EnCours=true) do
   begin
   for i:=20 to 30 do
       begin
       if imgMontagne2.Canvas.Pixels[PosJoueur2.x+i,450-(PosJoueur2.y-23)]<>clwhite then
          begin
          Encours:=false;
          end;
       end;
   if EnCours=true then
      begin
      PosJoueur2.y:=PosJoueur2.y-1;
      DessinerBackGround(PosAire);
      application.processmessages;
      end;
   end;
   end;

end;

Procedure TForm1.ChuteMontagne(offset:tpoint;x,y:integer);
var
   X1,Y1:integer;
   EnChute:boolean;
   couleur:tcolor;
   i:integer;
   Source,dest:trect;
   xdernier:integer;
   LigneVerte:boolean;
   Ymin,Ymax:integer;
   Yfin,Ytmp:integer;
   Bool:boolean;
begin
ChuteEnCours:=true;
if joueur=1 then
   begin
   x:=PosAire+offset.x+x;
   end
else
    begin
    x:=PosAire+offset.x-x;
    end;
y:=450-(offset.y+y);
if y>=419 then
   y:=419;
enchute:=true;
couleur:=clgreen;
tmpImage2.Width:=100;
tmpImage2.Height:=450;

Source.Top:=0;
Source.Left:=x-50;
Source.Right:=x+50;
Source.bottom:=450;
Dest.Top:=0;
Dest.Left:=0;
Dest.Right:=100;
Dest.bottom:=450;

tmpImage2.Canvas.CopyRect(dest,imgMontagne2.canvas,source);

Source.Top:=0;
Source.Left:=0;
Source.Right:=100;
Source.bottom:=450;
Dest.Top:=0;
Dest.Left:=x-50;
Dest.Right:=x+50;
Dest.bottom:=450;


i:=0;

Ymax:=y+30;

LigneVerte:=true;
with tmpimage2.canvas do
    for y1:=y+30 downto 2 do
        begin
        for x1:=10 to 90 do
            begin
            if (pixels[X1,Y1]<>clgreen) and (ligneVerte=true) then
               begin
               LigneVerte:=false;
               Ymax:=y1+1;
               end;
            end;
        end;
ligneverte:=true; //en fait ligneblanche (economie de variable)
Ymin:=2;
with tmpimage2.canvas do
    for y1:=2 to y+30 do
        begin
        for x1:=20 to 80 do
            begin
            if (pixels[X1,Y1]<>clwhite) and (ligneVerte=true) then
               begin
               LigneVerte:=false;
               Ymin:=y1-1;
               end;
            end;
        end;
with tmpimage2.canvas do
while(EnChute=true) do
    begin
    inc(i);
    if i/5-floor(i/5)=0 then
       begin
       ImgMontagne2.Canvas.draw(x-50,0,tmpImage2.picture.Bitmap); //FLOP
       DessinerBackground(PosAire);
       if quitter=true then exit;
       application.processmessages;
       end;
    EncHute:=false;
    if chkChute.checked=false then
    for X1:=20 to 80 do
        begin
        for y1:=Ymax downto Ymin do
            begin
            bool:=true;

            if (pixels[x1,y1]=couleur) and (pixels[x1,y1+1]=clwhite) then
               begin
               bool:=true;
               YFin:=999;
               for Ytmp:=Y1+1 to yMax do
                   if (pixels[x1,ytmp]=clgreen) and (bool=true) then
                      begin
                      Yfin:=Ytmp;
                      bool:=false;
                      break;
                      end;
               if Yfin=999 then Yfin:=y1+2;
               if Yfin<>999 then
                  begin
                  EnChute:=true;
                  Pixels[x1,y1]:=clwhite;
                  Pixels[x1,Yfin-1]:=clgreen;
                  end;
               end;
            end;
        end;
    //EnChute:=False;
    if chkChute.checked=true then
    for X1:=20 to 80 do
        begin
        for y1:=Ymax downto Ymin do
        if (pixels[x1,y1]=couleur) and (pixels[x1,y1+1]=clwhite) then
           begin
           EnChute:=true;
           Pixels[x1,y1]:=clwhite;
           Pixels[x1,y1+1]:=clgreen;
           end;
        end;
    end;

ImgMontagne2.Canvas.copyrect(dest,tmpImage2.Canvas,source); //FLOP
DessinerBackground(PosAire);
ChuteEnCours:=false;
end;

procedure Tform1.Copier(offset:tpoint;x,y:integer);
var
   Drect,Srect:Trect;
   x1:integer;
begin
if joueur=1 then
   begin
   x1:=PosAire+offset.x+x;
   end
else
    begin
    x1:=PosAire+offset.x-x;
    end;
//y1:=450-(offset.y+y);

Srect.Top:=0;
Srect.Left:=x1-32;
Srect.Right:=x1+32;
Srect.Bottom:=450;
Drect.Top:=0;
Drect.Bottom:=450;
Drect.left:=x-32;
Drect.right:=x+32;
Aire.canvas.CopyRect(Drect,imgmontagne2.canvas,Srect); //FLOP
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
if button=btnext then
   begin
   Tb1Force.position:=Tb1Force.position+1;
   end;
if button=btprev then
   begin
   Tb1Force.position:=Tb1Force.position-1;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Button1.enabled:=false;
if cbArme.itemindex=-1 then
   exit;
if cbArme.itemindex=4 then
   begin
   SuperTomate;
   Button1.enabled:=true;
   exit;
   end;
//FLOPButton1.enabled:=false;
init;
Tir(false);
Button1.enabled:=true;
end;

procedure Tform1.SuperTomate;
var
   tomate:tpoint;
   Old:tpoint;
   imgTomate:Tbitmap;
   imgBack:Tbitmap;
   i:integer;
   Source,dest:trect;
   offset:tpoint;
begin
touche:=' ';
offset.x:=0;
offset.y:=0;
i:=0;
imgtomate:=tbitmap.create;
imgTomate.LoadFromFile('.\bitmap\Tomate.bmp');
imgTomate.Transparent := True;
imgTomate.TransParentColor := clwhite;
imgback:=tbitmap.create;
imgback.LoadFromFile('.\bitmap\Tomate.bmp');
if joueur=1 then
   begin
   tomate.x:=Posjoueur1.x+40-PosAire;
   tomate.y:=450-PosJoueur1.y-20;
   end;
if joueur=2 then
   begin
   tomate.x:=Posjoueur2.x+40-PosAire;
   tomate.y:=450-PosJoueur2.y-20;
   end;
if tomate.x>770 then
      begin
      ChangerEcran(1);
      tomate.x:=1;
      end;
if tomate.x<0 then
      begin
      ChangerEcran(2);
      tomate.x:=765;
      end;

old.x:=0;
old.y:=0;
while (tomate.y<450) and (tomate.y>0) do
//      (tomate.x<770) and (tomate.x>0) do
      begin
      if tomate.x>770 then
         begin
         tomate.x:=1;
         if ChangerEcran(1)=false then exit;
         DessinerBackground(PosAire);
         end;
      if tomate.x<0 then
         begin
         tomate.x:=765;
         if ChangerEcran(2)=false then exit;
         DessinerBackground(PosAire);
         end;
      inc(i);
      if touche='Z' then
         begin
         old.x:=0;
         old.y:=-1;
         end;
      if touche='W' then
         begin
         old.x:=0;
         old.y:=1;
         end;
      if touche='S' then
         begin
         old.x:=1;
         old.y:=0;
         end;
      if touche='Q' then
         begin
         old.x:=-1;
         old.y:=0;
         end;
      tomate.x:=tomate.x+old.x;
      tomate.y:=tomate.y+old.y;
      Source.top:=tomate.y;
      Source.Left:=tomate.x;
      Source.Right:=Source.Left+30;
      Source.Bottom:=Source.top+30;
      Dest.Top:=0;
      Dest.Left:=0;
      Dest.Right:=30;
      Dest.Bottom:=30;
      imgback.Canvas.CopyRect(dest,Aire.canvas,source);
      Aire.canvas.draw(tomate.x,tomate.y,imgtomate);
      //Pause;
      if i/5-floor(i/5)=0 then
         sleep(1);
      Aire.canvas.Draw(tomate.x,tomate.y,imgBack);
    if encollision(1,offset,tomate.x,450-tomate.y)=true then
         begin
         Impact(1,offset,tomate.x,450-tomate.y);
         DessinerBackground(PosAire);
         Chutemontagne(offset,tomate.x,tomate.y);
         ChuteJoueur;
         exit;
         end;
      application.processmessages;

      end;
imgTomate.free;
imgBack.free;
end;

procedure TForm1.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
if button=btnext then
   begin
   tb2Force.Position:=tb2Force.Position+1;
   end
else
   begin
   tb2Force.Position:=tb2Force.Position-1;
   end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
PosAire:=PosAire-400;
   if PosAire<0 then
      PosAire:=0;
   DessinerBackground(PosAire);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
   offset:tpoint;
begin
offset.x:=0;
offset.y:=0;
impact(1,offset,300,100);
DessinerBackground(PosAire);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
   offset:tpoint;
begin
offset.x:=0;
offset.y:=0;
ChuteMontagne(offset,300,100);
end;

procedure TForm1.Button8Click(Sender: TObject);
var
   offset:tpoint;
begin
offset.x:=0;
offset.y:=0;
Copier(offset,300,100);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
init;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Init;
Timer1.enabled:=false;
end;

procedure TForm1.edtAngleChange(Sender: TObject);
begin
angle:=strtoint(edtAngle.text)*PI/360;
Puissance:=strtoint(edtForce.text);
Vent:=strtoint(edtvent.text)/200;
Gravite:=strtoint(edtgravite.text)/300;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
   PosAire:=PosAire+400;
   if Posaire+Aire.width>2500 then PosAire:=2500-Aire.width;
   DessinerBackground(PosAire);
end;

procedure TForm1.img1LeftClick(Sender: TObject);
begin
if Aire.canvas.pixels[posjoueur1.x,450-(PosJoueur1.y)+16]<>clgreen then
   begin
   dec(posJoueur1.x,5);
   DessinerBackground(PosAire);
   end;
end;

procedure TForm1.img1RightClick(Sender: TObject);
begin
if Aire.canvas.pixels[posjoueur1.x+55,450-(PosJoueur1.y)+10]<>clgreen then
      begin
      inc(posJoueur1.x,5);
      DessinerBackground(PosAire);
      end;
end;

procedure TForm1.img1UpClick(Sender: TObject);
begin
   inc(posJoueur1.y,5);
   DessinerBackground(PosAire);
end;

procedure TForm1.img1DownClick(Sender: TObject);
begin
   dec(posJoueur1.y,5);
   DessinerBackground(PosAire);
end;

procedure TForm1.img2UpClick(Sender: TObject);
begin
   inc(posJoueur2.y,5);
   DessinerBackground(PosAire);
end;

procedure TForm1.img2DownClick(Sender: TObject);
begin
   dec(posJoueur2.y,5);
   DessinerBackground(PosAire);
end;

procedure TForm1.img2RightClick(Sender: TObject);
begin
if Aire.canvas.pixels[posjoueur2.x+59-PosAire,450-(PosJoueur2.y)+15]<>clgreen then
   begin
   inc(posJoueur2.x,5);
   DessinerBackground(PosAire);
   end;
end;

procedure TForm1.img2LeftClick(Sender: TObject);
begin
if Aire.canvas.pixels[posjoueur2.x-PosAire+3,450-(PosJoueur2.y)+10]<>clgreen then
   begin
   dec(posJoueur2.x,5);
   DessinerBackground(PosAire);
   end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
Quitter:=true;
end;

procedure TForm1.tb2ForceChange(Sender: TObject);
begin
if joueur=1 then
   edtForce.text:=inttostr(tb1Force.position)
else
    edtForce.text:=inttostr(tb2Force.position);
end;

procedure TForm1.tb1ForceChange(Sender: TObject);
begin
EdtForce.Text:=inttostr(tb1Force.position);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
EdtForce.Text:=inttostr(tb2Force.position);
end;

procedure TForm1.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
if joueur=1 then
   begin
   joueur:=2;
   tb2ForceChange(self);
   end
else
    begin
    joueur:=1;
    Tb1ForceChange(Self);
    end;
init;
end;

procedure TForm1.Memo1Click(Sender: TObject);
begin
ChkChute.checked:=not ChkChute.checked;
end;



procedure TForm1.Button10Click(Sender: TObject);

begin
targeting:=true;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
   PIx,PIy:real;
   x,y,t:integer;
begin
PIx:=COS(angle)*puissance;
PIy:=SIN(angle)*puissance;
t:=100;
x:=floor(PIx/1000*t);
y:=450-floor(PIy/500*t);
Aire.Canvas.MoveTo(0,450);
Aire.canvas.lineto(x,y);
end;

procedure TForm1.AireMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
   valeur:real;
   Valeur2:real;
//   angle:real;
   a,b:real;
   X1,Y1:integer;
   X2,Y2:integer;
   distance:integer;
begin
exit;
Edit5.text:=inttostr(x);
Edit6.text:=inttostr(y);

if 450-y-PosJoueur1.y<>0 then
   begin
   valeur:=((x-(PosJoueur1.x+48-PosAire))/((450-y-PosJoueur1.y)));
   valeur:=ArcTan(valeur)*360/2/PI;
   if valeur<0 then
      begin
      if x>(PosJoueur1.x+48-PosAire) then
         valeur:=0;
      if x<(PosJoueur1.x+48-PosAire) then
         Valeur:=90;
      end
      else
          valeur:=90-valeur;
   //Edit1.text:=inttostr(floor(valeur));
   end;
//if ssleft in shift then else exit;
x1:=PosJoueur1.x-PosAire+28;//+48;
y1:=450-PosJoueur1.y;
a:=(y1-Y)/(x1-X);
b:=Y-a*X;
distance:=0;
x2:=0;
//distance:=floor( sqrt( (x-X1)*(x-x1)+(y-y1)*(y-y1) ) );
while (Distance<100) do
      begin
      inc(x2);
      y2:=floor(a*x2+b);
      Aire.canvas.pixels[x2,Y2]:=clred;
      distance:=floor( sqrt( (x2-X1)*(x2-x1)+ (y2-y1)*(y2-y1) ) );
      end;
Aire.canvas.moveto(x1,y1);
Aire.canvas.lineto(x2,y2);
Edit1.text:=format('%.3f',[a]);
Edit2.text:=format('%.3f',[b]);
Edit3.text:=inttostr(x1);
Edit4.text:=inttostr(y1);
{Edit3.text:=inttostr(x2);
Edit4.text:=inttostr(y2);}
edit7.text:=inttostr(distance);
{if tan(valeur)<>0 then
valeur2:=Sqr(1+1/(tan(valeur)*tan(valeur)));
if valeur2<>0 then
   Valeur2:=50/valeur2;
Edit2.text:=inttostr(floor(valeur2));}
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
chkLave.checked:=not chklave.checked;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   temp:char;
begin
temp:=char(key);
if (temp='Q') or (temp='Z') or (temp='S') or (temp='W') then
   touche:=temp;
Edit7.text:=temp;
end;

procedure TForm1.cbArmeChange(Sender: TObject);
begin
Button1.Enabled:=true;
end;

end.
