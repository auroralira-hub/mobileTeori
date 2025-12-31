import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';

class PatientListView extends GetView<PatientController> {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pasien')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau kontak pasien',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: controller.searchPatient,
            ),
          ),
          Expanded(
            child: Obx(() => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.filteredPatients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final p = controller.filteredPatients[idx];
                return PatientCard(
                  patient: p,
                  onTap: () => controller.goToDetail(p),
                );
              },
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addPatient,
        backgroundColor: Colors.green,
        tooltip: 'Tambah Pasien',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTap;
  const PatientCard({super.key, required this.patient, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Text(patient.name[0]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Umur: ${patient.age}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    Text(patient.contact, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Column(
                children: [
                  const Icon(Icons.receipt_long, color: Colors.blue),
                  Text('${patient.resepCount} Resep', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
