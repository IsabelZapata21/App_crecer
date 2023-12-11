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
  XFile? imagePath;
  bool waitingForCapture = false;
  bool? localizado;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeLocation();
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

  _initializeLocation() async {
    if (localizado != null) {
      localizado = null;
      setState(() {});
    }
    await Future.delayed(const Duration(seconds: 1));
    localizado = await service.estaEnOficina();
    setState(() {});
  }

  Widget _cameraWidget(CameraController controller) {
    final camera = controller.value;
    final size = MediaQuery.sizeOf(context);
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullScreen = MediaQuery.sizeOf(context).height;
    return WillPopScope(
      onWillPop: () async {
        if (imagePath != null) {
          setState(() {
            imagePath = null;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Tomar foto'),
          backgroundColor: Colors.purple,
        ),
        body: Stack(
          children: [
            imagePath == null
                ? Center(
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          return _controller.value.isInitialized
                              ? _cameraWidget(_controller)
                              : const Text('Esperando...');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  )
                : Positioned.fill(
                    child: Image.file(
                      File(imagePath!.path),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: _initializeLocation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        localizado != null
                            ? Icon(
                                localizado == true
                                    ? Icons.check
                                    : Icons.info_outline,
                                color: localizado == true
                                    ? Colors.green
                                    : Colors.yellow)
                            : const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                        const SizedBox(width: 8),
                        Text(
                          localizado == null
                              ? 'Buscando ubicación'
                              : localizado == true
                                  ? 'En oficina'
                                  : 'Ubicación sin reconocer',
                          style: TextStyle(
                              color: localizado == null
                                  ? Colors.white
                                  : localizado == true
                                      ? Colors.green
                                      : Colors.yellow),
                        ),
                      ],
                    ),
                  ),
                  waitingForCapture
                      ? const CircularProgressIndicator()
                      : imagePath == null
                          ? Hero(
                              tag: 'HeroCameraButton',
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: _takePicture,
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    onPrimary: Colors.white),
                                label: const Text('Tomar foto'),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => setState(() {
                                    imagePath = null;
                                  }),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                      onPrimary: Colors.white),
                                  child: const Text('Volver a tomar'),
                                ),
                                const SizedBox(width: 4),
                                Hero(
                                  tag: 'HeroCameraButton',
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.assistant),
                                    onPressed: _takePicture,
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.deepPurple,
                                        onPrimary: Colors.white),
                                    label: const Text('Marcar asistencia'),
                                  ),
                                ),
                              ],
                            ),
                  SizedBox(height: fullScreen * .1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _takePicture() async {
    if (imagePath == null) {
      waitingForCapture = true;
      setState(() {});
      imagePath = await _controller.takePicture();
      waitingForCapture = false;
      setState(() {});
      return;
    }
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
    final subir = await confirmUploadImage(context);
    if (!subir) return;
    final file = imagePath?.path ?? '';
    if (file.isEmpty) return;
    try {
      if (usuario?.id == null) throw ('Sesión perdida.');
      // Llamada al método para subir la imagen a Firebase Storage
      waitingForCapture = true;
      setState(() {});
      final value = await uploadImage(File(file),
          'asistencias/${DateTime.now().millisecondsSinceEpoch}.jpg');
      if (value == null) throw ('No se pudo subir al repositorio.');
      // Aquí puedes continuar con el resto del código
      final asistencia = Asistencia(
          urlFoto: value, estado: localizado ?? false, idUsuario: usuario?.id);
      await service.registrarAsistencia(asistencia);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      // Mostrar un mensaje de error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar la foto: $e')),
      );
    }
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }
}

Future<bool> confirmUploadImage(context) async {
  final value = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar asistencia"),
        content: const Text("¿Deseas marcar tu asistencia?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text("Aceptar"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
  return value ?? false;
}
