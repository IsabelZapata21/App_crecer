import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/services/asistencia/asistencia_service.dart';
import 'package:flutter_application_2/views/asistencia/foto.dart';
import 'package:intl/intl.dart';

class AsistenciaPage extends StatefulWidget {
  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  // Suponiendo que tienes una lista de asistencias desde un ViewModel o Servicio
  List<Asistencia> asistencias = [];
  final service = AsistenciaService();

  int get faltas => asistencias.where((element) => element.estado).length;
  int get asistido => asistencias.length;
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
        title: const Text('Asistencia'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Asistencias',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 20),
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
                        Spacer(),
                        if (asistido > faltas) ...[
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 5),
                          Text('ASISTIENDO',
                              style: TextStyle(color: Colors.green)),
                        ] else if (asistido <= faltas) ...[
                          Icon(Icons.check_circle, color: Colors.orange),
                          SizedBox(width: 5),
                          Text('EN EVALUACIÓN',
                              style: TextStyle(color: Colors.orange)),
                        ],
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Asistencias $asistido'),
                        Text('Faltas $faltas'),
                        Text('$asistido/${asistido + faltas}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: asistencias.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final fecha = asistencias[index].fecha;
                  final estado = asistencias[index].estado;
                  return AttendanceTile(
                    fecha:
                        '${DateFormat('yy/MM/dd').format(fecha ?? DateTime.now())}',
                    hora:
                        '${DateFormat('HH:mm:ss aa').format(fecha ?? DateTime.now())}',
                    estado: estado,
                  );
                },
              ),
            ),
            Center(
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.deepPurple,
                iconSize: 40.0,
                onPressed: () async {
                  final permisos = await service.tienePermisos();
                  if (!permisos) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'No tienes permisos para ver tu posición, actualiza desde la configuración de la aplicación')),
                    );
                    return;
                  }
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TomarFotoPage()));
                  asistencias = await service.obtenerAsistencias();
                  setState(() {});
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
  const AttendanceTile(
      {super.key, this.fecha = '', this.hora = '', this.estado = false});
  final String fecha;
  final String hora;
  final bool estado;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Text(fecha, style: TextStyle(fontWeight: FontWeight.bold)),
        title: Text(hora),
        trailing: estado
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.info, color: Colors.orange),
      ),
    );
  }
}
