import 'package:flutter/material.dart';
import 'package:medal/screens/calculator/bfp_calculator.dart';
import 'package:medal/screens/calculator/bmi_calculator.dart';
import 'package:medal/screens/calculator/bmr_calculator.dart';
import 'package:medal/screens/calculator/whr_calculator.dart';

class CalculatorListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kalkulator'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Kalkulator BMI'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMICalculator()),
              );
            },
          ),
          ListTile(
            title: Text('Kalkulator BMR'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMRCalculator()),
              );
            },
          ),
          ListTile(
            title: Text('Kalkulator BF(%)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BodyFatCalculatorPage()),
              );
            },
          ),
          ListTile(
            title: Text('Kalkulator WHR'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WhrCalculatorPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}