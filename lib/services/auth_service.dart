import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthResultado {
  final bool exito;
  final String mensaje;
  final Map<String, dynamic>? usuario;
  final bool noVerificado;
  AuthResultado(this.exito, this.mensaje, {this.usuario, this.noVerificado = false});
}

class AuthService {
  static Future<AuthResultado> login({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('${ApiConfig.auth}/login'),
            headers: ApiConfig.headers,
            body: jsonEncode({
              'nombre': nombre,
              'email': correo,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('usuario', jsonEncode(data['usuario']));
        return AuthResultado(true, data['message'] ?? 'Listo',
            usuario: data['usuario']);
      }

      return AuthResultado(false, data['error'] ?? 'Error al iniciar sesión',
          noVerificado: res.statusCode == 403);
    } catch (e) {
      return AuthResultado(false, 'No se pudo conectar con el servidor');
    }
  }
}