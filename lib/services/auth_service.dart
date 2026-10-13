import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
import 'sesion.dart';

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
        Sesion.token = data['token'];
        
        return AuthResultado(true, data['message'] ?? 'Listo',
            usuario: data['usuario']);
      }

      return AuthResultado(false, data['error'] ?? 'Error al iniciar sesión',
          noVerificado: res.statusCode == 403);
    } catch (e) {
      return AuthResultado(false, 'No se pudo conectar con el servidor');
    }
  }

  /// Registro con foto opcional (multipart)
  static Future<AuthResultado> registrar({
    required String nombre,
    required String correo,
    required String telefono,
    required String direccion,
    required String password,
    Uint8List? foto,
  }) async {
    try {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.auth}/register'),
      )..fields.addAll({
          'nombre': nombre,
          'email': correo,
          'telefono': telefono,
          'direccion': direccion,
          'password': password,
        });

      if (foto != null) {
        req.files.add(
          http.MultipartFile.fromBytes('foto', foto, filename: 'foto.jpg'),
        );
      }

      final streamed = await req.send().timeout(const Duration(seconds: 30));
      final res = await http.Response.fromStream(streamed);
      final data = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 201) {
        return AuthResultado(true, data['message'] ?? 'Cuenta creada',
            usuario: data['usuarios'] as Map<String, dynamic>?);
      }
      return AuthResultado(false, data['error'] ?? 'Error al registrarse');
    } catch (e) {
      return AuthResultado(false, 'No se pudo conectar con el servidor');
    }
  }

  /// Verifica la cuenta con el código de 6 dígitos del correo
  static Future<AuthResultado> verificarCuenta({
    required String correo,
    required String codigo,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('${ApiConfig.auth}/verify-account'),
            headers: ApiConfig.headers,
            body: jsonEncode({'email': correo, 'codigoVerificacion': codigo}),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        return AuthResultado(true, data['message'] ?? 'Cuenta verificada');
      }
      return AuthResultado(false, data['error'] ?? 'Código incorrecto');
    } catch (e) {
      return AuthResultado(false, 'No se pudo conectar con el servidor');
    }
  }

  /// Usuario guardado al iniciar sesión (para el perfil)
  static Future<Map<String, dynamic>?> usuarioGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString('usuario');
    if (texto == null) return null;
    return jsonDecode(texto) as Map<String, dynamic>;
  }

  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuario');
    Sesion.cerrar();
  }
}