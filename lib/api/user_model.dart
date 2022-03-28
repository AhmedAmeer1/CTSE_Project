class UserModel{

  String? uid;
  String? email;
  String? firstName;
  String? phoneNumber;

  UserModel({
    this.uid, this.email, this.firstName, this.phoneNumber,
  });


  factory UserModel.fromMap(map)
  {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      phoneNumber: map['phoneNumber'],
    );

  }


 Map<String,dynamic> toMap()
  {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'phoneNumber': phoneNumber,
    };

  }



}