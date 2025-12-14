import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';

class PatientDetailView extends StatelessWidget {
  const PatientDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Patient patient = Get.arguments as Patient;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(patient.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Info Pasien'),
              Tab(text: 'Riwayat Resep'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Info Pasien
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${patient.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Umur: ${patient.age}'),
                  Text('Kontak: ${patient.contact}'),
                  Text('Alamat: ${patient.address}'),
                ],
              ),
            ),
            // Riwayat Resep
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: patient.prescriptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final r = patient.prescriptions[idx];
                return Card(
                  child: ListTile(
                    title: Text('Tanggal: ${r.date}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dokter: ${r.doctor}'),
                        Text('Obat: ${r.items.join(', ')}'),
                        Text('Total: Rp${r.total}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Delete'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Resep Baru'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
