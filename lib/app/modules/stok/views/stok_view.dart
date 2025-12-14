import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stok_controller.dart';

class StokView extends GetView<StokController> {
  const StokView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-edit-medicine'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Obat',
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daftar Stok Obat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama, kode, kategori, atau manufacturer',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        _FilterChip(label: 'Semua (48)', selected: true),
                        _FilterChip(label: 'Stok menipis'),
                        _FilterChip(label: 'Hampir kadaluarsa'),
                        _FilterChip(label: 'Generik (24)'),
                        _FilterChip(label: 'Paten (24)'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _MedicineCard(
                    name: 'Paracetamol 500 mg',
                    form: 'Tablet',
                    code: 'OBT-001',
                    stock: 450,
                    stockStatus: 'safe',
                    expiry: '15 Mar 2025',
                    location: 'Rak A – Loker 01',
                  ),
                  _MedicineCard(
                    name: 'Amoxicillin 500 mg',
                    form: 'Kapsul',
                    code: 'OBT-002',
                    stock: 85,
                    stockStatus: 'low',
                    expiry: '10 Jan 2025',
                    location: 'Rak B – Loker 01',
                  ),
                  _MedicineCard(
                    name: 'Cetirizine 10 mg',
                    form: 'Tablet',
                    code: 'OBT-003',
                    stock: 320,
                    stockStatus: 'safe',
                    expiry: '28 Jan 2025',
                    location: 'Rak A – Loker 03',
                  ),
                  _MedicineCard(
                    name: 'OBH Combi Syrup',
                    form: 'Sirup',
                    code: 'OBT-004',
                    stock: 25,
                    stockStatus: 'critical',
                    expiry: '05 Jun 2025',
                    location: 'Rak C – Loker 02',
                  ),
                  _MedicineCard(
                    name: 'Omeprazole 20 mg',
                    form: 'Kapsul',
                    code: 'OBT-005',
                    stock: 180,
                    stockStatus: 'safe',
                    expiry: '20 Apr 2025',
                    location: 'Rak C – Loker 02',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              // Sudah di Stok
              break;
            case 2:
              Get.offAllNamed('/rak');
              break;
            case 3:
              Get.offAllNamed('/notifikasi');
              break;
            case 4:
              Get.offAllNamed('/lainnya');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Lainnya'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.green[100],
      ),
    );
  }
}


class _MedicineCard extends StatelessWidget {
  final String name, form, code, expiry, location, stockStatus;
  final int stock;
  const _MedicineCard({required this.name, required this.form, required this.code, required this.stock, required this.stockStatus, required this.expiry, required this.location});
  Color getStatusColor() {
    switch (stockStatus) {
      case 'safe':
        return Colors.green;
      case 'low':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  String getStatusLabel() {
    switch (stockStatus) {
      case 'safe':
        return 'Aman';
      case 'low':
        return 'Menipis';
      case 'critical':
        return 'Hampir Habis';
      default:
        return '-';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(form, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Kode: $code', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(getStatusLabel(), style: TextStyle(color: getStatusColor(), fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Text('Stok: $stock', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(expiry, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigasi ke Medicine Detail
        },
      ),
    );
  }
}
