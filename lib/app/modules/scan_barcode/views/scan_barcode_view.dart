import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apotek/app/core/lang.dart';
import 'package:apotek/app/routes/app_pages.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/scan_barcode_controller.dart';

class ScanBarcodeView extends GetView<ScanBarcodeController> {
  const ScanBarcodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xff040f25);
    final cardColor = const Color(0xff0b1c34);
    final accent = const Color(0xff00c07b);
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Scan Barcode Obat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Arahkan kamera ke barcode obat atau masukkan kode manual',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              _ScannerCard(cardColor: cardColor, accent: accent),
              const SizedBox(height: 24),
              _ManualInputCard(
                controller: controller.manualCodeController,
                onSearch: controller.searchManual,
                cardColor: cardColor,
              ),
              const SizedBox(height: 16),
              _TipsCard(cardColor: cardColor),
              const SizedBox(height: 16),
              _RegisteredList(
                cardColor: cardColor,
                items: controller.recentBarcodes,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accent,
        onPressed: controller.startScan,
        child: const Icon(Icons.qr_code_scanner, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _ManualInputCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final Color cardColor;
  const _ManualInputCard({
    required this.controller,
    required this.onSearch,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Input Manual',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Masukkan kode barcode (contoh: 8992761...)',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xff14253d),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xff00c07b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: onSearch,
              child: const Text(
                'Cari Obat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerCard extends StatelessWidget {
  final Color cardColor;
  final Color accent;
  const _ScannerCard({required this.cardColor, required this.accent});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScanBarcodeController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 260,
              width: double.infinity,
              child: MobileScanner(
                controller: controller.scannerController,
                onDetect: (capture) {
                  final code = capture.barcodes.firstOrNull?.rawValue;
                  if (code != null && code.isNotEmpty) {
                    controller.lastCode.value = code;
                    Get.snackbar(
                      'Barcode Terdeteksi',
                      code,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.startScan,
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Mulai Scan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => controller.scannerController.toggleTorch(),
                icon: const Icon(Icons.flash_on, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Obx(
            () => controller.lastCode.value.isNotEmpty
                ? Text(
                    'Terakhir: ${controller.lastCode.value}',
                    style: const TextStyle(color: Colors.white70),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final Color cardColor;
  const _TipsCard({required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Pastikan barcode dalam kondisi baik dan terbaca.',
      'Gunakan pencahayaan yang cukup.',
      'Jaga jarak 10-20 cm dari kamera.',
      'Bisa upload foto barcode jika scan gagal.',
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb, color: Colors.amber, size: 20),
              SizedBox(width: 6),
              Text(
                'Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.white70)),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisteredList extends StatelessWidget {
  final List<String> items;
  final Color cardColor;
  const _RegisteredList({required this.items, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Barcode Terdaftar (Demo)',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) {
              final parts = item.split('|');
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xff101f35),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parts.first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      parts.last,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: 2,
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
          case 3:
            Get.offAllNamed(Routes.home, arguments: {'tab': 3});
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: Lang.navHome()),
        BottomNavigationBarItem(icon: const Icon(Icons.inventory_2), label: Lang.navStock()),
        BottomNavigationBarItem(icon: const Icon(Icons.grid_view), label: Lang.navRack()),
        BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: Lang.navProfile()),
      ],
    );
  }
}
