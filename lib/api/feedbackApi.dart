import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;

class Database {
  late FirebaseFirestore firestore;

  initiliase() {
    firestore = FirebaseFirestore.instance;
  }


  Future<void> createFeedback(String id,String email, String description) async {
    try {
      await firestore.collection("feedback").add({
        id:id,
        'uid':id,
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
  Future<List> readFeedbackDetails() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('feedback')
          .orderBy('timestamp', descending: true)
          .get();
      //String searchQuery = "";

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          {
            DateTime date = doc['timestamp'].toDate();
            final timesAgo = date.subtract(new Duration(minutes: 1));

            Map a = {
              "id": doc.id,
              "email": doc['email'],
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




//   Future<void> update(
//       String id, String name, String description, String imageURL) async {
//     try {
//
//       print('name :  '+name);
//       await firestore
//           .collection("feedback")
//           .doc(id)
//           .update({'name': name, 'description': description, 'imageURL': imageURL});
//     } catch (e) {
//       print(e);
//     }
//
//
// }

}
