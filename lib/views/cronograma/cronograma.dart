import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_2/services/cronograma/actividades_service.dart';
import 'package:flutter_application_2/models/cronograma/actividades.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CronogramaScreen();
  }
}

class CronogramaScreen extends StatefulWidget {
  @override
  _CronogramaScreenState createState() => _CronogramaScreenState();
}

class _CronogramaScreenState extends State<CronogramaScreen> {
  @override
  void initState() {
    super.initState();
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  //variables
  Actividades? actividades;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime fechaInicio = DateTime.now();
  DateTime fechaFin = DateTime.now();
  String? estadoActividad;
  List<String> estadosActividad = ['Pendiente', 'Realizada', 'Cancelada'];
  List<DateTime> fechasGuardadas = [];

  Map<DateTime, List<Actividades>> actividadesPorDia = {};

  List<Actividades> _getActividadesForDay(DateTime day) {
    return actividadesPorDia[day] ?? [];
  }

  void _guardarActividades(Actividades actividad) async {
    Map<String, dynamic> actData = {
      'nombre': actividad.nombre,
      'descripcion': actividad.descripcion,
      'fechaInicio': actividad.fechaInicio.toString(),
      'fechaFin': actividad.fechaFin.toString(),
      'responsable': 1,
      'estado': actividad.estado
    };
    try {
      String mensaje = await ActividadesService().guardarActividades(actData);
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

    if (actividadesPorDia[_selectedDay] == null) {
      actividadesPorDia[_selectedDay] = [];
    }
    actividadesPorDia[_selectedDay]!.add(actividad);
    setState(() {});
  }

  void _mostrarFormulario({Actividades? actividad}) {
    final _tituloController =
        TextEditingController(text: actividad?.nombre ?? '');
    final _descripcionController =
        TextEditingController(text: actividad?.descripcion ?? '');
    final _responsableController =
        TextEditingController(text: actividad?.responsable ?? '');
    DateTime _fechaInicio = actividad?.fechaInicio ?? DateTime.now();
    DateTime _fechaFin = actividad?.fechaFin ?? DateTime.now();
    TimeOfDay _horaInicio = TimeOfDay.fromDateTime(_fechaInicio);
    TimeOfDay _horaFin = TimeOfDay.fromDateTime(_fechaFin);
    String _estado = actividad?.estado ?? 'Pendiente'; // Valor predeterminado

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  actividad == null ? 'Añadir Actividad' : 'Editar Actividad'),
              content: SingleChildScrollView(
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
                    ),
                    DropdownButtonFormField<String>(
                      value: _estado,
                      items: ['Pendiente', 'Realizado', 'Cancelado']
                          .map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
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
                if (actividad != null) ...[
                  TextButton(
                    child: Text('Eliminar'),
                    onPressed: () {
                      setState(() {
                        actividadesPorDia[_selectedDay]!.remove(actividad);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
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
                      idAct: // Aquí puedes generar un ID o usar una función para ello
                          '0', // Aquí puedes generar un ID o susar una función para ello
                      nombre: _tituloController.text,
                      descripcion: _descripcionController.text,
                      fechaInicio: _fechaInicio,
                      fechaFin: _fechaFin,
                      responsable: _responsableController.text,
                      estado: _estado,
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
            eventLoader: _getActividadesForDay,
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
                if (actividadesPorDia[date] != null &&
                    actividadesPorDia[date]!.isNotEmpty) {
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
                } else {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Actividades para ${DateFormat('dd-MM-yy').format(_selectedDay)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: actividadesPorDia[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                final actividad = actividadesPorDia[_selectedDay]![index];
                return ListTile(
                  title: Text(actividad.nombre.toString()),
                  subtitle: Text(
                      '${actividad.descripcion} (${actividad.fechaInicio?.toLocal().toString().split(' ')[0] ?? 'Fecha desconocida'} ${TimeOfDay.fromDateTime(actividad.fechaInicio ?? DateTime.now()).format(context)} - ${actividad.fechaFin?.toLocal().toString().split(' ')[0] ?? 'Fecha desconocida'} ${TimeOfDay.fromDateTime(actividad.fechaFin ?? DateTime.now()).format(context)})'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _mostrarFormulario(actividad: actividad);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            actividadesPorDia[_selectedDay]!.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
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
