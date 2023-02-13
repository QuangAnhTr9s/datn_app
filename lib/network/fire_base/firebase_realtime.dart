import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class MyFirebaseRealtime{
 static final fireDatabase = FirebaseDatabase.instance;
  static Future<bool> getDataDevice(String name) async {
  final ref = fireDatabase.ref(name);
  // Create a completer to wait for the result
  final completer = Completer<bool>();
  ref.onValue.listen((DatabaseEvent event) {
   final data = event.snapshot.value.toString();
   if (data == "1") {
    completer.complete(true);
   } else {
    completer.complete(false);
   }
  });
  final result = await completer.future;
  // Wait for the completer to complete and return the result
  return result;
 }
}