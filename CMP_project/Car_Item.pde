class Item{
  PImage itImage;
  float x,y;
  float speed;
  Item(PImage i, float x, float y, float s){
    itImage = i;
    this.x=x;
    this.y=y;
    speed=s;
  }
  void imageItem() {
    image(itImage, x, y);
  }
  
}
