import processing.net.*;
Client myClient;

boolean isConnected = false;
int lastRequestTime = -1000;
float idNum;

int myID;
boolean isPlaying = false;
PFont f;

color green = color(0, 255, 0);
color red = color(255, 0, 0);
color blue = color(0, 0, 255);
color yellow = color(255, 255, 0);
color[] colorList = {green, red, blue, yellow};

ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void setup() {
  myClient = new Client(this, "127.0.0.1", 20000);
  
  size(600,600);
  background(0);
  ellipseMode(CENTER);
  stroke(green);
  noFill();

  f = createFont("Arial", 16, true);
  textFont(f);

  KeyState.initialize();

  for (int i = 0; i < 4; i++) {
    ships.add(new Ship(i, 0, 0, 0, colorList[i]));
  }
}

void draw() {
  if (!isPlaying) {
    // entry scene
    if (!isConnected) {
      if (millis() - lastRequestTime > 1000) {
        idNum = random(Float.MAX_VALUE);
        myClient.write("JoinReq," + str(idNum));
        lastRequestTime = millis();
      }
    } else {
      ships.get(0).entry();
      ships.get(1).entry();
      ships.get(2).entry();
      ships.get(3).entry();
      isPlaying = true;
    }
  } else {
    // play scene
    Ship myShip = ships.get(myID);
    background(0);
    if (myShip.fire()) {
      Bullet b = new Bullet(myShip);
      myClient.write(b.data());
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
    myClient.write("Ship," + myShip.data());
    for (int i = 0; i < 4; i++) {
      Ship ship = ships.get(i);
      if (ship.lives > 0) {
        ship.render();
      }
    }
  }
}

void clientEvent(Client c) {
  if (millis() <= 2000) {
    return;
  }
  String readStr = c.readString();
  String[] data = split(readStr, ',');

  try {
    if (data[0].equals("Ships")) {
      for (int i = 0; i < 4; i++) {
        if (i == myID) continue;
        ships.get(int(data[i*7+1])).move(float(data[i*7+2]), float(data[i*7+3]), float(data[i*7+4]), boolean(data[i*7+5]), boolean(data[i*7+6]), int(data[i*7+7]));
      }
    } else if (data[0].equals("Bullet") && int(data[1]) != myID) {
      bullets.add(new Bullet(int(data[1]), unhex(data[2]), float(data[3]), float(data[4]), float(data[5])));
    } else if (data[0].equals("Join") && float(data[1]) == idNum) {
      myClient.write("Joined");
      myID = int(data[2]);
      isConnected = true;
    }
  } catch (NullPointerException e) {
    e.printStackTrace();
  }
}
