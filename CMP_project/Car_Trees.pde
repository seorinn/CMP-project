class Trees {
  PImage tree;
  float x, y;
  Trees(PImage t, float x, float y) {
    tree=t;
    this.x=x;
    this.y = y;
  }
  void imageTree() {
    image(tree, x, y);
  }
}
