import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedRequest {
  final String id;
  final String itemName;
  final int qty;
  final String? note;
  final String status;
  final String apotekerId;
  final String? karyawanId;
  final DateTime createdAt;

  MedRequest({
    required this.id,
    required this.itemName,
    required this.qty,
    required this.status,
    required this.apotekerId,
    required this.createdAt,
    this.note,
    this.karyawanId,
  });

  factory MedRequest.fromMap(Map<String, dynamic> data) {
    final qtyRaw = data['qty'];
    final qty = qtyRaw is int ? qtyRaw : int.tryParse(qtyRaw?.toString() ?? '') ?? 0;
    final createdRaw = data['created_at'];
    final createdAt =
        createdRaw is String ? DateTime.tryParse(createdRaw) ?? DateTime.now() : createdRaw as DateTime? ?? DateTime.now();
    return MedRequest(
      id: data['id'] as String,
      itemName: (data['item_name'] ?? '') as String,
      qty: qty,
      note: data['note'] as String?,
      status: (data['status'] ?? 'new') as String,
      apotekerId: (data['apoteker_id'] ?? '') as String,
      karyawanId: data['karyawan_id'] as String?,
      createdAt: createdAt,
    );
  }
}

class MedRequestController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final RxList<MedRequest> requests = <MedRequest>[].obs;
  final RxList<MedicineItem> medicines = <MedicineItem>[].obs;
  final selectedMedicine = Rxn<MedicineItem>();
  final isLoading = false.obs;
  final isLoadingMeds = false.obs;
  final errorMessage = ''.obs;
  final role = 'karyawan'.obs;
  final String? _userId = Supabase.instance.client.auth.currentUser?.id;
  String? get userId => _userId;

  final itemController = TextEditingController();
  final qtyController = TextEditingController();
  final noteController = TextEditingController();
  final FocusNode medicineFocus = FocusNode();

  bool get isApoteker => role.value.toLowerCase() == 'apoteker';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['role'] is String) {
      role.value = (args['role'] as String).toLowerCase();
    }
    itemController.addListener(() {
      final selected = selectedMedicine.value;
      if (selected != null && itemController.text.trim() != selected.name) {
        selectedMedicine.value = null;
      }
    });
    if (isApoteker) {
      loadMedicines();
    }
    loadRequests();
  }

  Future<void> loadRequests() async {
    if (_userId == null) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final query = _client.from('med_requests').select();
      if (isApoteker) {
        final data = await query.eq('apoteker_id', _userId).order('created_at', ascending: false);
        requests.assignAll((data as List).map((e) => MedRequest.fromMap(e as Map<String, dynamic>)));
      } else {
        final data = await query
            .or('status.eq.new,and(status.eq.assigned,karyawan_id.eq.$_userId)')
            .order('created_at', ascending: false);
        requests.assignAll((data as List).map((e) => MedRequest.fromMap(e as Map<String, dynamic>)));
      }
    } catch (error) {
      errorMessage.value = 'Gagal memuat permintaan.';
      debugPrint('Load requests failed: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRequest() async {
    if (_userId == null) return;
    final selected = selectedMedicine.value;
    final item = selected?.name ?? itemController.text.trim();
    final qty = int.tryParse(qtyController.text.trim()) ?? 0;
    if (item.isEmpty || qty <= 0) {
      Get.snackbar('Data tidak lengkap', 'Isi nama obat dan jumlah terlebih dahulu.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await _client.from('med_requests').insert({
        'apoteker_id': _userId,
        'medicine_id': selected?.id,
        'item_name': item,
        'qty': qty,
        'note': noteController.text.trim().isEmpty ? null : noteController.text.trim(),
        'status': 'new',
      });
      itemController.clear();
      qtyController.clear();
      noteController.clear();
      await loadRequests();
      Get.snackbar('Permintaan dibuat', 'Permintaan obat terkirim ke karyawan.', snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      debugPrint('Create request failed: $error');
      Get.snackbar('Gagal', 'Tidak bisa membuat permintaan.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> loadMedicines() async {
    isLoadingMeds.value = true;
    try {
      final data = await _client
          .from('medicines')
          .select('id, name, rack_code, stock')
          .order('name', ascending: true);
      medicines.assignAll((data as List).map((e) => MedicineItem.fromMap(e as Map<String, dynamic>)));
    } catch (error) {
      debugPrint('Load medicines failed: $error');
    } finally {
      isLoadingMeds.value = false;
    }
  }

  Future<void> claimRequest(MedRequest request) async {
    if (_userId == null) return;
    try {
      await _client.from('med_requests').update({
        'status': 'assigned',
        'karyawan_id': _userId,
      }).eq('id', request.id);
      await loadRequests();
    } catch (error) {
      debugPrint('Claim request failed: $error');
      Get.snackbar('Gagal', 'Tidak bisa mengambil permintaan.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> completeRequest(MedRequest request) async {
    if (_userId == null) return;
    try {
      await _client.from('med_requests').update({
        'status': 'done',
      }).eq('id', request.id);
      await loadRequests();
    } catch (error) {
      debugPrint('Complete request failed: $error');
      Get.snackbar('Gagal', 'Tidak bisa menyelesaikan permintaan.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    itemController.dispose();
    qtyController.dispose();
    noteController.dispose();
    medicineFocus.dispose();
    super.onClose();
  }
}

class MedicineItem {
  final String id;
  final String name;
  final String? rackCode;
  final int stock;

  MedicineItem({
    required this.id,
    required this.name,
    required this.stock,
    this.rackCode,
  });

  factory MedicineItem.fromMap(Map<String, dynamic> data) {
    final stockRaw = data['stock'];
    final stock = stockRaw is int ? stockRaw : int.tryParse(stockRaw?.toString() ?? '') ?? 0;
    return MedicineItem(
      id: data['id'] as String,
      name: (data['name'] ?? '') as String,
      rackCode: data['rack_code'] as String?,
      stock: stock,
    );
  }
}
