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

  List<Packaging> _packaging = [];
  List<Packaging> get packaging => _packaging;

  Packaging? _currentPackaging;
  Packaging? get currentPackaging => _currentPackaging;

  int? _weight = 500; //in grams
  int? get weight => _weight;


  PackagingController(this.apiService);

  setCurrentPackaging(Packaging? newPackaging){
    _currentPackaging = newPackaging;
    notifyListeners();
  }

  Future<void> fetchAllPackaging() async {
    if (_packaging.isEmpty) {
      _loading = true;
      notifyListeners();
      PackagingResponse response = await apiService.getAllPackaging();
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _packaging = [];
        _loading = false;
        notifyListeners();
      } else {
        _packaging = response.packagings!;
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> addPackaging(String name, int price,  String description) async {
    PackagingResponse response =  await apiService.addPackaging( name, price, description);
      if(response.error){
         _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _loading = false;
        _packaging = [];
        fetchAllPackaging();
        notifyListeners();
      }else{
        _loading = false;
        notifyListeners();
      }
  }

  Future<void> removePackaging(String id) async {
    PackagingResponse response =  await apiService.removePackaging(id);
      if(response.error){
         _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _loading = false;
        _packaging = [];
        fetchAllPackaging();
        notifyListeners();
      }else{
        _loading = false;
        notifyListeners();
      }
  }

  Future<void> updatePackaging(String name, int price, String description) async {
    if(_currentPackaging != null){
      PackagingResponse response =  await apiService.updatePackaging(_currentPackaging!.id, name, price, description);
      if(response.error){
         _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _loading = false;
        _packaging = [];
        fetchAllPackaging();
        notifyListeners();
      }else{
        _loading = false;
        notifyListeners();
      }
    }
  }

}
