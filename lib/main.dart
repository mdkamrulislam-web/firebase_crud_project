import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_crud_project/controllers/auth_controller.dart';
import 'package:firebase_crud_project/screens/home_page/home_screen.dart';
import 'package:firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:firebase_crud_project/screens/passcode_page/passcode_screen.dart';
import 'package:firebase_crud_project/screens/signup_page/info_screen.dart';
import 'package:firebase_crud_project/screens/signup_page/signup_screen.dart';
import 'package:firebase_crud_project/screens/login_page/forgot_password_screen.dart';
import 'package:firebase_crud_project/screens/signup_page/terms_conditions_screen.dart';
import 'package:firebase_crud_project/screens/secure_code_page/secure_code_screen.dart';
import 'package:firebase_crud_project/screens/phone_number_page/phone_number_screen.dart';
import 'package:firebase_crud_project/theme/theme.dart';
import 'package:firebase_crud_project/l10n/locale_string.dart';
import 'constants/firebase_auth_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await firebaseInitilization.then((value) {
    Get.put(AuthController());
  });

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        // ! Theme Settings
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: currentTheme.currentTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: auth.currentUser == null ? LoginScreen.id : HomeScreen.id,
        routes: {
          // ! Task 4
          LoginScreen.id: (context) => const LoginScreen(),
          ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
          SignupScreen.id: (context) => const SignupScreen(),
          InfoScreen.id: (context) => const InfoScreen(),
          TermsConditionsScreen.id: (context) => const TermsConditionsScreen(),
          PhoneNumberScreen.id: (context) => const PhoneNumberScreen(),
          SecureCodeScreen.id: (context) => const SecureCodeScreen(),
          PasscodeScreen.id: (context) =>
              const PasscodeScreen(userPasscode: '1234'),
          HomeScreen.id: (context) => const HomeScreen(),
        },

        title: 'Login Signup Demo',

        translations: LocaleString(),
        locale: const Locale('en', 'US'),
      ),
    );
  }
}
