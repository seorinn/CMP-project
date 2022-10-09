class Fire {
  //int size;
  float posX;
  float posY;
  int power;

  Fire() {
    //size = int(random(5, 10));
    posX = random(50, width-50);
    posY = random(50, height-50);
    power = int(random(20, 50));
  }

  void hit() {
    //fill(50, 50, 255);
    //ellipse(mouseX, mouseY, 30, 30);
    if (power > 0) {
      power -= 10;
      if(power < 10)
        power = 0;
    }
  }

  void drawFires(PImage img) {
    image(img, posX, posY, power, (1.5)*power);
  }

  boolean comparePos(float a, float b) {
    if (abs(posX - a) < power && abs(posY - b) < power) {
      return true;
    } else {
      return false;
    }
  }
}
