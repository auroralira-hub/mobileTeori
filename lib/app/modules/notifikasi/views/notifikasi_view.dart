import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/notifikasi_controller.dart';

class NotifikasiView extends GetView<NotifikasiController> {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    final kadaluarsaItems = [
      {
        'name': 'Amoxicillin 500 mg',
        'batch': 'BTH-2024-001',
        'expired': '10 Jan 2025',
        'stock': 85,
        'days': 2,
      },
      {
        'name': 'Paracetamol 500 mg',
        'batch': 'BTH-2023-089',
        'expired': '15 Jan 2025',
        'stock': 100,
        'days': 7,
      },
      {
        'name': 'Cetirizine 10 mg',
        'batch': 'BTH-2024-012',
        'expired': '28 Jan 2025',
        'stock': 120,
        'days': 20,
      },
      {
        'name': 'Omeprazole 20 mg',
        'batch': 'BTH-2024-023',
        'expired': '05 Feb 2025',
        'stock': 90,
        'days': 28,
      },
    ];

    final menipisItems = [
      {
        'name': 'OBH Combi Syrup',
        'stock': 25,
        'min': 30,
        'location': 'Rak C - Loker 08',
      },
      {
        'name': 'Vitamin C 500 mg',
        'stock': 45,
        'min': 80,
        'location': 'Rak A - Loker 12',
      },
      {
        'name': 'Salbutamol Inhaler',
        'stock': 12,
        'min': 20,
        'location': 'Rak B - Loker 05',
      },
      {
        'name': 'Betadine Solution',
        'stock': 30,
        'min': 50,
        'location': 'Rak D - Loker 09',
      },
      {
        'name': 'Alcohol 70%',
        'stock': 55,
        'min': 100,
        'location': 'Rak D - Loker 10',
      },
    ];

    final content = Obx(() {
      final isKadaluarsa = controller.tabIndex.value == 1;
      return Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isKadaluarsa
                ? _KadaluarsaSection(items: kadaluarsaItems)
                : _MenipisSection(items: menipisItems),
          ),
          const SizedBox(height: 24),
        ],
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onBack: () => Get.back(),
              filterTabs: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        label: 'Kadaluarsa',
                        icon: Icons.calendar_month,
                        selected: controller.tabIndex.value == 1,
                        onTap: () => controller.setTab(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TabButton(
                        label: 'Stok Menipis',
                        icon: Icons.inventory_2,
                        selected: controller.tabIndex.value == 2,
                        onTap: () => controller.setTab(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: content,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff00a86b),
        onPressed: () => Get.toNamed(Routes.scanBarcode),
        child: const Icon(Icons.qr_code_scanner, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff06b47c),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
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
          default:
            Get.offAllNamed(Routes.home, arguments: {'tab': 3});
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
      ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final Widget filterTabs;
  const _Header({required this.onBack, required this.filterTabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onBack,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              label: const Text('Kembali'),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Notifikasi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pantau obat yang perlu perhatian',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: filterTabs,
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff00a86b) : const Color(0xfff3f6fb),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.grey[700]),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KadaluarsaSection extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _KadaluarsaSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _SummaryBanner(
            color: Colors.red,
            title: 'Total: ${items.length} Obat',
            subtitle: 'Akan kadaluarsa dalam 30 hari',
            icon: Icons.inventory_2,
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => _ExpiredCard(
              name: item['name'],
              batch: item['batch'],
              expired: item['expired'],
              stock: item['stock'],
              days: item['days'],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenipisSection extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _MenipisSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _SummaryBanner(
            color: Colors.orange,
            title: 'Total: ${items.length} Obat',
            subtitle: 'Stok di bawah batas minimum',
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => _LowStockCard(
              name: item['name'],
              stock: item['stock'],
              min: item['min'],
              location: item['location'],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;
  const _SummaryBanner({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiredCard extends StatelessWidget {
  final String name;
  final String batch;
  final String expired;
  final int stock;
  final int days;
  const _ExpiredCard({
    required this.name,
    required this.batch,
    required this.expired,
    required this.stock,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Batch: $batch'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$days hari',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Tanggal Kadaluarsa',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text('Sisa Stok', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expired,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$stock pcs',
                    style: const TextStyle(fontWeight: FontWeight.w600),
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

class _LowStockCard extends StatelessWidget {
  final String name;
  final int stock;
  final int min;
  final String location;
  const _LowStockCard({
    required this.name,
    required this.stock,
    required this.min,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Stok Saat Ini'),
                      Text(
                        '$stock pcs',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Min. Stok'),
                      Text(
                        '$min pcs',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Lokasi: $location'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00a86b),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart_checkout),
                  label: const Text('Buat Order Pembelian'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
