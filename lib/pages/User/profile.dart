import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flower/pages/Flower/homePage.dart';

import '../../api/user_model.dart';
import '../../dialogs/custom_dialog_box.dart';
import '../../api/userApi.dart';

class Profile extends StatefulWidget {
  final id;
  final name;
  final number;
  Profile({
    this.id,
    this.name,
    this.number,
  });
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Database db;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _numberTextController = TextEditingController();
  TextEditingController _idTextController = TextEditingController();
  List docs = [];
  initialise() {
    db = Database();
    db.initiliase();
  }
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser =UserModel();

  @override
  void initState() {
    super.initState();
    initialise();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser =UserModel.fromMap(value.data());
      setState(() {
      });
    });

     _nameTextController.text =widget.name;
     _idTextController.text= widget.id ;
     _numberTextController.text = widget.number;
 }

  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();
  var nameFocus = FocusNode();
  var numberFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height/3;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text("${loggedInUser.firstName}",style: TextStyle(color: Colors.black),),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:70),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/registration-img.png',width: 150.0,height: 150.0,),
                ),
              ),
              SizedBox(
                height: 130,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(14.0,8.0,14.0,8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.4),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0),
                      child: TextFormField(
                        controller: _nameTextController,
                        focusNode: nameFocus,
                        decoration: const InputDecoration(
                        border: InputBorder.none,
                        ),
                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(14.0,8.0,14.0,8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.4),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0),
                      child: TextFormField(
                        controller: _numberTextController,
                        focusNode: numberFocus,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Telephone Number',
                          // icon:Icon(Icons.lock_outline),
                        ),
                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          child: RaisedButton(
              color: Colors.green.shade700,
              onPressed: () {
                 if (_nameTextController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Name !",
                          descriptions:"Hii Please Enter the Name",
                          text: "OK",
                        );
                      }).whenComplete(() =>
                      FocusScope.of(context).requestFocus(nameFocus));
                }
                else if (_numberTextController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Number !",
                          descriptions:"Hii Please Enter the Number ",
                          text: "OK",
                        );
                      }).whenComplete(() =>
                      FocusScope.of(context).requestFocus(numberFocus));
                }
                 else if (_numberTextController.text.length!=10) {
                   showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         return const CustomDialogBox(
                           title: "Invalid Number !",
                           descriptions:"Hii Please Enter the Correct Number",
                           text: "OK",
                         );
                       }).whenComplete(() =>
                       FocusScope.of(context).requestFocus(numberFocus));
                 }
                else {
                  db.update(_idTextController.text,_nameTextController.text,_numberTextController.text );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox (
                          title: ("User Details !"),
                          descriptions: "User Details  Updated successfully!",
                          text: "ok",
                        );
                      })
                      .whenComplete(() =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(title: 'Flower',))));
                }
              },
              child: const Text(
                "Update Profile",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}

