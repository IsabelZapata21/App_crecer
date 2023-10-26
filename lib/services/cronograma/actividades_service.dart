import 'dart:convert';

import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/cronograma/actividades.dart';
import 'package:http/http.dart' as http;

class CitasService{
    Future<String> guardarActividades(Map<String, dynamic> actividadData) async {
    final response = await http.post(Uri.parse("${ApiService.baseUrl}/guardar_actividades.php"),
        body: json.encode(actividadData));
    if (response.statusCode == 200) {
      return "Actividad exitosamente!";
    } else {
      throw Exception("Error al guardar la actividad: ${response.body}");
    }
  }
}

