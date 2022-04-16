import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await firestore
            .collection('employee')
            .doc(uid)
            .update({'name': nameC.text});
        Get.back();
        Get.snackbar('Berhasil', 'Profile berhasil diperbarui.');
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat memperbarui profile.');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
