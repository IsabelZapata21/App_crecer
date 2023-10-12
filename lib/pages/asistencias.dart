import 'package:flutter/material.dart';

class AsistenciaPage extends StatefulWidget {
  @override
  _AsistenciaPageState createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset('assets/foto.png'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            color: Colors.purple,
            iconSize: 40.0,
            onPressed: () {
              // _showCameraOptions(context);
            },
          ),
          SizedBox(height: 20),
          // Botones "Marcar Asistencia" y "Mis Asistencias" en una sola fila
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Espaciado entre los botones
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para marcar asistencia
                      },
                      child: Text('Marcar Asistencia'),
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para ver asistencias
                      },
                      child: Text('Mis Asistencias'),
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCameraOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opciones de cámara'),
          content: Text('Elige una opción:'),
          actions: <Widget>[
            TextButton(
              child: Text('Tomar Foto'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                // Aquí puedes agregar la lógica para tomar una foto
              },
            ),
            TextButton(
              child: Text('Mostrar Alerta'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                _showAlert(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content:
              Text('Ha ocurrido un error al intentar acceder a la cámara.'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
