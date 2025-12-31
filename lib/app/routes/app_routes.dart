part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const login = _Paths.login;
  static const home = _Paths.home;
  static const stok = _Paths.stok;
  static const rak = _Paths.rak;
  static const notifikasi = _Paths.notifikasi;
  static const lainnya = _Paths.lainnya;
  static const addEditMedicine = _Paths.addEditMedicine;
  static const dailyReport = _Paths.dailyReport;
  static const shiftManagement = _Paths.shiftManagement;
  static const stockCheck = _Paths.stockCheck;
  static const patient = _Paths.patient;
  static const patientDetail = _Paths.patientDetail;
  static const purchaseOrder = _Paths.purchaseOrder;
  static const analytics = _Paths.analytics;
  static const supplier = _Paths.supplier;
  static const register = _Paths.register;
  static const landing = _Paths.landing;
  static const scanBarcode = _Paths.scanBarcode;
  static const kasir = _Paths.kasir;
  static const posHistory = _Paths.posHistory;
  static const antrian = _Paths.antrian;
}

abstract class _Paths {
  _Paths._();

  static const login = '/login';
  static const home = '/home';
  static const stok = '/stok';
  static const rak = '/rak';
  static const notifikasi = '/notifikasi';
  static const lainnya = '/lainnya';
  static const addEditMedicine = '/add-edit-medicine';
  static const dailyReport = '/daily-report';
  static const shiftManagement = '/shift-management';
  static const stockCheck = '/stock-check';
  static const patient = '/patient';
  static const patientDetail = '/patient-detail';
  static const purchaseOrder = '/purchase-order';
  static const analytics = '/analytics';
  static const supplier = '/supplier';
  static const register = '/register';
  static const landing = '/landing';
  static const scanBarcode = '/scan-barcode';
  static const kasir = '/kasir';
  static const posHistory = '/pos-history';
  static const antrian = '/antrian';
}
