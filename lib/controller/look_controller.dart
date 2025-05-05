import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/look_texture.dart';
import 'package:jahit_baju_admin/data/model/texture.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/designer_response.dart';
import 'package:http/http.dart' as http;
import 'package:jahit_baju_admin/data/remote/response/look_response.dart';
import 'package:jahit_baju_admin/data/remote/response/texture_response.dart';
import 'package:jahit_baju_admin/data/remote/response/upload_response.dart';
import 'package:jahit_baju_admin/data/remote/response/upload_texture.dart';

class LookController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  Designer? _designer;
  Designer? get designer => _designer;

  List<String> _materials = [];
  List<String> get materials => _materials;

  List<TextureLook> _textures = [];
  List<TextureLook> get textures => _textures;

  List<String> _features = [];
  List<String> get features => _features;

  List<String> _selectedSizes = [];
  List<String> get selectedSizes => _selectedSizes;

  List<Look> _looks = [];
  List<Look> get looks => _looks;

  LookController(this.apiService);

  void setSelectedSize(List<String>? newSelectedSize) {
    _selectedSizes = newSelectedSize ?? [];
    notifyListeners();
  }

  void setMaterials(List<String>? newMaterials) {
    _materials = newMaterials ?? [];
    notifyListeners();
  }

  void addMaterial(String newMaterial) {
    _materials.add(newMaterial);
    notifyListeners();
  }

  void removeMaterial(int index) {
    _materials.removeAt(index);
    notifyListeners();
  }

  Future<void> removeTexture(int index) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    RemoveTextureResponse response = await apiService.removeTexture(
      _textures[index].id!,
    );
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      _textures.removeAt(index);
      notifyListeners();
    }
  }

  void setFeatures(List<String>? newFeatures) {
    _features = newFeatures ?? [];
    notifyListeners();
  }

  void addFeature(String newFeature) {
    _features.add(newFeature);
    notifyListeners();
  }

  void removeFeature(int index) {
    _features.removeAt(index);
    notifyListeners();
  }

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
    _loading = true;
    notifyListeners();
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
  print('Mulai fetch SVG dari: $_designUrl');
  _errorMsg = null;

  try {
    final response = await http.get(Uri.parse(_designUrl));
    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final regex = RegExp(r'id="(.*?)"');
      final matches = regex.allMatches(response.body);

      _features = matches.map((m) => m.group(1)!).toList();
      print('Features ditemukan: $_features');
      return response.body;
    } else {
      _errorMsg = 'Gagal memuat SVG';
      print(_errorMsg);
      throw Exception(_errorMsg);
    }
  } catch (e) {
    _errorMsg = e.toString();
    print('Terjadi error: $_errorMsg');
    rethrow;
  }
}


  Future<void> removeLook(Look look) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
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
      _looks.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
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

  Future<String?> uploadImage(Uint8List imageFile) async {
    _loading = true;
    _errorMsg = null;
    notifyListeners();
    var filename = generateProductImageFilename();

    UploadResponse response = await apiService.uploadLookDesign(
      imageFile,
      filename,
    );
    if (response.error) {
      _errorMsg = response.message;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
      return response.filename!;
    }
  }

  Future<String?> uploadLookTexture(Uint8List imageFile) async {
    _loading = true;
    _errorMsg = null;
    notifyListeners();
    var filename = generateLookTextureFilename();

    UploadResponse response = await apiService.uploadLookTexture(
      imageFile,
      filename,
    );
    if (response.error) {
      _errorMsg = response.message;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
      return response.filename!;
    }
  }

  String generateProductImageFilename() {
    final random = Random().nextInt(100000); // random integer 0-99999
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    return 'look_design_${random}_$formattedDate.svg';
  }

  String generateLookTextureFilename() {
    final random = Random().nextInt(100000); // random integer 0-99999
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    return 'look_texture_${random}_$formattedDate.png';
  }

  Future<void> getTextures() async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    TexturesResponse response = await apiService.getTextures();

    if (response.error) {
      _errorMsg = response.message;
    } else {
      _textures = response.texture!;
    }
    _loading = false;
    notifyListeners();
  }

  Future<TextureLook?> uploadTexture(
    String lookId,
    String title,
    String desc, {
    String? hex,
    String? url_texture,
  }) async {
    UploadTextureResponse response = await apiService.uploadTexture(
      lookId,
      title,
      desc,
      hex,
      url_texture,
    );
    if (response.error) {
      _errorMsg = response.message;
      notifyListeners();
    } else {
      return response.data!;
    }
  }
}
