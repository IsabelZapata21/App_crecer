import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/citas/citas.dart';
import 'package:flutter_application_2/views/asistencia/asistencias.dart';
import 'package:flutter_application_2/views/comuni/comunicacion.dart';
import 'package:flutter_application_2/views/cronograma/cronograma.dart';

class Dashboard extends StatelessWidget {
  @override
Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo más suave
      appBar: AppBar(
        backgroundColor: Colors.purple, // Un tono más profundo de púrpura
        title: Text('Dashboard'),
        elevation: 0, // Elimina la sombra para un diseño más plano
        actions: <Widget>[
          // ... (sin cambios aquí)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: const Icon(Icons.dashboard, size: 100, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            Text(
              'Bienvenida',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Cambiado a púrpura para coherencia
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionsWidget(context),
            const Spacer(),
            const Text(
              'Modo usuario',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
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