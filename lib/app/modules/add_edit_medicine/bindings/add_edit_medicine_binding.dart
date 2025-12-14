import 'package:get/get.dart';
import '../controllers/add_edit_medicine_controller.dart';

class AddEditMedicineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditMedicineController>(() => AddEditMedicineController());
  }
}
