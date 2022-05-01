import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/presence_details_controller.dart';

class PresenceDetailsView extends GetView<PresenceDetailsController> {
  const PresenceDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PresenceDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PresenceDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
