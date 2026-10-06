import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ServicioNotificaciones {
  static Map<String, String> _h(String token) =>
      {...ApiConfig.headers, 'Authorization': 'Bearer $token'};

  /// Notificaciones del usuario autenticado
  static Future<List<Map<String, dynamic>>> obtenerMias(String token) async {
    final r = await http
        .get(Uri.parse('${ApiConfig.notificaciones}/mis-notificaciones'), headers: _h(token))
        .timeout(const Duration(seconds: 15));
    if (r.statusCode != 200) throw Exception(_mensaje(r));
    return List<Map<String, dynamic>>.from(jsonDecode(r.body)['notificaciones'] ?? []);
  }

  /// Marca una notificación como leída
  static Future<void> marcarLeida(String token, dynamic id) async {
    final r = await http
        .put(Uri.parse('${ApiConfig.notificaciones}/$id/leida'), headers: _h(token))
        .timeout(const Duration(seconds: 15));
    if (r.statusCode != 200) throw Exception(_mensaje(r));
  }

  /// Elimina una notificación
  static Future<void> eliminar(String token, dynamic id) async {
    final r = await http
        .delete(Uri.parse('${ApiConfig.notificaciones}/$id'), headers: _h(token))
        .timeout(const Duration(seconds: 15));
    if (r.statusCode != 200) throw Exception(_mensaje(r));
  }

  static String _mensaje(http.Response r) {
    try {
      final b = jsonDecode(r.body);
      return b['error'] ?? b['message'] ?? 'Ocurrió un error';
    } catch (_) {
      return 'Ocurrió un error (${r.statusCode})';
    }
  }
}