public void drawBackground(){
    
    textSize(20);
    fill(0xFFFFFFFF);
    textAlign(CENTER);
    text("Temperature(°C)", 250, 50);
    text("Pressure Altitude (m)", 750, 50);
    text("Pressure (hPa)", 250, 550);
    text("Humidity (%)", 750, 550);
    
    textAlign(LEFT);
    text("BMP280", 1020, 25);
    text("HTU21D", 1120, 25);
    text("Temp.", 1020, 100);
    text("Speed", 1320, 100);
    text("Altitude", 1220, 100);
    text("Humd.", 1120, 100);
    text("Climb R.", 1420, 100);
    
      
      
    text("°C", 1055, 120);  
    text("m/s", 1365, 120); 
    text("m", 1265, 120);
    text("%", 1165, 120);
    text("m/s", 1465, 120);
    
    textSize(15);
    text("50", 3, 12);
    text("0", 3, 495);
    text("900", 3, 512);
    text("1020", 3, 995);
    text("1000", 503, 12);
    text("0", 503, 495);
    text("20", 503, 995);
    text("150", 503, 512);


    textSize(15);
    text("SL :", 228, 565);
    text(intStroke, 250, 565);
    
    image(img, 1625, 0, 70, 70);
    
    a4 = 1;
}

public void drawGrid () {
    fill(0xFFFFFFFF);
    line(0, 1000, 0, 0);
    line(0, 500, 1000, 500);
    line(500, 1000, 500, 0);
    line(1000, 0, 1000, 1000);
    line(1000, 70, 1700, 70);
}
