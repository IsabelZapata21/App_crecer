import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/auth/usuario.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';

class HistorialUsuarios extends StatefulWidget {
  @override
  _HistorialUsuariosState createState() => _HistorialUsuariosState();
}

class _HistorialUsuariosState extends State<HistorialUsuarios> {
  String _filtroSeleccionado = 'Todos';
  List<Usuario>? _usuarios;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    try {
      print('Iniciando carga de datos');
      final usuarios = await AuthService().listarUsuarios();
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
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final usuariosFiltrados = _filtroSeleccionado == 'Todos'
        ? _usuarios!
        : _usuarios!
            .where((usuario) => usuario.rol == _filtroSeleccionado)
            .toList();

    if (usuariosFiltrados.isEmpty) {
      return Center(
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
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Correo: ${usuario.email}'),
            Text('Rol: ${usuario.rol}'),
          ],
        ),
        onTap: () => _mostrarDetallesUsuario(usuario),
      ),
    );
  }

  void _mostrarDetallesUsuario(Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del usuario'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${usuario.nombres} ${usuario.apellidos}'),
              Text('DNI: ${usuario.dni}'),
              Text('Correo electrónico: ${usuario.email}'),
              Text('Teléfono: ${usuario.telefono}'),
              Text('Género: ${usuario.genero}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Editar'),
              onPressed: () {
                _editarUsuario(usuario);
                Navigator.of(context)
                    .pop(); // Cierra el AlertDialog después de editar.
              },
            ),
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void _editarUsuario(Usuario usuario) {
  String nuevaContrasena = "";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar usuario'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${usuario.nombres} ${usuario.apellidos}'),
                SizedBox(height: 16),
                Text('Teléfono: ${usuario.telefono}'),
                SizedBox(height: 16),
                Text('Género: ${usuario.genero}'),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      nuevaContrasena = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Nueva Contraseña'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Lógica para cambiar la contraseña aquí
                  await _cambiarContrasena(usuario.id, nuevaContrasena);
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          );
        },
      );
    },
  );
}


  Future<void> _cambiarContrasena(int? userId, String nuevaContrasena) async {
    if (userId != null) {
      final authService = AuthService();
      final response =
          await authService.cambiarContrasenia(userId, nuevaContrasena);

      if (response['success']) {
        // Contraseña cambiada correctamente
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contraseña cambiada correctamente'),
          duration: Duration(seconds: 2),
        ));
      } else {
        // Hubo un error al cambiar la contraseña
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cambiar la contraseña'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      // Manejar el caso donde userId es null (opcional)
    }
  }

  Widget _buildFiltroDropdown() {
    return DropdownButton<String>(
      value: _filtroSeleccionado,
      onChanged: (String? newValue) {
        setState(() {
          _filtroSeleccionado = newValue!;
        });
      },
      items: <String>['Todos', 'Colaborador', 'Interno', 'Administrador']
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
