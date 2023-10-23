void map_draw(){

    

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
    y1 = y1 + 0.00001;
    
}

}