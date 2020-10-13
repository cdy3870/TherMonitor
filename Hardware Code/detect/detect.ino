#include <Firebase_Arduino_WiFiNINA.h>
#include <Firebase_Arduino_WiFiNINA_HTTPClient.h>
#include <WiFiNINA.h>
#include <Wire.h>
#include <SparkFunTMP102.h>

/* Board
 * Install megaAVR boards and select Arduino UNO Rev2  
 */
 
/* Libs 
 *  WiFiNINA
 *  SparkFunTMP102
 *  FirebaseArduino (that supports WiFiNINA)
 */
 
#define WIFI_SSID "372 South Bouquet C" 
#define WIFI_PASSWORD "Janvar1226"
#define FIREBASE_HOST "thermonitor-f2d55.firebaseio.com" 
#define FIREBASE_AUTH "4ipmlNTVDKQW2rWdVPDPe1NS9aCPuq8x1GpVau7E" 

FirebaseData firebaseData;

/* Analog Pins */
int analogPin1 = A1; 
int analogPin2 = A3;

/* Digital Pins */
//int interruptPin = 2;
//int digitalPin = 3;

/* Times */
unsigned long time1 = 0;
unsigned long time2 = 0;

/* Other constants */
float voltage = 5.0;
int max_analog_value = 1023;

int count = 1;

void setup() {
  /* Serial Connection */
  Serial.begin(9600);

  /* Interrupt setup */
//  pinMode(interruptPin, INPUT_PULLUP);
//  pinMode(digitalPin, OUTPUT);
//  attachInterrupt(digitalPinToInterrupt(interruptPin, uploadToFirebase, CHANGE);
  
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
  /* Analog Readings */
  int sensorVal1 = 0;
  int sensorVal2 = 0;

  /* Reading from sensors */  
  sensorVal1 = analogRead(analogPin1);
  Serial.println(sensorVal1);
//  sensorVal2 = analogRead(analogPin2);
//  Serial.println(sensorVal1);

//  getTriggerTimes(1);
//  getTriggerTimes(2);
//  checkSensor(sensorVal1, analogPin1, 1);
//  checkSensor(sensorVal2, analogPin2, 2);
  float volts = sensorVal1*(voltage/max_analog_value);
  // From Sharp.h library
  float distance = 29.988*pow(volts, -1.173);   
  Serial.print(distance);     
  Serial.println(" cm");
  delay(100);    

}

//int getTriggerTimes(int id){
//  if(sensorVal > 240){  
//    if(id = 1){
//      time1 = millis();
//      Serial.print("Time 1: ");
//      Serial.println(time1);
//      Serial.print("Time 2: ");
//      Serial.println(time2);
//    }
//    else{
//      time2 = millis();
//      Serial.print("Time 1: ");
//      Serial.println(time1);
//      Serial.print("Time 2: ");
//      Serial.println(time2);
//    }
//  }
//}

int checkSensor(int analogPin){
    if(time1 > time2)uploadToFirebase("Entry");
    else uploadToFirebase("Exit");
    
//    while(sensorVal > 210){
//      sensorVal = analogRead(analogPin);
//    } 
}

int checkSensor(int sensorVal, int analogPin, int id){  
  /* Detection "Algorithm" */
  if(sensorVal > 240){
    Serial.print(id);
    Serial.println(" Entry/Exit");

//    digitalWrite(digitalPin, HIGH);
    if(id = 1){
      time1 = millis();
      Serial.print("Time 1: ");
      Serial.println(time1);
      Serial.print("Time 2: ");
      Serial.println(time2);
    }
    else{
      time2 = millis();
      Serial.print("Time 1: ");
      Serial.println(time1);
      Serial.print("Time 2: ");
      Serial.println(time2);
    }
    if(time1 > time2)uploadToFirebase("Entry");
    else uploadToFirebase("Exit");
    
    //while(sensorVal > 210){
    //  sensorVal = analogRead(analogPin);
    //}
    delay(500);
  }
}

void uploadToFirebase(String dir){
  /* Interfacing with Firebase */

  String path = "/Data";
  String count2 = String(count);
  count += 1;
  String jsonData = "{\"Timestamp\":\"231321546\", \"Direction\":\"" + dir + "\", \"Count\":\"" + count2 + "\"}";
  if(Firebase.setJSON(firebaseData, path, jsonData)){ // set sensorVal1ue in Firebase 
    Serial.println("data successfully pushed to Firebase");
  }  
  else{
    Serial.println("Error reason: " + firebaseData.errorReason());
  }
}
