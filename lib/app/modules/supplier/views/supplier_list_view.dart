import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/supplier_controller.dart';

class SupplierListView extends GetView<SupplierController> {
  const SupplierListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Supplier')),
      body: Obx(() => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.suppliers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final s = controller.suppliers[idx];
          return SupplierCard(
            supplier: s,
            onTap: () => controller.goToPO(s),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addSupplier,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Supplier',
      ),
    );
  }
}

class SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback? onTap;
  const SupplierCard({super.key, required this.supplier, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(supplier.logoUrl),
                radius: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(supplier.category, style: const TextStyle(color: Colors.grey)),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(supplier.rating.toString(), style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 8),
                        Text(supplier.contact, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () => SupplierController.quickCall(supplier.contact),
                  ),
                  IconButton(
                    icon: const Icon(Icons.email, color: Colors.blue),
                    onPressed: () => SupplierController.quickEmail(supplier.email),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message, color: Colors.green),
                    onPressed: () => SupplierController.quickWhatsApp(supplier.contact),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
