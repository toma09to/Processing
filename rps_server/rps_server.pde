import processing.net.*;
Server server;

PFont f;
char myHand = '0';
char opponentHand = '0';

int previousEndTime = 0;

void setup() {
  server = new Server(this, 20000);
  println("start server at address: ", server.ip());
  f = createFont("Arial", 16, true);
  background(255);
}

void draw() {
  Client c = server.available();
  if (c != null) {
    String s = c.readString();
    opponentHand = s.charAt(0);
  }
  
  if (myHand != '0' && opponentHand != '0') {
    textFont(f);
    fill(0);
    textAlign(CENTER);
    
    int judge = (int(myHand) - int(opponentHand) + 3) % 3;
    String message;
    if (judge == 1) {
      message = "You win";
    } else if (judge == 2) {
      message = "You lose";
    } else {
      message = "Draw";
    }
    text(message, width/2, height/2+16);
    
    myHand = '0';
    opponentHand = '0';
    previousEndTime = millis();
  }
  
  if (millis() - previousEndTime >= 3000 && millis() - previousEndTime <= 3050) {
    background(255);
  }
}

void keyTyped() {
  if (millis() - previousEndTime > 3000) {
    throwHand();
    server.write(myHand);
  }
}

void throwHand() {
  myHand = key;
  
  if (myHand < '0' || myHand > '3') {
    myHand = '0';
  }
  
  String hand;
  if (myHand == '1') {
    hand = "Rock";
  } else if (myHand == '2') {
    hand = "Paper";
  } else {
    hand = "Scissors";
  }
  
  background(255);
  
  textFont(f);
  fill(0);
  textAlign(CENTER);
  text(hand, width/2, height/2);
}
