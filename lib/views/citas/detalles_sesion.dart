import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/cita.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';
import 'package:flutter_application_2/services/citas/sesion_service.dart';

class DetallesSesion extends StatefulWidget {
  // final int idCita;

  // DetallesSesion({Key? key, required this.idCita}) : super(key: key);

  @override
  _DetallesSesionState createState() => _DetallesSesionState();
}

class _DetallesSesionState extends State<DetallesSesion> {
  //variables
  String _terminoBusqueda = ''; // Término de búsqueda
  List<Psicologo>? psicologos;
  List<Pacientes>? pacientes;

  void _guardarSesion(
      BuildContext context, Map<String, dynamic> sesionData) async {
    try {
      SesionService sessionService = SesionService();
      String resultado = await sessionService.guardarSesion(sesionData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guardado exitosamente: $resultado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Historial de citas'),
        actions: <Widget>[],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _terminoBusqueda = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar cita',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Citas>>(
              future: CitasService().obtenerListaCitas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No hay citas disponibles.'),
                  );
                } else {
                  final List<Citas> citas = snapshot.data!
                      .where((cita) =>
                          cita.descripcion?.contains(_terminoBusqueda) ?? false)
                      .toList();
                  return ListView.builder(
                    itemCount: citas.length,
                    itemBuilder: (context, index) {
                      final cita = citas[index];
                      return GestureDetector(
                        onTap: () => agregarNotaClinica(cita),
                        child: _buildCitaItem(
                          fecha:
                              'Fecha: ${cita.fechaCita?.toLocal().toString().split(' ')[0]}',
                          hora: 'Hora: ${cita.horaCita}',
                          descripcion: cita.descripcion ?? '',
                          isPast: false,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitaItem(
      {required String fecha,
      required String hora,
      required String descripcion,
      required bool isPast}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: isPast ? Colors.grey : Colors.purple,
          child: Icon(Icons.calendar_today, color: Colors.white, size: 30),
          radius: 30,
        ),
        title: Text(
          fecha,
          style: TextStyle(
            fontSize: 18,
            color: isPast ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(hora + '\n' + descripcion),
      ),
    );
  }

  void agregarNotaClinica(Citas cita) {
    // Variables para guardar la información
    Citas? citas;
    final TextEditingController _duracionController = TextEditingController();
    final TextEditingController _inicioController = TextEditingController();
    final TextEditingController _desarrolloController = TextEditingController();
    final TextEditingController _analisisController = TextEditingController();
    final TextEditingController _observacionesController =
        TextEditingController();
    TimeOfDay? horaInicio;
    TimeOfDay? horaFin;
    void dispose() {
      // Asegúrate de llamar a dispose en los controladores de texto
      _duracionController.dispose();
      _inicioController.dispose();
      _desarrolloController.dispose();
      _analisisController.dispose();
      _observacionesController.dispose();
      super.dispose();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Nota Clínica',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                    title: Text(
                        'Hora de inicio: ${horaInicio?.format(context) ?? 'No seleccionado'}'),
                    trailing: Icon(Icons.edit),
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode
                            .input, // Añadido para mostrar AM/PM
                      );
                      if (selectedTime != null) {
                        setState(() {
                          horaInicio = selectedTime;
                        });
                      }
                    },
                  ),
                  // Hora de fin
                  ListTile(
                    title: Text(
                        'Hora de fin: ${horaFin?.format(context) ?? 'No seleccionado'}'),
                    trailing: Icon(Icons.edit),
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode
                            .input, // Añadido para mostrar AM/PM
                      );
                      if (selectedTime != null) {
                        setState(() {
                          horaFin = selectedTime;
                        });
                      }
                    },
                  ),
                    // Duración
                    TextField(
                      controller: _duracionController,
                      decoration: InputDecoration(labelText: 'Duración'),
                    ),
                    // Inicio
                    TextField(
                      controller: _inicioController,
                      decoration: InputDecoration(labelText: 'Inicio'),
                    ),
                    // Desarrollo
                    TextField(
                      controller: _desarrolloController,
                      decoration: InputDecoration(labelText: 'Desarrollo'),
                    ),
                    // Análisis
                    TextField(
                      controller: _analisisController,
                      decoration: InputDecoration(labelText: 'Análisis'),
                    ),
                    // Observaciones
                    TextField(
                      controller: _observacionesController,
                      decoration: InputDecoration(labelText: 'Observaciones'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Generar nota clínica'),
                  onPressed: () {
                    if (_duracionController.text.isNotEmpty &&
                        _inicioController.text.isNotEmpty &&
                        _desarrolloController.text.isNotEmpty &&
                        _analisisController.text.isNotEmpty &&
                        _observacionesController.text.isNotEmpty &&
                        horaInicio != null &&
                        horaFin != null) {
                      // Aquí se recopilan los datos y se llama a _guardarSesion
                      final sesionData = {
                        'id_cita': cita.id,
                        'hora_inicio': horaInicio?.format(context),
                        'hora_fin': horaFin?.format(context),
                        'duracion': _duracionController.text,
                        'inicio': _inicioController.text,
                        'desarrollo': _desarrolloController.text,
                        'analisis': _analisisController.text,
                        'observaciones': _observacionesController.text,
                      };
                      _guardarSesion(
                          context, sesionData); // Pasamos el context aquí
                      Navigator.of(context).pop();
                    } else {
                      // Muestra un mensaje de error si los campos no están llenos
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Por favor, complete todos los campos')),
                      );
                    }
                  },
                ),
                TextButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
