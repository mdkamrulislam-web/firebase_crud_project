import 'package:flutter/material.dart';
import 'package:firebase_crud_project/screens/signup_page/info_screen.dart';
import 'package:firebase_crud_project/screens/secure_code_page/secure_code_screen.dart';
import 'package:firebase_crud_project/screens/signup_page/terms_conditions_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);
  static const String id = "phone_number_screen";

  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  // * Form Key
  final _formKey = GlobalKey<FormState>();

  // * Editing Controller
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // ! Phone Number Field
    final phoneNumberField = TextFormField(
      decoration: InputDecoration(
        // prefixText: 'dcdcd',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: const Color(0xFFf3f3f3),
        filled: true,
        hintText: 'Phone Number',
        prefix: const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            "(+880)",
          ),
        ),
        suffixIcon: const Icon(
          Icons.check_circle,
          color: Color(0xFF1cbb7c),
        ),
      ),
      autofocus: false,
      controller: phoneNumberController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        phoneNumberController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    // ! Sign Up Button
    final getSecureCodeButton = ElevatedButton(
      onPressed: () {
        // ignore: avoid_print
        print("Getting Secure Code!");
        Navigator.pushNamed(context, SecureCodeScreen.id);
      },
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Get Secure Code",
          style: TextStyle(fontSize: 18),
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          const Color(0xFF1cbb7c),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // ignore: avoid_print
                        print("Going Back!");
                        Navigator.pop(context);
                      });
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF1cbb7c),
                        ),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1cbb7c),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: size.width / 15,
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // ignore: avoid_print
                        print("Showing Info!");
                        Navigator.pushNamed(context, InfoScreen.id);
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          "Info",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1cbb7c),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                        fontSize: size.width / 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0x0fffffff),
                            borderRadius: BorderRadius.circular(10)),
                        child: phoneNumberField,
                      ),
                    ),
                    // ! Get Secure Code Button
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 24.0, left: 16, right: 16),
                            child: getSecureCodeButton,
                          ),
                        ),
                      ],
                    ),
                    // ! Terms & Conditions
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "I agree to ",
                            style: TextStyle(
                              color: Color(0xFF899cad),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // ignore: avoid_print
                                print("Showing Terms and Conditions");
                                Navigator.pushNamed(
                                    context, TermsConditionsScreen.id);
                              });
                            },
                            child: const Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                color: Color(0xFF1cbb7c),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
