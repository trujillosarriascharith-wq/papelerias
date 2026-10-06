import 'package:flutter/material.dart';
import '../theme/colores.dart';

/// Pie de página "Contáctenos" con teléfono, correo y dirección.
/// Se repite en: Pantalla Principal, categorías (Cuadernos, Marcadores...)
/// y carrito de compras.
class FooterContacto extends StatelessWidget {
  final String telefono;
  final String correo;
  final String direccion;

  const FooterContacto({
    super.key,
    this.telefono = '322 8793769',
    this.correo = 'papeleriajuanjose2017@gmail.com',
    this.direccion = 'Cra. 5# 8-36, Agrado, Huila,',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
           begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contáctenos',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _filaContacto(Icons.phone, telefono),
          _filaContacto(Icons.email, correo),
          _filaContacto(Icons.location_on, direccion),
        ],
      ),
    );
  }

  Widget _filaContacto(IconData icono, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(texto, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}