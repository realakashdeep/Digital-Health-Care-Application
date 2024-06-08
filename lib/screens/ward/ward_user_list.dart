import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/user.dart';
import '../../models/ward_model.dart';
import 'package:permission_handler/permission_handler.dart';

class WardUserList extends StatefulWidget {
  @override
  _WardUserListState createState() => _WardUserListState();
}

class _WardUserListState extends State<WardUserList> {
  String? _wardNumber;
  List<MyUser> users = [];

  @override
  void initState() {
    super.initState();
    getWardNumber();
  }

  Future<void> getWardNumber() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (uid.isEmpty) {
        throw Exception("Ward User is not logged in.");
      }

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection('Wards').doc(uid).get();

      if (documentSnapshot.exists) {
        setState(() {
          _wardNumber = WardModel.fromSnapshot(documentSnapshot).wardNumber;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> saveAsPdf() async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text(
                'User Details in Ward ' + (_wardNumber ?? ''),
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.Table.fromTextArray(
                headers: ['Name', 'Date Registered', 'Ward Number'],
                data: users.map((user) => [user.name, user.dateRegistered, user.ward]).toList(),
              ),
            ],
          ),
        ),
      );

      var status = await Permission.storage.request();
      if (status.isGranted) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users in Ward ' + (_wardNumber ?? '')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _wardNumber == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'User Details in Ward ' + _wardNumber!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .where('ward', isEqualTo: _wardNumber)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        users = snapshot.data!.docs
                            .map((doc) => MyUser.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
                            .toList();
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Date Registered')),
                                DataColumn(label: Text('Ward Number')),
                              ],
                              rows: users.map((user) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(user.name)),
                                    DataCell(Text(user.dateRegistered)),
                                    DataCell(Text(user.ward)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: saveAsPdf,
              child: Text('Save as PDF'),
            ),
          ],
        ),
      ),
    );
  }
}