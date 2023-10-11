import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';

class HistorialCitas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple, // Nuevo color de fondo
        title: Text('Historial de Citas'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildCitaItem(
              fecha: '03 Octubre 2023',
              hora: '15:00 - 16:00',
              descripcion: 'Consulta médica general',
              isPast: false, // Añadido para diferenciar citas pasadas
            ),
            _buildCitaItem(
              fecha: '10 Octubre 2023',
              hora: '10:00 - 11:00',
              descripcion: 'Revisión de exámenes',
              isPast: true, // Añadido para diferenciar citas pasadas
            ),
            // Puedes agregar más citas aquí
          ],
        ),
      ),
    );
  }

  Widget _buildCitaItem({required String fecha, required String hora, required String descripcion, required bool isPast}) {
    return Card(
      elevation: 2, // Elevación del card
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 0), // Margen horizontal reducido
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
        subtitle: Text('Hora: $hora\n$descripcion'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HistorialCitas(),
  ));
}
