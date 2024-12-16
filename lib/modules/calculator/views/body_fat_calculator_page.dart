import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/detail_card.dart';
import 'package:medal/widgets/expanded_button.dart';
import '../controllers/calculator_controller.dart';

class BodyFatCalculatorPage extends StatelessWidget {
  final CalculatorController controller = Get.find();

  final TextEditingController usiaController = TextEditingController();
  final TextEditingController tinggiBadanController = TextEditingController();
  final TextEditingController beratBadanController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  BodyFatCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator Body Fat'),
        backgroundColor: Colors.white,
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
              SizedBox(height: 30.0),

              // Output Hasil Body Fat
              Obx(() {
                final message = controller.bodyFatMessage.value;
                if (message.isEmpty) {
                  return SizedBox.shrink(); // Tidak menampilkan apa pun jika kosong
                }
                return DetailCard(
                  text: message,
                  icon: Icons.fitness_center, // Sesuaikan ikon jika diperlukan
                  isBold: true, // Karena sebelumnya menggunakan FontWeight.bold
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
