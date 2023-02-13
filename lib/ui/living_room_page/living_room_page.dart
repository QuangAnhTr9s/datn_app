import 'dart:math';

import 'package:demo_app/custom_widgets/custom_box_button.dart';
import 'package:demo_app/ui/living_room_page/living_room_page_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/custom_arc_progress.dart';

class LivingRoomPage extends StatefulWidget {
  const LivingRoomPage({super.key});

  @override
  State<LivingRoomPage> createState() => _LivingRoomState();
}

class _LivingRoomState extends State<LivingRoomPage>
    with TickerProviderStateMixin {
  final _livingRoomPageBloc = LivingRoomPageBloc();
  late Animation<double> animationArcProgress;
  late Animation<double> animationLinearProgressIndicator;
  late AnimationController animArcProgressController;
  late AnimationController animLinearProgressIndicatorController;

  @override
  void initState() {
    super.initState();

    animArcProgressController = AnimationController(
        duration: const Duration(milliseconds: 1), vsync: this);
    animationArcProgress =
        Tween<double>(begin: 0.0, end: 0.0).animate(animArcProgressController);
    animArcProgressController.forward();

    animLinearProgressIndicatorController = AnimationController(
        duration: const Duration(milliseconds: 1), vsync: this);
    animationLinearProgressIndicator = Tween<double>(begin: 0.0, end: 0.0)
        .animate(animLinearProgressIndicatorController);
    animLinearProgressIndicatorController.forward();
  }

  @override
  void dispose() {
    animArcProgressController.dispose();
    animLinearProgressIndicatorController.dispose();
    _livingRoomPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getDataFireAndUpdateProgressTemp("DHT/temp");
    getDataFireAndUpdateProgressHum("DHT/hum");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phòng khách',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow.shade700,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              width: double.maxFinite,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //nhiệt độ
                  SizedBox(
                    height: 210,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 35),
                          child: CustomPaint(
                            painter:
                                ProgressArc(null, Colors.grey.shade200, true),
                            size: const Size(250, 200),
                            child: CustomPaint(
                              painter: ProgressArc(animationArcProgress.value,
                                  Colors.redAccent, false),
                              size: const Size(250, 200),
                            ),
                          ),
                        ),
                        //hiển thị nhiệt độ
                        Positioned(
                            bottom: 70,
                            left: 85,
                            child: Row(
                              children: [
                                Text(
                                  "${(animationArcProgress.value / 3.14 * 50).round()}",
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const Text(
                                  '°C',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                              ],
                            )),
                        Positioned(
                            bottom: 22,
                            child: SizedBox(
                              width: 230,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                  // SizedBox(width: 80,),
                                  buildTextTemperature(
                                      animationArcProgress.value / 3.14 * 50),
                                  // SizedBox(width: 75,),
                                  const Text(
                                    '50',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //độ ẩm
                  SizedBox(
                      width: 250,
                      height: 110,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  valueColor:
                                      const AlwaysStoppedAnimation(Colors.blue),
                                  backgroundColor: Colors.grey.shade100,
                                  minHeight: 50,
                                  value: animationLinearProgressIndicator.value,
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: 20,
                                child: Text(
                                  '${(animationLinearProgressIndicator.value * 100).round()}%',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          //Text Humidity
                          buildTextHumidity(
                              animationLinearProgressIndicator.value * 100),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  //cảnh báo khí gas
                  FutureBuilder(
                    future: _livingRoomPageBloc.getDataDevice("GAS"),
                    builder: (context, snapshot) {
                      final isGas = snapshot.data ?? false;
                      return isGas
                          ? buildTextGas(
                              "Nguy hiểm! Có khí gas tràn ra ngoài !!!",
                              Colors.red)
                          : buildTextGas("An toàn", Colors.black38);
                    },
                  )
                ],
              ),
            ),

            // Devices
            Container(
              height: 250,
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //button light
                  FutureBuilder(
                    future: _livingRoomPageBloc.getDataDevice("Relay/RL1"),
                    // initialData: false,
                    builder: (context, snapshot) {
                      final onLight = snapshot.data ?? false;
                      if (snapshot.hasData) {
                        return StreamBuilder<bool>(
                            stream: _livingRoomPageBloc.lightStream,
                            builder: (context, snapshot) {
                              final isClicked = snapshot.data ?? onLight;
                              return MyBoxButton(
                                isClicked: isClicked,
                                name: "Đèn",
                                width: 150,
                                height: 170,
                                onTap:
                                _livingRoomPageBloc.handleClickLightButton1,
                                iconData: Icons.light_outlined,
                                colorOn: Colors.yellow,
                                colorOff: Colors.white,
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //button fan
                  FutureBuilder(
                    future: _livingRoomPageBloc.getDataDevice("Relay/RL4"),
                    builder: (context, snapshot) {
                      final onFan = snapshot.data ?? false;
                      return StreamBuilder<bool>(
                          stream: _livingRoomPageBloc.fanStream,
                          builder: (context, snapshot) {
                            final isClicked = snapshot.data ?? onFan;
                            return MyBoxButton(
                              isClicked: isClicked,
                              name: "Quạt",
                              width: 150,
                              height: 170,
                              onTap: _livingRoomPageBloc.handleClickFanButton,
                              iconData: Icons.flip_camera_android,
                              colorOn: Colors.blue,
                              colorOff: Colors.white,
                            );
                          });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildTextGas(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      decoration: BoxDecoration(border: Border.all(color: color),borderRadius: BorderRadius.circular(20),),
      child: Center(
        child: Text("Cảnh báo khí gas: $text",
          style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildTextTemperature(double temperature) {
    if (temperature < 15) {
      return buildTextTemperatureWidget("Lạnh", Colors.lightBlueAccent);
    } else if (15 <= temperature && temperature <= 20) {
      return buildTextTemperatureWidget("Se lạnh", Colors.blue.shade400);
    } else if (20 < temperature && temperature <= 30) {
      return buildTextTemperatureWidget("Ấm", Colors.yellow.shade700);
    } else if (30 < temperature && temperature <= 40) {
      return buildTextTemperatureWidget("Nóng", Colors.orangeAccent);
    } else {
      return buildTextTemperatureWidget("Rất nóng", Colors.red);
    }
  }

  Container buildTextTemperatureWidget(String text, Color color) {
    return Container(
        decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(text, style: TextStyle(
                  fontSize: 25, color: color, fontWeight: FontWeight.bold),
            )));
  }

  Widget buildTextHumidity(double humidity) {
    if (humidity < 40) {
      return buildTextHumidityWidget(
          "Độ ẩm không khí ở mức thấp", Colors.lightBlueAccent);
    } else if (40 <= humidity && humidity <= 70) {
      return buildTextHumidityWidget(
          "Độ ẩm không khí ở mức trung bình", Colors.blue.shade400);
    }
    if (70 <= humidity && humidity <= 80) {
      return buildTextHumidityWidget(
          "Độ ẩm không khí ở mức khá cao", Colors.blue.shade500);
    } else {
      return buildTextHumidityWidget("Độ ẩm không khí ở mức cao", Colors.red);
    }
  }

  Widget buildTextHumidityWidget(String text, Color color) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: color,
          ),
        ));
  }

  void getDataFireAndUpdateProgressHum(
    String name,
  ) {
    final ref = FirebaseDatabase.instance.ref(name);
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      double firstData = 0, lastData = 0;
      setState(() {
        lastData = double.parse(data.toString());
        if (firstData != lastData) {
          animationLinearProgressIndicator = Tween<double>(
            begin: firstData / 100,
            end: lastData / 100,
          ).animate(animLinearProgressIndicatorController);
          // animLinearProgressIndicatorController.reset();
          animLinearProgressIndicatorController.forward();
          firstData = lastData;
        }
      });
    });
  }

  void getDataFireAndUpdateProgressTemp(String name) {
    final ref = FirebaseDatabase.instance.ref(name);
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      double firstData = 0, lastData = 0;
      setState(() {
        lastData = double.parse(data.toString());
        if (firstData != lastData) {
          animationArcProgress = Tween<double>(
            begin: firstData / 100,
            end: pi * (lastData / 50),
          ).animate(animLinearProgressIndicatorController);
          // animLinearProgressIndicatorController.reset();
          animLinearProgressIndicatorController.forward();
          firstData = lastData;
        }
      });
    });
  }

}
