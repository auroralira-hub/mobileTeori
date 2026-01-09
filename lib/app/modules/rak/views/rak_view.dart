import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/lang.dart';
import '../../../routes/app_pages.dart';

class RakView extends StatefulWidget {
  const RakView({super.key});
  @override
  State<RakView> createState() => _RakViewState();
}

class _RakViewState extends State<RakView> {
  int selectedRak = 0;
  int selectedLoker = 0;
  final rakLabels = ['Rak A', 'Rak B', 'Rak C', 'Rak D'];
  final SupabaseClient _client = Supabase.instance.client;
  late List<List<Map<String, dynamic>>> rackData;
  bool isLoading = true;
  String? loadError;

  Map<String, dynamic> get currentLocker => rackData[selectedRak][selectedLoker];

  @override
  void initState() {
    super.initState();
    rackData = List.generate(4, (_) => List.generate(12, (_) => _emptyItem()));
    _fetchRackData();
  }

  Map<String, dynamic> _emptyItem() {
    return {
      'id': null,
      'name': 'Kosong',
      'stock': 0,
      'min': 0,
      'expiry': '-',
    };
  }

  void _fetchRackData() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });
    try {
      final data = await _client.from('medicines').select('id, name, rack_code, stock, expiry_date');
      final next = List.generate(4, (_) => List.generate(12, (_) => _emptyItem()));
      for (final row in (data as List)) {
        final rackCode = (row['rack_code'] ?? '').toString().trim().toUpperCase();
        if (rackCode.isEmpty) {
          continue;
        }
        final parsed = _parseRackCode(rackCode);
        if (parsed == null) {
          continue;
        }
        final name = (row['name'] ?? 'Kosong').toString();
        final stock = row['stock'] is int ? row['stock'] as int : int.tryParse('${row['stock']}') ?? 0;
        final expiryRaw = row['expiry_date'];
        final expiry = _formatExpiry(expiryRaw);
        next[parsed.item1][parsed.item2] = {
          'id': row['id'],
          'name': name,
          'stock': stock,
          'min': 0,
          'expiry': expiry,
        };
      }
      setState(() {
        rackData = next;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        loadError = error.toString();
        isLoading = false;
      });
    }
  }

  _RackSlot? _parseRackCode(String rackCode) {
    if (rackCode.isEmpty) return null;
    final letter = rackCode.substring(0, 1);
    final numberPart = rackCode.substring(1);
    final rackIndex = ['A', 'B', 'C', 'D'].indexOf(letter);
    final slotNumber = int.tryParse(numberPart) ?? 0;
    if (rackIndex < 0 || slotNumber < 1 || slotNumber > 12) {
      return null;
    }
    return _RackSlot(rackIndex, slotNumber - 1);
  }

  String _formatExpiry(Object? raw) {
    if (raw == null) return '-';
    if (raw is DateTime) {
      return raw.toIso8601String().split('T').first;
    }
    final text = raw.toString();
    if (text.contains('T')) {
      return text.split('T').first;
    }
    return text;
  }

  Future<void> _updateExpiryDate() async {
    final item = currentLocker;
    final id = item['id'] as String?;
    if (id == null) {
      Get.snackbar('Tidak bisa diubah', 'Loker ini kosong.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    try {
      final dateValue = picked.toIso8601String().split('T').first;
      await _client.from('medicines').update({'expiry_date': dateValue}).eq('id', id);
      setState(() {
        rackData[selectedRak][selectedLoker] = {
          ...item,
          'expiry': dateValue,
        };
      });
      Get.snackbar('Sukses', 'Tanggal kadaluarsa diperbarui.', snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.snackbar('Gagal', error.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

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
                            if (isLoading)
                              const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
                            else if (loadError != null)
                              Text(loadError!, style: const TextStyle(color: Colors.red))
                            else
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
                      onUpdateExpiry: _updateExpiryDate,
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
              Get.offAllNamed(Routes.home);
              break;
            case 1:
              Get.offAllNamed(Routes.stok);
              break;
            case 2:
              break;
            case 3:
              Get.offAllNamed(Routes.home, arguments: {'tab': 3});
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: Lang.navHome()),
          BottomNavigationBarItem(icon: const Icon(Icons.inventory_2), label: Lang.navStock()),
          BottomNavigationBarItem(icon: const Icon(Icons.grid_view), label: Lang.navRack()),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: Lang.navProfile(),
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
  final VoidCallback onUpdateExpiry;
  const _LockerDetail({
    required this.rackName,
    required this.lokerNumber,
    required this.item,
    required this.onUpdateExpiry,
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
                onPressed: onUpdateExpiry,
                child: const Text('Ubah Kadaluarsa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RackSlot {
  final int item1;
  final int item2;
  const _RackSlot(this.item1, this.item2);
}
