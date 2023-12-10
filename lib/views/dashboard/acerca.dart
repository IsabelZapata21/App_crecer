import 'package:flutter/material.dart';

class AcercaDe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de la aplicación'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.purple,
                child: Icon(
                  Icons.android,
                  size: 50.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'AppCrecer',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              Text(
                'Versión 1.0.0',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Descripción de la Aplicación: El aplicativo móvil se desarrolló con Flutter y una arquitectura MVVM, integrándose con el sitio web existente de la empresa. Consta de módulos como gestión de usuarios, historiales clínicos, programación de citas, comunicación interna y control de asistencias. Los resultados de la implementación fueron altamente positivos, con mejoras significativas percibidas por los usuarios en áreas como la eficiencia de la gestión clínica y de citas.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}