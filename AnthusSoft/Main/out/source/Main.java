/* autogenerated by Processing revision 1293 on 2023-10-24 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;
import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.marker.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Main extends PApplet {















Serial myPort; 
UnfoldingMap map;

PImage img;
PImage imgCompass;
PImage imgCompassArrow;
PImage background;
PImage gradient;

float yPos, prePosx, temp, tempRaw, preHeat, currentAltitude, currentAltitudeRaw, formerAltitude, climbR, preAlt, press, prePress, hum, humRaw, prehum, sdStatus;
float azimuth,speed;
int numbSats;

float x0, x1, y0, y1;
Float distance, totalDistance;

String FStroke;
String input = "0";

int[] sensorData;

int allign = 1215;
int xPos, backgroundReset = 1;
int intro, alpha = 0;
int intStroke;
long lastUpdated, isValid, interval, interval2, interval3 = 0;

float lat1, lat2 = 47.38290f, lng1, lng2 = -3.509265f;

public void setup() {
    /* size commented out by preprocessor */;
    
    myPort = new Serial(this, "COM18", 115200); //COM port of your board
    myPort.bufferUntil('\n'); //Checks for first line break to initiate 
    myPort.write('r'); //Sends a character to wake up BMP280
    
    map = new UnfoldingMap(this, 1001, 300, 919, 700, new Microsoft.AerialProvider());
    MapUtils.createDefaultEventDispatcher(this, map);
    
    background(0); //Set Start page
    textSize(100);
    textAlign(CENTER);
    fill(0xFFFFFFFF);
    text("Flight Control", width / 2, 100);
    textSize(40);
    text("Press enter to continue", width / 2, 550);
    text("Sea-Level pressure Today:", width / 2, 380);
    rectMode(CENTER);
    
    img = loadImage("Reload.png");
    imgCompass = loadImage("Compass.png");
    imgCompassArrow = loadImage("CompassArrow.png");
    background = loadImage("background.jpg");
    gradient = loadImage("gradient.png");
    
    delay(10);
}



public void draw() {
    
    FStroke = input.substring(Math.max(0, input.length() - 4)); //Caps String at 4 characters
    
    try{ 
        intStroke = Integer.valueOf(FStroke);
    } 
    catch(NumberFormatException ex) {
        ex.printStackTrace();
    }
    
    if (intro != 1) { //Intro loop for Sea-Level text
        stroke(255, 255, 255);
        fill(0x000000);
        rect(width / 2, 450, 150, 60);
        textAlign(CENTER);
        fill(255, 255, 255);
        textSize(60);
        text(FStroke, width / 2, 470);
        delay(10);
        
        formerAltitude = currentAltitudeRaw;
    }
    
    if (keyCode == BACKSPACE && intro != 1) { //Reset Sea-Level text
        input = "0";
    }
    
    if (keyCode == ENTER && intro != 1) { //Main programm startup
        background(0);
        delay(10);
        intro = 1;
        // rect(500, 500, 1000, 1000);
        
    }
    
    
    ////////////////////////////////////
    //          Main Program          //
    ////////////////////////////////////
    
    if (intro == 1) { 
        

        
        
        fill(0);
        rect(1500, 250, 1000, 500);
        noFill();
        // Call voids
        drawGrid(); 
        //drawBackground();
        rtVal();
        sensorStatus();
        
        map.draw();
        
        
        
        
        
        if (millis() - interval2 > 10000) { //Climb rate calculation & logging of former altitude
            interval2 = millis();
            climbR = (currentAltitudeRaw - formerAltitude) / 10;
            delay(1);
            formerAltitude = currentAltitudeRaw;
        }
        
        if (mousePressed && (mouseY > 0) && (mouseY < 100) && (mouseX > 1845) && (mouseX < 1920)) { // Reset button of the graph
            xPos = 0; //Reset graph to the start
            preHeat = temp;
            prePosx = 0;
            background(0);   
            backgroundReset = 1;
        }
        
        if (millis() - interval > 1000) { //Main update of graph every half second
            interval = millis();
            
            
            
            
            
            
            if (preHeat == 0) { //Initiate Previous values as the current one at startup
                prehum = hum;
                preHeat = temp;
                prePress = press;
                preAlt = currentAltitude;
                
                xPos = 0;
            } else { //Logs previous values for graph plotting
                //noFill();
                stroke(255, 255, 255);
                line(prePosx, preHeat, xPos - 1, yPos);
                line(prePosx, prePress, xPos - 1, press);
                if (currentAltitudeRaw > 0) {line(prePosx + 500, preAlt, xPos + 500 , currentAltitude);}
                line(prePosx + 500, prehum, xPos + 500, hum);
                
                
                delay(10);
                yPos = temp;
                prehum = hum;
                prePress = press;
                prePosx = xPos;
                preHeat = temp;
                preAlt = currentAltitude;
            }
            
            if (xPos >= 500) { //Pulls back graphs to x = 0 when it reaches the end of the graph
                xPos = 0;
                preHeat = temp;
                prePosx = 0;
                background(0);   
                
                drawBackground();
                backgroundReset = 1;
                
            } else { //Makes the graph go forward every half a second
                
                xPos = xPos + 3;
                
            }
            map_draw();
            maths();
        }
                if (backgroundReset == 1) { //Background reset call
                background(0);   
                drawBackground();
        }
    }
    }




public void serialEvent(Serial myPort) {
    
    try {   //Initiate & Breaks String from COM port into separate values
        String inString = myPort.readString();
        String[] stringData = split(inString, ',');
        float[] values = PApplet.parseFloat(stringData);
        
        
        if (inString!= null) { 
            
            
            currentAltitudeRaw = 44330 * (1.0f - pow(values[1] / intStroke, 0.1903f)); //Pressure Altitude calculations
            
            temp = map(values[0], 50, 0, 0, 500);           //Mapping of values into plot points
            press = map(values[1], 900, 1020, 500, 1000);
            hum = map(values[2], 30, 120, 1000, 500);
            currentAltitude = map(currentAltitudeRaw, 0, 1000, 500, 0);
            
            tempRaw = values[0]; //Grabs Raw value from Serial port
            humRaw = values[2];
            sdStatus = values[3];
            lat1 = values[4];
            lng1 = values[5];
            azimuth = values[6];
            speed = values[7];
            numbSats = PApplet.parseInt(values[8]);
            lastUpdated = PApplet.parseInt(values[9]);
            isValid = PApplet.parseInt(values[10]);
            
           // println(lat1);
           // println(lng1);

            /*print(values[0]);
            print(",");
            print(values[1]);
            print(",");
            print(values[2]);
            print(",");
            print(values[3]);
            print(",");            
            print(values[4]);
            print(",");
            print(values[5]);
            print(",");
            print(values[6]);
            print(",");
            print(values[7]);
            print(",");
            print(values[8]);
            print(",");
            print(values[9]);
            print(",");
            println(values[10]);*/
            myPort.write('s');
            
            
            }
        }
    
    catch(RuntimeException e) {
        e.printStackTrace();
        }
    }


public void keyPressed() { //Logs keypresses 
    
    if (keyCode != ENTER && keyCode != BACKSPACE) input += key;
    
    
    }

public void maths() {
    
    float lat1Maths = lat1;
    float lat2Maths = lat2;
    
    //Distance from previous coordinates
    float delta = radians(lng1 - lng2);
    float sdlong = sin(delta);
    float cdlong = cos(delta);
    lat1Maths = radians(lat1);
    lat2Maths = radians(lat2);
    float slat1 = sin(lat1);
    float clat1 = cos(lat1);
    float slat2 = sin(lat2);
    float clat2 = cos(lat2);
    delta = (clat1 * slat2) - (slat1 * clat2 * cdlong);
    delta = sq(delta);
    delta += sq(clat2 * sdlong);
    delta = sqrt(delta);
    float denom = (slat1 * slat2) + (clat1 * clat2 * cdlong);
    delta = atan2(delta, denom);
    delta = delta * 6372795;

   if (keyCode == TAB){
    for (int i = 0; i < 1; i++ ){
    //totalDistance = int(delta) + totalDistance;
    //lat2 = lat1;
    //lng2 = lng1;
    }
    }
    println(delta);
    //println(totalDistance);
    //lat1 = lat1 + 0.00002;*/

    }

public void drawBackground(){
    
    //background(0);

    textSize(20); //Text in Graph
    fill(0xFFFFFFFF);
    stroke(255);
    textAlign(CENTER);
    text("Temperature(°C)", 250, 50);
    text("Pressure Altitude (m)", 750, 50);
    text("Pressure (hPa)", 250, 550);
    text("Humidity (%)", 750, 550);
    
    textSize(15); //Values in Graph
    text("50", 3, 12);
    text("0", 3, 495);
    text("900", 3, 512);
    text("1020", 3, 995);
    text("1000", 503, 12);
    text("0", 503, 495);
    text("20", 503, 995);
    text("150", 503, 512);


    textSize(15); //Sea-Level Pressure
    text("SL :", 228, 565);
    text(intStroke, 250, 565);
    
    text("AnthusSoft v0.1", 50, 1030);

    backgroundReset = 0; // Runs the code only once
}

public void drawGrid () {
    stroke(255); // Lines in the graph
    line(0, 1000, 0, 0);
    line(0, 500, 1000, 500);
    line(500, 1000, 500, 0);
    line(1000, 0, 1000, 1000);
    line(1000, 70, 1920, 70);
    line(1000, 140, 1920, 140);
    line(0, 1000, 1000, 1000);
}
public void sensorStatus() {


    
    if (hum < 0) { //HTU21D Status

      int i = 0;
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1150, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFFFF0000);
      text("Offline", 1120, 50);
      i++;
      }

       
    } else {

      int i = 0;
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1150, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFF00FF00);
      text("Online", 1120, 50);
      i++;
      }
    }

    
    if (temp < 0) { //BMP280 Status
      
      int i = 0;
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1070, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFFFF0000);
      text("Offline", 1020, 50);
      i++;
      }
      
    } else {

      int i = 0; 
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1070, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFF00FF00);
      text("Online", 1020, 50);
      i++;
      }
    }

    if (sdStatus == 0) { //SD card Status
      
      int i = 0;
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1270, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFFFF0000);
      text("Offline", 1220, 50);
      i++;
      }
      
    } else {

      int i = 0; 
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1270, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFF00FF00);
      text("Online", 1220, 50);
      i++;
      }
    }

        if (isValid == 0) { //SD card Status
      
      int i = 0;
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1370, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFFFF0000);
      text("Offline", 1320, 50);
      i++;
      }
      
    } else {

      int i = 0; 
      while (i == 0){
      fill(0xFF000000);
      noStroke();
      rect(1370, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFF00FF00);
      text("Online", 1320, 50);
      i++;
      }
    }



    if (intStroke > 1050 || intStroke < 950) { //Press alt check

      int i = 0;
      while (i == 1){
      fill(0xFF000000);
      noStroke();
      rect(720, 245, 350, 50);
      textSize(20);
      textAlign(CENTER);
      fill(0xFFFF0000);
      text("Sea-Level Pressure out of bounds!", 750, 250);
      text("Please restart software", 750, 270);
      
      i++;
      }
      
    }

    if (currentAltitudeRaw > 100) { //Allign m if altitude > 100
      allign = 1215;
    } else {
      allign = 1220;
    }
}
public void map_draw(){

    

  noStroke();
  fill(215, 0, 0, 100);


  // Shows marker at Berlin location
  Location p0 = new Location(lat1, lng1);
  Location p1 = new Location(lat2, lng2);
  ScreenPosition pos0 = map.getScreenPosition(p0);
  ScreenPosition pos1 = map.getScreenPosition(p1);
  ellipse(pos0.x, pos0.y, 5, 5);
  ellipse(pos1.x, pos1.y, 5, 5);
  SimpleLinesMarker link = new SimpleLinesMarker (p1, p0);
  SimplePointMarker currentPos = new SimplePointMarker (p0);
  SimplePointMarker previousPos = new SimplePointMarker (p1);
  currentPos.setColor(color(255, 0, 0, 100));
  currentPos.setRadius(3);
  previousPos.setColor(color(255, 255, 0, 100));
  previousPos.setRadius(3);
  map.addMarkers(link, currentPos, previousPos);
 
  if (millis() - interval > 1000 && keyCode == ENTER){
    interval = millis();
    
    
    x0 = x1;
    y0 = y1;
    y1 = y1 + 0.00001f;
    
}

}
public void rtVal( ){

    
    fill(0xFF000000); //Black rectangles for text updates
    noStroke();
    rect(1037, 115, 35, 20);
    rect(1142, 115, 45, 20);
    rect(1237, 115, 55, 20);
    rect(1337, 115, 35, 20);
    rect(1437, 115, 35, 20);    
    rect(1037, 190, 35, 20);    
    rect(1137, 190, 35, 20);
    rect(1237, 190, 35, 20);    
    rect(1750, 1025, 400, 40);        
    fill(0xFFFFFFFF);
    
    textSize(20); //Values in real time
    textAlign(LEFT);
    text(nf(tempRaw, 0, 1), 1020, 120);  
    text(nf(speed, 0, 1), 1320, 120); 
    text(nf(currentAltitudeRaw, 0, 1), allign, 120);
    text(nf(humRaw, 0, 1), 1120, 120);
    text(nf(climbR, 0, 1), 1420, 120); 
    text(PApplet.parseInt(azimuth), 1020, 195);
    text(numbSats, 1120, 195);
    text(nf(PApplet.parseInt(lastUpdated) / 1000, 3, 0) , 1220, 195); 

    textAlign(LEFT); //Text in RT & Status
    text("BMP280", 1020, 25);
    text("HTU21D", 1120, 25);
    text("SD Card", 1220, 25);
    text("GPS", 1320, 25);
    text("Temp.", 1020, 100);
    text("Speed", 1320, 100);
    text("Altitude", 1220, 100);
    text("Humd.", 1120, 100);
    text("Climb R.", 1420, 100);
    text("Azimuth", 1020, 175);
    text("N° Sats.", 1120, 175);
    text("Time since last update", 1220, 175);
    
    text("Long :", 1790, 1030); //Stats under map
    text(nf(lng1, 0, 6), 1830, 1030);
    text("Lat :", 1645, 1030);
    text(nf(lat1, 0 , 6), 1700, 1030);
      
    text("°C", 1055, 120); //Units in RT
    text("m/s", 1365, 120); 
    text("m", 1265, 120);
    text("%", 1165, 120);
    text("m/s", 1465, 120);



    pushMatrix();
    translate(1760, 300); // Translates the coordinate system into the center of the screen, so that the rotation happen right in the center
     rotate(radians(-PApplet.parseInt(azimuth))); // Rotates the Compass around Z - Axis 
    image(imgCompass, -160, -149, 320, 298); // Loads the Compass image and as the coordinate system is relocated we need need to set the image at -960x, -540y (half the screen size)
  
    popMatrix(); // Brings coordinate system is back to the original position 0,0,0
  
    stroke(0xFFFF0000);
    line(1760, 300, 1760, 180);
      
    pushMatrix();
    translate(1760, 300);
    rotate(PI);
    image(gradient, -160, -150, 320, 300);
    popMatrix();  

    image(img, 1845, 0, 70, 70);
}


  public void settings() { size(1920, 1080, P2D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
