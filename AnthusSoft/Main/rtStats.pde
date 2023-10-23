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
    text(int(azimuth), 1020, 195);
    text(numbSats, 1120, 195);
    text(nf(int(lastUpdated) / 1000, 3, 0) , 1220, 195); 

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
     rotate(radians(-int(azimuth))); // Rotates the Compass around Z - Axis 
    image(imgCompass, -160, -149, 320, 298); // Loads the Compass image and as the coordinate system is relocated we need need to set the image at -960x, -540y (half the screen size)
  
    popMatrix(); // Brings coordinate system is back to the original position 0,0,0
  
    stroke(#FF0000);
    line(1760, 300, 1760, 180);
      
    pushMatrix();
    translate(1760, 300);
    rotate(PI);
    image(gradient, -160, -150, 320, 300);
    popMatrix();  

    image(img, 1845, 0, 70, 70);
}
