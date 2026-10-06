import 'package:flutter/material.dart';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onInicio;
  final VoidCallback? onPerfil;
  final VoidCallback? onCarrito;
  final VoidCallback? onNotificaciones;
  final VoidCallback? onRegistro;
  final int contadorCarrito;
  final int contadorNotificaciones;
  final Color colorIconos;
  final IconData iconoInicio;
  final IconData iconoPerfil;
  final IconData iconoCarrito;
  final IconData iconoNotificaciones;
  final IconData iconoRegistro;
  final bool compacto;

  const BarraSuperior({
    super.key,
    this.onInicio,
    this.onPerfil,
    this.onCarrito,
    this.onNotificaciones,
    this.onRegistro, // <- ESTO ERA LO QUE TE FALTABA
    this.contadorCarrito = 0,
    this.contadorNotificaciones = 0,
    this.colorIconos = Colors.white,
    this.iconoInicio = Icons.home,
    this.iconoPerfil = Icons.person,
    this.iconoCarrito = Icons.shopping_cart,
    this.iconoNotificaciones = Icons.notifications,
    this.iconoRegistro = Icons.app_registration,
    this.compacto = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(40);

  Widget _icono(IconData icono, VoidCallback? onTap, int contador) {
    if (onTap == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: Icon(icono, color: colorIconos),
            onPressed: onTap,
            padding: compacto ? EdgeInsets.zero : const EdgeInsets.all(8),
            constraints: compacto ? const BoxConstraints() : null,
          ),
          if (contador > 0)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text('$contador',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _icono(iconoInicio, onInicio, 0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _icono(iconoPerfil, onPerfil, 0),
            _icono(iconoCarrito, onCarrito, contadorCarrito),
            _icono(iconoNotificaciones, onNotificaciones, contadorNotificaciones),
            _icono(iconoRegistro, onRegistro, 0), // <- agrégalo aquí para que se vea
          ],
        ),
      ],
    );
  }
}