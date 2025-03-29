import 'package:jahit_baju_admin/data/model/user.dart';

class UsersResponse {
  bool error;
  String? message;
  List<User>? users;

  UsersResponse({required this.error, this.message, this.users});

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? null,
      users:
          json['data'] != null
              ? (json['data'] as List)
                  .map((item) => User.fromJson(item))
                  .toList()
              : null,
    );
  }
}


class UserResponse {
  bool error;
  String? message;
  User? user;

  UserResponse({required this.error, this.message, this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? null,
      user:
          json['data'] != null
              ? User.fromJson(json['data'])
              : null,
    );
  }
}
