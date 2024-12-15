import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/calculator_controller.dart';

class BMICalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  // Tambahkan TextEditingController untuk mengontrol input tinggi dan berat badan
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator BMI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "BMI (Body Mass Index) adalah indikator kesehatan berdasarkan berat dan tinggi badan.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),

            // Input untuk Tinggi Badan
            CustomTextFormField(
              icon: Icon(Icons.height),
              controller: heightController,
              labelText: "Tinggi Badan (cm)",
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10.0),

            // Input untuk Berat Badan
            CustomTextFormField(
              icon: Icon(Icons.monitor_weight),
              controller: weightController,
              labelText: "Berat Badan (kg)",
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20.0),

            ExpandedButton(
                text1: "Hitung BMI",
                press1: () {
                  // Ambil nilai dari controller dan update CalculatorController
                  controller.height.value =
                      double.tryParse(heightController.text) ?? 0.0;
                  controller.weight.value =
                      double.tryParse(weightController.text) ?? 0.0;

                  // Panggil fungsi hitung BMI
                  controller.calculateBMI();
                }),

            SizedBox(height: 20.0),

            // Output Hasil BMI
            Obx(() {
              return Text(
                controller.bmiMessage.value,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              );
            }),
          ],
        ),
      ),
    );
  }
}
