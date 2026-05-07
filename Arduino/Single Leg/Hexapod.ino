#include "ServoDriver.hpp"
#include "Leg.hpp"

ServoDriver driver;   // Create servo object
Leg leg0(&driver,0);

// 🔹 Global variables
int i = 0;
int T = 5;
int freq = 10; 
int loops = 0;
int total_loops = 5;
bool running = true;

void setup() {
  Serial.begin(9600);

  driver.Setup();

  driver.SetAngle(0, 0, 0);
  driver.SetAngle(0, 1, 45);
  driver.SetAngle(0, 2, 90);
}


void loop() {
  while (running) {
    leg0.gait(i, T, 0.5, 180, 150, -70);

    delay(100/freq);
    i++;

    if (i >= T*freq) {
      i = 0;
      loops++;
    }

    if (loops >= total_loops) {
      running = false;
    }
  }
}

