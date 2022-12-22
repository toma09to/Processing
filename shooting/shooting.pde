boolean keyLeft, keyRight, keyUp, keyDown;
PFont f;
color green = color(0, 255, 0);
color red = color(255, 0, 0);
Ship test = new Ship(300, 300, PI/2, green);
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
int previousAliveTime = -1000;
int previousAliveTime2 = -1000;
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
    bullets.add(new Bullet(test.headX(), test.headY(), test.rad, green));
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

  test.move();
  test.render();
}
