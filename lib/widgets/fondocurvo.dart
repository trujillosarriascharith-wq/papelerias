import 'package:flutter/material.dart';
import '../theme/colores.dart';

/// Fondo con el semicírculo rosa de arriba y el círculo decorativo
/// fijo en la esquina inferior derecha. El contenido va en [child].
class FondoCurvo extends StatelessWidget {
  final Widget child;
  final double altoCurva; // hasta dónde baja el semicírculo de arriba

  const FondoCurvo({super.key, required this.child, this.altoCurva = 330});

  Widget _circulo(double d, LinearGradient g) => Container(
        width: d,
        height: d,
        decoration: BoxDecoration(shape: BoxShape.circle, gradient: g),
      );

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final d = ancho * 1.6; // círculo más ancho que la pantalla
    final f0 = 1 - altoCurva / d; // parte visible del círculo grande

    final gradienteCurva = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        AppColors.primaryColor,
        AppColors.primaryColor,
        AppColors.secondaryColor,
      ],
      stops: [0, f0, 1],
    );
    const gradienteAbajo = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.primaryColor, AppColors.secondaryColor],
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: altoCurva - d,
          left: -(d - ancho) / 2,
          child: _circulo(d, gradienteCurva),
        ),
        Positioned(bottom: -80, right: -80, child: _circulo(220, gradienteAbajo)),
        child,
      ],
    );
  }
}