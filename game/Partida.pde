class Partida {
  private Nivel nivel;
  private Mario mario;
  private int vidas;
  private int puntaje;
  private int vidasIniciales = 3;
  private float xInicio, yInicio;

  Partida(float ancho, float alto) {
    nivel = new Nivel(ancho, alto);
    mario = nivel.crearMario();
    xInicio = mario.getX();
    yInicio = mario.getY();
    vidas = vidasIniciales;
    puntaje = 0;
  }

  public Nivel getNivel() { return nivel; }
  public Mario getMario() { return mario; }
  public int getVidas() { return vidas; }
  public int getPuntaje() { return puntaje; }

  public void sumarPuntaje(int p) { puntaje += p; }

  public boolean perderVida() {
    vidas--;
    if (vidas <= 0) return true;
    reiniciarPosiciones();
    return false;
  }

  public void reiniciarPosiciones() {
    mario.setPos(xInicio, yInicio);
    mario.setVx(0);
    mario.setVy(0);
    nivel.barriles.clear();
    nivel.dk.reset();
  }

  public void reiniciar() {
    vidas = vidasIniciales;
    puntaje = 0;
    reiniciarPosiciones();
  }
  
  public void setVidas(int puntaje, int vidas) {
    this.puntaje = puntaje;
    this.vidas = vidas;
  }
}
