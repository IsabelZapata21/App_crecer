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
    super.initState();
    AsistenciaService().obtenerAsistencias().then((value) {
      asistencias = value;
      setState(() {});
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Señor xd',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estado:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 5),
                            Text('ASISTIENDO',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Asistencias 15'),
                        Text('Faltas 0'),
                        Text('Asistencias 15/64'),
                      ],
                    ),
                  ],
                ),
              ),
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
            Center(
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.deepPurple,
                iconSize: 40.0,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TomarFotoPage()));
                  // ... (sin cambios aquí)
                },
              ),
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading:
            Text('08/09/2023', style: TextStyle(fontWeight: FontWeight.bold)),
        title: Text('06:20 PM'),
        trailing: Icon(Icons.check, color: Colors.green),
      ),
    );
  }
}
