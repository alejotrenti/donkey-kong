class SaveManager {
  static final String ARCHIVO = "partida.txt";
  private PApplet app;

  SaveManager(PApplet app) {
    this.app = app;
  }

  void guardar(Partida p) throws SaveGameException {
    try {
      PrintWriter pw = app.createWriter(ARCHIVO);
      pw.println(p.getVidas());
      pw.println(p.getPuntaje());
      pw.println(p.getMario().getX());
      pw.println(p.getMario().getY());
      pw.flush();
      pw.close();
    } catch (Exception e) {
      throw new SaveGameException("No se pudo guardar: " + e.getMessage());
    }
  }

  void cargar(Partida p) throws LoadGameException {
    try {
      String[] lineas = app.loadStrings(ARCHIVO);
      if (lineas == null || lineas.length < 4) {
        throw new LoadGameException("Archivo inválido o incompleto");
      }
      int vidas = Integer.parseInt(lineas[0].trim());
      int puntaje = Integer.parseInt(lineas[1].trim());
      float mx = Float.parseFloat(lineas[2].trim());
      float my = Float.parseFloat(lineas[3].trim());

      p.reiniciar();
      p.setVidas(puntaje, vidas);
      p.getMario().setPos(mx, my);
    } catch (LoadGameException e) {
      throw e;
    } catch (Exception e) {
      throw new LoadGameException("Error al cargar: " + e.getMessage());
    }
  }
}
