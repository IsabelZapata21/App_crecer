import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/especialidad.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';

class RegistroPsicologoScreen extends StatefulWidget {
  @override
  _RegistroPsicologoScreenState createState() =>
      _RegistroPsicologoScreenState();
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

  //Especialidad? especialidad;
  List<String> especialidades = [
    'Psicología clínica',
    'Psicología infantil',
    'Psicología organizacional',
    'Psicología educativa',
    'Psicología social'
  ];

  List<String> genero = [
    'Seleccionar',
    'Masculino',
    'Femenino',
    'Sin especificar'
  ];

  Future<void> _registrarPsicologo() async {
    try {
      // Validar que los campos no estén vacíos
      // Puedes agregar más validaciones según tus necesidades
      if (_selectedEspecialidad == 'Seleccionar' ||
          nombresController.text.isEmpty ||
          apellidosController.text.isEmpty ||
          telefonoController.text.isEmpty ||
          dniController.text.isEmpty ||
          _selectedGenero == 'Seleccionar' ||
          emailController.text.isEmpty ||
          nacimientoController.text.isEmpty ||
          nacionalidadController.text.isEmpty) {
        throw ('Todos los campos son obligatorios');
      }

      Map<String, dynamic> psicologoData = {
        'id_especialidad': especialidades.indexOf(_selectedEspecialidad), // Ajusta el campo según tus necesidades
        'dni': dniController.text,
        'nombres': nombresController.text,
        'apellidos': apellidosController.text,
        'genero': _selectedGenero,
        'telefono': telefonoController.text,
        'nacimiento': nacimientoController.text,
        'correo': emailController.text,
        'nacionalidad': nacionalidadController.text,
      };
      print(psicologoData);
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
            title: const Text('Error de registro'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
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
              DropdownButtonFormField<String>(
                value: _selectedEspecialidad,
                onChanged: (value) {
                  setState(() {
                    _selectedEspecialidad = value!;
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: 'Seleccionar',
                    child: Text('Seleccionar'),
                  ),
                  ...especialidades.map((p) {
                    return DropdownMenuItem<String>(
                      value: p,
                      child: Text(p),
                    );
                  }).toList(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Especialidad',
                  icon: Icon(Icons.remember_me_outlined, color: Colors.purple),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nombresController,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  icon: Icon(Icons.person, color: Colors.purple),
                ),
              ),
              // Resto del código sin cambios...
              const SizedBox(height: 20),
              TextField(
                controller: apellidosController,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  icon: Icon(Icons.person, color: Colors.purple),
                ),
              ),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  icon: Icon(Icons.phone, color: Colors.purple),
                ),
              ),
              const SizedBox(height: 10),
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
                decoration: const InputDecoration(
                  labelText: 'Género',
                  icon: Icon(Icons.remember_me_outlined, color: Colors.purple),
                ),
                isExpanded:
                    true, // Asegura que el desplegable ocupe el ancho completo
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dniController,
                decoration: const InputDecoration(
                  labelText: 'DNI',
                  icon: Icon(Icons.credit_card, color: Colors.purple),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email, color: Colors.purple),
                ),
              ),
              TextField(
                controller: nacimientoController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  icon: Icon(Icons.calendar_today, color: Colors.purple),
                ),
              ),
              TextField(
                controller: nacionalidadController,
                decoration: const InputDecoration(
                  labelText: 'Nacionalidad',
                  icon: Icon(Icons.location_on, color: Colors.purple),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarPsicologo,
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
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
