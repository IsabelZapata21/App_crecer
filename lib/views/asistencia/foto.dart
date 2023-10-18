import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TomarFotoPage extends StatefulWidget {
  @override
  _TomarFotoPageState createState() => _TomarFotoPageState();
}

class _TomarFotoPageState extends State<TomarFotoPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras[1];

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller.initialize();
    } catch (e) {
      _initializeControllerFuture =
          Future.error('Error initializing camera: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomar foto'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height:
                500, // Define el alto que quieras para el cuadro de la cámara
            width:
                500, // Define el ancho que quieras para el cuadro de la cámara
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return _controller.value.isInitialized
                      ? CameraPreview(_controller)
                      : Center(child: Text('Esperando...'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirmar"),
                    content: Text("¿Deseas guardar la foto?"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Aceptar"),
                        onPressed: () async {
                          try {
                            await _initializeControllerFuture;
                            final XFile image = await _controller.takePicture();
                            String imagePath = image.path;

                            // Aquí puedes usar `imagePath` para obtener la ruta de la imagen
                            // y luego marcar la asistencia con esa foto.
                            // Por ejemplo:
                            // markAttendanceWithImage(imagePath);

                            Navigator.of(context).pop();
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Marcar Asistencia'),
            style: ElevatedButton.styleFrom(primary: Colors.purple),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }
}
