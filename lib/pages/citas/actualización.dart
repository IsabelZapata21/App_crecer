import 'package:flutter/material.dart';

class Actualizar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Actualización de citas',
      theme: ThemeData(
        primarySwatch: Colors.purple,
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
  // Variables estáticas para los datos del paciente
  final String nombre = 'Juan Pérez';
  final String telefono = '555-1234';

  // Variables para almacenar las selecciones del usuario
  DateTime fechaCita = DateTime.now();
  TimeOfDay horaCita = TimeOfDay.now();
  String psicologoSeleccionado = 'Cesar Carrillo';
  String estadoCitaSeleccionado = 'Pendiente';

  // Listas para las opciones de psicólogos y estados de la cita
  List<String> psicologos = ['Cesar Carrillo', 'Sebastian Zapata'];
  List<String> estadosCita = ['Pendiente', 'Cancelado'];

  // Función para actualizar la cita
  void actualizarCita() {
    // Aquí puedes implementar la lógica para actualizar la cita en tu base de datos
    // Usar los valores almacenados en las variables
    print(
        'Cita actualizada para $nombre con psicólogo $psicologoSeleccionado en estado $estadoCitaSeleccionado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Buscar cita',
                    prefixIcon: Icon(Icons.search, color: Colors.purple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  // Aquí puedes agregar la lógica para filtrar las citas según la búsqueda
                ),
              ),
              Text(
                'Información de la cita:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Mostrar los datos del paciente como texto estático
              Text('Nombres y apellidos: $nombre',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text('Número de teléfono: $telefono',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              // ... (Resto del código para seleccionar fecha, hora, etc.)
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
                onPressed: actualizarCita,
                child: Text('Actualizar cita'),
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
    home: Actualizar(),
  ));
}
