import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/camp_model.dart';
import 'app_drawer.dart';

class CurrentCampsPage extends StatefulWidget {
  @override
  State<CurrentCampsPage> createState() => _CurrentCampsPageState();
}

class _CurrentCampsPageState extends State<CurrentCampsPage> {
  // Create TextEditingController instances for each text field
  final TextEditingController _campNameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _headDoctorController = TextEditingController();

  final TextEditingController _lastDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camps Details'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: AppDrawer(), // Use the AppDrawer widget here
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Camp').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'There Are No Current Camps Going On.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Camp camp = Camp.fromSnapshot(document);
              return GestureDetector(
                onTap: () {
                  _showCampDetails(context, camp);
                },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 15.0),
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              camp.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Start Date: ${camp.startDate}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'End Date: ${camp.lastDate}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              );

            }).toList(),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 70, // Set the desired width
        height: 70, // Set the desired height
        child: FloatingActionButton(
          onPressed: () {
            _showAddCampModal(context);
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: Colors.white, size: 36), // Increase the icon size
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddCampModal(BuildContext context) {
    bool _isSaving = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Add New Camp',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      _buildTextField('Camp Name', 'Enter camp name', _campNameController),
                      SizedBox(height: 16.0),
                      _buildTextField(
                        'Description (Max words 200)',
                        'Enter description',
                        _descriptionController,
                        maxLength: 200,
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 16.0),
                      _buildDateField(context, 'Start Date', 'Enter start date', _startDateController),
                      SizedBox(height: 16.0),
                      _buildTextField('Address', 'Enter address', _addressController),
                      SizedBox(height: 16.0),
                      _buildTextField('Head Doctor', 'Enter head doctor\'s name', _headDoctorController),
                      SizedBox(height: 16.0),
                      _buildDateField(context, 'Last Date', 'Enter last date', _lastDateController),
                      SizedBox(height: 20.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isSaving = true;
                            });
                            _saveCampData();
                            setState(() {
                              _isSaving = false;
                            });

                            // Close the modal
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(300, 40),
                          ),
                          child: _isSaving
                              ? CircularProgressIndicator() // Show loading indicator when _isSaving is true
                              : Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        )

                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCampDetails(BuildContext context, Camp camp) {
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(camp.startDate));
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(camp.lastDate));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              camp.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  camp.description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Start Date:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  formattedStartDate,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'End Date:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  formattedEndDate,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Address:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  camp.address,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Head Doctor:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  camp.headDoctor,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                deleteCampFromDatabase(camp.id);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red, // Change the color to red for better visibility
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String labelText, String hintText, TextEditingController controller,
      {int? maxLength, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String labelText, String hintText, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
          controller.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  void _saveCampData() {
    String campName = _campNameController.text;
    String description = _descriptionController.text;
    String startDate = _startDateController.text;
    String address = _addressController.text;
    String headDoctor = _headDoctorController.text;
    String lastDate = _lastDateController.text;

    FirebaseFirestore.instance.collection('Camp').add({
      'campName': campName,
      'description': description,
      'startDate': startDate,
      'address': address,
      'headDoctor': headDoctor,
      'lastDate': lastDate,
    }).then((value) {
      // Camp data saved successfully
      print('Camp data saved successfully');
    }).catchError((error) {
      // Error occurred while saving camp data
      print('Error saving camp data: $error');
    });
  }

  void deleteCampFromDatabase(String campId) {
    final firestoreInstance = FirebaseFirestore.instance;
    final campReference = firestoreInstance.collection('Camp').doc(campId);
    campReference.delete().then((_) {
      print('Camp deleted successfully');
    }).catchError((error) {
      print('Error deleting camp: $error');
    });
  }
}
