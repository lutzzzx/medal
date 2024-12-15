import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/calculator_controller.dart';

class BMRCalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  final TextEditingController usiaController = TextEditingController();
  final TextEditingController tinggiBadanController = TextEditingController();
  final TextEditingController beratBadanController = TextEditingController();

  BMRCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator BMR'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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

              // Input Usia
              CustomTextFormField(
                icon: Icon(Icons.person),
                controller: usiaController,
                labelText: "Usia (Tahun)",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),

              // Input Tinggi Badan
              CustomTextFormField(
                icon: Icon(Icons.height),
                controller: tinggiBadanController,
                labelText: "Tinggi Badan (cm)",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),

              // Input Berat Badan
              CustomTextFormField(
                icon: Icon(Icons.monitor_weight),
                controller: beratBadanController,
                labelText: "Berat Badan (kg)",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),

              // Pilihan Jenis Kelamin
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

              // Tombol Hitung BMR
              ExpandedButton(
                  text1: "Hitung BMR",
                  press1: () {
                    // Update nilai input ke controller
                    controller.age.value =
                        int.tryParse(usiaController.text) ?? 0;
                    controller.height.value =
                        double.tryParse(tinggiBadanController.text) ?? 0.0;
                    controller.weight.value =
                        double.tryParse(beratBadanController.text) ?? 0.0;

                    // Jalankan perhitungan BMR
                    controller.calculateBMR();
                  }),
              SizedBox(height: 20.0),

              // Output Hasil BMR
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
      ),
    );
  }
}
