import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final errorMessage = ''.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    if (username == 'admin' && password == 'admin') {
      errorMessage.value = '';
      // Navigasi ke dashboard/home
      Get.offAllNamed('/home');
    } else {
      errorMessage.value = 'Username atau password salah';
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
