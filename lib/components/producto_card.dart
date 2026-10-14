import 'dart:io';
import 'package:flutter/material.dart';
import '../models/producto_model.dart';

class ProductoCard extends StatelessWidget {
  final VoidCallback onComprar;
  final VoidCallback onVerMas;
  final VoidCallback? onEditar; // Solo se muestran si se pasan (admin)
  final VoidCallback? onEliminar;
  final ProductoModel producto;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onComprar,
    required this.onVerMas,
    this.onEditar,
    this.onEliminar,
  });

  Widget _botonAdmin({required IconData icono, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(icono, size: 18, color: color),
        ),
      ),
    );
  }

  Widget _construirImagen() {
    final String? imagen = producto.imagenUrl; // Apunta a tu columna 'imagen'
    const double alturaFoto = 120.0;

    if (imagen == null || imagen.isEmpty) {
      return Container(
        height: alturaFoto,
        width: double.infinity,
        color: Colors.pink.shade50,
        child: const Icon(
          Icons.icecream_rounded,
          size: 40,
          color: Color(0xFF9F6163),
        ),
      );
    }

    final bool esUrlWeb = imagen.startsWith('http://') || imagen.startsWith('https://');

    return Container(
      height: alturaFoto,
      width: double.infinity,
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: esUrlWeb
          ? Image.network(
              imagen,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.pink.shade50,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF9F6163),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.pink.shade50,
                child: const Icon(
                  Icons.broken_image_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            )
          : Image.file(
              File(imagen),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.pink.shade50,
                child: const Icon(
                  Icons.broken_image_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: _construirImagen(),
              ),
              if (onEditar != null || onEliminar != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      if (onEditar != null)
                        _botonAdmin(icono: Icons.edit, color: const Color(0xFF7FB268), onTap: onEditar!),
                      if (onEditar != null && onEliminar != null) const SizedBox(width: 6),
                      if (onEliminar != null)
                        _botonAdmin(icono: Icons.delete_outline, color: Colors.red, onTap: onEliminar!),
                    ],
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        producto.nombre,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '\$${producto.precio}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9F6163),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${producto.stock} | ${producto.estado}',
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
                const SizedBox(height: 8),
                Text(
                  producto.descripcion.join(', '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF916163),
                          side: const BorderSide(color: Color(0xFF9F6163)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onVerMas,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Ver más'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9F6163),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onComprar,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Comprar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}