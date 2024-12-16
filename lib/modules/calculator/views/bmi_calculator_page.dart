import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/detail_card.dart';
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
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "BMI (Body Mass Index) adalah indikator kesehatan berdasarkan berat dan tinggi badan.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            CustomTextFormField(
              icon: Icon(Icons.height),
              controller: heightController,
              labelText: "Tinggi Badan (cm)",
              keyboardType: TextInputType.number,
            ),
            CustomTextFormField(
              icon: Icon(Icons.monitor_weight),
              controller: weightController,
              labelText: "Berat Badan (kg)",
              keyboardType: TextInputType.number,
            ),
            ExpandedButton(
                text1: "Hitung BMI",
                press1: () {
                  controller.height.value =
                      double.tryParse(heightController.text) ?? 0.0;
                  controller.weight.value =
                      double.tryParse(weightController.text) ?? 0.0;
                  controller.calculateBMI();
                }),
            SizedBox(height: 30.0),
            Obx(() {
              final message = controller.bmiMessage.value;
              if (message.isEmpty) {
                return SizedBox.shrink();
              }
              return DetailCard(
                text: message,
                icon: Icons.info,
                isBold: true,
              );
            }),

          ],
        ),
      ),
    );
  }
}
