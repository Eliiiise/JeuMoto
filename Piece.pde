
class Piece{
  
  
  int actif = 0;
  int pieceACT = 1;
  
  Piece(){
      
  }
  
  void display() {
    
    float z = random(0,1);
    
    i3=int(i3);
    //vitesse=1;
    
    actif = 1;
    
     for (int n=0 ; n<memoBarriere.length ; n = n+1) {
       
      if (300 > i3+memoBarriere[n] && 280 < i3+memoBarriere[n] ) {
        memoPiece290 = splice(memoPiece290, int(-i3)-100 , memoPiece290.length);
        memoPiece380 = splice(memoPiece380, int(-i3)+50 , memoPiece380.length);
        memoPiece290 = splice(memoPiece290, int(-i3)+200 , memoPiece290.length);
      }
      
      if (300 > i3+memoBarriere[n] && -300 < i3+memoBarriere[n] ) {
        actif = 0;
      }
    }
    
    
    for (int n=0 ; n<memoPiece290.length ; n = n+1) {
      piece290(2000+memoPiece290[n]);
    }
    
    for (int n=0 ; n<memoPiece380.length ; n = n+1) {
      piece380(2000+memoPiece380[n]);
    }
    
    
    if (i3 % 100 > -20 && actif == 1 && pieceACT==1 ) {
      if (z>0.8) {
        memoPiece = splice(memoPiece, int(-i3) , memoPiece.length);
        pieceACT=1;
      }
    }
    
    if ( i3 % 100 < -80 ) {
      pieceACT=1;
    }
    
    for (int n=0 ; n<memoPiece.length ; n = n+1) {
      piece(2000+memoPiece[n]);
    }
    
  }
  
  
  
  void piece(int x) {
    int delta = x % 500 ;
    int y = x / 500;
    int u = memoHautNiveau[y]; 
    
    float yFinal=u+(delta/500.0 -0.95)*float(niveau1[y]);
    
    image(piece,int(i3+x),int(yFinal*(-220)+580));  //1 : 370  3 : -70  
  }
  
  void piece290(int x) {
    int delta = x % 500 ;
    int y = x / 500;
    int u = memoHautNiveau[y]; 
    
    float yFinal=u+(delta/500.0 -0.95)*float(niveau1[y]);
    
    image(piece,int(i3+x+300),int(yFinal*(-220)+580-290)); 
  }
  
  void piece380(int x) {
    int delta = x % 500 ;
    int y = x / 500;
    int u = memoHautNiveau[y]; 
    
    float yFinal=u+(delta/500.0 -0.95)*float(niveau1[y]);

    image(pieceRouge,int(i3+x+300),int(yFinal*(-220)+580-380));
  }
}
