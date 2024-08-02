int onoffpin=3;
int x2pin=4;
int x4pin=5;
int x8pin=6;
int uppin=8;
int downpin=9;
int leftpin=10;
int rightpin=11;
int connection=1;
int ledPin=13;
void setup() {

  pinMode(onoffpin, OUTPUT);   //set pin as output , blue led
  pinMode(x2pin, OUTPUT);   //set pin as output , red led
  pinMode(x4pin, OUTPUT);   //set pin as output , yellow led
  pinMode(x8pin, OUTPUT);   //set pin as output , yellow led
  pinMode(uppin, OUTPUT);   //set pin as output , yellow led
  pinMode(downpin, OUTPUT);   //set pin as output , yellow led
  pinMode(leftpin, OUTPUT);   //set pin as output , yellow led
  pinMode(rightpin, OUTPUT);   //set pin as output , yellow led
  pinMode(ledPin,OUTPUT);
  Serial.begin(9600);    //start serial communication @9600 bps
  }

void loop(){  
  if(Serial.available()){  //id data is available to read
  if (connection==0){
    String command = Serial.readStringUntil('\n');
    Serial.println(command);
    blinkLed(100, 100);
    if (command=='h'){
      connection==1;
    }
  }
  else{
    char val = Serial.read();
    Serial.print(val);
    if(val == 'o'){       //if r received
      digitalWrite(onoffpin, HIGH); //turn on red led
      }
    else if(val== 'f'){
      digitalWrite(onoffpin, LOW);
    }
    else if(val=='u'){
      digitalWrite(uppin,HIGH);
    }
    else if(val=='d'){
      digitalWrite(downpin,HIGH);
    }
    else if(val=='l'){
      digitalWrite(leftpin,HIGH);
    }
    else if(val=='r'){
      digitalWrite(rightpin,HIGH);
    }
    else if(val=='s'){
      digitalWrite(uppin, LOW);
      digitalWrite(downpin, LOW);
      digitalWrite(leftpin, LOW);
      digitalWrite(rightpin, LOW);
    }
    else if(val=='x'){
      digitalWrite(x2pin,HIGH);
      digitalWrite(x4pin,LOW);
      digitalWrite(x8pin,LOW);

    }
    else if(val=='y'){
      digitalWrite(x4pin,HIGH);
      digitalWrite(x2pin,LOW);
      digitalWrite(x8pin,LOW);

    }else if(val=='z'){
      digitalWrite(x8pin,HIGH);
      digitalWrite(x4pin,LOW);
      digitalWrite(x2pin,LOW);
    }
    }
    }
  }
void blinkLed(int onTime, int offTime) {
  digitalWrite(ledPin, HIGH); // Turn LED on
  delay(onTime); // Wait for onTime
  digitalWrite(ledPin, LOW); // Turn LED off
  delay(offTime); // Wait for offTime
}