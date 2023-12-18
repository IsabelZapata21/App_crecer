import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/views/psicologos/registrar_psicologo.dart';
import 'package:flutter_application_2/views/pacientes/listar_paciente.dart';
import 'package:flutter_application_2/views/pacientes/registrar_paciente.dart';
class PaciDashboard extends StatefulWidget {
  const PaciDashboard({super.key});

  @override
  State<PaciDashboard> createState() => _PaciDashboardState();
}

class _PaciDashboardState extends State<PaciDashboard> {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<UserRepository>(context, listen: false).usuario;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Usuarios'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              child:
                  const Icon(Icons.person_2_outlined, size: 100, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            Text(
              '${usuario?.genero == 'Femenino' ? 'Bienvenida' : 'Bienvenido'}, ${usuario?.fullName}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionsWidget(context),
            Text(
              'Modo ${usuario?.rol}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildOptionItem(
          context,
          'Registrar pacientes',
          Icons.assignment,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroPacienteScreen()),
            );
          },
        ),
        _buildOptionItem(
          context,
          'Listar pacientes',
          Icons.list,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistorialPacientes()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOptionItem(
      BuildContext context, String text, IconData icon, Function onPressed) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () => onPressed(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(icon, color: Colors.white, size: 30),
          radius: 30,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }
}
