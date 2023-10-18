import 'dart:convert';

import 'package:flutter_application_2/services/api_service.dart';
import 'package:http/http.dart' as http;

class CitasService{
    Future<String> programarCita(Map<String, dynamic> citaData) async {
    final response = await http.post(Uri.parse("${ApiService.baseUrl}/programar_cita.php"),
        body: json.encode(citaData));
    if (response.statusCode == 200) {
      return "Cita guardada exitosamente!";
    } else {
      throw Exception("Error al programar la cita: ${response.body}");
    }
  }
}