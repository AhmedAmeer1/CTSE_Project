import 'package:flutter/material.dart';
import 'package:learn_flower/pages/FlowerRequest/viewRequest.dart';
import '../../api/userApi.dart';
import '../../dialogs/custom_dialog_box.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}
class _UserDetailsState extends State<UserDetails> {

  late Database db;
  List docs =[];

  initialise(){
    db=Database();
    db.initiliase();
    db.readUserDetails().then((value) =>{
      setState((){
        docs=value;
      })
    } );
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('User Details '),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [

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
                            title: Padding(
                              padding: const EdgeInsets.only(top:30.0),
                              child: Text('Email Address :'+docs[index]['email'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                            ),
                            subtitle: Padding(
                              padding: const  EdgeInsets.only(top:10),
                              child: Text('Number :'+docs[index]['phoneNumber'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                            ),
                            leading: Text('Name :'+docs[index]['firstName'],style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16),),
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
                                          title: "Request Flower Deleted !",
                                          descriptions: "Request Flower deleted successfully!",
                                          text: "Yes",
                                        );
                                      }).whenComplete(() => Navigator.of(context).push(MaterialPageRoute( builder: (context) => const RequestDetails())));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
