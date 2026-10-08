import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../theme/colores.dart';
import '../theme/estilostextos.dart';
import '../widgets/botondegradado.dart';
import '../widgets/campodetexto.dart';
import '../widgets/fondocurvo.dart';
import '../widgets/medallonlogo.dart';
import '../widgets/subbarrainicio.dart';
import 'verificar_cuenta.dart';

class Registrarse extends StatefulWidget {
  const Registrarse({super.key});

  @override
  State<Registrarse> createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _direccion = TextEditingController();
  final _telefono = TextEditingController();
  final _password = TextEditingController();
  bool _cargando = false;
  Uint8List? _foto; // foto elegida de la galería

  @override
  void dispose() {
    for (final c in [_nombre, _correo, _direccion, _telefono, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _elegirFoto() async {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
    if (img == null) return;
    final bytes = await img.readAsBytes();
    if (mounted) setState(() => _foto = bytes);
  }

  void _aviso(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _crearCuenta() async {
    final nombre = _nombre.text.trim();
    final correo = _correo.text.trim();
    final direccion = _direccion.text.trim();
    final telefono = _telefono.text.trim();
    final password = _password.text;

    if (nombre.isEmpty ||
        correo.isEmpty ||
        direccion.isEmpty ||
        telefono.isEmpty ||
        password.isEmpty) {
      _aviso('Completa todos los campos');
      return;
    }

    setState(() => _cargando = true);
    final r = await AuthService.registrar(
      nombre: nombre,
      correo: correo,
      telefono: telefono,
      direccion: direccion,
      password: password,
      foto: _foto,
    );
    if (!mounted) return;
    setState(() => _cargando = false);

    _aviso(r.mensaje);
    if (!r.exito) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => VerificarCuenta(correo: correo)),
    );
  }

  Widget _campo(String etiqueta, IconData icono, TextEditingController c,
      {bool password = false, TextInputType tipo = TextInputType.text, Widget? prefijo}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CampoTexto(
        etiqueta: etiqueta,
        icono: icono,
        prefijo: prefijo,
        controller: c,
        esPassword: password,
        tipoTeclado: tipo,
        bordeColor: AppColors.primaryColor,
        colorIcono: Colors.black,
      ),
    );
  }

  Widget _tarjeta() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 12))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              color: Colors.white.withOpacity(0.85),
              child: Column(children: [
                Text('Registrarse', style: Estilostextos.estilosTitulo),
                const SizedBox(height: 4),
                const Text('Crea tu cuenta para comenzar',
                    style: TextStyle(fontSize: 13.5, color: Colors.black54)),
                const SizedBox(height: 18),
                _campo('Nombre', Icons.person_outline, _nombre),
                _campo('Correo', Icons.email, _correo,
                    tipo: TextInputType.emailAddress,
                    prefijo: Image.asset('assets/images/gmail2.webp', width: 20)),
                _campo('Dirección', Icons.home_outlined, _direccion),
                _campo('Teléfono', Icons.phone_outlined, _telefono, tipo: TextInputType.phone),
                _campo('Contraseña', Icons.lock, _password,
                    password: true, prefijo: const SizedBox(width: 16)),
                const SizedBox(height: 8),
                BotonDegradado(texto: 'Crear cuenta', cargando: _cargando, onPressed: _crearCuenta),
                const SizedBox(height: 14),
                Text('¿Ya tienes una cuenta?', style: Estilostextos.estilosLetra),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Inicia sesion')),
              ]),
            ),
          ),
        ),
      );

  Widget _formulario() => Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Padding(padding: const EdgeInsets.only(top: 59), child: _tarjeta()),
          MedallonLogo(
            icono: Icons.person_add_alt_1_rounded,
            insignia: Icons.photo_camera_rounded,
            imagen: _foto == null ? null : MemoryImage(_foto!),
            onInsignia: _elegirFoto,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: FondoCurvo(
        child: SafeArea(
          child: Stack(children: [
            LayoutBuilder(
              builder: (_, c) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: c.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                      child: _formulario(),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(top: 8, left: 0, child: SubBarraInicio()),
          ]),
        ),
      ),
    );
  }
}