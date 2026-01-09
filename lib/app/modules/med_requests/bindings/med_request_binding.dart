import 'package:get/get.dart';
import '../controllers/med_request_controller.dart';

class MedRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MedRequestController());
  }
}
