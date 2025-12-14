import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineDetailView extends StatelessWidget {
  const MedicineDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Detail Obat', style: TextStyle(color: Colors.white)),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Header Info
            Container(
              width: double.infinity,
              color: Colors.green[50],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Paracetamol 500 mg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 4),
                  Text('Tablet · Analgesik', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(height: 2),
                  Text('Kimia Farma', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            // Tabs
            const TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: 'Info Obat'),
                Tab(text: 'Batch & Lokasi'),
                Tab(text: 'Riwayat'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Info Obat
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Stok: 450 pcs'),
                        Text('Min Stok: 50 pcs'),
                        Text('Status: Aman'),
                        Text('Kode: OBT-001'),
                        Text('Harga: Rp 2.000'),
                      ],
                    ),
                  ),
                  // Batch & Lokasi
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Batch', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _BatchItem(batch: 'BTH-2024-001', expiry: '15 Mar 2025', qty: 200, location: 'Rak A – Loker 01'),
                        _BatchItem(batch: 'BTH-2024-002', expiry: '20 Jun 2025', qty: 250, location: 'Rak A – Loker 01'),
                      ],
                    ),
                  ),
                  // Riwayat
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Riwayat Aktivitas', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _LogItem(date: '01 Des 2025', desc: 'Stok masuk 100 pcs'),
                        _LogItem(date: '15 Nov 2025', desc: 'Stok keluar 50 pcs'),
                        _LogItem(date: '10 Nov 2025', desc: 'Penyesuaian +10 pcs'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BatchItem extends StatelessWidget {
  final String batch, expiry, location;
  final int qty;
  const _BatchItem({required this.batch, required this.expiry, required this.qty, required this.location});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(batch),
        subtitle: Text('Kadaluarsa: $expiry\nLokasi: $location'),
        trailing: Text('$qty pcs'),
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final String date, desc;
  const _LogItem({required this.date, required this.desc});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.history, color: Colors.green[400]),
      title: Text(desc),
      subtitle: Text(date),
    );
  }
}
