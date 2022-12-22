class Ship {
  float posX, posY;
  float rad;
  float speedX, speedY;
  float accelFactor, decelFactor;
  int chargeTime;
  int previousFireTime;
  
  Ship(float posX, float posY, float rad) {
    this.posX = posX;
    this.posY = posY;
    this.rad = rad;
    this.speedX = 0.0;
    this.speedY = 0.0;
    this.accelFactor = 0.03;
    this.decelFactor = 0.005;
    this.chargeTime = 500;
    this.previousFireTime = -this.chargeTime;
  }
  
  void render() {
    PVector[] frames = new PVector[4];
    frames[0] = new PVector(15.0,  0.0);
    frames[1] = new PVector(-15.0, 10.0);
    frames[2] = new PVector(-5.0,  0.0);
    frames[3] = new PVector(-15.0, -10.0);
    PVector[] flares = new PVector[4];
    flares[0] = new PVector(-15.0, 7.0);
    flares[1] = new PVector(-22.0, 7.0);
    flares[2] = new PVector(-15.0, -7.0);
    flares[3] = new PVector(-22.0, -7.0);

    // draw a frame
    beginShape();
    for (int i = 0; i < 4; i++) {
      // move and rotate vector
      float coordX = (frames[i].x*cos(this.rad) + frames[i].y*sin(this.rad)) + this.posX;
      float coordY = (-frames[i].x*sin(this.rad) + frames[i].y*cos(this.rad)) + this.posY;
      vertex(coordX, coordY);
    }
    endShape(CLOSE);

    // draw flares
    if (KeyState.get(UP)) {
      for (int i = 0; i < 4; i++) {
        float coordX = (flares[i].x*cos(this.rad) + flares[i].y*sin(this.rad)) + this.posX;
        float coordY = (-flares[i].x*sin(this.rad) + flares[i].y*cos(this.rad)) + this.posY;
        if (i % 2 == 0) beginShape();
        vertex(coordX, coordY);
        if (i % 2 == 1) endShape(CLOSE);
      }
    }
  }
  
  void move() {
    // acceleration
    if (KeyState.get(UP)) {
      speedX += accelFactor*cos(this.rad);
      speedY -= accelFactor*sin(this.rad);
    }

    // rotate
    if (KeyState.get(LEFT)) {
      test.rad += 0.1;
    }
    if (KeyState.get(RIGHT)) {
      test.rad -= 0.1;
    }

    // deceleration
    this.speedX -= this.speedX * decelFactor;
    this.speedY -= this.speedY * decelFactor;

    // move
    this.posX += this.speedX;
    this.posY += this.speedY;

    if (this.posX > width + 30) {
      this.posX -= width + 60;
    } else if (this.posX < -30) {
      this.posX += width + 60;
    }
    if (this.posY > height + 30) {
      this.posY -= height + 60;
    } else if (this.posY < -30) {
      this.posY += height + 60;
    }
  }

  boolean fire() {
    boolean ret = (KeyState.get(DOWN) && millis() - this.previousFireTime > this.chargeTime);
    if (ret) {
      this.previousFireTime = millis();
    }
    return ret;
  }

  float headX() {
    return 15.0*cos(this.rad) + this.posX;
  }

  float headY() {
    return 15.0*-sin(this.rad) + this.posY;
  }
}
