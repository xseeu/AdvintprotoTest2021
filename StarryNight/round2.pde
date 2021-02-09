void setup() {
  size(200, 200);
  smooth();
}

void draw() {
  background(0);

  // move the center of rotation 
  // to the center of the sketch
  translate(width/2, height/2);

  // rotate around the center of the sketch
  rotate(radians(frameCount));


  // draw a rectangle with 
  // its top-left corner
  // at the center of rotation
  fill(50, 55, 100);
  circle(5, 100, 100);
}
