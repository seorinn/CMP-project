import processing.sound.*;
import gifAnimation.*;

DoctorPage dp;
FirefighterPage fp;

Gif fireGif;
SoundFile heartBeat;
PImage backHome;
boolean home = true;

void setup() {
  size(1080, 720);
  background(255);
  heartBeat = new SoundFile(this, "heartbeat.wav");
  backHome = loadImage("backHome.png");
  home();

  fireGif = new Gif(this, "fire.gif");
  fireGif.play();
}

void draw() {
  frameRate(30);
  if (dp != null) {
    if (dp.endo) {
      dp.endoscope();
    } else if (dp.xray) {
      dp.x_ray();
    } else if (dp.heartRoom) {
      dp.goHeartRoom();
    } else if (dp.medicineRoom) {
      dp.goMedicineRoom();
    }
  } else if (fp != null) {
    //fp.num = 0;
    //fp.t += 0.1;
    //fp.time += 0.1;

    if (fp.playing) {
      fp.playing(fireGif);
    } else if (fp.missionFailed) {
      fp.missionFailed();
    } else if (fp.missionClear) {
      fp.missionClear();
    }
  }
  //else if (pp != null) {
  //} else if (cp != null) {
  //}
}

void home() {
  home = true;
  image(backHome, 0, 0);
  textSize(100);
  fill(205, 205, 100);
  textAlign(BASELINE);
  text("dreams come true!", 160, 300);
}

void keyPressed() {
  if (key == CODED && home) {
    if (keyCode == RIGHT) {
      dp = new DoctorPage();
      dp.selectMenu();
      home = false;
    } else if (keyCode == LEFT) {
      fp = new FirefighterPage();
      fp.setFire();
      fp.playing(fireGif);
      home = false;
    }
    //else if (keyCode == UP) {
    //} else if (keyCode == DOWN) {
    //}
  }
  if (dp!=null) {
    if (dp.xrayRoom) {
      if (key == 'a') {
        dp.endo = true;
        dp.xray = false;
      } else if (key == 's') {
        dp.xray = true;
        dp.endo = false;
      }
    }
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
    if (dp.select_Menu && key == 'h') {
      home();
      dp = null;
    }
  } else if (fp != null) {
    if (fp.playing) {
      if (key == 'e' && (fp.floor == 3 || fp.num == 0)) { //소방관 <-> 소방차
        if (fp.mouseImg == fp.firefighterImg) {
          fp.mouseImg = fp.fireEngineImg;
        } else {
          fp.mouseImg = fp.firefighterImg;
        }
      }
      if (key=='w' && fp.mouseImg == fp.firefighterImg) { //위층 이동(소방관)
        if (fp.floor > 1)
          fp.floor -= 1;
      }
      if (key=='s' && fp.mouseImg == fp.firefighterImg) { //아래층 이동(소방관)
        if (fp.floor < 3)
          fp.floor += 1;
      }
    }
    if (key == 'h') {
      home();
      fp = null;
    }
  }
  //else if(pp != null){}
  //else if(cp != null){}
}

void mousePressed() {
  if (dp != null) {
    if (dp.select_Menu) {
      if (dist(mouseX, mouseY, 157, 624) <= 85) {
        dp.xrayRoom = true;
        dp.goXrayRoom();
      } else if (dist(mouseX, mouseY, 387, 624) <= 75) {
        dp.heartRoom = true;
        heartBeat.loop();
      } else if (dist(mouseX, mouseY, 617, 624) <= 80)
        dp.medicineRoom = true;
    }
    if (dp.medicineRoom) {
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
        if (abs(fp.fires[i].posY - (50 + 150 * fp.floor)) < fp.fires[i].power && fp.fires[i].posX > mouseX-250 && fp.fires[i].posX < mouseX+250)
          fp.fires[i].hit();
        fp.score += 50;
      }
    }
    frameRate(10);
    image(fp.waterImg, mouseX - 215/2, 50 + 150*fp.floor - 115/2, 215, 115);
    image(fp.mouseImg, mouseX - 215/2, 50 + 150*fp.floor -115/2, 215, 115);
  }
  //else if(pp != null){}
  //else if(cp != null){}
}
