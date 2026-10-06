import 'package:flutter/material.dart';

class Estilostextos {
  // Título de sección, ej: "Categorias"
  static TextStyle estilosTitulo = const TextStyle(
    color: Color.fromARGB(255, 29, 29, 29),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  // Texto dentro de las etiquetas con borde dorado, ej: "Cuadernos"
  static TextStyle estilosLetra = const TextStyle(
    color: Color.fromARGB(255, 29, 29, 29),
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  // Texto de bienvenida y "Contactenos" (sobre fondo rosado)
  static TextStyle estilosBienvenida = const TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  // Texto de la sección de contacto (sobre fondo rosado)
  static TextStyle estilosContacto = const TextStyle(
    color: Colors.white,
    fontSize: 14,
  );
}