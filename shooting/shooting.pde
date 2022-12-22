boolean keyLeft, keyRight, keyUp, keyDown;
Ship test = new Ship(300, 300, PI/2);
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void setup() {
  size(600,600);
  background(0);
  ellipseMode(CENTER);
  stroke(0, 255, 0);
  noFill();
  KeyState.initialize();
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
    } else {
      bullets.remove(i);
    }
  }

  test.move();
  test.render();
}
