import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmi;
  String _message = "Masukkan tinggi dan berat badan Anda";

  void _calculateBMI() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0 && weight > 0) {
      final bmi = weight / ((height / 100) * (height / 100));
      setState(() {
        _bmi = bmi;
        if (bmi < 18.5) {
          _message = "Underweight (Kekurangan berat badan)";
        } else if (bmi >= 18.5 && bmi < 24.9) {
          _message = "Normal (Berat badan ideal)";
        } else if (bmi >= 25 && bmi < 29.9) {
          _message = "Overweight (Kelebihan berat badan)";
        } else {
          _message = "Obese (Obesitas)";
        }
      });
    } else {
      setState(() {
        _message = "Masukkan nilai tinggi dan berat badan yang valid";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator BMI'),
        backgroundColor: Colors.blue,
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
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tinggi Badan (cm)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Berat Badan (kg)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text("Hitung BMI"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(height: 20.0),
            if (_bmi != null)
              Text(
                "BMI Anda: ${_bmi!.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 10.0),
            Text(
              _message,
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}