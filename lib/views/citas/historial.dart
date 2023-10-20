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
        backgroundColor: Colors.purple, // Nuevo color de fondo
        title: Text('Historial de citas'),
        actions: <Widget>[
          _buildFiltroDropdown(), // Agregamos el filtro como un widget en el AppBar
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
        future: CitasService().obtenerListaCitas(), // Llama a la función para obtener la lista de citas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Muestra un indicador de carga mientras se obtienen los datos
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
            // Cuando se obtienen los datos con éxito
            final List<Citas> citas = snapshot.data!
                .where((cita) => _filtroSeleccionado == 'Todas' || cita.estado == _filtroSeleccionado)
                .toList();
            return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                final cita = citas[index];
                return _buildCitaItem(
                  fecha: 'Fecha: ${cita.fechaCita?.toLocal().toString().split(' ')[0]}', // Formatea la fecha
                  hora: 'Hora: ${cita.horaCita}',
                  descripcion: cita.descripcion ?? '',
                  isPast: false, // Añadido para diferenciar citas pasadas
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCitaItem({required String fecha, required String hora, required String descripcion, required bool isPast}) {
    return Card(
      elevation: 2, // Elevación del card
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Margen horizontal ajustado
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Padding ajustado
        leading: CircleAvatar(
          backgroundColor: isPast ? Colors.grey : Colors.purple, // Color basado en si la cita es pasada o no
          child: Icon(Icons.calendar_today, color: Colors.white, size: 30),
          radius: 30,
        ),
        title: Text(
          fecha,
          style: TextStyle(
            fontSize: 18,
            color: isPast ? Colors.grey : Colors.black, // Color basado en si la cita es pasada o no
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
