
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/user.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/term_condition_response.dart';
import 'package:jahit_baju_admin/data/remote/response/users_response.dart';

class PrivacyController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;
  
  String? _privacy;
  String? get privacy => _privacy;


  PrivacyController(this.apiService);

  Future<void> fetchPrivacy() async {
    _errorMsg = null;
    if (_privacy == null) {
      _loading = true;
      notifyListeners();
      TermConditionResponse response = await apiService.termCondition();
      if (response.error) {
        _errorMsg =
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";        
        _loading = false;
        notifyListeners();
      } else {
        _privacy = response.data;
        _loading = false;
        notifyListeners();
      }
    }
  }

  updatePrivacy(String editedText) async {
    TermConditionResponse response = await apiService.updateTermCondition(editedText);
      if (response.error) {
        _errorMsg =
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";        
        _loading = false;
        notifyListeners();
      } else {
        _privacy = response.data;
        _loading = false;
        notifyListeners();
      }
  }

  void refresh() {
    _privacy = null;
    fetchPrivacy();
  }
}