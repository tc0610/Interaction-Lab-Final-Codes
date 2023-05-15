class Player{
  PImage photo1, photo2;
  float xPos;
  float yPos;
  float wid;
  float hei;
  boolean isHand = true;
  
  Player(){
    photo1 = loadImage("images/hands.png");
    photo2 = loadImage("images/sci2.png");
  }
  
  void display(int x, int y){
    xPos = x;
    yPos = y;
    wid = 200;
    hei = 200;
    if (isHand){ 
     image(photo1, xPos, yPos); 
    }
    else{
     image(photo2, xPos, yPos, 100, 100); 
    }
  }
    
  float getY(){
   return yPos; 
  }
  
  float getX(){
   return xPos; 
  }
  
  float getWid(){
   return wid; 
  }
  
  boolean getIsHand(){
    return isHand;
  } 
  
  float getHei(){
   return hei; 
  }
  
  void ctScissor(){
    isHand = false;
  }
  
   void ctHand(){
    isHand = true;
  }
  
 
}
