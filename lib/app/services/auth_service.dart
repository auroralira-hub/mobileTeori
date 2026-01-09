import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class AuthProfile {
  final String id;
  final String email;
  final String role;
  final String? username;
  final String? fullName;
  final String? phone;
  final DateTime? createdAt;
  final String? avatarUrl;

  const AuthProfile({
    required this.id,
    required this.email,
    required this.role,
    this.username,
    this.fullName,
    this.phone,
    this.createdAt,
    this.avatarUrl,
  });
}

class AuthService extends GetxService {
  final _box = GetStorage();
  final SupabaseClient _client = Supabase.instance.client;
  static const _avatarBucket = 'avatars';
  String? _lastEmail;
  String? _lastRole;
  String? _lastUsername;
  String? _lastPhone;
  DateTime? _lastCreatedAt;
  String? _lastAvatarUrl;

  String? get lastUsername => _lastEmail;
  String? get lastRole => _lastRole;
  String? get lastProfileUsername => _lastUsername;
  String? get lastProfilePhone => _lastPhone;
  DateTime? get lastProfileCreatedAt => _lastCreatedAt;
  String? get lastProfileAvatarUrl => _lastAvatarUrl;

  Future<void> loadSaved() async {
    _lastEmail = _box.read('auth_last_email');
    _lastRole = _box.read('auth_last_role');
    _lastUsername = _box.read('auth_last_username');
    _lastPhone = _box.read('auth_last_phone');
    _lastAvatarUrl = _box.read('auth_last_avatar_url');
    final createdRaw = _box.read('auth_last_created_at');
    if (createdRaw is String && createdRaw.isNotEmpty) {
      _lastCreatedAt = DateTime.tryParse(createdRaw);
    }
  }

  Future<AuthProfile> signUp({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    final normalizedRole = _normalizeRole(role);
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'username': username.trim(),
        'role': normalizedRole,
      },
    );
    final user = response.user;
    if (user == null) {
      throw const AuthException('Registrasi gagal. Silakan coba lagi.');
    }
    final profile = await _fetchProfile(user.id).catchError((_) {
      return AuthProfile(
        id: user.id,
        email: email.trim(),
        role: normalizedRole,
        username: username.trim(),
      );
    });
    _cacheProfile(profile);
    return profile;
  }

  Future<AuthProfile> signIn({
    required String identifier,
    required String password,
    required String selectedRole,
  }) async {
    final email = await _resolveEmail(identifier);
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw const AuthException('Login gagal. Silakan cek kembali akun Anda.');
    }
    final profile = await _fetchProfile(user.id);
    final normalizedRole = _normalizeRole(selectedRole);
    if (profile.role != normalizedRole) {
      await _client.auth.signOut();
      throw StateError('Role tidak sesuai dengan akun.');
    }
    _cacheProfile(profile);
    return profile;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    _lastEmail = null;
    _lastRole = null;
    _lastUsername = null;
    _lastPhone = null;
    _lastCreatedAt = null;
    _lastAvatarUrl = null;
    _box.remove('auth_last_email');
    _box.remove('auth_last_role');
    _box.remove('auth_last_username');
    _box.remove('auth_last_phone');
    _box.remove('auth_last_created_at');
    _box.remove('auth_last_avatar_url');
  }

  Future<AuthProfile?> currentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final profile = await _fetchProfile(user.id);
    _cacheProfile(profile);
    return profile;
  }

  Future<AuthProfile> _fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select('id, email, role, username, full_name, phone, created_at, avatar_url')
        .eq('id', userId)
        .single();
    final createdRaw = data['created_at'];
    final createdAt = createdRaw is String ? DateTime.tryParse(createdRaw) : createdRaw as DateTime?;
    return AuthProfile(
      id: data['id'] as String,
      email: (data['email'] ?? '') as String,
      role: (data['role'] ?? '') as String,
      username: data['username'] as String?,
      fullName: data['full_name'] as String?,
      phone: data['phone'] as String?,
      createdAt: createdAt,
      avatarUrl: data['avatar_url'] as String?,
    );
  }

  void _cacheProfile(AuthProfile profile) {
    _lastEmail = profile.email;
    _lastRole = profile.role;
    _lastUsername = profile.username;
    _lastPhone = profile.phone;
    _lastCreatedAt = profile.createdAt;
    _lastAvatarUrl = profile.avatarUrl;
    _box.write('auth_last_email', _lastEmail);
    _box.write('auth_last_role', _lastRole);
    _box.write('auth_last_username', _lastUsername);
    _box.write('auth_last_phone', _lastPhone);
    _box.write('auth_last_avatar_url', _lastAvatarUrl);
    if (_lastCreatedAt != null) {
      _box.write('auth_last_created_at', _lastCreatedAt!.toIso8601String());
    }
  }

  String _normalizeRole(String role) {
    final normalized = role.trim().toLowerCase();
    if (normalized == 'apoteker' || normalized == 'karyawan') {
      return normalized;
    }
    return 'karyawan';
  }

  Future<String> _resolveEmail(String identifier) async {
    final trimmed = identifier.trim();
    if (trimmed.isEmpty) {
      throw const AuthException('Email atau username wajib diisi.');
    }
    if (GetUtils.isEmail(trimmed)) {
      return trimmed;
    }
    final data = await _client.rpc('get_email_by_username', params: {'p_username': trimmed});
    final email = data is String ? data : null;
    if (email == null || email.trim().isEmpty) {
      throw const AuthException('Username tidak ditemukan.');
    }
    return email.trim();
  }

  Future<AuthProfile> uploadAvatar({
    required String fileName,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Sesi sudah berakhir. Silakan login kembali.');
    }
    final ext = fileName.contains('.') ? fileName.split('.').last : 'jpg';
    final objectPath = '${user.id}/avatar.$ext';
    await _client.storage.from(_avatarBucket).uploadBinary(
          objectPath,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: contentType,
          ),
        );
    final publicUrl = _client.storage.from(_avatarBucket).getPublicUrl(objectPath);
    await _client.from('profiles').update({'avatar_url': publicUrl}).eq('id', user.id);
    final profile = await _fetchProfile(user.id);
    _cacheProfile(profile);
    return profile;
  }
}
