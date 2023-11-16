import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class NotaClinicaPage extends StatelessWidget {
  final Map<String, dynamic> data;

  NotaClinicaPage({required this.data});

  Future<void> _generateAndDownloadPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              _buildInfoRow('Psicologo', data['psicologo'] ?? ''),
              _buildInfoRow('Paciente', data['paciente'] ?? ''),
              _buildInfoRow('Hora inicio', data['hora_inicio'] ?? ''),
              _buildInfoRow('Hora fin', data['hora_fin'] ?? ''),
              _buildInfoRow('Duración', data['duracion'] ?? ''),
              _buildInfoRow('Inicio', data['inicio'] ?? ''),
              _buildInfoRow('Desarrollo', data['desarrollo'] ?? ''),
              _buildInfoRow('Análisis', data['analisis'] ?? ''),
              _buildInfoRow('Observaciones', data['observaciones'] ?? ''),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/nota_clinica.pdf");
    await file.writeAsBytes(await pdf.save());
// Abrir el PDF
    OpenFile.open(file.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF generado y guardado en ${file.path}'),
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            color: PdfColors.purple,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Text(value),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Nota Clínica'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              _generateAndDownloadPDF(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoTile('Psicologo', data['psicologo'] ?? ''),
            _buildInfoTile('Paciente', data['paciente'] ?? ''),
            _buildInfoTile('Hora inicio', data['hora_inicio'] ?? ''),
            _buildInfoTile('Hora fin', data['hora_fin'] ?? ''),
            _buildInfoTile('Duración', data['duracion'] ?? ''),
            _buildInfoTile('Inicio', data['inicio'] ?? ''),
            _buildInfoTile('Desarrollo', data['desarrollo'] ?? ''),
            _buildInfoTile('Análisis', data['analisis'] ?? ''),
            _buildInfoTile('Observaciones', data['observaciones'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
