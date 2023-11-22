class Usuario {
  Usuario({
    required this.id,
    required this.rol,
    required this.dni,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.genero,
    required this.email,
    required this.usuario,
    required this.createdAt,
  });

  final int? id;
  final String? rol;
  final String? dni;
  final String? nombres;
  final String? apellidos;
  final String? telefono;
  final String? genero;
  final String? email;
  final String? usuario;
  final int? createdAt;

  String? get fullName => nombres == null || apellidos == null ? null : '$nombres $apellidos';

  Usuario copyWith({
    int? id,
    String? rol,
    String? dni,
    String? nombres,
    String? apellidos,
    String? telefono,
    String? genero,
    String? email,
    String? usuario,
    int? createdAt,
  }) {
    return Usuario(
      id: id ?? this.id,
      rol: rol ?? this.rol,
      dni: dni ?? this.dni,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      telefono: telefono ?? this.telefono,
      genero: genero ?? this.genero,
      email: email ?? this.email,
      usuario: usuario ?? this.usuario,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json["id"],
      rol: json["rol"],
      dni: json["dni"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      telefono: json["telefono"],
      genero: json["genero"],
      email: json["email"],
      usuario: json["usuario"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "rol": rol,
        "dni": dni,
        "nombres": nombres,
        "apellidos": apellidos,
        "telefono": telefono,
        "genero": genero,
        "email": email,
        "usuario": usuario,
        "created_at": createdAt,
      };

  @override
  String toString() {
    return "$id, $rol, $dni, $nombres, $apellidos, $telefono, $genero, $email, $usuario, $createdAt, ";
  }
}
