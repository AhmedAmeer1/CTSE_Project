


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_flower/api/user_model.dart';
import 'package:learn_flower/signIn.dart';

import 'api/feedbackApi.dart';
import 'dialogs/custom_dialog_box.dart';
import 'homePage.dart';




class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _numberTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

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
        title: Text('Registration '),
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
                  child: Image.asset('assets/registration-img.png',width: 150.0,height: 150.0,),
                ),
              ),
              SizedBox(
                height: 30,
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
                          hintText: 'First NAME',
                          // icon:Icon(Icons.lock_outline),
                        ),

                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 5,
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
                height: 5,
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
                          // icon:Icon(Icons.lock_outline),
                        ),

                      ),
                    ),
                  )
              ),
              SizedBox(
                height:5,
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
                          // icon:Icon(Icons.lock_outline),
                        ),

                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 5,
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
                                  title: "Description !",
                                  descriptions:
                                  "Hii Please Enter the Description r",
                                  text: "OK",
                                );
                              }).whenComplete(() =>
                              FocusScope.of(context).requestFocus(passwordFocus));
                        }
                        else if (_nameTextController.text.isEmpty) {
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
                              FocusScope.of(context).requestFocus(nameFocus));
                        }
                        else if (_numberTextController.text.isEmpty) {
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
                              FocusScope.of(context).requestFocus(numberFocus));
                        }
                        else {
                          signUp(
                              _nameTextController.text,_numberTextController.text,_emailTextController.text,_passwordTextController.text );

                        }
                      },
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: const Text(
                        'Registration',
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
                      builder: (context) => SignIn()
                  )),
                  child: Text('If you  have a Account click SignIn',
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
  void signUp(String name, String number, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) =>
            {
              createUser() ,
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialogBox (
                      title: ("Registration successfull !"),
                      descriptions: "Your Registration is successfull!",
                      text: "ok",
                    );
                  })
                  .whenComplete(() =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: 'Flower',))))


            })
            .catchError((e) {

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialogBox (
              title: ("Registration Unsuccessfull !"),
              descriptions: "Your Registration is Unsuccessfull!",
              text: "ok",
            );
          })
          .whenComplete(() =>
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUp())));

    });





  }

  createUser() async {
        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        User? user = _auth.currentUser;

        UserModel userModel = UserModel();

        userModel.email = user!.email;
        userModel.uid = user.uid;
        userModel.firstName = _nameTextController.text;
        userModel.phoneNumber = _numberTextController.text;

        await firebaseFirestore
            .collection("users")
            .doc(user.uid)
            .set( userModel.toMap());

  }//create user brackey end



}





//44:22