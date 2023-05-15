//LOADS THE INDIVIDUAL STACKS OF BOOKS FOR STRESSLEVEL
//1 STACK = 1 level of STRESS

class Stress{
  float xPos;
  float yPos;
  float wid;
  float hei;
  PImage photo;
  
  Stress(int x, int y){
    photo = loadImage("images/books.png");
    xPos = x;
    yPos = y;
    wid = 100;
    hei = 100;
  }
  
  void display(){
   image(photo, xPos, yPos, wid, hei);
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
  
}
