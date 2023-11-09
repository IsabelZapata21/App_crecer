class Asistencia {
  Asistencia({
    this.idAs = 0,
    this.fecha,
    required this.urlFoto,
    required this.estado,
  });

  final int idAs;
  final DateTime? fecha;
  final String? urlFoto;
  final bool estado;

  Asistencia copyWith({
    int? idAs,
    DateTime? fecha,
    String? urlFoto,
    bool? estado,
  }) {
    return Asistencia(
      idAs: idAs ?? this.idAs,
      fecha: fecha ?? this.fecha,
      urlFoto: urlFoto ?? this.urlFoto,
      estado: estado ?? this.estado,
    );
  }

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      idAs: json["id_as"] ?? 0,
      fecha: DateTime.tryParse(json["fecha"] ?? ""),
      urlFoto: json["url_foto"] ?? '',
      estado: json["estado"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        // "fecha": fecha?.toIso8601String(),
        "urlFoto": urlFoto,
        "estado": estado,
      };

  @override
  String toString() {
    return "$idAs, $fecha, $urlFoto, $estado ";
  }
}
