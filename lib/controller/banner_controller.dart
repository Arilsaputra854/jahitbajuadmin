import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jahit_baju_admin/data/model/app_banner.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/app_banner_response.dart';
import 'package:jahit_baju_admin/data/remote/response/texture_response.dart';
import 'package:jahit_baju_admin/data/remote/response/upload_response.dart';

class BannerController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  List<AppBanner> _appBanner = [];
  List<AppBanner> get appBanner => _appBanner;

  BannerController(this.apiService);

  Future<void> fetchAllBanner() async {
    if (_appBanner.isEmpty) {
      _errorMsg = null;
      _loading = true;
      notifyListeners();

      getAppBannerResponse response = await apiService.getAllAppBanner();
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _appBanner = [];
      } else {
        _appBanner = response.appBanner!;
      }
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> removeAppBanner(AppBanner banner) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    AppBannerResponse response = await apiService.removeAppBanner(banner);
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

  Future<void> updateBanner(AppBanner banner) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    AppBannerResponse response = await apiService.updateAppBanner(banner);
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

  void refresh() {
    _appBanner = [];
    fetchAllBanner();
  }

  Future<String?> uploadBanner(Uint8List bannerFile) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    var filename = generateProductImageFilename();

    UploadResponse response = await apiService.uploadAppBanner(
      bannerFile,
      filename,
    );
    if (response.error) {
      _errorMsg = response.message;
    } else {
      return response.filename;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addBanner(AppBanner newBanner) async {
    _errorMsg = null;
    _loading = true;
    notifyListeners();
    AppBannerResponse response = await apiService.addAppBanner(newBanner);
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

  String generateProductImageFilename() {
    final random = Random().nextInt(100000); // random integer 0-99999
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    return 'app_banner_image_${random}_$formattedDate.jpg';
  }
}
