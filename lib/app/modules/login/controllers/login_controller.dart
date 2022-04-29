import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        // ignore: avoid_print
        print(credential);

        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passC.text == 'password') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: 'Verifikasi Email',
              middleText:
                  'Email belum diverifikasi. Silahkan verifikasi email terlebih dahulu.',
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                    onPressed: () {
                      try {
                        credential.user!.sendEmailVerification();
                        Get.back();
                        isLoading.value = false;
                        Get.snackbar(
                            'Email Dikirim', 'Email verifikasi telah dikirim.');
                      } catch (e) {
                        isLoading.value = false;
                        Get.snackbar('Terjadi Kesalahan',
                            'Tidak dapat mengirim verifikasi email.');
                      }
                    },
                    child: const Text('KIRIM ULANG'))
              ],
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'Email tidak terdaftar.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password salah.');
        } else {
          Get.snackbar('Terjadi Kesalahan', e.code);
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat Login.');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Email dan password harus diisi.');
    }
  }
}
