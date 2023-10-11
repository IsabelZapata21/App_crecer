import 'package:flutter/material.dart';

class Registro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Cita',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Nuevo color
      ),
      home: CitasPage(),
    );
  }
}
class CitasPage extends StatefulWidget {
  @override
  _CitasPageState createState() => _CitasPageState();
}
class _CitasPageState extends State<CitasPage> {
  // Variables para almacenar los datos de la cita
  String nombre = '';
  String telefono = '';
  DateTime fechaCita = DateTime.now();
  TimeOfDay horaCita = TimeOfDay.now();
  String psicologoSeleccionado = 'Cesar Carrillo';
  String estadoCitaSeleccionado = 'Pendiente';

  // Listas para las opciones de psicólogos y estados de la cita
  List<String> psicologos = ['Cesar Carrillo', 'Sebastian Zapata'];
  List<String> estadosCita = ['Pendiente', 'Cancelado'];

  // Función para guardar la cita
  void guardarCita() {
    // Aquí puedes implementar la lógica para guardar la cita en tu base de datos
    // Usar los valores almacenados en las variables
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple, // Nuevo color de fondo
        title: Text('Programar cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Ingresar información de la cita:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  setState(() {
                    nombre = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nombres y apellidos',
                  prefixIcon: Icon(Icons.person, color: Colors.purple), // Nuevo ícono
                ),
              ),
             SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  setState(() {
                    telefono = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Número de teléfono',
                  prefixIcon: Icon(Icons.phone, color: Colors.purple), // Nuevo ícono
                ),
              ),
              SizedBox(height: 16),
              Text('Fecha de la cita:'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final fechaSeleccionada = await showDatePicker(
                    context: context,
                    initialDate: fechaCita,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (fechaSeleccionada != null && fechaSeleccionada != fechaCita) {
                    setState(() {
                      fechaCita = fechaSeleccionada;
                    });
                  }
                },
                child: Text(
                  "${fechaCita.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Text('Hora de la Cita:'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final horaSeleccionada = await showTimePicker(
                    context: context,
                    initialTime: horaCita,
                  );
                  if (horaSeleccionada != null && horaSeleccionada != horaCita) {
                    setState(() {
                      horaCita = horaSeleccionada;
                    });
                  }
                },
                child: Text(
                  "${horaCita.format(context)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: psicologoSeleccionado,
                items: psicologos.map((String psicologo) {
                  return DropdownMenuItem(
                    value: psicologo,
                    child: Text(psicologo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    psicologoSeleccionado = value.toString();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Psicólogo',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: estadoCitaSeleccionado,
                items: estadosCita.map((String estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    estadoCitaSeleccionado = value.toString();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Estado de la Cita',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  guardarCita();
                  // Puedes agregar aquí la lógica para guardar la cita
                },
                child: Text('Guardar cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Registro(),
  ));
}
