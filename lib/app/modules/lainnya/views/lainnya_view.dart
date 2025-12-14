import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lainnya_controller.dart';

class LainnyaView extends GetView<LainnyaController> {
  const LainnyaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Apoteker
                Card(
                  color: Colors.green[400],
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.local_pharmacy, color: Colors.green, size: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('dr. Sarah Wijaya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Apoteker Penanggung Jawab', style: TextStyle(color: Colors.white)),
                              Text('SIPA: 503/APT/2020', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _InfoItem(label: 'Total Obat', value: '248'),
                        _InfoItem(label: 'Perlu Perhatian', value: '12'),
                        _InfoItem(label: 'Rak Aktif', value: '5'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Manajemen
                const Text('Menu Lainnya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _MenuButton(
                  icon: Icons.local_shipping,
                  label: 'Supplier & PO',
                  onTap: () => Get.toNamed('/supplier'),
                ),
                _MenuButton(
                  icon: Icons.bar_chart,
                  label: 'Laporan & Analytics',
                  color: Colors.blue,
                  onTap: () => Get.toNamed('/analytics'),
                ),
                _MenuButton(
                  icon: Icons.people,
                  label: 'Data Pasien',
                  color: Colors.purple,
                  onTap: () => Get.toNamed('/patient'),
                ),
                _MenuButton(
                  icon: Icons.schedule,
                  label: 'Manajemen Shift',
                  color: Colors.orange,
                  onTap: () => Get.toNamed('/shift-management'),
                ),
                _MenuButton(
                  icon: Icons.qr_code_scanner,
                  label: 'Cek Stok Real-time',
                  color: Colors.teal,
                  onTap: () => Get.toNamed('/stock-check'),
                ),
                _MenuButton(
                  icon: Icons.today,
                  label: 'Laporan Harian',
                  color: Colors.indigo,
                  onTap: () => Get.toNamed('/daily-report'),
                ),
                const SizedBox(height: 16),
                // Pengaturan
                const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _MenuButton(icon: Icons.settings, label: 'Pengaturan Aplikasi'),
                _MenuButton(icon: Icons.help, label: 'Bantuan & Dukungan', color: Colors.blue),
                const SizedBox(height: 16),
                // Tampilan
                const Text('Tampilan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Text('Mode Terang'),
                    Spacer(),
                    Switch(value: false, onChanged: (v) {}),
                  ],
                ),
                const SizedBox(height: 16),
                // Keluar
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () {},
                    child: const Text('Keluar'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(child: Text('ApotekCare v1.0.0', style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 4,
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

class _InfoItem extends StatelessWidget {
  final String label, value;
  const _InfoItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  const _MenuButton({required this.icon, required this.label, this.color, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.green),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
