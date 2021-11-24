import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';
import 'package:firebase_crud_project/helper/firestore_db.dart';
import 'package:firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:firebase_crud_project/screens/login_page/login_screen.dart';

class AuthController extends GetxController {
  late Rx<User?> firebaseUser;
  static AuthController instance = Get.find<AuthController>();

  // late ConfirmationResult confirmationResult;  // ! For Phone Authentication
  late Rx<GoogleSignInAccount?> googleSignInAccount;

  // ! SIGNUP FUNCTION
  Future<void> register(
      String email,
      String password,
      String firstName,
      String lastName,
      String imagePath,
      String imageName,
      BuildContext context) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                FirestoreDB.postDetailsToFirestore(
                    firstName, lastName, imagePath, imageName, context),
              });
    } catch (e) {
      Fluttertoast.showToast(
        msg: errorMessage(
          e.toString(),
        ),
      );
    }
  }

  // ! LOGIN FUNCTION
  Future<bool?> login(
      String email, String password, BuildContext context) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: 'Login Successful'),
              });
      Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: errorMessage(
          e.toString(),
        ),
      );
    }
  }

  // ! ERROR MESSAGES FUNCTION
  String errorMessage(String? e) {
    if (e ==
        "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
      return "There is no user record corresponding to this identifier. The user may have been deleted.";
    } else if (e ==
        "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
      return "The password is invalid or the user does not have a password.";
    } else if (e ==
        "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
      return "The email address is already in use by another account.";
    }
    //
    else {
      return "";
    }
  }

  // ! LOGOUT FUNCTION
  Future<void> logout(BuildContext context) async {
    await auth.signOut().then((value) => {
          Fluttertoast.showToast(msg: "Logged Out!"),
        });
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.id, (route) => false);
  }
}
