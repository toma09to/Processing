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
      ships.add(new Ship(0, 0, 0, 0, green));
      ships.add(new Ship(myID, -100, -100, 0, red));
      isPlaying = true;
    }
  } else {
    // play scene
    Ship myShip = ships.get(myID);
    background(0);

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
  }
}

void clientEvent(Client c) {
  String readStr = c.readString();
  String[] data = split(readStr, ',');
  println("Client: " + readStr);

  if (data[0].equals("Ship")) {
    if (int(data[1]) != myID) {
      Ship ship = ships.get(int(data[1]));
      ship.move(float(data[2]), float(data[3]), float(data[4]), boolean(data[5]));
    }
  } else if (data[0].equals("Bullet")) {
    bullets.add(new Bullet(unhex(data[1]), float(data[2]), float(data[3]), float(data[4])));
  } else if (data[0].equals("Join")) {
    if (float(data[1]) == idNum) {
      myClient.write("Joined");
      myID = int(data[2]);
      isConnected = true;
    }
  }
}
