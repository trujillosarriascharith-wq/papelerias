class UserModel {
  final String? id_usuario; // Nulo al crear, asignado por la BD al responder
  final String nombre;
  final String email;
  final String password;
  final String rol;

  UserModel({
    this.id_usuario,
    required this.nombre,
    required this.email,
    required this.password,
    this.rol = 'usuario', // Por defecto 'usuario'
  });

  // Getter útil para verificar si tiene permisos de administrador
  bool get esAdmin => rol.toLowerCase() == 'admin';

  // Mapear la respuesta de la base de datos (con el ID ya autocompletado)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id_usuario: json['id_usuario']?.toString(), // Lee el ID retornado por Supabase/Backend
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rol: json['rol'] ?? 'usuario',
    );
  }

  // Para enviar al backend
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'password': password,
      'rol': rol,
    };
  }
}