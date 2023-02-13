import 'dart:async';


import '../../network/fire_base/firebase_realtime.dart';

class LivingRoomPageBloc{
  bool _isClickedLightButton = false;
  bool _isClickedFanButton = false;

  final databaseReference = MyFirebaseRealtime.fireDatabase.ref();

  final StreamController<bool> _lightStreamController = StreamController<bool>.broadcast();
  final StreamController<bool> _fanStreamController = StreamController<bool>.broadcast();

  Stream<bool> get lightStream => _lightStreamController.stream;
  Stream<bool> get fanStream => _fanStreamController.stream;

  StreamSink get _lightSink => _lightStreamController.sink;
  StreamSink get _fanSink => _fanStreamController.sink;

  void dispose(){
    _lightStreamController.close();
    _fanStreamController.close();
  }
  Future<void> handleClickLightButton1() async {
    final isTrue = await MyFirebaseRealtime.getDataDevice("Relay/RL1");
    _isClickedLightButton = isTrue;
    _isClickedLightButton = !_isClickedLightButton;
    _lightSink.add(_isClickedLightButton);
    if(_isClickedLightButton){
     await databaseReference.update({
       "Relay/RL1": 1,
      });
    }else{
      await databaseReference.update({
        "Relay/RL1" : 0,
      });
    }
  }

  Future<void> handleClickFanButton() async {
    final isTrue = await getDataDevice("Relay/RL4");
    _isClickedFanButton = isTrue;
    _isClickedFanButton = !_isClickedFanButton;
    _fanSink.add(_isClickedFanButton);
    if(_isClickedFanButton){
     await databaseReference.update({
       "Relay/RL4": 1,
      });
    }else{
      await databaseReference.update({
        "Relay/RL4" : 0,
      });
    }
  }

  Future<bool> getDataDevice(String name) async {
    return await MyFirebaseRealtime.getDataDevice(name);
  }
}