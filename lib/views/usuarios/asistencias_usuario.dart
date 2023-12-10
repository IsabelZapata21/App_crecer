import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/asistencias/asistencia.dart';
import 'package:flutter_application_2/models/auth/usuario.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:flutter_application_2/services/asistencia/asistencia_service.dart';

class AsistenciasUsuarios extends StatefulWidget {
  @override
  _AsistenciasUsuariosState createState() => _AsistenciasUsuariosState();
}

class _AsistenciasUsuariosState extends State<AsistenciasUsuarios> {
  String _filtroSeleccionado = 'Todos';
  List<Usuario>? _usuarios;
  List<Asistencia> asistencias = [];
  final service = AsistenciaService();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    try {
      print('Iniciando carga de datos');
      final usuarios = await AuthService().listarUsuarios();
      //final asistencias = await
      print(usuarios);
      setState(() {
        _usuarios = usuarios;
      });
      print('Datos cargados exitosamente');
    } catch (e) {
      print('Error al cargar los usuarios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de usuarios'),
        backgroundColor: Colors.purple, // Cambia el color de la barra a púrpura
        actions: <Widget>[
          _buildFiltroDropdown(),
          // Agrega aquí otros elementos de acción si es necesario
        ],
      ),
      body: _buildUsuariosList(),
    );
  }

  Widget _buildUsuariosList() {
    if (_usuarios == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final usuariosFiltrados = _filtroSeleccionado == 'Todos'
        ? _usuarios!
        : _usuarios!
            .where((usuario) => usuario.rol == _filtroSeleccionado)
            .toList();

    if (usuariosFiltrados.isEmpty) {
      return const Center(
        child: Text('No hay usuarios disponibles.'),
      );
    }

    return ListView.builder(
      itemCount: usuariosFiltrados.length,
      itemBuilder: (context, index) {
        final usuario = usuariosFiltrados[index];
        return _buildUsuarioItem(usuario);
      },
    );
  }

  Widget _buildUsuarioItem(Usuario usuario) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        title: Text(
          'Nombre: ${usuario.nombres} ${usuario.apellidos}',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Correo: ${usuario.email}'),
            Text('Rol: ${usuario.rol}'),
          ],
        ),
        onTap: () => _mostrarAsistenciasUsuario(usuario),
      ),
    );
  }

  void _mostrarAsistenciasUsuario(Usuario usuario) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lista de asistencias'),
          content: FutureBuilder(
              future: AsistenciaService().obtenerAsistencias(usuario.id),
              builder: (context, snapshot) {
                if(snapshot.data==null) return const Center(child: CircularProgressIndicator());
                if (snapshot.data?.isEmpty??true){
                  return const Text('No hay asistencias registradas');                }
                final faltas =
                    snapshot.data?.where((element) => !element.estado).length??0;
                final asistido =
                    snapshot.data?.where((element) => element.estado).length??0;
                final estado = faltas<asistido?'Asistiendo':'En evaluación';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize
                      .min, // Ajusta el tamaño vertical según el contenido
                  children: [
                    Text('Estado: ${estado}'),
                    Text('Fecha:${snapshot.data?.last.fecha}'),
                    Text('Faltas:${faltas}'),
                    Text('Asistencias:${asistido}')
                  ],
                );
              }),
          contentPadding: EdgeInsets.fromLTRB(
              20.0, 10.0, 20.0, 10.0), // Ajusta el espacio interno
          insetPadding: EdgeInsets.all(10.0), // Ajusta el espacio externo
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Ajusta la forma del AlertDialog
          ),
          backgroundColor:
              Colors.white, // Cambia el color de fondo del AlertDialog
          elevation: 5.0, // Ajusta la elevación del AlertDialog
          clipBehavior: Clip
              .antiAliasWithSaveLayer, // Agrega anti-aliasing para bordes suaves
          scrollable:
              true, // Permite desplazamiento si el contenido es demasiado largo
          //scrollController: ScrollController(), // Controlador de desplazamiento si es necesario
          // Puedes ajustar otros parámetros según tus necesidades
        );
      },
    );
  }

  Widget _buildFiltroDropdown() {
    return DropdownButton<String>(
      value: _filtroSeleccionado,
      onChanged: (String? newValue) {
        setState(() {
          _filtroSeleccionado = newValue!;
        });
      },
      items: <String>[
        'Todos',
        'Colaborador',
        'Interno',
        'Administrador',
        'Practicante'
      ]
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
    );
  }
}
