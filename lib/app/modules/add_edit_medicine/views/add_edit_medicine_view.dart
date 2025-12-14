import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_edit_medicine_controller.dart';

class AddEditMedicineView extends GetView<AddEditMedicineController> {
  const AddEditMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.isEdit.value ? 'Edit Obat' : 'Tambah Obat')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.namaController,
                decoration: const InputDecoration(labelText: 'Nama Obat *'),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.kodeController,
                decoration: const InputDecoration(labelText: 'Kode Obat (Auto)'),
                enabled: false,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: controller.bentuk.value.isEmpty ? null : controller.bentuk.value,
                decoration: const InputDecoration(labelText: 'Bentuk'),
                items: controller.bentukList
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (v) => controller.bentuk.value = v ?? '',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: controller.kategori.value.isEmpty ? null : controller.kategori.value,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: controller.kategoriList
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => controller.kategori.value = v ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.manufacturerController,
                decoration: const InputDecoration(labelText: 'Manufacturer'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.stokAwalController,
                decoration: const InputDecoration(labelText: 'Stok Awal'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.minStokController,
                decoration: const InputDecoration(labelText: 'Min Stok'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.hargaBeliController,
                      decoration: const InputDecoration(labelText: 'Harga Beli'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: controller.hargaJualController,
                      decoration: const InputDecoration(labelText: 'Harga Jual'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: controller.pickTanggalKadaluarsa,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Tanggal Kadaluarsa'),
                  child: Obx(() => Text(
                    controller.tanggalKadaluarsa.value == null
                        ? '-'
                        : controller.tanggalKadaluarsa.value!.toString().split(' ')[0],
                  )),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: controller.lokasiRak.value.isEmpty ? null : controller.lokasiRak.value,
                decoration: const InputDecoration(labelText: 'Lokasi Rak'),
                items: controller.lokasiRakList
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => controller.lokasiRak.value = v ?? '',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.save,
                      child: const Text('Simpan'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Batal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
