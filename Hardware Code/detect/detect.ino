

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

int analogPin = A1; 

int val = 0; 

int count = 1;

void setup() {
  /* Serial Connection */
  Serial.begin(9600);

  /* Sensor Setup */
//   Wire.begin(0x48);
//  if(!infra_sensor.begin())
//  {
//    Serial.println("Cannot connect to TMP102.");
//    Serial.println("Is the board connected? Is the device ID correct?");
//    while(1);
//  }
  
//  infra_sensor.setHighTempF(82.0);  //set T_HIGH, the upper limit to trigger the alert on
//  infra_sensor.setLowTempF(81.0);  //set T_LOW, the lower limit to shut turn off the alert

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
 
  /* Reading from sensor */
//  infra_sensor.wakeup(); // Turn sensor on to start temperature measurement. Current consumtion typically ~10uA.
//   temperature = infra_sensor.readTempF(); // read temperature data
//  Serial.print(" Temperature reading: "); // print to serial
//  Serial.println(temperature);
  val = analogRead(analogPin);
  Serial.println(val);
  if(val > 210){
    Serial.print(val);
    Serial.println(" Entry");
    
    /* Interfacing with Firebase */
    String path = "/Data";
    String count2 = String(count);
    count += 1;
    String jsonData = "{\"Timestamp\":\"231321546\", \"Direction\":\"Entry\", \"Count\":\"" + count2 + "\"}";
    if(Firebase.setJSON(firebaseData, path, jsonData)){ // set value in Firebase 
      //Serial.print("data successfully pushed to Firebase");
    }  
    else{
      //Serial.println("Error reason: " + firebaseData.errorReason());
    }
    while(val > 210){
      val = analogRead(analogPin);
    }
    delay(500);
  }
    /* Detection "Algorithm" */
    //if(temperature) > 70 

      
 // infra_sensor.sleep(); // Place sensor in sleep mode to save power. Current consumtion typically <0.5uA.
//  delay(1000);  // Wait 1000ms
}
