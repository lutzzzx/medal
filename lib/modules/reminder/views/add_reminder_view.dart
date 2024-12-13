import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../../../data/models/reminder_model.dart';

class AddReminderView extends StatefulWidget {
  @override
  _AddReminderViewState createState() => _AddReminderViewState();
}

class _AddReminderViewState extends State<AddReminderView> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _dailyConsumptionController = TextEditingController();
  final _dosesController = TextEditingController();
  final _supplyController = TextEditingController();
  final _notesController = TextEditingController();
  String _medicineType = 'Tablet';
  String _medicineUse = 'sebelum makan';
  List<TimeOfDay> _times = [];
  final ReminderController controller = Get.find();

  void _generateTimes() {
    final dailyConsumption = int.tryParse(_dailyConsumptionController.text) ?? 1;
    final interval = 24 / dailyConsumption;
    _times.clear();
    for (int i = 0; i < dailyConsumption; i++) {
      final hour = (i * interval).floor();
      _times.add(TimeOfDay(hour: hour, minute: 0));
    }
    setState(() {});
  }

  void _addReminder() {
    if (_formKey.currentState!.validate()) {
      controller.createReminder(
        _medicineNameController.text,
        int.parse(_dailyConsumptionController.text),
        int.parse(_dosesController.text),
        _medicineType,
        _medicineUse,
        int.parse(_supplyController.text),
        _notesController.text,
        _times,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pengingat Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _medicineNameController,
                  decoration: InputDecoration(labelText: 'Nama Obat'),
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: _dailyConsumptionController,
                  decoration: InputDecoration(labelText: 'Konsumsi Per Hari'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _generateTimes(),
                  validator: (value) => value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                ),
                ..._times.asMap().entries.map((entry) {
                  int index = entry.key;
                  TimeOfDay time = entry.value;
                  return ListTile(
                    title: Text('Jam Minum ke-${index + 1}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final newTime = await showTimePicker(
                          context: context,
                          initialTime: time,
                        );
                        if (newTime != null) {
                          setState(() {
                            _times[index] = newTime;
                          });
                        }
                      },
                    ),
                    subtitle: Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                    ),
                  );
                }).toList(),
                TextFormField(
                  controller: _dosesController,
                  decoration: InputDecoration(labelText: 'Dosis per Konsumsi'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _medicineType,
                  items: ['Tablet', 'Sirup', 'Kapsul', 'Salep']
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _medicineType = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Jenis Obat'),
                ),
                DropdownButtonFormField<String>(
                  value: _medicineUse,
                  items: ['sebelum makan', 'sesudah makan', 'saat makan']
                      .map((use) => DropdownMenuItem(
                    value: use,
                    child: Text(use),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _medicineUse = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Waktu Konsumsi'),
                ),
                TextFormField(
                  controller: _supplyController,
                  decoration: InputDecoration(labelText: 'Persediaan Obat'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: 'Keterangan'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addReminder,
                  child: Text('Tambah Pengingat'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
