public void rtVal( ){

    
    fill(0xFF000000); //Black rectangles for text updates
    noStroke();
    rect(1037, 115, 35, 20);
    rect(1142, 115, 45, 20);
    rect(1237, 115, 55, 20);
    rect(1337, 115, 35, 20);
    rect(1437, 115, 35, 20);       
    fill(0xFFFFFFFF);
    
    textSize(20); //Values in real time
    textAlign(LEFT);
    text(nf(tempRaw, 0, 1), 1020, 120);  
    text(nf(currentAltitudeRaw, 0, 1), 1320, 120); 
    text(nf(currentAltitudeRaw, 0, 1), allign, 120);
    text(nf(humRaw, 0, 1), 1120, 120);
    text(nf(climbR, 0, 1), 1420, 120); 
}
