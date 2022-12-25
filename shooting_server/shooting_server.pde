import processing.net.*;
Server server;

boolean isPlaying = false;
int entry = 1;
int ready = 1;
PFont f;

color green = color(0, 255, 0);
color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color yellow = color(255, 255, 0);
color[] colorList = {green, red, blue, yellow};

ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void setup() {
  try {
    server = new Server(this, 20000);
  } catch (RuntimeException e) {
    e.printStackTrace();
    exit();
  }

  size(600,600);
  background(0);
  ellipseMode(CENTER);
  stroke(green);
  noFill();

  f = createFont("Arial", 16, true);
  textFont(f);

  KeyState.initialize();

  for (int i = 0; i < 4; i++) {
    ships.add(new Ship(i, -150 + 100*i, 0, PI/2, colorList[i]));
  }
}

void draw() {
  while (true) {
    Client c = server.available();
    if (c == null) {
      break;
    } else {
      String readStr = c.readString();
      String[] data = split(readStr, ',');

      try {
        if (data[0].equals("Ship")) {
          ships.get(int(data[1])).move(float(data[2]), float(data[3]), float(data[4]), boolean(data[5]), boolean(data[6]), int(data[7]));
        } else if (data[0].equals("Bullet")) {
          bullets.add(new Bullet(int(data[1]), unhex(data[2]), float(data[3]), float(data[4]), float(data[5])));
          server.write(readStr);
        } else if (data[0].equals("JoinReq")) {
          server.write("Join," + data[1] + ',' + str(entry) + ',');
        } else if (data[0].equals("Joined")) {
          entry += 1;
        } else if (data[0].equals("Ready")) {
          ready += 1;
        } else if (data[0].equals("NotReady")) {
          ready -= 1;
        }
      } catch (NullPointerException e) {
        e.printStackTrace();
      }
    }
  }

  background(0);
  if (!isPlaying) {
    // entry scene
    for (int i = 0; i < entry; i++) {
      ships.get(i).render();
    }
    if (frameCount % 30 == 0) {
      server.write("Entry," + str(entry));
    }

    if (KeyState.get(SPACE) && entry > 1 && ready == entry) {
      for (int i = 0; i < entry; i++) {
        ships.get(i).entry();
      }
      isPlaying = true;
    }
  } else {
    // play scene
    Ship myShip = ships.get(0);
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
        // if (b.isHit(myShip)) {
        //   myShip.isAlive = false;
        // }
      } else {
        bullets.remove(i);
        i -= 1;
      }
    }

    myShip.control();
    String sendData = "Ships,";
    for (int i = 0; i < 4; i++) {
      Ship ship = ships.get(i);
      if (ship.lives > 0) {
        ship.render();
      }
      sendData += ship.data();
    }
    server.write(sendData);
  }
}
