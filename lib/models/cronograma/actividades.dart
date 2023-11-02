class Actividades {
  Actividades({
    required this.idAct,
    required this.nombre,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.horaInicio,
    required this.horaFin,
    required this.responsable,
    required this.estado,
  });

  final int? idAct;
  final String? nombre;
  final String? descripcion;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? horaInicio;
  final String? horaFin;
  final String? responsable;
  final String? estado;

  Actividades copyWith({
    int? idAct,
    String? nombre,
    String? descripcion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? horaInicio,
    String? horaFin,
    String? responsable,
    String? estado,
  }) {
    return Actividades(
      idAct: idAct ?? this.idAct,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      responsable: responsable ?? this.responsable,
      estado: estado ?? this.estado,
    );
  }

  factory Actividades.fromJson(Map<String, dynamic> json) {
    return Actividades(
      idAct: json["id_act"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      fechaInicio: DateTime.tryParse(json["fecha_inicio"] ?? ""),
      fechaFin: DateTime.tryParse(json["fecha_fin"] ?? ""),
      horaInicio: json["hora_inicio"],
      horaFin: json["hora_fin"],
      responsable: json["responsable"],
      estado: json["estado"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_act": idAct,
        "nombre": nombre,
        "descripcion": descripcion,
        "fecha_inicio":
            "${fechaInicio?.year.toString().padLeft(4, '0')}-${fechaInicio?.month.toString().padLeft(2, '0')}-${fechaInicio?.day.toString().padLeft(2, '0')}",
        "fecha_fin":
            "${fechaFin?.year.toString().padLeft(4, '0')}-${fechaFin?.month.toString().padLeft(2, '0')}-${fechaFin?.day.toString().padLeft(2, '0')}",
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "responsable": responsable,
      };

  @override
  String toString() {
    return "$idAct, $nombre, $descripcion, $fechaInicio, $fechaFin, $horaInicio, $horaFin, $responsable, $estado, ";
  }
}
