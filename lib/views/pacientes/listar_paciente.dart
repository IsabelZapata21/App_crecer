import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/views/dashboard/acerca.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';

class HistorialPacientes extends StatefulWidget {
  @override
  _HistorialPacientesState createState() => _HistorialPacientesState();
}

class _HistorialPacientesState extends State<HistorialPacientes> {
  String _filtroSeleccionado = 'Todas'; // Por defecto, muestra todas las citas
  List<Pacientes>? pacientes;
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    pacientes = await PacienteService().obtenerDatos();
    setState(() {}); // Refrescar el widget después de cargar los datos.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Pacientes'),
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
        itemCount: pacientes?.length ?? 0,
        itemBuilder: (context, index) {
          final cita = pacientes?[index];
          return _buildCitaItem(
            fecha: 'Nombre: ${cita?.nombre}',
            hora: 'Telefono: ${cita?.telfono}',
            descripcion: 'Direccion: ${cita?.direccion}',
            isPast: false,
          );
        },
      ),
    );
  }

  Widget _buildCitaItem(
      {required String fecha,
      required String hora,
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
          radius: 30,
          child: const Icon(Icons.person, color: Colors.white, size: 30),
        ),
        title: Text(
          fecha,
          style: TextStyle(
            fontSize: 18,
            color: isPast ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(hora + '\n' + descripcion),
      ),
    );
  }

  Widget _buildFiltroDropdown() {
    return DropdownButton<String>(
      value: _filtroSeleccionado,
      onChanged: (String? newValue) {
        setState(() {
          _filtroSeleccionado = newValue!;
        });
      },
      items: <String>['Todas', 'Confirmada', 'Pendiente', 'Cancelado']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
    );
  }
}
