class Partida {
  private Nivel nivel;
  private Mario mario;
  private int vidas;
  private int puntaje;
  private int vidasIniciales = 3;
  private float xInicio, yInicio;
  private float yPiesRecord; // altura (y de los pies) del piso mas alto alcanzado; menor y = mas arriba

  // Bonus: uno solo por partida; baja con el tiempo y se suma al ganar. Si llega a 0, Game Over.
  private final int BONUS_INICIAL = 5000;
  private final int BONUS_PASO = 100;          // cuanto baja...
  private final float BONUS_INTERVALO = 2.0f;  // ...cada cuantos segundos
  private int bonus;
  private float timerBonus;

  Partida(float ancho, float alto) {
    nivel = new Nivel(ancho, alto);
    mario = nivel.crearMario();
    xInicio = mario.getX();
    yInicio = mario.getY();
    vidas = vidasIniciales;
    puntaje = 0;
    yPiesRecord = yInicio + mario.getH();
    bonus = BONUS_INICIAL;
    timerBonus = 0;
  }

  // Descuenta el bonus con el paso del tiempo. Devuelve true si llego a 0 (se acabo el tiempo)
  public boolean actualizarBonus(float dt) {
    timerBonus += dt;
    while (timerBonus >= BONUS_INTERVALO) {
      timerBonus -= BONUS_INTERVALO;
      bonus = Math.max(0, bonus - BONUS_PASO);
    }
    return bonus == 0;
  }

  public int getBonus() { return bonus; }
  public void setBonus(int b) { bonus = b; }
  public float getYPiesRecord() { return yPiesRecord; }
  public void setYPiesRecord(float y) { yPiesRecord = y; }

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
    bonus = BONUS_INICIAL;
    timerBonus = 0;
    reiniciarPosiciones();
  }
  
  public void setVidas(int puntaje, int vidas) {
    this.puntaje = puntaje;
    this.vidas = vidas;
  }
}
