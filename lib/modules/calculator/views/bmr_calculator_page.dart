import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class BMRCalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator BMR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "BMR (Basal Metabolic Rate) adalah jumlah kalori yang dibutuhkan tubuh untuk fungsi dasar dalam keadaan istirahat.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Usia (tahun)"),
              onChanged: (value) => controller.age.value = int.tryParse(value) ?? 0,
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Tinggi Badan (cm)"),
              onChanged: (value) => controller.height.value = double.tryParse(value) ?? 0.0,
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Berat Badan (kg)"),
              onChanged: (value) => controller .weight.value = double.tryParse(value) ?? 0.0,
            ),
            SizedBox(height: 10.0),
            DropdownButton<String>(
              value: controller.gender.value,
              items: [
                DropdownMenuItem(value: "Male", child: Text("Pria")),
                DropdownMenuItem(value: "Female", child: Text("Wanita")),
              ],
              onChanged: (value) {
                controller.gender.value = value!;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: controller.calculateBMR,
              child: Text("Hitung BMR"),
            ),
            SizedBox(height: 20.0),
            Obx(() {
              return Text(
                controller.bmrMessage.value,
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