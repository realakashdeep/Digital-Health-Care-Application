import 'package:flutter/material.dart';
import 'package:final_year_project/models/health_record_model.dart';
import 'package:provider/provider.dart';
import '../../provider/health_record_data_provider.dart';
import '../HealthRecordDetails.dart';

class UserHealthRecordListPage extends StatefulWidget {
  final String userId;

  UserHealthRecordListPage({required this.userId});

  @override
  _UserHealthRecordListPageState createState() => _UserHealthRecordListPageState();
}

class _UserHealthRecordListPageState extends State<UserHealthRecordListPage> {
  late Future<List<PatientHealthRecord>> _futureHealthRecords;

  @override
  void initState() {
    super.initState();
    // _futureHealthRecords = Provider.of<HealthRecordDataProvider>(context, listen: false).getUserHealthRecords(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Records',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<PatientHealthRecord>>(
        future: _futureHealthRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else {
            final healthRecords = snapshot.data!;
            return ListView.builder(
              itemCount: healthRecords.length,
              itemBuilder: (context, index) {
                final healthRecord = healthRecords[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      '',
                      // 'Record on ${healthRecord.timeStamp}',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserHealthRecordDetailPage(healthRecord: healthRecord),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
