import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/antrian_controller.dart';

class AntrianView extends GetView<AntrianController> {
  const AntrianView({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xff06b47c);
    final filters = ['Semua', 'Selesai'];
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final timeFmt = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: Column(
          children: [
            _Header(accent: accent, onBack: Get.back),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                children: [
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xffe1e7ef)),
                    ),
                    child: TextField(
                      onChanged: controller.setSearch,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey),
                        hintText: 'Cari nomor transaksi, kasir, atau nama obat',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Row(
                      children: filters.map((f) {
                        final selected = controller.selectedFilter.value == f;
                        final chipColor = f == 'Semua' ? accent : const Color(0xff06b47c);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: selected,
                            onSelected: (_) => controller.setFilter(f),
                            selectedColor: chipColor,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: selected ? Colors.transparent : const Color(0xffe1e7ef)),
                            ),
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
                    return const Center(child: Text('Belum ada transaksi.'));
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
                          payable: false,
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
        selectedItemColor: accent,
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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
      ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Color accent;
  final VoidCallback onBack;

  const _Header({required this.accent, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff06b47c), Color(0xff02a867)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Text(
            'Antrian Transaksi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
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
  final bool payable;

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
    required this.payable,
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
                child: Icon(payable ? Icons.credit_card : Icons.timer, color: accent),
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
              const Spacer(),
              if (payable)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Proses Bayar'),
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
