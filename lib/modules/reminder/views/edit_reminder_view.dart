import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../../../data/models/reminder_model.dart';

class EditReminderView extends StatefulWidget {
  final ReminderModel reminder;

  EditReminderView({required this.reminder});

  @override
  _EditReminderViewState createState() => _EditReminderViewState();
}

class _EditReminderViewState extends State<EditReminderView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _medicineNameController;
  late TextEditingController _dailyConsumptionController;
  late TextEditingController _dosesController;
  late TextEditingController _supplyController;
  late TextEditingController _notesController;
  late String _medicineType;
  late String _medicineUse;
  late List<TimeOfDay> _times;
  final ReminderController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _medicineNameController = TextEditingController(text: widget.reminder.medicineName);
    _dailyConsumptionController = TextEditingController(text: widget.reminder.dailyConsumption.toString());
    _dosesController = TextEditingController(text: widget.reminder.doses.toString());
    _supplyController = TextEditingController(text: widget.reminder.supply.toString());
    _notesController = TextEditingController(text: widget.reminder.notes);
    _medicineType = widget.reminder.medicineType;
    _medicineUse = widget.reminder.medicineUse;
    _times = widget.reminder.times.map((time) {
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }).toList();
  }

  void _editReminder() {
    if (_formKey.currentState!.validate()) {
      controller.updateExistingReminder(
        widget.reminder,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : Text('Edit Pengingat Obat')),
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
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: _dailyConsumptionController,
                  decoration: InputDecoration(labelText: 'Konsumsi Per Hari'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                  onChanged: (value) {
                    final dailyConsumption = int.tryParse(value);
                    if (dailyConsumption != null && dailyConsumption > 0) {
                      _generateTimes(dailyConsumption);
                    }
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _times.length,
                  itemBuilder: (context, index) {
                    final time = _times[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam minum ke-${index + 1}',
                          ),
                          Text(
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTime(index),
                      ),
                    );
                  },
                ),


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
                  onPressed: _editReminder,
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
