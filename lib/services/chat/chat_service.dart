import 'dart:convert';
import 'package:flutter_application_2/models/chat/mensaje.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:http/http.dart' as http;

class ChatService {
  // Obtener todas las asistencias
  Future<List<Mensaje>> obtenerMensajes() async {
    final response = await http
        .get(Uri.parse("${ApiService.baseUrl}/chat/obtener_mensajes.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Mensaje.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener las asistencias");
    }
  }

  Future<bool> enviarMensaje(Map<String, dynamic> mensaje) async {
    final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/chat/enviar_mensaje.php"),
        body: json.encode(mensaje));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error al programar la cita: ${response.body}");
    }
  }
}
