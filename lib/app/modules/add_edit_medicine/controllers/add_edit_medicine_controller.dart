import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditMedicineController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final kodeController = TextEditingController();
  final manufacturerController = TextEditingController();
  final stokAwalController = TextEditingController();
  final minStokController = TextEditingController();
  final hargaBeliController = TextEditingController();
  final hargaJualController = TextEditingController();

  final bentukList = ['Tablet', 'Kapsul', 'Sirup', 'Salep', 'Drops', 'Lainnya'];
  final kategoriList = ['Analgesik', 'Antibiotik', 'Vitamin', 'Antipiretik', 'Lainnya'];
  final lokasiRakList = ['Rak A', 'Rak B', 'Rak C', 'Rak D'];

  final bentuk = ''.obs;
  final kategori = ''.obs;
  final lokasiRak = ''.obs;
  final tanggalKadaluarsa = Rxn<DateTime>();
  final isEdit = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-generate kode obat (dummy)
    kodeController.text = 'OBT${DateTime.now().millisecondsSinceEpoch % 100000}';
  }

  void pickTanggalKadaluarsa() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      tanggalKadaluarsa.value = picked;
    }
  }

  void save() {
    if (formKey.currentState?.validate() ?? false) {
      // Simpan data (dummy, bisa dihubungkan ke stok list)
      Get.back();
      Get.snackbar('Sukses', isEdit.value ? 'Obat berhasil diubah' : 'Obat berhasil ditambahkan', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
