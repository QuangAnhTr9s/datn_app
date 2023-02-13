import 'dart:async';

import '../../validations/validations.dart';


class LoginPageBloc {
  //isShowPasswod
  bool _isShowPassword = false;

  //checkBox
  bool _isChecked = false;


  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    _isChecked = value;
  }

  final StreamController<String> _userNameStreamController = StreamController<String>.broadcast();
  final StreamController<String> _passwordStreamController = StreamController<String>.broadcast();
  final StreamController<bool> _isShowPasswordStreamController = StreamController<bool>.broadcast();
  final StreamController<bool> _isCheckedStreamController = StreamController<bool>.broadcast();

  Stream<String> get  userNameStream => _userNameStreamController.stream;
  Stream<String> get  passwordStream => _passwordStreamController.stream;
  Stream<bool> get  isShowPasswordStream => _isShowPasswordStreamController.stream;
  Stream<bool> get  isCheckedwordStream => _isCheckedStreamController.stream;

  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isShowPasswordStreamController.close();
    _isCheckedStreamController.close();
  }
  void changeShowPassword(){
    _isShowPassword = !_isShowPassword;
    _isShowPasswordStreamController.sink.add(_isShowPassword);
  }
  void isCheckedBox(bool? value){
    _isChecked = value ?? false;
    _isCheckedStreamController.sink.add(_isChecked);
  }
  bool isValidInfo(String email, String password){
    if(!Validations.isValidEmail(email)){
      _userNameStreamController.sink.addError("Tài khoản phải dài hơn 8 kí tự: a12...@gmail.com");
      return false;
    }
    _userNameStreamController.sink.add('OK');

    if(!Validations.isValidPassword(password)){
      _passwordStreamController.sink.addError("Mật khẩu phải dài hơn 8 kí tự!");
      return false;
    }
    _passwordStreamController.sink.add('OK');
    return true;
  }
}
