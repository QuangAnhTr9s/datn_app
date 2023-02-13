import 'dart:async';

import '../../validations/validations.dart';


class SignUpPageBloc {
  //isShowPasswod
  bool _isShowPassword = false;
  bool _isShowSecondPassword = false;

  final StreamController<String> _userNameStreamController = StreamController<String>.broadcast();
  final StreamController<String> _passwordStreamController = StreamController<String>.broadcast();
  final StreamController<String> _secondPasswordStreamController = StreamController<String>.broadcast();
  final StreamController<bool> _isShowPasswordStreamController = StreamController<bool>.broadcast();
  final StreamController<bool> _isShowSecondPasswordStreamController = StreamController<bool>.broadcast();


  Stream<String> get  userNameStream => _userNameStreamController.stream;
  Stream<String> get  passwordStream => _passwordStreamController.stream;
  Stream<String> get  isCorrectPasswordStream => _secondPasswordStreamController.stream;
  Stream<bool> get  isShowPasswordStream => _isShowPasswordStreamController.stream;
  Stream<bool> get  isShowSecondPasswordStream => _isShowSecondPasswordStreamController.stream;

  void changeShowPassword(){
    _isShowPassword = !_isShowPassword;
    _isShowPasswordStreamController.sink.add(_isShowPassword);
  }
  void changeShowSecondPassword(){
    _isShowSecondPassword = !_isShowSecondPassword;
    _isShowSecondPasswordStreamController.sink.add(_isShowSecondPassword);
  }

  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _secondPasswordStreamController.close();
    _isShowPasswordStreamController.close();
    _isShowSecondPasswordStreamController.close();
  }
  bool isValidInfo(String email, String password, String sencondPassword){
    if(!Validations.isValidEmail(email)){
      _userNameStreamController.sink.addError("Tài khoản phải dài hơn 8 kí tự!");
      return false;
    }
    _userNameStreamController.sink.add('OK');

    if(!Validations.isValidPassword(password)){
      _passwordStreamController.sink.addError("Mật khẩu phải dài hơn 8 kí tự!");
      return false;
    }
    _passwordStreamController.sink.add('OK');
    if(!Validations.isValidSecondPassword(sencondPassword, password)){
      _secondPasswordStreamController.sink.addError("Mật khẩu không khớp!");
      return false;
    }
    _secondPasswordStreamController.sink.add('');
    return true;
  }
}
