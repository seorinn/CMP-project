class Car {
  PImage carImage;
  float x, y, speed;
  Car(PImage c,float x, float y, float s) {
    carImage=c;
    this.x=x;
    this.y=y;
    speed=s;
  }
  void imageCar() {
    image(carImage, x, y);
  }
}
