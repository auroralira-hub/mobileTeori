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

  final topSelling = <Map<String, dynamic>>[
    {'name': 'Paracetamol 500 mg', 'sold': 45, 'amount': '450.000'},
    {'name': 'Amoxicillin 500 mg', 'sold': 38, 'amount': '840.000'},
    {'name': 'Vitamin C 1000 mg', 'sold': 35, 'amount': '525.000'},
    {'name': 'OBH Combi Syrup', 'sold': 22, 'amount': '660.000'},
    {'name': 'Cetirizine 10 mg', 'sold': 18, 'amount': '270.000'},
  ].obs;

  final transactions = <Map<String, dynamic>>[
    {
      'title': 'Resep - Tn. Ahmad',
      'items': 3,
      'time': '16:45',
      'total': '145.000',
    },
    {
      'title': 'Umum - Ny. Siti',
      'items': 2,
      'time': '16:30',
      'total': '85.000',
    },
    {
      'title': 'PT Kimia Farma',
      'items': 150,
      'time': '16:15',
      'total': '9.000.000',
    },
    {
      'title': 'Resep - An. Budi',
      'items': 4,
      'time': '15:50',
      'total': '220.000',
    },
    {
      'title': 'Umum - Tn. Rudi',
      'items': 1,
      'time': '15:30',
      'total': '35.000',
    },
  ].obs;

  final lowStocks = <Map<String, dynamic>>[
    {'name': 'OBH Combi Syrup', 'available': 25, 'min': 30},
    {'name': 'Azithromycin 500 mg', 'available': 25, 'min': 60},
    {'name': 'Antasida DOEN', 'available': 30, 'min': 100},
  ].obs;

  final expiredSoon = <Map<String, dynamic>>[
    {'name': 'Amoxicillin 500 mg', 'days': 2, 'date': '10 Jan 2025'},
    {'name': 'Paracetamol 500 mg', 'days': 7, 'date': '15 Jan 2025'},
    {'name': 'Cetirizine 10 mg', 'days': 20, 'date': '28 Jan 2025'},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    selectedDateString.value = DateFormat(
      'dd MMM yyyy',
    ).format(selectedDate.value);
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    selectedDateString.value = DateFormat('dd MMM yyyy').format(date);
    // TODO: Update metrics & lists sesuai tanggal jika sudah ada sumber data
  }

  void exportReport() {
    Get.snackbar(
      'Export',
      'Laporan berhasil diexport',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
