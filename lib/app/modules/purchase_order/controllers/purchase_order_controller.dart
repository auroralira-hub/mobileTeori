import 'package:flutter/material.dart';
import 'package:get/get.dart';

class POData {
  final String status;
  final String poNumber;
  final String supplier;
  final String date;
  final String total;
  final String actionLabel;
  final List<String> items;
  final int moreCount;
  final Color? actionColor;
  const POData({
    required this.status,
    required this.poNumber,
    required this.supplier,
    required this.date,
    required this.items,
    required this.moreCount,
    required this.total,
    required this.actionLabel,
    this.actionColor,
  });
}

class PurchaseOrderController extends GetxController {
  final statusTabs = ['Semua', 'Draft', 'Dikirim', 'Selesai'];
  final selectedStatus = 'Semua'.obs;

  final _poList = <POData>[
    POData(
      status: 'Dikirim',
      poNumber: 'PO-2024-001',
      supplier: 'PT Kimia Farma',
      date: '08 Des 2024',
      items: ['Paracetamol 500mg', 'Amoxicillin 500mg'],
      moreCount: 13,
      total: 'Rp 12.500.000',
      actionLabel: 'Terima Barang',
      actionColor: Colors.green,
    ),
    POData(
      status: 'Selesai',
      poNumber: 'PO-2024-002',
      supplier: 'PT Kalbe Farma',
      date: '07 Des 2024',
      items: ['Vitamin C 1000mg', 'Cetirizine 10mg'],
      moreCount: 6,
      total: 'Rp 8.750.000',
      actionLabel: 'Lihat Detail',
      actionColor: Colors.grey[300],
    ),
    POData(
      status: 'Draft',
      poNumber: 'PO-2024-003',
      supplier: 'PT Dexa Medica',
      date: '06 Des 2024',
      items: ['Omeprazole 20mg', 'Metformin 500mg'],
      moreCount: 10,
      total: 'Rp 15.200.000',
      actionLabel: 'Kirim PO',
      actionColor: Colors.blue,
    ),
    POData(
      status: 'Selesai',
      poNumber: 'PO-2024-004',
      supplier: 'PT Combiphar',
      date: '05 Des 2024',
      items: ['OBH Combi Syrup', 'Antimo'],
      moreCount: 4,
      total: 'Rp 4.500.000',
      actionLabel: 'Lihat Detail',
      actionColor: Colors.grey[300],
    ),
  ].obs;

  List<POData> get filteredPO {
    if (selectedStatus.value == 'Semua') return _poList;
    return _poList.where((po) => po.status == selectedStatus.value).toList();
  }

  int countFor(String status) =>
      _poList.where((po) => po.status == status).length;
}
