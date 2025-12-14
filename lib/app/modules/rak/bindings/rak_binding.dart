import 'package:get/get.dart';
import '../controllers/rak_controller.dart';

class RakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RakController>(() => RakController());
  }
}
