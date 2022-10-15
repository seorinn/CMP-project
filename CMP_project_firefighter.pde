import gifAnimation.*;

Gif fireGif;

PFont f;
PImage backgroundImg, msCompleteImg, fireImg, firefighterImg, waterImg, fireEngineImg, mouseImg, cloudImg, msFailImg;
Fire[] fires = new Fire[50];
int num, j;
int floor = 3;
float x = width/2;
float t = 0;
float time = 0;
int score = 500;

void setup() {
  size(1080, 720);
  backgroundImg = loadImage("background2.jpeg");
  msCompleteImg = loadImage("missionComplete.jpg");
  msFailImg = loadImage("missionFailed.jpg");
  firefighterImg = loadImage("firefighter.png");
  waterImg = loadImage("water.png");
  fireEngineImg = loadImage("fireEngine.png");
  cloudImg = loadImage("cloud.png");

  mouseImg = firefighterImg;

  fireGif = new Gif(this, "fire.gif");
  fireGif.play();

  f = createFont("Arial", 16, true);

  for (int i = 0; i < fires.length; i++) {
    fires[i] = new Fire();
  }
}

void draw() {
  frameRate(60);
  background(0);

  num = 0;
  j = 10;
  t += 0.1;
  time += 0.05;

  imageMode(CENTER);

  textFont(f, 50);
  fill(0);
  textAlign(CENTER);

  for (int i = 0; i < fires.length; i++) {
    if (fires[i].power != 0 && fires[i].show == true) {
      num ++;
      if (num != 0) {
        image(backgroundImg, width/2, height/2);
        if (floor == 1)
          image(mouseImg, mouseX, 50 + 150*floor, 215, 115);
        else if (floor == 2)
          image(mouseImg, mouseX, 50 + 150*floor, 215, 115);
        else if (floor == 3)
          image(mouseImg, mouseX, 50 + 150*floor, 215, 115);
      }
    }
    if (num == 0) {
      float tmp = time;
      image(msCompleteImg, width/2, height/2);
      text("SCORE: " + score, width/2, height/2 + 100);
      image(mouseImg, mouseX, mouseY, 215, 115);
    }
  }

  image(cloudImg, x, height/2 + 50);
  x -= 1;
  if (x < -500)
    x = width+500;

  for (int i = 0; i < 10; i++) {
    fires[i].setShow();
  }

  for (int i = 0; i < fires.length; i++) {
    if (fires[i].show)
      fires[i].drawFires(fireGif);
    if (fires[i].show && fires[i].power > 0 && t > 3) {
      if (!fires[j].show && j < fires.length) {
        fires[j].reposition(fires[i].posX, fires[i].posY, fires[i].power);
        fires[j].setShow();
        if (score < 100)
          score = 0;
        else
          score -= 100;
        t = 0;
      }
      j++;
    }
  }

  if (time < 30 && num != 0) {
    textFont(f, 20);
    textAlign(CENTER);
    text("You can get in the fire engine by pressing 'e' when you are on the 1st floor.", width/2, 50);
    textFont(f, 30);
    textAlign(RIGHT);
    text("SCORE: " + score, width-10, 50);
    textAlign(LEFT);
    text("TIME: " + nf((30 - time), 0, 1), 10, 50);
  } else if (time > 30 && num != 0)
    image(msFailImg, width/2, height/2);
}

void mouseClicked() {
  if (mouseButton == LEFT && num != 0) {
    for (int i = 0; i < fires.length; i++) {
      if (mouseImg == firefighterImg) {
        if (abs(fires[i].posX - mouseX) < fires[i].power && abs(fires[i].posY - (50 + 150*floor)) < fires[i].power) {
          fires[i].hit();
          score += 50;
        }
      } else {
        rectMode(CENTER);
        noStroke();
        fill(135, 206, 235);
        rect(mouseX, 50 + 150*floor+ 115/2 - 5, 500, 10);
        if (abs(fires[i].posY - (50 + 150 * floor)) < fires[i].power && fires[i].posX > mouseX-250 && fires[i].posX < mouseX+250)
          fires[i].hit();
        score += 50;
      }
    }
    frameRate(5);
    image(waterImg, mouseX, 50 + 150*floor, 215, 115);
    image(mouseImg, mouseX, 50 + 150*floor, 215, 115);
    //tmp = time;
  }
}

void keyPressed() {
  if (key == 'e' && (floor == 3 || num == 0)) {
    if (mouseImg == firefighterImg) {
      mouseImg = fireEngineImg;
    } else {
      mouseImg = firefighterImg;
    }
  }
  if (key=='w' && mouseImg == firefighterImg) {
    if (floor > 1)
      floor -= 1;
  }
  if (key=='s' && mouseImg == firefighterImg) {
    if (floor < 3)
      floor += 1;
  }
}
