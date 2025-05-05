
import 'package:jahit_baju_admin/data/model/texture.dart';

class TexturesResponse {
  bool error;
  String? message;
  List<TextureLook>? texture;

  TexturesResponse({
    required this.error,
    this.texture,    
    this.message,
  });

  factory TexturesResponse.fromJson(Map<String, dynamic> json) {
    return TexturesResponse(
      error: json['error'] ?? false,
      message: json['message'] != null ? json['message'] : null,  
      texture: json['data'] != null
        ? (json['data'] as List).map((item) => TextureLook.fromJson(item)).toList()
        : null,  
    );
  }
}


class RemoveTextureResponse {
  bool error;
  String? message;
  String? data;

  RemoveTextureResponse({
    required this.error,
    this.data,    
    this.message,
  });

  factory RemoveTextureResponse.fromJson(Map<String, dynamic> json) {
    return RemoveTextureResponse(
      error: json['error'] ?? false,
      message: json['message'] != null ? json['data']['message'] : null,  
      data: json['data'] != null ? json['data'] : null,  
    );
  }
}

