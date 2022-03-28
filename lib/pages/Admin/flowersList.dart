import 'dart:ui';

//import 'package:firebase_core/firebase_core.dart';

import 'package:learn_flower/pages/Admin/addFlower.dart';
import 'package:learn_flower/api/flowerApi.dart';
import 'package:learn_flower/pages/Admin/viewFeedback.dart';
import 'package:learn_flower/pages/Admin/viewRequest.dart';
import 'package:learn_flower/pages/Admin/viewUserDetails.dart';
import 'package:learn_flower/pages/detailFlower.dart';
import 'package:learn_flower/pages/Admin/updateFlower.dart';
// import 'package:my_garden_app/about.dart';
import 'package:flutter/material.dart';

import '../../homePage.dart';

class FlowersList extends StatefulWidget {
  FlowersList({ Key ? key}) : super(key: key);

  //for customized appbar
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // final String title;

  @override
  _FlowersListState createState() => _FlowersListState();
}

class _FlowersListState extends State<FlowersList> {
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

  @override
  void initState() {
    super.initState();
    initialise();
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
                accountName: const Text('AHMED'),
                accountEmail: const Text('ahm@gmail.com'),
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
              onTap: (){

              },
              child: const ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FeedbackDetails()
              )),
              child: const ListTile(
                title: Text('Feedback Details'),
                leading: Icon(Icons.help),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserDetails()
              )),
              child: const ListTile(
                title: Text('User Details'),
                leading: Icon(Icons.help),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RequestDetails()
              )),
              child: const ListTile(
                title: Text('Request Details'),
                leading: Icon(Icons.request_page),
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
                      prod_price:docs[index]['cDate'],
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

  final prod_id;
  final prod_name;
  final prod_picture;
  final prod_price;

  const Single_prod({
    this.prod_id,
    this.prod_name,
    this.prod_picture,
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
                  builder: (context) => View(
                    productId: prod_id,
                    detail_prod_name: prod_name,
                    detail_prod_picture: prod_picture,
                    detail_description: prod_price,
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






