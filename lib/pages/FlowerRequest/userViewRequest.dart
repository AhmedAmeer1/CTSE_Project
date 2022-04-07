import 'package:flutter/material.dart';
import 'package:learn_flower/pages/FlowerRequest/requestFlower.dart';
import 'package:learn_flower/pages/FlowerRequest/requestFlower.dart';
import 'package:learn_flower/pages/FlowerRequest/updateRequest.dart';
import '../../api/flowerRequestApi.dart';
import '../../dialogs/custom_dialog_box.dart';
import '../FlowerRequest/viewRequest.dart';

class UserRequestDetails extends StatefulWidget {
  const UserRequestDetails({Key? key}) : super(key: key);
  @override
  _UserRequestDetailsState createState() => _UserRequestDetailsState();
}
class _UserRequestDetailsState extends State<UserRequestDetails> {

  late Database db;
  List docs =[];

  initialise(){
    db=Database();
    db.initiliase();
    db.readUserRequestDetails('ahm@gmail.com').then((value) =>{
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
        title: Text('Flower Request '),
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
          //   color: Colors.white.withOpacity(0.8),
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
                      child :InkWell(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateRequest(
                              Id: docs[index]['id'],
                              name: docs[index]['FlowerName'],
                              description: docs[index]['description'],
                              email: docs[index]['email'],
                            ))),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: (){},
                              contentPadding: EdgeInsets.only(right:30,left:36,top:10),
                              title: Text('Flower Name :'+docs[index]['FlowerName']),
                              subtitle: Padding(
                                padding: const  EdgeInsets.only(top:10),
                                child: Text(docs[index]['description']),
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
                      )
                  );
                }
            ),


          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RequestFlower()))
              .then((value) {
            if (value != null) {
              initialise();
            }
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
