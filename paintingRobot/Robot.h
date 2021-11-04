#ifndef Robot_h
#define Robot_h

#include <Servo.h>

#define LEFTSTEP_STEP 2
#define LEFTSTEP_DIR 5
#define RIGHTSTEP_STEP 3
#define RIGHTSTEP_DIR 6
#define SERVO_PIN 11

enum BrushDir {up = true, down = false};
enum StepperDir {forward = true, backward = false};
void step(bool dir, int dirPin, int stepPin);

class Robot{
	float currX;
	float currY;
	float currAngle;

	float boardWidth;
	float boardHeight;

	Servo paintServo;

public:
	Robot(float boardWidth, float boardHeight);
	void gotoXY(float x, float y);
	void moveBrush(bool dir);

};

#endif //Robot_h
