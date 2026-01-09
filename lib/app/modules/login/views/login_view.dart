import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LoginController>()) {
      Get.put<LoginController>(LoginController(), permanent: true);
    }
    final currentArgs = Get.arguments;
    if (currentArgs != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<LoginController>()) {
          Get.find<LoginController>().prefillFromExternalArgs(currentArgs);
        }
      });
    }
    final accent = const Color(0xff06b47c);
    final roles = const ['Apoteker', 'Karyawan'];

    InputDecoration fieldDecoration({
      required String hint,
      required IconData icon,
      bool outlined = false,
    }) {
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: outlined ? accent : Colors.transparent, width: outlined ? 1.6 : 0),
      );
      return InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: !outlined,
        fillColor: outlined ? Colors.white : Colors.grey[100],
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: accent, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe8fff5), Color(0xfff8fbff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 32, 18, 26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _HeroLogo(accent: accent),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Text(
                                'Apotek Aafiyah',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: accent,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Sistem Internal Manajemen Apotek Aafiyah',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xffe4ecf5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Anda adalah',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                Obx(() {
                                  return Row(
                                    children: roles.map((r) {
                                      final selected = controller.selectedRole.value == r;
                                      final bg = selected ? const Color(0xffe8fff5) : Colors.white;
                                      final borderColor = selected ? accent : const Color(0xffe4ecf5);
                                      final iconColor = selected ? accent : Colors.grey;
                                      final labelColor = selected ? accent : Colors.black87;
                                      final subColor = Colors.grey;

                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: GestureDetector(
                                            onTap: () => controller.selectRole(r),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              decoration: BoxDecoration(
                                                color: bg,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: borderColor,
                                                  width: selected ? 1.6 : 1,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    r == 'Apoteker'
                                                        ? Icons.local_hospital_outlined
                                                        : Icons.inventory_2_outlined,
                                                    color: iconColor,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    r,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: labelColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    r == 'Apoteker'
                                                        ? 'Konsultasi & transaksi'
                                                        : 'Ambil obat & stok',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: subColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: controller.usernameController,
                                  decoration: fieldDecoration(
                                    hint: 'Email',
                                    icon: Icons.mail_outline,
                                    outlined: true,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                Obx(
                                  () => TextField(
                                    controller: controller.passwordController,
                                    obscureText: controller.obscurePassword.value,
                                    decoration: fieldDecoration(
                                      hint: 'Masukkan password',
                                      icon: Icons.lock_outline,
                                      outlined: true,
                                    ).copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.obscurePassword.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: controller.togglePasswordVisibility,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: controller.forgotPassword,
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    child: Text(
                                      'Lupa password?',
                                      style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 12.5),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: controller.login,
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Belum punya akun? '),
                                      TextButton(
                                        onPressed: () => Get.toNamed(Routes.register),
                                        child: const Text('Registrasi'),
                                      ),
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => controller.errorMessage.value.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            controller.errorMessage.value,
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroLogo extends StatelessWidget {
  final Color accent;
  const _HeroLogo({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xffc7ffe5),
            Color(0xfff4fffb),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: accent,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.add,
            size: 44,
            color: accent,
          ),
        ),
      ),
    );
  }
}
