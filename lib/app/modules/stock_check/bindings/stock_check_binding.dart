import 'package:get/get.dart';
import '../controllers/stock_check_controller.dart';

class StockCheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockCheckController>(() => StockCheckController());
  }
}
