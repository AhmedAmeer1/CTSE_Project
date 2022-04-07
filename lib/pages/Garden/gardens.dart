import 'dart:ui';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flower/pages/Flower/addFlower.dart';
import 'package:learn_flower/api/gardenApi.dart';
import 'package:learn_flower/pages/Flower/flowersList.dart';
import 'package:learn_flower/pages/Garden/updateGarden.dart';
import 'package:learn_flower/pages/feedback/viewFeedback.dart';
import 'package:learn_flower/pages/FlowerRequest/viewRequest.dart';
import 'package:learn_flower/pages/User/viewUserDetails.dart';
import 'package:learn_flower/pages/feedback/addfeedback.dart';
import 'package:learn_flower/pages/FlowerRequest/requestFlower.dart';
import 'package:learn_flower/pages/FlowerRequest/userViewRequest.dart';

import 'package:learn_flower/pages/Flower/updateFlower.dart';
// import 'package:my_garden_app/about.dart';
import 'package:flutter/material.dart';


import '../../api/user_model.dart';


import '../Flower/homePage.dart';
import '../User/profile.dart';
import 'detailGardens.dart';


class Gardens extends StatefulWidget {
  Gardens({Key? key}) : super(key: key);

  //for customized appbar
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  _GardensState createState() => _GardensState();
}

class _GardensState extends State<Gardens> {
  TextEditingController _searchQueryController = TextEditingController();
  var searchField = FocusNode();

  bool isSearching = false;

  late Database db;
  List docs = [];
  initialise() {
    db = Database();
    db.initiliase();
    db.readGarden("").then((value) => {
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
        title: Text('Gardens ',style: TextStyle(color: Colors.black),),
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
                  builder: (context) => MyHomePage(title: '',)
              )),
              child: const ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home),
              ),
            ),
            InkWell(
              onTap: (){},
              child: const ListTile(
                title: Text('About Us'),
                leading: Icon(Icons.help),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FlowersList()
              )),
              child: const ListTile(
                title: Text('Admin'),
                leading: Icon(Icons.feedback),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Gardens()
              )),
              child: const ListTile(
                title: Text('Gardens'),
                leading: Icon(Icons.feedback),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserRequestDetails()
              )),
              child: const ListTile(
                title: Text('Request view'),
                leading: Icon(Icons.feedback),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  Feedbackpage(id:loggedInUser.uid,email:loggedInUser.email)
              )),
              child: const ListTile(
                title: Text('Feedback'),
                leading: Icon(Icons.feedback),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  Profile(id:loggedInUser.uid,name:loggedInUser.firstName,number:loggedInUser.phoneNumber ,)
              )),
              child: const ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.settings),
              ),
            ),

          ],
        ),
      ),
      body: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailGarden(
                    name: docs[index]['name'],
                    picture: docs[index]['imageURL'],
                    location: docs[index]['location'],
                    time: docs[index]['time'],
                    ticket: docs[index]['ticket'],
                  ))),
              title: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  height: 150,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          docs[index]['imageURL'],
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                            color: Colors.black45.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  docs[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.9)),
                                ),
                                SizedBox(
                                  height: 4,
                                ),


                              ]))
                    ],
                  )),
              subtitle: Text(
                docs[index]['cDate'],
                textAlign: TextAlign.right,
              ),
            ),
          );
        },
      ),
  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//to search
//   void updateSearchQuery(String newQuery) {
//     db.read(newQuery).then((value) => {
//       setState(() {
//         docs = value;
//       })
//     });
//   }
//
//   void _clearSearchQuery() {
//     setState(() {
//       _searchQueryController.text = "";
//       updateSearchQuery("");
//     });
//   }



}

class AnimateExpansion extends StatefulWidget {
  final Widget child;
  final bool animate;
  final double axisAlignment;
  AnimateExpansion({
    this.animate = false,
    required this.axisAlignment,
    required this.child,
  });

  @override
  _AnimateExpansionState createState() => _AnimateExpansionState();
}

class _AnimateExpansionState extends State<AnimateExpansion>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  void _toggle() {
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _toggle();
  }

  @override
  void didUpdateWidget(AnimateExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _toggle();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axis: Axis.horizontal,
        axisAlignment: -1.0,
        sizeFactor: _animation,
        child: widget.child);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

