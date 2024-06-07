import 'package:flutter/material.dart';

class CareGiverProfile extends StatefulWidget {
  @override
  _CareGiverProfileState createState() => _CareGiverProfileState();
}
class _CareGiverProfileState extends State<CareGiverProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Caregiver\'s profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        )
    );
  }
}