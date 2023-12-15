import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';
import 'package:flutter_application_2/viewmodels/citas/registro_viewmodel.dart';
import 'package:flutter_application_2/views/citas/widgets/time_range_picker.dart';
import 'package:intl/intl.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return const CitasPage();
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
  DateTime fechaCita = DateTime.now();
  TimeOfDay horaCita = TimeOfDay.now();
  TimeOfDay finCita = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
  String? estadoCita;
  int created = 1;

  bool get isValuesSelected => paciente != null && psicologo != null;

  final telController = TextEditingController();
  final dirController = TextEditingController();
  final desController = TextEditingController();
  final espController = TextEditingController();
  //instancia del viewmodel
  final viewModel = RegistroValidate();

  // Listas para las opciones de psicólogos y estados de la cita
  List<Psicologo>? psicologos;
  List<CitaDuration> citas = [];
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
    String? error = viewModel.validarCampos(
        paciente, psicologo, desController.text, estadoCita);
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
      'especialidad': 1,
      'psicologo': psicologo?.id,
      'fechaCita': fechaCita.toString(),
      'horaCita': horaCita.format(context),
      'finCita': finCita.format(context),
      'estadoCita': estadoCita,
      'created': created,
    };
    print(citaData);
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
      fechaCita = DateTime.now();
      horaCita = TimeOfDay.now();
      finCita = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
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
                  ...pacientes?.map((p) {
                        return DropdownMenuItem<Pacientes?>(
                          value: p,
                          child: Text('${p.nombre}'),
                        );
                      }).toList() ??
                      [],
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
                onChanged: (value) async {
                  psicologo = value;
                  final id = int.tryParse(psicologo?.id ?? '0');
                  final fecha = DateFormat('y-M-d').format(fechaCita.toLocal());
                  final citas =
                      await PsicologoService().obtenerDisponibilidad(id, fecha);
                  this.citas = citas;
                  if (citas.isNotEmpty) {
                    final endTime =
                        DateTime.tryParse('0000-00-00 ${citas.last.finCita}');
                    if (endTime != null) {
                      final newTime = TimeOfDay.fromDateTime(endTime);
                      horaCita = newTime;
                      finCita = newTime.minute < 55
                          ? newTime.replacing(minute: 59)
                          : newTime.replacing(hour: newTime.hour + 1);
                    }
                  }
                  setState(() {
                    espController.text = value?.especialidad ?? '';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Psicólogo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: espController,
                enabled: false, // Deshabilita la edición
                decoration: InputDecoration(
                  labelText: 'Especialidad',
                  prefixIcon: Icon(Icons.phone, color: Colors.purple),
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
                enabled: isValuesSelected,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.note, color: Colors.purple),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isValuesSelected
                    ? () async {
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
                      }
                    : null,
                child: Text(
                  DateFormat('EEEE, d MMMM y', 'es')
                      .format(fechaCita.toLocal()),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: isValuesSelected
                    ? () async {
                        final disabledTime = <TimeRange>[];
                        for (var element in citas) {
                          final startTime = DateTime.tryParse(
                              '0000-00-00 ${element.horaCita}');
                          final endTime = DateTime.tryParse(
                              '0000-00-00 ${element.finCita}');
                          if (startTime == null || endTime == null) continue;
                          disabledTime.add(TimeRange(
                              startTime: TimeOfDay.fromDateTime(startTime),
                              endTime: TimeOfDay.fromDateTime(endTime)));
                        }
                        final horaSeleccionada = await showTimeRangePicker(
                            context: context,
                            maxDuration: const Duration(hours: 2),
                            minDuration: const Duration(hours: 1),
                            autoAdjustLabels: true,
                            paintingStyle: PaintingStyle.stroke,
                            labels: [
                              "12 am",
                              "3 am",
                              "6 am",
                              "9 am",
                              "12 pm",
                              "3 pm",
                              "6 pm",
                              "9 pm"
                            ].asMap().entries.map((e) {
                              return ClockLabel.fromIndex(
                                  idx: e.key, length: 8, text: e.value);
                            }).toList(),
                            labelOffset: -30,
                            start: disabledTime.isNotEmpty
                                ? disabledTime.last.endTime
                                : horaCita,
                            end: finCita,
                            disabledTime: disabledTime);
                        if (horaSeleccionada != null) {
                          setState(() {
                            horaCita = horaSeleccionada.startTime;
                            finCita = horaSeleccionada.endTime;
                          });
                        }
                      }
                    : null,
                child: Text(
                  '${horaCita.format(context)} - ${finCita.format(context)}',
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
                onChanged: isValuesSelected
                    ? (value) {
                        setState(() {
                          estadoCita = value.toString();
                        });
                      }
                    : null,
                decoration: InputDecoration(
                  labelText: 'Estado de la Cita',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isValuesSelected
                    ? () async {
                        guardarCita();
                      }
                    : null,
                child: const Text('Guardar cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
