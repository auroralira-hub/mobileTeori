import 'package:get/get.dart';

class AntrianController extends GetxController {
  final selectedFilter = 'Semua'.obs;
  void setFilter(String value) => selectedFilter.value = value;
}
