import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  UpdateProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.nameC.text = user['name'];
    controller.emailC.text = user['email'];
    controller.nipC.text = user['nip'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.nipC,
            decoration: const InputDecoration(
              labelText: 'NIP',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Photo Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipOval(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    if (user['profile'] != null) {
                      if (user['profile'] != '') {
                        return ClipOval(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              user['profile'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return const Text('No Image Choosen');
                      }
                    } else {
                      return const Text('No Image Choosen');
                    }
                  }
                },
              ),
              TextButton(
                  onPressed: () {
                    controller.pickImage();
                  },
                  child: const Text('choose'))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Obx(() => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.updateProfile(user['uid']);
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? 'ADD PEGAWAI' : 'LOADING...')))
        ],
      ),
    );
  }
}
