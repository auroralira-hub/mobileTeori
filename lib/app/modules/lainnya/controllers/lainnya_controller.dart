import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class LainnyaController extends GetxController {
  final userName = 'User'.obs;
  final roleLabel = 'Karyawan'.obs;
  final sipa = '-'.obs;
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _hydrateCachedProfile();
    _loadProfile();
  }

  void showComingSoon(String feature) {
    Get.snackbar(
      feature,
      'Fitur akan segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _hydrateCachedProfile() {
    final cachedName = _authService.lastProfileUsername ?? _authService.lastUsername;
    if (cachedName != null && cachedName.trim().isNotEmpty) {
      userName.value = cachedName;
    }
    final cachedRole = _authService.lastRole;
    if (cachedRole != null && cachedRole.trim().isNotEmpty) {
      roleLabel.value = _roleLabel(cachedRole);
    }
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _authService.currentProfile();
      if (profile == null) return;
      userName.value = profile.username ?? profile.email;
      roleLabel.value = _roleLabel(profile.role);
    } catch (_) {
      // Keep cached/fallback data when profile fetch fails.
    }
  }

  String _roleLabel(String role) {
    final normalized = role.trim().toLowerCase();
    if (normalized == 'apoteker') {
      return 'Apoteker Penanggung Jawab';
    }
    return 'Karyawan';
  }
}
