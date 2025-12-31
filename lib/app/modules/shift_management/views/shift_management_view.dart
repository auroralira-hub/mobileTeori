import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shift_management_controller.dart';

class ShiftManagementView extends GetView<ShiftManagementController> {
  const ShiftManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Shift')),
      body: Obx(() => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.shifts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final s = controller.shifts[idx];
          return ShiftCard(shift: s);
        },
      )),
    );
  }
}

class ShiftCard extends StatelessWidget {
  final Shift shift;
  const ShiftCard({super.key, required this.shift});

  Color getStatusColor() {
    switch (shift.status) {
      case ShiftStatus.active:
        return Colors.green;
      case ShiftStatus.done:
        return Colors.grey;
      case ShiftStatus.upcoming:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getStatusColor().withValues(alpha: 0.1),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: getStatusColor()),
                const SizedBox(width: 8),
                Text(shift.name, style: TextStyle(fontWeight: FontWeight.bold, color: getStatusColor())),
                const Spacer(),
                Text(shift.statusLabel, style: TextStyle(color: getStatusColor())),
              ],
            ),
            const SizedBox(height: 8),
            Text('Waktu: ${shift.time}'),
            Text('Apoteker: ${shift.apoteker}'),
          ],
        ),
      ),
    );
  }
}
