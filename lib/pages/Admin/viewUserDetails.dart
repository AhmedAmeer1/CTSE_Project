import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_flower/pages/Admin/viewFeedback.dart';
import '../../api/userApi.dart';
import '../../api/user_model.dart';
import '../../dialogs/custom_dialog_box.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}
class _UserDetailsState extends State<UserDetails> {

  late Database db;
  List docs =[];
  Object usermodel = UserModel();
  initialise(){
    db=Database();
    db.initiliase();
    db.readUserDetails().then((data) =>{
      setState((){
        usermodel=data;
      })
    } );
  }
  UserModel loggedInUser =UserModel();
  @override
  void initState() {
    super.initState();
    initialise();


    List docs = [];
    FirebaseFirestore.instance
        .collection("users")

        .get()
        .then((value) {
      this.loggedInUser =UserModel.fromMap(value.docs);
      setState(() {
        docs=loggedInUser as List;
      });

    } );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('Available Users '),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Image.asset(
          //   'assets/images/5.webp',
          //   fit: BoxFit.cover,
          //   height: double.infinity,
          //   width: double.infinity,
          // ),
          // Container(
          //   color: Colors.black.withOpacity(0.8),
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Container(
            child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (BuildContext context, int index){
                  return Card(
                      color: Colors.grey,
                      margin: EdgeInsets.all(10),
                      child :Column(
                        children: [
                          ListTile(
                            onTap: (){},
                            contentPadding: EdgeInsets.only(right:30,left:36,top:10),
                            title: Text(docs[index]['firstName']),
                            subtitle: Padding(
                              padding: const  EdgeInsets.only(top:10),
                              child: Text(docs[index]['email']),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Delete',style: TextStyle(color: Colors.red),),
                                onPressed: () {
                                  db.delete(docs[index]['id']);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomDialogBox(
                                          title: "Feedback Deleted !",
                                          descriptions: "Feedback deleted successfully!",
                                          text: "Yes",
                                        );
                                      }).whenComplete(() => Navigator.of(context).push(MaterialPageRoute( builder: (context) => const UserDetails())));
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
