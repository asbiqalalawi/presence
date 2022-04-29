import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int i) async {
    switch (i) {
      case 1:
        print('ABSENSI');
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }
}
