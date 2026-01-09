import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaleItemEntry {
  final String name;
  final int qty;

  const SaleItemEntry({
    required this.name,
    required this.qty,
  });
}

class SaleEntry {
  final String id;
  final DateTime createdAt;
  final int totalAmount;
  final String paymentMethod;
  final String cashierName;
  final List<SaleItemEntry> items;

  const SaleEntry({
    required this.id,
    required this.createdAt,
    required this.totalAmount,
    required this.paymentMethod,
    required this.cashierName,
    required this.items,
  });
}

class PosHistoryController extends GetxController {
  final search = ''.obs;
  final selectedFilter = 'Semua'.obs;
  final sales = <SaleEntry>[].obs;
  final isLoading = false.obs;
  final SupabaseClient _client = Supabase.instance.client;

  void setFilter(String value) => selectedFilter.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  void setSearch(String value) => search.value = value.trim();

  List<SaleEntry> get filteredSales {
    final query = search.value.toLowerCase();
    if (query.isEmpty) {
      return sales.toList();
    }
    return sales.where((sale) {
      if (sale.id.toLowerCase().contains(query)) {
        return true;
      }
      if (sale.cashierName.toLowerCase().contains(query)) {
        return true;
      }
      return sale.items.any((item) => item.name.toLowerCase().contains(query));
    }).toList();
  }

  int get totalTransactions => sales.length;

  int get totalItems => sales.fold(0, (sum, sale) {
        return sum + sale.items.fold(0, (itemSum, item) => itemSum + item.qty);
      });

  int get totalRevenue => sales.fold(0, (sum, sale) => sum + sale.totalAmount);

  Future<void> fetchSales() async {
    isLoading.value = true;
    try {
      final data = await _client
          .from('sales')
          .select('id, created_at, total_amount, payment_method, cashier:profiles(username), sale_items(qty, medicines(name))')
          .order('created_at', ascending: false);
      final parsed = (data as List)
          .map(
            (row) {
              final itemsRaw = (row['sale_items'] as List? ?? []);
              final items = itemsRaw
                  .map((item) {
                    final med = item['medicines'] as Map<String, dynamic>?;
                    final name = (med?['name'] ?? '-') as String;
                    final qty = (item['qty'] ?? 0) as int;
                    return SaleItemEntry(name: name, qty: qty);
                  })
                  .toList();
              final cashier = row['cashier'] as Map<String, dynamic>?;
              final cashierName = (cashier?['username'] ?? '-') as String;
              final createdRaw = row['created_at'];
              final createdAt = createdRaw is String ? DateTime.parse(createdRaw) : createdRaw as DateTime;
              return SaleEntry(
                id: row['id'] as String,
                createdAt: createdAt.toLocal(),
                totalAmount: (row['total_amount'] ?? 0) as int,
                paymentMethod: (row['payment_method'] ?? '-') as String,
                cashierName: cashierName,
                items: items,
              );
            },
          )
          .toList();
      sales.assignAll(parsed);
    } catch (error) {
      Get.snackbar('Gagal memuat', error.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
