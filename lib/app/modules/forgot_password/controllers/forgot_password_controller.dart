import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.back();
        Get.snackbar('Berhasil', 'Email reset password berhasil dikirim.');
      } catch (e) {
        Get.snackbar(
            'Terjadi Kesalahan', 'Tidak dapat mengirim email reset password.');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Email harus diisi.');
    }
  }
}
