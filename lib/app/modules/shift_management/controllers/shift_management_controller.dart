import 'package:get/get.dart';

enum ShiftStatus { active, done, upcoming }

class Shift {
  final String name, time, apoteker;
  final ShiftStatus status;
  Shift({required this.name, required this.time, required this.apoteker, required this.status});
  String get statusLabel {
    switch (status) {
      case ShiftStatus.active:
        return 'Aktif';
      case ShiftStatus.done:
        return 'Selesai';
      case ShiftStatus.upcoming:
        return 'Akan Datang';
    }
  }
}

class ShiftManagementController extends GetxController {
  final shifts = <Shift>[].obs;

  @override
  void onInit() {
    super.onInit();
    shifts.assignAll([
      Shift(name: 'Pagi', time: '07:00 - 13:00', apoteker: 'dr. Sarah', status: ShiftStatus.done),
      Shift(name: 'Siang', time: '13:00 - 19:00', apoteker: 'dr. Andi', status: ShiftStatus.active),
      Shift(name: 'Malam', time: '19:00 - 07:00', apoteker: 'dr. Rina', status: ShiftStatus.upcoming),
    ]);
  }
}
