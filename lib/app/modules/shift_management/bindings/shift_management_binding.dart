import 'package:get/get.dart';
import '../controllers/shift_management_controller.dart';

class ShiftManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShiftManagementController>(() => ShiftManagementController());
  }
}
