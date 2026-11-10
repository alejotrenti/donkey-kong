class Partida {
  private Nivel nivel;
  private Mario mario;
  private int vidas;
  private int puntaje;
  private int vidasIniciales = 3;
  private float xInicio, yInicio;
  private float yPiesRecord; // altura (y de los pies) del piso mas alto alcanzado; menor y = mas arriba

  Partida(float ancho, float alto) {
    nivel = new Nivel(ancho, alto);
    mario = nivel.crearMario();
    xInicio = mario.getX();
    yInicio = mario.getY();
    vidas = vidasIniciales;
    puntaje = 0;
    yPiesRecord = yInicio + mario.getH();
  }

  // Devuelve true si yPies es un piso mas alto que cualquiera alcanzado antes (y lo registra)
  public boolean registrarAltura(float yPies) {
    if (yPies < yPiesRecord - 1) {
      yPiesRecord = yPies;
      return true;
    }
    return false;
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
    yPiesRecord = yInicio + mario.getH();
    reiniciarPosiciones();
  }
  
  public void setVidas(int puntaje, int vidas) {
    this.puntaje = puntaje;
    this.vidas = vidas;
  }
}
