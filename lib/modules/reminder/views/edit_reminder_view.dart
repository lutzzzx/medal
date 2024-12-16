import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medal/widgets/hapus_ubah.dart';
import '../controllers/reminder_controller.dart';
import '../../../data/models/reminder_model.dart';
import 'package:medal/widgets/custom_text_form_field.dart'; // Update the import to your CustomTextFormField

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

  void _deleteReminder(BuildContext context) async {
    await controller.deleteReminder(widget.reminder.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengingat berhasil dihapus!')),
    );
    Get.back(); // Kembali ke daftar pengingat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengingat Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _medicineNameController,
                  icon: const Icon(Icons.radio_button_unchecked),
                  labelText: 'Nama Obat',
                  keyboardType: TextInputType.text,
                  isEdit: true,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
                CustomTextFormField(
                  controller: _dailyConsumptionController,
                  icon: const Icon(Icons.format_list_numbered),
                  labelText: 'Konsumsi Per Hari',
                  isEdit: true,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final dailyConsumption = int.tryParse(value);
                    if (dailyConsumption != null && dailyConsumption > 0) {
                      _generateTimes(dailyConsumption);
                    }
                  },
                  validator: (value) =>
                  value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editTime(index),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                        controller: _dosesController,
                        icon: const Icon(Icons.monitor_heart),
                        labelText: 'Dosis',
                        keyboardType: TextInputType.number,
                        isEdit: true,
                        validator: (value) =>
                        value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                      ),
                    ),
                    SizedBox(width: 14,),
                    Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                        icon: const Icon(Icons.visibility),
                        controller: TextEditingController(text: _medicineType),
                        labelText: 'Jenis Obat',
                        isEdit: true,
                        dropdownItems: ['Tablet', 'Sirup', 'Kapsul', 'Salep'],
                        initialDropdownValue: _medicineType,
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
                  icon: const Icon(Icons.schedule),
                  controller: TextEditingController(text: _medicineUse),
                  labelText: 'Waktu Konsumsi',
                  isEdit: true,
                  dropdownItems: ['sebelum makan', 'sesudah makan', 'saat makan'],
                  initialDropdownValue: _medicineUse,
                  onChanged: (value) {
                    setState(() {
                      _medicineUse = value;
                    });
                  },
                ),
                CustomTextFormField(
                  controller: _supplyController,
                  icon: const Icon(Icons.inventory_2),
                  labelText: 'Persediaan Obat',
                  isEdit: true,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                ),
                CustomTextFormField(
                  controller: _notesController,
                  icon: const Icon(Icons.note),
                  labelText: 'Keterangan',
                  isEdit: true,
                  keyboardType: TextInputType.multiline,
                  validator: (value) => null,
                ),
                const SizedBox(height: 20),
                HapusUbah(
                  text1: 'Hapus',
                  text2: 'Update',
                  press1: () => _deleteReminder(context),
                  press2: _editReminder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}