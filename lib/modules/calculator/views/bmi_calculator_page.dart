import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class BMICalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

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
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Tinggi Badan (cm)"),
              onChanged: (value) => controller.height.value = double.tryParse(value) ?? 0.0,
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Berat Badan (kg)"),
              onChanged: (value) => controller.weight.value = double.tryParse(value) ?? 0.0,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: controller.calculateBMI,
              child: Text("Hitung BMI"),
            ),
            SizedBox(height: 20.0),
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