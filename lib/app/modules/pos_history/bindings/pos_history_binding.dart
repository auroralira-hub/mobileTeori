import 'package:get/get.dart';
import '../controllers/pos_history_controller.dart';

class PosHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosHistoryController>(() => PosHistoryController());
  }
}
