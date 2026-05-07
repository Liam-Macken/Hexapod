#ifndef SERVODRIVER_HPP
#define SERVODRIVER_HPP

#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>
#include <Arduino.h>

Adafruit_PWMServoDriver left = Adafruit_PWMServoDriver(0x40);
Adafruit_PWMServoDriver right = Adafruit_PWMServoDriver(0x41);  

#define NUMSERVOS 9
#define SERVOMIN  500                                                 // this is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX  2500    
#define SERVOFREQ 50 

class ServoDriver {
  private: 
    int _ankleDegrees = 270;
    int _kneeDegrees = 270;
    int _hipDegrees = 180;

    int _ankleOffset = 90;
    int _kneeOffset = 50;
    int _hipOffset = -2;

    int _ankleLimitLow = 10;
    int _ankleLimitHigh = _ankleOffset + (_ankleDegrees/2);
    int _kneeLimitLow = -90;
    int _kneeLimitHigh = 150;
    int _hipLimitLow = -60;
    int _hipLimitHigh = 60;

  public: 
    ServoDriver(){

    }

    void Setup(){
      left.begin();
      // right.begin();

      left.setOscillatorFrequency(26000000);

      left.setPWMFreq(SERVOFREQ);
      // right.setPWMFreq(SERVOFREQ);

      yield();
    }



    void SetAngle(uint8_t leg, uint8_t joint, int angle){
      uint8_t servoNum = leg * 3 + joint;
      bool leftOrRight = false; // False = Left, True = Right
      int microSeconds = 0;

      if (leg > 2){
        servoNum = (leg - 3) * 3 + joint;
        leftOrRight = true;
      } 

      if(joint == 0 && angle >= _hipLimitLow && angle <= _hipLimitHigh){
        microSeconds = map(angle,_hipOffset - (_hipDegrees/2),_hipOffset + (_hipDegrees/2),SERVOMIN,SERVOMAX);
      } else if(joint == 1 && angle >= _kneeLimitLow && angle <= _kneeLimitHigh){
        microSeconds = map(angle,_kneeOffset - (_kneeDegrees/2),_kneeOffset + (_kneeDegrees/2),SERVOMIN,SERVOMAX);
      } else if(joint == 2 && angle >= _ankleLimitLow && angle <= _ankleLimitHigh) {
        microSeconds = map(angle,_ankleOffset - (_ankleDegrees/2),_ankleOffset + (_ankleDegrees/2),SERVOMAX,SERVOMIN);
      } else {
        return;
      }

      if (leftOrRight == false){
        left.writeMicroseconds(servoNum, microSeconds);
      } else {
        right.writeMicroseconds(servoNum, microSeconds);
      }
      
    }
};

#endif