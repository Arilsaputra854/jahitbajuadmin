import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahit_baju_admin/data/model/designer.dart';
import 'package:jahit_baju_admin/data/model/look.dart';
import 'package:jahit_baju_admin/data/model/packaging.dart';
import 'package:jahit_baju_admin/data/model/product.dart';
import 'package:jahit_baju_admin/data/remote/response/care_guide_response.dart';
import 'package:jahit_baju_admin/data/remote/response/city_response.dart';
import 'package:jahit_baju_admin/data/remote/response/designer_response.dart';
import 'package:jahit_baju_admin/data/remote/response/login_response.dart';
import 'package:jahit_baju_admin/data/remote/response/look_response.dart';
import 'package:jahit_baju_admin/data/remote/response/packaging_response.dart';
import 'package:jahit_baju_admin/data/remote/response/product_response.dart';
import 'package:jahit_baju_admin/data/remote/response/shipping_response.dart';
import 'package:jahit_baju_admin/data/remote/response/term_condition_response.dart';
import 'package:jahit_baju_admin/data/remote/response/users_response.dart';
import 'package:jahit_baju_admin/util/token_storage.dart';
import 'package:logger/logger.dart';

class ApiService {
  //final String baseUrl = "https://v1.jahitbajuofficial.com/api/";
  final String baseUrl = "https://bonefish-supreme-sculpin.ngrok-free.app/api/";

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

  Future<DesignerResponse> getDesigner() async {
    var token = await SecureStorage.getToken();
    var url = Uri.parse("${baseUrl}designer");

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    DesignerResponse designerResponse;
    try {
      var data = jsonDecode(response.body);
      logger.d("Get Designer : ${data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        designerResponse = DesignerResponse.fromJson(data);
      } else if (response.statusCode >= 500) {
        designerResponse = DesignerResponse(
          error: true,
          message: SOMETHING_WAS_WRONG_SERVER,
        );
      } else if (response.statusCode == 401) {
        designerResponse = DesignerResponse(error: true, message: UNAUTHORIZED);
      } else {
        designerResponse = DesignerResponse(
          error: true,
          message: SOMETHING_WAS_WRONG,
        );
      }
    } on SocketException catch (e) {
      logger.e("Get Designer : Tidak ada koneksi internet");
      designerResponse = DesignerResponse(
        error: true,
        message: NO_INTERNET_CONNECTION,
      );
    } catch (e, stackTrace) {
      logger.e("Get Designer :  $e");
      designerResponse = DesignerResponse(error: true, message: e.toString());
    }
    return designerResponse;
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
    var url = Uri.parse("${baseUrl}designer/look/${look.id}");

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
      return TermConditionResponse(error: true, data: SOMETHING_WAS_WRONG);
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
      return TermConditionResponse(error: true, data: SOMETHING_WAS_WRONG);
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
      return CareGuideResponse(error: true, message: SOMETHING_WAS_WRONG);
    }
  }

  updateProductCareTerm(String editedText) async {
    final url = Uri.parse("${baseUrl}care-guide");
    var token = await SecureStorage.getToken();
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      
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
      return CareGuideResponse(error: true, message: SOMETHING_WAS_WRONG);
    }
  }
}
