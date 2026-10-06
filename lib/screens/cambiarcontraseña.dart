import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colores.dart';
import '../theme/estilostextos.dart';
import '../widgets/barrasuperior.dart';
import '../widgets/botondegradado.dart';
import '../widgets/campodetexto.dart';
import '../widgets/fondocurvo.dart';
import '../widgets/fondodegradado.dart';
import '../widgets/medallonlogo.dart';
import '../services/servicio_recuperacion.dart';
import '../screens/inicioseseion.dart';

class CambiarContrasena extends StatefulWidget {
  final String correo;
  const CambiarContrasena({super.key, required this.correo});

  @override
  State<CambiarContrasena> createState() => _CambiarContrasenaState();
}

class _CambiarContrasenaState extends State<CambiarContrasena> {
  final _codigo = TextEditingController();
  final _password = TextEditingController();
  final _confirmar = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _codigo.dispose();
    _password.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _mensaje(String texto, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
    ));
  }

  Future<void> _cambiar() async {
    final codigo = _codigo.text.trim();
    if (codigo.isEmpty || _password.text.isEmpty || _confirmar.text.isEmpty) {
      return _mensaje('Complete todos los campos', error: true);
    }
    if (_password.text.length < 6) {
      return _mensaje('La contraseña debe tener al menos 6 caracteres', error: true);
    }
    if (_password.text != _confirmar.text) {
      return _mensaje('Las contraseñas no coinciden', error: true);
    }
    setState(() => _cargando = true);
    try {
      await ServicioRecuperacion.cambiarContrasena(
        correo: widget.correo,
        codigo: codigo,
        password: _password.text,
      );
      if (!mounted) return;
      _mensaje('Contraseña cambiada exitosamente');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const InicioSesion()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        _mensaje('No se pudo cambiar la contraseña: '
            '${e.toString().replaceFirst('Exception: ', '')}', error: true);
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Widget _subBarra() => Container(
        width: 70,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(14)),
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(14)),
          child: FondoDegradado(
            alto: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BarraSuperior(
              onInicio: () => Navigator.pop(context),
              colorIconos: Colors.black,
              compacto: true,
            ),
          ),
        ),
      );

  Widget _campo(String etiqueta, TextEditingController c, {bool password = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: CampoTexto(
          etiqueta: etiqueta,
          icono: Icons.lock,
          prefijo: const SizedBox(width: 16),
          controller: c,
          esPassword: password,
          bordeColor: AppColors.primaryColor,
        ),
      );

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
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 24),
              color: Colors.white.withOpacity(0.85),
              child: Column(children: [
                Text('Cambiar Contraseña', style: Estilostextos.estilosTitulo),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa el código que enviamos a tu correo y tu nueva contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: Colors.black54),
                ),
                const SizedBox(height: 22),
                _campo('Código', _codigo),
                _campo('Contraseña', _password, password: true),
                _campo('Confirmar Contraseña', _confirmar, password: true),
                const SizedBox(height: 16),
                BotonDegradado(texto: 'Cambiar Contraseña', cargando: _cargando, onPressed: _cambiar),
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
          const MedallonLogo(icono: Icons.lock_open_rounded, insignia: Icons.verified_rounded),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: FondoCurvo(
        altoCurva: 340,
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
            Positioned(top: 8, left: 0, child: _subBarra()),
          ]),
        ),
      ),
    );
  }
}