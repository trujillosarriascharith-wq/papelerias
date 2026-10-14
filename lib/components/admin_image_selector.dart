import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:photo_manager/photo_manager.dart';

class AdminImageSelector extends StatefulWidget {
  final File? imagen;
  final String? imagenUrl; // Foto actual del producto (modo edición)
  final bool habilitado;
  final Function(File) onImagenSeleccionada;
  final GlobalKey captureKey;
  final TransformationController encuadreController;

  const AdminImageSelector({
    super.key,
    required this.imagen,
    required this.imagenUrl,
    required this.onImagenSeleccionada,
    required this.captureKey,
    required this.encuadreController,
    this.habilitado = true,
  });

  static bool encuadreModificado(TransformationController controller) =>
      controller.value != Matrix4.identity();

  @override
  State<AdminImageSelector> createState() => AdminImageSelectorState();
}

class AdminImageSelectorState extends State<AdminImageSelector> {
  static const _extensionesImagen = ['jpg', 'jpeg', 'png', 'webp', 'avif'];
  bool _arrastrando = false;

  File? get imagen => widget.imagen;
  String? get imagenUrl => widget.imagenUrl;
  bool get habilitado => widget.habilitado;
  TransformationController get encuadreController => widget.encuadreController;

  void _usarImagen(File archivo) {
    encuadreController.value = Matrix4.identity();
    widget.onImagenSeleccionada(archivo);
  }

  void _alSoltarArchivo(DropDoneDetails detalles) {
    setState(() => _arrastrando = false);
    if (!habilitado) return;

    final imagenes = detalles.files.where((f) =>
        _extensionesImagen.any((ext) => f.name.toLowerCase().endsWith('.$ext'))
    );

    if (imagenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solo se permiten imágenes (jpg, png, webp, avif)'), backgroundColor: Colors.red),
      );
      return;
    }

    _usarImagen(File(imagenes.first.path));
  }

  Future<void> _elegirOrigen(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar foto del producto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFFB285D)),
                title: const Text('Elegir de la Galería'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFFB285D)),
                title: const Text('Tomar con la Cámara'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      final XFile? foto = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (foto != null) {
        _usarImagen(File(foto.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _arrastrando = true),
      onDragExited: (_) => setState(() => _arrastrando = false),
      onDragDone: _alSoltarArchivo,
      child: _construirRecuadro(context),
    );
  }

  Widget _construirRecuadro(BuildContext context) {
    return GestureDetector(
      onTap: habilitado ? () => _elegirOrigen(context) : null,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: _arrastrando ? const Color(0xFFFCE4EC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _arrastrando ? const Color(0xFFFB285D) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _arrastrando ? Icons.file_download_rounded : Icons.add_a_photo_rounded,
              size: 48,
              color: const Color(0xFFFB285D),
            ),
            const SizedBox(height: 8),
            Text(
              _arrastrando ? 'Suelta la imagen aquí' : 'Toca o arrastra aquí la foto del producto',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}