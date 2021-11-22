class UserModel {
  String? uid, email, firstName, lastName;

  UserModel({this.uid, this.email, this.firstName, this.lastName});

  //Receiving Data From Server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }

  //Sending Data to Server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email!.toLowerCase(),
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
