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

float lat1, lat2 = 47.38290, lng1, lng2 = -3.509265;

public void setup() {
    size(1920, 1080, P2D);
    
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
            numbSats = int(values[8]);
            lastUpdated = int(values[9]);
            isValid = int(values[10]);
            
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


void keyPressed() { //Logs keypresses 
    
    if (keyCode != ENTER && keyCode != BACKSPACE) input += key;
    
    
    }

void maths() {
    
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

