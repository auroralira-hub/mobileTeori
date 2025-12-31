import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/services/theme_service.dart';
import 'app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.put(ThemeService(), permanent: true);
    // Ensure AuthService loads persisted data before first use.
    if (!Get.isRegistered<AuthService>()) {
      final auth = Get.put(AuthService(), permanent: true);
      auth.loadSaved();
    }
    return Obx(
      () => GetMaterialApp(
        title: "Application",
        theme: themeService.lightTheme,
        darkTheme: themeService.darkTheme,
        themeMode: themeService.themeMode.value,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}
