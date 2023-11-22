import 'dart:io';

import 'package:flutter/material.dart';
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
  List<ChatMessage> _messages = [];
  // variables
  final ImagePicker _image = ImagePicker();
  File? archivo;

  final TextEditingController _textController = TextEditingController();

  void _handleSubmit(String text, String type) async {
    _textController.clear();
    ChatMessage message = ChatMessage(text: text, tipo: type);
    final sended = await ChatService()
        .enviarMensaje({"emisor": 2, "descripcion": text, "tipo": type});
    if (sended) {
      setState(() {
        _messages.insert(0, message);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
    ChatService().obtenerMensajes().then((value) {
      print(value);
      final list = value
          .map<ChatMessage>((e) =>
              ChatMessage(text: e.descripcion ?? '', tipo: e.tipo ?? 'M'))
          .toList();
      setState(() {
        _messages = list;
      });
    });
    super.initState();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.purple),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () {
                _pickImage(ImageSource.gallery);
                // Funcionalidad para seleccionar y enviar imágenes.
              },
            ),
            IconButton(
              icon: Icon(Icons.file_present),
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
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar un mensaje"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
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
        title: Text('Chat Grupal'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: _archiveChat,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
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
          title: Text('Búsqueda avanzada'),
          content: Column(
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
              child: Text('Buscar'),
              onPressed: () {
                // Función de búsqueda con los criterios seleccionados.
              },
            ),
            FloatingActionButton(
              child: Text('Cancelar'),
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
  final String text;
  final String tipo;
  const ChatMessage({super.key, required this.text, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text('U')),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Usuario', style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(height: 2),
                tipo == 'M'
                    ? Text(
                        text,
                        overflow: TextOverflow.clip,
                      )
                    : tipo == 'I'
                        ? Image.network(
                            text,
                            fit: BoxFit.contain,
                            height: 200,
                          )
                        : Row(
                            children: [
                              Icon(Icons.file_download),
                              Expanded(
                                child: Text(
                                  'Archivo enviado',
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
