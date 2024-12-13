// lib/modules/reminder/views/reminder_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../../../data/models/reminder_model.dart';
import 'edit_reminder_view.dart';

class ReminderDetailView extends StatelessWidget {
  final ReminderModel reminder;
  final ReminderController controller = Get.find();

  ReminderDetailView({required this.reminder});

  void _deleteReminder(BuildContext context) async {
    await controller.deleteReminder(reminder.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pengingat berhasil dihapus!')),
    );
    Get.back(); // Kembali ke daftar pengingat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pengingat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Obat: ${reminder.medicineName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Konsumsi Per Hari: ${reminder.dailyConsumption}'),
            Text('Dosis: ${reminder.doses} ${reminder.medicineType}'),
            Text('Waktu Konsumsi: ${reminder.medicineUse}'),
            Text('Persediaan Obat: ${reminder.supply}'),
            Text('Keterangan: ${reminder.notes}'),
            SizedBox(height: 10),
            Text('Jam Minum: ${reminder.times.join(', ')}'),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(EditReminderView(reminder: reminder));
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _deleteReminder(context),
                  icon: Icon(Icons.delete),
                  label: Text('Hapus'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}