PImage img1, img2, fireImage, firefighter1, firefighter2;
Fire[] fires = new Fire[5];
//int loc;
int num;

void setup() {
  size(512, 512);
  img1 = loadImage("village2.jpg");
  img2 = loadImage("missionComplete.jpg");
  fireImage = loadImage("fire.png");
  firefighter1 = loadImage("firefighter1.png");
  firefighter2 = loadImage("firefighter2.png");
  for (int i = 0; i < fires.length; i++) {
    fires[i] = new Fire();
  }
}

void draw() {
  frameRate(30);
  num = 0;
  imageMode(CENTER);
  image(img2, width/2, height/2);
  for (int i = 0; i < fires.length; i++) {
    if (fires[i].power != 0) {
      num ++;
      if (num != 0) {
        image(img1, width/2, height/2);
      }
    }
  }
  for (int i = 0; i < fires.length; i++) {
    fires[i].drawFires(fireImage);
  }
  //fill(110, 200, 240);
  //ellipse(mouseX, mouseY, 10, 10);
  image(firefighter1, mouseX, mouseY, 100, 80);
}

void setFires() {
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < fires.length; i++) {
      if (fires[i].comparePos(mouseX, mouseY)) {
        fires[i].hit();
      }
    }
    //fill(110, 200, 240);
    //ellipse(mouseX, mouseY, 50, 50);
    //println(num);    
  frameRate(5);
  image(firefighter2, mouseX, mouseY, 100, 80);
  }
}
