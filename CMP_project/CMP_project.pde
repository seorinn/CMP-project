import ddf.minim.*;
import processing.sound.*;
import gifAnimation.*;

DoctorPage dp;
FirefighterPage fp;
PainterPage pp;
CarPage cp;

Gif fireGif;
SoundFile heartBeat;
SoundFile bgm;
Minim minim= new Minim(this);
AudioPlayer song, crash, boost, ghostsound, handling, beep;
PImage mainImg, homeImg, optionImg, creditImg;
boolean home, option, credit;
boolean mainPage = true;
int ppPage = 0;
float bgmvol = 1;

void setup() {
  size(1080, 720);
  background(255);
  heartBeat = new SoundFile(this, "heartbeat.wav");
  bgm = new SoundFile(this, "Calimba - E's Jammy Jams.mp3");
  mainImg = loadImage("mainBackground1.png");
  homeImg = loadImage("mainBackground2.png");
  optionImg = loadImage("option.png");
  creditImg = loadImage("credits.png");
  displayMain();
  bgm.play();
  fireGif = new Gif(this, "fire.gif");
  fireGif.play();
}

void draw() {
  frameRate(60);
  if (home)
    displayMenu();
  if (option)
    image(optionImg, 0, 0);
  if (credit)
    image(creditImg, 0, 0);
  if (dp != null) {            //doctor
    if (dp.endo) {
      dp.endoscope();
    } else if (dp.xray) {
      dp.x_ray();
    } else if (dp.heartRoom) {
      dp.goHeartRoom();
    } else if (dp.medicineRoom) {
      dp.goMedicineRoom();
    }
  } else if (fp != null) {      //firefighter
    if (fp.playing)
      fp.playing(fireGif);
    else if (fp.missionFailed)
      fp.missionFailed();
    else if (fp.missionClear)
      fp.missionClear();
    textSize(25);
    textAlign(RIGHT);
    text("h = home", width-10, height-40);
  } else if (pp != null) {      //painter
    if (ppPage == 0) {
      pp.paintDraw();
    } else if (ppPage == 1) {
      pp.displayDraw();
    }
  } else if (cp != null&&cp.over==false) { // car racer
    cp.play();
  }
}

//main window
void displayMain() {
  image(mainImg, 0, 0);
}

//menu window that select job
void displayMenu() {
  mainPage = false;
  image(homeImg, 0, 0);
  textAlign(BASELINE);
  home = true;
}

void keyPressed() {
  if (mainPage)        //press any key to start application
    displayMenu();
  else if (home && key == CODED) {
    if (keyCode == RIGHT) {    //create doctor object
      dp = new DoctorPage();
      dp.selectMenu();
      bgm.pause();
      home = false;
    } else if (keyCode == LEFT) {    //create firefighter object
      fp = new FirefighterPage();
      fp.setFire();
      fp.playing(fireGif);
      bgm.pause();
      home = false;
    } else if (keyCode == UP) {    //create painter object
      pp = new PainterPage();
      pp.setPaint();
      bgm.pause();
      home = false;
    } else if (keyCode == DOWN) {  //create car racer object
      cp= new CarPage();
      cp.set();//car page
      bgm.pause();
      home=false;
    }
  }
  if (home && key == 'o') {    //option key
    if (option)
      option = false;
    else
      option = true;
  }
  if (option) {
    //change volume
    if (key=='1') {
      bgmvol-=0.1;
      bgmvol = constrain(bgmvol, 0.1, 0.9);
      bgm.amp(bgmvol);
    } else if (key=='2') {
      bgmvol+=0.1;
      bgmvol = constrain(bgmvol, 0.1, 0.9);
      bgm.amp(bgmvol);
    } else if (key == 'q')    //exit application
      exit();
    else if (key == 'c') {    //show credit
      if (credit)
        credit = false;
      else
        credit = true;
    }
  }
  if (dp!=null) {
    if (dp.xrayRoom) {
      if (key == 'a') {   //endoscope mode
        dp.endo = true;
        dp.xray = false;
      } else if (key == 's') {  //x-ray mode
        dp.xray = true;
        dp.endo = false;
      }
    }
    //go menu key in doctor page
    if (key == 'm') {
      dp.endo = false;
      dp.xray = false;
      dp.xrayRoom = false;
      dp.heartRoom = false;
      dp.medicineRoom = false;
      dp.submit = false;
      dp.cough = false;
      dp.fever = false;
      dp.headache = false;
      dp.runnyNose = false;
      dp.throatHurt = false;
      if (heartBeat.isPlaying())
        heartBeat.pause();
      dp.selectMenu();
    }
    if (dp.select_Menu && key == 'h') {  //go to select job menu window
      home = true;
      bgm.play();
      dp = null;
    }
  } else if (fp != null) {
    if (key == 'e' && (fp.floor == 3 || fp.missionFailed || fp.missionClear)) { //소방관 <-> 소방차
      if (fp.mouseImg == fp.firefighterImg)
        fp.mouseImg = fp.fireEngineImg;
      else
        fp.mouseImg = fp.firefighterImg;
    }
    if (key=='w' && fp.playing && fp.mouseImg == fp.firefighterImg) { //위층 이동(소방관)
      if (fp.floor > 1)
        fp.floor -= 1;
    }
    if (key=='s' && fp.playing && fp.mouseImg == fp.firefighterImg) { //아래층 이동(소방관)
      if (fp.floor < 3)
        fp.floor += 1;
    }
    if (key == ' ' && (fp.pause || fp.playing) ) {
      if (!fp.pause) {
        fp.pause = true;
        fp.playing = false;
        image(fp.pauseImg, 0, 0);
        fp.d = abs(fp.s-fp.e);
      } else {
        fp.pause = false;
        fp.playing = true;
        fp.s = millis();
      }
    } else if (key == 'a' && (fp.missionFailed || fp.missionClear)) {
      fp = null;
      fp = new FirefighterPage();
      fp.setFire();
      fp.playing(fireGif);
    }
    if (key == 'h') {
      home = true;
      bgm.play();
      fp = null;
    }
  } else if (pp != null) {
    if (ppPage == 0) {
      if (key == CODED) {
        if (keyCode == RIGHT) {
          pp.penIncre();
        } else if (keyCode == LEFT) {
          pp.penDecre();
        } else if (keyCode == UP) {
          pp.penColorUp();
        } else if (keyCode == DOWN) {
          pp.penColorDown();
        }
      } else if (key == 'n'|| key == 'N') {
        pp.newPaint();
      } else if (key == 's' || key == 'S') {
        pp.saveImage();
      }
    }
    if (key == 'd' || key == 'D') {
      if (ppPage == 0) {
        ppPage = 1;
        pp.paintToDis();
      } else {
        ppPage = 0;
        pp.disToPaint();
      }
    }
    if (key == 'h') {
      imageMode(CORNER);
      home = true;
      bgm.play();
      pp = null;
    }
  } else if (cp != null) {
    if (cp.over&&key=='r') {
      cp.reset();
      cp.over=false;
      loop();
    }
    if (key=='h') {
      imageMode(CORNER);
      song.pause();
      bgm.play();
      home=true;
      cp=null;
    }
  }
}

void mousePressed() {
  if (dp != null) {
    if (dp.select_Menu) {  //menu select with mouse click in doctor page
      if (dist(mouseX, mouseY, 157, 624) <= 85) {
        dp.xrayRoom = true;
        dp.goXrayRoom();
      } else if (dist(mouseX, mouseY, 387, 624) <= 75) {
        dp.heartRoom = true;
        heartBeat.loop();
      } else if (dist(mouseX, mouseY, 617, 624) <= 80)
        dp.medicineRoom = true;
    }
    if (dp.medicineRoom) {    //check items for prescription
      if (dist(mouseX, mouseY, 455, 345) <= 10)
        dp.cough = true;
      if (dist(mouseX, mouseY, 530, 345) <= 10)
        dp.cough = false;
      if (dist(mouseX, mouseY, 455, 400) <= 10)
        dp.fever = true;
      if (dist(mouseX, mouseY, 530, 400) <= 10)
        dp.fever = false;
      if (dist(mouseX, mouseY, 455, 465) <= 10)
        dp.headache = true;
      if (dist(mouseX, mouseY, 530, 465) <= 10)
        dp.headache = false;
      if (dist(mouseX, mouseY, 455, 520) <= 10)
        dp.runnyNose = true;
      if (dist(mouseX, mouseY, 530, 520) <= 10)
        dp.runnyNose = false;
      if (dist(mouseX, mouseY, 455, 580) <= 10)
        dp.throatHurt = true;
      if (dist(mouseX, mouseY, 530, 580) <= 10)
        dp.throatHurt = false;
      if ( (525 < mouseY && mouseY < 650) && (700 < mouseX && mouseX < 1020))
        dp.submit = true;
    }
  } else if (fp != null && fp.playing) {
    for (int i = 0; i < fp.fires.length; i++) {
      if (fp.mouseImg == fp.firefighterImg) { //불 끄기 - 소방관
        if (abs(fp.fires[i].posX - mouseX) < fp.fires[i].power && abs(fp.fires[i].posY - (50 + 150*fp.floor)) < fp.fires[i].power) {
          fp.fires[i].hit();
          fp.score += 50;
        }
      } else { //불 끄기 - 소방차
        rectMode(CENTER);
        noStroke();
        fill(135, 206, 235);
        rect(mouseX, 50 + 150*fp.floor+ 115/2 - 5, 500, 10);
        if (abs(fp.fires[i].posY - (50 + 150 * fp.floor)) < fp.fires[i].power && fp.fires[i].posX > mouseX-250 && fp.fires[i].posX < mouseX+250) {
          fp.fires[i].hit();
          fp.score += 50;
        }
      }
    }
    frameRate(10);
    image(fp.waterImg, mouseX - 215/2, 50 + 150*fp.floor - 115/2, 215, 115);
    image(fp.mouseImg, mouseX - 215/2, 50 + 150*fp.floor -115/2, 215, 115);
  }
}

void mouseDragged() {
  if (pp != null) {
    if (ppPage == 0) {
      pp.drawLine();
    }
  }
}

void mouseReleased() {
  if (pp != null) {
    pp.releaseMouse();
  }
}
