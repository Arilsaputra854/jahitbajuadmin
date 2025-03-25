
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahit_baju_admin/data/remote/response/login_response.dart';
import 'package:logger/logger.dart';

class ApiService {
  final String baseUrl = "https://v1.jahitbajuofficial.com/api/";
  
  
  Logger logger = Logger();
  final BuildContext context;

  static const String SOMETHING_WAS_WRONG =
      "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
  static const String SOMETHING_WAS_WRONG_SERVER =
      "Maaf, terjadi kesalahan pada server kami, Silakan coba lagi nanti.";
  static const String NO_INTERNET_CONNECTION = "Tidak ada koneksi internet.";
  static const String UNAUTHORIZED = "Tidak ada koneksi internet.";

  ApiService(this.context);

  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse("${baseUrl}users/login");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
      );

      var data = jsonDecode(response.body);
      logger.d("Login : $data");
      LoginResponse responseBody = LoginResponse.fromJson(data);

      return responseBody;
    } on SocketException catch (e) {

      logger.e("Login : Tidak ada koneksi internet");

      return LoginResponse(error: true);
    } catch (e, stackTrace) {
     logger.e("Login : $e");
      return LoginResponse(message: "Network error : $e", error: true);
    }
  }
}