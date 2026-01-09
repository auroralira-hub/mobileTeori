import 'package:get/get.dart';

enum NotifType { kadaluarsa, stokMenipis, info, success }

class NotificationModel {
  final String title;
  final String description;
  final DateTime timestamp;
  final NotifType type;
  final bool unread;
  NotificationModel({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.unread = true,
  });
}

class NotifikasiController extends GetxController {
  final tabIndex = 1.obs; // 1: Kadaluarsa, 2: Stok Menipis
  final notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy data
    notifications.assignAll([
      NotificationModel(
        title: 'Obat Kadaluarsa: Amoxicillin 500 mg',
        description: 'Batch BTH-2024-001 kadaluarsa 10 Jan 2025 (2 hari lagi)',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotifType.kadaluarsa,
        unread: true,
      ),
      NotificationModel(
        title: 'Stok Menipis: OBH Combi Syrup',
        description: 'Stok 25 pcs di bawah minimum (30 pcs)',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: NotifType.stokMenipis,
        unread: true,
      ),
      NotificationModel(
        title: 'Info: Update Sistem',
        description: 'Aplikasi Apotek Aafiyah telah diperbarui ke versi terbaru.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotifType.info,
        unread: false,
      ),
      NotificationModel(
        title: 'Sukses: Order Pembelian',
        description: 'Order pembelian #1234 berhasil diproses.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotifType.success,
        unread: false,
      ),
    ]);
  }

  List<NotificationModel> get filteredNotifications {
    if (tabIndex.value == 1) {
      return notifications.where((n) => n.type == NotifType.kadaluarsa).toList();
    } else if (tabIndex.value == 2) {
      return notifications.where((n) => n.type == NotifType.stokMenipis).toList();
    }
    return notifications;
  }

  void setTab(int idx) => tabIndex.value = idx;
  void markAsRead(int idx) {
    notifications[idx] = NotificationModel(
      title: notifications[idx].title,
      description: notifications[idx].description,
      timestamp: notifications[idx].timestamp,
      type: notifications[idx].type,
      unread: false,
    );
  }
}
