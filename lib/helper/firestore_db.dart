// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';
import 'package:firebase_crud_project/models/data_model/user_model.dart';

class FirestoreDB {
//   static addUser(
//     String email,
//     String firstName,
//     String lastName,
//     String uid,
//   ) async {
//     await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).set({
//       'email': email,
//       'createdOn': Timestamp.now(),
//       'firstName': firstName,
//       'lastName': lastName,
//       'uid': uid,
//     });
//   }


  static postDetailsToFirestore(String firstName, String lastName) async {
    // * Calling Firestore
    // * Calling User Model
    // * Sending These Values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    UserModel userModel = UserModel();

    // * Writing All the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstName;
    userModel.lastName = lastName;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Your Sign-up is Successful!");
  }
}

