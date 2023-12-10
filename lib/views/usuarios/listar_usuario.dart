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
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Lista de usuarios'),
        ),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          _buildFiltroDropdown(),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        title: Text(
          'Nombre: ${usuario.nombres} ${usuario.apellidos}',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text('Correo: ${usuario.email}\nRol: ${usuario.rol}'),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailText('Nombre', '${usuario.nombres} ${usuario.apellidos}'),
              _buildDetailText('DNI', '${usuario.dni}'),
              _buildDetailText('Correo electrónico', '${usuario.email}'),
              _buildDetailText('Teléfono', '${usuario.telefono}'),
              _buildDetailText('Género', '${usuario.genero}'),
            ],
          ),
          actions: <Widget>[
            _buildAlertDialogButton('Editar', () => _editarUsuario(usuario)),
            _buildAlertDialogButton('Cerrar', () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: $value'),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailText('Nombre', '${usuario.nombres} ${usuario.apellidos}'),
                  const SizedBox(height: 16),
                  _buildDetailText('Teléfono', '${usuario.telefono}'),
                  const SizedBox(height: 16),
                  _buildDetailText('Género', '${usuario.genero}'),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        nuevaContrasena = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Nueva Contraseña'),
                  ),
                ],
              ),
              actions: [
                _buildAlertDialogButton('Cancelar', () => Navigator.of(context).pop()),
                ElevatedButton(
                  onPressed: () async {
                    await _cambiarContrasena(usuario.id, nuevaContrasena);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar Cambios'),
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
      final response = await authService.cambiarContrasenia(userId, nuevaContrasena);

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Contraseña cambiada correctamente'),
          duration: Duration(seconds: 2),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
      items: <String>['Todos', 'Colaborador', 'Interno', 'Administrador', 'Practicante']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAlertDialogButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
