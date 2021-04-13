import java.util.Iterator;
import ddf.minim.*;
Player p;
ArrayList<Star> stars;
int lastAddTime;
int score;

Minim minim;
AudioPlayer eat;
AudioPlayer over;
PFont myfont;

float[] pvalues;
int PTS = 45;
int OBJ = 35;

float xmotion = 0;
float ymotion = 0;
float smotion = 0;

void setup() {
  size(1200,800,P2D);
  colorMode(HSB,360,255,255,255);
  frameRate(30);
  smooth();
  p = new Player();
  stars = new ArrayList<Star>();
  score = 0;

  minim = new Minim(this);
  eat = minim.loadFile("./sounds/eat.mp3");
  over = minim.loadFile("./sounds/GameOver.mp3");
  
  myfont = createFont("Nature-Green-Italic-3.ttf", 32);
}



void draw() {
  bg();
  push();
  fill(0);
  textSize(50);
  textAlign(CENTER);
  text("Score: " + score,width-150,80);
  pop();
  p.show();
  push();
  frameRate(15);
  //A huge planet.
  for(int x=width *2; x>1800; x=x-8)
  {

    int r=int(random(100));
    int g=int(random(255));
    int b=int(random(255));
    int c=color(r, g, b, 140);
    stroke(c);
    circle(width/2, height * 2 + 100, x);

    fill(c);
  }
  pop();
  p.move();
  //Randomize the formation of stars by a timer
  float interval = random(4000,13500);

  if (millis() - lastAddTime  > interval){
    stars.add(new Star(width));
    stars.add(new Star(width + 50));
    stars.add(new Star(width + 100));
    lastAddTime = millis();
  }
  Iterator<Star> iterator = stars.iterator();
  while(iterator.hasNext()){
    Star s = iterator.next();
    s.show();
    s.move();
    //If the player fails to eat the stars, it will turn into a black hole.
    s.changeBad();
    if(s.checkCollision(p)) {
      if(!s.bad) {
        //Phagocytic sound effect
        eat.rewind();
        eat.play();
        iterator.remove();
        score++;
      }else {
        over.play();
        noLoop();
        gameover();
      }
    }
  }
  
  //for (Star s: stars){
  //  s.show();
  //  s.move();
  //  if(s.checkCollision(p)) {
  //    stars.remove(0);
  //  }
  //}
}
void stars() {
  loadPixels();
  for (int x = 0; x < width; x += 92) {
    for (int y = 0; y < (height / 1.5); y += 92) {
      int h = 0;
      int s = 0;
      float i = random(1);
      if (x * y % 2 == 0) {
        h = i > 0.5 ? round(random(0, 60)) : round(random(180, 270));
        s = 128;
      }
      fill(h,s,255,255);
      rect(x + random(-92,92), y + random(-92,92), random(1, 2), random(1, 2));
    }
  }
}

//background
void bg(){
  fill(0, 0, 0, 16);
  rect(0, 0, width, height);
  //Stars in the background
  stars();
  noStroke();
   
  for (float g = 0; g < 1.0; g += 1.0 / OBJ) {
    float gn = 1-abs(0.5 - g) * 2;
    fill(90 + (gn * 16 * xmotion * 16) % 270, 128, gn > 0.4 ? 255 * gn : 255, (1-gn) * 24);
    
    noStroke();
    
    if (gn <= 0.5) {
      strokeWeight(24 * (1-g));
      stroke(0, 0, 0, 255 * (g / 16));
    }

    beginShape();
    for (float p = 0; p < 1.01; p += 1.0 / PTS) {
      float d = pow(3.25, (1-p) * 4);

      float y = p * width;
      float x = noise(p * 8 + sin(xmotion)) * (2 * d) * (gn * 8) + pow(2,gn);

      vertex(y, height / 2 - x + d - 130);
    }

    for (float p = 0; p < 1.01; p += 1.0 / PTS) {
      float d = pow(3.25, p * 4);

      float y = (1.0 - p) * width;
      float x = noise(p * 8 + pow(2,cos(xmotion))) * d * (gn * 8) + gn * 100;

      vertex(y, 6 + height / 2 + x + d -130);
    }
    endShape(CLOSE);
    
    noStroke();
   }
 
 xmotion += 0.018;
 ymotion += 0.008;
 smotion += 0.001;
}
void mousePressed() {

  p.jump();
}

void gameover() {
  push();
  rectMode(CENTER);
  strokeWeight(10);
  stroke(#66CDAA);
  fill(#00EEEE,220);
  rect(width/2,height/2,800,300,30);
  textAlign(CENTER);
  textSize(28);
  fill(  #FFF68F);
  text("This black hole devours you and your dreams!",width/2, 280);
  textSize(24);
  text("This is my project 1, thank you for your visit! I hope you like it.",width/2, 330);
  textSize(36);
  text("The number of stars you devour is " + score,width/2, 450);

  pop();
}
