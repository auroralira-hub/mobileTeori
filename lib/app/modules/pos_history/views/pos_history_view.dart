import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/lang.dart';
import '../../../routes/app_pages.dart';
import '../controllers/pos_history_controller.dart';

class PosHistoryView extends GetView<PosHistoryController> {
  const PosHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xff2a7ae4);
    final filters = ['Semua', 'Hari Ini', '7 Hari', '30 Hari'];
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final timeFmt = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: Get.back, accent: accent, controller: controller, currency: currency),
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
                                  onChanged: controller.setSearch,
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
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = controller.filteredSales;
                  if (items.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 58, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('Tidak ada transaksi', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('Belum ada transaksi yang tercatat', style: TextStyle(color: Colors.black45)),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final sale = items[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _OrderCard(
                          accent: accent,
                          id: sale.id,
                          name: 'Kasir: ${sale.cashierName}',
                          time: timeFmt.format(sale.createdAt),
                          status: 'Selesai',
                          statusColor: const Color(0xff06b47c),
                          label: sale.paymentMethod.toUpperCase(),
                          items: sale.items,
                          total: currency.format(sale.totalAmount),
                        ),
                      );
                    },
                  );
                },
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
  final PosHistoryController controller;
  final NumberFormat currency;

  const _Header({
    required this.onBack,
    required this.accent,
    required this.controller,
    required this.currency,
  });

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
          Obx(
            () => Row(
              children: [
                _StatCard(title: 'Total Transaksi', value: '${controller.totalTransactions}'),
                const SizedBox(width: 10),
                _StatCard(title: 'Total Item', value: '${controller.totalItems}'),
                const SizedBox(width: 10),
                _StatCard(title: 'Total Omzet', value: currency.format(controller.totalRevenue)),
              ],
            ),
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

class _OrderCard extends StatelessWidget {
  final Color accent;
  final String id;
  final String name;
  final String time;
  final String status;
  final Color statusColor;
  final String label;
  final List<SaleItemEntry> items;
  final String total;

  const _OrderCard({
    required this.accent,
    required this.id,
    required this.name,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.label,
    required this.items,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xffe7f7ef),
                child: Icon(Icons.receipt_long, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(id, style: const TextStyle(fontWeight: FontWeight.w800)),
                    Text(name, style: const TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Chip(text: status, color: statusColor.withValues(alpha: 0.12), textColor: statusColor),
              const SizedBox(width: 8),
              _Chip(text: label, color: const Color(0xffe8f0ff), textColor: const Color(0xff2a7ae4)),
            ],
          ),
          const SizedBox(height: 10),
          Text('${items.length} item obat', style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 6),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.name, style: const TextStyle(color: Colors.black87)),
                    Text('${e.qty}x', style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(total, style: const TextStyle(color: Color(0xff06b47c), fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Chip({required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
