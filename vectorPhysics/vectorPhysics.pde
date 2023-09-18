float objX = 100;                                                                                             // X coordinate of the object
float objY = 100;                                                                                             // Y coordinate of the object
float g = 9.81 / 10;                                                                                          // Gravitational ocnstant in m/s²
float m = 100;                                                                                                // Mass of the object in kg
float aX = 0;                                                                                                 // Acceleration of the object on the X axis in m/s²
float aY = 0;                                                                                                 // Acceleration of the object on the Y axis in m/s²
float pt = millis();                                                                                          // Previous time in ms
float t = pt;                                                                                                 // Time in ms
float vX = 0;                                                                                                 // Speed of the object on the X axis in m/s
float vY = 0;                                                                                                 // Speed of the object on the Y axis in m/s
float FG = m * g;                                                                                             // Size of the weight force in N
float FM = 0;                                                                                                 // Size of the force by the cursor in N
float alpha = 0;                                                                                              // Direction of the force by the cursor in °
float FRes = 0;                                                                                               // Resulting force of the force parallelogram in N
float beta = 0;                                                                                               // Direction of the resulting force in °
float deltaX = mouseX - objX;                                                                                 // X distance from the cursor to the object
float deltaY = mouseY - objY;                                                                                 // Y distance from the cursor to the object
float deltaYGes = mouseY - objY + FG;                                                                         // Y distance from the end of FRes to the object
boolean showLines = false;

void setup() {
  background(255);
  fullScreen();
  strokeWeight(1);
  color(0);
  rectMode(CENTER);
  fill(0);
}

void draw() {
  background(255);  
  pt = millis();
  init();                                                                                                     // Without this function the object somehow flies out of the window
  refreshDeltas();                                                                                            // Functiun refreshes the variables
  forces();                                                                                                   // Functiun refreshes the forces
  acceleration();                                                                                             // Function calculates the acceleration of the object
  calculateAngles();
  moveObj();                                                                                                  // Function calculates the movement of the object
  drawObjects();
  t = millis() - pt;
}

void drawObjects() {
  drawObj(objX, objY);                                                                                        // The object
  
  if (showLines) {
    stroke(255, 0, 0);
    drawArrow(int(objX), int(objY), mouseX, mouseY + int(FG));                                                // Arrow of the resulting force in red
    stroke(0, 255, 0);
    drawArrow(int(objX), int(objY), int(objX), int(objY) + int(FG));                                          // Arrow of the weight force in green
    stroke(0, 0, 255);
    drawArrow(int(objX), int(objY), mouseX, mouseY);                                                          // Arrow of the force by the cursor in blue
    stroke(0);
  }
}

void refreshDeltas() {
  deltaX = mouseX - objX;
  deltaY = mouseY - objY;
  deltaYGes = mouseY - objY + FG;
}

void drawObj(float objX, float objY) {
  square(objX, objY, 10);
}

void drawArrow(int sPointX, int sPointY, int ePointX, int ePointY) {
  line(sPointX, sPointY, ePointX, ePointY);
}

void acceleration() {
  aX = deltaX;
  aY = deltaYGes;
  vX = vX + aX * (t / 100);
  vY = vY + aY * (t / 100);
  line(objX, objY, objX + vX, objY + vY);
}

void forces() {
  FM = sqrt((objX - mouseX) * (objX - mouseX)) + sqrt((objY - mouseY) * (objY - mouseY));                     // Size of the force by the cursor, FM = sqrt((delta X)²) + sqrt((delta Y)²); c² = a² + b²
  FRes = sqrt((objX - mouseX) * (objX - mouseX)) + sqrt((objY - mouseY - FG) * (objY - mouseY - FG));         // Size of the resulting force when adding FG and FM, FRes = sqrt((delta X)²) + sqrt((delta Y - FG)²); c² = a² + b²
}

void calculateAngles() {
  if (deltaX != 0) {
    alpha = degrees(atan((deltaY) / (deltaX)));                                                               // Calculation of alpha
    if (deltaX > 0) {                                                                                         // Calculation from -90 to 90 into 0 to 360
      alpha += 90;
    } else if (deltaX < 0) {
      alpha += 270;
    }
  } else if (deltaX == 0 && deltaY > 0) {                                                                     // Edgecases at delta X = 0, because you're not allowed to divide by 0
    alpha = 180;
  } else {
    alpha = 0;
  }
  
  if (deltaX != 0) {
    beta = degrees(atan((deltaYGes) / (deltaX)));                                                             // Calculation of beta
    if (deltaX > 0) {                                                                                         // Calculation from -90 to 90 into 0 to 360
      beta += 90;
    } else if (deltaX < 0) {
      beta += 270;
    }
  } else if (deltaX == 0 && deltaYGes > 0) {                                                                  // Edgecases at delta X = 0, because you're not allowed to divide by 0
    beta = 180;
  } else {
    beta = 0;
  }
}

void moveObj() {
  objX = objX + vX * (t / 10);                                                                                // Moves the object 
  objY = objY + vY * (t / 10);
}

void init() {
  if (millis() >= 0 && millis() <= 1000) {
    objX = width / 2;
    objY = height / 2;
    aX = 0;
    aY = 0;
    vX = 0;
    vY = 0;
    FRes= 0;
    FM = 0;
  }
}

void mouseClicked() {
  if (showLines) {
    showLines = false;
  } else {
    showLines = true;
  }
}
