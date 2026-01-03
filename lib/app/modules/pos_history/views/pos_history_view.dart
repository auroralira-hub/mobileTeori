import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/lang.dart';
import '../../../routes/app_pages.dart';
import '../controllers/pos_history_controller.dart';

class PosHistoryView extends GetView<PosHistoryController> {
  const PosHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xff2a7ae4);
    final filters = ['Semua', 'Hari Ini', '7 Hari', '30 Hari'];

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: Get.back, accent: accent),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xffe1e7ef)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  onChanged: (v) => controller.search.value = v,
                                  decoration: const InputDecoration(
                                    hintText: 'Cari no. transaksi, kasir, produk',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.file_download_outlined),
                          label: const Text('Export'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff05b77a),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: filters.map((f) {
                        final selected = controller.selectedFilter.value == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: selected,
                            onSelected: (_) => controller.setFilter(f),
                            label: Text(f),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            selectedColor: const Color(0xff2a7ae4),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xffe1e7ef)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.receipt_long_outlined, size: 58, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Tidak ada transaksi', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Belum ada transaksi yang tercatat', style: TextStyle(color: Colors.black45)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: const Color(0xff06b47c),
        unselectedItemColor: Colors.grey,
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
              Get.offAllNamed(Routes.home, arguments: {'tab': 3});
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: Lang.navHome()),
          BottomNavigationBarItem(icon: const Icon(Icons.inventory_2_outlined), label: Lang.navStock()),
          BottomNavigationBarItem(icon: const Icon(Icons.grid_view), label: Lang.navRack()),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: Lang.navProfile()),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final Color accent;

  const _Header({required this.onBack, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1e6de0), Color(0xff4b8dff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          const Text(
            'Riwayat Transaksi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Semua transaksi tersimpan',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              _StatCard(title: 'Total Transaksi', value: '0'),
              SizedBox(width: 10),
              _StatCard(title: 'Total Item', value: '0'),
              SizedBox(width: 10),
              _StatCard(title: 'Total Omzet', value: 'Rp 0'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
