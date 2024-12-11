import 'package:flutter/material.dart';

class BodyFatCalculatorPage extends StatefulWidget {
  @override
  _BodyFatCalculatorPageState createState() => _BodyFatCalculatorPageState();
}

class _BodyFatCalculatorPageState extends State<BodyFatCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  double? _weight;
  double? _height;
  int? _age;
  String _gender = 'Male';
  double? _bodyFatPercentage;

  void _calculateBodyFat() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simplified body fat calculation based on BMI formula
      final bmi = _weight! / ((_height! / 100) * (_height! / 100));
      if (_gender == 'Male') {
        _bodyFatPercentage = 1.20 * bmi + 0.23 * _age! - 16.2;
      } else {
        _bodyFatPercentage = 1.20 * bmi + 0.23 * _age! - 5.4;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Fat Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Body Fat Percentage (BF%) is an estimate of the amount of fat in your body compared to your total weight. Use this calculator to find your BF% based on BMI and other inputs.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your weight';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _weight = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your height';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _height = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _age = int.parse(value!);
                      },
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      value: _gender,
                      items: ['Male', 'Female']
                          .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _calculateBodyFat,
                child: Text('Calculate'),
              ),
              SizedBox(height: 20.0),
              if (_bodyFatPercentage != null)
                Text(
                  'Your Body Fat Percentage is ${_bodyFatPercentage!.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
