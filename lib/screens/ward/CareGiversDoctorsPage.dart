import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/caregivers_model.dart';
import '../../models/doctors_model.dart';
import '../../models/ward_model.dart';
import '../../provider/ward/ward_user_provider.dart';
import '../../services/CareGiversService.dart';
import '../../services/doctor_services.dart';
import '../../services/ward_user_services.dart';
import 'CareGiverDetailsPage.dart';
import 'DoctorDetailsPage.dart'; // Add this import

class CareGiversDoctorsPage extends StatefulWidget {
  @override
  State<CareGiversDoctorsPage> createState() => _CareGiversDoctorsPageState();
}

class _CareGiversDoctorsPageState extends State<CareGiversDoctorsPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Future<List<CareGiver>>? _careGiversFuture;
  Future<List<Doctor>>? _doctorsFuture;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);
    String? userId = await wardUserProvider.getCurrentUserId();

    if (userId != null) {
      setState(() {
        _careGiversFuture = _fetchCareGivers(userId);
        _doctorsFuture = _fetchDoctors(userId);
      });
    }
  }

  Future<List<CareGiver>> _fetchCareGivers(String? userId) async {
    if (userId == null) return [];
    WardModel? wardUser = await WardUserServices().getWard(userId);
    if (wardUser == null) return [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('caregivers')
        .where('wardNumber', isEqualTo: wardUser.wardNumber)
        .get();

    return querySnapshot.docs.map((doc) => CareGiver.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Doctor>> _fetchDoctors(String? userId) async {
    if (userId == null) return [];
    WardModel? wardUser = await WardUserServices().getWard(userId);
    if (wardUser == null) return [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('wardNumber', isEqualTo: wardUser.wardNumber)
        .get();

    return querySnapshot.docs.map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Care Givers & Doctors'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'CareGiver'),
            Tab(text: 'Doctor'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCareGiversList(),
          _buildDoctorsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCareGiverDoctorDialog(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCareGiversList() {
    return RefreshIndicator(
      onRefresh: _fetchData,
      color: Colors.blue, // Set the loading indicator color to blue
      child: FutureBuilder<List<CareGiver>>(
        future: _careGiversFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Care Givers found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              CareGiver careGiver = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(careGiver.name),
                  subtitle: Text(careGiver.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareGiverDetailsPage(
                          name: careGiver.name,
                          email: careGiver.email,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    // Show pop-up menu for delete
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Care Giver?'),
                          content: Text('Are you sure you want to delete ${careGiver.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                print(careGiver.email);
                                await _firestore.collection('caregivers').doc(careGiver.email).delete();
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  Widget _buildDoctorsList() {
    return RefreshIndicator(
        onRefresh: _fetchData,
        color: Colors.blue, // Set the loading indicator color to blue
        child: FutureBuilder<List<Doctor>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No Doctors found.'));
      }
      return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
        Doctor doctor = snapshot.data![index];
        return Card(
            child: ListTile(
                title: Text(doctor.name),
                subtitle: Text(doctor.email),
                onTap: () {
                  // Navigate to DoctorDetailsPage and pass doctor details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsPage(
                        name: doctor.name,
                        email: doctor.email,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  // Show pop-up menu for delete
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Doctor?'),
                        content: Text('Are you sure you want to delete ${doctor.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await deleteDoctor(doctor.email); // Assuming you have a method to delete doctor
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
            ),
        );
          },
      );
        },
        ),
    );
  }




  void _showCareGiverDoctorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Register')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person_add, color: Colors.blue,),
                title: Text('Register Care Giver'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showRegisterCareGiverDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add, color: Colors.blue,),
                title: Text('Register Doctor'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showRegisterDoctorDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRegisterCareGiverDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);
    bool _obscurePassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Register Care Giver')),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Care Giver Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the care giver\'s name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String name = _nameController.text;
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      String? userId = await wardUserProvider.getCurrentUserId();
                      if (userId != null) {
                        WardModel? wardUser = await WardUserServices().getWard(userId);
                        if (wardUser != null) {
                          String? wardNumber = wardUser.wardNumber;
                          try {
                            await CareGiversService().addCareGiver(name, email, wardNumber, password);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Care Giver registered successfully')),
                            );
                            Navigator.of(context).pop();
                            setState(() {
                              _careGiversFuture = _fetchCareGivers(userId);
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: Ward information not available')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: User ID not available')),
                        );
                      }
                    }
                  },style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10.0),
                  ),
                ),
                  child: Text('Register',style: TextStyle(
                      color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRegisterDoctorDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _doctorsService = DoctorsService();
    final wardUserProvider = Provider.of<WardUserProvider>(context, listen: false);

    bool _obscurePassword = true;
    bool _isRegistering = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(child: Text('Register Doctor')),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Doctor Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the doctor\'s name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isRegistering ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isRegistering = true;
                          });

                          String? userId = await wardUserProvider.getCurrentUserId();

                          if (userId != null) {
                            WardModel? wardUser = await WardUserServices().getWard(userId);

                            if (wardUser != null) {
                              String? wardNumber = wardUser.wardNumber;

                              Doctor doctor = Doctor(
                                id: '',
                                name: _nameController.text,
                                email: _emailController.text,
                                wardNumber: wardNumber,
                                password: _passwordController.text,
                                aboutDoctor: '',
                                doctorContactNumber: '',
                                doctorImageUrl: '',
                              );

                              await _doctorsService.addDoctor(doctor);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Doctor registered successfully')),
                              );
                              Navigator.of(context).pop();
                              setState(() {
                                _doctorsFuture = _fetchDoctors(userId);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: Ward information not available')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: User ID not available')),
                            );
                          }

                          setState(() {
                            _isRegistering = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text('Register', style: TextStyle(
                          color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteCareGiver(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('caregivers').doc(uid).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Deleting Doctor.')),
      );
      throw e;
    }
  }

  Future<void> deleteDoctor(String email) async {
    try {
      await FirebaseFirestore.instance.collection('doctors').doc(email).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Deleting Care Giver.')),
      );
      throw e;
    }
  }
}
