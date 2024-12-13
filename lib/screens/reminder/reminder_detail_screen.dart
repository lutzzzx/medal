import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_reminder_screen.dart';

class ReminderDetailScreen extends StatelessWidget {
  final DocumentSnapshot reminder;

  ReminderDetailScreen({required this.reminder});

  void _deleteReminder(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminder.id)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pengingat berhasil dihapus!')),
    );

    Navigator.pop(context); // Kembali ke daftar pengingat
  }

  @override
  Widget build(BuildContext context) {
    final data = reminder.data() as Map<String, dynamic>;

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
              'Nama Obat: ${data['medicineName']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Konsumsi Per Hari: ${data['dailyConsumption']}'),
            Text('Dosis: ${data['doses']} ${data['medicineType']}'),
            Text('Waktu Konsumsi: ${data['medicineUse']}'),
            Text('Persediaan Obat: ${data['supply']}'),
            Text('Keterangan: ${data['notes']}'),
            SizedBox(height: 10),
            Text('Jam Minum: ${List<String>.from(data['times']).join(', ')}'),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReminderScreen(reminder: reminder),
                      ),
                    );
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
