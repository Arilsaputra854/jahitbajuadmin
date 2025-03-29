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
    RemoveProductResponse response = await apiService.productDelete(product.id!);
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
      _loading = false;refresh();
      notifyListeners();
    }
  }

  void refresh() {
    _products = [];
    fetchAllProduct();
  }
}
