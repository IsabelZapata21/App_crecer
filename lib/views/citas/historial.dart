import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/cita.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/psicologos_service.dart';
import 'package:intl/intl.dart';

class HistorialCitas extends StatefulWidget {
  @override
  _HistorialCitasState createState() => _HistorialCitasState();
}

class _HistorialCitasState extends State<HistorialCitas> {
  String _filtroSeleccionado = 'Todas'; // Por defecto, muestra todas las citas
  List<Psicologo>? psicologos;
  List<Pacientes>? pacientes;
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    psicologos = await PsicologoService().obtenerPsicologos();
    pacientes = await PacienteService().obtenerDatos();
    setState(() {}); // Refrescar el widget después de cargar los datos.
  }

  String obtenerNombrePacientePorId(String? idPaciente) {
    if (idPaciente == null) return 'Desconocido';
    final paciente = pacientes?.firstWhere((p) => p.id == idPaciente);
    return paciente?.nombre ?? 'Desconocido';
  }

  String obtenerNombrePsicologoPorId(String? idPsicologo) {
    if (idPsicologo == null) return 'Desconocido';
    final psicologo = psicologos?.firstWhere((p) => p.id == idPsicologo);
    return psicologo?.nombres ?? 'Desconocido';
  }

  String obtenerNombreEspecialidadPorId(String? idPsicologo) {
    if (idPsicologo == null) return 'Desconocido';
    final psicologo = psicologos?.firstWhere((p) => p.id == idPsicologo);
    return psicologo?.especialidad ?? 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Historial de citas'),
        actions: <Widget>[
          _buildFiltroDropdown(),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'cerrar_sesion') {
                // Agregar aquí la lógica para cerrar sesión
              } else if (value == 'acerca_de') {
                // Agregar aquí la lógica para mostrar la pantalla "Acerca de"
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'cerrar_sesion',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('Cerrar Sesión'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'acerca_de',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('Acerca de'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Citas>>(
        future: CitasService().obtenerListaCitas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay citas disponibles.'),
            );
          } else {
            final List<Citas> citas = snapshot.data!
                .where((cita) =>
                    _filtroSeleccionado == 'Todas' ||
                    cita.estado == _filtroSeleccionado)
                .toList();
            return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                final cita = citas[index];
                return GestureDetector(
                  onTap: () => _mostrarDetallesCita(cita),
                  child: _buildCitaItem(
                    fecha:
                        'Fecha: ${cita.fechaCita != null ? DateFormat('EEEE, d MMMM y', 'es').format(cita.fechaCita!.toLocal()) : 'Fecha no disponible'}',
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
    );
  }

  void _mostrarDetallesCita(Citas cita) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles de la cita',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(
                    'Fecha: ${cita.fechaCita != null ? DateFormat('EEEE, d MMMM y', 'es').format(cita.fechaCita!.toLocal()) : 'Fecha no disponible'}',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text('Hora: ${cita.horaCita}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.note, color: Colors.purple),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text('Descripción: ${cita.descripcion ?? ''}')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(
                      'Paciente: ${obtenerNombrePacientePorId(cita.idPaciente)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(
                      'Psicólogo: ${obtenerNombrePsicologoPorId(cita.idPsicologo)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.medical_services, color: Colors.purple),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                        'Especialidad: ${obtenerNombreEspecialidadPorId(cita.idPsicologo)}'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event_note, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text('Estado: ${cita.estado}'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Editar'),
              onPressed: () {
                _editarCita(cita); // Cierra el AlertDialog después de editar.
              },
            ),
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCitaItem(
      {required String fecha,
      required String hora,
      required String descripcion,
      required bool isPast}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: isPast ? Colors.grey : Colors.purple,
          child: const Icon(Icons.calendar_today, color: Colors.white, size: 30),
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

  Widget _buildFiltroDropdown() {
    return DropdownButton<String>(
      value: _filtroSeleccionado,
      onChanged: (String? newValue) {
        setState(() {
          _filtroSeleccionado = newValue!;
        });
      },
      items: <String>['Todas', 'Confirmada', 'Pendiente', 'Cancelado']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
    );
  }

  void _editarCita(Citas cita) {
    String nuevoEstado = cita.estado ?? 'Pendiente'; // Estado por defecto

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  title: const Text('Editar estado de la cita'),
                  content: DropdownButton<String>(
                    value: nuevoEstado,
                    onChanged: (String? newValue) {
                      setState(() {
                        nuevoEstado = newValue!;
                      });
                    },
                    items: <String>['Confirmada', 'Pendiente', 'Cancelado']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Guardar'),
                      onPressed: () async {
                        try {
                          await CitasService()
                              .actualizarEstadoCita(cita.id!, nuevoEstado);
                          Navigator.of(context)
                              .pop(); // Cierra el AlertDialog de edición
                          Navigator.of(context)
                              .pop(); // Cierra el AlertDialog de detalles
                          _cargarDatos();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cambio guardado correctamente'),
                            ),
                          ); // Refresca los datos
                        } catch (e) {
                          // Mostrar un mensaje de error al usuario
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Error al actualizar el estado: $e'),
                            ),
                          );
                        }
                      },
                    ),
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )));
      },
    );
  }
}
