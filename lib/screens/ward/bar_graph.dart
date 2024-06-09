import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/ward_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/user.dart';

class BarGraphReport extends StatefulWidget {
  const BarGraphReport({Key? key}) : super(key: key);

  @override
  BarGraphReportState createState() => BarGraphReportState();
}

class BarGraphReportState extends State<BarGraphReport> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late Future<void> _fetchUsersFuture;

  @override
  void initState() {
    super.initState();
    data = [];
    _tooltip = TooltipBehavior(enable: true);
    _fetchUsersFuture = getMyUsersFromFirebase();
  }

  Future<WardModel?> getWardModel() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      throw Exception("Ward User is not logged in.");
    }

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('Wards').doc(uid).get();

    if (documentSnapshot.exists) {
      return WardModel.fromSnapshot(documentSnapshot);
    } else {
      return null;
    }
  }

  Future<void> getMyUsersFromFirebase() async {
    try {
      WardModel? wardModel = await getWardModel();
      if(wardModel != null){
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('ward', isEqualTo: wardModel.wardNumber)
            .get();

        List<MyUser> users = querySnapshot.docs.map((doc) => MyUser.fromSnapshot(doc)).toList();
        print(users);
        _processMyUserData(users);
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _processMyUserData(List<MyUser> users) {
    final Map<int, int> userCounts = Map<int, int>.fromIterable(
      List.generate(12, (index) => index + 1),
      key: (item) => item,
      value: (item) => 0,
    );

    for (var user in users) {
      final registrationDate = _parseDate(user.dateRegistered);
      if (registrationDate != null) {
        final month = registrationDate.month;
        userCounts[month] = userCounts[month]! + 1;
      }
    }

    userCounts.forEach((month, count) {
      data.add(_ChartData(_getMonthName(month), count.toDouble()));
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  DateTime? _parseDate(String dateString) {
    if (dateString.isEmpty) {
      return null;
    }

    if (dateString.contains('/')) {
      // Handle DD/MM/YYYY format
      final parts = dateString.split('/');
      if (parts.length != 3) {
        throw FormatException('Invalid date format: $dateString');
      }
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) {
        throw FormatException('Invalid date format: $dateString');
      }
      return DateTime(year, month, day);
    } else if (dateString.contains('-')) {
      // Handle YYYY-MM-DD format
      final parts = dateString.split('-');
      if (parts.length != 3) {
        throw FormatException('Invalid date format: $dateString');
      }
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (year == null || month == null || day == null) {
        throw FormatException('Invalid date format: $dateString');
      }
      return DateTime(year, month, day);
    } else {
      throw FormatException('Unsupported date format: $dateString');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registrations Chart'),
      ),
      body: FutureBuilder<void>(
        future: _fetchUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching users: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical, // Set height for vertical scrolling
              child: RotatedBox(
                quarterTurns: 1, // Rotate the chart horizontally
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 600, // Set width for horizontal scrolling
                    child: SfCartesianChart(
                      title: ChartTitle(
                          text: "Monthly User Registrations"
                      ),
                      primaryXAxis: CategoryAxis(
                        labelRotation: -90, // Rotate x-axis labels
                        interval: 1, // Display all months
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        interval: 1,
                        title: AxisTitle(text: 'Number of Users Registered'),
                      ),
                      tooltipBehavior: _tooltip,
                      series: <CartesianSeries>[
                        ColumnSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'User Registrations',
                          color: Color.fromRGBO(8, 142, 255, 1),
                          width: 0.5, // Decrease the width of bars
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
