import 'package:get/get.dart';

import '../controllers/add_users_controller.dart';

class AddUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddUsersController>(
      () => AddUsersController(),
    );
  }
}
