import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/colores.dart';
import '../theme/estilostextos.dart';
import '../widgets/botondegradado.dart';
import '../widgets/campodetexto.dart';
import '../widgets/fondocurvo.dart';

class VerificarCuenta extends StatefulWidget {
  final String correo;
  const VerificarCuenta({super.key, required this.correo});

  @override
  State<VerificarCuenta> createState() => _VerificarCuentaState();
}

class _VerificarCuentaState extends State<VerificarCuenta> {
  final _codigo = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _codigo.dispose();
    super.dispose();
  }

  void _aviso(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _verificar() async {
    final codigo = _codigo.text.trim();
    if (codigo.length != 6) {
      _aviso('Escribe el código de 6 dígitos');
      return;
    }

    setState(() => _cargando = true);
    final r = await AuthService.verificarCuenta(
      correo: widget.correo,
      codigo: codigo,
    );
    if (!mounted) return;
    setState(() => _cargando = false);

    _aviso(r.mensaje);
    if (r.exito) Navigator.of(context).pop(); // vuelve a Iniciar sesión
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: FondoCurvo(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Verifica tu cuenta', style: Estilostextos.estilosTitulo),
                    const SizedBox(height: 10),
                    Text(
                      'Enviamos un código de 6 dígitos a\n${widget.correo}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13.5, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    CampoTexto(
                      etiqueta: 'Código de verificación',
                      icono: Icons.verified_outlined,
                      controller: _codigo,
                      tipoTeclado: TextInputType.number,
                      bordeColor: AppColors.primaryColor,
                      colorIcono: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    BotonDegradado(
                      texto: 'Verificar',
                      cargando: _cargando,
                      onPressed: _verificar,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}