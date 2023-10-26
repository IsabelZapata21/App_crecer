import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/cita.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';

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
        title: Text('Detalles de la Cita', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.purple),
                SizedBox(width: 8),
                Text('Fecha: ${cita.fechaCita?.toLocal().toString().split(' ')[0]}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.purple),
                SizedBox(width: 8),
                Text('Hora: ${cita.horaCita}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.note, color: Colors.purple),
                SizedBox(width: 8),
                Expanded(child: Text('Descripción: ${cita.descripcion ?? ''}')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, color: Colors.purple),
                SizedBox(width: 8),
                Text('Paciente: ${cita.idPaciente ?? 'Desconocido'}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.purple),
                SizedBox(width: 8),
                Text('Psicólogo: ${cita.idPsicologo ?? 'Desconocido'}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.purple),
                SizedBox(width: 8),
                Text('Especialidad: ${cita.idEspecialidad ?? 'Desconocido'}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event_note, color: Colors.purple),
                SizedBox(width: 8),
                Text('Estado: ${cita.estado}'),
              ],
            ),
          ],
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
