import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/theme_service.dart';

class HomeController extends GetxController {
  final currentTab = 0.obs;
  final userName = 'User'.obs;
  final role = 'Apoteker'.obs;
  final isLightMode = false.obs;
  late final ThemeService _themeService;

  @override
  void onInit() {
    super.onInit();
    _themeService = Get.find<ThemeService>();
    isLightMode.value = _themeService.themeMode.value == ThemeMode.light;
    final args = Get.arguments;
    if (args is Map) {
      final nameArg = args['name'];
      if (nameArg is String && nameArg.trim().isNotEmpty) {
        userName.value = nameArg;
      }
      final roleArg = args['role'];
      if (roleArg is String && roleArg.trim().isNotEmpty) {
        role.value = _titleCase(roleArg);
      }
    }
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void toggleLightMode(bool value) {
    isLightMode.value = value;
    _themeService.setMode(value ? ThemeMode.light : ThemeMode.dark);
  }

  String _titleCase(String input) {
    if (input.isEmpty) return input;
    final lower = input.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}
