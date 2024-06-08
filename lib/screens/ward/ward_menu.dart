import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:final_year_project/dump/populate.dart';
import 'package:final_year_project/screens/ward/bar_graph.dart';
import 'package:final_year_project/screens/ward/profile/ward_profile.dart';
import 'package:final_year_project/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/doctors_model.dart';
import '../../models/ward_model.dart';
import '../../provider/ward/ward_auth_provider.dart';
import '../../provider/ward/ward_user_provider.dart';
import '../../services/CareGiversService.dart';
import '../../services/doctor_services.dart';
import '../../services/ward_user_services.dart';
import 'CurrentCampsPage.dart';
import 'RegisterUserPage.dart';
import 'ward_user_list.dart';


class WardMenuPage extends StatefulWidget {
  @override
  State<WardMenuPage> createState() => _WardMenuPageState();
}

class _WardMenuPageState extends State<WardMenuPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ward Menu'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double gridSpacing = constraints.maxWidth * 0.05;
            double gridPadding = constraints.maxWidth * 0.1;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: gridSpacing, horizontal: gridPadding),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: constraints.maxWidth < 600 ? 2 : 3,
                      crossAxisSpacing: gridSpacing,
                      mainAxisSpacing: gridSpacing,
                      children: <Widget>[
                        buildMenuButton(
                          context,
                          'Register New User',
                          'assets/add_user.svg',
                          RegisterUserPage(),
                        ),
                        buildMenuButton(
                          context,
                          'Camps Details',
                          'assets/camp.svg',
                          CurrentCampsPage(),
                        ),
                        buildMenuButtonWithIcon(
                          context,
                          'View And Update Ward Details',
                          Icons.local_hospital,
                          WardProfilePage(),
                        ),
                        buildMenuButtonWithIcon(
                          context,
                          'Populate',
                          Icons.list_alt,
                          Populate(),
                        ),
                        buildMenuButtonWithIcon(
                          context,
                          'User Registration Report',
                          Icons.list_alt,
                          WardUserList(),
                        ),
                        buildMenuButtonWithIcon(
                          context,
                          'Monthly User Registration Bar Graph',
                          Icons.list_alt,
                          BarGraphReport(),
                        ),
                        buildMenuButtonWithIcon(
                          context,
                          'Register Care Giver/Doctor',
                          Icons.medical_information,
                          null,
                          onTap: () => _showCareGiverDoctorDialog(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 34.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            _showLogoutConfirmationDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
          ),
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.logout,
              color: Colors.white,
              size: 24,
            ),
          ),
          label: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }

  Widget buildMenuButton(BuildContext context, String label, String assetPath, Widget? page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.25; // Increased icon size factor
        double textSize = constraints.maxWidth * 0.10; // Increased text size factor

        return ElevatedButton(
          onPressed: () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                assetPath,
                color: Colors.white,
                width: iconSize,
                height: iconSize,
              ),
              const SizedBox(height: 8.0),
              Text(
                label,
                style: TextStyle(fontSize: textSize, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMenuButtonWithIcon(BuildContext context, String label, IconData icon, Widget? page, {VoidCallback? onTap}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.25; // Increased icon size factor
        double textSize = constraints.maxWidth * 0.10; // Increased text size factor

        return ElevatedButton(
          onPressed: onTap ?? () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: iconSize,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Text(
                label,
                style: TextStyle(fontSize: textSize, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
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
                leading: Icon(Icons.person_add),
                title: Text('Register Care Giver'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showRegisterCareGiverDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add),
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
    final _passwordController = TextEditingController(); // Add controller for password field
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
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
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

                      // generating wardNumber
                      String? userId = await wardUserProvider.getCurrentUserId();
                      if (userId != null) {
                        WardModel? wardUser = await WardUserServices().getWard(userId);

                        if (wardUser != null) {
                          String? wardNumber = wardUser.wardNumber;


                          try {
                            // Call the service method to add the care giver to Firestore
                            await CareGiversService().addCareGiver(name, email, wardNumber, _passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Care Giver registered successfully')),
                            );
                            Navigator.of(context).pop();
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
                  },
                  child: Text('Register'),
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
    bool _isRegistering = false; // Flag to track registration process

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
                      onPressed: _isRegistering // Disable button if already registering
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isRegistering = true; // Set flag to true when registration starts
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
                            _isRegistering = false; // Reset flag when registration completes
                          });
                        }
                      },
                      child: Text('Register'),
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



  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Are you sure you want to log out?', style: TextStyle(fontSize: 20, color: Colors.black)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.blue,
              ),
              child: Text('No', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await Provider.of<WardAuthProvider>(context, listen: false).signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.redAccent,
              ),
              child: Text('Yes', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  String _encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
