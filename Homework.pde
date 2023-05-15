class Homework{
  float xPos;
  float yPos;
  float ySpd;
  float wid;
  float hei;
  
  PImage photo;
  
  Homework(float x, float y){
    xPos = x;
    yPos = y;
    ySpd = 3;
    wid = 100;
    hei = 100;
    
    photo = loadImage("images/h.png");
  }
  
  void move(){
    if (yPos < 450){
     yPos += ySpd;
    }
  }
  
  float getY(){
   return yPos; 
  }
  
  float getWid(){
   return wid; 
  }
  
  float getHei(){
   return hei; 
  }
  
  float getX(){
   return xPos; 
  }
  
  void display(){
   image(photo, xPos, yPos, wid, hei); 
  }
 
  
}
