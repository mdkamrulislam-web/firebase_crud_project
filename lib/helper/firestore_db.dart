// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud_project/helper/storage_service.dart';
import 'package:firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';
import 'package:firebase_crud_project/models/data_model/user_model.dart';

class FirestoreDB {
  static postDetailsToFirestore(String firstName, String lastName,
      String imagePath, String imageName, BuildContext context) async {
    // * Calling Firestore
    // * Calling User Model
    // * Sending These Values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    UserModel userModel = UserModel();

    final Storage storage = Storage();

    // * Writing All the values
    userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.firstName = firstName;
    userModel.lastName = lastName;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Your Sign-up is Successful!");

    storage.uploadFile(imagePath, imageName, userModel.uid);
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
