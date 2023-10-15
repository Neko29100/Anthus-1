#include <Wire.h>
#include "SparkFunHTU21D.h"
#include <Adafruit_BMP280.h>

Adafruit_BMP280 bmp; // I2C Interface
HTU21D myHumidity;

void setup() {
  Serial.begin(115200);

  if (!bmp.begin()) {
    Serial.print("EEEEEEEEEE");
    while(1);
  }

  /* Default settings from datasheet. */
  bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode. */
                  Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                  Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                  Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                  Adafruit_BMP280::STANDBY_MS_500); /* Standby time. */

  myHumidity.begin();

  delay(100);
}

void loop() {
    float humd = myHumidity.readHumidity();
    float Temp = bmp.readTemperature();
    float Press = bmp.readPressure()/100;


  
   
    char input = Serial.read();
    
    Serial.print(Temp);
    delay(1);
    Serial.print(',');  
    Serial.print(Press);
    delay(1); 
    Serial.print(',');  
    Serial.println(humd, 1);
    delay(1);
     

    delay(200);
}