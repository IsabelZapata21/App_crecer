import 'package:flutter/material.dart';



class Cronograma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronograma'),
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
                  child: Text('Cerrar Sesión'),
                ),
                PopupMenuItem<String>(
                  value: 'acerca_de',
                  child: Text('Acerca de'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
    );
  }

  Widget _buildOptionsWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildOptionItem(
          context,
          'Programar cita',
          Icons.calendar_today,
          () {
            // Agregar aquí la lógica para ir a la pantalla de programar cita
          },
        ),
        _buildOptionItem(
          context,
          'Actualizar citas',
          Icons.update,
          () {
            // Agregar aquí la lógica para ir a la pantalla de actualizar citas
          },
        ),
        _buildOptionItem(
          context,
          'Historial de citas',
          Icons.history,
          () {
            // Agregar aquí la lógica para ir a la pantalla de historial de citas
          },
        ),
      ],
    );
  }

  Widget _buildOptionItem(BuildContext context, String text, IconData icon, Function onPressed) {
    return InkWell(
      onTap: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  icon,
                  size: 32,
                  color: Colors.orange,
                ),
                SizedBox(width: 16),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios, // Icono de flecha hacia la derecha
              size: 24,
              color: Colors.grey, // Puedes ajustar el color según tus preferencias
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Cronograma(),
  ));
}