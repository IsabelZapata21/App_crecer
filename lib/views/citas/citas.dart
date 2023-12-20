import 'package:flutter/material.dart';
import 'package:flutter_application_2/viewmodels/citas/citas_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/services/repository.dart';
//import 'package:flutter_application_2/views/usuarios/registrar.dart';
import 'package:flutter_application_2/views/dashboard/acerca.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';
import 'package:flutter_application_2/views/usuarios/splash.dart';

class Citas extends StatelessWidget {
  final viewModel = CitasViewModel();
  Citas({super.key}); //instancia de viewModelcitas
  @override
  //interfazCitas
  Widget build(BuildContext context) {
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple, // Nuevo color de fondo
        title: const Text('Citas'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'cerrar_sesion') {
                () async {
                      // Agregar lógica para cerrar sesión
                      await AuthManager.logOut();
                      // Navegar a la pantalla de inicio de sesión después de cerrar sesión
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    };
                // Agregar aquí la lógica para cerrar sesión
              } else if (value == 'acerca_de') {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AcercaDe()),
                    );
                // Agregar aquí la lógica para mostrar la pantalla "Acerca de"
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'cerrar_sesion',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('Cerrar Sesión'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.account_circle_rounded,
                size: 50, color: Colors.purple), // Logo o ícono
            const SizedBox(height: 15),
            Text(
              '${usuario?.genero == 'Femenino' ? 'Bienvenida' : 'Bienvenido'}, ${usuario?.fullName}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionsWidget(context),
            Text(
              'Modo ${usuario?.rol}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            )
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
          'Programar cita',
          Icons.collections_bookmark_sharp,
          () => viewModel.navigateToRegistro(
              context), // Usa el ViewModel para la navegación
        ),
        _buildOptionItem(
          context,
          'Historial de citas',
          Icons.archive,
          () => viewModel.navigateToHistorialCitas(
              context), // Usa el ViewModel para la navegación
        ),
        _buildOptionItem(
          context,
          'Historial clínico',
          Icons.apps_outlined,
          () => viewModel.navigateToReporte(
              context), // Usa el ViewModel para la navegación
        ),
      ],
    );
  }

  Widget _buildOptionItem(
      BuildContext context, String text, IconData icon, Function onPressed) {
    return Card(
      elevation: 2, // Elevación del card
      margin: const EdgeInsets.symmetric(
          vertical: 12, horizontal: 0), // Margen horizontal reducido
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Esquinas redondeadas
      ),
      child: ListTile(
        onTap: () => onPressed(),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 16), // Padding ajustado
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(icon, color: Colors.white, size: 30),
          radius: 30,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios, // Icono de flecha hacia la derecha
          size: 20, // Tamaño ajustado
          color: Colors.grey, // Puedes ajustar el color según tus preferencias
        ),
      ),
    );
  }
}