class CarPage {
  
  boolean over=false;
  boolean ghostMode=false;
  int ghostv=0;
  PImage tree;
  PImage roadP;
  PImage myCar;
  PImage ecar1, ecar2, ecar3;
  PImage item1, item2, item3;
  PFont startText;
  PFont endText;
  String startMessage[] = {"3", "2", "1", "START!"};
  ArrayList<Trees> trees = new ArrayList<Trees>();
  ArrayList<Trees> setTrees = new ArrayList<Trees>();
  ArrayList<Trees> roadPattern = new ArrayList<Trees>();
  ArrayList<Car> cars = new ArrayList<Car>();
  ArrayList<EnemyCar> ecars = new ArrayList<EnemyCar>();
  ArrayList<Item> items = new ArrayList<Item>();
  float startCount=0;
  float treeSpeed=5;
  float theta=0;
  int savedTime;
  int enemyCount=0;

  CarPage() {
   

    
    

    
    over=false;
    startText = createFont("Arial", 45);
    endText = createFont("Arial", 30 );

    tree=loadImage("tree1.png");
    roadP=loadImage("road_pattern.png");
    myCar=loadImage("Car1.png"); // can change to press the number button
    ecar1=loadImage("Car2.png");
    ecar2=loadImage("Car3.png");
    ecar3=loadImage("Car4.png");
    item1=loadImage("item1.png");
    item2=loadImage("item2.png");
    item3=loadImage("item3.png");
  }
  void set() {
    
    song=minim.loadFile("countdown.mp3");
    crash=minim.loadFile("crash.mp3");
    song.play();
    setTrees.add(new Trees(tree, width/2-420, 125));
    setTrees.add(new Trees(tree, width/2-420, 375));
    setTrees.add(new Trees(tree, width/2-420, 605));
    setTrees.add(new Trees(tree, width/2+420, 125));
    setTrees.add(new Trees(tree, width/2+420, 375));
    setTrees.add(new Trees(tree, width/2+420, 605));

    setTrees.add(new Trees(roadP, width/2, 125));
    setTrees.add(new Trees(roadP, width/2, 425));
    setTrees.add(new Trees(roadP, width/2, 725));

    if(cars.size()<1) cars.add(new Car(myCar, width/2, height/2+140, 0.03));
    
    savedTime=millis();
   }


  void play() {
    background(0, 255, 0);
    noStroke();
    fill(100);
    rect(width/2, height/2, 680, height);


    for (int i=0; i<setTrees.size(); i++) {
      setTrees.get(i).imageTree();
      if (startCount>=3)
        setTrees.get(i).y+=treeSpeed;
    }

    textFont(startText, 45);
    textAlign(CENTER);

    rectMode(CENTER);
    imageMode(CENTER);

    for (int i=0; i<trees.size(); i++) {
      if (trees.get(i).y<=height+75) {
        trees.get(i).y+=treeSpeed;
        trees.get(i).imageTree();
      } else {
        //trees.remove(i);// tree control
      }
    }

    for (int i=0; i<roadPattern.size(); i++) {
      if (roadPattern.get(i).y<height+75) {
        roadPattern.get(i).imageTree();
        roadPattern.get(i).y+=treeSpeed;
      } else {
        //roadPattern.remove(i); // pattern control
      }
    }

    if(cars.size()>0) cars.get(0).imageCar();

    int passedTime = millis()-savedTime;
    fill(0);
    if (startCount==0) text(startMessage[0], width/2, height/2);
    if (startCount==1) text(startMessage[1], width/2, height/2);
    if (startCount==2) text(startMessage[2], width/2, height/2);
    if (startCount==3) {
      text(startMessage[3], width/2, height/2);
      if (passedTime>480) {
        startCount=4;
      }
    }

    if (startCount==0&&passedTime>=1000&&passedTime<2000) {
      startCount=1;
    }
    if (startCount==1&&passedTime>=2000&&passedTime<3000) {
      startCount=2;
    }
    if (startCount==2&&passedTime>=3000&&passedTime<=4000) {
      startCount=3;
      savedTime=millis();
    }

    if (startCount>=3) {
      if (passedTime>=5000/treeSpeed) {                       // pass time
        trees.add(new Trees(tree, width/2-420, -150));
        trees.add(new Trees(tree, width/2+420, -150));
        roadPattern.add(new Trees(roadP, width/2, -150));
        savedTime=millis();
        enemyCount++;
      }
      cars.get(0).x=lerp(cars.get(0).x, mouseX, cars.get(0).speed);
      cars.get(0).x = constrain(cars.get(0).x, 230, 850);
      if (over==true) {                 //collision processing

        noLoop();
      }
    }

    if (enemyCount>5) { // score?
      if (enemyCount<10) text("Avoid cars!", width/2, height/2);
      if (enemyCount>=30&&enemyCount<35) text("Get an item!", width/2, height/2);
      if (enemyCount%5==0) {                 // generate ecar
        float ex = random(230, 850);
        int cs = (int)random(0, 3);
        if (cs==0) {
          enemyCount++;
          beep=minim.loadFile("car_beep.mp3");
          beep.play();
          ecars.add(new EnemyCar(ecar1, ex, -70, random(8+treeSpeed/5, 12+treeSpeed/5)) );
        } else if (cs==1) {
          enemyCount++;
          beep=minim.loadFile("car_beep.mp3");
          beep.play();
          ecars.add(new EnemyCar(ecar2, ex, -70, random(8+treeSpeed/5, 12+treeSpeed/5)) );
        } else if (cs==2) {
          enemyCount++;
          beep=minim.loadFile("car_beep.mp3");
          beep.play();
          ecars.add(new EnemyCar(ecar3, ex, -70, random(8+treeSpeed/5, 12+treeSpeed/5)) );
        }
      }
      for (int i=0; i<ecars.size(); i++) {         //ecar Move
        ecars.get(i).y+=ecars.get(i).speed;
        ecars.get(i).imageCar();


        if (ecars.get(i).eImage==ecar3) {

          ecars.get(i).x+=map(sin(theta), -1, 1, -5, 5);
          ecars.get(i).x=constrain(ecars.get(i).x, 230, 850);
        }
      }
      if (enemyCount%31==0) {
        float ex = random(230, 850);
        int m=(int)random(0, 3);
        enemyCount++;
        if (m==0) items.add(new Item(item1, ex, -75, 5));
        else if (m==1) items.add(new Item(item2, ex, -75, 6));
        else if (m==2) items.add(new Item(item3, ex, -75, 7));
      }
      if (enemyCount%21==0) {
        treeSpeed+=1;
        enemyCount++;
      }
      for (int i=0; i<items.size(); i++) {
        items.get(i).y+=items.get(i).speed;
        items.get(i).imageItem();
      }
    }
    for (EnemyCar ecar : ecars) {  // ecar collision
      float r1x = cars.get(0).x;
      float r1y = cars.get(0).y;
      float rw = 60;
      float r2x = ecar.x;
      float r2y = ecar.y;
      float rh = 140;
      if (r1x+rw>=r2x && r1x<=r2x+rw && r1y+rh>=r2y&&r1y<=r2y+rh) {
        if (ghostv==0) {
          crash.play();
          over=true;
        }
      }
    }
    for (int i=0; i<items.size(); i++) {  // item collision
      float r1x = cars.get(0).x;
      float r1y = cars.get(0).y;
      float rw = 64;
      float r2x = items.get(i).x;
      float r2y = items.get(i).y;
      float rh = 140;
      if (r1x+rw>=r2x && r1x<=r2x+rw && r1y+rh>=r2y&&r1y<=r2y+64) {

        if (items.get(i).speed==5) {        // handling
          handling=minim.loadFile("handling.mp3");
          handling.play();
          cars.get(0).speed+=0.05;
        } else if (items.get(i).speed==6) { // boost
          boost=minim.loadFile("boost.mp3");
          boost.play();
          treeSpeed+=4;
          for (EnemyCar ecar : ecars) {
            ecar.speed+=4;
          }
        } else if (items.get(i).speed==7) { // ghost
          ghostsound=minim.loadFile("ghostsound.mp3");
          ghostsound.play();
          ghostMode=true;
        }
        items.remove(i);
      }
    }
    text("Score: "+enemyCount*100, width-150, 50);
    if (over==true) {
      fill(200);
      rect(width/2, height/2, 400, 250);
      fill(0);
      textFont(endText, 30);
      text("Game Over", width/2, height/2-60);
      text("Your Score: " + enemyCount*100, width/2, height/2-10 );
      text("key R: Replay", width/2, height/2+70);
      
    }
    textFont(startText,30);
    text("Key h: Home", 100, 30);
    theta+=0.05;
    if (ghostMode==true) {
      ghostv=millis();
      treeSpeed+=10;
      ghostMode=false;
    }
    if (ghostv!=0) {
      int gp= millis()-ghostv;
      if (gp<=4500) {
        cars.get(0).carImage=item3;
      } else {
        treeSpeed-=10;
        cars.get(0).carImage=myCar;
        ghostv=0;
      }
    }
  }

  void reset() {
    for (int i=setTrees.size()-1; i>-1; i--) setTrees.remove(i);
    for (int i=trees.size()-1; i>-1; i--) trees.remove(i);
    for (int i=ecars.size()-1; i>-1; i--) ecars.remove(i);
    for (int i=items.size()-1; i>-1; i--) items.remove(i);
    for (int i=roadPattern.size()-1; i>-1; i--) roadPattern.remove(i);
    for (int i=cars.size()-1; i>-1; i--) cars.remove(i);
    set();
    startCount=0;
    treeSpeed=5;
    enemyCount=0;
  }
}
