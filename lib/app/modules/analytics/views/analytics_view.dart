import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xff06b47c);
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: Obx(() {
          final data = controller.currentData;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                _Header(accent: accent, onBack: Get.back),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: controller.periods.map((p) {
                      final selected = controller.selectedPeriod.value == p;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(p),
                          selected: selected,
                          onSelected: (_) => controller.selectedPeriod.value = p,
                          selectedColor: accent,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                          side: const BorderSide(color: Color(0xffe1e7ef)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BigStatCard(
                          title: 'Obat Masuk',
                          value: data.masukValue,
                          change: data.masukChange,
                          color: const Color(0xff05b77a),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BigStatCard(
                          title: 'Obat Keluar',
                          value: data.keluarValue,
                          change: data.keluarChange,
                          color: const Color(0xff2a7ae4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _MovementCard(points: data.movement),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _TopProductsCard(period: controller.selectedPeriod.value, products: data.topProducts),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.event_busy_outlined,
                          iconColor: const Color(0xffe67d00),
                          title: 'Kadaluarsa ${controller.selectedPeriod.value.contains('Bulan') ? 'Bulan Ini' : controller.selectedPeriod.value}',
                          subtitle: data.expiredCount,
                          note: 'Perlu perhatian',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.medical_services_outlined,
                          iconColor: const Color(0xff9c27b0),
                          title: 'Paling Diresepkan',
                          subtitle: data.topPrescription,
                          note: '850+ resep',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _InsightCard(
                    text:
                        'Penjualan minggu ini meningkat 15% dibanding minggu lalu. Stok Paracetamol perlu direstock segera.',
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: accent,
        unselectedItemColor: Colors.grey,
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
              Get.offAllNamed(Routes.lainnya);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Lainnya'),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Color accent;
  final VoidCallback onBack;
  const _Header({required this.accent, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff06b47c), Color(0xff02a867)],
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
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Laporan & Analitik', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              SizedBox(height: 2),
              Text('Dashboard insight apotek', style: TextStyle(color: Colors.white70)),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final Color color;

  const _BigStatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.white.withValues(alpha: 0.8)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(change, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _MovementCard extends StatelessWidget {
  final List<MovementPoint> points;
  const _MovementCard({required this.points});

  @override
  Widget build(BuildContext context) {
    const masukColor = Color(0xff06b47c);
    const keluarColor = Color(0xff2a7ae4);

    int maxVal = 1;
    for (final p in points) {
      maxVal = [maxVal, p.masuk, p.keluar].reduce((a, b) => a > b ? a : b);
    }
    double ratio(int val) => (val / maxVal).clamp(0.1, 1.0).toDouble();

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Pergerakan Stok', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              Icon(Icons.calendar_today_outlined, color: Colors.black45, size: 18),
            ],
          ),
          const SizedBox(height: 4),
          const Text('7 hari terakhir', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          ...points.map((p) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(width: 40, child: Text(p.label, style: const TextStyle(fontWeight: FontWeight.w700))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width * ratio(p.masuk) * 0.4,
                          decoration: BoxDecoration(
                            color: masukColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width * ratio(p.keluar) * 0.4,
                          decoration: BoxDecoration(
                            color: keluarColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${p.masuk}', style: const TextStyle(color: masukColor)),
                      Text('${p.keluar}', style: const TextStyle(color: keluarColor)),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              _Legend(color: masukColor, label: 'Obat Masuk'),
              SizedBox(width: 16),
              _Legend(color: keluarColor, label: 'Obat Keluar'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 8, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _TopProductsCard extends StatelessWidget {
  final String period;
  final List<TopProduct> products;
  const _TopProductsCard({required this.period, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffe9f9f1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top 5 Obat Paling Sering Keluar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          Text(period, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          ...products.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Text('$idx', style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black87)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text('${item.sold} pcs terjual', style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (item.isPositive ? Colors.green : Colors.red).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.percentText,
                      style: TextStyle(
                        color: item.isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String note;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.note,
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
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(note, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String text;
  const _InsightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffe9f2ff),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffd7e2ff)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.insights, color: Color(0xff2a7ae4)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Insight', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
