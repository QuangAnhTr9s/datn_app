import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../../network/fire_base/firebase_realtime.dart';

class KitchenPageBloc{
  bool _isClickedLightButton = false;
  final databaseReference = FirebaseDatabase.instance.ref();

  final StreamController<bool> _lightStreamController = StreamController<bool>.broadcast();

  Stream<bool> get lightStream => _lightStreamController.stream;

  StreamSink get _lightSink => _lightStreamController.sink;
  void dispose(){
    _lightStreamController.close();
  }
  Future<void> handleClickLightButton() async {
    final isTrue = await getDataDevice("Relay/RL3");
    _isClickedLightButton = isTrue;
    _isClickedLightButton = !_isClickedLightButton;
    _lightSink.add(_isClickedLightButton);
    if(_isClickedLightButton){
      await databaseReference.update({
        "Relay/RL3": 1,
      });
    }else{
      await databaseReference.update({
        "Relay/RL3" : 0,
      });
    }
  }
  Future<bool> getDataDevice(String name) async {
    return await MyFirebaseRealtime.getDataDevice(name);
  }
}