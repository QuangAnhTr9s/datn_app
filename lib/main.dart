
import 'package:demo_app/shared/const/screen_consts.dart';
import 'package:demo_app/shared_preferences/shared_preferences.dart';
import 'package:demo_app/ui/bedroom_page/bedroom_page.dart';
import 'package:demo_app/ui/home_page/home_page.dart';
import 'package:demo_app/ui/kitchen_page/kitchen_page.dart';
import 'package:demo_app/ui/living_room_page/living_room_page.dart';
import 'package:demo_app/ui/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'network/fire_base/fire_auth.dart';
import 'network/google/google_sign_in.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPreferences.initSharedPreferences();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
   const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:  TextTheme(
          titleMedium: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          displaySmall: TextStyle(fontSize: 16, color: Colors.grey.shade700)
        ),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.white)
      ),
      routes: {
        '/': (context) => const MainPage(),
        RouteName.HOME_SCREEN: (context) => const HomePage(),
        RouteName.LOGIN_SCREEN: (context) => const LoginPage(),
        RouteName.LIVING_ROOM_SCREEN: (context) => const LivingRoomPage(),
        RouteName.BEDROOM_SCREEN: (context) => const BedroomPage(),
        RouteName.KITCHEN_SCREEN: (context) => const KitchenPage(),
      },
      initialRoute: '/',
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});


  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //isSignIn
  bool isSignIn = false;

  //init Auth
  final Auth _auth = Auth();

  //init Google Login
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignIn = MySharedPreferences.getIsSaveSignIn();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            if(isSignIn == false){
              _signInWithGoogle.signOut();
              _auth.signOut();
              return const LoginPage();
            }
            return const HomePage();
          }else if(!snapshot.hasData){
            return const LoginPage();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },),
    );
  }
}

