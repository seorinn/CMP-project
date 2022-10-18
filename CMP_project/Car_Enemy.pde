class EnemyCar{
  PImage eImage;
  float x,y,speed;
  EnemyCar(PImage c,float x, float y, float s) {
    eImage=c;
    this.x=x;
    this.y=y;
    speed=s;
  }
  void imageCar() {
    image(eImage, x, y);
  }
}
