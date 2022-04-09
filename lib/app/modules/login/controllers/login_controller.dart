import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        print(credential);

        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
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
                  onPressed: () => Get.back(),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                    onPressed: () {
                      try {
                        credential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar(
                            'Email Dikirim', 'Email verifikasi telah dikirim.');
                      } catch (e) {
                        Get.snackbar('Terjadi Kesalahan',
                            'Tidak dapat mengirim verifikasi email.');
                      }
                    },
                    child: const Text('KIRIM ULANG'))
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'Email tidak terdaftar.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password salah.');
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat Login.');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Email dan password harus diisi.');
    }
  }
}
