import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Sederhana: simpan credential terakhir agar login setelah registrasi bisa dicek.
class AuthService extends GetxService {
  final _box = GetStorage();
  String? _username;
  String? _password;
  String? _role;

  final List<Map<String, String>> _demoUsers = const [
    {
      'username': 'budi.santoso@apotekcare.com',
      'password': 'apoteker123',
      'role': 'apoteker',
    },
    {
      'username': 'andi.pratama@apotekcare.com',
      'password': 'karyawan123',
      'role': 'karyawan',
    },
    {
      'username': 'admin',
      'password': 'admin',
      'role': 'apoteker',
    },
  ];

  void saveUser({
    required String username,
    required String password,
    required String role,
  }) {
    _username = username.trim();
    _password = password;
    _role = role.trim().toLowerCase();
    _box.write('auth_username', _username);
    _box.write('auth_password', _password);
    _box.write('auth_role', _role);
  }

  /// Return matched role when credential valid, otherwise null.
  String? validate(String username, String password, String selectedRole) {
    final user = username.trim().toLowerCase();
    final selected = selectedRole.trim().toLowerCase();
    final userLocalPart = user.contains('@') ? user.split('@').first : user;
    final userNoDots = user.replaceAll('.', '');
    final userLocalNoDots = userLocalPart.replaceAll('.', '');

    for (final demo in _demoUsers) {
      final demoUser = demo['username']!.toLowerCase();
      final demoLocal = demoUser.split('@').first;
      if ((user == demoUser || userLocalPart == demoLocal || userNoDots == demoUser || userLocalNoDots == demoLocal.replaceAll('.', '')) &&
          password == demo['password'] &&
          selected == demo['role']) {
        return demo['role'];
      }
    }

    if (_username == null || _password == null || _role == null) return null;
    final savedUser = _username!.toLowerCase();
    final savedLocal = savedUser.split('@').first;
    final isSameUser = user == savedUser ||
        userLocalPart == savedLocal ||
        userNoDots == savedUser.replaceAll('.', '') ||
        userLocalNoDots == savedLocal.replaceAll('.', '');
    final isSamePassword = password == _password;
    final isSameRole = selected == _role;
    return (isSameUser && isSamePassword && isSameRole) ? _role : null;
  }

  String? get lastUsername => _username;
  String? get lastRole => _role;

  Future<void> loadSaved() async {
    _username = _box.read('auth_username');
    _password = _box.read('auth_password');
    _role = _box.read('auth_role');
  }
}
