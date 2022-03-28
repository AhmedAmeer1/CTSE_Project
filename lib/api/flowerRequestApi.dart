import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;

class Database {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }



  Future<void> createFlowerRequest(String name,String email, String description) async {
    try {
      await firestore.collection("Request Flower").add({
        'FlowerName': name,
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
      await firestore.collection("Request Flower").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

//view method
  Future<List> readRequestDetails() async{
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('Request Flower')
          .orderBy('timestamp', descending: true)
          .get();
      //String searchQuery = "";

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          {
            DateTime date = doc['timestamp'].toDate();
            final timesAgo = date.subtract(new Duration(minutes: 1));

            Map a = {
              "id":doc.id,
              "FlowerName": doc['FlowerName'],
              "description": doc["description"],
              "cDate": timeago.format(timesAgo)
            };
            docs.add(a);
          }
        }
        return docs;
      }

    } catch (e) {
      print(e);
    }
    return docs;
  }


  Future<void> update(
      String id, String name, String code, String imageURL) async {
    try {
      await firestore
          .collection("feedback")
          .doc(id)
          .update({'name': name, 'description': code, 'imageURL': imageURL});
    } catch (e) {
      print(e);
    }
  }
}
