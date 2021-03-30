PImage bg, soil, life, soldier, cabbage, title, gameover, 
  startNormal, startHovered, restartNormal, restartHovered, 
  groundhogDown, groundhogIdle, groundhogLeft, groundhogRight;
float block = 80;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState = GAME_START;

final int BTN_W = 144;
final int BTN_H = 60;
final float HOG_W = block;
final float HOG_H = block;

float cabbageX, cabbageY;
int cabbagePosition = floor(random(0, 7));
int cabbageFloor = floor(random(2, 5));

float soldierX = 0;
float soldierY = 0;
int soldierFloor = floor(random(2, 5));

float hogX = block*4 ;
float hogY = block;
float hogSpeed = 16/3;
int lifeAmount = 2;
int lifeX = 10;

boolean upPressed = false;
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;
boolean getCabbage = false;

void setup() {
  size(640, 480, P2D);
  // loadImage
  bg = loadImage("img/bg.jpg");
  soil = loadImage("img/soil.png");
  soldier = loadImage("img/soldier.png");
  title = loadImage("img/title.jpg");
  life = loadImage("img/life.png");
  cabbage = loadImage("img/cabbage.png");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
}

void draw() {
  // Switch Game State
  switch(gameState) {

    // Game Start
  case GAME_START:
    background(title);
    image(startNormal, 248, 360);
    if (mouseX > 248 && mouseX < 248 + BTN_W && mouseY > 360 &&mouseY < 360 + BTN_H) {
      image(startHovered, 248, 360);
      if (mousePressed)gameState = GAME_RUN;
    }
    break;

    // Game Run
  case GAME_RUN:
    // bg, soil, grass, sun
    background(bg);
    image(soil, 0, block*2);
    fill(124, 204, 25);
    noStroke();
    rect(0, block*2-15, width, 15);
    fill(253, 184, 19);
    stroke(255, 255, 0);
    strokeWeight(5);
    ellipse(width-50, 50, 120, 120);

    //sodier
    soldierX += 2;
    soldierX %= block*9;
    soldierY = block * soldierFloor;
    image(soldier, soldierX - block, soldierY, block, block);

    //hog image
    if (keyPressed != true)image(groundhogIdle, hogX, hogY); 
    if (upPressed == true) image(groundhogIdle, hogX, hogY);
    if (downPressed == true)image(groundhogDown, hogX, hogY);
    if (rightPressed == true)image(groundhogRight, hogX, hogY);
    if (leftPressed == true)image(groundhogLeft, hogX, hogY);

    //hog moving
    if (upPressed) { 
      hogY -= hogSpeed;
      downPressed = false;
      rightPressed = false;
      leftPressed = false;
    }
    if (downPressed) {
      hogY += hogSpeed;
      upPressed = false;
      rightPressed = false;
      leftPressed = false;
    }
    if (leftPressed) {
      hogX -= hogSpeed;
      downPressed = false;
      rightPressed = false;
      upPressed = false;
    }
    if (rightPressed) {
      hogX += hogSpeed;
      downPressed = false;
      upPressed = false;
      leftPressed = false;
    }
    if (keyPressed != true) {
      hogX = (int)(hogX / block)*block;
      hogY = ceil(hogY / block)*block;
      image(groundhogIdle, hogX, hogY);
    }
    //boundary detection
    if (hogX < 0)hogX =0;
    if (hogX > width-HOG_W)hogX = width-HOG_W;
    if (hogY < 0)hogY =0;
    if (hogY > height-HOG_H)hogY = height-HOG_H;


    //cabbage
    if (getCabbage == true) {
      cabbageX = width;
      cabbageY = height;
    } else {
      cabbageX = block*cabbagePosition;
      cabbageY = block*cabbageFloor;
    }
    image(cabbage, cabbageX, cabbageY);

    //life
    if (hogX < soldierX + block && hogX + block > soldierX &&
      hogY < soldierY + block && hogY + block > soldierY) {
      //touch soldier
      lifeAmount = lifeAmount - 1;
      for (int A = 0; A <= lifeAmount-1; A+=1) {
        image(life, lifeX + 70*A, 10);
      }
      hogX = block*4 ;
      hogY = block;
      downPressed = false;
      upPressed = false;
      leftPressed = false;
      rightPressed = false;
      //
    } else if (hogX < cabbageX + block && hogX + block > cabbageX &&
      hogY < cabbageY + block && hogY + block > cabbageY) {
      // eat cabbage
      getCabbage = true;
      lifeAmount = lifeAmount + 1;
      for (int A = 0; A <= lifeAmount-1; A+=1) {
        image(life, lifeX + 70*A, 10);
      }
    } else { //nothing
      for (int A = 0; A <= lifeAmount-1; A+=1) {
        image(life, lifeX + 70*A, 10);
        image(cabbage, cabbageX, cabbageY);
      }
    }

    //game over
    if (lifeAmount == 0) gameState = GAME_OVER;
    break;

    // Game over
  case GAME_OVER:
    lifeAmount = 2;
    hogX = block*4 ;
    hogY = block;
    cabbagePosition = floor(random(0, 7));
    cabbageFloor = floor(random(2, 5));
    soldierFloor = floor(random(2, 5));
    getCabbage = false;
    background(gameover);
    image(restartNormal, 248, 360);
    if (mouseX > 248 && mouseX < 248 + BTN_W && mouseY > 360 && mouseY < 360 + BTN_H) {
      image(restartHovered, 248, 360);
      if (mousePressed)gameState = GAME_RUN;
    }
    break;
  }
}

void keyPressed() {
  switch(keyCode) {
  case UP:
    upPressed = true;
    break;
  case DOWN:
    downPressed = true;
    break;
  case RIGHT:
    rightPressed = true;
    break;
  case LEFT:
    leftPressed = true;
    break;
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      upPressed = false;
      break;
    case DOWN:
      downPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    }
  }
}  
