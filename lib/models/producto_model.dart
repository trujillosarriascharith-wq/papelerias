// /// Modelo de producto: cuadernos, marcadores, cartucheras, colores, temperas...
// /// Va en lib/models/producto_model.dart (no en widgets/).
// class ProductoModel {
//   final String id;
//   final String nombre;
//   final String imagen;
//   final List<String> descripcion; // ej: ['Marca Norma', 'Cuadriculado', '50 Hojas']
//   final int precio;
//   final int stock;
//   final String categoria;

//   ProductoModel({
//     required this.id,
//     required this.nombre,
//     required this.imagen,
//     required this.descripcion,
//     required this.precio,
//     required this.stock,
//     required this.categoria,
//   });

//   factory ProductoModel.fromJson(Map<String, dynamic> json) {
//     return ProductoModel(
//       id: json['id'].toString(),
//       nombre: json['nombre'] ?? '',
//       imagen: json['imagen'] ?? '',
//       descripcion: List<String>.from(json['descripcion'] ?? []),
//       precio: json['precio'] ?? 0,
//       stock: json['stock'] ?? 0,
//       categoria: json['categoria'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'nombre': nombre,
//         'imagen': imagen,
//         'descripcion': descripcion,
//         'precio': precio,
//         'stock': stock,
//         'categoria': categoria,
//       };
// }
/// Modelo de producto: cuadernos, marcadores, cartucheras, colores, temperas...
/// Va en lib/models/producto_model.dart
class ProductoModel {
  final String id_producto;
  final String nombre;
  final String imagen; // En la guía sale como imagenUrl - aquí lo hacemos compatible
  final List<String> descripcion; // ej: ['Marca Norma', 'Cuadriculado', '50 Hojas']
  final int precio;
  final int cantidad_stock;
  final String id_categoria;

  ProductoModel({
    required this.id_producto,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.precio,
    required this.cantidad_stock,
    required this.id_categoria,
  });

  // Getter para compatibilidad con el código de la guía que usa imagenUrl
  String get imagenUrl => imagen;

  // Mapear la respuesta que viene del backend/BD - VERSIÓN ROBUSTA
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    // 1. Imagen puede venir como imagen, imagenUrl, imagen_url
    final img = json['imagen']?? json['imagenUrl']?? json['imagen_url']?? json['imagenUrl']?? '';

    // 2. Descripción puede venir como Lista o como String (de tu tabla)
    List<String> descList = [];
    final rawDesc = json['descripcion'];
    if (rawDesc is List) {
      descList = List<String>.from(rawDesc.map((e) => e.toString()));
    } else if (rawDesc is String && rawDesc.isNotEmpty) {
      descList = [rawDesc];
    }

    // 3. Precio puede venir como int, double o String
    int parsePrecio(dynamic p) {
      if (p == null) return 0;
      if (p is int) return p;
      if (p is double) return p.toInt();
      return int.tryParse(p.toString())?? 0;
    }

    return ProductoModel(
      id_producto: json['id']?.toString()?? json['Id']?.toString()?? '',
      nombre: json['nombre']?? '',
      imagen: img.toString(),
      descripcion: descList,
      precio: parsePrecio(json['precio']),
      cantidad_stock: parsePrecio(json['cantidad_stock']),
      id_categoria: json['id_categoria']?? '',
    );
  }

  // Convertir a Map para enviar datos al backend
  Map<String, dynamic> toJson() {
    return {
      'id_producto': id_producto,
      'nombre': nombre,
      'imagen': imagen,
      'imagenUrl': imagen, // lo mandamos con los dos nombres por si el backend espera el otro
      'descripcion': descripcion,
      'precio': precio,
      'cantidad_stock': cantidad_stock,
      'id_categoria': id_categoria,
    };
  }
}