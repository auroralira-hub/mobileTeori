import 'package:get/get.dart';

class MovementPoint {
  final String label;
  final int masuk;
  final int keluar;
  const MovementPoint({
    required this.label,
    required this.masuk,
    required this.keluar,
  });
}

class TopProduct {
  final String name;
  final int sold;
  final String percentText;
  final bool isPositive;
  const TopProduct({
    required this.name,
    required this.sold,
    required this.percentText,
    this.isPositive = true,
  });
}

class AnalyticsData {
  final String masukValue;
  final String masukChange;
  final String keluarValue;
  final String keluarChange;
  final List<MovementPoint> movement;
  final List<TopProduct> topProducts;
  final String expiredCount;
  final String topPrescription;

  const AnalyticsData({
    required this.masukValue,
    required this.masukChange,
    required this.keluarValue,
    required this.keluarChange,
    required this.movement,
    required this.topProducts,
    required this.expiredCount,
    required this.topPrescription,
  });
}

class AnalyticsController extends GetxController {
  final periods = ['Minggu Ini', 'Bulan Ini', 'Tahun Ini'];
  final selectedPeriod = 'Bulan Ini'.obs;

  final Map<String, AnalyticsData> _dataByPeriod = {
    'Minggu Ini': const AnalyticsData(
      masukValue: '1,320 pcs',
      masukChange: '+6% minggu ini',
      keluarValue: '980 pcs',
      keluarChange: '+4% minggu ini',
      movement: [
        MovementPoint(label: 'Sen', masuk: 210, keluar: 160),
        MovementPoint(label: 'Sel', masuk: 190, keluar: 150),
        MovementPoint(label: 'Rab', masuk: 220, keluar: 170),
        MovementPoint(label: 'Kam', masuk: 200, keluar: 150),
        MovementPoint(label: 'Jum', masuk: 240, keluar: 170),
        MovementPoint(label: 'Sab', masuk: 260, keluar: 180),
      ],
      topProducts: [
        TopProduct(
          name: 'Paracetamol 500 mg',
          sold: 180,
          percentText: '+9%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Amoxicillin 500 mg',
          sold: 140,
          percentText: '+5%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Vitamin C 1000 mg',
          sold: 120,
          percentText: '+12%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Cetirizine 10 mg',
          sold: 90,
          percentText: '-3%',
          isPositive: false,
        ),
        TopProduct(
          name: 'OBH Combi Syrup',
          sold: 80,
          percentText: '+6%',
          isPositive: true,
        ),
      ],
      expiredCount: '1 Obat',
      topPrescription: 'Paracetamol',
    ),
    'Bulan Ini': const AnalyticsData(
      masukValue: '8,450 pcs',
      masukChange: '+18% bulan ini',
      keluarValue: '6,780 pcs',
      keluarChange: '+12% bulan ini',
      movement: [
        MovementPoint(label: 'Jul', masuk: 1200, keluar: 950),
        MovementPoint(label: 'Agu', masuk: 1400, keluar: 1100),
        MovementPoint(label: 'Sep', masuk: 1100, keluar: 980),
        MovementPoint(label: 'Okt', masuk: 1600, keluar: 1250),
        MovementPoint(label: 'Nov', masuk: 1350, keluar: 1150),
        MovementPoint(label: 'Des', masuk: 1800, keluar: 1400),
      ],
      topProducts: [
        TopProduct(
          name: 'Paracetamol 500 mg',
          sold: 850,
          percentText: '+12%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Amoxicillin 500 mg',
          sold: 620,
          percentText: '+8%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Vitamin C 1000 mg',
          sold: 580,
          percentText: '+15%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Cetirizine 10 mg',
          sold: 420,
          percentText: '-5%',
          isPositive: false,
        ),
        TopProduct(
          name: 'OBH Combi Syrup',
          sold: 380,
          percentText: '+22%',
          isPositive: true,
        ),
      ],
      expiredCount: '3 Obat',
      topPrescription: 'Paracetamol',
    ),
    'Tahun Ini': const AnalyticsData(
      masukValue: '92,300 pcs',
      masukChange: '+11% tahun ini',
      keluarValue: '81,950 pcs',
      keluarChange: '+9% tahun ini',
      movement: [
        MovementPoint(label: 'Jan', masuk: 7200, keluar: 6300),
        MovementPoint(label: 'Mar', masuk: 7600, keluar: 6700),
        MovementPoint(label: 'Mei', masuk: 8200, keluar: 7300),
        MovementPoint(label: 'Jul', masuk: 8400, keluar: 7600),
        MovementPoint(label: 'Sep', masuk: 8800, keluar: 7900),
        MovementPoint(label: 'Nov', masuk: 9300, keluar: 8200),
      ],
      topProducts: [
        TopProduct(
          name: 'Paracetamol 500 mg',
          sold: 9200,
          percentText: '+10%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Amoxicillin 500 mg',
          sold: 7800,
          percentText: '+7%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Vitamin C 1000 mg',
          sold: 6900,
          percentText: '+9%',
          isPositive: true,
        ),
        TopProduct(
          name: 'Cetirizine 10 mg',
          sold: 5300,
          percentText: '-2%',
          isPositive: false,
        ),
        TopProduct(
          name: 'OBH Combi Syrup',
          sold: 5100,
          percentText: '+5%',
          isPositive: true,
        ),
      ],
      expiredCount: '7 Obat',
      topPrescription: 'Amoxicillin',
    ),
  };

  AnalyticsData get currentData => _dataByPeriod[selectedPeriod.value]!;
}
