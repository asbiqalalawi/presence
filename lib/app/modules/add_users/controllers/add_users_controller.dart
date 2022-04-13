import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUsersController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser() async {
    if (passC.text.isNotEmpty) {
      isLoadingAdd.value = true;
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
            'role': 'pegawai',
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
        isLoadingAdd.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAdd.value = false;
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
        isLoadingAdd.value = false;
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat menambahkan pegawai.');
      }
    } else {
      isLoading.value = false;
      Get.snackbar('Terjadi kesalahan', 'Password harus diisi.');
    }
  }

  Future<void> addUser() async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: 'Validasi Admin',
        content: Column(
          children: [
            const Text('Masukkan password Anda'),
            const SizedBox(
              height: 10,
            ),
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
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: const Text('CANCEL'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAdd.isFalse) {
                  await createUser();
                }
                isLoading.value = false;
              },
              child: Text(isLoadingAdd.isFalse ? 'ADD USER' : 'LOADING...'),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar('Terjadi Kesalahan', 'NIP, nama, dan email harus diisi.');
    }
  }
}
