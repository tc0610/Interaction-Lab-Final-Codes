/**
Loads the image for the scissor object.
Allows scissor to be shown and moved accordingly

**/

class Scissor{
  float xPos;
  float yPos;
  float ySpd;
  PImage photo;
  float wid;
  float hei;
  
  Scissor(float x, float y){
    xPos = x;
    yPos = y;
    ySpd = 5;
    wid = 100;
    hei = 100;
    photo = loadImage("images/sci.png");
  }
  
  void move(){
   if (yPos < 450){
     yPos += ySpd;
   }
  }
   
  float getY(){
   return yPos; 
  }
  
  float getX(){
   return xPos; 
  }
  void display(){
   image(photo, xPos, yPos, wid, hei); 
  }
  
}
