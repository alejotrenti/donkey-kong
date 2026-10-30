class GameView {
  PApplet app;
  GameView(PApplet app) { this.app = app; }
  
  boolean ultimaDireccionIzquierda = false;
  PImage marioIdle, marioWalk1, marioWalk2, marioWalk3, marioJump;
  PImage marioClimbFrente, marioClimbEspalda1, marioClimbEspalda2, marioClimbEspalda3;
  PImage marioGolpeado;
  PImage dkIdle, dkLanzar;
  PImage paulineImg;

  
  public void initSprites() {
    marioIdle = loadImage("mario_idle.png");
    marioWalk1 = loadImage("mario_walk_1.png");
    marioWalk2 = loadImage("mario_walk_2.png");
    marioWalk3 = loadImage("mario_walk_3.png");
    marioJump = loadImage("mario_jump.png");
    marioClimbFrente = loadImage("mario_climb_frente.png");
    marioClimbEspalda1 = loadImage("mario_climb_espalda_1.png");
    marioClimbEspalda2 = loadImage("mario_climb_espalda_2.png");
    marioClimbEspalda3 = loadImage("mario_climb_espalda_3.png");
    marioGolpeado = loadImage("mario_golpeado.png");
    dkIdle = loadImage("dk_idle.png");
    dkLanzar = loadImage("dk_brazos_arriba_1.png");
    paulineImg = loadImage("pauline.png");
  }
  
  public void render(GameController c) {
    String estado = c.getNombreEstado();
    if (estado.equals("MENU")) {
      dibujarMenu();
    } else {
      dibujarJuego(c);
      if (estado.equals("PAUSADO")) dibujarPausa();
      if (estado.equals("VICTORIA")) dibujarVictoria(c);
      if (estado.equals("GAME OVER")) dibujarGameOver(c);
    }
  }

  private void dibujarMenu() {
    // 1. Fondo estilo Arcade (Gradiente vertical oscuro)
    for (int i = 0; i < app.height; i++) {
      float inter = app.map(i, 0, app.height, 0, 1);
      // De azul muy oscuro a negro
      app.stroke(app.lerpColor(app.color(10, 15, 40), app.color(0, 0, 0), inter));
      app.line(0, i, app.width, i);
    }
    app.noStroke();

    // 2. Título con Sombra (Efecto 3D)
    app.textAlign(CENTER, CENTER);
    app.textSize(64);
    app.fill(200, 30, 30); // Sombra roja
    app.text("DONKEY KONG", app.width / 2 + 4, 104); 
    app.fill(255, 220, 60); // Texto amarillo
    app.text("DONKEY KONG", app.width / 2, 100);

    // Subtítulo
    app.textSize(20);
    app.fill(150, 200, 255);

    // 3. Mostrar los Sprites en el menú (Si cargaron bien)
    if (marioIdle != null && dkIdle != null && paulineImg != null) {
      app.imageMode(CENTER);
      
      // DK a la izquierda, un poco animado
      float dkY = 250 + app.sin(app.frameCount * 0.05f) * 10;
      app.image(dkIdle, app.width / 2 - 150, dkY, 110, 80);
      
      // Pauline a la derecha
      float plY = 250 + app.sin(app.frameCount * 0.05f) * 10;
      app.image(paulineImg, app.width / 2 + 150, plY, 30, 45);
      
      // Mario en el medio, saltando
      app.image(marioJump, app.width / 2, 260 + app.abs(app.sin(app.frameCount * 0.1f)) * -20, 40, 50);
    }

    // 4. Controles en un "Panel" oscuro semi-transparente
    app.fill(0, 0, 0, 150);
    app.rect(app.width / 2 - 200, 340, 400, 160, 10); // Rectángulo redondeado
    
    app.textSize(16);
    app.fill(255);
    
    // Opciones principales (Parpadean para llamar la atención)
    if (app.frameCount % 60 < 40) {
      app.fill(255, 255, 0);
      app.textSize(20);
      app.text("Presiona ESPACIO para jugar", app.width / 2, 370);
    }
    
    app.fill(255);
    app.textSize(16);
    app.text("C: Cargar partida guardada", app.width / 2, 410);
    
    app.fill(180);
    app.textSize(14);
    app.text("A/D: Mover   |   W/S: Escaleras   |   ESPACIO: Saltar", app.width / 2, 450);
    app.text("P: Pausa   |   G: Guardar   |   ESC: Menú", app.width / 2, 475);
  }

  private void dibujarJuego(GameController c) {
    app.background(30, 30, 60);
    Partida p = c.getPartida();
    if (p == null) return;
    Nivel n = p.getNivel();

    // Plataformas
    app.noStroke();
    for (Plataforma pl : n.plataformas) {
      // Base roja
      app.fill(180, 60, 60);
      app.rect(pl.getX(), pl.getY(), pl.getW(), pl.getH());
      
      // Brillo superior (da sensación de volumen)
      app.fill(230, 100, 100);
      app.rect(pl.getX(), pl.getY(), pl.getW(), 4);
      
      // Sombra inferior
      app.fill(100, 30, 30);
      app.rect(pl.getX(), pl.getY() + pl.getH() - 4, pl.getW(), 4);
      
      // Remaches metálicos (cada 30 píxeles)
      app.fill(60, 20, 20);
      for (float rx = pl.getX() + 15; rx < pl.getX() + pl.getW(); rx += 30) {
        app.ellipse(rx, pl.getY() + pl.getH() / 2, 4, 4);
      }
    }

    // Escaleras
    // Color #18B2B1 en RGB es (24, 178, 177)
    app.fill(24, 178, 177); 
    app.noStroke();
    
    for (Escalera e : n.escaleras) {
      float x = e.getX();
      float y = e.getY();
      float w = e.getW();
      float h = e.getH();
      
      // 1. Los dos tubos verticales laterales (los pasamanos)
      float grosorTubo = 5;
      app.rect(x, y, grosorTubo, h);             // Tubo izquierdo
      app.rect(x + w - grosorTubo, y, grosorTubo, h); // Tubo derecho
      
      // 2. Los escalones (travesaños horizontales)
      // Calculamos cuántos escalones entran según el alto
      float altoEscalon = 14; 
      for (float ey = y + 8; ey < y + h; ey += altoEscalon) {
        app.rect(x, ey, w, 4); // Travesaño
      }
      
      // 3. (Opcional) Un pequeño brillo para que parezcan de metal
      app.fill(100, 230, 230, 150); // Celeste claro semi-transparente
      app.rect(x, y, 2, h); // Brillo en el tubo izquierdo
      app.rect(x + w - grosorTubo, y, 2, h); // Brillo en el tubo derecho
      
      // Restauramos el color para el próximo bucle
      app.fill(24, 178, 177); 
    }

    // Donkey Kong
    if (dkIdle != null) {
      PImage imgDk = dkIdle;
      
      // Si el timer de DK está entre 1.9 y 2.2 (justo cuando tira el barril), mostramos la pose
      // Ajustá el 1.9 dependiendo del intervalo (2.2f) que pusiste en DonkeyKong.pde
      float t = n.dk.getTimer();
      if (t > 1.9f && t < 2.2f) {
        imgDk = dkLanzar;
      }
      
      app.imageMode(CORNER);
      app.image(imgDk, n.dk.getX(), n.dk.getY(), n.dk.getW(), n.dk.getH());
    } else {
      // Fallback
      app.fill(120, 70, 30);
      app.rect(n.dk.getX(), n.dk.getY(), n.dk.getW(), n.dk.getH());
    }

    // Pauline
    if (paulineImg != null) {
      app.imageMode(CORNER);
      // Le damos un poquito más de ancho y alto visual para que resalte
      app.image(paulineImg, n.pauline.getX(), n.pauline.getY(), n.pauline.getW(), n.pauline.getH());
    } else {
      // Fallback por si no carga la imagen
      app.fill(255, 150, 200);
      app.rect(n.pauline.getX(), n.pauline.getY(), n.pauline.getW(), n.pauline.getH());
      app.fill(0);
      app.textSize(10);
      app.textAlign(CENTER, CENTER);
      app.text("HELP", n.pauline.getX() + n.pauline.getW() / 2, n.pauline.getY() + n.pauline.getH() / 2);
    }

    // Barriles
    for (Barril b : n.barriles) {
      float cx = b.getX() + b.getW() / 2;
      float cy = b.getY() + b.getH() / 2;
      float r = b.getW() / 2;

      // 1. Cuerpo del barril (madera)
      app.fill(160, 100, 50);
      app.ellipse(cx, cy, b.getW(), b.getH());

      // 2. Aros metálicos (líneas verticales oscuras)
      app.stroke(90, 50, 20);
      app.strokeWeight(2);
      app.line(cx - r/2, cy - r*0.8, cx - r/2, cy + r*0.8);
      app.line(cx + r/2, cy - r*0.8, cx + r/2, cy + r*0.8);
      
      // 3. Línea horizontal central (la "tapa" del barril)
      app.line(cx - r*0.8, cy, cx + r*0.8, cy);
      
      // 4. Animación de giro (rayitas que rotan)
      app.noStroke();
      app.fill(120, 70, 30);
      app.pushMatrix();
      app.translate(cx, cy);
      app.rotate(app.frameCount * 0.15f); // Gira constantemente
      app.rect(-r*0.6, -2, r*1.2, 4); // La línea que gira
      app.popMatrix();

      // Restaurar estilos
      app.noStroke(); 
    }

    // Mario
    dibujarMario(c);

    // HUD
    dibujarHUD(p);
  }

  private void dibujarHUD(Partida p) {
    app.fill(0, 0, 0, 150);
    app.noStroke();
    app.rect(0, 0, app.width, 30);
    app.fill(255);
    app.textAlign(LEFT, CENTER);
    app.textSize(16);
    app.text("Vidas: " + p.getVidas(), 20, 15);
    app.text("Puntaje: " + p.getPuntaje(), 150, 15);
    app.textAlign(RIGHT, CENTER);
    app.text("G: guardar | P: pausa | ESC: menu", app.width - 20, 15);
  }

  private void dibujarPausa() {
    app.fill(0, 0, 0, 180);
    app.rect(0, 0, app.width, app.height);
    app.fill(255);
    app.textAlign(CENTER, CENTER);
    app.textSize(48);
    app.text("PAUSA", app.width / 2, app.height / 2 - 20);
    app.textSize(18);
    app.text("P: continuar | ESC: menu", app.width / 2, app.height / 2 + 40);
  }

  private void dibujarVictoria(GameController c) {
    Partida p = c.getPartida();
    app.fill(0, 0, 0, 180);
    app.rect(0, 0, app.width, app.height);
    app.fill(255, 220, 60);
    app.textAlign(CENTER, CENTER);
    app.textSize(52);
    app.text("¡VICTORIA!", app.width / 2, app.height / 2 - 40);
    app.fill(255);
    app.textSize(22);
    app.text("Puntaje final: " + (p != null ? p.getPuntaje() : 0),
             app.width / 2, app.height / 2 + 20);
    app.textSize(18);
    app.text("R: nueva partida | ESC: menu", app.width / 2, app.height / 2 + 70);
  }

  private void dibujarGameOver(GameController c) {
    Partida p = c.getPartida();
    app.fill(0, 0, 0, 200);
    app.rect(0, 0, app.width, app.height);
    app.fill(230, 60, 60);
    app.textAlign(CENTER, CENTER);
    app.textSize(52);
    app.text("GAME OVER", app.width / 2, app.height / 2 - 40);
    app.fill(255);
    app.textSize(22);
    app.text("Puntaje final: " + (p != null ? p.getPuntaje() : 0),
             app.width / 2, app.height / 2 + 20);
    app.textSize(18);
    app.text("R: reintentar | ESC: menu", app.width / 2, app.height / 2 + 70);
  }
  
  private void dibujarMario(GameController c) {
    Mario m = c.getPartida().getMario();
    if (marioIdle == null) return; 

    PImage img = marioIdle;
    
    // Leemos la dirección directo del controlador (que ya la memorizó)
    boolean mirandoIzquierda = c.mirandoIzquierda;


    if (m.isEnEscalera()) {
      if (m.getVy() != 0) {
        int f = (app.frameCount / 8) % 3;
        img = (f == 0) ? marioClimbEspalda1 : (f == 1) ? marioClimbEspalda2 : marioClimbEspalda3;
      } else {
        img = marioClimbFrente;
      }
    } else if (!m.isEnSuelo()) {
      img = marioJump;
    } else if (app.abs(m.getVx()) > 1) {
      int f = (app.frameCount / 6) % 3;
      img = (f == 0) ? marioWalk1 : (f == 1) ? marioWalk2 : marioWalk3;
    }

    app.imageMode(CORNER);
    if (mirandoIzquierda) {
      app.pushMatrix();
      app.translate(m.getX() + m.getW(), m.getY());
      app.scale(-1, 1);
      app.image(img, 0, 0, m.getW(), m.getH());
      app.popMatrix();
    } else {
      app.image(img, m.getX(), m.getY(), m.getW(), m.getH());
    }
  } // Cierra dibujarMario
}   // Cierra class GameView
