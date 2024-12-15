import 'package:get/get.dart';
import 'package:medal/modules/auth/bindings/auth_binding.dart';
import 'package:medal/modules/auth/views/login_screen.dart';
import 'package:medal/modules/auth/views/register_screen.dart';
import 'package:medal/modules/calculator/bindings/calculator_binding.dart';
import 'package:medal/modules/calculator/views/bmi_calculator_page.dart';
import 'package:medal/modules/calculator/views/bmr_calculator_page.dart';
import 'package:medal/modules/calculator/views/body_fat_calculator_page.dart';
import 'package:medal/modules/calculator/views/calculator_list_page.dart';
import 'package:medal/modules/calculator/views/whr_calculator_page.dart';
import 'package:medal/modules/home/bindings/home_binding.dart';
import 'package:medal/modules/home/views/home_view.dart';
import 'package:medal/modules/layout/bindings/layout_binding.dart';
import 'package:medal/modules/layout/views/layout_view.dart';
import 'package:medal/modules/profile/bindings/profile_binding.dart';
import 'package:medal/modules/profile/views/profile_view.dart';
import 'package:medal/modules/reminder/bindings/reminder_binding.dart';
import 'package:medal/modules/reminder/views/add_reminder_view.dart';
import 'package:medal/modules/reminder/views/reminder_list_view.dart';
import 'package:medal/modules/tenaga_kesehatan/bindings/tenaga_kesehatan_binding.dart';
import 'package:medal/modules/tenaga_kesehatan/views/tenaga_kesehatan_main_page.dart';

class AppRoutes {
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String LAYOUT = '/layout';
  static const String PROFILE = '/profile';
  static const String REMINDER = '/reminder';
  static const String ADD_REMINDER = '/add-reminder';
  static const String HOME = '/home';
  static const String TENAGA_KESEHATAN = '/tenaga_kesehatan';
  static const String CALCULATOR_LIST = '/calculator-list';
  static const String BMR_CALCULATOR = '/bmr-calculator';
  static const String BMI_CALCULATOR = '/bmi-calculator';
  static const String BODY_FAT_CALCULATOR = '/body-fat-calculator';
  static const String WHR_CALCULATOR = '/whr-calculator';

  static final routes = [
    GetPage(
      name: LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: REGISTER,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: LAYOUT,
      page: () => LayoutView(),
      binding: LayoutBinding(),
    ),
    GetPage(
      name: HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: REMINDER,
      page: () => ReminderListView(),
      binding: ReminderBinding(),
    ),
    GetPage(
      name: ADD_REMINDER,
      page: () => AddReminderView(),
      binding: ReminderBinding(),
    ),
    GetPage(
      name: TENAGA_KESEHATAN,
      page: () => TenagaKesehatanMainPage(),
      binding: TenagaKesehatanBinding(),
    ),
    GetPage(
      name: CALCULATOR_LIST,
      page: () => CalculatorListPage(),
      binding: CalculatorBinding(),
    ),
    GetPage(name: BMR_CALCULATOR, page: () => BMRCalculatorPage()),
    GetPage(name: BMI_CALCULATOR, page: () => BMICalculatorPage()),
    GetPage(name: BODY_FAT_CALCULATOR, page: () => BodyFatCalculatorPage()),
    GetPage(name: WHR_CALCULATOR, page: () => WhrCalculatorPage()),
  ];
}
