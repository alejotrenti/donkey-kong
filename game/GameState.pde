interface GameState {
  void onEnter(GameController c);
  void update(GameController c, float dt);
  void onKeyPressed(GameController c, char k, int kc);
  void onKeyReleased(GameController c, char k, int kc);
  String getNombre();
}

class MenuState implements GameState {
  public void onEnter(GameController c) {}
  public void update(GameController c, float dt) {}
  public void onKeyPressed(GameController c, char k, int kc) {
    if (k == ' ' || k == ENTER) {
      c.nuevaPartida();
      c.cambiarEstado(new PlayingState());
    }
    if (k == 'c' || k == 'C') {
      try {
        if (c.getPartida() == null) c.nuevaPartida();
        c.getSaveManager().cargar(c.getPartida());
        c.cambiarEstado(new PlayingState());
      } catch (GameException e) {
        println("Error al cargar: " + e.getMessage());
      }
    }
  }
  public void onKeyReleased(GameController c, char k, int kc) {}
  public String getNombre() { return "MENU"; }
}

class PlayingState implements GameState {
  public void onEnter(GameController c) {}
  public void update(GameController c, float dt) {
    c.actualizarJuego(dt);
  }
  public void onKeyPressed(GameController c, char k, int kc) {
    if (k == 'p' || k == 'P') c.cambiarEstado(new PausedState());
    if (k == ESC) c.cambiarEstado(new MenuState());
    if (k == 'g' || k == 'G') {
      try { c.getSaveManager().guardar(c.getPartida()); }
      catch (GameException e) { println("Error: " + e.getMessage()); }
    }
  }
  public void onKeyReleased(GameController c, char k, int kc) {}
  public String getNombre() { return "JUGANDO"; }
}

class PausedState implements GameState {
  public void onEnter(GameController c) {}
  public void update(GameController c, float dt) {}
  public void onKeyPressed(GameController c, char k, int kc) {
    if (k == 'p' || k == 'P') c.cambiarEstado(new PlayingState());
    if (k == ESC) c.cambiarEstado(new MenuState());
  }
  public void onKeyReleased(GameController c, char k, int kc) {}
  public String getNombre() { return "PAUSADO"; }
}

// Cuando un barril golpea al jugador: el juego queda congelado unos segundos
// mostrando el sprite de golpeado, y recien despues se descuenta la vida
class GolpeadoState implements GameState {
  private final float DURACION = 3.0f; // segundos de pausa
  private float tiempo = 0;

  public void onEnter(GameController c) {}
  public void update(GameController c, float dt) {
    tiempo += dt;
    if (tiempo >= DURACION) {
      boolean gameOver = c.getPartida().perderVida(); // reinicia posiciones y limpia los barriles
      c.cambiarEstado(gameOver ? new GameOverState() : new PlayingState());
    }
  }
  public void onKeyPressed(GameController c, char k, int kc) {
    if (k == ESC) c.cambiarEstado(new MenuState());
  }
  public void onKeyReleased(GameController c, char k, int kc) {}
  public String getNombre() { return "GOLPEADO"; }
}

class VictoryState implements GameState {
  public void onEnter(GameController c) {}
  public void update(GameController c, float dt) {}
  public void onKeyPressed(GameController c, char k, int kc) {
    if (k == 'r' || k == 'R' || k == ENTER) {
      c.nuevaPartida();
      c.cambiarEstado(new PlayingState());
    }
    if (k == ESC) c.cambiarEstado(new MenuState());
  }
  public void onKeyReleased(GameController c, char k, int kc) {}
  public String getNombre() { return "VICTORIA"; }
}

class GameOverState implements GameState {
  public void onEnter(GameController c) {}
  public void update(GameController c, float dt) {}
  public void onKeyPressed(GameController c, char k, int kc) {
    if (k == 'r' || k == 'R' || k == ENTER) {
      c.nuevaPartida();
      c.cambiarEstado(new PlayingState());
    }
    if (k == ESC) c.cambiarEstado(new MenuState());
  }
  public void onKeyReleased(GameController c, char k, int kc) {}
  public String getNombre() { return "GAME OVER"; }
}
