class Usuario {
  String? nombre;
  String? correo;
  int? telefono;
  bool? admin;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.admin,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    nombre: json["nombre"],
    correo: json["correo"],
    telefono: json["telefono"],
    admin: json["admin"],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "correo": correo,
    "telefono": telefono,
    "admin": admin,
  };
}
