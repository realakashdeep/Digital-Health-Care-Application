import 'package:flutter/material.dart';
import '../../models/doctors_model.dart';
import '../../services/doctor_services.dart';

class DoctorProvider extends ChangeNotifier {
  final DoctorsService _doctorService = DoctorsService();
  Doctor? _doctor;
  bool _isLoading = false;
  String _error = '';

  Doctor? get doctor => _doctor;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchDoctorByEmail(String email) async {
    try {
      _isLoading = true;
      _error = '';
      _doctor = await _doctorService.getDoctor(email);
      if (_doctor == null) {
        _error = 'Doctor not found';
      }
    } catch (e) {
      _error = 'Failed to fetch doctor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDoctor(Doctor doctor) async {
    try {
      _isLoading = true;
      _error = '';
      await _doctorService.addDoctor(doctor);
      _doctor = doctor; // Set the current doctor to the added doctor
    } catch (e) {
      _error = 'Failed to add doctor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDoctor(String email, Map<String, dynamic> updatedData) async {
    try {
      _isLoading = true;
      _error = '';
      await _doctorService.updateDoctor(email, updatedData);
      if (_doctor != null) {
        _doctor = Doctor(
          email: email,
          name: '',
          wardNumber: '',
          password: '',
          aboutDoctor: '',
          doctorContactNumber: '',
          doctorImageUrl: '',
        );
      }
    } catch (e) {
      _error = 'Failed to update doctor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDoctor(String email) async {
    try {
      _isLoading = true;
      _error = '';
      await _doctorService.deleteDoctor(email);
      _doctor = null; // Remove the current doctor after deletion
    } catch (e) {
      _error = 'Failed to delete doctor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
