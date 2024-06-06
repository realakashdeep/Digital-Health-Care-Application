import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
        // Format selected date to match Firestore timestamp format
        String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

        // Query healthRecord collection for documents with lastUpdated equal to the selected date
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('healthRecord')
            .where('lastUpdated', isEqualTo: formattedDate)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _userDetailsList = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          });
        } else {
          // If no documents found for the selected date
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No activity found for the selected date')),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.8, // Adjust width as needed
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
                  _selectedDate != null ? 'Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}' : 'Choose Date',
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
              child: Text('Fetch Daily Activity'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_userDetailsList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _userDetailsList.map((userDetails) {
                  return Container(
                    width: screenWidth * 0.8, // 80% of the screen width
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${userDetails['fullName'] ?? 'N/A'}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text('Phone Number: ${userDetails['phoneNumber'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
