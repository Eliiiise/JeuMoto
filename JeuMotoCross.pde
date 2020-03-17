import processing.serial.*;
import ddf.minim.*;

Serial port;

int bvalue = 0;
int xvalue = 0;
float zvalue = 0;

int play = 0;

float memoHaut=-150;

float niveauEssence = 278;

int taillePlayer = 200;
int tailleBarriere = 100;
int taillePiece = 50;
int tailleTerrainLarg = 500;
int tailleTerrainHaut = 800;

PImage terrain, player, nuage, nuage2, sol, ciel, coline, coline2, barriere, plat, mont, des, piece, pieceRouge, compteurVitesse, indicateur, essenceUnder, essence, jaugeEssence, menu, playB, record, cptPiece;

PGraphics mask;

Minim minim;
AudioPlayer musicFond, musicPiece, musicCrash, musicButton, musicDead;

float i3=0;
float i4=-500, i5=0;
int x=1;
int cpt=0;

int nbPiece=0;

float pente=0;
float monte=0;
float vitesse=1;
int solHaut=150;
int deltaHaut=0;
int time=0;

int recordPiece=0;

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
    musicPiece = minim.loadFile("music-piece.wav");
    
     minim = new Minim(this);
    musicCrash = minim.loadFile("music-crash.mp3");
    
    minim = new Minim(this);
    musicButton = minim.loadFile("music-button.mp3");
    
    minim = new Minim(this);
    musicDead = minim.loadFile("music-dead.mp3");
    
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
    compteurVitesse.resize(140,140);
    
    indicateur = loadImage("indicateur.png");
    indicateur.resize(25,70);
    
    essence = loadImage("essence.png");
    essence.resize(350,65);
    
    essenceUnder = loadImage("essence-under.png");
    essenceUnder.resize(330,60);
    
    jaugeEssence= loadImage("essence-niveau.png");
    jaugeEssence.resize(290,52);
    
    menu = loadImage("menu.png");
    menu.resize(480,500);
    
    cptPiece = loadImage("cpt-piece.png");
    cptPiece.resize(170,60);
    
    playB = loadImage("play.png");
    playB.resize(150,80);
    
    record = loadImage("record.png");
    record.resize(360,60);
    
}

void draw() {
  
  if(!musicFond.isPlaying()){
    musicFond.rewind();
    musicFond.play();
  }
  
  monFond.display(); 
  monNuage.display();
  
  if ( play==0 ) {
    time=time+1;
    image(menu,450,160);
    image(playB,612,490);
    image(record,510,370);
    textSize(28);
    fill(255);
    text(recordPiece, 760, 410);
    if (time>50) {
      start();
    }
  }

  if ( play==1 ) {
    
    i3=i3-20*vitesse;
    speed(); 
    
    
    
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
    
    if ( niveauEssence<=0 && vitesse<=0 ) {
      dead();
    }
    
  }
  
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
  if (bvalue==1 && niveauEssence>0){//acceleration
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
        if(!musicCrash.isPlaying()){
          musicCrash.rewind();
          musicCrash.play();
        }
        dead();
      }
    }
  }
}


void tableauDeBord() {
  textSize(32);
  fill(255);
  image(cptPiece, width-250,45);
  text(nbPiece, width-180, 85);
  image(compteurVitesse,65,30);
  translate(135,100);
  rotate(radians(vitesse*50-3*40));
  image(indicateur,-12.5,-58);
  
  
  rotate(radians(-(vitesse*50-3*40)));
  translate(-135,-100);
  
  mask = createGraphics(290,52); //size of mask
  mask.beginDraw();
  mask.rect(275-niveauEssence, 1, 290-(278-niveauEssence),54,55);
  mask.endDraw();
  
  jaugeEssence.mask(mask);
  
  image(essenceUnder,500,50);
  image(jaugeEssence,-278+niveauEssence+500,56);
  image(essence,495,50);
  
  
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

void start() {
  if (bvalue==1){//acceleration
    if(!musicButton.isPlaying()){
      musicButton.rewind();
      musicButton.play();
    }
    play=1;
    memoHaut=-150;
    niveauEssence = 278;
    i3=0;
    x=1;
    cpt=0;
    nbPiece=0;
    vitesse=1;
    i4=-500;
    i5=0;
    niveau1 = new int[]{0,0,0,0,0};
    memoBarriere = new int[]{};
    memoPiece = new int[]{};
    memoPiece290 = new int[]{};
    memoPiece380 = new int[]{};
  }
}

void recordRefresh() {
  if (nbPiece>recordPiece) {
    recordPiece=nbPiece;
  }
}

void dead() {
  if(!musicDead.isPlaying()){
    musicDead.rewind();
    musicDead.play();
  }
  recordRefresh();
  play=0;
  time=0; 
}
