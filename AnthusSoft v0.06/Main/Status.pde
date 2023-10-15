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


    if (intStroke > 1050 || intStroke < 1000) { //Press alt check

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
