import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '..pages/admin_product_list_page.dart';
Future<void> _guardarSesionyNavegar(Map<String, dynamic> respuesta) async {
  final String token = respuesta['token'];
  final UserModel usuario = UserModel.fromJson(respuesta['usuario']);

  // Extrae el rol ('admin' o 'usuario')
  final String rol = (respuesta['usuario']['rol'] ?? 'usuario').toString().toLowerCase();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
  await prefs.setString('user_name', usuario.nombre);
  await prefs.setString('user_email', usuario.email);
  await prefs.setString('user_role', rol);

  if (!mounted) return;

  _mostrarMensaje('¡Bienvenido, ${usuario.nombre}!');

  // Si es administrador, va directo al panel; si no, a HomeScreen()
  if (rol == 'admin') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminProductListPage()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}