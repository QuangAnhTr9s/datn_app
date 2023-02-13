import 'dart:async';

import 'package:demo_app/network/fire_base/firebase_realtime.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../network/fire_base/fire_auth.dart';

class HomePageBloc{
  late TabController _tabController;

  final databaseReference = FirebaseDatabase.instance.ref();

  final _auth = Auth();

  bool _isClickedSwitchLivingRoom = false;
  bool _isClickedSwitchBedRoom = false;
  bool _isClickedSwitchKitchen = false;

  final StreamController<bool> _switchLvingRoomStreamController = StreamController<bool>.broadcast();
  final StreamController<bool> _switchBedRoomStreamController = StreamController<bool>.broadcast();
  final StreamController<bool> _switchKitchenStreamController = StreamController<bool>.broadcast();


  Stream<bool> get switchBedRoomStream => _switchBedRoomStreamController.stream;
  Stream<bool> get switchKitchenStream => _switchKitchenStreamController.stream;
  Stream<bool> get switchLivingRoomStream => _switchLvingRoomStreamController.stream;

  StreamSink get _switchBedRoomSink => _switchBedRoomStreamController.sink;
  StreamSink get _switchKitchenSink => _switchKitchenStreamController.sink;
  StreamSink get _switchLivingRoomSink => _switchLvingRoomStreamController.sink;


  User? get currentUser => _auth.currentUser;
  void handleClickSwitchLivingRoom() async{
    final isTrue = await getDataLivingRoom();
    _isClickedSwitchLivingRoom = isTrue;
    _isClickedSwitchLivingRoom = !_isClickedSwitchLivingRoom;
    _switchLivingRoomSink.add(_isClickedSwitchLivingRoom);
    if(_isClickedSwitchLivingRoom){
      await databaseReference.update({
        "Relay/RL1": 1,
        "Relay/RL4": 1,
      });
    }else{
      await databaseReference.update({
        "Relay/RL1" : 0,
        "Relay/RL4" : 0,
      });
    }
  }
  void handleClickSwitchBedRoom() async {
    final isTrue = await getDataBedroom();
    _isClickedSwitchBedRoom = isTrue;
    _isClickedSwitchBedRoom = !_isClickedSwitchBedRoom;
    _switchBedRoomSink.add(_isClickedSwitchBedRoom);
    if(_isClickedSwitchBedRoom){
      await databaseReference.update({
        "Relay/RL2": 1,
      });
    }else{
      await databaseReference.update({
        "Relay/RL2" : 0,
      });
    }
  }
  void handleClickSwitchKitchen() async {
    final isTrue = await getDataKitchen();
    _isClickedSwitchKitchen = isTrue;
    _isClickedSwitchKitchen = !_isClickedSwitchKitchen;
    _switchKitchenSink.add(_isClickedSwitchKitchen);
    if(_isClickedSwitchKitchen){
      await databaseReference.update({
        "Relay/RL3": 1,
      });
    }else{
      await databaseReference.update({
        "Relay/RL3" : 0,
      });
    }
  }
  Future<bool> getDataLivingRoom() async {
    final dataLight = await getDataDevice("Relay/RL1");
    final dataFan = await getDataDevice("Relay/RL4");
    return dataLight || dataFan;
  }
  Future<bool> getDataBedroom() async {
    final dataLight = await getDataDevice("Relay/RL2");
    return dataLight;
  }
  Future<bool> getDataKitchen() async {
    final dataLight = await getDataDevice("Relay/RL3");
    return dataLight;
  }

  TabController get tabController => _tabController;

  set tabController(TabController value) {
    _tabController = value;
  }
  Future<bool> getDataDevice(String name) async {
    return await MyFirebaseRealtime.getDataDevice(name);
  }
  void dispose(){
    _tabController.dispose();
    _switchKitchenStreamController.close();
    _switchLvingRoomStreamController.close();
    _switchBedRoomStreamController.close();
  }
}