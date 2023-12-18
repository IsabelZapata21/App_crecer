import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class RegistroPacienteScreen extends StatefulWidget {
  @override
  _RegistroPacienteScreenState createState() => _RegistroPacienteScreenState();
}

class _RegistroPacienteScreenState extends State<RegistroPacienteScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  Future<void> _registrarPaciente() async {
    try {
      // Validar que los campos no estén vacíos
      if (nombreController.text.isEmpty) {
        throw ('Falta ingresar el nombre del paciente');
      } else if (direccionController.text.isEmpty) {
        throw ('Falta ingresar la dirección del paciente');
      } else if (telefonoController.text.isEmpty) {
        throw ('Falta ingresar el teléfono del paciente');
      } else if (telefonoController.text.length != 9) {
        throw ('El número de teléfono debe tener 9 dígitos');
      }

      Map<String, dynamic> pacienteData = {
        'nombre': nombreController.text,
        'direccion': direccionController.text,
        'telefono': telefonoController.text,
      };

      // Llamar al servicio de registro de paciente
      final value = await PacienteService().registrarPaciente(pacienteData);

      // Verificar si el registro fue exitoso
      if (!(value['success'] ?? false)) {
        throw ('Error al registrar paciente: ${value['message']}');
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
          'Registro de paciente',
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
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del paciente',
                  icon: Icon(Icons.person, color: Colors.purple),
                ),
              ),
              TextField(
                controller: direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección del paciente',
                  icon: Icon(Icons.location_on, color: Colors.purple),
                ),
              ),
              TextField(
                controller: telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono del paciente',
                  icon: Icon(Icons.phone, color: Colors.purple),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarPaciente,
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Registrar Paciente',
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
