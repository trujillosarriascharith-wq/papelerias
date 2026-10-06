import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ChatPapeleriaService {
  static String get _chatUrl => ApiConfig.chat;

  static Future<String> enviarMensaje(String mensaje, {String? sesionId}) async {
    try {
      final response = await http.post(
        Uri.parse(_chatUrl),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'mensaje': mensaje,
          'sesionId': sesionId ?? 'papeleria_cliente_${DateTime.now().millisecondsSinceEpoch}',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['respuesta'] ?? data['mensaje'] ?? 'No se recibio respuesta.';
      } else {
        print('Error backend: ${response.statusCode} - ${response.body}');
        return 'En este momento no pudimos procesar tu solicitud.';
      }
    } catch (e) {
      print('Error de conexion: $e');
      return 'Error de conexion con la papeleria. Revisa que tu servidor este corriendo en puerto 3000.';
    }
  }

 
    }
