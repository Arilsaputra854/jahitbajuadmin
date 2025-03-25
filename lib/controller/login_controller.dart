
import 'package:flutter/material.dart';
import 'package:jahit_baju_admin/data/remote/api_service.dart';
import 'package:jahit_baju_admin/data/remote/response/login_response.dart';

class LoginController extends ChangeNotifier {
  ApiService apiService;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  
  String? _password;
  String? get password => _password;

  
  String? _email;
  String? get email => _email;


  
  bool _hidePassword = false;
  bool get hidePassword => _hidePassword;



  LoginController(this.apiService);

  

  void setPassword(String newPassword){
    _password = newPassword;
    notifyListeners();
  }

  
  void setEmail(String newEmail){
    _email = newEmail;
    notifyListeners();
  }

  void setHidePassword(){
    _hidePassword = !hidePassword;
    notifyListeners();
  }

  Future<String?> login() async {
    if(_email != null && _password != null){
      LoginResponse response =  await apiService.login(_email!, _password!);
      if(response.error){
        _errorMsg =  response.message ?? "Terjadi kesalahan, tidak dapat melakukan login.";        
      notifyListeners();  
      }else{
        return response.token;
      }
    }else{
      _errorMsg = "Silakan lengkapi email dan password anda.";
      notifyListeners();
    }
     
  }
}
