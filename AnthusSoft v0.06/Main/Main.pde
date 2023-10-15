import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;
import processing.serial.*;


Serial myPort; 

PImage img;

float yPos, prePosx, temp, tempRaw, preHeat, currentAltitude, currentAltitudeRaw, formerAltitude, climbR, preAlt, press, prePress, hum, humRaw, prehum, allign;

String FStroke;
String input = "0";

int[] sensorData;

int xPos, backgroundReset = 1;
int intro, alpha = 0;
int intStroke;
long interval, interval2 = 0;


public void setup() {
    size(1700, 1000);
    
    myPort = new Serial(this, "COM16", 115200); //COM port of your board
    myPort.bufferUntil('\n'); //Checks for first line break to initiate 
    myPort.write('r'); //Sends a character to wake up BMP280
    
    background(0); //Set Start page
    textSize(100);
    textAlign(CENTER);
    fill(0xFFFFFFFF);
    text("Flight Control", 850, 100);
    textSize(40);
    text("press enter to continue", 850, 550);
    text("Sea-Level pressure Today:", 850, 380);
    rectMode(CENTER);
    
    img = loadImage("Reload.png");
    
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
        rect(850, 450, 150, 60);
        textAlign(CENTER);
        fill(255, 255, 255);
        textSize(60);
        text(FStroke, 850, 470);
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
    }
    
    
    ////////////////////////////////////////////////
    //  Main Program                  //
    ////////////////////////////////////////////////
    
    if(intro == 1) { 
        
        
        
       if (backgroundReset == 1) { //Background reset call
            drawBackground();
        }
        
        
       // Call voids
        drawGrid(); 
        rtVal();
        sensorStatus();
        
        
        
        if (millis() - interval2 > 10000) { //Climb rate calculation & logging of former altitude
            interval2 = millis();
            climbR= (currentAltitudeRaw - formerAltitude) / 10;
            delay(1);
            formerAltitude = currentAltitudeRaw;
        }
        
        
        if (millis() - interval > 500) { //Main update of graph every half second
            interval = millis();
            
            
            
            if (mousePressed && (mouseY > 0) && (mouseY < 100) && (mouseX > 1625) && (mouseX < 1700)) { // Reset button of the graph
                xPos = 0; //Reset graph to the start
               preHeat = temp;
               prePosx = 0;
                background(0);   
                backgroundReset = 1;
            }
            
            
            
            if (preHeat == 0) { //Initiate Previous values as the current one at startup
               prehum = hum;
                preHeat = temp;
               prePress = press;
               preAlt = currentAltitude;
                
               xPos = 0;
        } else { //Logs previous values for graph plotting
                
                stroke(255, 255, 255);
                line(prePosx, preHeat, xPos - 1, yPos);
                line(prePosx, prePress, xPos - 1, press);
                if (currentAltitudeRaw > 0) {line(prePosx + 500, preAlt, xPos + 499 , currentAltitude);}
                line(prePosx+ 500, prehum, xPos + 499, hum);
                
                
                
                delay(10);
               yPos = temp;
               prehum = hum;
               prePress = press;
                prePosx = xPos;
                preHeat = temp;
               preAlt = currentAltitude;
            }
            
            if (xPos>= 500) { //Pulls back graphs to x = 0 when it reaches the end of the graph
                xPos = 0;
               preHeat = temp;
               prePosx = 0;
                background(0);   
                
                drawBackground();
                
                
                backgroundReset = 1;
        } else { //Makes the graph go forward every half a second
                
                xPos = xPos+ 3;
                
        }
        }
}
}




public void serialEvent(Serial myPort) {
    
    try {                                        //Initiate & Breaks String from COM port into separate values
        String inString = myPort.readString();
        String[] stringData = split(inString, ',');
        float[] values = PApplet.parseFloat(stringData);
        
        
        if (inString != null) { 
            
         
            currentAltitudeRaw = 44330 * (1.0f - pow(values[1] / intStroke, 0.1903f)); //Pressure Altitude calculations
            
           temp = map(values[0], 50, 0, 0, 500);           //Mapping of values into plot points
            press = map(values[1], 900, 1020, 500, 1000);
            hum = map(values[2], 30, 120, 1000, 500);
            currentAltitude = map(currentAltitudeRaw, 0, 1000, 500, 0);
            
            tempRaw = values[0]; //Grabs Raw value from Serial port
            humRaw =values[2];
            
            
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