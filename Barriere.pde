
class Barriere{
  
  int barriereACT=1;
  
  Barriere(){
      
  }
  
  void display() {
    
    i3=int(i3);
    if (i3 % 3000 < -2980 && barriereACT==1) {
      float r = random(200,2800);
      memoBarriere = splice(memoBarriere, int(-i3+r) , memoBarriere.length);
      barriereACT=0;
    }
    
    if (i3 % 3000 > -20 ) {
      barriereACT=1;
    }
    
    for (int n=0 ; n<memoBarriere.length ; n = n+1) {
      barriere(2000+memoBarriere[n]);
    }
    
  }
  
  
  
  void barriere(int x) {
    int delta = x % 500 ;
    int y = x / 500;
    int u = memoHautNiveau[y]; 
    
    float yFinal=u+(delta/500.0 -0.95)*float(niveau1[y]);

    image(barriere,int(i3+x),int(yFinal*(-220)+580));  //1 : 370  3 : -70 
  }
 
}
