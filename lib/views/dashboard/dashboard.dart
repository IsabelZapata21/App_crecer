import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/views/citas/citas.dart';
import 'package:flutter_application_2/views/asistencia/asistencias.dart';
import 'package:flutter_application_2/views/comuni/comunicacion.dart';
import 'package:flutter_application_2/views/cronograma/cronograma.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple, // Nuevo color de fondo
        title: Text('Dashboard'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.dashboard, size: 100, color: Colors.purple), // Logo o ícono
            SizedBox(height: 20),
            Text(
              'Bienvenida',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 20),
            _buildOptionsWidget(context),
            Spacer(), // Estira el modo usuario hasta la parte inferior
            Text(
              'Modo usuario',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildOptionItem(
          context,
          'Registrar asistencia',
          Icons.calendar_today,
          () {
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AsistenciaPage()),
          );// Agregar aquí la lógica para ir a la pantalla de programar cita
          },
        ),
        _buildOptionItem(
          context,
          'Ver cronograma',
          Icons.update,
          () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CronogramaScreen()),
          );// Ag// Agregar aquí la lógica para ir a la pantalla de actualizar citas
          },
        ),
        _buildOptionItem(
          context,
          'Ir a citas',
          Icons.history,
          () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Citas()),
          );
          },
        ),
        _buildOptionItem(
          context,
          'Ir a chat',
          Icons.message,
          () {
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatApp()),
          );
          },
        ),
      ],
    );
  }

  Widget _buildOptionItem(BuildContext context, String text, IconData icon, Function onPressed) {
    return Card(
      elevation: 2, // Elevación del card
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 0), // Margen horizontal reducido
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
      ),
      child: ListTile(
        onTap: () => onPressed(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Padding ajustado
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(icon, color: Colors.white, size: 30),
          radius: 30,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios, // Icono de flecha hacia la derecha
          size: 20, // Tamaño ajustado
          color: Colors.grey, // Puedes ajustar el color según tus preferencias
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Dashboard(),
  ));
}
