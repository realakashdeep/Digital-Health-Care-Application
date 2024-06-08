import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../models/appointment_model.dart';

class AppointmentDetails extends StatelessWidget {
  final AppointmentModel appointment;

  AppointmentDetails({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Save as PDF') {
                _generateAndSavePdf();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Save as PDF',
                child: Text('Save as PDF'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDetailItem(context, 'Appointment Date', appointment.appointmentDate),
              _buildDetailItem(context, 'Patient Name', appointment.patientName),
              _buildDetailItem(context, 'Blood Pressure', appointment.bp),
              _buildDetailItem(context, 'Temperature', appointment.temp),
              _buildDetailItem(context, 'Heart Rate', appointment.heartRate),
              _buildDetailItem(context, 'SpO2', appointment.spO2),
              _buildDetailItem(context, 'Assigned To', appointment.assignedTo),
              _buildDetailItem(context, 'Doctor Email', appointment.doctorMail),
              _buildDetailItem(context, 'Ward Number', appointment.wardNumber),
              _buildDetailItem(context, 'Status', appointment.status),
              _buildDetailItem(context, 'Symptoms', appointment.symptoms),
              _buildDetailItem(context, 'Prescriptions', appointment.prescriptions),
              _buildDetailItem(context, 'Tests', appointment.tests),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Container(
                  width: constraints.maxWidth * 0.99,  // 90% of the screen width
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndSavePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  appointment.patientName,
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  'Doctor: ${appointment.assignedTo}, Ward Number: ${appointment.wardNumber}',
                  style: pw.TextStyle(fontSize: 18),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  'Date: ${appointment.appointmentDate}',
                  style: pw.TextStyle(fontSize: 15),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildPdfDetailItem('Blood Pressure', appointment.bp),
                        _buildPdfDetailItem('SpO2', appointment.spO2),
                        _buildPdfDetailItem('Temperature', appointment.temp),
                        _buildPdfDetailItem('Heart Rate', appointment.heartRate),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildPdfDetailItem('Symptoms', appointment.symptoms, bold: true),
                        _buildPdfDetailItem('Prescriptions', appointment.prescriptions),
                        _buildPdfDetailItem('Tests', appointment.tests),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Prescription - $appointment.appointmentDate',
    );
  }

  pw.Widget _buildPdfDetailItem(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 14, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
          pw.Text(value, style: pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
