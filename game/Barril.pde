class Barril implements Colisionable, Movible {
  private float x, y;
  private float w = 22, h = 22;
  private float vx;
  private float vy;
  private float gravedad = 1200f;
  private boolean rodando;
  private boolean cayendo;
  private boolean saltado; // true cuando Mario ya lo salto (para sumar puntos una sola vez)

  Barril(float x, float y, int direccion) {
    this.x = x; this.y = y;
    this.vx = direccion * 180f;
    this.vy = 0;
    this.rodando = true;
  }

  public void update(float dt) {
    x += vx * dt;
    if (cayendo) {
      vy += gravedad * dt;
      y += vy * dt;
    }
  }

  public void setCayendo(boolean b) { cayendo = b; if (!b) vy = 0; }
  public boolean isCayendo() { return cayendo; }
  public void setDireccion(int dir) { vx = dir * 180f; }
  public int getDireccion() { return vx > 0 ? 1 : -1; }
  public boolean isSaltado() { return saltado; }
  public void setSaltado(boolean s) { saltado = s; }

  public float[] getBounds() { return new float[]{x, y, w, h}; }
  public float getX() { return x; }
  public float getY() { return y; }
  public float getW() { return w; }
  public float getH() { return h; }
  public void setPos(float nx, float ny) { x = nx; y = ny; }
}
