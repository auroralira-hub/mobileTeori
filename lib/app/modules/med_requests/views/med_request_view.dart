import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/med_request_controller.dart';

class MedRequestView extends GetView<MedRequestController> {
  const MedRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xff06b47c);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Obat'),
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Obx(
            () => controller.isApoteker
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Buat Permintaan', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Obx(
                          () => controller.isLoadingMeds.value
                              ? const LinearProgressIndicator()
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 6),
                        RawAutocomplete<MedicineItem>(
                          textEditingController: controller.itemController,
                          focusNode: controller.medicineFocus,
                          displayStringForOption: (item) => item.name,
                          optionsBuilder: (TextEditingValue value) {
                            final query = value.text.trim().toLowerCase();
                            if (query.isEmpty) {
                              return controller.medicines;
                            }
                            return controller.medicines.where(
                              (item) =>
                                  item.name.toLowerCase().contains(query) ||
                                  (item.rackCode ?? '').toLowerCase().contains(query),
                            );
                          },
                          onSelected: (item) {
                            controller.selectedMedicine.value = item;
                          },
                          fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
                            return TextField(
                              controller: textController,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                labelText: 'Nama Obat / Rak',
                                border: OutlineInputBorder(),
                              ),
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            final items = options.toList();
                            if (items.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  height: 240,
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return ListTile(
                                        title: Text(item.name),
                                        subtitle: Text('Rak ${item.rackCode ?? '-'} • Stok ${item.stock}'),
                                        onTap: () => onSelected(item),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controller.qtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Jumlah',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () {
                            final selected = controller.selectedMedicine.value;
                            if (selected == null) return const SizedBox.shrink();
                            return Text(
                              'Stok tersedia: ${selected.stock}',
                              style: const TextStyle(color: Colors.black54),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controller.noteController,
                          decoration: const InputDecoration(
                            labelText: 'Catatan (opsional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.createRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.send),
                            label: const Text('Kirim ke Karyawan'),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.requests.isEmpty) {
                  return const Center(child: Text('Belum ada permintaan.'));
                }
                return RefreshIndicator(
                  onRefresh: controller.loadRequests,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final request = controller.requests[index];
                      final isAssignedToMe = request.karyawanId != null && request.karyawanId == controller.userId;
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.itemName,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            const SizedBox(height: 6),
                            Text('Jumlah: ${request.qty}'),
                            if (request.note != null && request.note!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text('Catatan: ${request.note}'),
                            ],
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _StatusChip(status: request.status),
                                if (!controller.isApoteker && request.status == 'new')
                                  OutlinedButton(
                                    onPressed: () => controller.claimRequest(request),
                                    child: const Text('Ambil'),
                                  ),
                                if (!controller.isApoteker && request.status == 'assigned' && isAssignedToMe)
                                  ElevatedButton(
                                    onPressed: () => controller.completeRequest(request),
                                    child: const Text('Selesai'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    switch (status) {
      case 'assigned':
        bg = const Color(0xffe8edff);
        fg = const Color(0xff2f6fea);
        break;
      case 'done':
        bg = const Color(0xffe9f8f1);
        fg = const Color(0xff1eb978);
        break;
      default:
        bg = const Color(0xfffff6e5);
        fg = const Color(0xffe6a927);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}
