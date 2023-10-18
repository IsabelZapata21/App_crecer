class Psicologo {
  Psicologo({
    required this.id,
    required this.idEspecialidad,
    required this.dni,
    required this.nombres,
    required this.apellidos,
    required this.genero,
    required this.telefono,
    required this.nacimiento,
    required this.correo,
    required this.nacionalidad,
  });

  final String? id;
  final String? idEspecialidad;
  final String? dni;
  final String? nombres;
  final String? apellidos;
  final String? genero;
  final String? telefono;
  final DateTime? nacimiento;
  final String? correo;
  final String? nacionalidad;

  Psicologo copyWith({
    String? id,
    String? idEspecialidad,
    String? dni,
    String? nombres,
    String? apellidos,
    String? genero,
    String? telefono,
    DateTime? nacimiento,
    String? correo,
    String? nacionalidad,
  }) {
    return Psicologo(
      id: id ?? this.id,
      idEspecialidad: idEspecialidad ?? this.idEspecialidad,
      dni: dni ?? this.dni,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      genero: genero ?? this.genero,
      telefono: telefono ?? this.telefono,
      nacimiento: nacimiento ?? this.nacimiento,
      correo: correo ?? this.correo,
      nacionalidad: nacionalidad ?? this.nacionalidad,
    );
  }

  factory Psicologo.fromJson(Map<String, dynamic> json) {
    return Psicologo(
      id: json["id"],
      idEspecialidad: json["id_especialidad"],
      dni: json["dni"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      genero: json["genero"],
      telefono: json["telefono"],
      nacimiento: DateTime.tryParse(json["nacimiento"] ?? ""),
      correo: json["correo"],
      nacionalidad: json["nacionalidad"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_especialidad": idEspecialidad,
        "dni": dni,
        "nombres": nombres,
        "apellidos": apellidos,
        "genero": genero,
        "telefono": telefono,
        "nacimiento":
            "${nacimiento?.year.toString().padLeft(4, '0')}-${nacimiento?.month.toString().padLeft(2, '0')}-${nacimiento?.day.toString().padLeft(2, '0')}",
        "correo": correo,
        "nacionalidad": nacionalidad,
      };

  @override
  String toString() {
    return "$id, $idEspecialidad, $dni, $nombres, $apellidos, $genero, $telefono, $nacimiento, $correo, $nacionalidad, ";
  }
}
