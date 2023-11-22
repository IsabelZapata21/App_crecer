class Asistencia {
  Asistencia({
     this.idAs = 0,
     this.fecha,
    required this.urlFoto,
    required this.estado,
    this.idUsuario,
  });

  final int idAs;
  final DateTime? fecha;
  final String? urlFoto;
  final bool estado;
  final int? idUsuario;

  Asistencia copyWith({
    int? idAs,
    DateTime? fecha,
    String? urlFoto,
    bool? estado,
    int? idUsuario,
  }) {
    return Asistencia(
      idAs: idAs ?? this.idAs,
      fecha: fecha ?? this.fecha,
      urlFoto: urlFoto ?? this.urlFoto,
      estado: estado ?? this.estado,
      idUsuario: idUsuario ?? this.idUsuario,
    );
  }

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      idAs: json["id_as"],
      fecha: DateTime.tryParse(json["fecha"] ?? ""),
      urlFoto: json["url_foto"],
      estado: json["estado"],
      idUsuario: json["id_usuario"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_as": idAs,
        "fecha": fecha?.toIso8601String(),
        "urlFoto": urlFoto,
        "estado": estado,
        "id_usuario": idUsuario,
      };

  @override
  String toString() {
    return "$idAs, $fecha, $urlFoto, $estado, $idUsuario, ";
  }
}
