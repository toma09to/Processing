class Aircraft {
  float posX, posY;
  float speedX, speedY;
  float rad;
  
  Aircraft(float posX, float posY) {
    this.posX = posX;
    this.posY = posY;
    this.speedX = 0.0;
    this.speedY = 0.0;
    this.rad = 0.0;
  }
  
  void display() {
    PVector[] coords = new PVector[4];
    coords[0] = new PVector(15.0, 0.0);
    coords[1] = new PVector(-15.0, 10.0);
    coords[2] = new PVector(-5.0, 0.0);
    coords[3] = new PVector(-15.0, -10.0);
    beginShape();
    for (int i = 0; i < 4; i++) {
      // move and rotate vector
      float coordX = (coords[i].x*cos(this.rad) + coords[i].y*sin(this.rad)) + this.posX;
      float coordY = (-coords[i].x*sin(this.rad) + coords[i].y*cos(this.rad)) + this.posY;
      vertex(coordX, coordY);
    }
    endShape(CLOSE);
  }
  
  void move() {
    this.speedX -= this.speedX * 0.01;
    this.speedY -= this.speedY * 0.01;
    this.posX += this.speedX;
    this.posY += this.speedY;
  }
  
  void accelerate(float a) {
    speedX += a*cos(this.rad);
    speedY -= a*sin(this.rad);
  }
}
