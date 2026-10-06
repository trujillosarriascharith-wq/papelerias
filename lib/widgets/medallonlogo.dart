import 'package:flutter/material.dart';
import '../theme/colores.dart';

/// Logo en medallón: anillo translúcido, círculo blanco y centro con degradado.
/// Si recibe [imagen] la muestra en el centro; [onInsignia] hace tocable la insignia.
class MedallonLogo extends StatelessWidget {
  final IconData icono;
  final IconData insignia;
  final double tamano;
  final ImageProvider? imagen;
  final VoidCallback? onInsignia;

  const MedallonLogo({
    super.key,
    required this.icono,
    required this.insignia,
    this.tamano = 118,
    this.imagen,
    this.onInsignia,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.primaryColor;
    return SizedBox(
      width: tamano,
      height: tamano,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.55),
                boxShadow: [
                  BoxShadow(color: c.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 10)),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [c, Color.lerp(c, Colors.black, 0.3)!],
                    ),
                  ),
                  child: imagen != null
                      ? ClipOval(
                          child: Image(
                            image: imagen!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Center(child: Icon(icono, size: tamano * 0.46, color: Colors.white)),
                ),
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: 6,
            child: GestureDetector(
              onTap: onInsignia,
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Icon(insignia, size: 18, color: c),
              ),
            ),
          ),
        ],
      ),
    );
  }
}