import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/detail_card.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/calculator_controller.dart';

class WhrCalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipController = TextEditingController();

  WhrCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator WHR'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              CustomTextFormField(
                icon: Icon(Icons.straighten),
                controller: waistController,
                labelText: 'Lingkar Pinggang (cm)',
                keyboardType: TextInputType.number,
              ),
              CustomTextFormField(
                icon: Icon(Icons.straighten),
                controller: hipController,
                labelText: 'Lingkar Pinggul (cm)',
                keyboardType: TextInputType.number,
              ),
              ExpandedButton(
                  text1: "Hitung WHR",
                  press1: () {
                    controller.waist.value =
                        double.tryParse(waistController.text) ?? 0.0;
                    controller.hip.value =
                        double.tryParse(hipController.text) ?? 0.0;

                    controller.calculateWHR();
                  }),
              SizedBox(height: 30),
              Obx(() {
                final message = controller.whrMessage.value;
                if (message.isEmpty) {
                  return SizedBox.shrink();
                }
                return DetailCard(
                  text: '$message (WHR: ${controller.whr.value.toStringAsFixed(2)})',
                  icon: Icons.accessibility,
                  isBold: true,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
