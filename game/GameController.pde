class GameController {
  private GameState estado;
  private Partida partida;
  private float ancho, alto;
  private SaveManager saveManager;
  public boolean izquierda, derecha, subir, bajar;
  public boolean mirandoIzquierda = false;

  // Puntaje
  private final int PUNTOS_POR_PISO = 100;    // la primera vez que llega a un piso mas alto
  private final int PUNTOS_POR_BARRIL = 100;  // cada barril que salta
  private final int PUNTOS_POR_GANAR = 1000;
  private final float ALTURA_SALTO_BARRIL = 50; // distancia max. entre los pies y el barril para contar el salto

  GameController(PApplet app, float ancho, float alto) {
    this.ancho = ancho;
    this.alto = alto;
    this.saveManager = new SaveManager(app);
    this.estado = new MenuState();
    this.estado.onEnter(this);
  }

  public SaveManager getSaveManager() { return saveManager; }

  public void nuevaPartida() {
    partida = new Partida(ancho, alto);
  }

  public Partida getPartida() { return partida; }
  public GameState getEstado() { return estado; }
  public String getNombreEstado() { return estado.getNombre(); }

  public void cambiarEstado(GameState nuevo) {
    this.estado = nuevo;
    this.estado.onEnter(this);
  }

  public void update(float dt) {
    estado.update(this, dt);
  }

  public void onKeyPressed(char k, int kc) {
    if (estado instanceof PlayingState) {
      if (k == 'a' || k == 'A') { izquierda = true; mirandoIzquierda = true; }
      if (k == 'd' || k == 'D') { derecha = true; mirandoIzquierda = false; }
      if (k == 'w' || k == 'W') subir = true;
      if (k == 's' || k == 'S') bajar = true;
      if (k == ' ') {
        partida.getMario().saltar();
      }
    }
    estado.onKeyPressed(this, k, kc);
  }

  public void onKeyReleased(char k, int kc) {
    if (k == 'a' || k == 'A') izquierda = false;
    if (k == 'd' || k == 'D') derecha = false;
    if (k == 'w' || k == 'W') subir = false;
    if (k == 's' || k == 'S') bajar = false;
    estado.onKeyReleased(this, k, kc);
  }

  // Lógica principal del juego (delegada desde PlayingState)
  public void actualizarJuego(float dt) {
    if (partida == null) return;
    Mario m = partida.getMario();
    Nivel n = partida.getNivel();

    m.setInput(izquierda, derecha, subir, bajar);
    if (izquierda) mirandoIzquierda = true;
    if (derecha) mirandoIzquierda = false;
    m.update(dt);

    // PRIMERO Escaleras
    resolverEscaleras(m, n);
    
    // Colisiones con plataformas (resolver X e Y por separado)
    resolverPlataformas(m, n);

    // Limitar a pantalla
    limitarMario(m);

    // Actualizar barriles
    n.update(dt, m);

    // Colisiones con barriles
    for (int i = n.barriles.size() - 1; i >= 0; i--) {
      Barril b = n.barriles.get(i);
      if (Colisiones.intersecta(m, b)) {
        // Pausa de 3 s mostrando al jugador golpeado; GolpeadoState descuenta la vida al terminar
        cambiarEstado(new GolpeadoState());
        return; // cortar el update: el juego queda congelado
      }
    }
    

    // Colisión con Pauline → victoria
    if (Colisiones.intersecta(m, n.pauline)) {
      partida.sumarPuntaje(PUNTOS_POR_GANAR + partida.getBonus()); // se cobra el bonus que quede
      cambiarEstado(new VictoryState());
      return; // la partida termino: no sumar nada mas
    }

    // Bonus: baja con el tiempo; si llega a 0 se acabo el tiempo y termina la partida
    if (partida.actualizarBonus(dt)) {
      cambiarEstado(new GameOverState());
      return;
    }

    // Puntaje
    puntuarAvance(m);
    puntuarSaltos(m, n);
  }

  // +PUNTOS_POR_PISO la primera vez que Mario se para en un piso mas alto que todos los anteriores
  private void puntuarAvance(Mario m) {
    if (m.isEnSuelo() && partida.registrarAltura(m.getY() + m.getH())) {
      partida.sumarPuntaje(PUNTOS_POR_PISO);
    }
  }

  // +PUNTOS_POR_BARRIL por cada barril que pasa por debajo de Mario mientras esta en el aire
  private void puntuarSaltos(Mario m, Nivel n) {
    if (m.isEnSuelo() || m.isEnEscalera()) return;
    float pies = m.getY() + m.getH();
    for (Barril b : n.barriles) {
      if (b.isSaltado()) continue; // cada barril suma una sola vez
      boolean debajoEnX = b.getX() < m.getX() + m.getW() && b.getX() + b.getW() > m.getX();
      float distancia = b.getY() - pies; // > 0: el barril esta por debajo de los pies
      if (debajoEnX && distancia >= 0 && distancia < ALTURA_SALTO_BARRIL) {
        b.setSaltado(true);
        partida.sumarPuntaje(PUNTOS_POR_BARRIL);
      }
    }
  }

  private void resolverPlataformas(Mario m, Nivel n) {
    if (m.isEnEscalera()) {
      m.setEnSuelo(false);
      return;
    }
  
    float[] mb = m.getBounds();
    m.setEnSuelo(false);

    for (Plataforma p : n.plataformas) {
      float[] pb = p.getBounds();
      if (!Colisiones.intersecta(mb, pb)) continue;

      // Resolver por el eje de menor penetración
      float overlapX = Math.min(mb[0] + mb[2], pb[0] + pb[2]) - Math.max(mb[0], pb[0]);
      float overlapY = Math.min(mb[1] + mb[3], pb[1] + pb[3]) - Math.max(mb[1], pb[1]);

      if (overlapY < overlapX) {
        // Colisión vertical
        if (mb[1] + mb[3] / 2 < pb[1] + pb[3] / 2) {
          // Mario viene desde arriba
          m.setPos(m.getX(), pb[1] - m.getH());
          m.setEnSuelo(true);
        } else {
          // Mario golpea desde abajo
          m.setPos(m.getX(), pb[1] + pb[3]);
          m.setVy(0);
        }
      } else {
        // Colisión horizontal
        if (mb[0] + mb[2] / 2 < pb[0] + pb[2] / 2) {
          m.setPos(pb[0] - m.getW(), m.getY());
        } else {
          m.setPos(pb[0] + pb[2], m.getY());
        }
      }
      mb = m.getBounds();
    }
  }

  private void resolverEscaleras(Mario m, Nivel n) {
    Escalera actual = null;
    for (Escalera e : n.escaleras) {
      if (Colisiones.intersecta(m, e)) { actual = e; break; }
    }
    // No dejar que Mario baje mas alla del pie de la escalera (ahi esta el piso)
    if (actual != null) {
      float pie = actual.getY() + actual.getH();
      if (m.getY() + m.getH() > pie) {
        m.setPos(m.getX(), pie - m.getH());
      }
    }
    m.setEnEscalera(actual != null);
  }

  private void limitarMario(Mario m) {
    if (m.getX() < 0) m.setPos(0, m.getY());
    if (m.getX() + m.getW() > ancho) m.setPos(ancho - m.getW(), m.getY());
    if (m.getY() > alto) {
      // Cayó fuera: pierde vida
      boolean go = partida.perderVida();
      if (go) cambiarEstado(new GameOverState());
    }
  }
}
