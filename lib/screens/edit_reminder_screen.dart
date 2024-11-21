import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

class EditReminderScreen extends StatefulWidget {
  final DocumentSnapshot reminder;

  EditReminderScreen({required this.reminder});

  @override
  _EditReminderScreenState createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _medicineNameController;
  late TextEditingController _dailyConsumptionController;
  late TextEditingController _dosesController;
  late TextEditingController _supplyController;
  late TextEditingController _notesController;
  late String _medicineType;
  late bool _beforeMeal;
  late List<TimeOfDay> _times;

  @override
  void initState() {
    super.initState();
    final data = widget.reminder.data() as Map<String, dynamic>;
    _medicineNameController = TextEditingController(text: data['medicineName']);
    _dailyConsumptionController =
        TextEditingController(text: data['dailyConsumption'].toString());
    _dosesController = TextEditingController(text: data['doses']);
    _supplyController = TextEditingController(text: data['supply'].toString());
    _notesController = TextEditingController(text: data['notes']);
    _medicineType = data['medicineType'];
    _beforeMeal = data['beforeMeal'];
    _times = List<String>.from(data['times']).map((time) {
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }).toList();
  }

  void _generateTimes(int dailyConsumption) {
    setState(() {
      _times = List.generate(
        dailyConsumption,
            (index) {
          final interval = 24 ~/ dailyConsumption;
          return TimeOfDay(hour: (index * interval) % 24, minute: 0);
        },
      );
    });
  }

  Future<void> _editTime(int index) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: _times[index],
    );

    if (newTime != null) {
      setState(() {
        _times[index] = newTime;
      });
    }
  }

  void _scheduleNotifications(String medicineName) {
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
        NotificationService.scheduleNotification(
          id: scheduledTime.hashCode,
          title: 'Waktunya Minum Obat!',
          body: 'Jangan lupa minum obat $medicineName.',
          scheduledTime: scheduledTime,
        );
      }
    }
  }

  void _cancelOldNotifications() {
    for (final time in _times) {
      NotificationService.cancelNotification(time.hashCode);
    }
  }

  void _updateReminder() async {
    if (_formKey.currentState!.validate()) {
      final newTimes = _times
          .map((time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}')
          .toList();

      // Batalkan notifikasi lama
      _cancelOldNotifications();

      // Jadwalkan notifikasi baru
      _scheduleNotifications(_medicineNameController.text);

      await FirebaseFirestore.instance
          .collection('reminders')
          .doc(widget.reminder.id)
          .update({
        'medicineName': _medicineNameController.text,
        'dailyConsumption': int.parse(_dailyConsumptionController.text),
        'doses': _dosesController.text,
        'medicineType': _medicineType,
        'beforeMeal': _beforeMeal,
        'supply': int.parse(_supplyController.text),
        'notes': _notesController.text,
        'times': newTimes,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengingat berhasil diperbarui!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Pengingat Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
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
                  validator: (value) =>
                  value == null || int.tryParse(value) == null
                      ? 'Harus berupa angka'
                      : null,
                  onChanged: (value) {
                    final dailyConsumption = int.tryParse(value);
                    if (dailyConsumption != null && dailyConsumption > 0) {
                      _generateTimes(dailyConsumption);
                    }
                  },
                ),
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
                Text('Jam Konsumsi:', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _times.length,
                  itemBuilder: (context, index) {
                    final time = _times[index];
                    return ListTile(
                      title: Text(
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTime(index),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateReminder,
                  child: Text('Simpan Perubahan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
