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
 
#define WIFI_SSID "test" 
#define WIFI_PASSWORD "test"
#define FIREBASE_HOST "https://thermonitor-f2d55.firebaseio.com" 
#define FIREBASE_AUTH "4ipmlNTVDKQW2rWdVPDPe1NS9aCPuq8x1GpVau7E" 

FirebaseData firebaseData;

TMP102 infra_sensor;

void setup() {
  /* Serial Connection */
  Serial.begin(115200);

  /* Sensor Setup */
  Wire.begin();
  if(!infra_sensor.begin())
  {
    Serial.println("Cannot connect to TMP102.");
    Serial.println("Is the board connected? Is the device ID correct?");
    while(1);
  }
  
//  infra_sensor.setHighTempF(82.0);  //set T_HIGH, the upper limit to trigger the alert on
//  infra_sensor.setLowTempF(81.0);  //set T_LOW, the lower limit to shut turn off the alert

  /* Wi-Fi Setup */ 
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD); 
  while (WiFi.status() != WL_CONNECTED) { 
    Serial.print("Not connected to Wi-Fi"); 
    delay(500); 
  } 
  Serial.println(); 
  Serial.print("Connected: "); 
  Serial.println(WiFi.localIP()); 
  
  /* Firebase Setup */
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH, WIFI_SSID, WIFI_PASSWORD);
  Firebase.reconnectWiFi(true);
}

void loop() {
  float temperature;
  
  /* Reading from sensor */
  infra_sensor.wakeup(); // Turn sensor on to start temperature measurement. Current consumtion typically ~10uA.
  temperature = infra_sensor.readTempF(); // read temperature data
  Serial.print("Temperature reading: "); // print to serial
  Serial.println(temperature);

  /* Detection "Algorithm" */
  //if(temperature) > 70 

  /* Interfacing with Firebase */
  String occupancy_path = "Occupancy/";
  if(Firebase.pushInt(firebaseData, occupancy_path, 1)){ // set value in Firebase 
    Serial.print("data successfully pushed to Firebase");
  }  
  else{
    Serial.println("Error reason: " + firebaseData.errorReason());
  }
  
  infra_sensor.sleep(); // Place sensor in sleep mode to save power. Current consumtion typically <0.5uA.
  delay(1000);  // Wait 1000ms
}
