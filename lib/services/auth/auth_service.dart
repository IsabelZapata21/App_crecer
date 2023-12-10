import 'dart:convert';
import 'package:flutter_application_2/models/auth/usuario.dart';
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

  Future<List<Usuario>> listarUsuarios() async {
    final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/auth/listar_usuario.php'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      // La solicitud fue exitosa, parsea la respuesta
      final List<dynamic> usuariosJson =
          json.decode(response.body) as List<dynamic>;
      // Convierte la lista de usuarios en una lista de Map<String, dynamic>
      List<Usuario> usuarios =
          usuariosJson.map((user) => Usuario.fromJson(user)).toList();

      return usuarios;
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción
      throw Exception('Error al obtener la lista de usuarios');
    }
  }

  Future<Map<String, dynamic>> cambiarContrasenia(
      int userId, String nuevaContrasenia) async {

    final data = {'id': userId, 'contrasenia': nuevaContrasenia};
    print(data);
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/auth/cambiar_contrasena.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

Future<Map<String, dynamic>> obtenerUsuarioYAsistencias(
      int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/auth/as_usuario.php?id_usuario=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Error al obtener la información del usuario y sus asistencias');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
}
