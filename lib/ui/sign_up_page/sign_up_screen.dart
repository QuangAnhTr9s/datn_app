import 'package:demo_app/ui/login_page/login_page.dart';
import 'package:demo_app/ui/sign_up_page/sign_up_screen_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/custom_textfield.dart';
import '../../network/fire_base/fire_auth.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TextEditingController
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondPasswordController = TextEditingController();

  // TextEditingController _emailController = TextEditingController();
  final  _signUpPageBloc = SignUpPageBloc();
  //init fire auth
  final Auth _auth = Auth();

  bool value = false;

  @override
  void dispose() {
    _signUpPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Đăng ký"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //input first and last name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(child: MyTextField(placeHolder: "Họ", textEditingController: _lastNameController, obscureText: false, errorText: null)),
                    const SizedBox(width: 20,), Expanded(child: MyTextField(placeHolder: "Tên", textEditingController: _firstNameController, obscureText: false, errorText: null)),
                  ],),
                ),
                //input email
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<String>(
                      stream: _signUpPageBloc.userNameStream,
                      builder: (context, snapshotTextField) {
                        final errorTextEmail = snapshotTextField.hasError
                            ? snapshotTextField.error.toString()
                            : null;
                        return MyTextField(
                          placeHolder: 'Nhập tài khoản: a12...@gmail.com',
                          textEditingController: _emailController,
                          obscureText: false,
                          errorText: errorTextEmail,
                        );
                      }),
                ),

                //input password
                buildInputPassword(
                  _signUpPageBloc.isShowPasswordStream,
                  _signUpPageBloc.changeShowPassword,
                  _signUpPageBloc.passwordStream,
                  'Nhập mật khẩu: dài hơn 8 kí tự',
                  _passwordController,
                ),

                //input second password
                buildInputPassword(
                    _signUpPageBloc.isShowSecondPasswordStream,
                    _signUpPageBloc.changeShowSecondPassword,
                    _signUpPageBloc.isCorrectPasswordStream,
                    'Nhập lại mật khẩu',
                    _secondPasswordController),

                /*Checkbox(value: value, onChanged: (newValue) {
                  setState(() {
                    value = newValue!;
                    print(value);
                    print(newValue);
                  });
                },),*/

                //button Sign up
                InkWell(
                  onTap: () {
                    checkValidUser();
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: const Center(
                        child: Text(
                      "Đăng ký",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputPassword(
      Stream<bool> isShowPasswordStream,
      Function() changeShowPassword,
      Stream<String> passwordStream,
      String placeHolder,
      TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<bool>(
          // stream: _signUpScreenBloc.isShowPasswordStream,
          stream: isShowPasswordStream,
          builder: (context, snapshotIsShowPassword) {
            final isShowPassword = snapshotIsShowPassword.data ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //build Show/Hide Password
                    InkWell(
                      onTap: () {
                        // _signUpScreenBloc.changeShowPassword();
                        changeShowPassword();
                      },
                      child: Text(
                        isShowPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<String>(
                    stream: passwordStream,
                    builder: (context, snapshotTextField) {
                      final errorTextPassword = snapshotTextField.hasError
                          ? snapshotTextField.error.toString()
                          : null;
                      return MyTextField(
                        placeHolder: placeHolder,
                        textEditingController: textEditingController,
                        obscureText: !isShowPassword,
                        errorText: errorTextPassword,
                      );
                    }),
              ],
            );
          }),
    );
  }
  Future<void> checkValidUser() async {
    if (_signUpPageBloc.isValidInfo(_emailController.text,
        _passwordController.text, _secondPasswordController.text)) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      try {
        await _auth.createUserWithEmailAndPassword(
            firstName: _firstNameController.text.trim(), lastName: _lastNameController.text.trim(),
            email: _emailController.text, password: _passwordController.text).then((value) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage(),), (route) => false);
        },);
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
  }
}
