import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/config/supabase_config.dart';
import 'app/routes/app_pages.dart';
import 'app/services/theme_service.dart';
import 'app/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting();
  await GetStorage.init();
  if (SupabaseConfig.url.isEmpty || SupabaseConfig.anonKey.isEmpty) {
    throw StateError('Missing Supabase config. Provide SUPABASE_URL and SUPABASE_ANON_KEY.');
  }
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const MyApp());
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
    final initialRoute = Supabase.instance.client.auth.currentSession != null ? Routes.home : Routes.login;
    return Obx(
      () => GetMaterialApp(
        title: "Application",
        theme: themeService.lightTheme,
        darkTheme: themeService.darkTheme,
        themeMode: themeService.themeMode.value,
        initialRoute: initialRoute,
        getPages: AppPages.routes,
      ),
    );
  }
}
