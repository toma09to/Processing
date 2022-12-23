import processing.net.*;
Client myClient;

boolean keyLeft, keyRight, keyUp, keyDown;
PFont f;
color green = color(0, 255, 0);
color red = color(255, 0, 0);
Ship test = new Ship(300, 300, PI/2, green);
Ship test2 = new Ship(100, 100, PI/2, red);
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
int previousAliveTime = -1000;
int previousAliveTime2 = -1000;
int maxLives = 3;
int lives;

void setup() {
  myClient = new Client(this, "127.0.0.1", 20000);
  
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
  if (test2.fire()) {
    bullets.add(new Bullet(test2.headX(), test2.headY(), test2.rad, red));
  }

  for (int i = 0; i < bullets.size(); i++) {
    Bullet b = bullets.get(i);
    b.move();
    if (b.isAlive()) {
      b.render();
      if (b.isHit(test)) {
        test.isAlive = false;
      }
      if (b.isHit(test2)) {
        test2.isAlive = false;
      }
    } else {
      bullets.remove(i);
      i -= 1;
    }
  }

  if (test2.isAlive) {
    test2.move();
  }
  test.render();
  test2.render();
}

void clientEvent(Client c) {
  String readStr = c.readString();
  println(readStr);
  String[] data = split(readStr, ',');
  if (data[0].equals("Ship")) {
    test.posX = float(data[1]);
    test.posY = float(data[2]);
    test.rad = float(data[3]);
    test.isAccelerating = boolean(data[4]);
    test.shipColor = unhex(data[5]);
  }
}
