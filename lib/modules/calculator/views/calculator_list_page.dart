import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class CalculatorListPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Kalkulator BMI'),
            onTap: () {
              Get.toNamed('/bmi-calculator');
            },
          ),
          ListTile(
            title: Text('Kalkulator BMR'),
            onTap: () {
              Get.toNamed('/bmr-calculator');
            },
          ),
          ListTile(
            title: Text('Kalkulator BF(%)'),
            onTap: () {
              Get.toNamed('/body-fat-calculator');
            },
          ),
          ListTile(
            title: Text('Kalkulator WHR'),
            onTap: () {
              Get.toNamed('/whr-calculator');
            },
          ),
        ],
      ),
    );
  }
}