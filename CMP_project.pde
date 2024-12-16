import processing.sound.*;
DoctorPage dp;
SoundFile heartBeat;
PImage backHome;

void setup(){
    size(1080,720);
    background(255);
    heartBeat = new SoundFile(this,"heartbeat.wav");
    backHome = loadImage("backHome.png");
    home();
}

void draw(){
  if(dp != null){
      if(dp.endo){
        dp.endoscope();
      }
      if(dp.xray){
        dp.x_ray();
      }
      if(dp.heartRoom){
         dp.goHeartRoom();
      }
      if(dp.medicineRoom){
         dp.goMedicineRoom(); 
      }
  }
}

void home(){
    image(backHome,0,0);
    textSize(100);
    fill(205,205,100);
    text("dreams come true!",160,300);
}

void keyPressed(){
   if(key == CODED){
      if(keyCode == RIGHT){
          dp = new DoctorPage();
          dp.selectMenu();
      }
   }
   if(dp!=null && dp.xrayRoom && key == 'a'){
       dp.endo = true;
       dp.xray = false;
   }
   if(dp!=null && dp.xrayRoom && key == 's'){
       dp.xray = true;
       dp.endo = false;
   }
  if(dp!=null && key == 'm'){
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
     if(heartBeat.isPlaying())
       heartBeat.pause();
     dp.selectMenu();
  }
  if(dp!=null && dp.select_Menu && key == 'h'){
      home();
      dp = null;
  }
}

void mousePressed(){
  if(dp!=null && dp.select_Menu){
     if(dist(mouseX,mouseY,157,624) <= 85){
       dp.xrayRoom = true;
       dp.goXrayRoom();
     }
     
     if(dist(mouseX,mouseY,387,624) <= 75){
       dp.heartRoom = true;
       heartBeat.loop();
     }
     
     if(dist(mouseX,mouseY,617,624) <= 80){
       dp.medicineRoom = true;
     }
     
  }
   if(dp!=null && dp.medicineRoom){
       if(dist(mouseX,mouseY,455,345) <= 10){
         dp.cough = true;
       }
       if(dist(mouseX,mouseY,530,345) <= 10){
         dp.cough = false;
       }
       
       if(dist(mouseX,mouseY,455,400) <= 10){
         dp.fever = true;
       }
       if(dist(mouseX,mouseY,530,400) <= 10){
         dp.fever = false;
       }
       
       if(dist(mouseX,mouseY,455,465) <= 10){
         dp.headache = true;
       }
       if(dist(mouseX,mouseY,530,465) <= 10){
         dp.headache = false;
       }
       
       if(dist(mouseX,mouseY,455,520) <= 10){
         dp.runnyNose = true;
       }
       if(dist(mouseX,mouseY,530,520) <= 10){
         dp.runnyNose = false;
       }
       
       if(dist(mouseX,mouseY,455,580) <= 10){
         dp.throatHurt = true;
       }
       if(dist(mouseX,mouseY,530,580) <= 10){
         dp.throatHurt = false;
       }
       
       if( (525 < mouseY && mouseY < 650) && (700 < mouseX && mouseX < 1020)){
           dp.submit = true;
       }
   }
}
