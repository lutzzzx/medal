import 'package:get/get.dart';
import 'package:medal/modules/calculator/controllers/calculator_controller.dart';
import 'package:medal/modules/layout/controllers/layout_controller.dart';
import 'package:medal/modules/reminder/controllers/reminder_controller.dart';
import 'package:medal/modules/tenaga_kesehatan/controllers/tenaga_kesehatan_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutController>(() => LayoutController());
    Get.lazyPut<ReminderController>(() => ReminderController());
    Get.lazyPut<TenagaKesehatanController>(() => TenagaKesehatanController());
    Get.lazyPut<CalculatorController>(() => CalculatorController());
  }
}
