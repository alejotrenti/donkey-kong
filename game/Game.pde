GameController controller;
GameView view;
int lastTime;

void setup() {
  size(800, 600);
  controller = new GameController(this, width, height);
  view = new GameView(this);
  view.initSprites();
  lastTime = millis();
}

void draw() {
  int now = millis();
  float dt = (now - lastTime) / 1000.0f;
  lastTime = now;
  if (dt > 0.05f) dt = 0.05f; // limitar dt

  controller.update(dt);
  view.render(controller);
}

void keyPressed() {
  controller.onKeyPressed(key, keyCode);
  // Evita que Processing cierre la ventana al apretar ESC (ESC vuelve al menu)
  if (key == ESC) key = 0;
}

void keyReleased() {
  controller.onKeyReleased(key, keyCode);
}
