class Star{
  float posX,posY;
  color sCol;
  boolean sStroke;
  
  Star(){
    posX = random(width/2,width);
    posY = random(height/4,height-width/4);
    //print("Star:",posX,posY,'\n');
    sCol = color(255,255,0);
    sStroke = false;
  }
  
  void display(){
    fill(sCol); //set color
    
    if(!sStroke){ //set stroke
      noStroke();
    }
    
    circle(posX, posY, 30); //draw the circle
  }
  
  void move(){
    posX = random(width/2,width);
    posY = random(height/4,height-width/4);
  }
  


}
