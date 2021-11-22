import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';
import 'package:firebase_crud_project/helper/firestore_db.dart';
import 'package:firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:firebase_crud_project/screens/login_page/login_screen.dart';
// import 'package:firebase_crud_project/screens/signup_page/signup_screen.dart';

class AuthController extends GetxController {
  late Rx<User?> firebaseUser;
  static AuthController instance = Get.find<AuthController>();

  // late ConfirmationResult confirmationResult;  // ! For Phone Authentication
  late Rx<GoogleSignInAccount?> googleSignInAccount;
  // String? errorMessage;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);

    firebaseUser.bindStream(auth.userChanges());

    ever(firebaseUser, _setInitialScreen);

    // Google Signed in Account
    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSignIn.currentUser);
    googleSignInAccount.bindStream(googleSignIn.onCurrentUserChanged);

    ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
      // SignupScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignedInAccount) {
    if (googleSignedInAccount == null) {
      Get.offAll(() => const LoginScreen());
      // SignupScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  // ! SIGNUP WITH GOOGLE FUNCTION
  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // ignore: invalid_return_type_for_catch_error
        await auth.signInWithCredential(credential).catchError((err) => {
              // print(err),
            });
      }
    } on FirebaseAuthException catch (firebaseAuthException) {
      Get.snackbar(
        "Error!",
        firebaseAuthException.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // print(e.toString());
    }
  }

  // ! SIGNUP FUNCTION
  Future<void> register(
      String email, String password, String firstName, String lastName) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) =>
              {FirestoreDB.postDetailsToFirestore(firstName, lastName)});
      // await FirestoreDB.addUser(email, firstName, lastName);
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            // e.toString(),
            errorMessage(
          e.toString(),
        ),
      );
      // print(e.toString());
    }
  }

  // ! LOGIN FUNCTION
  Future<void> login(String email, String password) async {
    // String errorMessage;
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {Fluttertoast.showToast(msg: 'Login Successful')});
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            // e.toString(),
            errorMessage(
          e.toString(),
        ),
      );
      // print(e.toString());
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
  Future<void> logout() async {
    await auth.signOut();
  }

  // ! POSTING VALUES ON FIRESTORE DATABASE FUNCTION

}
