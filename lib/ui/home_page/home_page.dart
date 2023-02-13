import 'dart:async';

import 'package:demo_app/shared/const/screen_consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../custom_widgets/custom_icon.dart';
import '../../network/fire_base/fire_auth.dart';
import '../../network/google/google_sign_in.dart';
import 'home_page_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _homePageBloc = HomePageBloc();

  //lấy thời gian hiện tại
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homePageBloc.tabController = TabController(length: 3, vsync: this);
    //cập nhật thời gian theo từng giây
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _homePageBloc.dispose();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }
  final Auth _auth = Auth();
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();
  Future<void> _signOut() async {
    try{
      _signInWithGoogle.signOut();
      _auth.signOut();
    } catch(e){
      print('error in Home Sc: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    String timeText = DateFormat('h:mm a').format(_currentTime);
    String dmyText = DateFormat.yMMMMEEEEd().format(_currentTime);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: 750,
            color: const Color(0xD5F1EFEF),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                          color: Colors.orangeAccent),
                      child: Center(
                        child: IconButton(
                            onPressed: () async {
                              await _signOut().then((value) {
                                Navigator.of(context).pushNamedAndRemoveUntil(RouteName.LOGIN_SCREEN, (route) => false,);
                              });
                            }, icon: const Icon(Icons.logout, color: Colors.white, size: 30,)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  //hiển thị thông tin
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Xin chào ${_homePageBloc.currentUser?.displayName?? ''}",
                            style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
                          Text(
                            timeText,
                            style: const TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),),
                          Text(
                            dmyText,
                            style:
                                const TextStyle(fontSize: 17, color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),

                  //Rooms
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //build LivingRoom
                      FutureBuilder(
                        future: _homePageBloc.getDataLivingRoom(),
                        builder: (context, snapshot) {
                         final onDevices = snapshot.data ?? false;
                          return buildRoom(
                            height: 200, width: 340, iconData: Icons.chair,
                            color: Colors.yellow.shade700,
                            stream: _homePageBloc.switchLivingRoomStream,
                            handleClickSwitch: _homePageBloc.handleClickSwitchLivingRoom,
                            text: "Phòng khách",
                            numOfDevices: 2,
                            routeName: RouteName.LIVING_ROOM_SCREEN,
                            onDevice: onDevices,
                          );
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //build BedRoom
                          FutureBuilder(
                            future: _homePageBloc.getDataBedroom(),
                            builder: (context, snapshot) {
                              final onDevices = snapshot.data ?? false;
                              return buildRoom(
                                height: 200, width: (MediaQuery.of(context).size.width - 65)/2,
                                iconData: Icons.bed,
                                color: Colors.blue,
                                stream: _homePageBloc.switchBedRoomStream,
                                handleClickSwitch: _homePageBloc.handleClickSwitchBedRoom,
                                text: "Phòng ngủ",
                                numOfDevices: 1,
                                routeName: RouteName.BEDROOM_SCREEN,
                                onDevice: onDevices,
                              );
                            },
                          ),

                          //build Kitchen
                          FutureBuilder(
                            future: _homePageBloc.getDataKitchen(),
                            builder: (context, snapshot) {
                              final onDevices = snapshot.data ?? false;
                              return  buildRoom(
                                height: 200, width: (MediaQuery.of(context).size.width - 65)/2,
                                iconData: Icons.kitchen,
                                color: Colors.redAccent,
                                stream: _homePageBloc.switchKitchenStream,
                                handleClickSwitch: _homePageBloc.handleClickSwitchKitchen,
                                text: "Phòng bếp",
                                numOfDevices: 1,
                                routeName: RouteName.KITCHEN_SCREEN,
                                onDevice: onDevices,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget buildRoom(
      {required double? height,
      required double? width,
      required IconData iconData,
      required Color color,
      required Stream<bool> stream,
      required Function() handleClickSwitch,
      required String text,
        required int numOfDevices,
      required routeName,
        required bool onDevice,
      }) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: (
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyIcon(iconData: iconData, color: color),
                StreamBuilder<bool>(
                    stream: stream,
                    builder: (context, snapshot) {
                      final isSwitched = onDevice;
                      return Switch(
                        onChanged: (value) {
                          handleClickSwitch();
                        },
                        value: isSwitched,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      );
                    }),
              ],
            ),
            const SizedBox(height: 10,),
            Text(text, style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 5,),
            Text('$numOfDevices thiết bị', style: Theme.of(context).textTheme.displayMedium,),
          ],
        )),
      ),
    );
  }

}
