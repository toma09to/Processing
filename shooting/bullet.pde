class Bullet {
  float posX, posY;
  float rad;
  float speed;

  Bullet(float posX, float posY, float rad) {
    this.posX = posX;
    this.posY = posY;
    this.rad = rad;
    this.speed = 5.0;
  }

  void move() {
    this.posX += speed * cos(this.rad);
    this.posY -= speed * sin(this.rad);
  }

  void render() {
    fill(0, 255, 0);
    ellipse(this.posX, this.posY, 3, 3);
    noFill();
  }
    
  boolean isAlive() {
    return (this.posX >= -60 && this.posX <= width+60  && this.posY >= -60 && this.posY <= height+60);
  }

  boolean isHit(float x, float y) {
    return (pow(this.posX - x, 2) + pow(this.posY - y, 2) < pow(5.0, 2));
  }
}
