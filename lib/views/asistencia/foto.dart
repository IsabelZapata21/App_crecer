import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/services/asistencia/asistencia_service.dart';

class TomarFotoPage extends StatefulWidget {
  @override
  _TomarFotoPageState createState() => _TomarFotoPageState();
}

class _TomarFotoPageState extends State<TomarFotoPage> {
  late final CameraController _controller;
  late final Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.length < 2) {
        throw Exception('No se encontró la cámara solicitada.');
      }
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
        title: const Text('Tomar foto'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return _controller.value.isInitialized
                      ? CameraPreview(_controller)
                      : const Center(child: Text('Esperando...'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: const Text('Marcar Asistencia'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _takePicture() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar"),
          content: const Text("¿Deseas guardar la foto?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final XFile image = await _controller.takePicture();
                  String imagePath = image.path;
                  final asistencia = Asistencia(urlFoto: imagePath);
                  AsistenciaService().registrarAsistencia(asistencia);
                  // Aquí puedes usar `imagePath` para obtener la ruta de la imagen
                  // y luego marcar la asistencia con esa foto.

                  Navigator.of(context).pop();
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                  // Mostrar un mensaje de error al usuario
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al tomar la foto: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
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
