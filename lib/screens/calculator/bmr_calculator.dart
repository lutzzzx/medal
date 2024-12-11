import 'package:flutter/material.dart';

class BMRCalculator extends StatefulWidget {
  @override
  _BMRCalculatorState createState() => _BMRCalculatorState();
}

class _BMRCalculatorState extends State<BMRCalculator> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _gender = "Male";
  double? _bmr;
  String _message = "Masukkan data Anda untuk menghitung BMR";

  void _calculateBMR() {
    final int? age = int.tryParse(_ageController.text);
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (age != null && height != null && weight != null && age > 0 && height > 0 && weight > 0) {
      double bmr;
      if (_gender == "Male") {
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      } else {
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      }
      setState(() {
        _bmr = bmr;
        _message = "BMR Anda telah dihitung";
      });
    } else {
      setState(() {
        _message = "Masukkan nilai usia, tinggi, dan berat badan yang valid";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator BMR'),
        backgroundColor: Colors.blue,
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
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Usia (tahun)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
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
            SizedBox(height: 10.0),
            DropdownButton<String>(
              value: _gender,
              items: [
                DropdownMenuItem(value: "Male", child: Text("Pria")),
                DropdownMenuItem(value: "Female", child: Text("Wanita")),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _calculateBMR,
              child: Text("Hitung BMR"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(height: 20.0),
            if (_bmr != null)
              Text(
                "BMR Anda: ${_bmr!.toStringAsFixed(1)} kalori",
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