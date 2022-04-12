// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_users_controller.dart';

class AddUsersView extends GetView<AddUsersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD USERS'),
        centerTitle: true,
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          autocorrect: false,
          controller: controller.nipC,
          decoration: InputDecoration(
            labelText: 'NIP',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          autocorrect: false,
          controller: controller.nameC,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          autocorrect: false,
          controller: controller.emailC,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Obx(() => ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                await controller.addUser();
              }
            },
            child: Text(
                controller.isLoading.isFalse ? 'ADD PEGAWAI' : 'LOADING...')))
      ]),
    );
  }
}
