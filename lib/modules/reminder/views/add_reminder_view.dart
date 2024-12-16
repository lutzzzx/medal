import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/custom_text_form_field.dart';
import 'package:medal/widgets/expanded_button.dart';
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
    final dailyConsumption =
        int.tryParse(_dailyConsumptionController.text) ?? 1;
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
      appBar: AppBar(title: Text('Tambah Pengingat Obat'), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: _medicineNameController,
                  icon: Icon(Icons.radio_button_unchecked),
                  labelText: 'Nama Obat',
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                CustomTextFormField(
                  controller: _dailyConsumptionController,
                  icon: Icon(Icons.format_list_numbered),
                  labelText: 'Konsumsi Per Hari',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _generateTimes(),
                  validator: (value) =>
                  value == null || int.tryParse(value) == null
                      ? 'Harus berupa angka'
                      : null,
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                        controller: _dosesController,
                        icon: Icon(Icons.monitor_heart),
                        labelText: 'Dosis',
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value == null || int.tryParse(value) == null
                            ? 'Harus berupa angka'
                            : null,
                      ),
                    ),
                    SizedBox(width: 14,),
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                        controller: TextEditingController(text: _medicineType),
                        icon: Icon(Icons.visibility),
                        labelText: 'Jenis Obat',
                        dropdownItems: ['Tablet', 'Sirup', 'Kapsul', 'Salep'],
                        initialDropdownValue: 'Tablet',
                        onChanged: (value) {
                          setState(() {
                            _medicineType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                CustomTextFormField(
                  controller: TextEditingController(text: _medicineUse),
                  icon: Icon(Icons.schedule),
                  labelText: 'Waktu Konsumsi',
                  dropdownItems: [
                    'sebelum makan',
                    'sesudah makan',
                    'saat makan'
                  ],
                  initialDropdownValue: 'sesudah makan',
                  onChanged: (value) {
                    setState(() {
                      _medicineUse = value;
                    });
                  },
                ),
                CustomTextFormField(
                  controller: _supplyController,
                  icon: Icon(Icons.inventory_2),
                  labelText: 'Persediaan Obat',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || int.tryParse(value) == null
                      ? 'Harus berupa angka'
                      : null,
                ),
                CustomTextFormField(
                  controller: _notesController,
                  icon: Icon(Icons.notes),
                  labelText: 'Keterangan',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20),
                ExpandedButton(text1: "Tambah", press1: _addReminder),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
