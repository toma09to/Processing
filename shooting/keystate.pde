public static class KeyState {
  private static final HashMap<Integer, Boolean> states = new HashMap<Integer, Boolean>();

  private KeyState() {}

  static void initialize() {
    states.put(LEFT,  false);
    states.put(RIGHT, false);
    states.put(UP,    false);
    states.put(DOWN,  false);
  }

  public static boolean get(int code) {
    return states.get(code);
  }

  public static void put(int code, boolean state) {
    states.put(code, state);
  }
}

void keyPressed() {
  KeyState.put(keyCode, true);
}

void keyReleased() {
  KeyState.put(keyCode, false);
}
