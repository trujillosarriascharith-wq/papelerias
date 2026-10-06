import 'package:flutter/material.dart';
import 'barrasuperior.dart';
import 'fondodegradado.dart';

/// Mini barra con la casita, pegada a la izquierda
class SubBarraInicio extends StatelessWidget {
  const SubBarraInicio({super.key});

  @override
  Widget build(BuildContext context) => Container(
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
}