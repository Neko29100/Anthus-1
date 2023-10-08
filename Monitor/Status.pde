public void sensorStatus() {

    a = 0;
    b = 0; 
    
    if (Hum < 0) { //HTU21D Status
      while (b < 1){
      fill(0xFF000000);
      noStroke();
      rect(1150, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFFFF0000);
      text("Offline", 1120, 50);
      b++;
      }
      
    } else {
      while (a < 1){
      fill(0xFF000000);
      noStroke();
      rect(1150, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFF00FF00);
      text("Online", 1120, 50);
      a++;
      }
    }
    
    a2 = 0;
    b2 = 0; 
    
    if (Temp < 0) { //BMP280 Status
      while (b2 < 1){
      fill(0xFF000000);
      noStroke();
      rect(1070, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFFFF0000);
      text("Offline", 1020, 50);
      b2++;
      }
      
    } else {
      while (a2 < 1){
      fill(0xFF000000);
      noStroke();
      rect(1070, 45, 100, 40);
      textSize(20);
      textAlign(LEFT);
      fill(0xFF00FF00);
      text("Online", 1020, 50);
      a2++;
      }
    }

   int b3 = 0; 
    
    if (intStroke > 1050 || intStroke < 1000) { //Press alt check
      while (b3 < 1){
      fill(0xFF000000);
      noStroke();
      rect(720, 245, 350, 50);
      textSize(20);
      textAlign(CENTER);
      fill(0xFFFF0000);
      text("Sea-Level Pressure out of bounds!", 750, 250);
      text("Please restart software", 750, 270);
      
      b3++;
      }
      
    } 
}
