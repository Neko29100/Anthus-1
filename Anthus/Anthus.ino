#include <Wire.h>
#include <SD.h>
#include "SparkFunHTU21D.h"
#include <Adafruit_BMP280.h>
#include <SoftwareSerial.h>
#include <TinyGPS++.h>

const int sdCardPinChipSelect = 0;
const char *fileName = "data.csv";
unsigned long timestamp, interval = 0;

static const int RXPin = 3, TXPin = 2;
static const uint32_t GPSBaud = 9600;

float humd;
float Temp;
float Press;

Adafruit_BMP280 bmp; // I2C Interface
HTU21D myHumidity;
File myFile;
TinyGPSPlus gps;
SoftwareSerial ss(RXPin, TXPin);

int i = 0;
int sdStatus;

int i2, interval2, interval3 = 0;

double latBuffer, lngBuffer, courseBuffer, speedBuffer, lastUpdate;
int satellitesConnected;
int valid;

double prevLat, prevLng;

void setup() {
  Serial.begin(115200);

  if (!SD.begin(sdCardPinChipSelect)) {
    Serial.println();
    Serial.println("SD Card initialisation Failed");
    while (true)
      ;
  }
  Serial.println(F("SD Card is operational"));
  Serial.println();

  if (!bmp.begin()) {
    Serial.print("BMP failed to initiate, check wiring");
    while (1)
      ;
  }

  /* Default settings from datasheet. */
  bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode. */
                  Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                  Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                  Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                  Adafruit_BMP280::STANDBY_MS_500); /* Standby time. */

  myHumidity.begin();
  ss.begin(GPSBaud);

  delay(100);
}

void loop() {
  
  if (millis() - interval3 > 5000 && gps.location.isUpdated() == true) {
    interval3 = millis();
    prevLat = latBuffer;
    prevLng = lngBuffer;

    }




  if (millis() - interval > 1000) {


    while (ss.available() > 0)
    if (gps.encode(ss.read()))
      displayInfo();

    interval = millis();

    humd = myHumidity.readHumidity();
    Temp = bmp.readTemperature();
    Press = bmp.readPressure() / 100;

    sdLog();

    char input = Serial.read();

    Serial.print(Temp);
    delay(1);
    Serial.print(',');
    Serial.print(Press);
    delay(1);
    Serial.print(',');
    Serial.print(humd, 1);
    delay(1);
    Serial.print(',');
    Serial.print(sdStatus);
    delay(1);
    Serial.print(',');
    Serial.print(latBuffer, 6);
    delay(1);
    Serial.print(',');
    Serial.print(lngBuffer, 7);
    delay(1);
    Serial.print(',');
    Serial.print(courseBuffer);
    delay(1);
    Serial.print(',');
    Serial.print(speedBuffer);
    delay(1);
    Serial.print(',');
    Serial.print(satellitesConnected);
    delay(1);
    Serial.print(',');
    Serial.print(gps.location.age());
    delay(1);
    Serial.print(',');
    Serial.print(valid);
    delay(1);
    Serial.print(',');
    Serial.println(gps.distanceBetween(latBuffer, lngBuffer, prevLat, prevLng));
    delay(1);
  } 

  if (millis() > 5000 && gps.charsProcessed() < 10) {
  valid = false;
} else {
  valid = gps.location.isValid();
  }
}
 
void displayInfo() {

    interval2 = millis();
    latBuffer = gps.location.lat();
    lngBuffer = gps.location.lng();
    courseBuffer = gps.course.deg();
    speedBuffer = gps.speed.mps();
    satellitesConnected = gps.satellites.value();

}

void sdLog() {

  timestamp = millis() / 100;

  String roundedHum = String(humd, 1);
  String roundedTemp = String(Temp, 1);
  String roundedPress = String(Press, 1);
  String roundedAzimuth = String(courseBuffer, 1);
  String roundedSpeed = String(speedBuffer, 1);
  roundedHum.replace(".", ",");
  roundedTemp.replace(".", ",");
  roundedPress.replace(".", ",");
  roundedAzimuth.replace(".", ",");
  roundedSpeed.replace(".", ",");

  myFile = SD.open(fileName, FILE_WRITE);
  if (myFile) {

    if (i == 0)
    {
      myFile.println("-----------------------------------------------------NEW START OF PROGRAM-------------------------------------------------");
      Serial.println("New start");
      i++;
    }
    myFile.print(timestamp);
    myFile.print(";");
    myFile.print(roundedHum);
    myFile.print(";");
    myFile.print(roundedPress);
    myFile.print(";");
    myFile.print(roundedTemp);
    myFile.print(";");
    myFile.print(latBuffer);
    myFile.print(";");
    myFile.print(lngBuffer);
    myFile.print(";");
    myFile.print(roundedAzimuth);
    myFile.print(";");
    myFile.println(roundedSpeed);
    myFile.print(";");
    myFile.println(gps.location.age());
    myFile.close();
    sdStatus = 1;
  }
  else {
    Serial.println(F("Failed to log on the SD card"));
    sdStatus = 0;
  }
}