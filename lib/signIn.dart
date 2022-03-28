


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_flower/api/user_model.dart';
import 'package:learn_flower/signIn.dart';
import 'package:learn_flower/signup.dart';

import 'api/feedbackApi.dart';
import 'dialogs/custom_dialog_box.dart';
import 'homePage.dart';




class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late Database db;

  final _auth = FirebaseAuth.instance;

  initialise(){
    db=Database();
    db.initiliase();
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();





  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height/3;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('Login '),
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
                padding: const EdgeInsets.only(top:20),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/login-img.png',width: 150.0,height: 150.0,),
                ),
              ),
              SizedBox(
                height: 60,
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
                        controller: _emailTextController,
                        focusNode: emailFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          icon: Icon(Icons.email),
                          // icon:Icon(Icons.lock_outline),
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
                        controller: _passwordTextController,
                        focusNode: passwordFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          icon: Icon(Icons.password),
                          // icon:Icon(Icons.lock_outline),
                        ),

                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      14.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.green.shade700,
                    elevation: 0.0,
                    child: MaterialButton(
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
                        else if (_passwordTextController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialogBox(
                                  title: "password !",
                                  descriptions:
                                  "Hii Please Enter the Description r",
                                  text: "OK",
                                );
                              }).whenComplete(() =>
                              FocusScope.of(context).requestFocus(passwordFocus));
                        }
                        else {
                          signIn(
                              _emailTextController.text,_passwordTextController.text );

                        }
                      },
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: const Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignUp()
                  )),
                  child: Text('If you dont have a Account click SignUp',
                      style: TextStyle(color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      ),


    );
  }



  //login function
  void signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) =>
    {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return const CustomDialogBox (
            title: ("Login successfull !"),
            descriptions: "Your Login is successfull!",
            text: "ok",
      );
    })
        .whenComplete(() =>
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => MyHomePage(title: 'Flower',))))


    }).catchError((e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialogBox (
              title: ("Login Unsuccessfull !"),
              descriptions: "Your Login is Unsuccessfull!",
              text: "ok",
            );
          })
          .whenComplete(() =>
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignIn())));
    });
  }



}





//44:22