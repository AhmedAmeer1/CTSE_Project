import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';
import '../../api/flowerApi.dart';
import 'package:learn_flower/dialogs/custom_dialog_box.dart';
import 'flowersList.dart';

class Add extends StatefulWidget {
  Add({Key ? key, required this.db}) : super(key: key);
  Database db;
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  AssetImage _imageToShow = AssetImage('assets/upload_image.png');

  var flowerNameFocus = FocusNode();
  var flowerDescriptionFocus = FocusNode();

  get title => null;
  @override
  void initState() {
    super.initState();
  }

  String imageURL='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('Add Flower '),
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
              (!imageURL.isEmpty)
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Stack(children: [
                    Image.network(
                      imageURL,
                      width: 250,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 2.0,
                      bottom: 6.0,
                      child: ElevatedButton(
                        onPressed: () => uploadImage(),
                        child: Icon(Icons.camera_alt),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15),
                        ),
                      ),
                    )
                  ]),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      'assets/images/imgUpload.png',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 2.0,
                    bottom: 2.0,
                    child: ElevatedButton(
                      onPressed: () => uploadImage(),
                      child: Icon(Icons.camera_alt),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                  )
                ]),
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
                        controller: nameController,
                        focusNode: flowerNameFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Flower Name',
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
                  padding: const EdgeInsets.fromLTRB(14.0,8.0,14.0,8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.withOpacity(0.4),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0),
                      child: TextFormField(
                        controller: descriptionController,
                        focusNode: flowerDescriptionFocus,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Flower Description',
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
                if (imageURL.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Flower Image !",
                          descriptions:
                          "Hii Please select an image of the flower",
                          text: "Yes",
                        );
                      }).whenComplete(() => uploadImage());
                }
               else if (nameController.text.isEmpty) {
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
                  FocusScope.of(context).requestFocus(flowerNameFocus));
                  }
                  else if (descriptionController.text.isEmpty) {
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
                      FocusScope.of(context).requestFocus(flowerDescriptionFocus));
                  }
                  else {
                    widget.db.create(nameController.text, descriptionController.text, imageURL );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox (
                          title: ("Flower Added !"),
                          descriptions: "Flower added successfully!",
                          text: "ok",
                      );
                    })
                        .whenComplete(() =>
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => FlowersList())));
                  }
                  },


              child: Text(
                "Add Flower",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }









  Future<void> uploadImage() async {
    final _fireStorage = FirebaseStorage.instance;
    final image = ImagePicker();
  final  XFile? pickedFile;

    // Request Photos Permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    // Checking Permission
    if (permissionStatus.isGranted) {
      pickedFile   = await image.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        // Getting File Path
         imageURL = file.uri.path.split('/').last;

        // Uploading Image to FirebaseStorage
        var filePath = await _fireStorage
            .ref()
            .child('demo/$imageURL')
            .putFile(file)
            .then((value) {
          return value;
        });
        // Getting Uploaded Image Url
        String downloadUrl = await filePath.ref.getDownloadURL();
        imageURL = downloadUrl;
        setState(() {});
      } else {
        print('No Image Selected');
      }
    } else {
      print('Provider Permission');
    }
  }
}
