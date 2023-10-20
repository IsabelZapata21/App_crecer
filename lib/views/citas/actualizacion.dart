import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';
import 'package:flutter_application_2/viewmodels/citas/registro_viewmodel.dart';

class ActualizarCita extends StatefulWidget {
  @override
  _ActualizarCitaState createState() => _ActualizarCitaState();
}

class _ActualizarCitaState extends State<ActualizarCita> {
  String? searchTerm; // Variable para almacenar el término de búsqueda
  String? selectedPsychologist; // Variable para almacenar el psicólogo seleccionado
  String? selectedStatus; // Variable para almacenar el estado de la cita seleccionado

  // Listas de opciones para psicólogos y estados de cita (debes cargarlas desde tus servicios)
  List<String> psychologists = ['Psicólogo 1', 'Psicólogo 2', 'Psicólogo 3'];
  List<String> statuses = ['Pendiente', 'Cancelado', 'Completado'];
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

  // Listado de citas (debes cargarlo desde tus servicios)
  List<Psicologo>? psicologos;
  List<String> estadosCita = ['Pendiente', 'Cancelado'];
  List<Pacientes>? pacientes;

  Cita? selectedCita; // Cita seleccionada para modificar

  // Función para buscar la cita por paciente
  void searchCitaByPaciente() {
    // Aquí debes implementar la lógica para buscar las citas por paciente
    // utilizando el valor de `searchTerm` y cargarlas en la lista `citas`.
  }

  // Función para guardar la cita actualizada
  void guardarCitaActualizada() {
    // Aquí debes implementar la lógica para guardar la cita actualizada,
    // incluyendo el psicólogo y el estado de la cita seleccionados.
    // Puedes enviar una solicitud a tu servicio para actualizar la cita en la base de datos.
    // Después de guardar con éxito, muestra un diálogo de éxito y restablece los campos.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Cita'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  onChanged: (value) {
                    searchTerm = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Buscar Cita por Paciente',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    searchCitaByPaciente();
                  },
                  child: Text('Buscar'),
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              //itemCount: citas.length,
              itemBuilder: (context, index) {
                return ListTile(
               //   title: Text(citas[index].descripcion),
                 //subtitle: Text('Paciente: ${citas[index].paciente}'),
                  onTap: () {
                    setState(() {
                    //  selectedCita = citas[index];
                     // selectedPsychologist = selectedCita?.psicologo;
                      selectedStatus = selectedCita?.estado;
                    });
                  },
                );
              },
            ),
          ),
          if (selectedCita != null) ...[
            Divider(height: 1, color: Colors.black),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Información de la Cita:'),
                  Text('Descripción: ${selectedCita?.descripcion}'),
                  Text('Paciente: ${selectedCita?.paciente}'),
                  Text('Fecha: ${selectedCita?.fecha}'),
                  Text('Hora: ${selectedCita?.hora}'),
                  DropdownButtonFormField<String>(
                    value: selectedPsychologist,
                    items: psychologists.map((psychologist) {
                      return DropdownMenuItem<String>(
                        value: psychologist,
                        child: Text(psychologist),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPsychologist = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Psicólogo',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.purple),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: statuses.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Estado de la Cita',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.purple),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      guardarCitaActualizada();
                    },
                    child: Text('Guardar Cita Actualizada'),
                    style: ElevatedButton.styleFrom(primary: Colors.purple),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class Cita {
  final String id;
  final String descripcion;
  final String paciente;
  final String fecha;
  final String hora;
  final String estado;

  Cita({
    required this.id,
    required this.descripcion,
    required this.paciente,
    required this.fecha,
    required this.hora,
    required this.estado,
  });
}
