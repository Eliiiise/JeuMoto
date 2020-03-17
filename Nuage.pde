
class Nuage{
  
  float i=1400, i2=400;

  Nuage(){
      
  }
  
  void display() {
    image(nuage,i,280);
    image(nuage2,i2,100);
    i=i-4-vitesse;
    i2=i2-8-vitesse;
    boucleNuage();
  }
  
  void boucleNuage(){
  if (i<-1000) {
    x=int(random(20,50));
    i=1400;
    nuage = loadImage("nuage.png");
    nuage.resize(4*x,x);
    image(nuage,i,280);
  }
  if (i2<-500) {
    x=int(random(30,80));
    i2=1400;
    nuage2 = loadImage("nuage.png");
    nuage2.resize(4*x,x);
    image(nuage2,i2,100);
  }
 
}
}
