/*
 * arduinobutton
 *
 * Strongly inspired from: http://www.arduino.cc/en/Tutorial/Button
 * By strongly, I mean: very.
 */

// The number of the pushbutton pin
const int buttonPin = 2;

// Variable for reading the pushbutton status
int buttonState = 0;

void setup() {
  // Initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  Serial.begin(9600);
}

void loop(){

  // Read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  /*
   * Check if the pushbutton is pressed.
   * If it is, the buttonState is HIGH:
   */
  if (buttonState == HIGH) {
    Serial.print(1);
  }
}
