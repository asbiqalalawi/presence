import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String email = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: email, password: currC.text);

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();

          Get.snackbar('Berhasil', 'Password berhasil diubah.');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar('Terjadi Kesalahan', 'Password salah.');
          } else {
            Get.snackbar('Terjadi Kesalahan', e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar('Terjadi Kesalahan', 'Tidak dapat mengubah password.');
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Terjadi Kesalahan', 'Password baru tidak cocok.');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Semua input harus diisi.');
    }
  }
}
