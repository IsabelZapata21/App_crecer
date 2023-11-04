import 'dart:convert';
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
}

