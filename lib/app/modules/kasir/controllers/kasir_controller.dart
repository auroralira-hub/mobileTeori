import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';

class MedicineResult {
  final String id;
  final String name;
  final String rackCode;
  final int stock;
  final int price;

  const MedicineResult({
    required this.id,
    required this.name,
    required this.rackCode,
    required this.stock,
    required this.price,
  });
}

class CartItem {
  final String medicineId;
  final String name;
  final int unitPrice;
  final RxInt qty;

  CartItem({
    required this.medicineId,
    required this.name,
    required this.unitPrice,
    required int qty,
  }) : qty = qty.obs;

  int get lineTotal => unitPrice * qty.value;
}

class KasirController extends GetxController {
  final searchText = ''.obs;
  final searchResults = <MedicineResult>[].obs;
  final cartItems = <CartItem>[].obs;
  final isSearching = false.obs;
  final isSubmitting = false.obs;
  final cashierName = '-'.obs;
  final now = DateTime.now().obs;
  final SupabaseClient _client = Supabase.instance.client;
  late final AuthService _authService;
  Timer? _searchDebounce;
  Timer? _clockTimer;

  void onSearchChanged(String value) => searchText.value = value;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _hydrateCashierName();
    _loadCashierName();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      now.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    _clockTimer?.cancel();
    super.onClose();
  }

  void onSearchInputChanged(String value) {
    searchText.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      searchMedicines();
    });
  }

  void _hydrateCashierName() {
    final cached = _authService.lastProfileUsername ?? _authService.lastUsername;
    if (cached != null && cached.trim().isNotEmpty) {
      cashierName.value = cached;
    }
  }

  Future<void> _loadCashierName() async {
    try {
      final profile = await _authService.currentProfile();
      if (profile == null) return;
      final name = profile.username ?? profile.email;
      if (name.trim().isNotEmpty) {
        cashierName.value = name;
      }
    } catch (_) {
      // Keep cached name when profile fetch fails.
    }
  }

  Future<void> searchMedicines() async {
    final query = searchText.value.trim();
    isSearching.value = true;
    try {
      var queryBuilder = _client.from('medicines').select('id, name, rack_code, stock, price');
      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.ilike('name', '%$query%');
      }
      final data = await queryBuilder.order('name', ascending: true).limit(20);
      final results = (data as List)
          .map(
            (row) => MedicineResult(
              id: row['id'] as String,
              name: (row['name'] ?? '-') as String,
              rackCode: (row['rack_code'] ?? '-') as String,
              stock: (row['stock'] ?? 0) as int,
              price: (row['price'] ?? 0) as int,
            ),
          )
          .toList();
      searchResults.assignAll(results);
    } catch (error) {
      Get.snackbar('Gagal mencari', error.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSearching.value = false;
    }
  }

  void addToCart(MedicineResult item) {
    if (item.price <= 0) {
      Get.snackbar('Harga tidak valid', 'Harga belum diatur.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final existing = cartItems.firstWhereOrNull((e) => e.medicineId == item.id && e.unitPrice == item.price);
    if (existing != null) {
      existing.qty.value += 1;
      cartItems.refresh();
      return;
    }
    cartItems.add(
      CartItem(
        medicineId: item.id,
        name: item.name,
        unitPrice: item.price,
        qty: 1,
      ),
    );
  }

  void increaseQty(CartItem item) {
    item.qty.value += 1;
    cartItems.refresh();
  }

  void decreaseQty(CartItem item) {
    if (item.qty.value <= 1) {
      cartItems.remove(item);
    } else {
      item.qty.value -= 1;
      cartItems.refresh();
    }
  }

  int get totalAmount => cartItems.fold(0, (sum, item) => sum + item.lineTotal);

  Future<void> checkout({required String paymentMethod}) async {
    if (cartItems.isEmpty) {
      Get.snackbar('Keranjang kosong', 'Tambahkan item terlebih dahulu.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null || userId.trim().isEmpty) {
        Get.snackbar('Sesi tidak valid', 'Silakan login ulang.', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final sale = await _client
          .from('sales')
          .insert({
            'cashier_id': userId,
            'total_amount': totalAmount,
            'payment_method': paymentMethod,
          })
          .select('id')
          .single();
      final saleId = sale['id'] as String;
      final itemsPayload = cartItems
          .map(
            (item) => {
              'sale_id': saleId,
              'medicine_id': item.medicineId,
              'qty': item.qty.value,
              'unit_price': item.unitPrice,
              'line_total': item.lineTotal,
            },
          )
          .toList();
      await _client.from('sale_items').insert(itemsPayload);
      final requestPayload = cartItems
          .map(
            (item) => {
              'apoteker_id': userId,
              'karyawan_id': null,
              'item_name': item.name,
              'qty': item.qty.value,
              'note': 'POS',
              'status': 'new',
              'medicine_id': item.medicineId,
            },
          )
          .toList();
      await _client.from('med_requests').insert(requestPayload);
      cartItems.clear();
      if (searchText.value.trim().isNotEmpty) {
        await searchMedicines();
      }
      Get.snackbar('Sukses', 'Transaksi berhasil disimpan.', snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.snackbar('Gagal transaksi', error.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }
}
