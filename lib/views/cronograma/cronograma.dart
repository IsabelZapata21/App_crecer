import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

class Actividad {
  final String titulo;
  final String descripcion;

  Actividad({required this.titulo, required this.descripcion});
}

class CronogramaScreen extends StatefulWidget {
  @override
  _CronogramaScreenState createState() => _CronogramaScreenState();
}

class _CronogramaScreenState extends State<CronogramaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Actividad>> actividadesPorDia = {};

  List<Actividad> _getActividadesForDay(DateTime day) {
    return actividadesPorDia[day] ?? [];
  }

  void _mostrarFormulario({Actividad? actividad}) {
    final _tituloController =
        TextEditingController(text: actividad?.titulo ?? '');
    final _descripcionController =
        TextEditingController(text: actividad?.descripcion ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(actividad == null ? 'Añadir Actividad' : 'Editar Actividad'),
          content: Column(
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
            ],
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
                final nuevaActividad = Actividad(
                  titulo: _tituloController.text,
                  descripcion: _descripcionController.text,
                );

                setState(() {
                  if (actividad == null) {
                    actividadesPorDia[_selectedDay] = actividadesPorDia
                        .putIfAbsent(_selectedDay, () => [])
                      ..add(nuevaActividad);
                  } else {
                    final index =
                        actividadesPorDia[_selectedDay]!.indexOf(actividad);
                    actividadesPorDia[_selectedDay]![index] = nuevaActividad;
                  }
                });

                Navigator.of(context).pop();
              },
            ),
          ],
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
                  title: Text(actividad.titulo),
                  subtitle: Text(actividad.descripcion),
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