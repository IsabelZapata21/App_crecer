import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/auth/usuario.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController dniController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController contraseniaController = TextEditingController();

  String _selectedRol = 'Seleccionar'; // Valor predeterminado
  String _selectedGenero = 'Seleccionar'; // Valor predeterminado

  List<String> roles = [
    'Seleccionar',
    'Colaborador',
    'Administrador',
    'Interno',
    'Practicante'
  ];
  List<String> genero = [
    'Seleccionar',
    'Masculino',
    'Femenino',
    'Sin especificar'
  ];

  Future<void> _registrarUsuario() async {
  try {
    // Validar que los campos no estén vacíos
    if (nombresController.text.isEmpty) {
      throw ('Falta ingresar los nombres');
    } else if (apellidosController.text.isEmpty) {
      throw ('Falta ingresar los apellidos');
    } else if (telefonoController.text.isEmpty) {
      throw ('Falta ingresar el teléfono');
    } else if (telefonoController.text.length != 9) {
      throw ('El número de teléfono debe tener 9 dígitos');
    } else if (dniController.text.isEmpty) {
      throw ('Falta ingresar el DNI');
    } else if (dniController.text.length != 8) {
      throw ('El DNI debe tener 8 dígitos');
    } else if (emailController.text.isEmpty) {
      throw ('Falta ingresar el correo electrónico');
    } else if (!_esCorreoValido(emailController.text)) {
      throw ('Ingrese un correo electrónico válido');
    } else if (usuarioController.text.isEmpty) {
      throw ('Falta ingresar el usuario');
    } else if (contraseniaController.text.isEmpty) {
      throw ('Falta ingresar la contraseña');
    } else if (!_esContraseniaFuerte(contraseniaController.text)) {
      throw ('La contraseña debe contener al menos una mayúscula, un número y un símbolo');
    } else if (_selectedRol == 'Seleccionar') {
      throw ('Falta seleccionar el rol');
    } else if (_selectedGenero == 'Seleccionar') {
      throw ('Falta seleccionar el género');
    }

      Map<String, dynamic> userData = {
        'rol': _selectedRol,
        'nombres': nombresController.text,
        'apellidos': apellidosController.text,
        'telefono': telefonoController.text,
        'genero': _selectedGenero,
        'dni': dniController.text,
        'email': emailController.text,
        'usuario': usuarioController.text,
        'contrasenia': contraseniaController.text,
        'create_at': Provider.of<UserRepository>(context, listen: false).usuario?.id
      };

      // Llamar al servicio de registro
      final value = await AuthService().registrarUsuario(userData);

      // Verificar si el registro fue exitoso
      if (!(value['success'] ?? false)) {
        throw ('Error al registrar usuario: ${value['message']}');
      }

      // Redirigir a la pantalla de Dashboard después del registro exitoso
      Navigator.pop(context);
    } catch (e) {
      // Mostrar error en un AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de registro'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  bool _esCorreoValido(String correo) {
  // Utilizar una expresión regular para validar el formato del correo electrónico
  final emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  return emailRegExp.hasMatch(correo);
}

bool _esContraseniaFuerte(String contrasenia) {
  // Utilizar una expresión regular para validar la fortaleza de la contraseña
  final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');
  return passwordRegExp.hasMatch(contrasenia);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de usuario',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField(
                value: _selectedRol,
                onChanged: (value) {
                  setState(() {
                    _selectedRol = value.toString();
                  });
                },
                items: roles.map((rol) {
                  return DropdownMenuItem(
                    value: rol,
                    child: Text(rol),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  icon: Icon(Icons.remember_me_outlined, color: Colors.purple),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nombresController,
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  icon: Icon(Icons.person, color: Colors.purple),
                ),
              ),
              TextField(
                controller: apellidosController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  icon: Icon(Icons.person, color: Colors.purple),
                ),
              ),
              TextField(
                controller: telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  icon: Icon(Icons.phone, color: Colors.purple),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedGenero,
                onChanged: (value) {
                  setState(() {
                    _selectedGenero = value.toString();
                  });
                },
                items: genero.map((genero) {
                  return DropdownMenuItem(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Género',
                  icon: Icon(Icons.remember_me_outlined, color: Colors.purple),
                ),
                isExpanded: true, // Asegura que el desplegable ocupe el ancho completo
              ),
              SizedBox(height: 10),
              TextField(
                controller: dniController,
                decoration: InputDecoration(
                  labelText: 'DNI',
                  icon: Icon(Icons.credit_card, color: Colors.purple),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email, color: Colors.purple),
                ),
              ),
              TextField(
                controller: usuarioController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  icon: Icon(Icons.person, color: Colors.purple),
                ),
              ),
              TextField(
                controller: contraseniaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  icon: Icon(Icons.lock, color: Colors.purple),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
