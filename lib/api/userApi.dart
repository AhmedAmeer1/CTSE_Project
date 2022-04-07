
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_flower/api/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../dialogs/custom_dialog_box.dart';

class Database {
  late FirebaseFirestore firestore;

  final _auth = FirebaseAuth.instance;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }


  //login function
  Future<bool> signIn(String email, String password) async {
      bool loginSuccess=false;
        await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) =>
           {
              loginSuccess=true,
           }).catchError((e) {
              loginSuccess=false;
              });
      return loginSuccess;
  }



  Future<bool> signUp(String name, String number, String email, String password) async {
    bool loginSuccess=false;
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) =>
    {
      createUser(name,number) ,
      loginSuccess=true,
    })
        .catchError((e) {
      loginSuccess=false;
    });

    return loginSuccess;


  }

  //creating a new user
  createUser(String name, String number) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = name.toString();
    userModel.phoneNumber = number.toString();

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set( userModel.toMap());

  }




//view user details
  Future<List> readUserDetails() async{
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('users')
          .get();
      //String searchQuery = "";
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          {
            Map a = {
              "id":doc.id,
              "email": doc['email'],
              "firstName": doc["firstName"],
              "phoneNumber": doc["phoneNumber"],
            };
            docs.add(a);
          }
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }

    return docs;
  }

  // update user details
  Future<void> update(String id, String firstName, String phoneNumber) async {
    try {
      await firestore
          .collection("users")
          .doc(id)
          .update({'firstName': firstName, 'phoneNumber': phoneNumber});
    } catch (e) {
      print(e);
    }
  }


  Future<void> delete(String id) async {
    try {
      await firestore.collection("Request Flower").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }






}