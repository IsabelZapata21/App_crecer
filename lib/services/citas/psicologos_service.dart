import 'dart:convert';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:http/http.dart' as http;

class PsicologoService{
  Future<List<Psicologo>> obtenerPsicologos() async {
    final response = await http.get(Uri.parse("${ApiService.baseUrl}/obtener_psicologos.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Psicologo.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener los datos");
    }
  }
}
