import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/theme_service.dart';

class HomeController extends GetxController {
  final currentTab = 0.obs;
  final userName = 'User'.obs;
  final role = 'Karyawan'.obs;
  final isDarkMode = false.obs;
  final language = 'id'.obs; // 'id' or 'en'
  late final ThemeService _themeService;
  late final GetStorage _storage;

  static const _languageKey = 'language_code';

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
    _themeService = Get.find<ThemeService>();

    isDarkMode.value = _themeService.themeMode.value == ThemeMode.dark;

    final storedLang = _storage.read<String>(_languageKey);
    if (storedLang != null && (storedLang == 'en' || storedLang == 'id')) {
      language.value = storedLang;
    }
    _applyLocale(language.value);

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
      final tabArg = args['tab'];
      if (tabArg is int && tabArg >= 0 && tabArg <= 3) {
        currentTab.value = tabArg;
      }
    }
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _themeService.setMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void setLanguage(String code) {
    language.value = code;
    _storage.write(_languageKey, code);
    _applyLocale(code);
  }

  String _titleCase(String input) {
    if (input.isEmpty) return input;
    final lower = input.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  void _applyLocale(String code) {
    if (code == 'en') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('id', 'ID'));
    }
  }
}
