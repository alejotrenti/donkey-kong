class DonkeyKong extends Personaje {
  private float timer;
  private float intervalo = 2.2f;
  private boolean mirandoDerecha = true;

  DonkeyKong(float x, float y) {
    super(x, y, 110, 80);
  }

  // Devuelve un barril nuevo si toca lanzar, o null
  public Barril intentarLanzar(float dt) {
    timer += dt;
    if (timer >= intervalo) {
      timer = 0;
      mirandoDerecha = !mirandoDerecha;
      float bx = mirandoDerecha ? x + w : x - 24;
      float by = y + h - 24;
      return new Barril(bx, by, mirandoDerecha ? 1 : -1);
    }
    return null;
  }
   
  public float getTimer() { return timer; }

  public void reset() { timer = 0; }
}
