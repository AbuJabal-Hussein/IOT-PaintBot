
#include <SoftwareSerial.h>
#include "Robot.h"

Robot paintingRobot(5000, 5000);


void setup(){
  Serial.begin(115200);

}

void loop() {
  // put your main code here, to run repeatedly
  delay(5000);
  while(Serial.parseInt()!= -1){
    delay(200);
    Serial.println("begin path..");
    Serial.println("enter the number of points: ");
    delay(2000);
    
    int points_num = Serial.parseInt();
    delay(200);
    Serial.print("points_num = ");
    Serial.println(points_num);
    Serial.println("enter the points: ");
    delay(3000);
    String pathstr = Serial.readString();
    delay(2000);
    Serial.println("points = " + pathstr);
    if(points_num < 2){
      Serial.write(0);
      continue;
    }
    //lower the pen down
    paintingRobot.moveBrush(true);
    delay(2000);
    
    char *dup = strdup(pathstr.c_str());
    int x = atoi(strtok(dup, " "));
    int y = atoi(strtok(NULL, " "));
    Serial.print("x = ");
    Serial.print(x);
    Serial.print(" y = ");
    Serial.println(y);
    Serial.println("entering loop:");
    paintingRobot.gotoXY((double)x , (double)y);
    for(int i=2; i < points_num - 1; i+=2){
      x = atoi(strtok(NULL, " "));
      y = atoi(strtok(NULL, " "));
      paintingRobot.gotoXY((double)x , (double)y);
      Serial.print("x = ");
      Serial.print(x);
      Serial.print(" y = ");
      Serial.println(y);
      delay(100);
    }
    
    //lift up the pen
    paintingRobot.moveBrush(false);
    Serial.write(1);
    Serial.println("finished path..");
    delay(5000);
  }
  Serial.println("Done Painting.");
  
  delay(5000);
  
}
