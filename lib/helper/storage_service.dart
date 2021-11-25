import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Storage extends ChangeNotifier {
  Storage();
  String? downloadURL = " ";
  final FirebaseStorage storage = FirebaseStorage.instance;

  // ! Uploading Image on Firebase Storage and Saving Download URL in Firebase Firestore Database
  Future<void> uploadFile(filePath, fileName, uid) async {
    File file = File(filePath);
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      Reference ref = storage.ref().child("$uid/images").child("post_$postID");

      await ref.putFile(file);

      downloadURL = await ref.getDownloadURL();
      // ignore: avoid_print
      print(downloadURL);
      // ! Saving Download Link to Firebase Firestore
      await firebaseFirestore
          .collection("users")
          .doc(uid)
          .collection("images")
          .add({'downloadURL': downloadURL}).then((value) => {
                Fluttertoast.showToast(msg: "Image Uploaded!"),
                // ignore: avoid_print
                print("Uploaded!"),
              });
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
