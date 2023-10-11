import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
    final String baseUrl = "http://127.0.0.1/api_flutter";  // IP para acceder a localhost desde un emulador Android

    Future<List<dynamic>> fetchData() async {
        final response = await http.get(Uri.parse("$baseUrl/obtener_datos.php"));

        if (response.statusCode == 200) {
            return json.decode(response.body);
        } else {
            throw Exception("Error al obtener los datos");
        }
    }
  //cis
}

