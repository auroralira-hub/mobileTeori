import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class Patient {
  final String name, contact, address;
  final int age, resepCount;
  final List<Prescription> prescriptions;

  Patient({
    required this.name,
    required this.age,
    required this.contact,
    required this.address,
    required this.resepCount,
    required this.prescriptions,
  });
}

class Prescription {
  final String doctor, date;
  final List<String> items;
  final int total;

  Prescription({
    required this.doctor,
    required this.date,
    required this.items,
    required this.total,
  });
}

class PatientController extends GetxController {
  final searchController = TextEditingController();
  final patients = <Patient>[].obs;
  final filteredPatients = <Patient>[].obs;

  @override
  void onInit() {
    super.onInit();
    patients.assignAll([
      Patient(
        name: 'Budi Santoso',
        age: 32,
        contact: '+628123456789',
        address: 'Jl. Melati No. 10',
        resepCount: 3,
        prescriptions: [
          Prescription(
            doctor: 'dr. Sarah',
            date: '01/12/2025',
            items: ['Paracetamol', 'OBH'],
            total: 50000,
          ),
          Prescription(
            doctor: 'dr. Andi',
            date: '15/11/2025',
            items: ['Amoxicillin'],
            total: 35000,
          ),
        ],
      ),
      Patient(
        name: 'Siti Aminah',
        age: 28,
        contact: '+628987654321',
        address: 'Jl. Kenanga No. 5',
        resepCount: 2,
        prescriptions: [
          Prescription(
            doctor: 'dr. Sarah',
            date: '20/11/2025',
            items: ['Vitamin C'],
            total: 25000,
          ),
        ],
      ),
    ]);
    filteredPatients.assignAll(patients);
  }

  void searchPatient(String query) {
    if (query.isEmpty) {
      filteredPatients.assignAll(patients);
      return;
    }

    final q = query.toLowerCase();
    filteredPatients.assignAll(
      patients
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) || p.contact.contains(query),
          )
          .toList(),
    );
  }

  void goToDetail(Patient p) {
    Get.toNamed(Routes.patientDetail, arguments: p);
  }

  void addPatient() {
    Get.toNamed('${Routes.patient}/add');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
