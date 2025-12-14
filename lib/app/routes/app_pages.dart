
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

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.STOK,
      page: () => const StokView(),
      binding: StokBinding(),
    ),
    GetPage(
      name: Routes.RAK,
      page: () => const RakView(),
      binding: RakBinding(),
    ),
    GetPage(
      name: Routes.NOTIFIKASI,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(
      name: Routes.LAINNYA,
      page: () => const LainnyaView(),
      binding: LainnyaBinding(),
    ),
    GetPage(
      name: Routes.ADD_EDIT_MEDICINE,
      page: () => const AddEditMedicineView(),
      binding: AddEditMedicineBinding(),
    ),
    GetPage(
      name: Routes.DAILY_REPORT,
      page: () => const DailyReportView(),
      binding: DailyReportBinding(),
    ),
    GetPage(
      name: Routes.SHIFT_MANAGEMENT,
      page: () => const ShiftManagementView(),
      binding: ShiftManagementBinding(),
    ),
    GetPage(
      name: Routes.STOCK_CHECK,
      page: () => const StockCheckView(),
      binding: StockCheckBinding(),
    ),
    GetPage(
      name: Routes.PATIENT,
      page: () => const PatientListView(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_DETAIL,
      page: () => const PatientDetailView(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: Routes.PURCHASE_ORDER,
      page: () => const PurchaseOrderView(),
      binding: PurchaseOrderBinding(),
    ),
    GetPage(
      name: Routes.ANALYTICS,
      page: () => const AnalyticsView(),
      binding: AnalyticsBinding(),
    ),
    GetPage(
      name: Routes.SUPPLIER,
      page: () => const SupplierListView(),
      binding: SupplierBinding(),
    ),
  ];
}
