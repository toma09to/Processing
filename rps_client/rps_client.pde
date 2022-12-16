import processing.net.*;
Client client;

PFont f;
char myHand = '0';
char opponentHand = '0';

int previousEndTime = 0;

void setup() {
  client = new Client(this, "127.0.0.1", 20000);
  f = createFont("Arial", 16, true);
  background(255);
}

void draw() {
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
    text(message, width/2, height/2 + 16);
    
    myHand = '0';
    opponentHand = '0';
    previousEndTime = millis();
  }
  
  if (millis() - previousEndTime >= 3000 && millis() - previousEndTime <= 3050) {
    background(255);
  }
}

void clientEvent(Client c) {
  String s = c.readString();
  opponentHand = s.charAt(0);
  
  if (opponentHand < '0' || opponentHand > '3') {
    opponentHand = '0';
  }
}

void keyTyped() {
  if (millis() - previousEndTime > 3000) {
    throwHand();
    client.write(myHand);
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
  } else if (myHand == '3') {
    hand = "Scissors";
  } else {
    hand = "?";
  }
  
  background(255);
    
  textFont(f);
  fill(0);
  textAlign(CENTER);
  text(hand, width/2, height/2);
}
