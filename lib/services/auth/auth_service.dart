import 'dart:convert';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> registrarUsuario(
      Map<String, dynamic> data) async {
    final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/registrar.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> iniciarSesion(
      String usuario, String contrasenia) async {
    final data = {'usuario': usuario, 'contrasenia': contrasenia};
    final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/iniciar_sesion.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> actualizarDatos(
      Map<String, dynamic> data) async {
    final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/actualizar.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> restablecerContrasenia(String email) async {
    final data = {'email': email};
    final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/restablecer.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));

    return jsonDecode(response.body);
  }
}
