import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/user.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/users_response.dart';

class CostumerController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  List<User> _users = [];
  List<User> get users => _users;

  User? _currentUser;
  User? get currentUser => _currentUser;

  CostumerController(this.apiService);

  Future<User?> getCurrentUser() async {
    UserResponse response = await apiService.userGet();
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      notifyListeners();
    } else {
      return response.user!;
    }
  }

  Future<void> fetchAllUser() async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    UsersResponse response = await apiService.getAllUser();
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
    } else {
      _users = response.users!;
    }

    _loading = false;
    notifyListeners();
  }

  void setCurrentCostumer(User newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  removeUser(User user) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    UserResponse response = await apiService.removeUser(user.id);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _users = [];
    } else {
      refresh();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> activateUser(User user) async {
    _errorMsg = null;
    _loading = true;
    UserResponse response = await apiService.activateUser(user.id);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _users = [];
    } else {
      refresh();
    }
    _loading = false;
    notifyListeners();
  }

  void refresh() {
    fetchAllUser();
  }
}
