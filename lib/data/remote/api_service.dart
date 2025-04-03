import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/note.dart';
import 'package:jahit_baju_admin/data/model/order.dart';
import 'package:jahit_baju_admin/data/model/packaging.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/data/remote/response/care_guide_response.dart';
import 'package:jahit_baju_admin/data/remote/response/city_response.dart';
import 'package:jahit_baju_admin/data/remote/response/designer_response.dart';
import 'package:jahit_baju_admin/data/remote/response/login_response.dart';
import 'package:jahit_baju_admin/data/remote/response/look_response.dart';
import 'package:jahit_baju_admin/data/remote/response/order_response.dart';
import 'package:jahit_baju_admin/data/remote/response/packaging_response.dart';
import 'package:jahit_baju_admin/data/remote/response/product_note_response.dart';
import 'package:jahit_baju_admin/data/remote/response/product_response.dart';
import 'package:jahit_baju_admin/data/remote/response/shipping_response.dart';
import 'package:jahit_baju_admin/data/remote/response/term_condition_response.dart';
import 'package:jahit_baju_admin/data/remote/response/users_response.dart';
import 'package:jahit_baju_admin/util/token_storage.dart';
import 'package:logger/logger.dart';

class ApiService {
  final String baseUrl = "https://v1.jahitbajuofficial.com/api/";
  //final String baseUrl = "https://bonefish-supreme-sculpin.ngrok-free.app/api/";

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
    final url = Uri.parse("${baseUrl}admin/login");

    try {
      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{"Content-Type": "application/json"},
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

  Future<ShippingsResponse> getAllShipping(
    int totalWeight,
    String origin,
    String destination,
  ) async {
    final url = Uri.parse("${baseUrl}shippings");
    var token = await SecureStorage.getToken();

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode(<String, dynamic>{
          'total_weight': totalWeight,
          'origin': origin,
          'destination': destination,
        }),
      );

      var data = jsonDecode(response.body);
      logger.d("Shipping Get : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ShippingsResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return ShippingsResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return ShippingsResponse(error: true, message: UNAUTHORIZED);
      } else {
        return ShippingsResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Shipping Get : Tidak ada koneksi internet");
      return ShippingsResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Shipping Get : $e");
      return ShippingsResponse(error: true, message: e.toString());
    }
  }

  Future<PackagingResponse> getAllPackaging() async {
    final url = Uri.parse("${baseUrl}packaging");
    var token = await SecureStorage.getToken();

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      var data = jsonDecode(response.body);
      logger.d("Packaging Get : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PackagingResponse.fromJson(data);
      } else {
        return PackagingResponse.fromJson(data);
      }
    } on SocketException catch (e) {
      logger.e("Packaging Get : Tidak ada koneksi internet");
      return PackagingResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Packaging Get : $e");
      return PackagingResponse(error: true, message: e.toString());
    }
  }

  Future<PackagingResponse> updatePackaging(
    String id,
    String name,
    int price,
    String description,
  ) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}packaging?id=${id}");

    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );

      var data = jsonDecode(response.body);
      logger.d("Packaging Update : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PackagingResponse.fromJson(data);
      } else {
        return PackagingResponse.fromJson(data);
      }
    } on SocketException catch (e) {
      logger.e("Packaging Update : Tidak ada koneksi internet");
      return PackagingResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Packaging Update : $e");
      return PackagingResponse(error: true, message: e.toString());
    }
  }

  Future<PackagingResponse> addPackaging(
    String name,
    int price,
    String description,
  ) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}packaging");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );

      var data = jsonDecode(response.body);
      logger.d("Packaging Add : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PackagingResponse.fromJson(data);
      } else {
        return PackagingResponse.fromJson(data);
      }
    } on SocketException catch (e) {
      logger.e("Packaging Add : Tidak ada koneksi internet");
      return PackagingResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Packaging Add : $e");
      return PackagingResponse(error: true, message: e.toString());
    }
  }

  Future<PackagingResponse> removePackaging(String id) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}packaging?id=${id}");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      var data = jsonDecode(response.body);
      logger.d("Packaging Delete : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PackagingResponse.fromJson(data);
      } else {
        return PackagingResponse.fromJson(data);
      }
    } on SocketException catch (e) {
      logger.e("Packaging Delete : Tidak ada koneksi internet");
      return PackagingResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Packaging Delete : $e");
      return PackagingResponse(error: true, message: e.toString());
    }
  }

  Future<ProductsResponse> productsGet() async {
    final url = Uri.parse("${baseUrl}products");

    try {
      final response = await http.get(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      var data = jsonDecode(response.body);

      logger.d("Get Product : ${data["data"]}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductsResponse.fromJson(data);
      } else {
        return ProductsResponse(error: false, message: data["message"]);
      }
    } on SocketException catch (e) {
      logger.e("Get Product : Tidak ada koneksi internet");

      return ProductsResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("Get Product : ${e}");
      return ProductsResponse(error: true, message: e.toString());
    }
  }

  Future<ProductsResponse> addProduct(Product product) async {
    final url = Uri.parse("${baseUrl}products");
    var token = await SecureStorage.getToken();

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'stock': product.stock,
          'type': 1,
          'images_url': product.imageUrl,
          'tags': product.tags,
          'category': product.category,
          'size': product.size,
        }),
      );

      var data = jsonDecode(response.body);

      logger.d("Add Product : ${data["data"]}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductsResponse.fromJson(data);
      } else {
        return ProductsResponse(error: false, message: data["message"]);
      }
    } on SocketException catch (e) {
      logger.e("Add Product : Tidak ada koneksi internet");

      return ProductsResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("Add Product : ${e}");
      return ProductsResponse(error: true, message: e.toString());
    }
  }

  Future<RemoveProductResponse> productDelete(String id) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}products/${id}");

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );
      logger.d("Response Body : ${response.body}"); // Tambahkan log ini

      var data = jsonDecode(response.body);

      logger.d("Delete Product : ${data}");

      return RemoveProductResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("Delete Product : Tidak ada koneksi internet");

      return RemoveProductResponse(
        message: NO_INTERNET_CONNECTION,
        error: true,
      );
    } catch (e, stackTrace) {
      logger.e("Delete Product : ${e}");

      return RemoveProductResponse(error: true, message: e.toString());
    }
  }

  Future<ProductResponse> updateProduct(Product product) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}products/${product.id}");

    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'stock': product.stock,
          'type': 1,
          'images_url': product.imageUrl,
          'materials': product.materials,
          'tags': product.tags,
          'category': product.category,
          'size': product.size,
        }),
      );
      logger.d("Response Body : ${response.body}"); // Tambahkan log ini

      var data = jsonDecode(response.body);

      logger.d("Update Product : ${data}");

      return ProductResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("Update Product : Tidak ada koneksi internet");

      return ProductResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("Update Product : ${e}");

      return ProductResponse(error: true, message: e.toString());
    }
  }

  Future<DesignersResponse> getDesigner() async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer");

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );
    try {
      var data = jsonDecode(response.body);
      logger.d("Get Designer : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DesignersResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return DesignersResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return DesignersResponse(error: true, message: UNAUTHORIZED);
      } else {
        return DesignersResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Get Designer : Tidak ada koneksi internet");
      return DesignersResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Get Designer :  $e");
      return DesignersResponse(error: true, message: e.toString());
    }
  }

  Future<AddDesignerResponse> addDesigner(Designer designer) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer");

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode({
        'name': designer.name,
        'description': designer.description,
      }),
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("ad Designer : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddDesignerResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return AddDesignerResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return AddDesignerResponse(error: true, message: UNAUTHORIZED);
      } else {
        return AddDesignerResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Get Designer : Tidak ada koneksi internet");
      return AddDesignerResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Get Designer :  $e");
      return AddDesignerResponse(error: true, message: e.toString());
    }
  }

  Future<RemoveDesignerResponse> removeDesigner(Designer designer) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer?id=${designer.id}");

    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("remove Designer : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RemoveDesignerResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return RemoveDesignerResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return RemoveDesignerResponse(error: true, message: UNAUTHORIZED);
      } else {
        return RemoveDesignerResponse(
          error: true,
          message: SOMETHING_WAS_WRONG,
        );
      }
    } on SocketException catch (e) {
      logger.e("remove Designer : Tidak ada koneksi internet");
      return RemoveDesignerResponse(
        error: true,
        message: NO_INTERNET_CONNECTION,
      );
    } catch (e, stackTrace) {
      logger.e("remove Designer :  $e");
      return RemoveDesignerResponse(error: true, message: e.toString());
    }
  }

  Future<LookResponse> addLook(Look look) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer/look");

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode({
        'designer_id': look.designerId,
        'design_url': look.designUrl,
        'features': look.features,
        'materials': look.materials,
        'size': look.size,
        'price': look.price,
        'look_price': look.lookPrice,
        'name': look.name,
        'weight': look.weight,
        'description': look.description,
      }),
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("Add look : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LookResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return LookResponse(error: true, message: SOMETHING_WAS_WRONG_SERVER);
      } else if (response.statusCode == 401) {
        return LookResponse(error: true, message: UNAUTHORIZED);
      } else {
        return LookResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Add look : Tidak ada koneksi internet");
      return LookResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Add look :  $e");
      return LookResponse(error: true, message: e.toString());
    }
  }

  Future<removeLookResponse> removeLook(Look look) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer/look?id=${look.id}");

    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("Remove look : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return removeLookResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return removeLookResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return removeLookResponse(error: true, message: UNAUTHORIZED);
      } else {
        return removeLookResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Remove look : Tidak ada koneksi internet");
      return removeLookResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Remove look :  $e");
      return removeLookResponse(error: true, message: e.toString());
    }
  }

  Future<CityResponse> getListCity() async {
    final url = Uri.parse("${baseUrl}shipping/cities");
    final response = await http.get(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    try {
      var data = jsonDecode(response.body);

      logger.d("get city response : ${data}");

      return CityResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("get city response : Tidak ada koneksi internet");

      return CityResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("get city response : $e");
      return CityResponse(error: true, message: "Network error : $e");
    }
  }

  Future<UserResponse> getUserById(String id) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}users/${id}");
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);

      logger.d("get user response : ${data}");

      return UserResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("get user response : Tidak ada koneksi internet");

      return UserResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("get user response : $e");
      return UserResponse(error: true, message: "Network error : $e");
    }
  }

  Future<UsersResponse> getAllUser() async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}users");
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);

      logger.d("get all user response : ${data}");

      return UsersResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("get all user response : Tidak ada koneksi internet");

      return UsersResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("get all user response : $e");
      return UsersResponse(error: true, message: "Network error : $e");
    }
  }

  Future<UserResponse> removeUser(String id) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}users/${id}");
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);

      logger.d("remove user response : ${data}");

      return UserResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("remove user response : Tidak ada koneksi internet");

      return UserResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("remove user response : $e");
      return UserResponse(error: true, message: "Network error : $e");
    }
  }

  Future<TermConditionResponse> termCondition() async {
    final url = Uri.parse("${baseUrl}term-condition");
    final response = await http.get(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    try {
      var data = jsonDecode(response.body);

      logger.d("Term Condition : ${data}");
      return TermConditionResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("Get Favorite : Tidak ada koneksi internet");
      return TermConditionResponse(error: true, data: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Term Condition : $e");
      return TermConditionResponse(error: true, data: e.toString());
    }
  }

  Future<TermConditionResponse> updateTermCondition(String data) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}term-condition");
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode({'data': data}),
    );

    try {
      var data = jsonDecode(response.body);

      logger.d("update Term Condition : ${data}");
      return TermConditionResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("update Term Condition : Tidak ada koneksi internet");
      return TermConditionResponse(error: true, data: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("update Term Condition : $e");
      return TermConditionResponse(error: true, data: e.toString());
    }
  }

  Future<CareGuideResponse> getCareGuide() async {
    final url = Uri.parse("${baseUrl}care-guide");
    final response = await http.get(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("Care Guide : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CareGuideResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return CareGuideResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else {
        return CareGuideResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Care Guide :  Tidak ada koneksi internet");
      return CareGuideResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Care Guide :  $e");
      return CareGuideResponse(error: true, message: e.toString());
    }
  }

  Future<CareGuideResponse> updateProductCareTerm(String editedText) async {
    final url = Uri.parse("${baseUrl}care-guide");
    var token = await SecureStorage.getToken();
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode({'data': editedText}),
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("Update Care Guide : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CareGuideResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return CareGuideResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else {
        return CareGuideResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Update Care Guide :  Tidak ada koneksi internet");
      return CareGuideResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Update Care Guide :  $e");
      return CareGuideResponse(error: true, message: e.toString());
    }
  }

  Future<ProductNoteResponse> getNoteProduct(int type) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}product-note?type=${type}");

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("Get Product Note : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductNoteResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return ProductNoteResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return ProductNoteResponse(error: true, message: UNAUTHORIZED);
      } else {
        return ProductNoteResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Get Product Note : Tidak ada koneksi internet");
      return ProductNoteResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Get Product Note  :  $e");
      return ProductNoteResponse(error: true, message: e.toString());
    }
  }

  Future<ProductNoteResponse> updateNoteProduct(Note note) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}product-notes");

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode({'id': note.id, 'data': note.data}),
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("update Product Note : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductNoteResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return ProductNoteResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return ProductNoteResponse(error: true, message: UNAUTHORIZED);
      } else {
        return ProductNoteResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("update Product Note : Tidak ada koneksi internet");
      return ProductNoteResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("update Product Note  :  $e");
      return ProductNoteResponse(error: true, message: e.toString());
    }
  }

  Future<DesignerResponse> getDesignerById(String id) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer?id=${id}");

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);
      logger.d("Get Designer by Id : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DesignerResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return DesignerResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        return DesignerResponse(error: true, message: UNAUTHORIZED);
      } else {
        return DesignerResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Get Designer by Id :  Tidak ada koneksi internet");
      return DesignerResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Get Designer by Id :  $e");
      return DesignerResponse(error: true, message: e.toString());
    }
  }

  Future<LookResponse> updateLook(Look updatedLook) async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer/look?id=${updatedLook.id}");

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode({
        'designer_id': updatedLook.designerId,
        'name': updatedLook.name,
        'features': updatedLook.features,
        'materials': updatedLook.materials,
        'price': updatedLook.price,
        'look_price': updatedLook.lookPrice,
        'design_url': updatedLook.designUrl,
        'description': updatedLook.description,
        'size': updatedLook.size,
        'sold': updatedLook.sold,
        'seen': updatedLook.seen,
        'weight': updatedLook.weight,
      }),
    );
    try {
      var data = jsonDecode(response.body);
      logger.d("Update Look : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LookResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return LookResponse(error: true, message: SOMETHING_WAS_WRONG_SERVER);
      } else if (response.statusCode == 401) {
        return LookResponse(error: true, message: UNAUTHORIZED);
      } else {
        return LookResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Update Look : Tidak ada koneksi internet");
      return LookResponse(error: true, message: NO_INTERNET_CONNECTION);
    } catch (e, stackTrace) {
      logger.e("Update Look : $e");
      return LookResponse(error: true, message: e.toString());
    }
  }

  Future<OrdersResponse> getAllOrder() async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}orders");
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    try {
      var data = jsonDecode(response.body);

      logger.d("Get All Order : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrdersResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        return OrdersResponse(error: true, message: SOMETHING_WAS_WRONG_SERVER);
      } else if (response.statusCode == 401) {
        return OrdersResponse(error: true, message: UNAUTHORIZED);
      } else {
        return OrdersResponse(error: true, message: SOMETHING_WAS_WRONG);
      }
    } on SocketException catch (e) {
      logger.e("Get All Order : Tidak ada koneksi internet");
      return OrdersResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("Get All Order : ${e}");
      return OrdersResponse(error: true, message: "Network error : $e");
    }
  }

  Future<ProductResponse> productsGetById(String productId) async {
    final url = Uri.parse("${baseUrl}products?id=$productId");
    var token = await SecureStorage.getToken();

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      var data = jsonDecode(response.body);

      logger.d("Get Product by ID : ${data}");

      ProductResponse productResponse = ProductResponse.fromJson(data);
      return productResponse;
    } on SocketException catch (e) {
      logger.e("Get Product by ID : Tidak ada koneksi internet");

      return ProductResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("Get Product by ID : ${e}");
      return ProductResponse(
        error: true,
        message: "Network error : $e",
        product: null,
      );
    }
  }

  Future<LookResponse> getLookGetById(String lookId) async {
    final url = Uri.parse("${baseUrl}designer/look?id=$lookId");
    var token = await SecureStorage.getToken();

    try {
      final response = await http
          .get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${token}',
            },
          )
          .timeout(Duration(seconds: 10));

      var data = jsonDecode(response.body);

      logger.d("Get Look by ID : ${data}");

      return LookResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("Get Look by ID : Tidak ada koneksi internet");

      return LookResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("Get Look by ID : ${e}");
      return LookResponse(error: true, message: SOMETHING_WAS_WRONG);
    }
  }

  Future<OrderResponse> updateOrder(Order order) async {
    final url = Uri.parse("${baseUrl}order/${order.id}");
    var token = await SecureStorage.getToken();

    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode({
          'buyer_id': order.buyerId,
          'shipping_id': order.shippingId,
          'packaging_id': order.packagingId,
          'cart_id': order.cartId,
          'total_price': order.totalPrice,
          'rtw_price': order.rtwPrice,
          'custom_price': order.customPrice,
          'shipping_price': order.shippingPrice,
          'packaging_price': order.packagingPrice,
          'buyer_address': order.buyerAddress,
          'discount': order.discount,
          'order_created': order.orderCreated.toIso8601String(),
          'order_status': order.orderStatus,
          'last_update': order.lastUpdate.toIso8601String(),
          'items': order.items.map((item) => item.toJson()).toList(),
          'payment_url': order.paymentUrl ?? "",
          'expired_date': order.expiredDate.toIso8601String(),
          'resi': order.resi,
          'payment_method': order.paymentMethod,
          'xendit_status': order.xenditStatus,
          'payment_date':order. paymentDate?.toIso8601String(),
          'description': order.description,
        }),
      );

      var data = jsonDecode(response.body);

      logger.d("Update order : ${data}");

      return OrderResponse.fromJson(data);
    } on SocketException catch (e) {
      logger.e("Update order : Tidak ada koneksi internet");

      return OrderResponse(message: NO_INTERNET_CONNECTION, error: true);
    } catch (e, stackTrace) {
      logger.e("Update order : ${e}");
      return OrderResponse(error: true, message: SOMETHING_WAS_WRONG);
    }
  }

  Future<Map<String, dynamic>?> getCustomDesign(String filename) async {
    var token = await SecureStorage.getToken();
    final url = Uri.parse("${baseUrl}order/custom-design/$filename");

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer Bearer ${token}',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Return file or response as needed
        return {'error': false, 'data': response.body};
      } else {
        return {'error': true, 'message': 'File not found'};
      }
    } on SocketException catch (e) {
      logger.e("get custom design : Tidak ada koneksi internet");
    } catch (e, stackTrace) {
      logger.e("get custom design : Tidak ada koneksi internet");
    }
  }
  
}
