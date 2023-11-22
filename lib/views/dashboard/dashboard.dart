import 'package:flutter/material.dart';
import 'package:flutter_application_2/views/citas/citas.dart';
import 'package:flutter_application_2/views/asistencia/asistencias.dart';
import 'package:flutter_application_2/views/comuni/comunicacion.dart';
import 'package:flutter_application_2/views/cronograma/cronograma.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Dashboard'),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.info, color: Colors.purple),
                  title: Text('Acerca De'),
                  onTap: () {
                    // Agregar lógica para mostrar información sobre la aplicación
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
              child:
                  const Icon(Icons.dashboard, size: 100, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            Text(
              'Bienvenida',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
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
          Icons.assignment,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AsistenciaPage()),
            );
          },
        ),
        _buildOptionItem(
          context,
          'Ver cronograma',
          Icons.calendar_month_outlined,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CronogramaScreen()),
            );
          },
        ),
        _buildOptionItem(
          context,
          'Ir a citas',
          Icons.work_history,
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
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOptionItem(
      BuildContext context, String text, IconData icon, Function onPressed) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () => onPressed(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }
}
