import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:flutter_application_2/views/citas/citas.dart';
import 'package:flutter_application_2/views/asistencia/asistencias.dart';
import 'package:flutter_application_2/views/comuni/comunicacion.dart';
import 'package:flutter_application_2/views/cronograma/cronograma.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';
//import 'package:flutter_application_2/views/usuarios/registrar.dart';
import 'package:flutter_application_2/views/usuarios/usuario_dash.dart';
import 'package:flutter_application_2/views/dashboard/acerca.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
                  const Icon(Icons.person_pin, size: 50, color: Colors.purple),
            ),
            const SizedBox(height: 10),
            Text(
              '${usuario?.genero == 'Femenino' ? 'Bienvenida' : 'Bienvenido'}, ${usuario?.fullName}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            _buildOptionsWidget(context),
            Text(
              'Modo ${usuario?.rol}',
              style: const TextStyle(
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
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
    return Column(
      children: <Widget>[
        if (usuario?.isAdministrator == true)
          _buildOptionItem(
            context,
            'Usuarios',
            Icons.person,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsuarioDashboard()),
              );
            },
          ),
        _buildOptionItem(
          context,
          'Citas',
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
          'Asistencia',
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
          'Cronograma',
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
          'Comunicación',
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
