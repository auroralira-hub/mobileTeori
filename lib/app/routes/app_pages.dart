import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/stok/bindings/stok_binding.dart';
import '../modules/stok/views/stok_view.dart';
import '../modules/rak/bindings/rak_binding.dart';
import '../modules/rak/views/rak_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/lainnya/bindings/lainnya_binding.dart';
import '../modules/lainnya/views/lainnya_view.dart';
import '../modules/add_edit_medicine/bindings/add_edit_medicine_binding.dart';
import '../modules/add_edit_medicine/views/add_edit_medicine_view.dart';
import '../modules/daily_report/bindings/daily_report_binding.dart';
import '../modules/daily_report/views/daily_report_view.dart';
import '../modules/shift_management/bindings/shift_management_binding.dart';
import '../modules/shift_management/views/shift_management_view.dart';
import '../modules/stock_check/bindings/stock_check_binding.dart';
import '../modules/stock_check/views/stock_check_view.dart';
import '../modules/patient/bindings/patient_binding.dart';
import '../modules/patient/views/patient_list_view.dart';
import '../modules/patient/views/patient_detail_view.dart';
import '../modules/purchase_order/bindings/purchase_order_binding.dart';
import '../modules/purchase_order/views/purchase_order_view.dart';
import '../modules/analytics/bindings/analytics_binding.dart';
import '../modules/analytics/views/analytics_view.dart';
import '../modules/supplier/bindings/supplier_binding.dart';
import '../modules/supplier/views/supplier_list_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';
import '../modules/scan_barcode/bindings/scan_barcode_binding.dart';
import '../modules/scan_barcode/views/scan_barcode_view.dart';
import '../modules/kasir/bindings/kasir_binding.dart';
import '../modules/kasir/views/kasir_view.dart';
import '../modules/pos_history/bindings/pos_history_binding.dart';
import '../modules/pos_history/views/pos_history_view.dart';
import '../modules/antrian/bindings/antrian_binding.dart';
import '../modules/antrian/views/antrian_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.landing,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.scanBarcode,
      page: () => const ScanBarcodeView(),
      binding: ScanBarcodeBinding(),
    ),
    GetPage(
      name: Routes.kasir,
      page: () => const KasirView(),
      binding: KasirBinding(),
    ),
    GetPage(
      name: Routes.posHistory,
      page: () => const PosHistoryView(),
      binding: PosHistoryBinding(),
    ),
    GetPage(
      name: Routes.antrian,
      page: () => const AntrianView(),
      binding: AntrianBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.stok,
      page: () => const StokView(),
      binding: StokBinding(),
    ),
    GetPage(
      name: Routes.rak,
      page: () => const RakView(),
      binding: RakBinding(),
    ),
    GetPage(
      name: Routes.notifikasi,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(
      name: Routes.lainnya,
      page: () => const LainnyaView(),
      binding: LainnyaBinding(),
    ),
    GetPage(
      name: Routes.addEditMedicine,
      page: () => const AddEditMedicineView(),
      binding: AddEditMedicineBinding(),
    ),
    GetPage(
      name: Routes.dailyReport,
      page: () => const DailyReportView(),
      binding: DailyReportBinding(),
    ),
    GetPage(
      name: Routes.shiftManagement,
      page: () => const ShiftManagementView(),
      binding: ShiftManagementBinding(),
    ),
    GetPage(
      name: Routes.stockCheck,
      page: () => const StockCheckView(),
      binding: StockCheckBinding(),
    ),
    GetPage(
      name: Routes.patient,
      page: () => const PatientListView(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: Routes.patientDetail,
      page: () => const PatientDetailView(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: Routes.purchaseOrder,
      page: () => const PurchaseOrderView(),
      binding: PurchaseOrderBinding(),
    ),
    GetPage(
      name: Routes.analytics,
      page: () => const AnalyticsView(),
      binding: AnalyticsBinding(),
    ),
    GetPage(
      name: Routes.supplier,
      page: () => const SupplierListView(),
      binding: SupplierBinding(),
    ),
  ];
}
