import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final currentTab = 0.obs;
  final userName = 'User'.obs;
  final role = 'Karyawan'.obs;
  final profileUsername = '-'.obs;
  final profileEmail = '-'.obs;
  final profilePhone = '-'.obs;
  final joinedSince = '-'.obs;
  final profileAvatarUrl = ''.obs;
  final isUploadingAvatar = false.obs;
  final pendingRequestsCount = 0.obs;
  final isDarkMode = false.obs;
  final language = 'id'.obs; // 'id' or 'en'
  late final ThemeService _themeService;
  late final GetStorage _storage;
  late final AuthService _authService;
  late final SupabaseClient _client;
  final ImagePicker _picker = ImagePicker();
  Timer? _requestTimer;
  bool _requestCountReady = false;

  static const _languageKey = 'language_code';

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
    _themeService = Get.find<ThemeService>();
    _authService = Get.find<AuthService>();
    _client = Supabase.instance.client;

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

    ever<String>(role, (_) => _maybeStartRequestPolling());
    _hydrateCachedProfile();
    _loadProfile();
    _maybeStartRequestPolling();
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

  Future<void> logout() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.login, arguments: {'clearPrefill': true});
  }

  void _hydrateCachedProfile() {
    final cachedUsername = _authService.lastProfileUsername;
    if (cachedUsername != null && cachedUsername.trim().isNotEmpty) {
      profileUsername.value = cachedUsername;
    }
    final cachedEmail = _authService.lastUsername;
    if (cachedEmail != null && cachedEmail.trim().isNotEmpty) {
      profileEmail.value = cachedEmail;
    }
    final cachedPhone = _authService.lastProfilePhone;
    if (cachedPhone != null && cachedPhone.trim().isNotEmpty) {
      profilePhone.value = cachedPhone;
    }
    final cachedCreated = _authService.lastProfileCreatedAt;
    if (cachedCreated != null) {
      joinedSince.value = _formatDate(cachedCreated);
    }
    final cachedAvatar = _authService.lastProfileAvatarUrl;
    if (cachedAvatar != null && cachedAvatar.trim().isNotEmpty) {
      profileAvatarUrl.value = cachedAvatar;
    }
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _authService.currentProfile();
      if (profile == null) return;
      userName.value = profile.username ?? profile.email;
      role.value = _titleCase(profile.role);
      profileUsername.value = profile.username ?? '-';
      profileEmail.value = profile.email;
      profilePhone.value = (profile.phone != null && profile.phone!.trim().isNotEmpty) ? profile.phone! : '-';
      joinedSince.value = _formatDate(profile.createdAt);
      profileAvatarUrl.value = profile.avatarUrl ?? '';
    } catch (_) {
      // Keep cached/fallback data when profile fetch fails.
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final locale = language.value == 'en' ? 'en_US' : 'id_ID';
    return DateFormat('d MMMM yyyy', locale).format(date.toLocal());
  }

  Future<void> pickAndUploadAvatar() async {
    if (isUploadingAvatar.value) return;
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (file == null) return;
    isUploadingAvatar.value = true;
    try {
      final bytes = await file.readAsBytes();
      final contentType = _guessContentType(file.name);
      final profile = await _authService.uploadAvatar(
        fileName: file.name,
        bytes: bytes,
        contentType: contentType,
      );
      profileAvatarUrl.value = profile.avatarUrl ?? '';
      userName.value = profile.username ?? profile.email;
    } catch (error) {
      final message = _readableUploadError(error);
      debugPrint('Avatar upload failed: $error');
      Get.snackbar(
        'Upload gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  String _guessContentType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  void _maybeStartRequestPolling() {
    final isKaryawan = role.value.toLowerCase() == 'karyawan';
    if (!isKaryawan) {
      _requestTimer?.cancel();
      _requestTimer = null;
      pendingRequestsCount.value = 0;
      _requestCountReady = false;
      return;
    }
    _requestTimer ??= Timer.periodic(const Duration(seconds: 15), (_) {
      _fetchPendingRequests();
    });
    _fetchPendingRequests();
  }

  Future<void> _fetchPendingRequests() async {
    try {
      final data = await _client.from('med_requests').select('id').eq('status', 'new');
      final count = (data as List).length;
      if (_requestCountReady && count > pendingRequestsCount.value) {
        Get.snackbar(
          'Permintaan obat baru',
          'Ada $count permintaan menunggu diambil.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      pendingRequestsCount.value = count;
      _requestCountReady = true;
    } catch (_) {
      // Silent fail: do not block UI when polling fails.
    }
  }

  String _readableUploadError(Object error) {
    if (error is StorageException) {
      return error.message;
    }
    if (error is PostgrestException) {
      return error.message;
    }
    if (error is AuthException) {
      return error.message;
    }
    return error.toString();
  }

  @override
  void onClose() {
    _requestTimer?.cancel();
    super.onClose();
  }
}
