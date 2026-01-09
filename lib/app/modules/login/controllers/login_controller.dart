import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final resetEmailController = TextEditingController();
  final obscurePassword = true.obs;
  final errorMessage = ''.obs;
  final isSubmitting = false.obs;
  final selectedRole = 'Apoteker'.obs;
  String? _lastPrefillSignature;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      _prefillFromArgs(args);
    }
  }

  Future<void> login() async {
    if (isSubmitting.value) return;
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final role = selectedRole.value;
    if (username.isEmpty) {
      errorMessage.value = 'Email atau username wajib diisi';
      return;
    }
    if (password.isEmpty) {
      errorMessage.value = 'Password wajib diisi';
      return;
    }
    errorMessage.value = '';
    isSubmitting.value = true;
    try {
      final profile = await authService.signIn(
        identifier: username,
        password: password,
        selectedRole: role,
      );
      Get.offAllNamed(Routes.home, arguments: {
        'name': profile.username ?? profile.email,
        'role': profile.role,
      });
    } catch (error) {
      errorMessage.value = _readableError(error);
    } finally {
      isSubmitting.value = false;
    }
  }

  void forgotPassword() {
    resetEmailController.text = usernameController.text.trim();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan email atau username terdaftar. Kami akan kirim tautan/reset info (simulasi).',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: resetEmailController,
              decoration: const InputDecoration(
                labelText: 'Email atau username',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReset,
                child: const Text('Kirim Instruksi Reset'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  String _titleCase(String input) {
    if (input.isEmpty) return input;
    final lower = input.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  void prefillFromExternalArgs(dynamic args) {
    if (args is Map) {
      _prefillFromArgs(args);
    }
  }

  void _prefillFromArgs(Map args) {
    if (args['clearPrefill'] == true) {
      clearPrefill();
      return;
    }
    final argUser = args['username'];
    final argRole = args['role'];
    final signature = '${argUser ?? ''}|${argRole ?? ''}';
    if (signature == _lastPrefillSignature) return;
    _lastPrefillSignature = signature;
    if (argUser is String && argUser.trim().isNotEmpty) {
      usernameController.text = argUser.trim();
    }
    if (argRole is String && argRole.trim().isNotEmpty) {
      selectedRole.value = _titleCase(argRole);
    } else {
      selectedRole.value = 'Apoteker';
    }
    errorMessage.value = '';
  }

  void clearPrefill() {
    usernameController.clear();
    selectedRole.value = 'Apoteker';
    errorMessage.value = '';
  }

  void _submitReset() {
    final target = resetEmailController.text.trim();
    if (target.isEmpty) {
      Get.snackbar(
        'Reset Password',
        'Isi email atau username terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final isEmail = GetUtils.isEmail(target);
    Get.back();
    Get.snackbar(
      'Reset Password',
      isEmail
          ? 'Tautan reset dikirim ke $target (simulasi).'
          : 'Akun "$target" diproses, cek email terdaftar (simulasi).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _readableError(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    return 'Login gagal. Silakan coba lagi.';
  }
}
