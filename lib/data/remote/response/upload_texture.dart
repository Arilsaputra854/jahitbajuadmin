import 'package:jahit_baju_admin/data/model/texture.dart';

class UploadTextureResponse {
  final bool error;
  final String? message;
  final TextureLook? data;

  UploadTextureResponse({
    required this.error,
    this.message,
    this.data,
  });

  factory UploadTextureResponse.fromJson(Map<String, dynamic> json) {
    return UploadTextureResponse(
      error: json['error'] ?? true,
      message: json['message'],
      data: json['data'] != null ? TextureLook.fromJson(json['data']) : null,
    );
  }
}

