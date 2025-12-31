import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyReportController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final selectedDateString = ''.obs;

  final metrics = <String, dynamic>{
    'transaksi': 48,
    'revenue': '8.750.000',
    'obatTerjual': 450,
    'obatMasuk': 450,
    'obatKeluar': 235,
  }.obs;

  final topSelling = <Map<String, dynamic>>[].obs;
  final transactions = <Map<String, dynamic>>[].obs;
  final lowStocks = <Map<String, dynamic>>[].obs;
  final expiredSoon = <Map<String, dynamic>>[].obs;

  // Base dummy data (akan di-derive sesuai tanggal)
  final _baseTopSelling = const <Map<String, dynamic>>[
    {'name': 'Paracetamol 500 mg', 'sold': 45, 'amount': '450.000'},
    {'name': 'Amoxicillin 500 mg', 'sold': 38, 'amount': '840.000'},
    {'name': 'Vitamin C 1000 mg', 'sold': 35, 'amount': '525.000'},
    {'name': 'OBH Combi Syrup', 'sold': 22, 'amount': '660.000'},
    {'name': 'Cetirizine 10 mg', 'sold': 18, 'amount': '270.000'},
  ];

  final _baseTransactions = const <Map<String, dynamic>>[
    {'title': 'Resep - Tn. Ahmad', 'items': 3, 'time': '16:45', 'total': '145.000'},
    {'title': 'Umum - Ny. Siti', 'items': 2, 'time': '16:30', 'total': '85.000'},
    {'title': 'PT Kimia Farma', 'items': 150, 'time': '16:15', 'total': '9.000.000'},
    {'title': 'Resep - An. Budi', 'items': 4, 'time': '15:50', 'total': '220.000'},
    {'title': 'Umum - Tn. Rudi', 'items': 1, 'time': '15:30', 'total': '35.000'},
  ];

  final _baseLowStocks = const <Map<String, dynamic>>[
    {'name': 'OBH Combi Syrup', 'available': 25, 'min': 30},
    {'name': 'Azithromycin 500 mg', 'available': 25, 'min': 60},
    {'name': 'Antasida DOEN', 'available': 30, 'min': 100},
  ];

  final _baseExpiredSoon = const <Map<String, dynamic>>[
    {'name': 'Amoxicillin 500 mg', 'days': 2, 'date': '10 Jan 2025'},
    {'name': 'Paracetamol 500 mg', 'days': 7, 'date': '15 Jan 2025'},
    {'name': 'Cetirizine 10 mg', 'days': 20, 'date': '28 Jan 2025'},
  ];

  @override
  void onInit() {
    super.onInit();
    selectedDateString.value = DateFormat('dd MMM yyyy').format(selectedDate.value);
    _applyDummyDataForDate(selectedDate.value);
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    selectedDateString.value = DateFormat('dd MMM yyyy').format(date);

    // Update metrics & lists sesuai tanggal (dummy dinamis dulu)
    _applyDummyDataForDate(date);
  }

  void _applyDummyDataForDate(DateTime date) {
    // Seed sederhana biar datanya berubah per tanggal tapi tetap stabil
    final seed = date.year * 10000 + date.month * 100 + date.day;

    int wobble(int base, int range) {
      // hasil: base-range .. base+range
      final w = (seed % (range * 2 + 1)) - range;
      return base + w;
    }

    // Metrics (angka berubah tipis)
    final transaksi = wobble(48, 12).clamp(0, 9999);
    final obatTerjual = wobble(450, 120).clamp(0, 99999);
    final obatMasuk = wobble(450, 150).clamp(0, 99999);
    final obatKeluar = wobble(235, 90).clamp(0, 99999);

    // Revenue dummy (string rupiah tanpa format locale rumit)
    final revenueInt = (8750000 + (seed % 2000000) - 1000000).clamp(0, 999999999);
    final revenueStr = _formatRupiah(revenueInt);

    metrics.assignAll({
      'transaksi': transaksi,
      'revenue': revenueStr,
      'obatTerjual': obatTerjual,
      'obatMasuk': obatMasuk,
      'obatKeluar': obatKeluar,
    });

    // Top selling: sold berubah sedikit, amount juga ikut
    topSelling.assignAll(_baseTopSelling.map((e) {
      final soldBase = (e['sold'] as int);
      final sold = (soldBase + ((seed + soldBase) % 9) - 4).clamp(0, 9999);
      // amount tetap string; kita bikin amount kira-kira proporsional
      final amountInt = sold * 10000;
      return {
        'name': e['name'],
        'sold': sold,
        'amount': _formatRupiah(amountInt),
      };
    }).toList());

    // Transactions: items berubah sedikit, total dibuat proporsional
    transactions.assignAll(_baseTransactions.map((e) {
      final itemsBase = (e['items'] as int);
      final items = (itemsBase + ((seed + itemsBase) % 5) - 2).clamp(1, 99999);
      final totalInt = items * 35000 + ((seed % 5) * 5000);
      return {
        'title': e['title'],
        'items': items,
        'time': e['time'],
        'total': _formatRupiah(totalInt),
      };
    }).toList());

    // Low stocks: available berubah sedikit, min tetap
    lowStocks.assignAll(_baseLowStocks.map((e) {
      final availableBase = (e['available'] as int);
      final min = (e['min'] as int);
      final available = (availableBase + ((seed + min) % 11) - 5).clamp(0, 99999);
      return {
        'name': e['name'],
        'available': available,
        'min': min,
      };
    }).toList());

    // Expired soon: days berubah sedikit, date tetap
    expiredSoon.assignAll(_baseExpiredSoon.map((e) {
      final daysBase = (e['days'] as int);
      final days = (daysBase + (seed % 4) - 1).clamp(0, 365);
      return {
        'name': e['name'],
        'days': days,
        'date': e['date'],
      };
    }).toList());
  }

  String _formatRupiah(int value) {
    // Format sederhana: 8750000 -> "8.750.000"
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) {
        buf.write('.');
      }
    }
    return buf.toString();
  }

  void exportReport() {
    Get.snackbar(
      'Export',
      'Laporan berhasil diexport',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
