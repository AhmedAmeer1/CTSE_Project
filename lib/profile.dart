


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_flower/signIn.dart';

import 'api/userApi.dart';
import 'api/user_model.dart';
import 'dialogs/custom_dialog_box.dart';
import 'homePage.dart';




class Profile extends StatefulWidget {

  final name;
  final number;

  Profile({
    this.name,
    this.number,

  });

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Database db;

  final _auth = FirebaseAuth.instance;


  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _numberTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  List docs = [];
  initialise() {
    db = Database();
    db.initiliase();

  }

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser =UserModel();
  // late var uid ;
  // static const  email ;




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
     // _nameTextController= loggedInUser.firstName as TextEditingController ;
     _numberTextController.text = widget.number;
     // _emailTextController.text =user.id ;
     // _passwordTextController.text = loggedInUser.firstName! ;


  }




  // doc['email'],



  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();

  var nameFocus = FocusNode();
  var numberFocus = FocusNode();


// final name =TextFormField();




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
                padding: const EdgeInsets.only(top:20),
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
                        controller: _nameTextController,
                        focusNode: nameFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,


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
                height: 10,
              ),
              // Padding(
              //     padding: const EdgeInsets.fromLTRB(14.0,8.0,14.0,8.0),
              //     child: Material(
              //       borderRadius: BorderRadius.circular(10.0),
              //       color: Colors.grey.withOpacity(0.4),
              //       elevation: 0.0,
              //       child: Padding(
              //         padding: const EdgeInsets.only(left:12.0),
              //         child: TextFormField(
              //           controller: _emailTextController,
              //           focusNode: emailFocus,
              //
              //           decoration: const InputDecoration(
              //             border: InputBorder.none,
              //             hintText: 'Email',
              //             // icon:Icon(Icons.lock_outline),
              //           ),
              //
              //         ),
              //       ),
              //     )
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Padding(
              //     padding: const EdgeInsets.fromLTRB(14.0,8.0,14.0,8.0),
              //     child: Material(
              //       borderRadius: BorderRadius.circular(10.0),
              //       color: Colors.grey.withOpacity(0.4),
              //       elevation: 0.0,
              //       child: Padding(
              //         padding: const EdgeInsets.only(left:12.0),
              //         child: TextFormField(
              //           controller: _passwordTextController,
              //           focusNode: passwordFocus,
              //
              //           decoration: const InputDecoration(
              //             border: InputBorder.none,
              //             hintText: 'Password',
              //             // icon:Icon(Icons.lock_outline),
              //           ),
              //
              //         ),
              //       ),
              //     )
              // ),
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
                  update(
                      _nameTextController.text,_numberTextController.text );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox (
                          title: ("Registration Added !"),
                          descriptions: "Registration added successfully!",
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


              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }






  Future<void> update(String firstName, String phoneNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {

      UserModel userModel = UserModel();
      userModel.email = 'dsdsdsdsd';
      userModel.uid = user?.uid;
      userModel.firstName = 'dsdsdsdsd';
      userModel.phoneNumber = 'dsdsdsdsd';
    ;

      await firestore
          .collection("users")
          .doc('dDJA5DYGtMQLTxUJKLow81Z7Jmc2')
          .update({'firstName': firstName, 'phoneNumber': phoneNumber});
    } catch (e) {
      print(e);
    }
  }


  //login function
  void signUp(String name, String number, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) =>
    {
      createUser(name,number,email,password) ,



    })
        .catchError((e) {

      // Navigator.pushAndRemoveUntil(
      //     (context),
      //     MaterialPageRoute(builder: (context) => SignIn()),
      //         (route) => false);

    });





  }












  createUser(String name, String number,String email, String password) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    final userDetails ={
      'uid':user?.uid,
      'name':name,
      'number':number,
      'email': email,
      'password': password,
      'timestamp': FieldValue.serverTimestamp()
    };




    await firestore
        .collection("users")
        .doc(user?.uid)
        .set( userDetails);

  }



}





//44:22