
import 'package:jahit_baju_admin/data/model/packaging.dart';

class PackagingsResponse {
  bool error;
  String? message;
  List<Packaging>? packagings;

  PackagingsResponse({
    required this.error,
    this.message,
    this.packagings
  });

  factory PackagingsResponse.fromJson(Map<String, dynamic> json) {
    return PackagingsResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? null,
      packagings: json['data'] != null
          ? (json['data'] as List).map((item) => Packaging.fromJson(item)).toList()
          : null,    
    );
  }
}

class PackagingResponse {
  bool error;
  String? message;
  Packaging? packaging;

  PackagingResponse({
    required this.error,
    this.message,
    this.packaging
  });

  factory PackagingResponse.fromJson(Map<String, dynamic> json) {
    return PackagingResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? null,
      packaging: json['data'] != null
          ? Packaging.fromJson(json['data'])
          : null,    
    );
  }
}
