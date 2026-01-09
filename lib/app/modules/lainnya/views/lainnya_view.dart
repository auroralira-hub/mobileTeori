import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apotek/app/routes/app_pages.dart';
import '../controllers/lainnya_controller.dart';

class LainnyaView extends GetView<LainnyaController> {
  const LainnyaView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.scaffoldBackgroundColor;
    final stats = const [
      _StatData(label: 'Total Obat', value: '248'),
      _StatData(label: 'Perlu Perhatian', value: '12'),
      _StatData(label: 'Rak Aktif', value: '5'),
    ];
    final managementMenus = [
      _MenuData(
        label: 'Resep & Racikan',
        icon: Icons.receipt_long,
        color: const Color(0xffb286ff),
        onTap: () => Get.toNamed(Routes.addEditMedicine),
      ),
      _MenuData(
        label: 'Supplier & PO',
        icon: Icons.store_mall_directory,
        color: const Color(0xff68c4b3),
        onTap: () => Get.toNamed(Routes.supplier),
      ),
      _MenuData(
        label: 'Laporan & Analitik',
        icon: Icons.show_chart,
        color: const Color(0xff5fb0ff),
        onTap: () => Get.toNamed(Routes.analytics),
      ),
      _MenuData(
        label: 'Data Pasien',
        icon: Icons.people_alt,
        color: const Color(0xffa187ff),
        onTap: () => Get.toNamed(Routes.patient),
      ),
      _MenuData(
        label: 'Manajemen Shift',
        icon: Icons.calendar_month,
        color: const Color(0xffffa156),
        onTap: () => Get.toNamed(Routes.shiftManagement),
      ),
      _MenuData(
        label: 'Laporan Harian',
        icon: Icons.description,
        color: const Color(0xff8ac8ff),
        onTap: () => Get.toNamed(Routes.dailyReport),
      ),
    ];
    final settingsMenus = [
      _MenuData(
        label: 'Pengaturan Aplikasi',
        icon: Icons.settings,
        color: Colors.grey[600]!,
        onTap: () => controller.showComingSoon('Pengaturan Aplikasi'),
      ),
      _MenuData(
        label: 'Bantuan & Dukungan',
        icon: Icons.help_outline,
        color: Colors.deepPurple,
        onTap: () => controller.showComingSoon('Bantuan & Dukungan'),
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => _HeaderCard(
                  stats: stats,
                  name: controller.userName.value,
                  roleLabel: controller.roleLabel.value,
                  sipa: controller.sipa.value,
                ),
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Manajemen'),
              ...managementMenus.map((item) => _MenuTile(data: item)),
              const SizedBox(height: 16),
              const _SectionTitle('Pengaturan'),
              ...settingsMenus.map((item) => _MenuTile(data: item)),
              _LogoutButton(onTap: () => Get.offAllNamed(Routes.login)),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Apotek Aafiyah v1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff00a86b),
        onPressed: () => Get.toNamed(Routes.scanBarcode),
        child: const Icon(Icons.qr_code_scanner, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final List<_StatData> stats;
  final String name;
  final String roleLabel;
  final String sipa;
  const _HeaderCard({
    required this.stats,
    required this.name,
    required this.roleLabel,
    required this.sipa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff00a86b), Color(0xff00c48c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.zero,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu Lainnya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xff00a86b),
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      roleLabel,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'SIPA: $sipa',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats
                  .map(
                    (s) => Column(
                      children: [
                        Text(
                          s.value,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.label,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) ??
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MenuData data;
  const _MenuTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: data.color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(data.icon, color: data.color),
        ),
        title: Text(
          data.label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: data.onTap,
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xfffff0f0),
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Keluar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: 3,
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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stok'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
      ],
    );
  }
}

class _StatData {
  final String label;
  final String value;
  const _StatData({required this.label, required this.value});
}

class _MenuData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MenuData({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
