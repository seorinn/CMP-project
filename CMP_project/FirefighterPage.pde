class FirefighterPage {
  PImage backgroundImg = loadImage("backgroundF.jpeg");
  PImage msClearImg = loadImage("missionClear.jpg");
  PImage msFailedImg = loadImage("missionFailed.jpg");
  PImage firefighterImg = loadImage("firefighter.png");
  PImage waterImg = loadImage("water.png");
  PImage fireEngineImg = loadImage("fireEngine.png");
  PImage cloudImg = loadImage("cloud.png");
  PImage pauseImg = loadImage("pause.png");
  PImage mouseImg = firefighterImg;

  Fire[] fires = new Fire[100];

  int num; //num of fire left
  int j = 10; //num of fire at first
  int floor = 3;
  float x = 0;
  float t = 0; //time for fire spread
  float time = 0; //time from start
  float playTime = 20; // total time
  int score = 500;
  int s = millis();
  int e;
  int d = 0;

  boolean playing, pause, missionFailed, missionClear;

  void setFire() {
    for (int i = 0; i < fires.length; i++)
      fires[i] = new Fire();
  }

  void playing(Gif img) {
    e = millis();
    playing = true;
    image(backgroundImg, 0, 0);

    num = 0;
    t += 0.1;
    time += 0.1;

    for (int i = 0; i < j; i++)  //set num of fires when started
      fires[i].setShow();

    for (int i = 0; i < fires.length; i++)
      if (fires[i].power != 0 && fires[i].show)
        num ++; //count fire left

    if (num != 0 && (abs(s-e)+d)/1000 > playTime) {
      playing = false;
      missionFailed();
    } else if (num == 0) {
      playing = false;
      missionClear();
    }

    image(cloudImg, x, 0); //clouds
    x -= 1;
    if (x < -width)
      x = width;

    for (int i = 0; i < fires.length; i++) {
      fires[i].drawFires(img);
      if (fires[i].show && fires[i].power > 0 && t > 3) { // fires are left && time out && there is area that show=false
        if (!fires[j].show && j < fires.length) {
          fires[j].reposition(fires[i].posX, fires[i].posY, fires[i].power);
          fires[j].setShow(); //fire spread
        }
        if (score < 100) //score decrease
          score = 0;
        else
          score -= 100;
        t = 0;
        j++;
      }
    }
    if (floor == 1)                                                //moving character with mouse
      image(mouseImg, mouseX-215/2, 50 + 150*floor-115/2, 215, 115);
    else if (floor == 2)
      image(mouseImg, mouseX-215/2, 50 + 150*floor-115/2, 215, 115);
    else if (floor == 3)
      image(mouseImg, mouseX-215/2, 50 + 150*floor-115/2, 215, 115);

    textSize(25);
    text("spacebar = pause", width-10, height-80);
    text("w/s = up/down", width-10, height-120);

    fill(0);
    textSize(20);        //showing score and time
    textAlign(CENTER);
    text("You can get in the fire engine by pressing 'e' when you are on the 1st floor.", width/2, 50);
    textSize(30);
    textAlign(RIGHT);
    text("SCORE: " + score, width-10, 50);
    textAlign(LEFT);
    text("TIME: " + nf((playTime - (abs(s-e)+d)/1000), 0, 1), 10, 50);
  }

  void missionFailed() {
    playing = false;
    missionFailed = true;
    image(msFailedImg, 0, 0);
    image(mouseImg, mouseX-215/2, mouseY-115/2, 215, 115);
    image(cloudImg, x, 0); //clouds
    x -= 1;
    if (x < -width)
      x = width;
    textSize(25);
    textAlign(RIGHT);
    text("a = play again", width-10, height-80);
  }

  void missionClear() {
    playing = false;
    missionClear = true;
    image(msClearImg, 0, 0);
    textSize(50);
    textAlign(CENTER);
    text("SCORE: " + score, width/2, height/2 + 150);
    image(mouseImg, mouseX-215/2, mouseY-115/2, 215, 115);
    image(cloudImg, x, 0); //clouds
    x -= 1;
    if (x < -width)
      x = width;
    textSize(25);
    textAlign(RIGHT);
    text("a = play again", width-10, height-80);
  }
}
