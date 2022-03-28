import 'dart:core';
import 'dart:ui';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flower/api/user_model.dart';
import 'package:learn_flower/pages/Admin/addFlower.dart';
import 'package:learn_flower/api/flowerApi.dart';
import 'package:learn_flower/pages/Admin/flowersList.dart';
import 'package:learn_flower/pages/User/addfeedback.dart';
import 'package:learn_flower/pages/User/requestFlower.dart';
import 'package:learn_flower/pages/detailFlower.dart';
import 'package:learn_flower/pages/Admin/updateFlower.dart';
// import 'package:my_garden_app/about.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:learn_flower/profile.dart';
import 'package:learn_flower/signIn.dart';
import 'package:learn_flower/signup.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({  required this.title}) ;

  //for customized appbar
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //search key
  TextEditingController _searchQueryController = TextEditingController();
  var searchField = FocusNode();


  bool isSearching = false;

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

    } );
  }

  @override
  Widget build(BuildContext context) {


    Widget image_carousel = Container(
      height: 180.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: const [
          AssetImage('assets/images/5.webp'),
          AssetImage('assets/images/8.webp'),
          AssetImage('assets/images/6.jpg'),
          AssetImage('assets/images/7.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );


    return Scaffold(
      backgroundColor:Colors.white,
      key: widget.scaffoldKey,
      appBar:AppBar(
        foregroundColor: Colors.black,
        // title: Text('Flower App ',style: TextStyle(color: Colors.black),),
        title: Text("${loggedInUser.firstName}",style: TextStyle(color: Colors.black),),
        actions: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),

          ),

        ],
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
              onTap: (){},
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
                  builder: (context) => SignUp()
              )),
              child: const ListTile(
                title: Text('Registration'),
                leading: Icon(Icons.feedback),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  SignIn()
              )),
              child: const ListTile(
                title: Text('Login'),
                leading: Icon(Icons.feedback),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  Feedbackpage()
              )),
              child: const ListTile(
                title: Text('Feedback'),
                leading: Icon(Icons.feedback),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  RequestFlower()
              )),
              child: const ListTile(
                title: Text('Request a Flower'),
                leading: Icon(Icons.request_page),
              ),
            ),

            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  Profile(name:loggedInUser.firstName,number:loggedInUser.phoneNumber ,)
              )),
              child: const ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.settings),
              ),
            ),

          ],
        ),
      ),




      body:

      ListView(
          children:[
            image_carousel,
            const Padding(padding: EdgeInsets.all(20.0),
              child: Text('Recent Flowers'),
            ),
            Container(
              height: 720.0,
              child: GridView.builder(
                  itemCount: docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index){
                    return Single_prod(
                      prod_name:docs[index]['name'],
                      prod_picture:docs[index]['imageURL'],
                      prod_description:docs[index]['description'],
                      prod_price:docs[index]['cDate'],
                    );
                  }),
            ),
          ]

      ),





      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }






//to search
  void updateSearchQuery(String newQuery) {
    db.read(newQuery).then((value) => {
      setState(() {
        docs = value;
      })
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.text = "";
      updateSearchQuery("");
    });
  }

  //new functions
  void handleClick(String value, BuildContext context) {
    switch (value) {

    }
  }


}

















class Single_prod extends StatelessWidget {

  final prod_name;
  final prod_picture;
  final prod_description;
  final prod_price;

  const Single_prod({
    this.prod_name,
    this.prod_picture,
    this.prod_description,
    this.prod_price
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
                  builder: (context) => DetailProduct(
                    detail_prod_name: prod_name,
                    detail_prod_picture: prod_picture,
                    detail_description: prod_description,
                    detail_time: prod_price,
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
                      prod_price,textAlign: TextAlign.right,
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






