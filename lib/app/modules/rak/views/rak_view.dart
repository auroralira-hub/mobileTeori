import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RakView extends StatefulWidget {
  const RakView({super.key});
  @override
  State<RakView> createState() => _RakViewState();
}

class _RakViewState extends State<RakView> {
  int selectedRak = 0;
  int selectedLoker = 0;
  final rakLabels = ['Rak A', 'Rak B', 'Rak C', 'Rak D'];

  final List<List<Map<String, dynamic>>> rackData = [
    List.generate(
      12,
      (i) => {
        'name': [
          'Paracetamol 500 mg',
          'Amoxicillin 500 mg',
          'Ibuprofen 400 mg',
          'Cetirizine 10 mg',
          'OBH Combi Syrup',
          'Vitamin C 1000 mg',
          'Omeprazole 20 mg',
          'Ranitidine 150 mg',
          'Azithromycin 500 mg',
          'Chlorpheniramine 4 mg',
          'Antasida DOEN',
          'Loratadine 10 mg',
        ][i],
        'stock': [450, 320, 280, 320, 150, 210, 180, 140, 90, 60, 130, 170][i],
        'min': [100, 120, 150, 80, 60, 90, 60, 80, 50, 40, 70, 60][i],
        'expiry': [
          '15 Mar 2025',
          '10 Jan 2025',
          '08 Des 2024',
          '28 Jan 2025',
          '05 Jun 2025',
          '22 Feb 2025',
          '18 Apr 2025',
          '12 Mei 2025',
          '30 Des 2024',
          '25 Jan 2025',
          '02 Feb 2025',
          '14 Mar 2025',
        ][i],
      },
    ),
    List.generate(
      12,
      (i) => {
        'name': [
          'Metformin 500 mg',
          'Simvastatin 20 mg',
          'Amlodipine 10 mg',
          'Ciprofloxacin 500 mg',
          'Prednisone 5 mg',
          'Fluconazole 150 mg',
          'Acetylcysteine 600 mg',
          'Mefenamic Acid 500 mg',
          'Clarithromycin 500 mg',
          'Dexamethasone 0.5 mg',
          'Lisinopril 10 mg',
          'Hydroxyzine 25 mg',
        ][i],
        'stock': [110, 95, 160, 125, 70, 90, 140, 105, 80, 65, 120, 150][i],
        'min': [60, 70, 80, 90, 40, 50, 70, 60, 50, 40, 60, 80][i],
        'expiry': [
          '12 Feb 2025',
          '05 Mar 2025',
          '22 Jan 2025',
          '15 Feb 2025',
          '08 Mar 2025',
          '19 Apr 2025',
          '10 Mei 2025',
          '02 Mar 2025',
          '25 Jan 2025',
          '18 Feb 2025',
          '30 Apr 2025',
          '06 Mei 2025',
        ][i],
      },
    ),
    List.generate(
      12,
      (i) => {
        'name': [
          'Warfarin 5 mg',
          'Clopidogrel 75 mg',
          'Allopurinol 300 mg',
          'Sitagliptin 50 mg',
          'Azathioprine 50 mg',
          'Levothyroxine 50 mcg',
          'Bisoprolol 5 mg',
          'Spironolactone 25 mg',
          'Atenolol 50 mg',
          'Diazepam 5 mg',
          'Alprazolam 0.5 mg',
          'Domperidone 10 mg',
        ][i],
        'stock': [90, 130, 140, 70, 55, 200, 180, 95, 125, 60, 75, 165][i],
        'min': [50, 70, 80, 40, 30, 80, 70, 50, 60, 30, 30, 80][i],
        'expiry': [
          '11 Jan 2025',
          '20 Feb 2025',
          '08 Mar 2025',
          '17 Jan 2025',
          '28 Feb 2025',
          '09 Apr 2025',
          '21 Mei 2025',
          '13 Mar 2025',
          '05 Apr 2025',
          '19 Jan 2025',
          '15 Feb 2025',
          '07 Mei 2025',
        ][i],
      },
    ),
    List.generate(
      12,
      (i) => {
        'name': [
          'Salbutamol Inhaler',
          'Budesonide 0.5 mg',
          'Montelukast 10 mg',
          'Cetirizine Syrup',
          'Chlorhexidine 0.2%',
          'Povidone Iodine',
          'Erythromycin 500 mg',
          'Lincomycin 500 mg',
          'Amphotericin B',
          'Cefixime 200 mg',
          'Levofloxacin 500 mg',
          'Oseltamivir 75 mg',
        ][i],
        'stock': [40, 85, 95, 70, 60, 120, 80, 75, 30, 140, 150, 65][i],
        'min': [30, 60, 70, 50, 40, 60, 50, 50, 20, 90, 100, 50][i],
        'expiry': [
          '03 Mar 2025',
          '25 Feb 2025',
          '12 Apr 2025',
          '28 Jan 2025',
          '14 Feb 2025',
          '30 Apr 2025',
          '08 Mar 2025',
          '19 Mar 2025',
          '05 Jan 2025',
          '22 Mei 2025',
          '06 Jun 2025',
          '18 Jan 2025',
        ][i],
      },
    ),
  ];

  Map<String, dynamic> get currentLocker =>
      rackData[selectedRak][selectedLoker];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Rak',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          rakLabels.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _RakTab(
                              label: rakLabels[i],
                              selected: selectedRak == i,
                              onTap: () {
                                setState(() {
                                  selectedRak = i;
                                  selectedLoker = 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Layout Loker - ${rakLabels[selectedRak]}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemCount: 12,
                              itemBuilder: (context, idx) {
                                final isSelected = selectedLoker == idx;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () =>
                                      setState(() => selectedLoker = idx),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green[100]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.teal[100]!,
                                        width: isSelected ? 2 : 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            (idx + 1).toString().padLeft(
                                              2,
                                              '0',
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.green
                                                  : Colors.teal[800],
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Icon(
                                            Icons.inventory_2,
                                            color: isSelected
                                                ? Colors.green
                                                : Colors.teal[400],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _LockerDetail(
                      rackName: rakLabels[selectedRak],
                      lokerNumber: selectedLoker + 1,
                      item: currentLocker,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              Get.offAllNamed('/stok');
              break;
            case 2:
              break;
            case 3:
              Get.offAllNamed('/lainnya');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Rak'),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
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
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Kelola lokasi penyimpanan obat',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _RakTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RakTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LockerDetail extends StatelessWidget {
  final String rackName;
  final int lokerNumber;
  final Map<String, dynamic> item;
  const _LockerDetail({
    required this.rackName,
    required this.lokerNumber,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on, color: Colors.green),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loker ${lokerNumber.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      rackName,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Nama Obat', style: TextStyle(color: Colors.grey[700])),
            Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Stok', style: TextStyle(color: Colors.black54)),
                    Text(
                      '${item['stock']} pcs',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Kadaluarsa',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      item['expiry'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Min. Stok',
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  '${item['min']} pcs',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text('Atur Ulang Obat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
