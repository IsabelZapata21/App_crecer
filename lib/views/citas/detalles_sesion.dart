import 'package:flutter/material.dart';

class DetallesSesion extends StatefulWidget {
  @override
  _DetallesSesionState createState() => _DetallesSesionState();
}

class _DetallesSesionState extends State<DetallesSesion> {
  // Variables para almacenar los detalles de la sesión
  //int ID = 0; // Nuevo campo para el ID de la sesión
  int idCita = 0;
  DateTime horaInicio = DateTime.now();
  DateTime horaFin = DateTime.now();
  String duracion = '';
  String inicio = '';
  String desarrollo = '';
  String analisis = '';
  String observaciones = '';

  // Estilo para los TextField
  final inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Detalles de la Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 16),
            // Campo ID Cita (Nota: Este valor debe existir en la tabla 'citas' debido a la restricción de clave externa)
            TextField(
              onChanged: (value) => setState(() => idCita = int.tryParse(value) ?? 0),
              decoration: inputDecoration.copyWith(labelText: 'ID Cita'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Campo Duración
            TextField(
              onChanged: (value) => setState(() => duracion = value),
              decoration: inputDecoration.copyWith(labelText: 'Duración'),
            ),
            SizedBox(height: 16),
            // Campo Inicio
            TextField(
              onChanged: (value) => setState(() => inicio = value),
              decoration: inputDecoration.copyWith(labelText: 'Inicio'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            // Campo Desarrollo
            TextField(
              onChanged: (value) => setState(() => desarrollo = value),
              decoration: inputDecoration.copyWith(labelText: 'Desarrollo'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            // Campo Análisis
            TextField(
              onChanged: (value) => setState(() => analisis = value),
              decoration: inputDecoration.copyWith(labelText: 'Análisis'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            // Campo Observaciones con límite de 200 caracteres
            TextField(
              onChanged: (value) => setState(() => observaciones = value),
              decoration: inputDecoration.copyWith(labelText: 'Observaciones'),
              maxLength: 200,
            ),
            SizedBox(height: 16),
            // Botón Guardar Detalles
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar los detalles de la sesión
              },
              child: Text('Guardar Detalles'),
              style: ElevatedButton.styleFrom(primary: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}