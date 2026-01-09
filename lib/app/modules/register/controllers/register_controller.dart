import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseController = TextEditingController();
  final sipController = TextEditingController();
  final employeeIdController = TextEditingController();
  final pharmacistIdController = TextEditingController();
  final experienceController = TextEditingController();
  final workplaceController = TextEditingController();

  final genders = const ['Laki-laki', 'Perempuan', 'Lainnya'];
  final positions = const [
    'Apoteker Junior',
    'Apoteker Madya',
    'Apoteker Senior',
    'Kepala Apotek',
  ];
  final selectedGender = RxnString();
  final selectedPosition = RxnString();
  final roles = const ['Apoteker', 'Karyawan'];
  final selectedRole = 'Apoteker'.obs;

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isSubmitting = false.obs;

  String get role {
    final args = Get.arguments;
    if (args is Map && args.containsKey('role')) {
      final rawRole = args['role'];
      if (rawRole is String && rawRole.trim().isNotEmpty) {
        return rawRole.toLowerCase();
      }
    }
    return 'apoteker';
  }

  bool get isApoteker => role == 'apoteker';

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void register() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Konfirmasi Password',
        'Password dan konfirmasi tidak sama.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final email = emailController.text.trim();
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email tidak valid',
        'Gunakan email yang benar untuk registrasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      await authService.signUp(
        email: email,
        password: passwordController.text,
        username: usernameController.text.trim(),
        role: selectedRole.value,
      );
      Get.snackbar(
        'Registrasi Berhasil',
        'Akun Anda siap digunakan sebagai ${selectedRole.value}.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(
        Routes.login,
        arguments: {
          'username': email,
          'role': selectedRole.value,
        },
      );
    } catch (error) {
      Get.snackbar(
        'Registrasi Gagal',
        _readableError(error),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    sipController.dispose();
    employeeIdController.dispose();
    pharmacistIdController.dispose();
    experienceController.dispose();
    workplaceController.dispose();
    super.onClose();
  }

  String _readableError(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    return 'Registrasi gagal. Silakan coba lagi.';
  }
}
