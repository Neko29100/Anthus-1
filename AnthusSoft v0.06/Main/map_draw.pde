void map_draw(){

    

  noStroke();
  fill(215, 0, 0, 100);

 //pushMatrix();
  if(mouseX > 1000 && mouseX < 1300 && mouseY > 500 && mouseY < 800) {
  Location location = map.getLocation(mouseX, mouseY);
  text(location.toString(), mouseX, mouseY);
  }

  // Shows marker at Berlin location
  Location p0 = new Location(x0, y0);
  Location p1 = new Location(x1, y1);
  ScreenPosition pos0 = map.getScreenPosition(p0);
  ScreenPosition pos1 = map.getScreenPosition(p1);
  ellipse(pos0.x, pos0.y, 5, 5);
  ellipse(pos1.x, pos1.y, 5, 5);
  SimpleLinesMarker link = new SimpleLinesMarker (p1, p0);
  map.addMarkers(link);
//popMatrix();
 
  
  
  if (millis() - interval > 10 && keyCode == ENTER){
    interval = millis();
    
    
    x0 = x1;
    y0 = y1;

    
}

}