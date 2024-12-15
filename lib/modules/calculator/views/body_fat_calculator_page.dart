import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/calculator_controller.dart';

class BodyFatCalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  final TextEditingController usiaController = TextEditingController();
  final TextEditingController tinggiBadanController = TextEditingController();
  final TextEditingController beratBadanController = TextEditingController();

  BodyFatCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator Body Fat'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Body Fat Percentage (BF%) adalah estimasi jumlah lemak dalam tubuh Anda dibandingkan dengan total berat badan.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),

              CustomTextFormField(
                icon: Icon(Icons.monitor_weight),
                controller: beratBadanController,
                labelText: "Berat Badan (kg)",
                keyboardType: TextInputType.number,
              ),

              CustomTextFormField(
                icon: Icon(Icons.height),
                controller: tinggiBadanController,
                labelText: "Tinggi Badan (cm)",
                keyboardType: TextInputType.number,
              ),

              CustomTextFormField(
                icon: Icon(Icons.person),
                controller: usiaController,
                labelText: "Usia (Tahun)",
                keyboardType: TextInputType.number,
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: Obx(() => DropdownButton<String>(
                        isExpanded: true,
                        value: controller.gender.value,
                        items: [
                          DropdownMenuItem(value: "Male", child: Text("Pria")),
                          DropdownMenuItem(
                              value: "Female", child: Text("Wanita")),
                        ],
                        onChanged: (value) {
                          controller.gender.value = value!;
                        },
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        dropdownColor: Colors.white,
                        alignment: Alignment.centerLeft,
                      )),
                ),
              ),
              SizedBox(height: 20.0),

              // Tombol Hitung Body Fat
              ExpandedButton(
                  text1: "Hitung BF",
                  press1: () {
                    controller.age.value =
                        int.tryParse(usiaController.text) ?? 0;
                    controller.height.value =
                        double.tryParse(tinggiBadanController.text) ?? 0.0;
                    controller.weight.value =
                        double.tryParse(beratBadanController.text) ?? 0.0;

                    controller.calculateBodyFat();
                  }),
              SizedBox(height: 20.0),

              // Output Hasil Body Fat
              Obx(() {
                return Text(
                  controller.bodyFatMessage.value.isEmpty
                      ? 'Masukkan data lengkap untuk menghitung Body Fat.'
                      : controller.bodyFatMessage.value,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
