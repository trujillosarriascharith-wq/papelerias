
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Web (Chrome) usa localhost; el emulador Android usa 10.0.2.2
  static String get baseUrl =>
      kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';

  static String get chat => '$baseUrl/api/chat';
  static String get productos => '$baseUrl/api/productos';
  static String get auth => '$baseUrl/Auth';
  static String get notificaciones => '$baseUrl/api/notificaciones';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };
}