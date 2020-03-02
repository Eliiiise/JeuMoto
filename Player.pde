
class Player{
  int x;
  int y;
  color couleur;
  float cabrage=0, memoCab=0;
  float m,n;
  float gravit=10, memoHaut=-150, memoGravit=5, gravitCab;
  float memoZ=0, memoX=0;
  float saut=0;
  int memoSolHaut=-150;
  int vitesseMemo=1;

  Player(){
      
  }

  void display(){
    if (memoCab==0){
      m=-100;
      n=0;
    }
    if (memoCab<0){
      m=-30;
      n=-70;
    }
    if (memoCab>0){
      m=-170;
      n=70;
    }
      
    saut = saut - gravit;
    memoHaut=memoHaut+gravit - saut;
    /*print("]                  memoHaut[");
      print(memoHaut);
      print("]  -solHaut[");
      print(-solHaut);*/
    if (memoHaut>=-solHaut){
      memoHaut=-solHaut;
    }
    else
    {
      gravit=5;
    }
    
    if (memoZ-zvalue>5 && saut<-100){
      saut=5*(memoZ-zvalue);
      if (saut>80) {
        saut=80;
      }
    }
    memoZ=zvalue;
    rotate(radians(pente));
    if (pente==-20){
       translate(-272, 138);//emplacement - moitier de la taille du player
    }
    if (pente==20){
       translate(210, -210);//emplacement - moitier de la taille du player
    }
    translate(500+n, 850+memoHaut);//emplacement - moitier de la taille du player
    
    if (vitesse==2){
      memoCab=memoCab-8;
      gravitCab=gravit/10;
    }
    if (vitesseMemo-vitesse==-1){
       
       print("BBB   ");
    }
    vitesseMemo=vitesse;
    
    
    if (memoX-xvalue>1){
      cabrage=-8;
      gravitCab=gravit/10;
    }
    if (memoX-xvalue<-1){
      cabrage=8;
      gravitCab=-gravit/10;
    }
    memoX=xvalue;
    cabrage=cabrage+gravitCab;
    memoCab=memoCab+cabrage;
    
    if (memoCab==0){
      cabrage=0;
      gravitCab=0;
    }
    if (memoCab<6 && memoCab>-6){
      memoCab=0;
      cabrage=0;
      gravitCab=0;
    }
    
    if(memoCab>150 || memoCab<-150){
      memoCab=0;
      cabrage=0;
      gravitCab=0;
      print("STOPP       ");
    }
    
    rotate(radians(memoCab));
    image(player,m,-200);//moitier de la taille du player
    //circle(0,0,10);
  }
 
}
