import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUsersController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser() async {
    if (passC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passC.text);

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

          await userCredential.user!.sendEmailVerification();

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passC.text);

          Get.back();
          Get.back();
          Get.snackbar('Berhasil', 'Berhasil menambahkan pegawai.');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Terjadi Kesalahan', 'Password yang digunakan terlalu singkat.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan', 'Email sudah terdaftar.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password salah.');
        } else {
          Get.snackbar('Terjadi Kesalahan', e.code);
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat menambahkan pegawai.');
      }
    } else {
      Get.snackbar('Terjadi kesalahan', 'Password harus diisi.');
    }
  }

  void addUser() async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
        title: 'Validasi Admin',
        content: Column(
          children: [
            const Text('Masukkan password Anda'),
            TextField(
              controller: passC,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              await createUser();
            },
            child: const Text('ADD USER'),
          ),
        ],
      );
    } else {
      Get.snackbar('Terjadi Kesalahan', 'NIP, nama, dan email harus diisi.');
    }
  }
}
