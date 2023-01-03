void setup() {
  size(640,360);
}

void draw() {
  background(0);

  PVector mouse = new PVector(mouseX, mouseY);
  PVector center = new PVector(width/2, height/2);

  mouse.sub(center);
  mouse.normalize();
  mouse.mult(15);

  mouse.add(center);

  stroke(255);
  strokeWeight(4);
  line(width/2, height/2, mouse.x, mouse.y);
}
