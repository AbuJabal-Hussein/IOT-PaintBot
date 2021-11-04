#if ARDUINO >= 100
  #include <Arduino.h>
#else
  #include <WProgram.h>
#endif

#include "Robot.h"


Robot::Robot(float boardWidth, float boardHeight) : currX(0), currY(0), currAngle(0),
				 boardWidth(boardWidth), boardHeight(boardHeight){

	pinMode(LEFTSTEP_STEP, OUTPUT);
	pinMode(LEFTSTEP_DIR, OUTPUT);
	pinMode(RIGHTSTEP_STEP, OUTPUT);
	pinMode(RIGHTSTEP_DIR, OUTPUT);

	paintServo.attach(SERVO_PIN);
  paintServo.write(150);

}


void step(bool dir, int dirPin, int stepPin){
  digitalWrite(dirPin, dir);
  
  digitalWrite(stepPin, HIGH);
  delayMicroseconds(500);
  digitalWrite(stepPin, LOW);
  delayMicroseconds(500);
}


void moveForward(float dist){ 
  int steps = 200*16*dist/23/60; 

  for(int i = 0; i < steps; i++){
    step(StepperDir::forward, LEFTSTEP_DIR, LEFTSTEP_STEP);
    step(StepperDir::forward, RIGHTSTEP_DIR, RIGHTSTEP_STEP);
  }
}


void rotate(float angle){
  int abs_angle = angle >= 0 ? angle : -angle;
  int steps = 200*16*abs_angle/110.0;

  if (angle > 0){
    for (int i = 0; i < steps; i++){

       step(StepperDir::backward, LEFTSTEP_DIR, LEFTSTEP_STEP);
       step(StepperDir::forward, RIGHTSTEP_DIR, RIGHTSTEP_STEP);
    }
  }
  else{
    for (int i = 0; i < steps; i++){

       step(StepperDir::forward, LEFTSTEP_DIR, LEFTSTEP_STEP);
       step(StepperDir::backward, RIGHTSTEP_DIR, RIGHTSTEP_STEP);
    }
  }

}


void Robot::gotoXY(float x, float y){
  if (!((x > boardWidth) || (y > boardHeight))){
    float dx = x - currX;
    float dy = y - currY;
    float angle = degrees(atan2(dy, dx));
    float dist = sqrt(dx*dx + dy*dy);

    rotate(angle - currAngle);
    delay(500);
    moveForward(dist);

    currX = x;
    currY = y;
    currAngle = angle;
  }
}

void Robot::moveBrush(bool dir){

  if(dir){ //up
    paintServo.write(150);
  }
  else{ //down
    paintServo.write(20);
  }
}