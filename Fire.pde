class Fire {
  float posX;
  float posY;
  int power;
  boolean show;

  Fire() {
    power = int(random(50, 80));
    posX = random(50, width-50);
    posY = 50 + 150*int(random(1, 4)) + 57.5 - 0.75*power;
    show = false;
  }

  void hit() {
    if (power > 0) {
      posY += 0.75*power;
      power -= 20;
      posY -= 0.75*power;
    }
    if (power < 50)
      power = 0;
  }

  void drawFires(Gif img) {
    if (show)
      image(img, posX, posY, power, 1.5*power);
  }

  void reposition(float x, float y, int p) {
    posX = abs(x + int(random(-5, 5)) * 30);
    posY = y + 0.75*(p - power);
  }

  void setShow() {
    show = true;
  }
}
