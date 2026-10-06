/// Guarda los datos de la sesión actual (en memoria)
class Sesion {
  static String? token;

  static bool get activa => token != null && token!.isNotEmpty;

  static void cerrar() => token = null;
}