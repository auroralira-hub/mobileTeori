import 'package:get/get.dart';
class LainnyaController extends GetxController {

  void showComingSoon(String feature) {
    Get.snackbar(
      feature,
      'Fitur akan segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
