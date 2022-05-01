import 'package:get/get.dart';

import '../controllers/presence_details_controller.dart';

class PresenceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresenceDetailsController>(
      () => PresenceDetailsController(),
    );
  }
}
