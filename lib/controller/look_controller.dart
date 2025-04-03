import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/designer_response.dart';
import 'package:http/http.dart' as http;
import 'package:jahit_baju_admin/data/remote/response/look_response.dart';

class LookController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  Designer? _designer;
  Designer? get designer => _designer;

  List<Look> _looks = [];
  List<Look> get looks => _looks;

  LookController(this.apiService);

  Future<void> addLook(Look look) async {
    _loading = true;
    _errorMsg = null;
    notifyListeners();
    LookResponse response = await apiService.addLook(look);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateLook(Look updatedProduct) async {
    _errorMsg = null;
    LookResponse response = await apiService.updateLook(updatedProduct);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String> fetchSvg(String _designUrl) async {
    _errorMsg = null;
    final response = await http.get(Uri.parse(_designUrl));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Gagal memuat SVG');
    }
  }

  Future<void> removeLook(Look look) async {
    _errorMsg = null;
    removeLookResponse response = await apiService.removeLook(look);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllLooks() async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    DesignerResponse response = await apiService.getDesignerById(
      _designer!.id!,
    );
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _looks = response.designer!.looks!;
      _loading = false;
      notifyListeners();
    }
  }

  void refresh() {
    _looks = [];
    fetchAllLooks();
  }

  void setDesigner(Designer? newDesigner) {
    _designer = newDesigner;
    notifyListeners();
  }
}
