import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  void logOut() async {
    isLoading.value = true;
    await FirebaseAuth.instance.signOut();
    isLoading.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }
}
