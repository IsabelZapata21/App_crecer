import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronograma Flutter',
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
  DateTime? _selectedDay;
  List<Actividad> actividadesDelDia = [];

  void _mostrarFormulario({Actividad? actividad}) {
    final _tituloController = TextEditingController(text: actividad?.titulo);
    final _descripcionController =
        TextEditingController(text: actividad?.descripcion);

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
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                final nuevaActividad = Actividad(
                  titulo: _tituloController.text,
                  descripcion: _descripcionController.text,
                );

                setState(() {
                  if (actividad == null) {
                    actividadesDelDia.add(nuevaActividad);
                  } else {
                    final index = actividadesDelDia.indexOf(actividad);
                    actividadesDelDia[index] = nuevaActividad;
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
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay =
                    selectedDay; // Asegúrate de que el focusedDay se actualice al día seleccionado
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                // Asegúrate de que estás usando setState aquí también
                _focusedDay = focusedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: actividadesDelDia.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(actividadesDelDia[index].titulo),
                  subtitle: Text(actividadesDelDia[index].descripcion),
                  trailing: Icon(Icons.edit),
                  onTap: () {
                    _mostrarFormulario(actividad: actividadesDelDia[index]);
                  },
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
