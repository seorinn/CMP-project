class PainterPage{

  PImage img;
  PImage backImg = loadImage("background.jpg");
  PImage displayImg;
  PFont f = createFont("Arial", 16);

  float weight = 5; //펜 두께
  int paintNum = 1; //명화 번호(n 누를때마다 바뀌도록 )
  boolean paintIs = false; //명화 떠있는지(그리기 기능 활성화 여부 )

  int mypaintNum = 1; //내 그림 저장 번호
  boolean mouseHold = false;
  float mypaintXpos; //전시페이지에서 마우스로 좌우 이동하기 위한 x좌표

  color[] colors= new color[9]; //펜 색

  color curColor; //선택한 현재 펜의 색
  int colNum = 0; //색의 번호


  void setPaint(){
    background(backImg);
    colors[0] = color(0, 0, 0);
    colors[1] = color(255, 51, 51);
    colors[2] = color(255, 153, 51);
    colors[3] = color(255, 255, 51);
    colors[4] = color(255, 204, 153);
    colors[5] = color(153, 255, 51);
    colors[6] = color(51, 153, 255);
    colors[7] = color(51, 51, 225);
    colors[8] = color(255, 51, 153);
  }

  void paintDraw(){
    curColor = colors[colNum];

    strokeWeight(weight);
    textFont(f, 40);
    textAlign(CENTER);
    fill(0);
    text("Continue drawing", width/2, 63);

    textFont(f, 30);
    text("Press 'n' to draw new painting.", width/2, 108);

    text("Size", 150, 685);
    strokeWeight(4);
    stroke(0);
    triangle(200, 675, 220, 685, 220, 666);
    triangle(310, 675, 290, 685, 290, 666);
    strokeWeight(weight);
    line(240, 675, 270, 675);

    text("Color", 500, 685);
    strokeWeight(4);
    stroke(0);
    fill(curColor);
    ellipse(570, 675, 30, 30);
    fill(0);
    triangle(610, 679.5, 620, 697.5, 630, 679.5);
    triangle(610, 670.5, 620, 652.5, 630, 670.5);

    text("Save", 820, 685);
    strokeWeight(5);
    stroke(0);
    strokeJoin(ROUND);
    fill(255);
    rect(880, 650, 50, 50);
    fill(0);
    text("S", 905, 685);
    
    rectMode(CORNER);
    text("Display", 920, 80);
    strokeWeight(5);
    stroke(0);
    strokeJoin(ROUND);
    fill(255);
    rect(980, 45, 50, 50);
    fill(0);
    text("D", 1005, 80);

  }//paintDraw

  void displayDraw(){
    if(mousePressed == true){
      mouseHold = true;
    }
    if(mouseHold == true){
      imageMode(CENTER);
      float move = pmouseX-mouseX;
      background(backImg);
      if(move>0){
        mypaintXpos -= move;
      }
      else if(move<0){
        mypaintXpos -= move;
      }
      listPaint(mypaintXpos);
    }
    text("Back", 930, 80);
    strokeWeight(5);
    stroke(0);
    strokeJoin(ROUND);
    fill(255);
    rect(980, 45, 50, 50);
    fill(0);
    text("D", 1005, 80);
  } //displayDraw

  void releaseMouse(){
    mouseHold = false;
  }

  void drawLine(){
    if (paintIs == true){
      if (mouseX > width/2 && mouseX < (width + img.width)/2 && mouseY > (height-img.height)/2 && mouseY < (height-img.height)/2 + img.height ){
        strokeWeight(weight);
        stroke(curColor);
        line(pmouseX, pmouseY, mouseX, mouseY);
      }
    }
  }

  void penIncre(){
    if(weight < 30) weight ++;
  }

  void penDecre(){
    strokeWeight(weight+2);
    stroke(210, 210, 210);
    line(240, 675, 270, 675);
    if(weight > 1) weight --;
  }

  void penColorUp(){
    if(colNum == 8) colNum = 0;
    else colNum++;
  }

  void penColorDown(){
    if(colNum == 0) colNum = 8;
    else colNum--;
  }

  void newPaint(){
    background(backImg);

    imageMode(CORNER);
    img = loadImage("painting" + paintNum + ".png");
    paintNum++;
    if(paintNum == 4) paintNum = 1;

    strokeWeight(3);
    rectMode(CENTER);
    fill(155, 105, 80);
    rect(width/2, height/2, img.width+50, img.height+50);
    image(img, (width-img.width)/2, (height-img.height)/2, img.width, img.height);
    rectMode(CORNER);
    fill(255, 255, 255, 200);
    noStroke();
    rect(width/2, (height-img.height)/2, img.width/2, img.height);

    paintIs = true;
  }

  void saveImage() {
    PImage saveImg = createImage(img.width, img.height, RGB);

    loadPixels();
    saveImg.loadPixels();

    int index = 0;
    for (int y = 0; y < height; y++ ) {
      for (int x = 0; x < width; x++ ) {
        if(x>=(width-img.width)/2 && x<(width-img.width)/2 + img.width && y>(height-img.height)/2 && y<(height-img.height)/2 + img.height){
          int loc = x + y*width;
          float r = red(pixels[loc]);
          float g = green(pixels[loc]);
          float b = blue(pixels[loc]);
          saveImg.pixels[index] = color(r, g, b);
          index++;
        }
      }
    }
    saveImg.updatePixels();
    saveImg.save("myPaint" + mypaintNum + ".png");
    mypaintNum++;
  }

  void paintToDis(){
    mypaintXpos = width/2;
    background(backImg);
    listPaint(mypaintXpos);
  }

  void disToPaint(){
    background(backImg);
    paintIs = false;
  }

  void listPaint(float xpos){
    imageMode(CENTER);
    for (int i = 1; i < mypaintNum; i++){
      displayImg = loadImage("myPaint" + i + ".png");
      image(displayImg, xpos + ((i-1)*600), height/2, displayImg.width/1.5, displayImg.height/1.5);
    }
  }


}//class
