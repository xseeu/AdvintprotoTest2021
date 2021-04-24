//ML库，posenet识别身体
let video
let serial;
let poseNet;
let flag;
let poses = [];

var MAX_PARTICLES = 5000;
var COLORS = ['#69D2E7', '#27DBD8', '#50E46C', '#3386FF', '#FA69FA', '#FF4E50', '#F9D423'];
var particles = [];
var pool = [];
var wander1 = 0.5;
var wander2 = 2.0;
var drag1 = .9;
var drag2 = .79;
var force1 = 2;
var force2 = 9;
var theta1 = -0.5;
var theta2 = 0.5;
var size1 = 5;
var size2 = 180;
var sizeScalar = 0.97;

function Particle(x, y, size) {
    this.alive = true;
    this.size = size || 10;
    this.wander = 0.15;
    this.theta = random(TWO_PI);
    this.drag = 0.92;
    this.color = "#FFFFFF";
    this.location = createVector(x, y);
    this.velocity = createVector(0.0, 0.0);
}
Particle.prototype.move = function () {
    this.location.add(this.velocity);
    this.velocity.mult(this.drag);
    this.theta += random(theta1, theta2) * this.wander;
    this.velocity.x += sin(this.theta) * 0.1;
    this.velocity.y += cos(this.theta) * 0.1;
    this.size *= sizeScalar;
    this.alive = this.size > 0.5;
}
Particle.prototype.show = function () {
    fill(this.color);
    noStroke();
    ellipse(this.location.x, this.location.y, this.size, this.size);
}

function spawn(x, y) {
    var particle, theta, force;
    if (particles.length >= MAX_PARTICLES) {
        pool.push(particles.shift());
    }
    particle = new Particle(x, y, map(noise(frameCount * 0.001, mouseX * 0.01, mouseY * 0.01), 0, 1, size1, size2));
    particle.wander = random(wander1, wander2);
    particle.color = random(COLORS);
    particle.drag = random(drag1, drag2);
    theta = random(TWO_PI);
    force = random(force1, force2);
    particle.velocity.x = sin(theta) * force;
    particle.velocity.y = cos(theta) * force;
    particles.push(particle);
}

function update() {
    var i, particle;
    for (i = particles.length - 1; i >= 0; i--) {
        particle = particles[i];
        if (particle.alive) {
            particle.move();
        } else {
            pool.push(particles.splice(i, 1)[0]);
        }
    }
}

function moved(x, y) {
    var particle, max, i;
    max = random(1, 4);
    for (i = 0; i < max; i++) {
        spawn(x, y);
    }
}

function serverConnected() {
    print("We are connected!");
}

function gotList(thelist) {
    for (let i = 0; i < thelist.length; i++) {
        print(i + " " + thelist[i]);
    }
}

function gotOpen() {
    print("Serial Port is open!");
}

function gotError(theerror) {
    print(theerror);
}

function gotData() {
    var inData = serial.readLine();
}

function setup() {
    createCanvas(windowWidth, windowHeight);
    cursor("none");
    colorMode(HSB, 255);
    background(0);
    serial = new p5.SerialPort();
    let portlist = serial.list();
    serial.open("/dev/tty.usbmodem14401");
    serial.on('connected', serverConnected);
    serial.on('list', gotList);
    serial.on('data', gotData);
    serial.on('error', gotError);
    serial.on('open', gotOpen);
    video = createCapture(VIDEO);
    video.size(width, height);

    let options = {
        imageScaleFactor: 0.3, 
        flipHorizontal: true,
        minConfidence: 0.5,
        maxPoseDetections: 1,
        scoreThreshold: 0.5,
        detectionType: 'single',
    }

    poseNet = ml5.poseNet(video, options, modelReady);


    poseNet.on('pose', function (results) {
        poses = results;
    });
    video.hide();
}

function modelReady() {
    print("ready");
}

function draw() {
    if (serial.available() > 0) {
        sData = serial.readString();
        if (sData > 0 && sData <= 1) {
            print(sData);
            sizeScalar = map(sData, 0.1, 1, 0.85, 0.999);
        }
    }
    a1 = returnKeypoints();
    update();
    background(0, 32);
    for (var i = particles.length - 1; i >= 0; i--) {
        particles[i].show();
    }
    if (a1 != undefined) {
        moved(a1[0], a1[1]);
    }
}

function returnKeypoints() {
    for (let i = 0; i < poses.length; i++) { 
        let pose = poses[i].pose;

        for (let j = 0; j < pose.keypoints.length; j++) {
            let keypoint = pose.keypoints[j]; 
            if (keypoint.score > 0.3) { 
                let arr = [keypoint.position.x, keypoint.position.y]
                return arr
            }
        }
    }
}