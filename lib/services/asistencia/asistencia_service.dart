import 'dart:convert';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class AsistenciaService {
  final posicionOficina = const Position(
      longitude: -122.0849872,
      latitude: 37.4226711,
      timestamp: null,
      accuracy: 15,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);

  Future<bool> tienePermisos() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  Future<Position?> obtenerPosicion() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return null;
    }
  }

  Future<bool> estaEnOficina() async {
    final posicionActual = await obtenerPosicion();
    if (posicionActual == null) return false;

    // Calculamos la distancia
    final distancia = await Geolocator.distanceBetween(
      posicionActual.latitude,
      posicionActual.longitude,
      posicionOficina.latitude,
      posicionOficina.longitude,
    );

    // Si la distancia es menor o igual a 25 metros, se considera que está en la oficina.
    return distancia <= 25;
  }

  // Obtener todas las asistencias
  Future<List<Asistencia>> obtenerAsistencias() async {
    final response = await http.get(
        Uri.parse("${ApiService.baseUrl}/asistencias/obtener_asistencias.php"));
    if (response.statusCode == 200) {
      final newData = json.decode(response.body) as List<dynamic>;
      return newData.map((e) => Asistencia.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener las asistencias");
    }
  }

  // Marcar una nueva asistencia
  Future<void> registrarAsistencia(Asistencia asistencia) async {
    print(asistencia.toJson());
    final response = await http.post(
      Uri.parse("${ApiService.baseUrl}/asistencias/registrar_asistencia.php"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(asistencia.toJson()),
    );
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception("Error al marcar la asistencia");
    }
  }

  // Puedes agregar más métodos según lo que necesites, como actualizar o eliminar asistencias.
}
