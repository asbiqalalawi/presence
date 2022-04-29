import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/controllers/page_index_controller.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value, //optional, defFault as 0
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
