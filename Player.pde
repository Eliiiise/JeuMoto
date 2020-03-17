class Player{
  int x;
  int y;
  color couleur;
  float cabrage=0, memoCab=0;
  float m,n;
  float gravit=20, memoGravit=5, gravitCab;
  float memoZ=0, memoX=0;
  float saut=0;
  int memoSolHaut=-150;
  float vitesseMemo=1;
  float memoPente=0;

  Player(){
      
  }

  void display() {
     
    if (memoCab==0){
      m=-100;
      n=0;
    }
    
    if (memoCab<0) {
      m=-30;
      n=-70;
    }
    
    if (memoCab>0) {
      m=-170;
      n=70;
    }
      
    saut = saut - gravit/2;
    memoHaut=memoHaut+gravit - saut;

      
    
    if (memoHaut>=-solHaut){
      memoHaut=-solHaut;
    }
    else
    {
      gravit=5;
    }
    
    if (memoZ-zvalue>2 && saut<-100){
      saut=15*(memoZ-zvalue);
      if (saut>50) {
        saut=50;
      }
    }
    memoZ=zvalue;
    
    if (pente==-20 && memoPente>-20) {
      memoPente=memoPente-7;
    }
    
    if (pente==20 && memoPente<20) {
      memoPente=memoPente+7;
    }
    
    if (pente==0 && memoPente<0) {
      memoPente=memoPente+7;
    }
    
    if (pente==0 && memoPente>0) {
      memoPente=memoPente-7;
    }
    
    
    translate(500+n, 850+memoHaut);//emplacement - moitier de la taille du player
    
    if (vitesse==2){
      memoCab=memoCab-8;
      gravitCab=gravit/10;
    }
    if (vitesseMemo-vitesse==-1){

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
    }
    
    
    rotate(radians(memoCab));
    rotate(radians(memoPente));
    
    image(player,m,-200);
    
  }
 
}
