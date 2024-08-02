
import processing.serial.*;
import controlP5.*;

int buttonWidth;
int buttonHeight;
int sliderWidth;
int sliderHeight;
int currentSliderPos = 0;

boolean on = false;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean showMessage = false;

String[] sliderLabels = {"Normal", "2X", "4X", "8X"};
char[] ch={'w','x','y','z'};
PFont font;

int messageTimer = 0;
String message = "Please switch the On/Off button to On state to control telescope";

String testMessage = "H";



Serial port;

String portName;

ControlP5 cp5;








void settings() {
  size(displayWidth / 2, displayHeight / 2);
}

void setup() {
  surface.setResizable(true);
  buttonWidth = width / 8;
  buttonHeight = height / 8;
  sliderWidth = width - width/6;
  sliderHeight = height / 15;
  //port = new Serial(this, portno, 9600);
  String[] ports = Serial.list();
  println("Available ports:");
  println(ports);

  boolean connected = false;
  
  for (int i = 0; i < ports.length; i++) {
    try {
      // Open the serial port
      port = new Serial(this, ports[i], 9600);
      delay(1600); // Wait for the connection to establish

      // Send a test message to the Arduino
      port.write(testMessage + "\n");
      delay(500); // Wait for Arduino to process and respond
      // Check if data is available
      if (port.available() > 0) {
        println("Testing port: " + ports[i]);
        String input = port.readString().trim();

        // Check if the response matches the test message
        if (input != null && input.equals(testMessage)) {
          println("Connected to Arduino on port: " + ports[i]);
          portName = ports[i];
          connected = true;
          //port.stop(); // Close the port
          break; // Exit loop since Arduino is found
        } else {
          println("No valid response from port: " + ports[i]);
          print(input);
          if (port != null) {
        port.stop();}
        }
      } else {
        println("No data available on port: " + ports[i]);
        if (port != null) {
        port.stop();}
      }
    } catch (Exception e) {
      println("Failed to connect to " + ports[i] + " due to: " + e.getMessage());
      if (port != null) {
        port.stop();  
      }
  }
  }
  
  if (!connected) {
    println("Could not find Arduino.");
    return;
  }
  cp5 = new ControlP5(this);
  font = createFont("Arial", buttonHeight / 2);
  textFont(font);
}

void draw() {
  background(240);
  
  buttonWidth = width / 8;
  buttonHeight = height / 8;
  sliderWidth = width - width/6;
  sliderHeight = height / 15;
  
  // Draw On/Off button
  if (on) {
    fill(0, 200, 100); // Green when on
  } else {
    fill(200, 0, 0); // Red when off
  }
  rect(width / 2 - buttonWidth / 2, height / 20, buttonWidth, buttonHeight, 15);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(buttonHeight / 2.5);
  text("Power", width / 2, height / 20 + buttonHeight / 2); // On/Off symbol
  if (on){
    // Draw slider track
    drawSliderTrack(width/30, height - height / 10 - sliderHeight, width-4*width/42, sliderHeight);
  
    // Draw slider thumb
    drawSliderThumb(width/30 + currentSliderPos * (sliderWidth / (sliderLabels.length - 1)), height - height / 10 - sliderHeight, sliderHeight);
  
    // Draw slider labels
    fill(0);
    textSize(sliderHeight/2);
    for (int i = 0; i < sliderLabels.length; i++) {
      text(sliderLabels[i], 2*width/29 + i * ((sliderWidth) / (sliderLabels.length - 1)), height - height / 10 - sliderHeight / 2);
    }
    // Draw direction buttons
    drawDirectionButton(width / 2 - buttonWidth / 2, height / 4, buttonWidth, buttonHeight, up, "↑");
    drawDirectionButton(width / 2 - buttonWidth / 2, 3 * height / 4 - buttonHeight, buttonWidth, buttonHeight, down, "↓");
    drawDirectionButton(width / 2 - buttonWidth - 20, 2 * height / 4 - buttonHeight / 2, buttonWidth, buttonHeight, left, "←");
    drawDirectionButton(width / 2 + 20, 2 * height / 4 - buttonHeight / 2, buttonWidth, buttonHeight, right, "→");
  
       
      
      
    //// Draw slider
    //fill(200);
    //rect(50, height - height / 10 - sliderHeight, sliderWidth, sliderHeight, 15);
    //fill(0);
    //for (int i = 0; i < sliderLabels.length; i++) {
    //  text(sliderLabels[i], 50 + i * (sliderWidth / sliderLabels.length) + (sliderWidth / (2 * sliderLabels.length)), height - height / 10 - sliderHeight / 2);
    //}
    //fill(255, 0, 0);
    //ellipse(50 + currentSliderPos * (sliderWidth / (sliderLabels.length - 1)), height - height / 10 - sliderHeight / 2, sliderHeight, sliderHeight);
  }
  // Show message if necessary
  if (showMessage) {
    fill(0);
    textSize(height/19);
    text(message, width / 2, height - height / 20);
    if (millis() - messageTimer > 1000) {
      showMessage = false;
    }
  }
}

void drawDirectionButton(int x, int y, int w, int h, boolean active, String label) {
  if (active) fill(100, 150, 250); else fill(255);
  rect(x, y, w, h, 15);
  fill(0);
  textSize(height / 20);
  text(label, x + w / 2, y + h / 2);
}
void drawSliderTrack(int x, int y, int w, int h) {
  
  fill(200);
  rect(x, y, w, h, 10);
  //noStroke();
  // Draw gradient track
  //for (int i = 0; i < h; i++) {
  //  float inter = map(i, 0, h, 0, 1);
  //  int c = lerpColor(color(200, 200, 200), color(100, 100, 100), inter);
  //  stroke(c);
    //line(x, y + i, x + w, y + i);
  //}
  
}

void drawSliderThumb(float k, float m, float size) {
  fill(0, 150, 255);
  stroke(0);
  strokeWeight(2);
  //rectMode(CENTER);
  rect(k, m, 2*size, size, 10);
}
void mousePressed() {
  if (mouseX > width / 2 - buttonWidth / 2 && mouseX < width / 2 + buttonWidth / 2 && mouseY > height / 20 && mouseY < height / 20 + buttonHeight) {
    on = !on;
    if(on){
      port.write('o');
    }
    else{
      port.write('f');
    }
  } else if (on) {
    if (mouseX > width / 2 - buttonWidth / 2 && mouseX < width / 2 + buttonWidth / 2 && mouseY > height / 4 && mouseY < height / 4 + buttonHeight) {
      up = true;
      port.write('u');
    } else if (mouseX > width / 2 - buttonWidth / 2 && mouseX < width / 2 + buttonWidth / 2 && mouseY > 3 * height / 4 - buttonHeight && mouseY < 3 * height / 4) {
      down = true;
      port.write('d');
    } else if (mouseX > width / 2 - buttonWidth - 20 && mouseX < width / 2 - 20 && mouseY > 2 * height / 4 - buttonHeight / 2 && mouseY < 2 * height / 4 + buttonHeight / 2) {
      left = true;
      port.write('l');
    } else if (mouseX > width / 2 + 20 && mouseX < width / 2 + buttonWidth + 20 && mouseY > 2 * height / 4 - buttonHeight / 2 && mouseY < 2 * height / 4 + buttonHeight / 2) {
      right = true;
      port.write('r');
    } else if (mouseY > height - height / 10 - sliderHeight && mouseY < height - height / 10 && mouseX > width/32 && mouseX < width-width/32) {
      currentSliderPos = (int) map(mouseX, 50, 50 + sliderWidth, 0, sliderLabels.length - 1);
      port.write(ch[currentSliderPos]);
    }
  } else {
    showMessage = true;
    messageTimer = millis();
  }
}

void mouseReleased() {
  up = false;
  down = false;
  left = false;
  right = false;
  port.write('s');
}

void keyPressed() {
  if (on && key == CODED) {
    if (keyCode == UP) {
      up = true;
      port.write('u');
    } else if (keyCode == DOWN) {
      down = true;
      port.write('d');
    } else if (keyCode == LEFT) {
      left = true;
      port.write('l');
    } else if (keyCode == RIGHT) {
      right = true;
      port.write('r');
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      up = false;
    } else if (keyCode == DOWN) {
      down = false;
    } else if (keyCode == LEFT) {
      left = false;
    } else if (keyCode == RIGHT) {
      right = false;
    }
  port.write('s');

  }
}
void writeport(String pr){
  port.write(pr);
}
