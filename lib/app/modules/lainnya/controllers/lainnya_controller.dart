import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/theme_service.dart';

class LainnyaController extends GetxController {
  late final ThemeService themeService;

  @override
  void onInit() {
    super.onInit();
    themeService = Get.find<ThemeService>();
  }

  bool get isDark => themeService.themeMode.value == ThemeMode.dark;

  void toggleTheme(bool value) {
    final mode = value ? ThemeMode.dark : ThemeMode.light;
    themeService.setMode(mode);
  }

  void showComingSoon(String feature) {
    Get.snackbar(
      feature,
      'Fitur akan segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
