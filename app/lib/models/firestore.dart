// Import the firebase_core and cloud_firestore plugin
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> create(String doc, data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final user = prefs.getString('user');

  CollectionReference docCollection =
      FirebaseFirestore.instance.collection(doc);

  return docCollection
      .add({
        'data': data,
        'uid': jsonDecode(user)['uid'],
      })
      .then((value) => 'Success')
      .catchError((error) => error);
}

Future<DocumentSnapshot> readSingle(String doc, String docId) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection(doc).doc(docId);

  return docRef.get();
}

Future<QuerySnapshot> read(String doc) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final user = prefs.getString('user');

  CollectionReference docCollection =
      FirebaseFirestore.instance.collection(doc);

  return docCollection.where('uid', isEqualTo: jsonDecode(user)['uid']).get();
}

Future<String> update(String doc, String docId, data) async {
  CollectionReference docCollection =
      FirebaseFirestore.instance.collection(doc);

  return docCollection
      .doc(docId)
      .update({
        'data': data,
      })
      .then((value) => 'Success')
      .catchError((error) => error);
}

Future<String> delete(String doc, String docId) async {
  CollectionReference docCollection =
      FirebaseFirestore.instance.collection(doc);

  return docCollection
      .doc(docId)
      .delete()
      .then((value) => 'Success')
      .catchError((error) => error);
}
