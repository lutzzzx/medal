import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _dailyConsumptionController = TextEditingController();
  final _dosesController = TextEditingController();
  final _supplyController = TextEditingController();
  final _notesController = TextEditingController();
  String _medicineType = 'Tablet';
  bool _beforeMeal = true;
  List<TimeOfDay> _times = [];

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

  void _scheduleNotifications(String medicineName) async {
    await NotificationService.requestPermission();

    for (int i = 0; i < _times.length; i++) {
      final time = _times[i];
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // Pastikan waktu notifikasi ada di masa depan
      if (scheduledTime.isAfter(now)) {
        await NotificationService.scheduleNotification(
          id: scheduledTime.hashCode,
          title: 'Waktunya Minum Obat!',
          body: 'Jangan lupa minum obat $medicineName.',
          scheduledTime: scheduledTime,
        );
        debugPrint("Scheduled notification for $medicineName at $scheduledTime");
      } else {
        debugPrint(
            "Skipped scheduling notification for $medicineName at $scheduledTime (past time)");
      }
    }
  }


  void _addReminder() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus login untuk menambah pengingat')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('reminders').add({
        'userId': user.uid,
        'medicineName': _medicineNameController.text,
        'dailyConsumption': int.parse(_dailyConsumptionController.text),
        'doses': _dosesController.text,
        'medicineType': _medicineType,
        'beforeMeal': _beforeMeal,
        'supply': int.parse(_supplyController.text),
        'notes': _notesController.text,
        'times': _times
            .map((time) =>
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}')
            .toList(),
      });

      // Jadwalkan notifikasi
      _scheduleNotifications(_medicineNameController.text);

      Navigator.pop(context);
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
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: _dailyConsumptionController,
                  decoration: InputDecoration(labelText: 'Konsumsi Per Hari'),
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
                    title: Text('Jam Minum ${index + 1}'),
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
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Wajib diisi' : null,
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
                SwitchListTile(
                  title: Text('Dikonsumsi Sebelum Makan'),
                  value: _beforeMeal,
                  onChanged: (value) {
                    setState(() {
                      _beforeMeal = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _supplyController,
                  decoration: InputDecoration(labelText: 'Persediaan Obat'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || int.tryParse(value) == null
                      ? 'Harus berupa angka'
                      : null,
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
