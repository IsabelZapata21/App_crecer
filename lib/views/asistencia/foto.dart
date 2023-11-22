import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/services/asistencia/asistencia_service.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:provider/provider.dart';

Future<String?> uploadImage(File file, String fileName) async {
  try {
    // Referencia al bucket de almacenamiento en Firebase
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

// Define metadatos para el archivo (puedes personalizar según tus necesidades)
    SettableMetadata metadata = SettableMetadata(
      contentType:
          'image/${fileName.split('.').last.toLowerCase()}', // Establece el tipo MIME
    );
    // Sube el archivo
    UploadTask uploadTask = storageReference.putFile(file, metadata);
    // Espera a que se complete la carga
    await uploadTask.whenComplete(() => print('Archivo subido con éxito'));

    // Obtiene la URL del archivo cargado
    String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error al subir el archivo: $e');
  }
  return null;
}

Future<String?> uploadFile(File file, String fileName) async {
  try {
    // Referencia al bucket de almacenamiento en Firebase
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    // Sube el archivo
    UploadTask uploadTask = storageReference.putFile(file);
    // Espera a que se complete la carga
    await uploadTask.whenComplete(() => print('Archivo subido con éxito'));

    // Obtiene la URL del archivo cargado
    String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error al subir el archivo: $e');
  }
  return null;
}

class TomarFotoPage extends StatefulWidget {
  @override
  _TomarFotoPageState createState() => _TomarFotoPageState();
}

class _TomarFotoPageState extends State<TomarFotoPage> {
  late final CameraController _controller;
  late final Future<void> _initializeControllerFuture;
  final service = AsistenciaService();

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
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
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

                  // Llamada al método para subir la imagen a Firebase Storage
                  final value = await uploadImage(File(imagePath),
                      'asistencias/${DateTime.now().millisecondsSinceEpoch}.jpg');
                  if (value == null) throw ('No se pudo subir al repositorio.');
                  if (usuario?.id == null) throw ('Sesión perdida.');
                  // Aquí puedes continuar con el resto del código
                  final enOficina = await service.estaEnOficina();
                  final asistencia = Asistencia(
                      urlFoto: value,
                      estado: enOficina,
                      idUsuario: usuario?.id);
                  await service.registrarAsistencia(asistencia);
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                  // Mostrar un mensaje de error al usuario
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al tomar la foto: $e')),
                  );
                }
                Navigator.of(context).pop();
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
