import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DailyActivityPage extends StatefulWidget {
  @override
  _DailyActivityPageState createState() => _DailyActivityPageState();
}

class _DailyActivityPageState extends State<DailyActivityPage> {
  DateTime? _selectedDate;
  bool _isLoading = false;
  List<Map<String, dynamic>> _userDetailsList = [];

  Future<void> _fetchDailyActivity() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedDate != null) {
        String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

        if (currentUserEmail != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

          // Query appointments collection for documents with careMail matching the current user's email
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('appointments')
              .where('careMail', isEqualTo: currentUserEmail)
              .get();

          List<Map<String, dynamic>> userDetailsList = [];

          for (var doc in querySnapshot.docs) {
            // Extract the date part from appointmentDate
            String appointmentDate = (doc.data() as Map<String, dynamic>)['appointmentDate'];
            String appointmentDateTrimmed = appointmentDate.split(' ')[0]; // Trim the time part
            if (appointmentDateTrimmed == formattedDate) {
              userDetailsList.add(doc.data() as Map<String, dynamic>);
            }
          }

          setState(() {
            _userDetailsList = userDetailsList;
          });

          if (userDetailsList.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No activity found for the selected date')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unable to fetch user information')),
          );
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching daily activity: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.99,
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  minimumSize: Size(200, 20),
                ),
                child: Text(
                  _selectedDate != null
                      ? 'Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'
                      : 'Choose Date',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedDate != null) {
                  _fetchDailyActivity();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please choose a date')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.blue),
              ),
              child: Text('Fetch Daily Activity'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_userDetailsList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._userDetailsList.map((userDetail) {
                    return Container(
                      width: screenWidth * 0.9,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${userDetail['patientName'] ?? 'N/A'}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text('Status: ${userDetail['status'] ?? 'N/A'}'),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => _generatePDF(userDetail),
                                child: Text(
                                  'Generate PDF',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,  // Set the width to 50% of the screen width
                        child: ElevatedButton(
                          onPressed: () {
                            if (_userDetailsList.isNotEmpty) {
                              _generatePDF(_userDetailsList, isCombined: true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.blue),
                          ),
                          child: Text('All Users PDF', style: TextStyle(fontSize: 14),),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,  // Set the width to 50% of the screen width
                        child: ElevatedButton(
                          onPressed: () {
                            if (_userDetailsList.isNotEmpty) {
                              _generateSummaryReport(_userDetailsList);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.blue),
                          ),
                          child: Text('Summary Report'),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePDF(dynamic userDetails, {bool isCombined = false}) async {
    final pdf = pw.Document();
    String pdfName = 'Daily Activity';

    if (isCombined) {
      // Add chosen date to the PDF name for combined report
      pdfName += ' - ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}';
      int userIndex = 1;

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                ...userDetails.map<pw.Widget>((userDetail) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('User $userIndex', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      _buildPdfContent(userDetail),
                      pw.Divider(),
                    ],
                  );
                }).toList(),
              ],
            );
          },
        ),
      );
    } else {
      String appointmentDate = userDetails['appointmentDate'];
      String patientName = userDetails['patientName'];
      pdfName = '$patientName - ${appointmentDate.split(' ')[0]}';

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => _buildPdfContent(userDetails),
        ),
      );
    }

    await _saveAndPrintPDF(pdf, pdfName);
  }

  pw.Widget _buildPdfContent(Map<String, dynamic> userDetails) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Patient Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('Name: ${userDetails['patientName']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Ward Number: ${userDetails['wardNumber']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Assigned To Doctor: ${userDetails['assignedTo']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Doctors Mail: ${userDetails['doctorMail']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Appointment Date: ${userDetails['appointmentDate']}', style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 20),
        pw.Text('Patient\'s Health Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('Symptoms: ${userDetails['symptoms']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Temperature: ${userDetails['temp']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Blood Pressure: ${userDetails['bp']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Heart Rate: ${userDetails['heartRate']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('SpO2: ${userDetails['spO2']}', style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 20),
        pw.Text('Results', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('Tests recommended by doctor: ${userDetails['tests']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Prescriptions: ${userDetails['prescriptions']}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Status: ${userDetails['status']}', style: pw.TextStyle(fontSize: 18)),
      ],
    );
  }

  Future<void> _saveAndPrintPDF(pw.Document pdf, String pdfName) async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: pdfName,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF generated successfully: $pdfName')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  Future<void> _generateSummaryReport(List<Map<String, dynamic>> userDetailsList) async {
    final pdf = pw.Document();
    String pdfName = 'Summary Report - ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}';

    pdf.addPage(
      pw.MultiPage(
          orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4.landscape,  // Set page orientation to landscape
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Summary Report - ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                  headers: ['S.No', 'Patient Name', 'Assigned To', 'Symptoms', 'Prescriptions', 'Tests', 'Status'],
                  columnWidths: {
                    0: pw.FixedColumnWidth(30),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1),
                    5: pw.FlexColumnWidth(1),
                    6: pw.FlexColumnWidth(1),
                    7: pw.FlexColumnWidth(1),
                  },
                  data: List<List<String>>.generate(
                    userDetailsList.length,
                        (index) {
                      final userDetail = userDetailsList[index];
                      return [
                        (index + 1).toString(),
                        userDetail['patientName'] ?? 'N/A',
                        userDetail['assignedTo'] ?? 'N/A',
                        userDetail['symptoms'] ?? 'N/A',
                        userDetail['prescriptions'] ?? 'N/A',
                        userDetail['tests'] ?? 'N/A',
                        userDetail['status'] ?? 'N/A',
                      ];
                    },
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await _saveAndPrintPDF(pdf, pdfName);
  }

}
