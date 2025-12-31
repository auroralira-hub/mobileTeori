import 'package:get/get.dart';

class PosHistoryController extends GetxController {
  final search = ''.obs;
  final selectedFilter = 'Semua'.obs;

  void setFilter(String value) => selectedFilter.value = value;
}
