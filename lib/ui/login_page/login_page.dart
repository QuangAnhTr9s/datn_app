import 'package:demo_app/shared/const/screen_consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../custom_widgets/custom_textfield.dart';
import '../../network/fire_base/fire_auth.dart';
import '../../network/google/google_sign_in.dart';
import '../../shared/const/images.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../sign_up_page/sign_up_screen.dart';
import 'login_page_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //init bloc
  final LoginPageBloc _loginScreenBloc = LoginPageBloc();

  //TextEditingController
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //
  String _wrongLogin = '';

  //fire auth
  final Auth _auth = Auth();

  //google sign in
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();

  //DateTime
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    print('Login Screen inited');
    /* //mỗi lần vào screen sign in => chưa lưu đăng nhập
    MySharedPreferences.setSaveSignIn(false);*/
  }

  @override
  void dispose() {
    _loginScreenBloc.dispose();
    print("Login screen is disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 800, 
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    right: 0,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Image.asset(
                          Images.backgroundLogin,
                          fit: BoxFit.cover,
                        ))),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.only(top: 220, right: 20, left: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Đăng nhập',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      //nhập tài khoản
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tài khoản',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            StreamBuilder<String>(
                                stream: _loginScreenBloc.userNameStream,
                                builder: (context, snapshotTextField) {
                                  final errorTextUsername =
                                      snapshotTextField.hasError
                                          ? snapshotTextField.error.toString()
                                          : null;
                                  return MyTextField(
                                    placeHolder:
                                        'Nhập tài khoản: a12...@gmail.com',
                                    textEditingController: _usernameController,
                                    obscureText: false,
                                    errorText: errorTextUsername,
                                  );
                                })
                          ],
                        ),
                      ),
                      //nhập mật khẩu
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: StreamBuilder<bool>(
                            stream: _loginScreenBloc.isShowPasswordStream,
                            builder: (context, snapshotIsShowPassword) {
                              final isShowPassword =
                                  snapshotIsShowPassword.data ?? false;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Mật khẩu',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      //build Show/Hide Password
                                      InkWell(
                                        onTap: () {
                                          _loginScreenBloc.changeShowPassword();
                                        },
                                        child: Text(
                                          isShowPassword
                                              ? 'Ẩn mật khẩu'
                                              : 'Hiện mật khẩu',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  StreamBuilder<String>(
                                      stream: _loginScreenBloc.passwordStream,
                                      builder: (context, snapshotTextField) {
                                        final errorTextPassword =
                                            snapshotTextField.hasError
                                                ? snapshotTextField.error
                                                    .toString()
                                                : null;
                                        return MyTextField(
                                          placeHolder:
                                              'Nhập mật khẩu: dài hơn 8 kí tự',
                                          textEditingController:
                                              _passwordController,
                                          obscureText: !isShowPassword,
                                          errorText: errorTextPassword,
                                        );
                                      })
                                ],
                              );
                            }),
                      ),

                      //Text Wrong Login
                      _wrongLogin == ''
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _wrongLogin,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),

                      //Save login
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: StreamBuilder<bool>(
                            stream: _loginScreenBloc.isCheckedwordStream,
                            builder: (context, snapshot) {
                              bool isChecked = snapshot.data ?? false;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (value) async {
                                      _loginScreenBloc.isCheckedBox(value);
                                      //lưu biến isChecked vào Shared Preferences
                                      await MySharedPreferences.setSaveSignIn(
                                          value ?? false);
                                    },
                                  ),
                                  Text(isChecked
                                      ? "Không lưu đăng nhập"
                                      : "Lưu đăng nhập"),
                                ],
                              );
                            }),
                      ),

                      // nút đăng nhập
                      _buildButtonSignIn('ĐĂNG NHẬP'),

                      //Text Create new account? SIGN UP
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Bạn chưa có tài khoản? ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ));
                                },
                                child: const Text(
                                  "Đăng ký ngay!",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Social button
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Hoặc", style: TextStyle(fontSize: 20, color: Colors.grey),),
                        InkWell(
                          onTap: () => _handleGoogleSignIn(),
                          child: Container(
                            height: 50,
                            width: 240,
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                        child: Image.asset(Images.googleAvatar, fit: BoxFit.fill,))),
                                const Text("Đăng nhập với Google",
                                  style: TextStyle(fontSize: 18),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn(String label) {
    return Material(
      color: Colors.pink[300],
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        // splashColor: Colors.orangeAccent,
        onTap: () {
          checkValidUser();
        },
        child: SizedBox(
          height: 48,
          // decoration: BoxDecoration(color: Colors.redAccent[200], borderRadius: BorderRadius.circular(10), ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkValidUser() async {
    if (_loginScreenBloc.isValidInfo(
        _usernameController.text, _passwordController.text)) {
      try {
        User? user = await _auth
            .signInWithEmailAndPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        )
            .then(
          (value) async {
            if (value != null) {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: value),));
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteName.HOME_SCREEN,
                (route) => false,
              );
            }
            return null;
          },
        );
        print(user);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _wrongLogin = 'Tài khoản này chưa tồn tại!';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _wrongLogin = 'Sai mật khẩu!';
          });
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      User? userGoogle =
          await _signInWithGoogle.signInWithGoogle().then((value) async {
        if (value != null) {
          print('ok user google');
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          //lưu biến isChecked vào Shared Preferences
          await MySharedPreferences.setSaveSignIn(true).then(
            (value) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.HOME_SCREEN, (route) => false);
            },
          );
        }
        return null;
      });
    } catch (error) {
      print(error);
    }
  }

  //Press back 2 time to exit
  Future<bool> _onWillPop() async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);

    timeBackPressed = DateTime.now();
    if (isExitWarning) {
      const message = ' Nhấn trở lại lần nữa để thoát ';
      await Fluttertoast.showToast(msg: message, fontSize: 16);
      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
  }
}
