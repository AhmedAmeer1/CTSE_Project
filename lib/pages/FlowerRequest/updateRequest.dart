import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:learn_flower/pages/FlowerRequest/userViewRequest.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../api/flowerRequestApi.dart';
import '../../dialogs/custom_dialog_box.dart';
import '../Flower/homePage.dart';

class UpdateRequest  extends StatefulWidget {

  final Id;
  final name;
  final description;
  final email;


  UpdateRequest({
    this.Id,
    this.name,
    this.description,
    this.email,

  });




  @override
  _UpdateRequestState createState() => _UpdateRequestState();
}

class _UpdateRequestState extends State<UpdateRequest> {
  late Database db;


  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _flowerNameTextController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _idTextController = TextEditingController();



  var flowerNameFocus = FocusNode();
  var emailFocus = FocusNode();
  var descriptionFocus = FocusNode();


  initialise() {
    db = Database();
    db.initiliase();

  }

  @override
  void initState() {
    super.initState();
    _idTextController.text =widget.Id;
    _emailTextController.text =widget.email;
    _flowerNameTextController.text = widget.name;
    _descriptionController.text = widget.description;

    initialise();
  }




  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height/3;

    return Scaffold(
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('Request a flower '),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body:  SingleChildScrollView(

        child: Container(

          padding: EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
          child: Column(
            children: [


              Padding(
                padding: const EdgeInsets.only(top:30),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/images/13.png',width: 150.0,height: 150.0,),
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
                        controller: _flowerNameTextController,
                        focusNode: flowerNameFocus,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Flower Name',
                          icon:Icon(Icons.account_tree),
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
                          icon:Icon(Icons.email),
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
                        controller: _descriptionController,
                        focusNode: descriptionFocus,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description',
                          // icon:Icon(Icons.lock_outline),
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
                else if (_flowerNameTextController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Flower Name !",
                          descriptions:
                          "Hii Please Enter the name of the flower",
                          text: "OK",
                        );
                      })
                      .whenComplete(() =>
                      FocusScope.of(context).requestFocus(flowerNameFocus));
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
                  db.updateRequest(_idTextController.text,_flowerNameTextController.text,_descriptionController.text );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox (
                          title: ("Request Updates"),
                          descriptions: "Flower Request added successfully!",
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
                "Save",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}
