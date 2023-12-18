import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/auth/usuario.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/services/auth/auth_manager.dart';

class RegistroPsicologoScreen extends StatefulWidget {
  @override
  _RegistroPsicologoScreenState createState() => _RegistroPsicologoScreenState();
}

class _RegistroPsicologoScreenState extends State<RegistroPsicologoScreen> {
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController dniController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nacimientoController = TextEditingController();
  TextEditingController nacionalidadController = TextEditingController();

  String _selectedEspecialidad = 'Seleccionar'; // Valor predeterminado
  String _selectedGenero = 'Seleccionar'; // Valor predeterminado
  

  List<String> especialidades = ['Seleccionar', 'Especialidad 1', 'Especialidad 2', 'Especialidad 3']; // Reemplaza con tus especialidades
  List<String> genero = ['Seleccionar', 'Masculino', 'Femenino', 'Sin especificar'];

  Future<void> _registrarPsicologo() async {
    try {
      // Validar que los campos no estén vacíos
      // Puedes agregar más validaciones según tus necesidades

      Map<String, dynamic> psicologoData = {
        'id_especialidad': especialidades.indexOf(_selectedEspecialidad) + 1, // Sumar 1 porque los índices en la base de datos comienzan desde 1
        'dni': dniController.text,
        'nombres': nombresController.text,
        'apellidos': apellidosController.text,
        'genero': _selectedGenero,
        'telefono': telefonoController.text,
        'nacimiento': nacimientoController.text,
        'correo': emailController.text,
        'nacionalidad': nacionalidadController.text,
      };

      // Llamar al servicio de registro de psicólogo
      final value = await PsicologoService().registrarPsicologo(psicologoData);

      // Verificar si el registro fue exitoso
      if (!(value['success'] ?? false)) {
        throw ('Error al registrar psicólogo: ${value['message']}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de psicólogo',
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
                value: _selectedEspecialidad,
                onChanged: (value) {
                  setState(() {
                    _selectedEspecialidad = value.toString();
                  });
                },
                items: especialidades.map((especialidad) {
                  return DropdownMenuItem(
                    value: especialidad,
                    child: Text(especialidad),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Especialidad',
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
                controller: nacimientoController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  icon: Icon(Icons.calendar_today, color: Colors.purple),
                ),
              ),
              TextField(
                controller: nacionalidadController,
                decoration: InputDecoration(
                  labelText: 'Nacionalidad',
                  icon: Icon(Icons.location_on, color: Colors.purple),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarPsicologo,
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
