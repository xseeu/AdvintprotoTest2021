var balls = [];
let serial;
let latestData = "waiting for data";

function setup() {
  createCanvas(windowWidth, windowHeight);

  serial = new p5.SerialPort();

  serial.list();
  serial.open('/dev/tty.usbmodem14601');
  serial.on('connected', serverConnected);
  serial.on('list', gotList);
  serial.on('data', gotData);
  serial.on('error', gotError);
  serial.on('open', gotOpen);
  serial.on('close', gotClose);
}

function serverConnected() {
  print("Connected to Server");
}

function gotList(thelist) {
  print("List of Serial Ports:");

  for (let i = 0; i < thelist.length; i++) {
    print(i + " " + thelist[i]);
  }
}

function gotOpen() {
  print("Serial Port is Open");
}

function gotClose() {
  print("Serial Port is Closed");
  latestData = "Serial Port is Closed";
}

function gotError(theerror) {
  print(theerror);
}

function gotData() {
  var currentString = serial.read();
  let x = random(windowWidth);
  let y = random(windowHeight)
  if(currentString == 0) {
    
      for (var i = 0; i < 50; i++) {
    var ball = new Ball(x, y, 2);
    balls.push(ball);
  }
  }
  if (!currentString) return;

  latestData = currentString;
}

function draw() {
  background(0,20);
  for (var i = 0; i < balls.length; i++) {
    balls[i].update();
    balls[i].render();
  }
  for (var j = balls.length - 1; j >= 0; j--) {
    if(balls[j].alive == false) {
      balls.splice(j,1);
    }
  }
}

function Ball(xpos, ypos, ballSize) {
  this.pos = createVector(xpos, ypos);
  this.vel = p5.Vector.random2D();
  this.vel.setMag(random(1, 5));
  this.size = ballSize;
  this.alive = true;
  this.c = color(100, random(255), random(255));
  this.update = function() {
    this.pos.add(this.vel);
    if (this.pos.x <= 15) {
      this.c = color(100, random(255), random(150,255));
      this.alive = false;
    }
    if (this.pos.x >= width - this.size * 0.5) {
      this.c = color(random(255), random(255), random(255));
      this.alive = false;
    }
    if (this.pos.y <= 15) {
      this.c = color(random(255), random(255), random(255));
      this.alive = false;
    }
    if (this.pos.y >= height - this.size * 0.5) {
      this.c = color(random(255), random(255), random(255));
      this.alive = false;
    }
  }
  
  this.render = function() {
    fill(this.c);
    noStroke();
    ellipse(this.pos.x, this.pos.y, this.size);
  }
}