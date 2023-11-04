import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_2/services/cronograma/actividades_service.dart';
import 'package:flutter_application_2/models/cronograma/actividades.dart';
import 'package:intl/intl.dart';

class CronogramaScreen extends StatefulWidget {
  @override
  _CronogramaScreenState createState() => _CronogramaScreenState();
}

class _CronogramaScreenState extends State<CronogramaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //variables
  Actividades? actividades;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime fechaInicio = DateTime.now();
  DateTime fechaFin = DateTime.now();
  String? estadoActividad;
  List<String> estadosActividad = ['Pendiente', 'Realizada', 'Cancelada'];

  void _guardarActividades(Actividades actividad) async {
    print('actData ${actividad.toJson()}');
    try {
      String mensaje = await ActividadesService().guardarActividades(actividad.toJson());
      // Si se guardó con éxito, muestra un dialog
      print(mensaje);
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
    setState(() {});
  }

  void _actualizarActividades(Actividades actividad) async {
    Map<String, dynamic> actData = {
      'id_act': actividad.idAct,
      'nombre': actividad.nombre,
      'descripcion': actividad.descripcion,
      'fechaInicio': actividad.fechaInicio.toString(),
      'fechaFin': actividad.fechaFin.toString(),
      'horaInicio': actividad.horaInicio.toString(),
      'horaFin': actividad.horaFin.toString(),
      'responsable': 1,
      'estado': actividad.estado
    };
    print('actData $actData');
    try {
      String mensaje =
          await ActividadesService().actualizarActividades(actData);
      // Si se guardó con éxito, muestra un dialog
      print(mensaje);
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
    setState(() {});
  }

  void _eliminarActividades(Actividades actividad) async {
    if (actividad.idAct == null) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Actividad no seleccionada'),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
    try {
      String mensaje =
          await ActividadesService().eliminarActividades(id: actividad.idAct);
      // Si se guardó con éxito, muestra un dialog
      print(mensaje);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
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
    setState(() {});
  }

  void _mostrarFormulario() {
    final _tituloController = TextEditingController(text: '');
    final _descripcionController = TextEditingController(text: '');
    final _responsableController = TextEditingController(text: '');
    DateTime _fechaInicio = DateTime.now();
    DateTime _fechaFin = DateTime.now();
    TimeOfDay _horaInicio = TimeOfDay.fromDateTime(_fechaInicio);
    TimeOfDay _horaFin = TimeOfDay.fromDateTime(_fechaFin);
    String _estado = 'P'; // Valor predeterminado

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: Text('Añadir Actividad'),
              content: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: _descripcionController,
                      decoration: InputDecoration(labelText: 'Descripción'),
                    ),
                    TextField(
                      controller: _responsableController,
                      decoration: InputDecoration(labelText: 'Responsable'),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _estado,
                      items: ['P', 'R', 'C'].map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado == 'P'
                              ? 'Pendiente'
                              : estado == 'C'
                                  ? 'Cancelado'
                                  : 'Reportado'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null)
                          setState(() {
                            _estado = value;
                          });
                      },
                      decoration: InputDecoration(
                        labelText: 'Estado de la Actividad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ListTile(
                      title: Text(
                          "Fecha de inicio: ${DateFormat('dd-MM-yy').format(_fechaInicio)}"),
                      trailing:
                          Icon(Icons.calendar_today, color: Colors.purple),
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: _fechaInicio,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (fechaSeleccionada != null &&
                            fechaSeleccionada != _fechaInicio) {
                          setState(() {
                            _fechaInicio = DateTime(
                              fechaSeleccionada.year,
                              fechaSeleccionada.month,
                              fechaSeleccionada.day,
                              _horaInicio.hour,
                              _horaInicio.minute,
                            );
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                          "Hora de inicio: ${_horaInicio.format(context)}"),
                      trailing: Icon(Icons.access_time, color: Colors.purple),
                      onTap: () async {
                        TimeOfDay? horaSeleccionada = await showTimePicker(
                          context: context,
                          initialTime: _horaInicio,
                        );
                        if (horaSeleccionada != null &&
                            horaSeleccionada != _horaInicio) {
                          setState(() {
                            _horaInicio = horaSeleccionada;
                            _fechaInicio = DateTime(
                              _fechaInicio.year,
                              _fechaInicio.month,
                              _fechaInicio.day,
                              _horaInicio.hour,
                              _horaInicio.minute,
                            );
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                          "Fecha de fin: ${DateFormat('dd-MM-yy').format(_fechaFin)}"),
                      trailing:
                          Icon(Icons.calendar_today, color: Colors.purple),
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: _fechaFin,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (fechaSeleccionada != null &&
                            fechaSeleccionada != _fechaFin) {
                          setState(() {
                            _fechaFin = DateTime(
                              fechaSeleccionada.year,
                              fechaSeleccionada.month,
                              fechaSeleccionada.day,
                              _horaFin.hour,
                              _horaFin.minute,
                            );
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text("Hora de fin: ${_horaFin.format(context)}"),
                      trailing: Icon(Icons.access_time, color: Colors.purple),
                      onTap: () async {
                        TimeOfDay? horaSeleccionada = await showTimePicker(
                          context: context,
                          initialTime: _horaFin,
                        );
                        if (horaSeleccionada != null &&
                            horaSeleccionada != _horaFin) {
                          setState(() {
                            _horaFin = horaSeleccionada;
                            _fechaFin = DateTime(
                              _fechaFin.year,
                              _fechaFin.month,
                              _fechaFin.day,
                              _horaFin.hour,
                              _horaFin.minute,
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Guardar'),
                  onPressed: () {
                    _fechaInicio = DateTime(
                      _fechaInicio.year,
                      _fechaInicio.month,
                      _fechaInicio.day,
                      _horaInicio.hour,
                      _horaInicio.minute,
                    );
                    _fechaFin = DateTime(
                      _fechaFin.year,
                      _fechaFin.month,
                      _fechaFin.day,
                      _horaFin.hour,
                      _horaFin.minute,
                    );
                    final nuevaActividad = Actividades(
                      idAct: 0,
                      nombre: _tituloController.text,
                      descripcion: _descripcionController.text,
                      fechaInicio: _fechaInicio,
                      fechaFin: _fechaFin,
                      responsable: _responsableController.text,
                      idResponsable: 1,
                      estado: _estado,
                      horaInicio: _fechaInicio.toString(),
                      horaFin: _fechaFin.toString(),
                    );

                    _guardarActividades(nuevaActividad);
                    setState(() {});

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

  void _actualizarFormulario({required Actividades actividad}) {
    final _tituloController =
        TextEditingController(text: actividad.nombre ?? '');
    final _descripcionController =
        TextEditingController(text: actividad.descripcion ?? '');
    final _responsableController =
        TextEditingController(text: actividad.responsable ?? '');
    DateTime _fechaInicio = actividad.fechaInicio ?? DateTime.now();
    DateTime _fechaFin = actividad.fechaFin ?? DateTime.now();
    TimeOfDay _horaInicio = TimeOfDay.fromDateTime(_fechaInicio);
    TimeOfDay _horaFin = TimeOfDay.fromDateTime(_fechaFin);
    String _estado = actividad.estado ?? 'P'; // Valor predeterminado

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: const Text('Editar Actividad'),
              content: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: _descripcionController,
                      decoration: InputDecoration(labelText: 'Descripción'),
                    ),
                    TextField(
                      controller: _responsableController,
                      decoration: InputDecoration(labelText: 'Responsable'),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _estado,
                      items: ['P', 'R', 'C'].map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado == 'P'
                              ? 'Pendiente'
                              : estado == 'C'
                                  ? 'Cancelado'
                                  : 'Reportado'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null)
                          setState(() {
                            _estado = value;
                          });
                      },
                      decoration: InputDecoration(
                        labelText: 'Estado de la Actividad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ListTile(
                      title: Text(
                          "Fecha de inicio: ${DateFormat('dd-MM-yy').format(_fechaInicio)}"),
                      trailing:
                          Icon(Icons.calendar_today, color: Colors.purple),
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: _fechaInicio,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (fechaSeleccionada != null &&
                            fechaSeleccionada != _fechaInicio) {
                          setState(() {
                            _fechaInicio = DateTime(
                              fechaSeleccionada.year,
                              fechaSeleccionada.month,
                              fechaSeleccionada.day,
                              _horaInicio.hour,
                              _horaInicio.minute,
                            );
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                          "Hora de inicio: ${_horaInicio.format(context)}"),
                      trailing: Icon(Icons.access_time, color: Colors.purple),
                      onTap: () async {
                        TimeOfDay? horaSeleccionada = await showTimePicker(
                          context: context,
                          initialTime: _horaInicio,
                        );
                        if (horaSeleccionada != null &&
                            horaSeleccionada != _horaInicio) {
                          setState(() {
                            _horaInicio = horaSeleccionada;
                            _fechaInicio = DateTime(
                              _fechaInicio.year,
                              _fechaInicio.month,
                              _fechaInicio.day,
                              _horaInicio.hour,
                              _horaInicio.minute,
                            );
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                          "Fecha de fin: ${DateFormat('dd-MM-yy').format(_fechaFin)}"),
                      trailing:
                          Icon(Icons.calendar_today, color: Colors.purple),
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: _fechaFin,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (fechaSeleccionada != null &&
                            fechaSeleccionada != _fechaFin) {
                          setState(() {
                            _fechaFin = DateTime(
                              fechaSeleccionada.year,
                              fechaSeleccionada.month,
                              fechaSeleccionada.day,
                              _horaFin.hour,
                              _horaFin.minute,
                            );
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text("Hora de fin: ${_horaFin.format(context)}"),
                      trailing: Icon(Icons.access_time, color: Colors.purple),
                      onTap: () async {
                        TimeOfDay? horaSeleccionada = await showTimePicker(
                          context: context,
                          initialTime: _horaFin,
                        );
                        if (horaSeleccionada != null &&
                            horaSeleccionada != _horaFin) {
                          setState(() {
                            _horaFin = horaSeleccionada;
                            _fechaFin = DateTime(
                              _fechaFin.year,
                              _fechaFin.month,
                              _fechaFin.day,
                              _horaFin.hour,
                              _horaFin.minute,
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Eliminar'),
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Actualizar'),
                  onPressed: () {
                    _fechaInicio = DateTime(
                      _fechaInicio.year,
                      _fechaInicio.month,
                      _fechaInicio.day,
                      _horaInicio.hour,
                      _horaInicio.minute,
                    );
                    _fechaFin = DateTime(
                      _fechaFin.year,
                      _fechaFin.month,
                      _fechaFin.day,
                      _horaFin.hour,
                      _horaFin.minute,
                    );
                    final nuevaActividad = actividad.copyWith(
                        nombre: _tituloController.text,
                        descripcion: _descripcionController.text,
                        fechaInicio: _fechaInicio,
                        fechaFin: _fechaFin,
                        responsable: _responsableController.text,
                        estado: _estado,
                        horaInicio: _fechaInicio.toString(),
                        horaFin: _fechaFin.toString());
                    _actualizarActividades(nuevaActividad);
                    setState(() {});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades CRECER'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2101, 10, 16),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day);
                _focusedDay =
                    DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) => [],
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              todayBuilder: (context, date, events) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              defaultBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Actividades para ${DateFormat('dd-MM-yy').format(_selectedDay)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: ActividadesService()
                  .obtenerActividadesPorFecha(fecha: _selectedDay),
              builder: (context, snapshot) => snapshot.hasError
                  ? Text(snapshot.error.toString())
                  : ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final actividad = snapshot.data?[index];
                        return ListTile(
                          title: Text(actividad?.nombre ?? ''),
                          subtitle: Text(
                              '${actividad?.descripcion} (${TimeOfDay.fromDateTime(actividad?.fechaInicio ?? DateTime.now()).format(context)} - ${TimeOfDay.fromDateTime(actividad?.fechaFin ?? DateTime.now()).format(context)})'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  if (actividad != null) {
                                    _actualizarFormulario(actividad: actividad);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  if (actividad != null) {
                                    _eliminarActividades(actividad);
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _mostrarFormulario();
        },
      ),
    );
  }
}
