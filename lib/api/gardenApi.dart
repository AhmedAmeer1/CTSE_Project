import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;

class Database {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> createGarden(String name,String location,String time, String ticket, String imageURL) async {
    try {
      await firestore.collection("garden").add({
        'name': name,
        'location': location,
        'ticket': ticket,
        'time': time,
       'imageURL': imageURL,
        'timestamp': FieldValue.serverTimestamp()
      });

      print(imageURL);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteGarden(String id) async {
    try {
      await firestore.collection("garden").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

//view method
  Future<List> readGarden(String searchQuery) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('garden')
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
              'location': doc['location'],
              'ticket':  doc['ticket'],
              'time':  doc['time'],
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

  Future<void> updateGarden(
      String id, String name,String location,String time, String ticket, String imageURL) async {
    try {
       await firestore
          .collection("garden")
          .doc(id)
          .update({'name': name, 'location': location, 'time': time, 'ticket': ticket, 'imageURL': imageURL});
    } catch (e) {
      print(e);
    }
  }

































}
