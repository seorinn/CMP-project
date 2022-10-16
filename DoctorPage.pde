import processing.sound.*;

class DoctorPage {
  PImage insideBody = loadImage("insidebodyRemove.png");
  PImage bodyCover = loadImage("bodycoverRemove.png");
  PImage boneBody = loadImage("bodyboneRemove.png");
  PImage backImageH = loadImage("background_hospital.png");
  PImage backImageX = loadImage("backXray.png");
  PImage endoIcon = loadImage("endoIcon.png");
  PImage xrayIcon = loadImage("xrayIcon.png");
  PImage seeThroughMenu = loadImage("seeThroughMenu.png");
  PImage heartMenu = loadImage("stethoscope.png");
  PImage medicineMenu = loadImage("medicine.png");
  PImage backHeartRoom = loadImage("backHeartRoom.png");
  PImage heartIcon = loadImage("heart.png");
  PImage backMedicineRoom = loadImage("medicineRoom.png");
  PImage myMedicine = loadImage("myMedicine.png");
  
  PImage tem = createImage(bodyCover.width,bodyCover.height,RGB);
  
  
   boolean endo = false;
   boolean xray = false;
   boolean xrayRoom = false;
   boolean heartRoom = false;
   boolean select_Menu = false;
   boolean medicineRoom = false;
   
   boolean cough = false;
   boolean fever = false;
   boolean headache = false;
   boolean runnyNose = false;
   boolean throatHurt = false;
   boolean submit = false;
   
   void selectMenu(){
     select_Menu = true;
      image(backImageH,0,0,1080,720);
      textSize(60);
      fill(0);
      text("Where are you going?",50,100);
      image(seeThroughMenu,70,540);
      image(heartMenu,300,540);
      image(medicineMenu,530,540);
      textSize(40);
      fill(0);
      text("'h' key : go to home",720,680);
   }
   
   void goXrayRoom(){
      select_Menu = false;
      image(dp.backImageX,0,0,1080,720);
      image(dp.bodyCover,370,40); 
      fill(0);
      textSize(20);
      text("'a' key : endoscope mode",10,20);
      text("'s' key : x-ray mode",10,50);
      text("'m' key : go back to menu",840,590);
      image(endoIcon,30,100,200,200);
      image(xrayIcon,30,350,200,200);
   }
   
   void endoscope(){
     goXrayRoom();
     strokeWeight(6);
       stroke(255,0,0);
       noFill();
       ellipseMode(CORNER);
       ellipse(30,100,200,200);
       loadPixels();
       bodyCover.loadPixels();
       insideBody.loadPixels();
       tem.loadPixels();
       for (int y = 0; y < bodyCover.height; y++ ) {
          for (int x = 0; x < bodyCover.width; x++ ) {
                int loc = x + y*bodyCover.width;
                
                float distance = dist(x,y,mouseX-370,mouseY-40);
                
                if(distance < 70){
                    tem.pixels[loc] = color(insideBody.pixels[loc]);  
                }
                else if(distance >= 70 && distance < 73){
                   tem.pixels[loc] = color(255,0,0); 
                }
                else{
                  tem.pixels[loc] = color(bodyCover.pixels[loc]);
                }
              }
          }
          tem.updatePixels();
          image(tem,370,40);
   }
   
   void x_ray(){
     goXrayRoom();
     strokeWeight(6);
       stroke(255,0,0);
       noFill();
       ellipseMode(CORNER);
       ellipse(30,350,200,200);
       loadPixels();
       boneBody.loadPixels();
       bodyCover.loadPixels();
       tem.loadPixels();
       for (int y = 0; y < boneBody.height; y++ ) {
          for (int x = 0; x < boneBody.width; x++ ) {
                int loc = x + y*boneBody.width;
                
                float distance = dist(x,y,mouseX-370,mouseY-40);
                
                if(distance < 70){
                    tem.pixels[loc] = color(boneBody.pixels[loc]);  
                }
                else if(distance >= 70 && distance < 73){
                   tem.pixels[loc] = color(255,0,0); 
                }
                else{
                  tem.pixels[loc] = color(bodyCover.pixels[loc]);
                }
              }
          }
          tem.updatePixels();
          image(tem,370,40);
   }
   
   float theta = 0;
   void goHeartRoom(){
       select_Menu = false;
       image(backHeartRoom,0,0);
       image(heartIcon,960,210,90,90);
       fill(0);
       textSize(30);
       text("'m' key : go back to menu",720,660);
       stroke(0);
       strokeWeight(5);
       fill(220);
       ellipseMode(CENTER);
       ellipse(mouseX,mouseY,50,50);
       stroke(0);
       strokeWeight(3);
       ellipse(mouseX,mouseY,30,30);
       
       float distance = dist(mouseX,mouseY,310,220);
       distance = constrain(distance,0,200);
       float heartVolume = map(distance,0,200,1,0.1);
       heartBeat.amp(heartVolume);
       
      //draw heartRate
      stroke(255,0,0);
      noFill();
      beginShape();
      for(int i = 720; i < 950; i++){
          float y = heartVolume * 80 * sin(theta);
            vertex(i,y+200);
          theta += 0.3;
      }
      endShape();
      
      int heartRate = int(heartVolume * 100 + 30);
      fill(0,255,0);
      textSize(60);
      text(""+heartRate,960,160);
   }
   
   void goMedicineRoom(){
       image(backMedicineRoom,0,0);
       rectMode(CENTER);
       fill(0,255,0);
       noStroke();
       if(cough){
          rect(455,345,15,15);
       }
       if(cough == false){
          rect(530,345,15,15);
       }
       
       if(fever){
          rect(455,400,15,15);
       }
       if(fever == false){
          rect(530,400,15,15);
       }
       
       if(headache){
          rect(455,465,15,15);
       }
       if(headache == false){
          rect(530,465,15,15);
       }
       
       if(runnyNose){
          rect(455,520,15,15);
       }
       if(runnyNose == false){
          rect(530,520,15,15);
       }
       
       if(throatHurt){
          rect(455,580,15,15);
       }
       if(throatHurt == false){
          rect(530,580,15,15);
       }
       
       if(submit){
           if(cough && fever && !headache && !runnyNose && throatHurt) {
              image(myMedicine,250,170);
              textSize(70);
              fill(0);
              text("COVID-19",290,240);
              textSize(40);
              text("take a rest.",290,290);
           }
           else if(!cough && !fever && headache && !runnyNose && !throatHurt) {
              image(myMedicine,250,170);
              textSize(70);
              fill(0);
              text("lovesickness",290,240);
              textSize(40);
              text("run to him/her right now.",290,290);
           }
           else if(!cough && !fever && !headache && !runnyNose && !throatHurt) {
              image(myMedicine,250,170);
              textSize(70);
              fill(0);
              text("?",290,240);
              textSize(40);
              text("Why are you here?",290,290);
           }
           else if(!cough && fever && !headache && !runnyNose && !throatHurt){
              image(myMedicine,250,170);
              textSize(70);
              fill(0);
              text("You are angry",290,240);
              textSize(40);
              text("calm down",290,290);
           }
           else {
              image(myMedicine,250,170);
              textSize(70);
              fill(0);
              text("cold",290,240);
              textSize(40);
              text("drink lots of warm water.",290,290);
           }
       }
   }
}
