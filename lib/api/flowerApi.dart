import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;

class Database {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(String name, String code, String imageURL) async {
    try {
      await firestore.collection("flowers").add({
        'name': name,
        'description': code,
        'imageURL': imageURL,
        'timestamp': FieldValue.serverTimestamp()
      });
      print("debug : New Flower Added");
      print(imageURL);
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("flowers").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

//view method
  Future<List> read(String searchQuery) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('flowers')
          .orderBy('timestamp', descending: true)
          .get();
      //String searchQuery = "";

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (doc['name']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
            DateTime date = doc['timestamp'].toDate();
            final timesAgo = date.subtract(new Duration(minutes: 1));

            Map a = {
              "id": doc.id,
              "name": doc['name'],
              "description": doc["description"],
              "imageURL": doc["imageURL"],
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
      print(id);

      await firestore
          .collection("flowers")
          .doc(id)
          .update({'name': name, 'description': code, 'imageURL': imageURL});
    } catch (e) {
      print(e);
    }
  }

































}
