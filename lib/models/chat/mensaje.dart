class Mensaje {
  Mensaje({
    required this.idMen,
    required this.emisor,
    required this.descripcion,
    required this.fecha,
    required this.estado,
  });

  final int? idMen;
  final int? emisor;
  final String? descripcion;
  final DateTime? fecha;
  final bool? estado;

  Mensaje copyWith({
    int? idMen,
    int? emisor,
    String? descripcion,
    DateTime? fecha,
    bool? estado,
  }) {
    return Mensaje(
      idMen: idMen ?? this.idMen,
      emisor: emisor ?? this.emisor,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
    );
  }

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      idMen: json["id_men"],
      emisor: json["emisor"],
      descripcion: json["descripcion"],
      fecha: DateTime.tryParse(json["fecha"] ?? ""),
      estado: json["estado"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_men": idMen,
        "emisor": emisor,
        "descripcion": descripcion,
        "fecha": fecha?.toIso8601String(),
        "estado": estado,
      };

  @override
  String toString() {
    return "$idMen, $emisor, $descripcion, $fecha, $estado, ";
  }
}
