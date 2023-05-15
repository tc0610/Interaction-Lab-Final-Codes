import processing.sound.*;

//RECEVING SERIAL INPUT
import processing.serial.*;
Serial serialPort;
//NUM OF ELEMENTS IN ARRAY
int NUM_OF_VALUES_FROM_ARDUINO = 3; 
//ARRAY
int arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];

//ARRAYLIST of OBJECTS
ArrayList<Homework> works = new ArrayList<Homework>();
ArrayList<Scissor> scis = new ArrayList<Scissor>();
ArrayList<Stress> stress = new ArrayList<Stress>();

//IMAGES
PImage bg, start, title, qilin, scs, cry, descript;
PImage instruct, gotit, yay, oh, restart, h;
//PAGES NUMBER
int page = 0;

int maxStress = 50;

//EVERYTHING NEEDED FOR ONE GAME
float startTime;
boolean startRecorded = false;
int rt1 = 1000;
int rt2 = 1500;
int stressLevel = 0;
float stressVar = 0.8;
int scissNum = 0;
int counter = 0;

//PLAYER OBJECT
Player player;

//TIME OF GAME
int totalTime = 1*60*1000;
//int totalTime = 2000;
int timeLeft;

SoundFile victory, bgm, lose ding;

boolean hasWon = false;
boolean lost = false;
boolean isHand = true;


int xValue;
int yValue;


/** Every homework is 4% stress**/

void setup() {
  size(1200, 700);
  bg = loadImage("images/b.png");
  start = loadImage("images/start.png");
  restart = loadImage("images/restart.png");
  title = loadImage("images/title.png");
  qilin = loadImage("images/qilin.png");
  scs = loadImage("images/sci2.png");
  cry = loadImage("images/cry.png");
  descript = loadImage("images/descript.png");
  gotit = loadImage("images/gotit.png");
  instruct = loadImage("images/instruct.png");
  yay = loadImage("images/yay.png");
  oh = loadImage("images/oh.png");
  h = loadImage("images/hands.png");
  player = new Player();
  
  victory = new SoundFile(this, "music/victory.mp3");
  bgm = new SoundFile(this, "music/bgm.mp3");
  lose = new SoundFile(this, "music/lose.mp3");
  ding = new SoundFile(this, "music/ding.mp3");
  
  bgm.loop();
  
  printArray(Serial.list());
  serialPort = new Serial(this, "/dev/cu.usbmodem14101", 9600);
  
}

void draw() {
  
  image(bg, 0, 0);
  getSerialData();   
  yValue = 600 - 5 * int(arduino_values[1]);
  if(yValue >600){
    yValue = 20;
  }
  xValue = 10 * int(arduino_values[2]);
  //xValue = mouseX;
  
  
  //DETECTION OF HAND CLAP
   //////////////////////////////////////////////////////////////////////////
  if (arduino_values[0] == 1){
    isHand = true;
  }
  else{
    isHand = false; 
  }
  if(isHand){  
      player.ctScissor();
  }
   else{
    player.ctHand();    
  }
    

  
  //START PAGE
  //////////////////////////////////////////////////////////////////////////
  if (page == 0) {
    firstPage();
   
  } 
  
  //INSTRUCTIONS PAGE
   //////////////////////////////////////////////////////////////////////////
  else if (page == 1){
    instructPage();
    if(isHand){
      image(scs, width*0.8, height*0.8, 100,100);
    }
    else{
      image(h, width*0.8, height*0.8);
    }
  }
  
  // PLAYING PAGE
    //////////////////////////////////////////////////////////////////////////
  else if (page == 2) {
    
    image(qilin, width*0.4, height*0.6); 
    //image(scs, width*0.62, height*0.93, 30,30);
    fill(0);
    textSize(50);
    String sLevel = "Stresslevel: " + stressLevel;
    String scissN = "Scissors collected: " + scissNum;
    text(sLevel, width*0.03, height*0.97);
    text(scissN, width*0.65, height*0.97);
    
    player.display(xValue, yValue);
    
    
    if (millis() - startTime > rt1){
       randomSeed(millis());
       scis.add(new Scissor(random(width*0.1, width*0.9), 0));
       rt1 += random(2000, 5000);
     }
     if (millis() - startTime > rt2){
       works.add(new Homework(random(width*0.1, width*0.9), 0));
       rt2 += random(2000, 5000);
     }
     if(player.getIsHand()){
       checkCollisionHand();
     }
     else{
       checkCollisionScis();   
     }
     checkHomework();
     checkScissor();
     drawStressLevel();
     drawHomework();
     drawScissor();
     timeLeft();
     
   if (millis() - startTime > totalTime) {
    page = 3;
   }
   
  } 
  
  //END PAGE
  //////////////////////////////////////////////////////////////////////////
  else if (page == 3) {
    if(stressLevel <= maxStress){
       hasWon = true;
       image(yay, width*0.23, height*0.1);
       image(qilin, width*0.37, height*0.6);
    }
    else{
       lost = true;
       image(oh, width*0.23, height*0.1);
       image(cry, width*0.37, height*0.6);
    }
    image(restart, width*0.75, height-150, 300, 150);
    if(hasWon && victory.isPlaying() == false && counter == 0){
      victory.play();
      hasWon = false;
      counter ++;
    }
    else if(lost && lose.isPlaying() == false && counter == 0){
      lose.play();
      lost = false;
      counter ++;
    }
  } 
}


//MOUSECLICKED
//////////////////////////////////////////////////////////////////////////
void mouseClicked() {
  if (page == 0) {
    if (mouseX > width/2-150 && mouseX <  width/2+150) {
      if (mouseY > height-150 && mouseY < height) {
        page = 1;
      }
    }
  }
  
  else if (page == 1) {
    if (mouseX > width/2-150 && mouseX <  width/2+150) {
      if (mouseY > height-150 && mouseY < height) {
        page = 2;
        startTime = millis();
        startRecorded = true;
      }
    }
  }
  else if (page == 3) {
    if (mouseX > width*0.75 && mouseX <  width*0.75 + 300) {
      if (mouseY > height-150 && mouseY < height) {
        reset();
      }
    }
  }
}
//KEYPRESSED
//////////////////////////////////////////////////////////////////////////
void keyPressed(){
 if (key == 's' || key == 's'){
   if(isHand){  
      player.ctScissor();
      isHand = false;
  }
  else{
    player.ctHand();
     isHand = true;
  }
 }
}
//DRAWS THE OBJECTS
//////////////////////////////////////////////////////////////////////////
void drawScissor() {
  for (Scissor s : scis) {
    s.move();
    s.display();
  }
}

void drawHomework() {
  for (Homework w : works) {
    w.move();
    w.display();
  }
}

void drawStressLevel() {
  for (Stress st : stress) {
    st.display();
  }
}

//UPDATE ARRAYLISTS AND STRESSLEVEL 
//////////////////////////////////////////////////////////////////////////
void checkHomework(){
   for (int i=0; i < works.size(); i++){
     if(works.get(i).getY() >= 450){
       works.remove(i);
       stressLevel += 3;
       stress.add(new Stress(int(width*0.03), int(height*stressVar)));
       stressVar -= 0.03;
    }
  }
}

void checkScissor(){  
  for (int i=0; i < scis.size(); i++){
     if(scis.get(i).getY() >= 450){
       scis.remove(i);
    }
  }
}


//PAGE LOADING
//////////////////////////////////////////////////////////////////////////
void firstPage() {
  image(title, 120, -70, 900, 600);
  image(descript, width/2-200, height/2+135, 400, 75);
  image(start, width/2-150, height-150, 300, 150);
  
}

void instructPage(){
 image(instruct, 0,0);
 image(gotit, width/2-150, height-150, 300, 150);
}


//CHECK FOR COLLISION OF PLAYER WITH OBJECTS
//////////////////////////////////////////////////////////////////////////
void checkCollisionHand() {
  for (int j = 0; j < scis.size(); j++) {
    float d = dist(player.getX(), player.getY(), scis.get(j).getX(), scis.get(j).getY());
    if (d < 100){
      scissNum +=1;
      scis.remove(j);
    }
  }
}

void checkCollisionScis() {  
  if(scissNum > 0){
    for (int i = 0; i < works.size(); i++) {
      float d = dist(player.getX(), player.getY(), works.get(i).getX(), works.get(i).getY());
      if (d < 100){
         scissNum -=1;
         works.remove(i);
         if(ding.isPlaying() == false){
           ding.play();
         }  
       }
     }
  }
}

//RESET GAME
//////////////////////////////////////////////////////////////////////////
void reset(){
  page = 0;
  startRecorded = false;
  rt1 = 1000;
  rt2 = 1500;
  stressLevel = 0;
  stressVar = 0.8;
  scissNum = 0;
  counter = 0;
  for(int a = 0; a < works.size(); a++){
    works.remove(a);
  }
  for(int b = 0; b < scis.size(); b++){
    scis.remove(b);
  }
  for(int c = 0; c < stress.size(); c++){
    stress.remove(c);
  }
}
//PRINTS TIME LEFT ON SCREEN
//////////////////////////////////////////////////////////////////////////
void timeLeft(){
  timeLeft = int(startTime) - millis() + totalTime + 1000; 
  String l = "Time left (sec): " + timeLeft/1000;
  textSize(20);
  text(l, 5, 20);
}

void getSerialData() {
  while (serialPort.available() > 0) {
    String in = serialPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
    if (in != null) {
      print("From Arduino: " + in);
      String[] serialInArray = split(trim(in), ",");
      if (serialInArray.length == NUM_OF_VALUES_FROM_ARDUINO) {
        for (int i=0; i<serialInArray.length; i++) {
          arduino_values[i] = int(serialInArray[i]);
        }
      }
    }
  }
}
