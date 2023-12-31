import 'dart:convert';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/citas/cita.dart';
import 'package:http/http.dart' as http;

class CitasService {
  Future<String> programarCita(Map<String, dynamic> citaData) async {
    final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/programar_cita.php"),
        body: json.encode(citaData));
    if (response.statusCode == 200) {
      return "Cita guardada exitosamente!";
    } else {
      throw Exception("Error al programar la cita: ${response.body}");
    }
  }

  Future<List<Citas>> obtenerListaCitas() async {
    final response = await http.get(
      Uri.parse(
          "${ApiService.baseUrl}/obtener_cita.php"), // Reemplaza con la URL correcta
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Citas> citas =
          data.map((item) => Citas.fromJson(item)).toList();
      return citas;
    } else {
      throw Exception("Error al obtener la lista de citas: ${response.body}");
    }
  }

  Future<List<Citas>> obtenerListaCitasPorPaciente(String idPaciente) async {
    if (idPaciente == '') {
      return [];
    }
    final response = await http.get(
      Uri.parse(
          "${ApiService.baseUrl}/obtener_citas_pacientes.php?id_paciente=$idPaciente"), // Reemplaza con la URL correcta
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Citas> citas =
          data.map((item) => Citas.fromJson(item)).toList();
      return citas;
    } else {
      throw Exception("Error al obtener la lista de citas: ${response.body}");
    }
  }

  Future<void> actualizarEstadoCita(String id, String nuevoEstado) async {
    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/actualizar_estado_cita.php"),
      body: {
        'id': id,
        'estado': nuevoEstado,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Error al actualizar el estado de la cita: ${response.body}");
    }
  }
}
