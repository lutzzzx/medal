import 'package:get/get.dart';

class CalculatorController extends GetxController {
  // BMR Variables
  var age = 0.obs;
  var height = 0.0.obs;
  var weight = 0.0.obs;
  var gender = 'Male'.obs;
  var bmr = 0.0.obs;
  var bmrMessage = ''.obs;

  // BMI Variables
  var bmi = 0.0.obs;
  var bmiMessage = ''.obs;

  // WHR Variables
  var waist = 0.0.obs;
  var hip = 0.0.obs;
  var whr = 0.0.obs;
  var whrMessage = ''.obs;

  // Body Fat Variables
  var bodyFatPercentage = 0.0.obs;
  var bodyFatMessage = ''.obs;

  void calculateBMR() {
    if (age.value > 0 && height.value > 0 && weight.value > 0) {
      if (gender.value == 'Male') {
        bmr.value = 88.362 + (13.397 * weight.value) + (4.799 * height.value) - (5.677 * age.value);
      } else {
        bmr.value = 447.593 + (9.247 * weight.value) + (3.098 * height.value) - (4.330 * age.value);
      }
      bmrMessage.value = "BMR Anda: ${bmr.value.toStringAsFixed(1)} kalori";
    } else {
      bmrMessage.value = ""; // Tidak menampilkan pesan jika input belum lengkap
    }
  }

  void calculateBMI() {
    if (height.value > 0 && weight.value > 0) {
      bmi.value = weight.value / ((height.value / 100) * (height.value / 100));
      if (bmi.value < 18.5) {
        bmiMessage.value = "Underweight (Kekurangan berat badan)";
      } else if (bmi.value >= 18.5 && bmi.value < 24.9) {
        bmiMessage.value = "Normal (Berat badan ideal)";
      } else if (bmi.value >= 25 && bmi.value < 29.9) {
        bmiMessage.value = "Overweight (Kelebihan berat badan)";
      } else {
        bmiMessage.value = "Obese (Obesitas)";
      }
    } else {
      bmiMessage.value = ""; // Tidak menampilkan pesan jika input belum lengkap
    }
  }

  void calculateWHR() {
    if (waist.value > 0 && hip.value > 0) {
      whr.value = waist.value / hip.value;
      if (gender.value == 'Male') {
        whrMessage.value = whr.value > 0.9
            ? "Tinggi risiko kesehatan"
            : "Risiko kesehatan rendah";
      } else {
        whrMessage.value = whr.value > 0.85
            ? "Tinggi risiko kesehatan"
            : "Risiko kesehatan rendah";
      }
    } else {
      whrMessage.value = ""; // Tidak menampilkan pesan jika input belum lengkap
    }
  }

  void calculateBodyFat() {
    if (weight.value > 0 && height.value > 0 && age.value > 0) {
      final bmiValue = weight.value / ((height.value / 100) * (height.value / 100));
      if (gender.value == 'Male') {
        bodyFatPercentage.value = 1.20 * bmiValue + 0.23 * age.value - 16.2;
      } else {
        bodyFatPercentage.value = 1.20 * bmiValue + 0.23 * age.value - 5.4;
      }
      bodyFatMessage.value = "Persentase lemak tubuh: ${bodyFatPercentage.value.toStringAsFixed(1)}%";
    } else {
      bodyFatMessage.value = ""; // Tidak menampilkan pesan jika input belum lengkap
    }
  }
}
