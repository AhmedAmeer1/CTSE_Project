import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_flower/pages/Garden/gardenList.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../api/gardenApi.dart';
import 'package:learn_flower/dialogs/custom_dialog_box.dart';

class AddGarden extends StatefulWidget {
  AddGarden({Key ? key, required this.db}) : super(key: key);
  Database db;
  @override
  _AddGardenState createState() => _AddGardenState();
}

class _AddGardenState extends State<AddGarden> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController ticketController = new TextEditingController();
  AssetImage _imageToShow = AssetImage('assets/upload_image.png');

  var flowerNameFocus = FocusNode();
  var locationFocus = FocusNode();
  var ticketFocus = FocusNode();
  var timeFocus = FocusNode();

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
        title: Text('Add Garden '),
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
                    padding: const EdgeInsets.only(top: 20),
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
                        controller: nameController,
                        focusNode: flowerNameFocus,

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Garden Name',
                         icon:Icon(Icons.image_aspect_ratio)
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
                          hintText: 'Location',
                          icon:Icon(Icons.location_city)
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
                          hintText: 'Opening Hours',
                          icon:Icon(Icons.time_to_leave)
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
                          hintText: 'Ticket Price',
                          icon: Icon(Icons.price_change),
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
                if (imageURL.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Flower Image !",
                          descriptions:
                          "Hii Please select an image of the flower",
                          text: "ok",
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
                else if (locationController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Location !",
                          descriptions:
                          " Please Enter the Location",
                          text: "OK",
                        );
                      }).whenComplete(() =>
                      FocusScope.of(context).requestFocus(locationFocus));
                }
                else if (timeController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: " Opening Hours!",
                          descriptions:
                          " Please Enter the Opening Hours",
                          text: "OK",
                        );
                      }).whenComplete(() =>
                      FocusScope.of(context).requestFocus(timeFocus));
                }
                  else if (ticketController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox(
                          title: "Ticket !",
                          descriptions:
                          "Hii Please Enter the Ticket",
                          text: "OK",
                    );
                    }).whenComplete(() =>
                      FocusScope.of(context).requestFocus(ticketFocus));
                  }
                  else {
                    widget.db.createGarden(nameController.text, locationController.text,timeController.text,ticketController.text, imageURL );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CustomDialogBox (
                          title: ("Garden Added !"),
                          descriptions: "Garden added successfully!",
                          text: "ok",
                      );
                    })
                        .whenComplete(() =>
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => GardenList()))
                    );
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
