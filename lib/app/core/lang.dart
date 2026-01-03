import 'package:get_storage/get_storage.dart';

/// Simple helper to read stored language and provide bilingual labels.
class Lang {
  static const _key = 'language_code';
  static final GetStorage _box = GetStorage();

  static String get code {
    final stored = _box.read<String>(_key);
    return stored == 'en' ? 'en' : 'id';
  }

  static bool get isEn => code == 'en';

  static String navHome() => isEn ? 'Home' : 'Home';
  static String navStock() => isEn ? 'Stock' : 'Stok';
  static String navRack() => isEn ? 'Rack' : 'Rak';
  static String navProfile() => isEn ? 'Profile' : 'Profil';
}
