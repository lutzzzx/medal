import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class WhrCalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator WHR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Waist-to-Hip Ratio (WHR) adalah rasio lingkar pinggang terhadap lingkar pinggul.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Lingkar Pinggang (cm)'),
              onChanged: (value) => controller.waist.value = double.tryParse(value) ?? 0.0,
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Lingkar Pinggul (cm)'),
              onChanged: (value) => controller.hip.value = double.tryParse(value) ?? 0.0,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: controller.calculateWHR,
              child: Text('Hitung WHR'),
            ),
            SizedBox(height: 20.0),
            Obx(() {
              return Text(
                controller.whrMessage.value.isEmpty
                    ? ''
                    : '${controller.whrMessage.value} (WHR: ${controller.whr.value.toStringAsFixed(2)})',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              );
            }),
          ],
        ),
      ),
    );
  }
}
