import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/designer_response.dart';

class DesignerController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  List<Designer> _designers = [];
  List<Designer> get designers => _designers;

  DesignerController(this.apiService);

  Future<void> fetchAllDesigners() async {
    _errorMsg = null;
    if (_designers.isEmpty) {
      _loading = true;
      notifyListeners();
      DesignerResponse response = await apiService.getDesigner();
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _designers = [];
        _loading = false;
        notifyListeners();
      } else {
        _designers = response.data!;
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> addDesigner(Designer designer) async {
    _errorMsg = null;
    AddDesignerResponse response = await apiService.addDesigner(designer);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      refresh();
      _loading = false;
      notifyListeners();
    }
  }

  void refresh() {
    _designers = [];
    fetchAllDesigners();
  }

  Future<void> removeDesigner(Designer designer) async {
    _errorMsg = null;
    RemoveDesignerResponse response = await apiService.removeDesigner(designer);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      refresh();
      _loading = false;
      notifyListeners();
    }
  }
}
