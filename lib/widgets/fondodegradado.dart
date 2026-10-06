import 'package:flutter/material.dart';
import '../theme/colores.dart';

/// Encabezado con degradado rosa (primaryColor -> secondaryColor) con las
/// esquinas inferiores redondeadas.
/// Se usa en TODAS las pantallas: Pantalla Principal, categorías, carrito,
/// Pedido, Inicio de sesión, Registrarse, Recuperar/Cambiar contraseña,
/// Perfil, Asistente Nova, Notificaciones, pantallas de admin...
///
/// Recibe el contenido (logo, título, ícono) como [child].
class FondoDegradado extends StatelessWidget {
  final Widget child;
  final double alto;
  final EdgeInsetsGeometry padding;

  const FondoDegradado({
    super.key,
    required this.child,
    this.alto = 180,
    this.padding = const EdgeInsets.fromLTRB(16, 40, 16, 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: alto,
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
        ),
        borderRadius: BorderRadius.zero, //borde de las dos barras de la parte superior
      ),
      child: child,
    );
  }
}

/// Círculo decorativo que aparece en la esquina inferior derecha.
/// Con [degradado] = true usa el mismo degradado rosa de la barra
/// (más claro arriba, más oscuro abajo); por defecto conserva el color
/// semitransparente de siempre para las otras pantallas.
class CirculoDecorativo extends StatelessWidget {
  final double tamano;
  final bool degradado;

  const CirculoDecorativo({super.key, this.tamano = 220, this.degradado = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -tamano * 0.35,
      right: -tamano * 0.35,
      child: Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: degradado ? null : AppColors.secondaryColor.withOpacity(0.85),
          gradient: degradado
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                )
              : null,
        ),
      ),
    );
  }
}