
import 'package:jahit_baju_admin/data/model/packaging.dart';

class PackagingResponse {
  bool error;
  String? message;
  List<Packaging>? packagings;

  PackagingResponse({
    required this.error,
    this.message,
    this.packagings
  });

  factory PackagingResponse.fromJson(Map<String, dynamic> json) {
    return PackagingResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? null,
      packagings: json['data'] != null
          ? (json['data'] as List).map((item) => Packaging.fromJson(item)).toList()
          : null,    
    );
  }
}

