import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      "http://192.168.43.65/api_flutter"; // IP para acceder a localhost desde un emulador Android

  Future<List<Pacientes>> obtenerDatos() async {
    final response = await http.get(Uri.parse("$baseUrl/obtener_datos.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Pacientes.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener los datos");
    }
  }

  Future<List<Psicologo>> obtenerPsicologos() async {
    final response = await http.get(Uri.parse("$baseUrl/obtener_psicologos.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Psicologo.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener los datos");
    }
  }

  Future<void> programarCita(Map<String, dynamic> citaData) async {
    final response = await http.post(Uri.parse("$baseUrl/programar_cita.php"),
        body: json.encode(citaData));
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception("Error al programar la cita");
    }
  }
}

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
