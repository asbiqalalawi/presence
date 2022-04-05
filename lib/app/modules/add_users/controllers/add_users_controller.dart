import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddUsersController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addUser() async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          await firestore.collection('employee').doc(uid).set({
            'nip': nipC.text,
            'name': nameC.text,
            'email': emailC.text,
            'uid': uid,
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Terjadi Kesalahan', 'Password yang digunakan terlalu singkat.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan', 'Email sudah terdaftar.');
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat menambahkan pegawai.');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'NIP, nama, dan email harus diisi.');
    }
  }
}
