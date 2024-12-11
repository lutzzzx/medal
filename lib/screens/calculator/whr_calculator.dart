import 'package:flutter/material.dart';

class WhrCalculatorPage extends StatefulWidget {
  @override
  _WhrCalculatorPageState createState() => _WhrCalculatorPageState();
}

class _WhrCalculatorPageState extends State<WhrCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  double? _waist;
  double? _hip;
  String _gender = 'Pria';
  double? _whr;

  void _calculateWHR() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Menghitung WHR
      _whr = _waist! / _hip!;

      setState(() {});
    }
  }

  String _getRiskCategory() {
    if (_whr == null) return '';

    if (_gender == 'Pria') {
      if (_whr! > 0.9) {
        return 'Risiko tinggi';
      } else {
        return 'Risiko rendah';
      }
    } else {
      if (_whr! > 0.85) {
        return 'Risiko tinggi';
      } else {
        return 'Risiko rendah';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator WHR'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Waist-to-Hip Ratio (WHR) adalah rasio lingkar pinggang terhadap lingkar pinggul. WHR dapat digunakan untuk mengukur risiko kesehatan terkait obesitas.',
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
                        labelText: 'Lingkar Pinggang (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan lingkar pinggang Anda';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _waist = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Lingkar Pinggul (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan lingkar pinggul Anda';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _hip = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin',
                        border: OutlineInputBorder(),
                      ),
                      value: _gender,
                      items: ['Pria', 'Wanita']
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
                onPressed: _calculateWHR,
                child: Text('Hitung WHR'),
              ),
              SizedBox(height: 20.0),
              if (_whr != null)
                Column(
                  children: [
                    Text(
                      'WHR Anda adalah ${_whr!.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Kategori Risiko: ${_getRiskCategory()}',
                      style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}