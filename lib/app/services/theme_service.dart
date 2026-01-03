import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  static const _storageKey = 'theme_mode';
  final _box = GetStorage();

  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  ThemeService() {
    themeMode.value = _loadThemeFromBox();
  }

  ThemeMode _loadThemeFromBox() {
    // Force light mode regardless of stored value to disable dark mode app-wide.
    return ThemeMode.light;
  }

  ThemeData get lightTheme {
    const seed = Color(0xff06b47c);
    final base = ThemeData.light(useMaterial3: false);
    final textBase = ThemeData.light(useMaterial3: false).textTheme;
    final textTheme = textBase.apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
    );
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return base.copyWith(
      primaryColor: seed,
      scaffoldBackgroundColor: const Color(0xfff6f7fb),
      colorScheme: scheme,
      cardColor: Colors.white,
      textTheme: textTheme,
    );
  }

  ThemeData get darkTheme {
    const seed = Color(0xff06b47c);
    const surface = Color(0xff161a21);
    const background = Color(0xff0f1116);
    final base = ThemeData.dark(useMaterial3: false);
    final textBase = ThemeData.light(useMaterial3: false).textTheme;
    final textTheme = textBase.apply(
      bodyColor: const Color(0xffe8ecf2),
      displayColor: const Color(0xffe8ecf2),
    );
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      surface: surface,
    );
    return base.copyWith(
      primaryColor: seed,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      colorScheme: scheme,
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xff1c212a),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff2a303a)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff2a303a)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: seed, width: 1.6),
        ),
        hintStyle: const TextStyle(color: Color(0xff9aa2ad)),
        labelStyle: const TextStyle(color: Color(0xffcdd3dc)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xff2f3742)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xff10131a),
        selectedItemColor: seed,
        unselectedItemColor: Color(0xff6b7280),
      ),
    );
  }

  void setMode(ThemeMode mode) {
    // Dark mode disabled; always stick to light.
    themeMode.value = ThemeMode.light;
    _box.write(_storageKey, 'light');
  }

  void toggle() {
    setMode(themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
