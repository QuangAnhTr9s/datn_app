import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences{
  static late SharedPreferences _sharedPreferences;
  // static const _isSaveSignIn = false;
  static Future<void> setSaveSignIn(bool isSaveSignIn) async{
    _sharedPreferences.setBool('isSaveSignIn', isSaveSignIn);
  }
  static bool getIsSaveSignIn() => _sharedPreferences.getBool('isSaveSignIn') ?? false;

  static Future<void> initSharedPreferences() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

}