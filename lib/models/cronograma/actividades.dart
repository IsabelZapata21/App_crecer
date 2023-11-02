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
    this.idResponsable,
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
  final int? idResponsable;
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
    int? idResponsable,
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
      idResponsable: idResponsable ?? this.idResponsable,
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
      idResponsable: json["id_responsable"],
      estado: json["estado"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "descripcion": descripcion,
        "fechaInicio":
            "${fechaInicio?.year.toString().padLeft(4, '0')}-${fechaInicio?.month.toString().padLeft(2, '0')}-${fechaInicio?.day.toString().padLeft(2, '0')}",
        "fechaFin":
            "${fechaFin?.year.toString().padLeft(4, '0')}-${fechaFin?.month.toString().padLeft(2, '0')}-${fechaFin?.day.toString().padLeft(2, '0')}",
        "horaInicio": horaInicio,
        "horaFin": horaFin,
        "responsable": idResponsable,
        "estado": estado,
      };

  @override
  String toString() {
    return "$idAct, $nombre, $descripcion, $fechaInicio, $fechaFin, $horaInicio, $horaFin, $responsable, $idResponsable, $estado, ";
  }
}
