import 'dart:convert';

import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/cronograma/actividades.dart';
import 'package:http/http.dart' as http;

class ActividadesService {
  Future<String> guardarActividades(Map<String, dynamic> actData) async {
    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/guardar_actividad.php"),
      //headers: {"Content-Type": "application/json"},
      body: json.encode(actData),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Error al guardar la actividad: ${response.body}");
    }
  }

  Future<List<Actividades>> obtenerListaActividades() async {
    final response = await http.get(
      Uri.parse(
          "${ApiService.baseUrl}/obtener_actividades.php"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Actividades> actividad =
          data.map((item) => Actividades.fromJson(item)).toList();
      return actividad;
    } else {
      throw Exception("Error al obtener la lista de citas: ${response.body}");
    }
  }

  Future<List<Actividades>> obtenerActividadesPorFecha(DateTime fecha) async {
    final response = await http.get(
      Uri.parse(
          "${ApiService.baseUrl}/obtener_por_feccha.php?fecha=${fecha.toLocal().toString().split(' ')[0]}"), // Asegúrate de reemplazar 'ruta_del_endpoint' con la ruta correcta
    );

    if (response.statusCode == 200) {
      final List<dynamic> actividadesJson = json.decode(response.body);
      return actividadesJson.map((json) => Actividades.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener las actividades");
    }
  }
}
