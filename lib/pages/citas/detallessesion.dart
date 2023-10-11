import 'package:flutter/material.dart';

class DetallesSesion extends StatefulWidget {
  @override
  _DetallesSesionState createState() => _DetallesSesionState();
}

class _DetallesSesionState extends State<DetallesSesion> {
  // Variables para almacenar los detalles de la sesión
  int idCita = 0;
  DateTime horaInicio = DateTime.now();
  DateTime horaFin = DateTime.now();
  String duracion = '';
  String inicio = '';
  String desarrollo = '';
  String analisis = '';
  String observaciones = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Detalles de la Sesión'),
        actions: <Widget>[
          // ... (sin cambios aquí)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              onChanged: (value) => setState(() => idCita = int.tryParse(value) ?? 0),
              decoration: InputDecoration(labelText: 'ID Cita'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Aquí puedes agregar campos de selección de fecha y hora para horaInicio y horaFin
            TextField(
              onChanged: (value) => setState(() => duracion = value),
              decoration: InputDecoration(labelText: 'Duración'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => inicio = value),
              decoration: InputDecoration(labelText: 'Inicio'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => desarrollo = value),
              decoration: InputDecoration(labelText: 'Desarrollo'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => analisis = value),
              decoration: InputDecoration(labelText: 'Análisis'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => observaciones = value),
              decoration: InputDecoration(labelText: 'Observaciones'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para guardar los detalles de la sesión
              },
              child: Text('Guardar Detalles'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DetallesSesion(),
  ));
}
