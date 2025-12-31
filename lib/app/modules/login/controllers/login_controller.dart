import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final resetEmailController = TextEditingController();
  final obscurePassword = true.obs;
  final errorMessage = ''.obs;
  final selectedRole = 'Apoteker'.obs;
  final RxnString lockedRole = RxnString();
  String? _lastPrefillSignature;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void selectRole(String role) {
    final locked = lockedRole.value;
    if (locked != null && locked != role.toLowerCase()) {
      Get.snackbar(
        'Role terkunci',
        'Gunakan role $locked sesuai saat registrasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    selectedRole.value = role;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      _prefillFromArgs(args);
    } else if (authService.lastUsername != null) {
      usernameController.text = authService.lastUsername!;
      if (authService.lastRole != null) {
        selectedRole.value = _titleCase(authService.lastRole!);
      }
    }
  }

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final role = selectedRole.value;
    final matchedRole = authService.validate(username, password, role);
    if (matchedRole == null) {
      errorMessage.value = 'Username, password, atau role tidak sesuai';
      return;
    }
    errorMessage.value = '';
    Get.offAllNamed(Routes.home, arguments: {
      'name': username,
      'role': matchedRole,
    });
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
    final argUser = args['username'];
    final argRole = args['role'];
    final signature = '${argUser ?? ''}|${argRole ?? ''}';
    if (signature == _lastPrefillSignature) return;
    _lastPrefillSignature = signature;
    if (argUser is String && argUser.trim().isNotEmpty) {
      usernameController.text = argUser.trim();
    }
    if (argRole is String && argRole.trim().isNotEmpty) {
      lockedRole.value = argRole.toString().toLowerCase();
      selectedRole.value = _titleCase(argRole);
    } else {
      lockedRole.value = null;
      selectedRole.value = 'Apoteker';
    }
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
}
