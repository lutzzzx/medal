import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../../../data/models/reminder_model.dart';
import 'package:medal/widgets/reminder_form_field.dart';

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
      appBar: AppBar(title : const Text('Edit Pengingat Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReminderFormField(
                  controller: _medicineNameController, // Use your existing controller
                  icon: const Icon(Icons.radio_button_unchecked),  // Provide an appropriate icon
                  labelHint: 'Nama Obat',
                    keyboardType: TextInputType.text,              // The label text for the field
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Wajib diisi' : null, // Validation logic
                ),
                ReminderFormField(
                  controller: _dailyConsumptionController, // Use your existing controller
                  icon: const Icon(Icons.format_list_numbered),  // Provide an appropriate icon
                  labelHint: 'Konsumsi Per Hari',
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

                Row(
                  children: [
                    // First Container (TextFormField)
                    Expanded(
                      flex: 1, // Adjust flex to control width ratio
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Add margin
                        child: TextFormField(
                          controller: _dosesController,
                          decoration: InputDecoration(
                            hintText: 'Dosis', // Shortened label text for cleaner look
                            hintStyle: const TextStyle(color: Color.fromARGB(255, 3, 4, 94)), // Optional styling
                            prefixIcon: const Icon(
                              Icons.monitor_heart, // Heartbeat-like icon
                              color: Color.fromARGB(255, 3, 4, 94),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0), // Rounded corners
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 202, 240, 248),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 202, 240, 248),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0077B6), // Focus color
                                width: 1.5,
                              ),
                            ),
                            fillColor: const Color.fromARGB(255, 202, 240, 248), // Set fill color to light blue
                            filled: true,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                        ),
                      ),
                    ),

                    // Second Container (DropdownButtonFormField)
                    Expanded(
                      flex: 1, // Adjust flex to control width ratio
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Add margin
                        child: DropdownButtonFormField<String>(
                          value: _medicineType,
                          items: ['Tablet', 'Sirup', 'Kapsul', 'Salep']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: const TextStyle(color: Color.fromARGB(255, 3, 4, 94)), // Text styling
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _medicineType = value!;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0), // Add padding
                            // labelText: 'Jenis Obat', // Label text
                            // labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 4, 94)), // Optional label styling
                            prefixIcon: const Icon(
                              Icons.visibility, // Eye icon
                              color: Color.fromARGB(255, 3, 4, 94), // Icon color
                            ),
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down, // Dropdown arrow
                              color: Color.fromARGB(255, 3, 4, 94), // Icon color
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0), // Rounded corners
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 202, 240, 248),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0), // Enabled border style
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 202, 240, 248),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0), // Focused border style
                              borderSide: const BorderSide(
                                color: Color(0xFF0077B6), // Focus color
                                width: 1.5,
                              ),
                            ),
                            fillColor: const Color.fromARGB(255, 202, 240, 248), // Set fill color to light blue
                            filled: true,
                          ),
                          dropdownColor: Colors.white, // Background color of the dropdown menu
                          icon: const SizedBox.shrink(), // Remove default dropdown icon
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Add margin
                child:DropdownButtonFormField<String>(
                  value: _medicineUse,
                  items: ['sebelum makan', 'sesudah makan', 'saat makan']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(color: Color.fromARGB(255, 3, 4, 94)), // Text styling
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                       _medicineUse = value!;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0), // Add padding
                    // labelText: 'Waktu Konsumsi', // Label text
                    // labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 4, 94)), // Optional label styling
                    prefixIcon: const Icon(
                      Icons.schedule, // Eye icon
                      color: Color.fromARGB(255, 3, 4, 94), // Icon color
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down, // Dropdown arrow
                      color: Color.fromARGB(255, 3, 4, 94), // Icon color
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0), // Rounded corners
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 202, 240, 248),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0), // Enabled border style
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 202, 240, 248),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0), // Focused border style
                      borderSide: const BorderSide(
                        color: Color(0xFF0077B6), // Focus color
                        width: 1.5,
                      ),
                    ),
                    fillColor: const Color.fromARGB(255, 202, 240, 248), // Set fill color to light blue
                    filled: true,
                  ),
                  dropdownColor: Colors.white, // Background color of the dropdown menu
                  icon: const SizedBox.shrink(), // Remove default dropdown icon
                ),
                ),

                ReminderFormField(
                  controller: _supplyController, // Use your existing controller
                  icon: const Icon(Icons.inventory_2),  // Provide an appropriate icon
                  labelHint: 'Persediaan Obat',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),  // Adds 16 pixels of margin on all sides
                  child: TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Keterangan',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 3, 4, 94), // Change the label text color
                      ),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF0077B6),
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 202, 240, 248),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _deleteReminder(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Red color for delete button
                        minimumSize: const Size(double.infinity, 48), // Full width and fixed height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        elevation: 0, // No shadow
                        padding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Add some space between the buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _editReminder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088CC), // Bright blue color for update button
                        minimumSize: const Size(double.infinity, 48), // Full width and fixed height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        elevation: 0, // No shadow
                        padding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
