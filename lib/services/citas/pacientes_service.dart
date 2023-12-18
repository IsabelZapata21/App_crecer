import 'dart:convert';

import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:http/http.dart' as http;

class PacienteService{
  Future<List<Pacientes>> obtenerDatos() async {
    final response = await http.get(Uri.parse("${ApiService.baseUrl}/obtener_datos.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Pacientes.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener los datos");
    }
  }

   Future<Map<String, dynamic>> registrarPaciente(
      Map<String, dynamic> data) async {
    final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/psicologo/registrar_paciente.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));
    return jsonDecode(response.body);
  }
  

}