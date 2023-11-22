class Mensaje {
  Mensaje({
    required this.idMen,
    required this.emisor,
    required this.autor,
    required this.genero,
    required this.email,
    required this.usuario,
    required this.telefono,
    required this.descripcion,
    required this.fecha,
    required this.estado,
    required this.tipo,
  });

  final int? idMen;
  final int? emisor;
  final String? autor;
  final String? genero;
  final String? email;
  final String? usuario;
  final String? telefono;
  final String? descripcion;
  final DateTime? fecha;
  final bool? estado;
  final String? tipo;

  Mensaje copyWith({
    int? idMen,
    int? emisor,
    String? autor,
    String? genero,
    String? email,
    String? usuario,
    String? telefono,
    String? descripcion,
    DateTime? fecha,
    bool? estado,
    String? tipo,
  }) {
    return Mensaje(
      idMen: idMen ?? this.idMen,
      emisor: emisor ?? this.emisor,
      autor: autor ?? this.autor,
      genero: genero ?? this.genero,
      email: email ?? this.email,
      usuario: usuario ?? this.usuario,
      telefono: telefono ?? this.telefono,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
    );
  }

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      idMen: json["id_men"],
      emisor: json["emisor"],
      autor: json["autor"],
      genero: json["genero"],
      email: json["email"],
      usuario: json["usuario"],
      telefono: json["telefono"],
      descripcion: json["descripcion"],
      fecha: DateTime.tryParse(json["fecha"] ?? ""),
      estado: json["estado"],
      tipo: json["tipo"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_men": idMen,
        "emisor": emisor,
        "autor": autor,
        "genero": genero,
        "email": email,
        "usuario": usuario,
        "telefono": telefono,
        "descripcion": descripcion,
        "fecha": fecha?.toIso8601String(),
        "estado": estado,
        "tipo": tipo,
      };

  @override
  String toString() {
    return "$idMen, $emisor, $autor, $genero, $email, $usuario, $telefono, $descripcion, $fecha, $estado, $tipo, ";
  }
}
