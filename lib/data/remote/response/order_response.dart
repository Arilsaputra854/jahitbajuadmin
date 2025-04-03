import 'package:jahit_baju_admin/data/model/order.dart';

class OrdersResponse {
  bool error;
  String? message;
  List<Order>? data;

  OrdersResponse({
    required this.error,
    this.message,
    this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      error: json['error'] ?? false,
      message: json['message'],
      data: json['data'] != null ?  (json['data'] as List).map((item) => Order.fromJson(item)).toList() : null,
    );
  }
}

class OrderResponse {
  bool error;
  String? message;
  Order? data;

  OrderResponse({
    required this.error,
    this.message,
    this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      error: json['error'] ?? false,
      message: json['message'],
      data: json['data'] != null?  Order.fromJson(json['data']) : null,
    );
  }
}

