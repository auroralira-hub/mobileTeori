import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/kasir_controller.dart';

class KasirView extends GetView<KasirController> {
  const KasirView({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xff06b47c);

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () {
                final now = controller.now.value;
                final dateLabel = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
                final timeLabel = DateFormat('HH.mm.ss').format(now);
                return _KasirHeader(
                  onBack: Get.back,
                  accent: accent,
                  cashierName: controller.cashierName.value,
                  dateLabel: dateLabel,
                  timeLabel: timeLabel,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xffdfe6ef)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.toNamed(Routes.scanBarcode),
                            icon: const Icon(Icons.fullscreen),
                            color: accent,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: controller.onSearchInputChanged,
                              onSubmitted: (_) => controller.searchMedicines(),
                              onTap: controller.searchMedicines,
                              decoration: const InputDecoration(
                                hintText: 'Scan barcode atau ketik manual',
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
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: controller.searchMedicines,
                      icon: const Icon(Icons.search),
                      label: const Text('Cari'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2a7ae4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  final results = controller.searchResults;
                  final cartItems = controller.cartItems;
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      if (controller.isSearching.value)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (results.isNotEmpty) ...[
                        const Text(
                          'Hasil Pencarian',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        ...results.map(
                          (item) => Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text('Rak ${item.rackCode} • Stok ${item.stock} • Harga ${item.price}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Color(0xff06b47c)),
                                onPressed: () => controller.addToCart(item),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const Text(
                        'Keranjang',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      if (cartItems.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text('Keranjang masih kosong'),
                          ),
                        )
                      else ...[
                        ...cartItems.map(
                          (item) => Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text('Harga: ${item.unitPrice} • Total: ${item.lineTotal}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => controller.decreaseQty(item),
                                  ),
                                  Obx(() => Text('${item.qty.value}')),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => controller.increaseQty(item),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
                            Text(
                              '${controller.totalAmount}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () => _showPaymentDialog(context, controller),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff06b47c),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Obx(
                              () => Text(
                                controller.isSubmitting.value ? 'Memproses...' : 'Bayar',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
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

Future<void> _showPaymentDialog(BuildContext context, KasirController controller) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Metode Pembayaran'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('Tunai'),
            onTap: () {
              Get.back();
              controller.checkout(paymentMethod: 'cash');
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('QRIS'),
            onTap: () {
              Get.back();
              controller.checkout(paymentMethod: 'qris');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text('Transfer'),
            onTap: () {
              Get.back();
              controller.checkout(paymentMethod: 'transfer');
            },
          ),
        ],
      ),
    ),
  );
}

class _KasirHeader extends StatelessWidget {
  final VoidCallback onBack;
  final Color accent;
  final String cashierName;
  final String dateLabel;
  final String timeLabel;

  const _KasirHeader({
    required this.onBack,
    required this.accent,
    required this.cashierName,
    required this.dateLabel,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff07b073), Color(0xff029a63)],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'SISTEM KASIR (POS)',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text('Kasir: $cashierName', style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.event, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(dateLabel, style: const TextStyle(color: Colors.white70)),
              const SizedBox(width: 12),
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(timeLabel, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}
