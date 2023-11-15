import 'dart:convert';
import 'package:flutter_application_2/models/citas/sesion.dart';
import 'package:flutter_application_2/models/citas/sesiones.dart' as sesion;
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/services/api_service.dart';

class SesionService {
  Future<String> guardarSesion(Map<String, dynamic> sesionData) async {
    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/guardar_detalles_sesion.php"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sesionData),
    );

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, devuelve un mensaje de éxito.
      return "Sesión guardada exitosamente!";
    } else {
      // Si la respuesta no es exitosa, utiliza el cuerpo de la respuesta para obtener más detalles.
      // Aquí puedes imprimir el cuerpo de la respuesta o hacer algo con él.
      print('Error al guardar la sesión: ${response.body}');
      // Luego puedes lanzar una excepción o manejar el error como prefieras.
      throw Exception("Error al guardar la sesión: ${response.body}");
    }
  }

  Future<List<Sesion>> obtenerNotasClinicas() async {
    final response = await http
        .get(Uri.parse("${ApiService.baseUrl}/obtener_notas_clinicas.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Sesion.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener los datos");
    }
  }

  Future<sesion.Sesiones> obtenerNotasClinicasId(String idCita) async {
    final response = await http.get(Uri.parse(
        "${ApiService.baseUrl}/sesion/obtener_por_id.php?idCita=$idCita"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> datos = json.decode(response.body);
      // Procesa los datos según tus necesidades
      print('Psicólogo: ${datos['psicologo']}');
      print('Cita: ${datos['citas']}');
      print('Lista de Sesiones: ${datos['listaSesiones']}');
      return sesion.Sesiones.fromJson(datos);
    } else {
      throw Exception("Error al obtener los datos");
    }
  }
}
