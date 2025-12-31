import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xff06b47c);
    const bg = Color(0xfff4f6f9);

    final stockItems = <_StockItem>[
      const _StockItem(
        name: 'Paracetamol 500mg',
        category: 'Analgesik',
        qtyLabel: '120 strip',
        location: 'A1',
        batch: 'BTH-2024-045',
        expiry: '2025-06-30',
        status: 'Sudah kadaluarsa!',
        statusColor: Color(0xffd64545),
        icon: Icons.inventory_2_outlined,
        iconBg: Color(0xffe9f8f1),
        iconColor: Color(0xff1eb978),
        isExpired: true,
      ),
      const _StockItem(
        name: 'Amoxicillin 500mg',
        category: 'Antibiotik',
        qtyLabel: '15 strip',
        location: 'B2',
        batch: 'BTH-2024-012',
        expiry: '2025-05-10',
        status: 'Sudah kadaluarsa!',
        statusColor: Color(0xffd64545),
        icon: Icons.medical_services_outlined,
        iconBg: Color(0xfffff0f0),
        iconColor: Color(0xffd64545),
        isExpired: true,
      ),
      const _StockItem(
        name: 'Cetirizine 10mg',
        category: 'Antihistamin',
        qtyLabel: '25 strip',
        location: 'C3',
        batch: 'BTH-2024-089',
        expiry: '2025-01-10',
        status: 'Sudah kadaluarsa!',
        statusColor: Color(0xffd64545),
        icon: Icons.category_outlined,
        iconBg: Color(0xfffff8e7),
        iconColor: Color(0xffe6a927),
        isExpired: true,
      ),
    ];

    final lockerNumbers = List<int>.generate(12, (i) => i + 1);

    return Obx(() {
      final userName = controller.userName.value;
      final role = controller.role.value.toLowerCase();
      final isKaryawan = role == 'karyawan';

      Widget body;
      switch (controller.currentTab.value) {
        case 0:
          body = isKaryawan
              ? _KaryawanHomeTab(accent: accent, userName: userName)
              : _ApotekerHomeTab(accent: accent, userName: userName);
          break;
        case 1:
          body = isKaryawan
              ? _StockTab(accent: accent, stockItems: stockItems)
              : _ApotekerShell(
                  userName: userName,
                  child: _StockTab(accent: accent, stockItems: stockItems, withSafeArea: false),
                );
          break;
        case 2:
          body = isKaryawan
              ? _RackTab(accent: accent, lockerNumbers: lockerNumbers)
              : _ApotekerShell(
                  userName: userName,
                  child: _RackTab(accent: accent, lockerNumbers: lockerNumbers, withSafeArea: false),
                );
          break;
        default:
          body = isKaryawan
              ? _ProfileTab(accent: accent, bg: bg, userName: userName, controller: controller)
              : _MoreTab(
                  accent: accent,
                  bg: bg,
                  userName: userName,
                  controller: controller,
                  withSafeArea: true,
                );
      }

      return Scaffold(
        backgroundColor: bg,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.scanBarcode),
          backgroundColor: accent,
          child: const Icon(Icons.fullscreen, color: Colors.white),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentTab.value,
            selectedItemColor: accent,
            unselectedItemColor: Colors.grey,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
              BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
              BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Lainnya'),
            ],
          ),
        ),
        body: body,
      );
    });
  }
}

class _ApotekerShell extends StatelessWidget {
  final String userName;
  final Widget child;

  const _ApotekerShell({required this.userName, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _ApotekerHeader(userName: userName),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ApotekerHeader extends StatelessWidget {
  final String userName;

  const _ApotekerHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff07b073), Color(0xff029a63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selamat Datang', style: TextStyle(color: Colors.white70)),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('Shift Pagi', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.notifikasi),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Remaining sections are defined below.
class _ApotekerHomeTab extends StatelessWidget {
  final Color accent;
  final String userName;

  const _ApotekerHomeTab({required this.accent, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _ApotekerHeader(userName: userName),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 28, top: 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _StatCard(
                      title: 'Total Obat',
                      value: '248 Item',
                      icon: Icons.inventory_2_outlined,
                      accent: accent,
                      trailing: Icons.inventory_outlined,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Get.toNamed(Routes.stockCheck),
                            child: _SmallCard(
                              title: 'Stok Hampir Habis',
                              subtitle: 'Fitur Unggulan',
                              value: '8 Item',
                              icon: Icons.warning_amber_rounded,
                              iconColor: const Color(0xffe6a11d),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Get.toNamed(Routes.stockCheck),
                            child: _SmallCard(
                              title: 'Hampir Kadaluarsa',
                              value: '12 Item',
                              icon: Icons.event_busy_outlined,
                              iconColor: const Color(0xffd64545),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(Routes.posHistory),
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('Riwayat POS'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accent),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          overlayColor: accent.withValues(alpha: 0.16),
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(Routes.antrian),
                        icon: const Icon(Icons.list_alt),
                        label: const Text('Antrian Transaksi'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accent),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          overlayColor: accent.withValues(alpha: 0.16),
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(Routes.analytics),
                        icon: const Icon(Icons.show_chart_outlined),
                        label: const Text('Laporan & Analitik'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accent),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          overlayColor: accent.withValues(alpha: 0.16),
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(Routes.addEditMedicine),
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Tambah Obat Baru'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          overlayColor: accent.withValues(alpha: 0.16),
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(Routes.kasir),
                        icon: const Icon(Icons.point_of_sale),
                        label: const Text('Buka Kasir (POS)'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accent),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          overlayColor: accent.withValues(alpha: 0.16),
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _NotifPanel(accent: accent),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KaryawanHomeTab extends StatelessWidget {
  final Color accent;
  final String userName;

  const _KaryawanHomeTab({required this.accent, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff07b073), Color(0xff029a63)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(26),
                      bottomRight: Radius.circular(26),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Selamat Datang', style: TextStyle(color: Colors.white70)),
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Text('Karyawan', style: TextStyle(color: Colors.white)),
                                  Text('  ·  Shift Pagi', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.notifications_none, color: Colors.white),
                              ),
                              Positioned(
                                right: -1,
                                top: -2,
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffde4242),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white, width: 1.4),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '2',
                                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_active_outlined, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffe84444),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _AlertHeader(),
                        SizedBox(height: 8),
                        _AlertRow(
                          icon: Icons.close,
                          iconColor: Colors.white,
                          label: 'Kadaluwarsa: Ibuprofen 400mg (A3)',
                        ),
                        SizedBox(height: 6),
                        _AlertRow(
                          icon: Icons.circle,
                          iconColor: Color(0xff7ff6b1),
                          label: 'Stok Habis: Amoxicillin 500mg (B2)',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GlassGrid(
                    children: const [
                      _KaryawanTaskCard(
                        title: 'Menunggu Diambil',
                        value: '1',
                        subtitle: 'Tugas baru',
                        icon: Icons.timelapse,
                        color: Color(0xffe6a927),
                        bgColor: Color(0xfffff6e5),
                      ),
                      _KaryawanTaskCard(
                        title: 'Siap Dibayar',
                        value: '1',
                        subtitle: 'Menunggu kasir',
                        icon: Icons.verified_outlined,
                        color: Color(0xff1eb978),
                        bgColor: Color(0xffe9f8f1),
                      ),
                      _KaryawanTaskCard(
                        title: 'Alert Stok',
                        value: '2',
                        subtitle: 'Perlu perhatian',
                        icon: Icons.error_outline,
                        color: Color(0xffd64545),
                        bgColor: Color(0xffffefef),
                      ),
                      _KaryawanTaskCard(
                        title: 'Selesai Hari Ini',
                        value: '12',
                        subtitle: 'Tugas selesai',
                        icon: Icons.widgets_outlined,
                        color: Color(0xff3f7fea),
                        bgColor: Color(0xffeef3ff),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('Kinerja Hari Ini', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        _MetricItem(
                          icon: Icons.check_circle_outline,
                          iconColor: Color(0xff1eb978),
                          label: 'Tugas Diselesaikan',
                          value: '12 transaksi',
                        ),
                        SizedBox(height: 10),
                        _MetricItem(
                          icon: Icons.inventory_2_outlined,
                          iconColor: Color(0xff3f7fea),
                          label: 'Obat Diambil',
                          value: '45 item',
                        ),
                        SizedBox(height: 10),
                        _MetricItem(
                          icon: Icons.update_outlined,
                          iconColor: Color(0xff8f4ee3),
                          label: 'Update Stok',
                          value: '8 update',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long, color: Colors.white),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Lihat Antrian Transaksi',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '1 menunggu',
                            style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xfff2f6ff),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xffd3e1ff)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _MetricHeader(),
                        SizedBox(height: 10),
                        _BulletTaskItem(text: 'Mengambil obat dari rak sesuai transaksi'),
                        _BulletTaskItem(text: 'Menyiapkan racikan obat'),
                        _BulletTaskItem(text: 'Mengelola stok fisik'),
                        _BulletTaskItem(text: 'Update lokasi rak dan kadaluarsa'),
                      ],
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

class _AlertHeader extends StatelessWidget {
  const _AlertHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.warning_amber_rounded, color: Colors.white),
        SizedBox(width: 8),
        Text(
          'ALERT KRITIS!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _AlertRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _AlertRow({required this.icon, required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _KaryawanTaskCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _KaryawanTaskCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 40) / 2,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _MetricItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricHeader extends StatelessWidget {
  const _MetricHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.assignment_turned_in_outlined, color: Color(0xff3f7fea)),
        SizedBox(width: 8),
        Text(
          'Tugas Karyawan:',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _BulletTaskItem extends StatelessWidget {
  final String text;

  const _BulletTaskItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xff3f7fea), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final IconData? trailing;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffe7f7ef),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(trailing ?? icon, color: accent),
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SmallCard({
    required this.title,
    this.subtitle,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(color: Colors.black54, fontSize: 12.5),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifDetailItem extends StatelessWidget {
  final String title;
  final String batch;
  final String date;
  final String countdown;

  const _NotifDetailItem({
    required this.title,
    required this.batch,
    required this.date,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(batch, style: const TextStyle(color: Colors.black54, fontSize: 12.5)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xfffff0f0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xffffc7c7)),
                ),
                child: Text(
                  countdown,
                  style: const TextStyle(color: Color(0xffd64545), fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotifPanel extends StatelessWidget {
  final Color accent;

  const _NotifPanel({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffffefef),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffffd8d8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.event_busy_outlined, color: Color(0xffd64545)),
                  SizedBox(width: 8),
                  Text('Notifikasi Penting', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ],
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.notifikasi),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'Lihat',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _NotifDetailItem(
            title: 'Amoxicillin 500 mg',
            batch: 'Batch: BTH-2024-001',
            date: '15 Jan 2025',
            countdown: '7 hari',
          ),
          const SizedBox(height: 10),
          const _NotifDetailItem(
            title: 'Paracetamol 500 mg',
            batch: 'Batch: BTH-2024-045',
            date: '22 Jan 2025',
            countdown: '14 hari',
          ),
          const SizedBox(height: 10),
          const _NotifDetailItem(
            title: 'Cetirizine 10 mg',
            batch: 'Batch: BTH-2023-089',
            date: '28 Jan 2025',
            countdown: '20 hari',
          ),
        ],
      ),
    );
  }
}

class _StockItem {
  final String name;
  final String category;
  final String qtyLabel;
  final String location;
  final String batch;
  final String expiry;
  final String status;
  final Color statusColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool isExpired;

  const _StockItem({
    required this.name,
    required this.category,
    required this.qtyLabel,
    required this.location,
    required this.batch,
    required this.expiry,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.isExpired = false,
  });
}

class _StockTab extends StatelessWidget {
  final Color accent;
  final List<_StockItem> stockItems;
  final bool withSafeArea;

  const _StockTab({
    required this.accent,
    required this.stockItems,
    this.withSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff05b77a), Color(0xff02a867)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kelola Stok',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 6),
                        Text('Cari obat, kategori, atau lokasi rak...', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Cari obat, kategori, atau lokasi rak...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.16),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.26)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.26)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    _FilterChip(label: 'Semua', count: 5, selected: true),
                    SizedBox(width: 8),
                    _FilterChip(label: 'Aman', count: 1),
                    SizedBox(width: 8),
                    _FilterChip(label: 'Rendah', count: 2),
                  ],
                ),
                const SizedBox(height: 12),
                ...stockItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StockCard(accent: accent, item: item),
                  ),
                ),
                const SizedBox(height: 4),
                const _StockInfoNote(),
              ],
            ),
          ),
        ],
      ),
    );

    return withSafeArea ? SafeArea(child: content) : content;
  }
}

class _GlassGrid extends StatelessWidget {
  final List<Widget> children;
  const _GlassGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 10),
            Expanded(child: children[1]),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: children[2]),
            const SizedBox(width: 10),
            Expanded(child: children[3]),
          ],
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int? count;

  const _FilterChip({required this.label, this.selected = false, this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffe7f7ef) : const Color(0xfff5f7fa),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: selected ? const Color(0xff06b47c) : const Color(0xffe4e9f0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xff06b47c) : Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? Colors.white : const Color(0xffe8ecf2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: selected ? const Color(0xff06b47c) : Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final Color accent;
  final _StockItem item;

  const _StockCard({required this.accent, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: item.iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(item.icon, color: item.iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(item.category, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StockDetailRow(
            icon: Icons.inventory_2_outlined,
            label: 'Stok Tersedia',
            value: item.qtyLabel,
            valueColor: accent,
          ),
          const SizedBox(height: 8),
          _StockDetailRow(
            icon: Icons.location_on_outlined,
            label: 'Lokasi Rak',
            value: item.location,
            valueColor: const Color(0xff1eb978),
          ),
          const SizedBox(height: 8),
          _StockDetailRow(
            icon: Icons.qr_code_2,
            label: 'Batch',
            value: item.batch,
            valueColor: Colors.black87,
          ),
          const SizedBox(height: 8),
          _StockDetailRow(
            icon: Icons.event,
            label: 'Kadaluarsa',
            value: item.expiry,
            valueColor: const Color(0xffd64545),
          ),
          if (item.isExpired) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: item.statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: item.statusColor.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined, color: item.statusColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.status,
                      style: TextStyle(color: item.statusColor, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Tambah Stok', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Color(0xffd9dfe7)),
                  ),
                  child: const Text('Update Lokasi', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StockDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black54)),
        ),
        Text(
          value,
          style: TextStyle(color: valueColor, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _StockInfoNote extends StatelessWidget {
  const _StockInfoNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfff2f6ff),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffd3e1ff)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xff3f7fea)),
              SizedBox(width: 8),
              Text(
                'Tanggung Jawab Stok:',
                style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xff3f7fea)),
              ),
            ],
          ),
          SizedBox(height: 8),
          _BulletTaskItem(text: 'Update stok setelah menerima kiriman supplier'),
          _BulletTaskItem(text: 'Periksa tanggal kadaluarsa secara berkala'),
          _BulletTaskItem(text: 'Update lokasi rak jika ada perubahan'),
          _BulletTaskItem(text: 'Laporkan stok habis atau obat rusak'),
        ],
      ),
    );
  }
}

class _RackTab extends StatelessWidget {
  final Color accent;
  final List<int> lockerNumbers;
  final bool withSafeArea;

  const _RackTab({
    required this.accent,
    required this.lockerNumbers,
    this.withSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    const racks = ['Rak A', 'Rak B', 'Rak C', 'Rak D'];

    final content = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff05b77a), Color(0xff02a867)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Peta Rak Obat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kelola lokasi penyimpanan obat',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 14),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: racks.map((rack) {
                    final selected = rack == 'Rak A';
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _RackChip(label: rack, selected: selected),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Layout Loker - Rak A', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: lockerNumbers.length,
                        itemBuilder: (_, index) {
                          final number = lockerNumbers[index].toString().padLeft(2, '0');
                          return _LockerTile(number: number);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xffe7f7ef),
                        child: Icon(Icons.location_on_outlined, color: Color(0xff06b47c), size: 26),
                      ),
                      SizedBox(height: 10),
                      Text('Pilih Loker', style: TextStyle(fontWeight: FontWeight.w800)),
                      SizedBox(height: 6),
                      Text(
                        'Klik loker untuk melihat detail',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return withSafeArea ? SafeArea(child: content) : content;
  }
}

class _RackChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _RackChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? const Color(0xff06b47c) : const Color(0xfff7f8fb),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: selected ? Colors.transparent : const Color(0xffe4e9f0)),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: const Color(0xff06b47c).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, color: selected ? Colors.white : const Color(0xff3f7fea), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LockerTile extends StatelessWidget {
  final String number;

  const _LockerTile({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffe7f7ef),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff06b47c).withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xff06b47c),
            ),
          ),
          const SizedBox(height: 6),
          const Icon(Icons.inventory_2_outlined, color: Color(0xff06b47c)),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final Color accent;
  final Color bg;
  final String userName;
  final HomeController controller;

  const _ProfileTab({
    required this.accent,
    required this.bg,
    required this.userName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff05b77a), Color(0xff02a867)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Profil',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: accent),
                              color: accent.withValues(alpha: 0.08),
                            ),
                            child: Icon(Icons.add, color: accent, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _SmallBadge(label: 'Karyawan', color: const Color(0xff1eb978), bg: const Color(0xffe9f8f1)),
                                    const SizedBox(width: 8),
                                    _SmallBadge(label: 'Shift Pagi', color: const Color(0xff5c8dff), bg: const Color(0xffe8edff)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const _InfoRow(icon: Icons.person_outline, label: 'Username', value: 'andi.pratama'),
                      const Divider(),
                      const _InfoRow(icon: Icons.email_outlined, label: 'Email', value: 'andi.pratama@apotekcare.com'),
                      const Divider(),
                      const _InfoRow(icon: Icons.phone_outlined, label: 'Telepon', value: '081234567890'),
                      const Divider(),
                      const _InfoRow(icon: Icons.calendar_today_outlined, label: 'Bergabung Sejak', value: '15 Januari 2024'),
                      const Divider(),
                      const _InfoRow(icon: Icons.verified_user_outlined, label: 'Status Akun', value: 'Aktif', valueColor: Color(0xff1eb978)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const _StockInfoNote(),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _RestrictedAccessHeader(),
                      SizedBox(height: 8),
                      _BulletTaskItem(text: 'Tidak ada akses ke sistem pembayaran'),
                      _BulletTaskItem(text: 'Tidak dapat melihat harga dan revenue'),
                      _BulletTaskItem(text: 'Tidak dapat melihat data finansial pasien'),
                      _BulletTaskItem(text: 'Tidak dapat melakukan konsultasi medis'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Informasi Sesi', style: TextStyle(fontWeight: FontWeight.w800)),
                      SizedBox(height: 10),
                      _SessionInfoRow(label: 'Shift Aktif', value: 'Shift Pagi'),
                      SizedBox(height: 6),
                      _SessionInfoRow(label: 'Login sebagai', value: 'Karyawan', valueColor: Color(0xff1eb978)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xfffff4d7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.wb_sunny_outlined, color: Color(0xffd69a00)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Mode Terang',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isLightMode.value,
                          onChanged: controller.toggleLightMode,
                          activeThumbColor: accent,
                          activeTrackColor: accent.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.offAllNamed(Routes.login),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffde4242),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return SafeArea(child: Container(color: bg, child: content));
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _SmallBadge({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xfff5f7fa),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.black54),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w700, color: valueColor ?? Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RestrictedAccessHeader extends StatelessWidget {
  const _RestrictedAccessHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.lock_outline, color: Color(0xffd19026)),
        SizedBox(width: 8),
        Text('Akses Terbatas:', style: TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _SessionInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SessionInfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: valueColor ?? Colors.black87)),
      ],
    );
  }
}

class _MoreTab extends StatelessWidget {
  final Color accent;
  final Color bg;
  final String userName;
  final HomeController controller;
  final bool withSafeArea;

  const _MoreTab({
    required this.accent,
    required this.bg,
    required this.userName,
    required this.controller,
    this.withSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff05b77a), Color(0xff02a867)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu Lainnya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.verified_outlined, color: Colors.white, size: 34),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Apoteker Penanggung Jawab',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _StatNumber(label: 'Total Obat', value: '248'),
                      _StatNumber(label: 'Perlu Perhatian', value: '12'),
                      _StatNumber(label: 'Rak Aktif', value: '5'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manajemen',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 12),
                const _MenuItem(
                  icon: Icons.local_shipping_outlined,
                  title: 'Supplier & PO',
                  bgColor: Color(0xffe7f7ef),
                  iconColor: Color(0xff06b47c),
                ),
                const SizedBox(height: 10),
                const _MenuItem(
                  icon: Icons.show_chart_outlined,
                  title: 'Laporan & Analitik',
                  bgColor: Color(0xffe7f0ff),
                  iconColor: Color(0xff2f6fea),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Pengaturan',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xfffff4d7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.wb_sunny_outlined, color: Color(0xffd69a00)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Mode Terang',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isLightMode.value,
                          onChanged: controller.toggleLightMode,
                          activeThumbColor: accent,
                          activeTrackColor: accent.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.offAllNamed(Routes.login),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xffe07b7b)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout, color: Color(0xffd64545)),
                    label: const Text(
                      'Keluar',
                      style: TextStyle(color: Color(0xffd64545), fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'ApotekCare v1.0.0',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final wrapped = Container(color: bg, child: content);
    return withSafeArea ? SafeArea(child: wrapped) : wrapped;
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color bgColor;
  final Color iconColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black45),
        ],
      ),
    );
  }
}

class _StatNumber extends StatelessWidget {
  final String label;
  final String value;

  const _StatNumber({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
