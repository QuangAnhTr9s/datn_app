import 'dart:async';

import 'package:demo_app/network/fire_base/firebase_realtime.dart';

class BedroomPageBloc{
  bool _isClickedLightButton = false;
  final databaseReference = MyFirebaseRealtime.fireDatabase.ref();

  final StreamController<bool> _lightStreamController = StreamController<bool>.broadcast();

  Stream<bool> get lightStream => _lightStreamController.stream;

  StreamSink get _lightSink => _lightStreamController.sink;

  void dispose(){
    _lightStreamController.close();
  }
  Future<void> handleClickLightButton() async {
    final isTrue = await getDataDevice("Relay/RL2");
    _isClickedLightButton = isTrue;
    _isClickedLightButton = !_isClickedLightButton;
    _lightSink.add(_isClickedLightButton);
    if(_isClickedLightButton){
      await databaseReference.update({
        "Relay/RL2": 1,
      });
    }else{
      await databaseReference.update({
        "Relay/RL2" : 0,
      });
    }
  }
  Future<bool> getDataDevice(String name) async {
    return await MyFirebaseRealtime.getDataDevice(name);
  }

}