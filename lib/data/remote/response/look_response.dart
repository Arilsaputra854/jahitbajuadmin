
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/packaging.dart';

class LookResponse {
  bool error;
  String? message;
  Look? look;

  LookResponse({
    required this.error,
    this.message,
    this.look
  });

  factory LookResponse.fromJson(Map<String, dynamic> json) {
    return LookResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? null,
      look: json['data'] != null
          ? Look.fromJson(json['data'])
          : null,    
    );
  }
}

class removeLookResponse {
  bool error;
  String? message;
  removeLookResponse({
    required this.error,
    this.message,
  });

  factory removeLookResponse.fromJson(Map<String, dynamic> json) {
    return removeLookResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? null,
    );
  }
}



