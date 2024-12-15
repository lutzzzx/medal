import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../../../data/models/reminder_model.dart';
import 'package:medal/widgets/reminder_form_field.dart';

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
                  onChanged: (_) => _generateTimes(),
                  validator: (value) =>
                      value == null || int.tryParse(value) == null ? 'Harus berupa angka' : null,
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
                  margin: EdgeInsets.symmetric(vertical: 8.0),  // Adds 16 pixels of margin on all sides
                  child: TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Keterangan',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 3, 4, 94), // Change the label text color
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
                        borderSide: BorderSide(
                          color: Color(0xFF0077B6),
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 202, 240, 248),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0088CC), // Bright blue color
                    minimumSize: Size(double.infinity, 48), // Full width and fixed height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    elevation: 0, // No shadow
                    padding: EdgeInsets.symmetric(vertical: 12), // Vertical padding
                  ),
                  child: Text(
                    'Tambah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
