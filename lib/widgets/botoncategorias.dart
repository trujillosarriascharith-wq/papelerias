import 'package:flutter/material.dart';
import '../theme/colores.dart';

/// Botón de categoría de producto: imagen arriba + etiqueta con borde
/// dorado debajo (ver "Categorías" en la Pantalla Principal: Cuadernos,
/// Colores, Cartucheras, Temperas...).
///
/// Se usa dentro de un GridView de 2 columnas. Al tocarlo navega a
/// productos_screen.dart pasando la categoría seleccionada.
class BotonCategoria extends StatelessWidget {
  final String nombre;
  final String imagen;
  final VoidCallback onTap;

  const BotonCategoria({
    super.key,
    required this.nombre,
    required this.imagen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagen,
              width: 120,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.fondo,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: Text(
              nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}