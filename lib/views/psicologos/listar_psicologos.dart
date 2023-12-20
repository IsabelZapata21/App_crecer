import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';
import 'package:flutter_application_2/views/dashboard/acerca.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';

class HistorialPsicologos extends StatefulWidget {
  @override
  _HistorialPsicologosState createState() => _HistorialPsicologosState();
}

class _HistorialPsicologosState extends State<HistorialPsicologos> {
  String _filtroSeleccionado = 'Todas'; // Por defecto, muestra todas las citas
  List<Psicologo>? psicologos;
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    psicologos = await PsicologoService().obtenerPsicologos();
    setState(() {}); // Refrescar el widget después de cargar los datos.
  }

  String obtenerNombrePsicologoPorId(String? idPsicologo) {
    if (idPsicologo == null) return 'Desconocido';
    final psicologo = psicologos?.firstWhere((p) => p.id == idPsicologo);
    return psicologo?.nombres ?? 'Desconocido';
  }

  String obtenerNombreEspecialidadPorId(String? idPsicologo) {
    if (idPsicologo == null) return 'Desconocido';
    final psicologo = psicologos?.firstWhere((p) => p.id == idPsicologo);
    return psicologo?.especialidad ?? 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Psicologos'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'cerrar_sesion') {
                // Agregar aquí la lógica para cerrar sesión
              } else if (value == 'acerca_de') {
                // Agregar aquí la lógica para mostrar la pantalla "Acerca de"
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: ListTile(
                  leading: const Icon(Icons.info, color: Colors.purple),
                  title: Text('Acerca De'),
                  onTap: () {
                    // Agregar lógica para mostrar información sobre la aplicación
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AcercaDe()),
                    );
                  },
                )),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.purple),
                    title: Text('Cerrar Sesión'),
                    onTap: () async {
                      // Agregar lógica para cerrar sesión
                      await AuthManager.logOut();
                      // Navegar a la pantalla de inicio de sesión después de cerrar sesión
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: psicologos?.length ?? 0,
        itemBuilder: (context, index) {
          final cita = psicologos?[index];
          return GestureDetector(
            child: _buildCitaItem(
              fecha: '${cita?.nombres} ${cita?.apellidos}',
              descripcion: '${cita?.especialidad} \n${cita?.telefono}',
              isPast: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCitaItem(
      {required String fecha,
      required String descripcion,
      required bool isPast}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: isPast ? Colors.grey : Colors.purple,
          child: const Icon(Icons.person, color: Colors.white, size: 30),
          radius: 30,
        ),
        title: Text(
          fecha,
          style: TextStyle(
            fontSize: 18,
            color: isPast ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(descripcion),
      ),
    );
  }
}
