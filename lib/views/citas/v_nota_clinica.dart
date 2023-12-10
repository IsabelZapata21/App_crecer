import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:typed_data';
import 'package:printing/printing.dart';
import '../../models/citas/sesiones.dart';


class NotaClinicaPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final Psicologo? psicologo;
  final Paciente? paciente;

  NotaClinicaPage(
      {required this.data, required this.psicologo, required this.paciente});
  PdfImage? pdfImage;
  

  Future<void> _generateAndPreviewPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              //_buildHeader(),
              _buildInfoRow('Psicologo',
                  '${psicologo?.nombres} ${psicologo?.apellidos}'),
              _buildInfoRow('Hora inicio', data['hora_inicio'] ?? ''),
              _buildInfoRow('Hora fin', data['hora_fin'] ?? ''),
              _buildInfoRow('Duración', data['duracion'] ?? ''),
              _buildInfoRow('Inicio', data['inicio'] ?? ''),
              _buildInfoRow('Desarrollo', data['desarrollo'] ?? ''),
              _buildInfoRow('Análisis', data['analisis'] ?? ''),
              _buildInfoRow(
                  'Observaciones', data['observaciones'] ?? ''),
            ],
          );
        },
      ),
    );

    final preview =
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      return pdf.save();
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 300,
            height: 400,
            child: PdfPreview(
              build: (format) => pdf.save(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generateAndDownloadPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
             // _buildHeader(),
              _buildInfoRow('Psicologo', '${psicologo?.nombres} ${psicologo?.apellidos}'),
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

    OpenFile.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF generado y guardado en ${file.path}'),
      ),
    );
  }

  pw.Widget _buildHeader() {
    final Uint8List imageData = File('assets/image/logo_crecer.png').readAsBytesSync();
    final pw.Widget imageWidget = pw.Container(
      width: 200,
      height: 100,
      child: pw.Image(pw.MemoryImage(imageData)),
    );

    return pw.Container(
      alignment: pw.Alignment.center,
      margin: pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        children: [
          imageWidget,
          pw.SizedBox(height: 10),
          pw.Text(
            'CRECER',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
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
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              _generateAndPreviewPDF(context);
            },
          ),
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
            _buildInfoTile(
              'Psicologo',
              '${psicologo?.nombres} ${psicologo?.apellidos}',
            ),
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
