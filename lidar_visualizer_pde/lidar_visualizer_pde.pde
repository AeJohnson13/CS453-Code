import processing.serial.*; 

Serial mySerial;
int lf = 10;
boolean newVal = false;
String line;

void setup() {
  printArray(Serial.list());
  mySerial = new Serial( this, Serial.list()[1], 9600 );
  mySerial.bufferUntil(lf);
  size(1000,1000);
}
void draw() {
  if (newVal) {
    //print(line);  // cr lf still in string
    String[] number = split(line, ',');
    int stepNumber = int(number[0]);
    String distanceString = number[1].trim();
    int distance = int(distanceString);
    int angleDegrees = (stepNumber * 360) / 200;
    float angle = angleDegrees * 3.14 /180;
    float x = distance * cos(angle);
    float y = distance * sin(angle);
    
    print("x: ");
    print(-x);
    print(" y: ");
    println(y);
    
    
    circle(x+500, y+500, 20);
    
    newVal = false;
  }
}
void serialEvent(Serial p) {
  line = p.readString();
  if ( line != null ) {
    if (line.length() > 2) {
      newVal=true;
    }
  }
}
