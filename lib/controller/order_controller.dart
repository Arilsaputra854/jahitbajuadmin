import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/order.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/data/model/user.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/look_response.dart';
import 'package:jahit_baju_admin/data/remote/response/order_response.dart';
import 'package:jahit_baju_admin/data/remote/response/product_response.dart';
import 'package:jahit_baju_admin/data/remote/response/users_response.dart';

class OrderController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool _loading = false;
  bool get loading => _loading;

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  Order? _currentOrder;
  Order? get currentOrder => _currentOrder;

  OrderController(this.apiService);

  void setCurrentOrder(Order newOrder) {
    _currentOrder = newOrder;
    notifyListeners();
  }

  Future<void> fetchAllOrder() async {
    if (_orders.isEmpty) {
      _loading = true;
      notifyListeners();
      OrdersResponse response = await apiService.getAllOrder();
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _orders = [];
        _loading = false;
        notifyListeners();
      } else {
        _orders = response.data!;
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<User?> getUserById(String id) async {
    UserResponse response = await apiService.getUserById(id);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      return null;
    } else {
      return response.user!;
    }
  }

  Future<Look?> getLookById(String id) async {
    LookResponse response = await apiService.getLookGetById(id);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      return null;
    } else {
      return response.look!;
    }
  }

  Future<Product?> getProductByid(String id) async {
    ProductResponse response = await apiService.productsGetById(id);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      return null;
    } else {
      return response.product!;
    }
  }

  Future<void> updateOrder(Order order) async {
    _errorMsg = null;
    OrderResponse response = await apiService.updateOrder(order);
    if (response.error) {
      _errorMsg =
          response.message ??
          "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
      _loading = false;
      refresh();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  refresh() {
    _orders = [];
    fetchAllOrder();
  }

  Future<String?> fetchSvg(String filename) async {
    _errorMsg = null;
  final url = Uri.parse('${ApiService.baseUrl}upload/$filename');

  try {
    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      _errorMsg = "Tidak dapat menemukan desain.";
      return null;
    }
  } catch (e) {
    _errorMsg = e.toString();
    notifyListeners();    
    return null;
  }
}

}
