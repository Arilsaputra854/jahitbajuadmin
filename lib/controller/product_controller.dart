import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:jahit_baju_admin/data/model/app_banner.dart';
import 'package:jahit_baju_admin/data/remote/response/upload_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/data/model/user.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/product_response.dart';

class ProductController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  List<Product> _products = [];
  List<Product> get products => _products;

  Product? _currentProduct;
  Product? get currentProduct => _currentProduct;

  ProductController(this.apiService);

  void fetchAllUser() {}

  void setCurrentProduct(Product newProduct) {
    _currentProduct = newProduct;
    notifyListeners();
  }

  Future<void> fetchAllProduct() async {
    _errorMsg = null;
    if (_products.isEmpty) {
      _loading = true;
      notifyListeners();
      ProductsResponse response = await apiService.productsGet();
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _products = [];
        _loading = false;
        notifyListeners();
      } else {
        _products = response.products!;
        _loading = false;
        notifyListeners();
      }
    }
  }

  removeProduct(Product product) async {
    _loading = true;
    _errorMsg = null;
    notifyListeners();
    RemoveProductResponse response = await apiService.productDelete(
      product.id!,
    );
    if (response.error && response.data == null) {
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

  addProduct(Product product) async {
    _errorMsg = null;
    ProductsResponse response = await apiService.addProduct(product);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _products = response.products!;
      _loading = false;
      _products = [];
      fetchAllProduct();
      notifyListeners();
    }
  }

  updateProduct(Product product) async {
    _errorMsg = null;
    ProductResponse response = await apiService.updateProduct(product);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      notifyListeners();
    } else {
      _currentProduct = response.product!;
      _loading = false;
      refresh();
      notifyListeners();
    }
  }

  void refresh() {
    _products = [];
    fetchAllProduct();
  }

  Future<List<String>> uploadImage(List<Uint8List> imageFiles) async {
    _errorMsg = null;
    List<String> images = [];
    for (int i = 0; i < imageFiles.length; i++) {
      var filename = generateProductImageFilename();

      UploadResponse response = await apiService.uploadProductImage(
        imageFiles[i],
        filename,
      );
      if (response.error) {
        _errorMsg = response.message;
        notifyListeners();
      } else {
        images.add(response.filename!);
      }
    }

    return images ?? [];
  }

  String generateProductImageFilename() {
    final random = Random().nextInt(100000); // random integer 0-99999
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    return 'product_image_${random}_$formattedDate.jpg';
  }

}
