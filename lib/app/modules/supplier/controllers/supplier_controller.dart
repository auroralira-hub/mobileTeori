import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Supplier {
  final String name, category, logoUrl, contact, email;
  final double rating;

  Supplier({
    required this.name,
    required this.category,
    required this.logoUrl,
    required this.contact,
    required this.email,
    required this.rating,
  });
}

class SupplierController extends GetxController {
  final suppliers = <Supplier>[].obs;

  @override
  void onInit() {
    super.onInit();
    suppliers.assignAll([
      Supplier(
        name: 'PT Kimia Farma',
        category: 'Distributor',
        logoUrl: 'https://via.placeholder.com/56',
        contact: '+628123456789',
        email: 'kimiafarma@email.com',
        rating: 4.7,
      ),
      Supplier(
        name: 'PT Kalbe Farma',
        category: 'Pabrik',
        logoUrl: 'https://via.placeholder.com/56',
        contact: '+628987654321',
        email: 'kalbe@email.com',
        rating: 4.5,
      ),
    ]);
  }

  void goToPO(Supplier s) {
    Get.toNamed('/purchase-order');
  }

  void addSupplier() {
    // Ganti route ini sesuai halaman form tambah supplier kamu
    // misal: '/supplier/add' atau '/add-supplier'
    Get.toNamed('/supplier/add');
  }

  static Future<void> quickCall(String phone) async {
    final cleaned = _normalizePhone(phone);
    final uri = Uri(scheme: 'tel', path: cleaned);
    if (!await launchUrl(uri)) {
      Get.snackbar('Gagal', 'Tidak bisa membuka dialer: $cleaned');
    }
  }

  static Future<void> quickEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email.trim(),
    );
    if (!await launchUrl(uri)) {
      Get.snackbar('Gagal', 'Tidak bisa membuka email: ${email.trim()}');
    }
  }

  static Future<void> quickWhatsApp(String phone) async {
    final cleaned = _normalizePhone(phone);
    final waNumber = _toIndoIntl(cleaned);

    final uri = Uri.parse('https://wa.me/$waNumber');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Gagal', 'Tidak bisa membuka WhatsApp: $waNumber');
    }
  }

  static String _normalizePhone(String phone) {
    return phone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
  }

  static String _toIndoIntl(String phone) {
    var p = phone;
    if (p.startsWith('+')) p = p.substring(1); // +62xxxx -> 62xxxx
    if (p.startsWith('08')) return '62${p.substring(1)}'; // 08xxxx -> 628xxxx
    return p;
  }
}
