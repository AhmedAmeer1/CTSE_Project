import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learn_flower/api/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class Database {
  late FirebaseFirestore firestore;

  initiliase() {
    firestore = FirebaseFirestore.instance;
  }


  Future<void> createUser(String email, String description) async {
    try {
      await firestore.collection("feedback").add({
        'email': email,
        'description': description,
        'timestamp': FieldValue.serverTimestamp()
      });
      print("debug : New Flower Added");
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("feedback").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

//view method
  Future<Object> readUserDetails() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    UserModel usermodel = UserModel();

    try {
      querySnapshot = await firestore
          .collection('users')
          .orderBy('timestamp', descending: true)
          .get();
      //String searchQuery = "";

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          {
            DateTime date = doc['timestamp'].toDate();
            final timesAgo = date.subtract(new Duration(minutes: 1));



            usermodel.email= doc['email'];
            usermodel.firstName= doc['firstName'];
            usermodel.phoneNumber= doc["phoneNumber"];



          }
        }
        return usermodel;
      }
    } catch (e) {
      print(e);
    }

    return usermodel;
  }


  Future<void> update(
      String id, String name, String description, String imageURL) async {
    try {

      print('name :  '+name);
      await firestore
          .collection("feedback")
          .doc(id)
          .update({'name': name, 'description': description, 'imageURL': imageURL});
    } catch (e) {
      print(e);
    }


}



//view method
  Future<List> readSpecificUser(String Email) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('users')
          .orderBy('timestamp', descending: true)
          .get();
      //String searchQuery = "";

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          {


            DateTime date = doc['timestamp'].toDate();
            final timesAgo = date.subtract(new Duration(minutes: 1));
            if (Email==doc['email']) {
              Map a = {
                "id": doc.id,
                "email": doc['email'],
                "description": doc["description"],
                "cDate": timeago.format(timesAgo)
              };
              docs.add(a);
            }
            print('2222222222');
            }

        }
        print('1111111111');

        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }




}