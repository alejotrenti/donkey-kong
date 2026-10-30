class Mario extends Personaje implements Movible {
  private float vx, vy;
  private boolean enSuelo;
  private boolean enEscalera;
  private float velocidad = 220f;
  private float salto = -420f;
  private float gravedad = 1400f;
  private float velocidadEscalera = 160f;
  private boolean ultimaDireccionIzquierda = false; // NUEVA VARIABLE
  private boolean izquierda, derecha, subir, bajar;

  Mario(float x, float y) {
    super(x, y, 28, 36);
    enSuelo = false;
    enEscalera = false;
  }

  public void setInput(boolean izq, boolean der, boolean sub, boolean baj) {
    this.izquierda = izq;
    this.derecha = der;
    this.subir = sub;
    this.bajar = baj;
  }

  public void saltar() {
    if (enSuelo && !enEscalera) {
      vy = salto;
      enSuelo = false;
    }
  }

  public void update(float dt) {
    // Movimiento horizontal
    vx = 0;
    if (izquierda) vx -= velocidad;
    if (derecha) vx += velocidad;

    // Escaleras: movimiento vertical
    if (enEscalera) {
      if (subir) vy = -velocidadEscalera;
      else if (bajar) vy = velocidadEscalera;
      else vy = 0;
    } else {
      vy += gravedad * dt;
    }

    x += vx * dt;
    y += vy * dt;
    
    if (derecha) ultimaDireccionIzquierda = false;
    if (izquierda) ultimaDireccionIzquierda = true;
  }

  public void setEnSuelo(boolean b) { enSuelo = b; if (b) vy = 0; }
  public void setEnEscalera(boolean b) { enEscalera = b; }
  public boolean isEnEscalera() { return enEscalera; }
  public boolean isEnSuelo() { return enSuelo; }
  public void setPos(float nx, float ny) { x = nx; y = ny; vy = 0; }
  public void setVy(float v) { vy = v; }
  public float getVy() { return vy; }
  public void setVx(float v) { vx = v; }
  public float getVx() { return vx; }
  public boolean miraIzquierda() { return ultimaDireccionIzquierda; }

}
