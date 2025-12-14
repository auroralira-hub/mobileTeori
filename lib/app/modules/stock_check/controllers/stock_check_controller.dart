import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum StockStatus { safe, low, critical }

class StockItem {
  final String name;
  final String lastChecked;
  final int available;
  final int minStock;
  final StockStatus status;
  const StockItem({
    required this.name,
    required this.lastChecked,
    required this.available,
    required this.minStock,
    required this.status,
  });
}

class StockCategory {
  final String name;
  final List<StockItem> items;
  const StockCategory({required this.name, required this.items});
}

class StockCheckController extends GetxController {
  final searchController = TextEditingController();
  final query = ''.obs;
  final selectedFilter = 'Semua'.obs;

  final categories = <StockCategory>[
    StockCategory(
      name: 'Analgesik & Antipiretik',
      items: [
        StockItem(
          name: 'Paracetamol 500 mg',
          lastChecked: '08 Des 2024',
          available: 450,
          minStock: 100,
          status: StockStatus.safe,
        ),
        StockItem(
          name: 'Ibuprofen 400 mg',
          lastChecked: '08 Des 2024',
          available: 280,
          minStock: 150,
          status: StockStatus.safe,
        ),
        StockItem(
          name: 'Asam Mefenamat 500 mg',
          lastChecked: '07 Des 2024',
          available: 95,
          minStock: 100,
          status: StockStatus.low,
        ),
      ],
    ),
    StockCategory(
      name: 'Antibiotik',
      items: [
        StockItem(
          name: 'Amoxicillin 500 mg',
          lastChecked: '08 Des 2024',
          available: 85,
          minStock: 100,
          status: StockStatus.low,
        ),
        StockItem(
          name: 'Ciprofloxacin 500 mg',
          lastChecked: '08 Des 2024',
          available: 120,
          minStock: 80,
          status: StockStatus.safe,
        ),
        StockItem(
          name: 'Azithromycin 500 mg',
          lastChecked: '06 Des 2024',
          available: 25,
          minStock: 60,
          status: StockStatus.critical,
        ),
      ],
    ),
    StockCategory(
      name: 'Antihistamin',
      items: [
        StockItem(
          name: 'Cetirizine 10 mg',
          lastChecked: '08 Des 2024',
          available: 320,
          minStock: 80,
          status: StockStatus.safe,
        ),
        StockItem(
          name: 'Loratadine 10 mg',
          lastChecked: '08 Des 2024',
          available: 180,
          minStock: 70,
          status: StockStatus.safe,
        ),
        StockItem(
          name: 'Chlorpheniramine 4 mg',
          lastChecked: '07 Des 2024',
          available: 45,
          minStock: 50,
          status: StockStatus.low,
        ),
      ],
    ),
    StockCategory(
      name: 'Obat Lambung',
      items: [
        StockItem(
          name: 'Omeprazole 20 mg',
          lastChecked: '08 Des 2024',
          available: 180,
          minStock: 60,
          status: StockStatus.safe,
        ),
        StockItem(
          name: 'Ranitidine 150 mg',
          lastChecked: '08 Des 2024',
          available: 140,
          minStock: 80,
          status: StockStatus.safe,
        ),
        StockItem(
          name: 'Antasida DOEN',
          lastChecked: '05 Des 2024',
          available: 30,
          minStock: 100,
          status: StockStatus.critical,
        ),
      ],
    ),
  ];

  List<String> get filters => ['Semua', 'Aman', 'Menipis', 'Kritis'];

  List<StockCategory> get filteredCategories {
    final q = query.value.toLowerCase();
    return categories
        .map((cat) {
          final filteredItems = cat.items.where((item) {
            final matchQuery = q.isEmpty || item.name.toLowerCase().contains(q);
            final matchStatus =
                selectedFilter.value == 'Semua' ||
                (selectedFilter.value == 'Aman' &&
                    item.status == StockStatus.safe) ||
                (selectedFilter.value == 'Menipis' &&
                    item.status == StockStatus.low) ||
                (selectedFilter.value == 'Kritis' &&
                    item.status == StockStatus.critical);
            return matchQuery && matchStatus;
          }).toList();
          return StockCategory(name: cat.name, items: filteredItems);
        })
        .where((c) => c.items.isNotEmpty)
        .toList();
  }

  int countByStatus(StockStatus status) {
    return categories
        .expand((c) => c.items)
        .where((item) => item.status == status)
        .length;
  }
}
