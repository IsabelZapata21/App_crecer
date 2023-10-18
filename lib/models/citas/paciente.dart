class Pacientes {
  Pacientes({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telfono,
  });

  final String? id;
  final String? nombre;
  final String? direccion;
  final String? telfono;

  Pacientes copyWith({
    String? id,
    String? nombre,
    String? direccion,
    String? telfono,
  }) {
    return Pacientes(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telfono: telfono ?? this.telfono,
    );
  }

  factory Pacientes.fromJson(Map<String, dynamic> json) {
    return Pacientes(
      id: json["ID"],
      nombre: json["nombre"],
      direccion: json["direccion"],
      telfono: json["teléfono"],
    );
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "nombre": nombre,
        "direccion": direccion,
        "teléfono": telfono,
      };

  @override
  String toString() {
    return "$id, $nombre, $direccion, $telfono, ";
  }
}
