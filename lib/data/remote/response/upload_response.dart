class UploadResponse {
  final bool error;
  final String message;
  final String? filename;
  final String? path;

  UploadResponse({
    required this.error,
    required this.message,
    this.filename,
    this.path,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      error: json['error'],
      message: json['message'],
      filename: json['file']?['filename'],
      path: json['file']?['path'],
    );
  }
}