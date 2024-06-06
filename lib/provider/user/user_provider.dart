import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_services.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  MyUser? _user;

  MyUser? get user => _user;

  Future<void> fetchUser(String id) async {
    _user = await _userService.getUser(id);
    notifyListeners();
  }

  Future<void> addUser(MyUser user) async {
    await _userService.createUser(user);
    fetchUser(user.userId);
  }

  Future<void> updateUser(MyUser user) async {

    await _userService.updateUser(user);
    fetchUser(user.userId);
  }

  Future<void> deleteUser(String id) async {
    await _userService.deleteUser(id);
    _user = null;
    notifyListeners();
  }

  Future<String?> getCurrentUserId() async {
    return await _userService.getCurrentUserId();
  }
}
