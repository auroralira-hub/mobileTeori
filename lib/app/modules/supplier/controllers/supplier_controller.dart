import 'package:get/get.dart';

class Supplier {
  final String name, category, logoUrl, contact, email;
  final double rating;
  Supplier({required this.name, required this.category, required this.logoUrl, required this.contact, required this.email, required this.rating});
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
    // TODO: Navigasi ke form tambah supplier
  }

  static void quickCall(String phone) {
    // TODO: Integrasi call
  }
  static void quickEmail(String email) {
    // TODO: Integrasi email
  }
  static void quickWhatsApp(String phone) {
    // TODO: Integrasi WhatsApp
  }
}
