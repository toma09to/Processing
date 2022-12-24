import processing.net.*;
Server server;

boolean isPlaying = false;
int id = 1;
PFont f;
color green = color(0, 255, 0);
color red = color(255, 0, 0);
ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void setup() {
  server = new Server(this, 20000);

  size(600,600);
  background(0);
  ellipseMode(CENTER);
  stroke(green);
  noFill();

  f = createFont("Arial", 16, true);
  textFont(f);

  KeyState.initialize();
}

void draw() {
  while (true) {
    Client c = server.available();
    if (c == null) {
      break;
    } else {
      String readStr = c.readString();
      String[] data = split(readStr, ',');
      println("Server: " + readStr);

      if (data[0].equals("JoinReq")) {
        server.write("Join," + data[1] + ',' + str(id));
      } else if (data[0].equals("Joined")) {
        id += 1;
      }
    }
  }

  if (!isPlaying) {
    // entry scene
    
    // debug
  } else {
    // play scene
    Ship myShip = ships.get(0);
    background(0);
    if (myShip.fire()) { 
      Bullet b = new Bullet(myShip);
      server.write(b.data());
      bullets.add(b);
    }

    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);
      b.move();
      if (b.isAlive()) {
        b.render();
        if (b.isHit(myShip)) {
          myShip.isAlive = false;
        }
      } else {
        bullets.remove(i);
        i -= 1;
      }
    }

    myShip.control();
    myShip.render();
    server.write(myShip.data());
  }
}
