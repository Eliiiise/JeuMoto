class Sol {
  
  float memoHautSol=0;
  float HautSol=2.5;
 

  Sol() {
      
  }
  
  void platTerrain(int n,int m, int h) {
    for (int i = n; i < m; i = i+1) {
         image(plat,i3+((tailleTerrainLarg)*i),260+memoHautSol+(-h*220));
         noStroke();
        fill(129, 51, 0);
         rect(i3+((tailleTerrainLarg)*i),260+(-220)*(i-n)+memoHautSol+(-h*220)+tailleTerrainHaut,500,500);
    }
  }
  
  void monteTerrain(int n,int m, int h) {
    for (int i = n; i < m; i = i+1) {
        image(mont,i3+((tailleTerrainLarg)*i),275+(-220)*(i-n)+memoHautSol+(-h*220));
        noStroke();
        fill(129, 51, 0);
        rect(i3+((tailleTerrainLarg)*i),275+(-220)*(i-n)+memoHautSol+(-h*220)+tailleTerrainHaut,500,500);
        
    }
  }
  
  void descendTerrain(int n,int m, int h) {
    for (int i = n; i < m; i = i+1) {
        image(des,i3+((tailleTerrainLarg)*i),478+(+220)*(i-n)+memoHautSol+(-h*220));
        noStroke();
        fill(129, 51, 0);
        rect(i3+((tailleTerrainLarg)*i),478+(-220)*(i-n)+memoHautSol+(-h*220)+tailleTerrainHaut,500,500);
    }
  }
}
