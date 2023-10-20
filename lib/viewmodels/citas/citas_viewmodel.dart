import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/citas/registro.dart';
import 'package:flutter_application_2/views/citas/reporte_sesion.dart';
import 'package:flutter_application_2/views/citas/actualizacion.dart';
import 'package:flutter_application_2/views/citas/historial.dart';
class CitasViewModel {
  // Navegación a la pantalla de registro de citas
  void navigateToRegistro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registro()),
    );
  }
  // Navegación a la pantalla de actualización de citas
  void navigateToActualizar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActualizarCita()),
    );
  }

  // Navegación a la pantalla de historial de citas
  void navigateToHistorialCitas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistorialCitas()),
    );
  }

  // Navegación a la pantalla de reporte de sesiones
  void navigateToReporte(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Reporte()),
    );
  }
}