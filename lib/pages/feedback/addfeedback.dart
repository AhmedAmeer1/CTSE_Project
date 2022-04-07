import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/feedbackApi.dart';
import '../../api/user_model.dart';
import '../../dialogs/custom_dialog_box.dart';
import '../Flower/homePage.dart';

class Feedbackpage extends StatefulWidget {
  final id;
  final email;
  Feedbackpage({
    this.id,
    this.email,
  });

   @override
  _FeedbackpageState createState() => _FeedbackpageState();
}

class _FeedbackpageState extends State<Feedbackpage> {
  late Database db;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _idTextController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    _emailTextController.text= widget.email ;
    _idTextController.text= widget.id ;
  }
  var emailFocus = FocusNode();
  var descriptionFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height/3;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('Feedback '),
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
                padding: const EdgeInsets.only(top:60),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/images/13.png',width: 150.0,height: 150.0,),
                ),
              ),
              SizedBox(
                height: 60,
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
                        controller: _emailTextController,
                        focusNode: emailFocus,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          icon:Icon(Icons.email),
                        ),
                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 20,
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
                        controller: _descriptionController,
                        focusNode: descriptionFocus,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description',
                        ),
                      ),
                    ),
                  )
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
               if (_emailTextController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Flower Name !",
                          descriptions:
                          "Hii Please Enter the Flower Name",
                          text: "OK",
                        );
                      }).whenComplete(() =>
                      FocusScope.of(context).requestFocus(emailFocus));
                }
                else if (_descriptionController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Description !",
                          descriptions:
                          "Hii Please Enter the Description r",
                          text: "OK",
                        );
                      }).whenComplete(() =>
                      FocusScope.of(context).requestFocus(descriptionFocus));
                }
                else {
                 db.createFeedback(_idTextController.text,_emailTextController.text,_descriptionController.text );
                 showDialog(
                     context: context,
                     builder: (BuildContext context) {
                       return const CustomDialogBox (
                         title: ("Feedback Added !"),
                         descriptions: "Feedback added successfully!",
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
                "Add Feedback",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }


}
