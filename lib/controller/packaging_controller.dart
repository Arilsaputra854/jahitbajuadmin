import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/packaging.dart';
import 'package:jahit_baju_admin/data/model/shipping.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/packaging_response.dart';
import 'package:jahit_baju_admin/data/remote/response/shipping_response.dart';

class PackagingController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  List<Packaging> _packagings = [];
  List<Packaging> get packaging => _packagings;

  Packaging? _currentPackaging;
  Packaging? get currentPackaging => _currentPackaging;

  PackagingController(this.apiService);

  setCurrentPackaging(Packaging? newPackaging) {
    _currentPackaging = newPackaging;
    notifyListeners();
  }

  Future<void> fetchAllPackaging() async {
    if (_packagings.isEmpty) {
      _errorMsg = null;
      _loading = true;
      notifyListeners();

      PackagingsResponse response = await apiService.getAllPackaging();
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _packagings = [];
      } else {
        _packagings = response.packagings!;
      }
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addPackaging(String name, int price, String description) async {
    _errorMsg = null;
    PackagingResponse response = await apiService.addPackaging(
      name,
      price,
      description,
    );
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
    } else {
      refresh();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> removePackaging(String id) async {
    _errorMsg = null;
    PackagingResponse response = await apiService.removePackaging(id);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
    } else {
      refresh();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> updatePackaging(
    String name,
    int price,
    String description,
  ) async {
    if (_currentPackaging != null) {
      _errorMsg = null;
      PackagingResponse response = await apiService.updatePackaging(
        _currentPackaging!.id,
        name,
        price,
        description,
      );
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _loading = false;
      } else {
        refresh();
      }

      _loading = false;
      notifyListeners();
    }
  }

  void refresh() {
    _packagings = [];
    fetchAllPackaging();
  }
}
