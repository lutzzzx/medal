import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/calculator_list_container.dart';
import '../controllers/calculator_controller.dart';

class CalculatorListPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          CalculatorListContainer(
            text1: "Body Mass Index (BMI)",
            tap1: () {
              Get.toNamed('/bmi-calculator');
            },
          ),
          CalculatorListContainer(
            text1: "Basal Metabolic Rate (BMR)",
            tap1: () {
              Get.toNamed('/bmr-calculator');
            },
          ),
          CalculatorListContainer(
            text1: "Body Fat Percentage (BF%)",
            tap1: () {
              Get.toNamed('/body-fat-calculator');
            },
          ),
          CalculatorListContainer(
            text1: "Waist to Hip Ratio (WHR)",
            tap1: () {
              Get.toNamed('/whr-calculator');
            },
          ),
        ],
      ),
      // ListView(
      //   children: [
      //     ListTile(
      //       title: Text('Kalkulator BMI'),
      //       onTap: () {
      //         Get.toNamed('/bmi-calculator');
      //       },
      //     ),
      //     ListTile(
      //       title: Text('Kalkulator BMR'),
      //       onTap: () {
      //         Get.toNamed('/bmr-calculator');
      //       },
      //     ),
      //     ListTile(
      //       title: Text('Kalkulator BF(%)'),
      //       onTap: () {
      //         Get.toNamed('/body-fat-calculator');
      //       },
      //     ),
      //     ListTile(
      //       title: Text('Kalkulator WHR'),
      //       onTap: () {
      //         Get.toNamed('/whr-calculator');
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
