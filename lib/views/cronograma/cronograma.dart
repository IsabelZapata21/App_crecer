import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_application_2/models/cronograma/actividades.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart'; // Asegúrate de importar tu servicio

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CronogramaScreen(),
    );
  }
}

class CronogramaScreen extends StatefulWidget {
  @override
  _CronogramaScreenState createState() => _CronogramaScreenState();
}

class _CronogramaScreenState extends State<CronogramaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Actividades>> actividadesPorDia = {};

  final CitasService _citasService = CitasService(); // Instancia del servicio

  List<Actividades> _getActividadesForDay(DateTime day) {
    return actividadesPorDia[day] ?? [];
  }

  pdfWidgets.Document _crearPDF() {
    final pdf = pdfWidgets.Document();

    pdf.addPage(
      pdfWidgets.Page(
        build: (pdfWidgets.Context context) {
          return pdfWidgets.ListView.builder(
            itemCount: actividadesPorDia.length,
            itemBuilder: (context, index) {
              final actividades = actividadesPorDia.values.elementAt(index);
              return pdfWidgets.Column(
                children: actividades.map((actividad) {
                  return pdfWidgets.Padding(
                    padding: const pdfWidgets.EdgeInsets.all(8.0),
                    child: pdfWidgets.Text(
                      '${actividad.nombre} (${actividad.fechaInicio} - ${actividad.fechaFin})',
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );

    return pdf;
  }

  Future<bool> _solicitarPermisoDeAlmacenamiento() async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }

  void _exportarActividadesDelMes() async {
    final pdf = _crearPDF();
    // Aquí puedes guardar el PDF en el sistema de archivos o compartirlo
    // Por ahora, solo mostraré un SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF creado (aún no guardado)')),
    );
  }

  void _guardarActividades(Actividades actividad) {
    if (actividadesPorDia[_selectedDay] == null) {
      actividadesPorDia[_selectedDay] = [];
    }
    actividadesPorDia[_selectedDay]!.add(actividad);
  }

  void _exportarPDF() async {
    bool tienePermiso = await _solicitarPermisoDeAlmacenamiento();
    if (tienePermiso) {
      _exportarActividadesDelMes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso de almacenamiento denegado')),
      );
    }
  }

  void _mostrarFormulario({Actividades? actividad}) {
    final _tituloController =
        TextEditingController(text: actividad?.nombre ?? '');
    final _descripcionController =
        TextEditingController(text: actividad?.descripcion ?? '');
    DateTime _fechaInicio = actividad?.fechaInicio ?? DateTime.now();
    DateTime _fechaFin = actividad?.fechaFin ?? DateTime.now();
    TimeOfDay _horaInicio = TimeOfDay.fromDateTime(_fechaInicio);
    TimeOfDay _horaFin = TimeOfDay.fromDateTime(_fechaFin);

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
                    SizedBox(height: 10),
                    ListTile(
                      title: Text(
                          "Fecha de inicio: ${_fechaInicio.toLocal().toString().split(' ')[0]}"),
                      trailing:
                          Icon(Icons.calendar_today, color: Colors.purple),
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: _fechaInicio,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Colors.purple,
                                accentColor: Colors.purple,
                                colorScheme:
                                    ColorScheme.light(primary: Colors.purple),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
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
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Colors.purple,
                                accentColor: Colors.purple,
                                colorScheme:
                                    ColorScheme.light(primary: Colors.purple),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
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
                          "Fecha de fin: ${_fechaFin.toLocal().toString().split(' ')[0]}"),
                      trailing:
                          Icon(Icons.calendar_today, color: Colors.purple),
                      onTap: () async {
                        DateTime? fechaSeleccionada = await showDatePicker(
                          context: context,
                          initialDate: _fechaFin,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Colors.purple,
                                accentColor: Colors.purple,
                                colorScheme:
                                    ColorScheme.light(primary: Colors.purple),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
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
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Colors.purple,
                                accentColor: Colors.purple,
                                colorScheme:
                                    ColorScheme.light(primary: Colors.purple),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
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
                    final nuevaActividad = Actividades(
                      idAct:
                          'ID_GENERADO_AUTOMATICAMENTE', // Aquí puedes generar un ID único o usar un valor predeterminado
                      nombre: _tituloController.text,
                      descripcion: _descripcionController.text,
                      fechaInicio: _fechaInicio,
                      fechaFin: _fechaFin,
                      responsable:
                          'RESPONSABLE_DEFAULT', // Aquí puedes poner un valor predeterminado o agregar un campo en el formulario para el responsable
                      estado:
                          'ESTADO_DEFAULT', // Aquí puedes poner un valor predeterminado o agregar un campo en el formulario para el estado
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
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: _exportarActividadesDelMes,
          ),
        ],
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
              "Actividades para ${_selectedDay.toLocal().toString().split(' ')[0]}",
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

class CronogramaValidate {
  String? validarCampos(String nombre, String descripcion, DateTime fechaInicio,
      DateTime fechaFin) {
    if (nombre.isEmpty) return 'El nombre de la actividad es requerido.';
    if (descripcion.isEmpty) return 'La descripción es requerida.';
    if (fechaInicio.isAfter(fechaFin))
      return 'La fecha de inicio no puede ser posterior a la fecha de fin.';
    return null;
  }
}
