import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Storage extends ChangeNotifier {
  Storage();
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> uploadFile(filePath, fileName, uid) async {
    File file = File(filePath);
    try {
      await storage.ref('$uid/profile_pic/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
