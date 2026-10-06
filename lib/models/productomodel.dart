/// Modelo de producto: cuadernos, marcadores, cartucheras, colores, temperas...
/// Va en lib/models/producto_model.dart (no en widgets/).
class ProductoModel {
  final String id;
  final String nombre;
  final String imagen;
  final List<String> descripcion; // ej: ['Marca Norma', 'Cuadriculado', '50 Hojas']
  final int precio;
  final int stock;
  final String categoria;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      imagen: json['imagen'] ?? '',
      descripcion: List<String>.from(json['descripcion'] ?? []),
      precio: json['precio'] ?? 0,
      stock: json['stock'] ?? 0,
      categoria: json['categoria'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'imagen': imagen,
        'descripcion': descripcion,
        'precio': precio,
        'stock': stock,
        'categoria': categoria,
      };
}