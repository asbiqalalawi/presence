import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.ADD_USERS),
              icon: const Icon(Icons.person)),
        ],
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () {
            if (controller.isLoading.isFalse) {
              controller.logOut();
            }
          },
          child: controller.isLoading.isFalse
              ? const Icon(Icons.logout)
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
