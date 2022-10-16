import gifAnimation.*;

Gif fireGif;

PFont f;
PImage backgroundImg, msClearImg, fireImg, firefighterImg, waterImg, fireEngineImg, mouseImg, cloudImg, msFailedImg;
Fire[] fires = new Fire[100];
int num; //남은 불
int j = 10; //초기 불
int floor = 3;
float x = width/2;
float t = 0; //불 번짐 시간
float time = 0; //경과 게임 시간
float playTime = 60; // 게임 시간
int score = 500; //초기 점수

void setup() {
  size(1080, 720);
  backgroundImg = loadImage("background2.jpeg");
  msClearImg = loadImage("missionClear.jpg");
  msFailedImg = loadImage("missionFailed.jpg");
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
  t += 0.1;
  time += 0.1;

  imageMode(CENTER);

  textFont(f, 50);
  fill(0);
  textAlign(CENTER);

  for (int i = 0; i < j; i++)  //초기 불
    fires[i].setShow();

  for (int i = 0; i < fires.length; i++)
    if (fires[i].power != 0 && fires[i].show)
      num ++; //꺼지지 않은 불 개수 세기

  if (num != 0 && time < playTime) {                               //게임 진행중
    image(backgroundImg, width/2, height/2);
    for (int i = 0; i < fires.length; i++) {
      fires[i].drawFires(fireGif);
      if (fires[i].show && fires[i].power > 0 && t > 3) { //안꺼진 불 존재, 일정 시간 지남, show = false인 array 칸 존재
        if (!fires[j].show && j < fires.length) {
          fires[j].reposition(fires[i].posX, fires[i].posY, fires[i].power);
          fires[j].setShow(); //불 번짐
        }
        if (score < 100) //스코어 감소
          score = 0;
        else
          score -= 100;
        t = 0;
        j++;
      }
    }
    textFont(f, 20);                                              //점수, 시간 등 표기
    textAlign(CENTER);
    text("You can get in the fire engine by pressing 'e' when you are on the 1st floor.", width/2, 50);
    textFont(f, 30);
    textAlign(RIGHT);
    text("SCORE: " + score, width-10, 50);
    textAlign(LEFT);
    text("TIME: " + nf((playTime - time), 0, 1), 10, 50);

    if (floor == 1)                                                //마우스로 캐릭터 이동
      image(mouseImg, mouseX, 50 + 150*floor, 215, 115);
    else if (floor == 2)
      image(mouseImg, mouseX, 50 + 150*floor, 215, 115);
    else if (floor == 3)
      image(mouseImg, mouseX, 50 + 150*floor, 215, 115);
  } else if (time > playTime && num != 0) {                       //미션 실패
    image(msFailedImg, width/2, height/2);
    image(mouseImg, mouseX, mouseY, 215, 115);
  } else if (num == 0) {                                         //미션 성공
    //else {
    image(msClearImg, width/2, height/2);
    text("SCORE: " + score, width/2, height/2 + 150);
    image(mouseImg, mouseX, mouseY, 215, 115);
  }

  image(cloudImg, x, height/2 + 50); //구름 이동
  x -= 1;
  if (x < -500)
    x = width+500;
}

void mouseClicked() {
  if (mouseButton == LEFT && num != 0 && time < playTime) { //클릭, 게임 진행중일 때
    for (int i = 0; i < fires.length; i++) {
      if (mouseImg == firefighterImg) { //불 끄기 - 소방관
        if (abs(fires[i].posX - mouseX) < fires[i].power && abs(fires[i].posY - (50 + 150*floor)) < fires[i].power) {
          fires[i].hit();
          score += 50;
        }
      } else { //불 끄기 - 소방차
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
  }
}

void keyPressed() {
  if (key == 'e' && (floor == 3 || num == 0)) { //소방관 <-> 소방차
    if (mouseImg == firefighterImg) {
      mouseImg = fireEngineImg;
    } else {
      mouseImg = firefighterImg;
    }
  }
  if (key=='w' && mouseImg == firefighterImg) { //위층 이동(소방관)
    if (floor > 1)
      floor -= 1;
  }
  if (key=='s' && mouseImg == firefighterImg) { //아래층 이동(소방관)
    if (floor < 3)
      floor += 1;
  }
  if (key == 'h') { //main 이동
  }
}
