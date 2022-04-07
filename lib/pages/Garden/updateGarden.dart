import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flower/api/gardenApi.dart';

import 'package:learn_flower/dialogs/custom_dialog_box.dart';

import 'gardenList.dart';

class UpdateGarden extends StatefulWidget {
  final productId;
  final name;
  final picture;
  final location;
  final time;
  final ticket;

   UpdateGarden({
    this.productId,
    this.name,
    this.picture,
    this.location,
    this.time,
     this.ticket
  });



  @override
  _UpdateGardenState createState() => _UpdateGardenState();
}

class _UpdateGardenState extends State<UpdateGarden> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController ticketController = new TextEditingController();


  var flowerNameFocus = FocusNode();
  var locationFocus = FocusNode();
  var timeFocus = FocusNode();
  var ticketFocus = FocusNode();

  late String  imageURL='';

  late Database db;
  List docs = [];
  initialise() {
    db = Database();
    db.initiliase();

  }

  @override
  void initState() {
    super.initState();
    nameController.text =widget.name;
    locationController.text = widget.location;
    timeController.text = widget.time;
    ticketController.text = widget.ticket;
    imageURL=widget.picture;
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor:Colors.white,
        title: Text("Flower View"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                db.deleteGarden(widget.productId);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CustomDialogBox(
                        title: "Garden Deleted !",
                        descriptions: "Garden deleted successfully!",
                        text: "Yes",
                      );
                    }).whenComplete(() =>
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GardenList())));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.network(
                      imageURL,
                      width: 250,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
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
                        controller: locationController,
                        focusNode: locationFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'location',
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
                        controller: timeController,
                        focusNode: timeFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'opening hours',
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
                        controller: ticketController,
                        focusNode: ticketFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ticket price',
                          // icon:Icon(Icons.lock_outline),
                        ),

                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 5,
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
                if (imageURL == null) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Garden Image !",
                          descriptions:
                          "Hii Please select an image of the Garden",
                          text: "Yes",
                        );
                      }).whenComplete(() => uploadImage());
                } else if (nameController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Flower Name !",
                          descriptions:
                          "Hii Please Enter the name of the flower",
                          text: "Yes",
                        );
                      })
                      .whenComplete(() =>
                      FocusScope.of(context).requestFocus(flowerNameFocus));
                }
                else if (locationController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: " Garden location !",
                          descriptions:
                          "Hii Please Enter the name of the Garden location",
                          text: "Yes",
                        );
                      })
                      .whenComplete(() =>
                      FocusScope.of(context).requestFocus(locationFocus));
                }
                else if (timeController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: " opening hours !",
                          descriptions:
                          "Hii Please Enter the name of the opening hours",
                          text: "Yes",
                        );
                      })
                      .whenComplete(() =>
                      FocusScope.of(context).requestFocus(timeFocus));
                } else if (ticketController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Ticket price !",
                          descriptions:
                          "Hii Please Enter the description of the Ticket price",
                          text: "Yes",
                        );
                      })
                      .whenComplete(() => FocusScope.of(context)
                      .requestFocus(ticketFocus));
                } else {
                  db.updateGarden(widget.productId, nameController.text,locationController.text,timeController.text,ticketController.text, imageURL);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Garden  Updated !",
                          descriptions: "Garden updated successfully!",
                          text: "Yes",
                        );
                      }).whenComplete(() =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GardenList())));
                }
              },
              child: const Text(
                "Update Flower",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }


  Future<void> uploadImage() async {
    final _fireStorage = FirebaseStorage.instance;
    final image = ImagePicker();
    PickedFile? pickedFile;

    // Request Photos Permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    // Checking Permission
    if (permissionStatus.isGranted) {
      pickedFile = await image.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        // Getting File Path
        String fileName = file.uri.path.split('/').last;

        // Uploading Image to FirebaseStorage
        var filePath = await _fireStorage
            .ref()
            .child('demo/$fileName')
            .putFile(file)
            .then((value) {
          return value;
        });
        // Getting Uploaded Image Url
        String downloadUrl = await filePath.ref.getDownloadURL();
        String oldImageURL = imageURL;
        imageURL = downloadUrl;
        setState(() {});
        //delete old image from the firebase storage
        FirebaseStorage.instance.refFromURL(oldImageURL).delete().then(
                (_) => print('Successfully deleted $oldImageURL storage item'));
      } else {
        print('No Image Selected');
      }
    } else {
      print('Provider Permission');
    }
  }
}
