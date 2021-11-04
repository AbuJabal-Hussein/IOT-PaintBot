#include <SoftwareSerial.h>
#include <FirebaseArduino.h>
//Include ESP8266WiFi.h
#include <ESP8266WiFi.h>


#define WIFI_SSID "Android ggjgghh"
#define WIFI_PASSWORD "dlaa1453"

#define FIREBASE_HOST "paintbot-48ab2-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "YjypViASgPTJdxJTmHiDoMYcqdhB8X9MzDuBlhUx"


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  // put your main code here, to run repeatedly:
  int paths_num = Firebase.getInt("/num");
  if(!Firebase.success()){
    paths_num = 0;
  }
  delay(1000);
  Serial.println();
  Serial.print("paths num = ");
  Serial.println(paths_num);
  for(int j = 0; j < paths_num; j++){
    String path_name = "/path" + String(j);
    int points_num = Firebase.getInt(path_name + "/len");
    String pathstr = Firebase.getString(path_name + "/points");
    delay(2000);
    Serial.print("number of points: ");
    Serial.println(points_num);
    Serial.print("points:");
    Serial.println(pathstr);
    delay(200);
    Serial.write(points_num);
    delay(300);
    Serial.write(pathstr.c_str());
    delay(1000);
    Serial.println();
//    Serial.println(Serial.read());
  }
  Serial.write(-1);
  if(paths_num != 0){
    Firebase.remove("/");
  }
  
  delay(10000);
}
