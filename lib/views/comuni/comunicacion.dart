import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/chat/mensaje.dart';
import 'package:flutter_application_2/services/chat/chat_service.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:flutter_application_2/views/asistencia/foto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late StreamController<List<ChatMessage>> _messagesStreamController;
  late Stream<List<ChatMessage>> _messagesStream;
  late Timer _timer;
  // variables
  final ImagePicker _image = ImagePicker();
  File? archivo;

  final TextEditingController _textController = TextEditingController();

  void _handleSubmit(String text, String type) async {
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
    _textController.clear();
    final sended = await ChatService().enviarMensaje({
      "emisor": usuario?.id,
      "descripcion": text,
      "tipo": type,
    });
    if (!sended) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, verifica tu conexión '),
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final usuario =
          Provider.of<UserRepository>(context, listen: false).usuario;
      final pickedFile = await _image.pickImage(source: source);
      if (pickedFile != null) {
        String imagePath = pickedFile.path;

        // Llamada al método para subir la imagen a Firebase Storage
        final value = await uploadImage(File(imagePath),
            'chat/${DateTime.now().millisecondsSinceEpoch}-${usuario?.id}.jpg');
        if (value == null) throw ('No se pudo subir al repositorio.');
        _handleSubmit(value, 'I');
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      final usuario =
          Provider.of<UserRepository>(context, listen: false).usuario;
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Accede a la información del archivo seleccionado
        PlatformFile file = result.files.first;
        String? imagePath = file.path;
        if (imagePath == null) throw ('Sin asignar');

        // Llamada al método para subir la imagen a Firebase Storage
        final value = await uploadFile(File(imagePath),
            'chat/${DateTime.now().millisecondsSinceEpoch}-${usuario?.id}.jpg');
        if (value == null) throw ('No se pudo subir al repositorio.');
        // Ejemplo: Enviar el archivo como un mensaje
        _handleSubmit(value, 'F');
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  @override
  void initState() {
    // Crear el StreamController y el Stream
    _messagesStreamController = StreamController<List<ChatMessage>>();
    _messagesStream = _messagesStreamController.stream;

    // Iniciar el temporizador para emitir eventos cada segundo
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      // Actualizar la lista de mensajes (puedes cargar los mensajes de tu servicio aquí)
      actualizarListaMensajes();
    });
    super.initState();
  }

  @override
  void dispose() {
    // Detener el temporizador y cerrar el StreamController cuando el widget se elimina
    _timer.cancel();
    _messagesStreamController.close();
    super.dispose();
  }

  void actualizarListaMensajes() {
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;

    ChatService().obtenerMensajes().then((value) {
      final list = value
          .map<ChatMessage>((e) => ChatMessage(
                model: e,
                sended: usuario?.id == e.emisor,
              ))
          .toList();

      // Agregar la lista de mensajes al StreamController
      _messagesStreamController.add(list);
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.purple),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () {
                _pickImage(ImageSource.gallery);
                // Funcionalidad para seleccionar y enviar imágenes.
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_present),
              onPressed: () {
                _pickFile();
                // Funcionalidad para
                //seleccionar y enviar videos.
              },
            ),
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: (str) => _handleSubmit(str, 'M'),
                decoration: const InputDecoration.collapsed(
                    hintText: "Enviar un mensaje"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmit(_textController.text, 'M')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Grupal'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: _archiveChat,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Usar la lista de mensajes del snapshot para construir la interfaz
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, int index) => snapshot.data![index],
                  );
                } else {
                  // Mientras no haya datos, puedes mostrar un indicador de carga
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Búsqueda avanzada'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Palabras clave',
                ),
                // Funcionalidad de búsqueda por palabras clave.
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Usuario',
                ),
                // Funcionalidad de búsqueda por usuario.
              ),
            ],
          ),
          actions: <Widget>[
            FloatingActionButton(
              child: const Text('Buscar'),
              onPressed: () {
                // Función de búsqueda con los criterios seleccionados.
              },
            ),
            FloatingActionButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _archiveChat() {
    // Funcionalidad para archivar el chat actual.
  }
}

class ChatMessage extends StatelessWidget {
  final Mensaje model;
  final bool sended;
  const ChatMessage({super.key, required this.model, this.sended = false});

  @override
  Widget build(BuildContext context) {
    final user = model.autor ?? 'Usuario';
    final text = model.descripcion ?? '';
    final tipo = model.tipo ?? 'M';
    final mensaje = tipo == 'M'
        ? Text(
            text,
            overflow: TextOverflow.clip,
          )
        : tipo == 'I'
            ? Image.network(
                text,
                fit: BoxFit.contain,
                height: 200,
                errorBuilder: (context, error, stackTrace) => Text(
                  'No se puede visualizar ${text}',
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : const Row(
                children: [
                  Icon(Icons.file_download),
                  Expanded(
                    child: Text(
                      'Archivo enviado',
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: sended
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(user,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      mensaje,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                      child: Text(user.characters.first.toUpperCase())),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                      child: Text(user.characters.first.toUpperCase())),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user, style: Theme.of(context).textTheme.subtitle1),
                      const SizedBox(height: 2),
                      mensaje,
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
