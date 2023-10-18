import 'dart:convert';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:http/http.dart' as http;

class AsistenciaService {
  // Obtener todas las asistencias
  Future<List<Asistencia>> obtenerAsistencias() async {
    final response = await http.get(Uri.parse("${ApiService.baseUrl}/obtener_asistencias.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Asistencia.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener las asistencias");
    }
  }

  // Marcar una nueva asistencia
  /*
  Future<void> marcarAsistencia(Asistencia asistencia) async {
    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/registrar_asistencia.php"),
      body: asistencia.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al marcar la asistencia");
    }
  }

  // Puedes agregar más métodos según lo que necesites, como actualizar o eliminar asistencias.
}*/
}
