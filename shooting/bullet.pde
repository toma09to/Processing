class Bullet {
  float posX, posY;
  float rad;
  float speed;
  color bulletColor;

  Bullet(float posX, float posY, float rad, color col) {
    this.posX = posX;
    this.posY = posY;
    this.rad = rad;
    this.speed = 5.0;
    this.bulletColor = col;
  }

  void move() {
    this.posX += speed * cos(this.rad);
    this.posY -= speed * sin(this.rad);
  }

  void render() {
    noStroke();
    fill(this.bulletColor);
    ellipse(this.posX, this.posY, 5, 5);
    noFill();
    stroke(green);
  }
    
  boolean isAlive() {
    return (this.posX >= -60 && this.posX <= width+60  && this.posY >= -60 && this.posY <= height+60);
  }

  boolean isHit(float x, float y) {
    return (pow(this.posX - x, 2) + pow(this.posY - y, 2) < pow(10.0, 2));
  }
}
