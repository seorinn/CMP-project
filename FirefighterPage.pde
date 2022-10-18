//import gifAnimation.*;

class FirefighterPage {
  PImage backgroundImg = loadImage("background2.jpeg");
  PImage msClearImg = loadImage("missionClear.jpg");
  PImage msFailedImg = loadImage("missionFailed.jpg");
  PImage firefighterImg = loadImage("firefighter.png");
  PImage waterImg = loadImage("water.png");
  PImage fireEngineImg = loadImage("fireEngine.png");
  PImage cloudImg = loadImage("cloud.png");
  PImage pauseImg = loadImage("pause.png");
  PImage mouseImg = firefighterImg;

  Fire[] fires = new Fire[100];

  int num; //남은 불
  int j = 10; //초기 불
  int floor = 3;
  float x = 0;
  float t = 0; //불 번짐 시간
  float time = 0; //경과 게임 시간
  float playTime = 60; // 게임 시간
  int score = 500;

  boolean playing, pause, missionFailed, missionClear;

  void setFire() {
    for (int i = 0; i < fires.length; i++)
      fires[i] = new Fire();
  }

  void playing(Gif img) {
    playing = true;
    image(backgroundImg, 0, 0);

    num = 0;
    t += 0.1;
    time += 0.1;

    for (int i = 0; i < j; i++)  //초기 불
      fires[i].setShow();

    for (int i = 0; i < fires.length; i++)
      if (fires[i].power != 0 && fires[i].show)
        num ++; //꺼지지 않은 불 개수 세기

    if (num != 0 && time > playTime) {
      playing = false;
      missionFailed();
    } else if (num == 0) {
      playing = false;
      missionClear();
    }

    image(cloudImg, x, 0); //구름 이동
    x -= 1;
    if (x < -width)
      x = width;

    for (int i = 0; i < fires.length; i++) {
      fires[i].drawFires(img);
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
    if (floor == 1)                                                //마우스로 캐릭터 이동
      image(mouseImg, mouseX-215/2, 50 + 150*floor-115/2, 215, 115);
    else if (floor == 2)
      image(mouseImg, mouseX-215/2, 50 + 150*floor-115/2, 215, 115);
    else if (floor == 3)
      image(mouseImg, mouseX-215/2, 50 + 150*floor-115/2, 215, 115);

    textSize(30);
    text("spacebar = pause", width-10, height-100);

    fill(0);
    textSize(20);        //점수, 시간 등 표기
    textAlign(CENTER);
    text("You can get in the fire engine by pressing 'e' when you are on the 1st floor.", width/2, 50);
    textSize(30);
    textAlign(RIGHT);
    text("SCORE: " + score, width-10, 50);
    textAlign(LEFT);
    text("TIME: " + nf((playTime - time), 0, 1), 10, 50);
  }

  void missionFailed() {
    playing = false;
    missionFailed = true;
    image(msFailedImg, 0, 0);
    image(mouseImg, mouseX-215/2, mouseY-115/2, 215, 115);
    image(cloudImg, x, 0); //구름 이동
    x -= 1;
    if (x < -width)
      x = width;
    textSize(30);
    textAlign(RIGHT);
    text("a = play again", width-10, height-100);
  }

  void missionClear() {
    playing = false;
    missionClear = true;
    image(msClearImg, 0, 0);
    textSize(50);
    textAlign(CENTER);
    text("SCORE: " + score, width/2, height/2 + 150);
    image(mouseImg, mouseX-215/2, mouseY-115/2, 215, 115);
    image(cloudImg, x, 0); //구름 이동
    x -= 1;
    if (x < -width)
      x = width;
    textSize(30);
    textAlign(RIGHT);
    text("a = play again", width-10, height-100);
  }
}
