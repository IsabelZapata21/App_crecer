class Sesiones {
  Sesiones({
    required this.citas,
    required this.psicologo,
    required this.sesion,
  });

  final Citas? citas;
  final Psicologo? psicologo;
  final List<Sesion> sesion;

  Sesiones copyWith({
    Citas? citas,
    Psicologo? psicologo,
    List<Sesion>? sesion,
  }) {
    return Sesiones(
      citas: citas ?? this.citas,
      psicologo: psicologo ?? this.psicologo,
      sesion: sesion ?? this.sesion,
    );
  }

  factory Sesiones.fromJson(Map<String, dynamic> json) {
    return Sesiones(
      citas: json["citas"] == null ? null : Citas.fromJson(json["citas"]),
      psicologo: json["psicologo"] == null
          ? null
          : Psicologo.fromJson(json["psicologo"]),
      sesion: json["listaSesiones"] == null
          ? []
          : List<Sesion>.from(
              json["listaSesiones"]!.map((x) => Sesion.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "Citas": citas?.toJson(),
        "Psicologo": psicologo?.toJson(),
        "Sesion": sesion.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$citas, $psicologo, $sesion, ";
  }
}

class Citas {
  Citas({
    required this.id,
    required this.descripcion,
    required this.idPaciente,
    required this.idEspecialidad,
    required this.idPsicologo,
    required this.fechaCita,
    required this.horaCita,
    required this.estado,
    required this.createdAt,
  });

  final int? id;
  final String? descripcion;
  final int? idPaciente;
  final int? idEspecialidad;
  final int? idPsicologo;
  final DateTime? fechaCita;
  final String? horaCita;
  final String? estado;
  final int? createdAt;

  Citas copyWith({
    int? id,
    String? descripcion,
    int? idPaciente,
    int? idEspecialidad,
    int? idPsicologo,
    DateTime? fechaCita,
    String? horaCita,
    String? estado,
    int? createdAt,
  }) {
    return Citas(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      idPaciente: idPaciente ?? this.idPaciente,
      idEspecialidad: idEspecialidad ?? this.idEspecialidad,
      idPsicologo: idPsicologo ?? this.idPsicologo,
      fechaCita: fechaCita ?? this.fechaCita,
      horaCita: horaCita ?? this.horaCita,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Citas.fromJson(Map<String, dynamic> json) {
    return Citas(
      id: json["id"],
      descripcion: json["descripcion"],
      idPaciente: json["id_paciente"],
      idEspecialidad: json["id_especialidad"],
      idPsicologo: json["id_psicologo"],
      fechaCita: DateTime.tryParse(json["fecha_cita"] ?? ""),
      horaCita: json["hora_cita"],
      estado: json["estado"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "id_paciente": idPaciente,
        "id_especialidad": idEspecialidad,
        "id_psicologo": idPsicologo,
        "fecha_cita":
            "${fechaCita?.year.toString().padLeft(4, '0')}-${fechaCita?.month.toString().padLeft(2, '0')}-${fechaCita?.day.toString().padLeft(2, '0')}",
        "hora_cita": horaCita,
        "estado": estado,
        "created_at": createdAt,
      };

  @override
  String toString() {
    return "$id, $descripcion, $idPaciente, $idEspecialidad, $idPsicologo, $fechaCita, $horaCita, $estado, $createdAt, ";
  }
}

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

  final int? id;
  final int? idEspecialidad;
  final String? dni;
  final String? nombres;
  final String? apellidos;
  final String? genero;
  final String? telefono;
  final DateTime? nacimiento;
  final String? correo;
  final String? nacionalidad;

  Psicologo copyWith({
    int? id,
    int? idEspecialidad,
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

class Sesion {
  Sesion({
    required this.id,
    required this.idCita,
    required this.fechaSesion,
    required this.horaInicio,
    required this.horaFin,
    required this.duracion,
    required this.inicio,
    required this.desarrollo,
    required this.analisis,
    required this.observaciones,
  });

  final int? id;
  final int? idCita;
  final DateTime? fechaSesion;
  final String? horaInicio;
  final String? horaFin;
  final String? duracion;
  final String? inicio;
  final String? desarrollo;
  final String? analisis;
  final String? observaciones;

  Sesion copyWith({
    int? id,
    int? idCita,
    DateTime? fechaSesion,
    String? horaInicio,
    String? horaFin,
    String? duracion,
    String? inicio,
    String? desarrollo,
    String? analisis,
    String? observaciones,
  }) {
    return Sesion(
      id: id ?? this.id,
      idCita: idCita ?? this.idCita,
      fechaSesion: fechaSesion ?? this.fechaSesion,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      duracion: duracion ?? this.duracion,
      inicio: inicio ?? this.inicio,
      desarrollo: desarrollo ?? this.desarrollo,
      analisis: analisis ?? this.analisis,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  factory Sesion.fromJson(Map<String, dynamic> json) {
    return Sesion(
      id: json["ID"],
      idCita: json["id_cita"],
      fechaSesion: DateTime.tryParse(json["fecha_sesion"] ?? ""),
      horaInicio: json["hora_inicio"],
      horaFin: json["hora_fin"],
      duracion: json["duracion"],
      inicio: json["inicio"],
      desarrollo: json["desarrollo"],
      analisis: json["analisis"],
      observaciones: json["observaciones"],
    );
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "id_cita": idCita,
        "fecha_sesion":
            "${fechaSesion?.year.toString().padLeft(4, '0')}-${fechaSesion?.month.toString().padLeft(2, '0')}-${fechaSesion?.day.toString().padLeft(2, '0')}",
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "duracion": duracion,
        "inicio": inicio,
        "desarrollo": desarrollo,
        "analisis": analisis,
        "observaciones": observaciones,
      };

  @override
  String toString() {
    return "$id, $idCita, $fechaSesion, $horaInicio, $horaFin, $duracion, $inicio, $desarrollo, $analisis, $observaciones, ";
  }
}
