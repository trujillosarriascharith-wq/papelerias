import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/producto_model.dart';
import 'api_config.dart';
import 'package:http_parser/http_parser.dart';
class ProductoService {
  
  static String _mensajeError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? data['error'] ?? 'Error del servidor (código ${response.statusCode})';
    } catch (_) {
      return 'El servidor no respondió con JSON válido (código ${response.statusCode}).';
    }
  }

  static Future<String> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  static Future<http.MultipartFile> _archivoImagen(File imagen) async {
    final bytes = await imagen.readAsBytes();
    final ext = imagen.path.split('.').last.toLowerCase();
    final subtipo = switch (ext) {
      'png' => 'png',
      'webp' => 'webp',
      'avif' => 'avif',
      _ => 'jpeg',
    };

    return http.MultipartFile.fromBytes(
      'imagen',
      bytes,
      filename: 'producto_${DateTime.now().millisecondsSinceEpoch}.$subtipo',
      contentType: MediaType('image', subtipo),
    );
  }

  // 1. Obtener la lista de productos (/api/productos)
  Future<List<ProductoModel>> obtenerProductos() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/productos');

    try {
      final response = await http.get(url, headers: ApiConfig.headers);
      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode == 200) {
        final List<dynamic> datos = jsonDecode(response.body);
        return datos.map((item) => ProductoModel.fromJson(item)).toList();
      } else {
        if (contentType.contains('application/json')) {
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? errorData['error'] ?? 'Error al cargar productos');
        } else {
          throw Exception('Error del servidor (Código ${response.statusCode})');
        }
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // 2. Crear producto (/api/productos)
  static Future<void> crearProducto({
    required String idCategoria,
    required String nombre,
    required String descripcion,
    required double precio,
    required int cantidadStock,
    required String estado,
    required File imagen,
  }) async {
    final token = await _obtenerToken();

    final request = http.MultipartRequest('POST', Uri.parse('${ApiConfig.baseUrl}/productos'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id_categoria'] = idCategoria;
    request.fields['nombre'] = nombre;
    request.fields['descripcion'] = descripcion;
    request.fields['precio'] = precio.toString();
    request.fields['cantidad_stock'] = cantidadStock.toString();
    request.fields['estado'] = estado;
    request.files.add(await _archivoImagen(imagen));

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode != 201) {
      throw Exception(_mensajeError(response));
    }
  }

  // 3. Actualizar producto (/api/productos/:id)
  static Future<void> actualizarProducto({
    required String idProducto,
    required String idCategoria,
    required String nombre,
    required String descripcion,
    required double precio,
    required int cantidadStock,
    required String estado,
    File? imagen,
  }) async {
    final token = await _obtenerToken();

    final request = http.MultipartRequest('PUT', Uri.parse('${ApiConfig.baseUrl}/productos/$idProducto'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id_categoria'] = idCategoria;
    request.fields['nombre'] = nombre;
    request.fields['descripcion'] = descripcion;
    request.fields['precio'] = precio.toString();
    request.fields['cantidad_stock'] = cantidadStock.toString();
    request.fields['estado'] = estado;
    
    if (imagen != null) {
      request.files.add(await _archivoImagen(imagen));
    }

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response));
    }
  }

  // 4. Eliminar producto (/api/productos/:id)
  static Future<void> eliminarProducto(String idProducto) async {
    final token = await _obtenerToken();

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/productos/$idProducto'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response));
    }
  }
}