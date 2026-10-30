abstract class Personaje implements Colisionable {
  protected float x, y;
  protected float w, h;

  Personaje(float x, float y, float w, float h) {
    this.x = x; this.y = y; this.w = w; this.h = h;
  }

  public float[] getBounds() {
    return new float[]{x, y, w, h};
  }

  public float getX() { return x; }
  public float getY() { return y; }
  public float getW() { return w; }
  public float getH() { return h; }
}
