import processing.serial.*;
import ddf.minim.*;

Serial port;

int bvalue = 0;
int xvalue = 0;
float zvalue = 0;

float memoHaut=-150;

float niveauEssence = 278;

int taillePlayer = 200;
int tailleBarriere = 100;
int taillePiece = 50;
int tailleTerrainLarg = 500;
int tailleTerrainHaut = 800;

PImage terrain, player, nuage, nuage2, sol, ciel, coline, coline2, barriere, plat, mont, des, piece, pieceRouge, compteurVitesse, indicateur, essenceUnder, essence;

Minim minim;
AudioPlayer musicFond, musicPiece;

float i3=0;
int x=1;
int cpt=0;

int nbPiece=0;

float pente=0;
float monte=0;
float vitesse=1;
int solHaut=150;
int deltaHaut=0;

int hauteurSomme=0 ;

int[] niveau1 = {0,0,0,0,0};
int[] memoHautNiveau;
int[] memoBarriere = {};
int[] memoPiece = {};
int[] memoPiece290 = {};
int[] memoPiece380 = {};

Player monPlayer= new Player();
Barriere maBarriere = new Barriere();
Piece maPiece = new Piece();
Sol monSol = new Sol();
Nuage monNuage = new Nuage();
Fond monFond = new Fond();

void setup() {
  
    size(1400, 900);
    
    port = new Serial(this, "COM3", 9600);
    port.bufferUntil('\n');
    
    minim = new Minim(this);
    musicFond = minim.loadFile("music-fond.mp3");
    
    minim = new Minim(this);
    musicPiece = minim.loadFile("music-piece.mp3");
    
    terrain = loadImage("fond.png");
    terrain.resize(width, height);
    
    player = loadImage("moto.png");
    player.resize(taillePlayer, taillePlayer);
    
    barriere = loadImage("barriere.png");
    barriere.resize(tailleBarriere,tailleBarriere);
    
    piece = loadImage("piece-jaune.png");
    piece.resize(taillePiece,taillePiece);
    
    pieceRouge = loadImage("piece-rouge.png");
    pieceRouge.resize(taillePiece,taillePiece);
    
    plat = loadImage("plat.png");
    plat.resize(tailleTerrainLarg,tailleTerrainHaut);
    
    mont = loadImage("monte.png");
    mont.resize(tailleTerrainLarg,tailleTerrainHaut);
    
    des = loadImage("descente.png");
    des.resize(tailleTerrainLarg,tailleTerrainHaut);
    
    x=int(random(20,50));
    nuage = loadImage("nuage.png");
    nuage.resize(4*x,x);
    
    x=int(random(0,80));
    nuage2 = loadImage("nuage2.png");
    nuage2.resize(4*x,x);
    
    ciel = loadImage("ciel.png");
    ciel.resize(width, 300);
    
    coline = loadImage("coline.png");
    coline.resize(4000, 300);
    
    coline2 = loadImage("coline2.png");
    coline2.resize(4000, 700);
    
    sol = loadImage("sol.png");
    
    compteurVitesse = loadImage("vitesse.png");
    compteurVitesse.resize(150,150);
    
    indicateur = loadImage("indicateur.png");
    indicateur.resize(25,70);
    
    essence = loadImage("essence.png");
    essence.resize(284,40);
    
    essenceUnder = loadImage("essence-under.png");
    essenceUnder.resize(350,40);
    
}

void draw() {
  
  if(!musicFond.isPlaying()){
    musicFond.rewind();
    musicFond.play();
  }

  i3=i3-20*vitesse;
  speed(); 
  
  monFond.display(); 
  monNuage.display();
  
  tableauDeBord();
  
  translate(0,int(monte));

  addAleaTab();
  creaTerrain();
  
  maBarriere.display();
  maPiece.display();
  
  translate(0,-monte+deltaHaut);
  
  monPlayer.display();
  
  collisionBarriere();
  recupPiece();
  
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


int calculate( int returnValue, int baseValue ) {
  int delta = returnValue - baseValue;
  return round(delta /5);
}


void speed() {
  if (bvalue==1){//acceleration
    vitesse = vitesse+0.04;
    niveauEssence = niveauEssence-0.5;
  }
  if (pente == - 20) {//monte
    vitesse = vitesse-0.03;
  }
   if (pente ==  20) {//descente
    vitesse = vitesse+0.03;
  }
  vitesse = vitesse- (0.01*vitesse);//frottement
  
  if (vitesse>3) {//vitesse MAX
    vitesse = 3 ;
  }
  
}


void monteTerrain(int n,int m, int h) {
  monSol.monteTerrain(n,m,h);
  if (i3<=-tailleTerrainLarg*(n-1) && i3>-tailleTerrainLarg*(m-1)){
    int x = int(-i3);
    int delta = x % 500 ;
    int y = x / 500;
    int u = memoHautNiveau[y]; 
    println(u);
    
    int monteBloc=220;
    
    monte= delta*monteBloc/500+u*monteBloc;
    pente=-20;
    deltaHaut=-30;
  }
}


void platTerrain(int n,int m, int h) {
  monSol.platTerrain(n,m,h);
  if (i3<=-tailleTerrainLarg*(n-1) && i3>-tailleTerrainLarg*(m-1)){
    
    int x = int(-i3);
    int y = x / 500;
    int u = memoHautNiveau[y]; 
    int monteBloc=220;
    
    monte=u*monteBloc;
    pente=0;
    deltaHaut=-25;
  }
}


void descenteTerrain(int n,int m, int h) {
  monSol.descendTerrain(n,m,h);
  if (i3<=-tailleTerrainLarg*(n-1) && i3>-tailleTerrainLarg*(m-1)){
    
    int x = int(-i3);
    int delta = x % 500 ;
    int y = x / 500;
    int u = memoHautNiveau[y]; 
    println(u);
    
    int monteBloc=220;
    
    monte= -delta*monteBloc/500+u*monteBloc;
    pente=20;
    deltaHaut=-30;
  }
}


void recupPiece() {
    for (int n=0 ; n<memoPiece.length ; n = n+1) {
    if (300 > int(i3)+1700+memoPiece[n] && 0 < int(i3)+1700+memoPiece[n] ){
      if (memoHaut>-200) {
        memoPiece[n]=-2000;
        nbPiece=nbPiece+1;
        if(!musicPiece.isPlaying()){
          musicPiece.rewind();
          musicPiece.play();
        }
      }
    }
  }
  for (int n=0 ; n<memoPiece290.length ; n = n+1) {
    if (300 > int(i3)+2100+memoPiece290[n] && 0 < int(i3)+2100+memoPiece290[n] ){
      if (memoHaut<-240) {
        memoPiece290[n]=-2000;
        nbPiece=nbPiece+1;
        if(!musicPiece.isPlaying()){
          musicPiece.rewind();
          musicPiece.play();
        }
      }
    }
  }
  
  for (int n=0 ; n<memoPiece380.length ; n = n+1) {
    if (300 > int(i3)+2100+memoPiece380[n] && 0 < int(i3)+2100+memoPiece380[n] ){
      println(memoPiece380[n]);
      if (memoHaut<-300) {
        memoPiece380[n]=-2000;
        nbPiece=nbPiece+10;
        if(!musicPiece.isPlaying()){
          musicPiece.rewind();
          musicPiece.play();
        }
      }
    }
  }
}

void collisionBarriere() {
  for (int n=0 ; n<memoBarriere.length ; n = n+1) {
    if (300 > int(i3)+1700+memoBarriere[n] && 0 < int(i3)+1700+memoBarriere[n] ){
      if (memoHaut>-250) {
        println("Deaddd");
      }
    }
  }
}


void tableauDeBord() {
  textSize(32);
  fill(255);
  text(nbPiece, width-180, 85);
  image(piece, width-250,50);
  image(compteurVitesse,60,20);
  translate(135,100);
  rotate(radians(vitesse*50-3*40));
  image(indicateur,-12.5,-58);
  
  rotate(radians(-(vitesse*50-3*40)));
  translate(-135,-100);
  
  image(essenceUnder,450,30);
  fill(255,0,0);
  rect(522,34,niveauEssence,30,20);
  image(essence,517,30);
}


void addAleaTab() {
  float r = random(0,1);
  int p;
  if (r<= 0.3 || hauteurSomme>2){
    p=-1;
  }
  else if (r>= 0.7 || hauteurSomme<-2) {
    p=1;
  }
  else {
    p=0;
  }
  niveau1 = splice(niveau1, p , niveau1.length);
}


void creaTerrain() {
  
  hauteurSomme=0 ;
  memoHautNiveau = new int[niveau1.length];

  for (int l = 0 ; l < niveau1.length ; l = l + 1) {
    hauteurSomme = int(hauteurSomme + niveau1[l]);
    memoHautNiveau[l] = int(hauteurSomme); 
    
    if ( niveau1[l] == 1 ) {
      monteTerrain(l,l+1,hauteurSomme-1);
    }
    
    else if ( niveau1[l] == 0 ) {
      platTerrain(l,l+1,hauteurSomme);
    }
    
    else if ( niveau1[l] == -1 ) {
      descenteTerrain(l,l+1,hauteurSomme+1);
    }
    
  }
}
