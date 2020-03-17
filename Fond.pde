class Fond{
  
  

  Fond(){   
  }
  
  void display() {
    
    if (play==1) {
      i4=i4-0.5*vitesse;
      i5=i5-1*vitesse;
    }
    
    image(terrain,0,0);
    image(ciel,0,200);
    image(coline,int(i4),400);
    image(coline2,int(i5),480);
    
  }
 
}
