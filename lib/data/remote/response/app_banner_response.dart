
import 'package:jahit_baju_admin/data/model/app_banner.dart';

class getAppBannerResponse {
  bool error;
  String? message;
  List<AppBanner>? appBanner;

  getAppBannerResponse({
    required this.error,
    this.appBanner,    
    this.message,
  });

  factory getAppBannerResponse.fromJson(Map<String, dynamic> json) {
    return getAppBannerResponse(
      error: json['error'] ?? false,
      message: json['message'] != null ? json['data']['message'] : null,  
      appBanner: json['data'] != null ? (json['data'] as List).map((item) => AppBanner.fromJson(item)).toList() : null,  
    );
  }
}




class AppBannerResponse {
  bool error;
  String? message;
  AppBanner? appBanner;

  AppBannerResponse({
    required this.error,
    this.appBanner,    
    this.message,
  });

  factory AppBannerResponse.fromJson(Map<String, dynamic> json) {
    return AppBannerResponse(
      error: json['error'] ?? false,
      message: json['message'] != null ? json['data']['message'] : null,  
      appBanner: json['data'] != null ?AppBanner.fromJson(json['data']): null,  
    );
  }
}