import 'package:final_year_project/models/ward_model.dart';
import 'package:final_year_project/services/ward_user_services.dart';
import 'package:flutter/material.dart';

class WardUserProvider with ChangeNotifier {
  final WardUserServices _wardService = WardUserServices();

  WardModel? _user;

  WardModel? get user => _user;

  Future<void> fetchUser(String id) async {
    _user = await _wardService.getWard(id);
    notifyListeners();
  }

  Future<void> addUser(WardModel ward) async {
    await _wardService.createward(ward);
    fetchUser(ward.wardId); // Refresh the user
  }

  Future<void> updateUser(WardModel ward) async {
    await _wardService.updateward(ward);
    fetchUser(ward.wardId); // Refresh the user
  }

  Future<void> deleteUser(String id) async {
    await _wardService.deleteward(id);
    _user = null;
    notifyListeners();
  }

  Future<String?> getCurrentUserId() async {
    return await _wardService.getCurrentUserId();
  }

  Future<WardModel?> getWardByNumber(String wardNumber) async {
    _user = await _wardService.getUserByWardNumber(wardNumber);
    notifyListeners();
  }
}
