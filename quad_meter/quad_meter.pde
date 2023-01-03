void setup() {
  size(400,400);
  noStroke();
  fill(255);
}

void draw() {
  background(0);
  quad(0, 0, 0, height, mouseX, height, mouseX, 0);
}
