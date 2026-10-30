class Nivel {
  ArrayList<Plataforma> plataformas = new ArrayList<Plataforma>();
  ArrayList<Escalera> escaleras = new ArrayList<Escalera>();
  ArrayList<Barril> barriles = new ArrayList<Barril>();
  DonkeyKong dk;
  Pauline pauline;
  float ancho, alto;
  float xInicioMario, yInicioMario;

  Nivel(float ancho, float alto) {
    this.ancho = ancho;
    this.alto = alto;
    construirDemo();
  }

  // Factory method: construye el nivel de ejemplo
  private void construirDemo() {
    float altoPlat = 20;

    // Suelo
    plataformas.add(new Plataforma(40, alto - 60, ancho - 80, altoPlat));
    // Plataforma 2 (escalonada)
    plataformas.add(new Plataforma(40, alto - 170, ancho - 200, altoPlat));
    // Plataforma 3
    plataformas.add(new Plataforma(160, alto - 280, ancho - 200, altoPlat));
    // Plataforma 4
    plataformas.add(new Plataforma(40, alto - 390, ancho - 200, altoPlat));
    // Plataforma superior (meta)
    plataformas.add(new Plataforma(180, alto - 500, ancho - 260, altoPlat));
    // Plataforma exclusiva para Donkey Kong (arriba a la izquierda)
    plataformas.add(new Plataforma(100, alto - 500, 120, 20));

    // Escaleras (conectan plataformas contiguas)
    escaleras.add(new Escalera(620, alto - 170, 30, 110)); // suelo -> p2
    escaleras.add(new Escalera(220, alto - 280, 30, 110)); // p2 -> p3
    escaleras.add(new Escalera(600, alto - 390, 30, 110)); // p3 -> p4
    escaleras.add(new Escalera(260, alto - 500, 30, 110)); // p4 -> meta

    // Pauline arriba a la derecha
    pauline = new Pauline(ancho - 120, alto - 500 - 40);
    // DK arriba a la izquierda
    dk = new DonkeyKong(75, alto - 500 - 80);

    xInicioMario = 80;
    yInicioMario = alto - 60 - 36;
  }

  public void update(float dt, Mario mario) {
    // Barriles
    Barril nuevo = dk.intentarLanzar(dt);
    if (nuevo != null) barriles.add(nuevo);

    for (int i = barriles.size() - 1; i >= 0; i--) {
      Barril b = barriles.get(i);
      actualizarBarril(b, dt);
      if (b.getY() > alto + 100 || b.getX() < -100 || b.getX() > ancho + 100) {
        barriles.remove(i);
      }
    }
  }

  private void actualizarBarril(Barril b, float dt) {
    // Buscar plataforma bajo el barril
    float[] bb = b.getBounds();
    Plataforma soporte = null;
    for (Plataforma p : plataformas) {
      float[] pb = p.getBounds();

      // ¡NUEVA LÍNEA! Si la plataforma está muy arriba (como las de DK o Pauline), el barril la ignora.
      if (pb[1] < alto - 480) continue;

      boolean encimaX = bb[0] + bb[2] > pb[0] && bb[0] < pb[0] + pb[2];
      boolean justoDebajo = Math.abs((bb[1] + bb[3]) - pb[1]) < 12;
      if (encimaX && justoDebajo) {
        soporte = p;
        break;
      }
    }

    if (soporte != null) {
      b.setCayendo(false);
      b.setPos(b.getX(), soporte.getY() - b.getH());
      b.update(dt);
      // Si llega al borde de la plataforma, cae
      float[] sb = soporte.getBounds();
      if (b.getX() + b.getW() < sb[0] || b.getX() > sb[0] + sb[2]) {
        b.setCayendo(true);
      }
    } else {
      b.setCayendo(true);
      b.update(dt);
    }

    // Rebotar en paredes laterales
    if (b.getX() < 20) b.setDireccion(1);
    if (b.getX() + b.getW() > ancho - 20) b.setDireccion(-1);
  }

  public Mario crearMario() {
    return new Mario(xInicioMario, yInicioMario);
  }
}
