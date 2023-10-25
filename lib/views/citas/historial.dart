import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/cita.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';

class HistorialCitas extends StatefulWidget {
  @override
  _HistorialCitasState createState() => _HistorialCitasState();
}

class _HistorialCitasState extends State<HistorialCitas> {
  String _filtroSeleccionado = 'Todas'; // Por defecto, muestra todas las citas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Historial de citas'),
        actions: <Widget>[
          _buildFiltroDropdown(),
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
                PopupMenuItem<String>(
                  value: 'cerrar_sesion',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('Cerrar Sesión'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'acerca_de',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('Acerca de'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Citas>>(
        future: CitasService().obtenerListaCitas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay citas disponibles.'),
            );
          } else {
            final List<Citas> citas = snapshot.data!
                .where((cita) => _filtroSeleccionado == 'Todas' || cita.estado == _filtroSeleccionado)
                .toList();
            return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                final cita = citas[index];
                return GestureDetector(
                  onTap: () => _mostrarDetallesCita(cita),
                  child: _buildCitaItem(
                    fecha: 'Fecha: ${cita.fechaCita?.toLocal().toString().split(' ')[0]}',
                    hora: 'Hora: ${cita.horaCita}',
                    descripcion: cita.descripcion ?? '',
                    isPast: false,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

void _mostrarDetallesCita(Citas cita) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Detalles de la Cita'),
        content: SingleChildScrollView( // Añadido para manejar contenido que podría ser más largo
          child: ListBody( // Usamos ListBody en lugar de Column
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Fecha'),
                subtitle: Text('${cita.fechaCita?.toLocal().toString().split(' ')[0]}'),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Hora'),
                subtitle: Text('${cita.horaCita}'),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Descripción'),
                subtitle: Text('${cita.descripcion ?? ''}'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Paciente'),
                subtitle: Text('${cita.idPaciente}'), // Aquí deberías mostrar el nombre del paciente en lugar del ID
              ),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Psicólogo'),
                subtitle: Text('${cita.idPsicologo}'), // Aquí deberías mostrar el nombre del psicólogo en lugar del ID
              ),
              ListTile(
                leading: Icon(Icons.medical_services),
                title: Text('Especialidad'),
                subtitle: Text('${cita.idEspecialidad}'), // Aquí deberías mostrar el nombre de la especialidad en lugar del ID
              ),
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Estado'),
                subtitle: Text('${cita.estado}'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  Widget _buildCitaItem({required String fecha, required String hora, required String descripcion, required bool isPast}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: isPast ? Colors.grey : Colors.purple,
          child: Icon(Icons.calendar_today, color: Colors.white, size: 30),
          radius: 30,
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
      items: <String>['Todas', 'Confirmada', 'Pendiente', 'Cancelada']
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
