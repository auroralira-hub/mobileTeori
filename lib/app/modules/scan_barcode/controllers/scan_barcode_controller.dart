import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBarcodeController extends GetxController {
  final manualCodeController = TextEditingController();
  final recentBarcodes = <String>[
    'Paracetamol 500mg|8992761111111',
    'Amoxicillin 500mg|8992762222222',
    'Omeprazole 20mg|8990763333333',
  ];
  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  final lastCode = ''.obs;

  void startScan() {
    scannerController.start();
  }

  void searchManual() {
    final code = manualCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar(
        'Masukkan Kode',
        'Mohon isi kode barcode terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar(
      'Cari Obat',
      'Mencari barcode $code ...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    manualCodeController.dispose();
    scannerController.dispose();
    super.onClose();
  }
}
