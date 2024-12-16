import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/detail_card.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/calculator_controller.dart';

class BMRCalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  final TextEditingController usiaController = TextEditingController();
  final TextEditingController tinggiBadanController = TextEditingController();
  final TextEditingController beratBadanController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  BMRCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator BMR'),
        backgroundColor: Colors.white,
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
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),

              CustomTextFormField(
                icon: Icon(Icons.person),
                controller: usiaController,
                labelText: "Usia (Tahun)",
                keyboardType: TextInputType.number,
              ),

              CustomTextFormField(
                icon: Icon(Icons.height),
                controller: tinggiBadanController,
                labelText: "Tinggi Badan (cm)",
                keyboardType: TextInputType.number,
              ),

              CustomTextFormField(
                icon: Icon(Icons.monitor_weight),
                controller: beratBadanController,
                labelText: "Berat Badan (kg)",
                keyboardType: TextInputType.number,
              ),

              CustomTextFormField(
                icon: Icon(Icons.transgender),
                controller: genderController,
                labelText: "Jenis Kelamin",
                dropdownItems: ["Pria", "Wanita"],
                onChanged: (value) {
                  controller.gender.value = value == "Pria" ? "Male" : "Female";
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
              SizedBox(height: 30.0),

              // Output Hasil BMR
              Obx(() {
                final message = controller.bmrMessage.value;
                if (message.isEmpty) {
                  return SizedBox.shrink(); // Widget kosong jika tidak ada nilai
                }
                return DetailCard(
                  text: message,
                  icon: Icons.calculate, // Ikon contoh, sesuaikan jika diperlukan
                  isBold: true, // Karena pada Text sebelumnya menggunakan FontWeight.bold
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
