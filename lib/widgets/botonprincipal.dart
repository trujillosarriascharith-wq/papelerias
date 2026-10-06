import 'package:flutter/material.dart';
import '../theme/colores.dart';

/// Botón sólido reutilizable.
/// Se usa en: Inicio de sesión, crear cuenta, Recuperar/Cambiar contraseña,
/// Realizar Pedido, Agregar producto (admin), cerrar sesion
///
/// Un solo lugar para cambiar el estilo del botón y su estado de "cargando".
///
/// [icono]: opcional. Si se pasa, se dibuja a la izquierda del texto
/// (por ejemplo Icons.logout en "Cerrar Sesión").
class BotonPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final bool cargando;
  final Color? color;
  final IconData? icono;

  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cargando = false,
    this.color,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = ElevatedButton.styleFrom(
      backgroundColor: color ?? AppColors.botonAgregar,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    final contenidoCargando = const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
    );

    final estiloTexto = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: icono == null
          ? ElevatedButton(
              onPressed: cargando ? null : onPressed,
              style: estilo,
              child: cargando
                  ? contenidoCargando
                  : Text(texto, style: estiloTexto),
            )
          : ElevatedButton.icon(
              onPressed: cargando ? null : onPressed,
              style: estilo,
              icon: cargando
                  ? contenidoCargando
                  : Icon(icono, color: Colors.white, size: 18),
              label: Text(texto, style: estiloTexto),
            ),
    );
  }
}