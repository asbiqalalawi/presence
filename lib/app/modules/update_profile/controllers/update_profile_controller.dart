import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

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
        Map<String, dynamic> data = {'name': nameC.text};
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split('.').last;

          final mountainsRef = storageRef.child("$uid/profile.$ext");

          await mountainsRef.putFile(file);
          String imageUrl = await mountainsRef.getDownloadURL();

          data.addAll({'profile': imageUrl});
        }
        await firestore.collection('employee').doc(uid).update(data);
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
