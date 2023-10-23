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

void drawGrid () {
    stroke(255); // Lines in the graph
    line(0, 1000, 0, 0);
    line(0, 500, 1000, 500);
    line(500, 1000, 500, 0);
    line(1000, 0, 1000, 1000);
    line(1000, 70, 1920, 70);
    line(1000, 140, 1920, 140);
    line(0, 1000, 1000, 1000);
}
