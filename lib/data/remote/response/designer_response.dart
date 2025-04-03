

import 'package:jahit_baju_admin/data/model/designer.dart';

class DesignersResponse {
  bool error;
  String? message;
  List<Designer>? data;

  DesignersResponse({
    required this.error,
    this.data,    
    this.message,
  });

  factory DesignersResponse.fromJson(Map<String, dynamic> json) {
    return DesignersResponse(
      error: json['error'] ?? false,
      message: json['message'],  
      data: json['data'] != null
          ? (json['data'] as List).map((item) => Designer.fromJson(item)).toList()
          : null,    
    );
  }
}


class DesignerResponse {
  bool error;
  String? message;
  Designer? designer;

  DesignerResponse({
    required this.error,
    this.message,    
    this.designer,
  });

  factory DesignerResponse.fromJson(Map<String, dynamic> json) {
    return DesignerResponse(
      error: json['error'] ?? false,
      message: json['message'],  
      designer: json['data'] != null
          ? Designer.fromJson(json['data'])
          : null,    
    );
  }
}



class AddDesignerResponse {
  bool error;
  String? message;
  Designer? data;

  AddDesignerResponse({
    required this.error,
    this.data,    
    this.message,
  });

  factory AddDesignerResponse.fromJson(Map<String, dynamic> json) {
    return AddDesignerResponse(
      error: json['error'] ?? false,
      message: json['message'],  
      data: json['data'] != null
          ? Designer.fromJson(json['data'])
          : null,    
    );
  }
}



class RemoveDesignerResponse {
  bool error;
  String? message;
  String? data;

  RemoveDesignerResponse({
    required this.error,
    this.data,    
    this.message,
  });

  factory RemoveDesignerResponse.fromJson(Map<String, dynamic> json) {
    return RemoveDesignerResponse(
      error: json['error'] ?? false,
      message: json['message'],  
      data: json['data'],
    );
  }
}


