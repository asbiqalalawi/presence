import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != 'password') {
        try {
          String email = auth.currentUser!.email.toString();

          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar('Terjadi Kesalahan',
                'Password terlalu lemah, minimal 6 karakter.');
          } else {
            Get.snackbar(
                'Terjadi Kesalahan', 'Tidak dapat memperbarui password.');
          }
        }
      } else {
        Get.snackbar('Terjadi Kesalahan',
            'Password yang dimasukkan sama dengan password sebelumnya.');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Password baru harus diisi.');
    }
  }
}
