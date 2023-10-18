import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/services/asistencia/asistencia_service.dart';
import 'package:flutter_application_2/views/asistencia/foto.dart';


class AsistenciaPage extends StatefulWidget {
  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  // Suponiendo que tienes una lista de asistencias desde un ViewModel o Servicio
  List<Asistencia> asistencias = [];
  // Puedes obtener esta lista desde un ViewModel o Servicio
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AsistenciaService().obtenerAsistencias().then((value) {
      asistencias=value;
      setState(() {});

    }); //
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Señor xd'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estado:'),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    Text('ASISTIENDO'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Asistencias 15'),
                Text('Faltas 0'),
                Text('Asistencias 15/64'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 7, // You can update this based on your data
                itemBuilder: (context, index) {
                  return AttendanceTile();
                },
              ),
            ),
            IconButton(
            icon: Icon(Icons.camera_alt),
            color: Colors.purple,
            iconSize: 40.0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TomarFotoPage()),
              );
            },
          ),
          ],
        ),
      ),
    );
  }
}

class AttendanceTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('08/09/2023'),
          Text('06:20 PM'),
          Icon(Icons.check, color: Colors.green),
        ],
      ),
    );
  }
  }