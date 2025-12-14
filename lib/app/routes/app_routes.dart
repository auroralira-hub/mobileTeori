part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const STOK = _Paths.STOK;
  static const RAK = _Paths.RAK;
  static const NOTIFIKASI = _Paths.NOTIFIKASI;
  static const LAINNYA = _Paths.LAINNYA;
  static const ADD_EDIT_MEDICINE = _Paths.ADD_EDIT_MEDICINE;
  static const DAILY_REPORT = _Paths.DAILY_REPORT;
  static const SHIFT_MANAGEMENT = _Paths.SHIFT_MANAGEMENT;
  static const STOCK_CHECK = _Paths.STOCK_CHECK;
  static const PATIENT = _Paths.PATIENT;
  static const PATIENT_DETAIL = _Paths.PATIENT_DETAIL;
  static const PURCHASE_ORDER = _Paths.PURCHASE_ORDER;
  static const ANALYTICS = _Paths.ANALYTICS;
  static const SUPPLIER = _Paths.SUPPLIER;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const STOK = '/stok';
  static const RAK = '/rak';
  static const NOTIFIKASI = '/notifikasi';
  static const LAINNYA = '/lainnya';
  static const ADD_EDIT_MEDICINE = '/add-edit-medicine';
  static const DAILY_REPORT = '/daily-report';
  static const SHIFT_MANAGEMENT = '/shift-management';
  static const STOCK_CHECK = '/stock-check';
  static const PATIENT = '/patient';
  static const PATIENT_DETAIL = '/patient-detail';
  static const PURCHASE_ORDER = '/purchase-order';
  static const ANALYTICS = '/analytics';
  static const SUPPLIER = '/supplier';
}
