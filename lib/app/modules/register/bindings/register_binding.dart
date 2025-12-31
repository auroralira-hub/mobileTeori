import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../services/auth_service.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
