
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

//int s0 = 0;
//int s1 = 0;
//int s2 = 0;
//int 
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
  delay(200);
 Serial.println(); 
}

int getDistance(int sensorVal){
  float volts = sensorVal * (voltage / max_analog_value);
  // From Sharp.h library
  float distance = 29.988 * pow(volts, -1.173);
  Serial.print(distance);
  Serial.println(" cm");
  Serial.println();
  return distance;  
}

bool setTriggerTime(int id, float distance){
  if(distance < 50 && distance > 0){
    if(id == 1){
      time1 = millis();
      Serial.println("reached 1 first");
//      Serial.print("First Sensor Time 1: ");
//      Serial.println(time1);
//      Serial.print("Time 2: ");
//      Serial.println(time2);
    }
    else{
      time2 = millis();
      Serial.println("reached 2 first"); 
//      Serial.print("Second Sensor Time 1: ");
//      Serial.println(time1);
//      Serial.print("Time 2: ");
//      Serial.println(time2);
    }
    return true;
  }
  return false;
}

int checkSensor() {
//  float distance1 = 49;
//  float distance2 = 49;
  if (time1 < time2){
//    Serial.println("Entry");
    uploadToFirebase("Entry");
//    while(distance1 < 70 || distance2 < 70){
//      distance1 = getDistance(analogRead(analogPin1));
//      distance2 = getDistance(analogRead(analogPin2));
//    }
  }
  else{
//    Serial.println("Exit");
    uploadToFirebase("Exit");
//      while(distance1 < 70 || distance2 < 70){
//        distance1 = getDistance(analogRead(analogPin1));
//        distance2 = getDistance(analogRead(analogPin2));
//      }
  }
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
