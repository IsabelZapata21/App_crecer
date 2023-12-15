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
  Future<List<CitaDuration>> obtenerDisponibilidad(int? idPsicologo, String? fecha) async {
    final response = await http.get(Uri.parse("${ApiService.baseUrl}/psicologo/obtener_disponibilidad.php?idPsicologo=$idPsicologo&fecha=$fecha"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => CitaDuration.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener los datos");
    }
  }
}


class CitaDuration {
    CitaDuration({
        required this.id,
        required this.horaCita,
        required this.finCita,
    });

    final String? id;
    final String? horaCita;
    final String? finCita;

    CitaDuration copyWith({
        String? id,
        String? horaCita,
        String? finCita,
    }) {
        return CitaDuration(
            id: id ?? this.id,
            horaCita: horaCita ?? this.horaCita,
            finCita: finCita ?? this.finCita,
        );
    }

    factory CitaDuration.fromJson(Map<String, dynamic> json){ 
        return CitaDuration(
            id: json["id"],
            horaCita: json["hora_cita"],
            finCita: json["fin_cita"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "hora_cita": horaCita,
        "fin_cita": finCita,
    };

    @override
    String toString(){
        return "$id, $horaCita, $finCita, ";
    }
}