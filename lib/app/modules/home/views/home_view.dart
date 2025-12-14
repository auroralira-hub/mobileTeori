import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../notifikasi/views/notifikasi_view.dart';

PageRouteBuilder notifRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => const NotifikasiView(),
    transitionsBuilder: (context, animation, secondary, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xfff6f8fb);
    final screenWidth = MediaQuery.of(context).size.width;
    final statHalfWidth =
        (screenWidth - 16 * 2 - 12) / 2; // two cards with 12px gap
    final featureWidth =
        (screenWidth - 16 * 2 - 12 * 2) / 3; // three cards with 12px gaps
    final quickWidth =
        (screenWidth - 16 * 2 - 12) / 2; // two cards with 12px gap

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.green[500],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _HeaderCard(),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatCard(
                            width: double.infinity,
                            title: 'Total Obat',
                            value: '248 Item',
                            icon: Icons.inventory_2_outlined,
                            iconColor: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _StatCard(
                                width: statHalfWidth,
                                title: 'Stok Hampir Habis',
                                value: '8 Item',
                                icon: Icons.warning_amber_rounded,
                                iconColor: Colors.orange,
                              ),
                              _StatCard(
                                width: statHalfWidth,
                                title: 'Hampir Kadaluarsa',
                                value: '12 Item',
                                icon: Icons.calendar_month_rounded,
                                iconColor: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'Fitur Unggulan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _FeatureCard(
                            icon: Icons.bar_chart_rounded,
                            label: 'Laporan',
                            width: featureWidth,
                            color: Colors.blue[100]!,
                            iconColor: Colors.blue[500]!,
                            onTap: () => Get.toNamed('/analytics'),
                          ),
                          _FeatureCard(
                            icon: Icons.shopping_bag_rounded,
                            label: 'Order Supplier',
                            width: featureWidth,
                            color: Colors.orange[100]!,
                            iconColor: Colors.orange[600]!,
                            onTap: () => Get.toNamed('/purchase-order'),
                          ),
                          _FeatureCard(
                            icon: Icons.fact_check_rounded,
                            label: 'Cek Stok',
                            width: featureWidth,
                            color: Colors.green[100]!,
                            iconColor: Colors.green[500]!,
                            onTap: () => Get.toNamed('/stock-check'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Notifikasi Penting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(notifRoute()),
                            child: Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _NotificationCard(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'Aksi Cepat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _FeatureCard(
                            icon: Icons.inventory_rounded,
                            label: 'Cek Stok',
                            width: quickWidth,
                            color: Colors.blue[50]!,
                            iconColor: Colors.blue[500]!,
                            onTap: () => Get.toNamed('/stock-check'),
                          ),
                          _FeatureCard(
                            icon: Icons.description_rounded,
                            label: 'Laporan Harian',
                            width: quickWidth,
                            color: Colors.purple[50]!,
                            iconColor: Colors.purple[500]!,
                            onTap: () => Get.toNamed('/daily-report'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Get.offAllNamed('/stok');
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
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[500],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.local_pharmacy,
                color: Colors.green[500],
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Apoteker',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    'dr. Sarah Wijaya',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.of(context).push(notifRoute()),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green[700],
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final double width;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: iconColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.width,
    required this.color,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _NotifItemData(
        name: 'Amoxicillin 500 mg',
        batch: 'BTH-2024-001',
        date: '15 Jan 2025',
        days: '7 hari',
      ),
      _NotifItemData(
        name: 'Paracetamol 500 mg',
        batch: 'BTH-2024-045',
        date: '22 Jan 2025',
        days: '14 hari',
      ),
      _NotifItemData(
        name: 'Cetirizine 10 mg',
        batch: 'BTH-2023-089',
        date: '28 Jan 2025',
        days: '20 hari',
      ),
    ];
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Obat Akan Kadaluarsa (30 Hari)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...items.map((e) => _NotifItem(item: e)),
          ],
        ),
      ),
    );
  }
}

class _NotifItemData {
  final String name;
  final String batch;
  final String date;
  final String days;
  _NotifItemData({
    required this.name,
    required this.batch,
    required this.date,
    required this.days,
  });
}

class _NotifItem extends StatelessWidget {
  final _NotifItemData item;
  const _NotifItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Batch: ${item.batch}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(item.date, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.days,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
