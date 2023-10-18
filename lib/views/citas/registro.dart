// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de cita',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Nuevo color
      ),
      home: CitasPage(),
    );
  }
}

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  // Variables para almacenar los datos de la cita
  Pacientes? paciente;
  Psicologo? psicologo;
  int especialidad = 1;
  DateTime fechaCita = DateTime.now();
  TimeOfDay horaCita = TimeOfDay.now();
  String? estadoCita;
  int created = 1;
  final telController = TextEditingController();
  final dirController = TextEditingController();
  final desController = TextEditingController();

  // Listas para las opciones de psicólogos y estados de la cita
  List<Psicologo>? psicologos;
  List<String> estadosCita = ['Pendiente', 'Cancelado'];
  List<Pacientes>? pacientes; //esperar a que se inicialice
  @override
  void initState() {
    estadoCita = estadosCita[0];
    // Petición para traer los datos de los pacientes uwu
    PacienteService().obtenerDatos().then((value) {
      pacientes = value;
      paciente = value.first;
      telController.text = value.first.telfono ?? '';
      dirController.text = value.first.direccion ?? '';
      setState(() {});
    }); //
    PsicologoService().obtenerPsicologos().then((value) {
      psicologos = value;
      psicologo = value.first;
      setState(() {});
    }); //
    super.initState();
  }

  // Función para guardar la cita
  void guardarCita() async {
    //try {
    Map<String, dynamic> citaData = {
      'paciente': paciente?.id,
      'descripcion': desController.text,
      'especialidad': especialidad,
      'psicologo': psicologo?.id,
      'fechaCita': fechaCita.toString(),
      'horaCita': horaCita.format(context),
      'estadoCita': estadoCita,
      'created': created,
    };
    CitasService().programarCita(citaData);
    // Mostrar un mensaje de éxito al usuario, por ejemplo, usando un SnackBar o un diálogo.
  } //catch (e) {
  // Manejar y mostrar errores al usuario, por ejemplo, usando un SnackBar o un diálogo.
  //print(e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple, // Nuevo color de fondo
        title: const Text('Programar cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (pacientes != null)
                DropdownButtonFormField<Pacientes?>(
                  value: paciente,
                  items: pacientes!.map((p) {
                    return DropdownMenuItem<Pacientes?>(
                      value: p,
                      child: Text('${p.nombre}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      paciente = value;
                      telController.text = value?.telfono ?? '';
                      dirController.text = value?.direccion ?? '';
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Paciente',
                  ),
                ),
              if (psicologos != null)
                DropdownButtonFormField(
                  value: psicologo,
                  items: psicologos?.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text('${p.nombres} ${p.apellidos}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      psicologo = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Psicólogo',
                  ),
                ),
              if (paciente != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Información de la cita:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  enabled: false,
                  controller: dirController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    prefixIcon:
                        Icon(Icons.person, color: Colors.purple), // Nuevo ícono
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  enabled: false,
                  controller: telController,
                  decoration: const InputDecoration(
                    labelText: 'Número de teléfono',
                    prefixIcon:
                        Icon(Icons.phone, color: Colors.purple), // Nuevo ícono
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: desController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon:
                        Icon(Icons.person, color: Colors.purple), // Nuevo ícono
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Fecha de la cita:'),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final fechaSeleccionada = await showDatePicker(
                      context: context,
                      initialDate: fechaCita,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (fechaSeleccionada != null &&
                        fechaSeleccionada != fechaCita) {
                      setState(() {
                        fechaCita = fechaSeleccionada;
                      });
                    }
                  },
                  child: Text(
                    "${fechaCita.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final horaSeleccionada = await showTimePicker(
                      context: context,
                      initialTime: horaCita,
                    );
                    if (horaSeleccionada != null &&
                        horaSeleccionada != horaCita) {
                      setState(() {
                        horaCita = horaSeleccionada;
                      });
                    }
                  },
                  child: Text(
                    horaCita.format(context),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                DropdownButtonFormField(
                  value: estadoCita,
                  items: estadosCita.map((String estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Text(estado),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      estadoCita = value.toString();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Estado de la Cita',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    guardarCita();
                  },
                  child: const Text('Guardar cita'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
