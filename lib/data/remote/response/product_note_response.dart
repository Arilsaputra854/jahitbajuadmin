import 'package:jahit_baju_admin/data/model/note.dart';

class ProductNoteResponse {
  bool error;
  String? message;
  Note? data;

  ProductNoteResponse({
    required this.error,
    this.message,
    this.data
  });

  factory ProductNoteResponse.fromJson(Map<String, dynamic> json) {
    return ProductNoteResponse(
      error: json['error'] ?? false,
      message: json['message'],
      data: json['data'] != null? Note.fromJson(json['data']) : null,
    );
  }
}
