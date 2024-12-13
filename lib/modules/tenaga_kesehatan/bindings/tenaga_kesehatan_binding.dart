import 'package:get/get.dart';
import '../controllers/tenaga_kesehatan_controller.dart';

class TenagaKesehatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenagaKesehatanController>(() => TenagaKesehatanController());
  }
}