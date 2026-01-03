import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            _KasirHeader(onBack: Get.back, accent: accent),
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
                              onChanged: controller.onSearchChanged,
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
                      onPressed: () {},
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
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Keranjang kosong',
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Scan barcode untuk menambah produk',
                      style: TextStyle(color: Colors.black45),
                    ),
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

class _KasirHeader extends StatelessWidget {
  final VoidCallback onBack;
  final Color accent;

  const _KasirHeader({required this.onBack, required this.accent});

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
            children: const [
              Icon(Icons.person, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text('Kasir: Apt. Budi Santoso, S.Farm', style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.event, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text('Minggu, 28 Desember 2025', style: TextStyle(color: Colors.white70)),
              SizedBox(width: 12),
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text('06.03.18', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}
