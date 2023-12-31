import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/services/asistencia/asistencia_service.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:flutter_application_2/views/asistencia/foto.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AsistenciaPage extends StatefulWidget {
  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  // Suponiendo que tienes una lista de asistencias desde un ViewModel o Servicio
  List<Asistencia> asistencias = [];
  final service = AsistenciaService();

  int get faltas => asistencias.where((element) => !element.estado).length;
  int get asistido => asistencias.where((element) => element.estado).length;
  // Puedes obtener esta lista desde un ViewModel o Servicio

  @override
  void initState() {
    super.initState();
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;

    AsistenciaService().obtenerAsistencias(usuario?.id).then((value) {
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
                        Text('$asistido/${asistencias.length}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: asistencias.isEmpty
                  ? const Center(
                      child: Text('Aún no has registrado tus asistencias'))
                  : ListView.builder(
                      itemCount: asistencias.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final fecha = asistencias[index].fecha;
                        final estado = asistencias[index].estado;
                        if (fecha == null) return const SizedBox();
                        return AttendanceTile(
                          fecha: DateFormat('dd/MM/yy').format(fecha),
                          hora: DateFormat('HH:mm aa').format(fecha),
                          path: asistencias[index].urlFoto ?? '',
                          estado: estado,
                        );
                      },
                    ),
            ),
            Center(
              child: Hero(
                tag: 'HeroCameraButton',
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: goToPhotoView,
                  label: const Text('Marcar asistencia'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToPhotoView() async {
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
    final permisos = await service.tienePermisos();
    if (!permisos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No tienes permisos para ver tu posición, actualiza desde la configuración de la aplicación',
          ),
        ),
      );
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TomarFotoPage(),
      ),
    );

    // Actualizar la lista de asistencias después de tomar la foto
    asistencias = await service.obtenerAsistencias(usuario?.id);
    setState(() {});
  }
}

class AttendanceTile extends StatelessWidget {
  const AttendanceTile(
      {super.key,
      this.fecha = '',
      this.hora = '',
      this.path = '',
      this.estado = false});
  final String fecha;
  final String hora;
  final String path;
  final bool estado;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () {
          if (path.isEmpty) return;
          print(path);
          viewPhoto(context, path);
          // Navega a la nueva página con la foto en grande
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Text(fecha, style: TextStyle(fontWeight: FontWeight.bold)),
        title: Text(hora),
        trailing: estado
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.info, color: Colors.orange),
      ),
    );
  }
}

Future<void> viewPhoto(BuildContext context, String path) => showDialog(
      context: context,
      builder: (context) => Center(
        child: Image.network(
          path,
          fit: BoxFit.contain,
        ),
      ),
    );
