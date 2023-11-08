class Asistencia {
  Asistencia({
    this.idAs = 0,
    this.fecha,
    required this.urlFoto,
  });

  final int idAs;
  final DateTime? fecha;
  final String? urlFoto;

  Asistencia copyWith({
    int? idAs,
    DateTime? fecha,
    String? urlFoto,
  }) {
    return Asistencia(
      idAs: idAs ?? this.idAs,
      fecha: fecha ?? this.fecha,
      urlFoto: urlFoto ?? this.urlFoto,
    );
  }

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      idAs: int.tryParse(json["id_as"]) ?? 0,
      fecha: DateTime.tryParse(json["fecha"] ?? ""),
      urlFoto: json["url_foto"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        // "fecha": fecha?.toIso8601String(),
        "urlFoto": urlFoto,
      };

  @override
  String toString() {
    return "$idAs, $fecha, $urlFoto, ";
  }
}
