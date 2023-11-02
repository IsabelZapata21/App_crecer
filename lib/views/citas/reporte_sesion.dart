import 'package:flutter/material.dart';
import 'detalles_sesion.dart';

class Reporte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            Icon(Icons.apps_outlined),
            SizedBox(width: 8),
            Text('Reportes'),
          ],
        ),
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
       body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar reporte',
                prefixIcon: Icon(Icons.search, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              // Aquí puedes agregar la lógica para filtrar las citas según la búsqueda
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: <Widget>[
                _buildCitaItem(
                  fecha: '03 Octubre 2023',
                  hora: '15:00 - 16:00',
                  descripcion: 'Consulta médica general',
                ),
                SizedBox(height: 8.0),
                _buildCitaItem(
                  fecha: '10 Octubre 2023',
                  hora: '10:00 - 11:00',
                  descripcion: 'Revisión de exámenes',
                ),
                // Puedes agregar más citas aquí
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetallesSesion()),
          );// Aquí puedes agregar la lógica para dirigir al usuario a la pantalla de agregar cita
        },
      ),
    );
  }
  }

  Widget _buildCitaItem({required String fecha, required String hora, required String descripcion}) {
    return Card(
      elevation: 2, // Elevación del card
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Margen reducido
      child: ListTile(
        leading: Icon(
          Icons.calendar_today,
          size: 32,
          color: Colors.deepPurple, // Nuevo color
        ),
        title: Text(
          fecha,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold, // Texto en negrita
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0), // Espacio entre el título y el subtítulo
            Text('Hora: $hora'),
            Text(descripcion),
          ],
        ),
      ),
    );
  }