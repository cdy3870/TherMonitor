#include <Firebase_Arduino_WiFiNINA.h>
#include <Firebase_Arduino_WiFiNINA_HTTPClient.h>
#include <WiFiNINA.h>
#include <Wire.h>
#include <SparkFunTMP102.h>

/* Board
   Install megaAVR boards and select Arduino UNO Rev2
*/

/* Libs
    WiFiNINA
    SparkFunTMP102
    FirebaseArduino (that supports WiFiNINA)
*/

#define WIFI_SSID "372 South Bouquet C"
#define WIFI_PASSWORD "Janvar1226"
#define FIREBASE_HOST "thermonitor-f2d55.firebaseio.com"
#define FIREBASE_AUTH "4ipmlNTVDKQW2rWdVPDPe1NS9aCPuq8x1GpVau7E"

#define STATE_INIT 0
#define STATE_EXIT_1 1
#define STATE_EXIT_2 2
#define STATE_EXIT_3 3
#define STATE_ENTRY_1 4
#define STATE_ENTRY_2 5
#define STATE_ENTRY_3 6

FirebaseData firebaseData;

/* Analog Pins */
int analogPin1 = A1;
int analogPin2 = A3;

/* Analog readings */
int sensorVal1 = 0;
int sensorVal2 = 0;

/* Distances */
float distance1 = 0;
float distance2 = 0;

/* Times */
unsigned long time1 = 0;
unsigned long time2 = 0;

/* Other constants */
float voltage = 5.0;
int max_analog_value = 1023;

bool if_triggered_1 = false;
bool if_triggered_2 = false;

int count = 1;

// int[] states = {0, 1, 2, 3};
int current_state = STATE_INIT;
void setup() {
  /* Serial Connection */
  Serial.begin(9600);

  /* Wi-Fi Setup */
  Serial.println(WiFi.begin(WIFI_SSID, WIFI_PASSWORD));
  while (WiFi.status() != 3) {
    Serial.print("Not connected to Wi-Fi");
    Serial.print(WiFi.status());
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    delay(1000);

  }
  Serial.println();
  Serial.print("Connected: ");
  Serial.println(WiFi.localIP());

  /* Firebase Setup */
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASSWORD);
  Firebase.reconnectWiFi(true);
}

void loop() {
  time1 = 0;
  time2 = 0;
  /* Reading from sensors */
  sensorVal1 = analogRead(analogPin1);
  sensorVal2 = analogRead(analogPin2);

  /* Distance calculation */
  distance1 = getDistance(sensorVal1);
  distance2 = getDistance(sensorVal2);

  /* Setting trigger times */
 // setTriggerTime(1, distance1);
 // setTriggerTime(2, distance2);

  /* Setting trigger times */
  if_triggered_1 = setTriggerTime(1, distance1);
  if_triggered_2 = setTriggerTime(2, distance2);
  //if(!if_triggered_1)if_triggered_1 = setTriggerTime(1, distance1);
   if(!if_triggered_1){
     sensorVal1 = analogRead(analogPin1);
     distance1 = getDistance(sensorVal1);
     if_triggered_1 = setTriggerTime(1, distance1);
   }

  //if(current_state == STATE_ENTRY_3) checkSensor();

  switch(current_state){
    // 0,0
    case STATE_INIT:
      // if nothing is triggered, stay in state init
      if(if_triggered_1 == 0 && if_triggered_2 == 0)
      {
        current_state = STATE_INIT;
      }
     // if 2nd sensor is triggered, begin the exit sequence
      else if(if_triggered_1 == 0 && if_triggered_2 == 1)
      {
        current_state = STATE_EXIT_1;
      }
      // if 1st sensor is triggerec, begin the entry sequence
      else if(if_triggered_1 == 1 && if_triggered_2 == 0)
      {
        current_state = STATE_ENTRY_1;
      }
      // this shouldnt happen, but if it does we might need to make a new state
      else if(if_triggered_1 == 1 && if_triggered_2 == 1)
      {
        current_state = STATE_INIT;
      }
      break;
    // 0,1
    case STATE_EXIT_1:
      //Serial.println("EXIT SEQUENCE BEGINNING ... REAR SENSOR TRIGGERED");
      // goes back to init state, not a full sequence
      if(if_triggered_1 == 0 && if_triggered_2 == 0)
      {
        current_state = STATE_INIT;
      }
      // still in the beginning of the exit phase
      else if(if_triggered_1 == 0 && if_triggered_2 == 1)
      {
        current_state = STATE_EXIT_1;
      }
      // this would be if we skipped the double sensor phase and went straight until the end
      // this shouldnt happen, go back to normal
      else if(if_triggered_1 == 1 && if_triggered_2 == 0)
      {
        current_state = STATE_INIT;
      }
      // both sensors are triggered, middle of exit
      else if(if_triggered_1 == 1 && if_triggered_2 == 1)
      {
        current_state = STATE_EXIT_2;
      }
      break;
    // 1,1
    case STATE_EXIT_2:
      Serial.println("EXIT SEQUENCE MIDDLE ... BOTH SENSORS TRIGGERED");
      // maybe this should be an exit?  maybe go to state 3
      if(if_triggered_1 == 0 && if_triggered_2 == 0)
      {
        checkSensor(1);
        Serial.println("hit 00 after 11 exit");
        current_state = STATE_INIT;
      }
      else if(if_triggered_1 == 0 && if_triggered_2 == 1)
      {
        current_state = STATE_INIT;
      }
      else if(if_triggered_1 == 1 && if_triggered_2 == 0)
      {
        current_state = STATE_EXIT_3;
      }
      // stay in exit 2 while they are both triggered
      else if(if_triggered_1 == 1 && if_triggered_2 == 1)
      {
        current_state = STATE_EXIT_2;
      }
      break;
    // 1,0
    case STATE_EXIT_3:
      Serial.println("EXIT SEQUENCE ENDING ... FRONT SENSOR TRIGGERED");
      // there has been a complete exit, upload to the database
      if(if_triggered_1 == 0 && if_triggered_2 == 0)
      {
        checkSensor(1);
        Serial.println("EXIT SEQUENCE COMPLETE .... UPLOADING TO DATABASE");
        // upload exit to database
        current_state = STATE_INIT;
        break;
      }

      else if(if_triggered_1 == 0 && if_triggered_2 == 1)
      {
        current_state = STATE_INIT;
      }
      // stay on exit 3 if the exit has not completed yet
      else if(if_triggered_1 == 1 && if_triggered_2 == 0)
      {
        current_state = STATE_EXIT_3;
        break;
      }
      // this shouldnt happen hopefully
      else if(if_triggered_1 == 1 && if_triggered_2 == 1)
      {
        current_state = STATE_INIT;
      }
      Serial.println("EXIT SEQUENCE DID NOT COMPLETE");
      break;
    // 1,0
    case STATE_ENTRY_1:
      //Serial.println("ENTRY SEQUENCE BEGINNING ... FRONT SENSOR TRIGGERED");
      if(if_triggered_1 == 0 && if_triggered_2 == 0)
      {
        current_state = STATE_INIT;
      }
      else if(if_triggered_1 == 0 && if_triggered_2 == 1)
      {
        current_state = STATE_INIT;
      }
      else if(if_triggered_1 == 1 && if_triggered_2 == 0)
      {
        current_state = STATE_ENTRY_1;
      }
      else if(if_triggered_1 == 1 && if_triggered_2 == 1)
      {
        current_state = STATE_ENTRY_2;
      }
      break;
    // 1,1
    case STATE_ENTRY_2:
    Serial.println("ENTRY SEQUENCE MIDDLE ... BOTH SENSORS TRIGGERED");
      // same as for STATE_EXIT_2 maybe this should be considered an entry
      if(if_triggered_1 == 0 && if_triggered_2 == 0)
      {
        // might need to add database entry upload code here
        // current_state = STATE_ENTRY_3
        Serial.println("Went from entry 11 to 00");
        checkSensor(0);
        current_state = STATE_INIT;
      }
      else if(if_triggered_1 == 0 && if_triggered_2 == 1)
      {
        current_state = STATE_ENTRY_3;
      }
      else if(if_triggered_1 == 1 && if_triggered_2 == 0)
      {
        current_state = STATE_INIT;
      }
      else if(if_triggered_1 == 1 && if_triggered_2 == 1)
      {
        current_state = STATE_ENTRY_2;
      }
      break;
    // 0,1
    case STATE_ENTRY_3:
      Serial.println("ENTRY SEQUENCE END ... REAR SENSOR TRIGGERED");
      if(if_triggered_1 == 0 && if_triggered_2 == 0)
      {
        checkSensor(0);
        Serial.println("ENTRY SEQUENCE COMPLETE .... UPLOADING TO DATABASE");
        // send an entry to the database
        current_state = STATE_INIT;
        break;
      }
      else if(if_triggered_1 == 0 && if_triggered_2 == 1)
      {
        current_state = STATE_ENTRY_3;
      }
      else if(if_triggered_1 == 1 && if_triggered_2 == 0)
      {
        // this really shouldnt happen
        current_state = STATE_INIT;
      }
      // maybe this should go back to STATE_ENTRY_2
      else if(if_triggered_1 == 1 && if_triggered_2 == 1)
      {
        current_state = STATE_ENTRY_2;
      }
      Serial.println("ENTRY SEQUENCE DID NOT COMPLETE");
      break;
  }




//   if(if_triggered_1 && if_triggered_2) checkSensor();
//   else if(if_triggered_1 && !if_triggered_2){
//     time1 = 0;
//     time2 = 0;
//   }
//   else if(!if_triggered_1 && if_triggered_2){
//     time1 = 0;
//     time2 = 0;
//   }
   if_triggered_1 = false;
   if_triggered_2 = false;
  //delay(200);
// Serial.println();
}

int getDistance(int sensorVal){
  float volts = sensorVal * (voltage / max_analog_value);
  // From Sharp.h library
  float distance = 29.988 * pow(volts, -1.173);
//  Serial.print(distance);
//  Serial.println(" cm");
//  Serial.println();
  return distance;
}

bool setTriggerTime(int id, float distance){
  if(distance < 50 && distance > 0){
    if(id == 1){
      time1 = millis();
    //  Serial.println("reached 1 first");
//      Serial.print("First Sensor Time 1: ");
//      Serial.println(time1);
//      Serial.print("Time 2: ");
//      Serial.println(time2);
    }
    else{
      time2 = millis();
   //   Serial.println("reached 2 first");
//      Serial.print("Second Sensor Time 1: ");
//      Serial.println(time1);
//      Serial.print("Time 2: ");
//      Serial.println(time2);
    }
    return true;
  }
  return false;
}

int checkSensor(int sensor_id) {
//  float distance1 = 49;
//  float distance2 = 49;
//  if (time1 < time2){
////    Serial.println("Entry");
//    uploadToFirebase("Entry");
////    while(distance1 < 70 || distance2 < 70){
////      distance1 = getDistance(analogRead(analogPin1));
////      distance2 = getDistance(analogRead(analogPin2));
////    }
//  }
//  else{
////    Serial.println("Exit");
//    uploadToFirebase("Exit");
////      while(distance1 < 70 || distance2 < 70){
////        distance1 = getDistance(analogRead(analogPin1));
////        distance2 = getDistance(analogRead(analogPin2));
////      }
//  }
    if(sensor_id == 0) uploadToFirebase("Entry");
    else uploadToFirebase("Exit");
}

void uploadToFirebase(String dir) {
  /* Interfacing with Firebase */
  String path = "/Data";
  String count2 = String(count);
  count += 1;
  String jsonData = "{\"Timestamp\":\"231321546\", \"Direction\":\"" + dir + "\", \"Count\":\"" + count2 + "\"}";
  if (Firebase.setJSON(firebaseData, path, jsonData)) { // set sensorVal1ue in Firebase
    Serial.println("data successfully pushed to Firebase");
  }
  else {
    Serial.println("Error reason: " + firebaseData.errorReason());
  }
}
