import processing.serial.*;
import ddf.minim.*;

Serial port;

int bvalue = 0;
int xvalue = 0;
int yvalue = 0;
float press = 0;
float zvalue = 0;
int taillePlayer = 200;
PImage terrain, player, nuage, nuage2, sol, ciel, coline, coline2;
Minim minim;
AudioPlayer musicFond;
int i=1400, i2=400,i3=0, i4=-500, i5=0;
int x=1;
int t1=5500, ft1=6200, m1=11300, fm1=12500, m2=24600, fm2=25800, cpt=0;

float pente=0;
float monte=0;
float memMonte=0;
int vitesse=1;
int solHaut=150;

Player monPlayer= new Player();

void setup() {
    size(1400, 900);
    
    port = new Serial(this, "COM3", 9600);
    port.bufferUntil('\n');
    
    terrain = loadImage("fond.png");
    terrain.resize(width, height);
    
    player = loadImage("moto.png");
    player.resize(taillePlayer, taillePlayer);
    
    x=int(random(20,50));
    nuage = loadImage("nuage.png");
    nuage.resize(4*x,x);
    
    x=int(random(30,80));
    nuage2 = loadImage("nuage2.png");
    nuage2.resize(4*x,x);
    
    sol = loadImage("sol.png");
    
    ciel = loadImage("ciel.png");
    ciel.resize(width, 300);
    
    coline = loadImage("coline.png");
    coline.resize(4000, 300);
    
    coline2 = loadImage("coline2.png");
    coline2.resize(4000, 700);
    
}

void draw() {
  i=i-6*vitesse;
  i2=i2-8*vitesse;
  i3=i3-20*vitesse;
  i4=i4-1*vitesse;
  i5=i5-2*vitesse;
  
  speed();
  boucleNuage();
  
  image(terrain,0,0);
  image(nuage,i,280);
  image(nuage2,i2,100);
  image(ciel,0,200);
  image(coline,i4,400);
  image(coline2,i5,480);
  memMonte=memMonte+monte;
  image(sol,i3,memMonte-830);
  monPlayer.display();
  suivi();
  delay(10);
}

void serialEvent(Serial port) {
    String serialStr = port.readStringUntil('\n');
    serialStr = trim(serialStr);
    int values[] = int(split(serialStr, ','));
    if( values.length == 4 ) {
        xvalue = calculate(values[1], 342 );
        zvalue = calculate(values[2], 413 );
        bvalue = values[3];
    }     
}

void suivi() {
       cpt=cpt+20*vitesse;
       if (cpt>=m1 && cpt<=fm1 || cpt>=m2 && cpt<=fm2){
         pente=-20;
         monte=12*vitesse;
       }
       else if(cpt>=t1 && cpt<=ft1){
         solHaut=0;
       }
       else {
         solHaut=150;
         pente=0;
         monte=0;
       }
       
}

int calculate( int returnValue, int baseValue ) {
  int delta = returnValue - baseValue;
  return round(delta /5);
}

void speed() {
  if (bvalue==1){
    vitesse=2;
  }
  else {
    vitesse=1;
  }
}

void boucleNuage(){
  if (i<-500) {
    x=int(random(20,50));
    i=1400;
    nuage = loadImage("nuage.png");
    nuage.resize(4*x,x);
    image(nuage,i,280);
  }
  if (i2<-1000) {
    x=int(random(30,80));
    i2=1400;
    nuage2 = loadImage("nuage.png");
    nuage2.resize(4*x,x);
    image(nuage2,i2,100);
  }
}
