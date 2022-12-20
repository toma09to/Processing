boolean left, right, up, down;
Aircraft test = new Aircraft(200, 200);

void setup() {
  size(400,400);
  background(0);
  stroke(0, 255, 0);
  noFill();
}

void draw() {
  background(0);
  if (keyPressed) {
    if (keyCode == UP) {
      test.accelerate(0.03);
    }
    if (keyCode == DOWN) {
      test.accelerate(-0.01);
    }
    if (keyCode == LEFT) {
      test.rad += 0.1;
    }
    if (keyCode == RIGHT) {
      test.rad -= 0.1;
    }
  }
  test.move();
  test.display();
}
