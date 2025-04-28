// Arduino Lidar
// Alex Johnson 


// defines
#include <SoftwareSerial.h>  // for communication with lidar
#include <AccelStepper.h>

const int lidarRX = 2; 
const int lidarTX = 3;

SoftwareSerial Lidar(lidarRX, lidarTX);


const int dirPin = 4;
const int stepPin = 5;
const int pwrPin = 6; 

// Define motor interface type
#define motorInterfaceType 1

AccelStepper myStepper(motorInterfaceType, stepPin, dirPin);



// variables for getData(), not sure if they need to be global or not
int dist;                     //actual distance measurements of LiDAR
int strength;                 //signal strength of LiDAR
int check;                    //save check value
int i;
int uart[9];                   //save data measured by LiDAR
const int HEADER = 0x59;      //frame header of data package

// function getData() 
// reads from lidar and prints out distance and strength 
int getData(){
  if (Lidar.available())                //check if serial port has data input
  {
    if (Lidar.read() == HEADER)        //assess data package frame header 0x59
    {
      uart[0] = HEADER;
      if (Lidar.read() == HEADER)      //assess data package frame header 0x59
      {
        uart[1] = HEADER;
        for (i = 2; i < 9; i++)         //save data in array
        {
          uart[i] = Lidar.read();
        }
        check = uart[0] + uart[1] + uart[2] + uart[3] + uart[4] + uart[5] + uart[6] + uart[7];
        if (uart[8] == (check & 0xff))        //verify the received data as per protocol
        {
          dist = uart[2] + uart[3] * 256;     //calculate distance value
          strength = uart[4] + uart[5] * 256; //calculate signal strength value
          if (strength > 100){
            return dist;
          }
          else{
            return -1;
          }
        }
      }
    }
  }
  else{
    return -1;
  }
}


int degreeToStep(int degrees){
  return (degrees * 200) / 360;
}

void setup() {
  pinMode(pwrPin, OUTPUT);
  digitalWrite(pwrPin, HIGH);

  Serial.begin(9600);         //set bit rate of serial port connecting Arduino with computer
  Lidar.begin(115200);      //set bit rate of serial port connecting LiDAR with Arduino


	myStepper.setMaxSpeed(1000);
	myStepper.setAcceleration(50);
	myStepper.setSpeed(200);

  delay(5000);

  for(int x = 0; x <= 100; x++) 
  {
     myStepper.moveTo(x);
     Serial.print(myStepper.currentPosition());
     myStepper.run();
     delay(50);
     Serial.print(",");
     Serial.print(getData());
     Serial.println();
     delay(50);
  }
}

void loop()
{
  
}
/*
void loop() {
  for(int x = 0; x <= 100; x++) 
  {
     myStepper.moveTo(x);
     Serial.print(myStepper.currentPosition());
     myStepper.run();
     delay(50);
     Serial.print(",");
     Serial.print(getData());
     Serial.println();
     delay(50);
  }
  myStepper.moveTo(200);
  myStepper.run();
  delay(5000);
}
*/