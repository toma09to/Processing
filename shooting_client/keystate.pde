static int SPACE = ' ';
public static class KeyState {
  private static final HashMap<Integer, Boolean> states = new HashMap<Integer, Boolean>();

  private KeyState() {}

  static void initialize() {
    states.put(LEFT,  false);
    states.put(RIGHT, false);
    states.put(UP,    false);
    states.put(DOWN,  false);
    states.put(SPACE, false);
  }

  public static boolean get(int code) {
    return states.get(code);
  }

  public static void put(int code, boolean state) {
    states.put(code, state);
  }
}

void keyPressed() {
  if (key == CODED) {
    KeyState.put(keyCode, true);
  } else {
    KeyState.put(key, true);
  }

  if (!isPlaying && key == ' ') {
    if (!isReady) {
      isReady = true;
      myClient.write("Ready");
      println("r");
    } else {
      isReady = false;
      myClient.write("NotReady");
      println("nr");
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    KeyState.put(keyCode, false);
  } else {
    KeyState.put(key, false);
  }
}
