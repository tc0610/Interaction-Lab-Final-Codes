#include <SharpIR.h>

//model and input pin

int clapPin = 2;
int clap;
int start;
long delayTime = 500;

#define IRPin A0 //SHARP IR x
#define IRPin2 A1 //SHARP IR y
#define model 1080

int dist_cm;
int dist_cm2;
SharpIR mySensor = SharpIR(IRPin, model);
SharpIR mySensor2 = SharpIR(IRPin2, model);


void setup() {
 Serial.begin(9600);
 pinMode(clapPin, INPUT);

}

void loop() {
  long start = millis();
  while(millis() - start < delayTime){
    clap = digitalRead(clapPin);
    dist_cm = mySensor.distance();
    dist_cm2 = mySensor2.distance();
    Serial.print(clap);
    Serial.print(",");
    Serial.print(dist_cm);
    Serial.print(",");
    Serial.print(dist_cm2);
    Serial.println(); 
    
  }

}
