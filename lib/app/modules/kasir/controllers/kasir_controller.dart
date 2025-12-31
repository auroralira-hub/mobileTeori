import 'package:get/get.dart';

class KasirController extends GetxController {
  final searchText = ''.obs;

  void onSearchChanged(String value) => searchText.value = value;
}
