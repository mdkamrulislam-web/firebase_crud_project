import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud_project/screens/login_page/login_screen.dart';
import 'package:firebase_crud_project/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';
import 'package:firebase_crud_project/models/data_model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = auth.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String? url = "";
    double height = MediaQuery.of(context).size.height;

    // ! First Name Field
    final firstNameField = TextFormField(
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      decoration: InputDecoration(
        labelText: "firstName".tr,
        floatingLabelStyle: const TextStyle(
          //
          color: Color(0xFF1cbb7c),
          fontWeight: FontWeight.w600,
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFF1cbb7c),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: theme.focusColor == Colors.white
            ? Colors.grey.shade800
            : const Color(0xFFf3f3f3),
        filled: true,
      ),
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Please Enter Your First Name");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Name (Minimum 2 Characters.)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );
    // ! Last Name Field
    final lastNameField = TextFormField(
      style: TextStyle(
        color: theme.focusColor == Colors.white ? Colors.white : Colors.black,
      ),
      cursorColor: const Color(0xFF1cbb7c),
      decoration: InputDecoration(
        labelText: "lastName".tr,
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF1cbb7c),
          fontWeight: FontWeight.w600,
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFF1cbb7c),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: theme.focusColor == Colors.white
            ? Colors.grey.shade800
            : const Color(0xFFf3f3f3),
        filled: true,
      ),
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Please Enter Your Last Name");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Name (Minimum 2 Characters.)");
        }
        return null;
      },
      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    // ! Update Button
    final updateButton = ElevatedButton(
      onPressed: () async {
        await firebaseFirestore.collection("users").doc(loggedInUser.uid).set({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
        });
      },
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Upadate",
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
    try {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
                begin: FractionalOffset.bottomCenter,
                end: FractionalOffset.topCenter,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                "My Profile",
                style: TextStyle(
                  color: Color(0xFF1cbb7c),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    authController.logout(context);
                  },
                  icon: const Icon(Icons.logout),
                  color: const Color(0xFF1cbb7c),
                ),
              ],
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(loggedInUser.uid)
                  .collection("images")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Loading();
                } else {
                  return Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            // ignore: avoid_print
                            print("URL: $url");
                            url = snapshot.data!.docs[index]['downloadURL'];
                            // ignore: avoid_print
                            print("URL: $url");
                            return Column(
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 34),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.43,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              double innerHeight =
                                                  constraints.maxHeight;
                                              double innerWidth =
                                                  constraints.maxWidth;
                                              return Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height:
                                                          innerHeight * 0.72,
                                                      width: innerWidth,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 80,
                                                          ),
                                                          Text(
                                                            '${loggedInUser.firstName} ${loggedInUser.lastName}',
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF1cbb7c),
                                                              fontSize: 37,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            loggedInUser.email,
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await firebaseFirestore
                                                                  .collection(
                                                                      "users")
                                                                  .doc(
                                                                      loggedInUser
                                                                          .uid)
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    LoginScreen
                                                                        .id);
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Your Accout is Deleted!");
                                                              });
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              child: Text(
                                                                "Delete Account",
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 110,
                                                    right: 20,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          context: context,
                                                          builder: (context) =>
                                                              Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                            ),
                                                            // color: Color(0xFF737373),
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            child: Form(
                                                              key: _formKey,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        16),
                                                                child: Column(
                                                                  children: [
                                                                    // ! First Name Field
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              16),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color: theme.focusColor == Colors.white
                                                                                ? Colors.grey.shade900
                                                                                : const Color(0x0fffffff),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            firstNameField,
                                                                      ),
                                                                    ),
                                                                    // ! Last Name Field
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              16),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color: theme.focusColor == Colors.white
                                                                                ? Colors.grey.shade900
                                                                                : const Color(0x0fffffff),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            lastNameField,
                                                                      ),
                                                                    ),
                                                                    // ! Update Button
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 16.0),
                                                                            child:
                                                                                updateButton,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.settings,
                                                        size: 30,
                                                      ),
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(200),
                                                        child: url == null
                                                            ? const Loading()
                                                            : CachedNetworkImage(
                                                                width: 150,
                                                                height: 150,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                                imageUrl: url!,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      4.0,
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      );
    } on Exception {
      return const Loading();
    }
  }
}
