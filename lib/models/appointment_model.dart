import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {

  String appointmentId;
  String appointmentDate;
  String patientId;
  String patientName;
  String bp;
  String temp;
  String heartRate;
  String spO2;
  String assignedTo;

  String doctorMail;

  String careMail;
  String wardNumber;

  String status;
  String symptoms;
  String prescriptions;
  String tests;


  AppointmentModel({
    required this.appointmentId,
    required this.appointmentDate,
    required this.patientId,
    required this.patientName,
    required this.bp,
    required this.temp,
    required this.heartRate,
    required this.spO2,
    required this.assignedTo,
    required this.doctorMail,
    required this.symptoms,
    required this.status,
    required this.prescriptions,
    required this.tests,
    required this.careMail,
    required this.wardNumber
  });

  static AppointmentModel empty() => AppointmentModel(
      appointmentId : '',
      appointmentDate : '',
      patientId : '',
      assignedTo : '',
      bp: '',
      temp: '',
      heartRate: '',
      spO2: '',
      status: '',
      prescriptions: '',
      tests: '',
      patientName: '',
      symptoms: '',
      doctorMail: '',
      careMail: '',
      wardNumber: ''
  );

  Map<String, dynamic> toJson() {
    return {
      'appointmentId' : appointmentId,
      'appointmentDate' : appointmentDate,
      'patientId' : patientId,
      'assignedTo' : assignedTo,
      'bp' : bp,
      'temp' : temp,
      'heartRate' : heartRate,
      'spO2' : spO2,
      'status' : status,
      'prescriptions' : prescriptions,
      'tests' : tests,
      'patientName' : patientName,
      'symptoms' : symptoms,
      'doctorMail' : doctorMail,
      'careMail' : careMail,
      'wardNumber' : wardNumber

    };
  }

  factory AppointmentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AppointmentModel(
          appointmentId: document.id,
          appointmentDate: data['appointmentDate'] ?? '',
          patientId: data['patientId'] ?? '',
          assignedTo: data['assignedTo'] ?? '',
          bp: data['bp'] ?? '',
          temp: data['temp'] ?? '',
          heartRate: data['heartRate'] ?? '',
          spO2: data['spO2'] ?? '',
          status: data['status'] ?? '',
          prescriptions: data['prescriptions'] ?? '',
          tests: data['tests'] ?? '',
          patientName: data['patientName'] ?? '',
          symptoms: data['symptoms'] ?? '',
          doctorMail: data['doctorMail'] ?? '',
          careMail: data['careMail'] ?? '',
          wardNumber: data['wardNumber'] ?? ''
      );
    } else {
      return AppointmentModel.empty();
    }
  }
}
