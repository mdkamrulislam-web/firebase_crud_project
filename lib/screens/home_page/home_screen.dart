import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crud_project/constants/firebase_auth_constants.dart';
import 'package:firebase_crud_project/models/data_model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = auth.currentUser;
  UserModel loggedInUser = UserModel();
  String? url;

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                      return (const Center(
                        child: Text(
                          "No Image Found",
                        ),
                      ));
                    } else {
                      return Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                url = snapshot.data!.docs[index]['downloadURL'];
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
                                                builder:
                                                    (context, constraints) {
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
                                                          height: innerHeight *
                                                              0.72,
                                                          width: innerWidth,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
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
                                                                loggedInUser
                                                                    .email,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 110,
                                                        right: 20,
                                                        child: Icon(
                                                          Icons.settings,
                                                          color:
                                                              Colors.grey[700],
                                                          size: 30,
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
                                                                    .circular(
                                                                        200),
                                                            child:
                                                                Image.network(
                                                              url!,
                                                              width:
                                                                  innerWidth *
                                                                      0.45,
                                                              fit: BoxFit
                                                                  .fitWidth,
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
                                    // Image.network(
                                    //   url,
                                    //   height: 300,
                                    //   fit: BoxFit.cover,
                                    // ),
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
  }
}
