import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/model/city.dart';
import 'package:jahit_baju_admin/data/model/shipping.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/city_response.dart';
import 'package:jahit_baju_admin/data/remote/response/shipping_response.dart';

class ShippingController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  String? _destination;
  String? get destination => _destination;

  String? _origin;
  String? get origin => _origin;

  bool _loading = false;
  bool get loading => _loading;

  List<Shipping> _shippings = [];
  List<Shipping> get shippings => _shippings;

  List<City>? _listOfCity;
  List<City>? get listOfCity => _listOfCity;

  Shipping? _currentShipping;
  Shipping? get currentShipping => _currentShipping;

  ShippingController(this.apiService);

  setCurrentShipping(Shipping newShipping) {
    _currentShipping = newShipping;
    notifyListeners();
  }

  setDestination(String newDestination) {
    _destination = newDestination;
    notifyListeners();
  }

  setOrigin(String newOrigin) {
    _origin = newOrigin;
    notifyListeners();
  }

  Future<void> fetchAllDelivery() async {
    if ( _origin != null && _destination != null) {
      _loading = true;
      _errorMsg = null;
      ShippingsResponse response = await apiService.getAllShipping(
        500,
        _origin!,
        _destination!,
      );
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _shippings = [];
      } else {
        _shippings = response.shippings!;
      }
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchCityFromAPI() async {
    if (_listOfCity == null) {
      _errorMsg = null;
      CityResponse response = await apiService.getListCity();
      if (response.error) {
        _errorMsg = ApiService.SOMETHING_WAS_WRONG;
        _listOfCity = [];
      } else {
        _listOfCity = response.cities!;
      }
    }
    notifyListeners();
  }

  void refresh() {
    _shippings = [];
    fetchAllDelivery();
  }
}
