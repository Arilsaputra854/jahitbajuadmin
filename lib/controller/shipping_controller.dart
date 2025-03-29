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

  
  int? _weight = 500;
  int? get weight => _weight;
  
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

  setCurrentShipping(Shipping newShipping){
    _currentShipping = newShipping;
    notifyListeners();
  }

  setWeight(int newWeight){
    _weight = newWeight;
    notifyListeners();
  }

  
  setDestination(String newDestination){
    _destination = newDestination;
    print(_destination);
    notifyListeners();
  }
  
  setOrigin(String newOrigin){
    _origin = newOrigin;
    print(_origin);
    notifyListeners();
  }

  Future<void> fetchAllDelivery(int weight,String origin, String destination) async {
    if (_shippings.isEmpty) {
      _loading = true;
      notifyListeners();
      ShippingsResponse response = await apiService.getAllShipping(weight, origin, destination);
      if (response.error) {
        _errorMsg =
            response.message ??
            "Maaf, Terjadi kesalahan, silakan coba lagi nanti.";
        _shippings = [];
        _loading = false;
        notifyListeners();
      } else {
        _shippings = response.shippings!;
        _loading = false;
        notifyListeners();
      }
    }
  }

  
  Future<List<City>?> fetchListCity() async {
    if (_listOfCity == null) {
      _loading = true;
      notifyListeners();
      _listOfCity = await fetchCityFromAPI();

      _loading = false;
      notifyListeners();
    }

    return _listOfCity;
  }

  Future<List<City>?> fetchCityFromAPI() async {
    CityResponse response = await apiService.getListCity();
    if (response.error) {
      _errorMsg = ApiService.SOMETHING_WAS_WRONG;
    } else {
      return response.cities!;
    }
  }


  void refresh(){
    _shippings = [];
    fetchAllDelivery(weight!, origin!, destination!);
  }

}
