import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/stock_check_controller.dart';

class StockCheckView extends GetView<StockCheckController> {
  const StockCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    final summaries = [
      _SummaryMeta(
        label: 'Aman',
        icon: Icons.check_circle_outline,
        color: Colors.green,
        status: StockStatus.safe,
      ),
      _SummaryMeta(
        label: 'Menipis',
        icon: Icons.warning_amber_rounded,
        color: Colors.orange,
        status: StockStatus.low,
      ),
      _SummaryMeta(
        label: 'Kritis',
        icon: Icons.error_outline,
        color: Colors.red,
        status: StockStatus.critical,
      ),
      _SummaryMeta(
        label: 'Total',
        icon: Icons.medical_services_outlined,
        color: Colors.blue,
        status: null,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroSection(
                controller: controller.searchController,
                onSearch: (val) => controller.query.value = val,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    // Summary cards
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: summaries
                          .map(
                            (s) => _SummaryCard(
                              label: s.label,
                              icon: s.icon,
                              color: s.color,
                              count: s.status == null
                                  ? controller.categories
                                      .expand((c) => c.items)
                                      .length
                                  : controller.countByStatus(s.status!),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _FilterTabs(controller: controller),
                    const SizedBox(height: 16),
                    // Category + items
                    Obx(
                      () => Column(
                        children: controller.filteredCategories
                            .map((cat) => _CategoryCard(category: cat))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff00a86b),
        onPressed: () => Get.toNamed(Routes.scanBarcode),
        child: const Icon(Icons.qr_code_scanner, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff06b47c),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(Routes.home);
              break;
            case 1:
              Get.offAllNamed(Routes.stok);
              break;
            case 2:
              Get.offAllNamed(Routes.rak);
              break;
            default:
              Get.offAllNamed(Routes.lainnya);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Lainnya'),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  const _HeroSection({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                label: const Text('Kembali'),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.download, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Cek Stok',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Monitoring stok obat real-time',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Cari nama obat atau kategori...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMeta {
  final String label;
  final IconData icon;
  final Color color;
  final StockStatus? status;
  const _SummaryMeta({
    required this.label,
    required this.icon,
    required this.color,
    required this.status,
  });
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int count;
  const _SummaryCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),

                    child: Icon(icon, color: color),
                  ),
                  Text(
                    '$count Item',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final StockCheckController controller;
  const _FilterTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: controller.filters.map((filter) {
            final selected = controller.selectedFilter.value == filter;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => controller.selectedFilter.value = filter,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      filter,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? Colors.green[700] : Colors.green[900],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final StockCategory category;
  const _CategoryCard({required this.category});

  Color _statusColor(StockStatus status) {
    switch (status) {
      case StockStatus.safe:
        return Colors.green;
      case StockStatus.low:
        return Colors.orange;
      case StockStatus.critical:
        return Colors.red;
    }
  }

  String _statusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.safe:
        return 'Aman';
      case StockStatus.low:
        return 'Menipis';
      case StockStatus.critical:
        return 'Kritis';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text('${category.items.length} obat'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...category.items.map((item) {
                final color = _statusColor(item.status);
                final progress =
                    (item.available / (item.minStock * 1.2)).clamp(0.0, 1.0);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Card(
                    color: color.withValues(alpha: 0.08),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                item.status == StockStatus.safe
                                    ? Icons.check_circle
                                    : item.status == StockStatus.low
                                        ? Icons.warning_amber_rounded
                                        : Icons.error_outline,
                                color: color,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _statusLabel(item.status),
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Terakhir dicek: ${item.lastChecked}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Stok Tersedia'),
                                  Text(
                                    '${item.available} pcs',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Min. Stok'),
                                  Text(
                                    '${item.minStock} pcs',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
