import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void logOut() async {
    isLoading.value = true;
    await FirebaseAuth.instance.signOut();
    isLoading.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('employee').doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamPresence() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore
        .collection('employee')
        .doc(uid)
        .collection('presence')
        .orderBy('date', descending: true)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = auth.currentUser!.uid;

    String date = DateFormat.yMd().format(DateTime.now()).replaceAll('/', '-');

    yield* firestore
        .collection('employee')
        .doc(uid)
        .collection('presence')
        .doc(date)
        .snapshots();
  }
}
