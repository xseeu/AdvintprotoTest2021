class Star {
  float x,y,s;
  boolean bad;
  int c;
  //Constructor
  Star(float px){
    x = px;
    y = random(350,height - 500);
    s = random(30.0,33.0);
    c = #FFF68F;
    bad = false;
  }
  
  void move() {
    if(!bad){
      x -= 3.0;
    }else {
      x += 8.0;
    }
    y -= map(sin(frameCount/s),-1,1,-2,2);
  }
  
  void show() {
    if(bad){
      c = 0;
    }
    fill(c);
    circle(x,y,15);
    if(!bad){
      fill(c,25);
    }else {
      fill(c,55);
    }
    circle(x,y,40);
  }
  
  void changeBad() {
      if(x < 300){
        bad = true;
      }
  }
  
  boolean checkCollision(Player p) {
    //Using dist method to detect the distance between two objects and
    //determine whether or not to collide
    println(p.getPostionY());
    if (dist(p.x,p.y,x,y) < 20){
      return true;
    }else {
      return false;
    }
  }
  
  
}
