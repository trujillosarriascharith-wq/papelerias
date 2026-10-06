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
import '../screens/cambiarcontraseña.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
  State<RecuperarContrasena> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final _correo = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

  void _mensaje(String texto, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
    ));
  }

  Future<void> _enviar() async {
    final correo = _correo.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(correo)) {
      return _mensaje('Ingrese un correo válido', error: true);
    }
    setState(() => _cargando = true);
    try {
      await ServicioRecuperacion.enviarCodigo(correo);
      if (!mounted) return;
      _mensaje('Código enviado a tu correo');
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => CambiarContrasena(correo: correo)));
    } catch (e) {
      if (mounted) _mensaje(e.toString().replaceFirst('Exception: ', ''), error: true);
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
                Text('Recuperar Contraseña', style: Estilostextos.estilosTitulo),
                const SizedBox(height: 8),
                const Text(
                  'Te enviaremos un código de verificación a tu correo',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                CampoTexto(
                  etiqueta: 'Ingrese el Correo',
                  icono: Icons.email,
                  prefijo: const SizedBox(width: 16),
                  controller: _correo,
                  tipoTeclado: TextInputType.emailAddress,
                  bordeColor: AppColors.primaryColor,
                ),
                const SizedBox(height: 28),
                BotonDegradado(texto: 'Enviar', ancho: 130, cargando: _cargando, onPressed: _enviar),
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
          const MedallonLogo(icono: Icons.lock_reset_rounded, insignia: Icons.mark_email_unread_rounded),
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