class GameException extends Exception {
  GameException(String msg) { super(msg); }
}
class SaveGameException extends GameException {
  SaveGameException(String msg) { super(msg); }
}
class LoadGameException extends GameException {
  LoadGameException(String msg) { super(msg); }
}
