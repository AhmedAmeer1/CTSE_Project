import 'dart:ui';

//import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flower/pages/Flower/addFlower.dart';
import 'package:learn_flower/api/flowerApi.dart';
import 'package:learn_flower/pages/feedback/viewFeedback.dart';
import 'package:learn_flower/pages/FlowerRequest/viewRequest.dart';
import 'package:learn_flower/pages/User/viewUserDetails.dart';

import 'package:learn_flower/pages/Flower/updateFlower.dart';
// import 'package:my_garden_app/about.dart';
import 'package:flutter/material.dart';

import '../../api/user_model.dart';

import '../FlowerRequest/viewRequest.dart';
import '../Garden/gardenList.dart';
import '../User/signIn.dart';
import '../feedback/viewFeedback.dart';
import 'homePage.dart';


class FlowersList extends StatefulWidget {
  FlowersList({ Key ? key}) : super(key: key);

  //for customized appbar
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  _FlowersListState createState() => _FlowersListState();
}

class _FlowersListState extends State<FlowersList> {
  //search key

  var searchField = FocusNode();



  late Database db;
  List docs = [];
  initialise() {
    db = Database();
    db.initiliase();
    db.read("").then((value) => {
      setState(() {
        docs = value;
      })
    });
  }

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser =UserModel();

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

    } );
  }

  @override
  Widget build(BuildContext context) {





    return Scaffold(
      backgroundColor:Colors.white,
      key: widget.scaffoldKey,
      appBar:AppBar(
        foregroundColor: Colors.black,
        title: Text('Flower App ',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      drawer:  Drawer(
        child:  ListView(
          children: [
            Center(
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  loggedInUser.firstName ?? "user Name",
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary),
                ),
                accountEmail: Text(
                  user?.email ?? "user Email",
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary),
                ),
                currentAccountPicture: GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person,color: Colors.white,),
                  ),
                ),
                decoration: const BoxDecoration(
                    color: Colors.green
                ),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FlowersList()
              )),
              child: const ListTile(
                title: Text('Flowers'),
                leading: Icon(Icons.star),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FeedbackDetails()
              )),
              child: const ListTile(
                title: Text('Feedback Details'),
                leading: Icon(Icons.feedback),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserDetails()
              )),
              child: const ListTile(
                title: Text('User Details'),
                leading: Icon(Icons.recent_actors_rounded),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RequestDetails()
              )),
              child: const ListTile(
                title: Text('Request Details'),
                leading: Icon(Icons.receipt),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GardenList()
              )),
              child: const ListTile(
                title: Text('Gardens'),
                leading: Icon(Icons.ac_unit_outlined),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyHomePage(title: '',)
              )),
              child: const ListTile(
                title: Text('User'),
                leading: Icon(Icons.feedback),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  SignIn()
              )),
              child: const ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout),
              ),
            ),

          ],
        ),
      ),




      body:

      ListView(
          children:[

            const Padding(padding: EdgeInsets.all(20.0),
              child: Text('Recent Added Flowers'),
            ),
            Container(
              height: 720.0,
              child: GridView.builder(
                  itemCount: docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index){
                    return Single_prod(
                      prod_id:docs[index]['id'],
                      prod_name:docs[index]['name'],
                      prod_picture:docs[index]['imageURL'],
                      description:docs[index]['description'],
                      time:docs[index]['cDate'],
                    );
                  }),
            ),
          ]

      ),





      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Add(db: db)))
              .then((value) {
            if (value != null) {
              initialise();
            }
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }











}

















class Single_prod extends StatelessWidget {

  final prod_id;
  final prod_name;
  final prod_picture;
  final description;
  final time;

  const Single_prod({
    this.prod_id,
    this.prod_name,
    this.prod_picture,
    this.description,
    this.time
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,20),
      child: Card(
        child: Hero(
          tag: prod_name,
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => View(
                    productId: prod_id,
                    detail_prod_name: prod_name,
                    detail_prod_picture: prod_picture,
                    detail_description: description,

                  ))),
              child: GridTile(
                footer: Container(
                  color: Colors.white70,
                  child: ListTile(
                    leading: Text(
                      prod_name,
                      style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15 ),
                    ),
                    title: Text(
                      time,textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.green.shade700,fontWeight: FontWeight.w800,fontSize: 8 ),
                    ),
                  ),
                ),
                child: Image.network( prod_picture, fit: BoxFit.cover),



              ),
            ),

          ),
        ),
      ),
    );
  }
}






