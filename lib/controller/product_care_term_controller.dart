
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/user.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/care_guide_response.dart';
import 'package:jahit_baju_admin/data/remote/response/term_condition_response.dart';
import 'package:jahit_baju_admin/data/remote/response/users_response.dart';

class ProductCareTermController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;
  
  String? _term;
  String? get term => _term;


  ProductCareTermController(this.apiService);

  Future<void> fetchProductCareTerm() async {
    _errorMsg = null;
    if (_term == null) {
      _loading = true;
      notifyListeners();
      CareGuideResponse response = await apiService.getCareGuide();
      if (response.error) {
        _errorMsg =
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";        
        _loading = false;
        notifyListeners();
      } else {
        _term = response.data;
        _loading = false;
        notifyListeners();
      }
    }
  }

  updateProductCareTerm(String editedText) async {
    TermConditionResponse response = await apiService.updateProductCareTerm(editedText);
      if (response.error) {
        _errorMsg =
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";        
        _loading = false;
        notifyListeners();
      } else {
        _term = response.data;
        _loading = false;
        notifyListeners();
      }
  }

  void refresh() {
    _term = null;
    fetchProductCareTerm();
  }
}