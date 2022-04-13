import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
                labelText: 'Email', border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.passC,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.login();
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? 'LOGIN' : 'LOADING...'),
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
            child: const Text('Lupa password?'),
          ),
        ],
      ),
    );
  }
}
