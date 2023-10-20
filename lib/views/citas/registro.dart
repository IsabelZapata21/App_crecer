import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';
import 'package:flutter_application_2/viewmodels/citas/registro_viewmodel.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de cita',
      theme: ThemeData(
        primarySwatch: Colors.purple,
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
  //instancia del viewmodel
  final viewModel = RegistroValidate();

  // Listas para las opciones de psicólogos y estados de la cita
  List<Psicologo>? psicologos;
  List<String> estadosCita = ['Pendiente', 'Cancelado'];
  List<Pacientes>? pacientes;

  @override
  void initState() {
    estadoCita = estadosCita[0];
    PacienteService().obtenerDatos().then((value) {
      pacientes = value;
      setState(() {});
    });
    PsicologoService().obtenerPsicologos().then((value) {
      psicologos = value;
      setState(() {});
    });
    super.initState();
  }

void guardarCita() async {
  String? error = viewModel.validarCampos(paciente, psicologo, desController.text, estadoCita);
  if (error != null) {
    // Mostrar el error en un showDialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            child: Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
    return;
  }

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

  try {
    String mensaje = await CitasService().programarCita(citaData);
    // Si se guardó con éxito, muestra un dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Éxito'),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              // Limpia los campos y reinicia el estado
              _resetForm();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  } catch (e) {
    // Aquí puedes manejar el caso en el que no se pudo guardar la cita
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            child: Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

void _resetForm() {
  setState(() {
    paciente = null;
    psicologo = null;
    especialidad = 1;
    fechaCita = DateTime.now();
    horaCita = TimeOfDay.now();
    estadoCita = estadosCita[0];
    telController.clear();
    dirController.clear();
    desController.clear();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Programar cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButtonFormField<Pacientes?>(
                value: paciente,
                items: [
                  DropdownMenuItem<Pacientes?>(
                    value: null,
                    child: Text('Seleccionar'),
                  ),
                  ...pacientes!.map((p) {
                    return DropdownMenuItem<Pacientes?>(
                      value: p,
                      child: Text('${p.nombre}'),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    paciente = value;
                    telController.text = value?.telfono ?? '';
                    dirController.text = value?.direccion ?? '';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Paciente',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: psicologo,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Seleccionar'),
                  ),
                  ...?psicologos?.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text('${p.nombres} ${p.apellidos}'),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    psicologo = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Psicólogo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dirController,
                enabled: false, // Deshabilita la edición
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.person, color: Colors.purple),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telController,
                enabled: false, // Deshabilita la edición
                decoration: InputDecoration(
                  labelText: 'Número de teléfono',
                  prefixIcon: Icon(Icons.phone, color: Colors.purple),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: desController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.note, color: Colors.purple),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
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
                decoration: InputDecoration(
                  labelText: 'Estado de la Cita',
                  border: OutlineInputBorder(),
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
          ),
        ),
      ),
    );
  }
}