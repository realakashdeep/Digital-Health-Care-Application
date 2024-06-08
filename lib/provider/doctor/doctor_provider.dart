import 'package:flutter/material.dart';
import '../../models/doctors_model.dart';
import '../../services/doctor_services.dart';

class DoctorsProvider with ChangeNotifier {
  final DoctorsService _doctorsService = DoctorsService();
  List<Doctor> _doctors = [];
  bool _isLoading = false;

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;

  Future<void> fetchDoctorsByWardNumber(String wardNumber) async {
    try {
      _isLoading = true;
      notifyListeners();
      _doctors = await _doctorsService.getDoctorsByWardNumber(wardNumber);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDoctor(Doctor doctor) async {
    try {
      await _doctorsService.addDoctor(doctor);
      await fetchDoctorsByWardNumber(doctor.wardNumber);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      await _doctorsService.updateDoctor(doctor.email, doctor.toMap());
      await fetchDoctorsByWardNumber(doctor.wardNumber);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteDoctor(String email, String wardNumber) async {
    try {
      await _doctorsService.deleteDoctor(email);
      await fetchDoctorsByWardNumber(wardNumber);
    } catch (e) {
      print(e);
    }
  }
}
