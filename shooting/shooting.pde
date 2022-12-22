boolean keyLeft, keyRight, keyUp, keyDown;
PFont f;
Ship test = new Ship(300, 300, PI/2);
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
boolean gameOver = false;
int previousAliveTime = -1000;
int maxLives = 3;
int lives;

void setup() {
  size(600,600);
  background(0);
  ellipseMode(CENTER);
  stroke(0, 255, 0);
  noFill();
  f = createFont("Arial", 16, true);
  textFont(f);
  KeyState.initialize();
  lives = maxLives;
}

void draw() {
  background(0);
  if (test.fire()) {
    bullets.add(new Bullet(test.headX(), test.headY(), test.rad));
  }

  for (int i = 0; i < bullets.size(); i++) {
    Bullet b = bullets.get(i);
    b.move();
    if (b.isAlive()) {
      b.render();
      if (b.isHit(test.posX, test.posY)) {
        test.isAlive = false;
      }
    } else {
      bullets.remove(i);
      i -= 1;
    }
  }

  if (test.isAlive) {
    test.move();
    test.render();
    previousAliveTime = millis();
  } else if (millis() - previousAliveTime > 1000) {
    lives -= 1;
    if (lives > 0) {
      test.reset(300, 300, PI/2);
    } else {
      text("GAME OVER", 200, height/2);
    }
  } 
}
