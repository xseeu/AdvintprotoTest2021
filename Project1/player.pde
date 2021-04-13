class Player {
  float x,y,r,vy,gravity;
  //Constructor
  Player() {
    x = width/2;
    y = 475;
    r = 35;
    gravity = 1;
    vy = 0;
  }
  float getPostionY() {
    return y;
  }
  //Gravity and limitation
  void move() {
    y += vy;
    vy += gravity;
    y = constrain(y,0,485);
  }
  

  void jump() {
    vy = -15;
  }
  
  void show() {
    push();
    //Use the sin function and map to gently change some colors
    fill(#EEEE00,map(sin(frameCount/5.0),-1,1,100,180));
    circle(x,y,r);
    fill(#FFFF00,map(sin(frameCount/10.0),-1,1,1,10));
    circle(x,y,r*2.5);
    pop();
  }
  
}
