#ifndef LEG_HPP
#define LEG_HPP

#include "ServoDriver.hpp"
#include <Arduino.h>
#include <math.h>

#define FREQ 10
#define STEPLENGTH 200
#define STEPHEIGHT 70

class Leg {
  private: 
    
    uint8_t _legNum;
    ServoDriver* _driver;

    uint8_t coxaLength = 50;
    uint8_t femurLength = 110;
    uint8_t tibiaX = 160;
    uint8_t tibiaY = 40;

  public: 
    Leg(ServoDriver* driver, uint8_t legNum){
      _legNum = legNum;
      _driver = driver;
    }

    void IK(float x, float y, float z){
      // Constants
      const float C  = 50.0;
      const float F  = 110.0;
      const float Tx = 160.0;
      const float Ty = 40.0;

      // Derived values
      float T   = sqrt(Tx * Tx + Ty * Ty);
      float phi = atan2(Ty, Tx) * 180.0 / PI;   // atand(Ty/Tx)

      float theta, alpha, beta;

      // theta
      if (x == 0) {
        theta = 0;
      } else {
        theta = atan2(y, x) * 180.0 / PI;       // atand(x/y)
      }

      // i
      float thetaRad = theta * PI / 180.0;

      float i;
      if (y != 0 && sin(thetaRad) != 0) {
        i = (y / sin(thetaRad)) - C;
      } 
      else if (x != 0 && cos(thetaRad) != 0) {
        i = (x / cos(thetaRad)) - C;
      } 
      else {
        i = x - C;
      }

      // psi, R
      float psi = atan2(-z, i) * 180.0 / PI;    // atand(-z/i)
      float R   = sqrt(i * i + z * z);

      // beta
      beta = acos(
              (F * F + T * T - R * R) / (2.0 * F * T)
            ) * 180.0 / PI + phi;

      // alpha
      alpha = acos(
                (F * F + R * R - T * T) / (2.0 * F * R)
              ) * 180.0 / PI - psi;

      Serial.print(x);
      Serial.print(" ");
      Serial.print(y);
      Serial.print(" ");
      Serial.print(z);
      Serial.print(" ");
      Serial.print(theta);
      Serial.print(" ");
      Serial.print(alpha);
      Serial.print(" ");
      Serial.println(beta);

      if (!isnan(theta) && !isnan(alpha) && !isnan(beta)){    
        _driver->SetAngle(0,0,theta);
        _driver->SetAngle(0,1,alpha);
        _driver->SetAngle(0,2,beta);
      }

    }

    void gait(int t, float T, float groundPercent, float angle, float xOffset, float zOffset) {
      float num_points = T * FREQ;
      float s;
      float pathPosition;
      float x,y,z;

          Serial.print(t);
          Serial.print(" ");
          Serial.print(num_points);
          Serial.print(" ");

      if (t < groundPercent * num_points) {
        // Ground phase
        s = t / (groundPercent * num_points);
        pathPosition = -STEPLENGTH / 2.0 + STEPLENGTH * (10 * pow(s, 3) - 15 * pow(s, 4) + 6 * pow(s, 5));

        x = xOffset - pathPosition * sin(angle* PI / 180.0);
        y = pathPosition * cos(angle* PI / 180.0);
        z = zOffset;

      } else if (t < num_points) {
        // Swing phase
        s = (t - groundPercent * num_points) / ((1.0 - groundPercent) * num_points);
        pathPosition = STEPLENGTH / 2.0 - STEPLENGTH * (10 * pow(s, 3) - 15 * pow(s, 4) + 6 * pow(s, 5));

        x = xOffset - pathPosition * sin(angle * PI / 180.0);
        y = pathPosition * cos(angle * PI / 180.0);
        z = zOffset + STEPHEIGHT * cos(PI * pathPosition / STEPLENGTH);

      } else {
        // Invalid t
        x = NAN;
        y = NAN;
        z = NAN;
      }

      this->IK(x,y,z);
  }

};

#endif