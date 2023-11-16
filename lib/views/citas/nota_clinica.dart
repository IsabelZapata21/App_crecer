import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/citas/paciente.dart';
import 'package:flutter_application_2/models/citas/psicologo.dart';
import 'package:flutter_application_2/services/citas/pacientes_service.dart';
import 'package:flutter_application_2/services/citas/sesion_service.dart';
import 'package:flutter_application_2/views/citas/v_nota_clinica.dart';
import 'detalles_sesion.dart';
import 'package:flutter_application_2/models/citas/cita.dart';
import 'package:flutter_application_2/services/citas/citas_service.dart';

class NotaClinica extends StatefulWidget {
  @override
  State<NotaClinica> createState() => _NotaClinicaState();
}

class _NotaClinicaState extends State<NotaClinica> {
  Pacientes? paciente;
  String _terminoBusqueda = ''; // Término de búsqueda
  List<Psicologo>? psicologos;
  List<Pacientes>? pacientes;
  @override
  void initState() {
    PacienteService().obtenerDatos().then((value) {
      pacientes = value;
      setState(() {});
    });
    super.initState();
  }

  Widget _buildCitaItem(
      {required String fecha,
      required String hora,
      required String descripcion,
      required String idCita}) {
    return GestureDetector(
      onTap: () async {
        final value = await SesionService().obtenerNotasClinicasId(idCita);
        if (value.sesion.isEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('No hay sesiones'),
              );
            },
          );
          return;
        }
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('Sesiones'),
              children: value.sesion.map((sesion) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotaClinicaPage(data: sesion.toJson()),
                      ),
                    );
                  },
                  title: Text('Duración: ${sesion.duracion}'),
                  subtitle: Text('Descripción: ${sesion.desarrollo}'),
                );
              }).toList(),
            );
          },
        );
        // }).catchError((error) {
        //   showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text('Error'),
        //         content: Text('Error al obtener las sesiones: $error'),
        //       );
        //     },
        //   );
        // });
      },
      child: Card(
        elevation: 2, // Elevación del card
        margin:
            EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Margen reducido
        child: ListTile(
          leading: Icon(
            Icons.calendar_today,
            size: 32,
            color: Colors.deepPurple, // Nuevo color
          ),
          title: Text(
            fecha,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold, // Texto en negrita
              color: Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.0), // Espacio entre el título y el subtítulo
              Text('Hora: $hora'),
              Text(descripcion),
            ],
          ),
        ),
      ),
    );
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
            child: DropdownButtonFormField<Pacientes?>(
              value: paciente,
              items: [
                DropdownMenuItem<Pacientes?>(
                  value: null,
                  child: Text('Seleccionar'),
                ),
                ...pacientes?.map((p) {
                      return DropdownMenuItem<Pacientes?>(
                        value: p,
                        child: Text('${p.nombre}'),
                      );
                    }).toList() ??
                    [],
              ],
              onChanged: (value) {
                setState(() {
                  paciente = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Paciente',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Citas>>(
              future: CitasService()
                  .obtenerListaCitasPorPaciente(paciente?.id ?? ''),
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
                      return _buildCitaItem(
                        idCita: cita.id ?? '',
                        fecha:
                            'Fecha: ${cita.fechaCita?.toLocal().toString().split(' ')[0]}',
                        hora: 'Hora: ${cita.horaCita}',
                        descripcion: cita.descripcion ?? '',
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetallesSesion()),
          ); // Aquí puedes agregar la lógica para dirigir al usuario a la pantalla de agregar cita
        },
      ),
    );
  }
}
