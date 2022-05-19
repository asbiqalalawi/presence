import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresenceController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllPresence() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore
        .collection('employee')
        .doc(uid)
        .collection('presence')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
